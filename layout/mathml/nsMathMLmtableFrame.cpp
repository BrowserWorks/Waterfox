/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "nsMathMLmtableFrame.h"
#include "nsPresContext.h"
#include "nsStyleContext.h"
#include "nsStyleConsts.h"
#include "nsNameSpaceManager.h"
#include "nsRenderingContext.h"
#include "nsCSSRendering.h"
#include "nsMathMLElement.h"

#include "nsTArray.h"
#include "nsTableFrame.h"
#include "celldata.h"

#include "mozilla/RestyleManager.h"
#include "mozilla/RestyleManagerInlines.h"
#include <algorithm>

#include "nsIScriptError.h"
#include "nsContentUtils.h"

using namespace mozilla;
using namespace mozilla::image;

//
// <mtable> -- table or matrix - implementation
//

static int8_t
ParseStyleValue(nsIAtom* aAttribute, const nsAString& aAttributeValue)
{
  if (aAttribute == nsGkAtoms::rowalign_) {
    if (aAttributeValue.EqualsLiteral("top"))
      return NS_STYLE_VERTICAL_ALIGN_TOP;
    else if (aAttributeValue.EqualsLiteral("bottom"))
      return NS_STYLE_VERTICAL_ALIGN_BOTTOM;
    else if (aAttributeValue.EqualsLiteral("center"))
      return NS_STYLE_VERTICAL_ALIGN_MIDDLE;
    else
      return NS_STYLE_VERTICAL_ALIGN_BASELINE;
  } else if (aAttribute == nsGkAtoms::columnalign_) {
    if (aAttributeValue.EqualsLiteral("left"))
      return NS_STYLE_TEXT_ALIGN_LEFT;
    else if (aAttributeValue.EqualsLiteral("right"))
      return NS_STYLE_TEXT_ALIGN_RIGHT;
    else
      return NS_STYLE_TEXT_ALIGN_CENTER;
  } else if (aAttribute == nsGkAtoms::rowlines_ ||
             aAttribute == nsGkAtoms::columnlines_) {
    if (aAttributeValue.EqualsLiteral("solid"))
      return NS_STYLE_BORDER_STYLE_SOLID;
    else if (aAttributeValue.EqualsLiteral("dashed"))
      return NS_STYLE_BORDER_STYLE_DASHED;
    else
      return NS_STYLE_BORDER_STYLE_NONE;
  } else {
    MOZ_CRASH("Unrecognized attribute.");
  }

  return -1;
}

static nsTArray<int8_t>*
ExtractStyleValues(const nsAString& aString,
                   nsIAtom* aAttribute,
                   bool aAllowMultiValues)
{
  nsTArray<int8_t>* styleArray = nullptr;

  const char16_t* start = aString.BeginReading();
  const char16_t* end = aString.EndReading();

  int32_t startIndex = 0;
  int32_t count = 0;

  while (start < end) {
    // Skip leading spaces.
    while ((start < end) && nsCRT::IsAsciiSpace(*start)) {
      start++;
      startIndex++;
    }

    // Look for the end of the string, or another space.
    while ((start < end) && !nsCRT::IsAsciiSpace(*start)) {
      start++;
      count++;
    }

    // Grab the value found and process it.
    if (count > 0) {
      if (!styleArray)
        styleArray = new nsTArray<int8_t>();

      // We want to return a null array if an attribute gives multiple values,
      // but multiple values aren't allowed.
      if (styleArray->Length() > 1 && !aAllowMultiValues) {
        delete styleArray;
        return nullptr;
      }

      nsDependentSubstring valueString(aString, startIndex, count);
      int8_t styleValue = ParseStyleValue(aAttribute, valueString);
      styleArray->AppendElement(styleValue);

      startIndex += count;
      count = 0;
    }
  }
  return styleArray;
}

static nsresult
ReportParseError(nsIFrame* aFrame,
                 const char16_t* aAttribute,
                 const char16_t* aValue)
{
  nsIContent* content = aFrame->GetContent();

  const char16_t* params[] =
    { aValue, aAttribute, content->NodeInfo()->NameAtom()->GetUTF16String() };

  return nsContentUtils::ReportToConsole(nsIScriptError::errorFlag,
                                         NS_LITERAL_CSTRING("Layout: MathML"),
                                         content->OwnerDoc(),
                                         nsContentUtils::eMATHML_PROPERTIES,
                                         "AttributeParsingError", params, 3);
}

// Each rowalign='top bottom' or columnalign='left right center' (from
// <mtable> or <mtr>) is split once into an nsTArray<int8_t> which is
// stored in the property table. Row/Cell frames query the property table
// to see what values apply to them.

NS_DECLARE_FRAME_PROPERTY_DELETABLE(RowAlignProperty, nsTArray<int8_t>)
NS_DECLARE_FRAME_PROPERTY_DELETABLE(RowLinesProperty, nsTArray<int8_t>)
NS_DECLARE_FRAME_PROPERTY_DELETABLE(ColumnAlignProperty, nsTArray<int8_t>)
NS_DECLARE_FRAME_PROPERTY_DELETABLE(ColumnLinesProperty, nsTArray<int8_t>)

static const FramePropertyDescriptor<nsTArray<int8_t>>*
AttributeToProperty(nsIAtom* aAttribute)
{
  if (aAttribute == nsGkAtoms::rowalign_)
    return RowAlignProperty();
  if (aAttribute == nsGkAtoms::rowlines_)
    return RowLinesProperty();
  if (aAttribute == nsGkAtoms::columnalign_)
    return ColumnAlignProperty();
  NS_ASSERTION(aAttribute == nsGkAtoms::columnlines_, "Invalid attribute");
  return ColumnLinesProperty();
}

/* This method looks for a property that applies to a cell, but it looks
 * recursively because some cell properties can come from the cell, a row,
 * a table, etc. This function searches through the hierarchy for a property
 * and returns its value. The function stops searching after checking a <mtable>
 * frame.
 */
static nsTArray<int8_t>*
FindCellProperty(const nsIFrame* aCellFrame,
                 const FramePropertyDescriptor<nsTArray<int8_t>>* aFrameProperty)
{
  const nsIFrame* currentFrame = aCellFrame;
  nsTArray<int8_t>* propertyData = nullptr;

  while (currentFrame) {
    propertyData = currentFrame->GetProperty(aFrameProperty);
    bool frameIsTable = (currentFrame->IsTableFrame());

    if (propertyData || frameIsTable)
      currentFrame = nullptr; // A null frame pointer exits the loop
    else
      currentFrame = currentFrame->GetParent(); // Go to the parent frame
  }

  return propertyData;
}

