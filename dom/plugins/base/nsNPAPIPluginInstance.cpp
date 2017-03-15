/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/DebugOnly.h"

#ifdef MOZ_WIDGET_ANDROID
// For ScreenOrientation.h and Hal.h
#include "base/basictypes.h"
#endif

#include "mozilla/Logging.h"
#include "prmem.h"
#include "nscore.h"
#include "prenv.h"

#include "nsNPAPIPluginInstance.h"
#include "nsNPAPIPlugin.h"
#include "nsNPAPIPluginStreamListener.h"
#include "nsPluginHost.h"
#include "nsPluginLogging.h"
#include "nsContentUtils.h"
#include "nsPluginInstanceOwner.h"

#include "nsThreadUtils.h"
#include "nsIDOMElement.h"
#include "nsIDocument.h"
#include "nsIDocShell.h"
#include "nsIScriptGlobalObject.h"
#include "nsIScriptContext.h"
#include "nsDirectoryServiceDefs.h"
#include "nsJSNPRuntime.h"
#include "nsPluginStreamListenerPeer.h"
#include "nsSize.h"
#include "nsNetCID.h"
#include "nsIContent.h"
#include "nsVersionComparator.h"
#include "mozilla/Preferences.h"
#include "mozilla/Unused.h"
#include "nsILoadContext.h"
#include "mozilla/dom/HTMLObjectElementBinding.h"
#include "AudioChannelService.h"

using namespace mozilla;
using namespace mozilla::dom;

#ifdef MOZ_WIDGET_ANDROID
#include "ANPBase.h"
#include <android/log.h>
#include "android_npapi.h"
#include "mozilla/Mutex.h"
#include "mozilla/CondVar.h"
#include "mozilla/dom/ScreenOrientation.h"
#include "mozilla/Hal.h"
#include "GLContextProvider.h"
#include "GLContext.h"
#include "TexturePoolOGL.h"
#include "SurfaceTypes.h"
#include "EGLUtils.h"

using namespace mozilla;
using namespace mozilla::gl;

typedef nsNPAPIPluginInstance::VideoInfo VideoInfo;

class PluginEventRunnable : public Runnable
{
public:
  PluginEventRunnable(nsNPAPIPluginInstance* instance, ANPEvent* event)
    : mInstance(instance), mEvent(*event), mCanceled(false) {}

  virtual nsresult Run() {
    if (mCanceled)
      return NS_OK;

    mInstance->HandleEvent(&mEvent, nullptr);
    mInstance->PopPostedEvent(this);
    return NS_OK;
  }

  void Cancel() { mCanceled = true; }
private:
  nsNPAPIPluginInstance* mInstance;
  ANPEvent mEvent;
  bool mCanceled;
};

static RefPtr<GLContext> sPluginContext = nullptr;

static bool EnsureGLContext()
{
  if (!sPluginContext) {
    const auto flags = CreateContextFlags::REQUIRE_COMPAT_PROFILE;
    nsCString discardedFailureId;
    sPluginContext = GLContextProvider::CreateHeadless(flags, &discardedFailureId);
  }

  return sPluginContext != nullptr;
}

static std::map<NPP, nsNPAPIPluginInstance*> sPluginNPPMap;

#endif

using namespace mozilla;
using namespace mozilla::plugins::parent;
using namespace mozilla::layers;

static NS_DEFINE_IID(kIOutputStreamIID, NS_IOUTPUTSTREAM_IID);

NS_IMPL_ISUPPORTS(nsNPAPIPluginInstance, nsIAudioChannelAgentCallback)

nsNPAPIPluginInstance::nsNPAPIPluginInstance()
  : mDrawingModel(kDefaultDrawingModel)
#ifdef MOZ_WIDGET_ANDROID
  , mANPDrawingModel(0)
  , mFullScreenOrientation(dom::eScreenOrientation_LandscapePrimary)
  , mWakeLocked(false)
  , mFullScreen(false)
  , mOriginPos(gl::OriginPos::TopLeft)
#endif
  , mRunning(NOT_STARTED)
  , mWindowless(false)
  , mTransparent(false)
  , mCached(false)
  , mUsesDOMForCursor(false)
  , mInPluginInitCall(false)
  , mPlugin(nullptr)
  , mMIMEType(nullptr)
  , mOwner(nullptr)
#ifdef XP_MACOSX
  , mCurrentPluginEvent(nullptr)
#endif
#ifdef MOZ_WIDGET_ANDROID
  , mOnScreen(true)
#endif
  , mHaveJavaC2PJSObjectQuirk(false)
  , mCachedParamLength(0)
  , mCachedParamNames(nullptr)
  , mCachedParamValues(nullptr)
  , mMuted(false)
{
  mNPP.pdata = nullptr;
  mNPP.ndata = this;

  PLUGIN_LOG(PLUGIN_LOG_BASIC, ("nsNPAPIPluginInstance ctor: this=%p\n",this));

#ifdef MOZ_WIDGET_ANDROID
  sPluginNPPMap[&mNPP] = this;
#endif
}

nsNPAPIPluginInstance::~nsNPAPIPluginInstance()
{
  PLUGIN_LOG(PLUGIN_LOG_BASIC, ("nsNPAPIPluginInstance dtor: this=%p\n",this));

#ifdef MOZ_WIDGET_ANDROID
  sPluginNPPMap.erase(&mNPP);
#endif

  if (mMIMEType) {
    PR_Free((void *)mMIMEType);
    mMIMEType = nullptr;
  }

  if (!mCachedParamValues || !mCachedParamNames) {
    return;
  }
  MOZ_ASSERT(mCachedParamValues && mCachedParamNames);

  for (uint32_t i = 0; i < mCachedParamLength; i++) {
    if (mCachedParamNames[i]) {
      free(mCachedParamNames[i]);
      mCachedParamNames[i] = nullptr;
    }
    if (mCachedParamValues[i]) {
      free(mCachedParamValues[i]);
      mCachedParamValues[i] = nullptr;
    }
  }

  free(mCachedParamNames);
  mCachedParamNames = nullptr;

  free(mCachedParamValues);
  mCachedParamValues = nullptr;
}

uint32_t nsNPAPIPluginInstance::gInUnsafePluginCalls = 0;

void
nsNPAPIPluginInstance::Destroy()
{
  Stop();
  mPlugin = nullptr;
  mAudioChannelAgent = nullptr;

#if MOZ_WIDGET_ANDROID
  if (mContentSurface)
    mContentSurface->SetFrameAvailableCallback(nullptr);

  mContentSurface = nullptr;

  std::map<void*, VideoInfo*>::iterator it;
  for (it = mVideos.begin(); it != mVideos.end(); it++) {
    it->second->mSurfaceTexture->SetFrameAvailableCallback(nullptr);
    delete it->second;
  }
  mVideos.clear();
  SetWakeLock(false);
#endif
}

TimeStamp
nsNPAPIPluginInstance::StopTime()
{
  return mStopTime;
}

nsresult nsNPAPIPluginInstance::Initialize(nsNPAPIPlugin *aPlugin, nsPluginInstanceOwner* aOwner, const nsACString& aMIMEType)
{
  PROFILER_LABEL_FUNC(js::ProfileEntry::Category::OTHER);
  PLUGIN_LOG(PLUGIN_LOG_NORMAL, ("nsNPAPIPluginInstance::Initialize this=%p\n",this));

  NS_ENSURE_ARG_POINTER(aPlugin);
  NS_ENSURE_ARG_POINTER(aOwner);

  mPlugin = aPlugin;
  mOwner = aOwner;

  if (!aMIMEType.IsEmpty()) {
    mMIMEType = ToNewCString(aMIMEType);
  }

  return Start();
}

