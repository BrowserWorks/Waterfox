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

#if CONFIG_MISMATCH_DEBUG
#include "aom_util/debug_util.h"
#endif  // CONFIG_MISMATCH_DEBUG

#include "av1/common/av1_common_int.h"
#include "av1/common/reconinter.h"

#include "av1/encoder/encoder.h"
#include "av1/encoder/encode_strategy.h"
#include "av1/encoder/encodeframe.h"
#include "av1/encoder/firstpass.h"
#include "av1/encoder/pass2_strategy.h"
#include "av1/encoder/temporal_filter.h"
#include "av1/encoder/tpl_model.h"

#define TEMPORAL_FILTER_KEY_FRAME (CONFIG_REALTIME_ONLY ? 0 : 1)

void av1_configure_buffer_updates(AV1_COMP *const cpi,
                                  EncodeFrameParams *const frame_params,
                                  const FRAME_UPDATE_TYPE type,
                                  int force_refresh_all) {
  // NOTE(weitinglin): Should we define another function to take care of
  // cpi->rc.is_$Source_Type to make this function as it is in the comment?

  const ExternalFlags *const ext_flags = &cpi->ext_flags;
  cpi->rc.is_src_frame_alt_ref = 0;

  switch (type) {
    case KF_UPDATE:
      frame_params->refresh_golden_frame = 1;
      frame_params->refresh_bwd_ref_frame = 1;
      frame_params->refresh_alt_ref_frame = 1;
      break;

    case LF_UPDATE:
      frame_params->refresh_golden_frame = 0;
      frame_params->refresh_bwd_ref_frame = 0;
      frame_params->refresh_alt_ref_frame = 0;
      break;

    case GF_UPDATE:
      frame_params->refresh_golden_frame = 1;
      frame_params->refresh_bwd_ref_frame = 0;
      frame_params->refresh_alt_ref_frame = 0;
      break;

    case OVERLAY_UPDATE:
      frame_params->refresh_golden_frame = 1;
      frame_params->refresh_bwd_ref_frame = 0;
      frame_params->refresh_alt_ref_frame = 0;

      cpi->rc.is_src_frame_alt_ref = 1;
      break;

    case ARF_UPDATE:
      frame_params->refresh_golden_frame = 0;
      // NOTE: BWDREF does not get updated along with ALTREF_FRAME.
      frame_params->refresh_bwd_ref_frame = 0;
      frame_params->refresh_alt_ref_frame = 1;
      break;

    case INTNL_OVERLAY_UPDATE:
      frame_params->refresh_golden_frame = 0;
      frame_params->refresh_bwd_ref_frame = 0;
      frame_params->refresh_alt_ref_frame = 0;

      cpi->rc.is_src_frame_alt_ref = 1;
      break;

    case INTNL_ARF_UPDATE:
      frame_params->refresh_golden_frame = 0;
      frame_params->refresh_bwd_ref_frame = 1;
      frame_params->refresh_alt_ref_frame = 0;
      break;

    default: assert(0); break;
  }

  if (ext_flags->refresh_frame_flags_pending &&
      (!is_stat_generation_stage(cpi))) {
    frame_params->refresh_golden_frame = ext_flags->refresh_golden_frame;
    frame_params->refresh_alt_ref_frame = ext_flags->refresh_alt_ref_frame;
    frame_params->refresh_bwd_ref_frame = ext_flags->refresh_bwd_ref_frame;
  }

  if (force_refresh_all) {
    frame_params->refresh_golden_frame = 1;
    frame_params->refresh_bwd_ref_frame = 1;
    frame_params->refresh_alt_ref_frame = 1;
  }
}

static void set_additional_frame_flags(const AV1_COMMON *const cm,
                                       unsigned int *const frame_flags) {
  if (frame_is_intra_only(cm)) {
    *frame_flags |= FRAMEFLAGS_INTRAONLY;
  }
  if (frame_is_sframe(cm)) {
    *frame_flags |= FRAMEFLAGS_SWITCH;
  }
  if (cm->features.error_resilient_mode) {
    *frame_flags |= FRAMEFLAGS_ERROR_RESILIENT;
  }
}

static INLINE void update_keyframe_counters(AV1_COMP *cpi) {
  if (cpi->common.show_frame) {
    if (!cpi->common.show_existing_frame || cpi->rc.is_src_frame_alt_ref ||
        cpi->common.current_frame.frame_type == KEY_FRAME) {
      // If this is a show_existing_frame with a source other than altref,
      // or if it is not a displayed forward keyframe, the keyframe update
      // counters were incremented when it was originally encoded.
      cpi->rc.frames_since_key++;
      cpi->rc.frames_to_key--;
    }
  }
}

static INLINE int is_frame_droppable(const SVC *const svc,
                                     const ExternalFlags *const ext_flags) {
  // Droppable frame is only used by external refresh flags. VoD setting won't
  // trigger its use case.
  if (svc->external_ref_frame_config)
    return svc->non_reference_frame;
  else if (ext_flags->refresh_frame_flags_pending)
    return !(ext_flags->refresh_alt_ref_frame ||
             ext_flags->refresh_alt2_ref_frame ||
             ext_flags->refresh_bwd_ref_frame ||
             ext_flags->refresh_golden_frame || ext_flags->refresh_last_frame);
  else
    return 0;
}

static INLINE void update_frames_till_gf_update(AV1_COMP *cpi) {
  // TODO(weitinglin): Updating this counter for is_frame_droppable
  // is a work-around to handle the condition when a frame is drop.
  // We should fix the cpi->common.show_frame flag
  // instead of checking the other condition to update the counter properly.
  if (cpi->common.show_frame ||
      is_frame_droppable(&cpi->svc, &cpi->ext_flags)) {
    // Decrement count down till next gf
    if (cpi->rc.frames_till_gf_update_due > 0)
      cpi->rc.frames_till_gf_update_due--;
  }
}

static INLINE void update_gf_group_index(AV1_COMP *cpi) {
  // Increment the gf group index ready for the next frame. If this is
  // a show_existing_frame with a source other than altref, or if it is not
  // a displayed forward keyframe, the index was incremented when it was
  // originally encoded.
  if (!cpi->common.show_existing_frame || cpi->rc.is_src_frame_alt_ref ||
      cpi->common.current_frame.frame_type == KEY_FRAME) {
    ++cpi->gf_group.index;
  }
}

static void update_rc_counts(AV1_COMP *cpi) {
  update_keyframe_counters(cpi);
  update_frames_till_gf_update(cpi);
  update_gf_group_index(cpi);
}

