/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include <prtime.h>
#include <limits>
#include "nsITelemetry.h"
#include "nsHashKeys.h"
#include "nsDataHashtable.h"
#include "nsClassHashtable.h"
#include "nsTArray.h"
#include "mozilla/StaticMutex.h"
#include "mozilla/Unused.h"
#include "mozilla/Maybe.h"
#include "mozilla/StaticPtr.h"
#include "mozilla/Pair.h"
#include "jsapi.h"
#include "nsJSUtils.h"
#include "nsXULAppAPI.h"
#include "nsUTF8Utils.h"
#include "nsPrintfCString.h"

#include "TelemetryCommon.h"
#include "TelemetryEvent.h"
#include "TelemetryEventData.h"
#include "ipc/TelemetryIPCAccumulator.h"

using mozilla::StaticMutex;
using mozilla::StaticMutexAutoLock;
using mozilla::ArrayLength;
using mozilla::Maybe;
using mozilla::Nothing;
using mozilla::StaticAutoPtr;
using mozilla::TimeStamp;
using mozilla::Telemetry::Common::AutoHashtable;
using mozilla::Telemetry::Common::IsExpiredVersion;
using mozilla::Telemetry::Common::CanRecordDataset;
using mozilla::Telemetry::Common::IsInDataset;
using mozilla::Telemetry::Common::MsSinceProcessStart;
using mozilla::Telemetry::Common::LogToBrowserConsole;
using mozilla::Telemetry::Common::CanRecordInProcess;
using mozilla::Telemetry::Common::GetNameForProcessID;
using mozilla::Telemetry::EventExtraEntry;
using mozilla::Telemetry::ChildEventData;
using mozilla::Telemetry::ProcessID;

namespace TelemetryIPCAccumulator = mozilla::TelemetryIPCAccumulator;

////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
//
// Naming: there are two kinds of functions in this file:
//
// * Functions taking a StaticMutexAutoLock: these can only be reached via
//   an interface function (TelemetryEvent::*). They expect the interface
//   function to have acquired |gTelemetryEventsMutex|, so they do not
//   have to be thread-safe.
//
// * Functions named TelemetryEvent::*. This is the external interface.
//   Entries and exits to these functions are serialised using
//   |gTelemetryEventsMutex|.
//
// Avoiding races and deadlocks:
//
// All functions in the external interface (TelemetryEvent::*) are
// serialised using the mutex |gTelemetryEventsMutex|. This means
// that the external interface is thread-safe, and the internal
// functions can ignore thread safety. But it also brings a danger
// of deadlock if any function in the external interface can get back
// to that interface. That is, we will deadlock on any call chain like
// this:
//
// TelemetryEvent::* -> .. any functions .. -> TelemetryEvent::*
//
// To reduce the danger of that happening, observe the following rules:
//
// * No function in TelemetryEvent::* may directly call, nor take the
//   address of, any other function in TelemetryEvent::*.
//
// * No internal function may call, nor take the address
//   of, any function in TelemetryEvent::*.

////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
//
// PRIVATE TYPES

namespace {

const uint32_t kEventCount = mozilla::Telemetry::EventID::EventCount;
// This is a special event id used to mark expired events, to make expiry checks
// cheap at runtime.
const uint32_t kExpiredEventId = std::numeric_limits<uint32_t>::max();
static_assert(kExpiredEventId > kEventCount,
              "Built-in event count should be less than the expired event id.");

// This is the hard upper limit on the number of event records we keep in storage.
// If we cross this limit, we will drop any further event recording until elements
// are removed from storage.
const uint32_t kMaxEventRecords = 1000;
// Maximum length of any passed value string, in UTF8 byte sequence length.
const uint32_t kMaxValueByteLength = 80;
// Maximum length of any string value in the extra dictionary, in UTF8 byte sequence length.
const uint32_t kMaxExtraValueByteLength = 80;
// Maximum length of dynamic method names, in UTF8 byte sequence length.
const uint32_t kMaxMethodNameByteLength = 20;
// Maximum length of dynamic object names, in UTF8 byte sequence length.
const uint32_t kMaxObjectNameByteLength = 20;
// Maximum length of extra key names, in UTF8 byte sequence length.
const uint32_t kMaxExtraKeyNameByteLength = 15;
// The maximum number of valid extra keys for an event.
const uint32_t kMaxExtraKeyCount = 10;

typedef nsDataHashtable<nsCStringHashKey, uint32_t> StringUintMap;
typedef nsClassHashtable<nsCStringHashKey, nsCString> StringMap;

struct EventKey {
  uint32_t id;
  bool dynamic;
};

struct DynamicEventInfo {
  DynamicEventInfo(const nsACString& category, const nsACString& method,
                   const nsACString& object, const nsTArray<nsCString>& extra_keys,
                   bool recordOnRelease)
    : category(category)
    , method(method)
    , object(object)
    , extra_keys(extra_keys)
    , recordOnRelease(recordOnRelease)
  {}

  DynamicEventInfo(const DynamicEventInfo&) = default;
  DynamicEventInfo& operator=(const DynamicEventInfo&) = delete;

  const nsCString category;
  const nsCString method;
  const nsCString object;
  const nsTArray<nsCString> extra_keys;
  const bool recordOnRelease;

