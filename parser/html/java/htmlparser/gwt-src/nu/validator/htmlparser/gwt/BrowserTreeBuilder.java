/*
 * Copyright (c) 2007 Henri Sivonen
 * Copyright (c) 2008-2009 Mozilla Foundation
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

package nu.validator.htmlparser.gwt;

import java.util.LinkedList;

import nu.validator.htmlparser.common.DocumentMode;
import nu.validator.htmlparser.impl.CoalescingTreeBuilder;
import nu.validator.htmlparser.impl.HtmlAttributes;

import org.xml.sax.SAXException;

import com.google.gwt.core.client.JavaScriptException;
import com.google.gwt.core.client.JavaScriptObject;

class BrowserTreeBuilder extends CoalescingTreeBuilder<JavaScriptObject> {

    private JavaScriptObject document;

    private JavaScriptObject script;

    private JavaScriptObject placeholder;

    private boolean readyToRun;

    private final LinkedList<ScriptHolder> scriptStack = new LinkedList<ScriptHolder>();

    private class ScriptHolder {
        private final JavaScriptObject script;

        private final JavaScriptObject placeholder;

        /**
         * @param script
         * @param placeholder
         */
        public ScriptHolder(JavaScriptObject script,
                JavaScriptObject placeholder) {
            this.script = script;
            this.placeholder = placeholder;
        }

        /**
         * Returns the script.
         * 
         * @return the script
         */
        public JavaScriptObject getScript() {
            return script;
        }

        /**
         * Returns the placeholder.
         * 
         * @return the placeholder
         */
        public JavaScriptObject getPlaceholder() {
            return placeholder;
        }
    }

    protected BrowserTreeBuilder(JavaScriptObject document) {
        super();
        this.document = document;
        installExplorerCreateElementNS(document);
    }

    private static native boolean installExplorerCreateElementNS(
            JavaScriptObject doc) /*-{
                  if (!doc.createElementNS) {
                      doc.createElementNS = function (uri, local) {
                          if ("http://www.w3.org/1999/xhtml" == uri) {
                              return doc.createElement(local);
                          } else if ("http://www.w3.org/1998/Math/MathML" == uri) {
                              if (!doc.mathplayerinitialized) {
                                  var obj = document.createElement("object");
                                  obj.setAttribute("id", "mathplayer");
                                  obj.setAttribute("classid", "clsid:32F66A20-7614-11D4-BD11-00104BD3F987");
                                  document.getElementsByTagName("head")[0].appendChild(obj);
                                  document.namespaces.add("m", "http://www.w3.org/1998/Math/MathML", "#mathplayer");  
                                  doc.mathplayerinitialized = true;
                              }
                              return doc.createElement("m:" + local);
                          } else if ("http://www.w3.org/2000/svg" == uri) {
                              if (!doc.renesisinitialized) {
                                  var obj = document.createElement("object");
                                  obj.setAttribute("id", "renesis");
                                  obj.setAttribute("classid", "clsid:AC159093-1683-4BA2-9DCF-0C350141D7F2");
                                  document.getElementsByTagName("head")[0].appendChild(obj);
                                  document.namespaces.add("s", "http://www.w3.org/2000/svg", "#renesis");  
                                  doc.renesisinitialized = true;
                              }
                              return doc.createElement("s:" + local);
                          } else {
                              // throw
                          }
                      }
                  }
              }-*/;

    private static native boolean hasAttributeNS(JavaScriptObject element,
            String uri, String localName) /*-{
                        return element.hasAttributeNS(uri, localName); 
                    }-*/;

    private static native void setAttributeNS(JavaScriptObject element,
            String uri, String localName, String value) /*-{
                        element.setAttributeNS(uri, localName, value); 
                    }-*/;

    @Override protected void addAttributesToElement(JavaScriptObject element,
            HtmlAttributes attributes) throws SAXException {
        try {
            for (int i = 0; i < attributes.getLength(); i++) {
                String localName = attributes.getLocalNameNoBoundsCheck(i);
                String uri = attributes.getURINoBoundsCheck(i);
                if (!hasAttributeNS(element, uri, localName)) {
                    setAttributeNS(element, uri, localName,
                            attributes.getValueNoBoundsCheck(i));
                }
            }
        } catch (JavaScriptException e) {
            fatal(e);
        }
    }

    private static native void appendChild(JavaScriptObject parent,
            JavaScriptObject child) /*-{
                        parent.appendChild(child); 
                    }-*/;

    private static native JavaScriptObject createTextNode(JavaScriptObject doc,
            String text) /*-{
                        return doc.createTextNode(text); 
                    }-*/;

    private static native JavaScriptObject getLastChild(JavaScriptObject node) /*-{
                        return node.lastChild; 
                    }-*/;

    private static native void extendTextNode(JavaScriptObject node, String text) /*-{
                        node.data += text;
                    }-*/;
    
    @Override protected void appendCharacters(JavaScriptObject parent,
            String text) throws SAXException {
        try {
            if (parent == placeholder) {
                appendChild(script, createTextNode(document, text));

            }
            JavaScriptObject lastChild = getLastChild(parent);
            if (lastChild != null && getNodeType(lastChild) == 3) {
                extendTextNode(lastChild, text);
                return;
            }
            appendChild(parent, createTextNode(document, text));
        } catch (JavaScriptException e) {
            fatal(e);
        }
    }

    private static native boolean hasChildNodes(JavaScriptObject element) /*-{
                        return element.hasChildNodes(); 
                    }-*/;

    private static native JavaScriptObject getFirstChild(
            JavaScriptObject element) /*-{
                        return element.firstChild; 
                    }-*/;

    @Override protected void appendChildrenToNewParent(
            JavaScriptObject oldParent, JavaScriptObject newParent)
            throws SAXException {
        try {
            while (hasChildNodes(oldParent)) {
                appendChild(newParent, getFirstChild(oldParent));
            }
        } catch (JavaScriptException e) {
            fatal(e);
        }
    }

    private static native JavaScriptObject createComment(JavaScriptObject doc,
            String text) /*-{
                        return doc.createComment(text); 
                    }-*/;

    @Override protected void appendComment(JavaScriptObject parent,
            String comment) throws SAXException {
        try {
            if (parent == placeholder) {
                appendChild(script, createComment(document, comment));
            }
            appendChild(parent, createComment(document, comment));
        } catch (JavaScriptException e) {
            fatal(e);
        }
    }

    @Override protected void appendCommentToDocument(String comment)
            throws SAXException {
        try {
            appendChild(document, createComment(document, comment));
        } catch (JavaScriptException e) {
            fatal(e);
        }
    }

    private static native JavaScriptObject createElementNS(
            JavaScriptObject doc, String ns, String local) /*-{
                        return doc.createElementNS(ns, local); 
                    }-*/;

    @Override protected JavaScriptObject createElement(String ns, String name,
            HtmlAttributes attributes) throws SAXException {
        try {
            JavaScriptObject rv = createElementNS(document, ns, name);
            for (int i = 0; i < attributes.getLength(); i++) {
                setAttributeNS(rv, attributes.getURINoBoundsCheck(i),
                        attributes.getLocalNameNoBoundsCheck(i),
                        attributes.getValueNoBoundsCheck(i));
            }

            if ("script" == name) {
                if (placeholder != null) {
                    scriptStack.addLast(new ScriptHolder(script, placeholder));
                }
                script = rv;
                placeholder = createElementNS(document,
                        "http://n.validator.nu/placeholder/", "script");
                rv = placeholder;
                for (int i = 0; i < attributes.getLength(); i++) {
                    setAttributeNS(rv, attributes.getURINoBoundsCheck(i),
                            attributes.getLocalNameNoBoundsCheck(i),
                            attributes.getValueNoBoundsCheck(i));
                }
            }

            return rv;
        } catch (JavaScriptException e) {
            fatal(e);
            throw new RuntimeException("Unreachable");
        }
    }

    @Override protected JavaScriptObject createHtmlElementSetAsRoot(
            HtmlAttributes attributes) throws SAXException {
        try {
            JavaScriptObject rv = createElementNS(document,
                    "http://www.w3.org/1999/xhtml", "html");
            for (int i = 0; i < attributes.getLength(); i++) {
                setAttributeNS(rv, attributes.getURINoBoundsCheck(i),
                        attributes.getLocalNameNoBoundsCheck(i),
                        attributes.getValueNoBoundsCheck(i));
            }
            appendChild(document, rv);
            return rv;
        } catch (JavaScriptException e) {
            fatal(e);
            throw new RuntimeException("Unreachable");
        }
    }

    private static native JavaScriptObject getParentNode(
            JavaScriptObject element) /*-{
                        return element.parentNode; 
                    }-*/;

    @Override protected void appendElement(JavaScriptObject child,
            JavaScriptObject newParent) throws SAXException {
        try {
            if (newParent == placeholder) {
                appendChild(script, cloneNodeDeep(child));
            }
            appendChild(newParent, child);
        } catch (JavaScriptException e) {
            fatal(e);
        }
    }

    @Override protected boolean hasChildren(JavaScriptObject element)
            throws SAXException {
        try {
            return hasChildNodes(element);
        } catch (JavaScriptException e) {
            fatal(e);
            throw new RuntimeException("Unreachable");
        }
    }

    private static native void insertBeforeNative(JavaScriptObject parent,
            JavaScriptObject child, JavaScriptObject sibling) /*-{
                        parent.insertBefore(child, sibling);
                    }-*/;

    private static native int getNodeType(JavaScriptObject node) /*-{
                        return node.nodeType;
                    }-*/;

    private static native JavaScriptObject cloneNodeDeep(JavaScriptObject node) /*-{
              return node.cloneNode(true);
           }-*/;

    /**
     * Returns the document.
     * 
     * @return the document
     */
    JavaScriptObject getDocument() {
        JavaScriptObject rv = document;
        document = null;
        return rv;
    }

    private static native JavaScriptObject createDocumentFragment(
            JavaScriptObject doc) /*-{
                        return doc.createDocumentFragment(); 
                    }-*/;

    JavaScriptObject getDocumentFragment() {
        JavaScriptObject rv = createDocumentFragment(document);
        JavaScriptObject rootElt = getFirstChild(document);
        while (hasChildNodes(rootElt)) {
            appendChild(rv, getFirstChild(rootElt));
        }
        document = null;
        return rv;
    }

    /**
     * @see nu.validator.htmlparser.impl.TreeBuilder#createJavaScriptObject(String,
     *      java.lang.String, org.xml.sax.Attributes, java.lang.Object)
     */
    @Override protected JavaScriptObject createElement(String ns, String name,
            HtmlAttributes attributes, JavaScriptObject form)
            throws SAXException {
        try {
            JavaScriptObject rv = createElement(ns, name, attributes);
            // rv.setUserData("nu.validator.form-pointer", form, null);
            return rv;
        } catch (JavaScriptException e) {
            fatal(e);
            return null;
        }
    }

    /**
     * @see nu.validator.htmlparser.impl.TreeBuilder#start()
     */
    @Override protected void start(boolean fragment) throws SAXException {
        script = null;
        placeholder = null;
        readyToRun = false;
    }

    protected void documentMode(DocumentMode mode, String publicIdentifier,
            String systemIdentifier, boolean html4SpecificAdditionalErrorChecks)
            throws SAXException {
        // document.setUserData("nu.validator.document-mode", mode, null);
    }

    /**
     * @see nu.validator.htmlparser.impl.TreeBuilder#elementPopped(java.lang.String,
     *      java.lang.String, java.lang.Object)
     */
    @Override protected void elementPopped(String ns, String name,
            JavaScriptObject node) throws SAXException {
        if (node == placeholder) {
            readyToRun = true;
            requestSuspension();
        }
    }

    private static native void replace(JavaScriptObject oldNode,
            JavaScriptObject newNode) /*-{
                        oldNode.parentNode.replaceChild(newNode, oldNode);
                    }-*/;

    private static native JavaScriptObject getPreviousSibling(JavaScriptObject node) /*-{
                        return node.previousSibling;
                    }-*/;

    void maybeRunScript() {
        if (readyToRun) {
            readyToRun = false;
            replace(placeholder, script);
            if (scriptStack.isEmpty()) {
                script = null;
                placeholder = null;
            } else {
                ScriptHolder scriptHolder = scriptStack.removeLast();
                script = scriptHolder.getScript();
                placeholder = scriptHolder.getPlaceholder();
            }
        }
    }

    @Override protected void insertFosterParentedCharacters(String text,
            JavaScriptObject table, JavaScriptObject stackParent)
            throws SAXException {
        try {
            JavaScriptObject parent = getParentNode(table);
            if (parent != null) { // always an element if not null
                JavaScriptObject previousSibling = getPreviousSibling(table);
                if (previousSibling != null
                        && getNodeType(previousSibling) == 3) {
                    extendTextNode(previousSibling, text);
                    return;
                }
                insertBeforeNative(parent, createTextNode(document, text), table);
                return;
            }
            JavaScriptObject lastChild = getLastChild(stackParent);
            if (lastChild != null && getNodeType(lastChild) == 3) {
                extendTextNode(lastChild, text);
                return;
            }
            appendChild(stackParent, createTextNode(document, text));
        } catch (JavaScriptException e) {
            fatal(e);
        }
    }

    @Override protected void insertFosterParentedChild(JavaScriptObject child,
            JavaScriptObject table, JavaScriptObject stackParent)
            throws SAXException {
        JavaScriptObject parent = getParentNode(table);
        try {
            if (parent != null && getNodeType(parent) == 1) {
                insertBeforeNative(parent, child, table);
            } else {
                appendChild(stackParent, child);
            }
        } catch (JavaScriptException e) {
            fatal(e);
        }
    }

    private static native void removeChild(JavaScriptObject parent,
            JavaScriptObject child) /*-{
                        parent.removeChild(child);
                    }-*/;

    @Override protected void detachFromParent(JavaScriptObject element)
            throws SAXException {
        try {
            JavaScriptObject parent = getParentNode(element);
            if (parent != null) {
                removeChild(parent, element);
            }
        } catch (JavaScriptException e) {
            fatal(e);
        }
    }
}
