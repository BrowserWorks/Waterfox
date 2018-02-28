/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

/**
 * Native implementation of some OS.File operations.
 */

#include "NativeOSFileInternals.h"

#include "nsString.h"
#include "nsNetCID.h"
#include "nsThreadUtils.h"
#include "nsXPCOMCID.h"
#include "nsCycleCollectionParticipant.h"
#include "nsServiceManagerUtils.h"
#include "nsProxyRelease.h"

#include "nsINativeOSFileInternals.h"
#include "mozilla/dom/NativeOSFileInternalsBinding.h"

#include "mozilla/Encoding.h"
#include "nsIEventTarget.h"

#include "mozilla/DebugOnly.h"
#include "mozilla/Scoped.h"
#include "mozilla/HoldDropJSObjects.h"
#include "mozilla/TimeStamp.h"

#include "prio.h"
#include "prerror.h"
#include "private/pprio.h"

#include "jsapi.h"
#include "jsfriendapi.h"
#include "js/Utility.h"
#include "xpcpublic.h"

#include <algorithm>
#if defined(XP_UNIX)
#include <unistd.h>
#include <errno.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/uio.h>
#endif // defined (XP_UNIX)

#if defined(XP_WIN)
#include <windows.h>
#endif // defined (XP_WIN)

namespace mozilla {

MOZ_TYPE_SPECIFIC_SCOPED_POINTER_TEMPLATE(ScopedPRFileDesc, PRFileDesc, PR_Close)

namespace {

// Utilities for safely manipulating ArrayBuffer contents even in the
// absence of a JSContext.

/**
 * The C buffer underlying to an ArrayBuffer. Throughout the code, we manipulate
 * this instead of a void* buffer, as this lets us transfer data across threads
 * and into JavaScript without copy.
 */
struct ArrayBufferContents {
  /**
   * The data of the ArrayBuffer. This is the pointer manipulated to
   * read/write the contents of the buffer.
   */
  uint8_t* data;
  /**
   * The number of bytes in the ArrayBuffer.
   */
  size_t nbytes;
};

/**
 * RAII for ArrayBufferContents.
 */
struct ScopedArrayBufferContentsTraits {
  typedef ArrayBufferContents type;
  const static type empty() {
    type result = {0, 0};
    return result;
  }
  static void release(type ptr) {
    js_free(ptr.data);
    ptr.data = nullptr;
    ptr.nbytes = 0;
  }
};

struct MOZ_NON_TEMPORARY_CLASS ScopedArrayBufferContents: public Scoped<ScopedArrayBufferContentsTraits> {
  explicit ScopedArrayBufferContents(MOZ_GUARD_OBJECT_NOTIFIER_ONLY_PARAM):
    Scoped<ScopedArrayBufferContentsTraits>(MOZ_GUARD_OBJECT_NOTIFIER_ONLY_PARAM_TO_PARENT)
  { }

  ScopedArrayBufferContents& operator=(ArrayBufferContents ptr) {
    Scoped<ScopedArrayBufferContentsTraits>::operator=(ptr);
    return *this;
  }