  size_t
  SizeOfExcludingThis(mozilla::MallocSizeOf aMallocSizeOf) const
  {
    size_t n = 0;

    n += category.SizeOfExcludingThisIfUnshared(aMallocSizeOf);
    n += method.SizeOfExcludingThisIfUnshared(aMallocSizeOf);
    n += object.SizeOfExcludingThisIfUnshared(aMallocSizeOf);
    n += extra_keys.ShallowSizeOfExcludingThis(aMallocSizeOf);
    for (auto& key : extra_keys) {
      n += key.SizeOfExcludingThisIfUnshared(aMallocSizeOf);
    }

    return n;
  }
};

enum class RecordEventResult {
  Ok,
  UnknownEvent,
  InvalidExtraKey,
  StorageLimitReached,
  ExpiredEvent,
  WrongProcess,
};

enum class RegisterEventResult {
  Ok,
  AlreadyRegistered,
};

typedef nsTArray<EventExtraEntry> ExtraArray;

class EventRecord {
public:
  EventRecord(double timestamp, const EventKey& key, const Maybe<nsCString>& value,
              const ExtraArray& extra)
    : mTimestamp(timestamp)
    , mEventKey(key)
    , mValue(value)
    , mExtra(extra)
  {}

  EventRecord(const EventRecord& other) = default;

  EventRecord& operator=(const EventRecord& other) = delete;

  double Timestamp() const { return mTimestamp; }
  const EventKey& GetEventKey() const { return mEventKey; }
  const Maybe<nsCString>& Value() const { return mValue; }
  const ExtraArray& Extra() const { return mExtra; }

  size_t SizeOfExcludingThis(mozilla::MallocSizeOf aMallocSizeOf) const;

private:
  const double mTimestamp;
  const EventKey mEventKey;
  const Maybe<nsCString> mValue;
  const ExtraArray mExtra;
};

// Implements the methods for EventInfo.
const nsCString
EventInfo::method() const
{
  return nsCString(&gEventsStringTable[this->method_offset]);
}

const nsCString
EventInfo::object() const
{
  return nsCString(&gEventsStringTable[this->object_offset]);
}

// Implements the methods for CommonEventInfo.
const nsCString
CommonEventInfo::category() const
{
  return nsCString(&gEventsStringTable[this->category_offset]);
}

const nsCString
CommonEventInfo::expiration_version() const
{
  return nsCString(&gEventsStringTable[this->expiration_version_offset]);
}

const nsCString
CommonEventInfo::extra_key(uint32_t index) const
{
  MOZ_ASSERT(index < this->extra_count);
  uint32_t key_index = gExtraKeysTable[this->extra_index + index];
  return nsCString(&gEventsStringTable[key_index]);
}

// Implementation for the EventRecord class.
size_t
EventRecord::SizeOfExcludingThis(mozilla::MallocSizeOf aMallocSizeOf) const
{
  size_t n = 0;

  if (mValue) {
    n += mValue.value().SizeOfExcludingThisIfUnshared(aMallocSizeOf);
  }

  n += mExtra.ShallowSizeOfExcludingThis(aMallocSizeOf);
  for (uint32_t i = 0; i < mExtra.Length(); ++i) {
    n += mExtra[i].key.SizeOfExcludingThisIfUnshared(aMallocSizeOf);
    n += mExtra[i].value.SizeOfExcludingThisIfUnshared(aMallocSizeOf);
  }

  return n;
}

nsCString
UniqueEventName(const nsACString& category, const nsACString& method, const nsACString& object)
{
  nsCString name;
  name.Append(category);
  name.AppendLiteral("#");
  name.Append(method);
  name.AppendLiteral("#");
  name.Append(object);
  return name;
}

nsCString
UniqueEventName(const EventInfo& info)
{
  return UniqueEventName(info.common_info.category(),
                         info.method(),
                         info.object());
}

nsCString
UniqueEventName(const DynamicEventInfo& info)
{
  return UniqueEventName(info.category,
                         info.method,
                         info.object);
}

bool
IsExpiredDate(uint32_t expires_days_since_epoch) {
  if (expires_days_since_epoch == 0) {
    return false;
  }

  const uint32_t days_since_epoch = PR_Now() / (PRTime(PR_USEC_PER_SEC) * 24 * 60 * 60);
  return expires_days_since_epoch <= days_since_epoch;
}

void
TruncateToByteLength(nsCString& str, uint32_t length)
{
  // last will be the index of the first byte of the current multi-byte sequence.
  uint32_t last = RewindToPriorUTF8Codepoint(str.get(), length);
  str.Truncate(last);
}

} // anonymous namespace

////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
//
// PRIVATE STATE, SHARED BY ALL THREADS

namespace {

// Set to true once this global state has been initialized.
bool gInitDone = false;

bool gCanRecordBase;
bool gCanRecordExtended;

// The EventName -> EventKey cache map.
nsClassHashtable<nsCStringHashKey, EventKey> gEventNameIDMap(kEventCount);

// The CategoryName -> CategoryID cache map.
StringUintMap gCategoryNameIDMap;

// This tracks the IDs of the categories for which recording is enabled.
nsTHashtable<nsCStringHashKey> gEnabledCategories;

// The main event storage. Events are inserted here, keyed by process id and
// in recording order.
typedef nsTArray<EventRecord> EventRecordArray;
nsClassHashtable<nsUint32HashKey, EventRecordArray> gEventRecords;

// The details on dynamic events that are recorded from addons are registered here.
StaticAutoPtr<nsTArray<DynamicEventInfo>> gDynamicEventInfo;

} // namespace

////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
//
// PRIVATE: thread-safe helpers for event recording.

