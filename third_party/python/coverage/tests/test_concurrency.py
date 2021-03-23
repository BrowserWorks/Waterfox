# Licensed under the Apache License: http://www.apache.org/licenses/LICENSE-2.0
# For details: https://github.com/nedbat/coveragepy/blob/master/NOTICE.txt

"""Tests for concurrency libraries."""

import glob
import os
import random
import sys
import threading
import time

from flaky import flaky

import coverage
from coverage import env
from coverage.backward import import_local_file
from coverage.data import line_counts
from coverage.files import abs_file

from tests.coveragetest import CoverageTest
from tests.helpers import remove_files


# These libraries aren't always available, we'll skip tests if they aren't.

try:
    import multiprocessing
except ImportError:         # pragma: only jython
    multiprocessing = None

try:
    import eventlet
except ImportError:
    eventlet = None

try:
    import gevent
except ImportError:
    gevent = None

try:
    import greenlet
except ImportError:         # pragma: only jython
    greenlet = None


def measurable_line(l):
    """Is this a line of code coverage will measure?

    Not blank, not a comment, and not "else"
    """
    l = l.strip()
    if not l:
        return False
    if l.startswith('#'):
        return False
    if l.startswith('else:'):
        return False
    if env.JYTHON and l.startswith(('try:', 'except:', 'except ', 'break', 'with ')):
        # Jython doesn't measure these statements.
        return False                    # pragma: only jython
    return True


def line_count(s):
    """How many measurable lines are in `s`?"""
    return len(list(filter(measurable_line, s.splitlines())))


def print_simple_annotation(code, linenos):
    """Print the lines in `code` with X for each line number in `linenos`."""
    for lineno, line in enumerate(code.splitlines(), start=1):
        print(" {} {}".format("X" if lineno in linenos else " ", line))


class LineCountTest(CoverageTest):
    """Test the helpers here."""

    run_in_temp_dir = False

    def test_line_count(self):
        CODE = """
            # Hey there!
            x = 1
            if x:
                print("hello")
            else:
                print("bye")

            print("done")
            """

        self.assertEqual(line_count(CODE), 5)


# The code common to all the concurrency models.
SUM_RANGE_Q = """
    # Above this will be imports defining queue and threading.

    class Producer(threading.Thread):
        def __init__(self, limit, q):
            threading.Thread.__init__(self)
            self.limit = limit
            self.q = q

        def run(self):
            for i in range(self.limit):
                self.q.put(i)
            self.q.put(None)

    class Consumer(threading.Thread):
        def __init__(self, q, qresult):
            threading.Thread.__init__(self)
            self.q = q
            self.qresult = qresult

        def run(self):
            sum = 0
            while "no peephole".upper():
                i = self.q.get()
                if i is None:
                    break
                sum += i
            self.qresult.put(sum)

    def sum_range(limit):
        q = queue.Queue()
        qresult = queue.Queue()
        c = Consumer(q, qresult)
        p = Producer(limit, q)
        c.start()
        p.start()

        p.join()
        c.join()
        return qresult.get()

    # Below this will be something using sum_range.
    """

PRINT_SUM_RANGE = """
    print(sum_range({QLIMIT}))
    """

# Import the things to use threads.
if env.PY2:
    THREAD = """
    import threading
    import Queue as queue
    """
else:
    THREAD = """
    import threading
    import queue
    """

# Import the things to use eventlet.
EVENTLET = """
    import eventlet.green.threading as threading
    import eventlet.queue as queue
    """

# Import the things to use gevent.
GEVENT = """
    from gevent import monkey
    monkey.patch_thread()
    import threading
    import gevent.queue as queue
    """

# Uncomplicated code that doesn't use any of the concurrency stuff, to test
# the simple case under each of the regimes.
SIMPLE = """
    total = 0
    for i in range({QLIMIT}):
        total += i
    print(total)
    """


def cant_trace_msg(concurrency, the_module):
    """What might coverage.py say about a concurrency setting and imported module?"""
    # In the concurrency choices, "multiprocessing" doesn't count, so remove it.
    if "multiprocessing" in concurrency:
        parts = concurrency.split(",")
        parts.remove("multiprocessing")
        concurrency = ",".join(parts)

    if the_module is None:
        # We don't even have the underlying module installed, we expect
        # coverage to alert us to this fact.
        expected_out = (
            "Couldn't trace with concurrency=%s, "
            "the module isn't installed.\n" % concurrency
        )
    elif env.C_TRACER or concurrency == "thread" or concurrency == "":
        expected_out = None
    else:
        expected_out = (
            "Can't support concurrency=%s with PyTracer, "
            "only threads are supported\n" % concurrency
        )
    return expected_out