static void
ApplyBorderToStyle(const nsMathMLmtdFrame* aFrame,
                   nsStyleBorder& aStyleBorder)
{
  int32_t rowIndex;
  int32_t columnIndex;
  aFrame->GetRowIndex(rowIndex);
  aFrame->GetColIndex(columnIndex);

  nscoord borderWidth =
    nsPresContext::GetBorderWidthForKeyword(NS_STYLE_BORDER_WIDTH_THIN);

  nsTArray<int8_t>* rowLinesList =
    FindCellProperty(aFrame, RowLinesProperty());

  nsTArray<int8_t>* columnLinesList =
    FindCellProperty(aFrame, ColumnLinesProperty());

  // We don't place a row line on top of the first row
  if (rowIndex > 0 && rowLinesList) {
    // If the row number is greater than the number of provided rowline
    // values, we simply repeat the last value.
    int32_t listLength = rowLinesList->Length();
    if (rowIndex < listLength) {
      aStyleBorder.SetBorderStyle(eSideTop,
                    rowLinesList->ElementAt(rowIndex - 1));
    } else {
      aStyleBorder.SetBorderStyle(eSideTop,
                    rowLinesList->ElementAt(listLength - 1));
    }
    aStyleBorder.SetBorderWidth(eSideTop, borderWidth);
  }

  // We don't place a column line on the left of the first column.
  if (columnIndex > 0 && columnLinesList) {
    // If the column number is greater than the number of provided columline
    // values, we simply repeat the last value.
    int32_t listLength = columnLinesList->Length();
    if (columnIndex < listLength) {
      aStyleBorder.SetBorderStyle(eSideLeft,
                    columnLinesList->ElementAt(columnIndex - 1));
    } else {
      aStyleBorder.SetBorderStyle(eSideLeft,
                    columnLinesList->ElementAt(listLength - 1));
    }
    aStyleBorder.SetBorderWidth(eSideLeft, borderWidth);
  }
}

static nsMargin
ComputeBorderOverflow(nsMathMLmtdFrame* aFrame,
                      const nsStyleBorder& aStyleBorder)
{
  nsMargin overflow;
  int32_t rowIndex;
  int32_t columnIndex;
  nsTableFrame* table = aFrame->GetTableFrame();
  aFrame->GetCellIndexes(rowIndex, columnIndex);
  if (!columnIndex) {
    overflow.left = table->GetColSpacing(-1);
    overflow.right = table->GetColSpacing(0) / 2;
  } else if (columnIndex == table->GetColCount() - 1) {
    overflow.left = table->GetColSpacing(columnIndex - 1) / 2;
    overflow.right =  table->GetColSpacing(columnIndex + 1);
  } else {
    overflow.left = table->GetColSpacing(columnIndex - 1) / 2;
    overflow.right = table->GetColSpacing(columnIndex) / 2;
  }
  if (!rowIndex) {
    overflow.top = table->GetRowSpacing(-1);
    overflow.bottom = table->GetRowSpacing(0) / 2;
  } else if (rowIndex == table->GetRowCount() - 1) {
    overflow.top = table->GetRowSpacing(rowIndex - 1) / 2;
    overflow.bottom = table->GetRowSpacing(rowIndex + 1);
  } else {
    overflow.top = table->GetRowSpacing(rowIndex - 1) / 2;
    overflow.bottom = table->GetRowSpacing(rowIndex) / 2;
  }
  return overflow;
}

/*
 * A variant of the nsDisplayBorder contains special code to render a border
 * around a nsMathMLmtdFrame based on the rowline and columnline properties
 * set on the cell frame.
 */
class nsDisplaymtdBorder : public nsDisplayBorder
{
public:
  nsDisplaymtdBorder(nsDisplayListBuilder* aBuilder, nsMathMLmtdFrame* aFrame)
    : nsDisplayBorder(aBuilder, aFrame)
  {
  }

  nsDisplayItemGeometry* AllocateGeometry(nsDisplayListBuilder* aBuilder) override
  {
    return new nsDisplayItemGenericImageGeometry(this, aBuilder);
  }

  void ComputeInvalidationRegion(nsDisplayListBuilder* aBuilder,
                                 const nsDisplayItemGeometry* aGeometry,
                                 nsRegion* aInvalidRegion) override
  {
    auto geometry =
      static_cast<const nsDisplayItemGenericImageGeometry*>(aGeometry);
  
    if (aBuilder->ShouldSyncDecodeImages() &&
        geometry->ShouldInvalidateToSyncDecodeImages()) {
      bool snap;
      aInvalidRegion->Or(*aInvalidRegion, GetBounds(aBuilder, &snap));
    }
  
    nsDisplayItem::ComputeInvalidationRegion(aBuilder, aGeometry, aInvalidRegion);
  }

  virtual nsRect GetBounds(nsDisplayListBuilder* aBuilder, bool* aSnap) override
  {
    *aSnap = true;
    nsStyleBorder styleBorder = *mFrame->StyleBorder();
    nsMathMLmtdFrame* frame = static_cast<nsMathMLmtdFrame*>(mFrame);
    ApplyBorderToStyle(frame, styleBorder);
    nsRect bounds = CalculateBounds(styleBorder).GetBounds();
    nsMargin overflow = ComputeBorderOverflow(frame, styleBorder);
    bounds.Inflate(overflow);
    return bounds;
  }

  virtual void Paint(nsDisplayListBuilder* aBuilder, nsRenderingContext* aCtx) override
  {
    nsStyleBorder styleBorder = *mFrame->StyleBorder();
    nsMathMLmtdFrame* frame = static_cast<nsMathMLmtdFrame*>(mFrame);
    ApplyBorderToStyle(frame, styleBorder);

    nsRect bounds = nsRect(ToReferenceFrame(), mFrame->GetSize());
    nsMargin overflow = ComputeBorderOverflow(frame, styleBorder);
    bounds.Inflate(overflow);

    PaintBorderFlags flags = aBuilder->ShouldSyncDecodeImages()
                           ? PaintBorderFlags::SYNC_DECODE_IMAGES
                           : PaintBorderFlags();

    DrawResult result =
      nsCSSRendering::PaintBorderWithStyleBorder(mFrame->PresContext(), *aCtx,
                                                 mFrame, mVisibleRect,
                                                 bounds,
                                                 styleBorder,
                                                 mFrame->StyleContext(),
                                                 flags,
                                                 mFrame->GetSkipSides());

    nsDisplayItemGenericImageGeometry::UpdateDrawResult(this, result);
  }
};

