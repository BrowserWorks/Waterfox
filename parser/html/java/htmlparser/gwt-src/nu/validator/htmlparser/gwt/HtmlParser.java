/*
 * Copyright (c) 2007 Henri Sivonen
 * Copyright (c) 2007-2008 Mozilla Foundation
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

import nu.validator.htmlparser.common.XmlViolationPolicy;
import nu.validator.htmlparser.impl.ErrorReportingTokenizer;
import nu.validator.htmlparser.impl.Tokenizer;
import nu.validator.htmlparser.impl.UTF16Buffer;

import org.xml.sax.ErrorHandler;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;

import com.google.gwt.core.client.JavaScriptObject;
import com.google.gwt.user.client.Timer;

/**
 * This class implements an HTML5 parser that exposes data through the DOM 
 * interface. 
 * 
 * <p>By default, when using the constructor without arguments, the 
 * this parser treats XML 1.0-incompatible infosets as fatal errors. 
 * This corresponds to 
 * <code>FATAL</code> as the general XML violation policy. To make the parser 
 * support non-conforming HTML fully per the HTML 5 spec while on the other 
 * hand potentially violating the DOM API contract, set the general XML 
 * violation policy to <code>ALLOW</code>. This does not work with a standard 
 * DOM implementation. Handling all input without fatal errors and without 
 * violating the DOM API contract is possible by setting 
 * the general XML violation policy to <code>ALTER_INFOSET</code>. <em>This 
 * makes the parser non-conforming</em> but is probably the most useful 
 * setting for most applications.
 * 
 * <p>The doctype is not represented in the tree.
 * 
 * <p>The document mode is represented as user data <code>DocumentMode</code> 
 * object with the key <code>nu.validator.document-mode</code> on the document 
 * node. 
 * 
 * <p>The form pointer is also stored as user data with the key 
 * <code>nu.validator.form-pointer</code>.
 * 
 * @version $Id: HtmlDocumentBuilder.java 255 2008-05-29 08:57:38Z hsivonen $
 * @author hsivonen
 */
public class HtmlParser {

    private static final int CHUNK_SIZE = 512;
    
    private final Tokenizer tokenizer;

    private final BrowserTreeBuilder domTreeBuilder;

    private final StringBuilder documentWriteBuffer = new StringBuilder();

    private ErrorHandler errorHandler;

    private UTF16Buffer stream;

    private int streamLength;

    private boolean lastWasCR;

    private boolean ending;

    private ParseEndListener parseEndListener;

    private final LinkedList<UTF16Buffer> bufferStack = new LinkedList<UTF16Buffer>();

    /**
     * Instantiates the parser
     * 
     * @param implementation
     *            the DOM implementation
     *            @param xmlPolicy the policy
     */
    public HtmlParser(JavaScriptObject document) {
        this.domTreeBuilder = new BrowserTreeBuilder(document);
        this.tokenizer = new ErrorReportingTokenizer(domTreeBuilder);
        this.domTreeBuilder.setNamePolicy(XmlViolationPolicy.ALTER_INFOSET);
        this.tokenizer.setCommentPolicy(XmlViolationPolicy.ALTER_INFOSET);
        this.tokenizer.setContentNonXmlCharPolicy(XmlViolationPolicy.ALTER_INFOSET);
        this.tokenizer.setContentSpacePolicy(XmlViolationPolicy.ALTER_INFOSET);
        this.tokenizer.setNamePolicy(XmlViolationPolicy.ALTER_INFOSET);
        this.tokenizer.setXmlnsPolicy(XmlViolationPolicy.ALTER_INFOSET);
    }

    /**
     * Parses a document from a SAX <code>InputSource</code>.
     * @param is the source
     * @return the doc
     * @see javax.xml.parsers.DocumentBuilder#parse(org.xml.sax.InputSource)
     */
    public void parse(String source, ParseEndListener callback) throws SAXException {
        parseEndListener = callback;
        domTreeBuilder.setFragmentContext(null);
        tokenize(source, null);   
    }

