/*
 * Copyright 2014 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#include "SkTextBlobRunIterator.h"

#include "SkReadBuffer.h"
#include "SkTypeface.h"
#include "SkWriteBuffer.h"

namespace {

// TODO(fmalita): replace with SkFont.
class RunFont : SkNoncopyable {
public:
    RunFont(const SkPaint& paint)
        : fSize(paint.getTextSize())
        , fScaleX(paint.getTextScaleX())
        , fTypeface(SkSafeRef(paint.getTypeface()))
        , fSkewX(paint.getTextSkewX())
        , fAlign(paint.getTextAlign())
        , fHinting(paint.getHinting())
        , fFlags(paint.getFlags() & kFlagsMask) { }

    void applyToPaint(SkPaint* paint) const {
        paint->setTextEncoding(SkPaint::kGlyphID_TextEncoding);
        paint->setTypeface(fTypeface);
        paint->setTextSize(fSize);
        paint->setTextScaleX(fScaleX);
        paint->setTextSkewX(fSkewX);
        paint->setTextAlign(static_cast<SkPaint::Align>(fAlign));
        paint->setHinting(static_cast<SkPaint::Hinting>(fHinting));

        paint->setFlags((paint->getFlags() & ~kFlagsMask) | fFlags);
    }

    bool operator==(const RunFont& other) const {
        return fTypeface == other.fTypeface
            && fSize == other.fSize
            && fScaleX == other.fScaleX
            && fSkewX == other.fSkewX
            && fAlign == other.fAlign
            && fHinting == other.fHinting
            && fFlags == other.fFlags;
    }

    bool operator!=(const RunFont& other) const {
        return !(*this == other);
    }

    uint32_t flags() const { return fFlags; }

private:
    const static uint32_t kFlagsMask =
        SkPaint::kAntiAlias_Flag          |
        SkPaint::kUnderlineText_Flag      |
        SkPaint::kStrikeThruText_Flag     |
        SkPaint::kFakeBoldText_Flag       |
        SkPaint::kLinearText_Flag         |
        SkPaint::kSubpixelText_Flag       |
        SkPaint::kDevKernText_Flag        |
        SkPaint::kLCDRenderText_Flag      |
        SkPaint::kEmbeddedBitmapText_Flag |
        SkPaint::kAutoHinting_Flag        |
        SkPaint::kVerticalText_Flag       |
        SkPaint::kGenA8FromLCD_Flag;

    SkScalar                 fSize;
    SkScalar                 fScaleX;

    // Keep this SkAutoTUnref off the first position, to avoid interfering with SkNoncopyable
    // empty baseclass optimization (http://code.google.com/p/skia/issues/detail?id=3694).
    sk_sp<SkTypeface>        fTypeface;
    SkScalar                 fSkewX;

    static_assert(SkPaint::kAlignCount < 4, "insufficient_align_bits");
    uint32_t                 fAlign : 2;
    static_assert(SkPaint::kFull_Hinting < 4, "insufficient_hinting_bits");
    uint32_t                 fHinting : 2;
    static_assert((kFlagsMask & 0xffff) == kFlagsMask, "insufficient_flags_bits");
    uint32_t                 fFlags : 16;

    typedef SkNoncopyable INHERITED;
};

struct RunFontStorageEquivalent {
    SkScalar fSize, fScaleX;
    void*    fTypeface;
    SkScalar fSkewX;
    uint32_t fFlags;
};
static_assert(sizeof(RunFont) == sizeof(RunFontStorageEquivalent), "runfont_should_stay_packed");

} // anonymous namespace

//
// Textblob data is laid out into externally-managed storage as follows:
//
//    -----------------------------------------------------------------------------
//   | SkTextBlob | RunRecord | Glyphs[] | Pos[] | RunRecord | Glyphs[] | Pos[] | ...
//    -----------------------------------------------------------------------------
//
//  Each run record describes a text blob run, and can be used to determine the (implicit)
//  location of the following record.
//
// Extended Textblob runs have more data after the Pos[] array:
//
//    -------------------------------------------------------------------------
//    ... | RunRecord | Glyphs[] | Pos[] | TextSize | Clusters[] | Text[] | ...
//    -------------------------------------------------------------------------
//
// To determine the length of the extended run data, the TextSize must be read.
//
// Extended Textblob runs may be mixed with non-extended runs.

SkDEBUGCODE(static const unsigned kRunRecordMagic = 0xb10bcafe;)

namespace {
struct RunRecordStorageEquivalent {
    RunFont  fFont;
    SkPoint  fOffset;
    uint32_t fCount;
    uint32_t fFlags;
    SkDEBUGCODE(unsigned fMagic;)
};
}

class SkTextBlob::RunRecord {
public:
    RunRecord(uint32_t count, uint32_t textSize,  const SkPoint& offset, const SkPaint& font, GlyphPositioning pos)
        : fFont(font)
        , fCount(count)
        , fOffset(offset)
        , fPositioning(pos)
        , fExtended(textSize > 0) {
        SkDEBUGCODE(fMagic = kRunRecordMagic);
        if (textSize > 0) {
            *this->textSizePtr() = textSize;
        }
    }

    uint32_t glyphCount() const {
        return fCount;
    }

    const SkPoint& offset() const {
        return fOffset;
    }

    const RunFont& font() const {
        return fFont;
    }

    GlyphPositioning positioning() const {
        return fPositioning;
    }

    uint16_t* glyphBuffer() const {
        static_assert(SkIsAlignPtr(sizeof(RunRecord)), "");
        // Glyphs are stored immediately following the record.
        return reinterpret_cast<uint16_t*>(const_cast<RunRecord*>(this) + 1);
    }

    SkScalar* posBuffer() const {
        // Position scalars follow the (aligned) glyph buffer.
        return reinterpret_cast<SkScalar*>(reinterpret_cast<uint8_t*>(this->glyphBuffer()) +
                                           SkAlign4(fCount * sizeof(uint16_t)));
    }

    uint32_t textSize() const { return fExtended ? *this->textSizePtr() : 0; }

    uint32_t* clusterBuffer() const {
        // clusters follow the textSize.
        return fExtended ? 1 + this->textSizePtr() : nullptr;
    }

    char* textBuffer() const {
        if (!fExtended) { return nullptr; }
        return reinterpret_cast<char*>(this->clusterBuffer() + fCount);
    }

    static size_t StorageSize(int glyphCount, int textSize,
                              SkTextBlob::GlyphPositioning positioning) {
        static_assert(SkIsAlign4(sizeof(SkScalar)), "SkScalar size alignment");
        // RunRecord object + (aligned) glyph buffer + position buffer
        size_t size = sizeof(SkTextBlob::RunRecord)
                      + SkAlign4(glyphCount* sizeof(uint16_t))
                      + PosCount(glyphCount, positioning) * sizeof(SkScalar);
        if (textSize > 0) {  // Extended run.
            size += sizeof(uint32_t)
                + sizeof(uint32_t) * glyphCount
                + textSize;
        }
        return SkAlignPtr(size);
    }

    static const RunRecord* First(const SkTextBlob* blob) {
        // The first record (if present) is stored following the blob object.
        return reinterpret_cast<const RunRecord*>(blob + 1);
    }

    static const RunRecord* Next(const RunRecord* run) {
        return reinterpret_cast<const RunRecord*>(
                reinterpret_cast<const uint8_t*>(run)
                + StorageSize(run->glyphCount(), run->textSize(), run->positioning()));
    }

    void validate(const uint8_t* storageTop) const {
        SkASSERT(kRunRecordMagic == fMagic);
        SkASSERT((uint8_t*)Next(this) <= storageTop);

        SkASSERT(glyphBuffer() + fCount <= (uint16_t*)posBuffer());
        SkASSERT(posBuffer() + fCount * ScalarsPerGlyph(fPositioning) <= (SkScalar*)Next(this));
        if (fExtended) {
            SkASSERT(textSize() > 0);
            SkASSERT(textSizePtr() < (uint32_t*)Next(this));
            SkASSERT(clusterBuffer() < (uint32_t*)Next(this));
            SkASSERT(textBuffer() + textSize() <= (char*)Next(this));
        }
        static_assert(sizeof(SkTextBlob::RunRecord) == sizeof(RunRecordStorageEquivalent),
                      "runrecord_should_stay_packed");
    }

private:
    friend class SkTextBlobBuilder;

    static size_t PosCount(int glyphCount,
                           SkTextBlob::GlyphPositioning positioning) {
        return glyphCount * ScalarsPerGlyph(positioning);
    }
    
    uint32_t* textSizePtr() const {
        // textSize follows the position buffer.
        SkASSERT(fExtended);
        return (uint32_t*)(&this->posBuffer()[PosCount(fCount, fPositioning)]);
    }

    void grow(uint32_t count) {
        SkScalar* initialPosBuffer = posBuffer();
        uint32_t initialCount = fCount;
        fCount += count;

        // Move the initial pos scalars to their new location.
        size_t copySize = initialCount * sizeof(SkScalar) * ScalarsPerGlyph(fPositioning);
        SkASSERT((uint8_t*)posBuffer() + copySize <= (uint8_t*)Next(this));

        // memmove, as the buffers may overlap
        memmove(posBuffer(), initialPosBuffer, copySize);
    }

    RunFont          fFont;
    uint32_t         fCount;
    SkPoint          fOffset;
    GlyphPositioning fPositioning;
    bool             fExtended;

    SkDEBUGCODE(unsigned fMagic;)
};

static int32_t gNextID = 1;
static int32_t next_id() {
    int32_t id;
    do {
        id = sk_atomic_inc(&gNextID);
    } while (id == SK_InvalidGenID);
    return id;
}

SkTextBlob::SkTextBlob(int runCount, const SkRect& bounds)
    : fRunCount(runCount)
    , fBounds(bounds)
    , fUniqueID(next_id()) {
}

SkTextBlob::~SkTextBlob() {
    const RunRecord* run = RunRecord::First(this);
    for (int i = 0; i < fRunCount; ++i) {
        const RunRecord* nextRun = RunRecord::Next(run);
        SkDEBUGCODE(run->validate((uint8_t*)this + fStorageSize);)
        run->~RunRecord();
        run = nextRun;
    }
}

namespace {
union PositioningAndExtended {
    int32_t intValue;
    struct {
        SkTextBlob::GlyphPositioning positioning;
        bool extended;
        uint16_t padding;
    };
};
} // namespace

void SkTextBlob::flatten(SkWriteBuffer& buffer) const {
    int runCount = fRunCount;

    buffer.write32(runCount);
    buffer.writeRect(fBounds);

    SkPaint runPaint;
    SkTextBlobRunIterator it(this);
    while (!it.done()) {
        SkASSERT(it.glyphCount() > 0);

        buffer.write32(it.glyphCount());
        PositioningAndExtended pe;
        pe.intValue = 0;
        pe.positioning = it.positioning();
        SkASSERT((int32_t)it.positioning() == pe.intValue);  // backwards compat.

        uint32_t textSize = it.textSize();
        pe.extended = textSize > 0;
        buffer.write32(pe.intValue);
        if (pe.extended) {
            buffer.write32(textSize);
        }
        buffer.writePoint(it.offset());
        // This should go away when switching to SkFont
        it.applyFontToPaint(&runPaint);
        buffer.writePaint(runPaint);

        buffer.writeByteArray(it.glyphs(), it.glyphCount() * sizeof(uint16_t));
        buffer.writeByteArray(it.pos(),
            it.glyphCount() * sizeof(SkScalar) * ScalarsPerGlyph(it.positioning()));
        if (pe.extended) {
            buffer.writeByteArray(it.clusters(), sizeof(uint32_t) * it.glyphCount());
            buffer.writeByteArray(it.text(), it.textSize());
        }

        it.next();
        SkDEBUGCODE(runCount--);
    }
    SkASSERT(0 == runCount);
}

sk_sp<SkTextBlob> SkTextBlob::MakeFromBuffer(SkReadBuffer& reader) {
    int runCount = reader.read32();
    if (runCount < 0) {
        return nullptr;
    }

    SkRect bounds;
    reader.readRect(&bounds);

    SkTextBlobBuilder blobBuilder;
    for (int i = 0; i < runCount; ++i) {
        int glyphCount = reader.read32();

        PositioningAndExtended pe;
        pe.intValue = reader.read32();
        GlyphPositioning pos = pe.positioning;
        if (glyphCount <= 0 || pos > kFull_Positioning) {
            return nullptr;
        }
        uint32_t textSize = pe.extended ? (uint32_t)reader.read32() : 0;

        SkPoint offset;
        reader.readPoint(&offset);
        SkPaint font;
        reader.readPaint(&font);

        const SkTextBlobBuilder::RunBuffer* buf = nullptr;
        switch (pos) {
        case kDefault_Positioning:
            buf = &blobBuilder.allocRunText(font, glyphCount, offset.x(), offset.y(),
                                            textSize, SkString(), &bounds);
            break;
        case kHorizontal_Positioning:
            buf = &blobBuilder.allocRunTextPosH(font, glyphCount, offset.y(),
                                                textSize, SkString(), &bounds);
            break;
        case kFull_Positioning:
            buf = &blobBuilder.allocRunTextPos(font, glyphCount, textSize, SkString(), &bounds);
            break;
        default:
            return nullptr;
        }

        if (!reader.readByteArray(buf->glyphs, glyphCount * sizeof(uint16_t)) ||
            !reader.readByteArray(buf->pos,
                                  glyphCount * sizeof(SkScalar) * ScalarsPerGlyph(pos))) {
            return nullptr;
        }

        if (pe.extended) {
            if (!reader.readByteArray(buf->clusters, glyphCount * sizeof(uint32_t))  ||
                !reader.readByteArray(buf->utf8text, textSize)) {
                return nullptr;
            }
        }
    }

    return blobBuilder.make();
}

unsigned SkTextBlob::ScalarsPerGlyph(GlyphPositioning pos) {
    // GlyphPositioning values are directly mapped to scalars-per-glyph.
    SkASSERT(pos <= 2);
    return pos;
}

SkTextBlobRunIterator::SkTextBlobRunIterator(const SkTextBlob* blob)
    : fCurrentRun(SkTextBlob::RunRecord::First(blob))
    , fRemainingRuns(blob->fRunCount) {
    SkDEBUGCODE(fStorageTop = (uint8_t*)blob + blob->fStorageSize;)
}

bool SkTextBlobRunIterator::done() const {
    return fRemainingRuns <= 0;
}

void SkTextBlobRunIterator::next() {
    SkASSERT(!this->done());

    if (!this->done()) {
        SkDEBUGCODE(fCurrentRun->validate(fStorageTop);)
        fCurrentRun = SkTextBlob::RunRecord::Next(fCurrentRun);
        fRemainingRuns--;
    }
}

uint32_t SkTextBlobRunIterator::glyphCount() const {
    SkASSERT(!this->done());
    return fCurrentRun->glyphCount();
}

const uint16_t* SkTextBlobRunIterator::glyphs() const {
    SkASSERT(!this->done());
    return fCurrentRun->glyphBuffer();
}

const SkScalar* SkTextBlobRunIterator::pos() const {
    SkASSERT(!this->done());
    return fCurrentRun->posBuffer();
}

const SkPoint& SkTextBlobRunIterator::offset() const {
    SkASSERT(!this->done());
    return fCurrentRun->offset();
}

SkTextBlob::GlyphPositioning SkTextBlobRunIterator::positioning() const {
    SkASSERT(!this->done());
    return fCurrentRun->positioning();
}

void SkTextBlobRunIterator::applyFontToPaint(SkPaint* paint) const {
    SkASSERT(!this->done());

    fCurrentRun->font().applyToPaint(paint);
}

uint32_t* SkTextBlobRunIterator::clusters() const {
    SkASSERT(!this->done());
    return fCurrentRun->clusterBuffer();
}
uint32_t SkTextBlobRunIterator::textSize() const {
    SkASSERT(!this->done());
    return fCurrentRun->textSize();
}
char* SkTextBlobRunIterator::text() const {
    SkASSERT(!this->done());
    return fCurrentRun->textBuffer();
}


bool SkTextBlobRunIterator::isLCD() const {
    return SkToBool(fCurrentRun->font().flags() & SkPaint::kLCDRenderText_Flag);
}

SkTextBlobBuilder::SkTextBlobBuilder()
    : fStorageSize(0)
    , fStorageUsed(0)
    , fRunCount(0)
    , fDeferredBounds(false)
    , fLastRun(0) {
    fBounds.setEmpty();
}

SkTextBlobBuilder::~SkTextBlobBuilder() {
    if (nullptr != fStorage.get()) {
        // We are abandoning runs and must destruct the associated font data.
        // The easiest way to accomplish that is to use the blob destructor.
        this->make();
    }
}

SkRect SkTextBlobBuilder::TightRunBounds(const SkTextBlob::RunRecord& run) {
    SkRect bounds;
    SkPaint paint;
    run.font().applyToPaint(&paint);

    if (SkTextBlob::kDefault_Positioning == run.positioning()) {
        paint.measureText(run.glyphBuffer(), run.glyphCount() * sizeof(uint16_t), &bounds);
        return bounds.makeOffset(run.offset().x(), run.offset().y());
    }

    SkAutoSTArray<16, SkRect> glyphBounds(run.glyphCount());
    paint.getTextWidths(run.glyphBuffer(),
                        run.glyphCount() * sizeof(uint16_t),
                        NULL,
                        glyphBounds.get());

    SkASSERT(SkTextBlob::kFull_Positioning == run.positioning() ||
             SkTextBlob::kHorizontal_Positioning == run.positioning());
    // kFull_Positioning       => [ x, y, x, y... ]
    // kHorizontal_Positioning => [ x, x, x... ]
    //                            (const y applied by runBounds.offset(run->offset()) later)
    const SkScalar horizontalConstY = 0;
    const SkScalar* glyphPosX = run.posBuffer();
    const SkScalar* glyphPosY = (run.positioning() == SkTextBlob::kFull_Positioning) ?
                                                      glyphPosX + 1 : &horizontalConstY;
    const unsigned posXInc = SkTextBlob::ScalarsPerGlyph(run.positioning());
    const unsigned posYInc = (run.positioning() == SkTextBlob::kFull_Positioning) ?
                                                   posXInc : 0;

    bounds.setEmpty();
    for (unsigned i = 0; i < run.glyphCount(); ++i) {
        bounds.join(glyphBounds[i].makeOffset(*glyphPosX, *glyphPosY));
        glyphPosX += posXInc;
        glyphPosY += posYInc;
    }

    SkASSERT((void*)glyphPosX <= SkTextBlob::RunRecord::Next(&run));

    return bounds.makeOffset(run.offset().x(), run.offset().y());
}

SkRect SkTextBlobBuilder::ConservativeRunBounds(const SkTextBlob::RunRecord& run) {
    SkASSERT(run.glyphCount() > 0);
    SkASSERT(SkTextBlob::kFull_Positioning == run.positioning() ||
             SkTextBlob::kHorizontal_Positioning == run.positioning());

    SkPaint paint;
    run.font().applyToPaint(&paint);
    const SkRect fontBounds = paint.getFontBounds();
    if (fontBounds.isEmpty()) {
        // Empty font bounds are likely a font bug.  TightBounds has a better chance of
        // producing useful results in this case.
        return TightRunBounds(run);
    }

    // Compute the glyph position bbox.
    SkRect bounds;
    switch (run.positioning()) {
    case SkTextBlob::kHorizontal_Positioning: {
        const SkScalar* glyphPos = run.posBuffer();
        SkASSERT((void*)(glyphPos + run.glyphCount()) <= SkTextBlob::RunRecord::Next(&run));

        SkScalar minX = *glyphPos;
        SkScalar maxX = *glyphPos;
        for (unsigned i = 1; i < run.glyphCount(); ++i) {
            SkScalar x = glyphPos[i];
            minX = SkMinScalar(x, minX);
            maxX = SkMaxScalar(x, maxX);
        }

        bounds.setLTRB(minX, 0, maxX, 0);
    } break;
    case SkTextBlob::kFull_Positioning: {
        const SkPoint* glyphPosPts = reinterpret_cast<const SkPoint*>(run.posBuffer());
        SkASSERT((void*)(glyphPosPts + run.glyphCount()) <= SkTextBlob::RunRecord::Next(&run));

        bounds.setBounds(glyphPosPts, run.glyphCount());
    } break;
    default:
        SkFAIL("unsupported positioning mode");
    }

    // Expand by typeface glyph bounds.
    bounds.fLeft   += fontBounds.left();
    bounds.fTop    += fontBounds.top();
    bounds.fRight  += fontBounds.right();
    bounds.fBottom += fontBounds.bottom();

    // Offset by run position.
    return bounds.makeOffset(run.offset().x(), run.offset().y());
}

void SkTextBlobBuilder::updateDeferredBounds() {
    SkASSERT(!fDeferredBounds || fRunCount > 0);

    if (!fDeferredBounds) {
        return;
    }

    SkASSERT(fLastRun >= sizeof(SkTextBlob));
    SkTextBlob::RunRecord* run = reinterpret_cast<SkTextBlob::RunRecord*>(fStorage.get() +
                                                                          fLastRun);

    // FIXME: we should also use conservative bounds for kDefault_Positioning.
    SkRect runBounds = SkTextBlob::kDefault_Positioning == run->positioning() ?
                       TightRunBounds(*run) : ConservativeRunBounds(*run);
    fBounds.join(runBounds);
    fDeferredBounds = false;
}

void SkTextBlobBuilder::reserve(size_t size) {
    // We don't currently pre-allocate, but maybe someday...
    if (fStorageUsed + size <= fStorageSize) {
        return;
    }

    if (0 == fRunCount) {
        SkASSERT(nullptr == fStorage.get());
        SkASSERT(0 == fStorageSize);
        SkASSERT(0 == fStorageUsed);

        // the first allocation also includes blob storage
        fStorageUsed += sizeof(SkTextBlob);
    }

    fStorageSize = fStorageUsed + size;
    // FYI: This relies on everything we store being relocatable, particularly SkPaint.
    fStorage.realloc(fStorageSize);
}

bool SkTextBlobBuilder::mergeRun(const SkPaint &font, SkTextBlob::GlyphPositioning positioning,
                                 int count, SkPoint offset) {
    if (0 == fLastRun) {
        SkASSERT(0 == fRunCount);
        return false;
    }

    SkASSERT(fLastRun >= sizeof(SkTextBlob));
    SkTextBlob::RunRecord* run = reinterpret_cast<SkTextBlob::RunRecord*>(fStorage.get() +
                                                                          fLastRun);
    SkASSERT(run->glyphCount() > 0);

    if (run->textSize() != 0) {
        return false;
    }

    if (run->positioning() != positioning
        || run->font() != font
        || (run->glyphCount() + count < run->glyphCount())) {
        return false;
    }

    // we can merge same-font/same-positioning runs in the following cases:
    //   * fully positioned run following another fully positioned run
    //   * horizontally postioned run following another horizontally positioned run with the same
    //     y-offset
    if (SkTextBlob::kFull_Positioning != positioning
        && (SkTextBlob::kHorizontal_Positioning != positioning
            || run->offset().y() != offset.y())) {
        return false;
    }

    size_t sizeDelta = SkTextBlob::RunRecord::StorageSize(run->glyphCount() + count, 0, positioning) -
                       SkTextBlob::RunRecord::StorageSize(run->glyphCount(), 0, positioning);
    this->reserve(sizeDelta);

    // reserve may have realloced
    run = reinterpret_cast<SkTextBlob::RunRecord*>(fStorage.get() + fLastRun);
    uint32_t preMergeCount = run->glyphCount();
    run->grow(count);

    // Callers expect the buffers to point at the newly added slice, ant not at the beginning.
    fCurrentRunBuffer.glyphs = run->glyphBuffer() + preMergeCount;
    fCurrentRunBuffer.pos = run->posBuffer()
                          + preMergeCount * SkTextBlob::ScalarsPerGlyph(positioning);

    fStorageUsed += sizeDelta;

    SkASSERT(fStorageUsed <= fStorageSize);
    run->validate(fStorage.get() + fStorageUsed);

    return true;
}

void SkTextBlobBuilder::allocInternal(const SkPaint &font,
                                      SkTextBlob::GlyphPositioning positioning,
                                      int count, int textSize, SkPoint offset, const SkRect* bounds) {
    SkASSERT(count > 0);
    SkASSERT(textSize >= 0);
    SkASSERT(SkPaint::kGlyphID_TextEncoding == font.getTextEncoding());
    if (textSize != 0 || !this->mergeRun(font, positioning, count, offset)) {
        this->updateDeferredBounds();

        size_t runSize = SkTextBlob::RunRecord::StorageSize(count, textSize, positioning);
        this->reserve(runSize);

        SkASSERT(fStorageUsed >= sizeof(SkTextBlob));
        SkASSERT(fStorageUsed + runSize <= fStorageSize);

        SkTextBlob::RunRecord* run = new (fStorage.get() + fStorageUsed)
            SkTextBlob::RunRecord(count, textSize, offset, font, positioning);
        fCurrentRunBuffer.glyphs = run->glyphBuffer();
        fCurrentRunBuffer.pos = run->posBuffer();
        fCurrentRunBuffer.utf8text = run->textBuffer();
        fCurrentRunBuffer.clusters = run->clusterBuffer();

        fLastRun = fStorageUsed;
        fStorageUsed += runSize;
        fRunCount++;

        SkASSERT(fStorageUsed <= fStorageSize);
        run->validate(fStorage.get() + fStorageUsed);
    }
    SkASSERT(textSize > 0 || nullptr == fCurrentRunBuffer.utf8text);
    SkASSERT(textSize > 0 || nullptr == fCurrentRunBuffer.clusters);
    if (!fDeferredBounds) {
        if (bounds) {
            fBounds.join(*bounds);
        } else {
            fDeferredBounds = true;
        }
    }
}

const SkTextBlobBuilder::RunBuffer& SkTextBlobBuilder::allocRunText(const SkPaint& font, int count,
                                                                    SkScalar x, SkScalar y,
                                                                    int textByteCount,
                                                                    SkString lang,
                                                                    const SkRect* bounds) {
    this->allocInternal(font, SkTextBlob::kDefault_Positioning, count, textByteCount, SkPoint::Make(x, y), bounds);
    return fCurrentRunBuffer;
}

const SkTextBlobBuilder::RunBuffer& SkTextBlobBuilder::allocRunTextPosH(const SkPaint& font, int count,
                                                                        SkScalar y,
                                                                        int textByteCount,
                                                                        SkString lang,
                                                                        const SkRect* bounds) {
    this->allocInternal(font, SkTextBlob::kHorizontal_Positioning, count, textByteCount, SkPoint::Make(0, y),
                        bounds);

    return fCurrentRunBuffer;
}

const SkTextBlobBuilder::RunBuffer& SkTextBlobBuilder::allocRunTextPos(const SkPaint& font, int count,
                                                                       int textByteCount,
                                                                       SkString lang,
                                                                       const SkRect *bounds) {
   this->allocInternal(font, SkTextBlob::kFull_Positioning, count, textByteCount, SkPoint::Make(0, 0), bounds);

    return fCurrentRunBuffer;
}

sk_sp<SkTextBlob> SkTextBlobBuilder::make() {
    SkASSERT((fRunCount > 0) == (nullptr != fStorage.get()));

    this->updateDeferredBounds();

    if (0 == fRunCount) {
        SkASSERT(nullptr == fStorage.get());
        fStorageUsed = sizeof(SkTextBlob);
        fStorage.realloc(fStorageUsed);
    }

    SkTextBlob* blob = new (fStorage.release()) SkTextBlob(fRunCount, fBounds);
    SkDEBUGCODE(const_cast<SkTextBlob*>(blob)->fStorageSize = fStorageSize;)

    SkDEBUGCODE(
        size_t validateSize = sizeof(SkTextBlob);
        const SkTextBlob::RunRecord* run = SkTextBlob::RunRecord::First(blob);
        for (int i = 0; i < fRunCount; ++i) {
            validateSize += SkTextBlob::RunRecord::StorageSize(
                    run->fCount, run->textSize(), run->fPositioning);
            run->validate(reinterpret_cast<const uint8_t*>(blob) + fStorageUsed);
            run = SkTextBlob::RunRecord::Next(run);
        }
        SkASSERT(validateSize == fStorageUsed);
    )

    fStorageUsed = 0;
    fStorageSize = 0;
    fRunCount = 0;
    fLastRun = 0;
    fBounds.setEmpty();

    return sk_sp<SkTextBlob>(blob);
}