static void set_ext_overrides(AV1_COMMON *const cm,
                              EncodeFrameParams *const frame_params,
                              ExternalFlags *const ext_flags) {
  // Overrides the defaults with the externally supplied values with
  // av1_update_reference() and av1_update_entropy() calls
  // Note: The overrides are valid only for the next frame passed
  // to av1_encode_lowlevel()

  if (ext_flags->use_s_frame) {
    frame_params->frame_type = S_FRAME;
  }

  if (ext_flags->refresh_frame_context_pending) {
    cm->features.refresh_frame_context = ext_flags->refresh_frame_context;
    ext_flags->refresh_frame_context_pending = 0;
  }
  cm->features.allow_ref_frame_mvs = ext_flags->use_ref_frame_mvs;

  frame_params->error_resilient_mode = ext_flags->use_error_resilient;
  // A keyframe is already error resilient and keyframes with
  // error_resilient_mode interferes with the use of show_existing_frame
  // when forward reference keyframes are enabled.
  frame_params->error_resilient_mode &= frame_params->frame_type != KEY_FRAME;
  // For bitstream conformance, s-frames must be error-resilient
  frame_params->error_resilient_mode |= frame_params->frame_type == S_FRAME;
}

static int get_current_frame_ref_type(
    const AV1_COMP *const cpi, const EncodeFrameParams *const frame_params) {
  // We choose the reference "type" of this frame from the flags which indicate
  // which reference frames will be refreshed by it.  More than one  of these
  // flags may be set, so the order here implies an order of precedence. This is
  // just used to choose the primary_ref_frame (as the most recent reference
  // buffer of the same reference-type as the current frame)

  (void)frame_params;
  // TODO(jingning): This table should be a lot simpler with the new
  // ARF system in place. Keep frame_params for the time being as we are
  // still evaluating a few design options.
  switch (cpi->gf_group.layer_depth[cpi->gf_group.index]) {
    case 0: return 0;
    case 1: return 1;
    case MAX_ARF_LAYERS:
    case MAX_ARF_LAYERS + 1: return 4;
    default: return 7;
  }
}

static int choose_primary_ref_frame(
    const AV1_COMP *const cpi, const EncodeFrameParams *const frame_params) {
  const AV1_COMMON *const cm = &cpi->common;

  const int intra_only = frame_params->frame_type == KEY_FRAME ||
                         frame_params->frame_type == INTRA_ONLY_FRAME;
  if (intra_only || frame_params->error_resilient_mode || cpi->use_svc ||
      cpi->ext_flags.use_primary_ref_none) {
    return PRIMARY_REF_NONE;
  }

  // In large scale case, always use Last frame's frame contexts.
  // Note(yunqing): In other cases, primary_ref_frame is chosen based on
  // cpi->gf_group.layer_depth[cpi->gf_group.index], which also controls
  // frame bit allocation.
  if (cm->tiles.large_scale) return (LAST_FRAME - LAST_FRAME);

  // Find the most recent reference frame with the same reference type as the
  // current frame
  const int current_ref_type = get_current_frame_ref_type(cpi, frame_params);
  int wanted_fb = cpi->fb_of_context_type[current_ref_type];

  int primary_ref_frame = PRIMARY_REF_NONE;
  for (int ref_frame = LAST_FRAME; ref_frame <= ALTREF_FRAME; ref_frame++) {
    if (get_ref_frame_map_idx(cm, ref_frame) == wanted_fb) {
      primary_ref_frame = ref_frame - LAST_FRAME;
    }
  }

  return primary_ref_frame;
}

static void update_fb_of_context_type(
    const AV1_COMP *const cpi, const EncodeFrameParams *const frame_params,
    int *const fb_of_context_type) {
  const AV1_COMMON *const cm = &cpi->common;
  const int current_frame_ref_type =
      get_current_frame_ref_type(cpi, frame_params);

  if (frame_is_intra_only(cm) || cm->features.error_resilient_mode ||
      cpi->ext_flags.use_primary_ref_none) {
    for (int i = 0; i < REF_FRAMES; i++) {
      fb_of_context_type[i] = -1;
    }
    fb_of_context_type[current_frame_ref_type] =
        cm->show_frame ? get_ref_frame_map_idx(cm, GOLDEN_FRAME)
                       : get_ref_frame_map_idx(cm, ALTREF_FRAME);
  }

  if (!encode_show_existing_frame(cm)) {
    // Refresh fb_of_context_type[]: see encoder.h for explanation
    if (cm->current_frame.frame_type == KEY_FRAME) {
      // All ref frames are refreshed, pick one that will live long enough
      fb_of_context_type[current_frame_ref_type] = 0;
    } else {
      // If more than one frame is refreshed, it doesn't matter which one we
      // pick so pick the first.  LST sometimes doesn't refresh any: this is ok

      for (int i = 0; i < REF_FRAMES; i++) {
        if (cm->current_frame.refresh_frame_flags & (1 << i)) {
          fb_of_context_type[current_frame_ref_type] = i;
          break;
        }
      }
    }
  }
}

static int get_order_offset(const GF_GROUP *const gf_group,
                            const EncodeFrameParams *const frame_params) {
  // shown frame by definition has order offset 0
  // show_existing_frame ignores order_offset and simply takes the order_hint
  // from the reference frame being shown.
  if (frame_params->show_frame || frame_params->show_existing_frame) return 0;

  const int arf_offset =
      AOMMIN((MAX_GF_INTERVAL - 1), gf_group->arf_src_offset[gf_group->index]);
  return AOMMIN((MAX_GF_INTERVAL - 1), arf_offset);
}

static void adjust_frame_rate(AV1_COMP *cpi, int64_t ts_start, int64_t ts_end) {
  TimeStamps *time_stamps = &cpi->time_stamps;
  int64_t this_duration;
  int step = 0;

  // Clear down mmx registers
  aom_clear_system_state();

  if (cpi->use_svc && cpi->svc.spatial_layer_id > 0) {
    cpi->framerate = cpi->svc.base_framerate;
    av1_rc_update_framerate(cpi, cpi->common.width, cpi->common.height);
    return;
  }

  if (ts_start == time_stamps->first_ever) {
    this_duration = ts_end - ts_start;
    step = 1;
  } else {
    int64_t last_duration =
        time_stamps->prev_end_seen - time_stamps->prev_start_seen;

    this_duration = ts_end - time_stamps->prev_end_seen;

    // do a step update if the duration changes by 10%
    if (last_duration)
      step = (int)((this_duration - last_duration) * 10 / last_duration);
  }

  if (this_duration) {
    if (step) {
      av1_new_framerate(cpi, 10000000.0 / this_duration);
    } else {
      // Average this frame's rate into the last second's average
      // frame rate. If we haven't seen 1 second yet, then average
      // over the whole interval seen.
      const double interval =
          AOMMIN((double)(ts_end - time_stamps->first_ever), 10000000.0);
      double avg_duration = 10000000.0 / cpi->framerate;
      avg_duration *= (interval - avg_duration + this_duration);
      avg_duration /= interval;

      av1_new_framerate(cpi, 10000000.0 / avg_duration);
    }
  }
  time_stamps->prev_start_seen = ts_start;
  time_stamps->prev_end_seen = ts_end;
}

// If this is an alt-ref, returns the offset of the source frame used
// as the arf midpoint. Otherwise, returns 0.
static int get_arf_src_index(GF_GROUP *gf_group, int pass) {
  int arf_src_index = 0;
  if (pass != 1) arf_src_index = gf_group->arf_src_offset[gf_group->index];
  return arf_src_index;
}

