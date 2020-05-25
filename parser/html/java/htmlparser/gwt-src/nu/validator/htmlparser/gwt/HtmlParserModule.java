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

package nu.validator.htmlparser.gwt;

import org.xml.sax.SAXException;

import com.google.gwt.core.client.EntryPoint;
import com.google.gwt.core.client.JavaScriptObject;

public class HtmlParserModule implements EntryPoint {

    private static native void zapChildren(JavaScriptObject node) /*-{
        while (node.hasChildNodes()) {
            node.removeChild(node.lastChild);
        }
    }-*/;
    
    private static native void installDocWrite(JavaScriptObject doc, HtmlParser parser) /*-{
        doc.write = function() {
            if (arguments.length == 0) {
                return;
            }
            var text = arguments[0];
            for (var i = 1; i < arguments.length; i++) {
                text += arguments[i];
            }
            parser.@nu.validator.htmlparser.gwt.HtmlParser::documentWrite(Ljava/lang/String;)(text);
        }
        doc.writeln = function() {
            if (arguments.length == 0) {
                parser.@nu.validator.htmlparser.gwt.HtmlParser::documentWrite(Ljava/lang/String;)("\n");
                return;
            }
            var text = arguments[0];
            for (var i = 1; i < arguments.length; i++) {
                text += arguments[i];
            }
            text += "\n";
            parser.@nu.validator.htmlparser.gwt.HtmlParser::documentWrite(Ljava/lang/String;)(text);
        }
    }-*/;
    
    @SuppressWarnings("unused")
    private static void parseHtmlDocument(String source, JavaScriptObject document, JavaScriptObject readyCallback, JavaScriptObject errorHandler) throws SAXException {
        if (readyCallback == null) {
            readyCallback = JavaScriptObject.createFunction();
        }
        zapChildren(document);
        HtmlParser parser = new HtmlParser(document);
        parser.setScriptingEnabled(true);
        // XXX error handler
        
        installDocWrite(document, parser);
        
        parser.parse(source, new ParseEndListener(readyCallback));
    }
    
    private static native void exportEntryPoints() /*-{
        $wnd.parseHtmlDocument = @nu.validator.htmlparser.gwt.HtmlParserModule::parseHtmlDocument(Ljava/lang/String;Lcom/google/gwt/core/client/JavaScriptObject;Lcom/google/gwt/core/client/JavaScriptObject;Lcom/google/gwt/core/client/JavaScriptObject;);
    }-*/;

    
    public void onModuleLoad() {
        exportEntryPoints();        
    }

}
