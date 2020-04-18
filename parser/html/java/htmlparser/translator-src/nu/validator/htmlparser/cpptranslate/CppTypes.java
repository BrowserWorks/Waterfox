/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is HTML Parser C++ Translator code.
 *
 * The Initial Developer of the Original Code is
 * Mozilla Foundation.
 * Portions created by the Initial Developer are Copyright (C) 2008-2009
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *   Henri Sivonen <hsivonen@iki.fi>
 *
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 *
 * ***** END LICENSE BLOCK ***** */

package nu.validator.htmlparser.cpptranslate;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class CppTypes {

    private static final Pattern ATOM_DEF = Pattern.compile("^GK_ATOM\\(([^,]+),\\s*\"([^\"]*)\"\\).*$");

    private static Set<String> reservedWords = new HashSet<String>();

    static {
        reservedWords.add("small");
        reservedWords.add("for");
        reservedWords.add("false");
        reservedWords.add("true");
        reservedWords.add("default");
        reservedWords.add("class");
        reservedWords.add("switch");
        reservedWords.add("union");
        reservedWords.add("template");
        reservedWords.add("int");
        reservedWords.add("char");
        reservedWords.add("operator");
        reservedWords.add("or");
        reservedWords.add("and");
        reservedWords.add("not");
        reservedWords.add("xor");
        reservedWords.add("unicode");
    }

    private static final String[] TREE_BUILDER_INCLUDES = { "nsContentUtils",
            "nsIAtom", "nsHtml5AtomTable", "nsITimer", "nsHtml5String",
            "nsNameSpaceManager", "nsIContent", "nsTraceRefcnt", "jArray",
            "nsHtml5DocumentMode", "nsHtml5ArrayCopy", "nsHtml5Parser",
            "nsGkAtoms", "nsHtml5TreeOperation", "nsHtml5StateSnapshot",
            "nsHtml5StackNode", "nsHtml5TreeOpExecutor", "nsHtml5StreamParser",
            "nsAHtml5TreeBuilderState", "nsHtml5Highlighter",
            "nsHtml5PlainTextUtils", "nsHtml5ViewSourceUtils",
            "mozilla/Likely", "nsIContentHandle", "nsHtml5OplessBuilder" };

    private static final String[] TOKENIZER_INCLUDES = { "nsIAtom",
            "nsHtml5AtomTable", "nsHtml5String", "nsIContent", "nsTraceRefcnt",
            "jArray", "nsHtml5DocumentMode", "nsHtml5ArrayCopy",
            "nsHtml5NamedCharacters", "nsHtml5NamedCharactersAccel",
            "nsGkAtoms", "nsAHtml5TreeBuilderState", "nsHtml5Macros",
            "nsHtml5Highlighter", "nsHtml5TokenizerLoopPolicies" };

    private static final String[] INCLUDES = { "nsIAtom", "nsHtml5AtomTable",
            "nsHtml5String", "nsNameSpaceManager", "nsIContent",
            "nsTraceRefcnt", "jArray", "nsHtml5ArrayCopy",
            "nsAHtml5TreeBuilderState", "nsGkAtoms", "nsHtml5ByteReadable",
            "nsHtml5Macros", "nsIContentHandle", "nsHtml5Portability",
            "nsHtml5ContentCreatorFunction"};

    private static final String[] OTHER_DECLATIONS = {};

    private static final String[] TREE_BUILDER_OTHER_DECLATIONS = {};

    private static final String[] NAMED_CHARACTERS_INCLUDES = { "jArray",
            "nscore", "nsDebug", "prlog", "mozilla/ArrayUtils" };

    private static final String[] FORWARD_DECLARATIONS = { "nsHtml5StreamParser" };

    private static final String[] CLASSES_THAT_NEED_SUPPLEMENT = {
            "MetaScanner", "Tokenizer", "TreeBuilder", "UTF16Buffer", };

    private static final String[] STATE_LOOP_POLICIES = {
            "nsHtml5ViewSourcePolicy", "nsHtml5SilentPolicy" };

    private final Map<String, String> atomMap = new HashMap<String, String>();

    private final Writer atomWriter;

    private StringBuilder manualAtoms = new StringBuilder();

    public CppTypes(File atomList) {
        if (atomList == null) {
            atomWriter = null;
        } else {
            try {
                ingestAtoms(atomList);
                atomWriter = new OutputStreamWriter(new FileOutputStream(
                        atomList), "utf-8");
                atomWriter.append(manualAtoms);
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        }
    }

    private void ingestAtoms(File atomList) throws IOException {
        // This doesn't need to be efficient, so let's make it easy to write.
        BufferedReader atomReader = new BufferedReader(
                new InputStreamReader(new FileInputStream(atomList), "utf-8"));
        try {
            String line;
            while ((line = atomReader.readLine()) != null) {
                manualAtoms.append(line);
                manualAtoms.append('\n');
                if (line.startsWith("// BEGIN GENERATED")) {
                    return;
                }
                if (!line.startsWith("GK_ATOM")) {
                    continue;
                }
                Matcher m = ATOM_DEF.matcher(line);
                if (!m.matches()) {
                    throw new RuntimeException("Malformed atom definition: " + line);
                }
                atomMap.put(m.group(2), m.group(1));
            }
            throw new RuntimeException(
                    "Atom list did not have a marker for generated section.");
        } finally {
            atomReader.close();
        }
    }

    public void finished() {
        try {
            if (atomWriter != null) {
                atomWriter.write("// END GENERATED ATOMS, DO NOT ADD CODE BELOW THIS LINE\n");
                atomWriter.flush();
                atomWriter.close();
            }
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    public String classPrefix() {
        return "nsHtml5";
    }

    public String booleanType() {
        return "bool";
    }

    public String byteType() {
        return "int8_t";
    }

    public String charType() {
        return "char16_t";
    }

    /**
     * Only used for named characters.
     *
     * @return
     */
    public String unsignedShortType() {
        return "uint16_t";
    }

    public String intType() {
        return "int32_t";
    }

    public String unsignedIntType() {
        return "uint32_t";
    }

    public String stringType() {
        return "nsHtml5String";
    }

    public String localType() {
        return "nsIAtom*";
    }

    public String prefixType() {
        return "nsIAtom*";
    }

    public String nsUriType() {
        return "int32_t";
    }

    public String falseLiteral() {
        return "false";
    }

    public String trueLiteral() {
        return "true";
    }

    public String nullLiteral() {
        return "nullptr";
    }

    public String encodingDeclarationHandlerType() {
        return "nsHtml5StreamParser*";
    }

    public String nodeType() {
        return "nsIContentHandle*";
    }

    public String htmlCreatorType() {
        return "mozilla::dom::HTMLContentCreatorFunction";
    }

    public String svgCreatorType() {
        return "mozilla::dom::SVGContentCreatorFunction";
    }

    public String creatorType() {
        return "nsHtml5ContentCreatorFunction";
    }

    public String xhtmlNamespaceLiteral() {
        return "kNameSpaceID_XHTML";
    }

    public String svgNamespaceLiteral() {
        return "kNameSpaceID_SVG";
    }

    public String xmlnsNamespaceLiteral() {
        return "kNameSpaceID_XMLNS";
    }

    public String xmlNamespaceLiteral() {
        return "kNameSpaceID_XML";
    }

    public String noNamespaceLiteral() {
        return "kNameSpaceID_None";
    }

    public String xlinkNamespaceLiteral() {
        return "kNameSpaceID_XLink";
    }

    public String mathmlNamespaceLiteral() {
        return "kNameSpaceID_MathML";
    }

    public String arrayTemplate() {
        return "jArray";
    }

    public String autoArrayTemplate() {
        return "autoJArray";
    }

    public String localForLiteral(String literal) {
        String atom = atomMap.get(literal);
        if (atom == null) {
            atom = createAtomName(literal);
            atomMap.put(literal, atom);
            if (atomWriter != null) {
                try {
                    atomWriter.write("// ATOM GENERATED BY HTML PARSER TRANSLATOR (WILL BE AUTOMATICALLY OVERWRITTEN):\nGK_ATOM(" + atom + ", \"" + literal
                            + "\")\n");
                } catch (IOException e) {
                    throw new RuntimeException(e);
                }
            }
        }
        return "nsGkAtoms::" + atom;
    }

    private String createAtomName(String literal) {
        String candidate = literal.replaceAll("[^a-zA-Z0-9_]", "_");
        if ("".equals(candidate)) {
            candidate = "emptystring";
        }
        while (atomMap.values().contains(candidate)
                || reservedWords.contains(candidate)) {
            candidate = candidate + '_';
        }
        return candidate;
    }

    public String stringForLiteral(String literal) {
        return '"' + literal + '"';
    }

    public String staticArrayTemplate() {
        return "staticJArray";
    }

    public String newArrayCreator() {
        return "newJArray";
    }

    public String[] boilerplateIncludes(String javaClass) {
        if ("TreeBuilder".equals(javaClass)) {
            return TREE_BUILDER_INCLUDES;
        } else if ("Tokenizer".equals(javaClass)) {
            return TOKENIZER_INCLUDES;
        } else {
            return INCLUDES;
        }
    }

    public String[] boilerplateDeclarations(String javaClass) {
        if ("TreeBuilder".equals(javaClass)) {
            return TREE_BUILDER_OTHER_DECLATIONS;
        } else {
            return OTHER_DECLATIONS;
        }
    }

    public String[] namedCharactersIncludes() {
        return NAMED_CHARACTERS_INCLUDES;
    }

    public String[] boilerplateForwardDeclarations() {
        return FORWARD_DECLARATIONS;
    }

    public String documentModeHandlerType() {
        return "nsHtml5TreeBuilder*";
    }

    public String documentModeType() {
        return "nsHtml5DocumentMode";
    }

    public String arrayCopy() {
        return "nsHtml5ArrayCopy::arraycopy";
    }

    public String maxInteger() {
        return "INT32_MAX";
    }

    public String constructorBoilerplate(String className) {
        return "MOZ_COUNT_CTOR(" + className + ");";
    }

    public String destructorBoilderplate(String className) {
        return "MOZ_COUNT_DTOR(" + className + ");";
    }

    public String literalType() {
        return "const char*";
    }

    public boolean hasSupplement(String javaClass) {
        return Arrays.binarySearch(CLASSES_THAT_NEED_SUPPLEMENT, javaClass) > -1;
    }

    public String internerType() {
        return "nsHtml5AtomTable*";
    }

    public String treeBuilderStateInterface() {
        return "nsAHtml5TreeBuilderState";
    }

    public String treeBuilderStateType() {
        return "nsAHtml5TreeBuilderState*";
    }

    public String arrayLengthMacro() {
        return "MOZ_ARRAY_LENGTH";
    }

    public String staticAssert() {
        return "PR_STATIC_ASSERT";
    }

    public String abortIfFalse() {
        return "NS_ABORT_IF_FALSE";
    }

    public String continueMacro() {
        return "NS_HTML5_CONTINUE";
    }

    public String breakMacro() {
        return "NS_HTML5_BREAK";
    }

    public String characterNameType() {
        return "nsHtml5CharacterName&";
    }

    public String characterNameTypeDeclaration() {
        return "nsHtml5CharacterName";
    }

    public String transition() {
        return "P::transition";
    }

    public String tokenizerErrorCondition() {
        return "P::reportErrors";
    }

    public String firstTransitionArg() {
        return "mViewSource";
    }

    public String errorHandler() {
        return this.unlikely() + "(mViewSource)";
    }

    public String unlikely() {
        return "MOZ_UNLIKELY";
    }

    public String completedCharacterReference() {
        return "P::completedNamedCharacterReference(mViewSource)";
    }

    public String[] stateLoopPolicies() {
        return STATE_LOOP_POLICIES;
    }

    public String assertionMacro() {
        return "MOZ_ASSERT";
    }

    public String releaseAssertionMacro() {
        return "MOZ_RELEASE_ASSERT";
    }

    public String crashMacro() {
        return "MOZ_CRASH";
    }
}
