/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef DOM_MEDIA_MEDIASESSION_MEDIASESSIONIPCUTILS_H_
#define DOM_MEDIA_MEDIASESSION_MEDIASESSIONIPCUTILS_H_

#include "ipc/IPCMessageUtils.h"
#include "MediaMetadata.h"
#include "mozilla/dom/MediaSessionBinding.h"
#include "mozilla/Maybe.h"

namespace mozilla {
namespace dom {

typedef Maybe<MediaMetadataBase> MaybeMediaMetadataBase;

}  // namespace dom
}  // namespace mozilla

namespace IPC {

template <>
struct ParamTraits<mozilla::dom::MediaImage> {
  typedef mozilla::dom::MediaImage paramType;

  static void Write(Message* aMsg, const paramType& aParam) {
    WriteParam(aMsg, aParam.mSizes);
    WriteParam(aMsg, aParam.mSrc);
    WriteParam(aMsg, aParam.mType);
  }

  static bool Read(const Message* aMsg, PickleIterator* aIter,
                   paramType* aResult) {
    if (!ReadParam(aMsg, aIter, &(aResult->mSizes)) ||
        !ReadParam(aMsg, aIter, &(aResult->mSrc)) ||
        !ReadParam(aMsg, aIter, &(aResult->mType))) {
      return false;
    }
    return true;
  }
};

template <>
struct ParamTraits<mozilla::dom::MediaMetadataBase> {
  typedef mozilla::dom::MediaMetadataBase paramType;

  static void Write(Message* aMsg, const paramType& aParam) {
    WriteParam(aMsg, aParam.mTitle);
    WriteParam(aMsg, aParam.mArtist);
    WriteParam(aMsg, aParam.mAlbum);
    WriteParam(aMsg, aParam.mArtwork);
  }

  static bool Read(const Message* aMsg, PickleIterator* aIter,
                   paramType* aResult) {
    if (!ReadParam(aMsg, aIter, &(aResult->mTitle)) ||
        !ReadParam(aMsg, aIter, &(aResult->mArtist)) ||
        !ReadParam(aMsg, aIter, &(aResult->mAlbum)) ||
        !ReadParam(aMsg, aIter, &(aResult->mArtwork))) {
      return false;
    }
    return true;
  }
};

template <>
struct ParamTraits<mozilla::dom::MediaSessionPlaybackState>
    : public ContiguousEnumSerializer<
          mozilla::dom::MediaSessionPlaybackState,
          mozilla::dom::MediaSessionPlaybackState::None,
          mozilla::dom::MediaSessionPlaybackState::EndGuard_> {};

}  // namespace IPC

#endif  // DOM_MEDIA_MEDIASESSION_MEDIASESSIONIPCUTILS_H_
