sub av1_common_forward_decls() {
print <<EOF
/*
 * AV1
 */

#include "aom/aom_integer.h"
#include "av1/common/common.h"
#include "av1/common/enums.h"
#include "av1/common/quant_common.h"
#include "av1/common/filter.h"
#include "av1/common/convolve.h"
#include "av1/common/av1_txfm.h"
#include "av1/common/odintrin.h"

struct macroblockd;

/* Encoder forward decls */
struct macroblock;
struct aom_variance_vtable;
struct search_site_config;
struct mv;
union int_mv;
struct yv12_buffer_config;
typedef uint16_t od_dering_in;
EOF
}
forward_decls qw/av1_common_forward_decls/;

# functions that are 64 bit only.
$mmx_x86_64 = $sse2_x86_64 = $ssse3_x86_64 = $avx_x86_64 = $avx2_x86_64 = '';
if ($opts{arch} eq "x86_64") {
  $mmx_x86_64 = 'mmx';
  $sse2_x86_64 = 'sse2';
  $ssse3_x86_64 = 'ssse3';
  $avx_x86_64 = 'avx';
  $avx2_x86_64 = 'avx2';
}

#
# 10/12-tap convolution filters
#
add_proto qw/void av1_lowbd_convolve_init/, "void";
specialize qw/av1_lowbd_convolve_init ssse3/;

add_proto qw/void av1_convolve_horiz/, "const uint8_t *src, int src_stride, uint8_t *dst, int dst_stride, int w, int h, const InterpFilterParams fp, const int subpel_x_q4, int x_step_q4, ConvolveParams *conv_params";
specialize qw/av1_convolve_horiz ssse3/;

add_proto qw/void av1_convolve_vert/, "const uint8_t *src, int src_stride, uint8_t *dst, int dst_stride, int w, int h, const InterpFilterParams fp, const int subpel_x_q4, int x_step_q4, ConvolveParams *conv_params";
specialize qw/av1_convolve_vert ssse3/;

if (aom_config("CONFIG_HIGHBITDEPTH") eq "yes") {
  add_proto qw/void av1_highbd_convolve_init/, "void";
  specialize qw/av1_highbd_convolve_init sse4_1/;
  add_proto qw/void av1_highbd_convolve_horiz/, "const uint16_t *src, int src_stride, uint16_t *dst, int dst_stride, int w, int h, const InterpFilterParams fp, const int subpel_x_q4, int x_step_q4, int avg, int bd";
  specialize qw/av1_highbd_convolve_horiz sse4_1/;
  add_proto qw/void av1_highbd_convolve_vert/, "const uint16_t *src, int src_stride, uint16_t *dst, int dst_stride, int w, int h, const InterpFilterParams fp, const int subpel_x_q4, int x_step_q4, int avg, int bd";
  specialize qw/av1_highbd_convolve_vert sse4_1/;
}

#
# Inverse dct
#
if (aom_config("CONFIG_HIGHBITDEPTH") eq "yes") {
  {
    add_proto qw/void av1_iht4x4_16_add/, "const tran_low_t *input, uint8_t *dest, int dest_stride, int tx_type";
      specialize qw/av1_iht4x4_16_add sse2/;

    add_proto qw/void av1_iht4x8_32_add/, "const tran_low_t *input, uint8_t *dest, int dest_stride, int tx_type";
      specialize qw/av1_iht4x8_32_add sse2/;

    add_proto qw/void av1_iht8x4_32_add/, "const tran_low_t *input, uint8_t *dest, int dest_stride, int tx_type";
      specialize qw/av1_iht8x4_32_add sse2/;

    add_proto qw/void av1_iht8x16_128_add/, "const tran_low_t *input, uint8_t *dest, int dest_stride, int tx_type";
      specialize qw/av1_iht8x16_128_add sse2/;

    add_proto qw/void av1_iht16x8_128_add/, "const tran_low_t *input, uint8_t *dest, int dest_stride, int tx_type";
      specialize qw/av1_iht16x8_128_add sse2/;

    add_proto qw/void av1_iht16x32_512_add/, "const tran_low_t *input, uint8_t *dest, int dest_stride, int tx_type";
      specialize qw/av1_iht16x32_512_add sse2/;

    add_proto qw/void av1_iht32x16_512_add/, "const tran_low_t *input, uint8_t *dest, int dest_stride, int tx_type";
      specialize qw/av1_iht32x16_512_add sse2/;

    add_proto qw/void av1_iht4x16_64_add/, "const tran_low_t *input, uint8_t *dest, int dest_stride, int tx_type";

    add_proto qw/void av1_iht16x4_64_add/, "const tran_low_t *input, uint8_t *dest, int dest_stride, int tx_type";

    add_proto qw/void av1_iht8x32_256_add/, "const tran_low_t *input, uint8_t *dest, int dest_stride, int tx_type";

    add_proto qw/void av1_iht32x8_256_add/, "const tran_low_t *input, uint8_t *dest, int dest_stride, int tx_type";

    add_proto qw/void av1_iht8x8_64_add/, "const tran_low_t *input, uint8_t *dest, int dest_stride, int tx_type";
      specialize qw/av1_iht8x8_64_add sse2/;

    add_proto qw/void av1_iht16x16_256_add/, "const tran_low_t *input, uint8_t *output, int pitch, int tx_type";
      specialize qw/av1_iht16x16_256_add sse2 avx2/;

    add_proto qw/void av1_iht32x32_1024_add/, "const tran_low_t *input, uint8_t *output, int pitch, int tx_type";
  }
} else {
  {
    add_proto qw/void av1_iht4x4_16_add/, "const tran_low_t *input, uint8_t *dest, int dest_stride, int tx_type";
    specialize qw/av1_iht4x4_16_add sse2 neon dspr2/;

    add_proto qw/void av1_iht4x8_32_add/, "const tran_low_t *input, uint8_t *dest, int dest_stride, int tx_type";
      specialize qw/av1_iht4x8_32_add sse2/;

    add_proto qw/void av1_iht8x4_32_add/, "const tran_low_t *input, uint8_t *dest, int dest_stride, int tx_type";
      specialize qw/av1_iht8x4_32_add sse2/;

    add_proto qw/void av1_iht8x16_128_add/, "const tran_low_t *input, uint8_t *dest, int dest_stride, int tx_type";
      specialize qw/av1_iht8x16_128_add sse2/;

    add_proto qw/void av1_iht16x8_128_add/, "const tran_low_t *input, uint8_t *dest, int dest_stride, int tx_type";
      specialize qw/av1_iht16x8_128_add sse2/;

    add_proto qw/void av1_iht16x32_512_add/, "const tran_low_t *input, uint8_t *dest, int dest_stride, int tx_type";
      specialize qw/av1_iht16x32_512_add sse2/;

    add_proto qw/void av1_iht32x16_512_add/, "const tran_low_t *input, uint8_t *dest, int dest_stride, int tx_type";
      specialize qw/av1_iht32x16_512_add sse2/;

    add_proto qw/void av1_iht4x16_64_add/, "const tran_low_t *input, uint8_t *dest, int dest_stride, int tx_type";

    add_proto qw/void av1_iht16x4_64_add/, "const tran_low_t *input, uint8_t *dest, int dest_stride, int tx_type";

    add_proto qw/void av1_iht8x32_256_add/, "const tran_low_t *input, uint8_t *dest, int dest_stride, int tx_type";

    add_proto qw/void av1_iht32x8_256_add/, "const tran_low_t *input, uint8_t *dest, int dest_stride, int tx_type";

    add_proto qw/void av1_iht8x8_64_add/, "const tran_low_t *input, uint8_t *dest, int dest_stride, int tx_type";
      specialize qw/av1_iht8x8_64_add sse2 neon dspr2/;

    add_proto qw/void av1_iht16x16_256_add/, "const tran_low_t *input, uint8_t *output, int pitch, int tx_type";
      specialize qw/av1_iht16x16_256_add sse2 avx2 dspr2/;

    add_proto qw/void av1_iht32x32_1024_add/, "const tran_low_t *input, uint8_t *output, int pitch, int tx_type";

    if (aom_config("CONFIG_EXT_TX") ne "yes") {
      specialize qw/av1_iht4x4_16_add msa/;
      specialize qw/av1_iht8x8_64_add msa/;
      specialize qw/av1_iht16x16_256_add msa/;
    }
  }
}

