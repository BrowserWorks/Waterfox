/*
 * Copyright (c) 2010 Mozilla Foundation
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

package nu.validator.htmlparser.common;

import org.xml.sax.SAXException;

/**
 * An interface for intercepting information about the state transitions that
 * the tokenizer is making.
 * 
 * @version $Id$
 * @author hsivonen
 */
public interface TransitionHandler {

    /**
     * This method is called for every tokenizer state transition.
     * 
     * @param from
     *            the state the tokenizer is transitioning from
     * @param to
     *            the state being transitioned to
     * @param reconsume
     *            <code>true</code> if the current input character is going to
     *            be reconsumed in the new state
     * @param pos
     *            the current index into the input stream
     * @throws SAXException
     *             if something went wrong
     */
    void transition(int from, int to, boolean reconsume, int pos)
            throws SAXException;
}