nsresult nsNPAPIPluginInstance::Stop()
{
  PLUGIN_LOG(PLUGIN_LOG_NORMAL, ("nsNPAPIPluginInstance::Stop this=%p\n",this));

  // Make sure the plugin didn't leave popups enabled.
  if (mPopupStates.Length() > 0) {
    nsCOMPtr<nsPIDOMWindowOuter> window = GetDOMWindow();

    if (window) {
      window->PopPopupControlState(openAbused);
    }
  }

  if (RUNNING != mRunning) {
    return NS_OK;
  }

  // clean up all outstanding timers
  for (uint32_t i = mTimers.Length(); i > 0; i--)
    UnscheduleTimer(mTimers[i - 1]->id);

  // If there's code from this plugin instance on the stack, delay the
  // destroy.
  if (PluginDestructionGuard::DelayDestroy(this)) {
    return NS_OK;
  }

  // Make sure we lock while we're writing to mRunning after we've
  // started as other threads might be checking that inside a lock.
  {
    AsyncCallbackAutoLock lock;
    mRunning = DESTROYING;
    mStopTime = TimeStamp::Now();
  }

  OnPluginDestroy(&mNPP);

  // clean up open streams
  while (mStreamListeners.Length() > 0) {
    RefPtr<nsNPAPIPluginStreamListener> currentListener(mStreamListeners[0]);
    currentListener->CleanUpStream(NPRES_USER_BREAK);
    mStreamListeners.RemoveElement(currentListener);
  }

  if (!mPlugin || !mPlugin->GetLibrary())
    return NS_ERROR_FAILURE;

  NPPluginFuncs* pluginFunctions = mPlugin->PluginFuncs();

  NPError error = NPERR_GENERIC_ERROR;
  if (pluginFunctions->destroy) {
    NPSavedData *sdata = 0;

    NS_TRY_SAFE_CALL_RETURN(error, (*pluginFunctions->destroy)(&mNPP, &sdata), this,
                            NS_PLUGIN_CALL_UNSAFE_TO_REENTER_GECKO);

    NPP_PLUGIN_LOG(PLUGIN_LOG_NORMAL,
                   ("NPP Destroy called: this=%p, npp=%p, return=%d\n", this, &mNPP, error));
  }
  mRunning = DESTROYED;

#if MOZ_WIDGET_ANDROID
  for (uint32_t i = 0; i < mPostedEvents.Length(); i++) {
    mPostedEvents[i]->Cancel();
  }

  mPostedEvents.Clear();
#endif

  nsJSNPRuntime::OnPluginDestroy(&mNPP);

  if (error != NPERR_NO_ERROR)
    return NS_ERROR_FAILURE;
  else
    return NS_OK;
}

already_AddRefed<nsPIDOMWindowOuter>
nsNPAPIPluginInstance::GetDOMWindow()
{
  if (!mOwner)
    return nullptr;

  RefPtr<nsPluginInstanceOwner> kungFuDeathGrip(mOwner);

  nsCOMPtr<nsIDocument> doc;
  kungFuDeathGrip->GetDocument(getter_AddRefs(doc));
  if (!doc)
    return nullptr;

  RefPtr<nsPIDOMWindowOuter> window = doc->GetWindow();

  return window.forget();
}

nsresult
nsNPAPIPluginInstance::GetTagType(nsPluginTagType *result)
{
  if (!mOwner) {
    return NS_ERROR_FAILURE;
  }

  return mOwner->GetTagType(result);
}

nsresult
nsNPAPIPluginInstance::GetMode(int32_t *result)
{
  if (mOwner)
    return mOwner->GetMode(result);
  else
    return NS_ERROR_FAILURE;
}

nsTArray<nsNPAPIPluginStreamListener*>*
nsNPAPIPluginInstance::StreamListeners()
{
  return &mStreamListeners;
}

nsTArray<nsPluginStreamListenerPeer*>*
nsNPAPIPluginInstance::FileCachedStreamListeners()
{
  return &mFileCachedStreamListeners;
}

nsresult
nsNPAPIPluginInstance::Start()
{
  if (mRunning == RUNNING) {
    return NS_OK;
  }

  if (!mOwner) {
    MOZ_ASSERT(false, "Should not be calling Start() on unowned plugin.");
    return NS_ERROR_FAILURE;
  }

  PluginDestructionGuard guard(this);

  nsTArray<MozPluginParameter> attributes;
  nsTArray<MozPluginParameter> params;

  nsPluginTagType tagtype;
  nsresult rv = GetTagType(&tagtype);
  if (NS_SUCCEEDED(rv)) {
    mOwner->GetAttributes(attributes);
    mOwner->GetParameters(params);
  } else {
    MOZ_ASSERT(false, "Failed to get tag type.");
  }

  mCachedParamLength = attributes.Length() + 1 + params.Length();

  // We add an extra entry "PARAM" as a separator between the attribute
  // and param values, but we don't count it if there are no <param> entries.
  // Legacy behavior quirk.
  uint32_t quirkParamLength = params.Length() ?
                                mCachedParamLength : attributes.Length();

  mCachedParamNames = (char**)moz_xmalloc(sizeof(char*) * mCachedParamLength);
  mCachedParamValues = (char**)moz_xmalloc(sizeof(char*) * mCachedParamLength);

  for (uint32_t i = 0; i < attributes.Length(); i++) {
    mCachedParamNames[i] = ToNewUTF8String(attributes[i].mName);
    mCachedParamValues[i] = ToNewUTF8String(attributes[i].mValue);
  }

  // Android expects and empty string instead of null.
  mCachedParamNames[attributes.Length()] = ToNewUTF8String(NS_LITERAL_STRING("PARAM"));
  #ifdef MOZ_WIDGET_ANDROID
    mCachedParamValues[attributes.Length()] = ToNewUTF8String(NS_LITERAL_STRING(""));
  #else
    mCachedParamValues[attributes.Length()] = nullptr;
  #endif

  for (uint32_t i = 0, pos = attributes.Length() + 1; i < params.Length(); i ++) {
    mCachedParamNames[pos] = ToNewUTF8String(params[i].mName);
    mCachedParamValues[pos] = ToNewUTF8String(params[i].mValue);
    pos++;
  }

  int32_t       mode;
  const char*   mimetype;
  NPError       error = NPERR_GENERIC_ERROR;

  GetMode(&mode);
  GetMIMEType(&mimetype);

  CheckJavaC2PJSObjectQuirk(quirkParamLength, mCachedParamNames, mCachedParamValues);

  bool oldVal = mInPluginInitCall;
  mInPluginInitCall = true;

  // Need this on the stack before calling NPP_New otherwise some callbacks that
  // the plugin may make could fail (NPN_HasProperty, for example).
  NPPAutoPusher autopush(&mNPP);

  if (!mPlugin)
    return NS_ERROR_FAILURE;

  PluginLibrary* library = mPlugin->GetLibrary();
  if (!library)
    return NS_ERROR_FAILURE;

  // Mark this instance as running before calling NPP_New because the plugin may
  // call other NPAPI functions, like NPN_GetURLNotify, that assume this is set
  // before returning. If the plugin returns failure, we'll clear it out below.
  mRunning = RUNNING;

  nsresult newResult = library->NPP_New((char*)mimetype, &mNPP, (uint16_t)mode,
                                        quirkParamLength, mCachedParamNames,
                                        mCachedParamValues, nullptr, &error);
  mInPluginInitCall = oldVal;

  NPP_PLUGIN_LOG(PLUGIN_LOG_NORMAL,
  ("NPP New called: this=%p, npp=%p, mime=%s, mode=%d, argc=%d, return=%d\n",
  this, &mNPP, mimetype, mode, quirkParamLength, error));

  if (NS_FAILED(newResult) || error != NPERR_NO_ERROR) {
    mRunning = DESTROYED;
    nsJSNPRuntime::OnPluginDestroy(&mNPP);
    return NS_ERROR_FAILURE;
  }

  return newResult;
}

