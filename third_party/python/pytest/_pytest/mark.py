""" generic mechanism for marking and selecting python functions. """
from __future__ import absolute_import, division, print_function

import inspect
from collections import namedtuple
from operator import attrgetter
from .compat import imap


def alias(name):
    return property(attrgetter(name), doc='alias for ' + name)


class ParameterSet(namedtuple('ParameterSet', 'values, marks, id')):
    @classmethod
    def param(cls, *values, **kw):
        marks = kw.pop('marks', ())
        if isinstance(marks, MarkDecorator):
            marks = marks,
        else:
            assert isinstance(marks, (tuple, list, set))

        def param_extract_id(id=None):
            return id

        id = param_extract_id(**kw)
        return cls(values, marks, id)

    @classmethod
    def extract_from(cls, parameterset, legacy_force_tuple=False):
        """
        :param parameterset:
            a legacy style parameterset that may or may not be a tuple,
            and may or may not be wrapped into a mess of mark objects

        :param legacy_force_tuple:
            enforce tuple wrapping so single argument tuple values
            don't get decomposed and break tests

        """

        if isinstance(parameterset, cls):
            return parameterset
        if not isinstance(parameterset, MarkDecorator) and legacy_force_tuple:
            return cls.param(parameterset)

        newmarks = []
        argval = parameterset
        while isinstance(argval, MarkDecorator):
            newmarks.append(MarkDecorator(Mark(
                argval.markname, argval.args[:-1], argval.kwargs)))
            argval = argval.args[-1]
        assert not isinstance(argval, ParameterSet)
        if legacy_force_tuple:
            argval = argval,

        return cls(argval, marks=newmarks, id=None)

    @property
    def deprecated_arg_dict(self):
        return dict((mark.name, mark) for mark in self.marks)


class MarkerError(Exception):

    """Error in use of a pytest marker/attribute."""


def param(*values, **kw):
    return ParameterSet.param(*values, **kw)


def pytest_addoption(parser):
    group = parser.getgroup("general")
    group._addoption(
        '-k',
        action="store", dest="keyword", default='', metavar="EXPRESSION",
        help="only run tests which match the given substring expression. "
             "An expression is a python evaluatable expression "
             "where all names are substring-matched against test names "
             "and their parent classes. Example: -k 'test_method or test_"
             "other' matches all test functions and classes whose name "
             "contains 'test_method' or 'test_other'. "
             "Additionally keywords are matched to classes and functions "
             "containing extra names in their 'extra_keyword_matches' set, "
             "as well as functions which have names assigned directly to them."
    )

    group._addoption(
        "-m",
        action="store", dest="markexpr", default="", metavar="MARKEXPR",
        help="only run tests matching given mark expression.  "
             "example: -m 'mark1 and not mark2'."
    )

    group.addoption(
        "--markers", action="store_true",
        help="show markers (builtin, plugin and per-project ones)."
    )

    parser.addini("markers", "markers for test functions", 'linelist')


def pytest_cmdline_main(config):
    import _pytest.config
    if config.option.markers:
        config._do_configure()
        tw = _pytest.config.create_terminal_writer(config)
        for line in config.getini("markers"):
            name, rest = line.split(":", 1)
            tw.write("@pytest.mark.%s:" % name, bold=True)
            tw.line(rest)
            tw.line()
        config._ensure_unconfigure()
        return 0


pytest_cmdline_main.tryfirst = True


def pytest_collection_modifyitems(items, config):
    keywordexpr = config.option.keyword.lstrip()
    matchexpr = config.option.markexpr
    if not keywordexpr and not matchexpr:
        return
    # pytest used to allow "-" for negating
    # but today we just allow "-" at the beginning, use "not" instead
    # we probably remove "-" altogether soon
    if keywordexpr.startswith("-"):
        keywordexpr = "not " + keywordexpr[1:]
    selectuntil = False
    if keywordexpr[-1:] == ":":
        selectuntil = True
        keywordexpr = keywordexpr[:-1]

    remaining = []
    deselected = []
    for colitem in items:
        if keywordexpr and not matchkeyword(colitem, keywordexpr):
            deselected.append(colitem)
        else:
            if selectuntil:
                keywordexpr = None
            if matchexpr:
                if not matchmark(colitem, matchexpr):
                    deselected.append(colitem)
                    continue
            remaining.append(colitem)

    if deselected:
        config.hook.pytest_deselected(items=deselected)
        items[:] = remaining


class MarkMapping:
    """Provides a local mapping for markers where item access
    resolves to True if the marker is present. """
    def __init__(self, keywords):
        mymarks = set()
        for key, value in keywords.items():
            if isinstance(value, MarkInfo) or isinstance(value, MarkDecorator):
                mymarks.add(key)
        self._mymarks = mymarks

    def __getitem__(self, name):
        return name in self._mymarks


class KeywordMapping:
    """Provides a local mapping for keywords.
    Given a list of names, map any substring of one of these names to True.
    """
    def __init__(self, names):
        self._names = names

    def __getitem__(self, subname):
        for name in self._names:
            if subname in name:
                return True
        return False


def matchmark(colitem, markexpr):
    """Tries to match on any marker names, attached to the given colitem."""
    return eval(markexpr, {}, MarkMapping(colitem.keywords))


