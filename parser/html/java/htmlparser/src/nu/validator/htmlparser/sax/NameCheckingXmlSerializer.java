/*
 * Copyright (c) 2009 Mozilla Foundation
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

import java.io.OutputStream;
import java.io.Writer;

import nu.validator.htmlparser.impl.NCName;

import org.xml.sax.SAXException;

public class NameCheckingXmlSerializer extends XmlSerializer {

    public NameCheckingXmlSerializer(OutputStream out) {
        super(out);
    }

    public NameCheckingXmlSerializer(Writer out) {
        super(out);
    }

    /**
     * @see nu.validator.htmlparser.sax.XmlSerializer#checkNCName()
     */
    @Override protected void checkNCName(String name) throws SAXException {
        if (!NCName.isNCName(name)) {
            throw new SAXException("Not an XML 1.0 4th ed. NCName: " + name);
        }
    }

}
