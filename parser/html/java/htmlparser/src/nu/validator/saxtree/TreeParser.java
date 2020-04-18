/*
 * Copyright (c) 2007 Henri Sivonen
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

package nu.validator.saxtree;

import org.xml.sax.Attributes;
import org.xml.sax.ContentHandler;
import org.xml.sax.Locator;
import org.xml.sax.SAXException;
import org.xml.sax.ext.LexicalHandler;

/**
 * A tree visitor that replays a tree as SAX events.
 * @version $Id$
 * @author hsivonen
 */
public final class TreeParser implements Locator {
    
    /**
     * The content handler.
     */
    private final ContentHandler contentHandler;

    /**
     * The lexical handler.
     */
    private final LexicalHandler lexicalHandler;

    /**
     * The current locator.
     */
    private Locator locatorDelegate;

    /**
     * The constructor.
     * 
     * @param contentHandler
     *            must not be <code>null</code>
     * @param lexicalHandler
     *            may be <code>null</code>
     */
    public TreeParser(final ContentHandler contentHandler,
            final LexicalHandler lexicalHandler) {
        if (contentHandler == null) {
            throw new IllegalArgumentException("contentHandler was null.");
        }
        this.contentHandler = contentHandler;
        if (lexicalHandler == null) {
            this.lexicalHandler = new NullLexicalHandler();
        } else {
            this.lexicalHandler = lexicalHandler;
        }
    }

    /**
     * Causes SAX events for the tree rooted at the argument to be emitted.
     * <code>startDocument()</code> and <code>endDocument()</code> are only
     * emitted for a <code>Document</code> node.
     * 
     * @param node
     *            the root
     * @throws SAXException
     */
    public void parse(Node node) throws SAXException {
        contentHandler.setDocumentLocator(this);
        Node current = node;
        Node next;
        for (;;) {
            current.visit(this);
            if ((next = current.getFirstChild()) != null) {
                current = next;
                continue;
            }
            for (;;) {
                current.revisit(this);
                if (current == node) {
                    return;
                }
                if ((next = current.getNextSibling()) != null) {
                    current = next;
                    break;
                }
                current = current.getParentNode();
            }
        }
    }

    /**
     * @see org.xml.sax.ContentHandler#characters(char[], int, int)
     */
    void characters(char[] ch, int start, int length, Locator locator)
            throws SAXException {
        this.locatorDelegate = locator;
        contentHandler.characters(ch, start, length);
    }

    /**
     * @see org.xml.sax.ContentHandler#endDocument()
     */
    void endDocument(Locator locator) throws SAXException {
        this.locatorDelegate = locator;
        contentHandler.endDocument();
    }

    /**
     * @see org.xml.sax.ContentHandler#endElement(java.lang.String,
     *      java.lang.String, java.lang.String)
     */
    void endElement(String uri, String localName, String qName, Locator locator)
            throws SAXException {
        this.locatorDelegate = locator;
        contentHandler.endElement(uri, localName, qName);
    }

    /**
     * @see org.xml.sax.ContentHandler#endPrefixMapping(java.lang.String)
     */
    void endPrefixMapping(String prefix, Locator locator) throws SAXException {
        this.locatorDelegate = locator;
        contentHandler.endPrefixMapping(prefix);
    }

    /**
     * @see org.xml.sax.ContentHandler#ignorableWhitespace(char[], int, int)
     */
    void ignorableWhitespace(char[] ch, int start, int length, Locator locator)
            throws SAXException {
        this.locatorDelegate = locator;
        contentHandler.ignorableWhitespace(ch, start, length);
    }

    /**
     * @see org.xml.sax.ContentHandler#processingInstruction(java.lang.String,
     *      java.lang.String)
     */
    void processingInstruction(String target, String data, Locator locator)
            throws SAXException {
        this.locatorDelegate = locator;
        contentHandler.processingInstruction(target, data);
    }