namespace {

unsigned int
GetDataset(const StaticMutexAutoLock& lock, const EventKey& eventKey)
{
  if (!eventKey.dynamic) {
    return gEventInfo[eventKey.id].common_info.dataset;
  }

  if (!gDynamicEventInfo) {
    return nsITelemetry::DATASET_RELEASE_CHANNEL_OPTIN;
  }

  return (*gDynamicEventInfo)[eventKey.id].recordOnRelease ?
           nsITelemetry::DATASET_RELEASE_CHANNEL_OPTOUT :
           nsITelemetry::DATASET_RELEASE_CHANNEL_OPTIN;
}

nsCString
GetCategory(const StaticMutexAutoLock& lock, const EventKey& eventKey)
{
  if (!eventKey.dynamic) {
    return gEventInfo[eventKey.id].common_info.category();
  }

  if (!gDynamicEventInfo) {
    return NS_LITERAL_CSTRING("");
  }

  return (*gDynamicEventInfo)[eventKey.id].category;
}

bool
CanRecordEvent(const StaticMutexAutoLock& lock, const EventKey& eventKey,
               ProcessID process)
{
  if (!gCanRecordBase) {
    return false;
  }

  if (!CanRecordDataset(GetDataset(lock, eventKey), gCanRecordBase, gCanRecordExtended)) {
    return false;
  }

  // We don't allow specifying a process to record in for dynamic events.
  if (!eventKey.dynamic) {
    const CommonEventInfo& info = gEventInfo[eventKey.id].common_info;
    if (!CanRecordInProcess(info.record_in_processes, process)) {
      return false;
    }
  }

  return gEnabledCategories.GetEntry(GetCategory(lock, eventKey));
}

bool
IsExpired(const EventKey& key)
{
  return key.id == kExpiredEventId;
}

EventRecordArray*
GetEventRecordsForProcess(const StaticMutexAutoLock& lock, ProcessID processType,
                          const EventKey& eventKey)
{
  EventRecordArray* eventRecords = nullptr;
  if (!gEventRecords.Get(uint32_t(processType), &eventRecords)) {
    eventRecords = new EventRecordArray();
    gEventRecords.Put(uint32_t(processType), eventRecords);
  }
  return eventRecords;
}

EventKey*
GetEventKey(const StaticMutexAutoLock& lock, const nsACString& category,
           const nsACString& method, const nsACString& object)
{
  EventKey* event;
  const nsCString& name = UniqueEventName(category, method, object);
  if (!gEventNameIDMap.Get(name, &event)) {
    return nullptr;
  }
  return event;
}

static bool
CheckExtraKeysValid(const EventKey& eventKey, const ExtraArray& extra)
{
  nsTHashtable<nsCStringHashKey> validExtraKeys;
  if (!eventKey.dynamic) {
    const CommonEventInfo& common = gEventInfo[eventKey.id].common_info;
    for (uint32_t i = 0; i < common.extra_count; ++i) {
      validExtraKeys.PutEntry(common.extra_key(i));
    }
  } else if (gDynamicEventInfo) {
    const DynamicEventInfo& info = (*gDynamicEventInfo)[eventKey.id];
    for (uint32_t i = 0, len = info.extra_keys.Length(); i < len; ++i) {
      validExtraKeys.PutEntry(info.extra_keys[i]);
    }
  }

  for (uint32_t i = 0; i < extra.Length(); ++i) {
    if (!validExtraKeys.GetEntry(extra[i].key)) {
      return false;
    }
  }

  return true;
}

RecordEventResult
RecordEvent(const StaticMutexAutoLock& lock, ProcessID processType,
            double timestamp, const nsACString& category,
            const nsACString& method, const nsACString& object,
            const Maybe<nsCString>& value, const ExtraArray& extra)
{
  // Look up the event id.
  EventKey* eventKey = GetEventKey(lock, category, method, object);
  if (!eventKey) {
    return RecordEventResult::UnknownEvent;
  }

  if (eventKey->dynamic) {
    processType = ProcessID::Dynamic;
  }

  EventRecordArray* eventRecords = GetEventRecordsForProcess(lock, processType, *eventKey);

  // Apply hard limit on event count in storage.
  if (eventRecords->Length() >= kMaxEventRecords) {
    return RecordEventResult::StorageLimitReached;
  }

  // If the event is expired or not enabled for this process, we silently drop this call.
  // We don't want recording for expired probes to be an error so code doesn't
  // have to be removed at a specific time or version.
  // Even logging warnings would become very noisy.
  if (IsExpired(*eventKey)) {
    return RecordEventResult::ExpiredEvent;
  }

  // Check whether we can record this event.
  if (!CanRecordEvent(lock, *eventKey, processType)) {
    return RecordEventResult::Ok;
  }

  // Check whether the extra keys passed are valid.
  if (!CheckExtraKeysValid(*eventKey, extra)) {
    return RecordEventResult::InvalidExtraKey;
  }

  // Add event record.
  eventRecords->AppendElement(EventRecord(timestamp, *eventKey, value, extra));
  return RecordEventResult::Ok;
}

RecordEventResult
ShouldRecordChildEvent(const StaticMutexAutoLock& lock, const nsACString& category,
                       const nsACString& method, const nsACString& object)
{
  EventKey* eventKey = GetEventKey(lock, category, method, object);
  if (!eventKey) {
    // This event is unknown in this process, but it might be a dynamic event
    // that was registered in the parent process.
    return RecordEventResult::Ok;
  }

  if (IsExpired(*eventKey)) {
    return RecordEventResult::ExpiredEvent;
  }

  const auto processes = gEventInfo[eventKey->id].common_info.record_in_processes;
  if (!CanRecordInProcess(processes, XRE_GetProcessType())) {
    return RecordEventResult::WrongProcess;
  }

  return RecordEventResult::Ok;
}

RegisterEventResult
RegisterEvents(const StaticMutexAutoLock& lock, const nsACString& category,
               const nsTArray<DynamicEventInfo>& eventInfos,
               const nsTArray<bool>& eventExpired)
{
  MOZ_ASSERT(eventInfos.Length() == eventExpired.Length(), "Event data array sizes should match.");

  // Check that none of the events are already registered.
  for (auto& info : eventInfos) {
    if (gEventNameIDMap.Get(UniqueEventName(info))) {
      return RegisterEventResult::AlreadyRegistered;
    }
  }

  // Register the new events.
  if (!gDynamicEventInfo) {
    gDynamicEventInfo = new nsTArray<DynamicEventInfo>();
  }

  for (uint32_t i = 0, len = eventInfos.Length(); i < len; ++i) {
    gDynamicEventInfo->AppendElement(eventInfos[i]);
    uint32_t eventId = eventExpired[i] ? kExpiredEventId : gDynamicEventInfo->Length() - 1;
    gEventNameIDMap.Put(UniqueEventName(eventInfos[i]), new EventKey{eventId, true});
  }

  // Now after successful registration enable recording for this category.
  gEnabledCategories.PutEntry(category);

  return RegisterEventResult::Ok;
}

} // anonymous namespace

