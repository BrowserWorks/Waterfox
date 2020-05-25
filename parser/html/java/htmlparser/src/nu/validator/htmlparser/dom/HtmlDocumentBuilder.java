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

package nu.validator.htmlparser.dom;

import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.LinkedList;
import java.util.List;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import nu.validator.htmlparser.common.CharacterHandler;
import nu.validator.htmlparser.common.DoctypeExpectation;
import nu.validator.htmlparser.common.DocumentModeHandler;
import nu.validator.htmlparser.common.Heuristics;
import nu.validator.htmlparser.common.TokenHandler;
import nu.validator.htmlparser.common.TransitionHandler;
import nu.validator.htmlparser.common.XmlViolationPolicy;
import nu.validator.htmlparser.impl.ErrorReportingTokenizer;
import nu.validator.htmlparser.impl.Tokenizer;
import nu.validator.htmlparser.io.Driver;

import org.w3c.dom.DOMImplementation;
import org.w3c.dom.Document;
import org.w3c.dom.DocumentFragment;
import org.xml.sax.EntityResolver;
import org.xml.sax.ErrorHandler;
import org.xml.sax.InputSource;
import org.xml.sax.Locator;
import org.xml.sax.SAXException;

/**
 * This class implements an HTML5 parser that exposes data through the DOM 
 * interface. 
 * 
 * <p>By default, when using the constructor without arguments, the 
 * this parser coerces XML 1.0-incompatible infosets into XML 1.0-compatible
 * infosets. This corresponds to <code>ALTER_INFOSET</code> as the general 
 * XML violation policy. To make the parser support non-conforming HTML fully 
 * per the HTML 5 spec while on the other hand potentially violating the SAX2 
 * API contract, set the general XML violation policy to <code>ALLOW</code>. 
 * This does not work with a standard DOM implementation.
 * It is possible to treat XML 1.0 infoset violations as fatal by setting 
 * the general XML violation policy to <code>FATAL</code>. 
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
 * @version $Id$
 * @author hsivonen
 */
public class HtmlDocumentBuilder extends DocumentBuilder {

    /**
     * Returns the JAXP DOM implementation.
     * 
     * @return the JAXP DOM implementation
     */
    private static DOMImplementation jaxpDOMImplementation() {
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        factory.setNamespaceAware(true);
        DocumentBuilder builder;
        try {
            builder = factory.newDocumentBuilder();
        } catch (ParserConfigurationException e) {
            throw new RuntimeException(e);
        }
        return builder.getDOMImplementation();
    }

    /**
     * The tokenizer.
     */
    private Driver driver;

    /**
     * The tree builder.
     */
    private final DOMTreeBuilder treeBuilder;

    /**
     * The DOM impl.
     */
    private final DOMImplementation implementation;

    /**
     * The entity resolver.
     */
    private EntityResolver entityResolver;

    private ErrorHandler errorHandler = null;
    
    private DocumentModeHandler documentModeHandler = null;

    private DoctypeExpectation doctypeExpectation = DoctypeExpectation.HTML;

    private boolean checkingNormalization = false;

    private boolean scriptingEnabled = false;

    private final List<CharacterHandler> characterHandlers = new LinkedList<CharacterHandler>();
    
    private XmlViolationPolicy contentSpacePolicy = XmlViolationPolicy.FATAL;

    private XmlViolationPolicy contentNonXmlCharPolicy = XmlViolationPolicy.FATAL;

    private XmlViolationPolicy commentPolicy = XmlViolationPolicy.FATAL;

    private XmlViolationPolicy namePolicy = XmlViolationPolicy.FATAL;

    private XmlViolationPolicy streamabilityViolationPolicy = XmlViolationPolicy.ALLOW;
    
    private boolean html4ModeCompatibleWithXhtml1Schemata = false;

    private boolean mappingLangToXmlLang = false;

    private XmlViolationPolicy xmlnsPolicy = XmlViolationPolicy.FATAL;
    
    private boolean reportingDoctype = true;

    private ErrorHandler treeBuilderErrorHandler = null;