add_proto qw/void av1_iht32x32_1024_add/, "const tran_low_t *input, uint8_t *output, int pitch, int tx_type";

if (aom_config("CONFIG_TX64X64") eq "yes") {
  add_proto qw/void av1_iht64x64_4096_add/, "const tran_low_t *input, uint8_t *output, int pitch, int tx_type";
}

if (aom_config("CONFIG_NEW_QUANT") eq "yes") {
  add_proto qw/void quantize_nuq/, "const tran_low_t *coeff_ptr, intptr_t n_coeffs, int skip_block, const int16_t *quant_ptr, const int16_t *quant_shift_ptr, const int16_t *dequant_ptr, const cuml_bins_type_nuq *cuml_bins_ptr, const dequant_val_type_nuq *dequant_val, tran_low_t *qcoeff_ptr, tran_low_t *dqcoeff_ptr, uint16_t *eob_ptr, const int16_t *scan, const uint8_t *band";

  add_proto qw/void quantize_fp_nuq/, "const tran_low_t *coeff_ptr, intptr_t n_coeffs, int skip_block, const int16_t *quant_ptr, const int16_t *dequant_ptr, const cuml_bins_type_nuq *cuml_bins_ptr, const dequant_val_type_nuq *dequant_val, tran_low_t *qcoeff_ptr, tran_low_t *dqcoeff_ptr, uint16_t *eob_ptr, const int16_t *scan, const uint8_t *band";

  add_proto qw/void quantize_32x32_nuq/, "const tran_low_t *coeff_ptr, intptr_t n_coeffs, int skip_block, const int16_t *quant_ptr, const int16_t *quant_shift_ptr, const int16_t *dequant_ptr, const cuml_bins_type_nuq *cuml_bins_ptr, const dequant_val_type_nuq *dequant_val, tran_low_t *qcoeff_ptr, tran_low_t *dqcoeff_ptr, uint16_t *eob_ptr, const int16_t *scan, const uint8_t *band";

  add_proto qw/void quantize_32x32_fp_nuq/, "const tran_low_t *coeff_ptr, intptr_t n_coeffs, int skip_block, const int16_t *quant_ptr, const int16_t *dequant_ptr, const cuml_bins_type_nuq *cuml_bins_ptr, const dequant_val_type_nuq *dequant_val, tran_low_t *qcoeff_ptr, tran_low_t *dqcoeff_ptr, uint16_t *eob_ptr, const int16_t *scan, const uint8_t *band";

  if (aom_config("CONFIG_TX64X64") eq "yes") {
    add_proto qw/void quantize_64x64_nuq/, "const tran_low_t *coeff_ptr, intptr_t n_coeffs, int skip_block, const int16_t *quant_ptr, const int16_t *quant_shift_ptr, const int16_t *dequant_ptr, const cuml_bins_type_nuq *cuml_bins_ptr, const dequant_val_type_nuq *dequant_val, tran_low_t *qcoeff_ptr, tran_low_t *dqcoeff_ptr, uint16_t *eob_ptr, const int16_t *scan, const uint8_t *band";

    add_proto qw/void quantize_64x64_fp_nuq/, "const tran_low_t *coeff_ptr, intptr_t n_coeffs, int skip_block, const int16_t *quant_ptr, const int16_t *dequant_ptr, const cuml_bins_type_nuq *cuml_bins_ptr, const dequant_val_type_nuq *dequant_val, tran_low_t *qcoeff_ptr, tran_low_t *dqcoeff_ptr, uint16_t *eob_ptr, const int16_t *scan, const uint8_t *band";
  }
}

# FILTER_INTRA predictor functions
if (aom_config("CONFIG_FILTER_INTRA") eq "yes") {
  add_proto qw/void av1_dc_filter_predictor/, "uint8_t *dst, ptrdiff_t stride, int bs, const uint8_t *above, const uint8_t *left";
  add_proto qw/void av1_v_filter_predictor/, "uint8_t *dst, ptrdiff_t stride, int bs, const uint8_t *above, const uint8_t *left";
  add_proto qw/void av1_h_filter_predictor/, "uint8_t *dst, ptrdiff_t stride, int bs, const uint8_t *above, const uint8_t *left";
  add_proto qw/void av1_d45_filter_predictor/, "uint8_t *dst, ptrdiff_t stride, int bs, const uint8_t *above, const uint8_t *left";
  add_proto qw/void av1_d135_filter_predictor/, "uint8_t *dst, ptrdiff_t stride, int bs, const uint8_t *above, const uint8_t *left";
  add_proto qw/void av1_d117_filter_predictor/, "uint8_t *dst, ptrdiff_t stride, int bs, const uint8_t *above, const uint8_t *left";
  add_proto qw/void av1_d153_filter_predictor/, "uint8_t *dst, ptrdiff_t stride, int bs, const uint8_t *above, const uint8_t *left";
  add_proto qw/void av1_d207_filter_predictor/, "uint8_t *dst, ptrdiff_t stride, int bs, const uint8_t *above, const uint8_t *left";
  add_proto qw/void av1_d63_filter_predictor/, "uint8_t *dst, ptrdiff_t stride, int bs, const uint8_t *above, const uint8_t *left";
  add_proto qw/void av1_tm_filter_predictor/, "uint8_t *dst, ptrdiff_t stride, int bs, const uint8_t *above, const uint8_t *left";
  # High bitdepth functions
  if (aom_config("CONFIG_HIGHBITDEPTH") eq "yes") {
    add_proto qw/void av1_highbd_dc_filter_predictor/, "uint16_t *dst, ptrdiff_t stride, int bs, const uint16_t *above, const uint16_t *left, int bd";
    add_proto qw/void av1_highbd_v_filter_predictor/, "uint16_t *dst, ptrdiff_t stride, int bs, const uint16_t *above, const uint16_t *left, int bd";
    add_proto qw/void av1_highbd_h_filter_predictor/, "uint16_t *dst, ptrdiff_t stride, int bs, const uint16_t *above, const uint16_t *left, int bd";
    add_proto qw/void av1_highbd_d45_filter_predictor/, "uint16_t *dst, ptrdiff_t stride, int bs, const uint16_t *above, const uint16_t *left, int bd";
    add_proto qw/void av1_highbd_d135_filter_predictor/, "uint16_t *dst, ptrdiff_t stride, int bs, const uint16_t *above, const uint16_t *left, int bd";
    add_proto qw/void av1_highbd_d117_filter_predictor/, "uint16_t *dst, ptrdiff_t stride, int bs, const uint16_t *above, const uint16_t *left, int bd";
    add_proto qw/void av1_highbd_d153_filter_predictor/, "uint16_t *dst, ptrdiff_t stride, int bs, const uint16_t *above, const uint16_t *left, int bd";
    add_proto qw/void av1_highbd_d207_filter_predictor/, "uint16_t *dst, ptrdiff_t stride, int bs, const uint16_t *above, const uint16_t *left, int bd";
    add_proto qw/void av1_highbd_d63_filter_predictor/, "uint16_t *dst, ptrdiff_t stride, int bs, const uint16_t *above, const uint16_t *left, int bd";
    add_proto qw/void av1_highbd_tm_filter_predictor/, "uint16_t *dst, ptrdiff_t stride, int bs, const uint16_t *above, const uint16_t *left, int bd";
  }
}