////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
//
// PRIVATE: thread-unsafe helpers for event handling.

namespace {

nsresult
SerializeEventsArray(const EventRecordArray& events,
                    JSContext* cx,
                    JS::MutableHandleObject result,
                    unsigned int dataset)
{
  // We serialize the events to a JS array.
  JS::RootedObject eventsArray(cx, JS_NewArrayObject(cx, events.Length()));
  if (!eventsArray) {
    return NS_ERROR_FAILURE;
  }

  for (uint32_t i = 0; i < events.Length(); ++i) {
    const EventRecord& record = events[i];

    // Each entry is an array of one of the forms:
    // [timestamp, category, method, object, value]
    // [timestamp, category, method, object, null, extra]
    // [timestamp, category, method, object, value, extra]
    JS::AutoValueVector items(cx);

    // Add timestamp.
    JS::Rooted<JS::Value> val(cx);
    if (!items.append(JS::NumberValue(floor(record.Timestamp())))) {
      return NS_ERROR_FAILURE;
    }

    // Add category, method, object.
    nsCString strings[3];
    const EventKey& eventKey = record.GetEventKey();
    if (!eventKey.dynamic) {
      const EventInfo& info = gEventInfo[eventKey.id];
      strings[0] = info.common_info.category();
      strings[1] = info.method();
      strings[2] = info.object();
    } else if (gDynamicEventInfo) {
      const DynamicEventInfo& info = (*gDynamicEventInfo)[eventKey.id];
      strings[0] = info.category;
      strings[1] = info.method;
      strings[2] = info.object;
    }

    for (const nsCString& s : strings) {
      const NS_ConvertUTF8toUTF16 wide(s);
      if (!items.append(JS::StringValue(JS_NewUCStringCopyN(cx, wide.Data(), wide.Length())))) {
        return NS_ERROR_FAILURE;
      }
    }

    // Add the optional string value only when needed.
    // When the value field is empty and extra is not set, we can save a little space that way.
    // We still need to submit a null value if extra is set, to match the form:
    // [ts, category, method, object, null, extra]
    if (record.Value()) {
      const NS_ConvertUTF8toUTF16 wide(record.Value().value());
      if (!items.append(JS::StringValue(JS_NewUCStringCopyN(cx, wide.Data(), wide.Length())))) {
        return NS_ERROR_FAILURE;
      }
    } else if (!record.Extra().IsEmpty()) {
      if (!items.append(JS::NullValue())) {
        return NS_ERROR_FAILURE;
      }
    }

    // Add the optional extra dictionary.
    // To save a little space, only add it when it is not empty.
    if (!record.Extra().IsEmpty()) {
      JS::RootedObject obj(cx, JS_NewPlainObject(cx));
      if (!obj) {
        return NS_ERROR_FAILURE;
      }

      // Add extra key & value entries.
      const ExtraArray& extra = record.Extra();
      for (uint32_t i = 0; i < extra.Length(); ++i) {
        const NS_ConvertUTF8toUTF16 wide(extra[i].value);
        JS::Rooted<JS::Value> value(cx);
        value.setString(JS_NewUCStringCopyN(cx, wide.Data(), wide.Length()));

        if (!JS_DefineProperty(cx, obj, extra[i].key.get(), value, JSPROP_ENUMERATE)) {
          return NS_ERROR_FAILURE;
        }
      }
      val.setObject(*obj);

      if (!items.append(val)) {
        return NS_ERROR_FAILURE;
      }
    }

    // Add the record to the events array.
    JS::RootedObject itemsArray(cx, JS_NewArrayObject(cx, items));
    if (!JS_DefineElement(cx, eventsArray, i, itemsArray, JSPROP_ENUMERATE)) {
      return NS_ERROR_FAILURE;
    }
  }

  result.set(eventsArray);
  return NS_OK;
}

} // anonymous namespace

////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
//
// EXTERNALLY VISIBLE FUNCTIONS in namespace TelemetryEvents::

// This is a StaticMutex rather than a plain Mutex (1) so that
// it gets initialised in a thread-safe manner the first time
// it is used, and (2) because it is never de-initialised, and
// a normal Mutex would show up as a leak in BloatView.  StaticMutex
// also has the "OffTheBooks" property, so it won't show as a leak
// in BloatView.
// Another reason to use a StaticMutex instead of a plain Mutex is
// that, due to the nature of Telemetry, we cannot rely on having a
// mutex initialized in InitializeGlobalState. Unfortunately, we
// cannot make sure that no other function is called before this point.
static StaticMutex gTelemetryEventsMutex;