    private Heuristics heuristics = Heuristics.NONE;

    private TransitionHandler transitionHandler = null;

    /**
     * Instantiates the document builder with a specific DOM 
     * implementation and XML violation policy.
     * 
     * @param implementation
     *            the DOM implementation
     *            @param xmlPolicy the policy
     */
    public HtmlDocumentBuilder(DOMImplementation implementation,
            XmlViolationPolicy xmlPolicy) {
        this.implementation = implementation;
        this.treeBuilder = new DOMTreeBuilder(implementation);
        this.driver = null;
        setXmlPolicy(xmlPolicy);
    }

    /**
     * Instantiates the document builder with a specific DOM implementation 
     * and the infoset-altering XML violation policy.
     * 
     * @param implementation
     *            the DOM implementation
     */
    public HtmlDocumentBuilder(DOMImplementation implementation) {
        this(implementation, XmlViolationPolicy.ALTER_INFOSET);
    }

    /**
     * Instantiates the document builder with the JAXP DOM implementation 
     * and the infoset-altering XML violation policy.
     */
    public HtmlDocumentBuilder() {
        this(XmlViolationPolicy.ALTER_INFOSET);
    }

    /**
     * Instantiates the document builder with the JAXP DOM implementation 
     * and a specific XML violation policy.
     *            @param xmlPolicy the policy
     */
    public HtmlDocumentBuilder(XmlViolationPolicy xmlPolicy) {
        this(jaxpDOMImplementation(), xmlPolicy);
    }


    private Tokenizer newTokenizer(TokenHandler handler,
            boolean newAttributesEachTime) {
        if (errorHandler == null && transitionHandler == null
                && contentNonXmlCharPolicy == XmlViolationPolicy.ALLOW) {
            return new Tokenizer(handler, newAttributesEachTime);
        } else {
            return new ErrorReportingTokenizer(handler, newAttributesEachTime);
        }
    }
    
    /**
     * This class wraps different tree builders depending on configuration. This 
     * method does the work of hiding this from the user of the class.
     */
    private void lazyInit() {
        if (driver == null) {
            this.driver = new Driver(newTokenizer(treeBuilder, false));
            this.driver.setErrorHandler(errorHandler);
            this.driver.setTransitionHandler(transitionHandler);
            this.treeBuilder.setErrorHandler(treeBuilderErrorHandler);
            this.driver.setCheckingNormalization(checkingNormalization);
            this.driver.setCommentPolicy(commentPolicy);
            this.driver.setContentNonXmlCharPolicy(contentNonXmlCharPolicy);
            this.driver.setContentSpacePolicy(contentSpacePolicy);
            this.driver.setHtml4ModeCompatibleWithXhtml1Schemata(html4ModeCompatibleWithXhtml1Schemata);
            this.driver.setMappingLangToXmlLang(mappingLangToXmlLang);
            this.driver.setXmlnsPolicy(xmlnsPolicy);
            this.driver.setHeuristics(heuristics);
            for (CharacterHandler characterHandler : characterHandlers) {
                this.driver.addCharacterHandler(characterHandler);
            }
            this.treeBuilder.setDoctypeExpectation(doctypeExpectation);
            this.treeBuilder.setDocumentModeHandler(documentModeHandler);
            this.treeBuilder.setScriptingEnabled(scriptingEnabled);
            this.treeBuilder.setReportingDoctype(reportingDoctype);
            this.treeBuilder.setNamePolicy(namePolicy);
        }
    }
    
