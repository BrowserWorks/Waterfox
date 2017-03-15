/*
 * Copyright 2016 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#include "SkMatrix.h"
#include "SkPictureData.h"
#include "SkPicturePlayback.h"
#include "SkPictureRecord.h"
#include "SkPictureRecorder.h"
#include "SkPictureUtils.h"
#include "SkRecordedDrawable.h"
#include "SkRecordDraw.h"

void SkRecordedDrawable::onDraw(SkCanvas* canvas) {
    SkDrawable* const* drawables = nullptr;
    int drawableCount = 0;
    if (fDrawableList) {
        drawables = fDrawableList->begin();
        drawableCount = fDrawableList->count();
    }
    SkRecordDraw(*fRecord, canvas, nullptr, drawables, drawableCount, fBBH, nullptr/*callback*/);
}

SkPicture* SkRecordedDrawable::onNewPictureSnapshot() {
    SkBigPicture::SnapshotArray* pictList = nullptr;
    if (fDrawableList) {
        // TODO: should we plumb-down the BBHFactory and recordFlags from our host
        //       PictureRecorder?
        pictList = fDrawableList->newDrawableSnapshot();
    }

    size_t subPictureBytes = 0;
    for (int i = 0; pictList && i < pictList->count(); i++) {
        subPictureBytes += SkPictureUtils::ApproximateBytesUsed(pictList->begin()[i]);
    }
    // SkBigPicture will take ownership of a ref on both fRecord and fBBH.
    // We're not willing to give up our ownership, so we must ref them for SkPicture.
    return new SkBigPicture(fBounds, SkRef(fRecord.get()), pictList, SkSafeRef(fBBH.get()),
                            subPictureBytes);
}

void SkRecordedDrawable::flatten(SkWriteBuffer& buffer) const {
    // Write the bounds.
    buffer.writeRect(fBounds);

    // Create an SkPictureRecord to record the draw commands.
    SkPictInfo info;
    SkPictureRecord pictureRecord(SkISize::Make(fBounds.width(), fBounds.height()), 0);

    // If the query contains the whole picture, don't bother with the bounding box hierarchy.
    SkRect clipBounds;
    pictureRecord.getClipBounds(&clipBounds);
    SkBBoxHierarchy* bbh;
    if (clipBounds.contains(fBounds)) {
        bbh = nullptr;
    } else {
        bbh = fBBH.get();
    }

    // Record the draw commands.
    pictureRecord.beginRecording();
    SkRecordDraw(*fRecord, &pictureRecord, nullptr, fDrawableList->begin(), fDrawableList->count(),
                bbh, nullptr);
    pictureRecord.endRecording();

    // Flatten the recorded commands and drawables.
    SkPictureData pictureData(pictureRecord, info);
    pictureData.flatten(buffer);
}

sk_sp<SkFlattenable> SkRecordedDrawable::CreateProc(SkReadBuffer& buffer) {
    // Read the bounds.
    SkRect bounds;
    buffer.readRect(&bounds);

    // Unflatten into a SkPictureData.
    SkPictInfo info;
    info.setVersion(buffer.getVersion());
    info.fCullRect = bounds;
    info.fFlags = 0;    // ???
    SkAutoTDelete<SkPictureData> pictureData(SkPictureData::CreateFromBuffer(buffer, info));
    if (!pictureData) {
        return nullptr;
    }

    // Create a drawable.
    SkPicturePlayback playback(pictureData);
    SkPictureRecorder recorder;
    playback.draw(recorder.beginRecording(bounds), nullptr, &buffer);
    return recorder.finishRecordingAsDrawable();
}
