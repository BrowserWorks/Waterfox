# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
"""
The objective of optimization is to remove as many tasks from the graph as
possible, as efficiently as possible, thereby delivering useful results as
quickly as possible.  For example, ideally if only a test script is modified in
a push, then the resulting graph contains only the corresponding test suite
task.

See ``taskcluster/docs/optimization.rst`` for more information.
"""

from __future__ import absolute_import, print_function, unicode_literals

import logging
from abc import ABCMeta, abstractmethod, abstractproperty
from collections import defaultdict

import six
from slugid import nice as slugid

from taskgraph.graph import Graph
from taskgraph.taskgraph import TaskGraph
from taskgraph.util.parameterization import resolve_task_references
from taskgraph.util.python_path import import_sibling_modules

logger = logging.getLogger(__name__)
registry = {}


def register_strategy(name, args=()):
    def wrap(cls):
        if name not in registry:
            registry[name] = cls(*args)
            if not hasattr(registry[name], 'description'):
                registry[name].description = name
        return cls
    return wrap


def optimize_task_graph(target_task_graph, params, do_not_optimize,
                        existing_tasks=None, strategy_override=None):
    """
    Perform task optimization, returning a taskgraph and a map from label to
    assigned taskId, including replacement tasks.
    """
    label_to_taskid = {}
    if not existing_tasks:
        existing_tasks = {}

    # instantiate the strategies for this optimization process
    strategies = registry.copy()
    if strategy_override:
        strategies.update(strategy_override)

    optimizations = _get_optimizations(target_task_graph, strategies)

    removed_tasks = remove_tasks(
        target_task_graph=target_task_graph,
        optimizations=optimizations,
        params=params,
        do_not_optimize=do_not_optimize)

    replaced_tasks = replace_tasks(
        target_task_graph=target_task_graph,
        optimizations=optimizations,
        params=params,
        do_not_optimize=do_not_optimize,
        label_to_taskid=label_to_taskid,
        existing_tasks=existing_tasks,
        removed_tasks=removed_tasks)

    return get_subgraph(
            target_task_graph, removed_tasks, replaced_tasks,
            label_to_taskid), label_to_taskid


def _get_optimizations(target_task_graph, strategies):
    def optimizations(label):
        task = target_task_graph.tasks[label]
        if task.optimization:
            opt_by, arg = task.optimization.items()[0]
            strategy = strategies[opt_by]
            if hasattr(strategy, 'description'):
                opt_by += " ({})".format(strategy.description)
            return (opt_by, strategy, arg)
        else:
            return ('never', strategies['never'], None)
    return optimizations


def _log_optimization(verb, opt_counts):
    if opt_counts:
        logger.info(
            '{} '.format(verb.title()) +
            ', '.join(
                '{} tasks by {}'.format(c, b)
                for b, c in sorted(opt_counts.iteritems())) +
            ' during optimization.')
    else:
        logger.info('No tasks {} during optimization'.format(verb))


def remove_tasks(target_task_graph, params, optimizations, do_not_optimize):
    """
    Implement the "Removing Tasks" phase, returning a set of task labels of all removed tasks.
    """
    opt_counts = defaultdict(int)
    removed = set()
    reverse_links_dict = target_task_graph.graph.reverse_links_dict()

    message = "optimize: {label} {verb} because of {reason}"
    for label in target_task_graph.graph.visit_preorder():
        verb = "kept"

        # if we're not allowed to optimize, that's easy..
        if label in do_not_optimize:
            logger.debug(message.format(label=label, verb=verb, reason="do not optimize"))
            continue

        # if there are remaining tasks depending on this one, do not remove..
        if any(l not in removed for l in reverse_links_dict[label]):
            logger.debug(message.format(label=label, verb=verb, reason="dependent tasks"))
            continue

        # call the optimization strategy
        task = target_task_graph.tasks[label]
        opt_by, opt, arg = optimizations(label)
        if opt.should_remove_task(task, params, arg):
            verb = "removed"
            removed.add(label)
            opt_counts[opt_by] += 1

        reason = "'{}' strategy".format(opt_by)
        logger.debug(message.format(label=label, verb=verb, reason=reason))

    _log_optimization('removed', opt_counts)
    return removed


def replace_tasks(target_task_graph, params, optimizations, do_not_optimize,
                  label_to_taskid, removed_tasks, existing_tasks):
    """
    Implement the "Replacing Tasks" phase, returning a set of task labels of
    all replaced tasks. The replacement taskIds are added to label_to_taskid as
    a side-effect.
    """
    opt_counts = defaultdict(int)
    replaced = set()
    links_dict = target_task_graph.graph.links_dict()

    for label in target_task_graph.graph.visit_postorder():
        # if we're not allowed to optimize, that's easy..
        if label in do_not_optimize:
            continue

        # if this task depends on un-replaced, un-removed tasks, do not replace
        if any(l not in replaced and l not in removed_tasks for l in links_dict[label]):
            continue

        # if the task already exists, that's an easy replacement
        repl = existing_tasks.get(label)
        if repl:
            label_to_taskid[label] = repl
            replaced.add(label)
            opt_counts['existing_tasks'] += 1
            continue

        # call the optimization strategy
        task = target_task_graph.tasks[label]
        opt_by, opt, arg = optimizations(label)
        repl = opt.should_replace_task(task, params, arg)
        if repl:
            if repl is True:
                # True means remove this task; get_subgraph will catch any
                # problems with removed tasks being depended on
                removed_tasks.add(label)
            else:
                label_to_taskid[label] = repl
                replaced.add(label)
            opt_counts[opt_by] += 1
            continue

    _log_optimization('replaced', opt_counts)
    return replaced


