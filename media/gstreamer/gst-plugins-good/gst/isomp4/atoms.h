/* Quicktime muxer plugin for GStreamer
 * Copyright (C) 2008-2010 Thiago Santos <thiagoss@embedded.ufcg.edu.br>
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
/*
 * Unless otherwise indicated, Source Code is licensed under MIT license.
 * See further explanation attached in License Statement (distributed in the file
 * LICENSE).
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is furnished to do
 * so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#ifndef __ATOMS_H__
#define __ATOMS_H__

#include <glib.h>
#include <string.h>

#include "descriptors.h"
#include "properties.h"
#include "fourcc.h"

/* helper storage struct */
#define ATOM_ARRAY(struct_type) \
struct { \
  guint size; \
  guint len; \
  struct_type *data; \
}

/* storage helpers */

#define atom_array_init(array, reserve)                                       \
G_STMT_START {                                                                \
  (array)->len = 0;                                                           \
  (array)->size = reserve;                                                    \
  (array)->data = g_malloc (sizeof (*(array)->data) * reserve);               \
} G_STMT_END

#define atom_array_append(array, elmt, inc)                                   \
G_STMT_START {                                                                \
  g_assert ((array)->data);                                                   \
  g_assert (inc > 0);                                                         \
  if (G_UNLIKELY ((array)->len == (array)->size)) {                           \
    (array)->size += inc;                                                     \
    (array)->data =                                                           \
        g_realloc ((array)->data, sizeof (*((array)->data)) * (array)->size); \
  }                                                                           \
  (array)->data[(array)->len] = elmt;                                         \
  (array)->len++;                                                             \
} G_STMT_END

#define atom_array_get_len(array)                  ((array)->len)
#define atom_array_index(array, index)             ((array)->data[index])

#define atom_array_clear(array)                                               \
G_STMT_START {                                                                \
  (array)->size = (array)->len = 0;                                           \
  g_free ((array)->data);                                                     \
  (array)->data = NULL;                                                       \
} G_STMT_END

/* light-weight context that may influence header atom tree construction */
typedef enum _AtomsTreeFlavor
{
  ATOMS_TREE_FLAVOR_MOV,
  ATOMS_TREE_FLAVOR_ISOM,
  ATOMS_TREE_FLAVOR_3GP,
  ATOMS_TREE_FLAVOR_ISML
} AtomsTreeFlavor;

typedef struct _AtomsContext
{
  AtomsTreeFlavor flavor;
} AtomsContext;

AtomsContext* atoms_context_new  (AtomsTreeFlavor flavor);
void          atoms_context_free (AtomsContext *context);

#define METADATA_DATA_FLAG 0x0
#define METADATA_TEXT_FLAG 0x1

/* atom defs and functions */

/**
 * Used for storing time related values for some atoms.
 */
typedef struct _TimeInfo
{
  guint64 creation_time;
  guint64 modification_time;
  guint32 timescale;
  guint64 duration;
} TimeInfo;

typedef struct _Atom
{
  guint32 size;
  guint32 type;
  guint64 extended_size;
} Atom;

typedef struct _AtomFull
{
  Atom header;

  guint8 version;
  guint8 flags[3];
} AtomFull;

/*
 * Generic extension atom
 */
typedef struct _AtomData
{
  Atom header;

  /* not written */
  guint32 datalen;

  guint8 *data;
} AtomData;

typedef struct _AtomUUID
{
  Atom header;

  guint8 uuid[16];

  /* not written */
  guint32 datalen;

  guint8 *data;
} AtomUUID;

typedef struct _AtomFTYP
{
  Atom header;
  guint32 major_brand;
  guint32 version;
  guint32 *compatible_brands;

  /* not written */
  guint32 compatible_brands_size;
} AtomFTYP;