#ifdef DEBUG
#define DEBUG_VERIFY_THAT_FRAME_IS(_frame, _expected)                              \
  MOZ_ASSERT(mozilla::StyleDisplay::_expected == _frame->StyleDisplay()->mDisplay, \
             "internal error");
#else
#define DEBUG_VERIFY_THAT_FRAME_IS(_frame, _expected)
#endif

static void
ParseFrameAttribute(nsIFrame* aFrame,
                    nsIAtom* aAttribute,
                    bool aAllowMultiValues)
{
  nsAutoString attrValue;

  nsIContent* frameContent = aFrame->GetContent();
  frameContent->GetAttr(kNameSpaceID_None, aAttribute, attrValue);

  if (!attrValue.IsEmpty()) {
    nsTArray<int8_t>* valueList =
      ExtractStyleValues(attrValue, aAttribute, aAllowMultiValues);

    // If valueList is null, that indicates a problem with the attribute value.
    // Only set properties on a valid attribute value.
    if (valueList) {
      // The code reading the property assumes that this list is nonempty.
      NS_ASSERTION(valueList->Length() >= 1, "valueList should not be empty!");
      aFrame->SetProperty(AttributeToProperty(aAttribute), valueList);
    } else {
      ReportParseError(aFrame, aAttribute->GetUTF16String(), attrValue.get());
    }
  }
}

// rowspacing
//
// Specifies the distance between successive rows in an mtable.  Multiple
// lengths can be specified, each corresponding to its respective position
// between rows.  For example:
//
// [ROW_0]
// rowspace_0
// [ROW_1]
// rowspace_1
// [ROW_2]
//
// If the number of row gaps exceeds the number of lengths specified, the final
// specified length is repeated.  Additional lengths are ignored.
//
// values: (length)+
// default: 1.0ex
//
// Unitless values are permitted and provide a multiple of the default value
// Negative values are forbidden.
//

// columnspacing
//
// Specifies the distance between successive columns in an mtable.  Multiple
// lengths can be specified, each corresponding to its respective position
// between columns.  For example:
//
// [COLUMN_0] columnspace_0 [COLUMN_1] columnspace_1 [COLUMN_2]
//
// If the number of column gaps exceeds the number of lengths specified, the
// final specified length is repeated.  Additional lengths are ignored.
//
// values: (length)+
// default: 0.8em
//
// Unitless values are permitted and provide a multiple of the default value
// Negative values are forbidden.
//

// framespacing
//
// Specifies the distance between the mtable and its frame (if any).  The
// first value specified provides the spacing between the left and right edge
// of the table and the frame, the second value determines the spacing between
// the top and bottom edges and the frame.
//
// An error is reported if only one length is passed.  Any additional lengths
// are ignored
//
// values: length length
// default: 0em   0ex    If frame attribute is "none" or not specified,
//          0.4em 0.5ex  otherwise
//
// Unitless values are permitted and provide a multiple of the default value
// Negative values are forbidden.
//

static const float kDefaultRowspacingEx = 1.0f;
static const float kDefaultColumnspacingEm = 0.8f;
static const float kDefaultFramespacingArg0Em = 0.4f;
static const float kDefaultFramespacingArg1Ex = 0.5f;

static void
ExtractSpacingValues(const nsAString&   aString,
                     nsIAtom*           aAttribute,
                     nsTArray<nscoord>& aSpacingArray,
                     nsIFrame*          aFrame,
                     nscoord            aDefaultValue0,
                     nscoord            aDefaultValue1,
                     float              aFontSizeInflation)
{
  nsPresContext* presContext = aFrame->PresContext();
  nsStyleContext* styleContext = aFrame->StyleContext();

  const char16_t* start = aString.BeginReading();
  const char16_t* end = aString.EndReading();

  int32_t startIndex = 0;
  int32_t count = 0;
  int32_t elementNum = 0;

  while (start < end) {
    // Skip leading spaces.
    while ((start < end) && nsCRT::IsAsciiSpace(*start)) {
      start++;
      startIndex++;
    }

    // Look for the end of the string, or another space.
    while ((start < end) && !nsCRT::IsAsciiSpace(*start)) {
      start++;
      count++;
    }

    // Grab the value found and process it.
    if (count > 0) {
      const nsAString& str = Substring(aString, startIndex, count);
      nsAutoString valueString;
      valueString.Assign(str);
      nscoord newValue;
      if (aAttribute == nsGkAtoms::framespacing_ && elementNum) {
        newValue = aDefaultValue1;
      } else {
        newValue = aDefaultValue0;
      }
      nsMathMLFrame::ParseNumericValue(valueString, &newValue,
                                       nsMathMLElement::PARSE_ALLOW_UNITLESS,
                                       presContext, styleContext,
                                       aFontSizeInflation);
      aSpacingArray.AppendElement(newValue);

      startIndex += count;
      count = 0;
      elementNum++;
    }
  }
}

