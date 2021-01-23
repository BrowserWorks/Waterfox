/* -*- Mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 * vim: sw=2 ts=4 et :
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef dom_plugins_PluginInstanceChild_h
#define dom_plugins_PluginInstanceChild_h 1

#include "mozilla/EventForwards.h"
#include "mozilla/plugins/PPluginInstanceChild.h"
#include "mozilla/plugins/PluginScriptableObjectChild.h"
#include "mozilla/plugins/StreamNotifyChild.h"
#include "mozilla/plugins/PPluginSurfaceChild.h"
#include "mozilla/ipc/CrossProcessMutex.h"
#include "nsRefPtrHashtable.h"
#if defined(OS_WIN)
#  include "mozilla/gfx/SharedDIBWin.h"
#elif defined(MOZ_WIDGET_COCOA)
#  include "PluginUtilsOSX.h"
#  include "mozilla/gfx/QuartzSupport.h"
#  include "base/timer.h"

#endif

#include "npfunctions.h"
#include "mozilla/UniquePtr.h"
#include "nsTArray.h"
#include "ChildTimer.h"
#include "nsRect.h"
#include "nsTHashtable.h"
#include "mozilla/PaintTracker.h"
#include "mozilla/gfx/Types.h"

#include <map>

class gfxASurface;

namespace mozilla {
namespace plugins {

class PBrowserStreamChild;
class BrowserStreamChild;
class StreamNotifyChild;

class PluginInstanceChild : public PPluginInstanceChild {
  friend class BrowserStreamChild;
  friend class PluginStreamChild;
  friend class StreamNotifyChild;
  friend class PluginScriptableObjectChild;
  friend class PPluginInstanceChild;

#ifdef OS_WIN
  friend LRESULT CALLBACK PluginWindowProc(HWND hWnd, UINT message,
                                           WPARAM wParam, LPARAM lParam);
  static LRESULT CALLBACK PluginWindowProcInternal(HWND hWnd, UINT message,
                                                   WPARAM wParam,
                                                   LPARAM lParam);
#endif

 protected:
  mozilla::ipc::IPCResult AnswerCreateChildPluginWindow(
      NativeWindowHandle* aChildPluginWindow);

  mozilla::ipc::IPCResult RecvCreateChildPopupSurrogate(
      const NativeWindowHandle& aNetscapeWindow);

  mozilla::ipc::IPCResult AnswerNPP_SetWindow(const NPRemoteWindow& window);

  mozilla::ipc::IPCResult AnswerNPP_GetValue_NPPVpluginWantsAllNetworkStreams(
      bool* wantsAllStreams, NPError* rv);
  mozilla::ipc::IPCResult AnswerNPP_GetValue_NPPVpluginScriptableNPObject(
      PPluginScriptableObjectChild** value, NPError* result);
  mozilla::ipc::IPCResult
  AnswerNPP_GetValue_NPPVpluginNativeAccessibleAtkPlugId(nsCString* aPlugId,
                                                         NPError* aResult);
  mozilla::ipc::IPCResult AnswerNPP_SetValue_NPNVprivateModeBool(
      const bool& value, NPError* result);
  mozilla::ipc::IPCResult AnswerNPP_SetValue_NPNVmuteAudioBool(
      const bool& value, NPError* result);
  mozilla::ipc::IPCResult AnswerNPP_SetValue_NPNVCSSZoomFactor(
      const double& value, NPError* result);

  mozilla::ipc::IPCResult AnswerNPP_HandleEvent(const NPRemoteEvent& event,
                                                int16_t* handled);
  mozilla::ipc::IPCResult AnswerNPP_HandleEvent_Shmem(
      const NPRemoteEvent& event, Shmem&& mem, int16_t* handled, Shmem* rtnmem);
  mozilla::ipc::IPCResult AnswerNPP_HandleEvent_IOSurface(
      const NPRemoteEvent& event, const uint32_t& surface, int16_t* handled);

  // Async rendering
  mozilla::ipc::IPCResult RecvAsyncSetWindow(const gfxSurfaceType& aSurfaceType,
                                             const NPRemoteWindow& aWindow);

  virtual void DoAsyncSetWindow(const gfxSurfaceType& aSurfaceType,
                                const NPRemoteWindow& aWindow, bool aIsAsync);

  PPluginSurfaceChild* AllocPPluginSurfaceChild(
      const WindowsSharedMemoryHandle&, const gfx::IntSize&, const bool&) {
    return new PPluginSurfaceChild();
  }

  bool DeallocPPluginSurfaceChild(PPluginSurfaceChild* s) {
    delete s;
    return true;
  }

  mozilla::ipc::IPCResult AnswerPaint(const NPRemoteEvent& event,
                                      int16_t* handled) {
    PaintTracker pt;
    if (!AnswerNPP_HandleEvent(event, handled)) {
      return IPC_FAIL_NO_REASON(this);
    }
    return IPC_OK();
  }

  mozilla::ipc::IPCResult RecvWindowPosChanged(const NPRemoteEvent& event);

  mozilla::ipc::IPCResult RecvContentsScaleFactorChanged(
      const double& aContentsScaleFactor);

  mozilla::ipc::IPCResult AnswerNPP_Destroy(NPError* result);

  PPluginScriptableObjectChild* AllocPPluginScriptableObjectChild();

  bool DeallocPPluginScriptableObjectChild(
      PPluginScriptableObjectChild* aObject);

  virtual mozilla::ipc::IPCResult RecvPPluginScriptableObjectConstructor(
      PPluginScriptableObjectChild* aActor) override;

  virtual mozilla::ipc::IPCResult RecvPBrowserStreamConstructor(
      PBrowserStreamChild* aActor, const nsCString& aURL,
      const uint32_t& aLength, const uint32_t& aLastmodified,
      PStreamNotifyChild* aNotifyData, const nsCString& aHeaders) override;

  mozilla::ipc::IPCResult AnswerNPP_NewStream(PBrowserStreamChild* actor,
                                              const nsCString& mimeType,
                                              const bool& seekable, NPError* rv,
                                              uint16_t* stype);

  PBrowserStreamChild* AllocPBrowserStreamChild(const nsCString& url,
                                                const uint32_t& length,
                                                const uint32_t& lastmodified,
                                                PStreamNotifyChild* notifyData,
                                                const nsCString& headers);

  bool DeallocPBrowserStreamChild(PBrowserStreamChild* stream);

  PStreamNotifyChild* AllocPStreamNotifyChild(
      const nsCString& url, const nsCString& target, const bool& post,
      const nsCString& buffer, const bool& file, NPError* result);

  bool DeallocPStreamNotifyChild(PStreamNotifyChild* notifyData);

  mozilla::ipc::IPCResult AnswerSetPluginFocus();

  mozilla::ipc::IPCResult AnswerUpdateWindow();

  mozilla::ipc::IPCResult RecvNPP_DidComposite();

 public:
  PluginInstanceChild(const NPPluginFuncs* aPluginIface,
                      const nsCString& aMimeType,
                      const nsTArray<nsCString>& aNames,
                      const nsTArray<nsCString>& aValues);

  virtual ~PluginInstanceChild();

  NPError DoNPP_New();

  // Common sync+async implementation of NPP_NewStream
  NPError DoNPP_NewStream(BrowserStreamChild* actor, const nsCString& mimeType,
                          const bool& seekable, uint16_t* stype);

  bool Initialize();

  NPP GetNPP() { return &mData; }

  NPError NPN_GetValue(NPNVariable aVariable, void* aValue);

  NPError NPN_SetValue(NPPVariable aVariable, void* aValue);

  PluginScriptableObjectChild* GetActorForNPObject(NPObject* aObject);

  NPError NPN_NewStream(NPMIMEType aMIMEType, const char* aWindow,
                        NPStream** aStream);

  void InvalidateRect(NPRect* aInvalidRect);

#ifdef MOZ_WIDGET_COCOA
  void Invalidate();
#endif  // definied(MOZ_WIDGET_COCOA)

  uint32_t ScheduleTimer(uint32_t interval, bool repeat, TimerFunc func);
  void UnscheduleTimer(uint32_t id);

  int GetQuirks();

  void NPN_URLRedirectResponse(void* notifyData, NPBool allow);

  NPError NPN_InitAsyncSurface(NPSize* size, NPImageFormat format,
                               void* initData, NPAsyncSurface* surface);
  NPError NPN_FinalizeAsyncSurface(NPAsyncSurface* surface);

  void NPN_SetCurrentAsyncSurface(NPAsyncSurface* surface, NPRect* changed);

  void DoAsyncRedraw();

  mozilla::ipc::IPCResult RecvHandledWindowedPluginKeyEvent(
      const NativeEventData& aKeyEventData, const bool& aIsConsumed);

#if defined(XP_WIN)
  NPError DefaultAudioDeviceChanged(NPAudioDeviceChangeDetails& details);
  NPError AudioDeviceStateChanged(NPAudioDeviceStateChanged& aDeviceState);
#endif

 private:
  friend class PluginModuleChild;

  NPError InternalGetNPObjectForValue(NPNVariable aValue, NPObject** aObject);

  bool IsUsingDirectDrawing();

  mozilla::ipc::IPCResult RecvUpdateBackground(
      const SurfaceDescriptor& aBackground, const nsIntRect& aRect);

  PPluginBackgroundDestroyerChild* AllocPPluginBackgroundDestroyerChild();

  mozilla::ipc::IPCResult RecvPPluginBackgroundDestroyerConstructor(
      PPluginBackgroundDestroyerChild* aActor) override;

  bool DeallocPPluginBackgroundDestroyerChild(
      PPluginBackgroundDestroyerChild* aActor);

#if defined(OS_WIN)
  static bool RegisterWindowClass();
  bool CreatePluginWindow();
  void DestroyPluginWindow();
  void SizePluginWindow(int width, int height);
  int16_t WinlessHandleEvent(NPEvent& event);
  void CreateWinlessPopupSurrogate();
  void DestroyWinlessPopupSurrogate();
  void InitPopupMenuHook();
  void SetupFlashMsgThrottle();
  void UnhookWinlessFlashThrottle();
  void HookSetWindowLongPtr();
  void InitImm32Hook();
  static inline bool SetWindowLongHookCheck(HWND hWnd, int nIndex,
                                            LONG_PTR newLong);
  void FlashThrottleMessage(HWND, UINT, WPARAM, LPARAM, bool);
  static LRESULT CALLBACK DummyWindowProc(HWND hWnd, UINT message,
                                          WPARAM wParam, LPARAM lParam);
  static LRESULT CALLBACK PluginWindowProc(HWND hWnd, UINT message,
                                           WPARAM wParam, LPARAM lParam);
  static BOOL WINAPI TrackPopupHookProc(HMENU hMenu, UINT uFlags, int x, int y,
                                        int nReserved, HWND hWnd,
                                        CONST RECT* prcRect);
  static BOOL CALLBACK EnumThreadWindowsCallback(HWND hWnd, LPARAM aParam);
  static LRESULT CALLBACK WinlessHiddenFlashWndProc(HWND hWnd, UINT message,
                                                    WPARAM wParam,
                                                    LPARAM lParam);
#  ifdef _WIN64
  static LONG_PTR WINAPI SetWindowLongPtrAHook(HWND hWnd, int nIndex,
                                               LONG_PTR newLong);
  static LONG_PTR WINAPI SetWindowLongPtrWHook(HWND hWnd, int nIndex,
                                               LONG_PTR newLong);

#  else
  static LONG WINAPI SetWindowLongAHook(HWND hWnd, int nIndex, LONG newLong);
  static LONG WINAPI SetWindowLongWHook(HWND hWnd, int nIndex, LONG newLong);
#  endif

  static HIMC WINAPI ImmGetContextProc(HWND aWND);
  static LONG WINAPI ImmGetCompositionStringProc(HIMC aIMC, DWORD aIndex,
                                                 LPVOID aBuf, DWORD aLen);
  static BOOL WINAPI ImmSetCandidateWindowProc(HIMC hIMC,
                                               LPCANDIDATEFORM plCandidate);
  static BOOL WINAPI ImmNotifyIME(HIMC aIMC, DWORD aAction, DWORD aIndex,
                                  DWORD aValue);
  static BOOL WINAPI ImmAssociateContextExProc(HWND hWnd, HIMC aIMC,
                                               DWORD dwFlags);

  class FlashThrottleMsg : public CancelableRunnable {
   public:
    FlashThrottleMsg(PluginInstanceChild* aInstance, HWND aWnd, UINT aMsg,
                     WPARAM aWParam, LPARAM aLParam, bool isWindowed)
        : CancelableRunnable("FlashThrottleMsg"),
          mInstance(aInstance),
          mWnd(aWnd),
          mMsg(aMsg),
          mWParam(aWParam),
          mLParam(aLParam),
          mWindowed(isWindowed) {}

    NS_IMETHOD Run() override;
    nsresult Cancel() override;

    WNDPROC GetProc();
    HWND GetWnd() { return mWnd; }
    UINT GetMsg() { return mMsg; }
    WPARAM GetWParam() { return mWParam; }
    LPARAM GetLParam() { return mLParam; }

   private:
    PluginInstanceChild* mInstance;
    HWND mWnd;
    UINT mMsg;
    WPARAM mWParam;
    LPARAM mLParam;
    bool mWindowed;
  };

  bool ShouldPostKeyMessage(UINT message, WPARAM wParam, LPARAM lParam);
  bool MaybePostKeyMessage(UINT message, WPARAM wParam, LPARAM lParam);
#endif  // #if defined(OS_WIN)
  const NPPluginFuncs* mPluginIface;
  nsCString mMimeType;
  nsTArray<nsCString> mNames;
  nsTArray<nsCString> mValues;
  NPP_t mData;
  NPWindow mWindow;
#if defined(XP_DARWIN) || defined(XP_WIN)
  double mContentsScaleFactor;
#endif
  double mCSSZoomFactor;
  uint32_t mPostingKeyEvents;
  uint32_t mPostingKeyEventsOutdated;
  int16_t mDrawingModel;

  NPAsyncSurface* mCurrentDirectSurface;

  // The surface hashtables below serve a few purposes. They let us verify
  // and retain extra information about plugin surfaces, and they let us
  // free shared memory that the plugin might forget to release.
  struct DirectBitmap {
    DirectBitmap(PluginInstanceChild* aOwner, const Shmem& shmem,
                 const gfx::IntSize& size, uint32_t stride,
                 SurfaceFormat format);

   private:
    ~DirectBitmap();

   public:
    NS_INLINE_DECL_THREADSAFE_REFCOUNTING(DirectBitmap);

    PluginInstanceChild* mOwner;
    Shmem mShmem;
    gfx::SurfaceFormat mFormat;
    gfx::IntSize mSize;
    uint32_t mStride;
  };
  nsRefPtrHashtable<nsPtrHashKey<NPAsyncSurface>, DirectBitmap> mDirectBitmaps;

#if defined(XP_WIN)
  nsDataHashtable<nsPtrHashKey<NPAsyncSurface>, WindowsHandle> mDxgiSurfaces;
#endif

  mozilla::Mutex mAsyncInvalidateMutex;
  CancelableRunnable* mAsyncInvalidateTask;

  // Cached scriptable actors to avoid IPC churn
  PluginScriptableObjectChild* mCachedWindowActor;
  PluginScriptableObjectChild* mCachedElementActor;

#if defined(MOZ_X11) && defined(XP_UNIX) && !defined(XP_MACOSX)
  NPSetWindowCallbackStruct mWsInfo;
#elif defined(OS_WIN)
  HWND mPluginWindowHWND;
  WNDPROC mPluginWndProc;
  HWND mPluginParentHWND;
  int mNestedEventLevelDepth;
  HWND mCachedWinlessPluginHWND;
  HWND mWinlessPopupSurrogateHWND;
  nsIntPoint mPluginSize;
  WNDPROC mWinlessThrottleOldWndProc;
  HWND mWinlessHiddenMsgHWND;
#endif

#if defined(OS_WIN)
  nsTArray<FlashThrottleMsg*> mPendingFlashThrottleMsgs;
#endif
  nsTArray<UniquePtr<ChildTimer> > mTimers;

  /**
   * During destruction we enumerate all remaining scriptable objects and
   * invalidate/delete them. Enumeration can re-enter, so maintain a
   * hash separate from PluginModuleChild.mObjectMap.
   */
  UniquePtr<nsTHashtable<DeletingObjectEntry> > mDeletingHash;