# High bitdepth functions
if (aom_config("CONFIG_HIGHBITDEPTH") eq "yes") {
  #
  # Sub Pixel Filters
  #
  add_proto qw/void av1_highbd_convolve_copy/, "const uint8_t *src, ptrdiff_t src_stride, uint8_t *dst, ptrdiff_t dst_stride, const int16_t *filter_x, int x_step_q4, const int16_t *filter_y, int y_step_q4, int w, int h, int bps";

  add_proto qw/void av1_highbd_convolve_avg/, "const uint8_t *src, ptrdiff_t src_stride, uint8_t *dst, ptrdiff_t dst_stride, const int16_t *filter_x, int x_step_q4, const int16_t *filter_y, int y_step_q4, int w, int h, int bps";

  add_proto qw/void av1_highbd_convolve8/, "const uint8_t *src, ptrdiff_t src_stride, uint8_t *dst, ptrdiff_t dst_stride, const int16_t *filter_x, int x_step_q4, const int16_t *filter_y, int y_step_q4, int w, int h, int bps";
  specialize qw/av1_highbd_convolve8/, "$sse2_x86_64";

  add_proto qw/void av1_highbd_convolve8_horiz/, "const uint8_t *src, ptrdiff_t src_stride, uint8_t *dst, ptrdiff_t dst_stride, const int16_t *filter_x, int x_step_q4, const int16_t *filter_y, int y_step_q4, int w, int h, int bps";
  specialize qw/av1_highbd_convolve8_horiz/, "$sse2_x86_64";

  add_proto qw/void av1_highbd_convolve8_vert/, "const uint8_t *src, ptrdiff_t src_stride, uint8_t *dst, ptrdiff_t dst_stride, const int16_t *filter_x, int x_step_q4, const int16_t *filter_y, int y_step_q4, int w, int h, int bps";
  specialize qw/av1_highbd_convolve8_vert/, "$sse2_x86_64";

  add_proto qw/void av1_highbd_convolve8_avg/, "const uint8_t *src, ptrdiff_t src_stride, uint8_t *dst, ptrdiff_t dst_stride, const int16_t *filter_x, int x_step_q4, const int16_t *filter_y, int y_step_q4, int w, int h, int bps";
  specialize qw/av1_highbd_convolve8_avg/, "$sse2_x86_64";

  add_proto qw/void av1_highbd_convolve8_avg_horiz/, "const uint8_t *src, ptrdiff_t src_stride, uint8_t *dst, ptrdiff_t dst_stride, const int16_t *filter_x, int x_step_q4, const int16_t *filter_y, int y_step_q4, int w, int h, int bps";
  specialize qw/av1_highbd_convolve8_avg_horiz/, "$sse2_x86_64";

  add_proto qw/void av1_highbd_convolve8_avg_vert/, "const uint8_t *src, ptrdiff_t src_stride, uint8_t *dst, ptrdiff_t dst_stride, const int16_t *filter_x, int x_step_q4, const int16_t *filter_y, int y_step_q4, int w, int h, int bps";
  specialize qw/av1_highbd_convolve8_avg_vert/, "$sse2_x86_64";

  #
  # dct
  #
  add_proto qw/void av1_highbd_iht4x4_16_add/, "const tran_low_t *input, uint8_t *dest, int dest_stride, int tx_type, int bd";

  add_proto qw/void av1_highbd_iht4x8_32_add/, "const tran_low_t *input, uint8_t *dest, int dest_stride, int tx_type, int bd";

  add_proto qw/void av1_highbd_iht8x4_32_add/, "const tran_low_t *input, uint8_t *dest, int dest_stride, int tx_type, int bd";

  add_proto qw/void av1_highbd_iht8x16_128_add/, "const tran_low_t *input, uint8_t *dest, int dest_stride, int tx_type, int bd";

  add_proto qw/void av1_highbd_iht16x8_128_add/, "const tran_low_t *input, uint8_t *dest, int dest_stride, int tx_type, int bd";

  add_proto qw/void av1_highbd_iht16x32_512_add/, "const tran_low_t *input, uint8_t *dest, int dest_stride, int tx_type, int bd";

  add_proto qw/void av1_highbd_iht32x16_512_add/, "const tran_low_t *input, uint8_t *dest, int dest_stride, int tx_type, int bd";

  add_proto qw/void av1_highbd_iht4x16_64_add/, "const tran_low_t *input, uint8_t *dest, int dest_stride, int tx_type, int bd";

  add_proto qw/void av1_highbd_iht16x4_64_add/, "const tran_low_t *input, uint8_t *dest, int dest_stride, int tx_type, int bd";

  add_proto qw/void av1_highbd_iht8x32_256_add/, "const tran_low_t *input, uint8_t *dest, int dest_stride, int tx_type, int bd";

  add_proto qw/void av1_highbd_iht32x8_256_add/, "const tran_low_t *input, uint8_t *dest, int dest_stride, int tx_type, int bd";

  add_proto qw/void av1_highbd_iht8x8_64_add/, "const tran_low_t *input, uint8_t *dest, int dest_stride, int tx_type, int bd";

  add_proto qw/void av1_highbd_iht16x16_256_add/, "const tran_low_t *input, uint8_t *output, int pitch, int tx_type, int bd";
}

if (aom_config("CONFIG_HIGHBITDEPTH") eq "yes") {
  #inv txfm
  add_proto qw/void av1_inv_txfm2d_add_4x4/, "const int32_t *input, uint16_t *output, int stride, int tx_type, int bd";
  specialize qw/av1_inv_txfm2d_add_4x4 sse4_1/;
  add_proto qw/void av1_inv_txfm2d_add_8x8/, "const int32_t *input, uint16_t *output, int stride, int tx_type, int bd";
  specialize qw/av1_inv_txfm2d_add_8x8 sse4_1/;
  add_proto qw/void av1_inv_txfm2d_add_16x16/, "const int32_t *input, uint16_t *output, int stride, int tx_type, int bd";
  specialize qw/av1_inv_txfm2d_add_16x16 sse4_1/;
  add_proto qw/void av1_inv_txfm2d_add_32x32/, "const int32_t *input, uint16_t *output, int stride, int tx_type, int bd";
  specialize qw/av1_inv_txfm2d_add_32x32 avx2/;
  add_proto qw/void av1_inv_txfm2d_add_64x64/, "const int32_t *input, uint16_t *output, int stride, int tx_type, int bd";
}