def matchkeyword(colitem, keywordexpr):
    """Tries to match given keyword expression to given collector item.

    Will match on the name of colitem, including the names of its parents.
    Only matches names of items which are either a :class:`Class` or a
    :class:`Function`.
    Additionally, matches on names in the 'extra_keyword_matches' set of
    any item, as well as names directly assigned to test functions.
    """
    mapped_names = set()

    # Add the names of the current item and any parent items
    import pytest
    for item in colitem.listchain():
        if not isinstance(item, pytest.Instance):
            mapped_names.add(item.name)

    # Add the names added as extra keywords to current or parent items
    for name in colitem.listextrakeywords():
        mapped_names.add(name)

    # Add the names attached to the current function through direct assignment
    if hasattr(colitem, 'function'):
        for name in colitem.function.__dict__:
            mapped_names.add(name)

    mapping = KeywordMapping(mapped_names)
    if " " not in keywordexpr:
        # special case to allow for simple "-k pass" and "-k 1.3"
        return mapping[keywordexpr]
    elif keywordexpr.startswith("not ") and " " not in keywordexpr[4:]:
        return not mapping[keywordexpr[4:]]
    return eval(keywordexpr, {}, mapping)


def pytest_configure(config):
    config._old_mark_config = MARK_GEN._config
    if config.option.strict:
        MARK_GEN._config = config


def pytest_unconfigure(config):
    MARK_GEN._config = getattr(config, '_old_mark_config', None)


class MarkGenerator:
    """ Factory for :class:`MarkDecorator` objects - exposed as
    a ``pytest.mark`` singleton instance.  Example::

         import pytest
         @pytest.mark.slowtest
         def test_function():
            pass

    will set a 'slowtest' :class:`MarkInfo` object
    on the ``test_function`` object. """
    _config = None


    def __getattr__(self, name):
        if name[0] == "_":
            raise AttributeError("Marker name must NOT start with underscore")
        if self._config is not None:
            self._check(name)
        return MarkDecorator(Mark(name, (), {}))

    def _check(self, name):
        try:
            if name in self._markers:
                return
        except AttributeError:
            pass
        self._markers = l = set()
        for line in self._config.getini("markers"):
            beginning = line.split(":", 1)
            x = beginning[0].split("(", 1)[0]
            l.add(x)
        if name not in self._markers:
            raise AttributeError("%r not a registered marker" % (name,))


def istestfunc(func):
    return hasattr(func, "__call__") and \
        getattr(func, "__name__", "<lambda>") != "<lambda>"

class MarkDecorator:
    """ A decorator for test functions and test classes.  When applied
    it will create :class:`MarkInfo` objects which may be
    :ref:`retrieved by hooks as item keywords <excontrolskip>`.
    MarkDecorator instances are often created like this::

        mark1 = pytest.mark.NAME              # simple MarkDecorator
        mark2 = pytest.mark.NAME(name1=value) # parametrized MarkDecorator

    and can then be applied as decorators to test functions::

        @mark2
        def test_function():
            pass

    When a MarkDecorator instance is called it does the following:
      1. If called with a single class as its only positional argument and no
         additional keyword arguments, it attaches itself to the class so it
         gets applied automatically to all test cases found in that class.
      2. If called with a single function as its only positional argument and
         no additional keyword arguments, it attaches a MarkInfo object to the
         function, containing all the arguments already stored internally in
         the MarkDecorator.
      3. When called in any other case, it performs a 'fake construction' call,
         i.e. it returns a new MarkDecorator instance with the original
         MarkDecorator's content updated with the arguments passed to this
         call.

    Note: The rules above prevent MarkDecorator objects from storing only a
    single function or class reference as their positional argument with no
    additional keyword or positional arguments.

    """
    def __init__(self, mark):
        assert isinstance(mark, Mark), repr(mark)
        self.mark = mark

    name = alias('mark.name')
    args = alias('mark.args')
    kwargs = alias('mark.kwargs')

    @property
    def markname(self):
        return self.name # for backward-compat (2.4.1 had this attr)

    def __eq__(self, other):
        return self.mark == other.mark

    def __repr__(self):
        return "<MarkDecorator %r>" % (self.mark,)

    def __call__(self, *args, **kwargs):
        """ if passed a single callable argument: decorate it with mark info.
            otherwise add *args/**kwargs in-place to mark information. """
        if args and not kwargs:
            func = args[0]
            is_class = inspect.isclass(func)
            if len(args) == 1 and (istestfunc(func) or is_class):
                if is_class:
                    if hasattr(func, 'pytestmark'):
                        mark_list = func.pytestmark
                        if not isinstance(mark_list, list):
                            mark_list = [mark_list]
                        # always work on a copy to avoid updating pytestmark
                        # from a superclass by accident
                        mark_list = mark_list + [self]
                        func.pytestmark = mark_list
                    else:
                        func.pytestmark = [self]
                else:
                    holder = getattr(func, self.name, None)
                    if holder is None:
                        holder = MarkInfo(self.mark)
                        setattr(func, self.name, holder)
                    else:
                        holder.add_mark(self.mark)
                return func

        mark = Mark(self.name, args, kwargs)
        return self.__class__(self.mark.combined_with(mark))





class Mark(namedtuple('Mark', 'name, args, kwargs')):

    def combined_with(self, other):
        assert self.name == other.name
        return Mark(
            self.name, self.args + other.args,
            dict(self.kwargs, **other.kwargs))


class MarkInfo(object):
    """ Marking object created by :class:`MarkDecorator` instances. """
    def __init__(self, mark):
        assert isinstance(mark, Mark), repr(mark)
        self.combined = mark
        self._marks = [mark]

    name = alias('combined.name')
    args = alias('combined.args')
    kwargs = alias('combined.kwargs')

    def __repr__(self):
        return "<MarkInfo {0!r}>".format(self.combined)

    def add_mark(self, mark):
        """ add a MarkInfo with the given args and kwargs. """
        self._marks.append(mark)
        self.combined = self.combined.combined_with(mark)

    def __iter__(self):
        """ yield MarkInfo objects each relating to a marking-call. """
        return imap(MarkInfo, self._marks)


MARK_GEN = MarkGenerator()
