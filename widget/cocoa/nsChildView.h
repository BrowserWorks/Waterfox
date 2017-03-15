/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef nsChildView_h_
#define nsChildView_h_

// formal protocols
#include "mozView.h"
#ifdef ACCESSIBILITY
#include "mozilla/a11y/Accessible.h"
#include "mozAccessibleProtocol.h"
#endif

#include "nsISupports.h"
#include "nsBaseWidget.h"
#include "nsWeakPtr.h"
#include "TextInputHandler.h"
#include "nsCocoaUtils.h"
#include "gfxQuartzSurface.h"
#include "GLContextTypes.h"
#include "mozilla/Mutex.h"
#include "nsRegion.h"
#include "mozilla/MouseEvents.h"
#include "mozilla/UniquePtr.h"

#include "nsString.h"
#include "nsIDragService.h"
#include "ViewRegion.h"

#import <Carbon/Carbon.h>
#import <Cocoa/Cocoa.h>
#import <AppKit/NSOpenGL.h>

class nsChildView;
class nsCocoaWindow;

namespace {
class GLPresenter;
} // namespace

namespace mozilla {
class InputData;
class PanGestureInput;
class SwipeTracker;
struct SwipeEventQueue;
class VibrancyManager;
namespace layers {
class GLManager;
class IAPZCTreeManager;
} // namespace layers
namespace widget {
class RectTextureImage;
class WidgetRenderingContext;
} // namespace widget
} // namespace mozilla

@interface NSEvent (Undocumented)

// Return Cocoa event's corresponding Carbon event.  Not initialized (on
// synthetic events) until the OS actually "sends" the event.  This method
// has been present in the same form since at least OS X 10.2.8.
- (EventRef)_eventRef;

@end

@interface NSView (Undocumented)

// Draws the title string of a window.
// Present on NSThemeFrame since at least 10.6.
// _drawTitleBar is somewhat complex, and has changed over the years
// since OS X 10.6.  But in that time it's never done anything that
// would break when called outside of -[NSView drawRect:] (which we
// sometimes do), or whose output can't be redirected to a
// CGContextRef object (which we also sometimes do).  This is likely
// to remain true for the indefinite future.  However we should
// check _drawTitleBar in each new major version of OS X.  For more
// information see bug 877767.
- (void)_drawTitleBar:(NSRect)aRect;

// Returns an NSRect that is the bounding box for all an NSView's dirty
// rectangles (ones that need to be redrawn).  The full list of dirty
// rectangles can be obtained by calling -[NSView _dirtyRegion] and then
// calling -[NSRegion getRects:count:] on what it returns.  Both these
// methods have been present in the same form since at least OS X 10.5.
// Unlike -[NSView getRectsBeingDrawn:count:], these methods can be called
// outside a call to -[NSView drawRect:].
- (NSRect)_dirtyRect;

// Undocumented method of one or more of NSFrameView's subclasses.  Called
// when one or more of the titlebar buttons needs to be repositioned, to
// disappear, or to reappear (say if the window's style changes).  If
// 'redisplay' is true, the entire titlebar (the window's top 22 pixels) is
// marked as needing redisplay.  This method has been present in the same
// format since at least OS X 10.5.
- (void)_tileTitlebarAndRedisplay:(BOOL)redisplay;

// The following undocumented methods are used to work around bug 1069658,
// which is an Apple bug or design flaw that effects Yosemite.  None of them
// were present prior to Yosemite (OS X 10.10).
- (NSView *)titlebarView; // Method of NSThemeFrame
- (NSView *)titlebarContainerView; // Method of NSThemeFrame
- (BOOL)transparent; // Method of NSTitlebarView and NSTitlebarContainerView
- (void)setTransparent:(BOOL)transparent; // Method of NSTitlebarView and
                                          // NSTitlebarContainerView

@end

@interface ChildView : NSView<
#ifdef ACCESSIBILITY
                              mozAccessible,
