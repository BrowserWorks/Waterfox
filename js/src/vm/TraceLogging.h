/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 * vim: set ts=8 sts=4 et sw=4 tw=99:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef TraceLogging_h
#define TraceLogging_h

#include "mozilla/GuardObjects.h"
#include "mozilla/LinkedList.h"

#include "jsalloc.h"

#include "js/HashTable.h"
#include "js/TypeDecls.h"
#include "js/Vector.h"
#include "threading/Thread.h"
#include "vm/MutexIDs.h"
#include "vm/TraceLoggingGraph.h"
#include "vm/TraceLoggingTypes.h"

struct JSRuntime;

namespace JS {
    class ReadOnlyCompileOptions;
} // namespace JS

namespace js {
class PerThreadData;

namespace jit {
    class CompileRuntime;
} // namespace jit

/*
 * Tracelogging overview.
 *
 * Tracelogging makes it possible to trace the occurrence of a single event
 * and/or the start and stop of an event. This is implemented with as low
 * overhead as possible to not interfere with running.
 *
 * Logging something is done in 3 stages.
 * 1) Get the tracelogger of the current thread.
 *     - TraceLoggerForMainThread(JSRuntime*)
 *     - TraceLoggerForCurrentThread(); // Should NOT be used for the mainthread.
 *
 * 2) Optionally create a TraceLoggerEvent for the text that needs to get logged. This
 *    step takes some time, so try to do this beforehand, outside the hot
 *    path and don't do unnecessary repetitions, since it will cripple
 *    performance.
 *     - TraceLoggerEvent event(logger, "foo");
 *
 *    There are also some predefined events. They are located in
 *    TraceLoggerTextId. They don't require to create an TraceLoggerEvent and
 *    can also be used as an argument to these functions.
 *
 * 3) Log the occurrence of a single event:
 *    - TraceLogTimestamp(logger, TraceLoggerTextId);
 *      Note: it is temporarily not supported to provide an TraceLoggerEvent as
 *            argument to log the occurrence of a single event.
 *
 *    or log the start and stop of an event:
 *    - TraceLogStartEvent(logger, TraceLoggerTextId);
 *    - TraceLogStartEvent(logger, TraceLoggerEvent);
 *    - TraceLogStopEvent(logger, TraceLoggerTextId);
 *    - TraceLogStopEvent(logger, TraceLoggerEvent);
 *
 *    or the start/stop of an event with a RAII class:
 *    - AutoTraceLog atl(logger, TraceLoggerTextId);
 *    - AutoTraceLog atl(logger, TraceLoggerEvent);
 */

class AutoTraceLog;
class TraceLoggerEventPayload;
class TraceLoggerThread;

/**
 * An event that can be used to report start/stop events to TraceLogger. It
 * prepares the given info by requesting a TraceLoggerEventPayload containing
 * the string to report and an unique id. It also increases the useCount of
 * this payload, so it cannot get removed.
 */
class TraceLoggerEvent {
  private:
    TraceLoggerEventPayload* payload_;

  public:
    TraceLoggerEvent() { payload_ = nullptr; };
#ifdef JS_TRACE_LOGGING
    TraceLoggerEvent(TraceLoggerThread* logger, TraceLoggerTextId textId);
    TraceLoggerEvent(TraceLoggerThread* logger, TraceLoggerTextId type, JSScript* script);
    TraceLoggerEvent(TraceLoggerThread* logger, TraceLoggerTextId type,
                     const JS::ReadOnlyCompileOptions& compileOptions);
    TraceLoggerEvent(TraceLoggerThread* logger, const char* text);
    TraceLoggerEvent(const TraceLoggerEvent& event);
    TraceLoggerEvent& operator=(const TraceLoggerEvent& other);
    ~TraceLoggerEvent();
#else
    TraceLoggerEvent (TraceLoggerThread* logger, TraceLoggerTextId textId) {}
    TraceLoggerEvent (TraceLoggerThread* logger, TraceLoggerTextId type, JSScript* script) {}
    TraceLoggerEvent (TraceLoggerThread* logger, TraceLoggerTextId type,
                      const JS::ReadOnlyCompileOptions& compileOptions) {}
    TraceLoggerEvent (TraceLoggerThread* logger, const char* text) {}
    TraceLoggerEvent(const TraceLoggerEvent& event) {}
    TraceLoggerEvent& operator=(const TraceLoggerEvent& other) {};
    ~TraceLoggerEvent() {}
#endif