#
# Encoder functions below this point.
#
if (aom_config("CONFIG_AV1_ENCODER") eq "yes") {

# ENCODEMB INVOKE

if (aom_config("CONFIG_AOM_QM") eq "yes") {
  if (aom_config("CONFIG_HIGHBITDEPTH") eq "yes") {
    # the transform coefficients are held in 32-bit
    # values, so the assembler code for  av1_block_error can no longer be used.
    add_proto qw/int64_t av1_block_error/, "const tran_low_t *coeff, const tran_low_t *dqcoeff, intptr_t block_size, int64_t *ssz";

    add_proto qw/void av1_quantize_fp/, "const tran_low_t *coeff_ptr, intptr_t n_coeffs, int skip_block, const int16_t *zbin_ptr, const int16_t *round_ptr, const int16_t *quant_ptr, const int16_t *quant_shift_ptr, tran_low_t *qcoeff_ptr, tran_low_t *dqcoeff_ptr, const int16_t *dequant_ptr, uint16_t *eob_ptr, const int16_t *scan, const int16_t *iscan, const qm_val_t * qm_ptr, const qm_val_t *iqm_ptr";

    add_proto qw/void av1_quantize_fp_32x32/, "const tran_low_t *coeff_ptr, intptr_t n_coeffs, int skip_block, const int16_t *zbin_ptr, const int16_t *round_ptr, const int16_t *quant_ptr, const int16_t *quant_shift_ptr, tran_low_t *qcoeff_ptr, tran_low_t *dqcoeff_ptr, const int16_t *dequant_ptr, uint16_t *eob_ptr, const int16_t *scan, const int16_t *iscan, const qm_val_t * qm_ptr, const qm_val_t *iqm_ptr";

    if (aom_config("CONFIG_TX64X64") eq "yes") {
      add_proto qw/void av1_quantize_fp_64x64/, "const tran_low_t *coeff_ptr, intptr_t n_coeffs, int skip_block, const int16_t *zbin_ptr, const int16_t *round_ptr, const int16_t *quant_ptr, const int16_t *quant_shift_ptr, tran_low_t *qcoeff_ptr, tran_low_t *dqcoeff_ptr, const int16_t *dequant_ptr, uint16_t *eob_ptr, const int16_t *scan, const int16_t *iscan, const qm_val_t * qm_ptr, const qm_val_t *iqm_ptr";
    }

    add_proto qw/void av1_fdct8x8_quant/, "const int16_t *input, int stride, tran_low_t *coeff_ptr, intptr_t n_coeffs, int skip_block, const int16_t *zbin_ptr, const int16_t *round_ptr, const int16_t *quant_ptr, const int16_t *quant_shift_ptr, tran_low_t *qcoeff_ptr, tran_low_t *dqcoeff_ptr, const int16_t *dequant_ptr, uint16_t *eob_ptr, const int16_t *scan, const int16_t *iscan, const qm_val_t * qm_ptr, const qm_val_t *iqm_ptr";
  } else {
    add_proto qw/int64_t av1_block_error/, "const tran_low_t *coeff, const tran_low_t *dqcoeff, intptr_t block_size, int64_t *ssz";
    specialize qw/av1_block_error avx2 msa/, "$sse2_x86inc";

    add_proto qw/int64_t av1_block_error_fp/, "const int16_t *coeff, const int16_t *dqcoeff, int block_size";
    specialize qw/av1_block_error_fp neon/, "$sse2_x86inc";

    add_proto qw/void av1_quantize_fp/, "const tran_low_t *coeff_ptr, intptr_t n_coeffs, int skip_block, const int16_t *zbin_ptr, const int16_t *round_ptr, const int16_t *quant_ptr, const int16_t *quant_shift_ptr, tran_low_t *qcoeff_ptr, tran_low_t *dqcoeff_ptr, const int16_t *dequant_ptr, uint16_t *eob_ptr, const int16_t *scan, const int16_t *iscan, const qm_val_t * qm_ptr, const qm_val_t *iqm_ptr";

    add_proto qw/void av1_quantize_fp_32x32/, "const tran_low_t *coeff_ptr, intptr_t n_coeffs, int skip_block, const int16_t *zbin_ptr, const int16_t *round_ptr, const int16_t *quant_ptr, const int16_t *quant_shift_ptr, tran_low_t *qcoeff_ptr, tran_low_t *dqcoeff_ptr, const int16_t *dequant_ptr, uint16_t *eob_ptr, const int16_t *scan, const int16_t *iscan, const qm_val_t * qm_ptr, const qm_val_t *iqm_ptr";

    if (aom_config("CONFIG_TX64X64") eq "yes") {
      add_proto qw/void av1_quantize_fp_64x64/, "const tran_low_t *coeff_ptr, intptr_t n_coeffs, int skip_block, const int16_t *zbin_ptr, const int16_t *round_ptr, const int16_t *quant_ptr, const int16_t *quant_shift_ptr, tran_low_t *qcoeff_ptr, tran_low_t *dqcoeff_ptr, const int16_t *dequant_ptr, uint16_t *eob_ptr, const int16_t *scan, const int16_t *iscan, const qm_val_t * qm_ptr, const qm_val_t *iqm_ptr";
    }

    add_proto qw/void av1_fdct8x8_quant/, "const int16_t *input, int stride, tran_low_t *coeff_ptr, intptr_t n_coeffs, int skip_block, const int16_t *zbin_ptr, const int16_t *round_ptr, const int16_t *quant_ptr, const int16_t *quant_shift_ptr, tran_low_t *qcoeff_ptr, tran_low_t *dqcoeff_ptr, const int16_t *dequant_ptr, uint16_t *eob_ptr, const int16_t *scan, const int16_t *iscan, const qm_val_t * qm_ptr, const qm_val_t *iqm_ptr";
  }
} else {
  if (aom_config("CONFIG_HIGHBITDEPTH") eq "yes") {
    # the transform coefficients are held in 32-bit
    # values, so the assembler code for  av1_block_error can no longer be used.
    add_proto qw/int64_t av1_block_error/, "const tran_low_t *coeff, const tran_low_t *dqcoeff, intptr_t block_size, int64_t *ssz";

    add_proto qw/void av1_quantize_fp/, "const tran_low_t *coeff_ptr, intptr_t n_coeffs, int skip_block, const int16_t *zbin_ptr, const int16_t *round_ptr, const int16_t *quant_ptr, const int16_t *quant_shift_ptr, tran_low_t *qcoeff_ptr, tran_low_t *dqcoeff_ptr, const int16_t *dequant_ptr, uint16_t *eob_ptr, const int16_t *scan, const int16_t *iscan";
    specialize qw/av1_quantize_fp sse2/;

    add_proto qw/void av1_quantize_fp_32x32/, "const tran_low_t *coeff_ptr, intptr_t n_coeffs, int skip_block, const int16_t *zbin_ptr, const int16_t *round_ptr, const int16_t *quant_ptr, const int16_t *quant_shift_ptr, tran_low_t *qcoeff_ptr, tran_low_t *dqcoeff_ptr, const int16_t *dequant_ptr, uint16_t *eob_ptr, const int16_t *scan, const int16_t *iscan";

    if (aom_config("CONFIG_TX64X64") eq "yes") {
      add_proto qw/void av1_quantize_fp_64x64/, "const tran_low_t *coeff_ptr, intptr_t n_coeffs, int skip_block, const int16_t *zbin_ptr, const int16_t *round_ptr, const int16_t *quant_ptr, const int16_t *quant_shift_ptr, tran_low_t *qcoeff_ptr, tran_low_t *dqcoeff_ptr, const int16_t *dequant_ptr, uint16_t *eob_ptr, const int16_t *scan, const int16_t *iscan";
    }

    add_proto qw/void av1_fdct8x8_quant/, "const int16_t *input, int stride, tran_low_t *coeff_ptr, intptr_t n_coeffs, int skip_block, const int16_t *zbin_ptr, const int16_t *round_ptr, const int16_t *quant_ptr, const int16_t *quant_shift_ptr, tran_low_t *qcoeff_ptr, tran_low_t *dqcoeff_ptr, const int16_t *dequant_ptr, uint16_t *eob_ptr, const int16_t *scan, const int16_t *iscan";
  } else {
    add_proto qw/int64_t av1_block_error/, "const tran_low_t *coeff, const tran_low_t *dqcoeff, intptr_t block_size, int64_t *ssz";
    specialize qw/av1_block_error sse2 avx2 msa/;

    add_proto qw/int64_t av1_block_error_fp/, "const int16_t *coeff, const int16_t *dqcoeff, int block_size";
    specialize qw/av1_block_error_fp neon sse2/;

    add_proto qw/void av1_quantize_fp/, "const tran_low_t *coeff_ptr, intptr_t n_coeffs, int skip_block, const int16_t *zbin_ptr, const int16_t *round_ptr, const int16_t *quant_ptr, const int16_t *quant_shift_ptr, tran_low_t *qcoeff_ptr, tran_low_t *dqcoeff_ptr, const int16_t *dequant_ptr, uint16_t *eob_ptr, const int16_t *scan, const int16_t *iscan";
    specialize qw/av1_quantize_fp neon sse2/, "$ssse3_x86_64";

    add_proto qw/void av1_quantize_fp_32x32/, "const tran_low_t *coeff_ptr, intptr_t n_coeffs, int skip_block, const int16_t *zbin_ptr, const int16_t *round_ptr, const int16_t *quant_ptr, const int16_t *quant_shift_ptr, tran_low_t *qcoeff_ptr, tran_low_t *dqcoeff_ptr, const int16_t *dequant_ptr, uint16_t *eob_ptr, const int16_t *scan, const int16_t *iscan";
    specialize qw/av1_quantize_fp_32x32/, "$ssse3_x86_64";

    if (aom_config("CONFIG_TX64X64") eq "yes") {
      add_proto qw/void av1_quantize_fp_64x64/, "const tran_low_t *coeff_ptr, intptr_t n_coeffs, int skip_block, const int16_t *zbin_ptr, const int16_t *round_ptr, const int16_t *quant_ptr, const int16_t *quant_shift_ptr, tran_low_t *qcoeff_ptr, tran_low_t *dqcoeff_ptr, const int16_t *dequant_ptr, uint16_t *eob_ptr, const int16_t *scan, const int16_t *iscan";
    }

    add_proto qw/void av1_fdct8x8_quant/, "const int16_t *input, int stride, tran_low_t *coeff_ptr, intptr_t n_coeffs, int skip_block, const int16_t *zbin_ptr, const int16_t *round_ptr, const int16_t *quant_ptr, const int16_t *quant_shift_ptr, tran_low_t *qcoeff_ptr, tran_low_t *dqcoeff_ptr, const int16_t *dequant_ptr, uint16_t *eob_ptr, const int16_t *scan, const int16_t *iscan";
    specialize qw/av1_fdct8x8_quant sse2 ssse3 neon/;
  }

}

# fdct functions

add_proto qw/void av1_fht4x4/, "const int16_t *input, tran_low_t *output, int stride, int tx_type";
specialize qw/av1_fht4x4 sse2/;

add_proto qw/void av1_fwht4x4/, "const int16_t *input, tran_low_t *output, int stride";

add_proto qw/void av1_fht8x8/, "const int16_t *input, tran_low_t *output, int stride, int tx_type";
specialize qw/av1_fht8x8 sse2/;

add_proto qw/void av1_fht16x16/, "const int16_t *input, tran_low_t *output, int stride, int tx_type";
specialize qw/av1_fht16x16 sse2 avx2/;

add_proto qw/void av1_fht32x32/, "const int16_t *input, tran_low_t *output, int stride, int tx_type";
specialize qw/av1_fht32x32 sse2 avx2/;

if (aom_config("CONFIG_TX64X64") eq "yes") {
  add_proto qw/void av1_fht64x64/, "const int16_t *input, tran_low_t *output, int stride, int tx_type";
}

add_proto qw/void av1_fht4x8/, "const int16_t *input, tran_low_t *output, int stride, int tx_type";
specialize qw/av1_fht4x8 sse2/;

add_proto qw/void av1_fht8x4/, "const int16_t *input, tran_low_t *output, int stride, int tx_type";
specialize qw/av1_fht8x4 sse2/;

add_proto qw/void av1_fht8x16/, "const int16_t *input, tran_low_t *output, int stride, int tx_type";
specialize qw/av1_fht8x16 sse2/;

add_proto qw/void av1_fht16x8/, "const int16_t *input, tran_low_t *output, int stride, int tx_type";
specialize qw/av1_fht16x8 sse2/;

add_proto qw/void av1_fht16x32/, "const int16_t *input, tran_low_t *output, int stride, int tx_type";
specialize qw/av1_fht16x32 sse2/;

add_proto qw/void av1_fht32x16/, "const int16_t *input, tran_low_t *output, int stride, int tx_type";
specialize qw/av1_fht32x16 sse2/;

add_proto qw/void av1_fht4x16/, "const int16_t *input, tran_low_t *output, int stride, int tx_type";

add_proto qw/void av1_fht16x4/, "const int16_t *input, tran_low_t *output, int stride, int tx_type";

add_proto qw/void av1_fht8x32/, "const int16_t *input, tran_low_t *output, int stride, int tx_type";

add_proto qw/void av1_fht32x8/, "const int16_t *input, tran_low_t *output, int stride, int tx_type";

if (aom_config("CONFIG_HIGHBITDEPTH") ne "yes") {
  if (aom_config("CONFIG_EXT_TX") ne "yes") {
    specialize qw/av1_fht4x4 msa/;
    specialize qw/av1_fht8x8 msa/;
    specialize qw/av1_fht16x16 msa/;
  }
}

add_proto qw/void av1_fwd_idtx/, "const int16_t *src_diff, tran_low_t *coeff, int stride, int bs, int tx_type";

if (aom_config("CONFIG_DPCM_INTRA") eq "yes") {
  @sizes = (4, 8, 16, 32);
  foreach $size (@sizes) {
    add_proto "void", "av1_dpcm_ft$size", "const int16_t *input, int stride, TX_TYPE_1D tx_type, tran_low_t *output";
  }
}

if (aom_config("CONFIG_HIGHBITDEPTH") eq "yes") {
  #fwd txfm
  add_proto qw/void av1_fwd_txfm2d_4x4/, "const int16_t *input, int32_t *output, int stride, int tx_type, int bd";
  specialize qw/av1_fwd_txfm2d_4x4 sse4_1/;
  add_proto qw/void av1_fwd_txfm2d_8x8/, "const int16_t *input, int32_t *output, int stride, int tx_type, int bd";
  specialize qw/av1_fwd_txfm2d_8x8 sse4_1/;
  add_proto qw/void av1_fwd_txfm2d_16x16/, "const int16_t *input, int32_t *output, int stride, int tx_type, int bd";
  specialize qw/av1_fwd_txfm2d_16x16 sse4_1/;
  add_proto qw/void av1_fwd_txfm2d_32x32/, "const int16_t *input, int32_t *output, int stride, int tx_type, int bd";
  specialize qw/av1_fwd_txfm2d_32x32 sse4_1/;
  add_proto qw/void av1_fwd_txfm2d_64x64/, "const int16_t *input, int32_t *output, int stride, int tx_type, int bd";
  specialize qw/av1_fwd_txfm2d_64x64 sse4_1/;
}

#
# Motion search
#
add_proto qw/int av1_full_search_sad/, "const struct macroblock *x, const struct mv *ref_mv, int sad_per_bit, int distance, const struct aom_variance_vtable *fn_ptr, const struct mv *center_mv, struct mv *best_mv";
specialize qw/av1_full_search_sad sse3 sse4_1/;
$av1_full_search_sad_sse3=av1_full_search_sadx3;
$av1_full_search_sad_sse4_1=av1_full_search_sadx8;

add_proto qw/int av1_diamond_search_sad/, "struct macroblock *x, const struct search_site_config *cfg,  struct mv *ref_mv, struct mv *best_mv, int search_param, int sad_per_bit, int *num00, const struct aom_variance_vtable *fn_ptr, const struct mv *center_mv";

add_proto qw/int av1_full_range_search/, "const struct macroblock *x, const struct search_site_config *cfg, struct mv *ref_mv, struct mv *best_mv, int search_param, int sad_per_bit, int *num00, const struct aom_variance_vtable *fn_ptr, const struct mv *center_mv";

add_proto qw/void av1_temporal_filter_apply/, "uint8_t *frame1, unsigned int stride, uint8_t *frame2, unsigned int block_width, unsigned int block_height, int strength, int filter_weight, unsigned int *accumulator, uint16_t *count";
specialize qw/av1_temporal_filter_apply sse2 msa/;

if (aom_config("CONFIG_AOM_QM") eq "yes") {
  add_proto qw/void av1_quantize_b/, "const tran_low_t *coeff_ptr, intptr_t n_coeffs, int skip_block, const int16_t *zbin_ptr, const int16_t *round_ptr, const int16_t *quant_ptr, const int16_t *quant_shift_ptr, tran_low_t *qcoeff_ptr, tran_low_t *dqcoeff_ptr, const int16_t *dequant_ptr, uint16_t *eob_ptr, const int16_t *scan, const int16_t *iscan, const qm_val_t * qm_ptr, const qm_val_t * iqm_ptr, int log_scale";
} else {
  add_proto qw/void av1_quantize_b/, "const tran_low_t *coeff_ptr, intptr_t n_coeffs, int skip_block, const int16_t *zbin_ptr, const int16_t *round_ptr, const int16_t *quant_ptr, const int16_t *quant_shift_ptr, tran_low_t *qcoeff_ptr, tran_low_t *dqcoeff_ptr, const int16_t *dequant_ptr, uint16_t *eob_ptr, const int16_t *scan, const int16_t *iscan, int log_scale";
}

if (aom_config("CONFIG_HIGHBITDEPTH") eq "yes") {

  # ENCODEMB INVOKE
  if (aom_config("CONFIG_NEW_QUANT") eq "yes") {
    add_proto qw/void highbd_quantize_nuq/, "const tran_low_t *coeff_ptr, intptr_t n_coeffs, int skip_block, const int16_t *quant_ptr, const int16_t *quant_shift_ptr, const int16_t *dequant_ptr, const cuml_bins_type_nuq *cuml_bins_ptr, const dequant_val_type_nuq *dequant_val, tran_low_t *qcoeff_ptr, tran_low_t *dqcoeff_ptr, uint16_t *eob_ptr, const int16_t *scan, const uint8_t *band";

    add_proto qw/void highbd_quantize_fp_nuq/, "const tran_low_t *coeff_ptr, intptr_t n_coeffs, int skip_block, const int16_t *quant_ptr, const int16_t *dequant_ptr, const cuml_bins_type_nuq *cuml_bins_ptr, const dequant_val_type_nuq *dequant_val, tran_low_t *qcoeff_ptr, tran_low_t *dqcoeff_ptr, uint16_t *eob_ptr, const int16_t *scan, const uint8_t *band";

    add_proto qw/void highbd_quantize_32x32_nuq/, "const tran_low_t *coeff_ptr, intptr_t n_coeffs, int skip_block, const int16_t *quant_ptr, const int16_t *quant_shift_ptr, const int16_t *dequant_ptr, const cuml_bins_type_nuq *cuml_bins_ptr, const dequant_val_type_nuq *dequant_val, tran_low_t *qcoeff_ptr, tran_low_t *dqcoeff_ptr, uint16_t *eob_ptr, const int16_t *scan, const uint8_t *band";

    add_proto qw/void highbd_quantize_32x32_fp_nuq/, "const tran_low_t *coeff_ptr, intptr_t n_coeffs, int skip_block, const int16_t *quant_ptr, const int16_t *dequant_ptr, const cuml_bins_type_nuq *cuml_bins_ptr, const dequant_val_type_nuq *dequant_val, tran_low_t *qcoeff_ptr, tran_low_t *dqcoeff_ptr, uint16_t *eob_ptr, const int16_t *scan, const uint8_t *band";

    if (aom_config("CONFIG_TX64X64") eq "yes") {
      add_proto qw/void highbd_quantize_64x64_nuq/, "const tran_low_t *coeff_ptr, intptr_t n_coeffs, int skip_block, const int16_t *quant_ptr, const int16_t *quant_shift_ptr, const int16_t *dequant_ptr, const cuml_bins_type_nuq *cuml_bins_ptr, const dequant_val_type_nuq *dequant_val, tran_low_t *qcoeff_ptr, tran_low_t *dqcoeff_ptr, uint16_t *eob_ptr, const int16_t *scan, const uint8_t *band";

      add_proto qw/void highbd_quantize_64x64_fp_nuq/, "const tran_low_t *coeff_ptr, intptr_t n_coeffs, int skip_block, const int16_t *quant_ptr, const int16_t *dequant_ptr, const cuml_bins_type_nuq *cuml_bins_ptr, const dequant_val_type_nuq *dequant_val, tran_low_t *qcoeff_ptr, tran_low_t *dqcoeff_ptr, uint16_t *eob_ptr, const int16_t *scan, const uint8_t *band";
    }
  }

  add_proto qw/int64_t av1_highbd_block_error/, "const tran_low_t *coeff, const tran_low_t *dqcoeff, intptr_t block_size, int64_t *ssz, int bd";
  specialize qw/av1_highbd_block_error sse2/;

  if (aom_config("CONFIG_AOM_QM") eq "yes") {
    add_proto qw/void av1_highbd_quantize_fp/, "const tran_low_t *coeff_ptr, intptr_t n_coeffs, int skip_block, const int16_t *zbin_ptr, const int16_t *round_ptr, const int16_t *quant_ptr, const int16_t *quant_shift_ptr, tran_low_t *qcoeff_ptr, tran_low_t *dqcoeff_ptr, const int16_t *dequant_ptr, uint16_t *eob_ptr, const int16_t *scan, const int16_t *iscan, const qm_val_t * qm_ptr, const qm_val_t * iqm_ptr, int log_scale";

    add_proto qw/void av1_highbd_quantize_fp_32x32/, "const tran_low_t *coeff_ptr, intptr_t n_coeffs, int skip_block, const int16_t *zbin_ptr, const int16_t *round_ptr, const int16_t *quant_ptr, const int16_t *quant_shift_ptr, tran_low_t *qcoeff_ptr, tran_low_t *dqcoeff_ptr, const int16_t *dequant_ptr, uint16_t *eob_ptr, const int16_t *scan, const int16_t *iscan, const qm_val_t * qm_ptr, const qm_val_t * iqm_ptr, int log_scale";

    if (aom_config("CONFIG_TX64X64") eq "yes") {
      add_proto qw/void av1_highbd_quantize_fp_64x64/, "const tran_low_t *coeff_ptr, intptr_t n_coeffs, int skip_block, const int16_t *zbin_ptr, const int16_t *round_ptr, const int16_t *quant_ptr, const int16_t *quant_shift_ptr, tran_low_t *qcoeff_ptr, tran_low_t *dqcoeff_ptr, const int16_t *dequant_ptr, uint16_t *eob_ptr, const int16_t *scan, const int16_t *iscan, const qm_val_t * qm_ptr, const qm_val_t * iqm_ptr, int log_scale";
    }

    add_proto qw/void av1_highbd_quantize_b/, "const tran_low_t *coeff_ptr, intptr_t n_coeffs, int skip_block, const int16_t *zbin_ptr, const int16_t *round_ptr, const int16_t *quant_ptr, const int16_t *quant_shift_ptr, tran_low_t *qcoeff_ptr, tran_low_t *dqcoeff_ptr, const int16_t *dequant_ptr, uint16_t *eob_ptr, const int16_t *scan, const int16_t *iscan, const qm_val_t * qm_ptr, const qm_val_t * iqm_ptr, int log_scale";
  } else {
    add_proto qw/void av1_highbd_quantize_fp/, "const tran_low_t *coeff_ptr, intptr_t n_coeffs, int skip_block, const int16_t *zbin_ptr, const int16_t *round_ptr, const int16_t *quant_ptr, const int16_t *quant_shift_ptr, tran_low_t *qcoeff_ptr, tran_low_t *dqcoeff_ptr, const int16_t *dequant_ptr, uint16_t *eob_ptr, const int16_t *scan, const int16_t *iscan, int log_scale";
    specialize qw/av1_highbd_quantize_fp sse4_1/;

    add_proto qw/void av1_highbd_quantize_b/, "const tran_low_t *coeff_ptr, intptr_t n_coeffs, int skip_block, const int16_t *zbin_ptr, const int16_t *round_ptr, const int16_t *quant_ptr, const int16_t *quant_shift_ptr, tran_low_t *qcoeff_ptr, tran_low_t *dqcoeff_ptr, const int16_t *dequant_ptr, uint16_t *eob_ptr, const int16_t *scan, const int16_t *iscan, int log_scale";
  }

  # fdct functions
  add_proto qw/void av1_highbd_fht4x4/, "const int16_t *input, tran_low_t *output, int stride, int tx_type";
  specialize qw/av1_highbd_fht4x4 sse4_1/;

  add_proto qw/void av1_highbd_fht4x8/, "const int16_t *input, tran_low_t *output, int stride, int tx_type";

  add_proto qw/void av1_highbd_fht8x4/, "const int16_t *input, tran_low_t *output, int stride, int tx_type";

  add_proto qw/void av1_highbd_fht8x16/, "const int16_t *input, tran_low_t *output, int stride, int tx_type";

  add_proto qw/void av1_highbd_fht16x8/, "const int16_t *input, tran_low_t *output, int stride, int tx_type";

  add_proto qw/void av1_highbd_fht16x32/, "const int16_t *input, tran_low_t *output, int stride, int tx_type";

  add_proto qw/void av1_highbd_fht32x16/, "const int16_t *input, tran_low_t *output, int stride, int tx_type";

  add_proto qw/void av1_highbd_fht4x16/, "const int16_t *input, tran_low_t *output, int stride, int tx_type";

  add_proto qw/void av1_highbd_fht16x4/, "const int16_t *input, tran_low_t *output, int stride, int tx_type";

  add_proto qw/void av1_highbd_fht8x32/, "const int16_t *input, tran_low_t *output, int stride, int tx_type";

  add_proto qw/void av1_highbd_fht32x8/, "const int16_t *input, tran_low_t *output, int stride, int tx_type";

  add_proto qw/void av1_highbd_fht8x8/, "const int16_t *input, tran_low_t *output, int stride, int tx_type";

  add_proto qw/void av1_highbd_fht16x16/, "const int16_t *input, tran_low_t *output, int stride, int tx_type";

  add_proto qw/void av1_highbd_fht32x32/, "const int16_t *input, tran_low_t *output, int stride, int tx_type";

  if (aom_config("CONFIG_TX64X64") eq "yes") {
    add_proto qw/void av1_highbd_fht64x64/, "const int16_t *input, tran_low_t *output, int stride, int tx_type";
  }

  add_proto qw/void av1_highbd_fwht4x4/, "const int16_t *input, tran_low_t *output, int stride";

  add_proto qw/void av1_highbd_temporal_filter_apply/, "uint8_t *frame1, unsigned int stride, uint8_t *frame2, unsigned int block_width, unsigned int block_height, int strength, int filter_weight, unsigned int *accumulator, uint16_t *count";

}
# End av1_high encoder functions

if (aom_config("CONFIG_EXT_INTER") eq "yes") {
  add_proto qw/uint64_t av1_wedge_sse_from_residuals/, "const int16_t *r1, const int16_t *d, const uint8_t *m, int N";
  specialize qw/av1_wedge_sse_from_residuals sse2/;
  add_proto qw/int av1_wedge_sign_from_residuals/, "const int16_t *ds, const uint8_t *m, int N, int64_t limit";
  specialize qw/av1_wedge_sign_from_residuals sse2/;
  add_proto qw/void av1_wedge_compute_delta_squares/, "int16_t *d, const int16_t *a, const int16_t *b, int N";
  specialize qw/av1_wedge_compute_delta_squares sse2/;
}

}
# end encoder functions