static void
ParseSpacingAttribute(nsMathMLmtableFrame* aFrame, nsIAtom* aAttribute)
{
  NS_ASSERTION(aAttribute == nsGkAtoms::rowspacing_ ||
               aAttribute == nsGkAtoms::columnspacing_ ||
               aAttribute == nsGkAtoms::framespacing_,
               "Non spacing attribute passed");

  nsAutoString attrValue;
  nsIContent* frameContent = aFrame->GetContent();
  frameContent->GetAttr(kNameSpaceID_None, aAttribute, attrValue);

  if (nsGkAtoms::framespacing_ == aAttribute) {
    nsAutoString frame;
    frameContent->GetAttr(kNameSpaceID_None, nsGkAtoms::frame, frame);
    if (frame.IsEmpty() || frame.EqualsLiteral("none")) {
      aFrame->SetFrameSpacing(0, 0);
      return;
    }
  }

  nscoord value;
  nscoord value2;
  // Set defaults
  float fontSizeInflation = nsLayoutUtils::FontSizeInflationFor(aFrame);
  RefPtr<nsFontMetrics> fm =
    nsLayoutUtils::GetFontMetricsForFrame(aFrame, fontSizeInflation);
  if (nsGkAtoms::rowspacing_ == aAttribute) {
    value = kDefaultRowspacingEx * fm->XHeight();
    value2 = 0;
  } else if (nsGkAtoms::columnspacing_ == aAttribute) {
    value = kDefaultColumnspacingEm * fm->EmHeight();
    value2 = 0;
  } else {
    value = kDefaultFramespacingArg0Em * fm->EmHeight();
    value2 = kDefaultFramespacingArg1Ex * fm->XHeight();
  }

  nsTArray<nscoord> valueList;
  ExtractSpacingValues(attrValue, aAttribute, valueList, aFrame, value, value2,
                       fontSizeInflation);
  if (valueList.Length() == 0) {
    if (frameContent->HasAttr(kNameSpaceID_None, aAttribute)) {
      ReportParseError(aFrame, aAttribute->GetUTF16String(),
                       attrValue.get());
    }
    valueList.AppendElement(value);
  }
  if (aAttribute == nsGkAtoms::framespacing_) {
    if (valueList.Length() == 1) {
      if(frameContent->HasAttr(kNameSpaceID_None, aAttribute)) {
        ReportParseError(aFrame, aAttribute->GetUTF16String(),
                         attrValue.get());
      }
      valueList.AppendElement(value2);
    } else if (valueList.Length() != 2) {
      ReportParseError(aFrame, aAttribute->GetUTF16String(),
                       attrValue.get());
    }
  }

  if (aAttribute == nsGkAtoms::rowspacing_) {
    aFrame->SetRowSpacingArray(valueList);
  } else if (aAttribute == nsGkAtoms::columnspacing_) {
    aFrame->SetColSpacingArray(valueList);
  } else {
      aFrame->SetFrameSpacing(valueList.ElementAt(0),
                              valueList.ElementAt(1));
  }
}

static void ParseSpacingAttributes(nsMathMLmtableFrame* aTableFrame)
{
  ParseSpacingAttribute(aTableFrame, nsGkAtoms::rowspacing_);
  ParseSpacingAttribute(aTableFrame, nsGkAtoms::columnspacing_);
  ParseSpacingAttribute(aTableFrame, nsGkAtoms::framespacing_);
  aTableFrame->SetUseCSSSpacing();
}

// map all attributes within a table -- requires the indices of rows and cells.
// so it can only happen after they are made ready by the table base class.
static void
MapAllAttributesIntoCSS(nsMathMLmtableFrame* aTableFrame)
{
  // Map mtable rowalign & rowlines.
  ParseFrameAttribute(aTableFrame, nsGkAtoms::rowalign_, true);
  ParseFrameAttribute(aTableFrame, nsGkAtoms::rowlines_, true);

  // Map mtable columnalign & columnlines.
  ParseFrameAttribute(aTableFrame, nsGkAtoms::columnalign_, true);
  ParseFrameAttribute(aTableFrame, nsGkAtoms::columnlines_, true);

  // Map mtable rowspacing, columnspacing & framespacing
  ParseSpacingAttributes(aTableFrame);

  // mtable is simple and only has one (pseudo) row-group
  nsIFrame* rgFrame = aTableFrame->PrincipalChildList().FirstChild();
  if (!rgFrame || !rgFrame->IsTableRowGroupFrame())
    return;

  for (nsIFrame* rowFrame : rgFrame->PrincipalChildList()) {
    DEBUG_VERIFY_THAT_FRAME_IS(rowFrame, TableRow);
    if (rowFrame->IsTableRowFrame()) {
      // Map row rowalign.
      ParseFrameAttribute(rowFrame, nsGkAtoms::rowalign_, false);
      // Map row columnalign.
      ParseFrameAttribute(rowFrame, nsGkAtoms::columnalign_, true);

      for (nsIFrame* cellFrame : rowFrame->PrincipalChildList()) {
        DEBUG_VERIFY_THAT_FRAME_IS(cellFrame, TableCell);
        if (IS_TABLE_CELL(cellFrame->Type())) {
          // Map cell rowalign.
          ParseFrameAttribute(cellFrame, nsGkAtoms::rowalign_, false);
          // Map row columnalign.
          ParseFrameAttribute(cellFrame, nsGkAtoms::columnalign_, false);
        }
      }
    }
  }
}

// the align attribute of mtable can have a row number which indicates
// from where to anchor the table, e.g., top 5 means anchor the table at
// the top of the 5th row, axis -1 means anchor the table on the axis of
// the last row

// The REC says that the syntax is 
// '\s*(top|bottom|center|baseline|axis)(\s+-?[0-9]+)?\s*' 
// the parsing could have been simpler with that syntax
// but for backward compatibility we make optional 
// the whitespaces between the alignment name and the row number

enum eAlign {
  eAlign_top,
  eAlign_bottom,
  eAlign_center,
  eAlign_baseline,
  eAlign_axis
};

static void
ParseAlignAttribute(nsString& aValue, eAlign& aAlign, int32_t& aRowIndex)
{
  // by default, the table is centered about the axis
  aRowIndex = 0;
  aAlign = eAlign_axis;
  int32_t len = 0;

  // we only have to remove the leading spaces because 
  // ToInteger ignores the whitespaces around the number
  aValue.CompressWhitespace(true, false);

  if (0 == aValue.Find("top")) {
    len = 3; // 3 is the length of 'top'
    aAlign = eAlign_top;
  }
  else if (0 == aValue.Find("bottom")) {
    len = 6; // 6 is the length of 'bottom'
    aAlign = eAlign_bottom;
  }
  else if (0 == aValue.Find("center")) {
    len = 6; // 6 is the length of 'center'
    aAlign = eAlign_center;
  }
  else if (0 == aValue.Find("baseline")) {
    len = 8; // 8 is the length of 'baseline'
    aAlign = eAlign_baseline;
  }
  else if (0 == aValue.Find("axis")) {
    len = 4; // 4 is the length of 'axis'
    aAlign = eAlign_axis;
  }
  if (len) {
    nsresult error;
    aValue.Cut(0, len); // aValue is not a const here
    aRowIndex = aValue.ToInteger(&error);
    if (NS_FAILED(error))
      aRowIndex = 0;
  }
}

#ifdef DEBUG_rbs_off
// call ListMathMLTree(mParent) to get the big picture
static void
ListMathMLTree(nsIFrame* atLeast)
{
  // climb up to <math> or <body> if <math> isn't there
  nsIFrame* f = atLeast;
  for ( ; f; f = f->GetParent()) {
    nsIContent* c = f->GetContent();
    if (!c || c->IsMathMLElement(nsGkAtoms::math) ||
        c->NodeInfo()->NameAtom(nsGkAtoms::body))  // XXXbaku which kind of body tag?
      break;
  }
  if (!f) f = atLeast;
  f->List(stdout, 0);
}
#endif

