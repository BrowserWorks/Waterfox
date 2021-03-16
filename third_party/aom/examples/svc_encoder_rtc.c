/*
 *  Copyright (c) 2019, Alliance for Open Media. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

//  This is an example demonstrating how to implement a multi-layer AOM
//  encoding scheme for RTC video applications.

#include <assert.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "aom/aom_encoder.h"
#include "aom/aomcx.h"
#include "av1/common/enums.h"
#include "common/tools_common.h"
#include "common/video_writer.h"
#include "aom_ports/aom_timer.h"

#define zero(Dest) memset(&(Dest), 0, sizeof(Dest));

static const char *exec_name;

void usage_exit(void) { exit(EXIT_FAILURE); }

static int mode_to_num_temporal_layers[10] = { 1, 2, 3, 3, 2, 1, 1, 3, 3, 3 };
static int mode_to_num_spatial_layers[10] = { 1, 1, 1, 1, 1, 2, 3, 3, 3, 3 };
static int mode_to_num_layers[10] = { 1, 2, 3, 3, 2, 2, 3, 9, 9, 9 };

// For rate control encoding stats.
struct RateControlMetrics {
  // Number of input frames per layer.
  int layer_input_frames[AOM_MAX_TS_LAYERS];
  // Number of encoded non-key frames per layer.
  int layer_enc_frames[AOM_MAX_TS_LAYERS];
  // Framerate per layer layer (cumulative).
  double layer_framerate[AOM_MAX_TS_LAYERS];
  // Target average frame size per layer (per-frame-bandwidth per layer).
  double layer_pfb[AOM_MAX_LAYERS];
  // Actual average frame size per layer.
  double layer_avg_frame_size[AOM_MAX_LAYERS];
  // Average rate mismatch per layer (|target - actual| / target).
  double layer_avg_rate_mismatch[AOM_MAX_LAYERS];
  // Actual encoding bitrate per layer (cumulative across temporal layers).
  double layer_encoding_bitrate[AOM_MAX_LAYERS];
  // Average of the short-time encoder actual bitrate.
  // TODO(marpan): Should we add these short-time stats for each layer?
  double avg_st_encoding_bitrate;
  // Variance of the short-time encoder actual bitrate.
  double variance_st_encoding_bitrate;
  // Window (number of frames) for computing short-timee encoding bitrate.
  int window_size;
  // Number of window measurements.
  int window_count;
  int layer_target_bitrate[AOM_MAX_LAYERS];
};

static int read_frame(struct AvxInputContext *input_ctx, aom_image_t *img) {
  FILE *f = input_ctx->file;
  y4m_input *y4m = &input_ctx->y4m;
  int shortread = 0;

  if (input_ctx->file_type == FILE_TYPE_Y4M) {
    if (y4m_input_fetch_frame(y4m, f, img) < 1) return 0;
  } else {
    shortread = read_yuv_frame(input_ctx, img);
  }

  return !shortread;
}

static int file_is_y4m(const char detect[4]) {
  if (memcmp(detect, "YUV4", 4) == 0) {
    return 1;
  }
  return 0;
}

static int fourcc_is_ivf(const char detect[4]) {
  if (memcmp(detect, "DKIF", 4) == 0) {
    return 1;
  }
  return 0;
}

static void close_input_file(struct AvxInputContext *input) {
  fclose(input->file);
  if (input->file_type == FILE_TYPE_Y4M) y4m_input_close(&input->y4m);
}

static void open_input_file(struct AvxInputContext *input,
                            aom_chroma_sample_position_t csp) {
  /* Parse certain options from the input file, if possible */
  input->file = strcmp(input->filename, "-") ? fopen(input->filename, "rb")
                                             : set_binary_mode(stdin);

  if (!input->file) fatal("Failed to open input file");

  if (!fseeko(input->file, 0, SEEK_END)) {
    /* Input file is seekable. Figure out how long it is, so we can get
     * progress info.
     */
    input->length = ftello(input->file);
    rewind(input->file);
  }

  /* Default to 1:1 pixel aspect ratio. */
  input->pixel_aspect_ratio.numerator = 1;
  input->pixel_aspect_ratio.denominator = 1;

  /* For RAW input sources, these bytes will applied on the first frame
   *  in read_frame().
   */
  input->detect.buf_read = fread(input->detect.buf, 1, 4, input->file);
  input->detect.position = 0;

  if (input->detect.buf_read == 4 && file_is_y4m(input->detect.buf)) {
    if (y4m_input_open(&input->y4m, input->file, input->detect.buf, 4, csp,
                       input->only_i420) >= 0) {
      input->file_type = FILE_TYPE_Y4M;
      input->width = input->y4m.pic_w;
      input->height = input->y4m.pic_h;
      input->pixel_aspect_ratio.numerator = input->y4m.par_n;
      input->pixel_aspect_ratio.denominator = input->y4m.par_d;
      input->framerate.numerator = input->y4m.fps_n;
      input->framerate.denominator = input->y4m.fps_d;
      input->fmt = input->y4m.aom_fmt;
      input->bit_depth = input->y4m.bit_depth;
    } else {
      fatal("Unsupported Y4M stream.");
    }
  } else if (input->detect.buf_read == 4 && fourcc_is_ivf(input->detect.buf)) {
    fatal("IVF is not supported as input.");
  } else {
    input->file_type = FILE_TYPE_RAW;
  }
}

