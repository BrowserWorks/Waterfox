/*
 * Copyright (c) 2009-2013 Mozilla Foundation
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

package nu.validator.htmlparser.impl;

import java.util.HashMap;

import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;

import nu.validator.htmlparser.annotation.Inline;
import nu.validator.htmlparser.annotation.NoLength;
import nu.validator.htmlparser.common.TokenHandler;
import nu.validator.htmlparser.common.TransitionHandler;
import nu.validator.htmlparser.common.XmlViolationPolicy;

public class ErrorReportingTokenizer extends Tokenizer {

    /**
     * Magic value for UTF-16 operations.
     */
    private static final int SURROGATE_OFFSET = (0x10000 - (0xD800 << 10) - 0xDC00);

    /**
     * The policy for non-space non-XML characters.
     */
    private XmlViolationPolicy contentNonXmlCharPolicy = XmlViolationPolicy.ALTER_INFOSET;

    /**
     * Keeps track of PUA warnings.
     */
    private boolean alreadyWarnedAboutPrivateUseCharacters;

    /**
     * The current line number in the current resource being parsed. (First line
     * is 1.) Passed on as locator data.
     */
    private int line;

    private int linePrev;

    /**
     * The current column number in the current resource being tokenized. (First
     * column is 1, counted by UTF-16 code units.) Passed on as locator data.
     */
    private int col;

    private int colPrev;

    private boolean nextCharOnNewLine;

    private char prev;

    private HashMap<String, String> errorProfileMap = null;

    private TransitionHandler transitionHandler = null;

    private int transitionBaseOffset = 0;

    /**
     * @param tokenHandler
     * @param newAttributesEachTime
     */
    public ErrorReportingTokenizer(TokenHandler tokenHandler,
            boolean newAttributesEachTime) {
        super(tokenHandler, newAttributesEachTime);
    }

    /**
     * @param tokenHandler
     */
    public ErrorReportingTokenizer(TokenHandler tokenHandler) {
        super(tokenHandler);
    }

    /**
     * @see org.xml.sax.Locator#getLineNumber()
     */
    public int getLineNumber() {
        if (line > 0) {
            return line;
        } else {
            return -1;
        }
    }

    /**
     * @see org.xml.sax.Locator#getColumnNumber()
     */
    public int getColumnNumber() {
        if (col > 0) {
            return col;
        } else {
            return -1;
        }
    }

    /**
     * Sets the contentNonXmlCharPolicy.
     *
     * @param contentNonXmlCharPolicy
     *            the contentNonXmlCharPolicy to set
     */
    public void setContentNonXmlCharPolicy(
            XmlViolationPolicy contentNonXmlCharPolicy) {
        this.contentNonXmlCharPolicy = contentNonXmlCharPolicy;
    }

    /**
     * Sets the errorProfile.
     *
     * @param errorProfile
     */
    public void setErrorProfile(HashMap<String, String> errorProfileMap) {
        this.errorProfileMap = errorProfileMap;
    }

    /**
     * Reports on an event based on profile selected.
     *
     * @param profile
     *            the profile this message belongs to
     * @param message
     *            the message itself
     * @throws SAXException
     */
    public void note(String profile, String message) throws SAXException {
        if (errorProfileMap == null)
            return;
        String level = errorProfileMap.get(profile);
        if ("warn".equals(level)) {
            warn(message);
        } else if ("err".equals(level)) {
            err(message);
            // } else if ("info".equals(level)) {
            // info(message);
        }
    }

    protected void startErrorReporting() throws SAXException {
        line = linePrev = 0;
        col = colPrev = 1;
        nextCharOnNewLine = true;
        prev = '\u0000';
        alreadyWarnedAboutPrivateUseCharacters = false;
        transitionBaseOffset = 0;
    }

    @Inline protected void silentCarriageReturn() {
        nextCharOnNewLine = true;
        lastCR = true;
    }

    @Inline protected void silentLineFeed() {
        nextCharOnNewLine = true;
    }

    /**
     * Returns the line.
     *
     * @return the line
     */
    public int getLine() {
        return line;
    }

    /**
     * Returns the col.
     *
     * @return the col
     */
    public int getCol() {
        return col;
    }

    /**
     * Returns the nextCharOnNewLine.
     *
     * @return the nextCharOnNewLine
     */
    public boolean isNextCharOnNewLine() {
        return nextCharOnNewLine;
    }

    /**
     * Flushes coalesced character tokens.
     *
     * @param buf
     *            TODO
     * @param pos
     *            TODO
     *
     * @throws SAXException
     */
    @Override protected void flushChars(char[] buf, int pos)
            throws SAXException {
        if (pos > cstart) {
            int currLine = line;
            int currCol = col;
            line = linePrev;
            col = colPrev;
            tokenHandler.characters(buf, cstart, pos - cstart);
            line = currLine;
            col = currCol;
        }
        cstart = 0x7fffffff;
    }

    @Override protected char checkChar(@NoLength char[] buf, int pos)
            throws SAXException {
        linePrev = line;
        colPrev = col;
        if (nextCharOnNewLine) {
            line++;
            col = 1;
            nextCharOnNewLine = false;
        } else {
            col++;
        }

        char c = buf[pos];
        switch (c) {
            case '\u0000':
                err("Saw U+0000 in stream.");
            case '\t':
            case '\r':
            case '\n':
                break;
            case '\u000C':
                if (contentNonXmlCharPolicy == XmlViolationPolicy.FATAL) {
                    fatal("This document is not mappable to XML 1.0 without data loss due to "
                            + toUPlusString(c)
                            + " which is not a legal XML 1.0 character.");
                } else {
                    if (contentNonXmlCharPolicy == XmlViolationPolicy.ALTER_INFOSET) {
                        c = buf[pos] = ' ';
                    }
                    warn("This document is not mappable to XML 1.0 without data loss due to "
                            + toUPlusString(c)
                            + " which is not a legal XML 1.0 character.");
                }
                break;
            default:
                if ((c & 0xFC00) == 0xDC00) {
                    // Got a low surrogate. See if prev was high
                    // surrogate
                    if ((prev & 0xFC00) == 0xD800) {
                        int intVal = (prev << 10) + c + SURROGATE_OFFSET;
                        if ((intVal & 0xFFFE) == 0xFFFE) {
                            err("Astral non-character.");
                        }
                        if (isAstralPrivateUse(intVal)) {
                            warnAboutPrivateUseChar();
                        }
                    }
                } else if ((c < ' ' || ((c & 0xFFFE) == 0xFFFE))) {
                    switch (contentNonXmlCharPolicy) {
                        case FATAL:
                            fatal("Forbidden code point " + toUPlusString(c)
                                    + ".");
                            break;
                        case ALTER_INFOSET:
                            c = buf[pos] = '\uFFFD';
                            // fall through
                        case ALLOW:
                            err("Forbidden code point " + toUPlusString(c)
                                    + ".");
                    }
                } else if ((c >= '\u007F') && (c <= '\u009F')
                        || (c >= '\uFDD0') && (c <= '\uFDEF')) {
                    err("Forbidden code point " + toUPlusString(c) + ".");
                } else if (isPrivateUse(c)) {
                    warnAboutPrivateUseChar();
                }
        }
        prev = c;
        return c;
    }

    /**
     * @throws SAXException
     * @see nu.validator.htmlparser.impl.Tokenizer#transition(int, int, boolean,
     *      int)
     */
    @Override protected int transition(int from, int to, boolean reconsume,
            int pos) throws SAXException {
        if (transitionHandler != null) {
            transitionHandler.transition(from, to, reconsume,
                    transitionBaseOffset + pos);
        }
        return to;
    }

    private String toUPlusString(int c) {
        String hexString = Integer.toHexString(c);
        switch (hexString.length()) {
            case 1:
                return "U+000" + hexString;
            case 2:
                return "U+00" + hexString;
            case 3:
                return "U+0" + hexString;
            default:
                return "U+" + hexString;
        }
    }

    /**
     * Emits a warning about private use characters if the warning has not been
     * emitted yet.
     *
     * @throws SAXException
     */
    private void warnAboutPrivateUseChar() throws SAXException {
        if (!alreadyWarnedAboutPrivateUseCharacters) {
            warn("Document uses the Unicode Private Use Area(s), which should not be used in publicly exchanged documents. (Charmod C073)");
            alreadyWarnedAboutPrivateUseCharacters = true;
        }
    }

    /**
     * Tells if the argument is a BMP PUA character.
     *
     * @param c
     *            the UTF-16 code unit to check
     * @return <code>true</code> if PUA character
     */
    private boolean isPrivateUse(char c) {
        return c >= '\uE000' && c <= '\uF8FF';
    }

    /**
     * Tells if the argument is an astral PUA character.
     *
     * @param c
     *            the code point to check
     * @return <code>true</code> if astral private use
     */
    private boolean isAstralPrivateUse(int c) {
        return (c >= 0xF0000 && c <= 0xFFFFD)
                || (c >= 0x100000 && c <= 0x10FFFD);
    }

    @Override protected void errGarbageAfterLtSlash() throws SAXException {
        err("Garbage after \u201C</\u201D.");
    }

    @Override protected void errLtSlashGt() throws SAXException {
        err("Saw \u201C</>\u201D. Probable causes: Unescaped \u201C<\u201D (escape as \u201C&lt;\u201D) or mistyped end tag.");
    }

    @Override protected void errWarnLtSlashInRcdata() throws SAXException {
        if (html4) {
            err((stateSave == Tokenizer.DATA ? "CDATA" : "RCDATA")
                    + " element \u201C"
                    + endTagExpectation
                    + "\u201D contained the string \u201C</\u201D, but it was not the start of the end tag. (HTML4-only error)");
        } else {
            warn((stateSave == Tokenizer.DATA ? "CDATA" : "RCDATA")
                    + " element \u201C"
                    + endTagExpectation
                    + "\u201D contained the string \u201C</\u201D, but this did not close the element.");
        }
    }

    @Override protected void errHtml4LtSlashInRcdata(char folded)
            throws SAXException {
        if (html4 && (index > 0 || (folded >= 'a' && folded <= 'z'))
                && ElementName.IFRAME != endTagExpectation) {
            err((stateSave == Tokenizer.DATA ? "CDATA" : "RCDATA")
                    + " element \u201C"
                    + endTagExpectation.getName()
                    + "\u201D contained the string \u201C</\u201D, but it was not the start of the end tag. (HTML4-only error)");
        }
    }

    @Override protected void errCharRefLacksSemicolon() throws SAXException {
        err("Character reference was not terminated by a semicolon.");
    }

    @Override protected void errNoDigitsInNCR() throws SAXException {
        err("No digits after \u201C" + strBufToString() + "\u201D.");
    }

    @Override protected void errGtInSystemId() throws SAXException {
        err("\u201C>\u201D in system identifier.");
    }

    @Override protected void errGtInPublicId() throws SAXException {
        err("\u201C>\u201D in public identifier.");
    }

    @Override protected void errNamelessDoctype() throws SAXException {
        err("Nameless doctype.");
    }

    @Override protected void errConsecutiveHyphens() throws SAXException {
        err("Consecutive hyphens did not terminate a comment. \u201C--\u201D is not permitted inside a comment, but e.g. \u201C- -\u201D is.");
    }

    @Override protected void errPrematureEndOfComment() throws SAXException {
        err("Premature end of comment. Use \u201C-->\u201D to end a comment properly.");
    }

    @Override protected void errBogusComment() throws SAXException {
        err("Bogus comment.");
    }

    @Override protected void errUnquotedAttributeValOrNull(char c)
            throws SAXException {
        switch (c) {
            case '<':
                err("\u201C<\u201D in an unquoted attribute value. Probable cause: Missing \u201C>\u201D immediately before.");
                return;
            case '`':
                err("\u201C`\u201D in an unquoted attribute value. Probable cause: Using the wrong character as a quote.");
                return;
            case '\uFFFD':
                return;
            default:
                err("\u201C"
                        + c
                        + "\u201D in an unquoted attribute value. Probable causes: Attributes running together or a URL query string in an unquoted attribute value.");
                return;
        }
    }

    @Override protected void errSlashNotFollowedByGt() throws SAXException {
        err("A slash was not immediately followed by \u201C>\u201D.");
    }

    @Override protected void errHtml4XmlVoidSyntax() throws SAXException {
        if (html4) {
            err("The \u201C/>\u201D syntax on void elements is not allowed.  (This is an HTML4-only error.)");
        }
    }

    @Override protected void errNoSpaceBetweenAttributes() throws SAXException {
        err("No space between attributes.");
    }

    @Override protected void errHtml4NonNameInUnquotedAttribute(char c)
            throws SAXException {
        if (html4
                && !((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z')
                        || (c >= '0' && c <= '9') || c == '.' || c == '-'
                        || c == '_' || c == ':')) {
            err("Non-name character in an unquoted attribute value. (This is an HTML4-only error.)");
        }
    }

    @Override protected void errLtOrEqualsOrGraveInUnquotedAttributeOrNull(
            char c) throws SAXException {
        switch (c) {
            case '=':
                err("\u201C=\u201D at the start of an unquoted attribute value. Probable cause: Stray duplicate equals sign.");
                return;
            case '<':
                err("\u201C<\u201D at the start of an unquoted attribute value. Probable cause: Missing \u201C>\u201D immediately before.");
                return;
            case '`':
                err("\u201C`\u201D at the start of an unquoted attribute value. Probable cause: Using the wrong character as a quote.");
                return;
        }
    }

    @Override protected void errAttributeValueMissing() throws SAXException {
        err("Attribute value missing.");
    }

    @Override protected void errBadCharBeforeAttributeNameOrNull(char c)
            throws SAXException {
        if (c == '<') {
            err("Saw \u201C<\u201D when expecting an attribute name. Probable cause: Missing \u201C>\u201D immediately before.");
        } else if (c == '=') {
            errEqualsSignBeforeAttributeName();
        } else if (c != '\uFFFD') {
            errQuoteBeforeAttributeName(c);
        }
    }

    @Override protected void errEqualsSignBeforeAttributeName()
            throws SAXException {
        err("Saw \u201C=\u201D when expecting an attribute name. Probable cause: Attribute name missing.");
    }

    @Override protected void errBadCharAfterLt(char c) throws SAXException {
        err("Bad character \u201C"
                + c
                + "\u201D after \u201C<\u201D. Probable cause: Unescaped \u201C<\u201D. Try escaping it as \u201C&lt;\u201D.");
    }

    @Override protected void errLtGt() throws SAXException {
        err("Saw \u201C<>\u201D. Probable causes: Unescaped \u201C<\u201D (escape as \u201C&lt;\u201D) or mistyped start tag.");
    }

    @Override protected void errProcessingInstruction() throws SAXException {
        err("Saw \u201C<?\u201D. Probable cause: Attempt to use an XML processing instruction in HTML. (XML processing instructions are not supported in HTML.)");
    }

    @Override protected void errUnescapedAmpersandInterpretedAsCharacterReference()
            throws SAXException {
        if (errorHandler == null) {
            return;
        }
        SAXParseException spe = new SAXParseException(
                "The string following \u201C&\u201D was interpreted as a character reference. (\u201C&\u201D probably should have been escaped as \u201C&amp;\u201D.)",
                ampersandLocation);
        errorHandler.error(spe);
    }

    @Override protected void errNotSemicolonTerminated() throws SAXException {
        err("Named character reference was not terminated by a semicolon. (Or \u201C&\u201D should have been escaped as \u201C&amp;\u201D.)");
    }

    @Override protected void errNoNamedCharacterMatch() throws SAXException {
        if (errorHandler == null) {
            return;
        }
        SAXParseException spe = new SAXParseException(
                "\u201C&\u201D did not start a character reference. (\u201C&\u201D probably should have been escaped as \u201C&amp;\u201D.)",
                ampersandLocation);
        errorHandler.error(spe);
    }

    @Override protected void errQuoteBeforeAttributeName(char c)
            throws SAXException {
        err("Saw \u201C"
                + c
                + "\u201D when expecting an attribute name. Probable cause: \u201C=\u201D missing immediately before.");
    }

    @Override protected void errQuoteOrLtInAttributeNameOrNull(char c)
            throws SAXException {
        if (c == '<') {
            err("\u201C<\u201D in attribute name. Probable cause: \u201C>\u201D missing immediately before.");
        } else if (c != '\uFFFD') {
            err("Quote \u201C"
                    + c
                    + "\u201D in attribute name. Probable cause: Matching quote missing somewhere earlier.");
        }
    }

    @Override protected void errExpectedPublicId() throws SAXException {
        err("Expected a public identifier but the doctype ended.");
    }

    @Override protected void errBogusDoctype() throws SAXException {
        err("Bogus doctype.");
    }

    @Override protected void maybeWarnPrivateUseAstral() throws SAXException {
        if (errorHandler != null && isAstralPrivateUse(value)) {
            warnAboutPrivateUseChar();
        }
    }

    @Override protected void maybeWarnPrivateUse(char ch) throws SAXException {
        if (errorHandler != null && isPrivateUse(ch)) {
            warnAboutPrivateUseChar();
        }
    }

    @Override protected void maybeErrAttributesOnEndTag(HtmlAttributes attrs)
            throws SAXException {
        if (attrs.getLength() != 0) {
            /*
             * When an end tag token is emitted with attributes, that is a parse
             * error.
             */
            err("End tag had attributes.");
        }
    }

    @Override protected void maybeErrSlashInEndTag(boolean selfClosing)
            throws SAXException {
        if (selfClosing && endTag) {
            err("Stray \u201C/\u201D at the end of an end tag.");
        }
    }

    @Override protected char errNcrNonCharacter(char ch) throws SAXException {
        switch (contentNonXmlCharPolicy) {
            case FATAL:
                fatal("Character reference expands to a non-character ("
                        + toUPlusString((char) value) + ").");
                break;
            case ALTER_INFOSET:
                ch = '\uFFFD';
                // fall through
            case ALLOW:
                err("Character reference expands to a non-character ("
                        + toUPlusString((char) value) + ").");
        }
        return ch;
    }

    /**
     * @see nu.validator.htmlparser.impl.Tokenizer#errAstralNonCharacter(int)
     */
    @Override protected void errAstralNonCharacter(int ch) throws SAXException {
        err("Character reference expands to an astral non-character ("
                + toUPlusString(value) + ").");
    }

    @Override protected void errNcrSurrogate() throws SAXException {
        err("Character reference expands to a surrogate.");
    }

    @Override protected char errNcrControlChar(char ch) throws SAXException {
        switch (contentNonXmlCharPolicy) {
            case FATAL:
                fatal("Character reference expands to a control character ("
                        + toUPlusString((char) value) + ").");
                break;
            case ALTER_INFOSET:
                ch = '\uFFFD';
                // fall through
            case ALLOW:
                err("Character reference expands to a control character ("
                        + toUPlusString((char) value) + ").");
        }
        return ch;
    }

    @Override protected void errNcrCr() throws SAXException {
        err("A numeric character reference expanded to carriage return.");
    }

    @Override protected void errNcrInC1Range() throws SAXException {
        err("A numeric character reference expanded to the C1 controls range.");
    }

    @Override protected void errEofInPublicId() throws SAXException {
        err("End of file inside public identifier.");
    }

    @Override protected void errEofInComment() throws SAXException {
        err("End of file inside comment.");
    }

    @Override protected void errEofInDoctype() throws SAXException {
        err("End of file inside doctype.");
    }

    @Override protected void errEofInAttributeValue() throws SAXException {
        err("End of file reached when inside an attribute value. Ignoring tag.");
    }

    @Override protected void errEofInAttributeName() throws SAXException {
        err("End of file occurred in an attribute name. Ignoring tag.");
    }

    @Override protected void errEofWithoutGt() throws SAXException {
        err("Saw end of file without the previous tag ending with \u201C>\u201D. Ignoring tag.");
    }

    @Override protected void errEofInTagName() throws SAXException {
        err("End of file seen when looking for tag name. Ignoring tag.");
    }

    @Override protected void errEofInEndTag() throws SAXException {
        err("End of file inside end tag. Ignoring tag.");
    }

    @Override protected void errEofAfterLt() throws SAXException {
        err("End of file after \u201C<\u201D.");
    }

    @Override protected void errNcrOutOfRange() throws SAXException {
        err("Character reference outside the permissible Unicode range.");
    }

    @Override protected void errNcrUnassigned() throws SAXException {
        err("Character reference expands to a permanently unassigned code point.");
    }

    @Override protected void errDuplicateAttribute() throws SAXException {
        err("Duplicate attribute \u201C"
                + attributeName.getLocal(AttributeName.HTML) + "\u201D.");
    }

    @Override protected void errEofInSystemId() throws SAXException {
        err("End of file inside system identifier.");
    }

    @Override protected void errExpectedSystemId() throws SAXException {
        err("Expected a system identifier but the doctype ended.");
    }

    @Override protected void errMissingSpaceBeforeDoctypeName()
            throws SAXException {
        err("Missing space before doctype name.");
    }

    @Override protected void errHyphenHyphenBang() throws SAXException {
        err("\u201C--!\u201D found in comment.");
    }

    @Override protected void errNcrControlChar() throws SAXException {
        err("Character reference expands to a control character ("
                + toUPlusString((char) value) + ").");
    }

    @Override protected void errNcrZero() throws SAXException {
        err("Character reference expands to zero.");
    }

    @Override protected void errNoSpaceBetweenDoctypeSystemKeywordAndQuote()
            throws SAXException {
        err("No space between the doctype \u201CSYSTEM\u201D keyword and the quote.");
    }

    @Override protected void errNoSpaceBetweenPublicAndSystemIds()
            throws SAXException {
        err("No space between the doctype public and system identifiers.");
    }

    @Override protected void errNoSpaceBetweenDoctypePublicKeywordAndQuote()
            throws SAXException {
        err("No space between the doctype \u201CPUBLIC\u201D keyword and the quote.");
    }

    @Override protected void noteAttributeWithoutValue() throws SAXException {
        note("xhtml2", "Attribute without value");
    }

    @Override protected void noteUnquotedAttributeValue() throws SAXException {
        note("xhtml1", "Unquoted attribute value.");
    }

    /**
     * Sets the transitionHandler.
     *
     * @param transitionHandler
     *            the transitionHandler to set
     */
    public void setTransitionHandler(TransitionHandler transitionHandler) {
        this.transitionHandler = transitionHandler;
    }

    /**
     * Sets an offset to be added to the position reported to
     * <code>TransitionHandler</code>.
     *
     * @param offset
     *            the offset
     */
    public void setTransitionBaseOffset(int offset) {
        this.transitionBaseOffset = offset;
    }

}
