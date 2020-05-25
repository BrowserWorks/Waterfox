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

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.StringWriter;
import java.util.LinkedList;

import nu.validator.htmlparser.common.XmlViolationPolicy;
import nu.validator.htmlparser.sax.HtmlParser;

import org.xml.sax.InputSource;
import org.xml.sax.SAXParseException;

public class TreeTester {

    private final BufferedInputStream aggregateStream;

    private boolean streaming = false;

    /**
     * @param aggregateStream
     */
    public TreeTester(InputStream aggregateStream) {
        this.aggregateStream = new BufferedInputStream(aggregateStream);
    }

    private void runTests() throws Throwable {
        if (aggregateStream.read() != '#') {
            System.err.println("No hash at start!");
            return;
        }
        while (runTest()) {
            // spin
        }
    }

    private boolean runTest() throws Throwable {
        UntilHashInputStream stream = null;
        try {
            String context = null;
            boolean scriptingEnabled = true;
            boolean hadScriptingDirective = false;
            aggregateStream.mark(12288);
            if (skipLabel()) { // #data
                return false;
            }
            stream = new UntilHashInputStream(aggregateStream);
            while (stream.read() != -1) {
                // spin
            }
            if (skipLabel()) { // #errors
                System.err.println("Premature end of test data.");
                return false;
            }
            stream = new UntilHashInputStream(aggregateStream);
            while (stream.read() != -1) {
                // spin
            }

            StringBuilder sb = new StringBuilder();
            int c;
            while ((c = aggregateStream.read()) != '\n') {
                sb.append((char) c);
            }
            String label = sb.toString();
            if ("document-fragment".equals(label)) {
                sb.setLength(0);
                while ((c = aggregateStream.read()) != '\n') {
                    sb.append((char) c);
                }
                context = sb.toString();
                // Now potentially gather #script-on/off
                sb.setLength(0);
                while ((c = aggregateStream.read()) != '\n') {
                    sb.append((char) c);
                }
                label = sb.toString();
            }
            if ("script-on".equals(label)) {
                hadScriptingDirective = true;
            } else if ("script-off".equals(label)) {
                hadScriptingDirective = true;
                scriptingEnabled = false;
            }
            aggregateStream.reset();
            if (skipLabel()) { // #data
                System.err.println("Premature end of test data.");
                return false;
            }
            stream = new UntilHashInputStream(aggregateStream);
            InputSource is = new InputSource(stream);
            is.setEncoding("UTF-8");
            StringWriter sw = new StringWriter();
            ListErrorHandler leh = new ListErrorHandler();
            TreeDumpContentHandler treeDumpContentHandler = new TreeDumpContentHandler(
                    sw);
            HtmlParser htmlParser = new HtmlParser(XmlViolationPolicy.ALLOW);
            if (streaming) {
                htmlParser.setStreamabilityViolationPolicy(XmlViolationPolicy.FATAL);
            }
            htmlParser.setContentHandler(treeDumpContentHandler);
            htmlParser.setLexicalHandler(treeDumpContentHandler);
            htmlParser.setErrorHandler(leh);
            htmlParser.setScriptingEnabled(scriptingEnabled);
            try {
                if (context == null) {
                    htmlParser.parse(is);
                } else {
                    String ns = "http://www.w3.org/1999/xhtml";
                    if (context.startsWith("svg ")) {
                        ns = "http://www.w3.org/2000/svg";
                        context = context.substring(4);
                    } else if (context.startsWith("math ")) {
                        ns = "http://www.w3.org/1998/Math/MathML";
                        context = context.substring(5);
                    }
                    htmlParser.parseFragment(is, context, ns);
                    treeDumpContentHandler.endDocument();
                }
            } catch (SAXParseException e) {
                // ignore
            }
            stream.close();

            if (skipLabel()) { // #errors
                System.err.println("Premature end of test data.");
                return false;
            }
            LinkedList<String> expectedErrors = new LinkedList<String>();
            BufferedReader br = new BufferedReader(new InputStreamReader(
                    new UntilHashInputStream(aggregateStream), "UTF-8"));
            String line = null;
            while ((line = br.readLine()) != null) {
                expectedErrors.add(line);
            }

            if (context != null) {
                if (skipLabel()) { // #document-fragment
                    System.err.println("Premature end of test data.");
                    return false;
                }
                UntilHashInputStream stream2 = new UntilHashInputStream(aggregateStream);
                while (stream2.read() != -1) {
                    // spin
                }
            }
            if (hadScriptingDirective && skipLabel()) { // #script-on/off
                System.err.println("Premature end of test data.");
                return false;                
            }

            if (skipLabel()) { // #document
                System.err.println("Premature end of test data.");
                return false;
            }

            StringBuilder expectedBuilder = new StringBuilder();
            br = new BufferedReader(new InputStreamReader(
                    new UntilHashInputStream(aggregateStream), "UTF-8"));
            int ch;
            while ((ch = br.read()) != -1) {
                expectedBuilder.append((char)ch);
            }
            String expected = expectedBuilder.toString();
            String actual = sw.toString();

            LinkedList<String> actualErrors = leh.getErrors();

            if (expected.equals(actual) || (streaming && leh.isFatal()) /*
             * && expectedErrors.size() ==
             * actualErrors.size()
             */) {
                System.err.println("Success.");
                // System.err.println(stream);
            } else {
                System.err.print("Failure.\nData:\n" + stream + "\nExpected:\n"
                        + expected + "Got: \n" + actual);
                System.err.println("Expected errors:");
                for (String err : expectedErrors) {
                    System.err.println(err);
                }
                System.err.println("Actual errors:");
                for (String err : actualErrors) {
                    System.err.println(err);
                }
            }
        } catch (Throwable t) {
            System.err.println("Failure.\nData:\n" + stream);
            throw t;
        }
        return true;
    }

    private boolean skipLabel() throws IOException {
        int b = aggregateStream.read();
        if (b == -1) {
            return true;
        }
        for (;;) {
            b = aggregateStream.read();
            if (b == -1) {
                return true;
            } else if (b == 0x0A) {
                return false;
            }
        }
    }

    /**
     * @param args
     * @throws Throwable
     */
    public static void main(String[] args) throws Throwable {
        for (int i = 0; i < args.length; i++) {
            TreeTester tester = new TreeTester(new FileInputStream(args[i]));
            tester.runTests();
        }
    }

}