typedef struct _AtomMVHD
{
  AtomFull header;

  /* version 0: 32 bits */
  TimeInfo time_info;

  guint32 prefered_rate;      /* ISO: 0x00010000 */
  guint16 volume;             /* ISO: 0x0100 */
  guint16 reserved3;          /* ISO: 0x0 */
  guint32 reserved4[2];       /* ISO: 0, 0 */
  /* ISO: identity matrix =
   * { 0x00010000, 0, 0, 0, 0x00010000, 0, 0, 0, 0x40000000 } */
  guint32 matrix[9];

  /* ISO: all 0 */
  guint32 preview_time;
  guint32 preview_duration;
  guint32 poster_time;
  guint32 selection_time;
  guint32 selection_duration;
  guint32 current_time;

  guint32 next_track_id;
} AtomMVHD;

typedef struct _AtomTKHD
{
  AtomFull header;

  /* version 0: 32 bits */
  /* like the TimeInfo struct, but it has this track_ID inside */
  guint64 creation_time;
  guint64 modification_time;
  guint32 track_ID;
  guint32 reserved;
  guint64 duration;

  guint32 reserved2[2];
  guint16 layer;
  guint16 alternate_group;
  guint16 volume;
  guint16 reserved3;

  /* ISO: identity matrix =
   * { 0x00010000, 0, 0, 0, 0x00010000, 0, 0, 0, 0x40000000 } */
  guint32 matrix[9];
  guint32 width;
  guint32 height;
} AtomTKHD;

typedef struct _AtomMDHD
{
  AtomFull header;

  /* version 0: 32 bits */
  TimeInfo time_info;

  /* ISO: packed ISO-639-2/T language code (first bit must be 0) */
  guint16 language_code;
  /* ISO: 0 */
  guint16 quality;
} AtomMDHD;

typedef struct _AtomHDLR
{
  AtomFull header;

  /* ISO: 0 */
  guint32 component_type;
  guint32 handler_type;
  guint32 manufacturer;
  guint32 flags;
  guint32 flags_mask;
  gchar *name;

  AtomsTreeFlavor flavor;
} AtomHDLR;

typedef struct _AtomVMHD
{
  AtomFull header;          /* ISO: flags = 1 */

  guint16 graphics_mode;
  /* RGB */
  guint16 opcolor[3];
} AtomVMHD;

typedef struct _AtomSMHD
{
  AtomFull header;

  guint16 balance;
  guint16 reserved;
} AtomSMHD;

typedef struct _AtomHMHD
{
  AtomFull header;

  guint16 max_pdu_size;
  guint16 avg_pdu_size;
  guint32 max_bitrate;
  guint32 avg_bitrate;
  guint32 sliding_avg_bitrate;
} AtomHMHD;

typedef struct _AtomURL
{
  AtomFull header;

  gchar *location;
} AtomURL;

typedef struct _AtomDREF
{
  AtomFull header;

  GList *entries;
} AtomDREF;

typedef struct _AtomDINF
{
  Atom header;

  AtomDREF dref;
} AtomDINF;

typedef struct _STTSEntry
{
  guint32 sample_count;
  gint32 sample_delta;
} STTSEntry;

typedef struct _AtomSTTS
{
  AtomFull header;

  ATOM_ARRAY (STTSEntry) entries;
} AtomSTTS;

typedef struct _AtomSTSS
{
  AtomFull header;

  ATOM_ARRAY (guint32) entries;
} AtomSTSS;

typedef struct _AtomESDS
{
  AtomFull header;

  ESDescriptor es;
} AtomESDS;

typedef struct _AtomFRMA
{
  Atom header;

  guint32 media_type;
} AtomFRMA;

typedef enum _SampleEntryKind
{
  UNKNOWN,
  AUDIO,
  VIDEO,
  SUBTITLE,
} SampleEntryKind;

typedef struct _SampleTableEntry
{
  Atom header;

  guint8 reserved[6];
  guint16 data_reference_index;

  /* type of entry */
  SampleEntryKind kind;
} SampleTableEntry;

typedef struct _AtomHintSampleEntry
{
  SampleTableEntry se;
  guint32 size;
  guint8 *data;
} AtomHintSampleEntry;