nsresult nsNPAPIPluginInstance::SetWindow(NPWindow* window)
{
  // NPAPI plugins don't want a SetWindow(nullptr).
  if (!window || RUNNING != mRunning)
    return NS_OK;

#if MOZ_WIDGET_GTK
  // bug 108347, flash plugin on linux doesn't like window->width <=
  // 0, but Java needs wants this call.
  if (window && window->type == NPWindowTypeWindow &&
      (window->width <= 0 || window->height <= 0) &&
      (nsPluginHost::GetSpecialType(nsDependentCString(mMIMEType)) !=
       nsPluginHost::eSpecialType_Java)) {
    return NS_OK;
  }
#endif

  if (!mPlugin || !mPlugin->GetLibrary())
    return NS_ERROR_FAILURE;

  NPPluginFuncs* pluginFunctions = mPlugin->PluginFuncs();

  if (pluginFunctions->setwindow) {
    PluginDestructionGuard guard(this);

    // XXX Turns out that NPPluginWindow and NPWindow are structurally
    // identical (on purpose!), so there's no need to make a copy.

    PLUGIN_LOG(PLUGIN_LOG_NORMAL, ("nsNPAPIPluginInstance::SetWindow (about to call it) this=%p\n",this));

    bool oldVal = mInPluginInitCall;
    mInPluginInitCall = true;

    NPPAutoPusher nppPusher(&mNPP);

    NPError error;
    NS_TRY_SAFE_CALL_RETURN(error, (*pluginFunctions->setwindow)(&mNPP, (NPWindow*)window), this,
                            NS_PLUGIN_CALL_UNSAFE_TO_REENTER_GECKO);
    // 'error' is only used if this is a logging-enabled build.
    // That is somewhat complex to check, so we just use "unused"
    // to suppress any compiler warnings in build configurations
    // where the logging is a no-op.
    mozilla::Unused << error;

    mInPluginInitCall = oldVal;

    NPP_PLUGIN_LOG(PLUGIN_LOG_NORMAL,
    ("NPP SetWindow called: this=%p, [x=%d,y=%d,w=%d,h=%d], clip[t=%d,b=%d,l=%d,r=%d], return=%d\n",
    this, window->x, window->y, window->width, window->height,
    window->clipRect.top, window->clipRect.bottom, window->clipRect.left, window->clipRect.right, error));
  }
  return NS_OK;
}

nsresult
nsNPAPIPluginInstance::NewStreamFromPlugin(const char* type, const char* target,
                                           nsIOutputStream* *result)
{
  nsPluginStreamToFile* stream = new nsPluginStreamToFile(target, mOwner);
  return stream->QueryInterface(kIOutputStreamIID, (void**)result);
}

nsresult
nsNPAPIPluginInstance::NewStreamListener(const char* aURL, void* notifyData,
                                         nsNPAPIPluginStreamListener** listener)
{
  RefPtr<nsNPAPIPluginStreamListener> sl = new nsNPAPIPluginStreamListener(this, notifyData, aURL);

  mStreamListeners.AppendElement(sl);

  sl.forget(listener);

  return NS_OK;
}

nsresult nsNPAPIPluginInstance::Print(NPPrint* platformPrint)
{
  NS_ENSURE_TRUE(platformPrint, NS_ERROR_NULL_POINTER);

  PluginDestructionGuard guard(this);

  if (!mPlugin || !mPlugin->GetLibrary())
    return NS_ERROR_FAILURE;

  NPPluginFuncs* pluginFunctions = mPlugin->PluginFuncs();

  NPPrint* thePrint = (NPPrint *)platformPrint;

  // to be compatible with the older SDK versions and to match what
  // NPAPI and other browsers do, overwrite |window.type| field with one
  // more copy of |platformPrint|. See bug 113264
  uint16_t sdkmajorversion = (pluginFunctions->version & 0xff00)>>8;
  uint16_t sdkminorversion = pluginFunctions->version & 0x00ff;
  if ((sdkmajorversion == 0) && (sdkminorversion < 11)) {
    // Let's copy platformPrint bytes over to where it was supposed to be
    // in older versions -- four bytes towards the beginning of the struct
    // but we should be careful about possible misalignments
    if (sizeof(NPWindowType) >= sizeof(void *)) {
      void* source = thePrint->print.embedPrint.platformPrint;
      void** destination = (void **)&(thePrint->print.embedPrint.window.type);
      *destination = source;
    } else {
      NS_ERROR("Incompatible OS for assignment");
    }
  }

  if (pluginFunctions->print)
      NS_TRY_SAFE_CALL_VOID((*pluginFunctions->print)(&mNPP, thePrint), this,
                            NS_PLUGIN_CALL_UNSAFE_TO_REENTER_GECKO);

  NPP_PLUGIN_LOG(PLUGIN_LOG_NORMAL,
  ("NPP PrintProc called: this=%p, pDC=%p, [x=%d,y=%d,w=%d,h=%d], clip[t=%d,b=%d,l=%d,r=%d]\n",
  this,
  platformPrint->print.embedPrint.platformPrint,
  platformPrint->print.embedPrint.window.x,
  platformPrint->print.embedPrint.window.y,
  platformPrint->print.embedPrint.window.width,
  platformPrint->print.embedPrint.window.height,
  platformPrint->print.embedPrint.window.clipRect.top,
  platformPrint->print.embedPrint.window.clipRect.bottom,
  platformPrint->print.embedPrint.window.clipRect.left,
  platformPrint->print.embedPrint.window.clipRect.right));

  return NS_OK;
}

nsresult nsNPAPIPluginInstance::HandleEvent(void* event, int16_t* result,
                                            NSPluginCallReentry aSafeToReenterGecko)
{
  if (RUNNING != mRunning)
    return NS_OK;

  PROFILER_LABEL_FUNC(js::ProfileEntry::Category::OTHER);

  if (!event)
    return NS_ERROR_FAILURE;

  PluginDestructionGuard guard(this);

  if (!mPlugin || !mPlugin->GetLibrary())
    return NS_ERROR_FAILURE;

  NPPluginFuncs* pluginFunctions = mPlugin->PluginFuncs();

  int16_t tmpResult = kNPEventNotHandled;

  if (pluginFunctions->event) {
#ifdef XP_MACOSX
    mCurrentPluginEvent = event;
#endif
#if defined(XP_WIN)
    NS_TRY_SAFE_CALL_RETURN(tmpResult, (*pluginFunctions->event)(&mNPP, event), this,
                            aSafeToReenterGecko);
#else
    MAIN_THREAD_JNI_REF_GUARD;
    tmpResult = (*pluginFunctions->event)(&mNPP, event);
#endif
    NPP_PLUGIN_LOG(PLUGIN_LOG_NOISY,
      ("NPP HandleEvent called: this=%p, npp=%p, event=%p, return=%d\n",
      this, &mNPP, event, tmpResult));

    if (result)
      *result = tmpResult;
#ifdef XP_MACOSX
    mCurrentPluginEvent = nullptr;
#endif
  }

  return NS_OK;
}