// --------
// implementation of nsMathMLmtableWrapperFrame

NS_QUERYFRAME_HEAD(nsMathMLmtableWrapperFrame)
  NS_QUERYFRAME_ENTRY(nsIMathMLFrame)
NS_QUERYFRAME_TAIL_INHERITING(nsTableWrapperFrame)

nsContainerFrame*
NS_NewMathMLmtableOuterFrame (nsIPresShell* aPresShell, nsStyleContext* aContext)
{
  return new (aPresShell) nsMathMLmtableWrapperFrame(aContext);
}

NS_IMPL_FRAMEARENA_HELPERS(nsMathMLmtableWrapperFrame)
 
nsMathMLmtableWrapperFrame::~nsMathMLmtableWrapperFrame()
{
}

nsresult
nsMathMLmtableWrapperFrame::AttributeChanged(int32_t  aNameSpaceID,
                                             nsIAtom* aAttribute,
                                             int32_t  aModType)
{
  // Attributes specific to <mtable>:
  // frame         : in mathml.css
  // framespacing  : here
  // groupalign    : not yet supported
  // equalrows     : not yet supported 
  // equalcolumns  : not yet supported 
  // displaystyle  : here and in mathml.css
  // align         : in reflow 
  // rowalign      : here
  // rowlines      : here 
  // rowspacing    : here
  // columnalign   : here 
  // columnlines   : here 
  // columnspacing : here

  // mtable is simple and only has one (pseudo) row-group inside our inner-table
  nsIFrame* tableFrame = mFrames.FirstChild();
  NS_ASSERTION(tableFrame && tableFrame->IsTableFrame(),
               "should always have an inner table frame");
  nsIFrame* rgFrame = tableFrame->PrincipalChildList().FirstChild();
  if (!rgFrame || !rgFrame->IsTableRowGroupFrame())
    return NS_OK;

  // align - just need to issue a dirty (resize) reflow command
  if (aAttribute == nsGkAtoms::align) {
    PresContext()->PresShell()->
      FrameNeedsReflow(this, nsIPresShell::eResize, NS_FRAME_IS_DIRTY);
    return NS_OK;
  }

  // displaystyle - may seem innocuous, but it is actually very harsh --
  // like changing an unit. Blow away and recompute all our automatic
  // presentational data, and issue a style-changed reflow request
  if (aAttribute == nsGkAtoms::displaystyle_) {
    nsMathMLContainerFrame::RebuildAutomaticDataForChildren(GetParent());
    // Need to reflow the parent, not us, because this can actually
    // affect siblings.
    PresContext()->PresShell()->
      FrameNeedsReflow(GetParent(), nsIPresShell::eStyleChange, NS_FRAME_IS_DIRTY);
    return NS_OK;
  }

  // ...and the other attributes affect rows or columns in one way or another

  nsPresContext* presContext = tableFrame->PresContext();
  if (aAttribute == nsGkAtoms::rowspacing_ ||
      aAttribute == nsGkAtoms::columnspacing_ ||
      aAttribute == nsGkAtoms::framespacing_ ) {
    nsMathMLmtableFrame* mathMLmtableFrame = do_QueryFrame(tableFrame);
    if (mathMLmtableFrame) {
      ParseSpacingAttribute(mathMLmtableFrame, aAttribute);
      mathMLmtableFrame->SetUseCSSSpacing();
    }
  } else if (aAttribute == nsGkAtoms::rowalign_ ||
             aAttribute == nsGkAtoms::rowlines_ ||
             aAttribute == nsGkAtoms::columnalign_ ||
             aAttribute == nsGkAtoms::columnlines_) {
    // clear any cached property list for this table
    tableFrame->DeleteProperty(AttributeToProperty(aAttribute));
    // Reparse the new attribute on the table.
    ParseFrameAttribute(tableFrame, aAttribute, true);
  } else {
    // Ignore attributes that do not affect layout.
    return NS_OK;
  }

  // Explicitly request a reflow in our subtree to pick up any changes
  presContext->PresShell()->
      FrameNeedsReflow(this, nsIPresShell::eStyleChange, NS_FRAME_IS_DIRTY);

  return NS_OK;
}

nsIFrame*
nsMathMLmtableWrapperFrame::GetRowFrameAt(int32_t aRowIndex)
{
  int32_t rowCount = GetRowCount();

  // Negative indices mean to find upwards from the end.
  if (aRowIndex < 0) {
    aRowIndex = rowCount + aRowIndex;
  } else {
    // aRowIndex is 1-based, so convert it to a 0-based index
    --aRowIndex;
  }

  // if our inner table says that the index is valid, find the row now
  if (0 <= aRowIndex && aRowIndex <= rowCount) {
    nsIFrame* tableFrame = mFrames.FirstChild();
    NS_ASSERTION(tableFrame && tableFrame->IsTableFrame(),
                 "should always have an inner table frame");
    nsIFrame* rgFrame = tableFrame->PrincipalChildList().FirstChild();
    if (!rgFrame || !rgFrame->IsTableRowGroupFrame())
      return nullptr;
    for (nsIFrame* rowFrame : rgFrame->PrincipalChildList()) {
      if (aRowIndex == 0) {
        DEBUG_VERIFY_THAT_FRAME_IS(rowFrame, TableRow);
        if (!rowFrame->IsTableRowFrame())
          return nullptr;

        return rowFrame;
      }
      --aRowIndex;
    }
  }
  return nullptr;
}

