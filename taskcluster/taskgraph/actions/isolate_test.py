# -*- coding: utf-8 -*-

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

from __future__ import absolute_import, print_function, unicode_literals

import copy
import json
import logging
import os
import re

import six

from slugid import nice as slugid
from taskgraph.util.taskcluster import list_artifacts, get_artifact, get_task_definition
from ..util.parameterization import resolve_task_references
from .registry import register_callback_action
from .util import create_task_from_def, fetch_graph_and_labels, add_args_to_command

logger = logging.getLogger(__name__)


def get_failures(task_id):
    """Returns a dict containing properties containing a list of
    directories containing test failures and a separate list of
    individual test failures from the errorsummary.log artifact for
    the task.

    Calls the helper function munge_test_path to attempt to find an
    appropriate test path to pass to the task in
    MOZHARNESS_TEST_PATHS.  If no appropriate test path can be
    determined, nothing is returned.
    """
    re_bad_tests = [
        re.compile(r'Last test finished'),
        re.compile(r'LeakSanitizer'),
        re.compile(r'Main app process exited normally'),
        re.compile(r'ShutdownLeaks'),
        re.compile(r'[(]SimpleTest/TestRunner.js[)]'),
        re.compile(r'automation.py'),
        re.compile(r'https?://localhost:\d+/\d+/\d+/.*[.]html'),
        re.compile(r'jsreftest'),
        re.compile(r'leakcheck'),
        re.compile(r'mozrunner-startup'),
        re.compile(r'pid: '),
        re.compile(r'remoteautomation.py'),
        re.compile(r'unknown test url'),
    ]
    re_extract_tests = [
        re.compile(r'"test": "(?:[^:]+:)?(?:https?|file):[^ ]+/reftest/tests/([^ "]+)'),
        re.compile(r'"test": "(?:[^:]+:)?(?:https?|file):[^:]+:[0-9]+/tests/([^ "]+)'),
        re.compile(r'xpcshell-?[^ "]*\.ini:([^ "]+)'),
        re.compile(r'/tests/([^ "]+) - finished .*'),
        re.compile(r'"test": "([^ "]+)"'),
        re.compile(r'"message": "Error running command run_test with arguments '
                   '[(]<wptrunner[.]wpttest[.]TestharnessTest ([^>]+)>'),
        re.compile(r'"message": "TEST-[^ ]+ [|] ([^ "]+)[^|]*[|]')
    ]

    def munge_test_path(line):
        test_path = None
        for r in re_bad_tests:
            if r.search(line):
                return None
        for r in re_extract_tests:
            m = r.search(line)
            if m:
                test_path = m.group(1)
                break
        return test_path

    dirs = set()
    tests = set()
    artifacts = list_artifacts(task_id)
    for artifact in artifacts:
        if 'name' not in artifact or not artifact['name'].endswith('errorsummary.log'):
            continue

        stream = get_artifact(task_id, artifact['name'])
        if not stream:
            continue

        # The number of tasks created is determined by the
        # `times` value and the number of distinct tests and
        # directories as: times * (1 + len(tests) + len(dirs)).
        # Since the maximum value of `times` specifiable in the
        # Treeherder UI is 100, the number of tasks created can
        # reach a very large value depending on the number of
        # unique tests.  During testing, it was found that 10
        # distinct tests were sufficient to cause the action task
        # to exceed the maxRunTime of 1800 seconds resulting in it
        # being aborted.  We limit the number of distinct tests
        # and thereby the number of distinct test directories to a
        # maximum of 5 to keep the action task from timing out.

        for line in stream.read().split('\n'):
            test_path = munge_test_path(line.strip())

            if test_path:
                tests.add(test_path)
                test_dir = os.path.dirname(test_path)
                if test_dir:
                    dirs.add(test_dir)

            if len(tests) > 4:
                break

    return {'dirs': sorted(dirs), 'tests': sorted(tests)}


