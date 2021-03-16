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

#include <math.h>
#include <string.h>

#include "config/aom_scale_rtcd.h"

#include "aom/aom_integer.h"
#include "aom_ports/system_state.h"
#include "av1/common/av1_common_int.h"
#include "av1/common/cdef.h"
#include "av1/common/reconinter.h"
#include "av1/encoder/encoder.h"

#define REDUCED_PRI_STRENGTHS_LVL1 8
#define REDUCED_PRI_STRENGTHS_LVL2 5

#define REDUCED_TOTAL_STRENGTHS_LVL1 \
  (REDUCED_PRI_STRENGTHS_LVL1 * CDEF_SEC_STRENGTHS)
#define REDUCED_TOTAL_STRENGTHS_LVL2 \
  (REDUCED_PRI_STRENGTHS_LVL2 * CDEF_SEC_STRENGTHS)
#define TOTAL_STRENGTHS (CDEF_PRI_STRENGTHS * CDEF_SEC_STRENGTHS)

static const int priconv_lvl1[REDUCED_TOTAL_STRENGTHS_LVL1] = { 0, 1, 2,  3,
                                                                5, 7, 10, 13 };
static const int priconv_lvl2[REDUCED_TOTAL_STRENGTHS_LVL2] = { 0, 2, 4, 8,
                                                                14 };
static const int nb_cdef_strengths[CDEF_PICK_METHODS] = {
  TOTAL_STRENGTHS, REDUCED_TOTAL_STRENGTHS_LVL1, REDUCED_TOTAL_STRENGTHS_LVL2,
  TOTAL_STRENGTHS
};

// Get primary strength value for the given index and search method
static INLINE int get_pri_strength(CDEF_PICK_METHOD pick_method, int pri_idx) {
  switch (pick_method) {
    case CDEF_FAST_SEARCH_LVL1: return priconv_lvl1[pri_idx];
    case CDEF_FAST_SEARCH_LVL2: return priconv_lvl2[pri_idx];
    default: assert(0 && "Invalid CDEF primary index"); return -1;
  }
}

/* Search for the best strength to add as an option, knowing we
   already selected nb_strengths options. */
static uint64_t search_one(int *lev, int nb_strengths,
                           uint64_t mse[][TOTAL_STRENGTHS], int sb_count,
                           CDEF_PICK_METHOD pick_method) {
  uint64_t tot_mse[TOTAL_STRENGTHS];
  const int total_strengths = nb_cdef_strengths[pick_method];
  int i, j;
  uint64_t best_tot_mse = (uint64_t)1 << 63;
  int best_id = 0;
  memset(tot_mse, 0, sizeof(tot_mse));
  for (i = 0; i < sb_count; i++) {
    int gi;
    uint64_t best_mse = (uint64_t)1 << 63;
    /* Find best mse among already selected options. */
    for (gi = 0; gi < nb_strengths; gi++) {
      if (mse[i][lev[gi]] < best_mse) {
        best_mse = mse[i][lev[gi]];
      }
    }
    /* Find best mse when adding each possible new option. */
    for (j = 0; j < total_strengths; j++) {
      uint64_t best = best_mse;
      if (mse[i][j] < best) best = mse[i][j];
      tot_mse[j] += best;
    }
  }
  for (j = 0; j < total_strengths; j++) {
    if (tot_mse[j] < best_tot_mse) {
      best_tot_mse = tot_mse[j];
      best_id = j;
    }
  }
  lev[nb_strengths] = best_id;
  return best_tot_mse;
}

/* Search for the best luma+chroma strength to add as an option, knowing we
   already selected nb_strengths options. */
