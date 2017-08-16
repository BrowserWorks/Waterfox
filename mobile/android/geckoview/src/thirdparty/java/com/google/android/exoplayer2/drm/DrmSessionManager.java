/*
 * Copyright (C) 2016 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.google.android.exoplayer2.drm;

import android.annotation.TargetApi;
import android.os.Looper;

/**
 * Manages a DRM session.
 */
@TargetApi(16)
public interface DrmSessionManager<T extends ExoMediaCrypto> {

  /**
   * Acquires a {@link DrmSession} for the specified {@link DrmInitData}. The {@link DrmSession}
   * must be returned to {@link #releaseSession(DrmSession)} when it is no longer required.
   *
   * @param playbackLooper The looper associated with the media playback thread.
   * @param drmInitData DRM initialization data.
   * @return The DRM session.
   */
  DrmSession<T> acquireSession(Looper playbackLooper, DrmInitData drmInitData);

  /**
   * Releases a {@link DrmSession}.
   */
  void releaseSession(DrmSession<T> drmSession);

}
