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

#include "av1/encoder/encodeframe.h"
#include "av1/encoder/encoder.h"
#include "av1/encoder/ethread.h"
#include "aom_dsp/aom_dsp_common.h"

static void accumulate_rd_opt(ThreadData *td, ThreadData *td_t) {
  int i, j, k, l, m, n;

  for (i = 0; i < REFERENCE_MODES; i++)
    td->rd_counts.comp_pred_diff[i] += td_t->rd_counts.comp_pred_diff[i];

#if CONFIG_GLOBAL_MOTION
  for (i = 0; i < TOTAL_REFS_PER_FRAME; i++)
    td->rd_counts.global_motion_used[i] +=
        td_t->rd_counts.global_motion_used[i];
#endif  // CONFIG_GLOBAL_MOTION

  for (i = 0; i < TX_SIZES; i++)
    for (j = 0; j < PLANE_TYPES; j++)
      for (k = 0; k < REF_TYPES; k++)
        for (l = 0; l < COEF_BANDS; l++)
          for (m = 0; m < COEFF_CONTEXTS; m++)
            for (n = 0; n < ENTROPY_TOKENS; n++)
              td->rd_counts.coef_counts[i][j][k][l][m][n] +=
                  td_t->rd_counts.coef_counts[i][j][k][l][m][n];
}

static int enc_worker_hook(EncWorkerData *const thread_data, void *unused) {
  AV1_COMP *const cpi = thread_data->cpi;
  const AV1_COMMON *const cm = &cpi->common;
  const int tile_cols = cm->tile_cols;
  const int tile_rows = cm->tile_rows;
  int t;

  (void)unused;

  for (t = thread_data->start; t < tile_rows * tile_cols;
       t += cpi->num_workers) {
    int tile_row = t / tile_cols;
    int tile_col = t % tile_cols;

    av1_encode_tile(cpi, thread_data->td, tile_row, tile_col);
  }

  return 0;
}

