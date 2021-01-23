/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "ScriptPreloader-inl.h"
#include "mozilla/ScriptPreloader.h"
#include "mozilla/loader/ScriptCacheActors.h"

#include "mozilla/URLPreloader.h"

#include "mozilla/ArrayUtils.h"
#include "mozilla/ClearOnShutdown.h"
#include "mozilla/Components.h"
#include "mozilla/FileUtils.h"
#include "mozilla/IOBuffers.h"
#include "mozilla/Logging.h"
#include "mozilla/ScopeExit.h"
#include "mozilla/Services.h"
#include "mozilla/Telemetry.h"
#include "mozilla/Unused.h"
#include "mozilla/dom/ContentChild.h"
#include "mozilla/dom/ContentParent.h"

#include "MainThreadUtils.h"
#include "nsDebug.h"
#include "nsDirectoryServiceUtils.h"
#include "nsIFile.h"
#include "nsIObserverService.h"
#include "nsJSUtils.h"
#include "nsMemoryReporterManager.h"
#include "nsNetUtil.h"
#include "nsProxyRelease.h"
#include "nsThreadUtils.h"
#include "nsXULAppAPI.h"
#include "xpcpublic.h"

#define STARTUP_COMPLETE_TOPIC "browser-delayed-startup-finished"
#define DOC_ELEM_INSERTED_TOPIC "document-element-inserted"
#define CONTENT_DOCUMENT_LOADED_TOPIC "content-document-loaded"
#define CACHE_WRITE_TOPIC "browser-idle-startup-tasks-finished"
#define CLEANUP_TOPIC "xpcom-shutdown"
#define CACHE_INVALIDATE_TOPIC "startupcache-invalidate"

// The maximum time we'll wait for a child process to finish starting up before
// we send its script data back to the parent.
constexpr uint32_t CHILD_STARTUP_TIMEOUT_MS = 8000;

