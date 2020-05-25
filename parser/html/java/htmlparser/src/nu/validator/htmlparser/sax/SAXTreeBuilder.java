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

package nu.validator.htmlparser.sax;

import org.xml.sax.SAXException;

import nu.validator.htmlparser.impl.HtmlAttributes;
import nu.validator.htmlparser.impl.TreeBuilder;
import nu.validator.saxtree.Characters;
import nu.validator.saxtree.Comment;
import nu.validator.saxtree.DTD;
import nu.validator.saxtree.Document;
import nu.validator.saxtree.DocumentFragment;
import nu.validator.saxtree.Element;
import nu.validator.saxtree.Node;
import nu.validator.saxtree.ParentNode;

class SAXTreeBuilder extends TreeBuilder<Element> {

    private Document document;

    private Node cachedTable = null;

    private Node cachedTablePreviousSibling = null;

    SAXTreeBuilder() {
        super();
    }

    @Override
    protected void appendComment(Element parent, char[] buf, int start, int length) {
        parent.appendChild(new Comment(tokenizer, buf, start, length));
    }

    @Override
    protected void appendCommentToDocument(char[] buf, int start, int length) {
        document.appendChild(new Comment(tokenizer, buf, start, length));
    }

    @Override
    protected void appendCharacters(Element parent, char[] buf, int start, int length) {
        parent.appendChild(new Characters(tokenizer, buf, start, length));
    }

    @Override
    protected boolean hasChildren(Element element) {
        return element.getFirstChild() != null;
    }

    @Override
    protected void appendElement(Element child, Element newParent) {
        newParent.appendChild(child);
    }

    @Override
    protected Element createHtmlElementSetAsRoot(HtmlAttributes attributes) {
        Element newElt = new Element(tokenizer, "http://www.w3.org/1999/xhtml", "html", "html", attributes, true, null);
        document.appendChild(newElt);
        return newElt;
    }

    @Override
    protected void addAttributesToElement(Element element, HtmlAttributes attributes) throws SAXException {
        HtmlAttributes existingAttrs = (HtmlAttributes) element.getAttributes();
        existingAttrs.merge(attributes);
    }

    /**
     * @see nu.validator.htmlparser.impl.TreeBuilder#appendDoctypeToDocument(java.lang.String, java.lang.String, java.lang.String)
     */
    @Override
    protected void appendDoctypeToDocument(String name, String publicIdentifier, String systemIdentifier) {
         DTD dtd = new DTD(tokenizer, name, publicIdentifier, systemIdentifier);
         dtd.setEndLocator(tokenizer);
         document.appendChild(dtd);
    }

    /**
     * Returns the document.
     *
     * @return the document
     */
    Document getDocument() {
        Document rv = document;
        document = null;
        return rv;
    }

    DocumentFragment getDocumentFragment() {
        DocumentFragment rv = new DocumentFragment();
        rv.appendChildren(document.getFirstChild());
        document = null;
        return rv;
    }

    /**
     * @throws SAXException
     * @see nu.validator.htmlparser.impl.TreeBuilder#end()
     */
    @Override
    protected void end() throws SAXException {
        document.setEndLocator(tokenizer);
        cachedTable = null;
        cachedTablePreviousSibling = null;
    }

    /**
     * @see nu.validator.htmlparser.impl.TreeBuilder#start()
     */
    @Override
    protected void start(boolean fragment) {
        document = new Document(tokenizer);
        cachedTable = null;
        cachedTablePreviousSibling = null;
    }

    @Override
    protected void appendChildrenToNewParent(Element oldParent, Element newParent) throws SAXException {
        newParent.appendChildren(oldParent);
    }

    @Override
    protected Element createElement(String ns, String name, HtmlAttributes attributes,
            Element intendedParent) throws SAXException {
        return new Element(tokenizer, ns, name, name, attributes, true, null);
    }

    @Override
    protected Element createAndInsertFosterParentedElement(String ns, String name,
            HtmlAttributes attributes, Element table, Element stackParent) throws SAXException {
        ParentNode parent = table.getParentNode();
        Element child = createElement(ns, name, attributes, parent != null ? (Element) parent : stackParent);
        if (parent != null) { // always an element if not null
            parent.insertBetween(child, previousSibling(table), table);
            cachedTablePreviousSibling = child;
        } else {
            stackParent.appendChild(child);
        }

        return child;
    }

    @Override protected void insertFosterParentedCharacters(char[] buf,
            int start, int length, Element table, Element stackParent) throws SAXException {
        Node child = new Characters(tokenizer, buf, start, length);
        ParentNode parent = table.getParentNode();
        if (parent != null) { // always an element if not null
            parent.insertBetween(child, previousSibling(table), table);
            cachedTablePreviousSibling = child;
        } else {
            stackParent.appendChild(child);
        }
    }

    @Override protected void insertFosterParentedChild(Element child,
            Element table, Element stackParent) throws SAXException {
        ParentNode parent = table.getParentNode();
        if (parent != null) { // always an element if not null
            parent.insertBetween(child, previousSibling(table), table);
            cachedTablePreviousSibling = child;
        } else {
            stackParent.appendChild(child);
        }
    }

    private Node previousSibling(Node table) {
        if (table == cachedTable) {
            return cachedTablePreviousSibling;
        } else {
            cachedTable = table;
            return (cachedTablePreviousSibling = table.getPreviousSibling());
        }
    }

    @Override protected void detachFromParent(Element element)
            throws SAXException {
        element.detach();
    }
}
