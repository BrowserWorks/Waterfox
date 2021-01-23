# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

from collections import defaultdict
from json import dumps, JSONEncoder
import os
import mozpack.path as mozpath


class ResultSummary(object):
    """Represents overall result state from an entire lint run."""
    root = None

    def __init__(self, root):
        self.reset()

        # Store the repository root folder to be able to build
        # Issues relative paths to that folder
        if ResultSummary.root is None:
            ResultSummary.root = mozpath.normpath(root)

    def reset(self):
        self.issues = defaultdict(list)
        self.failed_run = set()
        self.failed_setup = set()
        self.suppressed_warnings = defaultdict(int)

    @property
    def returncode(self):
        if self.issues or self.failed:
            return 1
        return 0

    @property
    def failed(self):
        return self.failed_setup | self.failed_run

    @property
    def total_issues(self):
        return sum([len(v) for v in self.issues.values()])

    @property
    def total_suppressed_warnings(self):
        return sum(self.suppressed_warnings.values())

    def update(self, other):
        """Merge results from another ResultSummary into this one."""
        for path, obj in other.issues.items():
            self.issues[path].extend(obj)

        self.failed_run |= other.failed_run
        self.failed_setup |= other.failed_setup
        for k, v in other.suppressed_warnings.items():
            self.suppressed_warnings[k] += v


class Issue(object):
    """Represents a single lint issue and its related metadata.

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
    :param diff: a diff describing the changes that need to be made to the code
    """

    __slots__ = (
        "linter",
        "path",
        "message",
        "lineno",
        "column",
        "hint",
        "source",
        "level",
        "rule",
        "lineoffset",
        "diff",
        "relpath",
    )

    def __init__(
        self,
        linter,
        path,
        message,
        lineno,
        column=None,
        hint=None,
        source=None,
        level=None,
        rule=None,
        lineoffset=None,
        diff=None,
        relpath=None,
    ):
        self.message = message
        self.lineno = int(lineno) if lineno else 0
        self.column = int(column) if column else column
        self.hint = hint
        self.source = source
        self.level = level or "error"
        self.linter = linter
        self.rule = rule
        self.lineoffset = lineoffset
        self.diff = diff

        root = ResultSummary.root
        assert root is not None, 'Missing ResultSummary.root'
        if os.path.isabs(path):
            self.path = mozpath.normpath(path)
            if self.path.startswith(root):
                self.relpath = mozpath.relpath(self.path, root)
            else:
                self.relpath = self.path
        else:
            self.path = mozpath.join(root, path)
            self.relpath = mozpath.normpath(path)

    def __repr__(self):
        s = dumps(self, cls=IssueEncoder, indent=2)
        return "Issue({})".format(s)


class IssueEncoder(JSONEncoder):
    """Class for encoding :class:`~result.Issue`s to json.

    Usage:

        json.dumps(results, cls=IssueEncoder)
    """

    def default(self, o):
        if isinstance(o, Issue):
            return {a: getattr(o, a) for a in o.__slots__}
        return JSONEncoder.default(self, o)


def from_config(config, **kwargs):
    """Create a :class:`~result.Issue` from a linter config.

    Convenience method that pulls defaults from a linter
    config and forwards them.

    :param config: linter config as defined in a .yml file
    :param kwargs: same as :class:`~result.Issue`
    :returns: :class:`~result.Issue` object
    """
    attrs = {}
    for attr in Issue.__slots__:
        attrs[attr] = kwargs.get(attr, config.get(attr))

    if not attrs["linter"]:
        attrs["linter"] = config.get("name")

    if not attrs["message"]:
        attrs["message"] = config.get("description")

    return Issue(**attrs)