#endif
                              mozView, NSTextInputClient>
{
@private
  // the nsChildView that created the view. It retains this NSView, so
  // the link back to it must be weak.
  nsChildView* mGeckoChild;

  // Text input handler for mGeckoChild and us.  Note that this is a weak
  // reference.  Ideally, this should be a strong reference but a ChildView
  // object can live longer than the mGeckoChild that owns it.  And if
  // mTextInputHandler were a strong reference, this would make it difficult
  // for Gecko's leak detector to detect leaked TextInputHandler objects.
  // This is initialized by [mozView installTextInputHandler:aHandler] and
  // cleared by [mozView uninstallTextInputHandler].
  mozilla::widget::TextInputHandler* mTextInputHandler;  // [WEAK]

  // when mouseDown: is called, we store its event here (strong)
  NSEvent* mLastMouseDownEvent;

  // Needed for IME support in e10s mode.  Strong.
  NSEvent* mLastKeyDownEvent;

  // Whether the last mouse down event was blocked from Gecko.
  BOOL mBlockedLastMouseDown;

  // when acceptsFirstMouse: is called, we store the event here (strong)
  NSEvent* mClickThroughMouseDownEvent;

  // rects that were invalidated during a draw, so have pending drawing
  NSMutableArray* mPendingDirtyRects;
  BOOL mPendingFullDisplay;
  BOOL mPendingDisplay;

  // WheelStart/Stop events should always come in pairs. This BOOL records the
  // last received event so that, when we receive one of the events, we make sure
  // to send its pair event first, in case we didn't yet for any reason.
  BOOL mExpectingWheelStop;

  // Set to YES when our GL surface has been updated and we need to call
  // updateGLContext before we composite.
  BOOL mNeedsGLUpdate;

  // Holds our drag service across multiple drag calls. The reference to the
  // service is obtained when the mouse enters the view and is released when
  // the mouse exits or there is a drop. This prevents us from having to
  // re-establish the connection to the service manager many times per second
  // when handling |draggingUpdated:| messages.
  nsIDragService* mDragService;

  NSOpenGLContext *mGLContext;

  // Simple gestures support
  //
  // mGestureState is used to detect when Cocoa has called both
  // magnifyWithEvent and rotateWithEvent within the same
  // beginGestureWithEvent and endGestureWithEvent sequence. We
  // discard the spurious gesture event so as not to confuse Gecko.
  //
  // mCumulativeMagnification keeps track of the total amount of
  // magnification peformed during a magnify gesture so that we can
  // send that value with the final MozMagnifyGesture event.
  //
  // mCumulativeRotation keeps track of the total amount of rotation
  // performed during a rotate gesture so we can send that value with
  // the final MozRotateGesture event.
  enum {
    eGestureState_None,
    eGestureState_StartGesture,
    eGestureState_MagnifyGesture,
    eGestureState_RotateGesture
  } mGestureState;
  float mCumulativeMagnification;
  float mCumulativeRotation;

  BOOL mDidForceRefreshOpenGL;
  BOOL mWaitingForPaint;

#ifdef __LP64__
  // Support for fluid swipe tracking.
  BOOL* mCancelSwipeAnimation;
#endif

  // Whether this uses off-main-thread compositing.
  BOOL mUsingOMTCompositor;

  // The mask image that's used when painting into the titlebar using basic
  // CGContext painting (i.e. non-accelerated).
  CGImageRef mTopLeftCornerMask;
}

// class initialization
+ (void)initialize;

+ (void)registerViewForDraggedTypes:(NSView*)aView;

// these are sent to the first responder when the window key status changes
- (void)viewsWindowDidBecomeKey;
- (void)viewsWindowDidResignKey;

// Stop NSView hierarchy being changed during [ChildView drawRect:]
- (void)delayedTearDown;

- (void)sendFocusEvent:(mozilla::EventMessage)eventMessage;

- (void)handleMouseMoved:(NSEvent*)aEvent;

- (void)sendMouseEnterOrExitEvent:(NSEvent*)aEvent
                            enter:(BOOL)aEnter
                         exitFrom:(mozilla::WidgetMouseEvent::ExitFrom)aExitFrom;

- (void)updateGLContext;
- (void)_surfaceNeedsUpdate:(NSNotification*)notification;

