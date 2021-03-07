# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

import argparse
import copy
import os

from mozbuild.base import (
    BuildEnvironmentNotFoundException,
    MachCommandBase,
)


from mach.decorators import (
    CommandArgument,
    CommandProvider,
    Command,
)


here = os.path.abspath(os.path.dirname(__file__))
EXCLUSION_FILES = [
    os.path.join('tools', 'rewriting', 'Generated.txt'),
    os.path.join('tools', 'rewriting', 'ThirdPartyPaths.txt'),
]

EXCLUSION_FILES_OPTIONAL = []
thunderbird_excludes = os.path.join('comm', 'tools', 'lint', 'GlobalExclude.txt')
if os.path.exists(thunderbird_excludes):
    EXCLUSION_FILES_OPTIONAL.append(thunderbird_excludes)

GLOBAL_EXCLUDES = [
    'node_modules',
    'tools/lint/test/files',
]


def setup_argument_parser():
    from mozlint import cli
    return cli.MozlintParser()


def get_global_excludes(topsrcdir):
    # exclude misc paths
    excludes = GLOBAL_EXCLUDES[:]

    # exclude top level paths that look like objdirs
    excludes.extend([name for name in os.listdir(topsrcdir)
                     if name.startswith('obj') and os.path.isdir(name)])

    for path in EXCLUSION_FILES + EXCLUSION_FILES_OPTIONAL:
        with open(os.path.join(topsrcdir, path), 'r') as fh:
            excludes.extend([f.strip() for f in fh.readlines()])

    return excludes


@CommandProvider
class MachCommands(MachCommandBase):

    @Command(
        'lint', category='devenv',
        description='Run linters.',
        parser=setup_argument_parser)
    def lint(self, *runargs, **lintargs):
        """Run linters."""
        self.activate_virtualenv()
        from mozlint import cli, parser

        try:
            buildargs = {}
            buildargs['substs'] = copy.deepcopy(dict(self.substs))
            buildargs['defines'] = copy.deepcopy(dict(self.defines))
            buildargs['topobjdir'] = self.topobjdir
            lintargs.update(buildargs)
        except BuildEnvironmentNotFoundException:
            pass

        lintargs.setdefault('root', self.topsrcdir)
        lintargs['exclude'] = get_global_excludes(lintargs['root'])
        lintargs['config_paths'].insert(0, here)
        for path in EXCLUSION_FILES:
            parser.GLOBAL_SUPPORT_FILES.append(os.path.join(self.topsrcdir, path))
        return cli.run(*runargs, **lintargs)

    @Command('eslint', category='devenv',
             description='Run eslint or help configure eslint for optimal development.')
    @CommandArgument('paths', default=None, nargs='*',
                     help="Paths to file or directories to lint, like "
                          "'browser/' Defaults to the "
                          "current directory if not given.")
    @CommandArgument('-s', '--setup', default=False, action='store_true',
                     help='Configure eslint for optimal development.')
    @CommandArgument('-b', '--binary', default=None,
                     help='Path to eslint binary.')
    @CommandArgument('--fix', default=False, action='store_true',
                     help='Request that eslint automatically fix errors, where possible.')
    @CommandArgument('extra_args', nargs=argparse.REMAINDER,
                     help='Extra args that will be forwarded to eslint.')
    def eslint(self, paths, extra_args=[], **kwargs):
        self._mach_context.commands.dispatch('lint', self._mach_context,
                                             linters=['eslint'], paths=paths,
                                             argv=extra_args, **kwargs)
