/* Gstreamer
 * Copyright (C) <2011> Intel
 * Copyright (C) <2011> Collabora Ltd.
 * Copyright (C) <2011> Thibault Saunier <thibault.saunier@collabora.com>
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

#ifndef __GST_VC1_PARSER_H__
#define __GST_VC1_PARSER_H__

#ifndef GST_USE_UNSTABLE_API
#warning "The VC1 parsing library is unstable API and may change in future."
#warning "You can define GST_USE_UNSTABLE_API to avoid this warning."
#endif

#include <gst/gst.h>

G_BEGIN_DECLS

#define MAX_HRD_NUM_LEAKY_BUCKETS 31

/**
 * GST_VC1_BFRACTION_BASIS:
 * The @bfraction variable should be divided
 * by this constant to have the actual value.
 */
#define GST_VC1_BFRACTION_BASIS 840

#define GST_VC1_BFRACTION_RESERVED (GST_VC1_BFRACTION_BASIS + 1)
#define GST_VC1_BFRACTION_PTYPE_BI (GST_VC1_BFRACTION_BASIS + 2)

typedef enum {
  GST_VC1_END_OF_SEQ       = 0x0A,
  GST_VC1_SLICE            = 0x0B,
  GST_VC1_FIELD            = 0x0C,
  GST_VC1_FRAME            = 0x0D,
  GST_VC1_ENTRYPOINT       = 0x0E,
  GST_VC1_SEQUENCE         = 0x0F,
  GST_VC1_SLICE_USER       = 0x1B,
  GST_VC1_FIELD_USER       = 0x1C,
  GST_VC1_FRAME_USER       = 0x1D,
  GST_VC1_ENTRY_POINT_USER = 0x1E,
  GST_VC1_SEQUENCE_USER    = 0x1F
} GstVC1StartCode;

typedef enum {
  GST_VC1_PROFILE_SIMPLE,
  GST_VC1_PROFILE_MAIN,
  GST_VC1_PROFILE_RESERVED,
  GST_VC1_PROFILE_ADVANCED
} GstVC1Profile;

typedef enum {
  GST_VC1_PARSER_OK,
  GST_VC1_PARSER_BROKEN_DATA,
  GST_VC1_PARSER_NO_BDU,
  GST_VC1_PARSER_NO_BDU_END,
  GST_VC1_PARSER_ERROR,
} GstVC1ParserResult;

typedef enum
{
  GST_VC1_PICTURE_TYPE_P,
  GST_VC1_PICTURE_TYPE_B,
  GST_VC1_PICTURE_TYPE_I,
  GST_VC1_PICTURE_TYPE_BI,
  GST_VC1_PICTURE_TYPE_SKIPPED
} GstVC1PictureType;

typedef enum
{
    GST_VC1_LEVEL_LOW    = 0,    /* Simple/Main profile low level */
    GST_VC1_LEVEL_MEDIUM = 1,    /* Simple/Main profile medium level */
    GST_VC1_LEVEL_HIGH   = 2,   /* Main profile high level */

    GST_VC1_LEVEL_L0    = 0,    /* Advanced profile level 0 */
    GST_VC1_LEVEL_L1    = 1,    /* Advanced profile level 1 */
    GST_VC1_LEVEL_L2    = 2,    /* Advanced profile level 2 */
    GST_VC1_LEVEL_L3    = 3,    /* Advanced profile level 3 */
    GST_VC1_LEVEL_L4    = 4,    /* Advanced profile level 4 */

    /* 5 to 7 reserved */
    GST_VC1_LEVEL_UNKNOWN = 255  /* Unknown profile */
} GstVC1Level;

typedef enum
{
  GST_VC1_QUANTIZER_IMPLICITLY,
  GST_VC1_QUANTIZER_EXPLICITLY,
  GST_VC1_QUANTIZER_NON_UNIFORM,
  GST_VC1_QUANTIZER_UNIFORM
} GstVC1QuantizerSpec;

