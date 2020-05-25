/*
 * Copyright (c) 2008 Mozilla Foundation
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

package nu.validator.htmlparser.impl;

public class PushedLocation {
    private final int line;

    private final int linePrev;

    private final int col;

    private final int colPrev;

    private final boolean nextCharOnNewLine;

    private final String publicId;

    private final String systemId;

    private final PushedLocation next;

    /**
     * @param line
     * @param linePrev
     * @param col
     * @param colPrev
     * @param nextCharOnNewLine
     * @param publicId
     * @param systemId
     * @param next
     */
    public PushedLocation(int line, int linePrev, int col, int colPrev,
            boolean nextCharOnNewLine, String publicId, String systemId,
            PushedLocation next) {
        this.line = line;
        this.linePrev = linePrev;
        this.col = col;
        this.colPrev = colPrev;
        this.nextCharOnNewLine = nextCharOnNewLine;
        this.publicId = publicId;
        this.systemId = systemId;
        this.next = next;
    }

    /**
     * Returns the line.
     * 
     * @return the line
     */
    public int getLine() {
        return line;
    }

    /**
     * Returns the linePrev.
     * 
     * @return the linePrev
     */
    public int getLinePrev() {
        return linePrev;
    }

    /**
     * Returns the col.
     * 
     * @return the col
     */
    public int getCol() {
        return col;
    }

    /**
     * Returns the colPrev.
     * 
     * @return the colPrev
     */
    public int getColPrev() {
        return colPrev;
    }

    /**
     * Returns the nextCharOnNewLine.
     * 
     * @return the nextCharOnNewLine
     */
    public boolean isNextCharOnNewLine() {
        return nextCharOnNewLine;
    }

    /**
     * Returns the publicId.
     * 
     * @return the publicId
     */
    public String getPublicId() {
        return publicId;
    }

    /**
     * Returns the systemId.
     * 
     * @return the systemId
     */
    public String getSystemId() {
        return systemId;
    }

    /**
     * Returns the next.
     * 
     * @return the next
     */
    public PushedLocation getNext() {
        return next;
    }
}
