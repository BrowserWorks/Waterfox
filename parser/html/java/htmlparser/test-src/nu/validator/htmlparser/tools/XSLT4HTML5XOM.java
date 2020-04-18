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

import nu.validator.htmlparser.common.XmlViolationPolicy;
import nu.validator.htmlparser.sax.HtmlSerializer;
import nu.validator.htmlparser.xom.HtmlBuilder;
import nu.xom.Builder;
import nu.xom.Document;
import nu.xom.Element;
import nu.xom.Nodes;
import nu.xom.ParsingException;
import nu.xom.Serializer;
import nu.xom.ValidityException;
import nu.xom.converters.SAXConverter;
import nu.xom.xslt.XSLException;
import nu.xom.xslt.XSLTransform;

import org.xml.sax.SAXException;

public class XSLT4HTML5XOM {

    private static final String TEMPLATE = "--template=";

    private static final String INPUT_HTML = "--input-html=";

    private static final String INPUT_XML = "--input-xml=";

    private static final String OUTPUT_HTML = "--output-html=";

    private static final String OUTPUT_XML = "--output-xml=";

    /**
     * @param args
     * @throws IOException 
     * @throws ParsingException 
     * @throws ValidityException 
     * @throws XSLException 
     * @throws SAXException 
     */
    public static void main(String[] args) throws ValidityException,
            ParsingException, IOException, XSLException, SAXException {
        if (args.length == 0) {
            System.out.println("--template=file --input-[html|xml]=file --output-[html|xml]=file --mode=[sax-streaming|sax-buffered|dom]");
            System.exit(0);
        }
        String template = null;
        String input = null;
        boolean inputHtml = false;
        String output = null;
        boolean outputHtml = false;
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

        Builder builder = new Builder();

        Document transformationDoc = builder.build(new File(template));

        XSLTransform transform = new XSLTransform(transformationDoc);

        FileOutputStream outputStream = new FileOutputStream(output);

        Document inputDoc;
        if (inputHtml) {
            builder = new HtmlBuilder(XmlViolationPolicy.ALTER_INFOSET);
        }
        inputDoc = builder.build(new File(input));
        Nodes result = transform.transform(inputDoc);
        Document outputDoc = new Document((Element) result.get(0));
        if (outputHtml) {
            HtmlSerializer htmlSerializer = new HtmlSerializer(outputStream);
            SAXConverter converter = new SAXConverter(htmlSerializer);
            converter.setLexicalHandler(htmlSerializer);
            converter.convert(outputDoc);
        } else {
            Serializer serializer = new Serializer(outputStream);
            serializer.write(outputDoc);
        }
        outputStream.flush();
        outputStream.close();
    }

}
