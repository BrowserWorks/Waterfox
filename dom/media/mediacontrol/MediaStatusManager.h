/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef DOM_MEDIA_MEDIACONTROL_MEDIASTATUSMANAGER_H_
#define DOM_MEDIA_MEDIACONTROL_MEDIASTATUSMANAGER_H_

#include "mozilla/dom/MediaMetadata.h"
#include "mozilla/dom/MediaSessionBinding.h"
#include "mozilla/Maybe.h"
#include "nsDataHashtable.h"
#include "nsISupportsImpl.h"

namespace mozilla {
namespace dom {

class MediaSessionInfo {
 public:
  MediaSessionInfo() = default;

  explicit MediaSessionInfo(MediaMetadataBase& aMetadata) {
    mMetadata.emplace(aMetadata);
  }

  MediaSessionInfo(MediaMetadataBase& aMetadata,
                   MediaSessionPlaybackState& aState) {
    mMetadata.emplace(aMetadata);
    mDeclaredPlaybackState = aState;
  }

  static MediaSessionInfo EmptyInfo() { return MediaSessionInfo(); }

  // These attributes are all propagated from the media session in the content
  // process.
  Maybe<MediaMetadataBase> mMetadata;
  MediaSessionPlaybackState mDeclaredPlaybackState =
      MediaSessionPlaybackState::None;
};

/**
 * IMediaInfoUpdater is an interface which provides methods to update the media
 * related information that happens in the content process.
 */
class IMediaInfoUpdater {
  NS_INLINE_DECL_PURE_VIRTUAL_REFCOUNTING

  // Use this method to update controlled media's playback state and the
  // browsing context where controlled media exists.
  virtual void NotifyMediaPlaybackChanged(uint64_t aBrowsingContextId,
                                          MediaPlaybackState aState) = 0;

  // Use this method to update controlled media's audible state and the
  // browsing context where controlled media exists.
  virtual void NotifyMediaAudibleChanged(uint64_t aBrowsingContextId,
                                         MediaAudibleState aState) = 0;

  // Use this method to update media session's declared playback state for the
  // specific media session.
  virtual void SetDeclaredPlaybackState(uint64_t aBrowsingContextId,
                                        MediaSessionPlaybackState aState) = 0;

  // Use these methods to update controller's media session list. We'd use it
  // when media session is created/destroyed in the content process.
  virtual void NotifySessionCreated(uint64_t aBrowsingContextId) = 0;
  virtual void NotifySessionDestroyed(uint64_t aBrowsingContextId) = 0;

  // Use this method to update the metadata for the specific media session.
  virtual void UpdateMetadata(uint64_t aBrowsingContextId,
                              const Maybe<MediaMetadataBase>& aMetadata) = 0;

  // Use this method to update if the media in content process is being used in
  // Picture-in-Picture mode.
  virtual void SetIsInPictureInPictureMode(bool aIsInPictureInPictureMode) = 0;
};

/**
 * MediaStatusManager would decide the media related status which can represents
 * the whole tab. The status includes the playback status, tab's metadata and
 * the active media session ID if it exists.
 *
 * We would use `IMediaInfoUpdater` methods to update the media playback related
 * information and then use `MediaPlaybackStatus` to determine the final
 * playback state.
 *
 * The metadata would be the one from the active media session, or the default
 * one. This class would determine which media session is an active media
 * session [1] whithin a tab. It tracks all alive media sessions within a tab
 * and store their metadata which could be used to show on the virtual media
 * control interface. In addition, we can use it to get the current media
 * metadata even if there is no media session existing. However, the meaning of
 * active media session here is not equal to the definition from the spec [1].
 * We just choose the session which is the active one inside the tab, the global
 * active media session among different tabs would be the one inside the main
 * controller which is determined by MediaControlService.
 *
 * [1] https://w3c.github.io/mediasession/#active-media-session
 */
class MediaStatusManager : public IMediaInfoUpdater {
 public:
  explicit MediaStatusManager(uint64_t aBrowsingContextId);

