/*
 * Copyright (c) 2007 Henri Sivonen
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

package nu.validator.htmlparser.common;

import nu.validator.htmlparser.annotation.Const;
import nu.validator.htmlparser.annotation.NoLength;
import nu.validator.htmlparser.impl.ElementName;
import nu.validator.htmlparser.impl.HtmlAttributes;
import nu.validator.htmlparser.impl.Tokenizer;

import org.xml.sax.SAXException;

/**
 * <code>Tokenizer</code> reports tokens through this interface.
 * 
 * @version $Id$
 * @author hsivonen
 */
public interface TokenHandler {

    /**
     * This method is called at the start of tokenization before any other
     * methods on this interface are called. Implementations should hold the
     * reference to the <code>Tokenizer</code> in order to set the content
     * model flag and in order to be able to query for <code>Locator</code>
     * data.
     * 
     * @param self
     *            the <code>Tokenizer</code>.
     * @throws SAXException
     *             if something went wrong
     */
    public void startTokenization(Tokenizer self) throws SAXException;

    /**
     * If this handler implementation cares about comments, return
     * <code>true</code>. If not, return <code>false</code>.
     * 
     * @return whether this handler wants comments
     * @throws SAXException
     *             if something went wrong
     */
    public boolean wantsComments() throws SAXException;

    /**
     * Receive a doctype token.
     * 
     * @param name
     *            the name
     * @param publicIdentifier
     *            the public id
     * @param systemIdentifier
     *            the system id
     * @param forceQuirks
     *            whether the token is correct
     * @throws SAXException
     *             if something went wrong
     */
    public void doctype(String name, String publicIdentifier,
            String systemIdentifier, boolean forceQuirks) throws SAXException;

    /**
     * Receive a start tag token.
     * 
     * @param eltName
     *            the tag name
     * @param attributes
     *            the attributes
     * @param selfClosing
     *            TODO
     * @throws SAXException
     *             if something went wrong
     */
    public void startTag(ElementName eltName, HtmlAttributes attributes,
            boolean selfClosing) throws SAXException;

    /**
     * Receive an end tag token.
     * 
     * @param eltName
     *            the tag name
     * @throws SAXException
     *             if something went wrong
     */
    public void endTag(ElementName eltName) throws SAXException;

    /**
     * Receive a comment token. The data is junk if the
     * <code>wantsComments()</code> returned <code>false</code>.
     * 
     * @param buf
     *            a buffer holding the data
     * @param start the offset into the buffer
     * @param length
     *            the number of code units to read
     * @throws SAXException
     *             if something went wrong
     */
    public void comment(@NoLength char[] buf, int start, int length) throws SAXException;

    /**
     * Receive character tokens. This method has the same semantics as the SAX
     * method of the same name.
     * 
     * @param buf
     *            a buffer holding the data
     * @param start
     *            offset into the buffer
     * @param length
     *            the number of code units to read
     * @throws SAXException
     *             if something went wrong
     * @see org.xml.sax.ContentHandler#characters(char[], int, int)
     */
    public void characters(@Const @NoLength char[] buf, int start, int length)
            throws SAXException;

    /**
     * Reports a U+0000 that's being turned into a U+FFFD.
     * 
     * @throws SAXException
     *             if something went wrong
     */
    public void zeroOriginatingReplacementCharacter() throws SAXException;
    
    /**
     * The end-of-file token.
     * 
     * @throws SAXException
     *             if something went wrong
     */
    public void eof() throws SAXException;

    /**
     * The perform final cleanup.
     * 
     * @throws SAXException
     *             if something went wrong
     */
    public void endTokenization() throws SAXException;

    /**
     * Checks if the CDATA sections are allowed.
     * 
     * @return <code>true</code> if CDATA sections are allowed
     * @throws SAXException
     *             if something went wrong
     */
    public boolean cdataSectionAllowed() throws SAXException;

    /**
     * Notifies the token handler of the worst case amount of data to be
     * reported via <code>characters()</code> and
     * <code>zeroOriginatingReplacementCharacter()</code>.
     *
     * @param inputLength the maximum number of chars that can be reported
     * via <code>characters()</code> and
     * <code>zeroOriginatingReplacementCharacter()</code> before a new call to
     * this method.
     */
    public void ensureBufferSpace(int inputLength) throws SAXException;
}