class ConcurrencyTest(CoverageTest):
    """Tests of the concurrency support in coverage.py."""

    QLIMIT = 1000

    def try_some_code(self, code, concurrency, the_module, expected_out=None):
        """Run some concurrency testing code and see that it was all covered.

        `code` is the Python code to execute.  `concurrency` is the name of
        the concurrency regime to test it under.  `the_module` is the imported
        module that must be available for this to work at all. `expected_out`
        is the text we expect the code to produce.

        """

        self.make_file("try_it.py", code)

        cmd = "coverage run --concurrency=%s try_it.py" % concurrency
        out = self.run_command(cmd)

        expected_cant_trace = cant_trace_msg(concurrency, the_module)

        if expected_cant_trace is not None:
            self.assertEqual(out, expected_cant_trace)
        else:
            # We can fully measure the code if we are using the C tracer, which
            # can support all the concurrency, or if we are using threads.
            if expected_out is None:
                expected_out = "%d\n" % (sum(range(self.QLIMIT)))
            print(code)
            self.assertEqual(out, expected_out)

            # Read the coverage file and see that try_it.py has all its lines
            # executed.
            data = coverage.CoverageData(".coverage")
            data.read()

            # If the test fails, it's helpful to see this info:
            fname = abs_file("try_it.py")
            linenos = data.lines(fname)
            print("{}: {}".format(len(linenos), linenos))
            print_simple_annotation(code, linenos)

            lines = line_count(code)
            self.assertEqual(line_counts(data)['try_it.py'], lines)

    def test_threads(self):
        code = (THREAD + SUM_RANGE_Q + PRINT_SUM_RANGE).format(QLIMIT=self.QLIMIT)
        self.try_some_code(code, "thread", threading)

    def test_threads_simple_code(self):
        code = SIMPLE.format(QLIMIT=self.QLIMIT)
        self.try_some_code(code, "thread", threading)

    def test_eventlet(self):
        code = (EVENTLET + SUM_RANGE_Q + PRINT_SUM_RANGE).format(QLIMIT=self.QLIMIT)
        self.try_some_code(code, "eventlet", eventlet)

    def test_eventlet_simple_code(self):
        code = SIMPLE.format(QLIMIT=self.QLIMIT)
        self.try_some_code(code, "eventlet", eventlet)

    def test_gevent(self):
        code = (GEVENT + SUM_RANGE_Q + PRINT_SUM_RANGE).format(QLIMIT=self.QLIMIT)
        self.try_some_code(code, "gevent", gevent)

    def test_gevent_simple_code(self):
        code = SIMPLE.format(QLIMIT=self.QLIMIT)
        self.try_some_code(code, "gevent", gevent)

    def test_greenlet(self):
        GREENLET = """\
            from greenlet import greenlet

            def test1(x, y):
                z = gr2.switch(x+y)
                print(z)

            def test2(u):
                print(u)
                gr1.switch(42)

            gr1 = greenlet(test1)
            gr2 = greenlet(test2)
            gr1.switch("hello", " world")
            """
        self.try_some_code(GREENLET, "greenlet", greenlet, "hello world\n42\n")

    def test_greenlet_simple_code(self):
        code = SIMPLE.format(QLIMIT=self.QLIMIT)
        self.try_some_code(code, "greenlet", greenlet)

    def test_bug_330(self):
        BUG_330 = """\
            from weakref import WeakKeyDictionary
            import eventlet

            def do():
                eventlet.sleep(.01)

            gts = WeakKeyDictionary()
            for _ in range(100):
                gts[eventlet.spawn(do)] = True
                eventlet.sleep(.005)

            eventlet.sleep(.1)
            print(len(gts))
            """
        self.try_some_code(BUG_330, "eventlet", eventlet, "0\n")


SQUARE_OR_CUBE_WORK = """
    def work(x):
        # Use different lines in different subprocesses.
        if x % 2:
            y = x*x
        else:
            y = x*x*x
        return y
    """

SUM_RANGE_WORK = """
    def work(x):
        return sum_range((x+1)*100)
    """

