/*
 * Copyright (c) 2007 Henri Sivonen
 * Copyright (c) 2013 Mozilla Foundation
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
import java.io.InputStream;
import java.io.Reader;
import java.nio.ByteBuffer;
import java.nio.CharBuffer;
import java.nio.charset.Charset;
import java.nio.charset.CharsetDecoder;
import java.nio.charset.CoderResult;
import java.nio.charset.CodingErrorAction;

import nu.validator.htmlparser.common.ByteReadable;
import nu.validator.htmlparser.common.Heuristics;
import nu.validator.htmlparser.common.XmlViolationPolicy;
import nu.validator.htmlparser.extra.ChardetSniffer;
import nu.validator.htmlparser.extra.IcuDetectorSniffer;
import nu.validator.htmlparser.impl.Tokenizer;

import org.xml.sax.ErrorHandler;
import org.xml.sax.Locator;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;

/**
 * Be very careful with this class. It is not a general-purpose subclass of of
 * <code>Reader</code>. Instead, it is the minimal implementation that does
 * what <code>Tokenizer</code> needs while being an instance of
 * <code>Reader</code>.
 * 
 * The only reason why this is a public class is that it needs to be visible to
 * test code in another package.
 * 
 * @version $Id$
 * @author hsivonen
 */
public final class HtmlInputStreamReader extends Reader implements
        ByteReadable, Locator {

    private static final int SNIFFING_LIMIT = 1024;

    private final InputStream inputStream;

    private final ErrorHandler errorHandler;

    private final Tokenizer tokenizer;

    private final Driver driver;

    private CharsetDecoder decoder = null;

    private boolean sniffing = true;

    private int limit = 0;

    private int position = 0;

    private int bytesRead = 0;

    private boolean eofSeen = false;

    private boolean shouldReadBytes = false;

    private boolean charsetBoundaryPassed = false;

    private final byte[] byteArray = new byte[4096]; // Length must be >=

    // SNIFFING_LIMIT

    private final ByteBuffer byteBuffer = ByteBuffer.wrap(byteArray);

    private boolean needToNotifyTokenizer = false;

    private boolean flushing = false;

    private int line = -1;

    private int col = -1;

    private int lineColPos;

    private boolean hasPendingReplacementCharacter = false;

    private boolean nextCharOnNewLine;

    private boolean prevWasCR;

    /**
     * @param inputStream
     * @param errorHandler
     * @param locator
     * @throws IOException
     * @throws SAXException
     */
    public HtmlInputStreamReader(InputStream inputStream,
            ErrorHandler errorHandler, Tokenizer tokenizer, Driver driver,
            Heuristics heuristics) throws SAXException, IOException {
        this.inputStream = inputStream;
        this.errorHandler = errorHandler;
        this.tokenizer = tokenizer;
        this.driver = driver;
        this.sniffing = true;
        Encoding encoding = (new BomSniffer(this)).sniff();
        if (encoding == null) {
            position = 0;
            encoding = (new MetaSniffer(errorHandler, this)).sniff(this);
            boolean declared = true;
            if (encoding == null) {
                declared = false;
            } else if (encoding != Encoding.UTF8) {
                warn("Legacy encoding \u201C"
                        + encoding.getCanonName()
                        + "\u201D used. Documents should use UTF-8.");
            }
            if (encoding == null
                    && (heuristics == Heuristics.CHARDET || heuristics == Heuristics.ALL)) {
                encoding = (new ChardetSniffer(byteArray, limit)).sniff();
            }
            if (encoding == null
                    && (heuristics == Heuristics.ICU || heuristics == Heuristics.ALL)) {
                position = 0;
                encoding = (new IcuDetectorSniffer(this)).sniff();
            }
            sniffing = false;
            if (encoding == null) {
                encoding = Encoding.WINDOWS1252;
            }
            if (!declared) {
                err("The character encoding was not declared. Proceeding using \u201C" + encoding.getCanonName() + "\u201D.");
            }
            if (driver != null) {
                driver.setEncoding(encoding, Confidence.TENTATIVE);
            }
        } else {
            if (encoding == Encoding.UTF8) {
                if (driver != null) {
                    driver.setEncoding(Encoding.UTF8, Confidence.CERTAIN);
                }
            } else {
                warn("Legacy encoding \u201C"
                        + encoding.getCanonName()
                        + "\u201D used. Documents should use UTF-8.");
                if (driver != null) {
                    driver.setEncoding(Encoding.UTF16, Confidence.CERTAIN);
                }
            }
        }
        this.decoder = encoding.newDecoder();
        sniffing = false;
        position = 0;
        bytesRead = 0;
        byteBuffer.position(position);
        byteBuffer.limit(limit);
        initDecoder();
    }

    /**
     * 
     */
    private void initDecoder() {
        this.decoder.onMalformedInput(CodingErrorAction.REPORT);
        this.decoder.onUnmappableCharacter(CodingErrorAction.REPORT);
    }

    public HtmlInputStreamReader(InputStream inputStream,
            ErrorHandler errorHandler, Tokenizer tokenizer, Driver driver,
            Encoding encoding) throws SAXException, IOException {
        this.inputStream = inputStream;
        this.errorHandler = errorHandler;
        this.tokenizer = tokenizer;
        this.driver = driver;
        this.decoder = encoding.newDecoder();
        this.sniffing = false;
        position = 0;
        bytesRead = 0;
        byteBuffer.position(0);
        byteBuffer.limit(0);
        shouldReadBytes = true;
        initDecoder();
    }

    @Override public void close() throws IOException {
        inputStream.close();
    }

    @Override public int read(char[] charArray) throws IOException {
        lineColPos = 0;
        assert !sniffing;
        assert charArray.length >= 2;
        if (needToNotifyTokenizer) {
            if (driver != null) {
                driver.notifyAboutMetaBoundary();
            }
            needToNotifyTokenizer = false;
        }
        CharBuffer charBuffer = CharBuffer.wrap(charArray);
        charBuffer.limit(charArray.length);
        charBuffer.position(0);
        if (flushing) {
            decoder.flush(charBuffer);
            // return -1 if zero
            int cPos = charBuffer.position();
            return cPos == 0 ? -1 : cPos;
        }
        if (hasPendingReplacementCharacter) {
            charBuffer.put('\uFFFD');
            hasPendingReplacementCharacter = false;
        }
        for (;;) {
            if (shouldReadBytes) {
                int oldLimit = byteBuffer.limit();
                int readLen;
                if (charsetBoundaryPassed) {
                    readLen = byteArray.length - oldLimit;
                } else {
                    readLen = SNIFFING_LIMIT - oldLimit;
                }
                int num = inputStream.read(byteArray, oldLimit, readLen);
                if (num == -1) {
                    eofSeen = true;
                    inputStream.close();
                } else {
                    byteBuffer.position(0);
                    byteBuffer.limit(oldLimit + num);
                }
                shouldReadBytes = false;
            }
            boolean finalDecode = false;
            for (;;) {
                int oldBytePos = byteBuffer.position();
                CoderResult cr = decoder.decode(byteBuffer, charBuffer,
                        finalDecode);
                bytesRead += byteBuffer.position() - oldBytePos;
                if (cr == CoderResult.OVERFLOW) {
                    // Decoder will remember surrogates
                    return charBuffer.position();
                } else if (cr == CoderResult.UNDERFLOW) {
                    int remaining = byteBuffer.remaining();
                    if (!charsetBoundaryPassed) {
                        if (bytesRead + remaining >= SNIFFING_LIMIT) {
                            needToNotifyTokenizer = true;
                            charsetBoundaryPassed = true;
                        }
                    }

                    // XXX what happens if the entire byte buffer consists of 
                    // a pathologically long malformed sequence?

                    // If the buffer was not fully consumed, there may be an
                    // incomplete byte sequence that needs to seed the next
                    // buffer.
                    if (remaining > 0) {
                        System.arraycopy(byteArray, byteBuffer.position(),
                                byteArray, 0, remaining);
                    }
                    byteBuffer.position(0);
                    byteBuffer.limit(remaining);
                    if (flushing) {
                        // The final decode was successful. Not sure if this
                        // ever happens.
                        // Let's get out in any case.
                        int cPos = charBuffer.position();
                        return cPos == 0 ? -1 : cPos;
                    } else if (eofSeen) {
                        // If there's something left, it isn't something that
                        // would be
                        // consumed in the middle of the stream. Rerun the loop
                        // once
                        // in the final mode.
                        shouldReadBytes = false;
                        finalDecode = true;
                        flushing = true;
                        continue;
                    } else {
                        // The usual stuff. Want more bytes next time.
                        shouldReadBytes = true;
                        int cPos = charBuffer.position();
                        if (cPos == 0) {
                            // No output. Read more bytes right away
                            break;
                        }
                        return cPos;
                    }
                } else {
                    // The result is in error. No need to test.
                    StringBuilder sb = new StringBuilder();
                    for (int i = 0; i < cr.length(); i++) {
                        if (i > 0) {
                            sb.append(", ");
                        }
                        sb.append('\u201C');
                        sb.append(Integer.toHexString(byteBuffer.get() & 0xFF));
                        bytesRead++;
                        sb.append('\u201D');
                    }
                    if (charBuffer.hasRemaining()) {
                        charBuffer.put('\uFFFD');                     
                    } else {
                        hasPendingReplacementCharacter = true;
                    }
                    calculateLineAndCol(charBuffer);
                    if (cr.isMalformed()) {
                        err("Malformed byte sequence: " + sb + ".");
                    } else if (cr.isUnmappable()) {
                        err("Unmappable byte sequence: " + sb + ".");
                    } else {
                        throw new RuntimeException(
                                "CoderResult was none of overflow, underflow, malformed or unmappable.");
                    }
                    if (finalDecode) {
                        // These were the last bytes of input. Return without
                        // relooping.
                        // return -1 if zero
                        int cPos = charBuffer.position();
                        return cPos == 0 ? -1 : cPos;
                    }
                }
            }
        }
    }

    private void calculateLineAndCol(CharBuffer charBuffer) {
        if (tokenizer != null) {
            if (lineColPos == 0) {
                line = tokenizer.getLine();
                col = tokenizer.getCol();
                nextCharOnNewLine = tokenizer.isNextCharOnNewLine();
                prevWasCR = tokenizer.isPrevCR();
            }
            
            char[] charArray = charBuffer.array();
            int i = lineColPos;
            while (i < charBuffer.position()) {
                char c;
                if (nextCharOnNewLine) {
                    line++;
                    col = 1;
                    nextCharOnNewLine = false;
                } else {
                    col++;
                }

                c = charArray[i];
                switch (c) {
                    case '\r':
                        nextCharOnNewLine = true;
                        prevWasCR = true;
                        break;
                    case '\n':
                        if (prevWasCR) {
                            col--;
                        } else {
                            nextCharOnNewLine = true;
                        }
                        break;
                }
                i++;
            }
            lineColPos = i;
        }
    }

    public int readByte() throws IOException {
        if (!sniffing) {
            throw new IllegalStateException(
                    "readByte() called when not in the sniffing state.");
        }
        if (position == SNIFFING_LIMIT) {
            return -1;
        } else if (position < limit) {
            return byteArray[position++] & 0xFF;
        } else {
            int num = inputStream.read(byteArray, limit, SNIFFING_LIMIT - limit);
            if (num == -1) {
                return -1;
            } else {
                limit += num;
                return byteArray[position++] & 0xFF;
            }
        }
    }

    public static void main(String[] args) {
        CharsetDecoder dec = Charset.forName("UTF-8").newDecoder();
        dec.onMalformedInput(CodingErrorAction.REPORT);
        dec.onUnmappableCharacter(CodingErrorAction.REPORT);
        byte[] bytes = { (byte) 0xF0, (byte) 0x9D, (byte) 0x80, (byte) 0x80 };
        byte[] bytes2 = { (byte) 0xB8, (byte) 0x80, 0x63, 0x64, 0x65 };
        ByteBuffer byteBuf = ByteBuffer.wrap(bytes);
        ByteBuffer byteBuf2 = ByteBuffer.wrap(bytes2);
        char[] chars = new char[1];
        CharBuffer charBuf = CharBuffer.wrap(chars);

        CoderResult cr = dec.decode(byteBuf, charBuf, false);
        System.out.println(cr);
        System.out.println(byteBuf);
        // byteBuf.get();
        cr = dec.decode(byteBuf2, charBuf, false);
        System.out.println(cr);
        System.out.println(byteBuf2);

    }

    public int getColumnNumber() {
        if (tokenizer != null) {
            return col;
        }
        return -1;
    }

    public int getLineNumber() {
        if (tokenizer != null) {
            return line;
        }
        return -1;
    }

    public String getPublicId() {
        if (tokenizer != null) {
            return tokenizer.getPublicId();
        }
        return null;
    }

    public String getSystemId() {
        if (tokenizer != null) {
            return tokenizer.getSystemId();
        }
        return null;
    }

    /**
     * @param string
     * @throws SAXException
     */
    private void err(String message) throws IOException {
        // TODO remove wrapping when changing read() to take a CharBuffer
        try {
            if (errorHandler != null) {
                SAXParseException spe = new SAXParseException(message, this);
                errorHandler.error(spe);
            }
        } catch (SAXException e) {
            throw (IOException) new IOException(e.getMessage()).initCause(e);
        }
    }

    private void warn(String message) throws IOException {
        // TODO remove wrapping when changing read() to take a CharBuffer
        try {
            if (errorHandler != null) {
                SAXParseException spe = new SAXParseException(message, this);
                errorHandler.warning(spe);
            }
        } catch (SAXException e) {
            throw (IOException) new IOException(e.getMessage()).initCause(e);
        }
    }

    public Charset getCharset() {
        return decoder.charset();
    }

    /**
     * @see java.io.Reader#read()
     */
    @Override public int read() throws IOException {
        throw new UnsupportedOperationException();
    }

    /**
     * @see java.io.Reader#read(char[], int, int)
     */
    @Override public int read(char[] cbuf, int off, int len) throws IOException {
        throw new UnsupportedOperationException();
    }

    /**
     * @see java.io.Reader#read(java.nio.CharBuffer)
     */
    @Override public int read(CharBuffer target) throws IOException {
        throw new UnsupportedOperationException();
    }

    public void switchEncoding(Encoding newEnc) {
        this.decoder = newEnc.newDecoder();
        initDecoder();
    }
}
