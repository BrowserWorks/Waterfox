/*
 * Copyright © 2015-2016  Ebrahim Byagowi
 *
 *  This is part of HarfBuzz, a text shaping library.
 *
 * Permission is hereby granted, without written agreement and without
 * license or royalty fees, to use, copy, modify, and distribute this
 * software and its documentation for any purpose, provided that the
 * above copyright notice and the following two paragraphs appear in
 * all copies of this software.
 *
 * IN NO EVENT SHALL THE COPYRIGHT HOLDER BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES
 * ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN
 * IF THE COPYRIGHT HOLDER HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 *
 * THE COPYRIGHT HOLDER SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING,
 * BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
 * FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE COPYRIGHT HOLDER HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
 */

#define HB_SHAPER directwrite
#include "hb-shaper-impl-private.hh"

#include <DWrite_1.h>

#include "hb-directwrite.h"


#ifndef HB_DEBUG_DIRECTWRITE
#define HB_DEBUG_DIRECTWRITE (HB_DEBUG+0)
#endif

HB_SHAPER_DATA_ENSURE_DECLARE(directwrite, face)
HB_SHAPER_DATA_ENSURE_DECLARE(directwrite, font)


/*
 * DirectWrite font stream helpers
 */

// This is a font loader which provides only one font (unlike its original design).
// For a better implementation which was also source of this
// and DWriteFontFileStream, have a look at to NativeFontResourceDWrite.cpp in Mozilla
class DWriteFontFileLoader : public IDWriteFontFileLoader
{
private:
  IDWriteFontFileStream *mFontFileStream;
public:
  DWriteFontFileLoader (IDWriteFontFileStream *fontFileStream) {
    mFontFileStream = fontFileStream;
  }

  // IUnknown interface
  IFACEMETHOD(QueryInterface)(IID const& iid, OUT void** ppObject) { return S_OK; }
  IFACEMETHOD_(ULONG, AddRef)() { return 1; }
  IFACEMETHOD_(ULONG, Release)() { return 1; }

  // IDWriteFontFileLoader methods
  virtual HRESULT STDMETHODCALLTYPE CreateStreamFromKey(void const* fontFileReferenceKey,
    UINT32 fontFileReferenceKeySize,
    OUT IDWriteFontFileStream** fontFileStream)
  {
    *fontFileStream = mFontFileStream;
    return S_OK;
  }
};

class DWriteFontFileStream : public IDWriteFontFileStream
{
private:
  uint8_t *mData;
  uint32_t mSize;
public:
  DWriteFontFileStream(uint8_t *aData, uint32_t aSize)
  {
    mData = aData;
    mSize = aSize;
  }

  // IUnknown interface
  IFACEMETHOD(QueryInterface)(IID const& iid, OUT void** ppObject) { return S_OK; }
  IFACEMETHOD_(ULONG, AddRef)() { return 1; }
  IFACEMETHOD_(ULONG, Release)() { return 1; }

  // IDWriteFontFileStream methods
  virtual HRESULT STDMETHODCALLTYPE ReadFileFragment(void const** fragmentStart,
    UINT64 fileOffset,
    UINT64 fragmentSize,
    OUT void** fragmentContext)
  {
    // We are required to do bounds checking.
    if (fileOffset + fragmentSize > mSize) {
      return E_FAIL;
    }

    // truncate the 64 bit fileOffset to size_t sized index into mData
    size_t index = static_cast<size_t> (fileOffset);

    // We should be alive for the duration of this.
    *fragmentStart = &mData[index];
    *fragmentContext = nullptr;
    return S_OK;
  }

  virtual void STDMETHODCALLTYPE ReleaseFileFragment(void* fragmentContext) { }

  virtual HRESULT STDMETHODCALLTYPE GetFileSize(OUT UINT64* fileSize)
  {
    *fileSize = mSize;
    return S_OK;
  }

  virtual HRESULT STDMETHODCALLTYPE GetLastWriteTime(OUT UINT64* lastWriteTime)
  {
    return E_NOTIMPL;
  }
};


/*
* shaper face data
*/

