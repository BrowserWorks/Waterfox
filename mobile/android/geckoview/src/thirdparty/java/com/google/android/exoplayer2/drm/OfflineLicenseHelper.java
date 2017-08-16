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

import android.media.MediaDrm;
import android.os.ConditionVariable;
import android.os.Handler;
import android.os.HandlerThread;
import android.util.Pair;
import com.google.android.exoplayer2.C;
import com.google.android.exoplayer2.drm.DefaultDrmSessionManager.EventListener;
import com.google.android.exoplayer2.drm.DefaultDrmSessionManager.Mode;
import com.google.android.exoplayer2.drm.DrmSession.DrmSessionException;
import com.google.android.exoplayer2.upstream.HttpDataSource;
import com.google.android.exoplayer2.upstream.HttpDataSource.Factory;
import com.google.android.exoplayer2.util.Assertions;
import java.io.IOException;
import java.util.HashMap;

/**
 * Helper class to download, renew and release offline licenses.
 */
public final class OfflineLicenseHelper<T extends ExoMediaCrypto> {

  private final ConditionVariable conditionVariable;
  private final DefaultDrmSessionManager<T> drmSessionManager;
  private final HandlerThread handlerThread;

  /**
   * Instantiates a new instance which uses Widevine CDM. Call {@link #release()} when the instance
   * is no longer required.
   *
   * @param licenseUrl The default license URL.
   * @param httpDataSourceFactory A factory from which to obtain {@link HttpDataSource} instances.
   * @return A new instance which uses Widevine CDM.
   * @throws UnsupportedDrmException If the Widevine DRM scheme is unsupported or cannot be
   *     instantiated.
   */
  public static OfflineLicenseHelper<FrameworkMediaCrypto> newWidevineInstance(
      String licenseUrl, Factory httpDataSourceFactory) throws UnsupportedDrmException {
    return newWidevineInstance(
        new HttpMediaDrmCallback(licenseUrl, httpDataSourceFactory), null);
  }

  /**
   * Instantiates a new instance which uses Widevine CDM. Call {@link #release()} when the instance
   * is no longer required.
   *
   * @param callback Performs key and provisioning requests.
   * @param optionalKeyRequestParameters An optional map of parameters to pass as the last argument
   *     to {@link MediaDrm#getKeyRequest(byte[], byte[], String, int, HashMap)}. May be null.
   * @return A new instance which uses Widevine CDM.
   * @throws UnsupportedDrmException If the Widevine DRM scheme is unsupported or cannot be
   *     instantiated.
   * @see DefaultDrmSessionManager#DefaultDrmSessionManager(java.util.UUID, ExoMediaDrm,
   *     MediaDrmCallback, HashMap, Handler, EventListener)
   */
  public static OfflineLicenseHelper<FrameworkMediaCrypto> newWidevineInstance(
      MediaDrmCallback callback, HashMap<String, String> optionalKeyRequestParameters)
      throws UnsupportedDrmException {
    return new OfflineLicenseHelper<>(FrameworkMediaDrm.newInstance(C.WIDEVINE_UUID), callback,
        optionalKeyRequestParameters);
  }

  /**
   * Constructs an instance. Call {@link #release()} when the instance is no longer required.
   *
   * @param mediaDrm An underlying {@link ExoMediaDrm} for use by the manager.
   * @param callback Performs key and provisioning requests.
   * @param optionalKeyRequestParameters An optional map of parameters to pass as the last argument
   *     to {@link MediaDrm#getKeyRequest(byte[], byte[], String, int, HashMap)}. May be null.
   * @see DefaultDrmSessionManager#DefaultDrmSessionManager(java.util.UUID, ExoMediaDrm,
   *     MediaDrmCallback, HashMap, Handler, EventListener)
   */
  public OfflineLicenseHelper(ExoMediaDrm<T> mediaDrm, MediaDrmCallback callback,
      HashMap<String, String> optionalKeyRequestParameters) {
    handlerThread = new HandlerThread("OfflineLicenseHelper");
    handlerThread.start();
    conditionVariable = new ConditionVariable();
    EventListener eventListener = new EventListener() {
      @Override
      public void onDrmKeysLoaded() {
        conditionVariable.open();
      }

      @Override
      public void onDrmSessionManagerError(Exception e) {
        conditionVariable.open();
      }

      @Override
      public void onDrmKeysRestored() {
        conditionVariable.open();
      }

      @Override
      public void onDrmKeysRemoved() {
        conditionVariable.open();
      }
    };
    drmSessionManager = new DefaultDrmSessionManager<>(C.WIDEVINE_UUID, mediaDrm, callback,
        optionalKeyRequestParameters, new Handler(handlerThread.getLooper()), eventListener);
  }

