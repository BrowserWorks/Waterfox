# -*- coding: utf-8 -*-

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

from __future__ import absolute_import, print_function, unicode_literals

import json
import logging
import six

import requests
from requests.exceptions import HTTPError

from .registry import register_callback_action
from .util import create_tasks, combine_task_graph_files, add_args_to_command
from taskgraph.util.taskcluster import get_artifact_from_index
from taskgraph.util.taskgraph import find_decision_task
from taskgraph.taskgraph import TaskGraph
from taskgraph.util import taskcluster

PUSHLOG_TMPL = '{}/json-pushes?version=2&startID={}&endID={}'
INDEX_TMPL = 'gecko.v2.{}.pushlog-id.{}.decision'

logger = logging.getLogger(__name__)


@register_callback_action(
    title='Backfill',
    name='backfill',
    generic=True,
    symbol='Bk',
    description=('Take the label of the current task, '
                 'and trigger the task with that label '
                 'on previous pushes in the same project.'),
    order=200,
    context=[{}],  # This will be available for all tasks
    schema={
        'type': 'object',
        'properties': {
            'depth': {
                'type': 'integer',
                'default': 9,
                'minimum': 1,
                'maximum': 25,
                'title': 'Depth',
                'description': ('The number of previous pushes before the current '
                                'push to attempt to trigger this task on.')
            },
            'inclusive': {
                'type': 'boolean',
                'default': False,
                'title': 'Inclusive Range',
                'description': ('If true, the backfill will also retrigger the task '
                                'on the selected push.')
            },
            'testPath': {
                'type': 'string',
                'title': 'Test Path',
            },
            'times': {
                'type': 'integer',
                'default': 1,
                'minimum': 1,
                'maximum': 10,
                'title': 'Times',
                'description': ('The number of times to execute each job '
                                'you are backfilling.')
            }
        },
        'additionalProperties': False
    },
    available=lambda parameters: True
)
def backfill_action(parameters, graph_config, input, task_group_id, task_id):
    task = taskcluster.get_task_definition(task_id)
    label = task['metadata']['name']
    pushes = []
    inclusive_tweak = 1 if input.get('inclusive') else 0
    depth = input.get('depth', 9) + inclusive_tweak
    end_id = int(parameters['pushlog_id']) - (1 - inclusive_tweak)

    while True:
        start_id = max(end_id - depth, 0)
        pushlog_url = PUSHLOG_TMPL.format(parameters['head_repository'], start_id, end_id)
        r = requests.get(pushlog_url)
        r.raise_for_status()
        pushes = pushes + r.json()['pushes'].keys()
        if len(pushes) >= depth:
            break

        end_id = start_id - 1
        start_id -= depth
        if start_id < 0:
            break

    pushes = sorted(pushes)[-depth:]
    backfill_pushes = []

    for push in pushes:
        try:
            full_task_graph = get_artifact_from_index(
                    INDEX_TMPL.format(parameters['project'], push),
                    'public/full-task-graph.json')
            _, full_task_graph = TaskGraph.from_json(full_task_graph)
            label_to_taskid = get_artifact_from_index(
                    INDEX_TMPL.format(parameters['project'], push),
                    'public/label-to-taskid.json')
            push_params = get_artifact_from_index(
                    INDEX_TMPL.format(parameters['project'], push),
                    'public/parameters.yml')
            push_decision_task_id = find_decision_task(push_params, graph_config)
        except HTTPError as e:
            logger.info('Skipping {} due to missing index artifacts! Error: {}'.format(push, e))
            continue

        if label in full_task_graph.tasks.keys():
            def modifier(task):
                if task.label != label:
                    return task

                if input.get('testPath', ''):
                    is_wpttest = 'web-platform' in task.task['metadata']['name']
                    is_android = 'android' in task.task['metadata']['name']
                    gpu_required = False
                    if (not is_wpttest) and \
                       ('gpu' in task.task['metadata']['name'] or
                        'webgl' in task.task['metadata']['name'] or
                        ('reftest' in task.task['metadata']['name'] and
                         'jsreftest' not in task.task['metadata']['name'])):
                        gpu_required = True

                    # Create new cmd that runs a test-verify type job
                    preamble_length = 3
                    verify_args = ['--e10s',
                                   '--verify',
                                   '--total-chunk=1',
                                   '--this-chunk=1']
                    if is_android:
                        # no --e10s; todo, what about future geckoView?
                        verify_args.remove('--e10s')

                    if gpu_required:
                        verify_args.append('--gpu-required')

                    if 'testPath' in input:
                        task.task['payload']['env']['MOZHARNESS_TEST_PATHS'] = six.ensure_text(
                            json.dumps({
                                task.task['extra']['suite']['flavor']: [input['testPath']]
                            }))

                    cmd_parts = task.task['payload']['command']
                    keep_args = ['--installer-url', '--download-symbols', '--test-packages-url']
                    cmd_parts = remove_args_from_command(cmd_parts, preamble_length, keep_args)
                    cmd_parts = add_args_to_command(cmd_parts, verify_args)
                    task.task['payload']['command'] = cmd_parts

                    # morph the task label to a test-verify job
                    pc = task.task['metadata']['name'].split('/')
                    config = pc[-1].split('-')
                    subtype = ''
                    symbol = 'TV-bf'
                    if gpu_required:
                        subtype = '-gpu'
                        symbol = 'TVg-bf'
                    if is_wpttest:
                        subtype = '-wpt'
                        symbol = 'TVw-bf'
                    if not is_android:
                        subtype = "%s-e10s" % subtype
                    newlabel = "%s/%s-test-verify%s" % (pc[0], config[0], subtype)
                    task.task['metadata']['name'] = newlabel
                    task.task['tags']['label'] = newlabel

                    task.task['extra']['index']['rank'] = 0
                    task.task['extra']['chunks']['current'] = 1
                    task.task['extra']['chunks']['total'] = 1

                    task.task['extra']['suite']['name'] = 'test-verify'
                    task.task['extra']['suite']['flavor'] = 'test-verify'

                    task.task['extra']['treeherder']['symbol'] = symbol
                    del task.task['extra']['treeherder']['groupSymbol']
                return task

            times = input.get('times', 1)
            for i in range(times):
                create_tasks(graph_config, [label], full_task_graph, label_to_taskid,
                             push_params, push_decision_task_id, push, modifier=modifier)
            backfill_pushes.append(push)
        else:
            logging.info('Could not find {} on {}. Skipping.'.format(label, push))
    combine_task_graph_files(backfill_pushes)


