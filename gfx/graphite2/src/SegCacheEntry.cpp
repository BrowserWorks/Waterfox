/*  GRAPHITE2 LICENSING

    Copyright 2010, SIL International
    All rights reserved.

    This library is free software; you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published
    by the Free Software Foundation; either version 2.1 of License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should also have received a copy of the GNU Lesser General Public
    License along with this library in the file named "LICENSE".
    If not, write to the Free Software Foundation, 51 Franklin Street,
    Suite 500, Boston, MA 02110-1335, USA or visit their web page on the
    internet at http://www.fsf.org/licenses/lgpl.html.

Alternatively, the contents of this file may be used under the terms of the
Mozilla Public License (http://mozilla.org/MPL) or the GNU General Public
License, as published by the Free Software Foundation, either version 2
of the License or (at your option) any later version.
*/

#ifndef GRAPHITE2_NSEGCACHE

#include "inc/Main.h"
#include "inc/Slot.h"
#include "inc/Segment.h"
#include "inc/SegCache.h"
#include "inc/SegCacheEntry.h"


using namespace graphite2;

SegCacheEntry::SegCacheEntry(const uint16* cmapGlyphs, size_t length, Segment * seg, size_t charOffset, long long cacheTime)
    : m_glyphLength(0), m_unicode(gralloc<uint16>(length)), m_glyph(NULL),
    m_attr(NULL), m_justs(NULL),
    m_accessCount(0), m_lastAccess(cacheTime)
{
    if (m_unicode)
        for (size_t i = 0; i < length; i++)
            m_unicode[i] = cmapGlyphs[i];

    const size_t    glyphCount = seg->slotCount(),
                    sizeof_sjust = SlotJustify::size_of(seg->silf()->numJustLevels());
    if (!glyphCount) return;
    size_t num_justs = 0,
           justs_pos = 0;
    if (seg->hasJustification())
    {
        for (const Slot * s = seg->first(); s; s = s->next())
        {
            if (s->m_justs == 0)    continue;
            ++num_justs;
        }
        m_justs = gralloc<byte>(sizeof_sjust * num_justs);
    }
    const Slot * slot = seg->first();
    m_glyph = new Slot[glyphCount];
    m_attr = gralloc<int16>(glyphCount * seg->numAttrs());
    if (!m_glyph || (!m_attr && seg->numAttrs())) return;
    m_glyphLength = glyphCount;
    Slot * slotCopy = m_glyph;
    m_glyph->prev(NULL);

    uint16 pos = 0;
    while (slot)
    {
        slotCopy->userAttrs(m_attr + pos * seg->numAttrs());
        slotCopy->m_justs = m_justs ? reinterpret_cast<SlotJustify *>(m_justs + justs_pos++ * sizeof_sjust) : 0;
        slotCopy->set(*slot, -static_cast<int32>(charOffset), seg->numAttrs(), seg->silf()->numJustLevels(), length);
        slotCopy->index(pos);
        if (slot->firstChild())
            slotCopy->m_child = m_glyph + slot->firstChild()->index();
        if (slot->attachedTo())
            slotCopy->attachTo(m_glyph + slot->attachedTo()->index());
        if (slot->nextSibling())
            slotCopy->m_sibling = m_glyph + slot->nextSibling()->index();
        slot = slot->next();
        ++slotCopy;
        ++pos;
        if (slot)
        {
            slotCopy->prev(slotCopy-1);
            (slotCopy-1)->next(slotCopy);
        }
    }
}


void SegCacheEntry::clear()
{
    free(m_unicode);
    free(m_attr);
    free(m_justs);
    delete [] m_glyph;
    m_unicode = NULL;
    m_glyph = NULL;
    m_glyphLength = 0;
    m_attr = NULL;
}

#endif