void av1_encode_tiles_mt(AV1_COMP *cpi) {
  AV1_COMMON *const cm = &cpi->common;
  const int tile_cols = cm->tile_cols;
  const AVxWorkerInterface *const winterface = aom_get_worker_interface();
  const int num_workers = AOMMIN(cpi->oxcf.max_threads, tile_cols);
  int i;

  av1_init_tile_data(cpi);

  // Only run once to create threads and allocate thread data.
  if (cpi->num_workers == 0) {
    CHECK_MEM_ERROR(cm, cpi->workers,
                    aom_malloc(num_workers * sizeof(*cpi->workers)));

    CHECK_MEM_ERROR(cm, cpi->tile_thr_data,
                    aom_calloc(num_workers, sizeof(*cpi->tile_thr_data)));

    for (i = 0; i < num_workers; i++) {
      AVxWorker *const worker = &cpi->workers[i];
      EncWorkerData *const thread_data = &cpi->tile_thr_data[i];

      ++cpi->num_workers;
      winterface->init(worker);

      thread_data->cpi = cpi;

      if (i < num_workers - 1) {
        // Allocate thread data.
        CHECK_MEM_ERROR(cm, thread_data->td,
                        aom_memalign(32, sizeof(*thread_data->td)));
        av1_zero(*thread_data->td);

        // Set up pc_tree.
        thread_data->td->leaf_tree = NULL;
        thread_data->td->pc_tree = NULL;
        av1_setup_pc_tree(cm, thread_data->td);

#if CONFIG_MOTION_VAR
#if CONFIG_HIGHBITDEPTH
        int buf_scaler = 2;
#else
        int buf_scaler = 1;
#endif
        CHECK_MEM_ERROR(cm, thread_data->td->above_pred_buf,
                        (uint8_t *)aom_memalign(
                            16, buf_scaler * MAX_MB_PLANE * MAX_SB_SQUARE *
                                    sizeof(*thread_data->td->above_pred_buf)));
        CHECK_MEM_ERROR(cm, thread_data->td->left_pred_buf,
                        (uint8_t *)aom_memalign(
                            16, buf_scaler * MAX_MB_PLANE * MAX_SB_SQUARE *
                                    sizeof(*thread_data->td->left_pred_buf)));
        CHECK_MEM_ERROR(
            cm, thread_data->td->wsrc_buf,
            (int32_t *)aom_memalign(
                16, MAX_SB_SQUARE * sizeof(*thread_data->td->wsrc_buf)));
        CHECK_MEM_ERROR(
            cm, thread_data->td->mask_buf,
            (int32_t *)aom_memalign(
                16, MAX_SB_SQUARE * sizeof(*thread_data->td->mask_buf)));
#endif
        // Allocate frame counters in thread data.
        CHECK_MEM_ERROR(cm, thread_data->td->counts,
                        aom_calloc(1, sizeof(*thread_data->td->counts)));

#if CONFIG_PALETTE
        // Allocate buffers used by palette coding mode.
        if (cpi->common.allow_screen_content_tools) {
          CHECK_MEM_ERROR(
              cm, thread_data->td->palette_buffer,
              aom_memalign(16, sizeof(*thread_data->td->palette_buffer)));
        }
#endif  // CONFIG_PALETTE

        // Create threads
        if (!winterface->reset(worker))
          aom_internal_error(&cm->error, AOM_CODEC_ERROR,
                             "Tile encoder thread creation failed");
      } else {
        // Main thread acts as a worker and uses the thread data in cpi.
        thread_data->td = &cpi->td;
      }

      winterface->sync(worker);
    }
  }

  for (i = 0; i < num_workers; i++) {
    AVxWorker *const worker = &cpi->workers[i];
    EncWorkerData *thread_data;

    worker->hook = (AVxWorkerHook)enc_worker_hook;
    worker->data1 = &cpi->tile_thr_data[i];
    worker->data2 = NULL;
    thread_data = (EncWorkerData *)worker->data1;

    // Before encoding a frame, copy the thread data from cpi.
    if (thread_data->td != &cpi->td) {
      thread_data->td->mb = cpi->td.mb;
      thread_data->td->rd_counts = cpi->td.rd_counts;
#if CONFIG_MOTION_VAR
      thread_data->td->mb.above_pred_buf = thread_data->td->above_pred_buf;
      thread_data->td->mb.left_pred_buf = thread_data->td->left_pred_buf;
      thread_data->td->mb.wsrc_buf = thread_data->td->wsrc_buf;
      thread_data->td->mb.mask_buf = thread_data->td->mask_buf;
#endif
    }
    if (thread_data->td->counts != &cpi->common.counts) {
      memcpy(thread_data->td->counts, &cpi->common.counts,
             sizeof(cpi->common.counts));
    }

#if CONFIG_PALETTE
    if (cpi->common.allow_screen_content_tools && i < num_workers - 1)
      thread_data->td->mb.palette_buffer = thread_data->td->palette_buffer;
#endif  // CONFIG_PALETTE
  }

  // Encode a frame
  for (i = 0; i < num_workers; i++) {
    AVxWorker *const worker = &cpi->workers[i];
    EncWorkerData *const thread_data = (EncWorkerData *)worker->data1;

    // Set the starting tile for each thread.
    thread_data->start = i;

    if (i == cpi->num_workers - 1)
      winterface->execute(worker);
    else
      winterface->launch(worker);
  }

  // Encoding ends.
  for (i = 0; i < num_workers; i++) {
    AVxWorker *const worker = &cpi->workers[i];
    winterface->sync(worker);
  }

  for (i = 0; i < num_workers; i++) {
    AVxWorker *const worker = &cpi->workers[i];
    EncWorkerData *const thread_data = (EncWorkerData *)worker->data1;

    // Accumulate counters.
    if (i < cpi->num_workers - 1) {
      av1_accumulate_frame_counts(&cm->counts, thread_data->td->counts);
      accumulate_rd_opt(&cpi->td, thread_data->td);
#if CONFIG_VAR_TX
      cpi->td.mb.txb_split_count += thread_data->td->mb.txb_split_count;
#endif
    }
  }
}