nsresult nsNPAPIPluginInstance::GetValueFromPlugin(NPPVariable variable, void* value)
{
  if (!mPlugin || !mPlugin->GetLibrary())
    return NS_ERROR_FAILURE;

  NPPluginFuncs* pluginFunctions = mPlugin->PluginFuncs();

  nsresult rv = NS_ERROR_FAILURE;

  if (pluginFunctions->getvalue && RUNNING == mRunning) {
    PluginDestructionGuard guard(this);

    NPError pluginError = NPERR_GENERIC_ERROR;
    NS_TRY_SAFE_CALL_RETURN(pluginError, (*pluginFunctions->getvalue)(&mNPP, variable, value), this,
                            NS_PLUGIN_CALL_UNSAFE_TO_REENTER_GECKO);
    NPP_PLUGIN_LOG(PLUGIN_LOG_NORMAL,
    ("NPP GetValue called: this=%p, npp=%p, var=%d, value=%d, return=%d\n",
    this, &mNPP, variable, value, pluginError));

    if (pluginError == NPERR_NO_ERROR) {
      rv = NS_OK;
    }
  }

  return rv;
}

nsNPAPIPlugin* nsNPAPIPluginInstance::GetPlugin()
{
  return mPlugin;
}

nsresult nsNPAPIPluginInstance::GetNPP(NPP* aNPP)
{
  if (aNPP)
    *aNPP = &mNPP;
  else
    return NS_ERROR_NULL_POINTER;

  return NS_OK;
}

NPError nsNPAPIPluginInstance::SetWindowless(bool aWindowless)
{
  mWindowless = aWindowless;

  if (mMIMEType) {
    // bug 558434 - Prior to 3.6.4, we assumed windowless was transparent.
    // Silverlight apparently relied on this quirk, so we default to
    // transparent unless they specify otherwise after setting the windowless
    // property. (Last tested version: sl 4.0).
    // Changes to this code should be matched with changes in
    // PluginInstanceChild::InitQuirksMode.
    if (nsPluginHost::GetSpecialType(nsDependentCString(mMIMEType)) ==
        nsPluginHost::eSpecialType_Silverlight) {
      mTransparent = true;
    }
  }

  return NPERR_NO_ERROR;
}

NPError nsNPAPIPluginInstance::SetTransparent(bool aTransparent)
{
  mTransparent = aTransparent;
  return NPERR_NO_ERROR;
}

NPError nsNPAPIPluginInstance::SetUsesDOMForCursor(bool aUsesDOMForCursor)
{
  mUsesDOMForCursor = aUsesDOMForCursor;
  return NPERR_NO_ERROR;
}

bool
nsNPAPIPluginInstance::UsesDOMForCursor()
{
  return mUsesDOMForCursor;
}

void nsNPAPIPluginInstance::SetDrawingModel(NPDrawingModel aModel)
{
  mDrawingModel = aModel;
}

void nsNPAPIPluginInstance::RedrawPlugin()
{
  mOwner->RedrawPlugin();
}

#if defined(XP_MACOSX)
void nsNPAPIPluginInstance::SetEventModel(NPEventModel aModel)
{
  // the event model needs to be set for the object frame immediately
  if (!mOwner) {
    NS_WARNING("Trying to set event model without a plugin instance owner!");
    return;
  }

  mOwner->SetEventModel(aModel);
}
#endif

#if defined(MOZ_WIDGET_ANDROID)

static void SendLifecycleEvent(nsNPAPIPluginInstance* aInstance, uint32_t aAction)
{
  ANPEvent event;
  event.inSize = sizeof(ANPEvent);
  event.eventType = kLifecycle_ANPEventType;
  event.data.lifecycle.action = aAction;
  aInstance->HandleEvent(&event, nullptr);
}

void nsNPAPIPluginInstance::NotifyForeground(bool aForeground)
{
  PLUGIN_LOG(PLUGIN_LOG_NORMAL, ("nsNPAPIPluginInstance::SetForeground this=%p\n foreground=%d",this, aForeground));
  if (RUNNING != mRunning)
    return;

  SendLifecycleEvent(this, aForeground ? kResume_ANPLifecycleAction : kPause_ANPLifecycleAction);
}

void nsNPAPIPluginInstance::NotifyOnScreen(bool aOnScreen)
{
  PLUGIN_LOG(PLUGIN_LOG_NORMAL, ("nsNPAPIPluginInstance::SetOnScreen this=%p\n onScreen=%d",this, aOnScreen));
  if (RUNNING != mRunning || mOnScreen == aOnScreen)
    return;

  mOnScreen = aOnScreen;
  SendLifecycleEvent(this, aOnScreen ? kOnScreen_ANPLifecycleAction : kOffScreen_ANPLifecycleAction);
}

void nsNPAPIPluginInstance::MemoryPressure()
{
  PLUGIN_LOG(PLUGIN_LOG_NORMAL, ("nsNPAPIPluginInstance::MemoryPressure this=%p\n",this));
  if (RUNNING != mRunning)
    return;

  SendLifecycleEvent(this, kFreeMemory_ANPLifecycleAction);
}

void nsNPAPIPluginInstance::NotifyFullScreen(bool aFullScreen)
{
  PLUGIN_LOG(PLUGIN_LOG_NORMAL, ("nsNPAPIPluginInstance::NotifyFullScreen this=%p\n",this));

  if (RUNNING != mRunning || mFullScreen == aFullScreen)
    return;

  mFullScreen = aFullScreen;
  SendLifecycleEvent(this, mFullScreen ? kEnterFullScreen_ANPLifecycleAction : kExitFullScreen_ANPLifecycleAction);

  if (mFullScreen && mFullScreenOrientation != dom::eScreenOrientation_None) {
    java::GeckoAppShell::LockScreenOrientation(mFullScreenOrientation);
  }
}

void nsNPAPIPluginInstance::NotifySize(nsIntSize size)
{
  if (kOpenGL_ANPDrawingModel != GetANPDrawingModel() ||
      size == mCurrentSize)
    return;

  mCurrentSize = size;

  ANPEvent event;
  event.inSize = sizeof(ANPEvent);
  event.eventType = kDraw_ANPEventType;
  event.data.draw.model = kOpenGL_ANPDrawingModel;
  event.data.draw.data.surfaceSize.width = size.width;
  event.data.draw.data.surfaceSize.height = size.height;

  HandleEvent(&event, nullptr);
}

void nsNPAPIPluginInstance::SetANPDrawingModel(uint32_t aModel)
{
  mANPDrawingModel = aModel;
}

void* nsNPAPIPluginInstance::GetJavaSurface()
{
  void* surface = nullptr;
  nsresult rv = GetValueFromPlugin(kJavaSurface_ANPGetValue, &surface);
  if (NS_FAILED(rv))
    return nullptr;

  return surface;
}

void nsNPAPIPluginInstance::PostEvent(void* event)
{
  PluginEventRunnable *r = new PluginEventRunnable(this, (ANPEvent*)event);
  mPostedEvents.AppendElement(RefPtr<PluginEventRunnable>(r));

  NS_DispatchToMainThread(r);
}

void nsNPAPIPluginInstance::SetFullScreenOrientation(uint32_t orientation)
{
  if (mFullScreenOrientation == orientation)
    return;

  uint32_t oldOrientation = mFullScreenOrientation;
  mFullScreenOrientation = orientation;

  if (mFullScreen) {
    // We're already fullscreen so immediately apply the orientation change

    if (mFullScreenOrientation != dom::eScreenOrientation_None) {
      java::GeckoAppShell::LockScreenOrientation(mFullScreenOrientation);
    } else if (oldOrientation != dom::eScreenOrientation_None) {
      // We applied an orientation when we entered fullscreen, but
      // we don't want it anymore
      java::GeckoAppShell::UnlockScreenOrientation();
    }
  }
}