struct hb_directwrite_shaper_face_data_t {
  IDWriteFactory *dwriteFactory;
  IDWriteFontFile *fontFile;
  IDWriteFontFileStream *fontFileStream;
  IDWriteFontFileLoader *fontFileLoader;
  IDWriteFontFace *fontFace;
  hb_blob_t *faceBlob;
};

hb_directwrite_shaper_face_data_t *
_hb_directwrite_shaper_face_data_create(hb_face_t *face)
{
  hb_directwrite_shaper_face_data_t *data =
    (hb_directwrite_shaper_face_data_t *) malloc (sizeof (hb_directwrite_shaper_face_data_t));
  if (unlikely (!data))
    return NULL;

  // TODO: factory and fontFileLoader should be cached separately
  IDWriteFactory* dwriteFactory;
  DWriteCreateFactory (
    DWRITE_FACTORY_TYPE_SHARED,
    __uuidof (IDWriteFactory),
    (IUnknown**) &dwriteFactory
  );

  HRESULT hr;
  hb_blob_t *blob = hb_face_reference_blob (face);
  IDWriteFontFileStream *fontFileStream = new DWriteFontFileStream (
    (uint8_t*) hb_blob_get_data (blob, NULL), hb_blob_get_length (blob));

  IDWriteFontFileLoader *fontFileLoader = new DWriteFontFileLoader (fontFileStream);
  dwriteFactory->RegisterFontFileLoader (fontFileLoader);

  IDWriteFontFile *fontFile;
  uint64_t fontFileKey = 0;
  hr = dwriteFactory->CreateCustomFontFileReference (&fontFileKey, sizeof (fontFileKey),
      fontFileLoader, &fontFile);

#define FAIL(...) \
  HB_STMT_START { \
    DEBUG_MSG (DIRECTWRITE, NULL, __VA_ARGS__); \
    return false; \
  } HB_STMT_END;

  if (FAILED (hr)) {
    FAIL ("Failed to load font file from data!");
    return false;
  }

  BOOL isSupported;
  DWRITE_FONT_FILE_TYPE fileType;
  DWRITE_FONT_FACE_TYPE faceType;
  UINT32 numberOfFaces;
  hr = fontFile->Analyze (&isSupported, &fileType, &faceType, &numberOfFaces);
  if (FAILED (hr) || !isSupported) {
    FAIL ("Font file is not supported.");
    return false;
  }

#undef FAIL

  IDWriteFontFace *fontFace;
  dwriteFactory->CreateFontFace (faceType, 1, &fontFile, 0,
    DWRITE_FONT_SIMULATIONS_NONE, &fontFace);

  data->dwriteFactory = dwriteFactory;
  data->fontFile = fontFile;
  data->fontFileStream = fontFileStream;
  data->fontFileLoader = fontFileLoader;
  data->fontFace = fontFace;
  data->faceBlob = blob;

  return data;
}

void
_hb_directwrite_shaper_face_data_destroy(hb_directwrite_shaper_face_data_t *data)
{
  if (data->fontFace)
    data->fontFace->Release ();
  if (data->fontFile)
    data->fontFile->Release ();
  if (data->dwriteFactory) {
    if (data->fontFileLoader)
      data->dwriteFactory->UnregisterFontFileLoader (data->fontFileLoader);
    data->dwriteFactory->Release ();
  }
  if (data->fontFileLoader)
    delete data->fontFileLoader;
  if (data->fontFileStream)
    delete data->fontFileStream;
  if (data->faceBlob)
    hb_blob_destroy (data->faceBlob);
  if (data)
    free (data);
}


/*
 * shaper font data
 */

struct hb_directwrite_shaper_font_data_t {
};

hb_directwrite_shaper_font_data_t *
_hb_directwrite_shaper_font_data_create (hb_font_t *font)
{
  if (unlikely (!hb_directwrite_shaper_face_data_ensure (font->face))) return NULL;

  hb_directwrite_shaper_font_data_t *data =
    (hb_directwrite_shaper_font_data_t *) malloc (sizeof (hb_directwrite_shaper_font_data_t));
  if (unlikely (!data))
    return NULL;

  return data;
}

void
_hb_directwrite_shaper_font_data_destroy (hb_directwrite_shaper_font_data_t *data)
{
  free (data);
}