    /**
     * Tokenizes the input source.
     * 
     * @param is the source
     * @throws SAXException if stuff goes wrong
     * @throws IOException if IO goes wrong
     * @throws MalformedURLException if the system ID is malformed and the entity resolver is <code>null</code>
     */
    private void tokenize(InputSource is) throws SAXException, IOException,
            MalformedURLException {
        if (is == null) {
            throw new IllegalArgumentException("Null input.");
        }
        if (is.getByteStream() == null && is.getCharacterStream() == null) {
            String systemId = is.getSystemId();
            if (systemId == null) {
                throw new IllegalArgumentException(
                        "No byte stream, no character stream nor URI.");
            }
            if (entityResolver != null) {
                is = entityResolver.resolveEntity(is.getPublicId(), systemId);
            }
            if (is.getByteStream() == null || is.getCharacterStream() == null) {
                is = new InputSource();
                is.setSystemId(systemId);
                is.setByteStream(new URL(systemId).openStream());
            }
        }
        if (driver == null) lazyInit();
        driver.tokenize(is);
    }
    
    /**
     * Returns the DOM implementation
     * @return the DOM implementation
     * @see javax.xml.parsers.DocumentBuilder#getDOMImplementation()
     */
    @Override public DOMImplementation getDOMImplementation() {
        return implementation;
    }

    /**
     * Returns <code>true</code>.
     * @return <code>true</code>
     * @see javax.xml.parsers.DocumentBuilder#isNamespaceAware()
     */
    @Override public boolean isNamespaceAware() {
        return true;
    }

    /**
     * Returns <code>false</code>
     * @return <code>false</code>
     * @see javax.xml.parsers.DocumentBuilder#isValidating()
     */
    @Override public boolean isValidating() {
        return false;
    }

    /**
     * For API compatibility.
     * @see javax.xml.parsers.DocumentBuilder#newDocument()
     */
    @Override public Document newDocument() {
        return implementation.createDocument(null, null, null);
    }

    /**
     * Parses a document from a SAX <code>InputSource</code>.
     * @param is the source
     * @return the doc
     * @throws SAXException if stuff goes wrong
     * @throws IOException if IO goes wrong
     * @see javax.xml.parsers.DocumentBuilder#parse(org.xml.sax.InputSource)
     */
    @Override public Document parse(InputSource is) throws SAXException,
            IOException {
        treeBuilder.setFragmentContext(null);
        tokenize(is);
        return treeBuilder.getDocument();
    }

    /**
     * Parses a document fragment from a SAX <code>InputSource</code> with 
     * an HTML element as the fragment context.
     * @param is the source
     * @param context the context element name (HTML namespace assumed)
     * @return the document fragment
     * @throws SAXException if stuff goes wrong
     * @throws IOException if IO goes wrong
     */
    public DocumentFragment parseFragment(InputSource is, String context)
            throws IOException, SAXException {
        treeBuilder.setFragmentContext(context.intern());
        tokenize(is);
        return treeBuilder.getDocumentFragment();
    }

    /**
     * Parses a document fragment from a SAX <code>InputSource</code>.
     * @param is the source
     * @param contextLocal the local name of the context element
     * @param contextNamespace the namespace of the context element
     * @return the document fragment
     * @throws SAXException if stuff goes wrong
     * @throws IOException if IO goes wrong
     */
    public DocumentFragment parseFragment(InputSource is, String contextLocal,
            String contextNamespace) throws IOException, SAXException {
        treeBuilder.setFragmentContext(contextLocal.intern(),
                contextNamespace.intern(), null, false);
        tokenize(is);
        return treeBuilder.getDocumentFragment();
    }

    /**
     * Sets the entity resolver for URI-only inputs.
     * @param resolver the resolver
     * @see javax.xml.parsers.DocumentBuilder#setEntityResolver(org.xml.sax.EntityResolver)
     */
    @Override public void setEntityResolver(EntityResolver resolver) {
        this.entityResolver = resolver;
    }

    /**
     * Sets the error handler.
     * @param errorHandler the handler
     * @see javax.xml.parsers.DocumentBuilder#setErrorHandler(org.xml.sax.ErrorHandler)
     */
    @Override public void setErrorHandler(ErrorHandler errorHandler) {
        treeBuilder.setErrorHandler(errorHandler);
        if (driver != null) {
            driver.setErrorHandler(errorHandler);
        }
    }

    public void setTransitionHander(TransitionHandler handler) {
        transitionHandler = handler;
        driver = null;
    }
    