  /**
   * Request memory for this ArrayBufferContent. This memory may later
   * be used to create an ArrayBuffer object (possibly on another
   * thread) without copy.
   *
   * @return true In case of success, false otherwise.
   */
  bool Allocate(uint32_t length) {
    dispose();
    ArrayBufferContents& value = rwget();
    void *ptr = js_calloc(1, length);
    if (ptr) {
      value.data = (uint8_t *) ptr;
      value.nbytes = length;
      return true;
    }
    return false;
  }
private:
  explicit ScopedArrayBufferContents(ScopedArrayBufferContents& source) = delete;
  ScopedArrayBufferContents& operator=(ScopedArrayBufferContents& source) = delete;
};

///////// Cross-platform issues

// Platform specific constants. As OS.File always uses OS-level
// errors, we need to map a few high-level errors to OS-level
// constants.
#if defined(XP_UNIX)
#define OS_ERROR_NOMEM ENOMEM
#define OS_ERROR_INVAL EINVAL
#define OS_ERROR_TOO_LARGE EFBIG
#define OS_ERROR_RACE EIO
#elif defined(XP_WIN)
#define OS_ERROR_NOMEM ERROR_NOT_ENOUGH_MEMORY
#define OS_ERROR_INVAL ERROR_BAD_ARGUMENTS
#define OS_ERROR_TOO_LARGE ERROR_FILE_TOO_LARGE
#define OS_ERROR_RACE ERROR_SHARING_VIOLATION
#else
#error "We do not have platform-specific constants for this platform"
#endif

///////// Results of OS.File operations

/**
 * Base class for results passed to the callbacks.
 *
 * This base class implements caching of JS values returned to the client.
 * We make use of this caching in derived classes e.g. to avoid accidents
 * when we transfer data allocated on another thread into JS. Note that
 * this caching can lead to cycles (e.g. if a client adds a back-reference
 * in the JS value), so we implement all Cycle Collector primitives in
 * AbstractResult.
 */
class AbstractResult: public nsINativeOSFileResult {
public:
  NS_DECL_NSINATIVEOSFILERESULT
  NS_DECL_CYCLE_COLLECTING_ISUPPORTS
  NS_DECL_CYCLE_COLLECTION_SCRIPT_HOLDER_CLASS(AbstractResult)

  /**
   * Construct the result object. Must be called on the main thread
   * as the AbstractResult is cycle-collected.
   *
   * @param aStartDate The instant at which the operation was
   * requested.  Used to collect Telemetry statistics.
   */
  explicit AbstractResult(TimeStamp aStartDate)
    : mStartDate(aStartDate)
  {
    MOZ_ASSERT(NS_IsMainThread());
    mozilla::HoldJSObjects(this);
  }

  /**
   * Setup the AbstractResult once data is available.
   *
   * @param aDispatchDate The instant at which the IO thread received
   * the operation request. Used to collect Telemetry statistics.
   * @param aExecutionDuration The duration of the operation on the
   * IO thread.
   */
  void Init(TimeStamp aDispatchDate,
            TimeDuration aExecutionDuration) {
    MOZ_ASSERT(!NS_IsMainThread());

    mDispatchDuration = (aDispatchDate - mStartDate);
    mExecutionDuration = aExecutionDuration;
  }

  /**
   * Drop any data that could lead to a cycle.
   */
  void DropJSData() {
    mCachedResult = JS::UndefinedValue();
  }

protected:
  virtual ~AbstractResult() {
    MOZ_ASSERT(NS_IsMainThread());
    DropJSData();
    mozilla::DropJSObjects(this);
  }

  virtual nsresult GetCacheableResult(JSContext *cx, JS::MutableHandleValue aResult) = 0;

private:
  TimeStamp mStartDate;
  TimeDuration mDispatchDuration;
  TimeDuration mExecutionDuration;
  JS::Heap<JS::Value> mCachedResult;
};

NS_IMPL_CYCLE_COLLECTING_ADDREF(AbstractResult)
NS_IMPL_CYCLE_COLLECTING_RELEASE(AbstractResult)

NS_IMPL_CYCLE_COLLECTION_CLASS(AbstractResult)

NS_INTERFACE_MAP_BEGIN_CYCLE_COLLECTION(AbstractResult)
  NS_INTERFACE_MAP_ENTRY(nsINativeOSFileResult)
  NS_INTERFACE_MAP_ENTRY(nsISupports)
NS_INTERFACE_MAP_END

NS_IMPL_CYCLE_COLLECTION_TRACE_BEGIN(AbstractResult)
  NS_IMPL_CYCLE_COLLECTION_TRACE_JS_MEMBER_CALLBACK(mCachedResult)
NS_IMPL_CYCLE_COLLECTION_TRACE_END

NS_IMPL_CYCLE_COLLECTION_TRAVERSE_BEGIN(AbstractResult)
NS_IMPL_CYCLE_COLLECTION_TRAVERSE_END

NS_IMPL_CYCLE_COLLECTION_UNLINK_BEGIN(AbstractResult)
  tmp->DropJSData();
NS_IMPL_CYCLE_COLLECTION_UNLINK_END

NS_IMETHODIMP
AbstractResult::GetDispatchDurationMS(double *aDispatchDuration)
{
  *aDispatchDuration = mDispatchDuration.ToMilliseconds();
  return NS_OK;
}

NS_IMETHODIMP
AbstractResult::GetExecutionDurationMS(double *aExecutionDuration)
{
  *aExecutionDuration = mExecutionDuration.ToMilliseconds();
  return NS_OK;
}

NS_IMETHODIMP
AbstractResult::GetResult(JSContext *cx, JS::MutableHandleValue aResult)
{
  if (mCachedResult.isUndefined()) {
    nsresult rv = GetCacheableResult(cx, aResult);
    if (NS_FAILED(rv)) {
      return rv;
    }
    mCachedResult = aResult;
    return NS_OK;
  }
  aResult.set(mCachedResult);
  return NS_OK;
}

/**
 * Return a result as a string.
 *
 * In this implementation, attribute |result| is a string. Strings are
 * passed to JS without copy.
 */
class StringResult final : public AbstractResult
{
public:
  explicit StringResult(TimeStamp aStartDate)
    : AbstractResult(aStartDate)
  {
  }

