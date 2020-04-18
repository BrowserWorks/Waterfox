/*
 * Copyright (c) 2007 Henri Sivonen
 *
 * Permission is hereby granted, free of charge, to any person obtaining a 
 * copy of this software and associated documentation files (the "Software"), 
 * to deal in the Software without restriction, including without limitation 
 * the rights to use, copy, modify, merge, publish, distribute, sublicense, 
 * and/or sell copies of the Software, and to permit persons to whom the 
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in 
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
 * DEALINGS IN THE SOFTWARE.
 */

package nu.validator.htmlparser.test;

import java.io.IOException;
import java.io.InputStream;

public class UntilHashInputStream extends InputStream {

    private final StringBuilder builder = new StringBuilder();
    
    private final InputStream delegate;

    private int buffer = -1;
    
    private boolean closed = false;

    /**
     * @param delegate
     * @throws IOException 
     */
    public UntilHashInputStream(final InputStream delegate) throws IOException {
        this.delegate = delegate;
        this.buffer = delegate.read();
        if (buffer == '#') {
            closed = true;
        }
    }

    public int read() throws IOException {
        if (closed) {
            return -1;
        }
        int rv = buffer;
        buffer = delegate.read();
        if (buffer == '#' && rv == '\n') {
            // end of stream
            closed = true;
            return -1;
        } else {
            if (rv >= 0x20 && rv < 0x80) {
                builder.append(((char)rv));
            } else {
                builder.append("0x");
                builder.append(Integer.toHexString(rv));
            }
            return rv;
        }
    }

    /**
     * @see java.io.InputStream#close()
     */
    @Override
    public void close() throws IOException {
        super.close();
        if (closed) {
            return;
        }
        for (;;) {
            int b = delegate.read();
            if (b == 0x23 || b == -1) {
                break;
            }
        }
        closed = true;
    }

    /**
     * @see java.lang.Object#toString()
     */
    @Override
    public String toString() {
        return builder.toString();
    }

}
