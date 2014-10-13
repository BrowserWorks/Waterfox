
#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <orc/orc.h>
#include <orc/orccpuinsn.h>
#include <orc/orcx86.h>
#include <orc/orcsse.h>
#include <orc/orcmmx.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>


static const OrcSysOpcode orc_x86_opcodes[] = {
  { "punpcklbw", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f60 },
  { "punpcklwd", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f61 },
  { "punpckldq", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f62 },
  { "packsswb", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f63 },
  { "pcmpgtb", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f64 },
  { "pcmpgtw", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f65 },
  { "pcmpgtd", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f66 },
  { "packuswb", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f67 },
  { "punpckhbw", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f68 },
  { "punpckhwd", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f69 },
  { "punpckhdq", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f6a },
  { "packssdw", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f6b },
  { "punpcklqdq", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f6c },
  { "punpckhqdq", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f6d },
  { "movdqa", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f6f },
  { "psraw", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0fe1 },
  { "psrlw", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0fd1 },
  { "psllw", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0ff1 },
  { "psrad", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0fe2 },
  { "psrld", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0fd2 },
  { "pslld", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0ff2 },
  { "psrlq", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0fd3 },
  { "psllq", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0ff3 },
  { "psrldq", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f73 },
  { "pslldq", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f73 },
  { "psrlq", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0fd3 },
  { "pcmpeqb", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f74 },
  { "pcmpeqw", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f75 },
  { "pcmpeqd", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f76 },
  { "paddq", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0fd4 },
  { "pmullw", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0fd5 },
  { "psubusb", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0fd8 },
  { "psubusw", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0fd9 },
  { "pminub", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0fda },
  { "pand", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0fdb },
  { "paddusb", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0fdc },
  { "paddusw", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0fdd },
  { "pmaxub", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0fde },
  { "pandn", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0fdf },
  { "pavgb", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0fe0 },
  { "pavgw", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0fe3 },
  { "pmulhuw", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0fe4 },
  { "pmulhw", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0fe5 },
  { "psubsb", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0fe8 },
  { "psubsw", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0fe9 },
  { "pminsw", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0fea },
  { "por", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0feb },
  { "paddsb", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0fec },
  { "paddsw", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0fed },
  { "pmaxsw", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0fee },
  { "pxor", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0fef },
  { "pmuludq", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0ff4 },
  { "pmaddwd", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0ff5 },
  { "psadbw", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0ff6 },
  { "psubb", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0ff8 },
  { "psubw", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0ff9 },
  { "psubd", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0ffa },
  { "psubq", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0ffb },
  { "paddb", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0ffc },
  { "paddw", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0ffd },
  { "paddd", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0ffe },
  { "pshufb", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f3800 },
  { "phaddw", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f3801 },
  { "phaddd", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f3802 },
  { "phaddsw", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f3803 },
  { "pmaddubsw", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f3804 },
  { "phsubw", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f3805 },
  { "phsubd", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f3806 },
  { "phsubsw", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f3807 },
  { "psignb", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f3808 },
  { "psignw", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f3809 },
  { "psignd", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f380a },
  { "pmulhrsw", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f380b },
  { "pabsb", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f381c },
  { "pabsw", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f381d },
  { "pabsd", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f381e },
  { "pmovsxbw", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f3820 },
  { "pmovsxbd", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f3821 },
  { "pmovsxbq", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f3822 },
  { "pmovsxwd", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f3823 },
  { "pmovsxwq", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f3824 },
  { "pmovsxdq", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f3825 },
  { "pmuldq", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f3828 },
  { "pcmpeqq", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f3829 },
  { "packusdw", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f382b },
  { "pmovzxbw", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f3830 },
  { "pmovzxbd", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f3831 },
  { "pmovzxbq", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f3832 },
  { "pmovzxwd", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f3833 },
  { "pmovzxwq", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f3834 },
  { "pmovzxdq", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f3835 },
  { "pmulld", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f3840 },
  { "phminposuw", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f3841 },
  { "pminsb", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f3838 },
  { "pminsd", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f3839 },
  { "pminuw", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f383a },
  { "pminud", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f383b },
  { "pmaxsb", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f383c },
  { "pmaxsd", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f383d },
  { "pmaxuw", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f383e },
  { "pmaxud", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f383f },
  { "pcmpgtq", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x01, 0x0f3837 },
  { "addps", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x00, 0x0f58 },
  { "subps", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x00, 0x0f5c },
  { "mulps", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x00, 0x0f59 },
  { "divps", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x00, 0x0f5e },
  { "sqrtps", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x00, 0x0f51 },
  { "addpd", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x66, 0x0f58 },
  { "subpd", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x66, 0x0f5c },
  { "mulpd", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x66, 0x0f59 },
  { "divpd", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x66, 0x0f5e },
  { "sqrtpd", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x66, 0x0f51 },
  { "cmpeqps", ORC_X86_INSN_TYPE_SSEM_SSE, 0, 0x00, 0x0fc2, 0 },
  { "cmpeqpd", ORC_X86_INSN_TYPE_SSEM_SSE, 0, 0x66, 0x0fc2, 0 },
  { "cmpltps", ORC_X86_INSN_TYPE_SSEM_SSE, 0, 0x00, 0x0fc2, 1 },
  { "cmpltpd", ORC_X86_INSN_TYPE_SSEM_SSE, 0, 0x66, 0x0fc2, 1 },
  { "cmpleps", ORC_X86_INSN_TYPE_SSEM_SSE, 0, 0x00, 0x0fc2, 2 },
  { "cmplepd", ORC_X86_INSN_TYPE_SSEM_SSE, 0, 0x66, 0x0fc2, 2 },
  { "cvttps2dq", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0xf3, 0x0f5b },
  { "cvttpd2dq", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x66, 0x0fe6 },
  { "cvtdq2ps", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x00, 0x0f5b },
  { "cvtdq2pd", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0xf3, 0x0fe6 },
  { "cvtps2pd", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x00, 0x0f5a },
  { "cvtpd2ps", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x66, 0x0f5a },
  { "minps", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x00, 0x0f5d },
  { "minpd", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x66, 0x0f5d },
  { "maxps", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x00, 0x0f5f },
  { "maxpd", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x66, 0x0f5f },
  { "psraw", ORC_X86_INSN_TYPE_IMM8_MMX_SHIFT, 0, 0x01, 0x0f71, 4 },
  { "psrlw", ORC_X86_INSN_TYPE_IMM8_MMX_SHIFT, 0, 0x01, 0x0f71, 2 },
  { "psllw", ORC_X86_INSN_TYPE_IMM8_MMX_SHIFT, 0, 0x01, 0x0f71, 6 },
  { "psrad", ORC_X86_INSN_TYPE_IMM8_MMX_SHIFT, 0, 0x01, 0x0f72, 4 },
  { "psrld", ORC_X86_INSN_TYPE_IMM8_MMX_SHIFT, 0, 0x01, 0x0f72, 2 },
  { "pslld", ORC_X86_INSN_TYPE_IMM8_MMX_SHIFT, 0, 0x01, 0x0f72, 6 },
  { "psrlq", ORC_X86_INSN_TYPE_IMM8_MMX_SHIFT, 0, 0x01, 0x0f73, 2 },
  { "psllq", ORC_X86_INSN_TYPE_IMM8_MMX_SHIFT, 0, 0x01, 0x0f73, 6 },
  { "psrldq", ORC_X86_INSN_TYPE_IMM8_MMX_SHIFT, 0, 0x01, 0x0f73, 3 },
  { "pslldq", ORC_X86_INSN_TYPE_IMM8_MMX_SHIFT, 0, 0x01, 0x0f73, 7 },
  { "pshufd", ORC_X86_INSN_TYPE_IMM8_MMXM_MMX, 0, 0x66, 0x0f70 },
  { "pshuflw", ORC_X86_INSN_TYPE_IMM8_MMXM_MMX, 0, 0xf2, 0x0f70 },
  { "pshufhw", ORC_X86_INSN_TYPE_IMM8_MMXM_MMX, 0, 0xf3, 0x0f70 },
  { "palignr", ORC_X86_INSN_TYPE_IMM8_MMXM_MMX, 0, 0x66, 0x0f3a0f },
  { "pinsrw", ORC_X86_INSN_TYPE_IMM8_REGM_MMX, 0, 0x01, 0x0fc4 },
  { "movd", ORC_X86_INSN_TYPE_REGM_MMX, 0, 0x01, 0x0f6e },
  { "movq", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0xf3, 0x0f7e },
  { "movdqa", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x66, 0x0f6f },
  { "movdqu", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0xf3, 0x0f6f },
  { "movhps", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x00, 0x0f16 },
  { "pextrw", ORC_X86_INSN_TYPE_IMM8_MMX_REG_REV, 0, 0x01, 0x0f3a15 },
  { "movd", ORC_X86_INSN_TYPE_MMX_REGM_REV, 0, 0x01, 0x0f7e },
  { "movq", ORC_X86_INSN_TYPE_MMXM_MMX_REV, 0, 0x66, 0x0fd6 },
  { "movdqa", ORC_X86_INSN_TYPE_MMXM_MMX_REV, 0, 0x66, 0x0f7f },
  { "movdqu", ORC_X86_INSN_TYPE_MMXM_MMX_REV, 0, 0xf3, 0x0f7f },
  { "movntdq", ORC_X86_INSN_TYPE_MMXM_MMX_REV, 0, 0x66, 0x0fe7 },
  { "ldmxcsr", ORC_X86_INSN_TYPE_MEM, 0, 0x00, 0x0fae, 2 },
  { "stmxcsr", ORC_X86_INSN_TYPE_MEM, 0, 0x00, 0x0fae, 3 },
  { "add", ORC_X86_INSN_TYPE_IMM8_REGM, 0, 0x00, 0x83, 0 },
  { "add", ORC_X86_INSN_TYPE_IMM32_REGM, 0, 0x00, 0x81, 0 },
  { "add", ORC_X86_INSN_TYPE_REGM_REG, 0, 0x00, 0x03 },
  { "add", ORC_X86_INSN_TYPE_REG_REGM, 0, 0x00, 0x01 },
  { "or", ORC_X86_INSN_TYPE_IMM8_REGM, 0, 0x00, 0x83, 1 },
  { "or", ORC_X86_INSN_TYPE_IMM32_REGM, 0, 0x00, 0x81, 1 },
  { "or", ORC_X86_INSN_TYPE_REGM_REG, 0, 0x00, 0x0b },
  { "or", ORC_X86_INSN_TYPE_REG_REGM, 0, 0x00, 0x09 },
  { "adc", ORC_X86_INSN_TYPE_IMM8_REGM, 0, 0x00, 0x83, 2 },
  { "adc", ORC_X86_INSN_TYPE_IMM32_REGM, 0, 0x00, 0x81, 2 },
  { "adc", ORC_X86_INSN_TYPE_REGM_REG, 0, 0x00, 0x13 },
  { "adc", ORC_X86_INSN_TYPE_REG_REGM, 0, 0x00, 0x11 },
  { "sbb", ORC_X86_INSN_TYPE_IMM8_REGM, 0, 0x00, 0x83, 3 },
  { "sbb", ORC_X86_INSN_TYPE_IMM32_REGM, 0, 0x00, 0x81, 3 },
  { "sbb", ORC_X86_INSN_TYPE_REGM_REG, 0, 0x00, 0x1b },
  { "sbb", ORC_X86_INSN_TYPE_REG_REGM, 0, 0x00, 0x19 },
  { "and", ORC_X86_INSN_TYPE_IMM8_REGM, 0, 0x00, 0x83, 4 },
  { "and", ORC_X86_INSN_TYPE_IMM32_REGM, 0, 0x00, 0x81, 4 },
  { "and", ORC_X86_INSN_TYPE_REGM_REG, 0, 0x00, 0x23 },
  { "and", ORC_X86_INSN_TYPE_REG_REGM, 0, 0x00, 0x21 },
  { "sub", ORC_X86_INSN_TYPE_IMM8_REGM, 0, 0x00, 0x83, 5 },
  { "sub", ORC_X86_INSN_TYPE_IMM32_REGM, 0, 0x00, 0x81, 5 },
  { "sub", ORC_X86_INSN_TYPE_REGM_REG, 0, 0x00, 0x2b },
  { "sub", ORC_X86_INSN_TYPE_REG_REGM, 0, 0x00, 0x29 },
  { "xor", ORC_X86_INSN_TYPE_IMM8_REGM, 0, 0x00, 0x83, 6 },
  { "xor", ORC_X86_INSN_TYPE_IMM32_REGM, 0, 0x00, 0x81, 6 },
  { "xor", ORC_X86_INSN_TYPE_REGM_REG, 0, 0x00, 0x33 },
  { "xor", ORC_X86_INSN_TYPE_REG_REGM, 0, 0x00, 0x31 },
  { "cmp", ORC_X86_INSN_TYPE_IMM8_REGM, 0, 0x00, 0x83, 7 },
  { "cmp", ORC_X86_INSN_TYPE_IMM32_REGM, 0, 0x00, 0x81, 7 },
  { "cmp", ORC_X86_INSN_TYPE_REGM_REG, 0, 0x00, 0x3b },
  { "cmp", ORC_X86_INSN_TYPE_REG_REGM, 0, 0x00, 0x39 },
  { "jo", ORC_X86_INSN_TYPE_BRANCH, 0, 0x00, 0x70 },
  { "jno", ORC_X86_INSN_TYPE_BRANCH, 0, 0x00, 0x71 },
  { "jc", ORC_X86_INSN_TYPE_BRANCH, 0, 0x00, 0x72 },
  { "jnc", ORC_X86_INSN_TYPE_BRANCH, 0, 0x00, 0x73 },
  { "jz", ORC_X86_INSN_TYPE_BRANCH, 0, 0x00, 0x74 },
  { "jnz", ORC_X86_INSN_TYPE_BRANCH, 0, 0x00, 0x75 },
  { "jbe", ORC_X86_INSN_TYPE_BRANCH, 0, 0x00, 0x76 },
  { "ja", ORC_X86_INSN_TYPE_BRANCH, 0, 0x00, 0x77 },
  { "js", ORC_X86_INSN_TYPE_BRANCH, 0, 0x00, 0x78 },
  { "jns", ORC_X86_INSN_TYPE_BRANCH, 0, 0x00, 0x79 },
  { "jp", ORC_X86_INSN_TYPE_BRANCH, 0, 0x00, 0x7a },
  { "jnp", ORC_X86_INSN_TYPE_BRANCH, 0, 0x00, 0x7b },
  { "jl", ORC_X86_INSN_TYPE_BRANCH, 0, 0x00, 0x7c },
  { "jge", ORC_X86_INSN_TYPE_BRANCH, 0, 0x00, 0x7d },
  { "jle", ORC_X86_INSN_TYPE_BRANCH, 0, 0x00, 0x7e },
  { "jg", ORC_X86_INSN_TYPE_BRANCH, 0, 0x00, 0x7f },
  { "jmp", ORC_X86_INSN_TYPE_BRANCH, 0, 0x00, 0xeb },
  { "", ORC_X86_INSN_TYPE_LABEL, 0, 0x00, 0x00 },
  { "ret", ORC_X86_INSN_TYPE_NONE, 0, 0x00, 0xc3 },
  { "retq", ORC_X86_INSN_TYPE_NONE, 0, 0x00, 0xc3 },
  { "emms", ORC_X86_INSN_TYPE_NONE, 0, 0x00, 0x0f77 },
  { "rdtsc", ORC_X86_INSN_TYPE_NONE, 0, 0x00, 0x0f31 },
  { "nop", ORC_X86_INSN_TYPE_NONE, 0, 0x00, 0x90 },
  { "rep movsb", ORC_X86_INSN_TYPE_NONE, 0, 0xf3, 0xa4 },
  { "rep movsw", ORC_X86_INSN_TYPE_NONE, 0, 0x66, 0xf3a5 },
  { "rep movsl", ORC_X86_INSN_TYPE_NONE, 0, 0xf3, 0xa5 },
  { "push", ORC_X86_INSN_TYPE_STACK, 0, 0x00, 0x50 },
  { "pop", ORC_X86_INSN_TYPE_STACK, 0, 0x00, 0x58 },
  { "movzx", ORC_X86_INSN_TYPE_REGM_REG, 0, 0x00, 0x0fb6 },
  { "movw", ORC_X86_INSN_TYPE_REGM_REG, 0, 0x66, 0x8b },
  { "movl", ORC_X86_INSN_TYPE_REGM_REG, 0, 0x00, 0x8b },
  { "mov", ORC_X86_INSN_TYPE_REGM_REG, 0, 0x00, 0x8b },
  { "mov", ORC_X86_INSN_TYPE_IMM32_REGM_MOV, 0, 0x00, 0xb8 },
  { "movb", ORC_X86_INSN_TYPE_REG8_REGM, 0, 0x00, 0x88 },
  { "movw", ORC_X86_INSN_TYPE_REG16_REGM, 0, 0x66, 0x89 },
  { "movl", ORC_X86_INSN_TYPE_REG_REGM, 0, 0x00, 0x89 },
  { "mov", ORC_X86_INSN_TYPE_REG_REGM, 0, 0x00, 0x89 },
  { "test", ORC_X86_INSN_TYPE_REGM_REG, 0, 0x00, 0x85 },
  { "testl", ORC_X86_INSN_TYPE_IMM32_REGM, 0, 0x00, 0xf7, 0 },
  { "leal", ORC_X86_INSN_TYPE_REGM_REG, 0, 0x00, 0x8d },
  { "leaq", ORC_X86_INSN_TYPE_REGM_REG, 0, 0x00, 0x8d },
  { "imul", ORC_X86_INSN_TYPE_REGM_REG, 0, 0x00, 0x0faf },
  { "imull", ORC_X86_INSN_TYPE_REGM, 0, 0x00, 0xf7, 5 },
  { "incl", ORC_X86_INSN_TYPE_REGM, 0, 0x00, 0xff, 0 },
  { "decl", ORC_X86_INSN_TYPE_REGM, 0, 0x00, 0xff, 1 },
  { "sar", ORC_X86_INSN_TYPE_IMM8_REGM, 0, 0x00, 0xc1, 7 },
  { "sar", ORC_X86_INSN_TYPE_REGM, 0, 0x00, 0xd1, 7 },
  { "and", ORC_X86_INSN_TYPE_IMM32_A, 0, 0x00, 0x25, 4 },
  { "", ORC_X86_INSN_TYPE_ALIGN, 0, 0x00, 0x00 },
  { "pshufw", ORC_X86_INSN_TYPE_IMM8_MMXM_MMX, 0, 0x00, 0x0f70 },
  { "movq", ORC_X86_INSN_TYPE_MMXM_MMX, 0, 0x00, 0x0f6f },
  { "movq", ORC_X86_INSN_TYPE_MMXM_MMX_REV, 0, 0x00, 0x0f7f },
};

