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
 * A processing instruction.
 * @version $Id$
 * @author hsivonen
 */
public final class ProcessingInstruction extends Node {

    /**
     * PI target.
     */
    private final String target;
    
    /**
     * PI data.
     */
    private final String data;

    /**
     * Constructor.
     * @param locator the locator
     * @param target PI target
     * @param data PI data
     */
    public ProcessingInstruction(Locator locator, String target, String data) {
        super(locator);
        this.target = target;
        this.data = data;
    }

    /**
     * 
     * @see nu.validator.saxtree.Node#visit(nu.validator.saxtree.TreeParser)
     */
    @Override
    void visit(TreeParser treeParser) throws SAXException {
        treeParser.processingInstruction(target, data, this);
    }

    /**
     * 
     * @see nu.validator.saxtree.Node#getNodeType()
     */
    @Override
    public NodeType getNodeType() {
        return NodeType.PROCESSING_INSTRUCTION;
    }

    /**
     * Returns the data.
     * 
     * @return the data
     */
    public String getData() {
        return data;
    }

    /**
     * Returns the target.
     * 
     * @return the target
     */
    public String getTarget() {
        return target;
    }

}
