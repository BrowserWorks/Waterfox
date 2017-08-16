:mod:`concurrent.futures` --- Asynchronous computation
======================================================

.. module:: concurrent.futures
   :synopsis: Execute computations asynchronously using threads or processes. 

The :mod:`concurrent.futures` module provides a high-level interface for
asynchronously executing callables.

The asynchronous execution can be be performed by threads using
:class:`ThreadPoolExecutor` or seperate processes using
:class:`ProcessPoolExecutor`. Both implement the same interface, which is
defined by the abstract :class:`Executor` class.

Executor Objects
----------------

:class:`Executor` is an abstract class that provides methods to execute calls
asynchronously. It should not be used directly, but through its two
subclasses: :class:`ThreadPoolExecutor` and :class:`ProcessPoolExecutor`.

.. method:: Executor.submit(fn, *args, **kwargs)

   Schedules the callable to be executed as *fn*(*\*args*, *\*\*kwargs*) and
   returns a :class:`Future` representing the execution of the callable.

::

    with ThreadPoolExecutor(max_workers=1) as executor:
        future = executor.submit(pow, 323, 1235)
        print(future.result())

.. method:: Executor.map(func, *iterables, timeout=None)

   Equivalent to map(*func*, *\*iterables*) but func is executed asynchronously
   and several calls to *func* may be made concurrently. The returned iterator
   raises a :exc:`TimeoutError` if :meth:`__next__()` is called and the result
   isn't available after *timeout* seconds from the original call to
   :meth:`map()`. *timeout* can be an int or float. If *timeout* is not
   specified or ``None`` then there is no limit to the wait time. If a call
   raises an exception then that exception will be raised when its value is
   retrieved from the iterator.

.. method:: Executor.shutdown(wait=True)

   Signal the executor that it should free any resources that it is using when
   the currently pending futures are done executing. Calls to
   :meth:`Executor.submit` and :meth:`Executor.map` made after shutdown will
   raise :exc:`RuntimeError`.

   If *wait* is `True` then this method will not return until all the pending
   futures are done executing and the resources associated with the executor
   have been freed. If *wait* is `False` then this method will return
   immediately and the resources associated with the executor will be freed
   when all pending futures are done executing. Regardless of the value of
   *wait*, the entire Python program will not exit until all pending futures
   are done executing.

   You can avoid having to call this method explicitly if you use the `with`
   statement, which will shutdown the `Executor` (waiting as if
   `Executor.shutdown` were called with *wait* set to `True`):

::

    import shutil
    with ThreadPoolExecutor(max_workers=4) as e:
        e.submit(shutil.copy, 'src1.txt', 'dest1.txt')
        e.submit(shutil.copy, 'src2.txt', 'dest2.txt')
        e.submit(shutil.copy, 'src3.txt', 'dest3.txt')
        e.submit(shutil.copy, 'src3.txt', 'dest4.txt')


ThreadPoolExecutor Objects
--------------------------

The :class:`ThreadPoolExecutor` class is an :class:`Executor` subclass that uses
a pool of threads to execute calls asynchronously.

Deadlock can occur when the callable associated with a :class:`Future` waits on
the results of another :class:`Future`. For example:

::

    import time
    def wait_on_b():
        time.sleep(5)
        print(b.result())  # b will never complete because it is waiting on a.
        return 5

    def wait_on_a():
        time.sleep(5)
        print(a.result())  # a will never complete because it is waiting on b.
        return 6


    executor = ThreadPoolExecutor(max_workers=2)
    a = executor.submit(wait_on_b)
    b = executor.submit(wait_on_a)

And:

::

    def wait_on_future():
        f = executor.submit(pow, 5, 2)
        # This will never complete because there is only one worker thread and
        # it is executing this function.
        print(f.result())
    
    executor = ThreadPoolExecutor(max_workers=1)
    executor.submit(wait_on_future)

.. class:: ThreadPoolExecutor(max_workers)

   Executes calls asynchronously using a pool of at most *max_workers* threads.