MULTI_CODE = """
    # Above this will be a definition of work().
    import multiprocessing
    import os
    import time
    import sys

    def process_worker_main(args):
        # Need to pause, or the tasks go too quickly, and some processes
        # in the pool don't get any work, and then don't record data.
        time.sleep(0.02)
        ret = work(*args)
        return os.getpid(), ret

    if __name__ == "__main__":      # pragma: no branch
        # This if is on a single line so we can get 100% coverage
        # even if we have no arguments.
        if len(sys.argv) > 1: multiprocessing.set_start_method(sys.argv[1])
        pool = multiprocessing.Pool({NPROCS})
        inputs = [(x,) for x in range({UPTO})]
        outputs = pool.imap_unordered(process_worker_main, inputs)
        pids = set()
        total = 0
        for pid, sq in outputs:
            pids.add(pid)
            total += sq
        print("%d pids, total = %d" % (len(pids), total))
        pool.close()
        pool.join()
    """


@flaky(max_runs=30)         # Sometimes a test fails due to inherent randomness. Try more times.
class MultiprocessingTest(CoverageTest):
    """Test support of the multiprocessing module."""

    def setUp(self):
        if not multiprocessing:
            self.skipTest("No multiprocessing in this Python")      # pragma: only jython
        super(MultiprocessingTest, self).setUp()

    def try_multiprocessing_code(
        self, code, expected_out, the_module, nprocs, concurrency="multiprocessing", args=""
    ):
        """Run code using multiprocessing, it should produce `expected_out`."""
        self.make_file("multi.py", code)
        self.make_file(".coveragerc", """\
            [run]
            concurrency = %s
            source = .
            """ % concurrency)

        if env.PYVERSION >= (3, 4):
            start_methods = ['fork', 'spawn']
        else:
            start_methods = ['']

        for start_method in start_methods:
            if start_method and start_method not in multiprocessing.get_all_start_methods():
                continue

            remove_files(".coverage", ".coverage.*")
            cmd = "coverage run {args} multi.py {start_method}".format(
                args=args, start_method=start_method,
            )
            out = self.run_command(cmd)
            expected_cant_trace = cant_trace_msg(concurrency, the_module)

            if expected_cant_trace is not None:
                self.assertEqual(out, expected_cant_trace)
            else:
                self.assertEqual(out.rstrip(), expected_out)
                self.assertEqual(len(glob.glob(".coverage.*")), nprocs + 1)

                out = self.run_command("coverage combine")
                self.assertEqual(out, "")
                out = self.run_command("coverage report -m")

                last_line = self.squeezed_lines(out)[-1]
                self.assertRegex(last_line, r"multi.py \d+ 0 100%")

    def test_multiprocessing_simple(self):
        nprocs = 3
        upto = 30
        code = (SQUARE_OR_CUBE_WORK + MULTI_CODE).format(NPROCS=nprocs, UPTO=upto)
        total = sum(x*x if x%2 else x*x*x for x in range(upto))
        expected_out = "{nprocs} pids, total = {total}".format(nprocs=nprocs, total=total)
        self.try_multiprocessing_code(code, expected_out, threading, nprocs)

    def test_multiprocessing_append(self):
        nprocs = 3
        upto = 30
        code = (SQUARE_OR_CUBE_WORK + MULTI_CODE).format(NPROCS=nprocs, UPTO=upto)
        total = sum(x*x if x%2 else x*x*x for x in range(upto))
        expected_out = "{nprocs} pids, total = {total}".format(nprocs=nprocs, total=total)
        self.try_multiprocessing_code(code, expected_out, threading, nprocs, args="--append")

    def test_multiprocessing_and_gevent(self):
        nprocs = 3
        upto = 30
        code = (
            SUM_RANGE_WORK + EVENTLET + SUM_RANGE_Q + MULTI_CODE
        ).format(NPROCS=nprocs, UPTO=upto)
        total = sum(sum(range((x + 1) * 100)) for x in range(upto))
        expected_out = "{nprocs} pids, total = {total}".format(nprocs=nprocs, total=total)
        self.try_multiprocessing_code(
            code, expected_out, eventlet, nprocs, concurrency="multiprocessing,eventlet"
        )

    def try_multiprocessing_code_with_branching(self, code, expected_out):
        """Run code using multiprocessing, it should produce `expected_out`."""
        self.make_file("multi.py", code)
        self.make_file("multi.rc", """\
            [run]
            concurrency = multiprocessing
            branch = True
            omit = */site-packages/*
            """)

        if env.PYVERSION >= (3, 4):
            start_methods = ['fork', 'spawn']
        else:
            start_methods = ['']

        for start_method in start_methods:
            if start_method and start_method not in multiprocessing.get_all_start_methods():
                continue

            out = self.run_command("coverage run --rcfile=multi.rc multi.py %s" % (start_method,))
            self.assertEqual(out.rstrip(), expected_out)

            out = self.run_command("coverage combine")
            self.assertEqual(out, "")
            out = self.run_command("coverage report -m")

            last_line = self.squeezed_lines(out)[-1]
            self.assertRegex(last_line, r"multi.py \d+ 0 \d+ 0 100%")

    def test_multiprocessing_with_branching(self):
        nprocs = 3
        upto = 30
        code = (SQUARE_OR_CUBE_WORK + MULTI_CODE).format(NPROCS=nprocs, UPTO=upto)
        total = sum(x*x if x%2 else x*x*x for x in range(upto))
        expected_out = "{nprocs} pids, total = {total}".format(nprocs=nprocs, total=total)
        self.try_multiprocessing_code_with_branching(code, expected_out)

    def test_multiprocessing_bootstrap_error_handling(self):
        # An exception during bootstrapping will be reported.
        self.make_file("multi.py", """\
            import multiprocessing
            if __name__ == "__main__":
                with multiprocessing.Manager():
                    pass
            """)
        self.make_file(".coveragerc", """\
            [run]
            concurrency = multiprocessing
            _crash = _bootstrap
            """)
        out = self.run_command("coverage run multi.py")
        self.assertIn("Exception during multiprocessing bootstrap init", out)
        self.assertIn("Exception: Crashing because called by _bootstrap", out)

    def test_bug890(self):
        # chdir in multiprocessing shouldn't keep us from finding the
        # .coveragerc file.
        self.make_file("multi.py", """\
            import multiprocessing, os, os.path
            if __name__ == "__main__":
                if not os.path.exists("./tmp"): os.mkdir("./tmp")
                os.chdir("./tmp")
                with multiprocessing.Manager():
                    pass
                print("ok")
            """)
        self.make_file(".coveragerc", """\
            [run]
            concurrency = multiprocessing
            """)
        out = self.run_command("coverage run multi.py")
        self.assertEqual(out.splitlines()[-1], "ok")