    /**
     * Indicates whether NFC normalization of source is being checked.
     * @return <code>true</code> if NFC normalization of source is being checked.
     * @see nu.validator.htmlparser.impl.Tokenizer#isCheckingNormalization()
     */
    public boolean isCheckingNormalization() {
        return checkingNormalization;
    }

    /**
     * Toggles the checking of the NFC normalization of source.
     * @param enable <code>true</code> to check normalization
     * @see nu.validator.htmlparser.impl.Tokenizer#setCheckingNormalization(boolean)
     */
    public void setCheckingNormalization(boolean enable) {
        this.checkingNormalization = enable;
        if (driver != null) {
            driver.setCheckingNormalization(checkingNormalization);
        }
    }

    /**
     * Sets the policy for consecutive hyphens in comments.
     * @param commentPolicy the policy
     * @see nu.validator.htmlparser.impl.Tokenizer#setCommentPolicy(nu.validator.htmlparser.common.XmlViolationPolicy)
     */
    public void setCommentPolicy(XmlViolationPolicy commentPolicy) {
        this.commentPolicy = commentPolicy;
        if (driver != null) {
            driver.setCommentPolicy(commentPolicy);
        }
    }

    /**
     * Sets the policy for non-XML characters except white space.
     * @param contentNonXmlCharPolicy the policy
     * @see nu.validator.htmlparser.impl.Tokenizer#setContentNonXmlCharPolicy(nu.validator.htmlparser.common.XmlViolationPolicy)
     */
    public void setContentNonXmlCharPolicy(
            XmlViolationPolicy contentNonXmlCharPolicy) {
        this.contentNonXmlCharPolicy = contentNonXmlCharPolicy;
        driver = null;
    }

    /**
     * Sets the policy for non-XML white space.
     * @param contentSpacePolicy the policy
     * @see nu.validator.htmlparser.impl.Tokenizer#setContentSpacePolicy(nu.validator.htmlparser.common.XmlViolationPolicy)
     */
    public void setContentSpacePolicy(XmlViolationPolicy contentSpacePolicy) {
        this.contentSpacePolicy = contentSpacePolicy;
        if (driver != null) {
            driver.setContentSpacePolicy(contentSpacePolicy);
        }
    }

    /**
     * Whether the parser considers scripting to be enabled for noscript treatment.
     * 
     * @return <code>true</code> if enabled
     * @see nu.validator.htmlparser.impl.TreeBuilder#isScriptingEnabled()
     */
    public boolean isScriptingEnabled() {
        return scriptingEnabled;
    }

    /**
     * Sets whether the parser considers scripting to be enabled for noscript treatment.
     * @param scriptingEnabled <code>true</code> to enable
     * @see nu.validator.htmlparser.impl.TreeBuilder#setScriptingEnabled(boolean)
     */
    public void setScriptingEnabled(boolean scriptingEnabled) {
        this.scriptingEnabled = scriptingEnabled;
        if (treeBuilder != null) {
            treeBuilder.setScriptingEnabled(scriptingEnabled);
        }
    }

    /**
     * Returns the doctype expectation.
     * 
     * @return the doctypeExpectation
     */
    public DoctypeExpectation getDoctypeExpectation() {
        return doctypeExpectation;
    }

    /**
     * Sets the doctype expectation.
     * 
     * @param doctypeExpectation
     *            the doctypeExpectation to set
     * @see nu.validator.htmlparser.impl.TreeBuilder#setDoctypeExpectation(nu.validator.htmlparser.common.DoctypeExpectation)
     */
    public void setDoctypeExpectation(DoctypeExpectation doctypeExpectation) {
        this.doctypeExpectation = doctypeExpectation;
        if (treeBuilder != null) {
            treeBuilder.setDoctypeExpectation(doctypeExpectation);
        }
    }

    /**
     * Returns the document mode handler.
     * 
     * @return the documentModeHandler
     */
    public DocumentModeHandler getDocumentModeHandler() {
        return documentModeHandler;
    }