static uint64_t search_one_dual(int *lev0, int *lev1, int nb_strengths,
                                uint64_t (**mse)[TOTAL_STRENGTHS], int sb_count,
                                CDEF_PICK_METHOD pick_method) {
  uint64_t tot_mse[TOTAL_STRENGTHS][TOTAL_STRENGTHS];
  int i, j;
  uint64_t best_tot_mse = (uint64_t)1 << 63;
  int best_id0 = 0;
  int best_id1 = 0;
  const int total_strengths = nb_cdef_strengths[pick_method];
  memset(tot_mse, 0, sizeof(tot_mse));
  for (i = 0; i < sb_count; i++) {
    int gi;
    uint64_t best_mse = (uint64_t)1 << 63;
    /* Find best mse among already selected options. */
    for (gi = 0; gi < nb_strengths; gi++) {
      uint64_t curr = mse[0][i][lev0[gi]];
      curr += mse[1][i][lev1[gi]];
      if (curr < best_mse) {
        best_mse = curr;
      }
    }
    /* Find best mse when adding each possible new option. */
    for (j = 0; j < total_strengths; j++) {
      int k;
      for (k = 0; k < total_strengths; k++) {
        uint64_t best = best_mse;
        uint64_t curr = mse[0][i][j];
        curr += mse[1][i][k];
        if (curr < best) best = curr;
        tot_mse[j][k] += best;
      }
    }
  }
  for (j = 0; j < total_strengths; j++) {
    int k;
    for (k = 0; k < total_strengths; k++) {
      if (tot_mse[j][k] < best_tot_mse) {
        best_tot_mse = tot_mse[j][k];
        best_id0 = j;
        best_id1 = k;
      }
    }
  }
  lev0[nb_strengths] = best_id0;
  lev1[nb_strengths] = best_id1;
  return best_tot_mse;
}

/* Search for the set of strengths that minimizes mse. */
static uint64_t joint_strength_search(int *best_lev, int nb_strengths,
                                      uint64_t mse[][TOTAL_STRENGTHS],
                                      int sb_count,
                                      CDEF_PICK_METHOD pick_method) {
  uint64_t best_tot_mse;
  int fast = (pick_method == CDEF_FAST_SEARCH_LVL1 ||
              pick_method == CDEF_FAST_SEARCH_LVL2);
  int i;
  best_tot_mse = (uint64_t)1 << 63;
  /* Greedy search: add one strength options at a time. */
  for (i = 0; i < nb_strengths; i++) {
    best_tot_mse = search_one(best_lev, i, mse, sb_count, pick_method);
  }
  /* Trying to refine the greedy search by reconsidering each
     already-selected option. */
  if (!fast) {
    for (i = 0; i < 4 * nb_strengths; i++) {
      int j;
      for (j = 0; j < nb_strengths - 1; j++) best_lev[j] = best_lev[j + 1];
      best_tot_mse =
          search_one(best_lev, nb_strengths - 1, mse, sb_count, pick_method);
    }
  }
  return best_tot_mse;
}

/* Search for the set of luma+chroma strengths that minimizes mse. */
static uint64_t joint_strength_search_dual(int *best_lev0, int *best_lev1,
                                           int nb_strengths,
                                           uint64_t (**mse)[TOTAL_STRENGTHS],
                                           int sb_count,
                                           CDEF_PICK_METHOD pick_method) {
  uint64_t best_tot_mse;
  int i;
  best_tot_mse = (uint64_t)1 << 63;
  /* Greedy search: add one strength options at a time. */
  for (i = 0; i < nb_strengths; i++) {
    best_tot_mse =
        search_one_dual(best_lev0, best_lev1, i, mse, sb_count, pick_method);
  }
  /* Trying to refine the greedy search by reconsidering each
     already-selected option. */
  for (i = 0; i < 4 * nb_strengths; i++) {
    int j;
    for (j = 0; j < nb_strengths - 1; j++) {
      best_lev0[j] = best_lev0[j + 1];
      best_lev1[j] = best_lev1[j + 1];
    }
    best_tot_mse = search_one_dual(best_lev0, best_lev1, nb_strengths - 1, mse,
                                   sb_count, pick_method);
  }
  return best_tot_mse;
}

typedef void (*copy_fn_t)(uint16_t *dst, int dstride, const void *src,
                          int src_voffset, int src_hoffset, int sstride,
                          int vsize, int hsize);