typedef enum {
  GST_VC1_DQPROFILE_FOUR_EDGES,
  GST_VC1_DQPROFILE_DOUBLE_EDGES,
  GST_VC1_DQPROFILE_SINGLE_EDGE,
  GST_VC1_DQPROFILE_ALL_MBS
} GstVC1DQProfile;

typedef enum {
  GST_VC1_CONDOVER_NONE,
  GST_VC1_CONDOVER_ALL,
  GST_VC1_CONDOVER_SELECT
} GstVC1Condover;

/**
 * GstVC1MvMode:
 *
 */
typedef enum
{
  GST_VC1_MVMODE_1MV_HPEL_BILINEAR,
  GST_VC1_MVMODE_1MV,
  GST_VC1_MVMODE_1MV_HPEL,
  GST_VC1_MVMODE_MIXED_MV,
  GST_VC1_MVMODE_INTENSITY_COMP
} GstVC1MvMode;

typedef enum
{
  GST_VC1_FRAME_PROGRESSIVE = 0x0,
  GST_VC1_FRAME_INTERLACE   = 0x10,
  GST_VC1_FIELD_INTERLACE   = 0x11
} GstVC1FrameCodingMode;

typedef struct _GstVC1SeqHdr            GstVC1SeqHdr;
typedef struct _GstVC1AdvancedSeqHdr    GstVC1AdvancedSeqHdr;
typedef struct _GstVC1HrdParam          GstVC1HrdParam;
typedef struct _GstVC1EntryPointHdr     GstVC1EntryPointHdr;

typedef struct _GstVC1SeqLayer     GstVC1SeqLayer;

typedef struct _GstVC1SeqStructA   GstVC1SeqStructA;
typedef struct _GstVC1SeqStructB   GstVC1SeqStructB;
typedef struct _GstVC1SeqStructC   GstVC1SeqStructC;

/* Pictures Structures */
typedef struct _GstVC1FrameLayer        GstVC1FrameLayer;
typedef struct _GstVC1FrameHdr          GstVC1FrameHdr;
typedef struct _GstVC1PicAdvanced       GstVC1PicAdvanced;
typedef struct _GstVC1PicSimpleMain     GstVC1PicSimpleMain;
typedef struct _GstVC1Picture           GstVC1Picture;
typedef struct _GstVC1SliceHdr          GstVC1SliceHdr;

typedef struct _GstVC1VopDquant         GstVC1VopDquant;

typedef struct _GstVC1BitPlanes         GstVC1BitPlanes;

typedef struct _GstVC1BDU               GstVC1BDU;

struct _GstVC1HrdParam
{
  guint8 hrd_num_leaky_buckets;
  guint8 bit_rate_exponent;
  guint8 buffer_size_exponent;
  guint16 hrd_rate[MAX_HRD_NUM_LEAKY_BUCKETS];
  guint16 hrd_buffer[MAX_HRD_NUM_LEAKY_BUCKETS];
};

/**
 * GstVC1EntryPointHdr:
 *
 * Structure for entrypoint header, this will be used only in advanced profiles
 */
struct _GstVC1EntryPointHdr
{
  guint8 broken_link;
  guint8 closed_entry;
  guint8 panscan_flag;
  guint8 refdist_flag;
  guint8 loopfilter;
  guint8 fastuvmc;
  guint8 extended_mv;
  guint8 dquant;
  guint8 vstransform;
  guint8 overlap;
  guint8 quantizer;
  guint8 coded_size_flag;
  guint16 coded_width;
  guint16 coded_height;
  guint8 extended_dmv;
  guint8 range_mapy_flag;
  guint8 range_mapy;
  guint8 range_mapuv_flag;
  guint8 range_mapuv;

  guint8 hrd_full[MAX_HRD_NUM_LEAKY_BUCKETS];
};

/**
 * GstVC1AdvancedSeqHdr:
 *
 * Structure for the advanced profile sequence headers specific parameters.
 */
struct _GstVC1AdvancedSeqHdr
{
  GstVC1Level  level;