// Called if this frame is an ARF or ARF2. Also handles forward-keyframes
// For an ARF set arf2=0, for ARF2 set arf2=1
// temporal_filtered is set to 1 if we temporally filter the ARF frame, so that
// the correct post-filter buffer can be used.
static struct lookahead_entry *setup_arf_frame(
    AV1_COMP *const cpi, const int arf_src_index, int *code_arf,
    EncodeFrameParams *const frame_params, int *show_existing_alt_ref) {
  AV1_COMMON *const cm = &cpi->common;
  RATE_CONTROL *const rc = &cpi->rc;
#if !CONFIG_REALTIME_ONLY
  const AV1EncoderConfig *const oxcf = &cpi->oxcf;
#endif

  assert(arf_src_index <= rc->frames_to_key);
  *code_arf = 0;

  struct lookahead_entry *source =
      av1_lookahead_peek(cpi->lookahead, arf_src_index, cpi->compressor_stage);

  if (source != NULL) {
    cm->showable_frame = 1;

    // When arf_src_index == rc->frames_to_key, it indicates a fwd_kf
    if (arf_src_index == rc->frames_to_key) {
      // Skip temporal filtering and mark as intra_only if we have a fwd_kf
      cpi->no_show_kf = 1;
    } else {
#if !CONFIG_REALTIME_ONLY
      if (oxcf->arnr_max_frames > 0) {
        // Produce the filtered ARF frame.
        cm->current_frame.frame_type = INTER_FRAME;
        FRAME_UPDATE_TYPE frame_update_type =
            get_frame_update_type(&cpi->gf_group);
        av1_configure_buffer_updates(cpi, frame_params, frame_update_type, 0);
        *code_arf =
            av1_temporal_filter(cpi, arf_src_index, show_existing_alt_ref);
        if (*code_arf) {
          aom_extend_frame_borders(&cpi->alt_ref_buffer, av1_num_planes(cm));
        }
      }
#else
      (void)show_existing_alt_ref;
#endif
    }
    frame_params->show_frame = 0;
  }
  rc->source_alt_ref_pending = 0;
  return source;
}

// Determine whether there is a forced keyframe pending in the lookahead buffer
int is_forced_keyframe_pending(struct lookahead_ctx *lookahead,
                               const int up_to_index,
                               const COMPRESSOR_STAGE compressor_stage) {
  for (int i = 0; i <= up_to_index; i++) {
    const struct lookahead_entry *e =
        av1_lookahead_peek(lookahead, i, compressor_stage);
    if (e == NULL) {
      // We have reached the end of the lookahead buffer and not early-returned
      // so there isn't a forced key-frame pending.
      return -1;
    } else if (e->flags == AOM_EFLAG_FORCE_KF) {
      return (i + 1);
    } else {
      continue;
    }
  }
  return -1;  // Never reached
}

// Check if we should encode an ARF or internal ARF.  If not, try a LAST
// Do some setup associated with the chosen source
// temporal_filtered, flush, and frame_update_type are outputs.
// Return the frame source, or NULL if we couldn't find one
static struct lookahead_entry *choose_frame_source(
    AV1_COMP *const cpi, int *const code_arf, int *const flush,
    struct lookahead_entry **last_source, EncodeFrameParams *const frame_params,
    int *show_existing_alt_ref) {
  AV1_COMMON *const cm = &cpi->common;
  struct lookahead_entry *source = NULL;
  *code_arf = 0;

  // Should we encode an alt-ref frame.
  int arf_src_index = get_arf_src_index(&cpi->gf_group, cpi->oxcf.pass);
  // TODO(Aasaipriya): Forced key frames need to be fixed when rc_mode != AOM_Q
  if (arf_src_index &&
      (is_forced_keyframe_pending(cpi->lookahead, arf_src_index,
                                  cpi->compressor_stage) != -1) &&
      cpi->oxcf.rc_mode != AOM_Q) {
    arf_src_index = 0;
    *flush = 1;
  }

  if (arf_src_index)
    source = setup_arf_frame(cpi, arf_src_index, code_arf, frame_params,
                             show_existing_alt_ref);

  if (!source) {
    // Get last frame source.
    if (cm->current_frame.frame_number > 0) {
      *last_source =
          av1_lookahead_peek(cpi->lookahead, -1, cpi->compressor_stage);
    }
    // Read in the source frame.
    source = av1_lookahead_pop(cpi->lookahead, *flush, cpi->compressor_stage);
    if (source == NULL) return NULL;
    frame_params->show_frame = 1;
  }
  return source;
}

// Don't allow a show_existing_frame to coincide with an error resilient or
// S-Frame. An exception can be made in the case of a keyframe, since it does
// not depend on any previous frames.
static int allow_show_existing(const AV1_COMP *const cpi,
                               unsigned int frame_flags) {
  if (cpi->common.current_frame.frame_number == 0) return 0;

  const struct lookahead_entry *lookahead_src =
      av1_lookahead_peek(cpi->lookahead, 0, cpi->compressor_stage);
  if (lookahead_src == NULL) return 1;

  const int is_error_resilient =
      cpi->oxcf.error_resilient_mode ||
      (lookahead_src->flags & AOM_EFLAG_ERROR_RESILIENT);
  const int is_s_frame =
      cpi->oxcf.s_frame_mode || (lookahead_src->flags & AOM_EFLAG_SET_S_FRAME);
  const int is_key_frame =
      (cpi->rc.frames_to_key == 0) || (frame_flags & FRAMEFLAGS_KEY);
  return !(is_error_resilient || is_s_frame) || is_key_frame;
}

// Update frame_flags to tell the encoder's caller what sort of frame was
// encoded.
static void update_frame_flags(AV1_COMP *cpi, unsigned int *frame_flags) {
  if (encode_show_existing_frame(&cpi->common)) {
    *frame_flags &= ~FRAMEFLAGS_GOLDEN;
    *frame_flags &= ~FRAMEFLAGS_BWDREF;
    *frame_flags &= ~FRAMEFLAGS_ALTREF;
    *frame_flags &= ~FRAMEFLAGS_KEY;
    return;
  }

  if (cpi->refresh_golden_frame == 1) {
    *frame_flags |= FRAMEFLAGS_GOLDEN;
  } else {
    *frame_flags &= ~FRAMEFLAGS_GOLDEN;
  }

  if (cpi->refresh_alt_ref_frame == 1) {
    *frame_flags |= FRAMEFLAGS_ALTREF;
  } else {
    *frame_flags &= ~FRAMEFLAGS_ALTREF;
  }

  if (cpi->refresh_bwd_ref_frame == 1) {
    *frame_flags |= FRAMEFLAGS_BWDREF;
  } else {
    *frame_flags &= ~FRAMEFLAGS_BWDREF;
  }

  if (cpi->common.current_frame.frame_type == KEY_FRAME) {
    *frame_flags |= FRAMEFLAGS_KEY;
  } else {
    *frame_flags &= ~FRAMEFLAGS_KEY;
  }
}

#define DUMP_REF_FRAME_IMAGES 0