void
nsMathMLmtableWrapperFrame::Reflow(nsPresContext*           aPresContext,
                                   ReflowOutput&     aDesiredSize,
                                   const ReflowInput& aReflowInput,
                                   nsReflowStatus&          aStatus)
{
  nsAutoString value;
  // we want to return a table that is anchored according to the align attribute

  nsTableWrapperFrame::Reflow(aPresContext, aDesiredSize, aReflowInput, aStatus);
  NS_ASSERTION(aDesiredSize.Height() >= 0, "illegal height for mtable");
  NS_ASSERTION(aDesiredSize.Width() >= 0, "illegal width for mtable");

  // see if the user has set the align attribute on the <mtable>
  int32_t rowIndex = 0;
  eAlign tableAlign = eAlign_axis;
  mContent->GetAttr(kNameSpaceID_None, nsGkAtoms::align, value);
  if (!value.IsEmpty()) {
    ParseAlignAttribute(value, tableAlign, rowIndex);
  }

  // adjustments if there is a specified row from where to anchor the table
  // (conceptually: when there is no row of reference, picture the table as if
  // it is wrapped in a single big fictional row at dy = 0, this way of
  // doing so allows us to have a single code path for all cases).
  nscoord dy = 0;
  WritingMode wm = aDesiredSize.GetWritingMode();
  nscoord blockSize = aDesiredSize.BSize(wm);
  nsIFrame* rowFrame = nullptr;
  if (rowIndex) {
    rowFrame = GetRowFrameAt(rowIndex);
    if (rowFrame) {
      // translate the coordinates to be relative to us and in our writing mode
      nsIFrame* frame = rowFrame;
      LogicalRect rect(wm, frame->GetRect(),
                       aReflowInput.ComputedSizeAsContainerIfConstrained());
      blockSize = rect.BSize(wm);
      do {
        nsIFrame* parent = frame->GetParent();
        dy += frame->BStart(wm, parent->GetSize());
        frame = parent;
      } while (frame != this);
    }
  }
  switch (tableAlign) {
    case eAlign_top:
      aDesiredSize.SetBlockStartAscent(dy);
      break;
    case eAlign_bottom:
      aDesiredSize.SetBlockStartAscent(dy + blockSize);
      break;
    case eAlign_center:
      aDesiredSize.SetBlockStartAscent(dy + blockSize / 2);
      break;
    case eAlign_baseline:
      if (rowFrame) {
        // anchor the table on the baseline of the row of reference
        nscoord rowAscent = ((nsTableRowFrame*)rowFrame)->GetMaxCellAscent();
        if (rowAscent) { // the row has at least one cell with 'vertical-align: baseline'
          aDesiredSize.SetBlockStartAscent(dy + rowAscent);
          break;
        }
      }
      // in other situations, fallback to center
      aDesiredSize.SetBlockStartAscent(dy + blockSize / 2);
      break;
    case eAlign_axis:
    default: {
      // XXX should instead use style data from the row of reference here ?
      RefPtr<nsFontMetrics> fm =
        nsLayoutUtils::GetInflatedFontMetricsForFrame(this);
      nscoord axisHeight;
      GetAxisHeight(aReflowInput.mRenderingContext->GetDrawTarget(), fm, axisHeight);
      if (rowFrame) {
        // anchor the table on the axis of the row of reference
        // XXX fallback to baseline because it is a hard problem
        // XXX need to fetch the axis of the row; would need rowalign=axis to work better
        nscoord rowAscent = ((nsTableRowFrame*)rowFrame)->GetMaxCellAscent();
        if (rowAscent) { // the row has at least one cell with 'vertical-align: baseline'
          aDesiredSize.SetBlockStartAscent(dy + rowAscent);
          break;
        }
      }
      // in other situations, fallback to using half of the height
      aDesiredSize.SetBlockStartAscent(dy + blockSize / 2 + axisHeight);
    }
  }

  mReference.x = 0;
  mReference.y = aDesiredSize.BlockStartAscent();

  // just make-up a bounding metrics
  mBoundingMetrics = nsBoundingMetrics();
  mBoundingMetrics.ascent = aDesiredSize.BlockStartAscent();
  mBoundingMetrics.descent = aDesiredSize.Height() -
                             aDesiredSize.BlockStartAscent();
  mBoundingMetrics.width = aDesiredSize.Width();
  mBoundingMetrics.leftBearing = 0;
  mBoundingMetrics.rightBearing = aDesiredSize.Width();

  aDesiredSize.mBoundingMetrics = mBoundingMetrics;
  NS_FRAME_SET_TRUNCATION(aStatus, aReflowInput, aDesiredSize);
}

nsContainerFrame*
NS_NewMathMLmtableFrame(nsIPresShell* aPresShell, nsStyleContext* aContext)
{
  return new (aPresShell) nsMathMLmtableFrame(aContext);
}

NS_IMPL_FRAMEARENA_HELPERS(nsMathMLmtableFrame)

nsMathMLmtableFrame::~nsMathMLmtableFrame()
{
}

void
nsMathMLmtableFrame::SetInitialChildList(ChildListID  aListID,
                                         nsFrameList& aChildList)
{
  nsTableFrame::SetInitialChildList(aListID, aChildList);
  MapAllAttributesIntoCSS(this);
}

void
nsMathMLmtableFrame::RestyleTable()
{
  // re-sync MathML specific style data that may have changed
  MapAllAttributesIntoCSS(this);

  // Explicitly request a re-resolve and reflow in our subtree to pick up any changes
  PresContext()->RestyleManager()->
    PostRestyleEvent(mContent->AsElement(), eRestyle_Subtree,
                     nsChangeHint_AllReflowHints);
}

nscoord
nsMathMLmtableFrame::GetColSpacing(int32_t aColIndex)
{
  if (mUseCSSSpacing) {
    return nsTableFrame::GetColSpacing(aColIndex);
  }
  if (!mColSpacing.Length()) {
    NS_ERROR("mColSpacing should not be empty");
    return 0;
  }
  if (aColIndex < 0 || aColIndex >= GetColCount()) {
    NS_ASSERTION(aColIndex == -1 || aColIndex == GetColCount(),
                 "Desired column beyond bounds of table and border");
    return mFrameSpacingX;
  }
  if ((uint32_t) aColIndex >= mColSpacing.Length()) {
    return mColSpacing.LastElement();
  }
  return mColSpacing.ElementAt(aColIndex);
}

nscoord
nsMathMLmtableFrame::GetColSpacing(int32_t aStartColIndex,
                                  int32_t aEndColIndex)
{
  if (mUseCSSSpacing) {
    return nsTableFrame::GetColSpacing(aStartColIndex, aEndColIndex);
  }
  if (aStartColIndex == aEndColIndex) {
    return 0;
  }
  if (!mColSpacing.Length()) {
    NS_ERROR("mColSpacing should not be empty");
    return 0;
  }
  nscoord space = 0;
  if (aStartColIndex < 0) {
    NS_ASSERTION(aStartColIndex == -1,
                 "Desired column beyond bounds of table and border");
    space += mFrameSpacingX;
    aStartColIndex = 0;
  }
  if (aEndColIndex >= GetColCount()) {
    NS_ASSERTION(aEndColIndex == GetColCount(),
                 "Desired column beyond bounds of table and border");
    space += mFrameSpacingX;
    aEndColIndex = GetColCount();
  }
  // Only iterate over column spacing when there is the potential to vary
  int32_t min = std::min(aEndColIndex, (int32_t) mColSpacing.Length());
  for (int32_t i = aStartColIndex; i < min; i++) {
    space += mColSpacing.ElementAt(i);
  }
  // The remaining values are constant.  Note that if there are more
  // column spacings specified than there are columns, LastElement() will be
  // multiplied by 0, so it is still safe to use.
  space += (aEndColIndex - min) * mColSpacing.LastElement();
  return space;
}