- (bool)preRender:(NSOpenGLContext *)aGLContext;
- (void)postRender:(NSOpenGLContext *)aGLContext;

- (BOOL)isCoveringTitlebar;

- (void)viewWillStartLiveResize;
- (void)viewDidEndLiveResize;

- (NSColor*)vibrancyFillColorForThemeGeometryType:(nsITheme::ThemeGeometryType)aThemeGeometryType;
- (NSColor*)vibrancyFontSmoothingBackgroundColorForThemeGeometryType:(nsITheme::ThemeGeometryType)aThemeGeometryType;

// Simple gestures support
//
// XXX - The swipeWithEvent, beginGestureWithEvent, magnifyWithEvent,
// rotateWithEvent, and endGestureWithEvent methods are part of a
// PRIVATE interface exported by nsResponder and reverse-engineering
// was necessary to obtain the methods' prototypes. Thus, Apple may
// change the interface in the future without notice.
//
// The prototypes were obtained from the following link:
// http://cocoadex.com/2008/02/nsevent-modifications-swipe-ro.html
- (void)swipeWithEvent:(NSEvent *)anEvent;
- (void)beginGestureWithEvent:(NSEvent *)anEvent;
- (void)magnifyWithEvent:(NSEvent *)anEvent;
- (void)smartMagnifyWithEvent:(NSEvent *)anEvent;
- (void)rotateWithEvent:(NSEvent *)anEvent;
- (void)endGestureWithEvent:(NSEvent *)anEvent;

- (void)scrollWheel:(NSEvent *)anEvent;
- (void)handleAsyncScrollEvent:(CGEventRef)cgEvent ofType:(CGEventType)type;

- (void)setUsingOMTCompositor:(BOOL)aUseOMTC;

- (NSEvent*)lastKeyDownEvent;
@end

class ChildViewMouseTracker {

public:

  static void MouseMoved(NSEvent* aEvent);
  static void MouseScrolled(NSEvent* aEvent);
  static void OnDestroyView(ChildView* aView);
  static void OnDestroyWindow(NSWindow* aWindow);
  static BOOL WindowAcceptsEvent(NSWindow* aWindow, NSEvent* aEvent,
                                 ChildView* aView, BOOL isClickThrough = NO);
  static void MouseExitedWindow(NSEvent* aEvent);
  static void MouseEnteredWindow(NSEvent* aEvent);
  static void ReEvaluateMouseEnterState(NSEvent* aEvent = nil, ChildView* aOldView = nil);
  static void ResendLastMouseMoveEvent();
  static ChildView* ViewForEvent(NSEvent* aEvent);

  static ChildView* sLastMouseEventView;
  static NSEvent* sLastMouseMoveEvent;
  static NSWindow* sWindowUnderMouse;
  static NSPoint sLastScrollEventScreenLocation;
};

//-------------------------------------------------------------------------
//
// nsChildView
//
//-------------------------------------------------------------------------

class nsChildView : public nsBaseWidget
{
private:
  typedef nsBaseWidget Inherited;
  typedef mozilla::layers::IAPZCTreeManager IAPZCTreeManager;

public:
  nsChildView();

  // nsIWidget interface
  virtual MOZ_MUST_USE nsresult Create(nsIWidget* aParent,
                                       nsNativeWidget aNativeParent,
                                       const LayoutDeviceIntRect& aRect,
                                       nsWidgetInitData* aInitData = nullptr)
                                       override;

  virtual void            Destroy() override;

  NS_IMETHOD              Show(bool aState) override;
  virtual bool            IsVisible() const override;

  NS_IMETHOD              SetParent(nsIWidget* aNewParent) override;
  virtual nsIWidget*      GetParent(void) override;
  virtual float           GetDPI() override;

  NS_IMETHOD              Move(double aX, double aY) override;
  NS_IMETHOD              Resize(double aWidth, double aHeight, bool aRepaint) override;
  NS_IMETHOD              Resize(double aX, double aY,
                                 double aWidth, double aHeight, bool aRepaint) override;