void
TelemetryEvent::InitializeGlobalState(bool aCanRecordBase, bool aCanRecordExtended)
{
  StaticMutexAutoLock locker(gTelemetryEventsMutex);
  MOZ_ASSERT(!gInitDone, "TelemetryEvent::InitializeGlobalState "
             "may only be called once");

  gCanRecordBase = aCanRecordBase;
  gCanRecordExtended = aCanRecordExtended;

  // Populate the static event name->id cache. Note that the event names are
  // statically allocated and come from the automatically generated TelemetryEventData.h.
  const uint32_t eventCount = static_cast<uint32_t>(mozilla::Telemetry::EventID::EventCount);
  for (uint32_t i = 0; i < eventCount; ++i) {
    const EventInfo& info = gEventInfo[i];
    uint32_t eventId = i;

    // If this event is expired or not recorded in this process, mark it with
    // a special event id.
    // This avoids doing repeated checks at runtime.
    if (IsExpiredVersion(info.common_info.expiration_version().get()) ||
        IsExpiredDate(info.common_info.expiration_day)) {
      eventId = kExpiredEventId;
    }

    gEventNameIDMap.Put(UniqueEventName(info), new EventKey{eventId, false});
    if (!gCategoryNameIDMap.Contains(info.common_info.category())) {
      gCategoryNameIDMap.Put(info.common_info.category(),
                             info.common_info.category_offset);
    }
  }

#ifdef DEBUG
  gCategoryNameIDMap.MarkImmutable();
#endif
  gInitDone = true;
}

void
TelemetryEvent::DeInitializeGlobalState()
{
  StaticMutexAutoLock locker(gTelemetryEventsMutex);
  MOZ_ASSERT(gInitDone);

  gCanRecordBase = false;
  gCanRecordExtended = false;

  gEventNameIDMap.Clear();
  gCategoryNameIDMap.Clear();
  gEnabledCategories.Clear();
  gEventRecords.Clear();

  gDynamicEventInfo = nullptr;

  gInitDone = false;
}

void
TelemetryEvent::SetCanRecordBase(bool b)
{
  StaticMutexAutoLock locker(gTelemetryEventsMutex);
  gCanRecordBase = b;
}

void
TelemetryEvent::SetCanRecordExtended(bool b) {
  StaticMutexAutoLock locker(gTelemetryEventsMutex);
  gCanRecordExtended = b;
}

nsresult
TelemetryEvent::RecordChildEvents(ProcessID aProcessType,
                                  const nsTArray<mozilla::Telemetry::ChildEventData>& aEvents)
{
  MOZ_ASSERT(XRE_IsParentProcess());
  StaticMutexAutoLock locker(gTelemetryEventsMutex);
  for (uint32_t i = 0; i < aEvents.Length(); ++i) {
    const mozilla::Telemetry::ChildEventData e = aEvents[i];

    // Timestamps from child processes are absolute. We fix them up here to be
    // relative to the main process start time.
    // This allows us to put events from all processes on the same timeline.
    double relativeTimestamp = (e.timestamp - TimeStamp::ProcessCreation()).ToMilliseconds();

    ::RecordEvent(locker, aProcessType, relativeTimestamp, e.category, e.method, e.object, e.value, e.extra);
  }
  return NS_OK;
}