# If PVQ is enabled, fwd transforms are required by decoder
if (aom_config("CONFIG_PVQ") eq "yes") {
# fdct functions

if (aom_config("CONFIG_HIGHBITDEPTH") eq "yes") {
  add_proto qw/void av1_fht4x4/, "const int16_t *input, tran_low_t *output, int stride, int tx_type";
  specialize qw/av1_fht4x4 sse2/;

  add_proto qw/void av1_fht8x8/, "const int16_t *input, tran_low_t *output, int stride, int tx_type";
  specialize qw/av1_fht8x8 sse2/;

  add_proto qw/void av1_fht16x16/, "const int16_t *input, tran_low_t *output, int stride, int tx_type";
  specialize qw/av1_fht16x16 sse2/;

  add_proto qw/void av1_fwht4x4/, "const int16_t *input, tran_low_t *output, int stride";
  specialize qw/av1_fwht4x4 sse2/;
} else {
  add_proto qw/void av1_fht4x4/, "const int16_t *input, tran_low_t *output, int stride, int tx_type";
  specialize qw/av1_fht4x4 sse2 msa/;

  add_proto qw/void av1_fht8x8/, "const int16_t *input, tran_low_t *output, int stride, int tx_type";
  specialize qw/av1_fht8x8 sse2 msa/;

  add_proto qw/void av1_fht16x16/, "const int16_t *input, tran_low_t *output, int stride, int tx_type";
  specialize qw/av1_fht16x16 sse2 msa/;

  add_proto qw/void av1_fwht4x4/, "const int16_t *input, tran_low_t *output, int stride";
  specialize qw/av1_fwht4x4 msa sse2/;
}

}

