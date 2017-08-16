/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/* parsing of CSS stylesheets, based on a token stream from the CSS scanner */

#ifndef nsCSSParser_h___
#define nsCSSParser_h___

#include "mozilla/Attributes.h"
#include "mozilla/css/Loader.h"

#include "nsCSSPropertyID.h"
#include "nsCSSScanner.h"
#include "nsCOMPtr.h"
#include "nsAutoPtr.h"
#include "nsStringFwd.h"
#include "nsTArrayForwardDeclare.h"

class nsIPrincipal;
class nsIURI;
struct nsCSSSelectorList;
class nsMediaList;
class nsMediaQuery;
class nsCSSKeyframeRule;
class nsCSSValue;
struct nsRuleData;

namespace mozilla {
class CSSStyleSheet;
class CSSVariableValues;
namespace css {
class Rule;
class Declaration;
class StyleRule;

enum class SupportsParsingSettings {
  Normal,
  ImpliedParentheses
};

} // namespace css
} // namespace mozilla

// Interface to the css parser.

class MOZ_STACK_CLASS nsCSSParser {
public:
  explicit nsCSSParser(mozilla::css::Loader* aLoader = nullptr,
                       mozilla::CSSStyleSheet* aSheet = nullptr);
  ~nsCSSParser();

  static void Startup();
  static void Shutdown();

private:
  nsCSSParser(nsCSSParser const&) = delete;
  nsCSSParser& operator=(nsCSSParser const&) = delete;

public:
  /**
   * Parse aInput into the stylesheet that was previously passed to the
   * constructor.  Calling this method on an nsCSSParser that had nullptr
   * passed in as the style sheet is an error.
   *
   * @param aInput the data to parse
   * @param aSheetURL the URI to use as the sheet URI (for error reporting).
   *                  This must match the URI of the sheet passed to
   *                  the constructor.
   * @param aBaseURI the URI to use for relative URI resolution
   * @param aSheetPrincipal the principal of the stylesheet.  This must match
   *                        the principal of the sheet passed to the
   *                        constructor.
   * @param aLineNumber the line number of the first line of the sheet.
   * @param aReusableSheets style sheets that can be reused by an @import.
   *                        This can be nullptr.
   */
  nsresult ParseSheet(const nsAString& aInput,
                      nsIURI*          aSheetURL,
                      nsIURI*          aBaseURI,
                      nsIPrincipal*    aSheetPrincipal,
                      uint32_t         aLineNumber,
                      mozilla::css::LoaderReusableStyleSheets* aReusableSheets =
                        nullptr);

  // Parse HTML style attribute or its equivalent in other markup
  // languages.  aBaseURL is the base url to use for relative links in
  // the declaration.
  already_AddRefed<mozilla::css::Declaration>
           ParseStyleAttribute(const nsAString&  aAttributeValue,
                               nsIURI*           aDocURL,
                               nsIURI*           aBaseURL,
                               nsIPrincipal*     aNodePrincipal);

  // Parse the body of a declaration block.  Very similar to
  // ParseStyleAttribute, but used under different circumstances.
  // The contents of aDeclaration will be erased and replaced with the
  // results of parsing; aChanged will be set true if the aDeclaration
  // argument was modified.
  nsresult ParseDeclarations(const nsAString&  aBuffer,
                             nsIURI*           aSheetURL,
                             nsIURI*           aBaseURL,
                             nsIPrincipal*     aSheetPrincipal,
                             mozilla::css::Declaration* aDeclaration,
                             bool*           aChanged);

  nsresult ParseRule(const nsAString&        aRule,
                     nsIURI*                 aSheetURL,
                     nsIURI*                 aBaseURL,
                     nsIPrincipal*           aSheetPrincipal,
                     mozilla::css::Rule**    aResult);

  // Parse the value of a single CSS property, and add or replace that
  // property in aDeclaration.
  //
  // SVG "mapped attributes" (which correspond directly to CSS
  // properties) are parsed slightly differently from regular CSS; in
  // particular, units may be omitted from <length>.  The 'aIsSVGMode'
  // argument controls this quirk.  Note that this *only* applies to
  // mapped attributes, not inline styles or full style sheets in SVG.
  void ParseProperty(const nsCSSPropertyID aPropID,
                     const nsAString&    aPropValue,
                     nsIURI*             aSheetURL,
                     nsIURI*             aBaseURL,
                     nsIPrincipal*       aSheetPrincipal,
                     mozilla::css::Declaration* aDeclaration,
                     bool*               aChanged,
                     bool                aIsImportant,
                     bool                aIsSVGMode = false);