  NS_IMETHOD              Enable(bool aState) override;
  virtual bool            IsEnabled() const override;
  NS_IMETHOD              SetFocus(bool aRaise) override;
  virtual LayoutDeviceIntRect GetBounds() override;
  virtual LayoutDeviceIntRect GetClientBounds() override;
  virtual LayoutDeviceIntRect GetScreenBounds() override;

  // Returns the "backing scale factor" of the view's window, which is the
  // ratio of pixels in the window's backing store to Cocoa points. Prior to
  // HiDPI support in OS X 10.7, this was always 1.0, but in HiDPI mode it
  // will be 2.0 (and might potentially other values as screen resolutions
  // evolve). This gives the relationship between what Gecko calls "device
  // pixels" and the Cocoa "points" coordinate system.
  CGFloat                 BackingScaleFactor() const;

  mozilla::DesktopToLayoutDeviceScale GetDesktopToDeviceScale() final {
    return mozilla::DesktopToLayoutDeviceScale(BackingScaleFactor());
  }

  // Call if the window's backing scale factor changes - i.e., it is moved
  // between HiDPI and non-HiDPI screens
  void                    BackingScaleFactorChanged();

  virtual double          GetDefaultScaleInternal() override;

  virtual int32_t         RoundsWidgetCoordinatesTo() override;

  NS_IMETHOD              Invalidate(const LayoutDeviceIntRect &aRect) override;

  virtual void*           GetNativeData(uint32_t aDataType) override;
  virtual nsresult        ConfigureChildren(const nsTArray<Configuration>& aConfigurations) override;
  virtual LayoutDeviceIntPoint WidgetToScreenOffset() override;
  virtual bool            ShowsResizeIndicator(LayoutDeviceIntRect* aResizerRect) override;

  static  bool            ConvertStatus(nsEventStatus aStatus)
                          { return aStatus == nsEventStatus_eConsumeNoDefault; }
  NS_IMETHOD              DispatchEvent(mozilla::WidgetGUIEvent* aEvent,
                                        nsEventStatus& aStatus) override;

  virtual bool            WidgetTypeSupportsAcceleration() override;
  virtual bool            ShouldUseOffMainThreadCompositing() override;

  NS_IMETHOD        SetCursor(nsCursor aCursor) override;
  NS_IMETHOD        SetCursor(imgIContainer* aCursor, uint32_t aHotspotX, uint32_t aHotspotY) override;

  NS_IMETHOD        SetTitle(const nsAString& title) override;

  NS_IMETHOD        GetAttention(int32_t aCycleCount) override;

  virtual bool HasPendingInputEvent() override;

  NS_IMETHOD        ActivateNativeMenuItemAt(const nsAString& indexString) override;
  NS_IMETHOD        ForceUpdateNativeMenuAt(const nsAString& indexString) override;
  NS_IMETHOD        GetSelectionAsPlaintext(nsAString& aResult) override;

  NS_IMETHOD_(void) SetInputContext(const InputContext& aContext,
                                    const InputContextAction& aAction) override;
  NS_IMETHOD_(InputContext) GetInputContext() override;
  NS_IMETHOD_(TextEventDispatcherListener*)
    GetNativeTextEventDispatcherListener() override;
  NS_IMETHOD        AttachNativeKeyEvent(mozilla::WidgetKeyboardEvent& aEvent) override;
  NS_IMETHOD_(bool) ExecuteNativeKeyBinding(
                      NativeKeyBindingsType aType,
                      const mozilla::WidgetKeyboardEvent& aEvent,
                      DoCommandCallback aCallback,
                      void* aCallbackData) override;
  bool ExecuteNativeKeyBindingRemapped(
                      NativeKeyBindingsType aType,
                      const mozilla::WidgetKeyboardEvent& aEvent,
                      DoCommandCallback aCallback,
                      void* aCallbackData,
                      uint32_t aGeckoKeyCode,
                      uint32_t aCocoaKeyCode);
  virtual nsIMEUpdatePreference GetIMEUpdatePreference() override;

