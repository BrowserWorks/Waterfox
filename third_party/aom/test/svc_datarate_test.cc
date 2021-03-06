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

#include "config/aom_config.h"

#include "third_party/googletest/src/googletest/include/gtest/gtest.h"
#include "test/codec_factory.h"
#include "test/datarate_test.h"
#include "test/encode_test_driver.h"
#include "test/i420_video_source.h"
#include "test/util.h"
#include "test/y4m_video_source.h"
#include "aom/aom_codec.h"
#include "av1/common/enums.h"

namespace datarate_test {
namespace {

class DatarateTestSVC
    : public ::libaom_test::CodecTestWith4Params<libaom_test::TestMode, int,
                                                 unsigned int, int>,
      public DatarateTest {
 public:
  DatarateTestSVC() : DatarateTest(GET_PARAM(0)) {
    set_cpu_used_ = GET_PARAM(2);
    aq_mode_ = GET_PARAM(3);
  }

 protected:
  virtual void SetUp() {
    InitializeConfig();
    SetMode(GET_PARAM(1));
    ResetModel();
  }

  virtual int GetNumSpatialLayers() { return number_spatial_layers_; }

  virtual void ResetModel() {
    DatarateTest::ResetModel();
    layer_frame_cnt_ = 0;
    superframe_cnt_ = 0;
    number_temporal_layers_ = 1;
    number_spatial_layers_ = 1;
    for (int i = 0; i < AOM_MAX_LAYERS; i++) {
      target_layer_bitrate_[i] = 0;
      effective_datarate_tl[i] = 0.0;
    }
    memset(&layer_id_, 0, sizeof(aom_svc_layer_id_t));
    memset(&svc_params_, 0, sizeof(aom_svc_params_t));
    memset(&ref_frame_config_, 0, sizeof(aom_svc_ref_frame_config_t));
  }

  virtual void PreEncodeFrameHook(::libaom_test::VideoSource *video,
                                  ::libaom_test::Encoder *encoder) {
    int spatial_layer_id = 0;
    if (video->frame() == 0) {
      initialize_svc(number_temporal_layers_, number_spatial_layers_,
                     &svc_params_);
      encoder->Control(AV1E_SET_SVC_PARAMS, &svc_params_);
      encoder->Control(AV1E_SET_ENABLE_ORDER_HINT, 0);
      encoder->Control(AV1E_SET_ENABLE_TPL_MODEL, 0);
      encoder->Control(AV1E_SET_DELTAQ_MODE, 0);
    }
    if (number_spatial_layers_ == 2) {
      spatial_layer_id = (layer_frame_cnt_ % 2 == 0) ? 0 : 1;
    } else if (number_spatial_layers_ == 3) {
      spatial_layer_id = (layer_frame_cnt_ % 3 == 0)
                             ? 0
                             : ((layer_frame_cnt_ - 1) % 3 == 0) ? 1 : 2;
    }
    // Set the reference/update flags, layer_id, and reference_map
    // buffer index.
    frame_flags_ = set_layer_pattern(video->frame(), &layer_id_,
                                     &ref_frame_config_, spatial_layer_id);
    encoder->Control(AV1E_SET_SVC_LAYER_ID, &layer_id_);
    encoder->Control(AV1E_SET_SVC_REF_FRAME_CONFIG, &ref_frame_config_);
    layer_frame_cnt_++;
    DatarateTest::PreEncodeFrameHook(video, encoder);
  }

  virtual void FramePktHook(const aom_codec_cx_pkt_t *pkt) {
    const size_t frame_size_in_bits = pkt->data.frame.sz * 8;
    // Update the layer cumulative  bitrate.
    for (int i = layer_id_.temporal_layer_id; i < number_temporal_layers_;
         i++) {
      int layer = layer_id_.spatial_layer_id * number_temporal_layers_ + i;
      effective_datarate_tl[layer] += 1.0 * frame_size_in_bits;
    }
    if (layer_id_.spatial_layer_id == number_spatial_layers_ - 1) {
      last_pts_ = pkt->data.frame.pts;
      superframe_cnt_++;
    }
  }

  virtual void EndPassHook(void) {
    duration_ = ((last_pts_ + 1) * timebase_);
    for (int i = 0; i < number_temporal_layers_ * number_spatial_layers_; i++) {
      effective_datarate_tl[i] = (effective_datarate_tl[i] / 1000) / duration_;
    }
  }

  // Layer pattern configuration.
  virtual int set_layer_pattern(int frame_cnt, aom_svc_layer_id_t *layer_id,
                                aom_svc_ref_frame_config_t *ref_frame_config,
                                int spatial_layer) {
    layer_id->spatial_layer_id = spatial_layer;
    // Set the referende map buffer idx for the 7 references:
    // LAST_FRAME (0), LAST2_FRAME(1), LAST3_FRAME(2), GOLDEN_FRAME(3),
    // BWDREF_FRAME(4), ALTREF2_FRAME(5), ALTREF_FRAME(6).
    for (int i = 0; i < INTER_REFS_PER_FRAME; i++) {
      ref_frame_config->ref_idx[i] = i;
      ref_frame_config->reference[i] = 0;
    }
    for (int i = 0; i < REF_FRAMES; i++) ref_frame_config->refresh[i] = 0;
    // Set layer_flags to 0 when using ref_frame_config->reference.
    int layer_flags = 0;
    // Always reference LAST.
    ref_frame_config->reference[0] = 1;
    if (number_temporal_layers_ == 3 && number_spatial_layers_ == 1) {
      // 3-layer:
      //   1    3   5    7
      //     2        6
      // 0        4        8
      if (frame_cnt % 4 == 0) {
        // Base layer.
        layer_id->temporal_layer_id = 0;
        // Update LAST on layer 0, reference LAST and GF.
        ref_frame_config->refresh[0] = 1;
        ref_frame_config->reference[3] = 1;
      } else if ((frame_cnt - 1) % 4 == 0) {
        layer_id->temporal_layer_id = 2;
        // First top layer: no updates, only reference LAST (TL0).
      } else if ((frame_cnt - 2) % 4 == 0) {
        layer_id->temporal_layer_id = 1;
        // Middle layer (TL1): update LAST2, only reference LAST (TL0).
        ref_frame_config->refresh[1] = 1;
      } else if ((frame_cnt - 3) % 4 == 0) {
        layer_id->temporal_layer_id = 2;
        // Second top layer: no updates, only reference LAST.
        // Set buffer idx for LAST to slot 1, since that was the slot
        // updated in previous frame. So LAST is TL1 frame.
        ref_frame_config->ref_idx[0] = 1;
        ref_frame_config->ref_idx[1] = 0;
      }
    } else if (number_temporal_layers_ == 1 && number_spatial_layers_ == 2) {
      layer_id->temporal_layer_id = 0;
      if (layer_id->spatial_layer_id == 0) {
        // Reference LAST, update LAST. Keep LAST and GOLDEN in slots 0 and 3.
        ref_frame_config->ref_idx[0] = 0;
        ref_frame_config->ref_idx[3] = 3;
        ref_frame_config->refresh[0] = 1;
      } else if (layer_id->spatial_layer_id == 1) {
        // Reference LAST and GOLDEN. Set buffer_idx for LAST to slot 3
        // and GOLDEN to slot 0. Update slot 3 (LAST).
        ref_frame_config->ref_idx[0] = 3;
        ref_frame_config->ref_idx[3] = 0;
        ref_frame_config->refresh[3] = 1;
      }
      // Reference GOLDEN.
      if (layer_id->spatial_layer_id > 0) ref_frame_config->reference[3] = 1;
    } else if (number_temporal_layers_ == 1 && number_spatial_layers_ == 3) {
      // 3 spatial layers, 1 temporal.
      // Note for this case , we set the buffer idx for all references to be
      // either LAST or GOLDEN, which are always valid references, since decoder
      // will check if any of the 7 references is valid scale in
      // valid_ref_frame_size().
      layer_id->temporal_layer_id = 0;
      if (layer_id->spatial_layer_id == 0) {
        // Reference LAST, update LAST. Set all other buffer_idx to 0.
        for (int i = 0; i < 7; i++) ref_frame_config->ref_idx[i] = 0;
        ref_frame_config->refresh[0] = 1;
      } else if (layer_id->spatial_layer_id == 1) {
        // Reference LAST and GOLDEN. Set buffer_idx for LAST to slot 1
        // and GOLDEN (and all other refs) to slot 0.
        // Update slot 1 (LAST).
        for (int i = 0; i < 7; i++) ref_frame_config->ref_idx[i] = 0;
        ref_frame_config->ref_idx[0] = 1;
        ref_frame_config->refresh[1] = 1;
      } else if (layer_id->spatial_layer_id == 2) {
        // Reference LAST and GOLDEN. Set buffer_idx for LAST to slot 2
        // and GOLDEN (and all other refs) to slot 1.
        // Update slot 2 (LAST).
        for (int i = 0; i < 7; i++) ref_frame_config->ref_idx[i] = 1;
        ref_frame_config->ref_idx[0] = 2;
        ref_frame_config->refresh[2] = 1;
      }
      // Reference GOLDEN.
      if (layer_id->spatial_layer_id > 0) ref_frame_config->reference[3] = 1;
    } else if (number_temporal_layers_ == 3 && number_spatial_layers_ == 3) {
      // 3 spatial and 3 temporal layer.
      if (superframe_cnt_ % 4 == 0) {
        // Base temporal layer.
        layer_id->temporal_layer_id = 0;
        if (layer_id->spatial_layer_id == 0) {
          // Reference LAST, update LAST.
          // Set all buffer_idx to 0.
          for (int i = 0; i < 7; i++) ref_frame_config->ref_idx[i] = 0;
          ref_frame_config->refresh[0] = 1;
        } else if (layer_id->spatial_layer_id == 1) {
          // Reference LAST and GOLDEN. Set buffer_idx for LAST to slot 1,
          // GOLDEN (and all other refs) to slot 0.
          // Update slot 1 (LAST).
          for (int i = 0; i < 7; i++) ref_frame_config->ref_idx[i] = 0;
          ref_frame_config->ref_idx[0] = 1;
          ref_frame_config->refresh[1] = 1;
        } else if (layer_id->spatial_layer_id == 2) {
          // Reference LAST and GOLDEN. Set buffer_idx for LAST to slot 2,
          // GOLDEN (and all other refs) to slot 1.
          // Update slot 2 (LAST).
          for (int i = 0; i < 7; i++) ref_frame_config->ref_idx[i] = 1;
          ref_frame_config->ref_idx[0] = 2;
          ref_frame_config->refresh[2] = 1;
        }
      } else if ((superframe_cnt_ - 1) % 4 == 0) {
        // First top temporal enhancement layer.
        layer_id->temporal_layer_id = 2;
        if (layer_id->spatial_layer_id == 0) {
          // Reference LAST (slot 0).
          // Set GOLDEN to slot 3 and update slot 3.
          // Set all other buffer_idx to slot 0.
          for (int i = 0; i < 7; i++) ref_frame_config->ref_idx[i] = 0;
          ref_frame_config->ref_idx[3] = 3;
          ref_frame_config->refresh[3] = 1;
        } else if (layer_id->spatial_layer_id == 1) {
          // Reference LAST and GOLDEN. Set buffer_idx for LAST to slot 1,
          // GOLDEN (and all other refs) to slot 3.
          // Set LAST2 to slot 4 and Update slot 4.
          for (int i = 0; i < 7; i++) ref_frame_config->ref_idx[i] = 3;
          ref_frame_config->ref_idx[0] = 1;
          ref_frame_config->ref_idx[1] = 4;
          ref_frame_config->refresh[4] = 1;
        } else if (layer_id->spatial_layer_id == 2) {
          // Reference LAST and GOLDEN. Set buffer_idx for LAST to slot 2,
          // GOLDEN (and all other refs) to slot 4.
          // No update.
          for (int i = 0; i < 7; i++) ref_frame_config->ref_idx[i] = 4;
          ref_frame_config->ref_idx[0] = 2;
        }
      } else if ((superframe_cnt_ - 2) % 4 == 0) {
        // Middle temporal enhancement layer.
        layer_id->temporal_layer_id = 1;
        if (layer_id->spatial_layer_id == 0) {
          // Reference LAST.
          // Set all buffer_idx to 0.
          // Set GOLDEN to slot 5 and update slot 5.
          for (int i = 0; i < 7; i++) ref_frame_config->ref_idx[i] = 0;
          ref_frame_config->ref_idx[3] = 5;
          ref_frame_config->refresh[5] = 1;
        } else if (layer_id->spatial_layer_id == 1) {
          // Reference LAST and GOLDEN. Set buffer_idx for LAST to slot 1,
          // GOLDEN (and all other refs) to slot 5.
          // Set LAST2 to slot 6 and update slot 6.
          for (int i = 0; i < 7; i++) ref_frame_config->ref_idx[i] = 5;
          ref_frame_config->ref_idx[0] = 1;
          ref_frame_config->ref_idx[2] = 6;
          ref_frame_config->refresh[6] = 1;
        } else if (layer_id->spatial_layer_id == 2) {
          // Reference LAST and GOLDEN. Set buffer_idx for LAST to slot 2,
          // GOLDEN (and all other refs) to slot 6.
          // Set LAST2 to slot 6 and update slot 7.
          for (int i = 0; i < 7; i++) ref_frame_config->ref_idx[i] = 6;
          ref_frame_config->ref_idx[0] = 2;
          ref_frame_config->ref_idx[2] = 7;
          ref_frame_config->refresh[7] = 1;
        }
      } else if ((superframe_cnt_ - 3) % 4 == 0) {
        // Second top temporal enhancement layer.
        layer_id->temporal_layer_id = 2;
        if (layer_id->spatial_layer_id == 0) {
          // Set LAST to slot 5 and reference LAST.
          // Set GOLDEN to slot 3 and update slot 3.
          // Set all other buffer_idx to 0.
          for (int i = 0; i < 7; i++) ref_frame_config->ref_idx[i] = 0;
          ref_frame_config->ref_idx[0] = 5;
          ref_frame_config->ref_idx[3] = 3;
          ref_frame_config->refresh[3] = 1;
        } else if (layer_id->spatial_layer_id == 1) {
          // Reference LAST and GOLDEN. Set buffer_idx for LAST to slot 6,
          // GOLDEN to slot 3. Set LAST2 to slot 4 and update slot 4.
          for (int i = 0; i < 7; i++) ref_frame_config->ref_idx[i] = 0;
          ref_frame_config->ref_idx[0] = 6;
          ref_frame_config->ref_idx[3] = 3;
          ref_frame_config->ref_idx[1] = 4;
          ref_frame_config->refresh[4] = 1;
        } else if (layer_id->spatial_layer_id == 2) {
          // Reference LAST and GOLDEN. Set buffer_idx for LAST to slot 7,
          // GOLDEN to slot 4. No update.
          for (int i = 0; i < 7; i++) ref_frame_config->ref_idx[i] = 0;
          ref_frame_config->ref_idx[0] = 7;
          ref_frame_config->ref_idx[3] = 4;
        }
      }
      // Reference GOLDEN.
      if (layer_id->spatial_layer_id > 0) ref_frame_config->reference[3] = 1;
    }
    return layer_flags;
  }

  virtual void initialize_svc(int number_temporal_layers,
                              int number_spatial_layers,
                              aom_svc_params *svc_params) {
    svc_params->number_spatial_layers = number_spatial_layers;
    svc_params->number_temporal_layers = number_temporal_layers;
    for (int i = 0; i < number_temporal_layers * number_spatial_layers; ++i) {
      svc_params->max_quantizers[i] = 60;
      svc_params->min_quantizers[i] = 2;
      svc_params->layer_target_bitrate[i] = target_layer_bitrate_[i];
    }
    // Do at most 3 spatial or temporal layers here.
    svc_params->framerate_factor[0] = 1;
    if (number_temporal_layers == 2) {
      svc_params->framerate_factor[0] = 2;
      svc_params->framerate_factor[1] = 1;
    } else if (number_temporal_layers == 3) {
      svc_params->framerate_factor[0] = 4;
      svc_params->framerate_factor[1] = 2;
      svc_params->framerate_factor[2] = 1;
    }
    svc_params->scaling_factor_num[0] = 1;
    svc_params->scaling_factor_den[0] = 1;
    if (number_spatial_layers == 2) {
      svc_params->scaling_factor_num[0] = 1;
      svc_params->scaling_factor_den[0] = 2;
      svc_params->scaling_factor_num[1] = 1;
      svc_params->scaling_factor_den[1] = 1;
    } else if (number_spatial_layers == 3) {
      svc_params->scaling_factor_num[0] = 1;
      svc_params->scaling_factor_den[0] = 4;
      svc_params->scaling_factor_num[1] = 1;
      svc_params->scaling_factor_den[1] = 2;
      svc_params->scaling_factor_num[2] = 1;
      svc_params->scaling_factor_den[2] = 1;
    }
  }

  virtual void BasicRateTargetingSVC3TL1SLTest() {
    cfg_.rc_buf_initial_sz = 500;
    cfg_.rc_buf_optimal_sz = 500;
    cfg_.rc_buf_sz = 1000;
    cfg_.rc_dropframe_thresh = 0;
    cfg_.rc_min_quantizer = 0;
    cfg_.rc_max_quantizer = 63;
    cfg_.rc_end_usage = AOM_CBR;
    cfg_.g_lag_in_frames = 0;
    cfg_.g_error_resilient = 1;

    ::libaom_test::I420VideoSource video("hantro_collage_w352h288.yuv", 352,
                                         288, 30, 1, 0, 300);
    const int bitrate_array[2] = { 200, 550 };
    cfg_.rc_target_bitrate = bitrate_array[GET_PARAM(4)];
    ResetModel();
    number_temporal_layers_ = 3;
    target_layer_bitrate_[0] = 50 * cfg_.rc_target_bitrate / 100;
    target_layer_bitrate_[1] = 70 * cfg_.rc_target_bitrate / 100;
    target_layer_bitrate_[2] = cfg_.rc_target_bitrate;
    ASSERT_NO_FATAL_FAILURE(RunLoop(&video));
    for (int i = 0; i < number_temporal_layers_ * number_spatial_layers_; i++) {
      ASSERT_GE(effective_datarate_tl[i], target_layer_bitrate_[i] * 0.80)
          << " The datarate for the file is lower than target by too much!";
      ASSERT_LE(effective_datarate_tl[i], target_layer_bitrate_[i] * 1.30)
          << " The datarate for the file is greater than target by too much!";
    }
  }

  virtual void BasicRateTargetingSVC1TL2SLTest() {
    cfg_.rc_buf_initial_sz = 500;
    cfg_.rc_buf_optimal_sz = 500;
    cfg_.rc_buf_sz = 1000;
    cfg_.rc_dropframe_thresh = 0;
    cfg_.rc_min_quantizer = 0;
    cfg_.rc_max_quantizer = 63;
    cfg_.rc_end_usage = AOM_CBR;
    cfg_.g_lag_in_frames = 0;
    cfg_.g_error_resilient = 1;

    ::libaom_test::I420VideoSource video("hantro_collage_w352h288.yuv", 352,
                                         288, 30, 1, 0, 300);
    const int bitrate_array[2] = { 300, 600 };
    cfg_.rc_target_bitrate = bitrate_array[GET_PARAM(4)];
    ResetModel();
    number_temporal_layers_ = 1;
    number_spatial_layers_ = 2;
    target_layer_bitrate_[0] = 2 * cfg_.rc_target_bitrate / 4;
    target_layer_bitrate_[1] = 2 * cfg_.rc_target_bitrate / 4;
    ASSERT_NO_FATAL_FAILURE(RunLoop(&video));
    for (int i = 0; i < number_temporal_layers_ * number_spatial_layers_; i++) {
      ASSERT_GE(effective_datarate_tl[i], target_layer_bitrate_[i] * 0.80)
          << " The datarate for the file is lower than target by too much!";
      ASSERT_LE(effective_datarate_tl[i], target_layer_bitrate_[i] * 1.35)
          << " The datarate for the file is greater than target by too much!";
    }
  }

  virtual void BasicRateTargetingSVC1TL3SLTest() {
    cfg_.rc_buf_initial_sz = 500;
    cfg_.rc_buf_optimal_sz = 500;
    cfg_.rc_buf_sz = 1000;
    cfg_.rc_dropframe_thresh = 0;
    cfg_.rc_min_quantizer = 0;
    cfg_.rc_max_quantizer = 63;
    cfg_.rc_end_usage = AOM_CBR;
    cfg_.g_lag_in_frames = 0;
    cfg_.g_error_resilient = 1;

    ::libaom_test::I420VideoSource video("hantro_collage_w352h288.yuv", 352,
                                         288, 30, 1, 0, 300);
    const int bitrate_array[2] = { 500, 1000 };
    cfg_.rc_target_bitrate = bitrate_array[GET_PARAM(4)];
    ResetModel();
    number_temporal_layers_ = 1;
    number_spatial_layers_ = 3;
    target_layer_bitrate_[0] = 1 * cfg_.rc_target_bitrate / 8;
    target_layer_bitrate_[1] = 3 * cfg_.rc_target_bitrate / 8;
    target_layer_bitrate_[2] = 4 * cfg_.rc_target_bitrate / 8;
    ASSERT_NO_FATAL_FAILURE(RunLoop(&video));
    for (int i = 0; i < number_temporal_layers_ * number_spatial_layers_; i++) {
      ASSERT_GE(effective_datarate_tl[i], target_layer_bitrate_[i] * 0.80)
          << " The datarate for the file is lower than target by too much!";
      ASSERT_LE(effective_datarate_tl[i], target_layer_bitrate_[i] * 1.38)
          << " The datarate for the file is greater than target by too much!";
    }
  }

  virtual void BasicRateTargetingSVC3TL3SLTest() {
    cfg_.rc_buf_initial_sz = 500;
    cfg_.rc_buf_optimal_sz = 500;
    cfg_.rc_buf_sz = 1000;
    cfg_.rc_dropframe_thresh = 0;
    cfg_.rc_min_quantizer = 0;
    cfg_.rc_max_quantizer = 63;
    cfg_.rc_end_usage = AOM_CBR;
    cfg_.g_lag_in_frames = 0;
    cfg_.g_error_resilient = 1;

    ::libaom_test::I420VideoSource video("hantro_collage_w352h288.yuv", 352,
                                         288, 30, 1, 0, 300);
    const int bitrate_array[2] = { 600, 1200 };
    cfg_.rc_target_bitrate = bitrate_array[GET_PARAM(4)];
    ResetModel();
    number_temporal_layers_ = 3;
    number_spatial_layers_ = 3;
    // SL0
    const int bitrate_sl0 = 1 * cfg_.rc_target_bitrate / 8;
    target_layer_bitrate_[0] = 50 * bitrate_sl0 / 100;
    target_layer_bitrate_[1] = 70 * bitrate_sl0 / 100;
    target_layer_bitrate_[2] = bitrate_sl0;
    // SL1
    const int bitrate_sl1 = 3 * cfg_.rc_target_bitrate / 8;
    target_layer_bitrate_[3] = 50 * bitrate_sl1 / 100;
    target_layer_bitrate_[4] = 70 * bitrate_sl1 / 100;
    target_layer_bitrate_[5] = bitrate_sl1;
    // SL2
    const int bitrate_sl2 = 4 * cfg_.rc_target_bitrate / 8;
    target_layer_bitrate_[6] = 50 * bitrate_sl2 / 100;
    target_layer_bitrate_[7] = 70 * bitrate_sl2 / 100;
    target_layer_bitrate_[8] = bitrate_sl2;
    ASSERT_NO_FATAL_FAILURE(RunLoop(&video));
    for (int i = 0; i < number_temporal_layers_ * number_spatial_layers_; i++) {
      ASSERT_GE(effective_datarate_tl[i], target_layer_bitrate_[i] * 0.80)
          << " The datarate for the file is lower than target by too much!";
      ASSERT_LE(effective_datarate_tl[i], target_layer_bitrate_[i] * 1.38)
          << " The datarate for the file is greater than target by too much!";
    }
  }

  virtual void BasicRateTargetingSVC3TL3SLHDTest() {
    cfg_.rc_buf_initial_sz = 500;
    cfg_.rc_buf_optimal_sz = 500;
    cfg_.rc_buf_sz = 1000;
    cfg_.rc_dropframe_thresh = 0;
    cfg_.rc_min_quantizer = 0;
    cfg_.rc_max_quantizer = 63;
    cfg_.rc_end_usage = AOM_CBR;
    cfg_.g_lag_in_frames = 0;
    cfg_.g_error_resilient = 1;

    ::libaom_test::Y4mVideoSource video("niklas_1280_720_30.y4m", 0, 60);
    const int bitrate_array[2] = { 600, 1200 };
    cfg_.rc_target_bitrate = bitrate_array[GET_PARAM(4)];
    ResetModel();
    number_temporal_layers_ = 3;
    number_spatial_layers_ = 3;
    // SL0
    const int bitrate_sl0 = 1 * cfg_.rc_target_bitrate / 8;
    target_layer_bitrate_[0] = 50 * bitrate_sl0 / 100;
    target_layer_bitrate_[1] = 70 * bitrate_sl0 / 100;
    target_layer_bitrate_[2] = bitrate_sl0;
    // SL1
    const int bitrate_sl1 = 3 * cfg_.rc_target_bitrate / 8;
    target_layer_bitrate_[3] = 50 * bitrate_sl1 / 100;
    target_layer_bitrate_[4] = 70 * bitrate_sl1 / 100;
    target_layer_bitrate_[5] = bitrate_sl1;
    // SL2
    const int bitrate_sl2 = 4 * cfg_.rc_target_bitrate / 8;
    target_layer_bitrate_[6] = 50 * bitrate_sl2 / 100;
    target_layer_bitrate_[7] = 70 * bitrate_sl2 / 100;
    target_layer_bitrate_[8] = bitrate_sl2;
    ASSERT_NO_FATAL_FAILURE(RunLoop(&video));
    for (int i = 0; i < number_temporal_layers_ * number_spatial_layers_; i++) {
      ASSERT_GE(effective_datarate_tl[i], target_layer_bitrate_[i] * 0.70)
          << " The datarate for the file is lower than target by too much!";
      ASSERT_LE(effective_datarate_tl[i], target_layer_bitrate_[i] * 1.4)
          << " The datarate for the file is greater than target by too much!";
    }
  }

  virtual void BasicRateTargetingSVC3TL3SLKfTest() {
    cfg_.rc_buf_initial_sz = 500;
    cfg_.rc_buf_optimal_sz = 500;
    cfg_.rc_buf_sz = 1000;
    cfg_.rc_dropframe_thresh = 0;
    cfg_.rc_min_quantizer = 0;
    cfg_.rc_max_quantizer = 63;
    cfg_.rc_end_usage = AOM_CBR;
    cfg_.g_lag_in_frames = 0;
    cfg_.g_error_resilient = 1;
    cfg_.kf_mode = AOM_KF_AUTO;
    cfg_.kf_min_dist = cfg_.kf_max_dist = 100;

    ::libaom_test::I420VideoSource video("hantro_collage_w352h288.yuv", 352,
                                         288, 30, 1, 0, 300);
    const int bitrate_array[2] = { 600, 1200 };
    cfg_.rc_target_bitrate = bitrate_array[GET_PARAM(4)];
    ResetModel();
    number_temporal_layers_ = 3;
    number_spatial_layers_ = 3;
    // SL0
    const int bitrate_sl0 = 1 * cfg_.rc_target_bitrate / 8;
    target_layer_bitrate_[0] = 50 * bitrate_sl0 / 100;
    target_layer_bitrate_[1] = 70 * bitrate_sl0 / 100;
    target_layer_bitrate_[2] = bitrate_sl0;
    // SL1
    const int bitrate_sl1 = 3 * cfg_.rc_target_bitrate / 8;
    target_layer_bitrate_[3] = 50 * bitrate_sl1 / 100;
    target_layer_bitrate_[4] = 70 * bitrate_sl1 / 100;
    target_layer_bitrate_[5] = bitrate_sl1;
    // SL2
    const int bitrate_sl2 = 4 * cfg_.rc_target_bitrate / 8;
    target_layer_bitrate_[6] = 50 * bitrate_sl2 / 100;
    target_layer_bitrate_[7] = 70 * bitrate_sl2 / 100;
    target_layer_bitrate_[8] = bitrate_sl2;
    ASSERT_NO_FATAL_FAILURE(RunLoop(&video));
    for (int i = 0; i < number_temporal_layers_ * number_spatial_layers_; i++) {
      ASSERT_GE(effective_datarate_tl[i], target_layer_bitrate_[i] * 0.75)
          << " The datarate for the file is lower than target by too much!";
      ASSERT_LE(effective_datarate_tl[i], target_layer_bitrate_[i] * 1.4)
          << " The datarate for the file is greater than target by too much!";
    }
  }

  int layer_frame_cnt_;
  int superframe_cnt_;
  int number_temporal_layers_;
  int number_spatial_layers_;
  // Allow for up to 3 temporal layers.
  int target_layer_bitrate_[AOM_MAX_LAYERS];
  aom_svc_params_t svc_params_;
  aom_svc_ref_frame_config_t ref_frame_config_;
  aom_svc_layer_id_t layer_id_;
  double effective_datarate_tl[AOM_MAX_LAYERS];
};

// Check basic rate targeting for CBR, for 3 temporal layers, 1 spatial.
TEST_P(DatarateTestSVC, BasicRateTargetingSVC3TL1SL) {
  BasicRateTargetingSVC3TL1SLTest();
}

// Check basic rate targeting for CBR, for 2 spatial layers, 1 temporal.
TEST_P(DatarateTestSVC, BasicRateTargetingSVC1TL2SL) {
  BasicRateTargetingSVC1TL2SLTest();
}

// Check basic rate targeting for CBR, for 3 spatial layers, 1 temporal.
TEST_P(DatarateTestSVC, BasicRateTargetingSVC1TL3SL) {
  BasicRateTargetingSVC1TL3SLTest();
}

// Check basic rate targeting for CBR, for 3 spatial, 3 temporal layers.
TEST_P(DatarateTestSVC, BasicRateTargetingSVC3TL3SL) {
  BasicRateTargetingSVC3TL3SLTest();
}

// Check basic rate targeting for CBR, for 3 spatial, 3 temporal layers.
TEST_P(DatarateTestSVC, BasicRateTargetingSVC3TL3SLHD) {
  BasicRateTargetingSVC3TL3SLHDTest();
}

// Check basic rate targeting for CBR, for 3 spatial, 3 temporal layers,
// for auto key frame mode with short key frame period.
TEST_P(DatarateTestSVC, BasicRateTargetingSVC3TL3SLKf) {
  BasicRateTargetingSVC3TL3SLKfTest();
}

AV1_INSTANTIATE_TEST_CASE(DatarateTestSVC,
                          ::testing::Values(::libaom_test::kRealTime),
                          ::testing::Range(7, 9),
                          ::testing::Range<unsigned int>(0, 4),
                          ::testing::Values(0, 1));

}  // namespace
}  // namespace datarate_test
