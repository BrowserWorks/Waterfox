/*
 * Copyright (c) 2019, Alliance for Open Media. All rights reserved
 *
 * This source code is subject to the terms of the BSD 2 Clause License and
 * the Alliance for Open Media Patent License 1.0. If the BSD 2 Clause License
 * was not distributed with this source code in the LICENSE file, you can
 * obtain it at www.aomedia.org/license/software. If the Alliance for Open
 * Media Patent License 1.0 was not distributed with this source code in the
 * PATENTS file, you can obtain it at www.aomedia.org/license/patent.
 */

#include <stdint.h>

#include "config/aom_config.h"
#include "config/aom_scale_rtcd.h"

#include "aom/aom_codec.h"
#include "aom/aom_encoder.h"

#include "aom_ports/system_state.h"

#include "av1/common/av1_common_int.h"

#include "av1/encoder/encoder.h"
#include "av1/encoder/firstpass.h"
#include "av1/encoder/gop_structure.h"

// Set parameters for frames between 'start' and 'end' (excluding both).
static void set_multi_layer_params(const TWO_PASS *twopass,
                                   GF_GROUP *const gf_group, RATE_CONTROL *rc,
                                   FRAME_INFO *frame_info, int start, int end,
                                   int *cur_frame_idx, int *frame_ind,
                                   int arf_ind, int layer_depth) {
  const int num_frames_to_process = end - start - 1;
  assert(num_frames_to_process >= 0);
  if (num_frames_to_process == 0) return;

  // Either we are at the last level of the pyramid, or we don't have enough
  // frames between 'l' and 'r' to create one more level.
  if (layer_depth > gf_group->max_layer_depth_allowed ||
      num_frames_to_process < 3) {
    // Leaf nodes.
    while (++start < end) {
      gf_group->update_type[*frame_ind] = LF_UPDATE;
      gf_group->arf_src_offset[*frame_ind] = 0;
      ++*cur_frame_idx;
      gf_group->cur_frame_idx[*frame_ind] = *cur_frame_idx;
      gf_group->frame_disp_idx[*frame_ind] = start;
      gf_group->layer_depth[*frame_ind] = MAX_ARF_LAYERS;
      gf_group->arf_boost[*frame_ind] = av1_calc_arf_boost(
          twopass, rc, frame_info, start, end - start, 0, NULL, NULL);
      gf_group->max_layer_depth =
          AOMMAX(gf_group->max_layer_depth, layer_depth);
      ++(*frame_ind);
    }
  } else {
    const int m = (start + end) / 2;

    // Internal ARF.
    gf_group->update_type[*frame_ind] = INTNL_ARF_UPDATE;
    gf_group->arf_src_offset[*frame_ind] = m - start - 1;
    gf_group->cur_frame_idx[*frame_ind] = *cur_frame_idx;
    gf_group->frame_disp_idx[*frame_ind] = m;
    gf_group->layer_depth[*frame_ind] = layer_depth;

    // Get the boost factor for intermediate ARF frames.
    gf_group->arf_boost[*frame_ind] = av1_calc_arf_boost(
        twopass, rc, frame_info, m, end - m, m - start, NULL, NULL);
    ++(*frame_ind);

    // Frames displayed before this internal ARF.
    set_multi_layer_params(twopass, gf_group, rc, frame_info, start, m,
                           cur_frame_idx, frame_ind, 1, layer_depth + 1);

    // Overlay for internal ARF.
    gf_group->update_type[*frame_ind] = INTNL_OVERLAY_UPDATE;
    gf_group->arf_src_offset[*frame_ind] = 0;
    gf_group->cur_frame_idx[*frame_ind] = *cur_frame_idx;
    gf_group->frame_disp_idx[*frame_ind] = m;
    gf_group->arf_boost[*frame_ind] = 0;
    gf_group->layer_depth[*frame_ind] = layer_depth;
    ++(*frame_ind);

    // Frames displayed after this internal ARF.
    set_multi_layer_params(twopass, gf_group, rc, frame_info, m, end,
                           cur_frame_idx, frame_ind, arf_ind, layer_depth + 1);
  }
}