    TraceLoggerEventPayload* payload() const {
        MOZ_ASSERT(hasPayload());
        return payload_;
    }
    bool hasPayload() const {
        return !!payload_;
    }
};

/**
 * An internal class holding the string information to report, together with an
 * unique id and a useCount. Whenever this useCount reaches 0, this event
 * cannot get started/stopped anymore. Consumers may still request the
 * string information.
 */
class TraceLoggerEventPayload {
    uint32_t textId_;
    UniqueChars string_;
    uint32_t uses_;

  public:
    TraceLoggerEventPayload(uint32_t textId, char* string)
      : textId_(textId),
        string_(string),
        uses_(0)
    { }

    ~TraceLoggerEventPayload() {
        MOZ_ASSERT(uses_ == 0);
    }

    uint32_t textId() {
        return textId_;
    }
    const char* string() {
        return string_.get();
    }
    uint32_t uses() {
        return uses_;
    }
    void use() {
        uses_++;
    }
    void release() {
        uses_--;
    }
};

class TraceLoggerThread
{
#ifdef JS_TRACE_LOGGING
  private:
    typedef HashMap<const void*,
                    TraceLoggerEventPayload*,
                    PointerHasher<const void*, 3>,
                    SystemAllocPolicy> PointerHashMap;
    typedef HashMap<uint32_t,
                    TraceLoggerEventPayload*,
                    DefaultHasher<uint32_t>,
                    SystemAllocPolicy> TextIdHashMap;

    uint32_t enabled_;
    bool failed;

    UniquePtr<TraceLoggerGraph> graph;

    PointerHashMap pointerMap;
    TextIdHashMap textIdPayloads;
    uint32_t nextTextId;

    ContinuousSpace<EventEntry> events;

    // Every time the events get flushed, this count is increased by one.
    // Together with events.lastEntryId(), this gives an unique id for every
    // event.
    uint32_t iteration_;

#ifdef DEBUG
    typedef Vector<uint32_t, 1, js::SystemAllocPolicy > GraphStack;
    GraphStack graphStack;
#endif

  public:
    AutoTraceLog* top;

    TraceLoggerThread()
      : enabled_(0),
        failed(false),
        graph(),
        nextTextId(TraceLogger_Last),
        iteration_(0),
        top(nullptr)
    { }

    bool init();
    ~TraceLoggerThread();

    bool init(uint32_t loggerId);
    void initGraph();

    bool enable();
    bool enable(JSContext* cx);
    bool disable(bool force = false, const char* = "");
    bool enabled() { return enabled_ > 0; }

  private:
    bool fail(JSContext* cx, const char* error);

  public:
    // Given the previous iteration and size, return an array of events
    // (there could be lost events). At the same time update the iteration and
    // size and gives back how many events there are.
    EventEntry* getEventsStartingAt(uint32_t* lastIteration, uint32_t* lastSize, size_t* num) {
        EventEntry* start;
        if (iteration_ == *lastIteration) {
            MOZ_ASSERT(*lastSize <= events.size());
            *num = events.size() - *lastSize;
            start = events.data() + *lastSize;
        } else {
            *num = events.size();
            start = events.data();
        }

        getIterationAndSize(lastIteration, lastSize);
        return start;
    }

    void getIterationAndSize(uint32_t* iteration, uint32_t* size) const {
        *iteration = iteration_;
        *size = events.size();
    }

    // Extract the details filename, lineNumber and columnNumber out of a event
    // containing script information.
    void extractScriptDetails(uint32_t textId, const char** filename, size_t* filename_len,
                              const char** lineno, size_t* lineno_len, const char** colno,
                              size_t* colno_len);

    bool lostEvents(uint32_t lastIteration, uint32_t lastSize) {
        // If still logging in the same iteration, there are no lost events.
        if (lastIteration == iteration_) {
            MOZ_ASSERT(lastSize <= events.size());
            return false;
        }

        // If we are in the next consecutive iteration we are only sure we
        // didn't lose any events when the lastSize equals the maximum size
        // 'events' can get.
        if (lastIteration == iteration_ - 1 && lastSize == events.maxSize())
            return false;

        return true;
    }

    const char* eventText(uint32_t id);
    bool textIdIsScriptEvent(uint32_t id);

    // The createTextId functions map a unique input to a logger ID.
    // This can be used to give start and stop events. Calls to these functions should be
    // limited if possible, because of the overhead.
    // Note: it is not allowed to use them in logTimestamp.
    TraceLoggerEventPayload* getOrCreateEventPayload(TraceLoggerTextId textId);
    TraceLoggerEventPayload* getOrCreateEventPayload(const char* text);
    TraceLoggerEventPayload* getOrCreateEventPayload(TraceLoggerTextId type, JSScript* script);
    TraceLoggerEventPayload* getOrCreateEventPayload(TraceLoggerTextId type,
                                                     const JS::ReadOnlyCompileOptions& script);
  private:
    TraceLoggerEventPayload* getOrCreateEventPayload(TraceLoggerTextId type, const char* filename,
                                                     size_t lineno, size_t colno, const void* p);