  guint8  frmrtq_postproc;
  guint8  bitrtq_postproc;
  guint8  postprocflag;
  guint16 max_coded_width;
  guint16 max_coded_height;
  guint8  pulldown;
  guint8  interlace;
  guint8  tfcntrflag;
  guint8  finterpflag;
  guint8  psf;
  guint8  display_ext;
  guint16 disp_horiz_size;
  guint16 disp_vert_size;
  guint8  aspect_ratio_flag;
  guint8  aspect_ratio;
  guint8  aspect_horiz_size;
  guint8  aspect_vert_size;
  guint8  framerate_flag;
  guint8  framerateind;
  guint8  frameratenr;
  guint8  frameratedr;
  guint16 framerateexp;
  guint8  color_format_flag;
  guint8  color_prim;
  guint8  transfer_char;
  guint8  matrix_coef;
  guint8  hrd_param_flag;
  guint8  colordiff_format;

  GstVC1HrdParam hrd_param;

  /* computed */
  guint framerate; /* Around in fps, 0 if unknown*/
  guint bitrate;   /* Around in kpbs, 0 if unknown*/
  guint par_n;
  guint par_d;
  guint fps_n;
  guint fps_d;

  /* The last parsed entry point */
  GstVC1EntryPointHdr entrypoint;
};

struct _GstVC1SeqStructA
{
  guint32 vert_size;
  guint32 horiz_size;
};

struct _GstVC1SeqStructB
{
  GstVC1Level  level;

  guint8 cbr;
  guint32 framerate;

  /* In simple and main profiles only */
  guint32 hrd_buffer;
  guint32 hrd_rate;
};

struct _GstVC1SeqStructC
{
  GstVC1Profile profile;

  /* Only in simple and main profiles */
  guint8 frmrtq_postproc;
  guint8 bitrtq_postproc;
  guint8 res_sprite;
  guint8 loop_filter;
  guint8 multires;
  guint8 fastuvmc;
  guint8 extended_mv;
  guint8 dquant;
  guint8 vstransform;
  guint8 overlap;
  guint8 syncmarker;
  guint8 rangered;
  guint8 maxbframes;
  guint8 quantizer;
  guint8 finterpflag;

  /* Computed */
  guint framerate; /* Around in fps, 0 if unknown*/
  guint bitrate;   /* Around in kpbs, 0 if unknown*/

  /* This should be filled by user if previously known */
  guint16 coded_width;
  /* This should be filled by user if previously known */
  guint16 coded_height;

  /* Wmvp specific */
  guint8 wmvp;          /* Specify if the stream is wmp or not */
  /* In the wmvp case, the framerate is not computed but in the bistream */
  guint8 slice_code;
};

struct _GstVC1SeqLayer
{
  guint32 numframes;

  GstVC1SeqStructA struct_a;
  GstVC1SeqStructB struct_b;
  GstVC1SeqStructC struct_c;
};

/**
 * GstVC1SeqHdr:
 *
 * Structure for sequence headers in any profile.
 */
struct _GstVC1SeqHdr
{
  GstVC1Profile profile;

  GstVC1SeqStructC struct_c;

  /*  calculated */
  guint mb_height;
  guint mb_width;
  guint mb_stride;

  GstVC1AdvancedSeqHdr   advanced;

};

/**
 * GstVC1PicSimpleMain:
 * @bfaction: Should be divided by #GST_VC1_BFRACTION_BASIS
 * to get the real value.
 */
struct _GstVC1PicSimpleMain
{
  guint8 frmcnt;
  guint8 mvrange;
  guint8 rangeredfrm;

  /* I and P pic simple and main profiles only */
  guint8 respic;

  /* I and BI pic simple and main profiles only */
  guint8 transacfrm2;
  guint8 bf;

  /* B and P pic simple and main profiles only */
  guint8 mvmode;
  guint8 mvtab;
  guint8 ttmbf;

