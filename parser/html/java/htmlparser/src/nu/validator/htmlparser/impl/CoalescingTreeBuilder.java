/*
 * Copyright (c) 2008-2010 Mozilla Foundation
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

import org.xml.sax.SAXException;

import nu.validator.htmlparser.annotation.NoLength;

/**
 * A common superclass for tree builders that coalesce their text nodes.
 *
 * @version $Id$
 * @author hsivonen
 */
public abstract class CoalescingTreeBuilder<T> extends TreeBuilder<T> {

    protected final void accumulateCharacters(@NoLength char[] buf, int start,
            int length) throws SAXException {
        System.arraycopy(buf, start, charBuffer, charBufferLen, length);
        charBufferLen += length;
    }

    /**
     * @see nu.validator.htmlparser.impl.TreeBuilder#appendCharacters(java.lang.Object, char[], int, int)
     */
    @Override protected final void appendCharacters(T parent, char[] buf, int start,
            int length) throws SAXException {
        appendCharacters(parent, new String(buf, start, length));
    }

    protected abstract void appendCharacters(T parent, String text) throws SAXException;

    /**
     * @see nu.validator.htmlparser.impl.TreeBuilder#appendComment(java.lang.Object, char[], int, int)
     */
    @Override final protected void appendComment(T parent, char[] buf, int start,
            int length) throws SAXException {
        appendComment(parent, new String(buf, start, length));
    }

    protected abstract void appendComment(T parent, String comment) throws SAXException;

    /**
     * @see nu.validator.htmlparser.impl.TreeBuilder#appendCommentToDocument(char[], int, int)
     */
    @Override protected final void appendCommentToDocument(char[] buf, int start,
            int length) throws SAXException {
        // TODO Auto-generated method stub
        appendCommentToDocument(new String(buf, start, length));
    }

    protected abstract void appendCommentToDocument(String comment) throws SAXException;

    /**
     * @see nu.validator.htmlparser.impl.TreeBuilder#insertFosterParentedCharacters(char[], int, int, java.lang.Object, java.lang.Object)
     */
    @Override protected final void insertFosterParentedCharacters(char[] buf, int start,
            int length, T table, T stackParent) throws SAXException {
        insertFosterParentedCharacters(new String(buf, start, length), table, stackParent);
    }

    protected abstract void insertFosterParentedCharacters(String text, T table, T stackParent) throws SAXException;
}