static int construct_multi_layer_gf_structure(
    AV1_COMP *cpi, TWO_PASS *twopass, GF_GROUP *const gf_group,
    RATE_CONTROL *rc, FRAME_INFO *const frame_info, int gf_interval,
    FRAME_UPDATE_TYPE first_frame_update_type) {
  int frame_index = 0;

  // Keyframe / Overlay frame / Golden frame.
  assert(gf_interval >= 1);
  assert(first_frame_update_type == KF_UPDATE ||
         first_frame_update_type == OVERLAY_UPDATE ||
         first_frame_update_type == GF_UPDATE);

  gf_group->update_type[frame_index] = first_frame_update_type;
  gf_group->arf_src_offset[frame_index] = 0;
  gf_group->cur_frame_idx[frame_index] = 0;
  gf_group->layer_depth[frame_index] =
      first_frame_update_type == OVERLAY_UPDATE ? MAX_ARF_LAYERS + 1 : 0;
  gf_group->max_layer_depth = 0;
  ++frame_index;

  // ALTREF.
  const int use_altref = gf_group->max_layer_depth_allowed > 0;
  if (use_altref) {
    gf_group->update_type[frame_index] = ARF_UPDATE;
    gf_group->arf_src_offset[frame_index] = gf_interval - 1;
    gf_group->cur_frame_idx[frame_index] = 0;
    gf_group->frame_disp_idx[frame_index] = gf_interval;
    gf_group->layer_depth[frame_index] = 1;
    gf_group->arf_boost[frame_index] = cpi->rc.gfu_boost;
    gf_group->max_layer_depth = 1;
    ++frame_index;
  }

  int cur_frame_index = 0;
  // Rest of the frames.
  set_multi_layer_params(twopass, gf_group, rc, frame_info, 0, gf_interval,
                         &cur_frame_index, &frame_index, 0, use_altref + 1);

  // The end frame will be Overlay frame for an ARF GOP; otherwise set it to
  // be GF, for consistency, which will be updated in the next GOP.
  gf_group->update_type[frame_index] = use_altref ? OVERLAY_UPDATE : GF_UPDATE;
  gf_group->arf_src_offset[frame_index] = 0;
  return frame_index;
}

#define CHECK_GF_PARAMETER 0
#if CHECK_GF_PARAMETER
void check_frame_params(GF_GROUP *const gf_group, int gf_interval) {
  static const char *update_type_strings[FRAME_UPDATE_TYPES] = {
    "KF_UPDATE",       "LF_UPDATE",      "GF_UPDATE",
    "ARF_UPDATE",      "OVERLAY_UPDATE", "INTNL_OVERLAY_UPDATE",
    "INTNL_ARF_UPDATE"
  };
  FILE *fid = fopen("GF_PARAMS.txt", "a");

  fprintf(fid, "\ngf_interval = {%d}\n", gf_interval);
  for (int i = 0; i < gf_group->size; ++i) {
    fprintf(fid, "#%2d : %s %d %d %d %d\n", i,
            update_type_strings[gf_group->update_type[i]],
            gf_group->arf_src_offset[i], gf_group->arf_pos_in_gf[i],
            gf_group->arf_update_idx[i], gf_group->pyramid_level[i]);
  }

  fprintf(fid, "number of nodes in each level: \n");
  for (int i = 0; i < gf_group->pyramid_height; ++i) {
    fprintf(fid, "lvl %d: %d ", i, gf_group->pyramid_lvl_nodes[i]);
  }
  fprintf(fid, "\n");
  fclose(fid);
}
#endif  // CHECK_GF_PARAMETER

#define REF_IDX(ref) ((ref)-LAST_FRAME)

static INLINE void reset_ref_frame_idx(int *ref_idx, int reset_value) {
  for (int i = 0; i < REF_FRAMES; ++i) ref_idx[i] = reset_value;
}

static INLINE void set_ref_frame_disp_idx(GF_GROUP *const gf_group) {
  for (int i = 0; i < gf_group->size; ++i) {
    for (int ref = 0; ref < INTER_REFS_PER_FRAME + 1; ++ref) {
      int ref_gop_idx = gf_group->ref_frame_gop_idx[i][ref];
      if (ref_gop_idx == -1) {
        gf_group->ref_frame_disp_idx[i][ref] = -1;
      } else {
        gf_group->ref_frame_disp_idx[i][ref] =
            gf_group->frame_disp_idx[ref_gop_idx];
      }
    }
  }
}

