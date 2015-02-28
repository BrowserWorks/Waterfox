/* Generated automatically from machmode.def and config/i386/i386-modes.def
   by genmodes.  */

#ifndef GCC_INSN_MODES_H
#define GCC_INSN_MODES_H

enum machine_mode
{
  VOIDmode,                /* machmode.def:173 */
  BLKmode,                 /* machmode.def:177 */
  CCmode,                  /* machmode.def:205 */
  CCGCmode,                /* config/i386/i386-modes.def:61 */
  CCGOCmode,               /* config/i386/i386-modes.def:62 */
  CCNOmode,                /* config/i386/i386-modes.def:63 */
  CCAmode,                 /* config/i386/i386-modes.def:64 */
  CCCmode,                 /* config/i386/i386-modes.def:65 */
  CCOmode,                 /* config/i386/i386-modes.def:66 */
  CCSmode,                 /* config/i386/i386-modes.def:67 */
  CCZmode,                 /* config/i386/i386-modes.def:68 */
  CCFPmode,                /* config/i386/i386-modes.def:69 */
  CCFPUmode,               /* config/i386/i386-modes.def:70 */
  BImode,                  /* machmode.def:180 */
  QImode,                  /* machmode.def:185 */
  HImode,                  /* machmode.def:186 */
  SImode,                  /* machmode.def:187 */
  DImode,                  /* machmode.def:188 */
  TImode,                  /* machmode.def:189 */
  OImode,                  /* config/i386/i386-modes.def:88 */
  QQmode,                  /* machmode.def:208 */
  HQmode,                  /* machmode.def:209 */
  SQmode,                  /* machmode.def:210 */
  DQmode,                  /* machmode.def:211 */
  TQmode,                  /* machmode.def:212 */
  UQQmode,                 /* machmode.def:214 */
  UHQmode,                 /* machmode.def:215 */
  USQmode,                 /* machmode.def:216 */
  UDQmode,                 /* machmode.def:217 */
  UTQmode,                 /* machmode.def:218 */
  HAmode,                  /* machmode.def:220 */
  SAmode,                  /* machmode.def:221 */
  DAmode,                  /* machmode.def:222 */
  TAmode,                  /* machmode.def:223 */
  UHAmode,                 /* machmode.def:225 */
  USAmode,                 /* machmode.def:226 */
  UDAmode,                 /* machmode.def:227 */
  UTAmode,                 /* machmode.def:228 */
  SFmode,                  /* machmode.def:200 */
  DFmode,                  /* machmode.def:201 */
  XFmode,                  /* config/i386/i386-modes.def:24 */
  TFmode,                  /* config/i386/i386-modes.def:25 */
  SDmode,                  /* machmode.def:240 */
  DDmode,                  /* machmode.def:241 */
  TDmode,                  /* machmode.def:242 */
  CQImode,                 /* machmode.def:236 */
  CHImode,                 /* machmode.def:236 */
  CSImode,                 /* machmode.def:236 */
  CDImode,                 /* machmode.def:236 */
  CTImode,                 /* machmode.def:236 */
  COImode,                 /* machmode.def:236 */
  SCmode,                  /* machmode.def:237 */
  DCmode,                  /* machmode.def:237 */
  XCmode,                  /* machmode.def:237 */
  TCmode,                  /* machmode.def:237 */
  V2QImode,                /* config/i386/i386-modes.def:86 */
  V4QImode,                /* config/i386/i386-modes.def:74 */
  V2HImode,                /* config/i386/i386-modes.def:74 */
  V1SImode,                /* config/i386/i386-modes.def:85 */
  V8QImode,                /* config/i386/i386-modes.def:75 */
  V4HImode,                /* config/i386/i386-modes.def:75 */
  V2SImode,                /* config/i386/i386-modes.def:75 */
  V1DImode,                /* config/i386/i386-modes.def:84 */
  V16QImode,               /* config/i386/i386-modes.def:76 */
  V8HImode,                /* config/i386/i386-modes.def:76 */
  V4SImode,                /* config/i386/i386-modes.def:76 */
  V2DImode,                /* config/i386/i386-modes.def:76 */
  V1TImode,                /* config/i386/i386-modes.def:83 */
  V32QImode,               /* config/i386/i386-modes.def:77 */
  V16HImode,               /* config/i386/i386-modes.def:77 */
  V8SImode,                /* config/i386/i386-modes.def:77 */
  V4DImode,                /* config/i386/i386-modes.def:77 */
  V2TImode,                /* config/i386/i386-modes.def:77 */
  V64QImode,               /* config/i386/i386-modes.def:78 */
  V32HImode,               /* config/i386/i386-modes.def:78 */
  V16SImode,               /* config/i386/i386-modes.def:78 */
  V8DImode,                /* config/i386/i386-modes.def:78 */
  V4TImode,                /* config/i386/i386-modes.def:78 */
  V2SFmode,                /* config/i386/i386-modes.def:79 */
  V4SFmode,                /* config/i386/i386-modes.def:80 */
  V2DFmode,                /* config/i386/i386-modes.def:80 */
  V8SFmode,                /* config/i386/i386-modes.def:81 */
  V4DFmode,                /* config/i386/i386-modes.def:81 */
  V2TFmode,                /* config/i386/i386-modes.def:81 */
  V16SFmode,               /* config/i386/i386-modes.def:82 */
  V8DFmode,                /* config/i386/i386-modes.def:82 */
  V4TFmode,                /* config/i386/i386-modes.def:82 */
  MAX_MACHINE_MODE,

