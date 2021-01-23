# Any copyright is dedicated to the public domain.
# http://creativecommons.org/publicdomain/zero/1.0/

from __future__ import absolute_import

import time
from datetime import datetime
from time import mktime

import pytest
from mozunit import main

from taskgraph.optimize import seta
from taskgraph.optimize.backstop import Backstop
from taskgraph.optimize.bugbug import (
    BugBugPushSchedules,
    DisperseGroups,
    SkipUnlessDebug,
)
from taskgraph.task import Task
from taskgraph.util.bugbug import (
    BUGBUG_BASE_URL,
    BugbugTimeoutException,
    push_schedules,
)


@pytest.fixture(autouse=True)
def clear_push_schedules_memoize():
    push_schedules.clear()


@pytest.fixture(scope='module')
def params():
    return {
        'branch': 'integration/autoland',
        'head_repository': 'https://hg.mozilla.org/integration/autoland',
        'head_rev': 'abcdef',
        'project': 'autoland',
        'pushlog_id': 1,
        'pushdate': mktime(datetime.now().timetuple()),
    }


def generate_tasks(*tasks):
    for i, task in enumerate(tasks):
        task.setdefault('label', 'task-{}'.format(i))
        task.setdefault('kind', 'test')
        task.setdefault('task', {})
        task.setdefault('attributes', {})
        task['attributes'].setdefault('e10s', True)

        for attr in ('optimization', 'dependencies', 'soft_dependencies', 'release_artifacts'):
            task.setdefault(attr, None)

        task['task'].setdefault('label', task['label'])
        yield Task.from_json(task)


# task sets

default_tasks = list(generate_tasks(
    {'attributes': {'test_manifests': ['foo/test.ini', 'bar/test.ini']}},
    {'attributes': {'test_manifests': ['bar/test.ini'], 'build_type': 'debug'}},
    {'attributes': {'build_type': 'debug'}},
    {'attributes': {'test_manifests': [], 'build_type': 'opt'}},
    {'attributes': {'build_type': 'opt'}},
))


disperse_tasks = list(generate_tasks(
    {'attributes': {
        'test_manifests': ['foo/test.ini', 'bar/test.ini'],
        'test_platform': 'linux/opt',
    }},
    {'attributes': {
        'test_manifests': ['bar/test.ini'],
        'test_platform': 'linux/opt',
    }},
    {'attributes': {
        'test_manifests': ['bar/test.ini'],
        'test_platform': 'windows/debug',
    }},
    {'attributes': {
        'test_manifests': ['bar/test.ini'],
        'test_platform': 'linux/opt',
        'unittest_variant': 'fission',
    }},
    {'attributes': {
        'e10s': False,
        'test_manifests': ['bar/test.ini'],
        'test_platform': 'linux/opt',
    }},
))


def idfn(param):
    if isinstance(param, tuple):
        return param[0].__name__
    return None


@pytest.mark.parametrize("opt,tasks,arg,expected", [
    # debug
    pytest.param(
        SkipUnlessDebug(),
        default_tasks,
        None,
        ['task-0', 'task-1', 'task-2'],
    ),

    # disperse with no supplied importance
    pytest.param(
        DisperseGroups(),
        disperse_tasks,
        None,
        [t.label for t in disperse_tasks],
    ),

    # disperse with low importance
    pytest.param(
        DisperseGroups(),
        disperse_tasks,
        {'bar/test.ini': 'low'},
        ['task-0', 'task-2'],
    ),

    # disperse with medium importance
    pytest.param(
        DisperseGroups(),
        disperse_tasks,
        {'bar/test.ini': 'medium'},
        ['task-0', 'task-1', 'task-2'],
    ),

    # disperse with high importance
    pytest.param(
        DisperseGroups(),
        disperse_tasks,
        {'bar/test.ini': 'high'},
        ['task-0', 'task-1', 'task-2', 'task-3'],
    ),
], ids=idfn)
def test_optimization_strategy(responses, params, opt, tasks, arg, expected):
    labels = [t.label for t in tasks if not opt.should_remove_task(t, params, arg)]
    assert sorted(labels) == sorted(expected)


