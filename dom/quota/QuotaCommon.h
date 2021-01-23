/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_dom_quota_quotacommon_h__
#define mozilla_dom_quota_quotacommon_h__

#include "nsCOMPtr.h"
#include "nsDebug.h"
#include "nsPrintfCString.h"
#include "nsString.h"
#include "nsTArray.h"

#define BEGIN_QUOTA_NAMESPACE \
  namespace mozilla {         \
  namespace dom {             \
  namespace quota {
#define END_QUOTA_NAMESPACE \
  } /* namespace quota */   \
  } /* namespace dom */     \
  } /* namespace mozilla */
#define USING_QUOTA_NAMESPACE using namespace mozilla::dom::quota;

#define DSSTORE_FILE_NAME ".DS_Store"
#define DESKTOP_FILE_NAME ".desktop"
#define DESKTOP_INI_FILE_NAME "desktop.ini"
#define THUMBS_DB_FILE_NAME "thumbs.db"

#define QM_WARNING(...)                                                      \
  do {                                                                       \
    nsPrintfCString str(__VA_ARGS__);                                        \
    mozilla::dom::quota::ReportInternalError(__FILE__, __LINE__, str.get()); \
    NS_WARNING(str.get());                                                   \
  } while (0)

#define UNKNOWN_FILE_WARNING(_leafName)                                       \
  NS_WARNING(                                                                 \
      nsPrintfCString("Something (%s) in the directory that doesn't belong!", \
                      NS_ConvertUTF16toUTF8(_leafName).get())                 \
          .get())

// Telemetry probes to collect number of failure during the initialization.
#ifdef NIGHTLY_BUILD
#  define REPORT_TELEMETRY_INIT_ERR(_key, _label)   \
    mozilla::Telemetry::AccumulateCategoricalKeyed( \
        mozilla::dom::quota::_key,                  \
        mozilla::Telemetry::LABELS_QM_INIT_TELEMETRY_ERROR::_label);

#  define REPORT_TELEMETRY_ERR_IN_INIT(_initializing, _key, _label) \
    do {                                                            \
      if (_initializing) {                                          \
        REPORT_TELEMETRY_INIT_ERR(_key, _label)                     \
      }                                                             \
    } while (0)

#  define RECORD_IN_NIGHTLY(_recorder, _status) \
    do {                                        \
      if (NS_SUCCEEDED(_recorder)) {            \
        _recorder = _status;                    \
      }                                         \
    } while (0)

#  define CONTINUE_IN_NIGHTLY_RETURN_IN_OTHERS(_dummy) continue

#  define RETURN_STATUS_OR_RESULT(_status, _rv) \
    return NS_FAILED(_status) ? _status : _rv
#else
#  define REPORT_TELEMETRY_INIT_ERR(_key, _label) \
    {}

#  define REPORT_TELEMETRY_ERR_IN_INIT(_initializing, _key, _label) \
    {}

#  define RECORD_IN_NIGHTLY(_dummy, _status) \
    {}

#  define CONTINUE_IN_NIGHTLY_RETURN_IN_OTHERS(_rv) return _rv

#  define RETURN_STATUS_OR_RESULT(_status, _rv) return _rv
#endif

class nsIEventTarget;
class nsIFile;

namespace mozilla {

class LogModule;

namespace dom {
namespace quota {

extern const char kQuotaGenericDelimiter;

// Telemetry keys to indicate types of errors.
#ifdef NIGHTLY_BUILD
extern const nsLiteralCString kQuotaInternalError;
extern const nsLiteralCString kQuotaExternalError;
#else
// No need for these when we're not collecting telemetry.
#  define kQuotaInternalError
#  define kQuotaExternalError
#endif

class BackgroundThreadObject {
 protected:
  nsCOMPtr<nsIEventTarget> mOwningThread;

 public:
  void AssertIsOnOwningThread() const
#ifdef DEBUG
      ;
#else
  {
  }
#endif

  nsIEventTarget* OwningThread() const;

 protected:
  BackgroundThreadObject();

  explicit BackgroundThreadObject(nsIEventTarget* aOwningThread);
};

void AssertIsOnIOThread();

void AssertCurrentThreadOwnsQuotaMutex();

bool IsOnIOThread();

void ReportInternalError(const char* aFile, uint32_t aLine, const char* aStr);

LogModule* GetQuotaManagerLogger();

void AnonymizeCString(nsACString& aCString);

class AnonymizedCString : public nsCString {
 public:
  explicit AnonymizedCString(const nsACString& aCString) : nsCString(aCString) {
    AnonymizeCString(*this);
  }
};

void AnonymizeOriginString(nsACString& aOriginString);

class AnonymizedOriginString : public nsCString {
 public:
  explicit AnonymizedOriginString(const nsACString& aOriginString)
      : nsCString(aOriginString) {
    AnonymizeOriginString(*this);
  }
};

template <typename T>
void StringifyTableKeys(const T& aTable, nsACString& aResult) {
  bool first = true;
  for (auto iter = aTable.ConstIter(); !iter.Done(); iter.Next()) {
    if (first) {
      first = false;
    } else {
      aResult.Append(NS_LITERAL_CSTRING(", "));
    }

    const auto& key = iter.Get()->GetKey();

    aResult.Append(key);
  }
}

#ifdef XP_WIN
void CacheUseDOSDevicePathSyntaxPrefValue();
#endif

Result<nsCOMPtr<nsIFile>, nsresult> QM_NewLocalFile(const nsAString& aPath);

class IntString : public nsAutoString {
 public:
  explicit IntString(int64_t aInteger) { AppendInt(aInteger); }
};

class IntCString : public nsAutoCString {
 public:
  explicit IntCString(int64_t aInteger) { AppendInt(aInteger); }
};

}  // namespace quota
}  // namespace dom
}  // namespace mozilla

#endif  // mozilla_dom_quota_quotacommon_h__