def remove_args_from_command(cmd_parts, preamble_length=0, args_to_ignore=[]):
    """
       We need to remove all extra instances of command line arguments
       that are suite/job specific, like suite=jsreftest, subsuite=devtools
       and other ones like --total-chunk=X.
       args:
         cmd_parts: the raw command as seen by taskcluster
         preamble_length: the number of args to skip (usually python -u <name>)
         args_to_ignore: ignore specific args and their related values
    """
    cmd_type = 'default'
    if len(cmd_parts) == 1 and isinstance(cmd_parts[0], dict):
        # windows has single cmd part as dict: 'task-reference', with long string
        preamble_length += 2
        cmd_parts = cmd_parts[0]['task-reference'].split(' ')
        cmd_type = 'dict'
    elif len(cmd_parts) == 1 and isinstance(cmd_parts[0], list):
        # osx has an single value array with an array inside
        preamble_length += 2
        cmd_parts = cmd_parts[0]
        cmd_type = 'subarray'

    idx = preamble_length - 1
    while idx+1 < len(cmd_parts):
        idx += 1
        part = cmd_parts[idx]

        # task-reference values need a transform to s/<build>/{taskID}/
        if isinstance(part, dict):
            part = cmd_parts[idx]['task-reference']

        if filter(lambda x: x in part, args_to_ignore):
            # some args are |--arg=val| vs |--arg val|
            if '=' not in part:
                idx += 1
            continue

        # remove job specific arg, and reduce array index as size changes
        cmd_parts.remove(cmd_parts[idx])
        idx -= 1

    if cmd_type == 'dict':
        cmd_parts = [{'task-reference': ' '.join(cmd_parts)}]
    elif cmd_type == 'subarray':
        cmd_parts = [cmd_parts]
    return cmd_parts
