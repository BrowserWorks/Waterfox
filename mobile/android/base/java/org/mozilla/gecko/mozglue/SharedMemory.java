/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package org.mozilla.gecko.mozglue;

import android.os.MemoryFile;
import android.os.Parcel;
import android.os.ParcelFileDescriptor;
import android.os.Parcelable;
import android.util.Log;

import java.io.FileDescriptor;
import java.io.IOException;
import java.lang.reflect.Method;

public class SharedMemory implements Parcelable {
    private static final String LOGTAG = "GeckoShmem";
    private static Method sGetFDMethod = null; // MemoryFile.getFileDescriptor() is hidden. :(
    private ParcelFileDescriptor mDescriptor;
    private int mSize;
    private int mId;
    private long mHandle; // The native pointer.
    private boolean mIsMapped;
    private MemoryFile mBackedFile;

    static {
        try {
            sGetFDMethod = MemoryFile.class.getDeclaredMethod("getFileDescriptor");
        } catch (NoSuchMethodException e) {
            e.printStackTrace();
        }
    }

    private SharedMemory(Parcel in) {
        mDescriptor = in.readFileDescriptor();
        mSize = in.readInt();
        mId = in.readInt();
    }

    public static final Creator<SharedMemory> CREATOR = new Creator<SharedMemory>() {
        @Override
        public SharedMemory createFromParcel(Parcel in) {
            return new SharedMemory(in);
        }

        @Override
        public SharedMemory[] newArray(int size) {
            return new SharedMemory[size];
        }
    };

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        // We don't want ParcelFileDescriptor.writeToParcel() to close the fd.
        dest.writeFileDescriptor(mDescriptor.getFileDescriptor());
        dest.writeInt(mSize);
        dest.writeInt(mId);
    }

    public SharedMemory(int id, int size) throws NoSuchMethodException, IOException {
        if (sGetFDMethod == null) {
            throw new NoSuchMethodException("MemoryFile.getFileDescriptor() doesn't exist.");
        }
        mBackedFile = new MemoryFile(null, size);
        try {
            FileDescriptor fd = (FileDescriptor)sGetFDMethod.invoke(mBackedFile);
            mDescriptor = ParcelFileDescriptor.dup(fd);
            mSize = size;
            mId = id;
            mBackedFile.allowPurging(false);
        } catch (Exception e) {
            e.printStackTrace();
            close();
            throw new IOException(e.getMessage());
        }
    }

    public void flush() {
        if (mBackedFile == null) {
            close();
        }
    }

    public void close() {
        if (mIsMapped) {
            unmap(mHandle, mSize);
            mHandle = 0;
        }

        if (mDescriptor != null) {
            try {
                mDescriptor.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
            mDescriptor = null;
        }
    }

    // Should only be called by process that allocates shared memory.
    public void dispose() {
        if (!isValid()) {
            return;
        }

        close();

        if (mBackedFile != null) {
            mBackedFile.close();
            mBackedFile = null;
        }
    }

    private native void unmap(long address, int size);

    public boolean isValid() { return mDescriptor != null; }

    public int getSize() { return mSize; }

    private int getFD() {
        return isValid() ? mDescriptor.getFd() : -1;
    }

    public long getPointer() {
        if (!isValid()) {
            return 0;
        }

        if (!mIsMapped) {
            mHandle = map(getFD(), mSize);
            if (mHandle != 0) {
                mIsMapped = true;
            }
        }
        return mHandle;
    }

    private native long map(int fd, int size);

    @Override
    protected void finalize() throws Throwable {
        if (mBackedFile != null) {
            Log.w(LOGTAG, "dispose() not called before finalizing");
        }
        dispose();

        super.finalize();
    }

    @Override
    public String toString() {
        return "SHM(" + getSize() + " bytes): id=" + mId + ", backing=" + mBackedFile + ",fd=" + mDescriptor;
    }

    @Override
    public boolean equals(Object that) {
        return (this == that) ||
                ((that instanceof SharedMemory) && (hashCode() == that.hashCode()));
    }

    @Override
    public int hashCode() {
        return mId;
    }
}