void nsNPAPIPluginInstance::PopPostedEvent(PluginEventRunnable* r)
{
  mPostedEvents.RemoveElement(r);
}

void nsNPAPIPluginInstance::SetWakeLock(bool aLocked)
{
  if (aLocked == mWakeLocked)
    return;

  mWakeLocked = aLocked;
  hal::ModifyWakeLock(NS_LITERAL_STRING("screen"),
                      mWakeLocked ? hal::WAKE_LOCK_ADD_ONE : hal::WAKE_LOCK_REMOVE_ONE,
                      hal::WAKE_LOCK_NO_CHANGE);
}

GLContext* nsNPAPIPluginInstance::GLContext()
{
  if (!EnsureGLContext())
    return nullptr;

  return sPluginContext;
}

already_AddRefed<AndroidSurfaceTexture> nsNPAPIPluginInstance::CreateSurfaceTexture()
{
  if (!EnsureGLContext())
    return nullptr;

  GLuint texture = TexturePoolOGL::AcquireTexture();
  if (!texture)
    return nullptr;

  RefPtr<AndroidSurfaceTexture> surface = AndroidSurfaceTexture::Create(TexturePoolOGL::GetGLContext(),
                                                                        texture);
  if (!surface) {
    return nullptr;
  }

  nsCOMPtr<nsIRunnable> frameCallback = NewRunnableMethod(this, &nsNPAPIPluginInstance::OnSurfaceTextureFrameAvailable);
  surface->SetFrameAvailableCallback(frameCallback);
  return surface.forget();
}

void nsNPAPIPluginInstance::OnSurfaceTextureFrameAvailable()
{
  if (mRunning == RUNNING && mOwner)
    mOwner->Recomposite();
}

void* nsNPAPIPluginInstance::AcquireContentWindow()
{
  if (!mContentSurface) {
    mContentSurface = CreateSurfaceTexture();

    if (!mContentSurface)
      return nullptr;
  }

  return mContentSurface->NativeWindow();
}

AndroidSurfaceTexture*
nsNPAPIPluginInstance::AsSurfaceTexture()
{
  if (!mContentSurface)
    return nullptr;

  return mContentSurface;
}

void* nsNPAPIPluginInstance::AcquireVideoWindow()
{
  RefPtr<AndroidSurfaceTexture> surface = CreateSurfaceTexture();
  if (!surface) {
    return nullptr;
  }

  VideoInfo* info = new VideoInfo(surface);

  void* window = info->mSurfaceTexture->NativeWindow();
  mVideos.insert(std::pair<void*, VideoInfo*>(window, info));

  return window;
}

void nsNPAPIPluginInstance::ReleaseVideoWindow(void* window)
{
  std::map<void*, VideoInfo*>::iterator it = mVideos.find(window);
  if (it == mVideos.end())
    return;

  delete it->second;
  mVideos.erase(window);
}

void nsNPAPIPluginInstance::SetVideoDimensions(void* window, gfxRect aDimensions)
{
  std::map<void*, VideoInfo*>::iterator it;

  it = mVideos.find(window);
  if (it == mVideos.end())
    return;

  it->second->mDimensions = aDimensions;
}

void nsNPAPIPluginInstance::GetVideos(nsTArray<VideoInfo*>& aVideos)
{
  std::map<void*, VideoInfo*>::iterator it;
  for (it = mVideos.begin(); it != mVideos.end(); it++)
    aVideos.AppendElement(it->second);
}

nsNPAPIPluginInstance* nsNPAPIPluginInstance::GetFromNPP(NPP npp)
{
  std::map<NPP, nsNPAPIPluginInstance*>::iterator it;

  it = sPluginNPPMap.find(npp);
  if (it == sPluginNPPMap.end())
    return nullptr;

  return it->second;
}

#endif

nsresult nsNPAPIPluginInstance::GetDrawingModel(int32_t* aModel)
{
  *aModel = (int32_t)mDrawingModel;
  return NS_OK;
}

nsresult nsNPAPIPluginInstance::IsRemoteDrawingCoreAnimation(bool* aDrawing)
{
#ifdef XP_MACOSX
  if (!mPlugin)
      return NS_ERROR_FAILURE;

  PluginLibrary* library = mPlugin->GetLibrary();
  if (!library)
      return NS_ERROR_FAILURE;

  return library->IsRemoteDrawingCoreAnimation(&mNPP, aDrawing);
#else
  return NS_ERROR_FAILURE;
#endif
}

nsresult
nsNPAPIPluginInstance::ContentsScaleFactorChanged(double aContentsScaleFactor)
{
#if defined(XP_MACOSX) || defined(XP_WIN)
  if (!mPlugin)
      return NS_ERROR_FAILURE;

  PluginLibrary* library = mPlugin->GetLibrary();
  if (!library)
      return NS_ERROR_FAILURE;

  // We only need to call this if the plugin is running OOP.
  if (!library->IsOOP())
      return NS_OK;

  return library->ContentsScaleFactorChanged(&mNPP, aContentsScaleFactor);
#else
  return NS_ERROR_FAILURE;
#endif
}

nsresult
nsNPAPIPluginInstance::CSSZoomFactorChanged(float aCSSZoomFactor)
{
  if (RUNNING != mRunning)
    return NS_OK;

  PLUGIN_LOG(PLUGIN_LOG_NORMAL, ("nsNPAPIPluginInstance informing plugin of CSS Zoom Factor change this=%p\n",this));

  if (!mPlugin || !mPlugin->GetLibrary())
    return NS_ERROR_FAILURE;

  NPPluginFuncs* pluginFunctions = mPlugin->PluginFuncs();

  if (!pluginFunctions->setvalue)
    return NS_ERROR_FAILURE;

  PluginDestructionGuard guard(this);

  NPError error;
  double value = static_cast<double>(aCSSZoomFactor);
  NS_TRY_SAFE_CALL_RETURN(error, (*pluginFunctions->setvalue)(&mNPP, NPNVCSSZoomFactor, &value), this,
                          NS_PLUGIN_CALL_UNSAFE_TO_REENTER_GECKO);
  return (error == NPERR_NO_ERROR) ? NS_OK : NS_ERROR_FAILURE;
}

nsresult
nsNPAPIPluginInstance::GetJSObject(JSContext *cx, JSObject** outObject)
{
  if (mHaveJavaC2PJSObjectQuirk) {
    return NS_ERROR_FAILURE;
  }

  NPObject *npobj = nullptr;
  nsresult rv = GetValueFromPlugin(NPPVpluginScriptableNPObject, &npobj);
  if (NS_FAILED(rv) || !npobj)
    return NS_ERROR_FAILURE;

  *outObject = nsNPObjWrapper::GetNewOrUsed(&mNPP, cx, npobj);

  _releaseobject(npobj);

  return NS_OK;
}

void
nsNPAPIPluginInstance::SetCached(bool aCache)
{
  mCached = aCache;
}

bool
nsNPAPIPluginInstance::ShouldCache()
{
  return mCached;
}

nsresult
nsNPAPIPluginInstance::IsWindowless(bool* isWindowless)
{
#if defined(MOZ_WIDGET_ANDROID) || defined(XP_MACOSX)
  // All OS X plugins are windowless.
  // On android, pre-honeycomb, all plugins are treated as windowless.
  *isWindowless = true;
#else
  *isWindowless = mWindowless;
#endif
  return NS_OK;
}

class MOZ_STACK_CLASS AutoPluginLibraryCall
{
public:
  explicit AutoPluginLibraryCall(nsNPAPIPluginInstance* aThis)
    : mThis(aThis), mGuard(aThis), mLibrary(nullptr)
  {
    nsNPAPIPlugin* plugin = mThis->GetPlugin();
    if (plugin)
      mLibrary = plugin->GetLibrary();
  }
  explicit operator bool() { return !!mLibrary; }
  PluginLibrary* operator->() { return mLibrary; }

private:
  nsNPAPIPluginInstance* mThis;
  PluginDestructionGuard mGuard;
  PluginLibrary* mLibrary;
};