  virtual nsTransparencyMode GetTransparencyMode() override;
  virtual void                SetTransparencyMode(nsTransparencyMode aMode) override;

  virtual nsresult SynthesizeNativeKeyEvent(int32_t aNativeKeyboardLayout,
                                            int32_t aNativeKeyCode,
                                            uint32_t aModifierFlags,
                                            const nsAString& aCharacters,
                                            const nsAString& aUnmodifiedCharacters,
                                            nsIObserver* aObserver) override;

  virtual nsresult SynthesizeNativeMouseEvent(LayoutDeviceIntPoint aPoint,
                                              uint32_t aNativeMessage,
                                              uint32_t aModifierFlags,
                                              nsIObserver* aObserver) override;

  virtual nsresult SynthesizeNativeMouseMove(LayoutDeviceIntPoint aPoint,
                                             nsIObserver* aObserver) override
  { return SynthesizeNativeMouseEvent(aPoint, NSMouseMoved, 0, aObserver); }
  virtual nsresult SynthesizeNativeMouseScrollEvent(LayoutDeviceIntPoint aPoint,
                                                    uint32_t aNativeMessage,
                                                    double aDeltaX,
                                                    double aDeltaY,
                                                    double aDeltaZ,
                                                    uint32_t aModifierFlags,
                                                    uint32_t aAdditionalFlags,
                                                    nsIObserver* aObserver) override;
  virtual nsresult SynthesizeNativeTouchPoint(uint32_t aPointerId,
                                              TouchPointerState aPointerState,
                                              LayoutDeviceIntPoint aPoint,
                                              double aPointerPressure,
                                              uint32_t aPointerOrientation,
                                              nsIObserver* aObserver) override;

  // Mac specific methods

  virtual bool      DispatchWindowEvent(mozilla::WidgetGUIEvent& event);

  void WillPaintWindow();
  bool PaintWindow(LayoutDeviceIntRegion aRegion);
  bool PaintWindowInContext(CGContextRef aContext, const LayoutDeviceIntRegion& aRegion,
                            mozilla::gfx::IntSize aSurfaceSize);

#ifdef ACCESSIBILITY
  already_AddRefed<mozilla::a11y::Accessible> GetDocumentAccessible();
#endif

  virtual void CreateCompositor() override;
  virtual void PrepareWindowEffects() override;
  virtual void CleanupWindowEffects() override;
  virtual bool PreRender(mozilla::widget::WidgetRenderingContext* aContext) override;
  virtual void PostRender(mozilla::widget::WidgetRenderingContext* aContext) override;
  virtual void DrawWindowOverlay(mozilla::widget::WidgetRenderingContext* aManager,
                                 LayoutDeviceIntRect aRect) override;

  virtual void UpdateThemeGeometries(const nsTArray<ThemeGeometry>& aThemeGeometries) override;

  virtual void UpdateWindowDraggingRegion(const LayoutDeviceIntRegion& aRegion) override;
  LayoutDeviceIntRegion GetNonDraggableRegion() { return mNonDraggableRegion.Region(); }

  virtual void ReportSwipeStarted(uint64_t aInputBlockId, bool aStartSwipe) override;

  virtual void LookUpDictionary(
                 const nsAString& aText,
                 const nsTArray<mozilla::FontRange>& aFontRangeArray,
                 const bool aIsVertical,
                 const LayoutDeviceIntPoint& aPoint) override;

  void              ResetParent();

  static bool DoHasPendingInputEvent();
  static uint32_t GetCurrentInputEventCount();
  static void UpdateCurrentInputEventCount();

  NSView<mozView>* GetEditorView();

  nsCocoaWindow*    GetXULWindowWidget();

  virtual void      ReparentNativeWidget(nsIWidget* aNewParent) override;

  mozilla::widget::TextInputHandler* GetTextInputHandler()
  {
    return mTextInputHandler;
  }

  void              ClearVibrantAreas();
  NSColor*          VibrancyFillColorForThemeGeometryType(nsITheme::ThemeGeometryType aThemeGeometryType);
  NSColor*          VibrancyFontSmoothingBackgroundColorForThemeGeometryType(nsITheme::ThemeGeometryType aThemeGeometryType);