def create_isolate_failure_tasks(task_definition, failures, level, times):
    """
    Create tasks to re-run the original task plus tasks to test
    each failing test directory and individual path.

    """
    logger.info("Isolate task:\n{}".format(json.dumps(task_definition, indent=2)))

    # Operate on a copy of the original task_definition
    task_definition = copy.deepcopy(task_definition)

    task_name = task_definition['metadata']['name']
    repeatable_task = False
    if ('crashtest' in task_name or 'mochitest' in task_name or
        'reftest' in task_name and 'jsreftest' not in task_name):
        repeatable_task = True

    th_dict = task_definition['extra']['treeherder']
    symbol = th_dict['symbol']
    is_windows = 'windows' in th_dict['machine']['platform']

    suite = task_definition['extra']['suite']
    if '-coverage' in suite:
        suite = suite[:suite.index('-coverage')]
    is_wpt = 'web-platform-tests' in suite

    # command is a copy of task_definition['payload']['command'] from the original task.
    # It is used to create the new version containing the
    # task_definition['payload']['command'] with repeat_args which is updated every time
    # through the failure_group loop.

    command = copy.deepcopy(task_definition['payload']['command'])

    th_dict['groupSymbol'] = th_dict['groupSymbol'] + '-I'
    th_dict['tier'] = 3

    for i in range(times):
        create_task_from_def(slugid(), task_definition, level)

    if repeatable_task:
        task_definition['payload']['maxRunTime'] = 3600 * 3

    for failure_group in failures:
        if len(failures[failure_group]) == 0:
            continue
        if failure_group == 'dirs':
            failure_group_suffix = '-id'
            # execute 5 total loops
            repeat_args = ['--repeat=4'] if repeatable_task else []
        elif failure_group == 'tests':
            failure_group_suffix = '-it'
            # execute 20 total loops
            repeat_args = ['--repeat=19'] if repeatable_task else []
        else:
            logger.error("create_isolate_failure_tasks: Unknown failure_group {}".format(
                failure_group))
            continue

        if repeat_args:
            task_definition['payload']['command'] = add_args_to_command(command,
                                                                        extra_args=repeat_args)
        else:
            task_definition['payload']['command'] = command

        # saved_command is a saved version of the
        # task_definition['payload']['command'] with the repeat
        # arguments. We need to save it since
        # task_definition['payload']['command'] will be modified in the failure_path loop
        # when we are isolating web-platform-tests.

        saved_command = copy.deepcopy(task_definition['payload']['command'])

        for failure_path in failures[failure_group]:
            th_dict['symbol'] = symbol + failure_group_suffix
            if is_windows and not is_wpt:
                failure_path = '\\'.join(failure_path.split('/'))
            if is_wpt:
                include_args = ['--include={}'.format(failure_path)]
                task_definition['payload']['command'] = add_args_to_command(
                    saved_command,
                    extra_args=include_args)
            else:
                task_definition['payload']['env']['MOZHARNESS_TEST_PATHS'] = six.ensure_text(
                    json.dumps({suite: [failure_path]}))

            logger.info("Creating task for path {} with command {}".format(
                failure_path,
                task_definition['payload']['command']))
            for i in range(times):
                create_task_from_def(slugid(), task_definition, level)


@register_callback_action(
    name='isolate-test-failures',
    title='Isolate test failures in job',
    generic=True,
    symbol='it',
    description="Re-run Tests for original manifest, directories and tests for failing tests.",
    order=150,
    context=[
        {'kind': 'test'}
    ],
    schema={
        'type': 'object',
        'properties': {
            'times': {
                'type': 'integer',
                'default': 1,
                'minimum': 1,
                'maximum': 100,
                'title': 'Times',
                'description': 'How many times to run each task.',
            }
        },
        'additionalProperties': False
    },
)
def isolate_test_failures(parameters, graph_config, input, task_group_id, task_id):
    task = get_task_definition(task_id)
    decision_task_id, full_task_graph, label_to_taskid = fetch_graph_and_labels(
        parameters, graph_config)

    pre_task = full_task_graph.tasks[task['metadata']['name']]

    # fix up the task's dependencies, similar to how optimization would
    # have done in the decision
    dependencies = {name: label_to_taskid[label]
                    for name, label in pre_task.dependencies.iteritems()}

    task_definition = resolve_task_references(pre_task.label, pre_task.task, dependencies)
    task_definition.setdefault('dependencies', []).extend(dependencies.itervalues())

    failures = get_failures(task_id)
    logger.info('isolate_test_failures: %s' % failures)
    create_isolate_failure_tasks(task_definition,
                                 failures,
                                 parameters['level'],
                                 input['times'])
