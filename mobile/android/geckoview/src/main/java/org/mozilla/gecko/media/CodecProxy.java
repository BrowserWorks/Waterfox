/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package org.mozilla.gecko.media;

import android.media.MediaCodec;
import android.media.MediaCodec.BufferInfo;
import android.media.MediaCodec.CryptoInfo;
import android.media.MediaFormat;
import android.os.DeadObjectException;
import android.os.RemoteException;
import android.util.Log;
import android.view.Surface;

import org.mozilla.gecko.annotation.WrapForJNI;
import org.mozilla.gecko.gfx.GeckoSurface;
import org.mozilla.gecko.mozglue.JNIObject;

import java.io.IOException;
import java.nio.ByteBuffer;
import java.util.Queue;
import java.util.concurrent.ConcurrentLinkedQueue;

// Proxy class of ICodec binder.
public final class CodecProxy {
    private static final String LOGTAG = "GeckoRemoteCodecProxy";
    private static final boolean DEBUG = false;

    private ICodec mRemote;
    private boolean mIsEncoder;
    private FormatParam mFormat;
    private GeckoSurface mOutputSurface;
    private CallbacksForwarder mCallbacks;
    private String mRemoteDrmStubId;
    private Queue<Sample> mSurfaceOutputs = new ConcurrentLinkedQueue<>();

    public interface Callbacks {
        void onInputStatus(long timestamp, boolean processed);
        void onOutputFormatChanged(MediaFormat format);
        void onOutput(Sample output);
        void onError(boolean fatal);
    }

    @WrapForJNI
    public static class NativeCallbacks extends JNIObject implements Callbacks {
        public native void onInputStatus(long timestamp, boolean processed);
        public native void onOutputFormatChanged(MediaFormat format);
        public native void onOutput(Sample output);
        public native void onError(boolean fatal);

        @Override // JNIObject
        protected void disposeNative() {
            throw new UnsupportedOperationException();
        }
    }

    private class CallbacksForwarder extends ICodecCallbacks.Stub {
        private final Callbacks mCallbacks;
        private boolean mEndOfInput;
        private boolean mCodecProxyReleased;

        CallbacksForwarder(Callbacks callbacks) {
            mCallbacks = callbacks;
        }

        @Override
        public synchronized void onInputQueued(long timestamp) throws RemoteException {
            if (!mEndOfInput && !mCodecProxyReleased) {
                mCallbacks.onInputStatus(timestamp, true /* processed */);
            }
        }

        @Override
        public synchronized void onInputPending(long timestamp) throws RemoteException {
            if (!mEndOfInput && !mCodecProxyReleased) {
                mCallbacks.onInputStatus(timestamp, false /* processed */);
            }
        }

        @Override
        public synchronized void onOutputFormatChanged(FormatParam format) throws RemoteException {
            if (!mCodecProxyReleased) {
                mCallbacks.onOutputFormatChanged(format.asFormat());
            }
        }

        @Override
        public synchronized void onOutput(Sample sample) throws RemoteException {
            if (mCodecProxyReleased) {
                sample.dispose();
                return;
            }
            if (mOutputSurface != null) {
                // Don't render to surface just yet. Callback will make that happen when it's time.
                mSurfaceOutputs.offer(sample);
                mCallbacks.onOutput(sample);
            } else {
                // Non-surface output needs no rendering.
                mCallbacks.onOutput(sample);
                mRemote.releaseOutput(sample, false);
                sample.dispose();
            }
        }

        @Override
        public void onError(boolean fatal) throws RemoteException {
            reportError(fatal);
        }

        private synchronized void reportError(boolean fatal) {
            if (!mCodecProxyReleased) {
                mCallbacks.onError(fatal);
            }
        }

        private void setEndOfInput(boolean end) {
            mEndOfInput = end;
        }

        private synchronized void setCodecProxyReleased() {
            mCodecProxyReleased = true;
        }
    }

    @WrapForJNI
    public static CodecProxy create(boolean isEncoder,
                                    MediaFormat format,
                                    GeckoSurface surface,
                                    Callbacks callbacks,
                                    String drmStubId) {
        return RemoteManager.getInstance().createCodec(isEncoder, format, surface, callbacks, drmStubId);
    }

    public static CodecProxy createCodecProxy(boolean isEncoder,
                                              MediaFormat format,
                                              GeckoSurface surface,
                                              Callbacks callbacks,
                                              String drmStubId) {
        return new CodecProxy(isEncoder, format, surface, callbacks, drmStubId);
    }

    private CodecProxy(boolean isEncoder, MediaFormat format, GeckoSurface surface, Callbacks callbacks, String drmStubId) {
        mIsEncoder = isEncoder;
        mFormat = new FormatParam(format);
        mOutputSurface = surface;
        mRemoteDrmStubId = drmStubId;
        mCallbacks = new CallbacksForwarder(callbacks);
    }

    boolean init(ICodec remote) {
        try {
            remote.setCallbacks(mCallbacks);
            if (!remote.configure(mFormat, mOutputSurface, mIsEncoder ? MediaCodec.CONFIGURE_FLAG_ENCODE : 0, mRemoteDrmStubId)) {
                return false;
            }
            remote.start();
        } catch (RemoteException e) {
            e.printStackTrace();
            return false;
        }

        mRemote = remote;
        return true;
    }

