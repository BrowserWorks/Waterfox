/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

package org.mozilla.gecko.media;

// Non-default types used in interface.
import android.os.Bundle;
import android.view.Surface;
import org.mozilla.gecko.media.FormatParam;
import org.mozilla.gecko.media.ICodecCallbacks;
import org.mozilla.gecko.media.Sample;

interface ICodec {
    void setCallbacks(in ICodecCallbacks callbacks);
    boolean configure(in FormatParam format, inout Surface surface, int flags);
    oneway void start();
    oneway void stop();
    oneway void flush();
    oneway void release();

    Sample dequeueInput(int size);
    oneway void queueInput(in Sample sample);

    oneway void releaseOutput(in Sample sample);
}