#if defined(MOZ_WIDGET_COCOA)
 private:
#  if defined(__i386__)
  NPEventModel mEventModel;
#  endif
  CGColorSpaceRef mShColorSpace;
  CGContextRef mShContext;
  RefPtr<nsCARenderer> mCARenderer;
  void* mCGLayer;

  // Core Animation drawing model requires a refresh timer.
  uint32_t mCARefreshTimer;

 public:
  const NPCocoaEvent* getCurrentEvent() { return mCurrentEvent; }

  bool CGDraw(CGContextRef ref, nsIntRect aUpdateRect);

#  if defined(__i386__)
  NPEventModel EventModel() { return mEventModel; }
#  endif

 private:
  const NPCocoaEvent* mCurrentEvent;
#endif

  bool CanPaintOnBackground();

  bool IsVisible() {
#ifdef XP_MACOSX
    return mWindow.clipRect.top != mWindow.clipRect.bottom &&
           mWindow.clipRect.left != mWindow.clipRect.right;
#else
    return mWindow.clipRect.top != 0 || mWindow.clipRect.left != 0 ||
           mWindow.clipRect.bottom != 0 || mWindow.clipRect.right != 0;
#endif
  }

  // ShowPluginFrame - in general does four things:
  // 1) Create mCurrentSurface optimized for rendering to parent process
  // 2) Updated mCurrentSurface to be a complete copy of mBackSurface
  // 3) Draw the invalidated plugin area into mCurrentSurface
  // 4) Send it to parent process.
  bool ShowPluginFrame(void);

  // If we can read back safely from mBackSurface, copy
  // mSurfaceDifferenceRect from mBackSurface to mFrontSurface.
  // @return Whether the back surface could be read.
  bool ReadbackDifferenceRect(const nsIntRect& rect);

  // Post ShowPluginFrame task
  void AsyncShowPluginFrame(void);

  // In the PaintRect functions, aSurface is the size of the full plugin
  // window. Each PaintRect function renders into the subrectangle aRect of
  // aSurface (possibly more if we're working around a Flash bug).

  // Paint plugin content rectangle to surface with bg color filling
  void PaintRectToSurface(const nsIntRect& aRect, gfxASurface* aSurface,
                          const gfx::DeviceColor& aColor);

  // Render plugin content to surface using
  // white/black image alpha extraction algorithm
  void PaintRectWithAlphaExtraction(const nsIntRect& aRect,
                                    gfxASurface* aSurface);

  // Call plugin NPAPI function to render plugin content to surface
  // @param - aSurface - should be compatible with current platform plugin
  // rendering
  // @return - FALSE if plugin not painted to surface
  void PaintRectToPlatformSurface(const nsIntRect& aRect,
                                  gfxASurface* aSurface);

  // Update NPWindow platform attributes and call plugin "setwindow"
  // @param - aForceSetWindow - call setwindow even if platform attributes are
  // the same
  void UpdateWindowAttributes(bool aForceSetWindow = false);

  // Create optimized mCurrentSurface for parent process rendering
  // @return FALSE if optimized surface not created
  bool CreateOptSurface(void);

  // Create mHelperSurface if mCurrentSurface non compatible with plugins
  // @return TRUE if helper surface created successfully, or not needed
  bool MaybeCreatePlatformHelperSurface(void);

  // Make sure that we have surface for rendering
  bool EnsureCurrentBuffer(void);

  // Helper function for delayed InvalidateRect call
  // non null mCurrentInvalidateTask will call this function
  void InvalidateRectDelayed(void);

  // Clear mCurrentSurface/mCurrentSurfaceActor/mHelperSurface
  void ClearCurrentSurface();

  // Swap mCurrentSurface/mBackSurface and their associated actors
  void SwapSurfaces();

  // Clear all surfaces in response to NPP_Destroy
  void ClearAllSurfaces();

  void Destroy();

  void ActorDestroy(ActorDestroyReason aWhy) override;

  // Set as true when SetupLayer called
  // and go with different path in InvalidateRect function
  bool mLayersRendering;

  // Current surface available for rendering
  RefPtr<gfxASurface> mCurrentSurface;

  // Back surface, just keeping reference to
  // surface which is on ParentProcess side
  RefPtr<gfxASurface> mBackSurface;