def get_subgraph(target_task_graph, removed_tasks, replaced_tasks, label_to_taskid):
    """
    Return the subgraph of target_task_graph consisting only of
    non-optimized tasks and edges between them.

    To avoid losing track of taskIds for tasks optimized away, this method
    simultaneously substitutes real taskIds for task labels in the graph, and
    populates each task definition's `dependencies` key with the appropriate
    taskIds.  Task references are resolved in the process.
    """

    # check for any dependency edges from included to removed tasks
    bad_edges = [(l, r, n) for l, r, n in target_task_graph.graph.edges
                 if l not in removed_tasks and r in removed_tasks]
    if bad_edges:
        probs = ', '.join('{} depends on {} as {} but it has been removed'.format(l, r, n)
                          for l, r, n in bad_edges)
        raise Exception("Optimization error: " + probs)

    # fill in label_to_taskid for anything not removed or replaced
    assert replaced_tasks <= set(label_to_taskid)
    for label in sorted(target_task_graph.graph.nodes - removed_tasks - set(label_to_taskid)):
        label_to_taskid[label] = slugid()

    # resolve labels to taskIds and populate task['dependencies']
    tasks_by_taskid = {}
    named_links_dict = target_task_graph.graph.named_links_dict()
    omit = removed_tasks | replaced_tasks
    for label, task in target_task_graph.tasks.iteritems():
        if label in omit:
            continue
        task.task_id = label_to_taskid[label]
        named_task_dependencies = {
            name: label_to_taskid[label]
            for name, label in named_links_dict.get(label, {}).iteritems()}

        # Add remaining soft dependencies
        if task.soft_dependencies:
            named_task_dependencies.update({
                label: label_to_taskid[label]
                for label in task.soft_dependencies
                if label in label_to_taskid and label not in omit
            })

        task.task = resolve_task_references(task.label, task.task, named_task_dependencies)
        deps = task.task.setdefault('dependencies', [])
        deps.extend(sorted(named_task_dependencies.itervalues()))
        tasks_by_taskid[task.task_id] = task

    # resolve edges to taskIds
    edges_by_taskid = (
        (label_to_taskid.get(left), label_to_taskid.get(right), name)
        for (left, right, name) in target_task_graph.graph.edges
    )
    # ..and drop edges that are no longer entirely in the task graph
    #   (note that this omits edges to replaced tasks, but they are still in task.dependnecies)
    edges_by_taskid = set(
        (left, right, name)
        for (left, right, name) in edges_by_taskid
        if left in tasks_by_taskid and right in tasks_by_taskid
    )

    return TaskGraph(
        tasks_by_taskid,
        Graph(set(tasks_by_taskid), edges_by_taskid))


@register_strategy('never')
class OptimizationStrategy(object):
    def should_remove_task(self, task, params, arg):
        """Determine whether to optimize this task by removing it.  Returns
        True to remove."""
        return False

    def should_replace_task(self, task, params, arg):
        """Determine whether to optimize this task by replacing it.  Returns a
        taskId to replace this task, True to replace with nothing, or False to
        keep the task."""
        return False


@register_strategy('always')
class Always(OptimizationStrategy):
    def should_remove_task(self, task, params, arg):
        return True


@six.add_metaclass(ABCMeta)
class CompositeStrategy(OptimizationStrategy):

    def __init__(self, *substrategies, **kwargs):
        self.substrategies = []
        missing = set()
        for sub in substrategies:
            if isinstance(sub, six.text_type):
                if sub not in registry.keys():
                    missing.add(sub)
                    continue
                sub = registry[sub]

            self.substrategies.append(sub)

        if missing:
            raise TypeError("substrategies aren't registered: {}".format(
                ",  ".join(sorted(missing))))

        self.split_args = kwargs.pop('split_args', None)
        if not self.split_args:
            self.split_args = lambda arg: [arg] * len(substrategies)
        if kwargs:
            raise TypeError("unexpected keyword args")

    @abstractproperty
    def description(self):
        """A textual description of the combined substrategies."""
        pass

    @abstractmethod
    def reduce(self, results):
        """Given all substrategy results as a generator, return the overall
        result."""
        pass

    def _generate_results(self, fname, task, params, arg):
        for sub, arg in zip(self.substrategies, self.split_args(arg)):
            yield getattr(sub, fname)(task, params, arg)

    def should_remove_task(self, *args):
        results = self._generate_results('should_remove_task', *args)
        return self.reduce(results)

    def should_replace_task(self, *args):
        results = self._generate_results('should_replace_task', *args)
        return self.reduce(results)


