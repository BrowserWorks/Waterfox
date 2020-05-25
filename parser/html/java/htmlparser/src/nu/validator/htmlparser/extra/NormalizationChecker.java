/*
 * Copyright (c) 2006, 2007 Henri Sivonen
 * Copyright (c) 2007 Mozilla Foundation
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

package nu.validator.htmlparser.extra;

import nu.validator.htmlparser.common.CharacterHandler;

import org.xml.sax.ErrorHandler;
import org.xml.sax.Locator;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;

import com.ibm.icu.lang.UCharacter;
import com.ibm.icu.text.Normalizer;
import com.ibm.icu.text.UnicodeSet;

/**
 * @version $Id$
 * @author hsivonen
 */
public final class NormalizationChecker implements CharacterHandler {

    private ErrorHandler errorHandler;

    private Locator locator;

    /**
     * A thread-safe set of composing characters as per Charmod Norm.
     */
    @SuppressWarnings("deprecation")
    private static final UnicodeSet COMPOSING_CHARACTERS = (UnicodeSet) new UnicodeSet(
            "[[:nfc_qc=maybe:][:^ccc=0:]]").freeze();

    // see http://sourceforge.net/mailarchive/message.php?msg_id=37279908

    /**
     * A buffer for holding sequences overlap the SAX buffer boundary.
     */
    private char[] buf = new char[128];

    /**
     * A holder for the original buffer (for the memory leak prevention 
     * mechanism).
     */
    private char[] bufHolder = null;

    /**
     * The current used length of the buffer, i.e. the index of the first slot 
     * that does not hold current data.
     */
    private int pos;

    /**
     * Indicates whether the checker the next call to <code>characters()</code> 
     * is the first call in a run.
     */
    private boolean atStartOfRun;

    /**
     * Indicates whether the current run has already caused an error.
     */
    private boolean alreadyComplainedAboutThisRun;

    /**
     * Emit an error. The locator is used.
     * 
     * @param message the error message
     * @throws SAXException if something goes wrong
     */
    public void err(String message) throws SAXException {
        if (errorHandler != null) {
            SAXParseException spe = new SAXParseException(message, locator);
            errorHandler.error(spe);
        }
    }

    /**
     * Returns <code>true</code> if the argument is a composing BMP character 
     * or a surrogate and <code>false</code> otherwise.
     * 
     * @param c a UTF-16 code unit
     * @return <code>true</code> if the argument is a composing BMP character 
     * or a surrogate and <code>false</code> otherwise
     */
    private static boolean isComposingCharOrSurrogate(char c) {
        if (UCharacter.isHighSurrogate(c) || UCharacter.isLowSurrogate(c)) {
            return true;
        }
        return isComposingChar(c);
    }

    /**
     * Returns <code>true</code> if the argument is a composing character 
     * and <code>false</code> otherwise.
     * 
     * @param c a Unicode code point
     * @return <code>true</code> if the argument is a composing character 
     * <code>false</code> otherwise
     */
    private static boolean isComposingChar(int c) {
        return COMPOSING_CHARACTERS.contains(c);
    }

    /**
     * Constructor with mode selection.
     * 
     * @param sourceTextMode whether the source text-related messages 
     * should be enabled.
     */
    public NormalizationChecker(Locator locator) {
        super();
        start();
    }

    /**
     * @see nu.validator.htmlparser.common.CharacterHandler#start()
     */
    public void start() {
        atStartOfRun = true;
        alreadyComplainedAboutThisRun = false;
        pos = 0;
    }

    /**
     * @see nu.validator.htmlparser.common.CharacterHandler#characters(char[], int, int)
     */
    public void characters(char[] ch, int start, int length)
            throws SAXException {
        if (alreadyComplainedAboutThisRun) {
            return;
        }
        if (atStartOfRun) {
            char c = ch[start];
            if (pos == 1) {
                // there's a single high surrogate in buf
                if (isComposingChar(UCharacter.getCodePoint(buf[0], c))) {
                    err("Text run starts with a composing character.");
                }
                atStartOfRun = false;
            } else {
                if (length == 1 && UCharacter.isHighSurrogate(c)) {
                    buf[0] = c;
                    pos = 1;
                    return;
                } else {
                    if (UCharacter.isHighSurrogate(c)) {
                        if (isComposingChar(UCharacter.getCodePoint(c,
                                ch[start + 1]))) {
                            err("Text run starts with a composing character.");
                        }
                    } else {
                        if (isComposingCharOrSurrogate(c)) {
                            err("Text run starts with a composing character.");
                        }
                    }
                    atStartOfRun = false;
                }
            }
        }
        int i = start;
        int stop = start + length;
        if (pos > 0) {
            // there's stuff in buf
            while (i < stop && isComposingCharOrSurrogate(ch[i])) {
                i++;
            }
            appendToBuf(ch, start, i);
            if (i == stop) {
                return;
            } else {
                if (!Normalizer.isNormalized(buf, 0, pos, Normalizer.NFC, 0)) {
                    errAboutTextRun();
                }
                pos = 0;
            }
        }
        if (i < stop) {
            start = i;
            i = stop - 1;
            while (i > start && isComposingCharOrSurrogate(ch[i])) {
                i--;
            }
            if (i > start) {
                if (!Normalizer.isNormalized(ch, start, i, Normalizer.NFC, 0)) {
                    errAboutTextRun();
                }
            }
            appendToBuf(ch, i, stop);
        }
    }

    /**
     * Emits an error stating that the current text run or the source 
     * text is not in NFC.
     * 
     * @throws SAXException if the <code>ErrorHandler</code> throws
     */
    private void errAboutTextRun() throws SAXException {
        err("Source text is not in Unicode Normalization Form C.");
        alreadyComplainedAboutThisRun = true;
    }

    /**
     * Appends a slice of an UTF-16 code unit array to the internal 
     * buffer.
     * 
     * @param ch the array from which to copy
     * @param start the index of the first element that is copied
     * @param end the index of the first element that is not copied
     */
    private void appendToBuf(char[] ch, int start, int end) {
        if (start == end) {
            return;
        }
        int neededBufLen = pos + (end - start);
        if (neededBufLen > buf.length) {
            char[] newBuf = new char[neededBufLen];
            System.arraycopy(buf, 0, newBuf, 0, pos);
            if (bufHolder == null) {
                bufHolder = buf; // keep the original around
            }
            buf = newBuf;
        }
        System.arraycopy(ch, start, buf, pos, end - start);
        pos += (end - start);
    }

    /**
     * @see nu.validator.htmlparser.common.CharacterHandler#end()
     */
    public void end() throws SAXException {
        if (!alreadyComplainedAboutThisRun
                && !Normalizer.isNormalized(buf, 0, pos, Normalizer.NFC, 0)) {
            errAboutTextRun();
        }
        if (bufHolder != null) {
            // restore the original small buffer to avoid leaking
            // memory if this checker is recycled
            buf = bufHolder;
            bufHolder = null;
        }
    }

    public void setErrorHandler(ErrorHandler errorHandler) {
        this.errorHandler = errorHandler;
    }

}
