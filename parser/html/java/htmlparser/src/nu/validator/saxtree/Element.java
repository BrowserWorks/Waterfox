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

import java.util.List;

import org.xml.sax.Attributes;
import org.xml.sax.Locator;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.AttributesImpl;

/**
 * An element.
 * @version $Id$
 * @author hsivonen
 */
public final class Element extends ParentNode {

    /**
     * The namespace URI.
     */
    private final String uri;

    /**
     * The local name.
     */
    private final String localName;

    /**
     * The qualified name.
     */
    private final String qName;

    /**
     * The attributes.
     */
    private final Attributes attributes;

    /**
     * The namespace prefix mappings.
     */
    private final List<PrefixMapping> prefixMappings;

    /**
     * The contructor.
     * @param locator the locator.
     * @param uri the namespace URI
     * @param localName the local name
     * @param qName the qualified name
     * @param atts the attributes
     * @param retainAttributes <code>true</code> to retain the attributes instead of copying
     * @param prefixMappings the prefix mappings
     */
    public Element(Locator locator, String uri, String localName, String qName,
            Attributes atts, boolean retainAttributes,
            List<PrefixMapping> prefixMappings) {
        super(locator);
        this.uri = uri;
        this.localName = localName;
        this.qName = qName;
        if (retainAttributes) {
            this.attributes = atts;
        } else {
            this.attributes = new AttributesImpl(atts);
        }
        this.prefixMappings = prefixMappings;
    }

    /**
     * 
     * @see nu.validator.saxtree.Node#visit(nu.validator.saxtree.TreeParser)
     */
    @Override
    void visit(TreeParser treeParser) throws SAXException {
        if (prefixMappings != null) {
            for (PrefixMapping mapping : prefixMappings) {
                treeParser.startPrefixMapping(mapping.getPrefix(),
                        mapping.getUri(), this);
            }
        }
        treeParser.startElement(uri, localName, qName, attributes, this);
    }

    /**
     * @see nu.validator.saxtree.Node#revisit(nu.validator.saxtree.TreeParser)
     */
    @Override
    void revisit(TreeParser treeParser) throws SAXException {
        treeParser.endElement(uri, localName, qName, endLocator);
        if (prefixMappings != null) {
            for (PrefixMapping mapping : prefixMappings) {
                treeParser.endPrefixMapping(mapping.getPrefix(), endLocator);
            }
        }
    }

    /**
     * Returns the attributes.
     * 
     * @return the attributes
     */
    public Attributes getAttributes() {
        return attributes;
    }

    /**
     * Returns the localName.
     * 
     * @return the localName
     */
    public String getLocalName() {
        return localName;
    }

    /**
     * Returns the prefixMappings.
     * 
     * @return the prefixMappings
     */
    public List<PrefixMapping> getPrefixMappings() {
        return prefixMappings;
    }

    /**
     * Returns the qName.
     * 
     * @return the qName
     */
    public String getQName() {
        return qName;
    }

    /**
     * Returns the uri.
     * 
     * @return the uri
     */
    public String getUri() {
        return uri;
    }

    /**
     * 
     * @see nu.validator.saxtree.Node#getNodeType()
     */
    @Override
    public NodeType getNodeType() {
        return NodeType.ELEMENT;
    }

}
