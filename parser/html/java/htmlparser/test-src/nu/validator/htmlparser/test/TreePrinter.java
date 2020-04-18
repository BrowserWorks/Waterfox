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

package nu.validator.htmlparser.test;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;

import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import nu.validator.htmlparser.common.XmlViolationPolicy;
import nu.validator.htmlparser.sax.HtmlParser;

public class TreePrinter {

    public static void main(String[] args) throws SAXException, IOException {
        TreeDumpContentHandler treeDumpContentHandler = new TreeDumpContentHandler(new OutputStreamWriter(System.out, "UTF-8"));
        HtmlParser htmlParser = new HtmlParser();
        htmlParser.setContentHandler(treeDumpContentHandler);
        htmlParser.setLexicalHandler(treeDumpContentHandler);
        htmlParser.setErrorHandler(new SystemErrErrorHandler());
        htmlParser.setXmlPolicy(XmlViolationPolicy.ALLOW);
        File file = new File(args[0]);
        InputSource is = new InputSource(new FileInputStream(file));
        is.setSystemId(file.toURI().toASCIIString());
        htmlParser.parse(is);
    }
}