/*
 * shaper shape_plan data
 */

struct hb_directwrite_shaper_shape_plan_data_t {};

hb_directwrite_shaper_shape_plan_data_t *
_hb_directwrite_shaper_shape_plan_data_create (hb_shape_plan_t    *shape_plan HB_UNUSED,
					       const hb_feature_t *user_features HB_UNUSED,
					       unsigned int        num_user_features HB_UNUSED,
					       const int          *coords HB_UNUSED,
					       unsigned int        num_coords HB_UNUSED)
{
  return (hb_directwrite_shaper_shape_plan_data_t *) HB_SHAPER_DATA_SUCCEEDED;
}

void
_hb_directwrite_shaper_shape_plan_data_destroy (hb_directwrite_shaper_shape_plan_data_t *data HB_UNUSED)
{
}

// Most of TextAnalysis is originally written by Bas Schouten for Mozilla project
// but now is relicensed to MIT for HarfBuzz use
class TextAnalysis
  : public IDWriteTextAnalysisSource, public IDWriteTextAnalysisSink
{
public:

  IFACEMETHOD(QueryInterface)(IID const& iid, OUT void** ppObject) { return S_OK; }
  IFACEMETHOD_(ULONG, AddRef)() { return 1; }
  IFACEMETHOD_(ULONG, Release)() { return 1; }

  // A single contiguous run of characters containing the same analysis 
  // results.
  struct Run
  {
    uint32_t mTextStart;   // starting text position of this run
    uint32_t mTextLength;  // number of contiguous code units covered
    uint32_t mGlyphStart;  // starting glyph in the glyphs array
    uint32_t mGlyphCount;  // number of glyphs associated with this run of 
    // text
    DWRITE_SCRIPT_ANALYSIS mScript;
    uint8_t mBidiLevel;
    bool mIsSideways;

    inline bool ContainsTextPosition(uint32_t aTextPosition) const
    {
      return aTextPosition >= mTextStart
        && aTextPosition <  mTextStart + mTextLength;
    }

    Run *nextRun;
  };

public:
  TextAnalysis(const wchar_t* text,
    uint32_t textLength,
    const wchar_t* localeName,
    DWRITE_READING_DIRECTION readingDirection)
    : mText(text)
    , mTextLength(textLength)
    , mLocaleName(localeName)
    , mReadingDirection(readingDirection)
    , mCurrentRun(NULL) { };

  ~TextAnalysis() {
    // delete runs, except mRunHead which is part of the TextAnalysis object
    for (Run *run = mRunHead.nextRun; run;) {
      Run *origRun = run;
      run = run->nextRun;
      free (origRun);
    }
  }

  STDMETHODIMP GenerateResults(IDWriteTextAnalyzer* textAnalyzer,
    Run **runHead) {
    // Analyzes the text using the script analyzer and returns
    // the result as a series of runs.

    HRESULT hr = S_OK;

    // Initially start out with one result that covers the entire range.
    // This result will be subdivided by the analysis processes.
    mRunHead.mTextStart = 0;
    mRunHead.mTextLength = mTextLength;
    mRunHead.mBidiLevel =
      (mReadingDirection == DWRITE_READING_DIRECTION_RIGHT_TO_LEFT);
    mRunHead.nextRun = NULL;
    mCurrentRun = &mRunHead;

    // Call each of the analyzers in sequence, recording their results.
    if (SUCCEEDED (hr = textAnalyzer->AnalyzeScript (this, 0, mTextLength, this))) {
      *runHead = &mRunHead;
    }

    return hr;
  }

  // IDWriteTextAnalysisSource implementation

  IFACEMETHODIMP GetTextAtPosition(uint32_t textPosition,
    OUT wchar_t const** textString,
    OUT uint32_t* textLength)
  {
    if (textPosition >= mTextLength) {
      // No text at this position, valid query though.
      *textString = NULL;
      *textLength = 0;
    }
    else {
      *textString = mText + textPosition;
      *textLength = mTextLength - textPosition;
    }
    return S_OK;
  }

  IFACEMETHODIMP GetTextBeforePosition(uint32_t textPosition,
    OUT wchar_t const** textString,
    OUT uint32_t* textLength)
  {
    if (textPosition == 0 || textPosition > mTextLength) {
      // Either there is no text before here (== 0), or this
      // is an invalid position. The query is considered valid thouh.
      *textString = NULL;
      *textLength = 0;
    }
    else {
      *textString = mText;
      *textLength = textPosition;
    }
    return S_OK;
  }

  IFACEMETHODIMP_(DWRITE_READING_DIRECTION)
    GetParagraphReadingDirection() { return mReadingDirection; }

  IFACEMETHODIMP GetLocaleName(uint32_t textPosition,
    uint32_t* textLength,
    wchar_t const** localeName)
  {
    return S_OK;
  }

  IFACEMETHODIMP
    GetNumberSubstitution(uint32_t textPosition,
    OUT uint32_t* textLength,
    OUT IDWriteNumberSubstitution** numberSubstitution)
  {
    // We do not support number substitution.
    *numberSubstitution = NULL;
    *textLength = mTextLength - textPosition;

    return S_OK;
  }

  // IDWriteTextAnalysisSink implementation

  IFACEMETHODIMP
    SetScriptAnalysis(uint32_t textPosition,
    uint32_t textLength,
    DWRITE_SCRIPT_ANALYSIS const* scriptAnalysis)
  {
    SetCurrentRun(textPosition);
    SplitCurrentRun(textPosition);
    while (textLength > 0)
    {
      Run *run = FetchNextRun(&textLength);
      run->mScript = *scriptAnalysis;
    }

    return S_OK;
  }

  IFACEMETHODIMP
    SetLineBreakpoints(uint32_t textPosition,
    uint32_t textLength,
    const DWRITE_LINE_BREAKPOINT* lineBreakpoints) { return S_OK; }

  IFACEMETHODIMP SetBidiLevel(uint32_t textPosition,
    uint32_t textLength,
    uint8_t explicitLevel,
    uint8_t resolvedLevel) { return S_OK; }

  IFACEMETHODIMP
    SetNumberSubstitution(uint32_t textPosition,
    uint32_t textLength,
    IDWriteNumberSubstitution* numberSubstitution) { return S_OK; }

protected:
  Run *FetchNextRun(IN OUT uint32_t* textLength)
  {
    // Used by the sink setters, this returns a reference to the next run.
    // Position and length are adjusted to now point after the current run
    // being returned.

    Run *origRun = mCurrentRun;
    // Split the tail if needed (the length remaining is less than the
    // current run's size).
    if (*textLength < mCurrentRun->mTextLength)
    {
      SplitCurrentRun (mCurrentRun->mTextStart + *textLength);
    }
    else
    {
      // Just advance the current run.
      mCurrentRun = mCurrentRun->nextRun;
    }
    *textLength -= origRun->mTextLength;

    // Return a reference to the run that was just current.
    return origRun;
  }

  void SetCurrentRun(uint32_t textPosition)
  {
    // Move the current run to the given position.
    // Since the analyzers generally return results in a forward manner,
    // this will usually just return early. If not, find the
    // corresponding run for the text position.

    if (mCurrentRun && mCurrentRun->ContainsTextPosition (textPosition))
    {
      return;
    }

    for (Run *run = &mRunHead; run; run = run->nextRun) {
      if (run->ContainsTextPosition (textPosition))
      {
        mCurrentRun = run;
        return;
      }
    }
    //NS_NOTREACHED("We should always be able to find the text position in one \
            //                of our runs");
  }

  void SplitCurrentRun(uint32_t splitPosition)
  {
    if (!mCurrentRun)
    {
      //NS_ASSERTION(false, "SplitCurrentRun called without current run.");
      // Shouldn't be calling this when no current run is set!
      return;
    }
    // Split the current run.
    if (splitPosition <= mCurrentRun->mTextStart)
    {
      // No need to split, already the start of a run
      // or before it. Usually the first.
      return;
    }
    Run *newRun = (Run*) malloc (sizeof (Run));

    *newRun = *mCurrentRun;

    // Insert the new run in our linked list.
    newRun->nextRun = mCurrentRun->nextRun;
    mCurrentRun->nextRun = newRun;

    // Adjust runs' text positions and lengths.
    uint32_t splitPoint = splitPosition - mCurrentRun->mTextStart;
    newRun->mTextStart += splitPoint;
    newRun->mTextLength -= splitPoint;
    mCurrentRun->mTextLength = splitPoint;
    mCurrentRun = newRun;
  }

protected:
  // Input
  // (weak references are fine here, since this class is a transient
  //  stack-based helper that doesn't need to copy data)
  uint32_t mTextLength;
  const wchar_t* mText;
  const wchar_t* mLocaleName;
  DWRITE_READING_DIRECTION mReadingDirection;

  // Current processing state.
  Run *mCurrentRun;

  // Output is a list of runs starting here
  Run  mRunHead;
};

