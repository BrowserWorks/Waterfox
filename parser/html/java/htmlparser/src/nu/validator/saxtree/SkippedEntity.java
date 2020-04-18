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
 * A skipped entity.
 * @version $Id$
 * @author hsivonen
 */
public final class SkippedEntity extends Node {

    /**
     * The name.
     */
    private final String name;

    /**
     * Constructor.
     * @param locator the locator
     * @param name the name
     */
    public SkippedEntity(Locator locator, String name) {
        super(locator);
        this.name = name;
    }

    /**
     * 
     * @see nu.validator.saxtree.Node#visit(nu.validator.saxtree.TreeParser)
     */
    @Override
    void visit(TreeParser treeParser) throws SAXException {
        treeParser.skippedEntity(name, this);
    }

    /**
     * 
     * @see nu.validator.saxtree.Node#getNodeType()
     */
    @Override
    public NodeType getNodeType() {
        return NodeType.SKIPPED_ENTITY;
    }

    /**
     * Returns the name.
     * 
     * @return the name
     */
    public String getName() {
        return name;
    }
}