  // unit conversion convenience functions
  int32_t           CocoaPointsToDevPixels(CGFloat aPts) const {
    return nsCocoaUtils::CocoaPointsToDevPixels(aPts, BackingScaleFactor());
  }
  LayoutDeviceIntPoint CocoaPointsToDevPixels(const NSPoint& aPt) const {
    return nsCocoaUtils::CocoaPointsToDevPixels(aPt, BackingScaleFactor());
  }
  LayoutDeviceIntRect CocoaPointsToDevPixels(const NSRect& aRect) const {
    return nsCocoaUtils::CocoaPointsToDevPixels(aRect, BackingScaleFactor());
  }
  CGFloat           DevPixelsToCocoaPoints(int32_t aPixels) const {
    return nsCocoaUtils::DevPixelsToCocoaPoints(aPixels, BackingScaleFactor());
  }
  NSRect            DevPixelsToCocoaPoints(const LayoutDeviceIntRect& aRect) const {
    return nsCocoaUtils::DevPixelsToCocoaPoints(aRect, BackingScaleFactor());
  }

  already_AddRefed<mozilla::gfx::DrawTarget>
    StartRemoteDrawingInRegion(LayoutDeviceIntRegion& aInvalidRegion,
                               mozilla::layers::BufferMode* aBufferMode) override;
  void EndRemoteDrawing() override;
  void CleanupRemoteDrawing() override;
  bool InitCompositor(mozilla::layers::Compositor* aCompositor) override;

  IAPZCTreeManager* APZCTM() { return mAPZC ; }

  NS_IMETHOD StartPluginIME(const mozilla::WidgetKeyboardEvent& aKeyboardEvent,
                            int32_t aPanelX, int32_t aPanelY,
                            nsString& aCommitted) override;

  virtual void SetPluginFocused(bool& aFocused) override;

  bool IsPluginFocused() { return mPluginFocused; }

  virtual LayoutDeviceIntPoint GetClientOffset() override;

  void DispatchAPZWheelInputEvent(mozilla::InputData& aEvent, bool aCanTriggerSwipe);

  void SwipeFinished();

protected:
  virtual ~nsChildView();

  void              ReportMoveEvent();
  void              ReportSizeEvent();

  // override to create different kinds of child views. Autoreleases, so
  // caller must retain.
  virtual NSView*   CreateCocoaView(NSRect inFrame);
  void              TearDownView();

  virtual already_AddRefed<nsIWidget>
  AllocateChildPopupWidget() override
  {
    static NS_DEFINE_IID(kCPopUpCID, NS_POPUP_CID);
    nsCOMPtr<nsIWidget> widget = do_CreateInstance(kCPopUpCID);
    return widget.forget();
  }

  void ConfigureAPZCTreeManager() override;
  void ConfigureAPZControllerThread() override;

  void DoRemoteComposition(const LayoutDeviceIntRect& aRenderRect);

  // Overlay drawing functions for OpenGL drawing
  void DrawWindowOverlay(mozilla::layers::GLManager* aManager, LayoutDeviceIntRect aRect);
  void MaybeDrawResizeIndicator(mozilla::layers::GLManager* aManager);
  void MaybeDrawRoundedCorners(mozilla::layers::GLManager* aManager, const LayoutDeviceIntRect& aRect);
  void MaybeDrawTitlebar(mozilla::layers::GLManager* aManager);

  // Redraw the contents of mTitlebarCGContext on the main thread, as
  // determined by mDirtyTitlebarRegion.
  void UpdateTitlebarCGContext();

  LayoutDeviceIntRect RectContainingTitlebarControls();
  void UpdateVibrancy(const nsTArray<ThemeGeometry>& aThemeGeometries);
  mozilla::VibrancyManager& EnsureVibrancyManager();

  nsIWidget* GetWidgetForListenerEvents();

  struct SwipeInfo {
    bool wantsSwipe;
    uint32_t allowedDirections;
  };

