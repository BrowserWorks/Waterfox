/*
 * Copyright (c) 2007 Henri Sivonen
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
import nu.xom.Document;
import nu.xom.Element;

/**
 * Document with <code>Mode</code>.
 * @version $Id$
 * @author hsivonen
 */
public class ModalDocument extends Document implements Mode {

    private DocumentMode mode = null;
    
    /**
     * Copy constructor (<code>Mode</code>-aware).
     * @param doc
     */
    public ModalDocument(Document doc) {
        super(doc);
        if (doc instanceof Mode) {
            Mode modal = (Mode) doc;
            setMode(modal.getMode());
        }
    }

    /**
     * With root.
     * 
     * @param elt
     */
    public ModalDocument(Element elt) {
        super(elt);
    }

    /**
     * Gets the mode.
     * @see nu.validator.htmlparser.xom.Mode#getMode()
     */
    public DocumentMode getMode() {
        return mode;
    }

    /**
     * Sets the mode.
     * @see nu.validator.htmlparser.xom.Mode#setMode(nu.validator.htmlparser.common.DocumentMode)
     */
    public void setMode(DocumentMode mode) {
        this.mode = mode;
    }
    
}
