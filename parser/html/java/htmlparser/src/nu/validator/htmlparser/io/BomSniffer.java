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

package nu.validator.htmlparser.io;

import java.io.IOException;

import nu.validator.htmlparser.common.ByteReadable;

/**
 * The BOM sniffing part of the HTML5 encoding sniffing algorithm.
 * 
 * @version $Id$
 * @author hsivonen
 */
public final class BomSniffer {
    
    private final ByteReadable source;

    /**
     * @param source
     */
    public BomSniffer(final ByteReadable source) {
        this.source = source;
    }
    
    Encoding sniff() throws IOException {
        int b = source.readByte();
        if (b == 0xEF) { // UTF-8
            b = source.readByte();
            if (b == 0xBB) {
                b = source.readByte();
                if (b == 0xBF) {
                    return Encoding.UTF8;
                } else {
                    return null;
                }
            } else {
                return null;
            }
        } else if (b == 0xFF) { // little-endian
            b = source.readByte();
            if (b == 0xFE) {
                return Encoding.UTF16LE;
            } else {
                return null;
            }
        } else if (b == 0xFE) { // big-endian UTF-16
            b = source.readByte();
            if (b == 0xFF) {
                return Encoding.UTF16BE;
            } else {
                return null;
            }
        } else {
            return null;            
        }
    }
    
}
