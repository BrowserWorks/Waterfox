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

package nu.validator.htmlparser.tools;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.MalformedURLException;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParserFactory;
import javax.xml.transform.TransformerException;

import nu.validator.htmlparser.sax.HtmlSerializer;
import nu.validator.htmlparser.sax.XmlSerializer;
import nu.validator.htmlparser.test.SystemErrErrorHandler;

import org.xml.sax.ContentHandler;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.XMLReader;

public class XML2HTML {

    /**
     * @param args
     */
    public static void main(String[] args) throws SAXException,
            ParserConfigurationException, MalformedURLException, IOException,
            TransformerException {
        InputStream in;
        OutputStream out;

        switch (args.length) {
            case 0:
                in = System.in;
                out = System.out;
                break;
            case 1:
                in = new FileInputStream(args[0]);
                out = System.out;
                break;
            case 2:
                in = new FileInputStream(args[0]);
                out = new FileOutputStream(args[1]);
                break;
            default:
                System.err.println("Too many arguments. No arguments to use stdin/stdout. One argument to reading from file and write to stdout. Two arguments to read from first file and write to second.");
                System.exit(1);
                return;
        }

        ContentHandler serializer = new HtmlSerializer(out);
        
        SAXParserFactory factory = SAXParserFactory.newInstance();
        factory.setNamespaceAware(true);
        factory.setValidating(false);
        XMLReader parser = factory.newSAXParser().getXMLReader();
        parser.setErrorHandler(new SystemErrErrorHandler());
        parser.setContentHandler(serializer);
        parser.setProperty("http://xml.org/sax/properties/lexical-handler",
                serializer);
        parser.parse(new InputSource(in));
        out.flush();
        out.close();
    }
}
