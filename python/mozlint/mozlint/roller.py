# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

from __future__ import unicode_literals

import os
import signal
import sys
import traceback
from collections import defaultdict
from Queue import Empty
from multiprocessing import (
    Manager,
    Pool,
    cpu_count,
)

from .errors import LintersNotConfigured
from .types import supported_types
from .parser import Parser
from .vcs import VCSFiles


def _run_linters(queue, paths, **lintargs):
    parse = Parser()
    results = defaultdict(list)
    return_code = 0

    while True:
        try:
            # The astute reader may wonder what is preventing the worker from
            # grabbing the next linter from the queue after a SIGINT. Because
            # this is a Manager.Queue(), it is itself in a child process which
            # also received SIGINT. By the time the worker gets back here, the
            # Queue is dead and IOError is raised.
            linter_path = queue.get(False)
        except (Empty, IOError):
            return results, return_code

        # Ideally we would pass the entire LINTER definition as an argument
        # to the worker instead of re-parsing it. But passing a function from
        # a dynamically created module (with imp) does not seem to be possible
        # with multiprocessing on Windows.
        linter = parse(linter_path)
        func = supported_types[linter['type']]
        res = func(paths, linter, **lintargs) or []

        if not isinstance(res, (list, tuple)):
            if res:
                return_code = 1
            continue

        for r in res:
            results[r.path].append(r)


def _run_worker(*args, **lintargs):
    try:
        return _run_linters(*args, **lintargs)
    except Exception:
        # multiprocessing seems to munge worker exceptions, print
        # it here so it isn't lost.
        traceback.print_exc()
        raise
    finally:
        sys.stdout.flush()


class LintRoller(object):
    """Registers and runs linters.

    :param root: Path to which relative paths will be joined. If
                 unspecified, root will either be determined from
                 version control or cwd.
    :param lintargs: Arguments to pass to the underlying linter(s).
    """

    def __init__(self, root=None, **lintargs):
        self.parse = Parser()
        self.vcs = VCSFiles()

        self.linters = []
        self.lintargs = lintargs
        self.lintargs['root'] = root or self.vcs.root or os.getcwd()

        self.return_code = None

    def read(self, paths):
        """Parse one or more linters and add them to the registry.

        :param paths: A path or iterable of paths to linter definitions.
        """
        if isinstance(paths, basestring):
            paths = (paths,)

        for path in paths:
            self.linters.append(self.parse(path))

    def roll(self, paths=None, rev=None, workdir=None, num_procs=None):
        """Run all of the registered linters against the specified file paths.

        :param paths: An iterable of files and/or directories to lint.
        :param rev: Lint all files touched by the specified revision.
        :param workdir: Lint all files touched in the working directory.
        :param num_procs: The number of processes to use. Default: cpu count
        :return: A dictionary with file names as the key, and a list of
                 :class:`~result.ResultContainer`s as the value.
        """
        paths = paths or []
        if isinstance(paths, basestring):
            paths = [paths]

        if not self.linters:
            raise LintersNotConfigured

        # Calculate files from VCS
        if rev:
            paths.extend(self.vcs.by_rev(rev))
        if workdir:
            paths.extend(self.vcs.by_workdir())
        paths = paths or ['.']
        paths = map(os.path.abspath, paths)

        # Set up multiprocessing
        m = Manager()
        queue = m.Queue()

        for linter in self.linters:
            queue.put(linter['path'])

        num_procs = num_procs or cpu_count()
        num_procs = min(num_procs, len(self.linters))
        pool = Pool(num_procs)

        all_results = defaultdict(list)
        workers = []
        for i in range(num_procs):
            workers.append(
                pool.apply_async(_run_worker, args=(queue, paths), kwds=self.lintargs))
        pool.close()

        # ignore SIGINT in parent so we can still get partial results
        # from child processes. These should shutdown quickly anyway.
        signal.signal(signal.SIGINT, signal.SIG_IGN)
        self.return_code = 0
        for worker in workers:
            # parent process blocks on worker.get()
            results, return_code = worker.get()
            if results or return_code:
                self.return_code = 1
            for k, v in results.iteritems():
                all_results[k].extend(v)
        return all_results