nscoord
nsMathMLmtableFrame::GetRowSpacing(int32_t aRowIndex)
{
  if (mUseCSSSpacing) {
    return nsTableFrame::GetRowSpacing(aRowIndex);
  }
  if (!mRowSpacing.Length()) {
    NS_ERROR("mRowSpacing should not be empty");
    return 0;
  }
  if (aRowIndex < 0 || aRowIndex >= GetRowCount()) {
    NS_ASSERTION(aRowIndex == -1 || aRowIndex == GetRowCount(),
                 "Desired row beyond bounds of table and border");
    return mFrameSpacingY;
  }
  if ((uint32_t) aRowIndex >= mRowSpacing.Length()) {
    return mRowSpacing.LastElement();
  }
  return mRowSpacing.ElementAt(aRowIndex);
}

nscoord
nsMathMLmtableFrame::GetRowSpacing(int32_t aStartRowIndex,
                                   int32_t aEndRowIndex)
{
  if (mUseCSSSpacing) {
    return nsTableFrame::GetRowSpacing(aStartRowIndex, aEndRowIndex);
  }
  if (aStartRowIndex == aEndRowIndex) {
    return 0;
  }
  if (!mRowSpacing.Length()) {
    NS_ERROR("mRowSpacing should not be empty");
    return 0;
  }
  nscoord space = 0;
  if (aStartRowIndex < 0) {
    NS_ASSERTION(aStartRowIndex == -1,
                 "Desired row beyond bounds of table and border");
    space += mFrameSpacingY;
    aStartRowIndex = 0;
  }
  if (aEndRowIndex >= GetRowCount()) {
    NS_ASSERTION(aEndRowIndex == GetRowCount(),
                 "Desired row beyond bounds of table and border");
    space += mFrameSpacingY;
    aEndRowIndex = GetRowCount();
  }
  // Only iterate over row spacing when there is the potential to vary
  int32_t min = std::min(aEndRowIndex, (int32_t) mRowSpacing.Length());
  for (int32_t i = aStartRowIndex; i < min; i++) {
    space += mRowSpacing.ElementAt(i);
  }
  // The remaining values are constant.  Note that if there are more
  // row spacings specified than there are row, LastElement() will be
  // multiplied by 0, so it is still safe to use.
  space += (aEndRowIndex - min) * mRowSpacing.LastElement();
  return space;
}

void
nsMathMLmtableFrame::SetUseCSSSpacing()
{
  mUseCSSSpacing =
    !(mContent->HasAttr(kNameSpaceID_None, nsGkAtoms::rowspacing_) ||
      mContent->HasAttr(kNameSpaceID_None, nsGkAtoms::columnspacing_) ||
      mContent->HasAttr(kNameSpaceID_None, nsGkAtoms::framespacing_));
}

NS_QUERYFRAME_HEAD(nsMathMLmtableFrame)
  NS_QUERYFRAME_ENTRY(nsMathMLmtableFrame)
NS_QUERYFRAME_TAIL_INHERITING(nsTableFrame)

// --------
// implementation of nsMathMLmtrFrame

nsContainerFrame*
NS_NewMathMLmtrFrame(nsIPresShell* aPresShell, nsStyleContext* aContext)
{
  return new (aPresShell) nsMathMLmtrFrame(aContext);
}

NS_IMPL_FRAMEARENA_HELPERS(nsMathMLmtrFrame)

nsMathMLmtrFrame::~nsMathMLmtrFrame()
{
}

nsresult
nsMathMLmtrFrame::AttributeChanged(int32_t  aNameSpaceID,
                                   nsIAtom* aAttribute,
                                   int32_t  aModType)
{
  // Attributes specific to <mtr>:
  // groupalign  : Not yet supported.
  // rowalign    : Here
  // columnalign : Here

  nsPresContext* presContext = PresContext();

  if (aAttribute != nsGkAtoms::rowalign_ &&
      aAttribute != nsGkAtoms::columnalign_) {
    return NS_OK;
  }

  DeleteProperty(AttributeToProperty(aAttribute));

  bool allowMultiValues = (aAttribute == nsGkAtoms::columnalign_);

  // Reparse the new attribute.
  ParseFrameAttribute(this, aAttribute, allowMultiValues);

  // Explicitly request a reflow in our subtree to pick up any changes
  presContext->PresShell()->
      FrameNeedsReflow(this, nsIPresShell::eStyleChange, NS_FRAME_IS_DIRTY);

  return NS_OK;
}

// --------
// implementation of nsMathMLmtdFrame

nsContainerFrame*
NS_NewMathMLmtdFrame(nsIPresShell*   aPresShell,
                     nsStyleContext* aContext,
                     nsTableFrame*   aTableFrame)
{
  return new (aPresShell) nsMathMLmtdFrame(aContext, aTableFrame);
}

NS_IMPL_FRAMEARENA_HELPERS(nsMathMLmtdFrame)

nsMathMLmtdFrame::~nsMathMLmtdFrame()
{
}

void
nsMathMLmtdFrame::Init(nsIContent*       aContent,
                       nsContainerFrame* aParent,
                       nsIFrame*         aPrevInFlow)
{
  nsTableCellFrame::Init(aContent, aParent, aPrevInFlow);

  // We want to use the ancestor <math> element's font inflation to avoid
  // individual cells having their own varying font inflation.
  RemoveStateBits(NS_FRAME_FONT_INFLATION_FLOW_ROOT);
}

int32_t
nsMathMLmtdFrame::GetRowSpan()
{
  int32_t rowspan = 1;

  // Don't look at the content's rowspan if we're not an mtd or a pseudo cell.
  if (mContent->IsMathMLElement(nsGkAtoms::mtd_) &&
      !StyleContext()->GetPseudo()) {
    nsAutoString value;
    mContent->GetAttr(kNameSpaceID_None, nsGkAtoms::rowspan, value);
    if (!value.IsEmpty()) {
      nsresult error;
      rowspan = value.ToInteger(&error);
      if (NS_FAILED(error) || rowspan < 0)
        rowspan = 1;
      rowspan = std::min(rowspan, MAX_ROWSPAN);
    }
  }
  return rowspan;
}