typedef uint64_t (*compute_cdef_dist_t)(void *dst, int dstride, uint16_t *src,
                                        cdef_list *dlist, int cdef_count,
                                        BLOCK_SIZE bsize, int coeff_shift,
                                        int row, int col);

static void copy_sb16_16_highbd(uint16_t *dst, int dstride, const void *src,
                                int src_voffset, int src_hoffset, int sstride,
                                int vsize, int hsize) {
  int r;
  const uint16_t *src16 = CONVERT_TO_SHORTPTR((uint8_t *)src);
  const uint16_t *base = &src16[src_voffset * sstride + src_hoffset];
  for (r = 0; r < vsize; r++)
    memcpy(dst + r * dstride, base + r * sstride, hsize * sizeof(*base));
}

static void copy_sb16_16(uint16_t *dst, int dstride, const void *src,
                         int src_voffset, int src_hoffset, int sstride,
                         int vsize, int hsize) {
  int r, c;
  const uint8_t *src8 = (uint8_t *)src;
  const uint8_t *base = &src8[src_voffset * sstride + src_hoffset];
  for (r = 0; r < vsize; r++)
    for (c = 0; c < hsize; c++)
      dst[r * dstride + c] = (uint16_t)base[r * sstride + c];
}

static INLINE uint64_t mse_wxh_16bit_highbd(uint16_t *dst, int dstride,
                                            uint16_t *src, int sstride, int w,
                                            int h) {
  uint64_t sum = 0;
  int i, j;
  for (i = 0; i < h; i++) {
    for (j = 0; j < w; j++) {
      int e = dst[i * dstride + j] - src[i * sstride + j];
      sum += e * e;
    }
  }
  return sum;
}

static INLINE uint64_t mse_wxh_16bit(uint8_t *dst, int dstride, uint16_t *src,
                                     int sstride, int w, int h) {
  uint64_t sum = 0;
  int i, j;
  for (i = 0; i < h; i++) {
    for (j = 0; j < w; j++) {
      int e = (uint16_t)dst[i * dstride + j] - src[i * sstride + j];
      sum += e * e;
    }
  }
  return sum;
}

static INLINE void init_src_params(int *src_stride, int *width, int *height,
                                   int *width_log2, int *height_log2,
                                   BLOCK_SIZE bsize) {
  *src_stride = block_size_wide[bsize];
  *width = block_size_wide[bsize];
  *height = block_size_high[bsize];
  *width_log2 = MI_SIZE_LOG2 + mi_size_wide_log2[bsize];
  *height_log2 = MI_SIZE_LOG2 + mi_size_wide_log2[bsize];
}

/* Compute MSE only on the blocks we filtered. */
static uint64_t compute_cdef_dist_highbd(void *dst, int dstride, uint16_t *src,
                                         cdef_list *dlist, int cdef_count,
                                         BLOCK_SIZE bsize, int coeff_shift,
                                         int row, int col) {
  assert(bsize == BLOCK_4X4 || bsize == BLOCK_4X8 || bsize == BLOCK_8X4 ||
         bsize == BLOCK_8X8);
  uint64_t sum = 0;
  int bi, bx, by;
  uint16_t *dst16 = CONVERT_TO_SHORTPTR((uint8_t *)dst);
  uint16_t *dst_buff = &dst16[row * dstride + col];
  int src_stride, width, height, width_log2, height_log2;
  init_src_params(&src_stride, &width, &height, &width_log2, &height_log2,
                  bsize);
  for (bi = 0; bi < cdef_count; bi++) {
    by = dlist[bi].by;
    bx = dlist[bi].bx;
    sum += mse_wxh_16bit_highbd(
        &dst_buff[(by << height_log2) * dstride + (bx << width_log2)], dstride,
        &src[bi << (height_log2 + width_log2)], src_stride, width, height);
  }
  return sum >> 2 * coeff_shift;
}