static void
output_opcode (OrcCompiler *p, const OrcSysOpcode *opcode, int size,
    int src, int dest, int is_sse)
{
  ORC_ASSERT(opcode->code != 0);

  if (opcode->prefix != 0) {
    if (opcode->prefix == 0x01) {
      if (is_sse) {
        *p->codeptr++ = 0x66;
      }
    } else {
      *p->codeptr++ = opcode->prefix;
    }
  }
  orc_x86_emit_rex (p, size, dest, 0, src);
  if (opcode->code & 0xff0000) {
    *p->codeptr++ = (opcode->code >> 16) & 0xff;
  }
  if (opcode->code & 0xff00) {
    *p->codeptr++ = (opcode->code >> 8) & 0xff;
  }
  *p->codeptr++ = (opcode->code >> 0) & 0xff;
}

const char *
orc_x86_get_regname_mmxsse (int reg, int is_sse)
{
  if (is_sse) {
    return orc_x86_get_regname_sse (reg);
  } else {
    return orc_x86_get_regname_mmx (reg);
  }
}

int
is_sse_reg (int reg)
{
  return (reg >= X86_XMM0) && (reg <= X86_XMM15);
}

void
orc_x86_insn_output_asm (OrcCompiler *p, OrcX86Insn *xinsn)
{
  char imm_str[40] = { 0 };
  char op1_str[40] = { 0 };
  char op2_str[40] = { 0 };
  int is_sse;

  if (xinsn->opcode->type == ORC_X86_INSN_TYPE_ALIGN) {
    if (xinsn->size > 0) ORC_ASM_CODE(p,".p2align %d\n", xinsn->size);
    return;
  }
  if (xinsn->opcode->type == ORC_X86_INSN_TYPE_LABEL) {
    ORC_ASM_CODE(p,"%d:\n", xinsn->label);
    return;
  }

  is_sse = FALSE;
  if (is_sse_reg (xinsn->src) || is_sse_reg (xinsn->dest)) {
    is_sse = TRUE;
  }

  switch (xinsn->opcode->type) {
    case ORC_X86_INSN_TYPE_MMXM_MMX:
    case ORC_X86_INSN_TYPE_SSEM_SSE:
    case ORC_X86_INSN_TYPE_MMXM_MMX_REV:
    case ORC_X86_INSN_TYPE_SSEM_SSE_REV:
    case ORC_X86_INSN_TYPE_REGM_MMX:
    case ORC_X86_INSN_TYPE_MMX_REGM_REV:
    case ORC_X86_INSN_TYPE_REGM_REG:
    case ORC_X86_INSN_TYPE_REG_REGM:
    case ORC_X86_INSN_TYPE_STACK:
    case ORC_X86_INSN_TYPE_MEM:
    case ORC_X86_INSN_TYPE_REGM:
    case ORC_X86_INSN_TYPE_REG8_REGM:
    case ORC_X86_INSN_TYPE_REG16_REGM:
    case ORC_X86_INSN_TYPE_BRANCH:
    case ORC_X86_INSN_TYPE_LABEL:
    case ORC_X86_INSN_TYPE_ALIGN:
    case ORC_X86_INSN_TYPE_NONE:
      imm_str[0] = 0;
      break;
    case ORC_X86_INSN_TYPE_IMM8_MMX_SHIFT:
    case ORC_X86_INSN_TYPE_IMM8_MMXM_MMX:
    case ORC_X86_INSN_TYPE_IMM8_REGM_MMX:
    case ORC_X86_INSN_TYPE_IMM8_REGM:
    case ORC_X86_INSN_TYPE_IMM8_MMX_REG_REV:
    case ORC_X86_INSN_TYPE_IMM32_REGM:
    case ORC_X86_INSN_TYPE_IMM32_REGM_MOV:
    case ORC_X86_INSN_TYPE_IMM32_A:
      sprintf(imm_str, "$%d, ", xinsn->imm);
      break;
    default:
      ORC_ERROR("%d", xinsn->opcode->type);
      ORC_ASSERT(0);
      break;
  }

  switch (xinsn->opcode->type) {
    case ORC_X86_INSN_TYPE_MMXM_MMX:
    case ORC_X86_INSN_TYPE_SSEM_SSE:
    case ORC_X86_INSN_TYPE_IMM8_MMXM_MMX:
      if (xinsn->type == ORC_X86_RM_REG) {
        sprintf(op1_str, "%%%s, ",
            orc_x86_get_regname_mmxsse (xinsn->src, is_sse));
      } else if (xinsn->type == ORC_X86_RM_MEMOFFSET) {
        sprintf(op1_str, "%d(%%%s), ", xinsn->offset,
            orc_x86_get_regname_ptr (p, xinsn->src));
      } else if (xinsn->type == ORC_X86_RM_MEMINDEX) {
        sprintf(op1_str, "%d(%%%s,%%%s,%d), ", xinsn->offset,
            orc_x86_get_regname_ptr (p, xinsn->src),
            orc_x86_get_regname_ptr (p, xinsn->index_reg),
	    1<<xinsn->shift);
      } else {
	ORC_ASSERT(0);
      }
      break;
    case ORC_X86_INSN_TYPE_MMXM_MMX_REV: /* FIXME misnamed */
    case ORC_X86_INSN_TYPE_SSEM_SSE_REV:
    case ORC_X86_INSN_TYPE_MMX_REGM_REV:
    case ORC_X86_INSN_TYPE_IMM8_MMX_REG_REV:
      sprintf(op1_str, "%%%s, ",
            orc_x86_get_regname_mmxsse (xinsn->src, is_sse));
      break;
    case ORC_X86_INSN_TYPE_REGM_MMX:
    case ORC_X86_INSN_TYPE_REGM_REG:
    case ORC_X86_INSN_TYPE_IMM8_REGM_MMX:
      if (xinsn->type == ORC_X86_RM_REG) {
        sprintf(op1_str, "%%%s, ", orc_x86_get_regname_size (xinsn->src,
            xinsn->size));
      } else if (xinsn->type == ORC_X86_RM_MEMOFFSET) {
        sprintf(op1_str, "%d(%%%s), ", xinsn->offset,
            orc_x86_get_regname_ptr (p, xinsn->src));
      } else if (xinsn->type == ORC_X86_RM_MEMINDEX) {
        sprintf(op1_str, "%d(%%%s,%%%s,%d), ", xinsn->offset,
            orc_x86_get_regname_ptr (p, xinsn->src),
            orc_x86_get_regname_ptr (p, xinsn->index_reg),
	    1<<xinsn->shift);
      } else {
	ORC_ASSERT(0);
      }
      break;
    case ORC_X86_INSN_TYPE_MEM:
    case ORC_X86_INSN_TYPE_REGM:
    case ORC_X86_INSN_TYPE_IMM8_MMX_SHIFT:
    case ORC_X86_INSN_TYPE_STACK:
    case ORC_X86_INSN_TYPE_IMM32_REGM_MOV:
    case ORC_X86_INSN_TYPE_IMM8_REGM:
    case ORC_X86_INSN_TYPE_IMM32_REGM:
    case ORC_X86_INSN_TYPE_BRANCH:
    case ORC_X86_INSN_TYPE_NONE:
    case ORC_X86_INSN_TYPE_LABEL:
    case ORC_X86_INSN_TYPE_ALIGN:
    case ORC_X86_INSN_TYPE_IMM32_A:
      op1_str[0] = 0;
      break;
    case ORC_X86_INSN_TYPE_REG_REGM:
      sprintf(op1_str, "%%%s, ", orc_x86_get_regname (xinsn->src));
      break;
    case ORC_X86_INSN_TYPE_REG8_REGM:
      sprintf(op1_str, "%%%s, ", orc_x86_get_regname_8 (xinsn->src));
      break;
    case ORC_X86_INSN_TYPE_REG16_REGM:
      sprintf(op1_str, "%%%s, ", orc_x86_get_regname_16 (xinsn->src));
      break;
    default:
      ORC_ERROR("%d", xinsn->opcode->type);
      ORC_ASSERT(0);
      break;
  }

  switch (xinsn->opcode->type) {
    case ORC_X86_INSN_TYPE_MMXM_MMX:
    case ORC_X86_INSN_TYPE_SSEM_SSE:
    case ORC_X86_INSN_TYPE_IMM8_MMXM_MMX:
    case ORC_X86_INSN_TYPE_IMM8_REGM_MMX:
    case ORC_X86_INSN_TYPE_REGM_MMX:
    case ORC_X86_INSN_TYPE_IMM8_MMX_SHIFT:
      sprintf(op2_str, "%%%s",
            orc_x86_get_regname_mmxsse (xinsn->dest, is_sse));
      break;
    case ORC_X86_INSN_TYPE_MMXM_MMX_REV:
    case ORC_X86_INSN_TYPE_SSEM_SSE_REV:
      if (xinsn->type == ORC_X86_RM_REG) {
        sprintf(op2_str, "%%%s",
            orc_x86_get_regname_mmxsse (xinsn->dest, is_sse));
      } else if (xinsn->type == ORC_X86_RM_MEMOFFSET) {
        sprintf(op2_str, "%d(%%%s)", xinsn->offset,
            orc_x86_get_regname_ptr (p, xinsn->dest));
      } else if (xinsn->type == ORC_X86_RM_MEMINDEX) {
        sprintf(op1_str, "%d(%%%s,%%%s,%d), ", xinsn->offset,
            orc_x86_get_regname_ptr (p, xinsn->dest),
            orc_x86_get_regname_ptr (p, xinsn->index_reg),
	    1<<xinsn->shift);
      } else {
	ORC_ASSERT(0);
      }
      break;
    case ORC_X86_INSN_TYPE_MMX_REGM_REV:
    case ORC_X86_INSN_TYPE_IMM32_REGM_MOV:
    case ORC_X86_INSN_TYPE_IMM8_REGM:
    case ORC_X86_INSN_TYPE_IMM32_REGM:
    case ORC_X86_INSN_TYPE_REGM:
    case ORC_X86_INSN_TYPE_REG8_REGM:
    case ORC_X86_INSN_TYPE_REG16_REGM:
    case ORC_X86_INSN_TYPE_REG_REGM:
    case ORC_X86_INSN_TYPE_IMM8_MMX_REG_REV:
      if (xinsn->type == ORC_X86_RM_REG) {
        sprintf(op2_str, "%%%s", orc_x86_get_regname (xinsn->dest));
      } else if (xinsn->type == ORC_X86_RM_MEMOFFSET) {
        sprintf(op2_str, "%d(%%%s)", xinsn->offset,
            orc_x86_get_regname_ptr (p, xinsn->dest));
      } else if (xinsn->type == ORC_X86_RM_MEMINDEX) {
        sprintf(op1_str, "%d(%%%s,%%%s,%d), ", xinsn->offset,
            orc_x86_get_regname_ptr (p, xinsn->dest),
            orc_x86_get_regname_ptr (p, xinsn->index_reg),
	    1<<xinsn->shift);
      } else {
	ORC_ASSERT(0);
      }
      break;
    case ORC_X86_INSN_TYPE_REGM_REG:
    case ORC_X86_INSN_TYPE_STACK:
      sprintf(op2_str, "%%%s", orc_x86_get_regname_size (xinsn->dest,
	  xinsn->size));
      break;
    case ORC_X86_INSN_TYPE_MEM:
      if (xinsn->type == ORC_X86_RM_REG) {
        ORC_ERROR("register operand on memory instruction");
        sprintf(op2_str, "ERROR");
      } else if (xinsn->type == ORC_X86_RM_MEMOFFSET) {
	/* FIXME: this uses xinsn->src */
        sprintf(op2_str, "%d(%%%s)", xinsn->offset,
            orc_x86_get_regname_ptr (p, xinsn->src));
      } else {
	ORC_ASSERT(0);
      }
      break;
    case ORC_X86_INSN_TYPE_BRANCH:
      sprintf (op2_str, "%d%c", xinsn->label,
          (p->labels_int[xinsn->label] <
           xinsn - ((OrcX86Insn *)p->output_insns)) ? 'b' : 'f');
      break;
    case ORC_X86_INSN_TYPE_LABEL:
    case ORC_X86_INSN_TYPE_ALIGN:
    case ORC_X86_INSN_TYPE_NONE:
      op2_str[0] = 0;
      break;
    case ORC_X86_INSN_TYPE_IMM32_A:
      sprintf(op2_str, "%%%s", orc_x86_get_regname_size (X86_EAX, xinsn->size));
      break;
    default:
      ORC_ERROR("%d", xinsn->opcode->type);
      ORC_ASSERT(0);
      break;
  }

  ORC_ASM_CODE(p,"  %s %s%s%s\n", xinsn->opcode->name,
      imm_str, op1_str, op2_str);

}

