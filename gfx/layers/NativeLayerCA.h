/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef mozilla_layers_NativeLayerCA_h
#define mozilla_layers_NativeLayerCA_h

#include <IOSurface/IOSurface.h>

#include <deque>
#include <unordered_map>

#include "mozilla/Mutex.h"

#include "mozilla/gfx/MacIOSurface.h"
#include "mozilla/layers/NativeLayer.h"
#include "CFTypeRefPtr.h"
#include "nsRegion.h"
#include "nsISupportsImpl.h"

#ifdef __OBJC__
@class CALayer;
#else
typedef void CALayer;
#endif

namespace mozilla {

namespace gl {
class GLContextCGL;
class MozFramebuffer;
}  // namespace gl

namespace layers {

class NativeLayerRootSnapshotterCA;
class SurfacePoolHandleCA;

// NativeLayerRootCA is the CoreAnimation implementation of the NativeLayerRoot
// interface. A NativeLayerRootCA is created by the widget around an existing
// CALayer with a call to CreateForCALayer - this CALayer is the root of the
// "onscreen" representation of this layer tree.
// All methods can be called from any thread, there is internal locking.
// All effects from mutating methods are buffered locally and don't modify the
// underlying CoreAnimation layers until CommitToScreen() is called. This
// ensures that the modifications happen on the right thread.
//
// More specifically: During normal operation, screen updates are driven from a
// compositing thread. On this thread, the layers are created / destroyed, their
// contents are painted, and the result is committed to the screen. However,
// there are some scenarios that need to involve the main thread, most notably
// window resizing: During a window resize, we still need the drawing part to
// happen on the compositing thread, but the modifications to the underlying
// CALayers need to happen on the main thread, once compositing is done.
//
// NativeLayerRootCA + NativeLayerCA create and maintain *two* CALayer tree
// representations: An "onscreen" representation and an "offscreen"
// representation. These representations are updated via calls to
// CommitToScreen() and CommitOffscreen(), respectively. The reason for having
// two representations is the following: Our implementation of the snapshotter
// API uses CARenderer, which lets us render the composited result of our layer
// tree into a GPU buffer. But CARenderer requires "ownership" of the rendered
// CALayers in the sense that it associates the CALayers with a local
// "CAContext". A CALayer can only be associated with one CAContext at any time.
// If we wanted te render our *onscreen* CALayers with CARenderer, we would need
// to remove them from the window, reparent them to the CARenderer, render them,
// and then put them back into the window. This would lead to a visible flashing
// effect. To solve this problem, we build two CALayer representations, so that
// one representation can stay inside the window and the other can stay attached
// to the CARenderer.
class NativeLayerRootCA : public NativeLayerRoot {
 public:
  static already_AddRefed<NativeLayerRootCA> CreateForCALayer(CALayer* aLayer);

  // Can be called on any thread at any point. Returns whether comitting was
  // successful. Will return false if called off the main thread while
  // off-main-thread commits are suspended.
  bool CommitToScreen() override;

  void CommitOffscreen();
  void OnNativeLayerRootSnapshotterDestroyed(
      NativeLayerRootSnapshotterCA* aNativeLayerRootSnapshotter);

  // Enters a mode during which CommitToScreen(), when called on a non-main
  // thread, will not apply any updates to the CALayer tree.
  void SuspendOffMainThreadCommits();

  // Exits the mode entered by SuspendOffMainThreadCommits().
  // Returns true if the last CommitToScreen() was canceled due to suspension,
  // indicating that another call to CommitToScreen() is needed.
  bool UnsuspendOffMainThreadCommits();

  bool AreOffMainThreadCommitsSuspended();

  enum class WhichRepresentation : uint8_t { ONSCREEN, OFFSCREEN };

