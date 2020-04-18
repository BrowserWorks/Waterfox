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

import org.xml.sax.Locator;
import org.xml.sax.SAXException;

/**
 * A doctype.
 * @version $Id$
 * @author hsivonen
 */
public final class DTD extends ParentNode {

    /**
     * The name.
     */
    private final String name;
    
    /**
     * The public id.
     */
    private final String publicIdentifier;
    
    /**
     * The system id.
     */
    private final String systemIdentifier;

    /**
     * The constructor.
     * @param locator the locator
     * @param name the name
     * @param publicIdentifier the public id
     * @param systemIdentifier the system id
     */
    public DTD(Locator locator, String name, String publicIdentifier, String systemIdentifier) {
        super(locator);
        this.name = name;
        this.publicIdentifier = publicIdentifier;
        this.systemIdentifier = systemIdentifier;
    }

    /**
     * 
     * @see nu.validator.saxtree.Node#visit(nu.validator.saxtree.TreeParser)
     */
    @Override
    void visit(TreeParser treeParser) throws SAXException {
        treeParser.startDTD(name, publicIdentifier, systemIdentifier, this);
    }

    /**
     * @see nu.validator.saxtree.Node#revisit(nu.validator.saxtree.TreeParser)
     */
    @Override
    void revisit(TreeParser treeParser) throws SAXException {
        treeParser.endDTD(endLocator);
    }

    /**
     * Returns the name.
     * 
     * @return the name
     */
    public String getName() {
        return name;
    }

    /**
     * Returns the publicIdentifier.
     * 
     * @return the publicIdentifier
     */
    public String getPublicIdentifier() {
        return publicIdentifier;
    }

    /**
     * Returns the systemIdentifier.
     * 
     * @return the systemIdentifier
     */
    public String getSystemIdentifier() {
        return systemIdentifier;
    }

    /**
     * 
     * @see nu.validator.saxtree.Node#getNodeType()
     */
    @Override
    public NodeType getNodeType() {
        return NodeType.DTD;
    }

}
