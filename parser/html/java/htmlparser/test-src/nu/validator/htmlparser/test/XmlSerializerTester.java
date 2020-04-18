/*
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

package nu.validator.htmlparser.test;

import org.xml.sax.SAXException;
import org.xml.sax.helpers.AttributesImpl;

import nu.validator.htmlparser.sax.XmlSerializer;

public class XmlSerializerTester {

    
    
    /**
     * @param args
     * @throws SAXException 
     */
    public static void main(String[] args) throws SAXException {
        AttributesImpl attrs = new AttributesImpl();
        XmlSerializer serializer = new XmlSerializer(System.out);
        serializer.startDocument();
        serializer.startElement("1", "a", null, attrs);
        serializer.startElement("1", "b", null, attrs);
        serializer.endElement("1", "b", null);
        serializer.startElement("2", "c", null, attrs);
        serializer.endElement("2", "c", null);
        attrs.addAttribute("http://www.w3.org/1999/02/22-rdf-syntax-ns#", "about", null, "CDATA", "");
        serializer.startElement("http://www.w3.org/1999/02/22-rdf-syntax-ns#", "d", null, attrs);
        serializer.endElement("http://www.w3.org/1999/02/22-rdf-syntax-ns#", "d", null);        
        serializer.startPrefixMapping("rdf", "foo");
        serializer.startElement("http://www.w3.org/1999/02/22-rdf-syntax-ns#", "e", null, attrs);
        serializer.startPrefixMapping("p0", "bar");        
        serializer.startElement("http://www.w3.org/1999/02/22-rdf-syntax-ns#", "f", null, attrs);
        serializer.characters("a\uD834\uDD21a\uD834a\uDD21a".toCharArray(), 0, 8);
        serializer.endElement("http://www.w3.org/1999/02/22-rdf-syntax-ns#", "f", null);        
        serializer.endElement("http://www.w3.org/1999/02/22-rdf-syntax-ns#", "e", null);        
        
        serializer.endPrefixMapping("rdf");
        serializer.endElement("1", "a", null);
        serializer.endDocument();
    }

}