.. _threadpoolexecutor-example:

ThreadPoolExecutor Example
^^^^^^^^^^^^^^^^^^^^^^^^^^
::

    from concurrent import futures
    import urllib.request
    
    URLS = ['http://www.foxnews.com/',
            'http://www.cnn.com/',
            'http://europe.wsj.com/',
            'http://www.bbc.co.uk/',
            'http://some-made-up-domain.com/']
    
    def load_url(url, timeout):
        return urllib.request.urlopen(url, timeout=timeout).read()
    
    with futures.ThreadPoolExecutor(max_workers=5) as executor:
        future_to_url = dict((executor.submit(load_url, url, 60), url)
                             for url in URLS)
    
        for future in futures.as_completed(future_to_url):
            url = future_to_url[future]
            if future.exception() is not None:
                print('%r generated an exception: %s' % (url,
                                                         future.exception()))
            else:
                print('%r page is %d bytes' % (url, len(future.result())))

ProcessPoolExecutor Objects
---------------------------

The :class:`ProcessPoolExecutor` class is an :class:`Executor` subclass that
uses a pool of processes to execute calls asynchronously.
:class:`ProcessPoolExecutor` uses the :mod:`multiprocessing` module, which
allows it to side-step the :term:`Global Interpreter Lock` but also means that
only picklable objects can be executed and returned.

Calling :class:`Executor` or :class:`Future` methods from a callable submitted
to a :class:`ProcessPoolExecutor` will result in deadlock.

.. class:: ProcessPoolExecutor(max_workers=None)

   Executes calls asynchronously using a pool of at most *max_workers*
   processes. If *max_workers* is ``None`` or not given then as many worker
   processes will be created as the machine has processors.

.. _processpoolexecutor-example:

ProcessPoolExecutor Example
^^^^^^^^^^^^^^^^^^^^^^^^^^^
::

   import math

   PRIMES = [
       112272535095293,
       112582705942171,
       112272535095293,
       115280095190773,
       115797848077099,
       1099726899285419]

   def is_prime(n):
       if n % 2 == 0:
           return False

       sqrt_n = int(math.floor(math.sqrt(n)))
       for i in range(3, sqrt_n + 1, 2):
           if n % i == 0:
               return False
       return True

   def main():
       with futures.ProcessPoolExecutor() as executor:
           for number, prime in zip(PRIMES, executor.map(is_prime, PRIMES)):
               print('%d is prime: %s' % (number, prime))

   if __name__ == '__main__':
       main()

Future Objects
--------------

The :class:`Future` class encapulates the asynchronous execution of a callable.
:class:`Future` instances are created by :meth:`Executor.submit`.

.. method:: Future.cancel()

   Attempt to cancel the call. If the call is currently being executed then
   it cannot be cancelled and the method will return `False`, otherwise the call
   will be cancelled and the method will return `True`.

.. method:: Future.cancelled()

   Return `True` if the call was successfully cancelled.

.. method:: Future.running()

   Return `True` if the call is currently being executed and cannot be
   cancelled.

.. method:: Future.done()

   Return `True` if the call was successfully cancelled or finished running.

.. method:: Future.result(timeout=None)

   Return the value returned by the call. If the call hasn't yet completed then
   this method will wait up to *timeout* seconds. If the call hasn't completed
   in *timeout* seconds then a :exc:`TimeoutError` will be raised. *timeout* can
   be an int or float.If *timeout* is not specified or ``None`` then there is no
   limit to the wait time.

   If the future is cancelled before completing then :exc:`CancelledError` will
   be raised.

   If the call raised then this method will raise the same exception.

.. method:: Future.exception(timeout=None)

   Return the exception raised by the call. If the call hasn't yet completed
   then this method will wait up to *timeout* seconds. If the call hasn't
   completed in *timeout* seconds then a :exc:`TimeoutError` will be raised.
   *timeout* can be an int or float. If *timeout* is not specified or ``None``
   then there is no limit to the wait time.

   If the future is cancelled before completing then :exc:`CancelledError` will
   be raised.

   If the call completed without raising then ``None`` is returned.   