    /**
     * @param is
     * @throws SAXException
     * @throws IOException
     * @throws MalformedURLException
     */
    private void tokenize(String source, String context) throws SAXException {
        lastWasCR = false;
        ending = false;
        documentWriteBuffer.setLength(0);
        streamLength = source.length();
        stream = new UTF16Buffer(source.toCharArray(), 0,
                (streamLength < CHUNK_SIZE ? streamLength : CHUNK_SIZE));
        bufferStack.clear();
        push(stream);
        domTreeBuilder.setFragmentContext(context == null ? null : context.intern());
        tokenizer.start();
        pump();
    }

    private void pump() throws SAXException {
        if (ending) {
            tokenizer.end();
            domTreeBuilder.getDocument(); // drops the internal reference
            parseEndListener.parseComplete();
            // Don't schedule timeout
            return;
        }

        int docWriteLen = documentWriteBuffer.length();
        if (docWriteLen > 0) {
            char[] newBuf = new char[docWriteLen];
            documentWriteBuffer.getChars(0, docWriteLen, newBuf, 0);
            push(new UTF16Buffer(newBuf, 0, docWriteLen));
            documentWriteBuffer.setLength(0);
        }

        for (;;) {
            UTF16Buffer buffer = peek();
            if (!buffer.hasMore()) {
                if (buffer == stream) {
                    if (buffer.getEnd() == streamLength) {
                        // Stop parsing
                        tokenizer.eof();
                        ending = true;
                        break;
                    } else {
                        int newEnd = buffer.getStart() + CHUNK_SIZE;
                        buffer.setEnd(newEnd < streamLength ? newEnd
                                : streamLength);
                        continue;
                    }
                } else {
                    pop();
                    continue;
                }
            }
            // now we have a non-empty buffer
            buffer.adjust(lastWasCR);
            lastWasCR = false;
            if (buffer.hasMore()) {
                lastWasCR = tokenizer.tokenizeBuffer(buffer);
                domTreeBuilder.maybeRunScript();
                break;
            } else {
                continue;
            }
        }

        // schedule
        Timer timer = new Timer() {

            @Override public void run() {
                try {
                    pump();
                } catch (SAXException e) {
                    ending = true;
                    if (errorHandler != null) {
                        try {
                            errorHandler.fatalError(new SAXParseException(
                                    e.getMessage(), null, null, -1, -1, e));
                        } catch (SAXException e1) {
                        }
                    }
                }
            }

        };
        timer.schedule(1);
    }

    private void push(UTF16Buffer buffer) {
        bufferStack.addLast(buffer);
    }

    private UTF16Buffer peek() {
        return bufferStack.getLast();
    }

    private void pop() {
        bufferStack.removeLast();
    }

    public void documentWrite(String text) throws SAXException {
        UTF16Buffer buffer = new UTF16Buffer(text.toCharArray(), 0, text.length());
        while (buffer.hasMore()) {
            buffer.adjust(lastWasCR);
            lastWasCR = false;
            if (buffer.hasMore()) {
                lastWasCR = tokenizer.tokenizeBuffer(buffer);            
                domTreeBuilder.maybeRunScript();
            }
        }
    }

    /**
     * @see javax.xml.parsers.DocumentBuilder#setErrorHandler(org.xml.sax.ErrorHandler)
     */
    public void setErrorHandler(ErrorHandler errorHandler) {
        this.errorHandler = errorHandler;
        domTreeBuilder.setErrorHandler(errorHandler);
        tokenizer.setErrorHandler(errorHandler);
    }

    /**
     * Sets whether comment nodes appear in the tree.
     * @param ignoreComments <code>true</code> to ignore comments
     * @see nu.validator.htmlparser.impl.TreeBuilder#setIgnoringComments(boolean)
     */
    public void setIgnoringComments(boolean ignoreComments) {
        domTreeBuilder.setIgnoringComments(ignoreComments);
    }

    /**
     * Sets whether the parser considers scripting to be enabled for noscript treatment.
     * @param scriptingEnabled <code>true</code> to enable
     * @see nu.validator.htmlparser.impl.TreeBuilder#setScriptingEnabled(boolean)
     */
    public void setScriptingEnabled(boolean scriptingEnabled) {
        domTreeBuilder.setScriptingEnabled(scriptingEnabled);
    }

}