static uint64_t compute_cdef_dist(void *dst, int dstride, uint16_t *src,
                                  cdef_list *dlist, int cdef_count,
                                  BLOCK_SIZE bsize, int coeff_shift, int row,
                                  int col) {
  assert(bsize == BLOCK_4X4 || bsize == BLOCK_4X8 || bsize == BLOCK_8X4 ||
         bsize == BLOCK_8X8);
  uint64_t sum = 0;
  int bi, bx, by;
  uint8_t *dst8 = (uint8_t *)dst;
  uint8_t *dst_buff = &dst8[row * dstride + col];
  int src_stride, width, height, width_log2, height_log2;
  init_src_params(&src_stride, &width, &height, &width_log2, &height_log2,
                  bsize);
  for (bi = 0; bi < cdef_count; bi++) {
    by = dlist[bi].by;
    bx = dlist[bi].bx;
    sum += mse_wxh_16bit(
        &dst_buff[(by << height_log2) * dstride + (bx << width_log2)], dstride,
        &src[bi << (height_log2 + width_log2)], src_stride, width, height);
  }
  return sum >> 2 * coeff_shift;
}

static int sb_all_skip(const CommonModeInfoParams *const mi_params, int mi_row,
                       int mi_col) {
  const int maxr = AOMMIN(mi_params->mi_rows - mi_row, MI_SIZE_64X64);
  const int maxc = AOMMIN(mi_params->mi_cols - mi_col, MI_SIZE_64X64);
  const int stride = mi_params->mi_stride;
  MB_MODE_INFO **mbmi = mi_params->mi_grid_base + mi_row * stride + mi_col;
  for (int r = 0; r < maxr; ++r, mbmi += stride) {
    for (int c = 0; c < maxc; ++c) {
      if (!mbmi[c]->skip) return 0;
    }
  }
  return 1;
}

static void pick_cdef_from_qp(AV1_COMMON *const cm) {
  const int bd = cm->seq_params.bit_depth;
  const int q =
      av1_ac_quant_QTX(cm->quant_params.base_qindex, 0, bd) >> (bd - 8);
  CdefInfo *const cdef_info = &cm->cdef_info;
  cdef_info->cdef_bits = 0;
  cdef_info->nb_cdef_strengths = 1;
  cdef_info->cdef_damping = 3 + (cm->quant_params.base_qindex >> 6);

  int predicted_y_f1 = 0;
  int predicted_y_f2 = 0;
  int predicted_uv_f1 = 0;
  int predicted_uv_f2 = 0;
  aom_clear_system_state();
  if (!frame_is_intra_only(cm)) {
    predicted_y_f1 = clamp((int)roundf(q * q * -0.0000023593946f +
                                       q * 0.0068615186f + 0.02709886f),
                           0, 15);
    predicted_y_f2 = clamp((int)roundf(q * q * -0.00000057629734f +
                                       q * 0.0013993345f + 0.03831067f),
                           0, 3);
    predicted_uv_f1 = clamp((int)roundf(q * q * -0.0000007095069f +
                                        q * 0.0034628846f + 0.00887099f),
                            0, 15);
    predicted_uv_f2 = clamp((int)roundf(q * q * 0.00000023874085f +
                                        q * 0.00028223585f + 0.05576307f),
                            0, 3);
  } else {
    predicted_y_f1 = clamp(
        (int)roundf(q * q * 0.0000033731974f + q * 0.008070594f + 0.0187634f),
        0, 15);
    predicted_y_f2 = clamp(
        (int)roundf(q * q * 0.0000029167343f + q * 0.0027798624f + 0.0079405f),
        0, 3);
    predicted_uv_f1 = clamp(
        (int)roundf(q * q * -0.0000130790995f + q * 0.012892405f - 0.00748388f),
        0, 15);
    predicted_uv_f2 = clamp((int)roundf(q * q * 0.0000032651783f +
                                        q * 0.00035520183f + 0.00228092f),
                            0, 3);
  }
  cdef_info->cdef_strengths[0] =
      predicted_y_f1 * CDEF_SEC_STRENGTHS + predicted_y_f2;
  cdef_info->cdef_uv_strengths[0] =
      predicted_uv_f1 * CDEF_SEC_STRENGTHS + predicted_uv_f2;

  const CommonModeInfoParams *const mi_params = &cm->mi_params;
  const int nvfb = (mi_params->mi_rows + MI_SIZE_64X64 - 1) / MI_SIZE_64X64;
  const int nhfb = (mi_params->mi_cols + MI_SIZE_64X64 - 1) / MI_SIZE_64X64;
  MB_MODE_INFO **mbmi = mi_params->mi_grid_base;
  for (int r = 0; r < nvfb; ++r) {
    for (int c = 0; c < nhfb; ++c) {
      mbmi[MI_SIZE_64X64 * c]->cdef_strength = 0;
    }
    mbmi += MI_SIZE_64X64 * mi_params->mi_stride;
  }
}