nsresult
nsNPAPIPluginInstance::AsyncSetWindow(NPWindow* window)
{
  if (RUNNING != mRunning)
    return NS_OK;

  AutoPluginLibraryCall library(this);
  if (!library)
    return NS_ERROR_FAILURE;

  return library->AsyncSetWindow(&mNPP, window);
}

nsresult
nsNPAPIPluginInstance::GetImageContainer(ImageContainer**aContainer)
{
  *aContainer = nullptr;

  if (RUNNING != mRunning)
    return NS_OK;

  AutoPluginLibraryCall library(this);
  return !library ? NS_ERROR_FAILURE : library->GetImageContainer(&mNPP, aContainer);
}

nsresult
nsNPAPIPluginInstance::GetImageSize(nsIntSize* aSize)
{
  *aSize = nsIntSize(0, 0);

  if (RUNNING != mRunning)
    return NS_OK;

  AutoPluginLibraryCall library(this);
  return !library ? NS_ERROR_FAILURE : library->GetImageSize(&mNPP, aSize);
}

#if defined(XP_WIN)
nsresult
nsNPAPIPluginInstance::GetScrollCaptureContainer(ImageContainer**aContainer)
{
  *aContainer = nullptr;

  if (RUNNING != mRunning)
    return NS_OK;

  AutoPluginLibraryCall library(this);
  return !library ? NS_ERROR_FAILURE : library->GetScrollCaptureContainer(&mNPP, aContainer);
}
#endif

nsresult
nsNPAPIPluginInstance::HandledWindowedPluginKeyEvent(
                         const NativeEventData& aKeyEventData,
                         bool aIsConsumed)
{
  if (NS_WARN_IF(!mPlugin)) {
    return NS_ERROR_FAILURE;
  }

  PluginLibrary* library = mPlugin->GetLibrary();
  if (NS_WARN_IF(!library)) {
    return NS_ERROR_FAILURE;
  }
  return library->HandledWindowedPluginKeyEvent(&mNPP, aKeyEventData,
                                                aIsConsumed);
}

void
nsNPAPIPluginInstance::DidComposite()
{
  if (RUNNING != mRunning)
    return;

  AutoPluginLibraryCall library(this);
  library->DidComposite(&mNPP);
}

nsresult
nsNPAPIPluginInstance::NotifyPainted(void)
{
  NS_NOTREACHED("Dead code, shouldn't be called.");
  return NS_ERROR_NOT_IMPLEMENTED;
}

nsresult
nsNPAPIPluginInstance::GetIsOOP(bool* aIsAsync)
{
  AutoPluginLibraryCall library(this);
  if (!library)
    return NS_ERROR_FAILURE;

  *aIsAsync = library->IsOOP();
  return NS_OK;
}

nsresult
nsNPAPIPluginInstance::SetBackgroundUnknown()
{
  if (RUNNING != mRunning)
    return NS_OK;

  AutoPluginLibraryCall library(this);
  if (!library)
    return NS_ERROR_FAILURE;

  return library->SetBackgroundUnknown(&mNPP);
}

nsresult
nsNPAPIPluginInstance::BeginUpdateBackground(nsIntRect* aRect,
                                             DrawTarget** aDrawTarget)
{
  if (RUNNING != mRunning)
    return NS_OK;

  AutoPluginLibraryCall library(this);
  if (!library)
    return NS_ERROR_FAILURE;

  return library->BeginUpdateBackground(&mNPP, *aRect, aDrawTarget);
}

nsresult
nsNPAPIPluginInstance::EndUpdateBackground(nsIntRect* aRect)
{
  if (RUNNING != mRunning)
    return NS_OK;

  AutoPluginLibraryCall library(this);
  if (!library)
    return NS_ERROR_FAILURE;

  return library->EndUpdateBackground(&mNPP, *aRect);
}

nsresult
nsNPAPIPluginInstance::IsTransparent(bool* isTransparent)
{
  *isTransparent = mTransparent;
  return NS_OK;
}

nsresult
nsNPAPIPluginInstance::GetFormValue(nsAString& aValue)
{
  aValue.Truncate();

  char *value = nullptr;
  nsresult rv = GetValueFromPlugin(NPPVformValue, &value);
  if (NS_FAILED(rv) || !value)
    return NS_ERROR_FAILURE;

  CopyUTF8toUTF16(value, aValue);

  // NPPVformValue allocates with NPN_MemAlloc(), which uses
  // nsMemory.
  free(value);

  return NS_OK;
}

nsresult
nsNPAPIPluginInstance::PushPopupsEnabledState(bool aEnabled)
{
  nsCOMPtr<nsPIDOMWindowOuter> window = GetDOMWindow();
  if (!window)
    return NS_ERROR_FAILURE;

  PopupControlState oldState =
    window->PushPopupControlState(aEnabled ? openAllowed : openAbused,
                                  true);

  if (!mPopupStates.AppendElement(oldState)) {
    // Appending to our state stack failed, pop what we just pushed.
    window->PopPopupControlState(oldState);
    return NS_ERROR_FAILURE;
  }

  return NS_OK;
}

nsresult
nsNPAPIPluginInstance::PopPopupsEnabledState()
{
  int32_t last = mPopupStates.Length() - 1;

  if (last < 0) {
    // Nothing to pop.
    return NS_OK;
  }

  nsCOMPtr<nsPIDOMWindowOuter> window = GetDOMWindow();
  if (!window)
    return NS_ERROR_FAILURE;

  PopupControlState &oldState = mPopupStates[last];

  window->PopPopupControlState(oldState);

  mPopupStates.RemoveElementAt(last);

  return NS_OK;
}

nsresult
nsNPAPIPluginInstance::GetPluginAPIVersion(uint16_t* version)
{
  NS_ENSURE_ARG_POINTER(version);

  if (!mPlugin)
    return NS_ERROR_FAILURE;

  if (!mPlugin->GetLibrary())
    return NS_ERROR_FAILURE;

  NPPluginFuncs* pluginFunctions = mPlugin->PluginFuncs();

  *version = pluginFunctions->version;

  return NS_OK;
}

nsresult
nsNPAPIPluginInstance::PrivateModeStateChanged(bool enabled)
{
  if (RUNNING != mRunning)
    return NS_OK;

  PLUGIN_LOG(PLUGIN_LOG_NORMAL, ("nsNPAPIPluginInstance informing plugin of private mode state change this=%p\n",this));

  if (!mPlugin || !mPlugin->GetLibrary())
    return NS_ERROR_FAILURE;

  NPPluginFuncs* pluginFunctions = mPlugin->PluginFuncs();

  if (!pluginFunctions->setvalue)
    return NS_ERROR_FAILURE;

  PluginDestructionGuard guard(this);

  NPError error;
  NPBool value = static_cast<NPBool>(enabled);
  NS_TRY_SAFE_CALL_RETURN(error, (*pluginFunctions->setvalue)(&mNPP, NPNVprivateModeBool, &value), this,
                          NS_PLUGIN_CALL_UNSAFE_TO_REENTER_GECKO);
  return (error == NPERR_NO_ERROR) ? NS_OK : NS_ERROR_FAILURE;
}

