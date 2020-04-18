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

package nu.validator.htmlparser.xom;

import nu.validator.htmlparser.common.DocumentMode;
import nu.validator.htmlparser.impl.CoalescingTreeBuilder;
import nu.validator.htmlparser.impl.HtmlAttributes;
import nu.xom.Attribute;
import nu.xom.Document;
import nu.xom.Element;
import nu.xom.Node;
import nu.xom.Nodes;
import nu.xom.ParentNode;
import nu.xom.Text;
import nu.xom.XMLException;

import org.xml.sax.SAXException;

class XOMTreeBuilder extends CoalescingTreeBuilder<Element> {

    private final SimpleNodeFactory nodeFactory;

    private Document document;
    
    private int cachedTableIndex = -1;
    
    private Element cachedTable = null;

    protected XOMTreeBuilder(SimpleNodeFactory nodeFactory) {
        super();
        this.nodeFactory = nodeFactory;
    }

    @Override
    protected void addAttributesToElement(Element element, HtmlAttributes attributes)
            throws SAXException {
        try {
            for (int i = 0; i < attributes.getLength(); i++) {
                String localName = attributes.getLocalNameNoBoundsCheck(i);
                String uri = attributes.getURINoBoundsCheck(i);
                if (element.getAttribute(localName, uri) == null) {
                    element.addAttribute(nodeFactory.makeAttribute(
                            localName,
                            uri,
                            attributes.getValueNoBoundsCheck(i),
                            attributes.getTypeNoBoundsCheck(i) == "ID" ? Attribute.Type.ID
                                    : Attribute.Type.CDATA));
                }
            }
        } catch (XMLException e) {
            fatal(e);
        }
    }

    @Override protected void appendCharacters(Element parent, String text)
            throws SAXException {
        try {
            int childCount = parent.getChildCount();
            Node lastChild;
            if (childCount != 0
                    && ((lastChild = parent.getChild(childCount - 1)) instanceof Text)) {
                Text lastAsText = (Text) lastChild;
                lastAsText.setValue(lastAsText.getValue() + text);
                return;
            }
            parent.appendChild(nodeFactory.makeText(text));
        } catch (XMLException e) {
            fatal(e);
        }
    }

    @Override
    protected void appendChildrenToNewParent(Element oldParent,
            Element newParent) throws SAXException {
        try {
            Nodes children = oldParent.removeChildren();
            for (int i = 0; i < children.size(); i++) {
                newParent.appendChild(children.get(i));
            }
        } catch (XMLException e) {
            fatal(e);
        }
    }

    @Override
    protected void appendComment(Element parent, String comment) throws SAXException {
        try {
            parent.appendChild(nodeFactory.makeComment(comment));
        } catch (XMLException e) {
            fatal(e);
        }
    }

    @Override
    protected void appendCommentToDocument(String comment)
            throws SAXException {
        try {
            Element root = document.getRootElement();
            if ("http://www.xom.nu/fakeRoot".equals(root.getNamespaceURI())) {
                document.insertChild(nodeFactory.makeComment(comment), document.indexOf(root));
            } else {
                document.appendChild(nodeFactory.makeComment(comment));
            }
        } catch (XMLException e) {
            fatal(e);
        }
    }

    @Override
 protected Element createElement(String ns, String name,
            HtmlAttributes attributes, Element intendedParent) throws SAXException {
        try {
            Element rv = nodeFactory.makeElement(name, ns);
            for (int i = 0; i < attributes.getLength(); i++) {
                rv.addAttribute(nodeFactory.makeAttribute(
                        attributes.getLocalNameNoBoundsCheck(i),
                        attributes.getURINoBoundsCheck(i),
                        attributes.getValueNoBoundsCheck(i),
                        attributes.getTypeNoBoundsCheck(i) == "ID" ? Attribute.Type.ID
                                : Attribute.Type.CDATA));
            }
            return rv;
        } catch (XMLException e) {
            fatal(e);
            throw new RuntimeException("Unreachable");
        }
    }

    @Override
 protected Element createHtmlElementSetAsRoot(
            HtmlAttributes attributes) throws SAXException {
        try {
            Element rv = nodeFactory.makeElement("html",
                    "http://www.w3.org/1999/xhtml");
            for (int i = 0; i < attributes.getLength(); i++) {
                rv.addAttribute(nodeFactory.makeAttribute(
                        attributes.getLocalNameNoBoundsCheck(i),
                        attributes.getURINoBoundsCheck(i),
                        attributes.getValueNoBoundsCheck(i),
                        attributes.getTypeNoBoundsCheck(i) == "ID" ? Attribute.Type.ID
                                : Attribute.Type.CDATA));
            }
            document.setRootElement(rv);
            return rv;
        } catch (XMLException e) {
            fatal(e);
            throw new RuntimeException("Unreachable");
        }
    }

    @Override
    protected void detachFromParent(Element element) throws SAXException {
        try {
            element.detach();
        } catch (XMLException e) {
            fatal(e);
        }
    }

