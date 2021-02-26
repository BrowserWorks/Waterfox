# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
"""
Support for running mach python-test tasks (via run-task)
"""

from __future__ import absolute_import, print_function, unicode_literals

from six import text_type
from taskgraph.transforms.job import run_job_using, configure_taskdesc_for_run
from taskgraph.util.schema import Schema
from voluptuous import Required

python_test_schema = Schema({
    Required('using'): 'python-test',

    # Python version to use
    Required('python-version'): int,

    # The subsuite to run
    Required('subsuite'): text_type,

    # Base work directory used to set up the task.
    Required('workdir'): text_type,
})


defaults = {
    'python-version': 2,
    'subsuite': 'default',
}


@run_job_using('docker-worker', 'python-test', schema=python_test_schema, defaults=defaults)
@run_job_using('generic-worker', 'python-test', schema=python_test_schema, defaults=defaults)
def configure_python_test(config, job, taskdesc):
    run = job['run']
    worker = job['worker']

    # defer to the mach implementation
    run['mach'] = 'python-test --subsuite {subsuite}'.format(**run)
    run['using'] = 'mach'
    del run['subsuite']
    configure_taskdesc_for_run(config, job, taskdesc, worker['implementation'])