  /**
   * Initialize the object once the contents of the result as available.
   *
   * @param aContents The string to pass to JavaScript. Ownership of the
   * string and its contents is passed to StringResult. The string must
   * be valid UTF-16.
   */
  void Init(TimeStamp aDispatchDate,
            TimeDuration aExecutionDuration,
            nsString& aContents) {
    AbstractResult::Init(aDispatchDate, aExecutionDuration);
    mContents = aContents;
  }

protected:
  nsresult GetCacheableResult(JSContext* cx, JS::MutableHandleValue aResult) override;

private:
  nsString mContents;
};

nsresult
StringResult::GetCacheableResult(JSContext* cx, JS::MutableHandleValue aResult)
{
  MOZ_ASSERT(NS_IsMainThread());
  MOZ_ASSERT(mContents.get());

  // Convert mContents to a js string without copy. Note that this
  // may have the side-effect of stealing the contents of the string
  // from XPCOM and into JS.
  if (!xpc::StringToJsval(cx, mContents, aResult)) {
    return NS_ERROR_FAILURE;
  }
  return NS_OK;
}


/**
 * Return a result as a Uint8Array.
 *
 * In this implementation, attribute |result| is a Uint8Array. The array
 * is passed to JS without memory copy.
 */
class TypedArrayResult final : public AbstractResult
{
public:
  explicit TypedArrayResult(TimeStamp aStartDate)
    : AbstractResult(aStartDate)
  {
  }