  /* P pic simple and main profiles only */
  guint8 mvmode2;
  guint8 lumscale;
  guint8 lumshift;

  guint8 cbptab;
  guint8 ttfrm;

  /* B and BI picture only
   * Should be divided by #GST_VC1_BFRACTION_BASIS
   * to get the real value. */
  guint16 bfraction;

  /* Biplane value, those fields only mention the fact
   * that the bitplane is in raw mode or not */
  guint8 mvtypemb;
  guint8 skipmb;
  guint8 directmb; /* B pic main profile only */
};

/**
 * GstVC1PicAdvanced:
 * @bfaction: Should be divided by #GST_VC1_BFRACTION_BASIS
 * to get the real value.
 */
struct _GstVC1PicAdvanced
{
  GstVC1FrameCodingMode fcm;
  guint8  tfcntr;

  guint8  rptfrm;
  guint8  tff;
  guint8  rff;
  guint8  ps_present;
  guint32 ps_hoffset;
  guint32 ps_voffset;
  guint16 ps_width;
  guint16 ps_height;
  guint8  rndctrl;
  guint8  uvsamp;
  guint8  postproc;

  /*  B and P picture specific */
  guint8  mvrange;
  guint8  mvmode;
  guint8  mvtab;
  guint8  cbptab;
  guint8  ttmbf;
  guint8  ttfrm;

  /* B and BI picture only
   * Should be divided by #GST_VC1_BFRACTION_BASIS
   * to get the real value. */
  guint16 bfraction;

  /* ppic */
  guint8  mvmode2;
  guint8  lumscale;
  guint8  lumshift;

  /* bipic */
  guint8  bf;
  guint8  condover;
  guint8  transacfrm2;

  /* Biplane value, those fields only mention the fact
   * that the bitplane is in raw mode or not */
  guint8  acpred;
  guint8  overflags;
  guint8  mvtypemb;
  guint8  skipmb;
  guint8  directmb;
  guint8  forwardmb; /* B pic interlace field only */

  /* For interlaced pictures only */
  guint8  fieldtx;

  /* P and B pictures */
  guint8  intcomp;
  guint8  dmvrange;
  guint8  mbmodetab;
  guint8  imvtab;
  guint8  icbptab;
  guint8  mvbptab2;
  guint8  mvbptab4; /* If 4mvswitch in ppic */

  /*  P picture */
  guint8  mvswitch4;

  /* For interlaced fields only */
  guint16 refdist;
  guint8 fptype; /* Raw value */

  /* P pic */
  guint8  numref;
  guint8  reffield;
  guint8  lumscale2;
  guint8  lumshift2;
  guint8  intcompfield;

};

struct _GstVC1BitPlanes
{
  guint8  *acpred;
  guint8  *fieldtx;
  guint8  *overflags;
  guint8  *mvtypemb;
  guint8  *skipmb;
  guint8  *directmb;
  guint8  *forwardmb;

  guint size; /* Size of the arrays */
};

struct _GstVC1VopDquant
{
  guint8 pqdiff;
  guint8 abspq;

  /* Computed */
  guint8 altpquant;

  /*  if dqant != 2*/
  guint8 dquantfrm;
  guint8 dqprofile;

  /* Boundary edge selection. This represents DQSBEDGE
   * if dqprofile == GST_VC1_DQPROFILE_SINGLE_EDGE or
   * DQDBEDGE if dqprofile == GST_VC1_DQPROFILE_DOUBLE_EDGE */
  guint8 dqbedge;

  /* FIXME: remove */
  guint8 unused;

  /* if dqprofile == GST_VC1_DQPROFILE_ALL_MBS */
  guint8 dqbilevel;

};

struct _GstVC1FrameLayer
{
  guint8 key;
  guint32 framesize;

  guint32 timestamp;

  /* calculated */
  guint32 next_framelayer_offset;
  guint8 skiped_p_frame;
};

/**
 * GstVC1FrameHdr:
 *
 * Structure that represent picture in any profile or mode.
 * You should look at @ptype and @profile to know what is currently
 * in use.
 */