  SwipeInfo SendMayStartSwipe(const mozilla::PanGestureInput& aSwipeStartEvent);
  void TrackScrollEventAsSwipe(const mozilla::PanGestureInput& aSwipeStartEvent,
                               uint32_t aAllowedDirections);

protected:

  NSView<mozView>*      mView;      // my parallel cocoa view (ChildView or NativeScrollbarView), [STRONG]
  RefPtr<mozilla::widget::TextInputHandler> mTextInputHandler;
  InputContext          mInputContext;

  NSView<mozView>*      mParentView;
  nsIWidget*            mParentWidget;

#ifdef ACCESSIBILITY
  // weak ref to this childview's associated mozAccessible for speed reasons
  // (we get queried for it *a lot* but don't want to own it)
  nsWeakPtr             mAccessible;
#endif

  // Protects the view from being teared down while a composition is in
  // progress on the compositor thread.
  mozilla::Mutex mViewTearDownLock;

  mozilla::Mutex mEffectsLock;

  // May be accessed from any thread, protected
  // by mEffectsLock.
  bool mShowsResizeIndicator;
  LayoutDeviceIntRect mResizeIndicatorRect;
  bool mHasRoundedBottomCorners;
  int mDevPixelCornerRadius;
  bool mIsCoveringTitlebar;
  bool mIsFullscreen;
  bool mIsOpaque;
  LayoutDeviceIntRect mTitlebarRect;

  // The area of mTitlebarCGContext that needs to be redrawn during the next
  // transaction. Accessed from any thread, protected by mEffectsLock.
  LayoutDeviceIntRegion mUpdatedTitlebarRegion;
  CGContextRef mTitlebarCGContext;

  // Compositor thread only
  mozilla::UniquePtr<mozilla::widget::RectTextureImage> mResizerImage;
  mozilla::UniquePtr<mozilla::widget::RectTextureImage> mCornerMaskImage;
  mozilla::UniquePtr<mozilla::widget::RectTextureImage> mTitlebarImage;
  mozilla::UniquePtr<mozilla::widget::RectTextureImage> mBasicCompositorImage;

  // The area of mTitlebarCGContext that has changed and needs to be
  // uploaded to to mTitlebarImage. Main thread only.
  nsIntRegion           mDirtyTitlebarRegion;

  mozilla::ViewRegion   mNonDraggableRegion;

  // Cached value of [mView backingScaleFactor], to avoid sending two obj-c
  // messages (respondsToSelector, backingScaleFactor) every time we need to
  // use it.
  // ** We'll need to reinitialize this if the backing resolution changes. **
  mutable CGFloat       mBackingScaleFactor;

  bool                  mVisible;
  bool                  mDrawing;
  bool                  mIsDispatchPaint; // Is a paint event being dispatched

  bool mPluginFocused;

  // Used in OMTC BasicLayers mode. Presents the BasicCompositor result
  // surface to the screen using an OpenGL context.
  mozilla::UniquePtr<GLPresenter> mGLPresenter;

  mozilla::UniquePtr<mozilla::VibrancyManager> mVibrancyManager;
  RefPtr<mozilla::SwipeTracker> mSwipeTracker;
  mozilla::UniquePtr<mozilla::SwipeEventQueue> mSwipeEventQueue;

  // Only used for drawRect-based painting in popups.
  RefPtr<mozilla::gfx::DrawTarget> mBackingSurface;

  // This flag is only used when APZ is off. It indicates that the current pan
  // gesture was processed as a swipe. Sometimes the swipe animation can finish
  // before momentum events of the pan gesture have stopped firing, so this
  // flag tells us that we shouldn't allow the remaining events to cause
  // scrolling. It is reset to false once a new gesture starts (as indicated by
  // a PANGESTURE_(MAY)START event).
  bool mCurrentPanGestureBelongsToSwipe;

  static uint32_t sLastInputEventCount;

  void ReleaseTitlebarCGContext();

  // This is used by SynthesizeNativeTouchPoint to maintain state between
  // multiple synthesized points
  mozilla::UniquePtr<mozilla::MultiTouchInput> mSynthesizedTouchInput;
};

#endif // nsChildView_h_