class Any(CompositeStrategy):
    """Given one or more optimization strategies, remove or replace a task if any of them
    says to.

    Replacement will use the value returned by the first strategy that says to replace.
    """

    @property
    def description(self):
        return "-or-".join([s.description for s in self.substrategies])

    @classmethod
    def reduce(cls, results):
        for rv in results:
            if rv:
                return rv
        return False


class All(CompositeStrategy):
    """Given one or more optimization strategies, remove or replace a task if all of them
    says to.

    Replacement will use the value returned by the first strategy passed in.
    Note the values used for replacement need not be the same, as long as they
    all say to replace.
    """
    @property
    def description(self):
        return "-and-".join([s.description for s in self.substrategies])

    @classmethod
    def reduce(cls, results):
        rvs = list(results)
        if all(rvs):
            return rvs[0]
        return False


class Alias(CompositeStrategy):
    """Provides an alias to an existing strategy.

    This can be useful to swap strategies in and out without needing to modify
    the task transforms.
    """
    def __init__(self, strategy):
        super(Alias, self).__init__(strategy)

    @property
    def description(self):
        return self.substrategies[0].description

    def reduce(self, results):
        return next(results)


# Trigger registration in sibling modules.
import_sibling_modules()


# Register composite strategies.
register_strategy('build', args=('skip-unless-schedules',))(Alias)
register_strategy('build-fuzzing', args=('push-interval-10',))(Alias)
register_strategy('test', args=(
    Any('skip-unless-schedules', 'bugbug-reduced-fallback', split_args=tuple),
    'backstop',
))(All)
register_strategy('test-inclusive', args=('skip-unless-schedules',))(Alias)
register_strategy('test-try', args=('skip-unless-schedules',))(Alias)


# Strategy overrides used by |mach try| and/or shadow-scheduler tasks.

class experimental(object):
    """Experimental strategies either under development or used as benchmarks.

    These run as "shadow-schedulers" on each autoland push (tier 3) and/or can be used
    with `./mach try auto`.  E.g:

        ./mach try auto --strategy relevant_tests
    """

    bugbug_all = {
        'test': Any('skip-unless-schedules', 'bugbug', split_args=tuple),
    }
    """Doesn't limit platforms, medium confidence threshold."""

    bugbug_all_high = {
        'test': Any('skip-unless-schedules', 'bugbug-high', split_args=tuple),
    }
    """Doesn't limit platforms, high confidence threshold."""

    bugbug_debug_disperse = {
        'test': Any(
            'skip-unless-schedules',
            Any('bugbug', 'platform-debug', 'platform-disperse'),
            split_args=tuple
        ),
    }
    """Restricts tests to debug platforms."""

    bugbug_disperse_low = {
        'test': Any(
            'skip-unless-schedules',
            Any('bugbug-low', 'platform-disperse'),
            split_args=tuple
        ),
    }
    """Disperse tests across platforms, low confidence threshold."""

    bugbug_disperse = {
        'test': Any(
            'skip-unless-schedules',
            Any('bugbug', 'platform-disperse'),
            split_args=tuple
        ),
    }
    """Disperse tests across platforms, medium confidence threshold."""

    bugbug_disperse_high = {
        'test': Any(
            'skip-unless-schedules',
            Any('bugbug-high', 'platform-disperse'),
            split_args=tuple
        ),
    }
    """Disperse tests across platforms, high confidence threshold."""

    bugbug_reduced = {
        'test': Any('skip-unless-schedules', 'bugbug-reduced', split_args=tuple),
    }
    """Use the reduced set of tasks (and no groups) chosen by bugbug."""

    bugbug_reduced_high = {
        'test': Any('skip-unless-schedules', 'bugbug-reduced-high', split_args=tuple),
    }
    """Use the reduced set of tasks (and no groups) chosen by bugbug, high
    confidence threshold."""

    relevant_tests = {
        'test': Any('skip-unless-schedules', 'skip-unless-has-relevant-tests', split_args=tuple),
    }
    """Runs task containing tests in the same directories as modified files."""

    seta = {
        'test': Any('skip-unless-schedules', 'seta', split_args=tuple),
    }
    """Provides a stable history of SETA's performance in the event we make it
    non-default in the future. Only useful as a benchmark."""


class ExperimentalOverride(object):
    """Overrides dictionaries that are stored in a container with new values.

    This can be used to modify all strategies in a collection the same way,
    presumably with strategies affecting kinds of tasks tangential to the
    current context.

    Args:
        base (object): A container class supporting attribute access.
        overrides (dict): Values to update any accessed dictionaries with.
    """
    def __init__(self, base, overrides):
        self.base = base
        self.overrides = overrides

    def __getattr__(self, name):
        val = getattr(self.base, name).copy()
        val.update(self.overrides)
        return val


tryselect = ExperimentalOverride(experimental, {
    'build': Any('skip-unless-schedules', 'bugbug-reduced', split_args=tuple),
    'build-fuzzing': Alias('bugbug-reduced'),
})