// Note: these rate control metrics assume only 1 key frame in the
// sequence (i.e., first frame only). So for temporal pattern# 7
// (which has key frame for every frame on base layer), the metrics
// computation will be off/wrong.
// TODO(marpan): Update these metrics to account for multiple key frames
// in the stream.
static void set_rate_control_metrics(struct RateControlMetrics *rc,
                                     double framerate,
                                     unsigned int ss_number_layers,
                                     unsigned int ts_number_layers) {
  int ts_rate_decimator[AOM_MAX_TS_LAYERS] = { 1 };
  ts_rate_decimator[0] = 1;
  if (ts_number_layers == 2) {
    ts_rate_decimator[0] = 2;
    ts_rate_decimator[1] = 1;
  }
  if (ts_number_layers == 3) {
    ts_rate_decimator[0] = 4;
    ts_rate_decimator[1] = 2;
    ts_rate_decimator[2] = 1;
  }
  // Set the layer (cumulative) framerate and the target layer (non-cumulative)
  // per-frame-bandwidth, for the rate control encoding stats below.
  for (unsigned int sl = 0; sl < ss_number_layers; ++sl) {
    unsigned int i = sl * ts_number_layers;
    rc->layer_framerate[0] = framerate / ts_rate_decimator[0];
    rc->layer_pfb[i] =
        1000.0 * rc->layer_target_bitrate[i] / rc->layer_framerate[0];
    for (unsigned int tl = 0; tl < ts_number_layers; ++tl) {
      i = sl * ts_number_layers + tl;
      if (tl > 0) {
        rc->layer_framerate[tl] = framerate / ts_rate_decimator[tl];
        rc->layer_pfb[i] =
            1000.0 *
            (rc->layer_target_bitrate[i] - rc->layer_target_bitrate[i - 1]) /
            (rc->layer_framerate[tl] - rc->layer_framerate[tl - 1]);
      }
      rc->layer_input_frames[tl] = 0;
      rc->layer_enc_frames[tl] = 0;
      rc->layer_encoding_bitrate[i] = 0.0;
      rc->layer_avg_frame_size[i] = 0.0;
      rc->layer_avg_rate_mismatch[i] = 0.0;
    }
  }
  rc->window_count = 0;
  rc->window_size = 15;
  rc->avg_st_encoding_bitrate = 0.0;
  rc->variance_st_encoding_bitrate = 0.0;
}

static void printout_rate_control_summary(struct RateControlMetrics *rc,
                                          int frame_cnt,
                                          unsigned int ss_number_layers,
                                          unsigned int ts_number_layers) {
  int tot_num_frames = 0;
  double perc_fluctuation = 0.0;
  printf("Total number of processed frames: %d\n\n", frame_cnt - 1);
  printf("Rate control layer stats for %d layer(s):\n\n", ts_number_layers);
  for (unsigned int sl = 0; sl < ss_number_layers; ++sl) {
    tot_num_frames = 0;
    for (unsigned int tl = 0; tl < ts_number_layers; ++tl) {
      unsigned int i = sl * ts_number_layers + tl;
      const int num_dropped =
          tl > 0 ? rc->layer_input_frames[tl] - rc->layer_enc_frames[tl]
                 : rc->layer_input_frames[tl] - rc->layer_enc_frames[tl] - 1;
      tot_num_frames += rc->layer_input_frames[tl];
      rc->layer_encoding_bitrate[i] = 0.001 * rc->layer_framerate[tl] *
                                      rc->layer_encoding_bitrate[i] /
                                      tot_num_frames;
      rc->layer_avg_frame_size[i] =
          rc->layer_avg_frame_size[i] / rc->layer_enc_frames[tl];
      rc->layer_avg_rate_mismatch[i] =
          100.0 * rc->layer_avg_rate_mismatch[i] / rc->layer_enc_frames[tl];
      printf("For layer#: %d %d \n", sl, tl);
      printf("Bitrate (target vs actual): %d %f\n", rc->layer_target_bitrate[i],
             rc->layer_encoding_bitrate[i]);
      printf("Average frame size (target vs actual): %f %f\n", rc->layer_pfb[i],
             rc->layer_avg_frame_size[i]);
      printf("Average rate_mismatch: %f\n", rc->layer_avg_rate_mismatch[i]);
      printf(
          "Number of input frames, encoded (non-key) frames, "
          "and perc dropped frames: %d %d %f\n",
          rc->layer_input_frames[tl], rc->layer_enc_frames[tl],
          100.0 * num_dropped / rc->layer_input_frames[tl]);
      printf("\n");
    }
  }
  rc->avg_st_encoding_bitrate = rc->avg_st_encoding_bitrate / rc->window_count;
  rc->variance_st_encoding_bitrate =
      rc->variance_st_encoding_bitrate / rc->window_count -
      (rc->avg_st_encoding_bitrate * rc->avg_st_encoding_bitrate);
  perc_fluctuation = 100.0 * sqrt(rc->variance_st_encoding_bitrate) /
                     rc->avg_st_encoding_bitrate;
  printf("Short-time stats, for window of %d frames:\n", rc->window_size);
  printf("Average, rms-variance, and percent-fluct: %f %f %f\n",
         rc->avg_st_encoding_bitrate, sqrt(rc->variance_st_encoding_bitrate),
         perc_fluctuation);
  if (frame_cnt - 1 != tot_num_frames)
    die("Error: Number of input frames not equal to output!\n");
}