static void set_gop_ref_frame_map(GF_GROUP *const gf_group) {
  // Initialize the reference slots as all -1.
  for (int frame_idx = 0; frame_idx < gf_group->size; ++frame_idx)
    reset_ref_frame_idx(gf_group->ref_frame_gop_idx[frame_idx], -1);

  // Set the map for frames in the current gop
  for (int frame_idx = 0; frame_idx < gf_group->size; ++frame_idx) {
    const FRAME_UPDATE_TYPE update_type = gf_group->update_type[frame_idx];
    // TODO(yuec): need to figure out how to determine
    // (1) whether a KEY_FRAME has show_frame on
    // (2) whether a frame with INTNL_OVERLAY_UPDATE type has
    //     show_existing_frame on
    const int show_frame =
        update_type != ARF_UPDATE && update_type != INTNL_ARF_UPDATE;
    const int show_existing_frame =
        update_type == OVERLAY_UPDATE || update_type == INTNL_OVERLAY_UPDATE;

    int this_ref_map[INTER_REFS_PER_FRAME + 1];
    memcpy(this_ref_map, gf_group->ref_frame_gop_idx[frame_idx],
           sizeof(this_ref_map));
    int *next_ref_map = &gf_group->ref_frame_gop_idx[frame_idx + 1][0];

    switch (update_type) {
      case KF_UPDATE:
        if (show_frame) {
          reset_ref_frame_idx(this_ref_map, frame_idx);
        } else {
          this_ref_map[REF_IDX(LAST3_FRAME)] = frame_idx;
          this_ref_map[REF_IDX(EXTREF_FRAME)] = frame_idx;
          this_ref_map[REF_IDX(ALTREF2_FRAME)] = frame_idx;
          this_ref_map[REF_IDX(GOLDEN_FRAME)] = frame_idx;
          this_ref_map[REF_IDX(ALTREF_FRAME)] = frame_idx;
        }
        break;
      case LF_UPDATE: this_ref_map[REF_IDX(LAST3_FRAME)] = frame_idx; break;
      case GF_UPDATE:
        this_ref_map[REF_IDX(LAST3_FRAME)] = frame_idx;
        this_ref_map[REF_IDX(GOLDEN_FRAME)] = frame_idx;
        break;
      case OVERLAY_UPDATE:
        this_ref_map[REF_IDX(ALTREF_FRAME)] = frame_idx;
        break;
      case ARF_UPDATE: this_ref_map[REF_IDX(ALTREF_FRAME)] = frame_idx; break;
      case INTNL_OVERLAY_UPDATE:
        if (!show_existing_frame)
          this_ref_map[REF_IDX(LAST3_FRAME)] = frame_idx;
        break;
      case INTNL_ARF_UPDATE:
        this_ref_map[REF_IDX(EXTREF_FRAME)] = frame_idx;
        break;
      default: assert(0); break;
    }

    memcpy(next_ref_map, this_ref_map, sizeof(this_ref_map));

    switch (update_type) {
      case LF_UPDATE:
      case GF_UPDATE:
        next_ref_map[REF_IDX(LAST3_FRAME)] = this_ref_map[REF_IDX(LAST2_FRAME)];
        next_ref_map[REF_IDX(LAST2_FRAME)] = this_ref_map[REF_IDX(LAST_FRAME)];
        next_ref_map[REF_IDX(LAST_FRAME)] = this_ref_map[REF_IDX(LAST3_FRAME)];
        break;
      case INTNL_OVERLAY_UPDATE:
        if (!show_existing_frame) {
          next_ref_map[REF_IDX(LAST3_FRAME)] =
              this_ref_map[REF_IDX(LAST2_FRAME)];
          next_ref_map[REF_IDX(LAST2_FRAME)] =
              this_ref_map[REF_IDX(LAST_FRAME)];
          next_ref_map[REF_IDX(LAST_FRAME)] =
              this_ref_map[REF_IDX(LAST3_FRAME)];
        } else {
          next_ref_map[REF_IDX(LAST_FRAME)] =
              this_ref_map[REF_IDX(BWDREF_FRAME)];
          next_ref_map[REF_IDX(LAST2_FRAME)] =
              this_ref_map[REF_IDX(LAST_FRAME)];
          next_ref_map[REF_IDX(LAST3_FRAME)] =
              this_ref_map[REF_IDX(LAST2_FRAME)];
          next_ref_map[REF_IDX(BWDREF_FRAME)] =
              this_ref_map[REF_IDX(ALTREF2_FRAME)];
          next_ref_map[REF_IDX(ALTREF2_FRAME)] =
              this_ref_map[REF_IDX(EXTREF_FRAME)];
          next_ref_map[REF_IDX(EXTREF_FRAME)] =
              this_ref_map[REF_IDX(LAST3_FRAME)];
        }
        break;
      case INTNL_ARF_UPDATE:
        if (!show_existing_frame) {
          next_ref_map[REF_IDX(BWDREF_FRAME)] =
              this_ref_map[REF_IDX(EXTREF_FRAME)];
          next_ref_map[REF_IDX(ALTREF2_FRAME)] =
              this_ref_map[REF_IDX(BWDREF_FRAME)];
          next_ref_map[REF_IDX(EXTREF_FRAME)] =
              this_ref_map[REF_IDX(ALTREF2_FRAME)];
        }
        break;
      case OVERLAY_UPDATE:
        next_ref_map[REF_IDX(ALTREF_FRAME)] =
            this_ref_map[REF_IDX(GOLDEN_FRAME)];
        next_ref_map[REF_IDX(GOLDEN_FRAME)] =
            this_ref_map[REF_IDX(ALTREF_FRAME)];
        break;
      default: break;
    }
  }

  // Set the map in display order index by converting from gop indices in the
  // above map
  set_ref_frame_disp_idx(gf_group);
}

void av1_gop_setup_structure(AV1_COMP *cpi,
                             const EncodeFrameParams *const frame_params) {
  RATE_CONTROL *const rc = &cpi->rc;
  GF_GROUP *const gf_group = &cpi->gf_group;
  TWO_PASS *const twopass = &cpi->twopass;
  FRAME_INFO *const frame_info = &cpi->frame_info;
  const int key_frame = (frame_params->frame_type == KEY_FRAME);
  const FRAME_UPDATE_TYPE first_frame_update_type =
      key_frame ? KF_UPDATE
                : rc->source_alt_ref_active ? OVERLAY_UPDATE : GF_UPDATE;
  gf_group->size = construct_multi_layer_gf_structure(
      cpi, twopass, gf_group, rc, frame_info, rc->baseline_gf_interval,
      first_frame_update_type);

  set_gop_ref_frame_map(gf_group);

#if CHECK_GF_PARAMETER
  check_frame_params(gf_group, rc->baseline_gf_interval);
#endif
}