struct _GstVC1FrameHdr
{
  /* common fields */
  GstVC1PictureType ptype;
  guint8 interpfrm;
  guint8 halfqp;
  guint8 transacfrm;
  guint8 transdctab;
  guint8 pqindex;
  guint8 pquantizer;

  /* Computed */
  guint8 pquant;

  /* Convenience fields */
  guint8 profile;
  guint8 dquant;

  /*  If dquant */
  GstVC1VopDquant vopdquant;

  union {
    GstVC1PicSimpleMain simple;
    GstVC1PicAdvanced advanced;
  } pic;

  /* Size of the picture layer in bits */
  guint header_size;
};

/**
 * GstVC1SliceHdr:
 *
 * Structure that represents slice layer in advanced profile.
 */
struct _GstVC1SliceHdr
{
  guint16 slice_addr;

  /* Size of the slice layer in bits */
  guint header_size;
};

/**
 * GstVC1BDU:
 *
 * Structure that represents a Bitstream Data Unit.
 */
struct _GstVC1BDU
{
  GstVC1StartCode type;
  guint size;
  guint sc_offset;
  guint offset;
  guint8 * data;
};

GstVC1ParserResult gst_vc1_identify_next_bdu           (const guint8 *data,
                                                        gsize size,
                                                        GstVC1BDU *bdu);


GstVC1ParserResult gst_vc1_parse_sequence_header       (const guint8 *data,
                                                        gsize size,
                                                        GstVC1SeqHdr * seqhdr);

GstVC1ParserResult gst_vc1_parse_entry_point_header    (const  guint8 *data,
                                                        gsize size,
                                                        GstVC1EntryPointHdr * entrypoint,
                                                        GstVC1SeqHdr *seqhdr);

GstVC1ParserResult gst_vc1_parse_sequence_layer        (const guint8 *data,
                                                        gsize size,
                                                        GstVC1SeqLayer * seqlayer);

GstVC1ParserResult
gst_vc1_parse_sequence_header_struct_a                 (const guint8 *data,
                                                        gsize size,
                                                        GstVC1SeqStructA *structa);
GstVC1ParserResult
gst_vc1_parse_sequence_header_struct_b                 (const guint8 *data,
                                                        gsize size,
                                                        GstVC1SeqStructB *structb);

GstVC1ParserResult
gst_vc1_parse_sequence_header_struct_c                 (const guint8 *data,
                                                        gsize size,
                                                        GstVC1SeqStructC *structc);

GstVC1ParserResult gst_vc1_parse_frame_layer           (const guint8 *data,
                                                        gsize size,
                                                        GstVC1FrameLayer * framelayer);

GstVC1ParserResult gst_vc1_parse_frame_header          (const guint8 *data,
                                                        gsize size,
                                                        GstVC1FrameHdr * framehdr,
                                                        GstVC1SeqHdr *seqhdr,
                                                        GstVC1BitPlanes *bitplanes);

GstVC1ParserResult gst_vc1_parse_field_header          (const guint8 *data,
                                                        gsize size,
                                                        GstVC1FrameHdr * fieldhdr,
                                                        GstVC1SeqHdr *seqhdr,
                                                        GstVC1BitPlanes *bitplanes);

GstVC1ParserResult gst_vc1_parse_slice_header           (const guint8 *data,
                                                         gsize size,
                                                         GstVC1SliceHdr *slicehdr, 
                                                         GstVC1SeqHdr *seqhdr);

GstVC1BitPlanes *  gst_vc1_bitplanes_new               (void);

void               gst_vc1_bitplanes_free              (GstVC1BitPlanes *bitplanes);

void               gst_vc1_bitplanes_free_1            (GstVC1BitPlanes *bitplanes);

gboolean           gst_vc1_bitplanes_ensure_size       (GstVC1BitPlanes *bitplanes,
                                                        GstVC1SeqHdr *seqhdr);

G_END_DECLS
#endif