  /**
   * @param aContents The contents to pass to JS. Calling this method.
   * transmits ownership of the ArrayBufferContents to the TypedArrayResult.
   * Do not reuse this value anywhere else.
   */
  void Init(TimeStamp aDispatchDate,
            TimeDuration aExecutionDuration,
            ArrayBufferContents aContents) {
    AbstractResult::Init(aDispatchDate, aExecutionDuration);
    mContents = aContents;
  }

protected:
  nsresult GetCacheableResult(JSContext* cx, JS::MutableHandleValue aResult) override;
private:
  ScopedArrayBufferContents mContents;
};

nsresult
TypedArrayResult::GetCacheableResult(JSContext* cx, JS::MutableHandle<JS::Value> aResult)
{
  MOZ_ASSERT(NS_IsMainThread());
  // We cannot simply construct a typed array using contents.data as
  // this would allow us to have several otherwise unrelated
  // ArrayBuffers with the same underlying C buffer. As this would be
  // very unsafe, we need to cache the result once we have it.

  const ArrayBufferContents& contents = mContents.get();
  MOZ_ASSERT(contents.data);

  JS::Rooted<JSObject*>
    arrayBuffer(cx, JS_NewArrayBufferWithContents(cx, contents.nbytes, contents.data));
  if (!arrayBuffer) {
    return NS_ERROR_OUT_OF_MEMORY;
  }

  JS::Rooted<JSObject*>
    result(cx, JS_NewUint8ArrayWithBuffer(cx, arrayBuffer,
                                          0, contents.nbytes));
  if (!result) {
    return NS_ERROR_OUT_OF_MEMORY;
  }
  // The memory of contents has been allocated on a thread that
  // doesn't have a JSRuntime, hence without a context. Now that we
  // have a context, attach the memory to where it belongs.
  JS_updateMallocCounter(cx, contents.nbytes);
  mContents.forget();

  aResult.setObject(*result);
  return NS_OK;
}

//////// Callback events

/**
 * An event used to notify asynchronously of an error.
 */
class ErrorEvent final : public Runnable {
public:
  /**
   * @param aOnSuccess The success callback.
   * @param aOnError The error callback.
   * @param aDiscardedResult The discarded result.
   * @param aOperation The name of the operation, used for error reporting.
   * @param aOSError The OS error of the operation, as returned by errno/
   * GetLastError().
   *
   * Note that we pass both the success callback and the error
   * callback, as well as the discarded result to ensure that they are
   * all released on the main thread, rather than on the IO thread
   * (which would hopefully segfault). Also, we pass the callbacks as
   * alread_AddRefed to ensure that we do not manipulate main-thread
   * only refcounters off the main thread.
   */
  ErrorEvent(nsMainThreadPtrHandle<nsINativeOSFileSuccessCallback>& aOnSuccess,
             nsMainThreadPtrHandle<nsINativeOSFileErrorCallback>& aOnError,
             already_AddRefed<AbstractResult>& aDiscardedResult,
             const nsACString& aOperation,
             int32_t aOSError)
    : Runnable("ErrorEvent")
    , mOnSuccess(aOnSuccess)
    , mOnError(aOnError)
    , mDiscardedResult(aDiscardedResult)
    , mOSError(aOSError)
    , mOperation(aOperation)
  {
    MOZ_ASSERT(!NS_IsMainThread());
    }

  NS_IMETHOD Run() override {
    MOZ_ASSERT(NS_IsMainThread());
    (void)mOnError->Complete(mOperation, mOSError);

    // Ensure that the callbacks are released on the main thread.
    mOnSuccess = nullptr;
    mOnError = nullptr;
    mDiscardedResult = nullptr;

    return NS_OK;
  }
 private:
  // The callbacks. Maintained as nsMainThreadPtrHandle as they are generally
  // xpconnect values, which cannot be manipulated with nsCOMPtr off
  // the main thread. We store both the success callback and the
  // error callback to ensure that they are safely released on the
  // main thread.
  nsMainThreadPtrHandle<nsINativeOSFileSuccessCallback> mOnSuccess;
  nsMainThreadPtrHandle<nsINativeOSFileErrorCallback> mOnError;
  RefPtr<AbstractResult> mDiscardedResult;
  int32_t mOSError;
  nsCString mOperation;
};

/**
 * An event used to notify of a success.
 */
class SuccessEvent final : public Runnable {
public:
  /**
   * @param aOnSuccess The success callback.
   * @param aOnError The error callback.
   *
   * Note that we pass both the success callback and the error
   * callback to ensure that they are both released on the main
   * thread, rather than on the IO thread (which would hopefully
   * segfault). Also, we pass them as alread_AddRefed to ensure that
   * we do not manipulate xpconnect refcounters off the main thread
   * (which is illegal).
   */
  SuccessEvent(
    nsMainThreadPtrHandle<nsINativeOSFileSuccessCallback>& aOnSuccess,
    nsMainThreadPtrHandle<nsINativeOSFileErrorCallback>& aOnError,
    already_AddRefed<nsINativeOSFileResult>& aResult)
    : Runnable("SuccessEvent")
    , mOnSuccess(aOnSuccess)
    , mOnError(aOnError)
    , mResult(aResult)
  {
    MOZ_ASSERT(!NS_IsMainThread());
    }