#if DUMP_REF_FRAME_IMAGES == 1
static int dump_one_image(AV1_COMMON *cm,
                          const YV12_BUFFER_CONFIG *const ref_buf,
                          char *file_name) {
  int h;
  FILE *f_ref = NULL;

  if (ref_buf == NULL) {
    printf("Frame data buffer is NULL.\n");
    return AOM_CODEC_MEM_ERROR;
  }

  if ((f_ref = fopen(file_name, "wb")) == NULL) {
    printf("Unable to open file %s to write.\n", file_name);
    return AOM_CODEC_MEM_ERROR;
  }

  // --- Y ---
  for (h = 0; h < cm->height; ++h) {
    fwrite(&ref_buf->y_buffer[h * ref_buf->y_stride], 1, cm->width, f_ref);
  }
  // --- U ---
  for (h = 0; h < (cm->height >> 1); ++h) {
    fwrite(&ref_buf->u_buffer[h * ref_buf->uv_stride], 1, (cm->width >> 1),
           f_ref);
  }
  // --- V ---
  for (h = 0; h < (cm->height >> 1); ++h) {
    fwrite(&ref_buf->v_buffer[h * ref_buf->uv_stride], 1, (cm->width >> 1),
           f_ref);
  }

  fclose(f_ref);

  return AOM_CODEC_OK;
}

static void dump_ref_frame_images(AV1_COMP *cpi) {
  AV1_COMMON *const cm = &cpi->common;
  MV_REFERENCE_FRAME ref_frame;

  for (ref_frame = LAST_FRAME; ref_frame <= ALTREF_FRAME; ++ref_frame) {
    char file_name[256] = "";
    snprintf(file_name, sizeof(file_name), "/tmp/enc_F%d_ref_%d.yuv",
             cm->current_frame.frame_number, ref_frame);
    dump_one_image(cm, get_ref_frame_yv12_buf(cpi, ref_frame), file_name);
  }
}
#endif  // DUMP_REF_FRAME_IMAGES == 1

int av1_get_refresh_ref_frame_map(int refresh_frame_flags) {
  int ref_map_index = INVALID_IDX;

  for (ref_map_index = 0; ref_map_index < REF_FRAMES; ++ref_map_index)
    if ((refresh_frame_flags >> ref_map_index) & 1) break;

  return ref_map_index;
}

static void update_arf_stack(int ref_map_index,
                             RefBufferStack *ref_buffer_stack) {
  if (ref_buffer_stack->arf_stack_size >= 0) {
    if (ref_buffer_stack->arf_stack[0] == ref_map_index)
      stack_pop(ref_buffer_stack->arf_stack, &ref_buffer_stack->arf_stack_size);
  }

  if (ref_buffer_stack->lst_stack_size) {
    for (int i = ref_buffer_stack->lst_stack_size - 1; i >= 0; --i) {
      if (ref_buffer_stack->lst_stack[i] == ref_map_index) {
        for (int idx = i; idx < ref_buffer_stack->lst_stack_size - 1; ++idx)
          ref_buffer_stack->lst_stack[idx] =
              ref_buffer_stack->lst_stack[idx + 1];
        ref_buffer_stack->lst_stack[ref_buffer_stack->lst_stack_size - 1] =
            INVALID_IDX;
        --ref_buffer_stack->lst_stack_size;
      }
    }
  }

  if (ref_buffer_stack->gld_stack_size) {
    for (int i = ref_buffer_stack->gld_stack_size - 1; i >= 0; --i) {
      if (ref_buffer_stack->gld_stack[i] == ref_map_index) {
        for (int idx = i; idx < ref_buffer_stack->gld_stack_size - 1; ++idx)
          ref_buffer_stack->gld_stack[idx] =
              ref_buffer_stack->gld_stack[idx + 1];
        ref_buffer_stack->gld_stack[ref_buffer_stack->gld_stack_size - 1] =
            INVALID_IDX;
        --ref_buffer_stack->gld_stack_size;
      }
    }
  }
}

// Update reference frame stack info.
void av1_update_ref_frame_map(AV1_COMP *cpi,
                              FRAME_UPDATE_TYPE frame_update_type,
                              int show_existing_frame, int ref_map_index,
                              RefBufferStack *ref_buffer_stack) {
  AV1_COMMON *const cm = &cpi->common;
  // TODO(jingning): Consider the S-frame same as key frame for the
  // reference frame tracking purpose. The logic might be better
  // expressed than converting the frame update type.
  if (frame_is_sframe(cm)) frame_update_type = KEY_FRAME;

  if (is_frame_droppable(&cpi->svc, &cpi->ext_flags)) return;

  switch (frame_update_type) {
    case KEY_FRAME:
      if (show_existing_frame)
        ref_map_index = stack_pop(ref_buffer_stack->arf_stack,
                                  &ref_buffer_stack->arf_stack_size);
      stack_reset(ref_buffer_stack->lst_stack,
                  &ref_buffer_stack->lst_stack_size);
      stack_reset(ref_buffer_stack->gld_stack,
                  &ref_buffer_stack->gld_stack_size);
      stack_reset(ref_buffer_stack->arf_stack,
                  &ref_buffer_stack->arf_stack_size);
      stack_push(ref_buffer_stack->gld_stack, &ref_buffer_stack->gld_stack_size,
                 ref_map_index);
      break;
    case GF_UPDATE:
      update_arf_stack(ref_map_index, ref_buffer_stack);
      stack_push(ref_buffer_stack->gld_stack, &ref_buffer_stack->gld_stack_size,
                 ref_map_index);
      // For nonrd_mode: update LAST as well on GF_UPDATE frame.
      if (cpi->sf.rt_sf.use_nonrd_pick_mode)
        stack_push(ref_buffer_stack->lst_stack,
                   &ref_buffer_stack->lst_stack_size, ref_map_index);
      break;
    case LF_UPDATE:
      update_arf_stack(ref_map_index, ref_buffer_stack);
      stack_push(ref_buffer_stack->lst_stack, &ref_buffer_stack->lst_stack_size,
                 ref_map_index);
      break;
    case ARF_UPDATE:
    case INTNL_ARF_UPDATE:
      update_arf_stack(ref_map_index, ref_buffer_stack);
      stack_push(ref_buffer_stack->arf_stack, &ref_buffer_stack->arf_stack_size,
                 ref_map_index);
      break;
    case OVERLAY_UPDATE:
      ref_map_index = stack_pop(ref_buffer_stack->arf_stack,
                                &ref_buffer_stack->arf_stack_size);
      stack_push(ref_buffer_stack->gld_stack, &ref_buffer_stack->gld_stack_size,
                 ref_map_index);
      break;
    case INTNL_OVERLAY_UPDATE:
      ref_map_index = stack_pop(ref_buffer_stack->arf_stack,
                                &ref_buffer_stack->arf_stack_size);
      stack_push(ref_buffer_stack->lst_stack, &ref_buffer_stack->lst_stack_size,
                 ref_map_index);
      break;
    default: assert(0 && "unknown type");
  }
  return;
}