orc_uint8 nop_codes[][16] = {
  { 0 /* MSVC wants something here */ },
  { 0x90 },
  { 0x66, 0x90 }, /* xchg %ax,%ax */
#if 0
  { 0x0f, 0x1f, 0x00 }, /*  nopl (%rax) */
  { 0x0f, 0x1f, 0x40, 0x00 }, /* nopl 0x0(%rax) */
  { 0x0f, 0x1f, 0x44, 0x00, 0x00 }, /* nopl 0x0(%rax,%rax,1) */
  { 0x66, 0x0f, 0x1f, 0x44, 0x00, 0x00 }, /* nopw 0x0(%rax,%rax,1) */
  { 0x0f, 0x1f, 0x80, 0x00, 0x00, 0x00, 0x00 }, /* nopl 0x0(%rax) */
  { 0x0f, 0x1f, 0x84, 0x00, 0x00, 0x00, 0x00, 0x00 }, /* nopl 0x0(%rax,%rax,1) */
  { 0x66, 0x0f, 0x1f, 0x84, 0x00, 0x00, 0x00, 0x00, 0x00 }, /* nopw   0x0(%rax,%rax,1) */
  /* Forms of nopw %cs:0x0(%rax,%rax,1) */
  { 0x66, 0x2e, 0x0f, 0x1f, 0x84, 0x00, 0x00, 0x00, 0x00, 0x00 },
  { 0x66, 0x66, 0x2e, 0x0f, 0x1f, 0x84, 0x00, 0x00, 0x00, 0x00, 0x00 },
  { 0x66, 0x66, 0x66, 0x2e, 0x0f, 0x1f, 0x84, 0x00, 0x00, 0x00, 0x00, 0x00 },
  { 0x66, 0x66, 0x66, 0x66, 0x2e, 0x0f, 0x1f, 0x84, 0x00, 0x00, 0x00, 0x00,
    0x00 },
  { 0x66, 0x66, 0x66, 0x66, 0x66, 0x2e, 0x0f, 0x1f, 0x84, 0x00, 0x00, 0x00,
    0x00, 0x00 },
  { 0x66, 0x66, 0x66, 0x66, 0x66, 0x66, 0x2e, 0x0f, 0x1f, 0x84, 0x00, 0x00,
    0x00, 0x00, 0x00 },
#else
  { 0x90, 0x90, 0x90 },
  { 0x90, 0x90, 0x90, 0x90 },
  { 0x90, 0x90, 0x90, 0x90, 0x90 },
  { 0x90, 0x90, 0x90, 0x90, 0x90, 0x90 },
  { 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90 },
  { 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90 },
  { 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90 },
  { 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90 },
  { 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90 },
  { 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90 },
  { 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90,
    0x90, },
  { 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90,
    0x90, 0x90, },
  { 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90,
    0x90, 0x90, 0x90, },
#endif
};

