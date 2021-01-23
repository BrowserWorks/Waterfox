/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
// vim:set ts=2 sts=2 sw=2 et cin:
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef nsPluginInstanceOwner_h_
#define nsPluginInstanceOwner_h_

#include "mozilla/Attributes.h"
#include "mozilla/StaticPtr.h"
#include "mozilla/dom/HTMLObjectElementBinding.h"
#include "npapi.h"
#include "nsCOMPtr.h"
#include "nsIKeyEventInPluginCallback.h"
#include "nsIPluginInstanceOwner.h"
#include "nsIPrivacyTransitionObserver.h"
#include "nsIDOMEventListener.h"
#include "nsPluginHost.h"
#include "nsPluginNativeWindow.h"
#include "nsWeakReference.h"
#include "gfxRect.h"

#ifdef XP_MACOSX
#  include "mozilla/gfx/QuartzSupport.h"
#  include <ApplicationServices/ApplicationServices.h>
#endif

class nsIInputStream;
class nsPluginDOMContextMenuListener;
class nsPluginFrame;
class nsDisplayListBuilder;

#if defined(MOZ_X11)
class gfxContext;
#endif

namespace mozilla {
class TextComposition;
namespace dom {
class Element;
class Event;
}  // namespace dom
namespace widget {
class PuppetWidget;
}  // namespace widget
}  // namespace mozilla

using mozilla::widget::PuppetWidget;

#ifdef MOZ_X11
#  include "gfxXlibNativeRenderer.h"
#endif