@pytest.mark.parametrize("args,data,expected", [
    # empty
    pytest.param(
        (0.1,),
        {},
        [],
    ),

    # only tasks without test manifests selected
    pytest.param(
        (0.1,),
        {'tasks': {'task-1': 0.9, 'task-2': 0.1, 'task-3': 0.5}},
        ['task-2'],
    ),

    # tasks which are unknown to bugbug are selected
    pytest.param(
        (0.1,),
        {'tasks': {'task-1': 0.9, 'task-3': 0.5}, 'known_tasks': ['task-1', 'task-3', 'task-4']},
        ['task-2'],
    ),

    # tasks containing groups selected
    pytest.param(
        (0.1,),
        {'groups': {'foo/test.ini': 0.4}},
        ['task-0'],
    ),

    # tasks matching "tasks" or "groups" selected
    pytest.param(
        (0.1,),
        {'tasks': {'task-2': 0.2}, 'groups': {'foo/test.ini': 0.25, 'bar/test.ini': 0.75}},
        ['task-0', 'task-1', 'task-2'],
    ),

    # tasks matching "tasks" or "groups" selected, when they exceed the confidence threshold
    pytest.param(
        (0.5,),
        {
            'tasks': {'task-2': 0.2, 'task-4': 0.5},
            'groups': {'foo/test.ini': 0.65, 'bar/test.ini': 0.25}
        },
        ['task-0', 'task-4'],
    ),

    # tasks matching "reduced_tasks" are selected, when they exceed the confidence threshold
    pytest.param(
        (0.7, True),
        {
            'tasks': {'task-2': 0.7, 'task-4': 0.7},
            'reduced_tasks': {'task-4': 0.7},
            'groups': {'foo/test.ini': 0.75, 'bar/test.ini': 0.25}
        },
        ['task-4'],
    ),

], ids=idfn)
def test_bugbug_push_schedules(responses, params, args, data, expected):
    query = "/push/{branch}/{head_rev}/schedules".format(**params)
    url = BUGBUG_BASE_URL + query

    responses.add(
        responses.GET,
        url,
        json=data,
        status=200,
    )

    opt = BugBugPushSchedules(*args)
    labels = [t.label for t in default_tasks if not opt.should_remove_task(t, params, {})]
    assert sorted(labels) == sorted(expected)


def test_bugbug_timeout(monkeypatch, responses, params):
    query = "/push/{branch}/{head_rev}/schedules".format(**params)
    url = BUGBUG_BASE_URL + query
    responses.add(
        responses.GET,
        url,
        json={"ready": False},
        status=202,
    )

    # Make sure the test runs fast.
    monkeypatch.setattr(time, 'sleep', lambda i: None)

    opt = BugBugPushSchedules(0.5)
    with pytest.raises(BugbugTimeoutException):
        opt.should_remove_task(default_tasks[0], params, None)


def test_bugbug_fallback(monkeypatch, responses, params):
    query = "/push/{branch}/{head_rev}/schedules".format(**params)
    url = BUGBUG_BASE_URL + query
    responses.add(
        responses.GET,
        url,
        json={"ready": False},
        status=202,
    )

    # Make sure the test runs fast.
    monkeypatch.setattr(time, 'sleep', lambda i: None)

    monkeypatch.setattr(seta, 'is_low_value_task', lambda l, p: l == default_tasks[0].label)

    opt = BugBugPushSchedules(0.5, fallback=True)
    assert opt.should_remove_task(default_tasks[0], params, None)

    # Make sure we don't hit bugbug more than once.
    responses.reset()

    assert not opt.should_remove_task(default_tasks[1], params, None)


def test_backstop(params):
    all_labels = {t.label for t in default_tasks}
    opt = Backstop(10, 60, {'try'})  # every 10th push or 1 hour

    # If there's no previous push date, run tasks
    params['pushlog_id'] = 8
    scheduled = {t.label for t in default_tasks if not opt.should_remove_task(t, params, None)}
    assert scheduled == all_labels

    # Only multiples of 10 schedule tasks. Pushdate from push 8 was cached.
    params['pushlog_id'] = 9
    params['pushdate'] += 3599
    scheduled = {t.label for t in default_tasks if not opt.should_remove_task(t, params, None)}
    assert scheduled == set()

    params['pushlog_id'] = 10
    params['pushdate'] += 1
    scheduled = {t.label for t in default_tasks if not opt.should_remove_task(t, params, None)}
    assert scheduled == all_labels

    # Tasks are also scheduled if an hour has passed.
    params['pushlog_id'] = 11
    params['pushdate'] += 3600
    scheduled = {t.label for t in default_tasks if not opt.should_remove_task(t, params, None)}
    assert scheduled == all_labels

    # On non-autoland projects the 'remove_on_projects' value is used.
    params['project'] = 'mozilla-central'
    scheduled = {t.label for t in default_tasks if not opt.should_remove_task(t, params, None)}
    assert scheduled == all_labels

    params['project'] = 'try'
    scheduled = {t.label for t in default_tasks if not opt.should_remove_task(t, params, None)}
    assert scheduled == set()


if __name__ == '__main__':
    main()