nsresult
TelemetryEvent::RecordEvent(const nsACString& aCategory, const nsACString& aMethod,
                            const nsACString& aObject, JS::HandleValue aValue,
                            JS::HandleValue aExtra, JSContext* cx,
                            uint8_t optional_argc)
{
  // Check value argument.
  if ((optional_argc > 0) && !aValue.isNull() && !aValue.isString()) {
    LogToBrowserConsole(nsIScriptError::warningFlag,
                        NS_LITERAL_STRING("Invalid type for value parameter."));
    return NS_OK;
  }

  // Extract value parameter.
  Maybe<nsCString> value;
  if (aValue.isString()) {
    nsAutoJSString jsStr;
    if (!jsStr.init(cx, aValue)) {
      LogToBrowserConsole(nsIScriptError::warningFlag,
                          NS_LITERAL_STRING("Invalid string value for value parameter."));
      return NS_OK;
    }

    nsCString str = NS_ConvertUTF16toUTF8(jsStr);
    if (str.Length() > kMaxValueByteLength) {
      LogToBrowserConsole(nsIScriptError::warningFlag,
                          NS_LITERAL_STRING("Value parameter exceeds maximum string length, truncating."));
      TruncateToByteLength(str, kMaxValueByteLength);
    }
    value = mozilla::Some(str);
  }

  // Check extra argument.
  if ((optional_argc > 1) && !aExtra.isNull() && !aExtra.isObject()) {
    LogToBrowserConsole(nsIScriptError::warningFlag,
                        NS_LITERAL_STRING("Invalid type for extra parameter."));
    return NS_OK;
  }

  // Extract extra dictionary.
  ExtraArray extra;
  if (aExtra.isObject()) {
    JS::RootedObject obj(cx, &aExtra.toObject());
    JS::Rooted<JS::IdVector> ids(cx, JS::IdVector(cx));
    if (!JS_Enumerate(cx, obj, &ids)) {
      LogToBrowserConsole(nsIScriptError::warningFlag,
                          NS_LITERAL_STRING("Failed to enumerate object."));
      return NS_OK;
    }

    for (size_t i = 0, n = ids.length(); i < n; i++) {
      nsAutoJSString key;
      if (!key.init(cx, ids[i])) {
        LogToBrowserConsole(nsIScriptError::warningFlag,
                            NS_LITERAL_STRING("Extra dictionary should only contain string keys."));
        return NS_OK;
      }

      JS::Rooted<JS::Value> value(cx);
      if (!JS_GetPropertyById(cx, obj, ids[i], &value)) {
        LogToBrowserConsole(nsIScriptError::warningFlag,
                            NS_LITERAL_STRING("Failed to get extra property."));
        return NS_OK;
      }

      nsAutoJSString jsStr;
      if (!value.isString() || !jsStr.init(cx, value)) {
        LogToBrowserConsole(nsIScriptError::warningFlag,
                            NS_LITERAL_STRING("Extra properties should have string values."));
        return NS_OK;
      }

      nsCString str = NS_ConvertUTF16toUTF8(jsStr);
      if (str.Length() > kMaxExtraValueByteLength) {
        LogToBrowserConsole(nsIScriptError::warningFlag,
                            NS_LITERAL_STRING("Extra value exceeds maximum string length, truncating."));
        TruncateToByteLength(str, kMaxExtraValueByteLength);
      }

      extra.AppendElement(EventExtraEntry{NS_ConvertUTF16toUTF8(key), str});
    }
  }

  // Lock for accessing internal data.
  // While the lock is being held, no complex calls like JS calls can be made,
  // as all of these could record Telemetry, which would result in deadlock.
  RecordEventResult res;
  if (!XRE_IsParentProcess()) {
    {
      StaticMutexAutoLock lock(gTelemetryEventsMutex);
      res = ::ShouldRecordChildEvent(lock, aCategory, aMethod, aObject);
    }

    if (res == RecordEventResult::Ok) {
      TelemetryIPCAccumulator::RecordChildEvent(TimeStamp::NowLoRes(), aCategory,
                                                aMethod, aObject, value, extra);
    }
  } else {
    StaticMutexAutoLock lock(gTelemetryEventsMutex);

    if (!gInitDone) {
      return NS_ERROR_FAILURE;
    }

    // Get the current time.
    double timestamp = -1;
    if (NS_WARN_IF(NS_FAILED(MsSinceProcessStart(&timestamp)))) {
      return NS_ERROR_FAILURE;
    }

    res = ::RecordEvent(lock, ProcessID::Parent, timestamp, aCategory, aMethod, aObject, value, extra);
  }

  // Trigger warnings or errors where needed.
  switch (res) {
    case RecordEventResult::UnknownEvent: {
      JS_ReportErrorASCII(cx, R"(Unknown event: ["%s", "%s", "%s"])",
                          PromiseFlatCString(aCategory).get(),
                          PromiseFlatCString(aMethod).get(),
                          PromiseFlatCString(aObject).get());
      return NS_ERROR_INVALID_ARG;
    }
    case RecordEventResult::InvalidExtraKey: {
      nsPrintfCString msg(R"(Invalid extra key for event ["%s", "%s", "%s"].)",
                          PromiseFlatCString(aCategory).get(),
                          PromiseFlatCString(aMethod).get(),
                          PromiseFlatCString(aObject).get());
      LogToBrowserConsole(nsIScriptError::warningFlag, NS_ConvertUTF8toUTF16(msg));
      return NS_OK;
    }
    case RecordEventResult::StorageLimitReached:
      LogToBrowserConsole(nsIScriptError::warningFlag,
                          NS_LITERAL_STRING("Event storage limit reached."));
      return NS_OK;
    default:
      return NS_OK;
  }
}

static bool
GetArrayPropertyValues(JSContext* cx, JS::HandleObject obj, const char* property,
                       nsTArray<nsCString>* results)
{
  JS::RootedValue value(cx);
  if (!JS_GetProperty(cx, obj, property, &value)) {
    JS_ReportErrorASCII(cx, R"(Missing required property "%s" for event)", property);
    return false;
  }

  bool isArray = false;
  if (!JS_IsArrayObject(cx, value, &isArray) || !isArray) {
    JS_ReportErrorASCII(cx, R"(Property "%s" for event should be an array)", property);
    return false;
  }

  JS::RootedObject arrayObj(cx, &value.toObject());
  uint32_t arrayLength;
  if (!JS_GetArrayLength(cx, arrayObj, &arrayLength)) {
    return false;
  }

  for (uint32_t arrayIdx = 0; arrayIdx < arrayLength; ++arrayIdx) {
    JS::Rooted<JS::Value> element(cx);
    if (!JS_GetElement(cx, arrayObj, arrayIdx, &element)) {
      return false;
    }

    if (!element.isString()) {
      JS_ReportErrorASCII(cx, R"(Array entries for event property "%s" should be strings)", property);
      return false;
    }

    nsAutoJSString jsStr;
    if (!jsStr.init(cx, element)) {
      return false;
    }

    results->AppendElement(NS_ConvertUTF16toUTF8(jsStr));
  }

  return true;
}

static bool
IsStringCharValid(const char aChar, const bool allowInfixPeriod)
{
  return (aChar >= 'A' && aChar <= 'Z')
      || (aChar >= 'a' && aChar <= 'z')
      || (aChar >= '0' && aChar <= '9')
      || (allowInfixPeriod && (aChar == '.'));
}