# Deringing Functions

if (aom_config("CONFIG_CDEF") eq "yes") {
  add_proto qw/void aom_clpf_block_hbd/, "uint16_t *dst, const uint16_t *src, int dstride, int sstride, int sizex, int sizey, unsigned int strength, unsigned int bd";
  add_proto qw/void aom_clpf_hblock_hbd/, "uint16_t *dst, const uint16_t *src, int dstride, int sstride, int sizex, int sizey, unsigned int strength, unsigned int bd";
  add_proto qw/void aom_clpf_block/, "uint8_t *dst, const uint16_t *src, int dstride, int sstride, int sizex, int sizey, unsigned int strength, unsigned int bd";
  add_proto qw/void aom_clpf_hblock/, "uint8_t *dst, const uint16_t *src, int dstride, int sstride, int sizex, int sizey, unsigned int strength, unsigned int bd";
  add_proto qw/int od_dir_find8/, "const od_dering_in *img, int stride, int32_t *var, int coeff_shift";
  add_proto qw/void od_filter_dering_direction_4x4/, "uint16_t *y, int ystride, const uint16_t *in, int threshold, int dir, int damping";
  add_proto qw/void od_filter_dering_direction_8x8/, "uint16_t *y, int ystride, const uint16_t *in, int threshold, int dir, int damping";

  add_proto qw/void copy_8x8_16bit_to_8bit/, "uint8_t *dst, int dstride, const uint16_t *src, int sstride";
  add_proto qw/void copy_4x4_16bit_to_8bit/, "uint8_t *dst, int dstride, const uint16_t *src, int sstride";
  add_proto qw/void copy_8x8_16bit_to_16bit/, "uint16_t *dst, int dstride, const uint16_t *src, int sstride";
  add_proto qw/void copy_4x4_16bit_to_16bit/, "uint16_t *dst, int dstride, const uint16_t *src, int sstride";
  add_proto qw/void copy_rect8_8bit_to_16bit/, "uint16_t *dst, int dstride, const uint8_t *src, int sstride, int v, int h";
  add_proto qw/void copy_rect8_16bit_to_16bit/, "uint16_t *dst, int dstride, const uint16_t *src, int sstride, int v, int h";

# VS compiling for 32 bit targets does not support vector types in
  # structs as arguments, which makes the v256 type of the intrinsics
  # hard to support, so optimizations for this target are disabled.
  if ($opts{config} !~ /libs-x86-win32-vs.*/) {
    specialize qw/aom_clpf_block_hbd sse2 ssse3 sse4_1 neon/;
    specialize qw/aom_clpf_hblock_hbd sse2 ssse3 sse4_1 neon/;
    specialize qw/aom_clpf_block sse2 ssse3 sse4_1 neon/;
    specialize qw/aom_clpf_hblock sse2 ssse3 sse4_1 neon/;
    specialize qw/od_dir_find8 sse2 ssse3 sse4_1 neon/;
    specialize qw/od_filter_dering_direction_4x4 sse2 ssse3 sse4_1 neon/;
    specialize qw/od_filter_dering_direction_8x8 sse2 ssse3 sse4_1 neon/;

    specialize qw/copy_8x8_16bit_to_8bit sse2 ssse3 sse4_1 neon/;
    specialize qw/copy_4x4_16bit_to_8bit sse2 ssse3 sse4_1 neon/;
    specialize qw/copy_8x8_16bit_to_16bit sse2 ssse3 sse4_1 neon/;
    specialize qw/copy_4x4_16bit_to_16bit sse2 ssse3 sse4_1 neon/;
    specialize qw/copy_rect8_8bit_to_16bit sse2 ssse3 sse4_1 neon/;
    specialize qw/copy_rect8_16bit_to_16bit sse2 ssse3 sse4_1 neon/;
  }
}