// Layer pattern configuration.
static int set_layer_pattern(int layering_mode, int superframe_cnt,
                             aom_svc_layer_id_t *layer_id,
                             aom_svc_ref_frame_config_t *ref_frame_config,
                             int *use_svc_control, int spatial_layer_id,
                             int is_key_frame, int ksvc_mode) {
  int i;
  int shift = (layering_mode == 7) ? 2 : 0;
  *use_svc_control = 1;
  layer_id->spatial_layer_id = spatial_layer_id;
  // Set the referende map buffer idx for the 7 references:
  // LAST_FRAME (0), LAST2_FRAME(1), LAST3_FRAME(2), GOLDEN_FRAME(3),
  // BWDREF_FRAME(4), ALTREF2_FRAME(5), ALTREF_FRAME(6).
  for (i = 0; i < INTER_REFS_PER_FRAME; i++) ref_frame_config->ref_idx[i] = i;
  for (i = 0; i < INTER_REFS_PER_FRAME; i++) ref_frame_config->reference[i] = 0;
  for (i = 0; i < REF_FRAMES; i++) ref_frame_config->refresh[i] = 0;
  // Note for this layered patterns only use LAST and GF for prediction in
  // non-rd mode (speed >= 7).
  int layer_flags = AOM_EFLAG_NO_REF_LAST2 | AOM_EFLAG_NO_REF_LAST3 |
                    AOM_EFLAG_NO_REF_ARF | AOM_EFLAG_NO_REF_BWD |
                    AOM_EFLAG_NO_REF_ARF2;
  if (ksvc_mode) {
    // Same pattern as case 8.
    layering_mode = 8;
    if (!is_key_frame)
      // No inter-layer prediction on inter-frames.
      layer_flags |= AOM_EFLAG_NO_REF_GF;
  }
  switch (layering_mode) {
    case 0:
      // 1-layer: update LAST on every frame, reference LAST and GF.
      layer_id->temporal_layer_id = 0;
      ref_frame_config->refresh[0] = 1;
      break;
    case 1:
      // 2-temporal layer.
      //    1    3    5
      //  0    2    4
      if (superframe_cnt % 2 == 0) {
        layer_id->temporal_layer_id = 0;
        // Update LAST on layer 0, reference LAST and GF.
        ref_frame_config->refresh[0] = 1;
      } else {
        layer_id->temporal_layer_id = 1;
        // No updates on layer 1, only reference LAST (TL0).
        layer_flags |= AOM_EFLAG_NO_REF_GF;
      }
      break;
    case 2:
      // 3-temporal layer:
      //   1    3   5    7
      //     2        6
      // 0        4        8
      if (superframe_cnt % 4 == 0) {
        // Base layer.
        layer_id->temporal_layer_id = 0;
        // Update LAST on layer 0, reference LAST and GF.
        ref_frame_config->refresh[0] = 1;
      } else if ((superframe_cnt - 1) % 4 == 0) {
        layer_id->temporal_layer_id = 2;
        // First top layer: no updates, only reference LAST (TL0).
        layer_flags |= AOM_EFLAG_NO_REF_GF;
      } else if ((superframe_cnt - 2) % 4 == 0) {
        layer_id->temporal_layer_id = 1;
        // Middle layer (TL1): update LAST2, only reference LAST (TL0).
        ref_frame_config->refresh[1] = 1;
        layer_flags |= AOM_EFLAG_NO_REF_GF;
      } else if ((superframe_cnt - 3) % 4 == 0) {
        layer_id->temporal_layer_id = 2;
        // Second top layer: no updates, only reference LAST.
        // Set buffer idx for LAST to slot 1, since that was the slot
        // updated in previous frame. So LAST is TL1 frame.
        ref_frame_config->ref_idx[0] = 1;
        ref_frame_config->ref_idx[1] = 0;
        layer_flags |= AOM_EFLAG_NO_REF_GF;
      }
      break;
    case 3:
      // 3-temporal layer: but middle layer updates GF, so 2nd TL2 will
      // only reference GF (not LAST). Other frames only reference LAST.
      //   1    3   5    7
      //     2        6
      // 0        4        8
      if (superframe_cnt % 4 == 0) {
        // Base layer.
        layer_id->temporal_layer_id = 0;
        // Update LAST on layer 0, only reference LAST.
        ref_frame_config->refresh[0] = 1;
        layer_flags |= AOM_EFLAG_NO_REF_GF;
      } else if ((superframe_cnt - 1) % 4 == 0) {
        layer_id->temporal_layer_id = 2;
        // First top layer: no updates, only reference LAST (TL0).
        layer_flags |= AOM_EFLAG_NO_REF_GF;
      } else if ((superframe_cnt - 2) % 4 == 0) {
        layer_id->temporal_layer_id = 1;
        // Middle layer (TL1): update GF, only reference LAST (TL0).
        ref_frame_config->refresh[3] = 1;
        layer_flags |= AOM_EFLAG_NO_REF_GF;
      } else if ((superframe_cnt - 3) % 4 == 0) {
        layer_id->temporal_layer_id = 2;
        // Second top layer: no updates, only reference GF.
        layer_flags |= AOM_EFLAG_NO_REF_LAST;
      }
      break;
    case 4:
      // 2-temporal layer with the old update flags, not with the new
      // SVC control.
      *use_svc_control = 0;
      //    1    3    5
      //  0    2    4
      if (superframe_cnt % 2 == 0) {
        layer_id->temporal_layer_id = 0;
        // Update LAST on layer 0, reference LAST and GF.
        layer_flags |= AOM_EFLAG_NO_UPD_GF | AOM_EFLAG_NO_UPD_ARF;
      } else {
        layer_id->temporal_layer_id = 1;
        // No updates on layer 1, only reference LAST (TL0).
        layer_flags |= AOM_EFLAG_NO_UPD_LAST | AOM_EFLAG_NO_UPD_GF |
                       AOM_EFLAG_NO_UPD_ARF | AOM_EFLAG_NO_REF_GF;
      }
      break;
    case 5:
      // 2 spatial layers, 1 temporal.
      layer_id->temporal_layer_id = 0;
      if (layer_id->spatial_layer_id == 0) {
        // Reference LAST, update LAST.
        ref_frame_config->refresh[0] = 1;
        layer_flags |= AOM_EFLAG_NO_REF_GF;
      } else if (layer_id->spatial_layer_id == 1) {
        // Reference LAST and GOLDEN. Set buffer_idx for LAST to slot 1
        // and GOLDEN to slot 0. Update slot 1 (LAST).
        ref_frame_config->ref_idx[0] = 1;
        ref_frame_config->ref_idx[3] = 0;
        ref_frame_config->refresh[1] = 1;
      }
      break;
    case 6:
      // 3 spatial layers, 1 temporal.
      // Note for this case, we set the buffer idx for all references to be
      // either LAST or GOLDEN, which are always valid references, since decoder
      // will check if any of the 7 references is valid scale in
      // valid_ref_frame_size().
      layer_id->temporal_layer_id = 0;
      if (layer_id->spatial_layer_id == 0) {
        // Reference LAST, update LAST. Set all buffer_idx to 0.
        for (i = 0; i < INTER_REFS_PER_FRAME; i++)
          ref_frame_config->ref_idx[i] = 0;
        ref_frame_config->refresh[0] = 1;
        layer_flags |= AOM_EFLAG_NO_REF_GF;
      } else if (layer_id->spatial_layer_id == 1) {
        // Reference LAST and GOLDEN. Set buffer_idx for LAST to slot 1
        // and GOLDEN (and all other refs) to slot 0.
        // Update slot 1 (LAST).
        for (i = 0; i < INTER_REFS_PER_FRAME; i++)
          ref_frame_config->ref_idx[i] = 0;
        ref_frame_config->ref_idx[0] = 1;
        ref_frame_config->refresh[1] = 1;
      } else if (layer_id->spatial_layer_id == 2) {
        // Reference LAST and GOLDEN. Set buffer_idx for LAST to slot 2
        // and GOLDEN (and all other refs) to slot 1.
        // Update slot 2 (LAST).
        for (i = 0; i < INTER_REFS_PER_FRAME; i++)
          ref_frame_config->ref_idx[i] = 1;
        ref_frame_config->ref_idx[0] = 2;
        ref_frame_config->refresh[2] = 1;
      }
      break;
    case 7:
      // 3 spatial and 3 temporal layer.
      // Same as case 8 but overalap in the buffer slot updates.
      // (shift = 2). The slots 3 and 4 updated by first TL2 are
      // reused for update in TL1 superframe.
      // Note for this case, frame order hint must be disabled for
      // lower resolutios (operating points > 0) to be decoedable.
    case 8:
      // 3 spatial and 3 temporal layer.
      // No overlap in buffer updates between TL2 and TL1.
      // TL2 updates slot 3 and 4, TL1 updates 5, 6, 7.
      // Set the references via the svc_ref_frame_config control.
      layer_flags = 0;
      // Always reference LAST.
      ref_frame_config->reference[0] = 1;
      if (superframe_cnt % 4 == 0) {
        // Base temporal layer.
        layer_id->temporal_layer_id = 0;
        if (layer_id->spatial_layer_id == 0) {
          // Reference LAST, update LAST.
          // Set all buffer_idx to 0.
          for (i = 0; i < INTER_REFS_PER_FRAME; i++)
            ref_frame_config->ref_idx[i] = 0;
          ref_frame_config->refresh[0] = 1;
        } else if (layer_id->spatial_layer_id == 1) {
          // Reference LAST and GOLDEN. Set buffer_idx for LAST to slot 1,
          // GOLDEN (and all other refs) to slot 0.
          // Update slot 1 (LAST).
          for (i = 0; i < INTER_REFS_PER_FRAME; i++)
            ref_frame_config->ref_idx[i] = 0;
          ref_frame_config->ref_idx[0] = 1;
          ref_frame_config->refresh[1] = 1;
        } else if (layer_id->spatial_layer_id == 2) {
          // Reference LAST and GOLDEN. Set buffer_idx for LAST to slot 2,
          // GOLDEN (and all other refs) to slot 1.
          // Update slot 2 (LAST).
          for (i = 0; i < INTER_REFS_PER_FRAME; i++)
            ref_frame_config->ref_idx[i] = 1;
          ref_frame_config->ref_idx[0] = 2;
          ref_frame_config->refresh[2] = 1;
        }
      } else if ((superframe_cnt - 1) % 4 == 0) {
        // First top temporal enhancement layer.
        layer_id->temporal_layer_id = 2;
        if (layer_id->spatial_layer_id == 0) {
          // Reference LAST (slot 0).
          // Set GOLDEN to slot 3 and update slot 3.
          // Set all other buffer_idx to slot 0.
          for (i = 0; i < INTER_REFS_PER_FRAME; i++)
            ref_frame_config->ref_idx[i] = 0;
          ref_frame_config->ref_idx[3] = 3;
          ref_frame_config->refresh[3] = 1;
        } else if (layer_id->spatial_layer_id == 1) {
          // Reference LAST and GOLDEN. Set buffer_idx for LAST to slot 1,
          // GOLDEN (and all other refs) to slot 3.
          // Set LAST2 to slot 4 and Update slot 4.
          for (i = 0; i < INTER_REFS_PER_FRAME; i++)
            ref_frame_config->ref_idx[i] = 3;
          ref_frame_config->ref_idx[0] = 1;
          ref_frame_config->ref_idx[1] = 4;
          ref_frame_config->refresh[4] = 1;
        } else if (layer_id->spatial_layer_id == 2) {
          // Reference LAST and GOLDEN. Set buffer_idx for LAST to slot 2,
          // GOLDEN (and all other refs) to slot 4.
          // No update.
          for (i = 0; i < INTER_REFS_PER_FRAME; i++)
            ref_frame_config->ref_idx[i] = 4;
          ref_frame_config->ref_idx[0] = 2;
        }
      } else if ((superframe_cnt - 2) % 4 == 0) {
        // Middle temporal enhancement layer.
        layer_id->temporal_layer_id = 1;
        if (layer_id->spatial_layer_id == 0) {
          // Reference LAST.
          // Set all buffer_idx to 0.
          // Set GOLDEN to slot 5 and update slot 5.
          for (i = 0; i < INTER_REFS_PER_FRAME; i++)
            ref_frame_config->ref_idx[i] = 0;
          ref_frame_config->ref_idx[3] = 5 - shift;
          ref_frame_config->refresh[5 - shift] = 1;
        } else if (layer_id->spatial_layer_id == 1) {
          // Reference LAST and GOLDEN. Set buffer_idx for LAST to slot 1,
          // GOLDEN (and all other refs) to slot 5.
          // Set LAST2 to slot 6 and update slot 6.
          for (i = 0; i < INTER_REFS_PER_FRAME; i++)
            ref_frame_config->ref_idx[i] = 5 - shift;
          ref_frame_config->ref_idx[0] = 1;
          ref_frame_config->ref_idx[2] = 6 - shift;
          ref_frame_config->refresh[6 - shift] = 1;
        } else if (layer_id->spatial_layer_id == 2) {
          // Reference LAST and GOLDEN. Set buffer_idx for LAST to slot 2,
          // GOLDEN (and all other refs) to slot 6.
          // Set LAST2 to slot 6 and update slot 7.
          for (i = 0; i < INTER_REFS_PER_FRAME; i++)
            ref_frame_config->ref_idx[i] = 6 - shift;
          ref_frame_config->ref_idx[0] = 2;
          ref_frame_config->ref_idx[2] = 7 - shift;
          ref_frame_config->refresh[7 - shift] = 1;
        }
      } else if ((superframe_cnt - 3) % 4 == 0) {
        // Second top temporal enhancement layer.
        layer_id->temporal_layer_id = 2;
        if (layer_id->spatial_layer_id == 0) {
          // Set LAST to slot 5 and reference LAST.
          // Set GOLDEN to slot 3 and update slot 3.
          // Set all other buffer_idx to 0.
          for (i = 0; i < INTER_REFS_PER_FRAME; i++)
            ref_frame_config->ref_idx[i] = 0;
          ref_frame_config->ref_idx[0] = 5 - shift;
          ref_frame_config->ref_idx[3] = 3;
          ref_frame_config->refresh[3] = 1;
        } else if (layer_id->spatial_layer_id == 1) {
          // Reference LAST and GOLDEN. Set buffer_idx for LAST to slot 6,
          // GOLDEN to slot 3. Set LAST2 to slot 4 and update slot 4.
          for (i = 0; i < INTER_REFS_PER_FRAME; i++)
            ref_frame_config->ref_idx[i] = 0;
          ref_frame_config->ref_idx[0] = 6 - shift;
          ref_frame_config->ref_idx[3] = 3;
          ref_frame_config->ref_idx[1] = 4;
          ref_frame_config->refresh[4] = 1;
        } else if (layer_id->spatial_layer_id == 2) {
          // Reference LAST and GOLDEN. Set buffer_idx for LAST to slot 7,
          // GOLDEN to slot 4. No update.
          for (i = 0; i < INTER_REFS_PER_FRAME; i++)
            ref_frame_config->ref_idx[i] = 0;
          ref_frame_config->ref_idx[0] = 7 - shift;
          ref_frame_config->ref_idx[3] = 4;
        }
      }
      if (layer_id->spatial_layer_id > 0)
        ref_frame_config->reference[3] = 1;  // Reference GOLDEN.
      break;
    default: assert(0); die("Error: Unsupported temporal layering mode!\n");
  }
  return layer_flags;
}