void
orc_x86_insn_output_opcode (OrcCompiler *p, OrcX86Insn *xinsn)
{
  int is_sse;

  is_sse = FALSE;
  if (is_sse_reg (xinsn->src) || is_sse_reg (xinsn->dest)) {
    is_sse = TRUE;
  }

  switch (xinsn->opcode->type) {
    case ORC_X86_INSN_TYPE_IMM8_MMX_SHIFT:
      output_opcode (p, xinsn->opcode, 4, xinsn->dest, 0, is_sse);
      break;
    case ORC_X86_INSN_TYPE_MMX_REGM_REV:
    case ORC_X86_INSN_TYPE_MMXM_MMX_REV:
    case ORC_X86_INSN_TYPE_SSEM_SSE_REV:
      output_opcode (p, xinsn->opcode, 4, xinsn->dest, xinsn->src, is_sse);
      break;
    case ORC_X86_INSN_TYPE_REG_REGM:
    case ORC_X86_INSN_TYPE_IMM8_REGM:
    case ORC_X86_INSN_TYPE_IMM32_REGM:
    case ORC_X86_INSN_TYPE_REG8_REGM:
    case ORC_X86_INSN_TYPE_REG16_REGM:
      output_opcode (p, xinsn->opcode, xinsn->size, xinsn->dest, xinsn->src, FALSE);
      break;
    case ORC_X86_INSN_TYPE_IMM8_MMXM_MMX:
    case ORC_X86_INSN_TYPE_MMXM_MMX:
    case ORC_X86_INSN_TYPE_SSEM_SSE:
    case ORC_X86_INSN_TYPE_REGM_MMX:
      output_opcode (p, xinsn->opcode, 4, xinsn->src, xinsn->dest, is_sse);
      break;
    case ORC_X86_INSN_TYPE_IMM8_REGM_MMX:
      output_opcode (p, xinsn->opcode, xinsn->size, xinsn->src, xinsn->dest,
          is_sse);
      break;
    case ORC_X86_INSN_TYPE_IMM8_MMX_REG_REV:
      output_opcode (p, xinsn->opcode, 4, xinsn->dest, xinsn->src,
          is_sse);
      break;
    case ORC_X86_INSN_TYPE_MEM:
    case ORC_X86_INSN_TYPE_REGM_REG:
      output_opcode (p, xinsn->opcode, xinsn->size, xinsn->src, xinsn->dest, FALSE);
      break;
    case ORC_X86_INSN_TYPE_REGM:
      output_opcode (p, xinsn->opcode, xinsn->size, xinsn->src, xinsn->dest, FALSE);
      break;
    case ORC_X86_INSN_TYPE_IMM32_REGM_MOV:
      orc_x86_emit_rex (p, xinsn->size, 0, 0, xinsn->dest);
      *p->codeptr++ = xinsn->opcode->code + (xinsn->dest&7);
      break;
    case ORC_X86_INSN_TYPE_NONE:
      output_opcode (p, xinsn->opcode, 4, 0, 0, FALSE);
      break;
    case ORC_X86_INSN_TYPE_IMM32_A:
      output_opcode (p, xinsn->opcode, xinsn->size, 0, 0, FALSE);
      break;
    case ORC_X86_INSN_TYPE_ALIGN:
      {
        int diff;
        int i;
        diff = (p->code - p->codeptr)&((1<<xinsn->size) - 1);
        for(i=0;i<diff;i++){
          *p->codeptr++ = nop_codes[diff][i];
        }
      }
      break;
    case ORC_X86_INSN_TYPE_LABEL:
    case ORC_X86_INSN_TYPE_BRANCH:
    case ORC_X86_INSN_TYPE_STACK:
      break;
    default:
      ORC_ERROR("%d", xinsn->opcode->type);
      ORC_ASSERT(0);
      break;
  }
}

