/*
 * Copyright (c) 2007 Henri Sivonen
 * Copyright (c) 2007-2009 Mozilla Foundation
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

import java.util.List;

import org.xml.sax.Attributes;
import org.xml.sax.Locator;
import org.xml.sax.SAXException;

/**
 * The common node superclass.
 * @version $Id$
 * @author hsivonen
 */
public abstract class Node implements Locator {

    /**
     * The system id.
     */
    private final String systemId;
    
    /**
     * The public id.
     */
    private final String publicId;
    
    /**
     * The column.
     */
    private final int column;
    
    /**
     * The line.
     */
    private final int line;

    /**
     * The next sibling.
     */
    private Node nextSibling = null;
    
    /**
     * The parent.
     */
    private ParentNode parentNode = null;

    /**
     * The constructor.
     * 
     * @param locator the locator
     */
    Node(Locator locator) {
        if (locator == null) {
            this.systemId = null;
            this.publicId = null;
            this.column = -1;
            this.line = -1;
        } else {
            this.systemId = locator.getSystemId();
            this.publicId = locator.getPublicId();
            this.column = locator.getColumnNumber();
            this.line = locator.getLineNumber();
        }
    }
    
    /**
     * 
     * @see org.xml.sax.Locator#getColumnNumber()
     */
    public int getColumnNumber() {
        return column;
    }

    /**
     * 
     * @see org.xml.sax.Locator#getLineNumber()
     */
    public int getLineNumber() {
        return line;
    }

    /**
     * 
     * @see org.xml.sax.Locator#getPublicId()
     */
    public String getPublicId() {
        return publicId;
    }

    /**
     * 
     * @see org.xml.sax.Locator#getSystemId()
     */
    public String getSystemId() {
        return systemId;
    }

    /**
     * Visit the node.
     * 
     * @param treeParser the visitor
     * @throws SAXException if stuff goes wrong
     */
    abstract void visit(TreeParser treeParser) throws SAXException;
    
    /**
     * Revisit the node.
     * 
     * @param treeParser the visitor
     * @throws SAXException if stuff goes wrong
     */
    void revisit(TreeParser treeParser) throws SAXException {
        return;
    }
    
    /**
     * Return the first child.
     * @return the first child
     */
    public Node getFirstChild() {
        return null;
    }

    /**
     * Returns the nextSibling.
     * 
     * @return the nextSibling
     */
    public final Node getNextSibling() {
        return nextSibling;
    }
    
    /**
     * Returns the previous sibling
     * @return the previous sibling
     */
    public final Node getPreviousSibling() {
        Node prev = null;
        Node next = parentNode.getFirstChild();
        for(;;) {
            if (this == next) {
                return prev;
            }
            prev = next;
            next = next.nextSibling;
        }
    }

    /**
     * Sets the nextSibling.
     * 
     * @param nextSibling the nextSibling to set
     */
    void setNextSibling(Node nextSibling) {
        this.nextSibling = nextSibling;
    }
    
    
    /**
     * Returns the parentNode.
     * 
     * @return the parentNode
     */
    public final ParentNode getParentNode() {
        return parentNode;
    }
    
    /**
     * Sets the parentNode.
     * 
     * @param parentNode the parentNode to set
     */
    void setParentNode(ParentNode parentNode) {
        this.parentNode = parentNode;
    }
    
    /**
     * Return the node type.
     * @return the node type
     */
    public abstract NodeType getNodeType();
    
    // Subclass-specific accessors that are hoisted here to 
    // avoid casting.
    
    /**
     * Detach this node from its parent.
     */
    public void detach() {
        if (parentNode != null) {
            parentNode.removeChild(this);
            parentNode = null;
        }
    }
    
    /**
     * Returns the name.
     * 
     * @return the name
     */
    public String getName() {
        throw new UnsupportedOperationException();
    }

    /**
     * Returns the publicIdentifier.
     * 
     * @return the publicIdentifier
     */
    public String getPublicIdentifier() {
        throw new UnsupportedOperationException();
    }

    /**
     * Returns the systemIdentifier.
     * 
     * @return the systemIdentifier
     */
    public String getSystemIdentifier() {
        throw new UnsupportedOperationException();
    }

    /**
     * Returns the attributes.
     * 
     * @return the attributes
     */
    public Attributes getAttributes() {
        throw new UnsupportedOperationException();
    }

    /**
     * Returns the localName.
     * 
     * @return the localName
     */
    public String getLocalName() {
        throw new UnsupportedOperationException();
    }

    /**
     * Returns the prefixMappings.
     * 
     * @return the prefixMappings
     */
    public List<PrefixMapping> getPrefixMappings() {
        throw new UnsupportedOperationException();
    }

    /**
     * Returns the qName.
     * 
     * @return the qName
     */
    public String getQName() {
        throw new UnsupportedOperationException();
    }

    /**
     * Returns the uri.
     * 
     * @return the uri
     */
    public String getUri() {
        throw new UnsupportedOperationException();
    }

    /**
     * Returns the data.
     * 
     * @return the data
     */
    public String getData() {
        throw new UnsupportedOperationException();
    }

    /**
     * Returns the target.
     * 
     * @return the target
     */
    public String getTarget() {
        throw new UnsupportedOperationException();
    }
}
