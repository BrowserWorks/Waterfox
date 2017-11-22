# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

from __future__ import absolute_import, print_function, unicode_literals

from taskgraph.loader.single_dep import loader as base_loader

# XXX: This logic should rely in kind.yml. This hasn't been done in the original
# patch because it required some heavy changes in single_dep.
LABELS_WHICH_SHOULD_SIGN_CI_BUILDS = (
    'build-win32/debug', 'build-win32/opt', 'build-win32/pgo',
    'build-win64/debug', 'build-win64/opt', 'build-win64/pgo',
    'build-win32-devedition/opt', 'build-win64-devedition/opt',
)


def loader(kind, path, config, params, loaded_tasks):
    jobs = base_loader(kind, path, config, params, loaded_tasks)

    for job in jobs:
        dependent_task = job['dependent-task']
        if dependent_task.attributes.get('nightly') or \
                dependent_task.label in LABELS_WHICH_SHOULD_SIGN_CI_BUILDS:
            yield job
