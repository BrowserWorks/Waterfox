# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

from __future__ import absolute_import

import sys
import unittest

import pytest
from taskgraph.decision import full_task_graph_to_runnable_jobs
from taskgraph.graph import Graph
from taskgraph.taskgraph import TaskGraph
from taskgraph.task import Task
from mozunit import main


class TestRunnableJobs(unittest.TestCase):

    tasks = [
        {
            'kind': 'build',
            'label': 'a',
            'attributes': {},
            'task': {
                'extra': {
                    'treeherder': {
                        'symbol': 'B'
                    }
                },
            }
        },
        {
            'kind': 'test',
            'label': 'b',
            'attributes': {},
            'task': {
                'extra': {
                    'treeherder': {
                        'collection': {
                            'opt': True
                        },
                        'groupName': 'Some group',
                        'groupSymbol': 'GS',
                        'machine': {
                            'platform': 'linux64'
                        },
                        'symbol': 't'
                    }
                },
            }
        },
    ]

    def make_taskgraph(self, tasks):
        label_to_taskid = {k: k + '-tid' for k in tasks}
        for label, task_id in label_to_taskid.iteritems():
            tasks[label].task_id = task_id
        graph = Graph(nodes=set(tasks), edges=set())
        taskgraph = TaskGraph(tasks, graph)
        return taskgraph, label_to_taskid

    @pytest.mark.xfail(
        sys.version_info >= (3, 0), reason="python3 migration is not complete"
    )
    def test_taskgraph_to_runnable_jobs(self):
        tg, label_to_taskid = self.make_taskgraph({
            t['label']: Task(**t) for t in self.tasks[:]
        })

        res = full_task_graph_to_runnable_jobs(tg.to_json())

        self.assertEqual(res, {
            'a': {
                'symbol': 'B'
            },
            'b': {
                'collection': {'opt': True},
                'groupName': 'Some group',
                'groupSymbol': 'GS',
                'symbol': 't',
                'platform': 'linux64'
            }
        })


if __name__ == '__main__':
    main()