    /**
     * @see org.xml.sax.ContentHandler#skippedEntity(java.lang.String)
     */
    void skippedEntity(String name, Locator locator) throws SAXException {
        this.locatorDelegate = locator;
        contentHandler.skippedEntity(name);
    }

    /**
     * @see org.xml.sax.ContentHandler#startDocument()
     */
    void startDocument(Locator locator) throws SAXException {
        this.locatorDelegate = locator;
        contentHandler.startDocument();
    }

    /**
     * @see org.xml.sax.ContentHandler#startElement(java.lang.String,
     *      java.lang.String, java.lang.String, org.xml.sax.Attributes)
     */
    void startElement(String uri, String localName, String qName,
            Attributes atts, Locator locator) throws SAXException {
        this.locatorDelegate = locator;
        contentHandler.startElement(uri, localName, qName, atts);
    }

    /**
     * @see org.xml.sax.ContentHandler#startPrefixMapping(java.lang.String,
     *      java.lang.String)
     */
    void startPrefixMapping(String prefix, String uri, Locator locator)
            throws SAXException {
        this.locatorDelegate = locator;
        contentHandler.startPrefixMapping(prefix, uri);
    }

    /**
     * @see org.xml.sax.ext.LexicalHandler#comment(char[], int, int)
     */
    void comment(char[] ch, int start, int length, Locator locator)
            throws SAXException {
        this.locatorDelegate = locator;
        lexicalHandler.comment(ch, start, length);
    }

    /**
     * @see org.xml.sax.ext.LexicalHandler#endCDATA()
     */
    void endCDATA(Locator locator) throws SAXException {
        this.locatorDelegate = locator;
        lexicalHandler.endCDATA();
    }

    /**
     * @see org.xml.sax.ext.LexicalHandler#endDTD()
     */
    void endDTD(Locator locator) throws SAXException {
        this.locatorDelegate = locator;
        lexicalHandler.endDTD();
    }

    /**
     * @see org.xml.sax.ext.LexicalHandler#endEntity(java.lang.String)
     */
    void endEntity(String name, Locator locator) throws SAXException {
        this.locatorDelegate = locator;
        lexicalHandler.endEntity(name);
    }

    /**
     * @see org.xml.sax.ext.LexicalHandler#startCDATA()
     */
    void startCDATA(Locator locator) throws SAXException {
        this.locatorDelegate = locator;
        lexicalHandler.startCDATA();
    }

    /**
     * @see org.xml.sax.ext.LexicalHandler#startDTD(java.lang.String,
     *      java.lang.String, java.lang.String)
     */
    void startDTD(String name, String publicId, String systemId, Locator locator)
            throws SAXException {
        this.locatorDelegate = locator;
        lexicalHandler.startDTD(name, publicId, systemId);
    }

    /**
     * @see org.xml.sax.ext.LexicalHandler#startEntity(java.lang.String)
     */
    void startEntity(String name, Locator locator) throws SAXException {
        this.locatorDelegate = locator;
        lexicalHandler.startEntity(name);
    }

    /**
     * @see org.xml.sax.Locator#getColumnNumber()
     */
    public int getColumnNumber() {
        if (locatorDelegate == null) {
            return -1;
        } else {
            return locatorDelegate.getColumnNumber();
        }
    }

    /**
     * @see org.xml.sax.Locator#getLineNumber()
     */
    public int getLineNumber() {
        if (locatorDelegate == null) {
            return -1;
        } else {
            return locatorDelegate.getLineNumber();
        }
    }

    /**
     * @see org.xml.sax.Locator#getPublicId()
     */
    public String getPublicId() {
        if (locatorDelegate == null) {
            return null;
        } else {

            return locatorDelegate.getPublicId();
        }
    }

    /**
     * @see org.xml.sax.Locator#getSystemId()
     */
    public String getSystemId() {
        if (locatorDelegate == null) {
            return null;
        } else {
            return locatorDelegate.getSystemId();
        }
    }
}