static int get_free_ref_map_index(const RefBufferStack *ref_buffer_stack) {
  for (int idx = 0; idx < REF_FRAMES; ++idx) {
    int is_free = 1;
    for (int i = 0; i < ref_buffer_stack->arf_stack_size; ++i) {
      if (ref_buffer_stack->arf_stack[i] == idx) {
        is_free = 0;
        break;
      }
    }

    for (int i = 0; i < ref_buffer_stack->lst_stack_size; ++i) {
      if (ref_buffer_stack->lst_stack[i] == idx) {
        is_free = 0;
        break;
      }
    }

    for (int i = 0; i < ref_buffer_stack->gld_stack_size; ++i) {
      if (ref_buffer_stack->gld_stack[i] == idx) {
        is_free = 0;
        break;
      }
    }

    if (is_free) return idx;
  }
  return INVALID_IDX;
}

int av1_get_refresh_frame_flags(const AV1_COMP *const cpi,
                                const EncodeFrameParams *const frame_params,
                                FRAME_UPDATE_TYPE frame_update_type,
                                const RefBufferStack *const ref_buffer_stack) {
  const AV1_COMMON *const cm = &cpi->common;
  const ExternalFlags *const ext_flags = &cpi->ext_flags;
  const SVC *const svc = &cpi->svc;
  // Switch frames and shown key-frames overwrite all reference slots
  if ((frame_params->frame_type == KEY_FRAME && frame_params->show_frame) ||
      frame_params->frame_type == S_FRAME)
    return 0xFF;

  // show_existing_frames don't actually send refresh_frame_flags so set the
  // flags to 0 to keep things consistent.
  if (frame_params->show_existing_frame &&
      (!frame_params->error_resilient_mode ||
       frame_params->frame_type == KEY_FRAME)) {
    return 0;
  }

  if (is_frame_droppable(svc, ext_flags)) return 0;

  int refresh_mask = 0;

  if (ext_flags->refresh_frame_flags_pending) {
    if (svc->external_ref_frame_config) {
      for (unsigned int i = 0; i < INTER_REFS_PER_FRAME; i++) {
        int ref_frame_map_idx = svc->ref_idx[i];
        refresh_mask |= svc->refresh[ref_frame_map_idx] << ref_frame_map_idx;
      }
      return refresh_mask;
    }
    // Unfortunately the encoder interface reflects the old refresh_*_frame
    // flags so we have to replicate the old refresh_frame_flags logic here in
    // order to preserve the behaviour of the flag overrides.
    int ref_frame_map_idx = get_ref_frame_map_idx(cm, LAST_FRAME);
    if (ref_frame_map_idx != INVALID_IDX)
      refresh_mask |= ext_flags->refresh_last_frame << ref_frame_map_idx;

    ref_frame_map_idx = get_ref_frame_map_idx(cm, EXTREF_FRAME);
    if (ref_frame_map_idx != INVALID_IDX)
      refresh_mask |= ext_flags->refresh_bwd_ref_frame << ref_frame_map_idx;

    ref_frame_map_idx = get_ref_frame_map_idx(cm, ALTREF2_FRAME);
    if (ref_frame_map_idx != INVALID_IDX)
      refresh_mask |= ext_flags->refresh_alt2_ref_frame << ref_frame_map_idx;

    if (frame_update_type == OVERLAY_UPDATE) {
      ref_frame_map_idx = get_ref_frame_map_idx(cm, ALTREF_FRAME);
      if (ref_frame_map_idx != INVALID_IDX)
        refresh_mask |= ext_flags->refresh_golden_frame << ref_frame_map_idx;
    } else {
      ref_frame_map_idx = get_ref_frame_map_idx(cm, GOLDEN_FRAME);
      if (ref_frame_map_idx != INVALID_IDX)
        refresh_mask |= ext_flags->refresh_golden_frame << ref_frame_map_idx;

      ref_frame_map_idx = get_ref_frame_map_idx(cm, ALTREF_FRAME);
      if (ref_frame_map_idx != INVALID_IDX)
        refresh_mask |= ext_flags->refresh_alt_ref_frame << ref_frame_map_idx;
    }
    return refresh_mask;
  }

  // Search for the open slot to store the current frame.
  int free_fb_index = get_free_ref_map_index(ref_buffer_stack);
  switch (frame_update_type) {
    case KF_UPDATE:
    case GF_UPDATE:
      if (free_fb_index != INVALID_IDX) {
        refresh_mask = 1 << free_fb_index;
      } else {
        if (ref_buffer_stack->gld_stack_size)
          refresh_mask =
              1 << ref_buffer_stack
                       ->gld_stack[ref_buffer_stack->gld_stack_size - 1];
        else
          refresh_mask =
              1 << ref_buffer_stack
                       ->lst_stack[ref_buffer_stack->lst_stack_size - 1];
      }
      break;
    case LF_UPDATE:
      if (free_fb_index != INVALID_IDX) {
        refresh_mask = 1 << free_fb_index;
      } else {
        if (ref_buffer_stack->lst_stack_size >= 2)
          refresh_mask =
              1 << ref_buffer_stack
                       ->lst_stack[ref_buffer_stack->lst_stack_size - 1];
        else if (ref_buffer_stack->gld_stack_size >= 2)
          refresh_mask =
              1 << ref_buffer_stack
                       ->gld_stack[ref_buffer_stack->gld_stack_size - 1];
        else
          assert(0 && "No ref map index found");
      }
      break;
    case ARF_UPDATE:
      if (free_fb_index != INVALID_IDX) {
        refresh_mask = 1 << free_fb_index;
      } else {
        if (ref_buffer_stack->gld_stack_size >= 3)
          refresh_mask =
              1 << ref_buffer_stack
                       ->gld_stack[ref_buffer_stack->gld_stack_size - 1];
        else if (ref_buffer_stack->lst_stack_size >= 2)
          refresh_mask =
              1 << ref_buffer_stack
                       ->lst_stack[ref_buffer_stack->lst_stack_size - 1];
        else
          assert(0 && "No ref map index found");
      }
      break;
    case INTNL_ARF_UPDATE:
      if (free_fb_index != INVALID_IDX) {
        refresh_mask = 1 << free_fb_index;
      } else {
        refresh_mask =
            1 << ref_buffer_stack
                     ->lst_stack[ref_buffer_stack->lst_stack_size - 1];
      }
      break;
    case OVERLAY_UPDATE: break;
    case INTNL_OVERLAY_UPDATE: break;
    default: assert(0); break;
  }

  return refresh_mask;
}

#if !CONFIG_REALTIME_ONLY
void setup_mi(AV1_COMP *const cpi, YV12_BUFFER_CONFIG *src) {
  AV1_COMMON *const cm = &cpi->common;
  const int num_planes = av1_num_planes(cm);
  MACROBLOCK *const x = &cpi->td.mb;
  MACROBLOCKD *const xd = &x->e_mbd;

  av1_setup_src_planes(x, src, 0, 0, num_planes, cm->seq_params.sb_size);

  av1_setup_block_planes(xd, cm->seq_params.subsampling_x,
                         cm->seq_params.subsampling_y, num_planes);

  set_mi_offsets(&cm->mi_params, xd, 0, 0);
}

