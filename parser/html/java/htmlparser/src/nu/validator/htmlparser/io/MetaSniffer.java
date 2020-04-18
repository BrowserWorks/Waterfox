/*
 * Copyright (c) 2009 Mozilla Foundation
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
import java.nio.charset.UnsupportedCharsetException;

import nu.validator.htmlparser.common.ByteReadable;
import nu.validator.htmlparser.impl.MetaScanner;

import org.xml.sax.ErrorHandler;
import org.xml.sax.Locator;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;

public class MetaSniffer extends MetaScanner implements Locator {
    
    private Encoding characterEncoding = null;

    private final ErrorHandler errorHandler;
    
    private final Locator locator;
    
    private int line = 1;
    
    private int col = 0;
    
    private boolean prevWasCR = false;

    public MetaSniffer(ErrorHandler eh, Locator locator) {
        this.errorHandler = eh;
        this.locator = locator;
        this.characterEncoding = null;
    }
    
    /**
     * -1 means end.
     * @return
     * @throws IOException
     */
    protected int read() throws IOException {
        int b = readable.readByte();
        // [NOCPP[
        switch (b) {
            case '\n':
                if (!prevWasCR) {
                    line++;
                    col = 0;
                }
                prevWasCR = false;
                break;
            case '\r':
                line++;
                col = 0;
                prevWasCR = true;
                break;
            default:
                col++;
                prevWasCR = false;
                break;
        }
        // ]NOCPP]
        return b;
    }

    /**
     * Main loop.
     * 
     * @return
     * 
     * @throws SAXException
     * @throws IOException
     * @throws
     */
    public Encoding sniff(ByteReadable readable) throws SAXException, IOException {
        this.readable = readable;
        stateLoop(stateSave);
        return characterEncoding;
    }
    

    /**
     * @param string
     * @throws SAXException
     */
    private void err(String message) throws SAXException {
        if (errorHandler != null) {
          SAXParseException spe = new SAXParseException(message, this);
          errorHandler.error(spe);
        }
    }

    /**
     * @param string
     * @throws SAXException
     */
    private void warn(String message) throws SAXException {
        if (errorHandler != null) {
          SAXParseException spe = new SAXParseException(message, this);
          errorHandler.warning(spe);
        }
    }
    
    public int getColumnNumber() {
        return col;
    }

    public int getLineNumber() {
        return line;
    }

    public String getPublicId() {
        if (locator != null) {
            return locator.getPublicId();
        }
        return null;
    }

    public String getSystemId() {
        if (locator != null) {
            return locator.getSystemId();
        }
        return null;
    }
    
    protected boolean tryCharset(String encoding) throws SAXException {
        encoding = Encoding.toAsciiLowerCase(encoding);
        try {
            // XXX spec says only UTF-16
            if ("utf-16".equals(encoding) || "utf-16be".equals(encoding) || "utf-16le".equals(encoding) || "utf-32".equals(encoding) || "utf-32be".equals(encoding) || "utf-32le".equals(encoding)) {
                this.characterEncoding = Encoding.UTF8;
                err("The internal character encoding declaration specified \u201C" + encoding + "\u201D which is not a rough superset of ASCII. Using \u201CUTF-8\u201D instead.");
                return true;
            } else {
                Encoding cs = Encoding.forName(encoding);
                String canonName = cs.getCanonName();
                if (!cs.isAsciiSuperset()) {
                    err("The encoding \u201C"
                                + encoding
                                + "\u201D is not an ASCII superset and, therefore, cannot be used in an internal encoding declaration. Continuing the sniffing algorithm.");
                    return false;
                }
                if (!cs.isRegistered()) {
                    if (encoding.startsWith("x-")) {
                        err("The encoding \u201C"
                                + encoding
                                + "\u201D is not an IANA-registered encoding. (Charmod C022)");                    
                    } else {
                        err("The encoding \u201C"
                                + encoding
                                + "\u201D is not an IANA-registered encoding and did not use the \u201Cx-\u201D prefix. (Charmod C023)");
                    }
                } else if (!cs.getCanonName().equals(encoding)) {
                    err("The encoding \u201C" + encoding
                            + "\u201D is not the preferred name of the character encoding in use. The preferred name is \u201C"
                            + canonName + "\u201D. (Charmod C024)");
                }
                if (cs.isShouldNot()) {
                    warn("Authors should not use the character encoding \u201C"
                            + encoding
                            + "\u201D. It is recommended to use \u201CUTF-8\u201D.");                
                } else if (cs.isObscure()) {
                    warn("The character encoding \u201C" + encoding + "\u201D is not widely supported. Better interoperability may be achieved by using \u201CUTF-8\u201D.");
                }
                Encoding actual = cs.getActualHtmlEncoding();
                if (actual == null) {
                    this.characterEncoding = cs;
                } else {
                    warn("Using \u201C" + actual.getCanonName() + "\u201D instead of the declared encoding \u201C" + encoding + "\u201D.");
                    this.characterEncoding = actual;
                }
                return true;
            }
        } catch (UnsupportedCharsetException e) {
            err("Unsupported character encoding name: \u201C" + encoding + "\u201D. Will continue sniffing.");
        }
        return false;
    }
}    