  // Overridden methods
  already_AddRefed<NativeLayer> CreateLayer(
      const gfx::IntSize& aSize, bool aIsOpaque,
      SurfacePoolHandle* aSurfacePoolHandle) override;
  void AppendLayer(NativeLayer* aLayer) override;
  void RemoveLayer(NativeLayer* aLayer) override;
  void SetLayers(const nsTArray<RefPtr<NativeLayer>>& aLayers) override;
  UniquePtr<NativeLayerRootSnapshotter> CreateSnapshotter() override;

  void SetBackingScale(float aBackingScale);
  float BackingScale();

 protected:
  explicit NativeLayerRootCA(CALayer* aLayer);
  ~NativeLayerRootCA() override;

  struct Representation {
    explicit Representation(CALayer* aRootCALayer);
    ~Representation();
    void Commit(WhichRepresentation aRepresentation,
                const nsTArray<RefPtr<NativeLayerCA>>& aSublayers);
    CALayer* mRootCALayer = nullptr;  // strong
    bool mMutated = false;
  };

  template <typename F>
  void ForAllRepresentations(F aFn);

  Mutex mMutex;  // protects all other fields
  Representation mOnscreenRepresentation;
  Representation mOffscreenRepresentation;
  NativeLayerRootSnapshotterCA* mWeakSnapshotter = nullptr;
  nsTArray<RefPtr<NativeLayerCA>> mSublayers;  // in z-order
  float mBackingScale = 1.0f;
  bool mMutated = false;

  // While mOffMainThreadCommitsSuspended is true, no commits
  // should happen on a non-main thread, because they might race with
  // main-thread driven updates such as window shape changes, and cause
  // glitches.
  bool mOffMainThreadCommitsSuspended = false;

  // Set to true if CommitToScreen() was aborted because of commit suspension.
  // Set to false when CommitToScreen() completes successfully. When true,
  // indicates that CommitToScreen() needs to be called at the next available
  // opportunity.
  bool mCommitPending = false;
};

class NativeLayerRootSnapshotterCA final : public NativeLayerRootSnapshotter {
 public:
  static UniquePtr<NativeLayerRootSnapshotterCA> Create(
      NativeLayerRootCA* aLayerRoot, CALayer* aRootCALayer);
  virtual ~NativeLayerRootSnapshotterCA();

  bool ReadbackPixels(const gfx::IntSize& aReadbackSize,
                      gfx::SurfaceFormat aReadbackFormat,
                      const Range<uint8_t>& aReadbackBuffer) override;

 protected:
  NativeLayerRootSnapshotterCA(NativeLayerRootCA* aLayerRoot,
                               RefPtr<gl::GLContext>&& aGL,
                               CALayer* aRootCALayer);

  RefPtr<NativeLayerRootCA> mLayerRoot;
  RefPtr<gl::GLContext> mGL;
  UniquePtr<gl::MozFramebuffer>
      mFB;  // can be null, recreated when aReadbackSize changes
  CARenderer* mRenderer = nullptr;  // strong
};

// NativeLayerCA wraps a CALayer and lets you draw to it. It ensures that only
// fully-drawn frames make their way to the screen, by maintaining a swap chain
// of IOSurfaces.
// All calls to mutating methods are buffered, and don't take effect on the
// underlying CoreAnimation layers until ApplyChanges() is called.
// The two most important methods are NextSurface and NotifySurfaceReady:
// NextSurface takes an available surface from the swap chain or creates a new
// surface if necessary. This surface can then be drawn to. Once drawing is
// finished, NotifySurfaceReady marks the surface as ready. This surface is
// committed to the layer during the next call to ApplyChanges().
// The swap chain keeps track of invalid areas within the surfaces.
class NativeLayerCA : public NativeLayer {
 public:
  virtual NativeLayerCA* AsNativeLayerCA() override { return this; }

