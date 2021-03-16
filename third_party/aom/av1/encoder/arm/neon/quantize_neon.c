/*
 * Copyright (c) 2016, Alliance for Open Media. All rights reserved
 *
 * This source code is subject to the terms of the BSD 2 Clause License and
 * the Alliance for Open Media Patent License 1.0. If the BSD 2 Clause License
 * was not distributed with this source code in the LICENSE file, you can
 * obtain it at www.aomedia.org/license/software. If the Alliance for Open
 * Media Patent License 1.0 was not distributed with this source code in the
 * PATENTS file, you can obtain it at www.aomedia.org/license/patent.
 */

#include <arm_neon.h>

#include <math.h>

#include "aom_mem/aom_mem.h"

#include "av1/common/quant_common.h"
#include "av1/common/seg_common.h"
#include "av1/common/arm/mem_neon.h"

#include "av1/encoder/av1_quantize.h"
#include "av1/encoder/encoder.h"
#include "av1/encoder/rd.h"

void av1_quantize_fp_neon(const tran_low_t *coeff_ptr, intptr_t count,
                          const int16_t *zbin_ptr, const int16_t *round_ptr,
                          const int16_t *quant_ptr,
                          const int16_t *quant_shift_ptr,
                          tran_low_t *qcoeff_ptr, tran_low_t *dqcoeff_ptr,
                          const int16_t *dequant_ptr, uint16_t *eob_ptr,
                          const int16_t *scan, const int16_t *iscan) {
  // TODO(jingning) Decide the need of these arguments after the
  // quantization process is completed.
  (void)zbin_ptr;
  (void)quant_shift_ptr;
  (void)scan;

  // Quantization pass: All coefficients with index >= zero_flag are
  // skippable. Note: zero_flag can be zero.
  int i;
  const int16x8_t v_zero = vdupq_n_s16(0);
  const int16x8_t v_one = vdupq_n_s16(1);
  int16x8_t v_eobmax_76543210 = vdupq_n_s16(-1);
  int16x8_t v_round = vmovq_n_s16(round_ptr[1]);
  int16x8_t v_quant = vmovq_n_s16(quant_ptr[1]);
  int16x8_t v_dequant = vmovq_n_s16(dequant_ptr[1]);
  // adjust for dc
  v_round = vsetq_lane_s16(round_ptr[0], v_round, 0);
  v_quant = vsetq_lane_s16(quant_ptr[0], v_quant, 0);
  v_dequant = vsetq_lane_s16(dequant_ptr[0], v_dequant, 0);
  // process dc and the first seven ac coeffs
  {
    const int16x8_t v_iscan = vld1q_s16(&iscan[0]);
    const int16x8_t v_coeff = load_tran_low_to_s16q(&coeff_ptr[0]);
    const int16x8_t v_coeff_sign = vshrq_n_s16(v_coeff, 15);
    const int16x8_t v_abs = vabsq_s16(v_coeff);
    const int16x8_t v_tmp = vqaddq_s16(v_abs, v_round);
    const int32x4_t v_tmp_lo =
        vmull_s16(vget_low_s16(v_tmp), vget_low_s16(v_quant));
    const int32x4_t v_tmp_hi =
        vmull_s16(vget_high_s16(v_tmp), vget_high_s16(v_quant));
    const int16x8_t v_tmp2 =
        vcombine_s16(vshrn_n_s32(v_tmp_lo, 16), vshrn_n_s32(v_tmp_hi, 16));
    const uint16x8_t v_nz_mask = vceqq_s16(v_tmp2, v_zero);
    const int16x8_t v_iscan_plus1 = vaddq_s16(v_iscan, v_one);
    const int16x8_t v_nz_iscan = vbslq_s16(v_nz_mask, v_zero, v_iscan_plus1);
    const int16x8_t v_qcoeff_a = veorq_s16(v_tmp2, v_coeff_sign);
    const int16x8_t v_qcoeff = vsubq_s16(v_qcoeff_a, v_coeff_sign);
    const int16x8_t v_dqcoeff = vmulq_s16(v_qcoeff, v_dequant);
    v_eobmax_76543210 = vmaxq_s16(v_eobmax_76543210, v_nz_iscan);
    store_s16q_to_tran_low(&qcoeff_ptr[0], v_qcoeff);
    store_s16q_to_tran_low(&dqcoeff_ptr[0], v_dqcoeff);
    v_round = vmovq_n_s16(round_ptr[1]);
    v_quant = vmovq_n_s16(quant_ptr[1]);
    v_dequant = vmovq_n_s16(dequant_ptr[1]);
  }
  // now process the rest of the ac coeffs
  for (i = 8; i < count; i += 8) {
    const int16x8_t v_iscan = vld1q_s16(&iscan[i]);
    const int16x8_t v_coeff = load_tran_low_to_s16q(&coeff_ptr[i]);
    const int16x8_t v_coeff_sign = vshrq_n_s16(v_coeff, 15);
    const int16x8_t v_abs = vabsq_s16(v_coeff);
    const int16x8_t v_tmp = vqaddq_s16(v_abs, v_round);
    const int32x4_t v_tmp_lo =
        vmull_s16(vget_low_s16(v_tmp), vget_low_s16(v_quant));
    const int32x4_t v_tmp_hi =
        vmull_s16(vget_high_s16(v_tmp), vget_high_s16(v_quant));
    const int16x8_t v_tmp2 =
        vcombine_s16(vshrn_n_s32(v_tmp_lo, 16), vshrn_n_s32(v_tmp_hi, 16));
    const uint16x8_t v_nz_mask = vceqq_s16(v_tmp2, v_zero);
    const int16x8_t v_iscan_plus1 = vaddq_s16(v_iscan, v_one);
    const int16x8_t v_nz_iscan = vbslq_s16(v_nz_mask, v_zero, v_iscan_plus1);
    const int16x8_t v_qcoeff_a = veorq_s16(v_tmp2, v_coeff_sign);
    const int16x8_t v_qcoeff = vsubq_s16(v_qcoeff_a, v_coeff_sign);
    const int16x8_t v_dqcoeff = vmulq_s16(v_qcoeff, v_dequant);
    v_eobmax_76543210 = vmaxq_s16(v_eobmax_76543210, v_nz_iscan);
    store_s16q_to_tran_low(&qcoeff_ptr[i], v_qcoeff);
    store_s16q_to_tran_low(&dqcoeff_ptr[i], v_dqcoeff);
  }
#ifdef __aarch64__
  *eob_ptr = vmaxvq_s16(v_eobmax_76543210);
#else
  {
    const int16x4_t v_eobmax_3210 = vmax_s16(vget_low_s16(v_eobmax_76543210),
                                             vget_high_s16(v_eobmax_76543210));
    const int64x1_t v_eobmax_xx32 =
        vshr_n_s64(vreinterpret_s64_s16(v_eobmax_3210), 32);
    const int16x4_t v_eobmax_tmp =
        vmax_s16(v_eobmax_3210, vreinterpret_s16_s64(v_eobmax_xx32));
    const int64x1_t v_eobmax_xxx3 =
        vshr_n_s64(vreinterpret_s64_s16(v_eobmax_tmp), 16);
    const int16x4_t v_eobmax_final =
        vmax_s16(v_eobmax_tmp, vreinterpret_s16_s64(v_eobmax_xxx3));

    *eob_ptr = (uint16_t)vget_lane_s16(v_eobmax_final, 0);
  }
#endif  // __aarch64__
}