  public:
    // Log an event (no start/stop, only the timestamp is recorded).
    void logTimestamp(TraceLoggerTextId id);

    // Record timestamps for start and stop of an event.
    void startEvent(TraceLoggerTextId id);
    void startEvent(const TraceLoggerEvent& event);
    void stopEvent(TraceLoggerTextId id);
    void stopEvent(const TraceLoggerEvent& event);

    // These functions are actually private and shouldn't be used in normal
    // code. They are made public so they can be used in assembly.
    void logTimestamp(uint32_t id);
    void startEvent(uint32_t id);
    void stopEvent(uint32_t id);
  private:
    void stopEvent();
    void log(uint32_t id);

  public:
    static unsigned offsetOfEnabled() {
        return offsetof(TraceLoggerThread, enabled_);
    }
#endif
};

#ifdef JS_TRACE_LOGGING
class TraceLoggerMainThread
  : public TraceLoggerThread,
    public mozilla::LinkedListElement<TraceLoggerMainThread>
{

};
#endif

class TraceLoggerThreadState
{
#ifdef JS_TRACE_LOGGING
    typedef HashMap<Thread::Id,
                    TraceLoggerThread*,
                    Thread::Hasher,
                    SystemAllocPolicy> ThreadLoggerHashMap;

#ifdef DEBUG
    bool initialized;
#endif

    bool enabledTextIds[TraceLogger_Last];
    bool mainThreadEnabled;
    bool offThreadEnabled;
    bool graphSpewingEnabled;
    bool spewErrors;
    ThreadLoggerHashMap threadLoggers;
    mozilla::LinkedList<TraceLoggerMainThread> traceLoggerMainThreadList;

  public:
    uint64_t startupTime;
    Mutex lock;

    TraceLoggerThreadState()
      :
#ifdef DEBUG
        initialized(false),
#endif
        mainThreadEnabled(false),
        offThreadEnabled(false),
        graphSpewingEnabled(false),
        spewErrors(false),
        lock(js::mutexid::TraceLoggerThreadState)
    { }

    bool init();
    ~TraceLoggerThreadState();

    TraceLoggerThread* forMainThread(JSRuntime* runtime);
    TraceLoggerThread* forMainThread(jit::CompileRuntime* runtime);
    TraceLoggerThread* forThread(const Thread::Id& thread);
    void destroyMainThread(JSRuntime* runtime);

    bool isTextIdEnabled(uint32_t textId) {
        if (textId < TraceLogger_Last)
            return enabledTextIds[textId];
        return true;
    }
    void enableTextId(JSContext* cx, uint32_t textId);
    void disableTextId(JSContext* cx, uint32_t textId);
    void maybeSpewError(const char* text) {
        if (spewErrors)
            fprintf(stderr, "%s\n", text);
    }