int32_t
nsMathMLmtdFrame::GetColSpan()
{
  int32_t colspan = 1;

  // Don't look at the content's colspan if we're not an mtd or a pseudo cell.
  if (mContent->IsMathMLElement(nsGkAtoms::mtd_) &&
      !StyleContext()->GetPseudo()) {
    nsAutoString value;
    mContent->GetAttr(kNameSpaceID_None, nsGkAtoms::columnspan_, value);
    if (!value.IsEmpty()) {
      nsresult error;
      colspan = value.ToInteger(&error);
      if (NS_FAILED(error) || colspan <= 0 || colspan > MAX_COLSPAN)
        colspan = 1;
    }
  }
  return colspan;
}

nsresult
nsMathMLmtdFrame::AttributeChanged(int32_t  aNameSpaceID,
                                   nsIAtom* aAttribute,
                                   int32_t  aModType)
{
  // Attributes specific to <mtd>:
  // groupalign  : Not yet supported
  // rowalign    : here
  // columnalign : here
  // rowspan     : here
  // columnspan  : here

  if (aAttribute == nsGkAtoms::rowalign_ ||
      aAttribute == nsGkAtoms::columnalign_) {

    DeleteProperty(AttributeToProperty(aAttribute));

    // Reparse the attribute.
    ParseFrameAttribute(this, aAttribute, false);
    return NS_OK;
  }

  if (aAttribute == nsGkAtoms::rowspan ||
      aAttribute == nsGkAtoms::columnspan_) {
    // use the naming expected by the base class 
    if (aAttribute == nsGkAtoms::columnspan_)
      aAttribute = nsGkAtoms::colspan;
    return nsTableCellFrame::AttributeChanged(aNameSpaceID, aAttribute, aModType);
  }

  return NS_OK;
}

uint8_t
nsMathMLmtdFrame::GetVerticalAlign() const
{
  // Set the default alignment in case no alignment was specified
  uint8_t alignment = nsTableCellFrame::GetVerticalAlign();

  nsTArray<int8_t>* alignmentList = FindCellProperty(this, RowAlignProperty());

  if (alignmentList) {
    int32_t rowIndex;
    GetRowIndex(rowIndex);

    // If the row number is greater than the number of provided rowalign values,
    // we simply repeat the last value.
    if (rowIndex < (int32_t)alignmentList->Length())
      alignment = alignmentList->ElementAt(rowIndex);
    else
      alignment = alignmentList->ElementAt(alignmentList->Length() - 1);
  }

  return alignment;
}

nsresult
nsMathMLmtdFrame::ProcessBorders(nsTableFrame* aFrame,
                                 nsDisplayListBuilder* aBuilder,
                                 const nsDisplayListSet& aLists)
{
  aLists.BorderBackground()->AppendNewToTop(new (aBuilder)
                                            nsDisplaymtdBorder(aBuilder, this));
  return NS_OK;
}

LogicalMargin
nsMathMLmtdFrame::GetBorderWidth(WritingMode aWM) const
{
  nsStyleBorder styleBorder = *StyleBorder();
  ApplyBorderToStyle(this, styleBorder);
  return LogicalMargin(aWM, styleBorder.GetComputedBorder());
}

nsMargin
nsMathMLmtdFrame::GetBorderOverflow()
{
  nsStyleBorder styleBorder = *StyleBorder();
  ApplyBorderToStyle(this, styleBorder);
  nsMargin overflow = ComputeBorderOverflow(this, styleBorder);
  return overflow;
}

// --------
// implementation of nsMathMLmtdInnerFrame

NS_QUERYFRAME_HEAD(nsMathMLmtdInnerFrame)
  NS_QUERYFRAME_ENTRY(nsIMathMLFrame)
NS_QUERYFRAME_TAIL_INHERITING(nsBlockFrame)

nsContainerFrame*
NS_NewMathMLmtdInnerFrame(nsIPresShell* aPresShell, nsStyleContext* aContext)
{
  return new (aPresShell) nsMathMLmtdInnerFrame(aContext);
}

NS_IMPL_FRAMEARENA_HELPERS(nsMathMLmtdInnerFrame)

nsMathMLmtdInnerFrame::nsMathMLmtdInnerFrame(nsStyleContext* aContext)
  : nsBlockFrame(aContext, kClassID)
{
  // Make a copy of the parent nsStyleText for later modification.
  mUniqueStyleText = new (PresContext()) nsStyleText(*StyleText());
}

nsMathMLmtdInnerFrame::~nsMathMLmtdInnerFrame()
{
  mUniqueStyleText->Destroy(PresContext());
}

void
nsMathMLmtdInnerFrame::Reflow(nsPresContext*           aPresContext,
                              ReflowOutput&     aDesiredSize,
                              const ReflowInput& aReflowInput,
                              nsReflowStatus&          aStatus)
{
  // Let the base class do the reflow
  nsBlockFrame::Reflow(aPresContext, aDesiredSize, aReflowInput, aStatus);

  // more about <maligngroup/> and <malignmark/> later
  // ...
}

const
nsStyleText* nsMathMLmtdInnerFrame::StyleTextForLineLayout()
{
  // Set the default alignment in case nothing was specified
  uint8_t alignment = StyleText()->mTextAlign;

  nsTArray<int8_t>* alignmentList =
    FindCellProperty(this, ColumnAlignProperty());

  if (alignmentList) {
    nsMathMLmtdFrame* cellFrame = (nsMathMLmtdFrame*)GetParent();
    int32_t columnIndex;
    cellFrame->GetColIndex(columnIndex);

    // If the column number is greater than the number of provided columalign
    // values, we simply repeat the last value.
    if (columnIndex < (int32_t)alignmentList->Length())
      alignment = alignmentList->ElementAt(columnIndex);
    else
      alignment = alignmentList->ElementAt(alignmentList->Length() - 1);
  }

  mUniqueStyleText->mTextAlign = alignment;
  return mUniqueStyleText;
}

/* virtual */ void
nsMathMLmtdInnerFrame::DidSetStyleContext(nsStyleContext* aOldStyleContext)
{
  nsBlockFrame::DidSetStyleContext(aOldStyleContext);
  mUniqueStyleText->Destroy(PresContext());
  mUniqueStyleText = new (PresContext()) nsStyleText(*StyleText());
}