  NS_IMETHOD Run() override {
    MOZ_ASSERT(NS_IsMainThread());
    (void)mOnSuccess->Complete(mResult);

    // Ensure that the callbacks are released on the main thread.
    mOnSuccess = nullptr;
    mOnError = nullptr;
    mResult = nullptr;

    return NS_OK;
  }
 private:
  // The callbacks. Maintained as nsMainThreadPtrHandle as they are generally
  // xpconnect values, which cannot be manipulated with nsCOMPtr off
  // the main thread. We store both the success callback and the
  // error callback to ensure that they are safely released on the
  // main thread.
  nsMainThreadPtrHandle<nsINativeOSFileSuccessCallback> mOnSuccess;
  nsMainThreadPtrHandle<nsINativeOSFileErrorCallback> mOnError;
  RefPtr<nsINativeOSFileResult> mResult;
};


//////// Action events

/**
 * Base class shared by actions.
 */
class AbstractDoEvent: public Runnable {
public:
  AbstractDoEvent(
    nsMainThreadPtrHandle<nsINativeOSFileSuccessCallback>& aOnSuccess,
    nsMainThreadPtrHandle<nsINativeOSFileErrorCallback>& aOnError)
    : Runnable("AbstractDoEvent")
    , mOnSuccess(aOnSuccess)
    , mOnError(aOnError)
#if defined(DEBUG)
    , mResolved(false)
#endif // defined(DEBUG)
  {
    MOZ_ASSERT(NS_IsMainThread());
  }

  /**
   * Fail, asynchronously.
   */
  void Fail(const nsACString& aOperation,
            already_AddRefed<AbstractResult>&& aDiscardedResult,
            int32_t aOSError = 0) {
    Resolve();
    RefPtr<ErrorEvent> event = new ErrorEvent(mOnSuccess,
                                                mOnError,
                                                aDiscardedResult,
                                                aOperation,
                                                aOSError);
    nsresult rv = NS_DispatchToMainThread(event);
    if (NS_FAILED(rv)) {
      // Last ditch attempt to release on the main thread - some of
      // the members of event are not thread-safe, so letting the
      // pointer go out of scope would cause a crash.
      NS_ReleaseOnMainThreadSystemGroup("AbstractDoEvent::ErrorEvent",
                                        event.forget());
    }
  }

  /**
   * Succeed, asynchronously.
   */
  void Succeed(already_AddRefed<nsINativeOSFileResult>&& aResult) {
    Resolve();
    RefPtr<SuccessEvent> event = new SuccessEvent(mOnSuccess,
                                                    mOnError,
                                                    aResult);
    nsresult rv = NS_DispatchToMainThread(event);
    if (NS_FAILED(rv)) {
      // Last ditch attempt to release on the main thread - some of
      // the members of event are not thread-safe, so letting the
      // pointer go out of scope would cause a crash.
      NS_ReleaseOnMainThreadSystemGroup("AbstractDoEvent::SuccessEvent",
                                        event.forget());
    }

  }

private:

  /**
   * Mark the event as complete, for debugging purposes.
   */
  void Resolve() {
#if defined(DEBUG)
    MOZ_ASSERT(!mResolved);
    mResolved = true;
#endif // defined(DEBUG)
  }

private:
  nsMainThreadPtrHandle<nsINativeOSFileSuccessCallback> mOnSuccess;
  nsMainThreadPtrHandle<nsINativeOSFileErrorCallback> mOnError;
#if defined(DEBUG)
  // |true| once the action is complete
  bool mResolved;
#endif // defined(DEBUG)
};

/**
 * An abstract event implementing reading from a file.
 *
 * Concrete subclasses are responsible for handling the
 * data obtained from the file and possibly post-processing it.
 */
class AbstractReadEvent: public AbstractDoEvent {
public:
  /**
   * @param aPath The path of the file.
   */
  AbstractReadEvent(const nsAString& aPath,
                    const uint64_t aBytes,
                    nsMainThreadPtrHandle<nsINativeOSFileSuccessCallback>& aOnSuccess,
                    nsMainThreadPtrHandle<nsINativeOSFileErrorCallback>& aOnError)
    : AbstractDoEvent(aOnSuccess, aOnError)
    , mPath(aPath)
    , mBytes(aBytes)
  {
    MOZ_ASSERT(NS_IsMainThread());
  }

