
#ifndef __DIRAC_PARSE_H__
#define __DIRAC_PARSE_H__

#ifdef __cplusplus
extern "C" {
#endif

#ifndef TRUE
#define TRUE 1
#endif
#ifndef FALSE
#define FALSE 0
#endif

typedef enum _SchroParseCode {
  SCHRO_PARSE_CODE_SEQUENCE_HEADER = 0x00,
  SCHRO_PARSE_CODE_END_OF_SEQUENCE = 0x10,
  SCHRO_PARSE_CODE_AUXILIARY_DATA = 0x20,
  SCHRO_PARSE_CODE_PADDING = 0x30,

  SCHRO_PARSE_CODE_INTRA_REF = 0x0c,
  SCHRO_PARSE_CODE_INTRA_NON_REF = 0x08,
  SCHRO_PARSE_CODE_INTRA_REF_NOARITH = 0x4c,
  SCHRO_PARSE_CODE_INTRA_NON_REF_NOARITH = 0x48,

  SCHRO_PARSE_CODE_INTER_REF_1 = 0x0d,
  SCHRO_PARSE_CODE_INTER_REF_1_NOARITH = 0x4d,
  SCHRO_PARSE_CODE_INTER_REF_2 = 0x0e,
  SCHRO_PARSE_CODE_INTER_REF_2_NOARITH = 0x4e,

  SCHRO_PARSE_CODE_INTER_NON_REF_1 = 0x09,
  SCHRO_PARSE_CODE_INTER_NON_REF_1_NOARITH = 0x49,
  SCHRO_PARSE_CODE_INTER_NON_REF_2 = 0x0a,
  SCHRO_PARSE_CODE_INTER_NON_REF_2_NOARITH = 0x4a,

  SCHRO_PARSE_CODE_LD_INTRA_REF = 0xcc,
  SCHRO_PARSE_CODE_LD_INTRA_NON_REF = 0xc8
} SchroParseCode;

#define SCHRO_PARSE_CODE_PICTURE(is_ref,n_refs,is_lowdelay,is_noarith) \
  (8 | ((is_ref)<<2) | (n_refs) | ((is_lowdelay)<<7) | ((is_noarith)<<6))

#define SCHRO_PARSE_CODE_IS_SEQ_HEADER(x) ((x) == SCHRO_PARSE_CODE_SEQUENCE_HEADER)
#define SCHRO_PARSE_CODE_IS_END_OF_SEQUENCE(x) ((x) == SCHRO_PARSE_CODE_END_OF_SEQUENCE)
#define SCHRO_PARSE_CODE_IS_AUXILIARY_DATA(x) ((x) == SCHRO_PARSE_CODE_AUXILIARY_DATA)
#define SCHRO_PARSE_CODE_IS_PADDING(x) ((x) == SCHRO_PARSE_CODE_PADDING)
#define SCHRO_PARSE_CODE_IS_PICTURE(x) ((x) & 0x8)
#define SCHRO_PARSE_CODE_IS_LOW_DELAY(x) (((x) & 0x88) == 0x88)
#define SCHRO_PARSE_CODE_IS_CORE_SYNTAX(x) (((x) & 0x88) == 0x08)
#define SCHRO_PARSE_CODE_USING_AC(x) (((x) & 0x48) == 0x08)
#define SCHRO_PARSE_CODE_IS_REFERENCE(x) (((x) & 0xc) == 0x0c)
#define SCHRO_PARSE_CODE_IS_NON_REFERENCE(x) (((x) & 0xc) == 0x08)
#define SCHRO_PARSE_CODE_NUM_REFS(x) ((x) & 0x3)
#define SCHRO_PARSE_CODE_IS_INTRA(x) (SCHRO_PARSE_CODE_IS_PICTURE(x) && SCHRO_PARSE_CODE_NUM_REFS(x) == 0)
#define SCHRO_PARSE_CODE_IS_INTER(x) (SCHRO_PARSE_CODE_IS_PICTURE(x) && SCHRO_PARSE_CODE_NUM_REFS(x) > 0)

#define SCHRO_PARSE_HEADER_SIZE (4+1+4+4)

typedef enum _SchroVideoFormatEnum {
  SCHRO_VIDEO_FORMAT_CUSTOM = 0,
  SCHRO_VIDEO_FORMAT_QSIF,
  SCHRO_VIDEO_FORMAT_QCIF,
  SCHRO_VIDEO_FORMAT_SIF,
  SCHRO_VIDEO_FORMAT_CIF,
  SCHRO_VIDEO_FORMAT_4SIF,
  SCHRO_VIDEO_FORMAT_4CIF,
  SCHRO_VIDEO_FORMAT_SD480I_60,
  SCHRO_VIDEO_FORMAT_SD576I_50,
  SCHRO_VIDEO_FORMAT_HD720P_60,
  SCHRO_VIDEO_FORMAT_HD720P_50,
  SCHRO_VIDEO_FORMAT_HD1080I_60,
  SCHRO_VIDEO_FORMAT_HD1080I_50,
  SCHRO_VIDEO_FORMAT_HD1080P_60,
  SCHRO_VIDEO_FORMAT_HD1080P_50,
  SCHRO_VIDEO_FORMAT_DC2K_24,
  SCHRO_VIDEO_FORMAT_DC4K_24
} SchroVideoFormatEnum;

typedef enum _SchroChromaFormat {
  SCHRO_CHROMA_444 = 0,
  SCHRO_CHROMA_422,
  SCHRO_CHROMA_420
} SchroChromaFormat;

#define SCHRO_CHROMA_FORMAT_H_SHIFT(format) (((format) == SCHRO_CHROMA_444)?0:1)
#define SCHRO_CHROMA_FORMAT_V_SHIFT(format) (((format) == SCHRO_CHROMA_420)?1:0)

typedef enum _SchroSignalRange {
  SCHRO_SIGNAL_RANGE_CUSTOM = 0,
  SCHRO_SIGNAL_RANGE_8BIT_FULL = 1,
  SCHRO_SIGNAL_RANGE_8BIT_VIDEO = 2,
  SCHRO_SIGNAL_RANGE_10BIT_VIDEO = 3,
  SCHRO_SIGNAL_RANGE_12BIT_VIDEO = 4
} SchroSignalRange;

typedef enum _SchroColourSpec {
  SCHRO_COLOUR_SPEC_CUSTOM = 0,
  SCHRO_COLOUR_SPEC_SDTV_525 = 1,
  SCHRO_COLOUR_SPEC_SDTV_625 = 2,
  SCHRO_COLOUR_SPEC_HDTV = 3,
  SCHRO_COLOUR_SPEC_CINEMA = 4
} SchroColourSpec;

typedef enum _SchroColourPrimaries {
  SCHRO_COLOUR_PRIMARY_HDTV = 0,
  SCHRO_COLOUR_PRIMARY_SDTV_525 = 1,
  SCHRO_COLOUR_PRIMARY_SDTV_625 = 2,
  SCHRO_COLOUR_PRIMARY_CINEMA = 3
} SchroColourPrimaries;

typedef enum _SchroColourMatrix {
  SCHRO_COLOUR_MATRIX_HDTV = 0,
  SCHRO_COLOUR_MATRIX_SDTV = 1,
  SCHRO_COLOUR_MATRIX_REVERSIBLE = 2
}SchroColourMatrix;

typedef enum _SchroTransferFunction {
  SCHRO_TRANSFER_CHAR_TV_GAMMA = 0,
  SCHRO_TRANSFER_CHAR_EXTENDED_GAMUT = 1,
  SCHRO_TRANSFER_CHAR_LINEAR = 2,
  SCHRO_TRANSFER_CHAR_DCI_GAMMA = 3
} SchroTransferFunction;



typedef struct _DiracSequenceHeader DiracSequenceHeader;

struct _DiracSequenceHeader {
  int major_version;
  int minor_version;
  int profile;
  int level;

  int index;
  int width;
  int height;
  int chroma_format;
  
  int interlaced;
  int top_field_first;
  
  int frame_rate_numerator;
  int frame_rate_denominator;
  int aspect_ratio_numerator;
  int aspect_ratio_denominator;
    
  int clean_width;
  int clean_height;
  int left_offset;
  int top_offset;
    
  int luma_offset;
  int luma_excursion;
  int chroma_offset;
  int chroma_excursion;
    
  int colour_primaries;
  int colour_matrix;
  int transfer_function;

  int interlaced_coding;

  int unused0;
  int unused1;
  int unused2;
};  


int dirac_sequence_header_parse (DiracSequenceHeader *header,
    unsigned char *data, int length);

#ifdef __cplusplus
}
#endif

#endif