typedef struct _SampleTableEntryMP4V
{
  SampleTableEntry se;

  guint16 version;
  guint16 revision_level;

  guint32 vendor;                 /* fourcc code */
  guint32 temporal_quality;
  guint32 spatial_quality;

  guint16 width;
  guint16 height;

  guint32 horizontal_resolution;
  guint32 vertical_resolution;
  guint32 datasize;

  guint16 frame_count;            /* usually 1 */

  guint8 compressor[32];         /* pascal string, i.e. first byte = length */

  guint16 depth;
  guint16 color_table_id;

  /* (optional) list of AtomInfo */
  GList *extension_atoms;
} SampleTableEntryMP4V;

typedef struct _SampleTableEntryMP4A
{
  SampleTableEntry se;

  guint16 version;
  guint16 revision_level;
  guint32 vendor;

  guint16 channels;
  guint16 sample_size;
  guint16 compression_id;
  guint16 packet_size;

  guint32 sample_rate;            /* fixed point 16.16 */

  guint32 samples_per_packet;
  guint32 bytes_per_packet;
  guint32 bytes_per_frame;
  guint32 bytes_per_sample;

  /* (optional) list of AtomInfo */
  GList *extension_atoms;
} SampleTableEntryMP4A;

typedef struct _SampleTableEntryMP4S
{
  SampleTableEntry se;

  AtomESDS es;
} SampleTableEntryMP4S;

typedef struct _SampleTableEntryTX3G
{
  SampleTableEntry se;

  guint32 display_flags;
  guint64 default_text_box;
  guint16 font_id;
  guint8  font_face; /* bold=0x1, italic=0x2, underline=0x4 */
  guint8  font_size; /* should always be 0.05 multiplied by the video track header height */
  guint32 foreground_color_rgba;

} SampleTableEntryTX3G;

typedef struct _AtomSTSD
{
  AtomFull header;

  guint n_entries;
  /* list of subclasses of SampleTableEntry */
  GList *entries;
} AtomSTSD;

typedef struct _AtomSTSZ
{
  AtomFull header;

  guint32 sample_size;

  /* need the size here because when sample_size is constant,
   * the list is empty */
  guint32 table_size;
  ATOM_ARRAY (guint32) entries;
} AtomSTSZ;

typedef struct _STSCEntry
{
  guint32 first_chunk;
  guint32 samples_per_chunk;
  guint32 sample_description_index;
} STSCEntry;

typedef struct _AtomSTSC
{
  AtomFull header;

  ATOM_ARRAY (STSCEntry) entries;
} AtomSTSC;


/*
 * used for both STCO and CO64
 * if used as STCO, entries should be truncated to use only 32bits
 */
typedef struct _AtomSTCO64
{
  AtomFull header;

  ATOM_ARRAY (guint64) entries;
} AtomSTCO64;

typedef struct _CTTSEntry
{
  guint32 samplecount;
  guint32 sampleoffset;
} CTTSEntry;

typedef struct _AtomCTTS
{
  AtomFull header;

  /* also entry count here */
  ATOM_ARRAY (CTTSEntry) entries;
  gboolean do_pts;
} AtomCTTS;

typedef struct _AtomSTBL
{
  Atom header;

  AtomSTSD stsd;
  AtomSTTS stts;
  AtomSTSS stss;
  AtomSTSC stsc;
  AtomSTSZ stsz;
  /* NULL if not present */
  AtomCTTS *ctts;

  AtomSTCO64 stco64;
} AtomSTBL;

typedef struct _AtomMINF
{
  Atom header;

  /* only (exactly) one of those must be present */
  AtomVMHD *vmhd;
  AtomSMHD *smhd;
  AtomHMHD *hmhd;

  AtomHDLR *hdlr;
  AtomDINF dinf;
  AtomSTBL stbl;
} AtomMINF;

typedef struct _EditListEntry
{
  /* duration in movie's timescale */
  guint32 duration;
  /* start time in media's timescale, -1 for empty */
  guint32 media_time;
  guint32 media_rate;  /* fixed point 32 bit */
} EditListEntry;

