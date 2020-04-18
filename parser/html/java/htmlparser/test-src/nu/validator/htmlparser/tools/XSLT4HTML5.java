/*
 * Copyright (c) 2007 Henri Sivonen
 * Copyright (c) 2007 Mozilla Foundation
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

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.MalformedURLException;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParserFactory;
import javax.xml.transform.Templates;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.sax.SAXResult;
import javax.xml.transform.sax.SAXTransformerFactory;
import javax.xml.transform.sax.TemplatesHandler;
import javax.xml.transform.sax.TransformerHandler;

import nu.validator.htmlparser.common.XmlViolationPolicy;
import nu.validator.htmlparser.dom.HtmlDocumentBuilder;
import nu.validator.htmlparser.sax.HtmlParser;
import nu.validator.htmlparser.sax.HtmlSerializer;
import nu.validator.htmlparser.sax.XmlSerializer;
import nu.validator.htmlparser.test.SystemErrErrorHandler;

import org.w3c.dom.Document;
import org.xml.sax.ContentHandler;
import org.xml.sax.SAXException;
import org.xml.sax.XMLReader;
import org.xml.sax.ext.LexicalHandler;

public class XSLT4HTML5 {

    private enum Mode {
        STREAMING_SAX, BUFFERED_SAX, DOM,
    }

    private static final String TEMPLATE = "--template=";

    private static final String INPUT_HTML = "--input-html=";

    private static final String INPUT_XML = "--input-xml=";

    private static final String OUTPUT_HTML = "--output-html=";

    private static final String OUTPUT_XML = "--output-xml=";

    private static final String MODE = "--mode=";

    /**
     * @param args
     * @throws ParserConfigurationException 
     * @throws SAXException 
     * @throws IOException 
     * @throws MalformedURLException 
     * @throws TransformerException 
     */
    public static void main(String[] args) throws SAXException,
            ParserConfigurationException, MalformedURLException, IOException, TransformerException {
        if (args.length == 0) {
            System.out.println("--template=file --input-[html|xml]=file --output-[html|xml]=file --mode=[sax-streaming|sax-buffered|dom]");
            System.exit(0);
        }
        String template = null;
        String input = null;
        boolean inputHtml = false;
        String output = null;
        boolean outputHtml = false;
        Mode mode = null;
        for (int i = 0; i < args.length; i++) {
            String arg = args[i];
            if (arg.startsWith(TEMPLATE)) {
                if (template == null) {
                    template = arg.substring(TEMPLATE.length());
                } else {
                    System.err.println("Tried to set template twice.");
                    System.exit(1);
                }
            } else if (arg.startsWith(INPUT_HTML)) {
                if (input == null) {
                    input = arg.substring(INPUT_HTML.length());
                    inputHtml = true;
                } else {
                    System.err.println("Tried to set input twice.");
                    System.exit(2);
                }
            } else if (arg.startsWith(INPUT_XML)) {
                if (input == null) {
                    input = arg.substring(INPUT_XML.length());
                    inputHtml = false;
                } else {
                    System.err.println("Tried to set input twice.");
                    System.exit(2);
                }
            } else if (arg.startsWith(OUTPUT_HTML)) {
                if (output == null) {
                    output = arg.substring(OUTPUT_HTML.length());
                    outputHtml = true;
                } else {
                    System.err.println("Tried to set output twice.");
                    System.exit(3);
                }
            } else if (arg.startsWith(OUTPUT_XML)) {
                if (output == null) {
                    output = arg.substring(OUTPUT_XML.length());
                    outputHtml = false;
                } else {
                    System.err.println("Tried to set output twice.");
                    System.exit(3);
                }
            } else if (arg.startsWith(MODE)) {
                if (mode == null) {
                    String modeStr = arg.substring(MODE.length());
                    if ("dom".equals(modeStr)) {
                        mode = Mode.DOM;
                    } else if ("sax-buffered".equals(modeStr)) {
                        mode = Mode.BUFFERED_SAX;
                    } else if ("sax-streaming".equals(modeStr)) {
                        mode = Mode.STREAMING_SAX;
                    } else {
                        System.err.println("Unrecognized mode.");
                        System.exit(5);
                    }
                } else {
                    System.err.println("Tried to set mode twice.");
                    System.exit(4);
                }
            }
        }

        if (template == null) {
            System.err.println("No template specified.");
            System.exit(6);
        }
        if (input == null) {
            System.err.println("No input specified.");
            System.exit(7);
        }
        if (output == null) {
            System.err.println("No output specified.");
            System.exit(8);
        }
        if (mode == null) {
            mode = Mode.BUFFERED_SAX;
        }
        
        SystemErrErrorHandler errorHandler = new SystemErrErrorHandler();

        SAXParserFactory factory = SAXParserFactory.newInstance();
        factory.setNamespaceAware(true);
        factory.setValidating(false);
        XMLReader reader = factory.newSAXParser().getXMLReader();
        reader.setErrorHandler(errorHandler);

        SAXTransformerFactory transformerFactory = (SAXTransformerFactory) TransformerFactory.newInstance();
        transformerFactory.setErrorListener(errorHandler);
        TemplatesHandler templatesHandler = transformerFactory.newTemplatesHandler();
        reader.setContentHandler(templatesHandler);
        reader.parse(new File(template).toURI().toASCIIString());

        Templates templates = templatesHandler.getTemplates();

        FileOutputStream outputStream = new FileOutputStream(output);
        ContentHandler serializer;
        if (outputHtml) {
            serializer = new HtmlSerializer(outputStream);
        } else {
            serializer = new XmlSerializer(outputStream);
        }
        SAXResult result = new SAXResult(new XmlnsDropper(serializer));
        result.setLexicalHandler((LexicalHandler) serializer);

        if (mode == Mode.DOM) {
            Document inputDoc;
            DocumentBuilder builder;
            if (inputHtml) {
                builder = new HtmlDocumentBuilder(XmlViolationPolicy.ALTER_INFOSET);
            } else {
                DocumentBuilderFactory builderFactory = DocumentBuilderFactory.newInstance();
                factory.setNamespaceAware(true);
                try {
                    builder = builderFactory.newDocumentBuilder();
                } catch (ParserConfigurationException e) {
                    throw new RuntimeException(e);
                }
            }
            inputDoc = builder.parse(new File(input));
            DOMSource inputSource = new DOMSource(inputDoc,
                    new File(input).toURI().toASCIIString());
            Transformer transformer = templates.newTransformer();
            transformer.setErrorListener(errorHandler);
            transformer.transform(inputSource, result);
        } else {
            if (inputHtml) {
                reader = new HtmlParser(XmlViolationPolicy.ALTER_INFOSET);
                if (mode == Mode.STREAMING_SAX) {
                    reader.setProperty("http://validator.nu/properties/streamability-violation-policy", XmlViolationPolicy.FATAL);
                }
            }
            TransformerHandler transformerHandler = transformerFactory.newTransformerHandler(templates);
            transformerHandler.setResult(result);
            reader.setErrorHandler(errorHandler);
            reader.setContentHandler(transformerHandler);
            reader.setProperty("http://xml.org/sax/properties/lexical-handler", transformerHandler);
            reader.parse(new File(input).toURI().toASCIIString());
        }
        outputStream.flush();
        outputStream.close();
    }

}