namespace mozilla {
namespace {
static LazyLogModule gLog("ScriptPreloader");

#define LOG(level, ...) MOZ_LOG(gLog, LogLevel::level, (__VA_ARGS__))
}  // namespace

using mozilla::dom::AutoJSAPI;
using mozilla::dom::ContentChild;
using mozilla::dom::ContentParent;
using namespace mozilla::loader;

ProcessType ScriptPreloader::sProcessType;

nsresult ScriptPreloader::CollectReports(nsIHandleReportCallback* aHandleReport,
                                         nsISupports* aData, bool aAnonymize) {
  MOZ_COLLECT_REPORT(
      "explicit/script-preloader/heap/saved-scripts", KIND_HEAP, UNITS_BYTES,
      SizeOfHashEntries<ScriptStatus::Saved>(mScripts, MallocSizeOf),
      "Memory used to hold the scripts which have been executed in this "
      "session, and will be written to the startup script cache file.");

  MOZ_COLLECT_REPORT(
      "explicit/script-preloader/heap/restored-scripts", KIND_HEAP, UNITS_BYTES,
      SizeOfHashEntries<ScriptStatus::Restored>(mScripts, MallocSizeOf),
      "Memory used to hold the scripts which have been restored from the "
      "startup script cache file, but have not been executed in this session.");

  MOZ_COLLECT_REPORT("explicit/script-preloader/heap/other", KIND_HEAP,
                     UNITS_BYTES, ShallowHeapSizeOfIncludingThis(MallocSizeOf),
                     "Memory used by the script cache service itself.");

  // Since the mem-mapped cache file is mapped into memory, we want to report
  // it as explicit memory somewhere. But since the child cache is shared
  // between all processes, we don't want to report it as explicit memory for
  // all of them. So we report it as explicit only in the parent process, and
  // non-explicit everywhere else.
  if (XRE_IsParentProcess()) {
    MOZ_COLLECT_REPORT("explicit/script-preloader/non-heap/memmapped-cache",
                       KIND_NONHEAP, UNITS_BYTES,
                       mCacheData.nonHeapSizeOfExcludingThis(),
                       "The memory-mapped startup script cache file.");
  } else {
    MOZ_COLLECT_REPORT("script-preloader-memmapped-cache", KIND_NONHEAP,
                       UNITS_BYTES, mCacheData.nonHeapSizeOfExcludingThis(),
                       "The memory-mapped startup script cache file.");
  }

  return NS_OK;
}

ScriptPreloader& ScriptPreloader::GetSingleton() {
  static RefPtr<ScriptPreloader> singleton;

  if (!singleton) {
    if (XRE_IsParentProcess()) {
      singleton = new ScriptPreloader();
      singleton->mChildCache = &GetChildSingleton();
      Unused << singleton->InitCache();
    } else {
      singleton = &GetChildSingleton();
    }

    ClearOnShutdown(&singleton);
  }

  return *singleton;
}

// The child singleton is available in all processes, including the parent, and
// is used for scripts which are expected to be loaded into child processes
// (such as process and frame scripts), or scripts that have already been loaded
// into a child. The child caches are managed as follows:
//
// - Every startup, we open the cache file from the last session, move it to a
//  new location, and begin pre-loading the scripts that are stored in it. There
//  is a separate cache file for parent and content processes, but the parent
//  process opens both the parent and content cache files.
//
// - Once startup is complete, we write a new cache file for the next session,
//   containing only the scripts that were used during early startup, so we
//   don't waste pre-loading scripts that may not be needed.
//
// - For content processes, opening and writing the cache file is handled in the
//  parent process. The first content process of each type sends back the data
//  for scripts that were loaded in early startup, and the parent merges them
//  and writes them to a cache file.
//
// - Currently, content processes only benefit from the cache data written
//  during the *previous* session. Ideally, new content processes should
//  probably use the cache data written during this session if there was no
//  previous cache file, but I'd rather do that as a follow-up.
ScriptPreloader& ScriptPreloader::GetChildSingleton() {
  static RefPtr<ScriptPreloader> singleton;

  if (!singleton) {
    singleton = new ScriptPreloader();
    if (XRE_IsParentProcess()) {
      Unused << singleton->InitCache(NS_LITERAL_STRING("scriptCache-child"));
    }
    ClearOnShutdown(&singleton);
  }

  return *singleton;
}

void ScriptPreloader::InitContentChild(ContentParent& parent) {
  auto& cache = GetChildSingleton();

  // We want startup script data from the first process of a given type.
  // That process sends back its script data before it executes any
  // untrusted code, and then we never accept further script data for that
  // type of process for the rest of the session.
  //
  // The script data from each process type is merged with the data from the
  // parent process's frame and process scripts, and shared between all
  // content process types in the next session.
  //
  // Note that if the first process of a given type crashes or shuts down
  // before sending us its script data, we silently ignore it, and data for
  // that process type is not included in the next session's cache. This
  // should be a sufficiently rare occurrence that it's not worth trying to
  // handle specially.
  auto processType = GetChildProcessType(parent.GetRemoteType());
  bool wantScriptData = !cache.mInitializedProcesses.contains(processType);
  cache.mInitializedProcesses += processType;

  auto fd = cache.mCacheData.cloneFileDescriptor();
  // Don't send original cache data to new processes if the cache has been
  // invalidated.
  if (fd.IsValid() && !cache.mCacheInvalidated) {
    Unused << parent.SendPScriptCacheConstructor(fd, wantScriptData);
  } else {
    Unused << parent.SendPScriptCacheConstructor(NS_ERROR_FILE_NOT_FOUND,
                                                 wantScriptData);
  }
}

ProcessType ScriptPreloader::GetChildProcessType(const nsAString& remoteType) {
  if (remoteType.EqualsLiteral(EXTENSION_REMOTE_TYPE)) {
    return ProcessType::Extension;
  }
  if (remoteType.EqualsLiteral(PRIVILEGEDABOUT_REMOTE_TYPE)) {
    return ProcessType::PrivilegedAbout;
  }
  return ProcessType::Web;
}

namespace {

static void TraceOp(JSTracer* trc, void* data) {
  auto preloader = static_cast<ScriptPreloader*>(data);

  preloader->Trace(trc);
}

}  // anonymous namespace

void ScriptPreloader::Trace(JSTracer* trc) {
  for (auto& script : IterHash(mScripts)) {
    JS::TraceEdge(trc, &script->mScript,
                  "ScriptPreloader::CachedScript.mScript");
  }
}

ScriptPreloader::ScriptPreloader()
    : mMonitor("[ScriptPreloader.mMonitor]"),
      mSaveMonitor("[ScriptPreloader.mSaveMonitor]") {
  // We do not set the process type for child processes here because the
  // remoteType in ContentChild is not ready yet.
  if (XRE_IsParentProcess()) {
    sProcessType = ProcessType::Parent;
  }

  nsCOMPtr<nsIObserverService> obs = services::GetObserverService();
  MOZ_RELEASE_ASSERT(obs);

  if (XRE_IsParentProcess()) {
    // In the parent process, we want to freeze the script cache as soon
    // as idle tasks for the first browser window have completed.
    obs->AddObserver(this, STARTUP_COMPLETE_TOPIC, false);
    obs->AddObserver(this, CACHE_WRITE_TOPIC, false);
  }

  obs->AddObserver(this, CLEANUP_TOPIC, false);
  obs->AddObserver(this, CACHE_INVALIDATE_TOPIC, false);

  AutoSafeJSAPI jsapi;
  JS_AddExtraGCRootsTracer(jsapi.cx(), TraceOp, this);
}

void ScriptPreloader::Cleanup() {
  // Wait for any pending parses to finish before clearing the mScripts
  // hashtable, since the parse tasks depend on memory allocated by those
  // scripts.
  {
    MonitorAutoLock mal(mMonitor);
    FinishPendingParses(mal);

    mScripts.Clear();
  }

  AutoSafeJSAPI jsapi;
  JS_RemoveExtraGCRootsTracer(jsapi.cx(), TraceOp, this);

  UnregisterWeakMemoryReporter(this);
}

void ScriptPreloader::StartCacheWrite() {
  MOZ_ASSERT(!mSaveThread);

  Unused << NS_NewNamedThread("SaveScripts", getter_AddRefs(mSaveThread), this);

  nsCOMPtr<nsIAsyncShutdownClient> barrier = GetShutdownBarrier();
  barrier->AddBlocker(this, NS_LITERAL_STRING(__FILE__), __LINE__,
                      EmptyString());
}

void ScriptPreloader::InvalidateCache() {
  mMonitor.AssertNotCurrentThreadOwns();
  MonitorAutoLock mal(mMonitor);

  mCacheInvalidated = true;

  // Wait for pending off-thread parses to finish, since they depend on the
  // memory allocated by our CachedScripts, and can't be canceled
  // asynchronously.
  FinishPendingParses(mal);

  // Pending scripts should have been cleared by the above, and new parses
  // should not have been queued.
  MOZ_ASSERT(mParsingScripts.empty());
  MOZ_ASSERT(mParsingSources.empty());
  MOZ_ASSERT(mPendingScripts.isEmpty());

  for (auto& script : IterHash(mScripts)) {
    script.Remove();
  }

  // If we've already finished saving the cache at this point, start a new
  // delayed save operation. This will write out an empty cache file in place
  // of any cache file we've already written out this session, which will
  // prevent us from falling back to the current session's cache file on the
  // next startup.
  if (mSaveComplete && mChildCache) {
    mSaveComplete = false;

    StartCacheWrite();
  }
}

nsresult ScriptPreloader::Observe(nsISupports* subject, const char* topic,
                                  const char16_t* data) {
  nsCOMPtr<nsIObserverService> obs = services::GetObserverService();
  if (!strcmp(topic, STARTUP_COMPLETE_TOPIC)) {
    obs->RemoveObserver(this, STARTUP_COMPLETE_TOPIC);

    MOZ_ASSERT(XRE_IsParentProcess());

    mStartupFinished = true;
  } else if (!strcmp(topic, CACHE_WRITE_TOPIC)) {
    obs->RemoveObserver(this, CACHE_WRITE_TOPIC);

    MOZ_ASSERT(mStartupFinished);
    MOZ_ASSERT(XRE_IsParentProcess());

    if (mChildCache) {
      StartCacheWrite();
    }
  } else if (mContentStartupFinishedTopic.Equals(topic)) {
    // If this is an uninitialized about:blank viewer or a chrome: document
    // (which should always be an XBL binding document), ignore it. We don't
    // have to worry about it loading malicious content.
    if (nsCOMPtr<dom::Document> doc = do_QueryInterface(subject)) {
      nsCOMPtr<nsIURI> uri = doc->GetDocumentURI();

      if ((NS_IsAboutBlank(uri) &&
           doc->GetReadyStateEnum() == doc->READYSTATE_UNINITIALIZED) ||
          uri->SchemeIs("chrome")) {
        return NS_OK;
      }
    }
    FinishContentStartup();
  } else if (!strcmp(topic, "timer-callback")) {
    FinishContentStartup();
  } else if (!strcmp(topic, CLEANUP_TOPIC)) {
    Cleanup();
  } else if (!strcmp(topic, CACHE_INVALIDATE_TOPIC)) {
    InvalidateCache();
  }

  return NS_OK;
}

void ScriptPreloader::FinishContentStartup() {
  MOZ_ASSERT(XRE_IsContentProcess());

#ifdef DEBUG
  if (mContentStartupFinishedTopic.Equals(CONTENT_DOCUMENT_LOADED_TOPIC)) {
    MOZ_ASSERT(sProcessType == ProcessType::PrivilegedAbout);
  } else {
    MOZ_ASSERT(sProcessType != ProcessType::PrivilegedAbout);
  }
#endif /* DEBUG */

  nsCOMPtr<nsIObserverService> obs = services::GetObserverService();
  obs->RemoveObserver(this, mContentStartupFinishedTopic.get());

  mSaveTimer = nullptr;

  mStartupFinished = true;

  if (mChildActor) {
    mChildActor->SendScriptsAndFinalize(mScripts);
  }

#ifdef XP_WIN
  // Record the amount of USS at startup. This is Windows-only for now,
  // we could turn it on for Linux relatively cheaply. On macOS it can have
  // a perf impact.
  mozilla::Telemetry::Accumulate(
      mozilla::Telemetry::MEMORY_UNIQUE_CONTENT_STARTUP,
      nsMemoryReporterManager::ResidentUnique() / 1024);
#endif
}

bool ScriptPreloader::WillWriteScripts() {
  return !mDataPrepared && (XRE_IsParentProcess() || mChildActor);
}

Result<nsCOMPtr<nsIFile>, nsresult> ScriptPreloader::GetCacheFile(
    const nsAString& suffix) {
  NS_ENSURE_TRUE(mProfD, Err(NS_ERROR_NOT_INITIALIZED));

  nsCOMPtr<nsIFile> cacheFile;
  MOZ_TRY(mProfD->Clone(getter_AddRefs(cacheFile)));

  MOZ_TRY(cacheFile->AppendNative(NS_LITERAL_CSTRING("startupCache")));
  Unused << cacheFile->Create(nsIFile::DIRECTORY_TYPE, 0777);

  MOZ_TRY(cacheFile->Append(mBaseName + suffix));

  return std::move(cacheFile);
}

static const uint8_t MAGIC[] = "mozXDRcachev002";

Result<Ok, nsresult> ScriptPreloader::OpenCache() {
  MOZ_TRY(NS_GetSpecialDirectory("ProfLDS", getter_AddRefs(mProfD)));

  nsCOMPtr<nsIFile> cacheFile;
  MOZ_TRY_VAR(cacheFile, GetCacheFile(NS_LITERAL_STRING(".bin")));

  bool exists;
  MOZ_TRY(cacheFile->Exists(&exists));
  if (exists) {
    MOZ_TRY(cacheFile->MoveTo(nullptr,
                              mBaseName + NS_LITERAL_STRING("-current.bin")));
  } else {
    MOZ_TRY(
        cacheFile->SetLeafName(mBaseName + NS_LITERAL_STRING("-current.bin")));
    MOZ_TRY(cacheFile->Exists(&exists));
    if (!exists) {
      return Err(NS_ERROR_FILE_NOT_FOUND);
    }
  }

  MOZ_TRY(mCacheData.init(cacheFile));

  return Ok();
}

// Opens the script cache file for this session, and initializes the script
// cache based on its contents. See WriteCache for details of the cache file.
Result<Ok, nsresult> ScriptPreloader::InitCache(const nsAString& basePath) {
  mCacheInitialized = true;
  mBaseName = basePath;

  RegisterWeakMemoryReporter(this);

  if (!XRE_IsParentProcess()) {
    return Ok();
  }

  // Grab the compilation scope before initializing the URLPreloader, since
  // it's not safe to run component loader code during its critical section.
  AutoSafeJSAPI jsapi;
  JS::RootedObject scope(jsapi.cx(), xpc::CompilationScope());

  // Note: Code on the main thread *must not access Omnijar in any way* until
  // this AutoBeginReading guard is destroyed.
  URLPreloader::AutoBeginReading abr;

  MOZ_TRY(OpenCache());

  return InitCacheInternal(scope);
}

Result<Ok, nsresult> ScriptPreloader::InitCache(
    const Maybe<ipc::FileDescriptor>& cacheFile, ScriptCacheChild* cacheChild) {
  MOZ_ASSERT(XRE_IsContentProcess());

  mCacheInitialized = true;
  mChildActor = cacheChild;
  sProcessType =
      GetChildProcessType(dom::ContentChild::GetSingleton()->GetRemoteType());

  nsCOMPtr<nsIObserverService> obs = services::GetObserverService();
  MOZ_RELEASE_ASSERT(obs);

  if (sProcessType == ProcessType::PrivilegedAbout) {
    // Since we control all of the documents loaded in the privileged
    // content process, we can increase the window of active time for the
    // ScriptPreloader to include the scripts that are loaded until the
    // first document finishes loading.
    mContentStartupFinishedTopic.AssignLiteral(CONTENT_DOCUMENT_LOADED_TOPIC);
  } else {
    // In the child process, we need to freeze the script cache before any
    // untrusted code has been executed. The insertion of the first DOM
    // document element may sometimes be earlier than is ideal, but at
    // least it should always be safe.
    mContentStartupFinishedTopic.AssignLiteral(DOC_ELEM_INSERTED_TOPIC);
  }
  obs->AddObserver(this, mContentStartupFinishedTopic.get(), false);

  RegisterWeakMemoryReporter(this);

  auto cleanup = MakeScopeExit([&] {
    // If the parent is expecting cache data from us, make sure we send it
    // before it writes out its cache file. For normal proceses, this isn't
    // a concern, since they begin loading documents quite early. For the
    // preloaded process, we may end up waiting a long time (or, indeed,
    // never loading a document), so we need an additional timeout.
    if (cacheChild) {
      NS_NewTimerWithObserver(getter_AddRefs(mSaveTimer), this,
                              CHILD_STARTUP_TIMEOUT_MS,
                              nsITimer::TYPE_ONE_SHOT);
    }
  });

  if (cacheFile.isNothing()) {
    return Ok();
  }

  MOZ_TRY(mCacheData.init(cacheFile.ref()));

  return InitCacheInternal();
}

Result<Ok, nsresult> ScriptPreloader::InitCacheInternal(
    JS::HandleObject scope) {
  auto size = mCacheData.size();

  uint32_t headerSize;
  if (size < sizeof(MAGIC) + sizeof(headerSize)) {
    return Err(NS_ERROR_UNEXPECTED);
  }

  auto data = mCacheData.get<uint8_t>();
  auto end = data + size;

  if (memcmp(MAGIC, data.get(), sizeof(MAGIC))) {
    return Err(NS_ERROR_UNEXPECTED);
  }
  data += sizeof(MAGIC);

  headerSize = LittleEndian::readUint32(data.get());
  data += sizeof(headerSize);

  if (data + headerSize > end) {
    return Err(NS_ERROR_UNEXPECTED);
  }

  {
    auto cleanup = MakeScopeExit([&]() { mScripts.Clear(); });

    LinkedList<CachedScript> scripts;

    Range<uint8_t> header(data, data + headerSize);
    data += headerSize;

    InputBuffer buf(header);

    size_t offset = 0;
    while (!buf.finished()) {
      auto script = MakeUnique<CachedScript>(*this, buf);
      MOZ_RELEASE_ASSERT(script);

      auto scriptData = data + script->mOffset;
      if (scriptData + script->mSize > end) {
        return Err(NS_ERROR_UNEXPECTED);
      }

      // Make sure offsets match what we'd expect based on script ordering and
      // size, as a basic sanity check.
      if (script->mOffset != offset) {
        return Err(NS_ERROR_UNEXPECTED);
      }
      offset += script->mSize;

      script->mXDRRange.emplace(scriptData, scriptData + script->mSize);

      // Don't pre-decode the script unless it was used in this process type
      // during the previous session.
      if (script->mOriginalProcessTypes.contains(CurrentProcessType())) {
        scripts.insertBack(script.get());
      } else {
        script->mReadyToExecute = true;
      }

      mScripts.Put(script->mCachePath, script.get());
      Unused << script.release();
    }

    if (buf.error()) {
      return Err(NS_ERROR_UNEXPECTED);
    }

    mPendingScripts = std::move(scripts);
    cleanup.release();
  }

  DecodeNextBatch(OFF_THREAD_FIRST_CHUNK_SIZE, scope);
  return Ok();
}

void ScriptPreloader::PrepareCacheWriteInternal() {
  MOZ_ASSERT(NS_IsMainThread());

  mMonitor.AssertCurrentThreadOwns();

  auto cleanup = MakeScopeExit([&]() {
    if (mChildCache) {
      mChildCache->PrepareCacheWrite();
    }
  });

  if (mDataPrepared) {
    return;
  }

  AutoSafeJSAPI jsapi;
  bool found = false;
  for (auto& script : IterHash(mScripts, Match<ScriptStatus::Saved>())) {
    // Don't write any scripts that are also in the child cache. They'll be
    // loaded from the child cache in that case, so there's no need to write
    // them twice.
    CachedScript* childScript =
        mChildCache ? mChildCache->mScripts.Get(script->mCachePath) : nullptr;
    if (childScript && !childScript->mProcessTypes.isEmpty()) {
      childScript->UpdateLoadTime(script->mLoadTime);
      childScript->mProcessTypes += script->mProcessTypes;
      script.Remove();
      continue;
    }

    if (!(script->mProcessTypes == script->mOriginalProcessTypes)) {
      // Note: EnumSet doesn't support operator!=, hence the weird form above.
      found = true;
    }

    if (!script->mSize && !script->XDREncode(jsapi.cx())) {
      script.Remove();
    }
  }

  if (!found) {
    mSaveComplete = true;
    return;
  }

  mDataPrepared = true;
}

void ScriptPreloader::PrepareCacheWrite() {
  MonitorAutoLock mal(mMonitor);

  PrepareCacheWriteInternal();
}

// Writes out a script cache file for the scripts accessed during early
// startup in this session. The cache file is a little-endian binary file with
// the following format:
//
// - A uint32 containing the size of the header block.
//
// - A header entry for each file stored in the cache containing:
//   - The URL that the script was originally read from.
//   - Its cache key.
//   - The offset of its XDR data within the XDR data block.
//   - The size of its XDR data in the XDR data block.
//   - A bit field describing which process types the script is used in.
//
// - A block of XDR data for the encoded scripts, with each script's data at
//   an offset from the start of the block, as specified above.
Result<Ok, nsresult> ScriptPreloader::WriteCache() {
  MOZ_ASSERT(!NS_IsMainThread());

  if (!mDataPrepared && !mSaveComplete) {
    MonitorAutoUnlock mau(mSaveMonitor);

    NS_DispatchToMainThread(
        NewRunnableMethod("ScriptPreloader::PrepareCacheWrite", this,
                          &ScriptPreloader::PrepareCacheWrite),
        NS_DISPATCH_SYNC);
  }

  if (mSaveComplete) {
    // If we don't have anything we need to save, we're done.
    return Ok();
  }

  nsCOMPtr<nsIFile> cacheFile;
  MOZ_TRY_VAR(cacheFile, GetCacheFile(NS_LITERAL_STRING("-new.bin")));

  bool exists;
  MOZ_TRY(cacheFile->Exists(&exists));
  if (exists) {
    MOZ_TRY(cacheFile->Remove(false));
  }

  {
    AutoFDClose fd;
    MOZ_TRY(cacheFile->OpenNSPRFileDesc(PR_WRONLY | PR_CREATE_FILE, 0644,
                                        &fd.rwget()));

    // We also need to hold mMonitor while we're touching scripts in
    // mScripts, or they may be freed before we're done with them.
    mMonitor.AssertNotCurrentThreadOwns();
    MonitorAutoLock mal(mMonitor);

    nsTArray<CachedScript*> scripts;
    for (auto& script : IterHash(mScripts, Match<ScriptStatus::Saved>())) {
      scripts.AppendElement(script);
    }

    // Sort scripts by load time, with async loaded scripts before sync scripts.
    // Since async scripts are always loaded immediately at startup, it helps to
    // have them stored contiguously.
    scripts.Sort(CachedScript::Comparator());

    OutputBuffer buf;
    size_t offset = 0;
    for (auto script : scripts) {
      script->mOffset = offset;
      script->Code(buf);

      offset += script->mSize;
    }

    uint8_t headerSize[4];
    LittleEndian::writeUint32(headerSize, buf.cursor());

    MOZ_TRY(Write(fd, MAGIC, sizeof(MAGIC)));
    MOZ_TRY(Write(fd, headerSize, sizeof(headerSize)));
    MOZ_TRY(Write(fd, buf.Get(), buf.cursor()));
    for (auto script : scripts) {
      MOZ_TRY(Write(fd, script->Range().begin().get(), script->mSize));

      if (script->mScript) {
        script->FreeData();
      }
    }
  }

  MOZ_TRY(cacheFile->MoveTo(nullptr, mBaseName + NS_LITERAL_STRING(".bin")));

  return Ok();
}

// Runs in the mSaveThread thread, and writes out the cache file for the next
// session after a reasonable delay.
nsresult ScriptPreloader::Run() {
  MonitorAutoLock mal(mSaveMonitor);

  // Ideally wait about 10 seconds before saving, to avoid unnecessary IO
  // during early startup. But only if the cache hasn't been invalidated,
  // since that can trigger a new write during shutdown, and we don't want to
  // cause shutdown hangs.
  if (!mCacheInvalidated) {
    mal.Wait(TimeDuration::FromSeconds(10));
  }

  auto result = URLPreloader::GetSingleton().WriteCache();
  Unused << NS_WARN_IF(result.isErr());

  result = WriteCache();
  Unused << NS_WARN_IF(result.isErr());

  result = mChildCache->WriteCache();
  Unused << NS_WARN_IF(result.isErr());

  NS_DispatchToMainThread(
      NewRunnableMethod("ScriptPreloader::CacheWriteComplete", this,
                        &ScriptPreloader::CacheWriteComplete),
      NS_DISPATCH_NORMAL);
  return NS_OK;
}

void ScriptPreloader::CacheWriteComplete() {
  mSaveThread->AsyncShutdown();
  mSaveThread = nullptr;
  mSaveComplete = true;

  nsCOMPtr<nsIAsyncShutdownClient> barrier = GetShutdownBarrier();
  barrier->RemoveBlocker(this);
}

void ScriptPreloader::NoteScript(const nsCString& url,
                                 const nsCString& cachePath,
                                 JS::HandleScript jsscript, bool isRunOnce) {
  if (!Active()) {
    if (isRunOnce) {
      if (auto script = mScripts.Get(cachePath)) {
        script->mIsRunOnce = true;
        script->MaybeDropScript();
      }
    }
    return;
  }

  // Don't bother trying to cache any URLs with cache-busting query
  // parameters.
  if (cachePath.FindChar('?') >= 0) {
    return;
  }

  // Don't bother caching files that belong to the mochitest harness.
  NS_NAMED_LITERAL_CSTRING(mochikitPrefix, "chrome://mochikit/");
  if (StringHead(url, mochikitPrefix.Length()) == mochikitPrefix) {
    return;
  }

  auto script =
      mScripts.LookupOrAdd(cachePath, *this, url, cachePath, jsscript);
  if (isRunOnce) {
    script->mIsRunOnce = true;
  }

  if (!script->MaybeDropScript() && !script->mScript) {
    MOZ_ASSERT(jsscript);
    script->mScript = jsscript;
    script->mReadyToExecute = true;
  }

  script->UpdateLoadTime(TimeStamp::Now());
  script->mProcessTypes += CurrentProcessType();
}

void ScriptPreloader::NoteScript(const nsCString& url,
                                 const nsCString& cachePath,
                                 ProcessType processType,
                                 nsTArray<uint8_t>&& xdrData,
                                 TimeStamp loadTime) {
  // After data has been prepared, there's no point in noting further scripts,
  // since the cache either has already been written, or is about to be
  // written. Any time prior to the data being prepared, we can safely mutate
  // mScripts without locking. After that point, the save thread is free to
  // access it, and we can't alter it without locking.
  if (mDataPrepared) {
    return;
  }

  auto script = mScripts.LookupOrAdd(cachePath, *this, url, cachePath, nullptr);

  if (!script->HasRange()) {
    MOZ_ASSERT(!script->HasArray());

    script->mSize = xdrData.Length();
    script->mXDRData.construct<nsTArray<uint8_t>>(
        std::forward<nsTArray<uint8_t>>(xdrData));

    auto& data = script->Array();
    script->mXDRRange.emplace(data.Elements(), data.Length());
  }

  if (!script->mSize && !script->mScript) {
    // If the content process is sending us a script entry for a script
    // which was in the cache at startup, it expects us to already have this
    // script data, so it doesn't send it.
    //
    // However, the cache may have been invalidated at this point (usually
    // due to the add-on manager installing or uninstalling a legacy
    // extension during very early startup), which means we may no longer
    // have an entry for this script. Since that means we have no data to
    // write to the new cache, and no JSScript to generate it from, we need
    // to discard this entry.
    mScripts.Remove(cachePath);
    return;
  }

  script->UpdateLoadTime(loadTime);
  script->mProcessTypes += processType;
}

JSScript* ScriptPreloader::GetCachedScript(JSContext* cx,
                                           const nsCString& path) {
  // If a script is used by both the parent and the child, it's stored only
  // in the child cache.
  if (mChildCache) {
    RootedScript script(cx, mChildCache->GetCachedScriptInternal(cx, path));
    if (script) {
      Telemetry::AccumulateCategorical(
          Telemetry::LABELS_SCRIPT_PRELOADER_REQUESTS::HitChild);
      return script;
    }
  }

  RootedScript script(cx, GetCachedScriptInternal(cx, path));
  Telemetry::AccumulateCategorical(
      script ? Telemetry::LABELS_SCRIPT_PRELOADER_REQUESTS::Hit
             : Telemetry::LABELS_SCRIPT_PRELOADER_REQUESTS::Miss);
  return script;
}

JSScript* ScriptPreloader::GetCachedScriptInternal(JSContext* cx,
                                                   const nsCString& path) {
  auto script = mScripts.Get(path);
  if (script) {
    return WaitForCachedScript(cx, script);
  }

  return nullptr;
}

JSScript* ScriptPreloader::WaitForCachedScript(JSContext* cx,
                                               CachedScript* script) {
  // Check for finished operations before locking so that we can move onto
  // decoding the next batch as soon as possible after the pending batch is
  // ready. If we wait until we hit an unfinished script, we wind up having at
  // most one batch of buffered scripts, and occasionally under-running that
  // buffer.
  MaybeFinishOffThreadDecode();

  if (!script->mReadyToExecute) {
    LOG(Info, "Must wait for async script load: %s\n", script->mURL.get());
    auto start = TimeStamp::Now();

    mMonitor.AssertNotCurrentThreadOwns();
    MonitorAutoLock mal(mMonitor);

    // Check for finished operations again *after* locking, or we may race
    // against mToken being set between our last check and the time we
    // entered the mutex.
    MaybeFinishOffThreadDecode();

    if (!script->mReadyToExecute &&
        script->mSize < MAX_MAINTHREAD_DECODE_SIZE) {
      LOG(Info, "Script is small enough to recompile on main thread\n");

      script->mReadyToExecute = true;
      Telemetry::ScalarAdd(
          Telemetry::ScalarID::SCRIPT_PRELOADER_MAINTHREAD_RECOMPILE, 1);
    } else {
      while (!script->mReadyToExecute) {
        mal.Wait();

        MonitorAutoUnlock mau(mMonitor);
        MaybeFinishOffThreadDecode();
      }
    }

    double waitedMS = (TimeStamp::Now() - start).ToMilliseconds();
    Telemetry::Accumulate(Telemetry::SCRIPT_PRELOADER_WAIT_TIME, int(waitedMS));
    LOG(Debug, "Waited %fms\n", waitedMS);
  }

  return script->GetJSScript(cx);
}

/* static */
void ScriptPreloader::OffThreadDecodeCallback(JS::OffThreadToken* token,
                                              void* context) {
  auto cache = static_cast<ScriptPreloader*>(context);

  cache->mMonitor.AssertNotCurrentThreadOwns();
  MonitorAutoLock mal(cache->mMonitor);

  // First notify any tasks that are already waiting on scripts, since they'll
  // be blocking the main thread, and prevent any runnables from executing.
  cache->mToken = token;
  mal.NotifyAll();

  // If nothing processed the token, and we don't already have a pending
  // runnable, then dispatch a new one to finish the processing on the main
  // thread as soon as possible.
  if (cache->mToken && !cache->mFinishDecodeRunnablePending) {
    cache->mFinishDecodeRunnablePending = true;
    NS_DispatchToMainThread(
        NewRunnableMethod("ScriptPreloader::DoFinishOffThreadDecode", cache,
                          &ScriptPreloader::DoFinishOffThreadDecode));
  }
}

void ScriptPreloader::FinishPendingParses(MonitorAutoLock& aMal) {
  mMonitor.AssertCurrentThreadOwns();

  mPendingScripts.clear();

  MaybeFinishOffThreadDecode();

  // Loop until all pending decode operations finish.
  while (!mParsingScripts.empty()) {
    aMal.Wait();
    MaybeFinishOffThreadDecode();
  }
}

void ScriptPreloader::DoFinishOffThreadDecode() {
  mFinishDecodeRunnablePending = false;
  MaybeFinishOffThreadDecode();
}

void ScriptPreloader::MaybeFinishOffThreadDecode() {
  if (!mToken) {
    return;
  }

  auto cleanup = MakeScopeExit([&]() {
    mToken = nullptr;
    mParsingSources.clear();
    mParsingScripts.clear();

    DecodeNextBatch(OFF_THREAD_CHUNK_SIZE);
  });

  AutoSafeJSAPI jsapi;
  JSContext* cx = jsapi.cx();

  JSAutoRealm ar(cx, xpc::CompilationScope());
  JS::Rooted<JS::ScriptVector> jsScripts(cx, JS::ScriptVector(cx));

  // If this fails, we still need to mark the scripts as finished. Any that
  // weren't successfully compiled in this operation (which should never
  // happen under ordinary circumstances) will be re-decoded on the main
  // thread, and raise the appropriate errors when they're executed.
  //
  // The exception from the off-thread decode operation will be reported when
  // we pop the AutoJSAPI off the stack.
  Unused << JS::FinishMultiOffThreadScriptsDecoder(cx, mToken, &jsScripts);

  unsigned i = 0;
  for (auto script : mParsingScripts) {
    LOG(Debug, "Finished off-thread decode of %s\n", script->mURL.get());
    if (i < jsScripts.length()) {
      script->mScript = jsScripts[i++];
    }
    script->mReadyToExecute = true;
  }
}

void ScriptPreloader::DecodeNextBatch(size_t chunkSize,
                                      JS::HandleObject scope) {
  MOZ_ASSERT(mParsingSources.length() == 0);
  MOZ_ASSERT(mParsingScripts.length() == 0);

  auto cleanup = MakeScopeExit([&]() {
    mParsingScripts.clearAndFree();
    mParsingSources.clearAndFree();
  });

  auto start = TimeStamp::Now();
  LOG(Debug, "Off-thread decoding scripts...\n");

  size_t size = 0;
  for (CachedScript* next = mPendingScripts.getFirst(); next;) {
    auto script = next;
    next = script->getNext();

    // Skip any scripts that we decoded on the main thread rather than
    // waiting for an off-thread operation to complete.
    if (script->mReadyToExecute) {
      script->remove();
      continue;
    }
    // If we have enough data for one chunk and this script would put us
    // over our chunk size limit, we're done.
    if (size > SMALL_SCRIPT_CHUNK_THRESHOLD &&
        size + script->mSize > chunkSize) {
      break;
    }
    if (!mParsingScripts.append(script) ||
        !mParsingSources.emplaceBack(script->Range(), script->mURL.get(), 0)) {
      break;
    }

    LOG(Debug, "Beginning off-thread decode of script %s (%u bytes)\n",
        script->mURL.get(), script->mSize);

    script->remove();
    size += script->mSize;
  }

  if (size == 0 && mPendingScripts.isEmpty()) {
    return;
  }

  AutoSafeJSAPI jsapi;
  JSContext* cx = jsapi.cx();
  JSAutoRealm ar(cx, scope ? scope : xpc::CompilationScope());

  JS::CompileOptions options(cx);
  options.setNoScriptRval(true).setSourceIsLazy(true);

  if (!JS::CanCompileOffThread(cx, options, size) ||
      !JS::DecodeMultiOffThreadScripts(cx, options, mParsingSources,
                                       OffThreadDecodeCallback,
                                       static_cast<void*>(this))) {
    // If we fail here, we don't move on to process the next batch, so make
    // sure we don't have any other scripts left to process.
    MOZ_ASSERT(mPendingScripts.isEmpty());
    for (auto script : mPendingScripts) {
      script->mReadyToExecute = true;
    }

    LOG(Info, "Can't decode %lu bytes of scripts off-thread",
        (unsigned long)size);
    for (auto script : mParsingScripts) {
      script->mReadyToExecute = true;
    }
    return;
  }

  cleanup.release();

  LOG(Debug, "Initialized decoding of %u scripts (%u bytes) in %fms\n",
      (unsigned)mParsingSources.length(), (unsigned)size,
      (TimeStamp::Now() - start).ToMilliseconds());
}

ScriptPreloader::CachedScript::CachedScript(ScriptPreloader& cache,
                                            InputBuffer& buf)
    : mCache(cache) {
  Code(buf);

  // Swap the mProcessTypes and mOriginalProcessTypes values, since we want to
  // start with an empty set of processes loaded into for this session, and
  // compare against last session's values later.
  mOriginalProcessTypes = mProcessTypes;
  mProcessTypes = {};
}

bool ScriptPreloader::CachedScript::XDREncode(JSContext* cx) {
  auto cleanup = MakeScopeExit([&]() { MaybeDropScript(); });

  JSAutoRealm ar(cx, mScript);
  JS::RootedScript jsscript(cx, mScript);

  mXDRData.construct<JS::TranscodeBuffer>();

  JS::TranscodeResult code = JS::EncodeScript(cx, Buffer(), jsscript);
  if (code == JS::TranscodeResult_Ok) {
    mXDRRange.emplace(Buffer().begin(), Buffer().length());
    mSize = Range().length();
    return true;
  }
  mXDRData.destroy();
  JS_ClearPendingException(cx);
  return false;
}

JSScript* ScriptPreloader::CachedScript::GetJSScript(JSContext* cx) {
  MOZ_ASSERT(mReadyToExecute);
  if (mScript) {
    return mScript;
  }

  if (!HasRange()) {
    // We've already executed the script, and thrown it away. But it wasn't
    // in the cache at startup, so we don't have any data to decode. Give
    // up.
    return nullptr;
  }

  // If we have no script at this point, the script was too small to decode
  // off-thread, or it was needed before the off-thread compilation was
  // finished, and is small enough to decode on the main thread rather than
  // wait for the off-thread decoding to finish. In either case, we decode
  // it synchronously the first time it's needed.

  auto start = TimeStamp::Now();
  LOG(Info, "Decoding script %s on main thread...\n", mURL.get());

  JS::RootedScript script(cx);
  if (JS::DecodeScript(cx, Range(), &script)) {
    mScript = script;

    if (mCache.mSaveComplete) {
      FreeData();
    }
  }

  LOG(Debug, "Finished decoding in %fms",
      (TimeStamp::Now() - start).ToMilliseconds());

  return mScript;
}

// nsIAsyncShutdownBlocker

nsresult ScriptPreloader::GetName(nsAString& aName) {
  aName.AssignLiteral(u"ScriptPreloader: Saving bytecode cache");
  return NS_OK;
}

nsresult ScriptPreloader::GetState(nsIPropertyBag** aState) {
  *aState = nullptr;
  return NS_OK;
}

nsresult ScriptPreloader::BlockShutdown(
    nsIAsyncShutdownClient* aBarrierClient) {
  // If we're waiting on a timeout to finish saving, interrupt it and just save
  // immediately.
  mSaveMonitor.NotifyAll();
  return NS_OK;
}

already_AddRefed<nsIAsyncShutdownClient> ScriptPreloader::GetShutdownBarrier() {
  nsCOMPtr<nsIAsyncShutdownService> svc = components::AsyncShutdown::Service();
  MOZ_RELEASE_ASSERT(svc);

  nsCOMPtr<nsIAsyncShutdownClient> barrier;
  Unused << svc->GetXpcomWillShutdown(getter_AddRefs(barrier));
  MOZ_RELEASE_ASSERT(barrier);

  return barrier.forget();
}

NS_IMPL_ISUPPORTS(ScriptPreloader, nsIObserver, nsIRunnable, nsIMemoryReporter,
                  nsIAsyncShutdownBlocker)

#undef LOG

}  // namespace mozilla