typedef struct _AtomELST
{
  AtomFull header;

  /* number of entries is implicit */
  GSList *entries;
} AtomELST;

typedef struct _AtomEDTS
{
  Atom header;
  AtomELST elst;
} AtomEDTS;

typedef struct _AtomMDIA
{
  Atom header;

  AtomMDHD mdhd;
  AtomHDLR hdlr;
  AtomMINF minf;
} AtomMDIA;

typedef struct _AtomILST
{
  Atom header;

  /* list of AtomInfo */
  GList* entries;
} AtomILST;

typedef struct _AtomTagData
{
  AtomFull header;
  guint32 reserved;

  guint32 datalen;
  guint8* data;
} AtomTagData;

typedef struct _AtomTag
{
  Atom header;

  AtomTagData data;
} AtomTag;

typedef struct _AtomMETA
{
  AtomFull header;
  AtomHDLR hdlr;
  AtomILST *ilst;
} AtomMETA;

typedef struct _AtomUDTA
{
  Atom header;

  /* list of AtomInfo */
  GList* entries;
  /* or list is further down */
  AtomMETA *meta;
} AtomUDTA;

enum TrFlags
{
  TR_DATA_OFFSET              = 0x01,     /* data-offset-present */
  TR_FIRST_SAMPLE_FLAGS       = 0x04,     /* first-sample-flags-present */
  TR_SAMPLE_DURATION          = 0x0100,   /* sample-duration-present */
  TR_SAMPLE_SIZE              = 0x0200,   /* sample-size-present */
  TR_SAMPLE_FLAGS             = 0x0400,   /* sample-flags-present */
  TR_COMPOSITION_TIME_OFFSETS = 0x0800    /* sample-composition-time-offsets-presents */
};

enum TfFlags
{
  TF_BASE_DATA_OFFSET         = 0x01,     /* base-data-offset-present */
  TF_SAMPLE_DESCRIPTION_INDEX = 0x02,     /* sample-description-index-present */
  TF_DEFAULT_SAMPLE_DURATION  = 0x08,     /* default-sample-duration-present */
  TF_DEFAULT_SAMPLE_SIZE      = 0x010,    /* default-sample-size-present */
  TF_DEFAULT_SAMPLE_FLAGS     = 0x020,    /* default-sample-flags-present */
  TF_DURATION_IS_EMPTY        = 0x010000  /* sample-composition-time-offsets-presents */
};

typedef struct _AtomTRAK
{
  Atom header;

  AtomTKHD tkhd;
  AtomEDTS *edts;
  AtomMDIA mdia;

  /* some helper info for structural conformity checks */
  gboolean is_video;
  gboolean is_h264;
} AtomTRAK;

typedef struct _AtomTREX
{
  AtomFull header;

  guint32 track_ID;
  guint32 default_sample_description_index;
  guint32 default_sample_duration;
  guint32 default_sample_size;
  guint32 default_sample_flags;
} AtomTREX;

typedef struct _AtomMEHD
{
  AtomFull header;

  guint64 fragment_duration;
} AtomMEHD;


typedef struct _AtomMVEX
{
  Atom header;

  AtomMEHD mehd;

  /* list of AtomTREX */
  GList *trexs;
} AtomMVEX;

typedef struct _AtomMFHD
{
  AtomFull header;

  guint32 sequence_number;
} AtomMFHD;

typedef struct _AtomTFHD
{
  AtomFull header;

  guint32 track_ID;
  guint64 base_data_offset;
  guint32 sample_description_index;
  guint32 default_sample_duration;
  guint32 default_sample_size;
  guint32 default_sample_flags;
} AtomTFHD;

typedef struct _TRUNSampleEntry
{
  guint32 sample_duration;
  guint32 sample_size;
  guint32 sample_flags;
  guint32 sample_composition_time_offset;
} TRUNSampleEntry;

