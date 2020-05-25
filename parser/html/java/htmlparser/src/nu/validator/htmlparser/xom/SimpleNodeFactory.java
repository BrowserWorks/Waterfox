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

package nu.validator.htmlparser.xom;

import nu.xom.Attribute;
import nu.xom.Comment;
import nu.xom.Document;
import nu.xom.Element;
import nu.xom.Text;
import nu.xom.Attribute.Type;

/**
 * A simpler node factory that does not use <code>Nodes</code>..
 * 
 * @version $Id$
 * @author hsivonen
 */
public class SimpleNodeFactory {

    /**
     * <code>return new Attribute(localName, uri, value, type);</code>
     * @param localName
     * @param uri
     * @param value
     * @param type
     * @return
     */
    public Attribute makeAttribute(String localName, String uri, String value, Type type) {
        return new Attribute(localName, uri, value, type);
    }

    /**
     * <code>return new Text(string);</code>
     * @param string
     * @return
     */
    public Text makeText(String string) {
        return new Text(string);
    }

    /**
     * <code>return new Comment(string);</code>
     * @param string
     * @return
     */
    public Comment makeComment(String string) {
        return new Comment(string);
    }

    /**
     * <code>return new Element(name, namespace);</code>
     * @param name
     * @param namespace
     * @return
     */
    public Element makeElement(String name, String namespace) {
        return new Element(name, namespace);
    }

    /**
     * <code>return new FormPtrElement(name, namespace, form);</code>
     * @param name
     * @param namespace
     * @param form
     * @return
     */
    public Element makeElement(String name, String namespace, Element form) {
        return new FormPtrElement(name, namespace, form);
    }
    
    /**
     * <code>return new ModalDocument(new Element("root", "http://www.xom.nu/fakeRoot"));</code>
     * 
     * <p>Subclasses adviced to return an instance of <code>Mode</code>. (Not required, though.)
     * 
     * @return
     */
    public Document makeDocument() {
        return new ModalDocument(new Element("root", "http://www.xom.nu/fakeRoot"));
    }
    
}