void av1_cdef_search(YV12_BUFFER_CONFIG *frame, const YV12_BUFFER_CONFIG *ref,
                     AV1_COMMON *cm, MACROBLOCKD *xd, int pick_method,
                     int rdmult) {
  if (pick_method == CDEF_PICK_FROM_Q) {
    pick_cdef_from_qp(cm);
    return;
  }

  cdef_list dlist[MI_SIZE_128X128 * MI_SIZE_128X128];
  int dir[CDEF_NBLOCKS][CDEF_NBLOCKS] = { { 0 } };
  int var[CDEF_NBLOCKS][CDEF_NBLOCKS] = { { 0 } };
  const CommonModeInfoParams *const mi_params = &cm->mi_params;
  const int nvfb = (mi_params->mi_rows + MI_SIZE_64X64 - 1) / MI_SIZE_64X64;
  const int nhfb = (mi_params->mi_cols + MI_SIZE_64X64 - 1) / MI_SIZE_64X64;
  int *sb_index = aom_malloc(nvfb * nhfb * sizeof(*sb_index));
  const int damping = 3 + (cm->quant_params.base_qindex >> 6);
  const int fast = (pick_method == CDEF_FAST_SEARCH_LVL1 ||
                    pick_method == CDEF_FAST_SEARCH_LVL2);
  const int total_strengths = nb_cdef_strengths[pick_method];
  DECLARE_ALIGNED(32, uint16_t, tmp_dst[1 << (MAX_SB_SIZE_LOG2 * 2)]);
  const int num_planes = av1_num_planes(cm);
  av1_setup_dst_planes(xd->plane, cm->seq_params.sb_size, frame, 0, 0, 0,
                       num_planes);
  uint64_t(*mse[2])[TOTAL_STRENGTHS];
  mse[0] = aom_malloc(sizeof(**mse) * nvfb * nhfb);
  mse[1] = aom_malloc(sizeof(**mse) * nvfb * nhfb);

  int bsize[3];
  int mi_wide_l2[3];
  int mi_high_l2[3];
  int xdec[3];
  int ydec[3];
  uint8_t *ref_buffer[3] = { ref->y_buffer, ref->u_buffer, ref->v_buffer };
  int ref_stride[3] = { ref->y_stride, ref->uv_stride, ref->uv_stride };

  for (int pli = 0; pli < num_planes; pli++) {
    xdec[pli] = xd->plane[pli].subsampling_x;
    ydec[pli] = xd->plane[pli].subsampling_y;
    bsize[pli] = ydec[pli] ? (xdec[pli] ? BLOCK_4X4 : BLOCK_8X4)
                           : (xdec[pli] ? BLOCK_4X8 : BLOCK_8X8);
    mi_wide_l2[pli] = MI_SIZE_LOG2 - xd->plane[pli].subsampling_x;
    mi_high_l2[pli] = MI_SIZE_LOG2 - xd->plane[pli].subsampling_y;
  }

  copy_fn_t copy_fn;
  compute_cdef_dist_t compute_cdef_dist_fn;

  if (cm->seq_params.use_highbitdepth) {
    copy_fn = copy_sb16_16_highbd;
    compute_cdef_dist_fn = compute_cdef_dist_highbd;
  } else {
    copy_fn = copy_sb16_16;
    compute_cdef_dist_fn = compute_cdef_dist;
  }

  DECLARE_ALIGNED(32, uint16_t, inbuf[CDEF_INBUF_SIZE]);
  uint16_t *const in = inbuf + CDEF_VBORDER * CDEF_BSTRIDE + CDEF_HBORDER;
  const int coeff_shift = AOMMAX(cm->seq_params.bit_depth - 8, 0);
  int sb_count = 0;
  for (int fbr = 0; fbr < nvfb; ++fbr) {
    for (int fbc = 0; fbc < nhfb; ++fbc) {
      // No filtering if the entire filter block is skipped
      if (sb_all_skip(mi_params, fbr * MI_SIZE_64X64, fbc * MI_SIZE_64X64))
        continue;

      const MB_MODE_INFO *const mbmi =
          mi_params->mi_grid_base[MI_SIZE_64X64 * fbr * mi_params->mi_stride +
                                  MI_SIZE_64X64 * fbc];
      if (((fbc & 1) &&
           (mbmi->sb_type == BLOCK_128X128 || mbmi->sb_type == BLOCK_128X64)) ||
          ((fbr & 1) &&
           (mbmi->sb_type == BLOCK_128X128 || mbmi->sb_type == BLOCK_64X128)))
        continue;

      int nhb = AOMMIN(MI_SIZE_64X64, mi_params->mi_cols - MI_SIZE_64X64 * fbc);
      int nvb = AOMMIN(MI_SIZE_64X64, mi_params->mi_rows - MI_SIZE_64X64 * fbr);
      int hb_step = 1;
      int vb_step = 1;
      BLOCK_SIZE bs;
      if (mbmi->sb_type == BLOCK_128X128 || mbmi->sb_type == BLOCK_128X64 ||
          mbmi->sb_type == BLOCK_64X128) {
        bs = mbmi->sb_type;
        if (bs == BLOCK_128X128 || bs == BLOCK_128X64) {
          nhb =
              AOMMIN(MI_SIZE_128X128, mi_params->mi_cols - MI_SIZE_64X64 * fbc);
          hb_step = 2;
        }
        if (bs == BLOCK_128X128 || bs == BLOCK_64X128) {
          nvb =
              AOMMIN(MI_SIZE_128X128, mi_params->mi_rows - MI_SIZE_64X64 * fbr);
          vb_step = 2;
        }
      } else {
        bs = BLOCK_64X64;
      }

      const int cdef_count = av1_cdef_compute_sb_list(
          mi_params, fbr * MI_SIZE_64X64, fbc * MI_SIZE_64X64, dlist, bs);

      const int yoff = CDEF_VBORDER * (fbr != 0);
      const int xoff = CDEF_HBORDER * (fbc != 0);
      int dirinit = 0;
      for (int pli = 0; pli < num_planes; pli++) {
        for (int i = 0; i < CDEF_INBUF_SIZE; i++) inbuf[i] = CDEF_VERY_LARGE;
        /* We avoid filtering the pixels for which some of the pixels to
           average are outside the frame. We could change the filter instead,
           but it would add special cases for any future vectorization. */
        const int ysize = (nvb << mi_high_l2[pli]) +
                          CDEF_VBORDER * (fbr + vb_step < nvfb) + yoff;
        const int xsize = (nhb << mi_wide_l2[pli]) +
                          CDEF_HBORDER * (fbc + hb_step < nhfb) + xoff;
        const int row = fbr * MI_SIZE_64X64 << mi_high_l2[pli];
        const int col = fbc * MI_SIZE_64X64 << mi_wide_l2[pli];
        for (int gi = 0; gi < total_strengths; gi++) {
          int pri_strength = gi / CDEF_SEC_STRENGTHS;
          if (fast) pri_strength = get_pri_strength(pick_method, pri_strength);
          const int sec_strength = gi % CDEF_SEC_STRENGTHS;
          copy_fn(&in[(-yoff * CDEF_BSTRIDE - xoff)], CDEF_BSTRIDE,
                  xd->plane[pli].dst.buf, row - yoff, col - xoff,
                  xd->plane[pli].dst.stride, ysize, xsize);
          av1_cdef_filter_fb(
              NULL, tmp_dst, CDEF_BSTRIDE, in, xdec[pli], ydec[pli], dir,
              &dirinit, var, pli, dlist, cdef_count, pri_strength,
              sec_strength + (sec_strength == 3), damping, coeff_shift);
          const uint64_t curr_mse = compute_cdef_dist_fn(
              ref_buffer[pli], ref_stride[pli], tmp_dst, dlist, cdef_count,
              bsize[pli], coeff_shift, row, col);
          if (pli < 2)
            mse[pli][sb_count][gi] = curr_mse;
          else
            mse[1][sb_count][gi] += curr_mse;
        }
      }
      sb_index[sb_count++] =
          MI_SIZE_64X64 * fbr * mi_params->mi_stride + MI_SIZE_64X64 * fbc;
    }
  }

  /* Search for different number of signalling bits. */
  int nb_strength_bits = 0;
  uint64_t best_rd = UINT64_MAX;
  CdefInfo *const cdef_info = &cm->cdef_info;
  for (int i = 0; i <= 3; i++) {
    int best_lev0[CDEF_MAX_STRENGTHS];
    int best_lev1[CDEF_MAX_STRENGTHS] = { 0 };
    const int nb_strengths = 1 << i;
    uint64_t tot_mse;
    if (num_planes > 1) {
      tot_mse = joint_strength_search_dual(best_lev0, best_lev1, nb_strengths,
                                           mse, sb_count, pick_method);
    } else {
      tot_mse = joint_strength_search(best_lev0, nb_strengths, mse[0], sb_count,
                                      pick_method);
    }

    const int total_bits = sb_count * i + nb_strengths * CDEF_STRENGTH_BITS *
                                              (num_planes > 1 ? 2 : 1);
    const int rate_cost = av1_cost_literal(total_bits);
    const uint64_t dist = tot_mse * 16;
    const uint64_t rd = RDCOST(rdmult, rate_cost, dist);
    if (rd < best_rd) {
      best_rd = rd;
      nb_strength_bits = i;
      memcpy(cdef_info->cdef_strengths, best_lev0,
             nb_strengths * sizeof(best_lev0[0]));
      if (num_planes > 1) {
        memcpy(cdef_info->cdef_uv_strengths, best_lev1,
               nb_strengths * sizeof(best_lev1[0]));
      }
    }
  }

  cdef_info->cdef_bits = nb_strength_bits;
  cdef_info->nb_cdef_strengths = 1 << nb_strength_bits;
  for (int i = 0; i < sb_count; i++) {
    uint64_t best_mse = UINT64_MAX;
    int best_gi = 0;
    for (int gi = 0; gi < cdef_info->nb_cdef_strengths; gi++) {
      uint64_t curr = mse[0][i][cdef_info->cdef_strengths[gi]];
      if (num_planes > 1) curr += mse[1][i][cdef_info->cdef_uv_strengths[gi]];
      if (curr < best_mse) {
        best_gi = gi;
        best_mse = curr;
      }
    }
    mi_params->mi_grid_base[sb_index[i]]->cdef_strength = best_gi;
  }

  if (fast) {
    for (int j = 0; j < cdef_info->nb_cdef_strengths; j++) {
      const int luma_strength = cdef_info->cdef_strengths[j];
      const int chroma_strength = cdef_info->cdef_uv_strengths[j];
      int pri_strength;
      pri_strength =
          get_pri_strength(pick_method, luma_strength / CDEF_SEC_STRENGTHS);
      cdef_info->cdef_strengths[j] = pri_strength * CDEF_SEC_STRENGTHS +
                                     (luma_strength % CDEF_SEC_STRENGTHS);
      pri_strength =
          get_pri_strength(pick_method, chroma_strength / CDEF_SEC_STRENGTHS);
      cdef_info->cdef_uv_strengths[j] = pri_strength * CDEF_SEC_STRENGTHS +
                                        (chroma_strength % CDEF_SEC_STRENGTHS);
    }
  }

  cdef_info->cdef_damping = damping;

  aom_free(mse[0]);
  aom_free(mse[1]);
  aom_free(sb_index);
}
