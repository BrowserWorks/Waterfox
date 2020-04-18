/*
 * Copyright (c) 2007 Henri Sivonen
 * Copyright (c) 2008-2009 Mozilla Foundation
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

package nu.validator.htmlparser.sax;

import org.xml.sax.Attributes;
import org.xml.sax.ContentHandler;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;
import org.xml.sax.ext.LexicalHandler;

import nu.validator.htmlparser.impl.HtmlAttributes;
import nu.validator.htmlparser.impl.TreeBuilder;

class SAXStreamer extends TreeBuilder<Attributes>{

    private ContentHandler contentHandler = null;
    private LexicalHandler lexicalHandler = null;

    SAXStreamer() {
        super();
    }

    @Override
    protected void addAttributesToElement(Attributes element, HtmlAttributes attributes) throws SAXException {
        Attributes existingAttrs = element;
        for (int i = 0; i < attributes.getLength(); i++) {
            String qName = attributes.getQNameNoBoundsCheck(i);
            if (existingAttrs.getIndex(qName) < 0) {
                fatal();
            }
        }
    }

    @Override
    protected void appendCharacters(Attributes parent, char[] buf, int start, int length) throws SAXException {
        contentHandler.characters(buf, start, length);
    }

    @Override
    protected void appendChildrenToNewParent(Attributes oldParent, Attributes newParent) throws SAXException {
        fatal();
    }

    @Override
    protected void appendComment(Attributes parent, char[] buf, int start, int length) throws SAXException {
        if (lexicalHandler != null) {
            lexicalHandler.comment(buf, start, length);
        }
    }

    @Override
    protected void appendCommentToDocument(char[] buf, int start, int length)
            throws SAXException {
        if (lexicalHandler != null) {
            lexicalHandler.comment(buf, start, length);
        }
    }

    @Override
    protected Attributes createElement(String ns, String name, HtmlAttributes attributes, Attributes intendedParent) throws SAXException {
        return attributes;
    }

    @Override
    protected Attributes createHtmlElementSetAsRoot(HtmlAttributes attributes) throws SAXException {
        return attributes;
    }

    @Override
    protected void detachFromParent(Attributes element) throws SAXException {
        fatal();
    }

    @Override
    protected void appendElement(Attributes child, Attributes newParent) throws SAXException {
    }

    @Override
    protected boolean hasChildren(Attributes element) throws SAXException {
        return false;
    }

    public void setContentHandler(ContentHandler handler) {
        contentHandler = handler;
    }

    public void setLexicalHandler(LexicalHandler handler) {
        lexicalHandler = handler;
    }

    /**
     * @see nu.validator.htmlparser.impl.TreeBuilder#appendDoctypeToDocument(java.lang.String, java.lang.String, java.lang.String)
     */
    @Override
    protected void appendDoctypeToDocument(String name, String publicIdentifier, String systemIdentifier) throws SAXException {
        if (lexicalHandler != null) {
            lexicalHandler.startDTD(name, publicIdentifier, systemIdentifier);
            lexicalHandler.endDTD();
        }
    }

    /**
     * @see nu.validator.htmlparser.impl.TreeBuilder#elementPopped(String, java.lang.String, java.lang.Object)
     */
    @Override
    protected void elementPopped(String ns, String name, Attributes node) throws SAXException {
        contentHandler.endElement(ns, name, name);
    }

    /**
     * @see nu.validator.htmlparser.impl.TreeBuilder#elementPushed(String, java.lang.String, java.lang.Object)
     */
    @Override
    protected void elementPushed(String ns, String name, Attributes node) throws SAXException {
        contentHandler.startElement(ns, name, name, node);
    }

    /**
     * @see nu.validator.htmlparser.impl.TreeBuilder#end()
     */
    @Override
    protected void end() throws SAXException {
        contentHandler.endDocument();
    }

    /**
     * @see nu.validator.htmlparser.impl.TreeBuilder#start()
     */
    @Override
    protected void start(boolean fragment) throws SAXException {
        contentHandler.setDocumentLocator(tokenizer);
        if (!fragment) {
            contentHandler.startDocument();
        }
    }

    protected void fatal() throws SAXException {
        SAXParseException spe = new SAXParseException(
                "Cannot recover after last error. Any further errors will be ignored.",
                tokenizer);
        if (errorHandler != null) {
            errorHandler.fatalError(spe);
        }
        throw spe;
    }

    @Override
    protected Attributes createAndInsertFosterParentedElement(String ns, String name,
            HtmlAttributes attributes, Attributes table, Attributes stackParent) throws SAXException {
        fatal();
        throw new RuntimeException("Unreachable");
    }

    @Override protected void insertFosterParentedCharacters(char[] buf,
            int start, int length, Attributes table, Attributes stackParent)
            throws SAXException {
        fatal();
    }

    @Override protected void insertFosterParentedChild(Attributes child,
            Attributes table, Attributes stackParent) throws SAXException {
        fatal();
    }

}