// Apply temporal filtering to key frames and encode the filtered frame.
// If the current frame is not key frame, this function is identical to
// av1_encode().
static int denoise_and_encode(AV1_COMP *const cpi, uint8_t *const dest,
                              EncodeFrameInput *const frame_input,
                              EncodeFrameParams *const frame_params,
                              EncodeFrameResults *const frame_results) {
  const AV1EncoderConfig *const oxcf = &cpi->oxcf;
  AV1_COMMON *const cm = &cpi->common;

  // Decide whether to apply temporal filtering to the source frame.
  int apply_filtering =
      frame_params->frame_type == KEY_FRAME &&
      oxcf->enable_keyframe_filtering && !is_stat_generation_stage(cpi) &&
      !frame_params->show_existing_frame &&
      cpi->rc.frames_to_key > TF_NUM_FILTERING_FRAMES_FOR_KEY_FRAME &&
      !is_lossless_requested(oxcf) && oxcf->arnr_max_frames > 0;
  if (apply_filtering) {
    const double y_noise_level = av1_estimate_noise_from_single_plane(
        frame_input->source, 0, cm->seq_params.bit_depth);
    apply_filtering = y_noise_level > 0;
  }

  // Save the pointer to the original source image.
  YV12_BUFFER_CONFIG *source_kf_buffer = frame_input->source;

  // Apply filtering to key frame.
  if (apply_filtering) {
    // Initialization for frame motion estimation.
    MACROBLOCKD *const xd = &cpi->td.mb.e_mbd;
    av1_init_mi_buffers(&cm->mi_params);
    setup_mi(cpi, frame_input->source);
    av1_init_macroblockd(cm, xd, NULL);
    memset(
        cpi->mbmi_ext_info.frame_base, 0,
        cpi->mbmi_ext_info.alloc_size * sizeof(*cpi->mbmi_ext_info.frame_base));

    av1_set_speed_features_framesize_independent(cpi, oxcf->speed);
    av1_set_speed_features_framesize_dependent(cpi, oxcf->speed);
    av1_set_rd_speed_thresholds(cpi);
    av1_setup_frame_buf_refs(cm);
    av1_setup_frame_sign_bias(cm);
    av1_frame_init_quantizer(cpi);
    av1_setup_past_independence(cm);

    if (!frame_params->show_frame) {
      int arf_src_index = get_arf_src_index(&cpi->gf_group, cpi->oxcf.pass);
      av1_temporal_filter(cpi, -1 * arf_src_index, NULL);
    } else {
      av1_temporal_filter(cpi, -1, NULL);
    }
    aom_extend_frame_borders(&cpi->alt_ref_buffer, av1_num_planes(cm));
    // Use the filtered frame for encoding.
    frame_input->source = &cpi->alt_ref_buffer;
    // Copy metadata info to alt-ref buffer.
    aom_remove_metadata_from_frame_buffer(frame_input->source);
    aom_copy_metadata_to_frame_buffer(frame_input->source,
                                      source_kf_buffer->metadata);
  }

  if (frame_params->frame_type == KEY_FRAME && !is_stat_generation_stage(cpi) &&
      oxcf->enable_tpl_model && oxcf->lag_in_frames > 0 &&
      frame_params->show_frame) {
    av1_tpl_setup_stats(cpi, 0, frame_params, frame_input);
  }

  if (av1_encode(cpi, dest, frame_input, frame_params, frame_results) !=
      AOM_CODEC_OK) {
    return AOM_CODEC_ERROR;
  }

  // Set frame_input source to true source for psnr calculation.
  if (apply_filtering) {
    cpi->source = source_kf_buffer;
    cpi->unscaled_source = source_kf_buffer;
  }

  return AOM_CODEC_OK;
}
#endif  // !CONFIG_REALTIME_ONLY

static INLINE int find_unused_ref_frame(const int *used_ref_frames,
                                        const int *stack, int stack_size) {
  for (int i = 0; i < stack_size; ++i) {
    const int this_ref = stack[i];
    int ref_idx = 0;
    for (ref_idx = 0; ref_idx <= ALTREF_FRAME - LAST_FRAME; ++ref_idx) {
      if (this_ref == used_ref_frames[ref_idx]) break;
    }

    // not in use
    if (ref_idx > ALTREF_FRAME - LAST_FRAME) return this_ref;
  }

  return INVALID_IDX;
}

void av1_get_ref_frames(AV1_COMP *const cpi, RefBufferStack *ref_buffer_stack) {
  AV1_COMMON *cm = &cpi->common;
  int *const remapped_ref_idx = cm->remapped_ref_idx;
  int *const arf_stack = ref_buffer_stack->arf_stack;
  int *const lst_stack = ref_buffer_stack->lst_stack;
  int *const gld_stack = ref_buffer_stack->gld_stack;
  const int arf_stack_size = ref_buffer_stack->arf_stack_size;
  const int lst_stack_size = ref_buffer_stack->lst_stack_size;
  const int gld_stack_size = ref_buffer_stack->gld_stack_size;

  // Initialization
  for (int i = 0; i < REF_FRAMES; ++i) remapped_ref_idx[i] = INVALID_IDX;

  if (arf_stack_size) {
    remapped_ref_idx[ALTREF_FRAME - LAST_FRAME] = arf_stack[arf_stack_size - 1];

    if (arf_stack_size > 1)
      remapped_ref_idx[BWDREF_FRAME - LAST_FRAME] = arf_stack[0];

    if (arf_stack_size > 2)
      remapped_ref_idx[ALTREF2_FRAME - LAST_FRAME] = arf_stack[1];
  }

  if (lst_stack_size) {
    remapped_ref_idx[LAST_FRAME - LAST_FRAME] = lst_stack[0];

    if (lst_stack_size > 1)
      remapped_ref_idx[LAST2_FRAME - LAST_FRAME] = lst_stack[1];
  }

  if (gld_stack_size) {
    remapped_ref_idx[GOLDEN_FRAME - LAST_FRAME] = gld_stack[0];

    if (gld_stack_size > 1) {
      if (arf_stack_size <= 1)
        remapped_ref_idx[BWDREF_FRAME - LAST_FRAME] = gld_stack[1];
      else
        remapped_ref_idx[LAST3_FRAME - LAST_FRAME] = gld_stack[1];
    }
  }

  for (int idx = ALTREF_FRAME - LAST_FRAME; idx >= 0; --idx) {
    int ref_map_index = remapped_ref_idx[idx];

    if (ref_map_index != INVALID_IDX) continue;

    ref_map_index =
        find_unused_ref_frame(remapped_ref_idx, arf_stack, arf_stack_size);

    if (ref_map_index == INVALID_IDX) {
      ref_map_index =
          find_unused_ref_frame(remapped_ref_idx, gld_stack, gld_stack_size);
    }

    if (ref_map_index == INVALID_IDX) {
      ref_map_index =
          find_unused_ref_frame(remapped_ref_idx, lst_stack, lst_stack_size);
    }

    if (ref_map_index != INVALID_IDX)
      remapped_ref_idx[idx] = ref_map_index;
    else
      remapped_ref_idx[idx] = ref_buffer_stack->gld_stack[0];
  }
}