  // Overridden methods
  gfx::IntSize GetSize() override;
  void SetPosition(const gfx::IntPoint& aPosition) override;
  gfx::IntPoint GetPosition() override;
  gfx::IntRect GetRect() override;
  void SetValidRect(const gfx::IntRect& aValidRect) override;
  gfx::IntRect GetValidRect() override;
  RefPtr<gfx::DrawTarget> NextSurfaceAsDrawTarget(
      const gfx::IntRegion& aUpdateRegion,
      gfx::BackendType aBackendType) override;
  Maybe<GLuint> NextSurfaceAsFramebuffer(const gfx::IntRegion& aUpdateRegion,
                                         bool aNeedsDepth) override;
  void NotifySurfaceReady() override;
  void DiscardBackbuffers() override;
  bool IsOpaque() override;
  void SetClipRect(const Maybe<gfx::IntRect>& aClipRect) override;
  Maybe<gfx::IntRect> ClipRect() override;
  void SetSurfaceIsFlipped(bool aIsFlipped) override;
  bool SurfaceIsFlipped() override;

 protected:
  friend class NativeLayerRootCA;

  NativeLayerCA(const gfx::IntSize& aSize, bool aIsOpaque,
                SurfacePoolHandleCA* aSurfacePoolHandle);
  ~NativeLayerCA() override;

  // Gets the next surface for drawing from our swap chain and stores it in
  // mInProgressSurface. Returns whether this was successful.
  // mInProgressSurface is guaranteed to be not in use by the window server.
  // After a call to NextSurface, NextSurface must not be called again until
  // after NotifySurfaceReady has been called. Can be called on any thread. When
  // used from multiple threads, callers need to make sure that they still only
  // call NextSurface and NotifySurfaceReady alternatingly and not in any other
  // order.
  bool NextSurface(const MutexAutoLock&);

  // To be called by NativeLayerRootCA:
  typedef NativeLayerRootCA::WhichRepresentation WhichRepresentation;
  CALayer* UnderlyingCALayer(WhichRepresentation aRepresentation);
  void ApplyChanges(WhichRepresentation aRepresentation);
  void SetBackingScale(float aBackingScale);

  // Invalidates the specified region in all surfaces that are tracked by this
  // layer.
  void InvalidateRegionThroughoutSwapchain(const MutexAutoLock&,
                                           const gfx::IntRegion& aRegion);

  GLuint GetOrCreateFramebufferForSurface(const MutexAutoLock&,
                                          CFTypeRefPtr<IOSurfaceRef> aSurface,
                                          bool aNeedsDepth);

  // Invalidate aUpdateRegion and make sure that mInProgressSurface has valid
  // content everywhere outside aUpdateRegion, so that only aUpdateRegion needs
  // to be drawn. If content needs to be copied from a previous surface, aCopyFn
  // is called to do the copying.
  // aCopyFn: Fn(CFTypeRefPtr<IOSurfaceRef> aValidSourceIOSurface,
  //             const gfx::IntRegion& aCopyRegion) -> void
  template <typename F>
  void HandlePartialUpdate(const MutexAutoLock&,
                           const gfx::IntRegion& aUpdateRegion, F&& aCopyFn);

  struct SurfaceWithInvalidRegion {
    CFTypeRefPtr<IOSurfaceRef> mSurface;
    gfx::IntRegion mInvalidRegion;
  };

  struct SurfaceWithInvalidRegionAndCheckCount {
    SurfaceWithInvalidRegion mEntry;
    uint32_t mCheckCount;  // The number of calls to IOSurfaceIsInUse
  };

  Maybe<SurfaceWithInvalidRegion> GetUnusedSurfaceAndCleanUp(
      const MutexAutoLock&);

  // Wraps one CALayer representation of this NativeLayer.
  struct Representation {
    ~Representation();

    CALayer* UnderlyingCALayer() { return mWrappingCALayer; }

    // Applies buffered changes to the native CALayers. The contract with the
    // caller is as follows: If any of these values have changed since the last
    // call to ApplyChanges, mMutated[Field] needs to have been set to true
    // before the call.
    void ApplyChanges(const gfx::IntSize& aSize, bool aIsOpaque,
                      const gfx::IntPoint& aPosition,
                      const Maybe<gfx::IntRect>& aClipRect, float aBackingScale,
                      bool aSurfaceIsFlipped,
                      CFTypeRefPtr<IOSurfaceRef> aFrontSurface);