nsresult
nsNPAPIPluginInstance::IsPrivateBrowsing(bool* aEnabled)
{
  if (!mOwner)
    return NS_ERROR_FAILURE;

  nsCOMPtr<nsIDocument> doc;
  mOwner->GetDocument(getter_AddRefs(doc));
  NS_ENSURE_TRUE(doc, NS_ERROR_FAILURE);

  nsCOMPtr<nsPIDOMWindowOuter> domwindow = doc->GetWindow();
  NS_ENSURE_TRUE(domwindow, NS_ERROR_FAILURE);

  nsCOMPtr<nsIDocShell> docShell = domwindow->GetDocShell();
  nsCOMPtr<nsILoadContext> loadContext = do_QueryInterface(docShell);
  *aEnabled = (loadContext && loadContext->UsePrivateBrowsing());
  return NS_OK;
}

static void
PluginTimerCallback(nsITimer *aTimer, void *aClosure)
{
  nsNPAPITimer* t = (nsNPAPITimer*)aClosure;
  NPP npp = t->npp;
  uint32_t id = t->id;

  PLUGIN_LOG(PLUGIN_LOG_NOISY, ("nsNPAPIPluginInstance running plugin timer callback this=%p\n", npp->ndata));

  MAIN_THREAD_JNI_REF_GUARD;
  // Some plugins (Flash on Android) calls unscheduletimer
  // from this callback.
  t->inCallback = true;
  (*(t->callback))(npp, id);
  t->inCallback = false;

  // Make sure we still have an instance and the timer is still alive
  // after the callback.
  nsNPAPIPluginInstance *inst = (nsNPAPIPluginInstance*)npp->ndata;
  if (!inst || !inst->TimerWithID(id, nullptr))
    return;

  // use UnscheduleTimer to clean up if this is a one-shot timer
  uint32_t timerType;
  t->timer->GetType(&timerType);
  if (t->needUnschedule || timerType == nsITimer::TYPE_ONE_SHOT)
    inst->UnscheduleTimer(id);
}

nsNPAPITimer*
nsNPAPIPluginInstance::TimerWithID(uint32_t id, uint32_t* index)
{
  uint32_t len = mTimers.Length();
  for (uint32_t i = 0; i < len; i++) {
    if (mTimers[i]->id == id) {
      if (index)
        *index = i;
      return mTimers[i];
    }
  }
  return nullptr;
}

uint32_t
nsNPAPIPluginInstance::ScheduleTimer(uint32_t interval, NPBool repeat, void (*timerFunc)(NPP npp, uint32_t timerID))
{
  if (RUNNING != mRunning)
    return 0;

  nsNPAPITimer *newTimer = new nsNPAPITimer();

  newTimer->inCallback = newTimer->needUnschedule = false;
  newTimer->npp = &mNPP;

  // generate ID that is unique to this instance
  uint32_t uniqueID = mTimers.Length();
  while ((uniqueID == 0) || TimerWithID(uniqueID, nullptr))
    uniqueID++;
  newTimer->id = uniqueID;

  // create new xpcom timer, scheduled correctly
  nsresult rv;
  nsCOMPtr<nsITimer> xpcomTimer = do_CreateInstance(NS_TIMER_CONTRACTID, &rv);
  if (NS_FAILED(rv)) {
    delete newTimer;
    return 0;
  }
  const short timerType = (repeat ? (short)nsITimer::TYPE_REPEATING_SLACK : (short)nsITimer::TYPE_ONE_SHOT);
  xpcomTimer->InitWithFuncCallback(PluginTimerCallback, newTimer, interval, timerType);
  newTimer->timer = xpcomTimer;

  // save callback function
  newTimer->callback = timerFunc;

  // add timer to timers array
  mTimers.AppendElement(newTimer);

  return newTimer->id;
}

void
nsNPAPIPluginInstance::UnscheduleTimer(uint32_t timerID)
{
  // find the timer struct by ID
  uint32_t index;
  nsNPAPITimer* t = TimerWithID(timerID, &index);
  if (!t)
    return;

  if (t->inCallback) {
    t->needUnschedule = true;
    return;
  }

  // cancel the timer
  t->timer->Cancel();

  // remove timer struct from array
  mTimers.RemoveElementAt(index);

  // delete timer
  delete t;
}

NPBool
nsNPAPIPluginInstance::ConvertPoint(double sourceX, double sourceY, NPCoordinateSpace sourceSpace,
                                    double *destX, double *destY, NPCoordinateSpace destSpace)
{
  if (mOwner) {
    return mOwner->ConvertPoint(sourceX, sourceY, sourceSpace, destX, destY, destSpace);
  }

  return false;
}

nsresult
nsNPAPIPluginInstance::GetDOMElement(nsIDOMElement* *result)
{
  if (!mOwner) {
    *result = nullptr;
    return NS_ERROR_FAILURE;
  }

  return mOwner->GetDOMElement(result);
}

nsresult
nsNPAPIPluginInstance::InvalidateRect(NPRect *invalidRect)
{
  if (RUNNING != mRunning)
    return NS_OK;

  if (!mOwner)
    return NS_ERROR_FAILURE;

  return mOwner->InvalidateRect(invalidRect);
}

nsresult
nsNPAPIPluginInstance::InvalidateRegion(NPRegion invalidRegion)
{
  if (RUNNING != mRunning)
    return NS_OK;

  if (!mOwner)
    return NS_ERROR_FAILURE;

  return mOwner->InvalidateRegion(invalidRegion);
}

nsresult
nsNPAPIPluginInstance::GetMIMEType(const char* *result)
{
  if (!mMIMEType)
    *result = "";
  else
    *result = mMIMEType;

  return NS_OK;
}

nsPluginInstanceOwner*
nsNPAPIPluginInstance::GetOwner()
{
  return mOwner;
}

void
nsNPAPIPluginInstance::SetOwner(nsPluginInstanceOwner *aOwner)
{
  mOwner = aOwner;
}

nsresult
nsNPAPIPluginInstance::AsyncSetWindow(NPWindow& window)
{
  return NS_ERROR_NOT_IMPLEMENTED;
}

void
nsNPAPIPluginInstance::URLRedirectResponse(void* notifyData, NPBool allow)
{
  if (!notifyData) {
    return;
  }

  uint32_t listenerCount = mStreamListeners.Length();
  for (uint32_t i = 0; i < listenerCount; i++) {
    nsNPAPIPluginStreamListener* currentListener = mStreamListeners[i];
    if (currentListener->GetNotifyData() == notifyData) {
      currentListener->URLRedirectResponse(allow);
    }
  }
}

NPError
nsNPAPIPluginInstance::InitAsyncSurface(NPSize *size, NPImageFormat format,
                                        void *initData, NPAsyncSurface *surface)
{
  if (mOwner) {
    return mOwner->InitAsyncSurface(size, format, initData, surface);
  }

  return NPERR_GENERIC_ERROR;
}

NPError
nsNPAPIPluginInstance::FinalizeAsyncSurface(NPAsyncSurface *surface)
{
  if (mOwner) {
    return mOwner->FinalizeAsyncSurface(surface);
  }

  return NPERR_GENERIC_ERROR;
}

void
nsNPAPIPluginInstance::SetCurrentAsyncSurface(NPAsyncSurface *surface, NPRect *changed)
{
  if (mOwner) {
    mOwner->SetCurrentAsyncSurface(surface, changed);
  }
}

class CarbonEventModelFailureEvent : public Runnable {
public:
  nsCOMPtr<nsIContent> mContent;

  explicit CarbonEventModelFailureEvent(nsIContent* aContent)
    : mContent(aContent)
  {}

  ~CarbonEventModelFailureEvent() {}

  NS_IMETHOD Run();
};