int av1_encode_strategy(AV1_COMP *const cpi, size_t *const size,
                        uint8_t *const dest, unsigned int *frame_flags,
                        int64_t *const time_stamp, int64_t *const time_end,
                        const aom_rational64_t *const timestamp_ratio,
                        int flush) {
  const AV1EncoderConfig *const oxcf = &cpi->oxcf;
  AV1_COMMON *const cm = &cpi->common;
  GF_GROUP *gf_group = &cpi->gf_group;
  ExternalFlags *const ext_flags = &cpi->ext_flags;

  EncodeFrameInput frame_input;
  EncodeFrameParams frame_params;
  EncodeFrameResults frame_results;
  memset(&frame_input, 0, sizeof(frame_input));
  memset(&frame_params, 0, sizeof(frame_params));
  memset(&frame_results, 0, sizeof(frame_results));

  // TODO(sarahparker) finish bit allocation for one pass pyramid
  if (has_no_stats_stage(cpi) && oxcf->rc_mode != AOM_Q) {
    cpi->oxcf.gf_max_pyr_height =
        AOMMIN(cpi->oxcf.gf_max_pyr_height, USE_ALTREF_FOR_ONE_PASS);
    cpi->oxcf.gf_min_pyr_height =
        AOMMIN(cpi->oxcf.gf_min_pyr_height, cpi->oxcf.gf_max_pyr_height);
  }

  if (!is_stat_generation_stage(cpi)) {
    // If this is a forward keyframe, mark as a show_existing_frame
    if (cpi->oxcf.fwd_kf_enabled && (gf_group->index == gf_group->size) &&
        gf_group->update_type[1] == ARF_UPDATE && cpi->rc.frames_to_key == 0) {
      frame_params.show_existing_frame = 1;
    } else {
      frame_params.show_existing_frame =
          ((oxcf->enable_overlay == 0 || cpi->sf.hl_sf.disable_overlay_frames ||
            cpi->show_existing_alt_ref) &&
           gf_group->update_type[gf_group->index] == OVERLAY_UPDATE) ||
          gf_group->update_type[gf_group->index] == INTNL_OVERLAY_UPDATE;
    }
    frame_params.show_existing_frame &= allow_show_existing(cpi, *frame_flags);

    // Reset show_existing_alt_ref decision to 0 after it is used.
    if (gf_group->update_type[gf_group->index] == OVERLAY_UPDATE) {
      cpi->show_existing_alt_ref = 0;
    }
  } else {
    frame_params.show_existing_frame = 0;
  }

  int code_arf = 0;
  struct lookahead_entry *source = NULL;
  struct lookahead_entry *last_source = NULL;
  if (frame_params.show_existing_frame) {
    source = av1_lookahead_pop(cpi->lookahead, flush, cpi->compressor_stage);
    frame_params.show_frame = 1;
  } else {
    int show_existing_alt_ref = 0;
    source = choose_frame_source(cpi, &code_arf, &flush, &last_source,
                                 &frame_params, &show_existing_alt_ref);
    if (gf_group->update_type[gf_group->index] == ARF_UPDATE)
      cpi->show_existing_alt_ref = show_existing_alt_ref;
  }

  if (source == NULL) {  // If no source was found, we can't encode a frame.
#if !CONFIG_REALTIME_ONLY
    if (flush && oxcf->pass == 1 && !cpi->twopass.first_pass_done) {
      av1_end_first_pass(cpi); /* get last stats packet */
      cpi->twopass.first_pass_done = 1;
    }
#endif
    return -1;
  }

  frame_input.source = code_arf ? &cpi->alt_ref_buffer : &source->img;
  frame_input.last_source = last_source != NULL ? &last_source->img : NULL;
  frame_input.ts_duration = source->ts_end - source->ts_start;
  // Save unfiltered source. It is used in av1_get_second_pass_params().
  cpi->unfiltered_source = frame_input.source;

  *time_stamp = source->ts_start;
  *time_end = source->ts_end;
  if (source->ts_start < cpi->time_stamps.first_ever) {
    cpi->time_stamps.first_ever = source->ts_start;
    cpi->time_stamps.prev_end_seen = source->ts_start;
  }

  av1_apply_encoding_flags(cpi, source->flags);
  if (!frame_params.show_existing_frame)
    *frame_flags = (source->flags & AOM_EFLAG_FORCE_KF) ? FRAMEFLAGS_KEY : 0;

  // Shown frames and arf-overlay frames need frame-rate considering
  if (frame_params.show_frame)
    adjust_frame_rate(cpi, source->ts_start, source->ts_end);

  if (!frame_params.show_existing_frame) {
    if (cpi->film_grain_table) {
      cm->cur_frame->film_grain_params_present = aom_film_grain_table_lookup(
          cpi->film_grain_table, *time_stamp, *time_end, 0 /* =erase */,
          &cm->film_grain_params);
    } else {
      cm->cur_frame->film_grain_params_present =
          cm->seq_params.film_grain_params_present;
    }
    // only one operating point supported now
    const int64_t pts64 = ticks_to_timebase_units(timestamp_ratio, *time_stamp);
    if (pts64 < 0 || pts64 > UINT32_MAX) return AOM_CODEC_ERROR;
    cm->frame_presentation_time = (uint32_t)pts64;
  }

#if CONFIG_REALTIME_ONLY
  av1_get_one_pass_rt_params(cpi, &frame_params, *frame_flags);
#else
  if (has_no_stats_stage(cpi) && oxcf->mode == REALTIME &&
      oxcf->lag_in_frames == 0)
    av1_get_one_pass_rt_params(cpi, &frame_params, *frame_flags);
  else if (!is_stat_generation_stage(cpi))
    av1_get_second_pass_params(cpi, &frame_params, &frame_input, *frame_flags);
#endif
  FRAME_UPDATE_TYPE frame_update_type = get_frame_update_type(gf_group);

  if (frame_params.show_existing_frame &&
      frame_params.frame_type != KEY_FRAME) {
    // Force show-existing frames to be INTER, except forward keyframes
    frame_params.frame_type = INTER_FRAME;
  }

  // TODO(david.turner@argondesign.com): Move all the encode strategy
  // (largely near av1_get_compressed_data) in here

  // TODO(david.turner@argondesign.com): Change all the encode strategy to
  // modify frame_params instead of cm or cpi.

  // Per-frame encode speed.  In theory this can vary, but things may have been
  // written assuming speed-level will not change within a sequence, so this
  // parameter should be used with caution.
  frame_params.speed = oxcf->speed;

  // Work out some encoding parameters specific to the pass:
  if (has_no_stats_stage(cpi) && cpi->oxcf.aq_mode == CYCLIC_REFRESH_AQ) {
    av1_cyclic_refresh_update_parameters(cpi);
  } else if (is_stat_generation_stage(cpi)) {
    cpi->td.mb.e_mbd.lossless[0] = is_lossless_requested(&cpi->oxcf);
    const int kf_requested = (cm->current_frame.frame_number == 0 ||
                              (*frame_flags & FRAMEFLAGS_KEY));
    if (kf_requested && frame_update_type != OVERLAY_UPDATE &&
        frame_update_type != INTNL_OVERLAY_UPDATE) {
      frame_params.frame_type = KEY_FRAME;
    } else {
      frame_params.frame_type = INTER_FRAME;
    }
  } else if (is_stat_consumption_stage(cpi)) {
#if CONFIG_MISMATCH_DEBUG
    mismatch_move_frame_idx_w();
#endif
#if TXCOEFF_COST_TIMER
    cm->txcoeff_cost_timer = 0;
    cm->txcoeff_cost_count = 0;
#endif
  }

  if (!is_stat_generation_stage(cpi))
    set_ext_overrides(cm, &frame_params, ext_flags);

  // Shown keyframes and S frames refresh all reference buffers
  const int force_refresh_all =
      ((frame_params.frame_type == KEY_FRAME && frame_params.show_frame) ||
       frame_params.frame_type == S_FRAME) &&
      !frame_params.show_existing_frame;

  av1_configure_buffer_updates(cpi, &frame_params, frame_update_type,
                               force_refresh_all);

  if (!is_stat_generation_stage(cpi)) {
    const RefCntBuffer *ref_frames[INTER_REFS_PER_FRAME];
    const YV12_BUFFER_CONFIG *ref_frame_buf[INTER_REFS_PER_FRAME];

    if (!ext_flags->refresh_frame_flags_pending) {
      av1_get_ref_frames(cpi, &cpi->ref_buffer_stack);
    } else if (cpi->svc.external_ref_frame_config) {
      for (unsigned int i = 0; i < INTER_REFS_PER_FRAME; i++)
        cm->remapped_ref_idx[i] = cpi->svc.ref_idx[i];
    }

    // Get the reference frames
    for (int i = 0; i < INTER_REFS_PER_FRAME; ++i) {
      ref_frames[i] = get_ref_frame_buf(cm, ref_frame_priority_order[i]);
      ref_frame_buf[i] = ref_frames[i] != NULL ? &ref_frames[i]->buf : NULL;
    }
    // Work out which reference frame slots may be used.
    frame_params.ref_frame_flags = get_ref_frame_flags(
        &cpi->sf, ref_frame_buf, ext_flags->ref_frame_flags);

    frame_params.primary_ref_frame =
        choose_primary_ref_frame(cpi, &frame_params);
    frame_params.order_offset = get_order_offset(&cpi->gf_group, &frame_params);

    frame_params.refresh_frame_flags = av1_get_refresh_frame_flags(
        cpi, &frame_params, frame_update_type, &cpi->ref_buffer_stack);

    frame_params.existing_fb_idx_to_show =
        frame_params.show_existing_frame
            ? (frame_update_type == INTNL_OVERLAY_UPDATE
                   ? get_ref_frame_map_idx(cm, BWDREF_FRAME)
                   : get_ref_frame_map_idx(cm, ALTREF_FRAME))
            : INVALID_IDX;
  }

  // The way frame_params->remapped_ref_idx is setup is a placeholder.
  // Currently, reference buffer assignment is done by update_ref_frame_map()
  // which is called by high-level strategy AFTER encoding a frame.  It modifies
  // cm->remapped_ref_idx.  If you want to use an alternative method to
  // determine reference buffer assignment, just put your assignments into
  // frame_params->remapped_ref_idx here and they will be used when encoding
  // this frame.  If frame_params->remapped_ref_idx is setup independently of
  // cm->remapped_ref_idx then update_ref_frame_map() will have no effect.
  memcpy(frame_params.remapped_ref_idx, cm->remapped_ref_idx,
         REF_FRAMES * sizeof(*cm->remapped_ref_idx));

  cpi->td.mb.e_mbd.delta_qindex = 0;

  if (!frame_params.show_existing_frame) {
    cm->quant_params.using_qmatrix = cpi->oxcf.using_qm;
#if !CONFIG_REALTIME_ONLY
    if (oxcf->lag_in_frames > 0 && !is_stat_generation_stage(cpi)) {
      if (cpi->gf_group.index == 1 && cpi->oxcf.enable_tpl_model) {
        av1_configure_buffer_updates(cpi, &frame_params, frame_update_type, 0);
        av1_set_frame_size(cpi, cm->width, cm->height);
        av1_tpl_setup_stats(cpi, 0, &frame_params, &frame_input);
        assert(cpi->num_gf_group_show_frames == 1);
      }
    }
#endif
  }

#if CONFIG_REALTIME_ONLY
  if (av1_encode(cpi, dest, &frame_input, &frame_params, &frame_results) !=
      AOM_CODEC_OK) {
    return AOM_CODEC_ERROR;
  }
#else
  if (denoise_and_encode(cpi, dest, &frame_input, &frame_params,
                         &frame_results) != AOM_CODEC_OK) {
    return AOM_CODEC_ERROR;
  }
#endif  // CONFIG_REALTIME_ONLY
  if (!is_stat_generation_stage(cpi))
    cpi->num_gf_group_show_frames += frame_params.show_frame;

  if (!is_stat_generation_stage(cpi)) {
    // First pass doesn't modify reference buffer assignment or produce frame
    // flags
    update_frame_flags(cpi, frame_flags);
    if (!ext_flags->refresh_frame_flags_pending) {
      int ref_map_index =
          av1_get_refresh_ref_frame_map(cm->current_frame.refresh_frame_flags);
      av1_update_ref_frame_map(cpi, frame_update_type, cm->show_existing_frame,
                               ref_map_index, &cpi->ref_buffer_stack);
    }
  }

#if !CONFIG_REALTIME_ONLY
  if (!is_stat_generation_stage(cpi)) {
#if TXCOEFF_COST_TIMER
    cm->cum_txcoeff_cost_timer += cm->txcoeff_cost_timer;
    fprintf(stderr,
            "\ntxb coeff cost block number: %ld, frame time: %ld, cum time %ld "
            "in us\n",
            cm->txcoeff_cost_count, cm->txcoeff_cost_timer,
            cm->cum_txcoeff_cost_timer);
#endif
    av1_twopass_postencode_update(cpi);
  }
#endif  // !CONFIG_REALTIME_ONLY

  if (!is_stat_generation_stage(cpi)) {
    update_fb_of_context_type(cpi, &frame_params, cpi->fb_of_context_type);
    set_additional_frame_flags(cm, frame_flags);
    update_rc_counts(cpi);
  }

  // Unpack frame_results:
  *size = frame_results.size;

  // Leave a signal for a higher level caller about if this frame is droppable
  if (*size > 0) {
    cpi->droppable = is_frame_droppable(&cpi->svc, ext_flags);
  }

  if (cpi->use_svc) av1_save_layer_context(cpi);

  return AOM_CODEC_OK;
}
