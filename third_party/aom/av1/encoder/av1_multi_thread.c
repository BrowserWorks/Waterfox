/*
 * Copyright (c) 2018, Alliance for Open Media. All rights reserved
 *
 * This source code is subject to the terms of the BSD 2 Clause License and
 * the Alliance for Open Media Patent License 1.0. If the BSD 2 Clause License
 * was not distributed with this source code in the LICENSE file, you can
 * obtain it at www.aomedia.org/license/software. If the Alliance for Open
 * Media Patent License 1.0 was not distributed with this source code in the
 * PATENTS file, you can obtain it at www.aomedia.org/license/patent.
 */

#include <assert.h>

#include "av1/encoder/encoder.h"
#include "av1/encoder/ethread.h"
#include "av1/encoder/av1_multi_thread.h"

void av1_row_mt_mem_alloc(AV1_COMP *cpi, int max_sb_rows) {
  struct AV1Common *cm = &cpi->common;
  MultiThreadHandle *multi_thread_ctxt = &cpi->multi_thread_ctxt;
  int tile_row, tile_col;
  const int tile_cols = cm->tiles.cols;
  const int tile_rows = cm->tiles.rows;

  multi_thread_ctxt->allocated_tile_cols = tile_cols;
  multi_thread_ctxt->allocated_tile_rows = tile_rows;
  multi_thread_ctxt->allocated_sb_rows = max_sb_rows;

  // Allocate memory for row based multi-threading
  for (tile_row = 0; tile_row < multi_thread_ctxt->allocated_tile_rows;
       tile_row++) {
    for (tile_col = 0; tile_col < multi_thread_ctxt->allocated_tile_cols;
         tile_col++) {
      TileDataEnc *this_tile =
          &cpi->tile_data[tile_row * multi_thread_ctxt->allocated_tile_cols +
                          tile_col];
      av1_row_mt_sync_mem_alloc(&this_tile->row_mt_sync, cm, max_sb_rows);
      if (cpi->oxcf.cdf_update_mode)
        CHECK_MEM_ERROR(
            cm, this_tile->row_ctx,
            (FRAME_CONTEXT *)aom_memalign(
                16,
                AOMMAX(1, (av1_get_sb_cols_in_tile(cm, this_tile->tile_info) -
                           1)) *
                    sizeof(*this_tile->row_ctx)));
    }
  }
}

void av1_row_mt_mem_dealloc(AV1_COMP *cpi) {
  MultiThreadHandle *multi_thread_ctxt = &cpi->multi_thread_ctxt;
  int tile_col;
  int tile_row;

  // Free row based multi-threading sync memory
  for (tile_row = 0; tile_row < multi_thread_ctxt->allocated_tile_rows;
       tile_row++) {
    for (tile_col = 0; tile_col < multi_thread_ctxt->allocated_tile_cols;
         tile_col++) {
      TileDataEnc *this_tile =
          &cpi->tile_data[tile_row * multi_thread_ctxt->allocated_tile_cols +
                          tile_col];
      av1_row_mt_sync_mem_dealloc(&this_tile->row_mt_sync);
      if (cpi->oxcf.cdf_update_mode) aom_free(this_tile->row_ctx);
    }
  }
  multi_thread_ctxt->allocated_sb_rows = 0;
  multi_thread_ctxt->allocated_tile_cols = 0;
  multi_thread_ctxt->allocated_tile_rows = 0;
}