NS_IMETHODIMP
CarbonEventModelFailureEvent::Run()
{
  nsString type = NS_LITERAL_STRING("npapi-carbon-event-model-failure");
  nsContentUtils::DispatchTrustedEvent(mContent->GetComposedDoc(), mContent,
                                       type, true, true);
  return NS_OK;
}

void
nsNPAPIPluginInstance::CarbonNPAPIFailure()
{
  nsCOMPtr<nsIDOMElement> element;
  GetDOMElement(getter_AddRefs(element));
  if (!element) {
    return;
  }

  nsCOMPtr<nsIContent> content(do_QueryInterface(element));
  if (!content) {
    return;
  }

  nsCOMPtr<nsIRunnable> e = new CarbonEventModelFailureEvent(content);
  nsresult rv = NS_DispatchToCurrentThread(e);
  if (NS_FAILED(rv)) {
    NS_WARNING("Failed to dispatch CarbonEventModelFailureEvent.");
  }
}

static bool
GetJavaVersionFromMimetype(nsPluginTag* pluginTag, nsCString& version)
{
  for (uint32_t i = 0; i < pluginTag->MimeTypes().Length(); ++i) {
    nsCString type = pluginTag->MimeTypes()[i];
    nsAutoCString jpi("application/x-java-applet;jpi-version=");

    int32_t idx = type.Find(jpi, false, 0, -1);
    if (idx != 0) {
      continue;
    }

    type.Cut(0, jpi.Length());
    if (type.IsEmpty()) {
      continue;
    }

    type.ReplaceChar('_', '.');
    version = type;
    return true;
  }

  return false;
}

void
nsNPAPIPluginInstance::CheckJavaC2PJSObjectQuirk(uint16_t paramCount,
                                                 const char* const* paramNames,
                                                 const char* const* paramValues)
{
  if (!mMIMEType || !mPlugin) {
    return;
  }

  nsPluginTagType tagtype;
  nsresult rv = GetTagType(&tagtype);
  if (NS_FAILED(rv) ||
      (tagtype != nsPluginTagType_Applet)) {
    return;
  }

  RefPtr<nsPluginHost> pluginHost = nsPluginHost::GetInst();
  if (!pluginHost) {
    return;
  }

  nsPluginTag* pluginTag = pluginHost->TagForPlugin(mPlugin);
  if (!pluginTag ||
      !pluginTag->mIsJavaPlugin) {
    return;
  }

  // check the params for "code" being present and non-empty
  bool haveCodeParam = false;
  bool isCodeParamEmpty = true;

  for (uint16_t i = paramCount; i > 0; --i) {
    if (PL_strcasecmp(paramNames[i - 1], "code") == 0) {
      haveCodeParam = true;
      if (strlen(paramValues[i - 1]) > 0) {
        isCodeParamEmpty = false;
      }
      break;
    }
  }

  // Due to the Java version being specified inconsistently across platforms
  // check the version via the mimetype for choosing specific Java versions
  nsCString javaVersion;
  if (!GetJavaVersionFromMimetype(pluginTag, javaVersion)) {
    return;
  }

  mozilla::Version version(javaVersion.get());

  if (version >= "1.7.0.4") {
    return;
  }

  if (!haveCodeParam && version >= "1.6.0.34" && version < "1.7") {
    return;
  }

  if (haveCodeParam && !isCodeParamEmpty) {
    return;
  }

  mHaveJavaC2PJSObjectQuirk = true;
}

double
nsNPAPIPluginInstance::GetContentsScaleFactor()
{
  double scaleFactor = 1.0;
  if (mOwner) {
    mOwner->GetContentsScaleFactor(&scaleFactor);
  }
  return scaleFactor;
}

float
nsNPAPIPluginInstance::GetCSSZoomFactor()
{
  float zoomFactor = 1.0;
  if (mOwner) {
    mOwner->GetCSSZoomFactor(&zoomFactor);
  }
  return zoomFactor;
}

nsresult
nsNPAPIPluginInstance::GetRunID(uint32_t* aRunID)
{
  if (NS_WARN_IF(!aRunID)) {
    return NS_ERROR_INVALID_POINTER;
  }

  if (NS_WARN_IF(!mPlugin)) {
    return NS_ERROR_FAILURE;
  }

  PluginLibrary* library = mPlugin->GetLibrary();
  if (!library) {
    return NS_ERROR_FAILURE;
  }

  return library->GetRunID(aRunID);
}

nsresult
nsNPAPIPluginInstance::GetOrCreateAudioChannelAgent(nsIAudioChannelAgent** aAgent)
{
  if (!mAudioChannelAgent) {
    nsresult rv;
    mAudioChannelAgent = do_CreateInstance("@mozilla.org/audiochannelagent;1", &rv);
    if (NS_WARN_IF(!mAudioChannelAgent)) {
      return NS_ERROR_FAILURE;
    }

    nsCOMPtr<nsPIDOMWindowOuter> window = GetDOMWindow();
    if (NS_WARN_IF(!window)) {
      return NS_ERROR_FAILURE;
    }

    rv = mAudioChannelAgent->Init(window->GetCurrentInnerWindow(),
                                 (int32_t)AudioChannelService::GetDefaultAudioChannel(),
                                 this);
    if (NS_WARN_IF(NS_FAILED(rv))) {
      return rv;
    }
  }

  nsCOMPtr<nsIAudioChannelAgent> agent = mAudioChannelAgent;
  agent.forget(aAgent);
  return NS_OK;
}

NS_IMETHODIMP
nsNPAPIPluginInstance::WindowVolumeChanged(float aVolume, bool aMuted)
{
  // We just support mute/unmute
  nsresult rv = SetMuted(aMuted);
  NS_WARNING_ASSERTION(NS_SUCCEEDED(rv), "SetMuted failed");
  if (mMuted != aMuted) {
    mMuted = aMuted;
    AudioChannelService::AudibleState audible = aMuted ?
      AudioChannelService::AudibleState::eNotAudible :
      AudioChannelService::AudibleState::eAudible;
    mAudioChannelAgent->NotifyStartedAudible(audible,
                                             AudioChannelService::AudibleChangedReasons::eVolumeChanged);
  }
  return rv;
}

NS_IMETHODIMP
nsNPAPIPluginInstance::WindowSuspendChanged(nsSuspendedTypes aSuspend)
{
  // It doesn't support suspended, so we just do something like mute/unmute.
  WindowVolumeChanged(1.0, /* useless */
                      aSuspend != nsISuspendedTypes::NONE_SUSPENDED);
  return NS_OK;
}

NS_IMETHODIMP
nsNPAPIPluginInstance::WindowAudioCaptureChanged(bool aCapture)
{
  return NS_OK;
}

nsresult
nsNPAPIPluginInstance::SetMuted(bool aIsMuted)
{
  if (RUNNING != mRunning)
    return NS_OK;

  PLUGIN_LOG(PLUGIN_LOG_NORMAL, ("nsNPAPIPluginInstance informing plugin of mute state change this=%p\n",this));

  if (!mPlugin || !mPlugin->GetLibrary())
    return NS_ERROR_FAILURE;

  NPPluginFuncs* pluginFunctions = mPlugin->PluginFuncs();

  if (!pluginFunctions->setvalue)
    return NS_ERROR_FAILURE;

  PluginDestructionGuard guard(this);

  NPError error;
  NPBool value = static_cast<NPBool>(aIsMuted);
  NS_TRY_SAFE_CALL_RETURN(error, (*pluginFunctions->setvalue)(&mNPP, NPNVmuteAudioBool, &value), this,
                          NS_PLUGIN_CALL_UNSAFE_TO_REENTER_GECKO);
  return (error == NPERR_NO_ERROR) ? NS_OK : NS_ERROR_FAILURE;
}