    /**
     * Sets the document mode handler.
     * 
     * @param documentModeHandler
     *            the documentModeHandler to set
     * @see nu.validator.htmlparser.impl.TreeBuilder#setDocumentModeHandler(nu.validator.htmlparser.common.DocumentModeHandler)
     */
    public void setDocumentModeHandler(DocumentModeHandler documentModeHandler) {
        this.documentModeHandler = documentModeHandler;
    }

    /**
     * Returns the streamabilityViolationPolicy.
     * 
     * @return the streamabilityViolationPolicy
     */
    public XmlViolationPolicy getStreamabilityViolationPolicy() {
        return streamabilityViolationPolicy;
    }

    /**
     * Sets the streamabilityViolationPolicy.
     * 
     * @param streamabilityViolationPolicy
     *            the streamabilityViolationPolicy to set
     */
    public void setStreamabilityViolationPolicy(
            XmlViolationPolicy streamabilityViolationPolicy) {
        this.streamabilityViolationPolicy = streamabilityViolationPolicy;
        driver = null;
    }

    /**
     * Whether the HTML 4 mode reports boolean attributes in a way that repeats
     * the name in the value.
     * @param html4ModeCompatibleWithXhtml1Schemata
     */
    public void setHtml4ModeCompatibleWithXhtml1Schemata(
            boolean html4ModeCompatibleWithXhtml1Schemata) {
        this.html4ModeCompatibleWithXhtml1Schemata = html4ModeCompatibleWithXhtml1Schemata;
        if (driver != null) {
            driver.setHtml4ModeCompatibleWithXhtml1Schemata(html4ModeCompatibleWithXhtml1Schemata);
        }
    }

    /**
     * Returns the <code>Locator</code> during parse.
     * @return the <code>Locator</code>
     */
    public Locator getDocumentLocator() {
        return driver.getDocumentLocator();
    }

    /**
     * Whether the HTML 4 mode reports boolean attributes in a way that repeats
     * the name in the value.
     * 
     * @return the html4ModeCompatibleWithXhtml1Schemata
     */
    public boolean isHtml4ModeCompatibleWithXhtml1Schemata() {
        return html4ModeCompatibleWithXhtml1Schemata;
    }

    /**
     * Whether <code>lang</code> is mapped to <code>xml:lang</code>.
     * @param mappingLangToXmlLang
     * @see nu.validator.htmlparser.impl.Tokenizer#setMappingLangToXmlLang(boolean)
     */
    public void setMappingLangToXmlLang(boolean mappingLangToXmlLang) {
        this.mappingLangToXmlLang = mappingLangToXmlLang;
        if (driver != null) {
            driver.setMappingLangToXmlLang(mappingLangToXmlLang);
        }
    }

    /**
     * Whether <code>lang</code> is mapped to <code>xml:lang</code>.
     * 
     * @return the mappingLangToXmlLang
     */
    public boolean isMappingLangToXmlLang() {
        return mappingLangToXmlLang;
    }

    /**
     * Whether the <code>xmlns</code> attribute on the root element is 
     * passed to through. (FATAL not allowed.)
     * @param xmlnsPolicy
     * @see nu.validator.htmlparser.impl.Tokenizer#setXmlnsPolicy(nu.validator.htmlparser.common.XmlViolationPolicy)
     */
    public void setXmlnsPolicy(XmlViolationPolicy xmlnsPolicy) {
        if (xmlnsPolicy == XmlViolationPolicy.FATAL) {
            throw new IllegalArgumentException("Can't use FATAL here.");
        }
        this.xmlnsPolicy = xmlnsPolicy;
        if (driver != null) {
            driver.setXmlnsPolicy(xmlnsPolicy);
        }
    }

    /**
     * Returns the xmlnsPolicy.
     * 
     * @return the xmlnsPolicy
     */
    public XmlViolationPolicy getXmlnsPolicy() {
        return xmlnsPolicy;
    }

    /**
     * Returns the commentPolicy.
     * 
     * @return the commentPolicy
     */
    public XmlViolationPolicy getCommentPolicy() {
        return commentPolicy;
    }

