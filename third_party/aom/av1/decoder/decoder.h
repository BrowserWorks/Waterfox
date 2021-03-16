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

#ifndef AOM_AV1_DECODER_DECODER_H_
#define AOM_AV1_DECODER_DECODER_H_

#include "config/aom_config.h"

#include "aom/aom_codec.h"
#include "aom_dsp/bitreader.h"
#include "aom_scale/yv12config.h"
#include "aom_util/aom_thread.h"

#include "av1/common/av1_common_int.h"
#include "av1/common/thread_common.h"
#include "av1/decoder/dthread.h"
#if CONFIG_ACCOUNTING
#include "av1/decoder/accounting.h"
#endif
#if CONFIG_INSPECTION
#include "av1/decoder/inspection.h"
#endif

#ifdef __cplusplus
extern "C" {
#endif

typedef void (*decode_block_visitor_fn_t)(const AV1_COMMON *const cm,
                                          MACROBLOCKD *const xd,
                                          aom_reader *const r, const int plane,
                                          const int row, const int col,
                                          const TX_SIZE tx_size);

typedef void (*predict_inter_block_visitor_fn_t)(AV1_COMMON *const cm,
                                                 MACROBLOCKD *const xd,
                                                 BLOCK_SIZE bsize);

typedef void (*cfl_store_inter_block_visitor_fn_t)(AV1_COMMON *const cm,
                                                   MACROBLOCKD *const xd);

typedef struct ThreadData {
  DECLARE_ALIGNED(32, MACROBLOCKD, xd);
  CB_BUFFER cb_buffer_base;
  aom_reader *bit_reader;
  uint8_t *mc_buf[2];
  int32_t mc_buf_size;
  int mc_buf_use_highbd;  // Boolean: whether the byte pointers stored in
                          // mc_buf were converted from highbd pointers.

  CONV_BUF_TYPE *tmp_conv_dst;
  uint8_t *tmp_obmc_bufs[2];

  decode_block_visitor_fn_t read_coeffs_tx_intra_block_visit;
  decode_block_visitor_fn_t predict_and_recon_intra_block_visit;
  decode_block_visitor_fn_t read_coeffs_tx_inter_block_visit;
  decode_block_visitor_fn_t inverse_tx_inter_block_visit;
  predict_inter_block_visitor_fn_t predict_inter_block_visit;
  cfl_store_inter_block_visitor_fn_t cfl_store_inter_block_visit;
} ThreadData;

typedef struct AV1DecRowMTJobInfo {
  int tile_row;
  int tile_col;
  int mi_row;
} AV1DecRowMTJobInfo;

typedef struct AV1DecRowMTSyncData {
#if CONFIG_MULTITHREAD
  pthread_mutex_t *mutex_;
  pthread_cond_t *cond_;
#endif
  int allocated_sb_rows;
  int *cur_sb_col;
  int sync_range;
  int mi_rows;
  int mi_cols;
  int mi_rows_parse_done;
  int mi_rows_decode_started;
  int num_threads_working;
} AV1DecRowMTSync;

typedef struct AV1DecRowMTInfo {
  int tile_rows_start;
  int tile_rows_end;
  int tile_cols_start;
  int tile_cols_end;
  int start_tile;
  int end_tile;
  int mi_rows_to_decode;

  // Invariant:
  //   mi_rows_parse_done >= mi_rows_decode_started.
  // mi_rows_parse_done and mi_rows_decode_started are both initialized to 0.
  // mi_rows_parse_done is incremented freely. mi_rows_decode_started may only
  // be incremented to catch up with mi_rows_parse_done but is not allowed to
  // surpass mi_rows_parse_done.
  //
  // When mi_rows_decode_started reaches mi_rows_to_decode, there are no more
  // decode jobs.

  // Indicates the progress of the bit-stream parsing of superblocks.
  // Initialized to 0. Incremented by sb_mi_size when parse sb row is done.
  int mi_rows_parse_done;
  // Indicates the progress of the decoding of superblocks.
  // Initialized to 0. Incremented by sb_mi_size when decode sb row is started.
  int mi_rows_decode_started;
  // Boolean: Initialized to 0 (false). Set to 1 (true) on error to abort
  // decoding.
  int row_mt_exit;
} AV1DecRowMTInfo;

typedef struct TileDataDec {
  TileInfo tile_info;
  aom_reader bit_reader;
  DECLARE_ALIGNED(16, FRAME_CONTEXT, tctx);
  AV1DecRowMTSync dec_row_mt_sync;
} TileDataDec;

typedef struct TileBufferDec {
  const uint8_t *data;
  size_t size;
} TileBufferDec;

typedef struct DataBuffer {
  const uint8_t *data;
  size_t size;
} DataBuffer;

typedef struct EXTERNAL_REFERENCES {
  YV12_BUFFER_CONFIG refs[MAX_EXTERNAL_REFERENCES];
  int num;
} EXTERNAL_REFERENCES;

typedef struct TileJobsDec {
  TileBufferDec *tile_buffer;
  TileDataDec *tile_data;
} TileJobsDec;

typedef struct AV1DecTileMTData {
#if CONFIG_MULTITHREAD
  pthread_mutex_t *job_mutex;
#endif
  TileJobsDec *job_queue;
  int jobs_enqueued;
  int jobs_dequeued;
  int alloc_tile_rows;
  int alloc_tile_cols;
} AV1DecTileMT;

typedef struct AV1Decoder {
  DECLARE_ALIGNED(32, MACROBLOCKD, mb);

  DECLARE_ALIGNED(32, AV1_COMMON, common);

  AVxWorker lf_worker;
  AV1LfSync lf_row_sync;
  AV1LrSync lr_row_sync;
  AV1LrStruct lr_ctxt;
  AVxWorker *tile_workers;
  int num_workers;
  DecWorkerData *thread_data;
  ThreadData td;
  TileDataDec *tile_data;
  int allocated_tiles;

  TileBufferDec tile_buffers[MAX_TILE_ROWS][MAX_TILE_COLS];
  AV1DecTileMT tile_mt_info;

  // Each time the decoder is called, we expect to receive a full temporal unit.
  // This can contain up to one shown frame per spatial layer in the current
  // operating point (note that some layers may be entirely omitted).
  // If the 'output_all_layers' option is true, we save all of these shown
  // frames so that they can be returned to the application. If the
  // 'output_all_layers' option is false, then we only output one image per
  // temporal unit.
  //
  // Note: The saved buffers are released at the start of the next time the
  // application calls aom_codec_decode().
  int output_all_layers;
  RefCntBuffer *output_frames[MAX_NUM_SPATIAL_LAYERS];
  size_t num_output_frames;  // How many frames are queued up so far?

  // In order to properly support random-access decoding, we need
  // to behave slightly differently for the very first frame we decode.
  // So we track whether this is the first frame or not.
  int decoding_first_frame;

  int allow_lowbitdepth;
  int max_threads;
  int inv_tile_order;
  int need_resync;  // wait for key/intra-only frame.
  int reset_decoder_state;

  int tile_size_bytes;
  int tile_col_size_bytes;
  int dec_tile_row, dec_tile_col;  // always -1 for non-VR tile encoding
#if CONFIG_ACCOUNTING
  int acct_enabled;
  Accounting accounting;
#endif
  int sequence_header_ready;
  int sequence_header_changed;
#if CONFIG_INSPECTION
  aom_inspect_cb inspect_cb;
  void *inspect_ctx;
#endif
  int operating_point;
  int current_operating_point;
  int seen_frame_header;
  // The expected start_tile (tg_start syntax element) of the next tile group.
  int next_start_tile;

  // State if the camera frame header is already decoded while
  // large_scale_tile = 1.
  int camera_frame_header_ready;
  size_t frame_header_size;
  DataBuffer obu_size_hdr;
  int output_frame_width_in_tiles_minus_1;
  int output_frame_height_in_tiles_minus_1;
  int tile_count_minus_1;
  uint32_t coded_tile_data_size;
  unsigned int ext_tile_debug;  // for ext-tile software debug & testing
  unsigned int row_mt;
  EXTERNAL_REFERENCES ext_refs;
  YV12_BUFFER_CONFIG tile_list_outbuf;

  CB_BUFFER *cb_buffer_base;
  int cb_buffer_alloc_size;

  int allocated_row_mt_sync_rows;

#if CONFIG_MULTITHREAD
  pthread_mutex_t *row_mt_mutex_;
  pthread_cond_t *row_mt_cond_;
#endif

  AV1DecRowMTInfo frame_row_mt_info;
  aom_metadata_array_t *metadata;

  int context_update_tile_id;
  int skip_loop_filter;
  int skip_film_grain;
  int is_annexb;
  int valid_for_referencing[REF_FRAMES];
} AV1Decoder;

// Returns 0 on success. Sets pbi->common.error.error_code to a nonzero error
// code and returns a nonzero value on failure.
int av1_receive_compressed_data(struct AV1Decoder *pbi, size_t size,
                                const uint8_t **psource);

// Get the frame at a particular index in the output queue
int av1_get_raw_frame(AV1Decoder *pbi, size_t index, YV12_BUFFER_CONFIG **sd,
                      aom_film_grain_t **grain_params);

int av1_get_frame_to_show(struct AV1Decoder *pbi, YV12_BUFFER_CONFIG *frame);

aom_codec_err_t av1_copy_reference_dec(struct AV1Decoder *pbi, int idx,
                                       YV12_BUFFER_CONFIG *sd);

aom_codec_err_t av1_set_reference_dec(AV1_COMMON *cm, int idx,
                                      int use_external_ref,
                                      YV12_BUFFER_CONFIG *sd);
aom_codec_err_t av1_copy_new_frame_dec(AV1_COMMON *cm,
                                       YV12_BUFFER_CONFIG *new_frame,
                                       YV12_BUFFER_CONFIG *sd);

struct AV1Decoder *av1_decoder_create(BufferPool *const pool);

void av1_decoder_remove(struct AV1Decoder *pbi);
void av1_dealloc_dec_jobs(struct AV1DecTileMTData *tile_mt_info);

void av1_dec_row_mt_dealloc(AV1DecRowMTSync *dec_row_mt_sync);

void av1_dec_free_cb_buf(AV1Decoder *pbi);

static INLINE void decrease_ref_count(RefCntBuffer *const buf,
                                      BufferPool *const pool) {
  if (buf != NULL) {
    --buf->ref_count;
    // Reference counts should never become negative. If this assertion fails,
    // there is a bug in our reference count management.
    assert(buf->ref_count >= 0);
    // A worker may only get a free framebuffer index when calling get_free_fb.
    // But the raw frame buffer is not set up until we finish decoding header.
    // So if any error happens during decoding header, frame_bufs[idx] will not
    // have a valid raw frame buffer.
    if (buf->ref_count == 0 && buf->raw_frame_buffer.data) {
      pool->release_fb_cb(pool->cb_priv, &buf->raw_frame_buffer);
      buf->raw_frame_buffer.data = NULL;
      buf->raw_frame_buffer.size = 0;
      buf->raw_frame_buffer.priv = NULL;
    }
  }
}

#define ACCT_STR __func__
static INLINE int av1_read_uniform(aom_reader *r, int n) {
  const int l = get_unsigned_bits(n);
  const int m = (1 << l) - n;
  const int v = aom_read_literal(r, l - 1, ACCT_STR);
  assert(l != 0);
  if (v < m)
    return v;
  else
    return (v << 1) - m + aom_read_literal(r, 1, ACCT_STR);
}

typedef void (*palette_visitor_fn_t)(MACROBLOCKD *const xd, int plane,
                                     aom_reader *r);

void av1_visit_palette(AV1Decoder *const pbi, MACROBLOCKD *const xd,
                       aom_reader *r, palette_visitor_fn_t visit);

typedef void (*block_visitor_fn_t)(AV1Decoder *const pbi, ThreadData *const td,
                                   int mi_row, int mi_col, aom_reader *r,
                                   PARTITION_TYPE partition, BLOCK_SIZE bsize);

#ifdef __cplusplus
}  // extern "C"
#endif

#endif  // AOM_AV1_DECODER_DECODER_H_