  private:
    TraceLoggerThread* forMainThread(PerThreadData* mainThread);
#endif
};

#ifdef JS_TRACE_LOGGING
void DestroyTraceLoggerThreadState();
void DestroyTraceLoggerMainThread(JSRuntime* runtime);

TraceLoggerThread* TraceLoggerForMainThread(JSRuntime* runtime);
TraceLoggerThread* TraceLoggerForMainThread(jit::CompileRuntime* runtime);
TraceLoggerThread* TraceLoggerForCurrentThread();
#else
inline TraceLoggerThread* TraceLoggerForMainThread(JSRuntime* runtime) {
    return nullptr;
};
inline TraceLoggerThread* TraceLoggerForMainThread(jit::CompileRuntime* runtime) {
    return nullptr;
};
inline TraceLoggerThread* TraceLoggerForCurrentThread() {
    return nullptr;
};
#endif

inline bool TraceLoggerEnable(TraceLoggerThread* logger) {
#ifdef JS_TRACE_LOGGING
    if (logger)
        return logger->enable();
#endif
    return false;
}
inline bool TraceLoggerEnable(TraceLoggerThread* logger, JSContext* cx) {
#ifdef JS_TRACE_LOGGING
    if (logger)
        return logger->enable(cx);
#endif
    return false;
}
inline bool TraceLoggerDisable(TraceLoggerThread* logger) {
#ifdef JS_TRACE_LOGGING
    if (logger)
        return logger->disable();
#endif
    return false;
}

#ifdef JS_TRACE_LOGGING
bool TraceLogTextIdEnabled(uint32_t textId);
void TraceLogEnableTextId(JSContext* cx, uint32_t textId);
void TraceLogDisableTextId(JSContext* cx, uint32_t textId);
#else
inline bool TraceLogTextIdEnabled(uint32_t textId) {
    return false;
}
inline void TraceLogEnableTextId(JSContext* cx, uint32_t textId) {}
inline void TraceLogDisableTextId(JSContext* cx, uint32_t textId) {}
#endif
inline void TraceLogTimestamp(TraceLoggerThread* logger, TraceLoggerTextId textId) {
#ifdef JS_TRACE_LOGGING
    if (logger)
        logger->logTimestamp(textId);
#endif
}
inline void TraceLogStartEvent(TraceLoggerThread* logger, TraceLoggerTextId textId) {
#ifdef JS_TRACE_LOGGING
    if (logger)
        logger->startEvent(textId);
#endif
}
inline void TraceLogStartEvent(TraceLoggerThread* logger, const TraceLoggerEvent& event) {
#ifdef JS_TRACE_LOGGING
    if (logger)
        logger->startEvent(event);
#endif
}
inline void TraceLogStopEvent(TraceLoggerThread* logger, TraceLoggerTextId textId) {
#ifdef JS_TRACE_LOGGING
    if (logger)
        logger->stopEvent(textId);
#endif
}
inline void TraceLogStopEvent(TraceLoggerThread* logger, const TraceLoggerEvent& event) {
#ifdef JS_TRACE_LOGGING
    if (logger)
        logger->stopEvent(event);
#endif
}

// Helper functions for assembly. May not be used otherwise.
inline void TraceLogTimestampPrivate(TraceLoggerThread* logger, uint32_t id) {
#ifdef JS_TRACE_LOGGING
    if (logger)
        logger->logTimestamp(id);
#endif
}
inline void TraceLogStartEventPrivate(TraceLoggerThread* logger, uint32_t id) {
#ifdef JS_TRACE_LOGGING
    if (logger)
        logger->startEvent(id);
#endif
}
inline void TraceLogStopEventPrivate(TraceLoggerThread* logger, uint32_t id) {
#ifdef JS_TRACE_LOGGING
    if (logger)
        logger->stopEvent(id);
#endif
}

// Automatic logging at the start and end of function call.
class MOZ_RAII AutoTraceLog
{
#ifdef JS_TRACE_LOGGING
    TraceLoggerThread* logger;
    union {
        const TraceLoggerEvent* event;
        TraceLoggerTextId id;
    } payload;
    bool isEvent;
    bool executed;
    AutoTraceLog* prev;

  public:
    AutoTraceLog(TraceLoggerThread* logger,
                 const TraceLoggerEvent& event MOZ_GUARD_OBJECT_NOTIFIER_PARAM)
      : logger(logger),
        isEvent(true),
        executed(false)
    {
        MOZ_GUARD_OBJECT_NOTIFIER_INIT;
        payload.event = &event;
        if (logger) {
            logger->startEvent(event);

            prev = logger->top;
            logger->top = this;
        }
    }

    AutoTraceLog(TraceLoggerThread* logger, TraceLoggerTextId id MOZ_GUARD_OBJECT_NOTIFIER_PARAM)
      : logger(logger),
        isEvent(false),
        executed(false)
    {
        MOZ_GUARD_OBJECT_NOTIFIER_INIT;
        payload.id = id;
        if (logger) {
            logger->startEvent(id);

            prev = logger->top;
            logger->top = this;
        }
    }

    ~AutoTraceLog()
    {
        if (logger) {
            while (this != logger->top)
                logger->top->stop();
            stop();
        }
    }
  private:
    void stop() {
        if (!executed) {
            executed = true;
            if (isEvent)
                logger->stopEvent(*payload.event);
            else
                logger->stopEvent(payload.id);
        }

        if (logger->top == this)
            logger->top = prev;
    }
#else
  public:
    AutoTraceLog(TraceLoggerThread* logger, uint32_t textId MOZ_GUARD_OBJECT_NOTIFIER_PARAM)
    {
        MOZ_GUARD_OBJECT_NOTIFIER_INIT;
    }
    AutoTraceLog(TraceLoggerThread* logger,
                 const TraceLoggerEvent& event MOZ_GUARD_OBJECT_NOTIFIER_PARAM)
    {
        MOZ_GUARD_OBJECT_NOTIFIER_INIT;
    }
#endif

  private:
    MOZ_DECL_USE_GUARD_OBJECT_NOTIFIER
};

} // namespace js

#endif /* TraceLogging_h */