# PVQ Functions

if (aom_config("CONFIG_PVQ") eq "yes") {
  add_proto qw/double pvq_search_rdo_double/, "const od_val16 *xcoeff, int n, int k, int *ypulse, double g2, double pvq_norm_lambda, int prev_k";
  specialize qw/pvq_search_rdo_double sse4_1/;
}

# WARPED_MOTION / GLOBAL_MOTION functions

if ((aom_config("CONFIG_WARPED_MOTION") eq "yes") ||
    (aom_config("CONFIG_GLOBAL_MOTION") eq "yes")) {
  add_proto qw/void av1_warp_affine/, "const int32_t *mat, const uint8_t *ref, int width, int height, int stride, uint8_t *pred, int p_col, int p_row, int p_width, int p_height, int p_stride, int subsampling_x, int subsampling_y, int comp_avg, int16_t alpha, int16_t beta, int16_t gamma, int16_t delta";
  specialize qw/av1_warp_affine sse2 ssse3/;

  if (aom_config("CONFIG_HIGHBITDEPTH") eq "yes") {
    add_proto qw/void av1_highbd_warp_affine/, "const int32_t *mat, const uint16_t *ref, int width, int height, int stride, uint16_t *pred, int p_col, int p_row, int p_width, int p_height, int p_stride, int subsampling_x, int subsampling_y, int bd, int comp_avg, int16_t alpha, int16_t beta, int16_t gamma, int16_t delta";
    specialize qw/av1_highbd_warp_affine ssse3/;
  }
}

