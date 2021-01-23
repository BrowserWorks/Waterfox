/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef DOM_MEDIA_MEDIACONTROL_CONTENTMEDIACONTROLLER_H_
#define DOM_MEDIA_MEDIACONTROL_CONTENTMEDIACONTROLLER_H_

#include "MediaControlKeysEvent.h"

namespace mozilla {
namespace dom {

class BrowsingContext;

/**
 * This enum is used to update controlled media state to the media controller in
 * the chrome process.
 * `eStarted`: media has successfully registered to the content media controller
 * `ePlayed` : media has started playing
 * `ePaused` : media has paused playing, but still can be resumed by content
 *             media controller
 * `eStopped`: media has unregistered from the content media controller, we can
 *             not control it anymore
 * When using these states to notify media controller, there are some rules we
 * MUST follow (1) `eStart` MUST be the first state and `eStop` MUST be the last
 * state (2) Do not notify same state again (3) `ePaused` can only be used after
 * notifying `ePlayed`.
 */
enum class MediaPlaybackState : uint32_t {
  eStarted,
  ePlayed,
  ePaused,
  eStopped,
};

/**
 * This enum is used to update controlled media audible audible state to the
 * media controller in the chrome process.
 */
enum class MediaAudibleState : bool {
  eInaudible = false,
  eAudible = true,
};

/**
 * ContentControlKeyEventReceiver is an interface which is used to receive media
 * control key events sent from the chrome process, this class MUST only be used
 * in PlaybackController.
 *
 * Each browsing context tree would only have one ContentControlKeyEventReceiver
 * that is used to handle media control key events for that browsing context
 * tree.
 */
class ContentControlKeyEventReceiver {
 public:
  NS_INLINE_DECL_PURE_VIRTUAL_REFCOUNTING

  // Return nullptr if the top level browsing context is no longer alive.
  static ContentControlKeyEventReceiver* Get(BrowsingContext* aBC);

  // Use this method to handle the event from `ContentMediaAgent`.
  virtual void HandleEvent(MediaControlKeysEvent aKeyEvent) = 0;

  // Use this method to get the browsing context from which the receiver is
  // created.
  virtual BrowsingContext* GetBrowsingContext() const { return nullptr; }
};

/**
 * ContentMediaAgent is an interface which we use to (1) update controlled media
 * status to the media controller in the chrome process and (2) act an event
 * source to dispatch control key events to its listeners.
 *
 * If the media would like to know the media control key events, then media
 * MUST inherit from ContentControlKeyEventReceiver, and register themselves to
 * ContentMediaAgent. Whenever media key events occur, ContentMediaAgent would
 * notify all its receivers. In addition, whenever controlled media changes its
 * playback status or audible state, they should update their status update via
 * ContentMediaAgent.
 *
 * Each browsing context tree would only have one ContentMediaAgent that is used
 * to update controlled media status existing in that browsing context tree.
 */
class ContentMediaAgent {
 public:
  NS_INLINE_DECL_PURE_VIRTUAL_REFCOUNTING

  // Return nullptr if the top level browsing context is no longer alive.
  static ContentMediaAgent* Get(BrowsingContext* aBC);

  // Use this method to update the media playback state of controlled media, and
  // MUST follow the rule of MediaPlaybackState.
  virtual void NotifyPlaybackStateChanged(
      const ContentControlKeyEventReceiver* aMedia,
      MediaPlaybackState aState) = 0;

  // Use this method to update the audible state of controlled media, and MUST
  // follow the following rules in which `audible` and `inaudible` should be a
  // pair. `inaudible` should always be notified after `audible`. When audible
  // media paused, `inaudible` should be notified
  // Eg. (O) `audible` -> `inaudible` -> `audible` -> `inaudible`
  //     (X) `inaudible` -> `audible`    [notify `inaudible` before `audible`]
  //     (X) `audible` -> `audible`      [notify `audible` twice]
  //     (X) `audible` -> (media pauses) [forgot to notify `inaudible`]
  virtual void NotifyAudibleStateChanged(
      const ContentControlKeyEventReceiver* aMedia,
      MediaAudibleState aState) = 0;

  // Use this method to update the picture in picture mode state of controlled
  // media, and it's safe to notify same state again.
  virtual void NotifyPictureInPictureModeChanged(
      const ContentControlKeyEventReceiver* aMedia, bool aEnabled) = 0;

  // Use these methods to register/unregister `ContentControlKeyEventReceiver`
  // in order to listen to media control key events.
  virtual void AddReceiver(ContentControlKeyEventReceiver* aReceiver) = 0;
  virtual void RemoveReceiver(ContentControlKeyEventReceiver* aReceiver) = 0;
};

/**
 * ContentMediaController has a responsibility to update the content media state
 * to MediaController that exists in the chrome process and control all media
 * within a tab. It also delivers control commands from MediaController in order
 * to control media in the content page.
 *
 * Each ContentMediaController has its own ID that is corresponding to the top
 * level browsing context ID. That means we share same the
 * ContentMediaController for those media existing in the same browsing context
 * tree and same process.
 *
 * So if the content of a page are all in the same process, then we would only
 * create one ContentMediaController. However, if the content of a page are
 * running in different processes because a page has cross-origin iframes, then
 * we would have multiple ContentMediaController at the same time, creating one
 * ContentMediaController in each process to manage media.
 */
class ContentMediaController final : public ContentMediaAgent,
                                     public ContentControlKeyEventReceiver {
 public:
  NS_INLINE_DECL_REFCOUNTING(ContentMediaController, override)

  explicit ContentMediaController(uint64_t aId);
  // ContentMediaAgent methods
  void AddReceiver(ContentControlKeyEventReceiver* aListener) override;
  void RemoveReceiver(ContentControlKeyEventReceiver* aListener) override;
  void NotifyPlaybackStateChanged(const ContentControlKeyEventReceiver* aMedia,
                                  MediaPlaybackState aState) override;
  void NotifyAudibleStateChanged(const ContentControlKeyEventReceiver* aMedia,
                                 MediaAudibleState aState) override;
  void NotifyPictureInPictureModeChanged(
      const ContentControlKeyEventReceiver* aMedia, bool aEnabled) override;

  // ContentControlKeyEventReceiver method
  void HandleEvent(MediaControlKeysEvent aEvent) override;

 private:
  ~ContentMediaController() = default;

  nsTArray<RefPtr<ContentControlKeyEventReceiver>> mReceivers;
  uint64_t mTopLevelBrowsingContextId;
};

}  // namespace dom
}  // namespace mozilla

#endif  // DOM_MEDIA_MEDIACONTROL_CONTENTMEDIACONTROLLER_H_
