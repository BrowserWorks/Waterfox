# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

import json
import os
import subprocess
import sys
from abc import ABCMeta, abstractmethod, abstractproperty
from distutils.spawn import find_executable

GIT_CINNABAR_NOT_FOUND = """
Could not detect `git-cinnabar`.

The `mach try` command requires git-cinnabar to be installed when
pushing from git. For more information and installation instruction,
please see:

    https://github.com/glandium/git-cinnabar
""".lstrip()

HG_PUSH_TO_TRY_NOT_FOUND = """
Could not detect `push-to-try`.

The `mach try` command requires the push-to-try extension enabled
when pushing from hg. Please install it by running:

    $ ./mach mercurial-setup
""".lstrip()

VCS_NOT_FOUND = """
Could not detect version control. Only `hg` or `git` are supported.
""".strip()

UNCOMMITTED_CHANGES = """
ERROR please commit changes before continuing
""".strip()


class VCSHelper(object):
    """A abstract base VCS helper that detects hg or git"""
    __metaclass__ = ABCMeta

    def __init__(self, root):
        self.root = root

    @classmethod
    def find_vcs(cls):
        # First check if we're in an hg repo, if not try git
        commands = (
            ['hg', 'root'],
            ['git', 'rev-parse', '--show-toplevel'],
        )

        for cmd in commands:
            proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            output = proc.communicate()[0].strip()

            if proc.returncode == 0:
                return cmd[0], output
        return None, ''

    @classmethod
    def create(cls):
        vcs, root = cls.find_vcs()
        if not vcs:
            print(VCS_NOT_FOUND)
            sys.exit(1)
        return vcs_class[vcs](root)

    def run(self, cmd):
        try:
            return subprocess.check_output(cmd, stderr=subprocess.STDOUT)
        except subprocess.CalledProcessError as e:
            print("Error running `{}`:".format(' '.join(cmd)))
            print(e.output)
            raise

    def write_task_config(self, labels):
        config = os.path.join(self.root, 'try_task_config.json')
        with open(config, 'w') as fh:
            json.dump(sorted(labels), fh, indent=2)
        return config

    def check_working_directory(self):
        if self.has_uncommitted_changes:
            print(UNCOMMITTED_CHANGES)
            sys.exit(1)

    @abstractmethod
    def push_to_try(self, msg, labels=None):
        pass

    @abstractproperty
    def files_changed(self):
        pass

    @abstractproperty
    def has_uncommitted_changes(self):
        pass


class HgHelper(VCSHelper):

    def push_to_try(self, msg, labels=None):
        self.check_working_directory()

        if labels:
            config = self.write_task_config(labels)
            self.run(['hg', 'add', config])

        try:
            return subprocess.check_call(['hg', 'push-to-try', '-m', msg])
        except subprocess.CalledProcessError:
            try:
                self.run(['hg', 'showconfig', 'extensions.push-to-try'])
            except subprocess.CalledProcessError:
                print(HG_PUSH_TO_TRY_NOT_FOUND)
            return 1
        finally:
            self.run(['hg', 'revert', '-a'])

            if labels and os.path.isfile(config):
                os.remove(config)

    @property
    def files_changed(self):
        return self.run(['hg', 'log', '-r', '::. and not public()',
                         '--template', '{join(files, "\n")}\n'])

    @property
    def has_uncommitted_changes(self):
        stat = [s for s in self.run(['hg', 'status', '-amrn']).split() if s]
        return len(stat) > 0


class GitHelper(VCSHelper):

    def push_to_try(self, msg, labels=None):
        self.check_working_directory()

        if not find_executable('git-cinnabar'):
            print(GIT_CINNABAR_NOT_FOUND)
            return 1

        if labels:
            config = self.write_task_config(labels)
            self.run(['git', 'add', config])

        subprocess.check_call(['git', 'commit', '--allow-empty', '-m', msg])
        try:
            return subprocess.call(['git', 'push', 'hg::ssh://hg.mozilla.org/try',
                                    '+HEAD:refs/heads/branches/default/tip'])
        finally:
            self.run(['git', 'reset', 'HEAD~'])

    @property
    def files_changed(self):
        # This finds the files changed on the current branch based on the
        # diff of the current branch its merge-base base with other branches.
        current_branch = self.run(['git', 'rev-parse', 'HEAD']).strip()
        all_branches = self.run(['git', 'for-each-ref', 'refs/heads', 'refs/remotes',
                                 '--format=%(objectname)']).splitlines()
        other_branches = set(all_branches) - set([current_branch])
        base_commit = self.run(['git', 'merge-base', 'HEAD'] + list(other_branches)).strip()
        return self.run(['git', 'diff', '--name-only', '-z', 'HEAD',
                         base_commit]).strip('\0').split('\0')

    @property
    def has_uncommitted_changes(self):
        stat = [s for s in self.run(['git', 'diff', '--cached', '--name-only',
                                     '--diff-filter=AMD']).split() if s]
        return len(stat) > 0


vcs_class = {
    'git': GitHelper,
    'hg': HgHelper,
}