  NS_IMETHOD Run() override {
    MOZ_ASSERT(!NS_IsMainThread());
    TimeStamp dispatchDate = TimeStamp::Now();

    nsresult rv = BeforeRead();
    if (NS_FAILED(rv)) {
      // Error reporting is handled by BeforeRead();
      return NS_OK;
    }

    ScopedArrayBufferContents buffer;
    rv = Read(buffer);
    if (NS_FAILED(rv)) {
      // Error reporting is handled by Read();
      return NS_OK;
    }

    AfterRead(dispatchDate, buffer);
    return NS_OK;
  }

 private:
  /**
   * Read synchronously.
   *
   * Must be called off the main thread.
   *
   * @param aBuffer The destination buffer.
   */
  nsresult Read(ScopedArrayBufferContents& aBuffer)
  {
    MOZ_ASSERT(!NS_IsMainThread());

    ScopedPRFileDesc file;
#if defined(XP_WIN)
    // On Windows, we can't use PR_OpenFile because it doesn't
    // handle UTF-16 encoding, which is pretty bad. In addition,
    // PR_OpenFile opens files without sharing, which is not the
    // general semantics of OS.File.
    HANDLE handle =
      ::CreateFileW(mPath.get(),
                    GENERIC_READ,
                    FILE_SHARE_READ | FILE_SHARE_WRITE | FILE_SHARE_DELETE,
                    /*Security attributes*/nullptr,
                    OPEN_EXISTING,
                    FILE_ATTRIBUTE_NORMAL | FILE_FLAG_SEQUENTIAL_SCAN,
                    /*Template file*/ nullptr);

    if (handle == INVALID_HANDLE_VALUE) {
      Fail(NS_LITERAL_CSTRING("open"), nullptr, ::GetLastError());
      return NS_ERROR_FAILURE;
    }

    file = PR_ImportFile((PROsfd)handle);
    if (!file) {
      // |file| is closed by PR_ImportFile
      Fail(NS_LITERAL_CSTRING("ImportFile"), nullptr, PR_GetOSError());
      return NS_ERROR_FAILURE;
    }

#else
    // On other platforms, PR_OpenFile will do.
    NS_ConvertUTF16toUTF8 path(mPath);
    file = PR_OpenFile(path.get(), PR_RDONLY, 0);
    if (!file) {
      Fail(NS_LITERAL_CSTRING("open"), nullptr, PR_GetOSError());
      return NS_ERROR_FAILURE;
    }

#endif // defined(XP_XIN)

    PRFileInfo64 stat;
    if (PR_GetOpenFileInfo64(file, &stat) != PR_SUCCESS) {
      Fail(NS_LITERAL_CSTRING("stat"), nullptr, PR_GetOSError());
      return NS_ERROR_FAILURE;
    }

    uint64_t bytes = std::min((uint64_t)stat.size, mBytes);
    if (bytes > UINT32_MAX) {
      Fail(NS_LITERAL_CSTRING("Arithmetics"), nullptr, OS_ERROR_INVAL);
      return NS_ERROR_FAILURE;
    }

    if (!aBuffer.Allocate(bytes)) {
      Fail(NS_LITERAL_CSTRING("allocate"), nullptr, OS_ERROR_NOMEM);
      return NS_ERROR_FAILURE;
    }

    uint64_t total_read = 0;
    int32_t just_read = 0;
    char* dest_chars = reinterpret_cast<char*>(aBuffer.rwget().data);
    do {
      just_read = PR_Read(file, dest_chars + total_read,
                          std::min(uint64_t(PR_INT32_MAX), bytes - total_read));
      if (just_read == -1) {
        Fail(NS_LITERAL_CSTRING("read"), nullptr, PR_GetOSError());
        return NS_ERROR_FAILURE;
      }
      total_read += just_read;
    } while (just_read != 0 && total_read < bytes);
    if (total_read != bytes) {
      // We seem to have a race condition here.
      Fail(NS_LITERAL_CSTRING("read"), nullptr, OS_ERROR_RACE);
      return NS_ERROR_FAILURE;
    }

    return NS_OK;
  }

protected:
  /**
   * Any steps that need to be taken before reading.
   *
   * In case of error, this method should call Fail() and return
   * a failure code.
   */
  virtual
  nsresult BeforeRead() {
    return NS_OK;
  }