  // Same as ParseProperty but returns an nsCSSValue in aResult
  // rather than storing the property in a Declaration.  aPropID
  // must be a longhand property.
  void ParseLonghandProperty(const nsCSSPropertyID aPropID,
                             const nsAString&    aPropValue,
                             nsIURI*             aSheetURL,
                             nsIURI*             aBaseURL,
                             nsIPrincipal*       aSheetPrincipal,
                             nsCSSValue&         aResult);

  // Parse the value of a CSS transform property. Returns
  // whether the value was successfully parsed. If
  // aDisallowRelativeValues is true then this method will
  // only successfully parse if all values are numbers or
  // have non-relative dimensions.
  bool ParseTransformProperty(const nsAString& aPropValue,
                              bool             aDisallowRelativeValues,
                              nsCSSValue&      aResult);

  // The same as ParseProperty but for a variable.
  void ParseVariable(const nsAString&    aVariableName,
                     const nsAString&    aPropValue,
                     nsIURI*             aSheetURL,
                     nsIURI*             aBaseURL,
                     nsIPrincipal*       aSheetPrincipal,
                     mozilla::css::Declaration* aDeclaration,
                     bool*               aChanged,
                     bool                aIsImportant);
  /**
   * Parse aBuffer into a media list |aMediaList|, which must be non-null,
   * replacing its current contents. |aURL| and |aLineNumber| are used for error
   * reporting.
   */
  void ParseMediaList(const nsSubstring& aBuffer,
                      nsIURI*            aURL,
                      uint32_t           aLineNumber,
                      nsMediaList*       aMediaList);

  /*
   * Parse aBuffer into a list of media queries and their associated values,
   * according to grammar:
   *    <source-size-list> = <source-size>#?
   *    <source-size> = <media-condition>? <length>
   *
   * Note that this grammar is top-level: The function expects to consume the
   * entire input buffer.
   *
   * Output arrays overwritten (not appended) and are cleared in case of parse
   * failure.
   */
  bool ParseSourceSizeList(const nsAString& aBuffer,
                           nsIURI* aURI, // for error reporting
                           uint32_t aLineNumber, // for error reporting
                           InfallibleTArray< nsAutoPtr<nsMediaQuery> >& aQueries,
                           InfallibleTArray<nsCSSValue>& aValues);

  /**
   * Parse aBuffer into a nsCSSValue |aValue|. Will return false
   * if aBuffer is not a valid font family list.
   */
  bool ParseFontFamilyListString(const nsSubstring& aBuffer,
                                 nsIURI*            aURL,
                                 uint32_t           aLineNumber,
                                 nsCSSValue&        aValue);

  /**
   * Parse aBuffer into a nsCSSValue |aValue|. Will return false
   * if aBuffer is not a valid CSS color specification.
   * One can use nsRuleNode::ComputeColor to compute an nscolor from
   * the returned nsCSSValue.
   */
  bool ParseColorString(const nsSubstring& aBuffer,
                        nsIURI*            aURL,
                        uint32_t           aLineNumber,
                        nsCSSValue&        aValue,
                        bool               aSuppressErrors = false);

  /**
   * Parse aBuffer into a nsCSSValue |aValue|. Will return false
   * if aBuffer is not a valid CSS margin specification.
   * One can use nsRuleNode::GetRectValue to compute an nsCSSRect from
   * the returned nsCSSValue.
   */
  bool ParseMarginString(const nsSubstring& aBuffer,
                         nsIURI*            aURL,
                         uint32_t           aLineNumber,
                         nsCSSValue&        aValue,
                         bool               aSuppressErrors = false);

  /**
   * Parse aBuffer into a selector list.  On success, caller must
   * delete *aSelectorList when done with it.
   */
  nsresult ParseSelectorString(const nsSubstring&  aSelectorString,
                               nsIURI*             aURL,
                               uint32_t            aLineNumber,
                               nsCSSSelectorList** aSelectorList);

  /*
   * Parse a keyframe rule (which goes inside an @keyframes rule).
   * Return it if the parse was successful.
   */
  already_AddRefed<nsCSSKeyframeRule>
  ParseKeyframeRule(const nsSubstring& aBuffer,
                    nsIURI*            aURL,
                    uint32_t           aLineNumber);

  /*
   * Parse a selector list for a keyframe rule.  Return whether
   * the parse succeeded.
   */
  bool ParseKeyframeSelectorString(const nsSubstring& aSelectorString,
                                   nsIURI*            aURL,
                                   uint32_t           aLineNumber,
                                   InfallibleTArray<float>& aSelectorList);