static inline uint16_t hb_uint16_swap (const uint16_t v)
{ return (v >> 8) | (v << 8); }
static inline uint32_t hb_uint32_swap (const uint32_t v)
{ return (hb_uint16_swap(v) << 16) | hb_uint16_swap(v >> 16); }

/*
 * shaper
 */

static hb_bool_t
_hb_directwrite_shape_full(hb_shape_plan_t    *shape_plan,
  hb_font_t          *font,
  hb_buffer_t        *buffer,
  const hb_feature_t *features,
  unsigned int        num_features,
  float               lineWidth)
{
  hb_face_t *face = font->face;
  hb_directwrite_shaper_face_data_t *face_data = HB_SHAPER_DATA_GET (face);
  hb_directwrite_shaper_font_data_t *font_data = HB_SHAPER_DATA_GET (font);
  IDWriteFactory *dwriteFactory = face_data->dwriteFactory;
  IDWriteFontFace *fontFace = face_data->fontFace;

  IDWriteTextAnalyzer* analyzer;
  dwriteFactory->CreateTextAnalyzer(&analyzer);

  unsigned int scratch_size;
  hb_buffer_t::scratch_buffer_t *scratch = buffer->get_scratch_buffer (&scratch_size);
#define ALLOCATE_ARRAY(Type, name, len) \
  Type *name = (Type *) scratch; \
  { \
    unsigned int _consumed = DIV_CEIL ((len) * sizeof (Type), sizeof (*scratch)); \
    assert (_consumed <= scratch_size); \
    scratch += _consumed; \
    scratch_size -= _consumed; \
  }

#define utf16_index() var1.u32

  ALLOCATE_ARRAY(wchar_t, textString, buffer->len * 2);

  unsigned int chars_len = 0;
  for (unsigned int i = 0; i < buffer->len; i++)
  {
    hb_codepoint_t c = buffer->info[i].codepoint;
    buffer->info[i].utf16_index() = chars_len;
    if (likely(c <= 0xFFFFu))
      textString[chars_len++] = c;
    else if (unlikely(c > 0x10FFFFu))
      textString[chars_len++] = 0xFFFDu;
    else {
      textString[chars_len++] = 0xD800u + ((c - 0x10000u) >> 10);
      textString[chars_len++] = 0xDC00u + ((c - 0x10000u) & ((1u << 10) - 1));
    }
  }

  ALLOCATE_ARRAY(WORD, log_clusters, chars_len);
  // if (num_features)
  {
    /* Need log_clusters to assign features. */
    chars_len = 0;
    for (unsigned int i = 0; i < buffer->len; i++)
    {
      hb_codepoint_t c = buffer->info[i].codepoint;
      unsigned int cluster = buffer->info[i].cluster;
      log_clusters[chars_len++] = cluster;
      if (hb_in_range(c, 0x10000u, 0x10FFFFu))
        log_clusters[chars_len++] = cluster; /* Surrogates. */
    }
  }

  // TODO: Handle TEST_DISABLE_OPTIONAL_LIGATURES

  DWRITE_READING_DIRECTION readingDirection = buffer->props.direction ? 
    DWRITE_READING_DIRECTION_RIGHT_TO_LEFT :
    DWRITE_READING_DIRECTION_LEFT_TO_RIGHT;

  /*
  * There's an internal 16-bit limit on some things inside the analyzer,
  * but we never attempt to shape a word longer than 64K characters
  * in a single gfxShapedWord, so we cannot exceed that limit.
  */
  uint32_t textLength = buffer->len;

  TextAnalysis analysis(textString, textLength, NULL, readingDirection);
  TextAnalysis::Run *runHead;
  HRESULT hr;
  hr = analysis.GenerateResults(analyzer, &runHead);

#define FAIL(...) \
  HB_STMT_START { \
    DEBUG_MSG (DIRECTWRITE, NULL, __VA_ARGS__); \
    return false; \
  } HB_STMT_END;

  if (FAILED (hr))
  {
    FAIL ("Analyzer failed to generate results.");
    return false;
  }

  uint32_t maxGlyphCount = 3 * textLength / 2 + 16;
  uint32_t glyphCount;
  bool isRightToLeft = HB_DIRECTION_IS_BACKWARD (buffer->props.direction);

  const wchar_t localeName[20] = {0};
  if (buffer->props.language != NULL)
  {
    mbstowcs ((wchar_t*) localeName,
      hb_language_to_string (buffer->props.language), 20);
  }

  DWRITE_TYPOGRAPHIC_FEATURES singleFeatures;
  singleFeatures.featureCount = num_features;
  if (num_features)
  {
    DWRITE_FONT_FEATURE* dwfeatureArray = (DWRITE_FONT_FEATURE*)
      malloc (sizeof (DWRITE_FONT_FEATURE) * num_features);
    for (unsigned int i = 0; i < num_features; ++i)
    {
      dwfeatureArray[i].nameTag = (DWRITE_FONT_FEATURE_TAG)
        hb_uint32_swap (features[i].tag);
      dwfeatureArray[i].parameter = features[i].value;
    }
    singleFeatures.features = dwfeatureArray;
  }
  const DWRITE_TYPOGRAPHIC_FEATURES* dwFeatures =
    (const DWRITE_TYPOGRAPHIC_FEATURES*) &singleFeatures;
  const uint32_t featureRangeLengths[] = { textLength };

  uint16_t* clusterMap = (uint16_t*) malloc (textLength * sizeof (uint16_t));
  DWRITE_SHAPING_TEXT_PROPERTIES* textProperties = (DWRITE_SHAPING_TEXT_PROPERTIES*)
    malloc (textLength * sizeof (DWRITE_SHAPING_TEXT_PROPERTIES));
retry_getglyphs:
  uint16_t* glyphIndices = (uint16_t*) malloc (maxGlyphCount * sizeof (uint16_t));
  DWRITE_SHAPING_GLYPH_PROPERTIES* glyphProperties = (DWRITE_SHAPING_GLYPH_PROPERTIES*)
    malloc (maxGlyphCount * sizeof (DWRITE_SHAPING_GLYPH_PROPERTIES));

  hr = analyzer->GetGlyphs (textString, textLength, fontFace, FALSE,
    isRightToLeft, &runHead->mScript, localeName, NULL, &dwFeatures,
    featureRangeLengths, 1, maxGlyphCount, clusterMap, textProperties, glyphIndices,
    glyphProperties, &glyphCount);

  if (unlikely (hr == HRESULT_FROM_WIN32 (ERROR_INSUFFICIENT_BUFFER)))
  {
    free (glyphIndices);
    free (glyphProperties);

    maxGlyphCount *= 2;

    goto retry_getglyphs;
  }
  if (FAILED (hr))
  {
    FAIL ("Analyzer failed to get glyphs.");
    return false;
  }

  float* glyphAdvances = (float*) malloc (maxGlyphCount * sizeof (float));
  DWRITE_GLYPH_OFFSET* glyphOffsets = (DWRITE_GLYPH_OFFSET*)
    malloc(maxGlyphCount * sizeof (DWRITE_GLYPH_OFFSET));

  /* The -2 in the following is to compensate for possible
   * alignment needed after the WORD array.  sizeof(WORD) == 2. */
  unsigned int glyphs_size = (scratch_size * sizeof(int) - 2)
         / (sizeof(WORD) +
            sizeof(DWRITE_SHAPING_GLYPH_PROPERTIES) +
            sizeof(int) +
            sizeof(DWRITE_GLYPH_OFFSET) +
            sizeof(uint32_t));
  ALLOCATE_ARRAY (uint32_t, vis_clusters, glyphs_size);

#undef ALLOCATE_ARRAY

  int fontEmSize = font->face->get_upem();
  if (fontEmSize < 0)
    fontEmSize = -fontEmSize;

  if (fontEmSize < 0)
    fontEmSize = -fontEmSize;
  double x_mult = (double) font->x_scale / fontEmSize;
  double y_mult = (double) font->y_scale / fontEmSize;

  hr = analyzer->GetGlyphPlacements (textString,
    clusterMap, textProperties, textLength, glyphIndices,
    glyphProperties, glyphCount, fontFace, fontEmSize,
    FALSE, isRightToLeft, &runHead->mScript, localeName,
    &dwFeatures, featureRangeLengths, 1,
    glyphAdvances, glyphOffsets);

  if (FAILED (hr))
  {
    FAIL ("Analyzer failed to get glyph placements.");
    return false;
  }

  IDWriteTextAnalyzer1* analyzer1;
  analyzer->QueryInterface (&analyzer1);

  if (analyzer1 && lineWidth)
  {

    DWRITE_JUSTIFICATION_OPPORTUNITY* justificationOpportunities =
      (DWRITE_JUSTIFICATION_OPPORTUNITY*)
      malloc (maxGlyphCount * sizeof (DWRITE_JUSTIFICATION_OPPORTUNITY));
    hr = analyzer1->GetJustificationOpportunities (fontFace, fontEmSize,
      runHead->mScript, textLength, glyphCount, textString, clusterMap,
      glyphProperties, justificationOpportunities);

    if (FAILED (hr))
    {
      FAIL ("Analyzer failed to get justification opportunities.");
      return false;
    }

    float* justifiedGlyphAdvances =
      (float*) malloc (maxGlyphCount * sizeof (float));
    DWRITE_GLYPH_OFFSET* justifiedGlyphOffsets = (DWRITE_GLYPH_OFFSET*)
      malloc (glyphCount * sizeof (DWRITE_GLYPH_OFFSET));
    hr = analyzer1->JustifyGlyphAdvances (lineWidth, glyphCount, justificationOpportunities,
      glyphAdvances, glyphOffsets, justifiedGlyphAdvances, justifiedGlyphOffsets);

    if (FAILED (hr))
    {
      FAIL("Analyzer failed to get justified glyph advances.");
      return false;
    }

    DWRITE_SCRIPT_PROPERTIES scriptProperties;
    hr = analyzer1->GetScriptProperties (runHead->mScript, &scriptProperties);
    if (FAILED (hr))
    {
      FAIL("Analyzer failed to get script properties.");
      return false;
    }
    uint32_t justificationCharacter = scriptProperties.justificationCharacter;

    // if a script justificationCharacter is not space, it can have GetJustifiedGlyphs
    if (justificationCharacter != 32)
    {
      uint16_t* modifiedClusterMap = (uint16_t*) malloc (textLength * sizeof (uint16_t));
    retry_getjustifiedglyphs:
      uint16_t* modifiedGlyphIndices = (uint16_t*) malloc (maxGlyphCount * sizeof (uint16_t));
      float* modifiedGlyphAdvances = (float*) malloc (maxGlyphCount * sizeof (float));
      DWRITE_GLYPH_OFFSET* modifiedGlyphOffsets = (DWRITE_GLYPH_OFFSET*)
        malloc (maxGlyphCount * sizeof (DWRITE_GLYPH_OFFSET));
      uint32_t actualGlyphsCount;
      hr = analyzer1->GetJustifiedGlyphs (fontFace, fontEmSize, runHead->mScript,
        textLength, glyphCount, maxGlyphCount, clusterMap, glyphIndices,
        glyphAdvances, justifiedGlyphAdvances, justifiedGlyphOffsets,
        glyphProperties, &actualGlyphsCount, modifiedClusterMap, modifiedGlyphIndices,
        modifiedGlyphAdvances, modifiedGlyphOffsets);

      if (hr == HRESULT_FROM_WIN32 (ERROR_INSUFFICIENT_BUFFER))
      {
        maxGlyphCount = actualGlyphsCount;
        free (modifiedGlyphIndices);
        free (modifiedGlyphAdvances);
        free (modifiedGlyphOffsets);

        maxGlyphCount = actualGlyphsCount;

        goto retry_getjustifiedglyphs;
      }
      if (FAILED (hr))
      {
        FAIL ("Analyzer failed to get justified glyphs.");
        return false;
      }

      free (clusterMap);
      free (glyphIndices);
      free (glyphAdvances);
      free (glyphOffsets);

      glyphCount = actualGlyphsCount;
      clusterMap = modifiedClusterMap;
      glyphIndices = modifiedGlyphIndices;
      glyphAdvances = modifiedGlyphAdvances;
      glyphOffsets = modifiedGlyphOffsets;

      free (justifiedGlyphAdvances);
      free (justifiedGlyphOffsets);
    }
    else
    {
      free (glyphAdvances);
      free (glyphOffsets);

      glyphAdvances = justifiedGlyphAdvances;
      glyphOffsets = justifiedGlyphOffsets;
    }

    free (justificationOpportunities);

  }

  /* Ok, we've got everything we need, now compose output buffer,
   * very, *very*, carefully! */

  /* Calculate visual-clusters.  That's what we ship. */
  for (unsigned int i = 0; i < glyphCount; i++)
    vis_clusters[i] = -1;
  for (unsigned int i = 0; i < buffer->len; i++)
  {
    uint32_t *p =
      &vis_clusters[log_clusters[buffer->info[i].utf16_index()]];
    *p = MIN (*p, buffer->info[i].cluster);
  }
  for (unsigned int i = 1; i < glyphCount; i++)
    if (vis_clusters[i] == -1)
      vis_clusters[i] = vis_clusters[i - 1];

#undef utf16_index

  if (unlikely (!buffer->ensure (glyphCount)))
    FAIL ("Buffer in error");

#undef FAIL

  /* Set glyph infos */
  buffer->len = 0;
  for (unsigned int i = 0; i < glyphCount; i++)
  {
    hb_glyph_info_t *info = &buffer->info[buffer->len++];

    info->codepoint = glyphIndices[i];
    info->cluster = vis_clusters[i];

    /* The rest is crap.  Let's store position info there for now. */
    info->mask = glyphAdvances[i];
    info->var1.i32 = glyphOffsets[i].advanceOffset;
    info->var2.i32 = glyphOffsets[i].ascenderOffset;
  }

  /* Set glyph positions */
  buffer->clear_positions ();
  for (unsigned int i = 0; i < glyphCount; i++)
  {
    hb_glyph_info_t *info = &buffer->info[i];
    hb_glyph_position_t *pos = &buffer->pos[i];

    /* TODO vertical */
    pos->x_advance = x_mult * (int32_t) info->mask;
    pos->x_offset =
      x_mult * (isRightToLeft ? -info->var1.i32 : info->var1.i32);
    pos->y_offset = y_mult * info->var2.i32;
  }

  if (isRightToLeft)
    hb_buffer_reverse (buffer);

  free (clusterMap);
  free (glyphIndices);
  free (textProperties);
  free (glyphProperties);
  free (glyphAdvances);
  free (glyphOffsets);

  if (num_features)
    free (singleFeatures.features);

  /* Wow, done! */
  return true;
}

hb_bool_t
_hb_directwrite_shape(hb_shape_plan_t    *shape_plan,
  hb_font_t          *font,
  hb_buffer_t        *buffer,
  const hb_feature_t *features,
  unsigned int        num_features)
{
  return _hb_directwrite_shape_full(shape_plan, font, buffer,
    features, num_features, 0);
}

/*
 * Public [experimental] API
 */

hb_bool_t
hb_shape_dwrite_experimental_width(hb_font_t          *font,
  hb_buffer_t        *buffer,
  const hb_feature_t *features,
  unsigned int        num_features,
  float               width)
{
  static char *shapers = "directwrite";
  hb_shape_plan_t *shape_plan = hb_shape_plan_create_cached (font->face,
    &buffer->props, features, num_features, &shapers);
  hb_bool_t res = _hb_directwrite_shape_full (shape_plan, font, buffer,
    features, num_features, width);

  if (res)
    buffer->content_type = HB_BUFFER_CONTENT_TYPE_GLYPHS;

  return res;
}
