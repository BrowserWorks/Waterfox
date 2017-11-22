// # SpawnTask.js
// Directly copied from the "co" library by TJ Holowaychuk.
// See https://github.com/tj/co/tree/4.6.0
// For use with mochitest-plain and mochitest-chrome.

// spawn_task(generatorFunction):
// Expose only the `co` function, which is very similar to Task.spawn in Task.jsm.
// We call this function spawn_task to make its purpose more plain, and to
// reduce the chance of name collisions.
var spawn_task = (function () {

/**
 * slice() reference.
 */

var slice = Array.prototype.slice;

/**
 * Wrap the given generator `fn` into a
 * function that returns a promise.
 * This is a separate function so that
 * every `co()` call doesn't create a new,
 * unnecessary closure.
 *
 * @param {GeneratorFunction} fn
 * @return {Function}
 * @api public
 */

co.wrap = function (fn) {
  createPromise.__generatorFunction__ = fn;
  return createPromise;
  function createPromise() {
    return co.call(this, fn.apply(this, arguments));
  }
};

/**
 * Execute the generator function or a generator
 * and return a promise.
 *
 * @param {Function} fn
 * @return {Promise}
 * @api public
 */

function co(gen) {
  var ctx = this;
  var args = slice.call(arguments, 1)

  // we wrap everything in a promise to avoid promise chaining,
  // which leads to memory leak errors.
  // see https://github.com/tj/co/issues/180
  return new Promise(function(resolve, reject) {
    if (typeof gen === 'function') gen = gen.apply(ctx, args);
    if (!gen || typeof gen.next !== 'function') return resolve(gen);

    onFulfilled();

    /**
     * @param {Mixed} res
     * @return {Promise}
     * @api private
     */

    function onFulfilled(res) {
      var ret;
      try {
        ret = gen.next(res);
      } catch (e) {
        return reject(e);
      }
      next(ret);
    }

    /**
     * @param {Error} err
     * @return {Promise}
     * @api private
     */

    function onRejected(err) {
      var ret;
      try {
        ret = gen.throw(err);
      } catch (e) {
        return reject(e);
      }
      next(ret);
    }

    /**
     * Get the next value in the generator,
     * return a promise.
     *
     * @param {Object} ret
     * @return {Promise}
     * @api private
     */

    function next(ret) {
      if (ret.done) return resolve(ret.value);
      var value = toPromise.call(ctx, ret.value);
      if (value && isPromise(value)) return value.then(onFulfilled, onRejected);
      return onRejected(new TypeError('You may only yield a function, promise, generator, array, or object, '
        + 'but the following object was passed: "' + String(ret.value) + '"'));
    }
  });
}

/**
 * Convert a `yield`ed value into a promise.
 *
 * @param {Mixed} obj
 * @return {Promise}
 * @api private
 */

function toPromise(obj) {
  if (!obj) return obj;
  if (isPromise(obj)) return obj;
  if (isGeneratorFunction(obj) || isGenerator(obj)) return co.call(this, obj);
  if ('function' == typeof obj) return thunkToPromise.call(this, obj);
  if (Array.isArray(obj)) return arrayToPromise.call(this, obj);
  if (isObject(obj)) return objectToPromise.call(this, obj);
  return obj;
}

/**
 * Convert a thunk to a promise.
 *
 * @param {Function}
 * @return {Promise}
 * @api private
 */

function thunkToPromise(fn) {
  var ctx = this;
  return new Promise(function (resolve, reject) {
    fn.call(ctx, function (err, res) {
      if (err) return reject(err);
      if (arguments.length > 2) res = slice.call(arguments, 1);
      resolve(res);
    });
  });
}

/**
 * Convert an array of "yieldables" to a promise.
 * Uses `Promise.all()` internally.
 *
 * @param {Array} obj
 * @return {Promise}
 * @api private
 */

function arrayToPromise(obj) {
  return Promise.all(obj.map(toPromise, this));
}

/**
 * Convert an object of "yieldables" to a promise.
 * Uses `Promise.all()` internally.
 *
 * @param {Object} obj
 * @return {Promise}
 * @api private
 */

function objectToPromise(obj){
  var results = new obj.constructor();
  var keys = Object.keys(obj);
  var promises = [];
  for (var i = 0; i < keys.length; i++) {
    var key = keys[i];
    var promise = toPromise.call(this, obj[key]);
    if (promise && isPromise(promise)) defer(promise, key);
    else results[key] = obj[key];
  }
  return Promise.all(promises).then(function () {
    return results;
  });

  function defer(promise, key) {
    // predefine the key in the result
    results[key] = undefined;
    promises.push(promise.then(function (res) {
      results[key] = res;
    }));
  }
}

/**
 * Check if `obj` is a promise.
 *
 * @param {Object} obj
 * @return {Boolean}
 * @api private
 */

function isPromise(obj) {
  return 'function' == typeof obj.then;
}

/**
 * Check if `obj` is a generator.
 *
 * @param {Mixed} obj
 * @return {Boolean}
 * @api private
 */

function isGenerator(obj) {
  return 'function' == typeof obj.next && 'function' == typeof obj.throw;
}

/**
 * Check if `obj` is a generator function.
 *
 * @param {Mixed} obj
 * @return {Boolean}
 * @api private
 */
function isGeneratorFunction(obj) {
  var constructor = obj.constructor;
  if (!constructor) return false;
  if ('GeneratorFunction' === constructor.name || 'GeneratorFunction' === constructor.displayName) return true;
  return isGenerator(constructor.prototype);
}

/**
 * Check for plain object.
 *
 * @param {Mixed} val
 * @return {Boolean}
 * @api private
 */

function isObject(val) {
  return Object == val.constructor;
}

return co;
})();