typedef struct _AtomTRUN
{
  AtomFull header;

  guint32 sample_count;
  gint32 data_offset;
  guint32 first_sample_flags;

  /* array of fields */
  ATOM_ARRAY (TRUNSampleEntry) entries;
} AtomTRUN;

typedef struct _AtomSDTP
{
  AtomFull header;

  /* not serialized */
  guint32 sample_count;

  /* array of fields */
  ATOM_ARRAY (guint8) entries;
} AtomSDTP;

typedef struct _AtomTRAF
{
  Atom header;

  AtomTFHD tfhd;

  /* list of AtomTRUN */
  GList *truns;
  /* list of AtomSDTP */
  GList *sdtps;
} AtomTRAF;

typedef struct _AtomMOOF
{
  Atom header;

  AtomMFHD mfhd;

  /* list of AtomTRAF */
  GList *trafs;
} AtomMOOF;


typedef struct _AtomMOOV
{
  /* style */
  AtomsContext context;

  Atom header;

  AtomMVHD mvhd;
  AtomMVEX mvex;

  /* list of AtomTRAK */
  GList *traks;
  AtomUDTA *udta;

  gboolean fragmented;
} AtomMOOV;

typedef struct _AtomWAVE
{
  Atom header;

  /* list of AtomInfo */
  GList *extension_atoms;
} AtomWAVE;

typedef struct _TFRAEntry
{
  guint64 time;
  guint64 moof_offset;
  guint32 traf_number;
  guint32 trun_number;
  guint32 sample_number;
} TFRAEntry;

typedef struct _AtomTFRA
{
  AtomFull header;

  guint32 track_ID;
  guint32 lengths;
  /* array of entries */
  ATOM_ARRAY (TFRAEntry) entries;
} AtomTFRA;

typedef struct _AtomMFRA
{
  Atom header;

  /* list of tfra */
  GList *tfras;
} AtomMFRA;

/*
 * Function to serialize an atom
 */
typedef guint64 (*AtomCopyDataFunc) (Atom *atom, guint8 **buffer, guint64 *size, guint64 *offset);

/*
 * Releases memory allocated by an atom
 */
typedef guint64 (*AtomFreeFunc) (Atom *atom);

/*
 * Some atoms might have many optional different kinds of child atoms, so this
 * is useful for enabling generic handling of any atom.
 * All we need are the two functions (copying it to an array
 * for serialization and the memory releasing function).
 */
typedef struct _AtomInfo
{
  Atom *atom;
  AtomCopyDataFunc copy_data_func;
  AtomFreeFunc free_func;
} AtomInfo;


guint64    atom_copy_data              (Atom *atom, guint8 **buffer,
                                        guint64 *size, guint64* offset);

AtomFTYP*  atom_ftyp_new               (AtomsContext *context, guint32 major,
                                        guint32 version, GList *brands);
guint64    atom_ftyp_copy_data         (AtomFTYP *ftyp, guint8 **buffer,
                                        guint64 *size, guint64 *offset);
void       atom_ftyp_free              (AtomFTYP *ftyp);

AtomTRAK*  atom_trak_new               (AtomsContext *context);
void       atom_trak_add_samples       (AtomTRAK * trak, guint32 nsamples, guint32 delta,
                                        guint32 size, guint64 chunk_offset, gboolean sync,
                                        gint64 pts_offset);
void       atom_trak_add_elst_entry    (AtomTRAK * trak, guint32 duration,
                                        guint32 media_time, guint32 rate);
guint32    atom_trak_get_timescale     (AtomTRAK *trak);
guint32    atom_trak_get_id            (AtomTRAK * trak);
void       atom_stbl_add_samples       (AtomSTBL * stbl, guint32 nsamples,
                                        guint32 delta, guint32 size,
                                        guint64 chunk_offset, gboolean sync,
                                        gint64 pts_offset);