if (aom_config("CONFIG_GLOBAL_MOTION") eq "yes" &&
    aom_config("CONFIG_AV1_ENCODER") eq "yes") {
  add_proto qw/double compute_cross_correlation/, "unsigned char *im1, int stride1, int x1, int y1, unsigned char *im2, int stride2, int x2, int y2";
  specialize qw/compute_cross_correlation sse4_1/;
}

# LOOP_RESTORATION functions

if (aom_config("CONFIG_LOOP_RESTORATION") eq "yes") {
  add_proto qw/void apply_selfguided_restoration/, "uint8_t *dat, int width, int height, int stride, int eps, int *xqd, uint8_t *dst, int dst_stride, int32_t *tmpbuf";
  specialize qw/apply_selfguided_restoration sse4_1/;

  add_proto qw/void av1_selfguided_restoration/, "uint8_t *dgd, int width, int height, int stride, int32_t *dst, int dst_stride, int r, int eps, int32_t *tmpbuf";
  specialize qw/av1_selfguided_restoration sse4_1/;

  add_proto qw/void av1_highpass_filter/, "uint8_t *dgd, int width, int height, int stride, int32_t *dst, int dst_stride, int r, int eps";
  specialize qw/av1_highpass_filter sse4_1/;

  if (aom_config("CONFIG_HIGHBITDEPTH") eq "yes") {
    add_proto qw/void apply_selfguided_restoration_highbd/, "uint16_t *dat, int width, int height, int stride, int bit_depth, int eps, int *xqd, uint16_t *dst, int dst_stride, int32_t *tmpbuf";
    specialize qw/apply_selfguided_restoration_highbd sse4_1/;

    add_proto qw/void av1_selfguided_restoration_highbd/, "uint16_t *dgd, int width, int height, int stride, int32_t *dst, int dst_stride, int bit_depth, int r, int eps, int32_t *tmpbuf";
    specialize qw/av1_selfguided_restoration_highbd sse4_1/;

    add_proto qw/void av1_highpass_filter_highbd/, "uint16_t *dgd, int width, int height, int stride, int32_t *dst, int dst_stride, int r, int eps";
    specialize qw/av1_highpass_filter_highbd sse4_1/;
  }
}

1;