// add_task(generatorFunction):
// Call `add_task(generatorFunction)` for each separate
// asynchronous task in a mochitest. Tasks are run consecutively.
// Before the first task, `SimpleTest.waitForExplicitFinish()`
// will be called automatically, and after the last task,
// `SimpleTest.finish()` will be called.
var add_task = (function () {
  // The list of tasks to run.
  var task_list = [];
  var run_only_this_task = null;

  // The "add_task" function
  return function (generatorFunction) {
    if (task_list.length === 0) {
      // This is the first time add_task has been called.
      // First, confirm that SimpleTest is available.
      if (!SimpleTest) {
        throw new Error("SimpleTest not available.");
      }
      // Don't stop tests until asynchronous tasks are finished.
      SimpleTest.waitForExplicitFinish();
      // Because the client is using add_task for this set of tests,
      // we need to spawn a "master task" that calls each task in succesion.
      // Use setTimeout to ensure the master task runs after the client
      // script finishes.
      setTimeout(function () {
        spawn_task(function* () {
          // Allow for a task to be skipped; we need only use the structured logger
          // for this, whilst deactivating log buffering to ensure that messages
          // are always printed to stdout.
          function skipTask(name) {
            let logger = parentRunner && parentRunner.structuredLogger;
            if (!logger) {
              info("SpawnTask.js | Skipping test " + name);
              return;
            }
            logger.deactivateBuffering();
            logger.testStatus(SimpleTest._getCurrentTestURL(), name, "SKIP");
            logger.warning("SpawnTask.js | Skipping test " + name);
            logger.activateBuffering();
          }

          // We stop the entire test file at the first exception because this
          // may mean that the state of subsequent tests may be corrupt.
          try {
            for (var task of task_list) {
              var name = task.name || "";
              if (task.__skipMe || (run_only_this_task && task != run_only_this_task)) {
                skipTask(name);
                continue;
              }
              info("SpawnTask.js | Entering test " + name);
              yield task();
              info("SpawnTask.js | Leaving test " + name);
            }
          } catch (ex) {
            try {
              ok(false, "" + ex);
            } catch (ex2) {
              ok(false, "(The exception cannot be converted to string.)");
            }
          }
          // All tasks are finished.
          SimpleTest.finish();
        });
      });
    }
    generatorFunction.skip = () => generatorFunction.__skipMe = true;
    generatorFunction.only = () => run_only_this_task = generatorFunction;
    // Add the task to the list of tasks to run after
    // the main thread is finished.
    task_list.push(generatorFunction);
    return generatorFunction;
  };
})();