AtomMOOV*  atom_moov_new               (AtomsContext *context);
void       atom_moov_free              (AtomMOOV *moov);
guint64    atom_moov_copy_data         (AtomMOOV *atom, guint8 **buffer, guint64 *size, guint64* offset);
void       atom_moov_update_timescale  (AtomMOOV *moov, guint32 timescale);
void       atom_moov_update_duration   (AtomMOOV *moov);
void       atom_moov_set_fragmented    (AtomMOOV *moov, gboolean fragmented);
void       atom_moov_chunks_add_offset (AtomMOOV *moov, guint32 offset);
void       atom_moov_add_trak          (AtomMOOV *moov, AtomTRAK *trak);

guint64    atom_mvhd_copy_data         (AtomMVHD * atom, guint8 ** buffer,
                                        guint64 * size, guint64 * offset);
void       atom_stco64_chunks_add_offset (AtomSTCO64 * stco64, guint32 offset);
guint64    atom_trak_copy_data         (AtomTRAK * atom, guint8 ** buffer,
                                        guint64 * size, guint64 * offset);
void       atom_stbl_clear             (AtomSTBL * stbl);
void       atom_stbl_init              (AtomSTBL * stbl);
guint64    atom_stss_copy_data         (AtomSTSS *atom, guint8 **buffer,
                                        guint64 *size, guint64* offset);
guint64    atom_stts_copy_data         (AtomSTTS *atom, guint8 **buffer,
                                        guint64 *size, guint64* offset);
guint64    atom_stsc_copy_data         (AtomSTSC *atom, guint8 **buffer,
                                        guint64 *size, guint64* offset);
guint64    atom_stsz_copy_data         (AtomSTSZ *atom, guint8 **buffer,
                                        guint64 *size, guint64* offset);
guint64    atom_ctts_copy_data         (AtomCTTS *atom, guint8 **buffer,
                                        guint64 *size, guint64* offset);
guint64    atom_stco64_copy_data       (AtomSTCO64 *atom, guint8 **buffer,
                                        guint64 *size, guint64* offset);
AtomMOOF*  atom_moof_new               (AtomsContext *context, guint32 sequence_number);
void       atom_moof_free              (AtomMOOF *moof);
guint64    atom_moof_copy_data         (AtomMOOF *moof, guint8 **buffer, guint64 *size, guint64* offset);
AtomTRAF * atom_traf_new               (AtomsContext * context, guint32 track_ID);
void       atom_traf_free              (AtomTRAF * traf);
void       atom_traf_add_samples       (AtomTRAF * traf, guint32 delta,
                                        guint32 size, gboolean sync, gint64 pts_offset,
                                        gboolean sdtp_sync);
guint32    atom_traf_get_sample_num    (AtomTRAF * traf);
void       atom_moof_add_traf          (AtomMOOF *moof, AtomTRAF *traf);

AtomMFRA*  atom_mfra_new               (AtomsContext *context);
void       atom_mfra_free              (AtomMFRA *mfra);
AtomTFRA*  atom_tfra_new               (AtomsContext *context, guint32 track_ID);
void       atom_tfra_add_entry         (AtomTFRA *tfra, guint64 dts, guint32 sample_num);
void       atom_tfra_update_offset     (AtomTFRA * tfra, guint64 offset);
void       atom_mfra_add_tfra          (AtomMFRA *mfra, AtomTFRA *tfra);
guint64    atom_mfra_copy_data         (AtomMFRA *mfra, guint8 **buffer, guint64 *size, guint64* offset);


/* media sample description related helpers */

typedef struct
{
  guint16 version;
  guint32 fourcc;
  guint width;
  guint height;
  guint depth;
  guint frame_count;
  gint color_table_id;
  guint par_n;
  guint par_d;

  GstBuffer *codec_data;
} VisualSampleEntry;

typedef struct
{
  guint32 fourcc;
  guint version;
  gint compression_id;
  guint sample_rate;
  guint channels;
  guint sample_size;
  guint bytes_per_packet;
  guint samples_per_packet;
  guint bytes_per_sample;
  guint bytes_per_frame;

  GstBuffer *codec_data;
} AudioSampleEntry;

