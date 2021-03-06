/*
 *  Copyright (c) 2019, Alliance for Open Media. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#ifndef AOM_AV1_ENCODER_SVC_LAYERCONTEXT_H_
#define AOM_AV1_ENCODER_SVC_LAYERCONTEXT_H_

#include "av1/encoder/aq_cyclicrefresh.h"
#include "av1/encoder/encoder.h"
#include "av1/encoder/ratectrl.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef struct {
  RATE_CONTROL rc;
  int framerate_factor;
  int64_t layer_target_bitrate;
  int scaling_factor_num;
  int scaling_factor_den;
  int64_t target_bandwidth;
  int64_t spatial_layer_target_bandwidth;
  double framerate;
  int avg_frame_size;
  int max_q;
  int min_q;
  int frames_from_key_frame;
  // Cyclic refresh parameters (aq-mode=3), that need to be updated per-frame.
  int sb_index;
  int8_t *map;
  uint8_t *last_coded_q_map;
  int actual_num_seg1_blocks;
  int actual_num_seg2_blocks;
  int counter_encode_maxq_scene_change;
  uint8_t speed;
  unsigned char group_index;
} LAYER_CONTEXT;

typedef struct SVC {
  int spatial_layer_id;
  int temporal_layer_id;
  int number_spatial_layers;
  int number_temporal_layers;
  int external_ref_frame_config;
  int non_reference_frame;
  // LAST_FRAME (0), LAST2_FRAME(1), LAST3_FRAME(2), GOLDEN_FRAME(3),
  // BWDREF_FRAME(4), ALTREF2_FRAME(5), ALTREF_FRAME(6).
  int reference[INTER_REFS_PER_FRAME];
  int ref_idx[INTER_REFS_PER_FRAME];
  int refresh[REF_FRAMES];
  double base_framerate;
  unsigned int current_superframe;
  unsigned int buffer_time_index[REF_FRAMES];
  unsigned char buffer_spatial_layer[REF_FRAMES];
  int skip_nonzeromv_last;
  int skip_nonzeromv_gf;
  // Layer context used for rate control in one pass temporal CBR mode or
  // two pass spatial mode.
  LAYER_CONTEXT layer_context[AOM_MAX_LAYERS];
} SVC;

struct AV1_COMP;

// Initialize layer context data from init_config().
void av1_init_layer_context(struct AV1_COMP *const cpi);

// Update the layer context from a change_config() call.
void av1_update_layer_context_change_config(struct AV1_COMP *const cpi,
                                            const int64_t target_bandwidth);

// Prior to encoding the frame, update framerate-related quantities
// for the current temporal layer.
void av1_update_temporal_layer_framerate(struct AV1_COMP *const cpi);

// Prior to encoding the frame, set the layer context, for the current layer
// to be encoded, to the cpi struct.
void av1_restore_layer_context(struct AV1_COMP *const cpi);

// Save the layer context after encoding the frame.
void av1_save_layer_context(struct AV1_COMP *const cpi);

void av1_free_svc_cyclic_refresh(struct AV1_COMP *const cpi);

void av1_svc_reset_temporal_layers(struct AV1_COMP *const cpi, int is_key);

void av1_one_pass_cbr_svc_start_layer(struct AV1_COMP *const cpi);

#ifdef __cplusplus
}  // extern "C"
#endif

#endif  // AOM_AV1_ENCODER_SVC_LAYERCONTEXT_H_