    // Lazily initialized by first call to ApplyChanges. mWrappingLayer is the
    // layer that applies mClipRect (if set), and mContentCALayer is the layer
    // that hosts the IOSurface. We do not share clip layers between consecutive
    // NativeLayerCA objects with the same clip rect.
    CALayer* mWrappingCALayer = nullptr;      // strong
    CALayer* mContentCALayer = nullptr;       // strong
    CALayer* mOpaquenessTintLayer = nullptr;  // strong

    bool mMutatedPosition = true;
    bool mMutatedClipRect = true;
    bool mMutatedBackingScale = true;
    bool mMutatedSurfaceIsFlipped = true;
    bool mMutatedFrontSurface = true;
  };

  Representation& GetRepresentation(WhichRepresentation aRepresentation);
  template <typename F>
  void ForAllRepresentations(F aFn);

  // Controls access to all fields of this class.
  Mutex mMutex;

  // Each IOSurface is initially created inside NextSurface.
  // The surface stays alive until the recycling mechanism in NextSurface
  // determines it is no longer needed (because the swap chain has grown too
  // long) or until DiscardBackbuffers() is called or the layer is destroyed.
  // During the surface's lifetime, it will continuously move through the fields
  // mInProgressSurface, mFrontSurface, and back to front through the mSurfaces
  // queue:
  //
  //  mSurfaces.front()
  //  ------[NextSurface()]-----> mInProgressSurface
  //  --[NotifySurfaceReady()]--> mFrontSurface
  //  --[NotifySurfaceReady()]--> mSurfaces.back()  --> .... -->
  //  mSurfaces.front()
  //
  // We mark an IOSurface as "in use" as long as it is either in
  // mInProgressSurface. When it is in mFrontSurface or in the mSurfaces queue,
  // it is not marked as "in use" by us - but it can be "in use" by the window
  // server. Consequently, IOSurfaceIsInUse on a surface from mSurfaces reflects
  // whether the window server is still reading from the surface, and we can use
  // this indicator to decide when to recycle the surface.
  //
  // Users of NativeLayerCA normally proceed in this order:
  //  1. Begin a frame by calling NextSurface to get the surface.
  //  2. Draw to the surface.
  //  3. Mark the surface as done by calling NotifySurfaceReady.
  //  4. Call NativeLayerRoot::CommitToScreen(), which calls ApplyChanges()
  //     during a CATransaction.

  // The surface we returned from the most recent call to NextSurface, before
  // the matching call to NotifySurfaceReady.
  // Will only be Some() between calls to NextSurface and NotifySurfaceReady.
  Maybe<SurfaceWithInvalidRegion> mInProgressSurface;

  // The surface that the most recent call to NotifySurfaceReady was for.
  // Will be Some() after the first call to NotifySurfaceReady, for the rest of
  // the layer's life time.
  Maybe<SurfaceWithInvalidRegion> mFrontSurface;

  // The queue of surfaces which make up the rest of our "swap chain".
  // mSurfaces.front() is the next surface we'll attempt to use.
  // mSurfaces.back() is the one that was used most recently.
  std::vector<SurfaceWithInvalidRegionAndCheckCount> mSurfaces;

  // Non-null between calls to NextSurfaceAsDrawTarget and NotifySurfaceReady.
  RefPtr<MacIOSurface> mInProgressLockedIOSurface;

  RefPtr<SurfacePoolHandleCA> mSurfacePoolHandle;

  Representation mOnscreenRepresentation;
  Representation mOffscreenRepresentation;

  gfx::IntPoint mPosition;
  gfx::IntRect mValidRect;
  const gfx::IntSize mSize;
  Maybe<gfx::IntRect> mClipRect;
  float mBackingScale = 1.0f;
  bool mSurfaceIsFlipped = false;
  const bool mIsOpaque = false;
};

}  // namespace layers
}  // namespace mozilla

#endif  // mozilla_layers_NativeLayerCA_h