  MIN_MODE_RANDOM = VOIDmode,
  MAX_MODE_RANDOM = BLKmode,

  MIN_MODE_CC = CCmode,
  MAX_MODE_CC = CCFPUmode,

  MIN_MODE_INT = QImode,
  MAX_MODE_INT = OImode,

  MIN_MODE_PARTIAL_INT = VOIDmode,
  MAX_MODE_PARTIAL_INT = VOIDmode,

  MIN_MODE_FRACT = QQmode,
  MAX_MODE_FRACT = TQmode,

  MIN_MODE_UFRACT = UQQmode,
  MAX_MODE_UFRACT = UTQmode,

  MIN_MODE_ACCUM = HAmode,
  MAX_MODE_ACCUM = TAmode,

  MIN_MODE_UACCUM = UHAmode,
  MAX_MODE_UACCUM = UTAmode,

  MIN_MODE_FLOAT = SFmode,
  MAX_MODE_FLOAT = TFmode,

  MIN_MODE_DECIMAL_FLOAT = SDmode,
  MAX_MODE_DECIMAL_FLOAT = TDmode,

  MIN_MODE_COMPLEX_INT = CQImode,
  MAX_MODE_COMPLEX_INT = COImode,

  MIN_MODE_COMPLEX_FLOAT = SCmode,
  MAX_MODE_COMPLEX_FLOAT = TCmode,

  MIN_MODE_VECTOR_INT = V2QImode,
  MAX_MODE_VECTOR_INT = V4TImode,

  MIN_MODE_VECTOR_FRACT = VOIDmode,
  MAX_MODE_VECTOR_FRACT = VOIDmode,

  MIN_MODE_VECTOR_UFRACT = VOIDmode,
  MAX_MODE_VECTOR_UFRACT = VOIDmode,

  MIN_MODE_VECTOR_ACCUM = VOIDmode,
  MAX_MODE_VECTOR_ACCUM = VOIDmode,

  MIN_MODE_VECTOR_UACCUM = VOIDmode,
  MAX_MODE_VECTOR_UACCUM = VOIDmode,

  MIN_MODE_VECTOR_FLOAT = V2SFmode,
  MAX_MODE_VECTOR_FLOAT = V4TFmode,

  NUM_MACHINE_MODES = MAX_MACHINE_MODE
};

#define CONST_MODE_SIZE
#define CONST_MODE_BASE_ALIGN
#define CONST_MODE_IBIT const
#define CONST_MODE_FBIT const

#endif /* insn-modes.h */