void
orc_x86_insn_output_modrm (OrcCompiler *p, OrcX86Insn *xinsn)
{
  switch (xinsn->opcode->type) {
    case ORC_X86_INSN_TYPE_REGM_REG:
    case ORC_X86_INSN_TYPE_REGM_MMX:
    case ORC_X86_INSN_TYPE_MMXM_MMX:
    case ORC_X86_INSN_TYPE_IMM8_REGM_MMX:
    case ORC_X86_INSN_TYPE_IMM8_MMXM_MMX:
      if (xinsn->type == ORC_X86_RM_REG) {
        orc_x86_emit_modrm_reg (p, xinsn->src, xinsn->dest);
      } else if (xinsn->type == ORC_X86_RM_MEMOFFSET) {
        orc_x86_emit_modrm_memoffset (p, xinsn->offset, xinsn->src,
            xinsn->dest);
      } else if (xinsn->type == ORC_X86_RM_MEMINDEX) {
        orc_x86_emit_modrm_memindex2 (p, xinsn->offset, xinsn->src,
            xinsn->index_reg, xinsn->shift, xinsn->dest);
      } else {
        ORC_ASSERT(0);
      }
      break;
    case ORC_X86_INSN_TYPE_REG_REGM:
    case ORC_X86_INSN_TYPE_MMXM_MMX_REV:
    case ORC_X86_INSN_TYPE_SSEM_SSE_REV:
    case ORC_X86_INSN_TYPE_MMX_REGM_REV:
    case ORC_X86_INSN_TYPE_IMM8_MMX_REG_REV:
    case ORC_X86_INSN_TYPE_REG8_REGM:
    case ORC_X86_INSN_TYPE_REG16_REGM:
      if (xinsn->type == ORC_X86_RM_REG) {
        orc_x86_emit_modrm_reg (p, xinsn->dest, xinsn->src);
      } else if (xinsn->type == ORC_X86_RM_MEMOFFSET) {
        orc_x86_emit_modrm_memoffset (p, xinsn->offset, xinsn->dest,
            xinsn->src);
      } else if (xinsn->type == ORC_X86_RM_MEMINDEX) {
        orc_x86_emit_modrm_memindex2 (p, xinsn->offset, xinsn->dest,
            xinsn->index_reg, xinsn->shift, xinsn->src);
      } else {
        ORC_ASSERT(0);
      }
      break;
    case ORC_X86_INSN_TYPE_MEM:
      if (xinsn->type == ORC_X86_RM_REG) {
        orc_x86_emit_modrm_reg (p, xinsn->src, xinsn->opcode->code2);
      } else if (xinsn->type == ORC_X86_RM_MEMOFFSET) {
        orc_x86_emit_modrm_memoffset (p, xinsn->offset, xinsn->src,
            xinsn->opcode->code2);
      } else if (xinsn->type == ORC_X86_RM_MEMINDEX) {
        orc_x86_emit_modrm_memindex2 (p, xinsn->offset, xinsn->src,
            xinsn->index_reg, xinsn->shift, xinsn->opcode->code2);
      } else {
        ORC_ASSERT(0);
      }
      break;
    case ORC_X86_INSN_TYPE_IMM32_REGM_MOV:
    case ORC_X86_INSN_TYPE_IMM32_A:
    case ORC_X86_INSN_TYPE_NONE:
    case ORC_X86_INSN_TYPE_ALIGN:
      break;
    case ORC_X86_INSN_TYPE_IMM8_MMX_SHIFT:
    case ORC_X86_INSN_TYPE_IMM8_REGM:
    case ORC_X86_INSN_TYPE_IMM32_REGM:
    case ORC_X86_INSN_TYPE_REGM:
      if (xinsn->type == ORC_X86_RM_REG) {
        orc_x86_emit_modrm_reg (p, xinsn->dest, xinsn->opcode->code2);
      } else if (xinsn->type == ORC_X86_RM_MEMOFFSET) {
        orc_x86_emit_modrm_memoffset (p, xinsn->offset, xinsn->dest,
            xinsn->opcode->code2);
      } else if (xinsn->type == ORC_X86_RM_MEMINDEX) {
        orc_x86_emit_modrm_memindex2 (p, xinsn->offset, xinsn->dest,
            xinsn->index_reg, xinsn->shift, xinsn->opcode->code2);
      } else {
        ORC_ASSERT(0);
      }
      break;
    case ORC_X86_INSN_TYPE_SSEM_SSE:
      if (xinsn->type == ORC_X86_RM_REG) {
        orc_x86_emit_modrm_reg (p, xinsn->src, xinsn->dest);
      } else if (xinsn->type == ORC_X86_RM_MEMOFFSET) {
        orc_x86_emit_modrm_memoffset (p, xinsn->offset, xinsn->src,
            xinsn->dest);
      } else if (xinsn->type == ORC_X86_RM_MEMINDEX) {
        orc_x86_emit_modrm_memindex2 (p, xinsn->offset, xinsn->src,
            xinsn->index_reg, xinsn->shift, xinsn->dest);
      } else {
        ORC_ASSERT(0);
      }
      *p->codeptr++ = xinsn->opcode->code2;
      break;
    case ORC_X86_INSN_TYPE_STACK:
      *p->codeptr++ = xinsn->opcode->code + (xinsn->dest&0x7);
      break;
    case ORC_X86_INSN_TYPE_BRANCH:
      if (xinsn->size == 4) {
        if (xinsn->opcode_index == ORC_X86_jmp) {
          *p->codeptr++ = 0xe9;
        } else {
          *p->codeptr++ = 0x0f;
          *p->codeptr++ = xinsn->opcode->code + 0x10;
        }
      } else {
        *p->codeptr++ = xinsn->opcode->code;
      }

      if (xinsn->size == 4) {
        x86_add_fixup (p, p->codeptr, xinsn->label, 1);
        *p->codeptr++ = 0xfc;
        *p->codeptr++ = 0xff;
        *p->codeptr++ = 0xff;
        *p->codeptr++ = 0xff;
      } else {
        x86_add_fixup (p, p->codeptr, xinsn->label, 0);
        *p->codeptr++ = 0xff;
      }
      break;
    case ORC_X86_INSN_TYPE_LABEL:
      x86_add_label (p, p->codeptr, xinsn->label);
      break;
    default:
      ORC_ERROR("%d", xinsn->opcode->type);
      ORC_ASSERT(0);
      break;
  }
}

