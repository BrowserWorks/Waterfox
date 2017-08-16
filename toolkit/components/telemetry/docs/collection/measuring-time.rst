======================
Measuring elapsed time
======================

To make it easier to measure how long operations take, we have helpers for both JavaScript and C++.
These helpers record the elapsed time into histograms, so you have to create suitable histograms for them first.

From JavaScript
===============
JavaScript can measure elapsed time using `TelemetryStopwatch.jsm <https://dxr.mozilla.org/mozilla-central/source/toolkit/components/telemetry/TelemetryStopwatch.jsm>`_.

``TelemetryStopwatch`` is a helper that simplifies recording elapsed time (in milliseconds) into histograms (plain or keyed).

API:

.. code-block:: js

    TelemetryStopwatch = {
      // Start, check if running, cancel & finish recording elapsed time into a
      // histogram.
      // |aObject| is optional. If specificied, the timer is associated with this
      // object, so multiple time measurements can be done concurrently.
      start(histogramId, aObject);
      running(histogramId, aObject);
      cancel(histogramId, aObject);
      finish(histogramId, aObject);
      // Start, check if running, cancel & finish recording elapsed time into a
      // keyed histogram.
      // |key| specificies the key to record into.
      // |aObject| is optional and used as above.
      startKeyed(histogramId, key, aObject);
      runningKeyed(histogramId, key, aObject);
      cancelKeyed(histogramId, key, aObject);
      finishKeyed(histogramId, key, aObject);
    };

Example:

.. code-block:: js

    TelemetryStopwatch.start("SAMPLE_FILE_LOAD_TIME_MS");
    // ... start loading file.
    if (failedToOpenFile) {
      // Cancel this if the operation failed early etc.
      TelemetryStopwatch.cancel("SAMPLE_FILE_LOAD_TIME_MS");
      return;
    }
    // ... do more work.
    TelemetryStopwatch.finish("SAMPLE_FILE_LOAD_TIME_MS");

    // Another loading attempt? Start stopwatch again if
    // not already running.
    if (!TelemetryStopwatch.running("SAMPLE_FILE_LOAD_TIME_MS")) {
      TelemetryStopwatch.start("SAMPLE_FILE_LOAD_TIME_MS");
    }

    // Periodically, it's necessary to attempt to finish a
    // TelemetryStopwatch that's already been canceled or
    // finished. Normally, that throws a warning to the
    // console. If the TelemetryStopwatch being possibly
    // cancelled or finished is expected behaviour, the
    // warning can be suppressed by passing the optional
    // aCanceledOkay argument.

    // ... suppress warning on a previously finished
    // TelemetryStopwatch
    TelemetryStopwatch.finish("SAMPLE_FILE_LOAD_TIME_MS", null,
                              true /* aCanceledOkay */);

From C++
========

API:

.. code-block:: cpp

    // This helper class is the preferred way to record elapsed time.
    template<ID id, TimerResolution res = MilliSecond>
    class AutoTimer {
      // Record into a plain histogram.
      explicit AutoTimer(TimeStamp aStart = TimeStamp::Now());
      // Record into a keyed histogram, with key |aKey|.
      explicit AutoTimer(const nsCString& aKey,
                         TimeStamp aStart = TimeStamp::Now());
    };

    void AccumulateTimeDelta(ID id, TimeStamp start, TimeStamp end = TimeStamp::Now());

Example:

.. code-block:: cpp

    {
      Telemetry::AutoTimer<Telemetry::FIND_PLUGINS> telemetry;
      // ... scan disk for plugins.
    }
    // When leaving the scope, AutoTimers destructor will record the time that passed.
