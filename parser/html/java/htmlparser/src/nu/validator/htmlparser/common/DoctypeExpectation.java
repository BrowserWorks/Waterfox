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

package nu.validator.htmlparser.common;

/**
 * Used for indicating desired behavior with legacy doctypes.
 * 
 * @version $Id$
 * @author hsivonen
 */
public enum DoctypeExpectation {
    /**
     * Be a pure HTML5 parser.
     */
    HTML,
    
    /**
     * Require the HTML 4.01 Transitional public id. Turn on HTML4-specific
     * additional errors regardless of doctype.
     */
    HTML401_TRANSITIONAL,
    
    /**
     * Require the HTML 4.01 Transitional public id and a system id. Turn on
     * HTML4-specific additional errors regardless of doctype.
     */
    HTML401_STRICT,
    
    /**
     * Treat the doctype required by HTML 5, doctypes with the HTML 4.01 Strict 
     * public id and doctypes with the HTML 4.01 Transitional public id and a 
     * system id as non-errors. Turn on HTML4-specific additional errors if the 
     * public id is the HTML 4.01 Strict or Transitional public id.
     */
    AUTO,
    
    /**
     * Never enable HTML4-specific error checks. Never report any doctype 
     * condition as an error. (Doctype tokens in wrong places will be 
     * reported as errors, though.) The application may decide what to log 
     * in response to calls to <code>DocumentModeHanler</code>. This mode 
     * in meant for doing surveys on existing content.
     */
    NO_DOCTYPE_ERRORS
}