  /**
   * Parse a property and value and return whether the property/value pair
   * is supported.
   */
  bool EvaluateSupportsDeclaration(const nsAString& aProperty,
                                   const nsAString& aValue,
                                   nsIURI* aDocURL,
                                   nsIURI* aBaseURL,
                                   nsIPrincipal* aDocPrincipal);

  /**
   * Parse an @supports condition and returns the result of evaluating the
   * condition.
   *
   * The one-argument CSS.supports() allows for providing a parentheses-less
   * @supports condition, i.e. the parentheses are "implied". In such a case,
   * aSettings can be set to ImpliedParentheses.
   */
  bool EvaluateSupportsCondition(const nsAString& aCondition,
                                 nsIURI* aDocURL,
                                 nsIURI* aBaseURL,
                                 nsIPrincipal* aDocPrincipal,
                                 mozilla::css::SupportsParsingSettings aSettings
                                  = mozilla::css::SupportsParsingSettings::Normal);

  typedef void (*VariableEnumFunc)(const nsAString&, void*);

  /**
   * Parses aPropertyValue as a property value and calls aFunc for each
   * variable reference that is found.  Returns false if there was
   * a syntax error in the use of variable references.
   */
  bool EnumerateVariableReferences(const nsAString& aPropertyValue,
                                   VariableEnumFunc aFunc,
                                   void* aData);

  /**
   * Parses aPropertyValue as a property value and resolves variable references
   * using the values in aVariables.
   */
  bool ResolveVariableValue(const nsAString& aPropertyValue,
                            const mozilla::CSSVariableValues* aVariables,
                            nsString& aResult,
                            nsCSSTokenSerializationType& aFirstToken,
                            nsCSSTokenSerializationType& aLastToken);

  /**
   * Parses a string as a CSS token stream value for particular property,
   * resolving any variable references.  The parsed property value is stored
   * in the specified nsRuleData object.  If aShorthandPropertyID has a value
   * other than eCSSProperty_UNKNOWN, this is the property that will be parsed;
   * otherwise, aPropertyID will be parsed.  Either way, only aPropertyID,
   * a longhand property, will be copied over to the rule data.
   *
   * If the property cannot be parsed, it will be treated as if 'initial' or
   * 'inherit' were specified, for non-inherited and inherited properties
   * respectively.
   */
  void ParsePropertyWithVariableReferences(
                                   nsCSSPropertyID aPropertyID,
                                   nsCSSPropertyID aShorthandPropertyID,
                                   const nsAString& aValue,
                                   const mozilla::CSSVariableValues* aVariables,
                                   nsRuleData* aRuleData,
                                   nsIURI* aDocURL,
                                   nsIURI* aBaseURL,
                                   nsIPrincipal* aDocPrincipal,
                                   mozilla::CSSStyleSheet* aSheet,
                                   uint32_t aLineNumber,
                                   uint32_t aLineOffset);

  /**
   * Parses a string as a counter-style name. Returns nullptr if fails.
   */
  already_AddRefed<nsIAtom> ParseCounterStyleName(const nsAString& aBuffer,
                                                  nsIURI* aURL);

  bool ParseCounterDescriptor(nsCSSCounterDesc aDescID,
                              const nsAString& aBuffer,
                              nsIURI* aSheetURL,
                              nsIURI* aBaseURL,
                              nsIPrincipal* aSheetPrincipal,
                              nsCSSValue& aValue);

  bool ParseFontFaceDescriptor(nsCSSFontDesc aDescID,
                               const nsAString& aBuffer,
                               nsIURI* aSheetURL,
                               nsIURI* aBaseURL,
                               nsIPrincipal* aSheetPrincipal,
                               nsCSSValue& aValue);

  // Check whether a given value can be applied to a property.
  bool IsValueValidForProperty(const nsCSSPropertyID aPropID,
                               const nsAString&    aPropValue);

  // Return the default value to be used for -moz-control-character-visibility,
  // from preferences (cached by our Startup(), so that both nsStyleText and
  // nsRuleNode can have fast access to it).
  static uint8_t ControlCharVisibilityDefault();

protected:
  // This is a CSSParserImpl*, but if we expose that type name in this
  // header, we can't put the type definition (in nsCSSParser.cpp) in
  // the anonymous namespace.
  void* mImpl;
};

#endif /* nsCSSParser_h___ */
