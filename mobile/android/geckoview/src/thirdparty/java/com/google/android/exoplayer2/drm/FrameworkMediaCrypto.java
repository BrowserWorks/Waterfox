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
import android.media.MediaCrypto;
import com.google.android.exoplayer2.util.Assertions;

/**
 * An {@link ExoMediaCrypto} implementation that wraps the framework {@link MediaCrypto}.
 */
@TargetApi(16)
public final class FrameworkMediaCrypto implements ExoMediaCrypto {

  private final MediaCrypto mediaCrypto;

  /* package */ FrameworkMediaCrypto(MediaCrypto mediaCrypto) {
    this.mediaCrypto = Assertions.checkNotNull(mediaCrypto);
  }

  public MediaCrypto getWrappedMediaCrypto() {
    return mediaCrypto;
  }

  @Override
  public boolean requiresSecureDecoderComponent(String mimeType) {
    return mediaCrypto.requiresSecureDecoderComponent(mimeType);
  }

}