int main(int argc, char **argv) {
  AvxVideoWriter *outfile[AOM_MAX_LAYERS] = { NULL };
  aom_codec_ctx_t codec;
  aom_codec_enc_cfg_t cfg;
  int frame_cnt = 0;
  aom_image_t raw;
  aom_codec_err_t res;
  unsigned int width;
  unsigned int height;
  uint32_t error_resilient = 0;
  int speed;
  int frame_avail;
  int got_data = 0;
  int flags = 0;
  unsigned i;
  int pts = 0;             // PTS starts at 0.
  int frame_duration = 1;  // 1 timebase tick per frame.
  int layering_mode = 0;
  aom_svc_layer_id_t layer_id;
  aom_svc_params_t svc_params;
  aom_svc_ref_frame_config_t ref_frame_config;
  const AvxInterface *encoder = NULL;
  struct AvxInputContext input_ctx;
  struct RateControlMetrics rc;
  int64_t cx_time = 0;
  const int min_args_base = 13;
  const int min_args = min_args_base;
  double sum_bitrate = 0.0;
  double sum_bitrate2 = 0.0;
  double framerate = 30.0;
  int use_svc_control = 1;
  zero(rc.layer_target_bitrate);
  memset(&layer_id, 0, sizeof(aom_svc_layer_id_t));
  memset(&input_ctx, 0, sizeof(input_ctx));
  memset(&svc_params, 0, sizeof(svc_params));

  // Flag to test dynamic scaling of source frames for single
  // spatial stream, using the scaling_mode control.
  const int test_dynamic_scaling_single_layer = 0;

  /* Setup default input stream settings */
  input_ctx.framerate.numerator = 30;
  input_ctx.framerate.denominator = 1;
  input_ctx.only_i420 = 1;
  input_ctx.bit_depth = 0;
  unsigned int ts_number_layers = 1;
  unsigned int ss_number_layers = 1;
  exec_name = argv[0];
  // Check usage and arguments.
  if (argc < min_args) {
    die("Usage: %s <infile> <outfile> <codec_type(av1)> <width> <height> "
        "<rate_num> <rate_den> <speed> <frame_drop_threshold> "
        "<error_resilient> <threads> <mode> "
        "<Rate_0> ... <Rate_nlayers-1>\n",
        argv[0]);
  }

  encoder = get_aom_encoder_by_name(argv[3]);

  width = (unsigned int)strtoul(argv[4], NULL, 0);
  height = (unsigned int)strtoul(argv[5], NULL, 0);
  if (width < 16 || width % 2 || height < 16 || height % 2) {
    die("Invalid resolution: %d x %d", width, height);
  }

  layering_mode = (int)strtol(argv[12], NULL, 0);
  if (layering_mode < 0 || layering_mode > 13) {
    die("Invalid layering mode (0..12) %s", argv[12]);
  }

  if (argc != min_args + mode_to_num_layers[layering_mode]) {
    die("Invalid number of arguments");
  }

  ts_number_layers = mode_to_num_temporal_layers[layering_mode];
  ss_number_layers = mode_to_num_spatial_layers[layering_mode];

  input_ctx.filename = argv[1];
  open_input_file(&input_ctx, 0);

  // Y4M reader has its own allocation.
  if (input_ctx.file_type != FILE_TYPE_Y4M) {
    if (!aom_img_alloc(&raw, AOM_IMG_FMT_I420, width, height, 32)) {
      die("Failed to allocate image", width, height);
    }
  }

  // Populate encoder configuration.
  res = aom_codec_enc_config_default(encoder->codec_interface(), &cfg, 0);
  if (res) {
    printf("Failed to get config: %s\n", aom_codec_err_to_string(res));
    return EXIT_FAILURE;
  }

  // Update the default configuration with our settings.
  cfg.g_w = width;
  cfg.g_h = height;

  // Timebase format e.g. 30fps: numerator=1, demoninator = 30.
  cfg.g_timebase.num = (int)strtol(argv[6], NULL, 0);
  cfg.g_timebase.den = (int)strtol(argv[7], NULL, 0);

  speed = (int)strtol(argv[8], NULL, 0);
  if (speed < 0 || speed > 8) {
    die("Invalid speed setting: must be positive");
  }

  for (i = min_args_base;
       (int)i < min_args_base + mode_to_num_layers[layering_mode]; ++i) {
    rc.layer_target_bitrate[i - 13] = (int)strtol(argv[i], NULL, 0);
    svc_params.layer_target_bitrate[i - 13] = rc.layer_target_bitrate[i - 13];
  }

  cfg.rc_target_bitrate =
      svc_params.layer_target_bitrate[ss_number_layers * ts_number_layers - 1];

  svc_params.framerate_factor[0] = 1;
  if (ts_number_layers == 2) {
    svc_params.framerate_factor[0] = 2;
    svc_params.framerate_factor[1] = 1;
  } else if (ts_number_layers == 3) {
    svc_params.framerate_factor[0] = 4;
    svc_params.framerate_factor[1] = 2;
    svc_params.framerate_factor[2] = 1;
  }

  // Real time parameters.
  cfg.g_usage = AOM_USAGE_REALTIME;

  cfg.rc_dropframe_thresh = (unsigned int)strtoul(argv[9], NULL, 0);
  cfg.rc_end_usage = AOM_CBR;
  cfg.rc_min_quantizer = 2;
  cfg.rc_max_quantizer = 52;
  cfg.rc_undershoot_pct = 50;
  cfg.rc_overshoot_pct = 50;
  cfg.rc_buf_initial_sz = 600;
  cfg.rc_buf_optimal_sz = 600;
  cfg.rc_buf_sz = 1000;

  // Use 1 thread as default.
  cfg.g_threads = (unsigned int)strtoul(argv[11], NULL, 0);

  error_resilient = (uint32_t)strtoul(argv[10], NULL, 0);
  if (error_resilient != 0 && error_resilient != 1) {
    die("Invalid value for error resilient (0, 1): %d.", error_resilient);
  }
  // Enable error resilient mode.
  cfg.g_error_resilient = error_resilient;
  cfg.g_lag_in_frames = 0;
  cfg.kf_mode = AOM_KF_AUTO;

  // Disable automatic keyframe placement.
  cfg.kf_min_dist = cfg.kf_max_dist = 3000;

  framerate = cfg.g_timebase.den / cfg.g_timebase.num;
  set_rate_control_metrics(&rc, framerate, ss_number_layers, ts_number_layers);

  if (input_ctx.file_type == FILE_TYPE_Y4M) {
    if (input_ctx.width != cfg.g_w || input_ctx.height != cfg.g_h) {
      die("Incorrect width or height: %d x %d", cfg.g_w, cfg.g_h);
    }
    if (input_ctx.framerate.numerator != cfg.g_timebase.den ||
        input_ctx.framerate.denominator != cfg.g_timebase.num) {
      die("Incorrect framerate: numerator %d denominator %d",
          cfg.g_timebase.num, cfg.g_timebase.den);
    }
  }

  // Open an output file for each stream.
  for (unsigned int sl = 0; sl < ss_number_layers; ++sl) {
    for (unsigned tl = 0; tl < ts_number_layers; ++tl) {
      i = sl * ts_number_layers + tl;
      char file_name[PATH_MAX];
      AvxVideoInfo info;
      info.codec_fourcc = encoder->fourcc;
      info.frame_width = cfg.g_w;
      info.frame_height = cfg.g_h;
      info.time_base.numerator = cfg.g_timebase.num;
      info.time_base.denominator = cfg.g_timebase.den;

      snprintf(file_name, sizeof(file_name), "%s_%d.av1", argv[2], i);
      outfile[i] = aom_video_writer_open(file_name, kContainerIVF, &info);
      if (!outfile[i]) die("Failed to open %s for writing", file_name);
      assert(outfile[i] != NULL);
    }
  }

  // Initialize codec.
  if (aom_codec_enc_init(&codec, encoder->codec_interface(), &cfg, 0))
    die_codec(&codec, "Failed to initialize encoder");

  aom_codec_control(&codec, AOME_SET_CPUUSED, speed);
  aom_codec_control(&codec, AV1E_SET_AQ_MODE, 3);
  aom_codec_control(&codec, AV1E_SET_GF_CBR_BOOST_PCT, 0);
  aom_codec_control(&codec, AV1E_SET_ENABLE_CDEF, 1);
  aom_codec_control(&codec, AV1E_SET_ENABLE_ORDER_HINT, 0);
  aom_codec_control(&codec, AV1E_SET_ENABLE_TPL_MODEL, 0);
  aom_codec_control(&codec, AV1E_SET_DELTAQ_MODE, 0);

  svc_params.number_spatial_layers = ss_number_layers;
  svc_params.number_temporal_layers = ts_number_layers;
  for (i = 0; i < ss_number_layers * ts_number_layers; ++i) {
    svc_params.max_quantizers[i] = cfg.rc_max_quantizer;
    svc_params.min_quantizers[i] = cfg.rc_min_quantizer;
  }
  for (i = 0; i < ss_number_layers; ++i) {
    svc_params.scaling_factor_num[i] = 1;
    svc_params.scaling_factor_den[i] = 1;
  }
  if (ss_number_layers == 2) {
    svc_params.scaling_factor_num[0] = 1;
    svc_params.scaling_factor_den[0] = 2;
  } else if (ss_number_layers == 3) {
    svc_params.scaling_factor_num[0] = 1;
    svc_params.scaling_factor_den[0] = 4;
    svc_params.scaling_factor_num[1] = 1;
    svc_params.scaling_factor_den[1] = 2;
  }

  aom_codec_control(&codec, AV1E_SET_SVC_PARAMS, &svc_params);

  // This controls the maximum target size of the key frame.
  // For generating smaller key frames, use a smaller max_intra_size_pct
  // value, like 100 or 200.
  {
    const int max_intra_size_pct = 300;
    aom_codec_control(&codec, AOME_SET_MAX_INTRA_BITRATE_PCT,
                      max_intra_size_pct);
  }

  frame_avail = 1;
  while (frame_avail || got_data) {
    struct aom_usec_timer timer;
    frame_avail = read_frame(&input_ctx, &raw);
    int is_key_frame = (frame_cnt % cfg.kf_max_dist) == 0;
    // Loop over spatial layers.
    for (unsigned int slx = 0; slx < ss_number_layers; slx++) {
      aom_codec_iter_t iter = NULL;
      const aom_codec_cx_pkt_t *pkt;
      int layer = 0;

      // Set the reference/update flags, layer_id, and reference_map
      // buffer index.
      flags = set_layer_pattern(layering_mode, frame_cnt, &layer_id,
                                &ref_frame_config, &use_svc_control, slx,
                                is_key_frame, (layering_mode == 9));
      aom_codec_control(&codec, AV1E_SET_SVC_LAYER_ID, &layer_id);
      if (use_svc_control)
        aom_codec_control(&codec, AV1E_SET_SVC_REF_FRAME_CONFIG,
                          &ref_frame_config);

      layer = slx * ts_number_layers + layer_id.temporal_layer_id;
      if (frame_avail && slx == 0) ++rc.layer_input_frames[layer];

      if (test_dynamic_scaling_single_layer) {
        if (frame_cnt >= 200 && frame_cnt <= 400) {
          // Scale source down by 2x2.
          struct aom_scaling_mode mode = { AOME_ONETWO, AOME_ONETWO };
          aom_codec_control(&codec, AOME_SET_SCALEMODE, &mode);
        } else {
          // Source back up to original resolution (no scaling).
          struct aom_scaling_mode mode = { AOME_NORMAL, AOME_NORMAL };
          aom_codec_control(&codec, AOME_SET_SCALEMODE, &mode);
        }
      }

      // Do the layer encode.
      aom_usec_timer_start(&timer);
      if (aom_codec_encode(&codec, frame_avail ? &raw : NULL, pts, 1, flags))
        die_codec(&codec, "Failed to encode frame");
      aom_usec_timer_mark(&timer);
      cx_time += aom_usec_timer_elapsed(&timer);

      got_data = 0;
      while ((pkt = aom_codec_get_cx_data(&codec, &iter))) {
        got_data = 1;
        switch (pkt->kind) {
          case AOM_CODEC_CX_FRAME_PKT:
            for (unsigned int sl = layer_id.spatial_layer_id;
                 sl < ss_number_layers; ++sl) {
              for (unsigned tl = layer_id.temporal_layer_id;
                   tl < ts_number_layers; ++tl) {
                unsigned int j = sl * ts_number_layers + tl;
                aom_video_writer_write_frame(outfile[j], pkt->data.frame.buf,
                                             pkt->data.frame.sz, pts);
                if (sl == (unsigned int)layer_id.spatial_layer_id)
                  rc.layer_encoding_bitrate[j] += 8.0 * pkt->data.frame.sz;
                // Keep count of rate control stats per layer (for non-key).
                if (tl == (unsigned int)layer_id.temporal_layer_id &&
                    sl == (unsigned int)layer_id.spatial_layer_id &&
                    !(pkt->data.frame.flags & AOM_FRAME_IS_KEY)) {
                  rc.layer_avg_frame_size[j] += 8.0 * pkt->data.frame.sz;
                  rc.layer_avg_rate_mismatch[j] +=
                      fabs(8.0 * pkt->data.frame.sz - rc.layer_pfb[j]) /
                      rc.layer_pfb[j];
                  if (slx == 0) ++rc.layer_enc_frames[tl];
                }
              }
            }

            // Update for short-time encoding bitrate states, for moving window
            // of size rc->window, shifted by rc->window / 2.
            // Ignore first window segment, due to key frame.
            // For spatial layers: only do this for top/highest SL.
            if (frame_cnt > rc.window_size && slx == ss_number_layers - 1) {
              sum_bitrate += 0.001 * 8.0 * pkt->data.frame.sz * framerate;
              rc.window_size = (rc.window_size <= 0) ? 1 : rc.window_size;
              if (frame_cnt % rc.window_size == 0) {
                rc.window_count += 1;
                rc.avg_st_encoding_bitrate += sum_bitrate / rc.window_size;
                rc.variance_st_encoding_bitrate +=
                    (sum_bitrate / rc.window_size) *
                    (sum_bitrate / rc.window_size);
                sum_bitrate = 0.0;
              }
            }
            // Second shifted window.
            if (frame_cnt > rc.window_size + rc.window_size / 2 &&
                slx == ss_number_layers - 1) {
              sum_bitrate2 += 0.001 * 8.0 * pkt->data.frame.sz * framerate;
              if (frame_cnt > 2 * rc.window_size &&
                  frame_cnt % rc.window_size == 0) {
                rc.window_count += 1;
                rc.avg_st_encoding_bitrate += sum_bitrate2 / rc.window_size;
                rc.variance_st_encoding_bitrate +=
                    (sum_bitrate2 / rc.window_size) *
                    (sum_bitrate2 / rc.window_size);
                sum_bitrate2 = 0.0;
              }
            }
            break;
          default: break;
        }
      }
    }  // loop over spatial layers
    ++frame_cnt;
    pts += frame_duration;
  }
  close_input_file(&input_ctx);
  printout_rate_control_summary(&rc, frame_cnt, ss_number_layers,
                                ts_number_layers);
  printf("\n");
  printf("Frame cnt and encoding time/FPS stats for encoding: %d %f %f\n",
         frame_cnt, 1000 * (float)cx_time / (double)(frame_cnt * 1000000),
         1000000 * (double)frame_cnt / (double)cx_time);

  if (aom_codec_destroy(&codec)) die_codec(&codec, "Failed to destroy codec");

  // Try to rewrite the output file headers with the actual frame count.
  for (i = 0; i < ss_number_layers * ts_number_layers; ++i)
    aom_video_writer_close(outfile[i]);

  if (input_ctx.file_type != FILE_TYPE_Y4M) {
    aom_img_free(&raw);
  }
  return EXIT_SUCCESS;
}