typedef struct
{
  guint32 fourcc;

  guint8  font_face; /* bold=0x1, italic=0x2, underline=0x4 */
  guint8  font_size;
  guint32 foreground_color_rgba;
} SubtitleSampleEntry;

void subtitle_sample_entry_init (SubtitleSampleEntry * entry);

void atom_trak_set_audio_type (AtomTRAK * trak, AtomsContext * context,
                               AudioSampleEntry * entry, guint32 scale,
                               AtomInfo * ext, gint sample_size);

void atom_trak_set_video_type (AtomTRAK * trak, AtomsContext * context,
                               VisualSampleEntry * entry, guint32 rate,
                               GList * ext_atoms_list);

void atom_trak_set_subtitle_type (AtomTRAK * trak, AtomsContext * context,
                               SubtitleSampleEntry * entry);

void atom_trak_update_bitrates (AtomTRAK * trak, guint32 avg_bitrate,
                                guint32 max_bitrate);

void atom_trak_tx3g_update_dimension (AtomTRAK * trak, guint32 width,
                                      guint32 height);

AtomInfo *   build_codec_data_extension  (guint32 fourcc, const GstBuffer * codec_data);
AtomInfo *   build_mov_aac_extension     (AtomTRAK * trak, const GstBuffer * codec_data,
                                          guint32 avg_bitrate, guint32 max_bitrate);
AtomInfo *   build_mov_alac_extension    (AtomTRAK * trak, const GstBuffer * codec_data);
AtomInfo *   build_esds_extension        (AtomTRAK * trak, guint8 object_type,
                                          guint8 stream_type, const GstBuffer * codec_data,
                                          guint32 avg_bitrate, guint32 max_bitrate);
AtomInfo *   build_btrt_extension        (guint32 buffer_size_db, guint32 avg_bitrate,
                                          guint32 max_bitrate);
AtomInfo *   build_jp2h_extension        (AtomTRAK * trak, gint width, gint height,
                                          const gchar *colorspace, gint ncomp,
                                          const GValue * cmap_array,
                                          const GValue * cdef_array);

AtomInfo *   build_jp2x_extension        (const GstBuffer * prefix);
AtomInfo *   build_fiel_extension        (gint fields);
AtomInfo *   build_amr_extension         (void);
AtomInfo *   build_h263_extension        (void);
AtomInfo *   build_gama_atom             (gdouble gamma);
AtomInfo *   build_SMI_atom              (const GstBuffer *seqh);
AtomInfo *   build_ima_adpcm_extension   (gint channels, gint rate,
                                          gint blocksize);
AtomInfo *   build_uuid_xmp_atom         (GstBuffer * xmp);


/*
 * Meta tags functions
 */
void atom_moov_add_str_tag    (AtomMOOV *moov, guint32 fourcc, const gchar *value);
void atom_moov_add_uint_tag   (AtomMOOV *moov, guint32 fourcc, guint32 flags,
                               guint32 value);
void atom_moov_add_tag        (AtomMOOV *moov, guint32 fourcc, guint32 flags,
                               const guint8 * data, guint size);
void atom_moov_add_blob_tag   (AtomMOOV *moov, guint8 *data, guint size);

void atom_moov_add_3gp_str_tag       (AtomMOOV * moov, guint32 fourcc, const gchar * value);
void atom_moov_add_3gp_uint_tag      (AtomMOOV * moov, guint32 fourcc, guint16 value);
void atom_moov_add_3gp_str_int_tag   (AtomMOOV * moov, guint32 fourcc, const gchar * value,
                                      gint16 ivalue);
void atom_moov_add_3gp_tag           (AtomMOOV * moov, guint32 fourcc, guint8 * data,
                                      guint size);

void atom_moov_add_xmp_tags          (AtomMOOV * moov, GstBuffer * xmp);

#define GST_QT_MUX_DEFAULT_TAG_LANGUAGE   "und" /* undefined/unknown */
guint16  language_code               (const char * lang);

#endif /* __ATOMS_H__ */
