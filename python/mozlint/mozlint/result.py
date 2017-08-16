# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

from json import dumps, JSONEncoder


class ResultContainer(object):
    """Represents a single lint error and its related metadata.

    :param linter: name of the linter that flagged this error
    :param path: path to the file containing the error
    :param message: text describing the error
    :param lineno: line number that contains the error
    :param column: column containing the error
    :param level: severity of the error, either 'warning' or 'error' (default 'error')
    :param hint: suggestion for fixing the error (optional)
    :param source: source code context of the error (optional)
    :param rule: name of the rule that was violated (optional)
    :param lineoffset: denotes an error spans multiple lines, of the form
                       (<lineno offset>, <num lines>) (optional)
    """

    __slots__ = (
        'linter',
        'path',
        'message',
        'lineno',
        'column',
        'hint',
        'source',
        'level',
        'rule',
        'lineoffset',
    )

    def __init__(self, linter, path, message, lineno, column=None, hint=None,
                 source=None, level=None, rule=None, lineoffset=None):
        self.path = path
        self.message = message
        self.lineno = lineno
        self.column = column
        self.hint = hint
        self.source = source
        self.level = level or 'error'
        self.linter = linter
        self.rule = rule
        self.lineoffset = lineoffset

    def __repr__(self):
        s = dumps(self, cls=ResultEncoder, indent=2)
        return "ResultContainer({})".format(s)


class ResultEncoder(JSONEncoder):
    """Class for encoding :class:`~result.ResultContainer`s to json.

    Usage:

        json.dumps(results, cls=ResultEncoder)
    """
    def default(self, o):
        if isinstance(o, ResultContainer):
            return {a: getattr(o, a) for a in o.__slots__}
        return JSONEncoder.default(self, o)


def from_config(config, **kwargs):
    """Create a :class:`~result.ResultContainer` from a linter config.

    Convenience method that pulls defaults from a linter
    config and forwards them.

    :param config: linter config as defined in a .yml file
    :param kwargs: same as :class:`~result.ResultContainer`
    :returns: :class:`~result.ResultContainer` object
    """
    attrs = {}
    for attr in ResultContainer.__slots__:
        attrs[attr] = kwargs.get(attr, config.get(attr))

    if not attrs['linter']:
        attrs['linter'] = config.get('name')

    if not attrs['message']:
        attrs['message'] = config.get('description')

    return ResultContainer(**attrs)