    @Override
    protected void appendElement(Element child,
            Element newParent) throws SAXException {
        try {
            child.detach();
            newParent.appendChild(child);
        } catch (XMLException e) {
            fatal(e);
        }
    }

    @Override
    protected boolean hasChildren(Element element) throws SAXException {
        try {
            return element.getChildCount() != 0;
        } catch (XMLException e) {
            fatal(e);
            throw new RuntimeException("Unreachable");
        }
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

    Nodes getDocumentFragment() {
        Element rootElt = document.getRootElement();
        Nodes rv = rootElt.removeChildren();
        document = null;
        return rv;
    }

    /**
     * @see nu.validator.htmlparser.impl.TreeBuilder#createElement(String,
     *      java.lang.String, org.xml.sax.Attributes, java.lang.Object)
     */
    @Override
    protected Element createElement(String ns, String name,
            HtmlAttributes attributes, Element form, Element intendedParent) throws SAXException {
        try {
            Element rv = nodeFactory.makeElement(name,
 ns, form);
            for (int i = 0; i < attributes.getLength(); i++) {
                rv.addAttribute(nodeFactory.makeAttribute(
                        attributes.getLocalName(i),
                        attributes.getURINoBoundsCheck(i),
                        attributes.getValueNoBoundsCheck(i),
                        attributes.getTypeNoBoundsCheck(i) == "ID" ? Attribute.Type.ID
                                : Attribute.Type.CDATA));
            }
            return rv;
        } catch (XMLException e) {
            fatal(e);
            throw new RuntimeException("Unreachable");
        }
    }

    /**
     * @see nu.validator.htmlparser.impl.TreeBuilder#start()
     */
    @Override
    protected void start(boolean fragment) throws SAXException {
        document = nodeFactory.makeDocument();
        cachedTableIndex = -1;
        cachedTable = null;
    }

    /**
     * @see nu.validator.htmlparser.impl.TreeBuilder#documentMode(nu.validator.htmlparser.common.DocumentMode,
     *      java.lang.String, java.lang.String, boolean)
     */
    @Override
    protected void documentMode(DocumentMode mode, String publicIdentifier,
            String systemIdentifier, boolean html4SpecificAdditionalErrorChecks)
            throws SAXException {
        if (document instanceof Mode) {
            Mode modal = (Mode) document;
            modal.setMode(mode);
        }
    }

    @Override
    protected Element createAndInsertFosterParentedElement(String ns, String name,
            HtmlAttributes attributes, Element table, Element stackParent) throws SAXException {
        try {
            Node parent = table.getParent();
            Element child = createElement(ns, name, attributes, parent != null ? (Element) parent : stackParent);
            if (parent != null) { // always an element if not null
                ((ParentNode) parent).insertChild(child, indexOfTable(table, stackParent));
                cachedTableIndex++;
            } else {
                stackParent.appendChild(child);
            }
            return child;
        } catch (XMLException e) {
            fatal(e);
            throw new RuntimeException("Unreachable");
        }
    }

    @Override protected void insertFosterParentedCharacters(String text,
            Element table, Element stackParent) throws SAXException {
        try {
            Node parent = table.getParent();
            if (parent != null) { // always an element if not null
                Element parentAsElt = (Element) parent;
                int tableIndex = indexOfTable(table, parentAsElt);
                Node prevSibling;
                if (tableIndex != 0
                        && ((prevSibling = parentAsElt.getChild(tableIndex - 1)) instanceof Text)) {
                    Text prevAsText = (Text) prevSibling;
                    prevAsText.setValue(prevAsText.getValue() + text);
                    return;
                }
                parentAsElt.insertChild(nodeFactory.makeText(text), tableIndex);
                cachedTableIndex++;
                return;
            }
            int childCount = stackParent.getChildCount();
            Node lastChild;
            if (childCount != 0
                    && ((lastChild = stackParent.getChild(childCount - 1)) instanceof Text)) {
                Text lastAsText = (Text) lastChild;
                lastAsText.setValue(lastAsText.getValue() + text);
                return;
            }
            stackParent.appendChild(nodeFactory.makeText(text));
        } catch (XMLException e) {
            fatal(e);
        }
    }

    @Override protected void insertFosterParentedChild(Element child,
            Element table, Element stackParent) throws SAXException {
        try {
            Node parent = table.getParent();
            if (parent != null) { // always an element if not null
                ((ParentNode)parent).insertChild(child, indexOfTable(table, stackParent));
                cachedTableIndex++;
            } else {
                stackParent.appendChild(child);
            }
        } catch (XMLException e) {
            fatal(e);
        }
    }
    
    private int indexOfTable(Element table, Element stackParent) {
        if (table == cachedTable) {
            return cachedTableIndex;
        } else {
            cachedTable = table;
            return (cachedTableIndex = stackParent.indexOf(table));
        }
    }

    /**
     * @see nu.validator.htmlparser.impl.TreeBuilder#end()
     */
    @Override protected void end() throws SAXException {
        cachedTableIndex = -1;
        cachedTable = null;
    }
}
