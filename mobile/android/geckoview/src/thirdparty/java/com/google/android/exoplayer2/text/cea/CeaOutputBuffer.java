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
package com.google.android.exoplayer2.text.cea;

import com.google.android.exoplayer2.text.SubtitleOutputBuffer;

/**
 * A {@link SubtitleOutputBuffer} for {@link CeaDecoder}s.
 */
public final class CeaOutputBuffer extends SubtitleOutputBuffer {

  private final CeaDecoder owner;

  /**
   * @param owner The decoder that owns this buffer.
   */
  public CeaOutputBuffer(CeaDecoder owner) {
    super();
    this.owner = owner;
  }

  @Override
  public final void release() {
    owner.releaseOutputBuffer(this);
  }

}