void
orc_x86_insn_output_immediate (OrcCompiler *p, OrcX86Insn *xinsn)
{
  switch (xinsn->opcode->type) {
    case ORC_X86_INSN_TYPE_REGM_REG:
    case ORC_X86_INSN_TYPE_REGM_MMX:
    case ORC_X86_INSN_TYPE_MMXM_MMX:
    case ORC_X86_INSN_TYPE_REG_REGM:
    case ORC_X86_INSN_TYPE_MMXM_MMX_REV:
    case ORC_X86_INSN_TYPE_SSEM_SSE_REV:
    case ORC_X86_INSN_TYPE_MMX_REGM_REV:
    case ORC_X86_INSN_TYPE_REG8_REGM:
    case ORC_X86_INSN_TYPE_REG16_REGM:
      break;
    case ORC_X86_INSN_TYPE_IMM8_MMX_SHIFT:
    case ORC_X86_INSN_TYPE_IMM8_REGM_MMX:
    case ORC_X86_INSN_TYPE_IMM8_MMX_REG_REV:
    case ORC_X86_INSN_TYPE_IMM8_MMXM_MMX:
    case ORC_X86_INSN_TYPE_IMM8_REGM:
      *p->codeptr++ = xinsn->imm;
      break;
    case ORC_X86_INSN_TYPE_IMM32_REGM_MOV:
    case ORC_X86_INSN_TYPE_IMM32_REGM:
    case ORC_X86_INSN_TYPE_IMM32_A:
      *p->codeptr++ = xinsn->imm&0xff;
      *p->codeptr++ = (xinsn->imm>>8)&0xff;
      *p->codeptr++ = (xinsn->imm>>16)&0xff;
      *p->codeptr++ = (xinsn->imm>>24)&0xff;
      break;
    case ORC_X86_INSN_TYPE_SSEM_SSE:
    case ORC_X86_INSN_TYPE_STACK:
    case ORC_X86_INSN_TYPE_REGM:
    case ORC_X86_INSN_TYPE_MEM:
    case ORC_X86_INSN_TYPE_BRANCH:
    case ORC_X86_INSN_TYPE_LABEL:
    case ORC_X86_INSN_TYPE_ALIGN:
    case ORC_X86_INSN_TYPE_NONE:
      break;
    default:
      ORC_ERROR("%d", xinsn->opcode->type);
      ORC_ASSERT(0);
      break;
  }
}