class nsPluginInstanceOwner final : public nsIPluginInstanceOwner,
                                    public nsIDOMEventListener,
                                    public nsIPrivacyTransitionObserver,
                                    public nsIKeyEventInPluginCallback,
                                    public nsSupportsWeakReference {
 public:
  typedef mozilla::gfx::DrawTarget DrawTarget;

  nsPluginInstanceOwner();

  NS_DECL_ISUPPORTS
  NS_DECL_NSIPLUGININSTANCEOWNER
  NS_DECL_NSIPRIVACYTRANSITIONOBSERVER

  NS_IMETHOD GetURL(const char* aURL, const char* aTarget,
                    nsIInputStream* aPostStream, void* aHeadersData,
                    uint32_t aHeadersDataLen,
                    bool aDoCheckLoadURIChecks) override;

  NPBool ConvertPoint(double sourceX, double sourceY,
                      NPCoordinateSpace sourceSpace, double* destX,
                      double* destY, NPCoordinateSpace destSpace) override;

  NPError InitAsyncSurface(NPSize* size, NPImageFormat format, void* initData,
                           NPAsyncSurface* surface) override;
  NPError FinalizeAsyncSurface(NPAsyncSurface* surface) override;
  void SetCurrentAsyncSurface(NPAsyncSurface* surface,
                              NPRect* changed) override;

  /**
   * Get the type of the HTML tag that was used ot instantiate this
   * plugin.  Currently supported tags are EMBED or OBJECT.
   */
  NS_IMETHOD GetTagType(nsPluginTagType* aResult);

  void GetParameters(nsTArray<mozilla::dom::MozPluginParameter>& parameters);
  void GetAttributes(nsTArray<mozilla::dom::MozPluginParameter>& attributes);

  /**
   * Returns the DOM element corresponding to the tag which references
   * this plugin in the document.
   *
   * @param aDOMElement - resulting DOM element
   * @result - NS_OK if this operation was successful
   */
  NS_IMETHOD GetDOMElement(mozilla::dom::Element** aResult);

  // nsIDOMEventListener interfaces
  NS_DECL_NSIDOMEVENTLISTENER

  nsresult ProcessMouseDown(mozilla::dom::Event* aMouseEvent);
  nsresult ProcessKeyPress(mozilla::dom::Event* aKeyEvent);
  nsresult Destroy();

#ifdef XP_WIN
  void Paint(const RECT& aDirty, HDC aDC);
#elif defined(XP_MACOSX)
  void Paint(const gfxRect& aDirtyRect, CGContextRef cgContext);
  void RenderCoreAnimation(CGContextRef aCGContext, int aWidth, int aHeight);
  void DoCocoaEventDrawRect(const gfxRect& aDrawRect, CGContextRef cgContext);
#elif defined(MOZ_X11)
  void Paint(gfxContext* aContext, const gfxRect& aFrameRect,
             const gfxRect& aDirtyRect);
#endif

  // locals

  nsresult Init(nsIContent* aContent);

  void* GetPluginPort();
  void ReleasePluginPort(void* pluginPort);

  nsEventStatus ProcessEvent(const mozilla::WidgetGUIEvent& anEvent);

  static void GeneratePluginEvent(
      const mozilla::WidgetCompositionEvent* aSrcCompositionEvent,
      mozilla::WidgetCompositionEvent* aDistCompositionEvent);

#if defined(XP_WIN)
  void SetWidgetWindowAsParent(HWND aWindowToAdopt);
  nsresult SetNetscapeWindowAsParent(HWND aWindowToAdopt);
#endif

#ifdef XP_MACOSX
  enum {ePluginPaintEnable, ePluginPaintDisable};

  void WindowFocusMayHaveChanged();

  bool WindowIsActive();
  void SendWindowFocusChanged(bool aIsActive);
  NPDrawingModel GetDrawingModel();
  bool IsRemoteDrawingCoreAnimation();

  NPEventModel GetEventModel();
  static void CARefresh(nsITimer* aTimer, void* aClosure);
  void AddToCARefreshTimer();
  void RemoveFromCARefreshTimer();
  // This calls into the plugin (NPP_SetWindow) and can run script.
  void FixUpPluginWindow(int32_t inPaintState);
  void HidePluginWindow();
  // Set plugin port info in the plugin (in the 'window' member of the
  // NPWindow structure passed to the plugin by SetWindow()).
  void SetPluginPort();
#else   // XP_MACOSX
  void UpdateWindowPositionAndClipRect(bool aSetWindow);
  void UpdateWindowVisibility(bool aVisible);
#endif  // XP_MACOSX

  void ResolutionMayHaveChanged();
#if defined(XP_MACOSX) || defined(XP_WIN)
  nsresult ContentsScaleFactorChanged(double aContentsScaleFactor);
#endif

  void UpdateDocumentActiveState(bool aIsActive);

  void SetFrame(nsPluginFrame* aFrame);
  nsPluginFrame* GetFrame();

  uint32_t GetLastEventloopNestingLevel() const {
    return mLastEventloopNestingLevel;
  }

  static uint32_t GetEventloopNestingLevel();

  void ConsiderNewEventloopNestingLevel() {
    uint32_t currentLevel = GetEventloopNestingLevel();

    if (currentLevel < mLastEventloopNestingLevel) {
      mLastEventloopNestingLevel = currentLevel;
    }
  }

  const char* GetPluginName() {
    if (mInstance && mPluginHost) {
      const char* name = nullptr;
      if (NS_SUCCEEDED(mPluginHost->GetPluginName(mInstance, &name)) && name)
        return name;
    }
    return "";
  }

#ifdef MOZ_X11
  void GetPluginDescription(nsACString& aDescription) {
    aDescription.Truncate();
    if (mInstance && mPluginHost) {
      nsCOMPtr<nsIPluginTag> pluginTag;

      mPluginHost->GetPluginTagForInstance(mInstance,
                                           getter_AddRefs(pluginTag));
      if (pluginTag) {
        pluginTag->GetDescription(aDescription);
      }
    }
  }
#endif

  bool SendNativeEvents() {
#ifdef XP_WIN
    // XXX we should remove the plugin name check
    return mPluginWindow->type == NPWindowTypeDrawable &&
           (MatchPluginName("Shockwave Flash") ||
            MatchPluginName("Test Plug-in"));
#elif defined(MOZ_X11) || defined(XP_MACOSX)
    return true;
#else
    return false;
#endif
  }

  bool MatchPluginName(const char* aPluginName) {
    return strncmp(GetPluginName(), aPluginName, strlen(aPluginName)) == 0;
  }

  void NotifyPaintWaiter(nsDisplayListBuilder* aBuilder);

  // Returns the image container that has our currently displayed image.
  already_AddRefed<mozilla::layers::ImageContainer> GetImageContainer();
  // Returns true if this is windowed plugin that can return static captures
  // for scroll operations.
  bool NeedsScrollImageLayer();

  void DidComposite();

  /**
   * Returns the bounds of the current async-rendered surface. This can only
   * change in response to messages received by the event loop (i.e. not during
   * painting).
   */
  nsIntSize GetCurrentImageSize();

  // Methods to update the background image we send to async plugins.
  // The eventual target of these operations is PluginInstanceParent,
  // but it takes several hops to get there.
  void SetBackgroundUnknown();
  already_AddRefed<DrawTarget> BeginUpdateBackground(const nsIntRect& aRect);
  void EndUpdateBackground(const nsIntRect& aRect);

  bool UseAsyncRendering();

  nsIURI* GetBaseURI() const;

  bool GetCompositionString(uint32_t aIndex, nsTArray<uint8_t>* aString,
                            int32_t* aLength);
  bool SetCandidateWindow(
      const mozilla::widget::CandidateWindowPosition& aPosition);
  bool RequestCommitOrCancel(bool aCommitted);
  bool EnableIME(bool aEnable);

  // See nsIKeyEventInPluginCallback
  virtual void HandledWindowedPluginKeyEvent(
      const mozilla::NativeEventData& aKeyEventData, bool aIsConsumed) override;

  /**
   * OnWindowedPluginKeyEvent() is called when the plugin process receives
   * native key event directly.
   *
   * @param aNativeKeyData      The key event which was received by the
   *                            plugin process directly.
   */
  void OnWindowedPluginKeyEvent(const mozilla::NativeEventData& aNativeKeyData);

  void GetCSSZoomFactor(float* result);

 private:
  virtual ~nsPluginInstanceOwner();

  // return FALSE if LayerSurface dirty (newly created and don't have valid
  // plugin content yet)
  bool IsUpToDate() {
    nsIntSize size;
    return NS_SUCCEEDED(mInstance->GetImageSize(&size)) &&
           size == nsIntSize(mPluginWindow->width, mPluginWindow->height);
  }

#if defined(XP_WIN)
  nsIWidget* GetContainingWidgetIfOffset();
  already_AddRefed<mozilla::TextComposition> GetTextComposition();
  void HandleNoConsumedCompositionMessage(
      mozilla::WidgetCompositionEvent* aCompositionEvent,
      const NPEvent* aPluginEvent);
  bool mGotCompositionData;
  bool mSentStartComposition;
  bool mPluginDidNotHandleIMEComposition;
  uint32_t mWheelScrollLines;
  uint32_t mWheelScrollChars;
#endif

  nsPluginNativeWindow* mPluginWindow;
  RefPtr<nsNPAPIPluginInstance> mInstance;
  nsPluginFrame* mPluginFrame;
  nsWeakPtr mContent;  // WEAK, content owns us
  nsCString mDocumentBase;
  bool mWidgetCreationComplete;
  nsCOMPtr<nsIWidget> mWidget;
  RefPtr<nsPluginHost> mPluginHost;

#ifdef XP_MACOSX
  static mozilla::StaticRefPtr<nsITimer> sCATimer;
  static nsTArray<nsPluginInstanceOwner*>* sCARefreshListeners;
  bool mSentInitialTopLevelWindowEvent;
  bool mLastWindowIsActive;
  bool mLastContentFocused;
  // True if, the next time the window is activated, we should blur ourselves.
  bool mShouldBlurOnActivate;
#endif
  double mLastScaleFactor;
  double mLastCSSZoomFactor;
  // Initially, the event loop nesting level we were created on, it's updated
  // if we detect the appshell is on a lower level as long as we're not stopped.
  // We delay DoStopPlugin() until the appshell reaches this level or lower.
  uint32_t mLastEventloopNestingLevel;
  bool mContentFocused;
  bool mWidgetVisible;  // used on Mac to store our widget's visible state
#ifdef MOZ_X11
  // Used with windowless plugins only, initialized in CreateWidget().
  bool mFlash10Quirks;
#endif
  bool mPluginWindowVisible;
  bool mPluginDocumentActiveState;

#ifdef XP_MACOSX
  NPEventModel mEventModel;
  // This is a hack! UseAsyncRendering() can incorrectly return false
  // when we don't have an object frame (possible as of bug 90268).
  // We hack around this by always returning true if we've ever
  // returned true.
  bool mUseAsyncRendering;
#endif

  // pointer to wrapper for nsIDOMContextMenuListener
  RefPtr<nsPluginDOMContextMenuListener> mCXMenuListener;

  nsresult DispatchKeyToPlugin(mozilla::dom::Event* aKeyEvent);
  nsresult DispatchMouseToPlugin(mozilla::dom::Event* aMouseEvent,
                                 bool aAllowPropagate = false);
  nsresult DispatchFocusToPlugin(mozilla::dom::Event* aFocusEvent);
  nsresult DispatchCompositionToPlugin(mozilla::dom::Event* aEvent);

#ifdef XP_WIN
  void CallDefaultProc(const mozilla::WidgetGUIEvent* aEvent);
#endif

#ifdef XP_MACOSX
  static NPBool ConvertPointPuppet(PuppetWidget* widget,
                                   nsPluginFrame* pluginFrame, double sourceX,
                                   double sourceY,
                                   NPCoordinateSpace sourceSpace, double* destX,
                                   double* destY, NPCoordinateSpace destSpace);
  static NPBool ConvertPointNoPuppet(nsIWidget* widget,
                                     nsPluginFrame* pluginFrame, double sourceX,
                                     double sourceY,
                                     NPCoordinateSpace sourceSpace,
                                     double* destX, double* destY,
                                     NPCoordinateSpace destSpace);
  void PerformDelayedBlurs();
#endif  // XP_MACOSX

  int mLastMouseDownButtonType;

#ifdef MOZ_X11
  class Renderer : public gfxXlibNativeRenderer {
   public:
    Renderer(NPWindow* aWindow, nsPluginInstanceOwner* aInstanceOwner,
             const nsIntSize& aPluginSize, const nsIntRect& aDirtyRect)
        : mWindow(aWindow),
          mInstanceOwner(aInstanceOwner),
          mPluginSize(aPluginSize),
          mDirtyRect(aDirtyRect) {}
    virtual nsresult DrawWithXlib(cairo_surface_t* surface, nsIntPoint offset,
                                  nsIntRect* clipRects,
                                  uint32_t numClipRects) override;

   private:
    NPWindow* mWindow;
    nsPluginInstanceOwner* mInstanceOwner;
    const nsIntSize& mPluginSize;
    const nsIntRect& mDirtyRect;
  };
#endif

  bool mWaitingForPaint;
};

#endif  // nsPluginInstanceOwner_h_