static bool
IsValidIdentifierString(const nsACString& str, const size_t maxLength,
                        const bool allowInfixPeriod)
{
  // Check string length.
  if (str.Length() > maxLength) {
    return false;
  }

  // Check string characters.
  const char* first = str.BeginReading();
  const char* end = str.EndReading();

  for (const char* cur = first; cur < end; ++cur) {
      const bool allowPeriod = allowInfixPeriod && (cur != first) && (cur != (end - 1));
      if (!IsStringCharValid(*cur, allowPeriod)) {
        return false;
      }
  }

  return true;
}

nsresult
TelemetryEvent::RegisterEvents(const nsACString& aCategory,
                               JS::Handle<JS::Value> aEventData,
                               JSContext* cx)
{
  if (!IsValidIdentifierString(aCategory, 30, true)) {
    JS_ReportErrorASCII(cx, "Category parameter should match the identifier pattern.");
    return NS_ERROR_INVALID_ARG;
  }

  if (!aEventData.isObject()) {
    JS_ReportErrorASCII(cx, "Event data parameter should be an object");
    return NS_ERROR_INVALID_ARG;
  }

  JS::RootedObject obj(cx, &aEventData.toObject());
  JS::Rooted<JS::IdVector> eventPropertyIds(cx, JS::IdVector(cx));
  if (!JS_Enumerate(cx, obj, &eventPropertyIds)) {
    return NS_ERROR_FAILURE;
  }

  // Collect the event data into local storage first.
  // Only after successfully validating all contained events will we register them into global storage.
  nsTArray<DynamicEventInfo> newEventInfos;
  nsTArray<bool> newEventExpired;

  for (size_t i = 0, n = eventPropertyIds.length(); i < n; i++) {
    nsAutoJSString eventName;
    if (!eventName.init(cx, eventPropertyIds[i])) {
      return NS_ERROR_FAILURE;
    }

    if (!IsValidIdentifierString(NS_ConvertUTF16toUTF8(eventName), kMaxMethodNameByteLength, false)) {
      JS_ReportErrorASCII(cx, "Event names should match the identifier pattern.");
      return NS_ERROR_INVALID_ARG;
    }

    JS::RootedValue value(cx);
    if (!JS_GetPropertyById(cx, obj, eventPropertyIds[i], &value) || !value.isObject()) {
      return NS_ERROR_FAILURE;
    }
    JS::RootedObject eventObj(cx, &value.toObject());

    // Extract the event registration data.
    nsTArray<nsCString> methods;
    nsTArray<nsCString> objects;
    nsTArray<nsCString> extra_keys;
    bool expired = false;
    bool recordOnRelease = false;

    // The methods & objects properties are required.
    if (!GetArrayPropertyValues(cx, eventObj, "methods", &methods)) {
      return NS_ERROR_FAILURE;
    }

    if (!GetArrayPropertyValues(cx, eventObj, "objects", &objects)) {
      return NS_ERROR_FAILURE;
    }

    // extra_keys is optional.
    bool hasProperty = false;
    if (JS_HasProperty(cx, eventObj, "extra_keys", &hasProperty) && hasProperty) {
      if (!GetArrayPropertyValues(cx, eventObj, "extra_keys", &extra_keys)) {
        return NS_ERROR_FAILURE;
      }
    }

    // expired is optional.
    if (JS_HasProperty(cx, eventObj, "expired", &hasProperty) && hasProperty) {
      JS::RootedValue temp(cx);
      if (!JS_GetProperty(cx, eventObj, "expired", &temp) || !temp.isBoolean()) {
        return NS_ERROR_FAILURE;
      }

      expired = temp.toBoolean();
    }

    // record_on_release is optional.
    if (JS_HasProperty(cx, eventObj, "record_on_release", &hasProperty) && hasProperty) {
      JS::RootedValue temp(cx);
      if (!JS_GetProperty(cx, eventObj, "record_on_release", &temp) || !temp.isBoolean()) {
        return NS_ERROR_FAILURE;
      }

      recordOnRelease = temp.toBoolean();
    }

    // Validate methods.
    for (auto& method : methods) {
      if (!IsValidIdentifierString(method, kMaxMethodNameByteLength, false)) {
        JS_ReportErrorASCII(cx, "Method names should match the identifier pattern.");
        return NS_ERROR_INVALID_ARG;
      }
    }

    // Validate objects.
    for (auto& object : objects) {
      if (!IsValidIdentifierString(object, kMaxObjectNameByteLength, false)) {
        JS_ReportErrorASCII(cx, "Object names should match the identifier pattern.");
        return NS_ERROR_INVALID_ARG;
      }
    }

    // Validate extra keys.
    if (extra_keys.Length() > kMaxExtraKeyCount) {
      JS_ReportErrorASCII(cx, "No more than 10 extra keys can be registered.");
      return NS_ERROR_INVALID_ARG;
    }
    for (auto& key : extra_keys) {
      if (!IsValidIdentifierString(key, kMaxExtraKeyNameByteLength, false)) {
        JS_ReportErrorASCII(cx, "Extra key names should match the identifier pattern.");
        return NS_ERROR_INVALID_ARG;
      }
    }

    // Append event infos to be registered.
    for (auto& method : methods) {
      for (auto& object : objects) {
        // We defer the actual registration here in case any other event description is invalid.
        // In that case we don't need to roll back any partial registration.
        DynamicEventInfo info{nsCString(aCategory), method, object,
                              nsTArray<nsCString>(extra_keys), recordOnRelease};
        newEventInfos.AppendElement(info);
        newEventExpired.AppendElement(expired);
      }
    }
  }

  RegisterEventResult res = RegisterEventResult::Ok;
  {
    StaticMutexAutoLock locker(gTelemetryEventsMutex);
    res = ::RegisterEvents(locker, aCategory, newEventInfos, newEventExpired);
  }

  switch (res) {
    case RegisterEventResult::AlreadyRegistered:
      JS_ReportErrorASCII(cx, "Attempt to register event that is already registered.");
      return NS_ERROR_INVALID_ARG;
    default:
      break;
  }

  return NS_OK;
}

