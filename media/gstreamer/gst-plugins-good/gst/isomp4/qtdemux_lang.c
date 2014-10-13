/* GStreamer Quicktime/ISO demuxer language utility functions
 * Copyright (C) 2010 Tim-Philipp Müller <tim centricular net>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 51 Franklin St, Fifth Floor,
 * Boston, MA 02110-1301, USA.
 */

#include "qtdemux.h"
#include "qtdemux_lang.h"

#include <string.h>

/* http://developer.apple.com/mac/library/documentation/QuickTime/QTFF/QTFFChap4/qtff4.html */

static const gchar qt_lang_map[][4] = {

/* 000 English
 * 001 French
 * 002 German
 * 003 Italian
 * 004 Dutch
 * 005 Swedish
 * 006 Spanish
 * 007 Danish
 * 008 Portuguese
 * 009 Norwegian
 */
  "eng", "fre", "deu", "ita", "nld", "swe", "spa", "dan", "por", "nor",

/* 010 Hebrew
 * 011 Japanese
 * 012 Arabic
 * 013 Finnish
 * 014 Greek
 * 015 Icelandic
 * 016 Maltese
 * 017 Turkish
 * 018 Croatian
 * 019 Traditional Chinese (ISO 639-2 can't express script differences, so zho)
 */
  "heb", "jpn", "ara", "fin", "ell", "isl", "mlt", "tur", "hrv", "zho",

/* 020 Urdu
 * 021 Hindi
 * 022 Thai
 * 023 Korean
 * 024 Lithuanian
 * 025 Polish
 * 026 Hungarian
 * 027 Estonian
 * 028 Latvian / Lettish
 * 029 Lappish / Saamish (used code for Nothern Sami)
 */
  "urd", "hin", "tha", "kor", "lit", "pol", "hun", "est", "lav", "sme",

/* 030 Faeroese
 * 031 Farsi
 * 032 Russian
 * 033 Simplified Chinese (ISO 639-2 can't express script differences, so zho)
 * 034 Flemish (no ISO 639-2 code, used Dutch code)
 * 035 Irish
 * 036 Albanian
 * 037 Romanian
 * 038 Czech
 * 039 Slovak
 */
  "fao", "fas", "rus", "zho", "nld", "gle", "sqi", "ron", "ces", "slk",

/* 040 Slovenian
 * 041 Yiddish
 * 042 Serbian
 * 043 Macedonian
 * 044 Bulgarian
 * 045 Ukrainian
 * 046 Byelorussian
 * 047 Uzbek
 * 048 Kazakh
 * 049 Azerbaijani
 */
  "slv", "yid", "srp", "mkd", "bul", "ukr", "bel", "uzb", "kaz", "aze",

/* 050 AzerbaijanAr (presumably script difference? used aze here)
 * 051 Armenian
 * 052 Georgian
 * 053 Moldavian
 * 054 Kirghiz
 * 055 Tajiki
 * 056 Turkmen
 * 057 Mongolian
 * 058 MongolianCyr (presumably script difference? used mon here)
 * 059 Pashto
 */

  "aze", "hye", "kat", "mol", "kir", "tgk", "tuk", "mon", "mon", "pus",


/* 060 Kurdish
 * 061 Kashmiri
 * 062 Sindhi
 * 063 Tibetan
 * 064 Nepali
 * 065 Sanskrit
 * 066 Marathi
 * 067 Bengali
 * 068 Assamese
 * 069 Gujarati
 */
  "kur", "kas", "snd", "bod", "nep", "san", "mar", "ben", "asm", "guj",

/* 070 Punjabi
 * 071 Oriya
 * 072 Malayalam
 * 073 Kannada
 * 074 Tamil
 * 075 Telugu
 * 076 Sinhalese
 * 077 Burmese
 * 078 Khmer
 * 079 Lao
 */
  "pan", "ori", "mal", "kan", "tam", "tel", "sin", "mya", "khm", "lao",

/* 080 Vietnamese
 * 081 Indonesian
 * 082 Tagalog
 * 083 MalayRoman
 * 084 MalayArabic
 * 085 Amharic
 * 087 Galla (same as Oromo?)
 * 087 Oromo
 * 088 Somali
 * 089 Swahili
 */
  "vie", "ind", "tgl", "msa", "msa", "amh", "orm", "orm", "som", "swa",

/* 090 Ruanda
 * 091 Rundi
 * 092 Chewa
 * 093 Malagasy
 * 094 Esperanto
 * 095 ---
 * 096 ---
 * 097 ---
 * 098 ---
 * 099 ---
 */
  "kin", "run", "nya", "mlg", "ep", "und", "und", "und", "und", "und",

/* 100-109 ---
 * 110-119 ---
 */
  "und", "und", "und", "und", "und", "und", "und", "und", "und", "und",
  "und", "und", "und", "und", "und", "und", "und", "und", "und", "und",

/* 120-127 ---
 * 128 Welsh
 * 129 Basque
 */
  "und", "und", "und", "und", "und", "und", "und", "und", "cym", "eus",

/* 130 Catalan
 * 131 Latin
 * 132 Quechua
 * 133 Guarani
 * 134 Aymara
 * 135 Tatar
 * 136 Uighur
 * 137 Dzongkha
 * 138 JavaneseRom
 */
  "cat", "lat", "que", "grn", "aym", "tat", "uig", "dzo", "jav"
};

/* map quicktime language code to ISO-639-2T id, returns "und" if unknown */
void
qtdemux_lang_map_qt_code_to_iso (gchar id[4], guint16 qt_lang_code)
{
  const gchar *iso_code;

  g_assert (qt_lang_code < 0x800);

  if (qt_lang_code < G_N_ELEMENTS (qt_lang_map))
    iso_code = qt_lang_map[qt_lang_code];
  else
    iso_code = "und";

  GST_DEBUG ("mapped quicktime language code %u to ISO 639-2T code '%s'",
      qt_lang_code, iso_code);

  memcpy (id, iso_code, 4);

  g_assert (id[3] == '\0');
}