#ifdef XP_MACOSX
  // Current IOSurface available for rendering
  // We can't use thebes gfxASurface like other platforms.
  PluginUtilsOSX::nsDoubleBufferCARenderer mDoubleBufferCARenderer;
#endif

  // (Not to be confused with mBackSurface).  This is a recent copy
  // of the opaque pixels under our object frame, if
  // |mIsTransparent|.  We ask the plugin render directly onto a
  // copy of the background pixels if available, and fall back on
  // alpha recovery otherwise.
  RefPtr<gfxASurface> mBackground;

#ifdef XP_WIN
  // These actors mirror mCurrentSurface/mBackSurface
  PPluginSurfaceChild* mCurrentSurfaceActor;
  PPluginSurfaceChild* mBackSurfaceActor;
#endif

  // Accumulated invalidate rect, while back buffer is not accessible,
  // in plugin coordinates.
  nsIntRect mAccumulatedInvalidRect;

  // Plugin only call SetTransparent
  // and does not remember their transparent state
  // and p->getvalue return always false
  bool mIsTransparent;

  // Surface type optimized of parent process
  gfxSurfaceType mSurfaceType;

  // Keep InvalidateRect task pointer to be able Cancel it on Destroy
  RefPtr<CancelableRunnable> mCurrentInvalidateTask;

  // Keep AsyncSetWindow task pointer to be able to Cancel it on Destroy
  RefPtr<CancelableRunnable> mCurrentAsyncSetWindowTask;

  // True while plugin-child in plugin call
  // Use to prevent plugin paint re-enter
  bool mPendingPluginCall;

  // On some platforms, plugins may not support rendering to a surface with
  // alpha, or not support rendering to an image surface.
  // In those cases we need to draw to a temporary platform surface; we cache
  // that surface here.
  RefPtr<gfxASurface> mHelperSurface;

  // true when plugin does not support painting to ARGB32
  // surface this is false if plugin supports
  // NPPVpluginTransparentAlphaBool (which is not part of
  // NPAPI yet)
  bool mDoAlphaExtraction;

  // true when the plugin has painted at least once. We use this to ensure
  // that we ask a plugin to paint at least once even if it's invisible;
  // some plugin (instances) rely on this in order to work properly.
  bool mHasPainted;

  // Cached rectangle rendered to previous surface(mBackSurface)
  // Used for reading back to current surface and syncing data,
  // in plugin coordinates.
  nsIntRect mSurfaceDifferenceRect;

  // Has this instance been destroyed, either by ActorDestroy or NPP_Destroy?
  bool mDestroyed;

#ifdef XP_WIN
  // WM_*CHAR messages are never consumed by chrome process's widget.
  // So, if preceding keydown or keyup event is consumed by reserved
  // shortcut key in the chrome process, we shouldn't send the following
  // WM_*CHAR messages to the plugin.
  bool mLastKeyEventConsumed;

  // Store the last IME state by ImmAssociateContextEx.  This will reset by
  // WM_KILLFOCUS;
  bool mLastEnableIMEState;
#endif  // #ifdef XP_WIN

  // While IME in the process has composition, this is set to true.
  // Otherwise, false.
  static bool sIsIMEComposing;

  // A counter is incremented by AutoStackHelper to indicate that there is an
  // active plugin call which should be preventing shutdown.
 public:
  class AutoStackHelper {
   public:
    explicit AutoStackHelper(PluginInstanceChild* instance)
        : mInstance(instance) {
      ++mInstance->mStackDepth;
    }
    ~AutoStackHelper() { --mInstance->mStackDepth; }

   private:
    PluginInstanceChild* const mInstance;
  };

 private:
  int32_t mStackDepth;
};

}  // namespace plugins
}  // namespace mozilla

#endif  // ifndef dom_plugins_PluginInstanceChild_h