nsresult
TelemetryEvent::CreateSnapshots(uint32_t aDataset, bool aClear, JSContext* cx,
                                uint8_t optional_argc, JS::MutableHandleValue aResult)
{
  if (!XRE_IsParentProcess()) {
    return NS_ERROR_FAILURE;
  }

  // Creating a JS snapshot of the events is a two-step process:
  // (1) Lock the storage and copy the events into function-local storage.
  // (2) Serialize the events into JS.
  // We can't hold a lock for (2) because we will run into deadlocks otherwise
  // from JS recording Telemetry.

  // (1) Extract the events from storage with a lock held.
  nsTArray<mozilla::Pair<const char*, EventRecordArray>> processEvents;
  {
    StaticMutexAutoLock locker(gTelemetryEventsMutex);

    if (!gInitDone) {
      return NS_ERROR_FAILURE;
    }

    for (auto iter = gEventRecords.Iter(); !iter.Done(); iter.Next()) {
      const EventRecordArray* eventStorage = static_cast<EventRecordArray*>(iter.Data());
      EventRecordArray events;

      const uint32_t len = eventStorage->Length();
      for (uint32_t i = 0; i < len; ++i) {
        const EventRecord& record = (*eventStorage)[i];
        if (IsInDataset(GetDataset(locker, record.GetEventKey()), aDataset)) {
          events.AppendElement(record);
        }
      }

      if (events.Length()) {
        const char* processName = GetNameForProcessID(ProcessID(iter.Key()));
        processEvents.AppendElement(mozilla::MakePair(processName, events));
      }
    }

    if (aClear) {
      gEventRecords.Clear();
    }
  }

  // (2) Serialize the events to a JS object.
  JS::RootedObject rootObj(cx, JS_NewPlainObject(cx));
  if (!rootObj) {
    return NS_ERROR_FAILURE;
  }

  const uint32_t processLength = processEvents.Length();
  for (uint32_t i = 0; i < processLength; ++i)
  {
    JS::RootedObject eventsArray(cx);
    if (NS_FAILED(SerializeEventsArray(processEvents[i].second(), cx, &eventsArray, aDataset))) {
      return NS_ERROR_FAILURE;
    }

    if (!JS_DefineProperty(cx, rootObj, processEvents[i].first(), eventsArray, JSPROP_ENUMERATE)) {
      return NS_ERROR_FAILURE;
    }
  }

  aResult.setObject(*rootObj);
  return NS_OK;
}

/**
 * Resets all the stored events. This is intended to be only used in tests.
 */
void
TelemetryEvent::ClearEvents()
{
  StaticMutexAutoLock lock(gTelemetryEventsMutex);

  if (!gInitDone) {
    return;
  }

  gEventRecords.Clear();
}

void
TelemetryEvent::SetEventRecordingEnabled(const nsACString& category, bool enabled)
{
  StaticMutexAutoLock locker(gTelemetryEventsMutex);

  uint32_t categoryId;
  if (!gCategoryNameIDMap.Get(category, &categoryId)) {
    LogToBrowserConsole(nsIScriptError::warningFlag,
                        NS_LITERAL_STRING("Unkown category for SetEventRecordingEnabled."));
    return;
  }

  if (enabled) {
    gEnabledCategories.PutEntry(category);
  } else {
    gEnabledCategories.RemoveEntry(category);
  }
}

size_t
TelemetryEvent::SizeOfIncludingThis(mozilla::MallocSizeOf aMallocSizeOf)
{
  StaticMutexAutoLock locker(gTelemetryEventsMutex);
  size_t n = 0;


  n += gEventRecords.ShallowSizeOfExcludingThis(aMallocSizeOf);
  for (auto iter = gEventRecords.Iter(); !iter.Done(); iter.Next()) {
    EventRecordArray* eventRecords = static_cast<EventRecordArray*>(iter.Data());
    n += eventRecords->ShallowSizeOfIncludingThis(aMallocSizeOf);

    const uint32_t len = eventRecords->Length();
    for (uint32_t i = 0; i < len; ++i) {
      n += (*eventRecords)[i].SizeOfExcludingThis(aMallocSizeOf);
    }
  }

  n += gEventNameIDMap.ShallowSizeOfExcludingThis(aMallocSizeOf);
  for (auto iter = gEventNameIDMap.ConstIter(); !iter.Done(); iter.Next()) {
    n += iter.Key().SizeOfExcludingThisIfUnshared(aMallocSizeOf);
  }

  n += gCategoryNameIDMap.ShallowSizeOfExcludingThis(aMallocSizeOf);
  for (auto iter = gCategoryNameIDMap.ConstIter(); !iter.Done(); iter.Next()) {
    n += iter.Key().SizeOfExcludingThisIfUnshared(aMallocSizeOf);
  }

  n += gEnabledCategories.ShallowSizeOfExcludingThis(aMallocSizeOf);

  if (gDynamicEventInfo) {
    n += gDynamicEventInfo->ShallowSizeOfIncludingThis(aMallocSizeOf);
    for (auto& info : *gDynamicEventInfo) {
      n += info.SizeOfExcludingThis(aMallocSizeOf);
    }
  }

  return n;
}