static INLINE void calculate_dqcoeff_lp_and_store(const int16x8_t qcoeff,
                                                  const int16x8_t dequant,
                                                  int16_t *dqcoeff) {
  const int32x4_t dqcoeff_0 =
      vmull_s16(vget_low_s16(qcoeff), vget_low_s16(dequant));
  const int32x4_t dqcoeff_1 =
      vmull_s16(vget_high_s16(qcoeff), vget_high_s16(dequant));

  vst1q_s16(dqcoeff, vcombine_s16(vmovn_s32(dqcoeff_0), vmovn_s32(dqcoeff_1)));
}

void av1_quantize_lp_neon(const int16_t *coeff_ptr, intptr_t count,
                          const int16_t *round_ptr, const int16_t *quant_ptr,
                          int16_t *qcoeff_ptr, int16_t *dqcoeff_ptr,
                          const int16_t *dequant_ptr, uint16_t *eob_ptr,
                          const int16_t *scan) {
  // Quantization pass: All coefficients with index >= zero_flag are
  // skippable. Note: zero_flag can be zero.
  const int16x8_t v_zero = vdupq_n_s16(0);
  const int16x8_t v_one = vdupq_n_s16(1);
  int16x8_t v_eobmax_76543210 = vdupq_n_s16(-1);
  int16x8_t v_round = vmovq_n_s16(round_ptr[1]);
  int16x8_t v_quant = vmovq_n_s16(quant_ptr[1]);
  int16x8_t v_dequant = vmovq_n_s16(dequant_ptr[1]);

  // adjust for dc
  v_round = vsetq_lane_s16(round_ptr[0], v_round, 0);
  v_quant = vsetq_lane_s16(quant_ptr[0], v_quant, 0);
  v_dequant = vsetq_lane_s16(dequant_ptr[0], v_dequant, 0);
  // process dc and the first seven ac coeffs
  {
    const int16x8_t v_iscan = vld1q_s16(&scan[0]);
    const int16x8_t v_coeff = vld1q_s16(coeff_ptr);
    const int16x8_t v_coeff_sign = vshrq_n_s16(v_coeff, 15);
    const int16x8_t v_abs = vabsq_s16(v_coeff);
    const int16x8_t v_tmp = vqaddq_s16(v_abs, v_round);
    const int32x4_t v_tmp_lo =
        vmull_s16(vget_low_s16(v_tmp), vget_low_s16(v_quant));
    const int32x4_t v_tmp_hi =
        vmull_s16(vget_high_s16(v_tmp), vget_high_s16(v_quant));
    const int16x8_t v_tmp2 =
        vcombine_s16(vshrn_n_s32(v_tmp_lo, 16), vshrn_n_s32(v_tmp_hi, 16));
    const uint16x8_t v_nz_mask = vceqq_s16(v_tmp2, v_zero);
    const int16x8_t v_iscan_plus1 = vaddq_s16(v_iscan, v_one);
    const int16x8_t v_nz_iscan = vbslq_s16(v_nz_mask, v_zero, v_iscan_plus1);
    const int16x8_t v_qcoeff_a = veorq_s16(v_tmp2, v_coeff_sign);
    const int16x8_t v_qcoeff = vsubq_s16(v_qcoeff_a, v_coeff_sign);
    calculate_dqcoeff_lp_and_store(v_qcoeff, v_dequant, dqcoeff_ptr);
    v_eobmax_76543210 = vmaxq_s16(v_eobmax_76543210, v_nz_iscan);
    vst1q_s16(qcoeff_ptr, v_qcoeff);
    v_round = vmovq_n_s16(round_ptr[1]);
    v_quant = vmovq_n_s16(quant_ptr[1]);
    v_dequant = vmovq_n_s16(dequant_ptr[1]);
  }
  // now process the rest of the ac coeffs
  for (int i = 8; i < count; i += 8) {
    const int16x8_t v_iscan = vld1q_s16(&scan[i]);
    const int16x8_t v_coeff = vld1q_s16(coeff_ptr + i);
    const int16x8_t v_coeff_sign = vshrq_n_s16(v_coeff, 15);
    const int16x8_t v_abs = vabsq_s16(v_coeff);
    const int16x8_t v_tmp = vqaddq_s16(v_abs, v_round);
    const int32x4_t v_tmp_lo =
        vmull_s16(vget_low_s16(v_tmp), vget_low_s16(v_quant));
    const int32x4_t v_tmp_hi =
        vmull_s16(vget_high_s16(v_tmp), vget_high_s16(v_quant));
    const int16x8_t v_tmp2 =
        vcombine_s16(vshrn_n_s32(v_tmp_lo, 16), vshrn_n_s32(v_tmp_hi, 16));
    const uint16x8_t v_nz_mask = vceqq_s16(v_tmp2, v_zero);
    const int16x8_t v_iscan_plus1 = vaddq_s16(v_iscan, v_one);
    const int16x8_t v_nz_iscan = vbslq_s16(v_nz_mask, v_zero, v_iscan_plus1);
    const int16x8_t v_qcoeff_a = veorq_s16(v_tmp2, v_coeff_sign);
    const int16x8_t v_qcoeff = vsubq_s16(v_qcoeff_a, v_coeff_sign);
    calculate_dqcoeff_lp_and_store(v_qcoeff, v_dequant, dqcoeff_ptr + i);
    v_eobmax_76543210 = vmaxq_s16(v_eobmax_76543210, v_nz_iscan);
    vst1q_s16(qcoeff_ptr + i, v_qcoeff);
  }
#ifdef __aarch64__
  *eob_ptr = vmaxvq_s16(v_eobmax_76543210);
#else
  {
    const int16x4_t v_eobmax_3210 = vmax_s16(vget_low_s16(v_eobmax_76543210),
                                             vget_high_s16(v_eobmax_76543210));
    const int64x1_t v_eobmax_xx32 =
        vshr_n_s64(vreinterpret_s64_s16(v_eobmax_3210), 32);
    const int16x4_t v_eobmax_tmp =
        vmax_s16(v_eobmax_3210, vreinterpret_s16_s64(v_eobmax_xx32));
    const int64x1_t v_eobmax_xxx3 =
        vshr_n_s64(vreinterpret_s64_s16(v_eobmax_tmp), 16);
    const int16x4_t v_eobmax_final =
        vmax_s16(v_eobmax_tmp, vreinterpret_s16_s64(v_eobmax_xxx3));

    *eob_ptr = (uint16_t)vget_lane_s16(v_eobmax_final, 0);
  }
#endif  // __aarch64__
}