def test_coverage_stop_in_threads():
    has_started_coverage = []
    has_stopped_coverage = []

    def run_thread():           # pragma: nested
        """Check that coverage is stopping properly in threads."""
        deadline = time.time() + 5
        ident = threading.currentThread().ident
        if sys.gettrace() is not None:
            has_started_coverage.append(ident)
        while sys.gettrace() is not None:
            # Wait for coverage to stop
            time.sleep(0.01)
            if time.time() > deadline:
                return
        has_stopped_coverage.append(ident)

    cov = coverage.Coverage()
    cov.start()

    t = threading.Thread(target=run_thread)             # pragma: nested
    t.start()                                           # pragma: nested

    time.sleep(0.1)                                     # pragma: nested
    cov.stop()                                          # pragma: nested
    t.join()

    assert has_started_coverage == [t.ident]
    assert has_stopped_coverage == [t.ident]


def test_thread_safe_save_data(tmpdir):
    # Non-regression test for:
    # https://bitbucket.org/ned/coveragepy/issues/581

    # Create some Python modules and put them in the path
    modules_dir = tmpdir.mkdir('test_modules')
    module_names = ["m{:03d}".format(i) for i in range(1000)]
    for module_name in module_names:
        modules_dir.join(module_name + ".py").write("def f(): pass\n")

    # Shared variables for threads
    should_run = [True]
    imported = []

    old_dir = os.getcwd()
    os.chdir(modules_dir.strpath)
    try:
        # Make sure that all dummy modules can be imported.
        for module_name in module_names:
            import_local_file(module_name)

        def random_load():                              # pragma: nested
            """Import modules randomly to stress coverage."""
            while should_run[0]:
                module_name = random.choice(module_names)
                mod = import_local_file(module_name)
                mod.f()
                imported.append(mod)

        # Spawn some threads with coverage enabled and attempt to read the
        # results right after stopping coverage collection with the threads
        #  still running.
        duration = 0.01
        for _ in range(3):
            cov = coverage.Coverage()
            cov.start()

            threads = [threading.Thread(target=random_load) for _ in range(10)]     # pragma: nested
            should_run[0] = True                    # pragma: nested
            for t in threads:                       # pragma: nested
                t.start()

            time.sleep(duration)                    # pragma: nested

            cov.stop()                              # pragma: nested

            # The following call used to crash with running background threads.
            cov.get_data()

            # Stop the threads
            should_run[0] = False
            for t in threads:
                t.join()

            if (not imported) and duration < 10:    # pragma: only failure
                duration *= 2

    finally:
        os.chdir(old_dir)
        should_run[0] = False