    boolean deinit() {
        try {
            mRemote.stop();
            mRemote.release();
            mRemote = null;
            return true;
        } catch (RemoteException e) {
            e.printStackTrace();
            return false;
        }
    }

    @WrapForJNI
    public synchronized boolean isAdaptivePlaybackSupported()
    {
      if (mRemote == null) {
          Log.e(LOGTAG, "cannot check isAdaptivePlaybackSupported with an ended codec");
          return false;
      }
      try {
            return mRemote.isAdaptivePlaybackSupported();
        } catch (RemoteException e) {
            e.printStackTrace();
            return false;
        }
    }

    @WrapForJNI
    public synchronized boolean input(ByteBuffer bytes, BufferInfo info, CryptoInfo cryptoInfo) {
        if (mRemote == null) {
            Log.e(LOGTAG, "cannot send input to an ended codec");
            return false;
        }

        boolean eos = info.flags == MediaCodec.BUFFER_FLAG_END_OF_STREAM;
        mCallbacks.setEndOfInput(eos);

        if (eos) {
            return sendInput(Sample.EOS);
        }

        try {
            return sendInput(mRemote.dequeueInput(info.size).set(bytes, info, cryptoInfo));
        } catch (RemoteException | NullPointerException e) {
            Log.e(LOGTAG, "fail to dequeue input buffer", e);
            return false;
        } catch (IOException e) {
            Log.e(LOGTAG, "fail to copy input data.", e);
            // Balance dequeue/queue.
            return sendInput(null);
        }
    }

    private boolean sendInput(Sample sample) {
        try {
            mRemote.queueInput(sample);
            if (sample != null) {
                sample.dispose();
            }
        } catch (Exception e) {
            Log.e(LOGTAG, "fail to queue input:" + sample, e);
            return false;
        }

        return true;
    }

    @WrapForJNI
    public synchronized boolean flush() {
        if (mRemote == null) {
            Log.e(LOGTAG, "cannot flush an ended codec");
            return false;
        }
        try {
            if (DEBUG) { Log.d(LOGTAG, "flush " + this); }
            mRemote.flush();
        } catch (DeadObjectException e) {
            return false;
        } catch (RemoteException e) {
            e.printStackTrace();
            return false;
        }
        return true;
    }

    @WrapForJNI
    public boolean release() {
        mCallbacks.setCodecProxyReleased();
        synchronized (this) {
            if (mRemote == null) {
                Log.w(LOGTAG, "codec already ended");
                return true;
            }
            if (DEBUG) { Log.d(LOGTAG, "release " + this); }

            if (!mSurfaceOutputs.isEmpty()) {
                // Flushing output buffers to surface may cause some frames to be skipped and
                // should not happen unless caller release codec before processing all buffers.
                Log.w(LOGTAG, "release codec when " + mSurfaceOutputs.size() + " output buffers unhandled");
                try {
                    for (Sample s : mSurfaceOutputs) {
                        mRemote.releaseOutput(s, true);
                    }
                } catch (RemoteException e) {
                    e.printStackTrace();
                }
                mSurfaceOutputs.clear();
            }

            try {
                RemoteManager.getInstance().releaseCodec(this);
            } catch (DeadObjectException e) {
                return false;
            } catch (RemoteException e) {
                e.printStackTrace();
                return false;
            }
            return true;
        }
    }

    @WrapForJNI
    public synchronized boolean setRates(int newBitRate) {
        if (!mIsEncoder) {
            Log.w(LOGTAG, "this api is encoder-only");
            return false;
        }

        if (android.os.Build.VERSION.SDK_INT < 19) {
            Log.w(LOGTAG, "this api was added in API level 19");
            return false;
        }

        if (mRemote == null) {
            Log.w(LOGTAG, "codec already ended");
            return true;
        }

        try {
            mRemote.setRates(newBitRate);
        } catch (RemoteException e) {
            Log.e(LOGTAG, "remote fail to set rates:" + newBitRate);
            e.printStackTrace();
        }
        return true;
    }

    @WrapForJNI
    public synchronized boolean releaseOutput(Sample sample, boolean render) {
        if (!mSurfaceOutputs.remove(sample)) {
            if (mRemote != null) Log.w(LOGTAG, "already released: " + sample);
            return true;
        }

        if (mRemote == null) {
            Log.w(LOGTAG, "codec already ended");
            sample.dispose();
            return true;
        }

        if (DEBUG && !render) { Log.d(LOGTAG, "drop output:" + sample.info.presentationTimeUs); }

        try {
            mRemote.releaseOutput(sample, render);
        } catch (RemoteException e) {
            Log.e(LOGTAG, "remote fail to render output:" + sample.info.presentationTimeUs);
            e.printStackTrace();
        }
        sample.dispose();

        return true;
    }

    /* package */ void reportError(boolean fatal) {
        mCallbacks.reportError(fatal);
    }
}