  /** Releases the helper. Should be called when the helper is no longer required. */
  public void release() {
    handlerThread.quit();
  }

  /**
   * Downloads an offline license.
   *
   * @param drmInitData The {@link DrmInitData} for the content whose license is to be downloaded.
   * @return The key set id for the downloaded license.
   * @throws IOException If an error occurs reading data from the stream.
   * @throws InterruptedException If the thread has been interrupted.
   * @throws DrmSessionException Thrown when a DRM session error occurs.
   */
  public synchronized byte[] downloadLicense(DrmInitData drmInitData) throws IOException,
      InterruptedException, DrmSessionException {
    Assertions.checkArgument(drmInitData != null);
    return blockingKeyRequest(DefaultDrmSessionManager.MODE_DOWNLOAD, null, drmInitData);
  }

  /**
   * Renews an offline license.
   *
   * @param offlineLicenseKeySetId The key set id of the license to be renewed.
   * @return The renewed offline license key set id.
   * @throws DrmSessionException Thrown when a DRM session error occurs.
   */
  public synchronized byte[] renewLicense(byte[] offlineLicenseKeySetId)
      throws DrmSessionException {
    Assertions.checkNotNull(offlineLicenseKeySetId);
    return blockingKeyRequest(DefaultDrmSessionManager.MODE_DOWNLOAD, offlineLicenseKeySetId, null);
  }

  /**
   * Releases an offline license.
   *
   * @param offlineLicenseKeySetId The key set id of the license to be released.
   * @throws DrmSessionException Thrown when a DRM session error occurs.
   */
  public synchronized void releaseLicense(byte[] offlineLicenseKeySetId)
      throws DrmSessionException {
    Assertions.checkNotNull(offlineLicenseKeySetId);
    blockingKeyRequest(DefaultDrmSessionManager.MODE_RELEASE, offlineLicenseKeySetId, null);
  }

  /**
   * Returns the remaining license and playback durations in seconds, for an offline license.
   *
   * @param offlineLicenseKeySetId The key set id of the license.
   * @return The remaining license and playback durations, in seconds.
   * @throws DrmSessionException Thrown when a DRM session error occurs.
   */
  public synchronized Pair<Long, Long> getLicenseDurationRemainingSec(byte[] offlineLicenseKeySetId)
      throws DrmSessionException {
    Assertions.checkNotNull(offlineLicenseKeySetId);
    DrmSession<T> drmSession = openBlockingKeyRequest(DefaultDrmSessionManager.MODE_QUERY,
        offlineLicenseKeySetId, null);
    DrmSessionException error = drmSession.getError();
    Pair<Long, Long> licenseDurationRemainingSec =
        WidevineUtil.getLicenseDurationRemainingSec(drmSession);
    drmSessionManager.releaseSession(drmSession);
    if (error != null) {
      if (error.getCause() instanceof KeysExpiredException) {
        return Pair.create(0L, 0L);
      }
      throw error;
    }
    return licenseDurationRemainingSec;
  }

  private byte[] blockingKeyRequest(@Mode int licenseMode, byte[] offlineLicenseKeySetId,
      DrmInitData drmInitData) throws DrmSessionException {
    DrmSession<T> drmSession = openBlockingKeyRequest(licenseMode, offlineLicenseKeySetId,
        drmInitData);
    DrmSessionException error = drmSession.getError();
    byte[] keySetId = drmSession.getOfflineLicenseKeySetId();
    drmSessionManager.releaseSession(drmSession);
    if (error != null) {
      throw error;
    }
    return keySetId;
  }

  private DrmSession<T> openBlockingKeyRequest(@Mode int licenseMode, byte[] offlineLicenseKeySetId,
      DrmInitData drmInitData) {
    drmSessionManager.setMode(licenseMode, offlineLicenseKeySetId);
    conditionVariable.close();
    DrmSession<T> drmSession = drmSessionManager.acquireSession(handlerThread.getLooper(),
        drmInitData);
    // Block current thread until key loading is finished
    conditionVariable.block();
    return drmSession;
  }

}