OrcX86Insn *
orc_x86_get_output_insn (OrcCompiler *p)
{
  OrcX86Insn *xinsn;
  if (p->n_output_insns >= p->n_output_insns_alloc) {
    p->n_output_insns_alloc += 10;
    p->output_insns = realloc (p->output_insns,
        sizeof(OrcX86Insn) * p->n_output_insns_alloc);
  }

  xinsn = ((OrcX86Insn *)p->output_insns) + p->n_output_insns;
  memset (xinsn, 0, sizeof(OrcX86Insn));
  p->n_output_insns++;
  return xinsn;
}

void
orc_x86_recalc_offsets (OrcCompiler *p)
{
  OrcX86Insn *xinsn;
  int i;
  unsigned char *minptr;

  minptr = p->code;
  p->codeptr = p->code;
  for(i=0;i<p->n_output_insns;i++){
    unsigned char *ptr;

    xinsn = ((OrcX86Insn *)p->output_insns) + i;

    xinsn->code_offset = p->codeptr - p->code;

    ptr = p->codeptr;
    orc_x86_insn_output_opcode (p, xinsn);
    orc_x86_insn_output_modrm (p, xinsn);
    orc_x86_insn_output_immediate (p, xinsn);

    if (xinsn->opcode->type == ORC_X86_INSN_TYPE_ALIGN) {
      if (xinsn->size > 0) {
        minptr += ((p->code - minptr)&((1<<xinsn->size) - 1));
      }
    } else {
      minptr += p->codeptr - ptr;
      if (xinsn->opcode->type == ORC_X86_INSN_TYPE_BRANCH) {
        if (xinsn->size == 4) minptr -= 4;
      }
    }

  }

  p->codeptr = p->code;
  p->n_fixups = 0;
}

void
orc_x86_calculate_offsets (OrcCompiler *p)
{
  OrcX86Insn *xinsn;
  int i;
  int j;

  orc_x86_recalc_offsets (p);

  for(j=0;j<3;j++){
    int change = FALSE;

    for(i=0;i<p->n_output_insns;i++){
      OrcX86Insn *dinsn;
      int diff;

      xinsn = ((OrcX86Insn *)p->output_insns) + i;
      if (xinsn->opcode->type != ORC_X86_INSN_TYPE_BRANCH) {
        continue;
      }

      dinsn = ((OrcX86Insn *)p->output_insns) + p->labels_int[xinsn->label];

      if (xinsn->size == 1) {
        diff = dinsn->code_offset - (xinsn->code_offset + 2);
        if (diff < -128 || diff > 127) {
          xinsn->size = 4;
          ORC_DEBUG("%d: relaxing at %d,%04x diff %d",
              j, i, xinsn->code_offset, diff);
          change = TRUE;
        } else {
        }
      } else {
        diff = dinsn->code_offset - (xinsn->code_offset + 2);
        if (diff >= -128 && diff <= 127) {
          ORC_DEBUG("%d: unrelaxing at %d,%04x diff %d",
              j, i, xinsn->code_offset, diff);
          xinsn->size = 1;
          change = TRUE;
        }
      }
    }

    if (!change) break;

    orc_x86_recalc_offsets (p);
  }
}

void
orc_x86_output_insns (OrcCompiler *p)
{
  OrcX86Insn *xinsn;
  int i;

  for(i=0;i<p->n_output_insns;i++){
    xinsn = ((OrcX86Insn *)p->output_insns) + i;

    orc_x86_insn_output_asm (p, xinsn);

    orc_x86_insn_output_opcode (p, xinsn);
    orc_x86_insn_output_modrm (p, xinsn);
    orc_x86_insn_output_immediate (p, xinsn);
  }
}

void
orc_x86_emit_cpuinsn_size (OrcCompiler *p, int index, int size, int src, int dest)
{
  OrcX86Insn *xinsn = orc_x86_get_output_insn (p);
  const OrcSysOpcode *opcode = orc_x86_opcodes + index;

  xinsn->opcode_index = index;
  xinsn->opcode = opcode;
  xinsn->src = src;
  xinsn->dest = dest;
  xinsn->type = ORC_X86_RM_REG;
  xinsn->size = size;
}