  /**
   * Proceed after reading.
   */
  virtual
  void AfterRead(TimeStamp aDispatchDate, ScopedArrayBufferContents& aBuffer) = 0;

 protected:
  const nsString mPath;
  const uint64_t mBytes;
};

/**
 * An implementation of a Read event that provides the data
 * as a TypedArray.
 */
class DoReadToTypedArrayEvent final : public AbstractReadEvent {
public:
  DoReadToTypedArrayEvent(const nsAString& aPath,
                          const uint32_t aBytes,
                          nsMainThreadPtrHandle<nsINativeOSFileSuccessCallback>& aOnSuccess,
                          nsMainThreadPtrHandle<nsINativeOSFileErrorCallback>& aOnError)
    : AbstractReadEvent(aPath, aBytes,
                        aOnSuccess, aOnError)
    , mResult(new TypedArrayResult(TimeStamp::Now()))
  { }

  ~DoReadToTypedArrayEvent() override {
    // If AbstractReadEvent::Run() has bailed out, we may need to cleanup
    // mResult, which is main-thread only data
    if (!mResult) {
      return;
    }
    NS_ReleaseOnMainThreadSystemGroup("DoReadToTypedArrayEvent::mResult",
                                      mResult.forget());
  }

protected:
  void AfterRead(TimeStamp aDispatchDate,
                 ScopedArrayBufferContents& aBuffer) override {
    MOZ_ASSERT(!NS_IsMainThread());
    mResult->Init(aDispatchDate, TimeStamp::Now() - aDispatchDate, aBuffer.forget());
    Succeed(mResult.forget());
  }

 private:
  RefPtr<TypedArrayResult> mResult;
};

/**
 * An implementation of a Read event that provides the data
 * as a JavaScript string.
 */
class DoReadToStringEvent final : public AbstractReadEvent {
public:
  DoReadToStringEvent(const nsAString& aPath,
                      const nsACString& aEncoding,
                      const uint32_t aBytes,
                      nsMainThreadPtrHandle<nsINativeOSFileSuccessCallback>& aOnSuccess,
                      nsMainThreadPtrHandle<nsINativeOSFileErrorCallback>& aOnError)
    : AbstractReadEvent(aPath, aBytes, aOnSuccess, aOnError)
    , mEncoding(aEncoding)
    , mResult(new StringResult(TimeStamp::Now()))
  { }

  ~DoReadToStringEvent() override {
    // If AbstraactReadEvent::Run() has bailed out, we may need to cleanup
    // mResult, which is main-thread only data
    if (!mResult) {
      return;
    }
    NS_ReleaseOnMainThreadSystemGroup("DoReadToStringEvent::mResult",
                                      mResult.forget());
  }

protected:
  nsresult BeforeRead() override {
    // Obtain the decoder. We do this before reading to avoid doing
    // any unnecessary I/O in case the name of the encoding is incorrect.
    MOZ_ASSERT(!NS_IsMainThread());
    const Encoding* encoding = Encoding::ForLabel(mEncoding);
    if (!encoding) {
      Fail(NS_LITERAL_CSTRING("Decode"), mResult.forget(), OS_ERROR_INVAL);
      return NS_ERROR_FAILURE;
    }
    mDecoder = encoding->NewDecoderWithBOMRemoval();
    if (!mDecoder) {
      Fail(NS_LITERAL_CSTRING("DecoderForEncoding"), mResult.forget(), OS_ERROR_INVAL);
      return NS_ERROR_FAILURE;
    }

    return NS_OK;
  }

