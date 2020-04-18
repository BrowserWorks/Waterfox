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

package nu.validator.htmlparser.dom;

import org.w3c.dom.DocumentType;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.xml.sax.Attributes;
import org.xml.sax.ContentHandler;
import org.xml.sax.SAXException;
import org.xml.sax.ext.LexicalHandler;

public class Dom2Sax {

    private static String emptyIfNull(String namespaceURI) {
        return namespaceURI == null ? "" : namespaceURI;
    }
    
    private final NamedNodeMapAttributes attributes = new NamedNodeMapAttributes();

    private final ContentHandler contentHandler;

    private final LexicalHandler lexicalHandler;

    /**
     * @param contentHandler
     * @param lexicalHandler
     */
    public Dom2Sax(ContentHandler contentHandler, LexicalHandler lexicalHandler) {
        if (contentHandler == null) {
            throw new IllegalArgumentException("ContentHandler must not be null.");
        }
        this.contentHandler = contentHandler;
        this.lexicalHandler = lexicalHandler;
    }

    public void parse(Node node) throws SAXException {
        Node current = node;
        Node next;
        char[] buf;
        for (;;) {
            switch (current.getNodeType()) {
                case Node.ELEMENT_NODE:
                    attributes.setNamedNodeMap(current.getAttributes());
                    // To work around severe bogosity in the default DOM
                    // impl, use the node name if local name is null.
                    String localName = current.getLocalName();
                    contentHandler.startElement(
                            emptyIfNull(current.getNamespaceURI()),
                            localName == null ? current.getNodeName()
                                    : localName, null, attributes);
                    attributes.clear();
                    break;
                case Node.TEXT_NODE:
                    buf = current.getNodeValue().toCharArray();
                    contentHandler.characters(buf, 0, buf.length);
                    break;
                case Node.CDATA_SECTION_NODE:
                    if (lexicalHandler != null) {
                        lexicalHandler.startCDATA();
                    }
                    buf = current.getNodeValue().toCharArray();
                    contentHandler.characters(buf, 0, buf.length);
                    if (lexicalHandler != null) {
                        lexicalHandler.endCDATA();
                    }
                    break;
                case Node.COMMENT_NODE:
                    if (lexicalHandler != null) {
                        buf = current.getNodeValue().toCharArray();
                        lexicalHandler.comment(buf, 0, buf.length);
                    }
                    break;
                case Node.DOCUMENT_NODE:
                    contentHandler.startDocument();
                    break;
                case Node.DOCUMENT_TYPE_NODE:
                    if (lexicalHandler != null) {
                        DocumentType doctype = (DocumentType) current;
                        lexicalHandler.startDTD(doctype.getName(),
                                doctype.getPublicId(), doctype.getSystemId());
                        lexicalHandler.endDTD();
                    }
                    break;
                case Node.PROCESSING_INSTRUCTION_NODE:
                    contentHandler.processingInstruction(current.getNodeName(), current.getNodeValue());
                    break;
                case Node.ENTITY_REFERENCE_NODE:
                    contentHandler.skippedEntity(current.getNodeName());
                    break;
            }
            if ((next = current.getFirstChild()) != null) {
                current = next;
                continue;
            }
            for (;;) {
                switch (current.getNodeType()) {
                    case Node.ELEMENT_NODE:
                        // To work around severe bogosity in the default DOM
                        // impl, use the node name if local name is null.
                        String localName = current.getLocalName();
                        contentHandler.endElement(
                                emptyIfNull(current.getNamespaceURI()),
                                localName == null ? current.getNodeName()
                                        : localName, null);
                        break;
                    case Node.DOCUMENT_NODE:
                        contentHandler.endDocument();
                        break;
                }
                if (current == node) {
                    return;
                }
                if ((next = current.getNextSibling()) != null) {
                    current = next;
                    break;
                }
                current = current.getParentNode();
            }
        }
    }

    private class NamedNodeMapAttributes implements Attributes {

        private NamedNodeMap map;
        
        private int length;
        
        public void setNamedNodeMap(NamedNodeMap attributes) {
            this.map = attributes;
            this.length = attributes.getLength();
        }
        
        public void clear() {
            this.map = null;
        }

        public int getIndex(String qName) {
            for (int i = 0; i < length; i++) {
                Node n = map.item(i);
                if (n.getNodeName().equals(qName)) {
                    return i;
                }
            }
            return -1;
        }

        public int getIndex(String uri, String localName) {
            for (int i = 0; i < length; i++) {
                Node n = map.item(i);
                if (n.getLocalName().equals(localName) && emptyIfNull(n.getNamespaceURI()).equals(uri)) {
                    return i;
                }
            }
            return -1;
        }

        public int getLength() {
            return length;
        }

        public String getLocalName(int index) {
            if (index < length && index >= 0) {
                return map.item(index).getLocalName();
            } else {
                return null;
            }
        }

        public String getQName(int index) {
            if (index < length && index >= 0) {
                return map.item(index).getNodeName();
            } else {
                return null;
            }
        }

        public String getType(int index) {
            if (index < length && index >= 0) {
                return "id".equals(map.item(index).getLocalName()) ? "ID" : "CDATA";
            } else {
                return null;
            }
        }

        public String getType(String qName) {
            int index = getIndex(qName);
            if (index == -1) {
                return null;
            } else {
                return getType(index);
            }
        }

        public String getType(String uri, String localName) {
            int index = getIndex(uri, localName);
            if (index == -1) {
                return null;
            } else {
                return getType(index);
            }
        }

        public String getURI(int index) {
            if (index < length && index >= 0) {
                return emptyIfNull(map.item(index).getNamespaceURI());
            } else {
                return null;
            }
        }

        public String getValue(int index) {
            if (index < length && index >= 0) {
                return map.item(index).getNodeValue();
            } else {
                return null;
            }
        }

        public String getValue(String qName) {
            int index = getIndex(qName);
            if (index == -1) {
                return null;
            } else {
                return getValue(index);
            }
        }

        public String getValue(String uri, String localName) {
            int index = getIndex(uri, localName);
            if (index == -1) {
                return null;
            } else {
                return getValue(index);
            }
        }

    }
}
