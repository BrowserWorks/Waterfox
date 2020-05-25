/*
 * Copyright (c) 2007 Henri Sivonen
 * Copyright (c) 2008-2011 Mozilla Foundation
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

import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.io.Writer;
import java.util.Arrays;

import org.xml.sax.Attributes;
import org.xml.sax.ContentHandler;
import org.xml.sax.Locator;
import org.xml.sax.SAXException;
import org.xml.sax.ext.LexicalHandler;

public class HtmlSerializer implements ContentHandler, LexicalHandler {

    private static final String[] VOID_ELEMENTS = { "area", "base", "basefont",
            "bgsound", "br", "col", "command", "embed", "frame", "hr", "img",
            "input", "keygen", "link", "meta", "param", "source", "track",
            "wbr" };

    private static final String[] NON_ESCAPING = { "iframe", "noembed",
            "noframes", "noscript", "plaintext", "script", "style", "xmp" };

    private static Writer wrap(OutputStream out) {
        try {
            return new OutputStreamWriter(out, "UTF-8");
        } catch (UnsupportedEncodingException e) {
            throw new RuntimeException(e);
        }
    }

    private int ignoreLevel = 0;

    private int escapeLevel = 0;

    private final Writer writer;

    public HtmlSerializer(OutputStream out) {
        this(wrap(out));
    }

    public HtmlSerializer(Writer out) {
        this.writer = out;
    }

    public void characters(char[] ch, int start, int length)
            throws SAXException {
        try {
            if (escapeLevel > 0) {
                writer.write(ch, start, length);
            } else {
                for (int i = start; i < start + length; i++) {
                    char c = ch[i];
                    switch (c) {
                        case '<':
                            writer.write("&lt;");
                            break;
                        case '>':
                            writer.write("&gt;");
                            break;
                        case '&':
                            writer.write("&amp;");
                            break;
                        case '\u00A0':
                            writer.write("&nbsp;");
                            break;
                        default:
                            writer.write(c);
                            break;
                    }
                }
            }
        } catch (IOException e) {
            throw new SAXException(e);
        }
    }

    public void endDocument() throws SAXException {
        try {
            writer.flush();
            writer.close();
        } catch (IOException e) {
            throw new SAXException(e);
        }
    }

    public void endElement(String uri, String localName, String qName)
            throws SAXException {
        if (escapeLevel > 0) {
            escapeLevel--;
        }
        if (ignoreLevel > 0) {
            ignoreLevel--;
        } else {
            try {
                writer.write('<');
                writer.write('/');
                writer.write(localName);
                writer.write('>');
            } catch (IOException e) {
                throw new SAXException(e);
            }
        }
    }

    public void ignorableWhitespace(char[] ch, int start, int length)
            throws SAXException {
        characters(ch, start, length);
    }

    public void processingInstruction(String target, String data)
            throws SAXException {
    }

    public void setDocumentLocator(Locator locator) {
    }

    public void startDocument() throws SAXException {
        try {
            writer.write("<!DOCTYPE html>\n");
        } catch (IOException e) {
            throw new SAXException(e);
        }
    }

    public void startElement(String uri, String localName, String qName,
            Attributes atts) throws SAXException {
        if (escapeLevel > 0) {
            escapeLevel++;
        }
        boolean xhtml = "http://www.w3.org/1999/xhtml".equals(uri);
        if (ignoreLevel > 0
                || !(xhtml || "http://www.w3.org/2000/svg".equals(uri) || "http://www.w3.org/1998/Math/MathML".equals(uri))) {
            ignoreLevel++;
            return;
        }
        try {
            writer.write('<');
            writer.write(localName);
            for (int i = 0; i < atts.getLength(); i++) {
                String attUri = atts.getURI(i);
                String attLocal = atts.getLocalName(i);
                if (attUri.length() == 0) {
                    writer.write(' ');
                } else if (!xhtml
                        && "http://www.w3.org/1999/xlink".equals(attUri)) {
                    writer.write(" xlink:");
                } else if ("http://www.w3.org/XML/1998/namespace".equals(attUri)) {
                    if (xhtml) {
                        if ("lang".equals(attLocal)) {
                            writer.write(' ');
                        } else {
                            continue;
                        }
                    } else {
                        writer.write(" xml:");
                    }
                } else {
                    continue;
                }
                writer.write(atts.getLocalName(i));
                writer.write('=');
                writer.write('"');
                String val = atts.getValue(i);
                for (int j = 0; j < val.length(); j++) {
                    char c = val.charAt(j);
                    switch (c) {
                        case '"':
                            writer.write("&quot;");
                            break;
                        case '&':
                            writer.write("&amp;");
                            break;
                        case '\u00A0':
                            writer.write("&nbsp;");
                            break;
                        default:
                            writer.write(c);
                            break;
                    }
                }
                writer.write('"');
            }
            writer.write('>');
            if (Arrays.binarySearch(VOID_ELEMENTS, localName) > -1) {
                ignoreLevel++;
                return;
            }
            if ("pre".equals(localName) || "textarea".equals(localName)
                    || "listing".equals(localName)) {
                writer.write('\n');
            }
            if (escapeLevel == 0
                    && Arrays.binarySearch(NON_ESCAPING, localName) > -1) {
                escapeLevel = 1;
            }
        } catch (IOException e) {
            throw new SAXException(e);
        }
    }

    public void comment(char[] ch, int start, int length) throws SAXException {
        if (ignoreLevel > 0 || escapeLevel > 0) {
            return;
        }
        try {
            writer.write("<!--");
            writer.write(ch, start, length);
            writer.write("-->");
        } catch (IOException e) {
            throw new SAXException(e);
        }
    }

    public void endCDATA() throws SAXException {
    }

    public void endDTD() throws SAXException {
    }

    public void endEntity(String name) throws SAXException {
    }

    public void startCDATA() throws SAXException {
    }

    public void startDTD(String name, String publicId, String systemId)
            throws SAXException {
    }

    public void startEntity(String name) throws SAXException {
    }

    public void startPrefixMapping(String prefix, String uri)
            throws SAXException {
    }

    public void endPrefixMapping(String prefix) throws SAXException {
    }

    public void skippedEntity(String name) throws SAXException {
    }

}