  void AfterRead(TimeStamp aDispatchDate,
                 ScopedArrayBufferContents& aBuffer) override {
    MOZ_ASSERT(!NS_IsMainThread());

    auto src = MakeSpan(aBuffer.get().data, aBuffer.get().nbytes);

    CheckedInt<size_t> needed = mDecoder->MaxUTF16BufferLength(src.Length());
    if (!needed.isValid() ||
        needed.value() > MaxValue<nsAString::size_type>::value) {
      Fail(NS_LITERAL_CSTRING("arithmetics"), mResult.forget(), OS_ERROR_TOO_LARGE);
      return;
    }

    nsString resultString;
    bool ok = resultString.SetLength(needed.value(), fallible);
    if (!ok) {
      Fail(NS_LITERAL_CSTRING("allocation"), mResult.forget(), OS_ERROR_TOO_LARGE);
      return;
    }

    // Yoric said on IRC that this method is normally called for the entire file,
    // but that's not guaranteed. Retaining the bug that EOF in conversion isn't
    // handled anywhere.
    uint32_t result;
    size_t read;
    size_t written;
    bool hadErrors;
    Tie(result, read, written, hadErrors) =
      mDecoder->DecodeToUTF16(src, resultString, false);
    MOZ_ASSERT(result == kInputEmpty);
    MOZ_ASSERT(read == src.Length());
    MOZ_ASSERT(written <= needed.value());
    Unused << hadErrors;
    ok = resultString.SetLength(written, fallible);
    if (!ok) {
      Fail(
        NS_LITERAL_CSTRING("allocation"), mResult.forget(), OS_ERROR_TOO_LARGE);
      return;
    }

    mResult->Init(aDispatchDate, TimeStamp::Now() - aDispatchDate, resultString);
    Succeed(mResult.forget());
  }

 private:
  nsCString mEncoding;
  mozilla::UniquePtr<mozilla::Decoder> mDecoder;
  RefPtr<StringResult> mResult;
};

} // namespace

// The OS.File service

NS_IMPL_ISUPPORTS(NativeOSFileInternalsService, nsINativeOSFileInternalsService);

NS_IMETHODIMP
NativeOSFileInternalsService::Read(const nsAString& aPath,
                                   JS::HandleValue aOptions,
                                   nsINativeOSFileSuccessCallback *aOnSuccess,
                                   nsINativeOSFileErrorCallback *aOnError,
                                   JSContext* cx)
{
  // Extract options
  nsCString encoding;
  uint64_t bytes = UINT64_MAX;

  if (aOptions.isObject()) {
    dom::NativeOSFileReadOptions dict;
    if (!dict.Init(cx, aOptions)) {
      return NS_ERROR_INVALID_ARG;
    }

    if (dict.mEncoding.WasPassed()) {
      CopyUTF16toUTF8(dict.mEncoding.Value(), encoding);
    }

    if (dict.mBytes.WasPassed() && !dict.mBytes.Value().IsNull()) {
      bytes = dict.mBytes.Value().Value();
    }
  }

  // Prepare the off main thread event and dispatch it
  nsCOMPtr<nsINativeOSFileSuccessCallback> onSuccess(aOnSuccess);
  nsMainThreadPtrHandle<nsINativeOSFileSuccessCallback> onSuccessHandle(
    new nsMainThreadPtrHolder<nsINativeOSFileSuccessCallback>(
      "nsINativeOSFileSuccessCallback", onSuccess));
  nsCOMPtr<nsINativeOSFileErrorCallback> onError(aOnError);
  nsMainThreadPtrHandle<nsINativeOSFileErrorCallback> onErrorHandle(
    new nsMainThreadPtrHolder<nsINativeOSFileErrorCallback>(
      "nsINativeOSFileErrorCallback", onError));

  RefPtr<AbstractDoEvent> event;
  if (encoding.IsEmpty()) {
    event = new DoReadToTypedArrayEvent(aPath, bytes,
                                        onSuccessHandle,
                                        onErrorHandle);
  } else {
    event = new DoReadToStringEvent(aPath, encoding, bytes,
                                    onSuccessHandle,
                                    onErrorHandle);
  }

  nsresult rv;
  nsCOMPtr<nsIEventTarget> target = do_GetService(NS_STREAMTRANSPORTSERVICE_CONTRACTID, &rv);

  if (NS_FAILED(rv)) {
    return rv;
  }
  return target->Dispatch(event, NS_DISPATCH_NORMAL);
}

} // namespace mozilla