    /**
     * Returns the contentNonXmlCharPolicy.
     * 
     * @return the contentNonXmlCharPolicy
     */
    public XmlViolationPolicy getContentNonXmlCharPolicy() {
        return contentNonXmlCharPolicy;
    }

    /**
     * Returns the contentSpacePolicy.
     * 
     * @return the contentSpacePolicy
     */
    public XmlViolationPolicy getContentSpacePolicy() {
        return contentSpacePolicy;
    }

    /**
     * @param reportingDoctype
     * @see nu.validator.htmlparser.impl.TreeBuilder#setReportingDoctype(boolean)
     */
    public void setReportingDoctype(boolean reportingDoctype) {
        this.reportingDoctype = reportingDoctype;
        if (treeBuilder != null) {
            treeBuilder.setReportingDoctype(reportingDoctype);
        }
    }

    /**
     * Returns the reportingDoctype.
     * 
     * @return the reportingDoctype
     */
    public boolean isReportingDoctype() {
        return reportingDoctype;
    }

    /**
     * The policy for non-NCName element and attribute names.
     * @param namePolicy
     * @see nu.validator.htmlparser.impl.Tokenizer#setNamePolicy(nu.validator.htmlparser.common.XmlViolationPolicy)
     */
    public void setNamePolicy(XmlViolationPolicy namePolicy) {
        this.namePolicy = namePolicy;
        if (driver != null) {
            driver.setNamePolicy(namePolicy);
            treeBuilder.setNamePolicy(namePolicy);
        }
    }
    
    /**
     * Sets the encoding sniffing heuristics.
     * 
     * @param heuristics the heuristics to set
     * @see nu.validator.htmlparser.impl.Tokenizer#setHeuristics(nu.validator.htmlparser.common.Heuristics)
     */
    public void setHeuristics(Heuristics heuristics) {
        this.heuristics = heuristics;
        if (driver != null) {
            driver.setHeuristics(heuristics);
        }
    }
    
    public Heuristics getHeuristics() {
        return this.heuristics;
    }

    /**
     * This is a catch-all convenience method for setting name, xmlns, content space, 
     * content non-XML char and comment policies in one go. This does not affect the 
     * streamability policy or doctype reporting.
     * 
     * @param xmlPolicy
     */
    public void setXmlPolicy(XmlViolationPolicy xmlPolicy) {
        setNamePolicy(xmlPolicy);
        setXmlnsPolicy(xmlPolicy == XmlViolationPolicy.FATAL ? XmlViolationPolicy.ALTER_INFOSET : xmlPolicy);
        setContentSpacePolicy(xmlPolicy);
        setContentNonXmlCharPolicy(xmlPolicy);
        setCommentPolicy(xmlPolicy);
    }

    /**
     * The policy for non-NCName element and attribute names.
     * 
     * @return the namePolicy
     */
    public XmlViolationPolicy getNamePolicy() {
        return namePolicy;
    }

    /**
     * Does nothing.
     * @deprecated
     */
    public void setBogusXmlnsPolicy(
            XmlViolationPolicy bogusXmlnsPolicy) {
    }

    /**
     * Returns <code>XmlViolationPolicy.ALTER_INFOSET</code>.
     * @deprecated
     * @return <code>XmlViolationPolicy.ALTER_INFOSET</code>
     */
    public XmlViolationPolicy getBogusXmlnsPolicy() {
        return XmlViolationPolicy.ALTER_INFOSET;
    }
    
    public void addCharacterHandler(CharacterHandler characterHandler) {
        this.characterHandlers.add(characterHandler);
        if (driver != null) {
            driver.addCharacterHandler(characterHandler);
        }
    }

    
    /**
     * Sets whether comment nodes appear in the tree.
     * @param ignoreComments <code>true</code> to ignore comments
     * @see nu.validator.htmlparser.impl.TreeBuilder#setIgnoringComments(boolean)
     */
    public void setIgnoringComments(boolean ignoreComments) {
        treeBuilder.setIgnoringComments(ignoreComments);
    }

}