.. method:: Future.add_done_callback(fn)

   Attaches the callable *fn* to the future. *fn* will be called, with the
   future as its only argument, when the future is cancelled or finishes
   running.

   Added callables are called in the order that they were added and are always
   called in a thread belonging to the process that added them. If the callable
   raises an :exc:`Exception` then it will be logged and ignored. If the
   callable raises another :exc:`BaseException` then the behavior is not
   defined.

   If the future has already completed or been cancelled then *fn* will be
   called immediately.

Internal Future Methods
^^^^^^^^^^^^^^^^^^^^^^^

The following :class:`Future` methods are meant for use in unit tests and
:class:`Executor` implementations.

.. method:: Future.set_running_or_notify_cancel()

   This method should only be called by :class:`Executor` implementations before
   executing the work associated with the :class:`Future` and by unit tests.

   If the method returns `False` then the :class:`Future` was cancelled i.e.
   :meth:`Future.cancel` was called and returned `True`. Any threads waiting
   on the :class:`Future` completing (i.e. through :func:`as_completed` or
   :func:`wait`) will be woken up.

   If the method returns `True` then the :class:`Future` was not cancelled
   and has been put in the running state i.e. calls to
   :meth:`Future.running` will return `True`.

   This method can only be called once and cannot be called after
   :meth:`Future.set_result` or :meth:`Future.set_exception` have been
   called.

.. method:: Future.set_result(result)

   Sets the result of the work associated with the :class:`Future` to *result*.

   This method should only be used by Executor implementations and unit tests.

.. method:: Future.set_exception(exception)

   Sets the result of the work associated with the :class:`Future` to the
   :class:`Exception` *exception*.

   This method should only be used by Executor implementations and unit tests.

Module Functions
----------------

.. function:: wait(fs, timeout=None, return_when=ALL_COMPLETED)

   Wait for the :class:`Future` instances (possibly created by different
   :class:`Executor` instances) given by *fs*  to complete. Returns a named
   2-tuple of sets. The first set, named "done", contains the futures that
   completed (finished or were cancelled) before the wait completed. The second
   set, named "not_done", contains uncompleted futures.

   *timeout* can be used to control the maximum number of seconds to wait before
   returning. *timeout* can be an int or float. If *timeout* is not specified or
   ``None`` then there is no limit to the wait time.

   *return_when* indicates when this function should return. It must be one of
   the following constants:

      +-----------------------------+----------------------------------------+
      | Constant                    | Description                            |
      +=============================+========================================+
      | :const:`FIRST_COMPLETED`    | The function will return when any      |
      |                             | future finishes or is cancelled.       |
      +-----------------------------+----------------------------------------+
      | :const:`FIRST_EXCEPTION`    | The function will return when any      |
      |                             | future finishes by raising an          |
      |                             | exception. If no future raises an      |
      |                             | exception then it is equivalent to     |
      |                             | `ALL_COMPLETED`.                       |
      +-----------------------------+----------------------------------------+
      | :const:`ALL_COMPLETED`      | The function will return when all      |
      |                             | futures finish or are cancelled.       |
      +-----------------------------+----------------------------------------+

.. function:: as_completed(fs, timeout=None)

   Returns an iterator over the :class:`Future` instances (possibly created by
   different :class:`Executor` instances) given by *fs* that yields futures as
   they complete (finished or were cancelled). Any futures given by *fs* that
   are duplicated will be returned once. Any futures that completed
   before :func:`as_completed` is called will be yielded first.  The returned
   iterator raises a :exc:`TimeoutError` if :meth:`~iterator.__next__` is
   called and the result isn't available after *timeout* seconds from the
   original call to :func:`as_completed`.  *timeout* can be an int or float.
   If *timeout* is not specified or ``None``, there is no limit to the wait
   time.