  // IMediaInfoUpdater's methods
  void NotifyMediaPlaybackChanged(uint64_t aBrowsingContextId,
                                  MediaPlaybackState aState) override;
  void NotifyMediaAudibleChanged(uint64_t aBrowsingContextId,
                                 MediaAudibleState aState) override;
  void SetDeclaredPlaybackState(uint64_t aSessionContextId,
                                MediaSessionPlaybackState aState) override;
  void NotifySessionCreated(uint64_t aSessionContextId) override;
  void NotifySessionDestroyed(uint64_t aSessionContextId) override;
  void UpdateMetadata(uint64_t aSessionContextId,
                      const Maybe<MediaMetadataBase>& aMetadata) override;

  // Return active media session's metadata if active media session exists and
  // it has already set its metadata. Otherwise, return default media metadata
  // which is based on website's title and favicon.
  MediaMetadataBase GetCurrentMediaMetadata() const;

  bool IsMediaAudible() const;
  bool IsMediaPlaying() const;
  bool IsAnyMediaBeingControlled() const;

  MediaEventSource<MediaMetadataBase>& MetadataChangedEvent() {
    return mMetadataChangedEvent;
  }

  // Return the actual playback state.
  MediaSessionPlaybackState GetState() const;

 protected:
  ~MediaStatusManager() = default;
  virtual void HandleActualPlaybackStateChanged() = 0;

  uint64_t mTopLevelBrowsingContextId;

  // Within a tab, the Id of the browsing context which has already created a
  // media session and owns the audio focus within a tab.
  Maybe<uint64_t> mActiveMediaSessionContextId;

 private:
  nsString GetDefaultFaviconURL() const;
  nsString GetDefaultTitle() const;
  MediaMetadataBase CreateDefaultMetadata() const;
  bool IsInPrivateBrowsing() const;
  void FillMissingTitleAndArtworkIfNeeded(MediaMetadataBase& aMetadata) const;

  bool IsSessionOwningAudioFocus(uint64_t aBrowsingContextId) const;
  void SetActiveMediaSessionContextId(uint64_t aBrowsingContextId);
  void ClearActiveMediaSessionContextIdIfNeeded();
  void HandleAudioFocusOwnerChanged(Maybe<uint64_t>& aBrowsingContextId);

  // When the amount of playing media changes, we would use this function to
  // update the guessed playback state.
  void SetGuessedPlayState(MediaSessionPlaybackState aState);

  // Whenever the declared playback state or the guessed playback state changes,
  // we should recompute actual playback state to know if we need to update the
  // virtual control interface.
  void UpdateActualPlaybackState();

  // Return the active media session's declared playback state. If the active
  // media session doesn't exist, return  'None' instead.
  MediaSessionPlaybackState GetCurrentDeclaredPlaybackState() const;

  // This state can match to the `guessed playback state` in the spec [1], it
  // indicates if we have any media element playing within the tab which this
  // controller belongs to. But currently we only take media elements into
  // account, which is different from the way the spec recommends. In addition,
  // We don't support web audio and plugin and not consider audible state of
  // media.
  // [1] https://w3c.github.io/mediasession/#guessed-playback-state
  MediaSessionPlaybackState mGuessedPlaybackState =
      MediaSessionPlaybackState::None;

  // This playback state would be the final playback which can be used to know
  // if the controller is playing or not.
  // https://w3c.github.io/mediasession/#actual-playback-state
  MediaSessionPlaybackState mActualPlaybackState =
      MediaSessionPlaybackState::None;

  nsDataHashtable<nsUint64HashKey, MediaSessionInfo> mMediaSessionInfoMap;
  MediaEventProducer<MediaMetadataBase> mMetadataChangedEvent;
  MediaPlaybackStatus mPlaybackStatusDelegate;
};

}  // namespace dom
}  // namespace mozilla

#endif  // DOM_MEDIA_MEDIACONTROL_MEDIASTATUSMANAGER_H_