void
orc_x86_emit_cpuinsn_imm (OrcCompiler *p, int index, int imm, int src, int dest)
{
  OrcX86Insn *xinsn = orc_x86_get_output_insn (p);
  const OrcSysOpcode *opcode = orc_x86_opcodes + index;

  xinsn->opcode_index = index;
  xinsn->opcode = opcode;
  xinsn->imm = imm;
  xinsn->src = src;
  xinsn->dest = dest;
  xinsn->type = ORC_X86_RM_REG;
  xinsn->size = 4;
}

void
orc_x86_emit_cpuinsn_load_memoffset (OrcCompiler *p, int index, int size,
    int imm, int offset, int src, int dest)
{
  OrcX86Insn *xinsn = orc_x86_get_output_insn (p);
  const OrcSysOpcode *opcode = orc_x86_opcodes + index;

  xinsn->opcode_index = index;
  xinsn->opcode = opcode;
  xinsn->imm = imm;
  xinsn->src = src;
  xinsn->dest = dest;
  xinsn->type = ORC_X86_RM_MEMOFFSET;
  xinsn->offset = offset;
  xinsn->size = size;
}

void
orc_x86_emit_cpuinsn_store_memoffset (OrcCompiler *p, int index, int size,
    int imm, int offset, int src, int dest)
{
  OrcX86Insn *xinsn = orc_x86_get_output_insn (p);
  const OrcSysOpcode *opcode = orc_x86_opcodes + index;

  xinsn->opcode_index = index;
  xinsn->opcode = opcode;
  xinsn->imm = imm;
  xinsn->src = src;
  xinsn->dest = dest;
  xinsn->type = ORC_X86_RM_MEMOFFSET;
  xinsn->offset = offset;
  xinsn->size = size;
}

void
orc_x86_emit_cpuinsn_load_memindex (OrcCompiler *p, int index, int size,
    int imm, int offset, int src, int src_index, int shift, int dest)
{
  OrcX86Insn *xinsn = orc_x86_get_output_insn (p);
  const OrcSysOpcode *opcode = orc_x86_opcodes + index;

  xinsn->opcode_index = index;
  xinsn->opcode = opcode;
  xinsn->imm = imm;
  xinsn->src = src;
  xinsn->dest = dest;
  xinsn->type = ORC_X86_RM_MEMINDEX;
  xinsn->offset = offset;
  xinsn->index_reg = src_index;
  xinsn->shift = shift;
  xinsn->size = size;
}

void
orc_x86_emit_cpuinsn_imm_reg (OrcCompiler *p, int index, int size, int imm,
    int dest)
{
  OrcX86Insn *xinsn = orc_x86_get_output_insn (p);
  const OrcSysOpcode *opcode = orc_x86_opcodes + index;

  xinsn->opcode_index = index;
  xinsn->opcode = opcode;
  xinsn->imm = imm;
  xinsn->src = 0;
  xinsn->dest = dest;
  xinsn->type = ORC_X86_RM_REG;
  xinsn->size = size;
}

void
orc_x86_emit_cpuinsn_imm_memoffset (OrcCompiler *p, int index, int size,
    int imm, int offset, int dest)
{
  OrcX86Insn *xinsn = orc_x86_get_output_insn (p);
  const OrcSysOpcode *opcode = orc_x86_opcodes + index;

  xinsn->opcode_index = index;
  xinsn->opcode = opcode;
  xinsn->imm = imm;
  xinsn->src = 0;
  xinsn->dest = dest;
  xinsn->type = ORC_X86_RM_MEMOFFSET;
  xinsn->offset = offset;
  xinsn->size = size;
}

void
orc_x86_emit_cpuinsn_reg_memoffset (OrcCompiler *p, int index, int src,
    int offset, int dest)
{
  OrcX86Insn *xinsn = orc_x86_get_output_insn (p);
  const OrcSysOpcode *opcode = orc_x86_opcodes + index;
  int size = 4;

  xinsn->opcode_index = index;
  xinsn->opcode = opcode;
  xinsn->src = src;
  xinsn->dest = dest;
  xinsn->type = ORC_X86_RM_MEMOFFSET;
  xinsn->offset = offset;
  xinsn->size = size;
}

void
orc_x86_emit_cpuinsn_reg_memoffset_8 (OrcCompiler *p, int index, int src,
    int offset, int dest)
{
  OrcX86Insn *xinsn = orc_x86_get_output_insn (p);
  const OrcSysOpcode *opcode = orc_x86_opcodes + index;
  int size = 8;

  xinsn->opcode_index = index;
  xinsn->opcode = opcode;
  xinsn->src = src;
  xinsn->dest = dest;
  xinsn->type = ORC_X86_RM_MEMOFFSET;
  xinsn->offset = offset;
  xinsn->size = size;
}

void
orc_x86_emit_cpuinsn_memoffset_reg (OrcCompiler *p, int index, int size,
    int offset, int src, int dest)
{
  OrcX86Insn *xinsn = orc_x86_get_output_insn (p);
  const OrcSysOpcode *opcode = orc_x86_opcodes + index;

  xinsn->opcode_index = index;
  xinsn->opcode = opcode;
  xinsn->src = src;
  xinsn->dest = dest;
  xinsn->type = ORC_X86_RM_MEMOFFSET;
  xinsn->offset = offset;
  xinsn->size = size;
}

void
orc_x86_emit_cpuinsn_branch (OrcCompiler *p, int index, int label)
{
  OrcX86Insn *xinsn = orc_x86_get_output_insn (p);
  const OrcSysOpcode *opcode = orc_x86_opcodes + index;

  xinsn->opcode_index = index;
  xinsn->opcode = opcode;
  xinsn->label = label;
  xinsn->size = 1;
}

void
orc_x86_emit_cpuinsn_align (OrcCompiler *p, int index, int align_shift)
{
  OrcX86Insn *xinsn = orc_x86_get_output_insn (p);
  const OrcSysOpcode *opcode = orc_x86_opcodes + index;

  xinsn->opcode_index = index;
  xinsn->opcode = opcode;
  xinsn->size = align_shift;
}

void
orc_x86_emit_cpuinsn_label (OrcCompiler *p, int index, int label)
{
  OrcX86Insn *xinsn = orc_x86_get_output_insn (p);
  const OrcSysOpcode *opcode = orc_x86_opcodes + index;

  xinsn->opcode_index = index;
  xinsn->opcode = opcode;
  xinsn->label = label;
  x86_add_label2 (p, p->n_output_insns - 1, label);
}

void
orc_x86_emit_cpuinsn_none (OrcCompiler *p, int index)
{
  OrcX86Insn *xinsn = orc_x86_get_output_insn (p);
  const OrcSysOpcode *opcode = orc_x86_opcodes + index;
  int size = 4;

  xinsn->opcode_index = index;
  xinsn->opcode = opcode;
  xinsn->size = size;
}

void
orc_x86_emit_cpuinsn_memoffset (OrcCompiler *p, int index, int size,
    int offset, int srcdest)
{
  OrcX86Insn *xinsn = orc_x86_get_output_insn (p);
  const OrcSysOpcode *opcode = orc_x86_opcodes + index;

  xinsn->opcode_index = index;
  xinsn->opcode = opcode;
  xinsn->src = srcdest;
  xinsn->dest = srcdest;
  xinsn->type = ORC_X86_RM_MEMOFFSET;
  xinsn->offset = offset;
  xinsn->size = size;
}

