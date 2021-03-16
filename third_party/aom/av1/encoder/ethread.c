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

#include "av1/encoder/av1_multi_thread.h"
#include "av1/encoder/encodeframe.h"
#include "av1/encoder/encoder.h"
#include "av1/encoder/ethread.h"
#include "av1/encoder/rdopt.h"
#include "aom_dsp/aom_dsp_common.h"

static AOM_INLINE void accumulate_rd_opt(ThreadData *td, ThreadData *td_t) {
  for (int i = 0; i < REFERENCE_MODES; i++)
    td->rd_counts.comp_pred_diff[i] += td_t->rd_counts.comp_pred_diff[i];

  for (int i = 0; i < REF_FRAMES; i++)
    td->rd_counts.global_motion_used[i] +=
        td_t->rd_counts.global_motion_used[i];

  td->rd_counts.compound_ref_used_flag |=
      td_t->rd_counts.compound_ref_used_flag;
  td->rd_counts.skip_mode_used_flag |= td_t->rd_counts.skip_mode_used_flag;

  for (int i = 0; i < TX_SIZES_ALL; i++) {
    for (int j = 0; j < TX_TYPES; j++)
      td->rd_counts.tx_type_used[i][j] += td_t->rd_counts.tx_type_used[i][j];
  }

  for (int i = 0; i < BLOCK_SIZES_ALL; i++) {
    for (int j = 0; j < 2; j++) {
      td->rd_counts.obmc_used[i][j] += td_t->rd_counts.obmc_used[i][j];
    }
  }

  for (int i = 0; i < 2; i++) {
    td->rd_counts.warped_used[i] += td_t->rd_counts.warped_used[i];
  }
}

static AOM_INLINE void update_delta_lf_for_row_mt(AV1_COMP *cpi) {
  AV1_COMMON *cm = &cpi->common;
  MACROBLOCKD *xd = &cpi->td.mb.e_mbd;
  const int mib_size = cm->seq_params.mib_size;
  const int frame_lf_count =
      av1_num_planes(cm) > 1 ? FRAME_LF_COUNT : FRAME_LF_COUNT - 2;
  for (int row = 0; row < cm->tiles.rows; row++) {
    for (int col = 0; col < cm->tiles.cols; col++) {
      TileDataEnc *tile_data = &cpi->tile_data[row * cm->tiles.cols + col];
      const TileInfo *const tile_info = &tile_data->tile_info;
      for (int mi_row = tile_info->mi_row_start; mi_row < tile_info->mi_row_end;
           mi_row += mib_size) {
        if (mi_row == tile_info->mi_row_start)
          av1_reset_loop_filter_delta(xd, av1_num_planes(cm));
        for (int mi_col = tile_info->mi_col_start;
             mi_col < tile_info->mi_col_end; mi_col += mib_size) {
          const int idx_str = cm->mi_params.mi_stride * mi_row + mi_col;
          MB_MODE_INFO **mi = cm->mi_params.mi_grid_base + idx_str;
          MB_MODE_INFO *mbmi = mi[0];
          if (mbmi->skip == 1 && (mbmi->sb_type == cm->seq_params.sb_size)) {
            for (int lf_id = 0; lf_id < frame_lf_count; ++lf_id)
              mbmi->delta_lf[lf_id] = xd->delta_lf[lf_id];
            mbmi->delta_lf_from_base = xd->delta_lf_from_base;
          } else {
            if (cm->delta_q_info.delta_lf_multi) {
              for (int lf_id = 0; lf_id < frame_lf_count; ++lf_id)
                xd->delta_lf[lf_id] = mbmi->delta_lf[lf_id];
            } else {
              xd->delta_lf_from_base = mbmi->delta_lf_from_base;
            }
          }
        }
      }
    }
  }
}

void av1_row_mt_sync_read_dummy(struct AV1RowMTSyncData *const row_mt_sync,
                                int r, int c) {
  (void)row_mt_sync;
  (void)r;
  (void)c;
  return;
}

void av1_row_mt_sync_write_dummy(struct AV1RowMTSyncData *const row_mt_sync,
                                 int r, int c, const int cols) {
  (void)row_mt_sync;
  (void)r;
  (void)c;
  (void)cols;
  return;
}

void av1_row_mt_sync_read(AV1RowMTSync *const row_mt_sync, int r, int c) {
#if CONFIG_MULTITHREAD
  const int nsync = row_mt_sync->sync_range;

  if (r) {
    pthread_mutex_t *const mutex = &row_mt_sync->mutex_[r - 1];
    pthread_mutex_lock(mutex);

    while (c > row_mt_sync->cur_col[r - 1] - nsync) {
      pthread_cond_wait(&row_mt_sync->cond_[r - 1], mutex);
    }
    pthread_mutex_unlock(mutex);
  }
#else
  (void)row_mt_sync;
  (void)r;
  (void)c;
#endif  // CONFIG_MULTITHREAD
}

void av1_row_mt_sync_write(AV1RowMTSync *const row_mt_sync, int r, int c,
                           const int cols) {
#if CONFIG_MULTITHREAD
  const int nsync = row_mt_sync->sync_range;
  int cur;
  // Only signal when there are enough encoded blocks for next row to run.
  int sig = 1;

  if (c < cols - 1) {
    cur = c;
    if (c % nsync) sig = 0;
  } else {
    cur = cols + nsync;
  }

  if (sig) {
    pthread_mutex_lock(&row_mt_sync->mutex_[r]);

    row_mt_sync->cur_col[r] = cur;

    pthread_cond_signal(&row_mt_sync->cond_[r]);
    pthread_mutex_unlock(&row_mt_sync->mutex_[r]);
  }
#else
  (void)row_mt_sync;
  (void)r;
  (void)c;
  (void)cols;
#endif  // CONFIG_MULTITHREAD
}

// Allocate memory for row synchronization
void av1_row_mt_sync_mem_alloc(AV1RowMTSync *row_mt_sync, AV1_COMMON *cm,
                               int rows) {
  row_mt_sync->rows = rows;
#if CONFIG_MULTITHREAD
  {
    int i;

    CHECK_MEM_ERROR(cm, row_mt_sync->mutex_,
                    aom_malloc(sizeof(*row_mt_sync->mutex_) * rows));
    if (row_mt_sync->mutex_) {
      for (i = 0; i < rows; ++i) {
        pthread_mutex_init(&row_mt_sync->mutex_[i], NULL);
      }
    }

    CHECK_MEM_ERROR(cm, row_mt_sync->cond_,
                    aom_malloc(sizeof(*row_mt_sync->cond_) * rows));
    if (row_mt_sync->cond_) {
      for (i = 0; i < rows; ++i) {
        pthread_cond_init(&row_mt_sync->cond_[i], NULL);
      }
    }
  }
#endif  // CONFIG_MULTITHREAD

  CHECK_MEM_ERROR(cm, row_mt_sync->cur_col,
                  aom_malloc(sizeof(*row_mt_sync->cur_col) * rows));

  // Set up nsync.
  row_mt_sync->sync_range = 1;
}

// Deallocate row based multi-threading synchronization related mutex and data
void av1_row_mt_sync_mem_dealloc(AV1RowMTSync *row_mt_sync) {
  if (row_mt_sync != NULL) {
#if CONFIG_MULTITHREAD
    int i;

    if (row_mt_sync->mutex_ != NULL) {
      for (i = 0; i < row_mt_sync->rows; ++i) {
        pthread_mutex_destroy(&row_mt_sync->mutex_[i]);
      }
      aom_free(row_mt_sync->mutex_);
    }
    if (row_mt_sync->cond_ != NULL) {
      for (i = 0; i < row_mt_sync->rows; ++i) {
        pthread_cond_destroy(&row_mt_sync->cond_[i]);
      }
      aom_free(row_mt_sync->cond_);
    }
#endif  // CONFIG_MULTITHREAD
    aom_free(row_mt_sync->cur_col);
    // clear the structure as the source of this call may be dynamic change
    // in tiles in which case this call will be followed by an _alloc()
    // which may fail.
    av1_zero(*row_mt_sync);
  }
}

static AOM_INLINE void assign_tile_to_thread(
    MultiThreadHandle *multi_thread_ctxt, int num_tiles, int num_workers) {
  int tile_id = 0;
  int i;

  for (i = 0; i < num_workers; i++) {
    multi_thread_ctxt->thread_id_to_tile_id[i] = tile_id++;
    if (tile_id == num_tiles) tile_id = 0;
  }
}

static int get_next_job(AV1_COMP *const cpi, int *current_mi_row,
                        int cur_tile_id) {
  AV1_COMMON *const cm = &cpi->common;
  TileDataEnc *const this_tile = &cpi->tile_data[cur_tile_id];
  AV1RowMTInfo *row_mt_info = &this_tile->row_mt_info;

  if (row_mt_info->current_mi_row < this_tile->tile_info.mi_row_end) {
    *current_mi_row = row_mt_info->current_mi_row;
    row_mt_info->num_threads_working++;
    row_mt_info->current_mi_row += cm->seq_params.mib_size;
    return 1;
  }
  return 0;
}

static AOM_INLINE void switch_tile_and_get_next_job(AV1_COMP *const cpi,
                                                    int *cur_tile_id,
                                                    int *current_mi_row,
                                                    int *end_of_frame) {
  AV1_COMMON *const cm = &cpi->common;
  const int tile_cols = cm->tiles.cols;
  const int tile_rows = cm->tiles.rows;

  int tile_id = -1;  // Stores the tile ID with minimum proc done
  int max_mis_to_encode = 0;
  int min_num_threads_working = INT_MAX;

  for (int tile_row = 0; tile_row < tile_rows; tile_row++) {
    for (int tile_col = 0; tile_col < tile_cols; tile_col++) {
      int tile_index = tile_row * tile_cols + tile_col;
      TileDataEnc *this_tile = &cpi->tile_data[tile_index];
      AV1RowMTInfo *row_mt_info = &this_tile->row_mt_info;
      int num_sb_rows_in_tile =
          av1_get_sb_rows_in_tile(cm, this_tile->tile_info);
      int num_sb_cols_in_tile =
          av1_get_sb_cols_in_tile(cm, this_tile->tile_info);
      int theoretical_limit_on_threads =
          AOMMIN((num_sb_cols_in_tile + 1) >> 1, num_sb_rows_in_tile);
      int num_threads_working = row_mt_info->num_threads_working;
      if (num_threads_working < theoretical_limit_on_threads) {
        int num_mis_to_encode =
            this_tile->tile_info.mi_row_end - row_mt_info->current_mi_row;

        // Tile to be processed by this thread is selected on the basis of
        // availability of jobs:
        // 1) If jobs are available, tile to be processed is chosen on the
        // basis of minimum number of threads working for that tile. If two or
        // more tiles have same number of threads working for them, then the
        // tile with maximum number of jobs available will be chosen.
        // 2) If no jobs are available, then end_of_frame is reached.
        if (num_mis_to_encode > 0) {
          if (num_threads_working < min_num_threads_working) {
            min_num_threads_working = num_threads_working;
            max_mis_to_encode = 0;
          }
          if (num_threads_working == min_num_threads_working &&
              num_mis_to_encode > max_mis_to_encode) {
            tile_id = tile_index;
            max_mis_to_encode = num_mis_to_encode;
          }
        }
      }
    }
  }
  if (tile_id == -1) {
    *end_of_frame = 1;
  } else {
    // Update the cur ID to the next tile ID that will be processed,
    // which will be the least processed tile
    *cur_tile_id = tile_id;
    get_next_job(cpi, current_mi_row, *cur_tile_id);
  }
}

static int enc_row_mt_worker_hook(void *arg1, void *unused) {
  EncWorkerData *const thread_data = (EncWorkerData *)arg1;
  AV1_COMP *const cpi = thread_data->cpi;
  AV1_COMMON *const cm = &cpi->common;

  MultiThreadHandle *multi_thread_ctxt = &cpi->multi_thread_ctxt;
  int thread_id = thread_data->thread_id;
  int cur_tile_id = multi_thread_ctxt->thread_id_to_tile_id[thread_id];
  (void)unused;

  assert(cur_tile_id != -1);

  int end_of_frame = 0;
  while (1) {
    int current_mi_row = -1;
#if CONFIG_MULTITHREAD
    pthread_mutex_lock(cpi->row_mt_mutex_);
#endif
    if (!get_next_job(cpi, &current_mi_row, cur_tile_id)) {
      // No jobs are available for the current tile. Query for the status of
      // other tiles and get the next job if available
      switch_tile_and_get_next_job(cpi, &cur_tile_id, &current_mi_row,
                                   &end_of_frame);
    }
#if CONFIG_MULTITHREAD
    pthread_mutex_unlock(cpi->row_mt_mutex_);
#endif
    if (end_of_frame == 1) break;

    TileDataEnc *const this_tile = &cpi->tile_data[cur_tile_id];
    int tile_row = this_tile->tile_info.tile_row;
    int tile_col = this_tile->tile_info.tile_col;

    assert(current_mi_row != -1 &&
           current_mi_row <= this_tile->tile_info.mi_row_end);

    ThreadData *td = thread_data->td;

    td->mb.e_mbd.tile_ctx = td->tctx;
    td->mb.tile_pb_ctx = &this_tile->tctx;
    if (this_tile->allow_update_cdf) {
      td->mb.row_ctx = this_tile->row_ctx;
      if (current_mi_row == this_tile->tile_info.mi_row_start)
        memcpy(td->mb.e_mbd.tile_ctx, &this_tile->tctx, sizeof(FRAME_CONTEXT));
    } else {
      memcpy(td->mb.e_mbd.tile_ctx, &this_tile->tctx, sizeof(FRAME_CONTEXT));
    }

    av1_init_above_context(&cm->above_contexts, av1_num_planes(cm), tile_row,
                           &td->mb.e_mbd);

    cfl_init(&td->mb.e_mbd.cfl, &cm->seq_params);
    av1_crc32c_calculator_init(&td->mb.mb_rd_record.crc_calculator);

    av1_encode_sb_row(cpi, td, tile_row, tile_col, current_mi_row);
#if CONFIG_MULTITHREAD
    pthread_mutex_lock(cpi->row_mt_mutex_);
#endif
    this_tile->row_mt_info.num_threads_working--;
#if CONFIG_MULTITHREAD
    pthread_mutex_unlock(cpi->row_mt_mutex_);
#endif
  }

  return 1;
}

static int enc_worker_hook(void *arg1, void *unused) {
  EncWorkerData *const thread_data = (EncWorkerData *)arg1;
  AV1_COMP *const cpi = thread_data->cpi;
  const AV1_COMMON *const cm = &cpi->common;
  const int tile_cols = cm->tiles.cols;
  const int tile_rows = cm->tiles.rows;
  int t;

  (void)unused;

  for (t = thread_data->start; t < tile_rows * tile_cols;
       t += cpi->num_workers) {
    int tile_row = t / tile_cols;
    int tile_col = t % tile_cols;

    TileDataEnc *const this_tile =
        &cpi->tile_data[tile_row * cm->tiles.cols + tile_col];
    thread_data->td->mb.e_mbd.tile_ctx = &this_tile->tctx;
    thread_data->td->mb.tile_pb_ctx = &this_tile->tctx;
    av1_encode_tile(cpi, thread_data->td, tile_row, tile_col);
  }

  return 1;
}

static AOM_INLINE void create_enc_workers(AV1_COMP *cpi, int num_workers) {
  AV1_COMMON *const cm = &cpi->common;
  const AVxWorkerInterface *const winterface = aom_get_worker_interface();
  int sb_mi_size = av1_get_sb_mi_size(cm);

  CHECK_MEM_ERROR(cm, cpi->workers,
                  aom_malloc(num_workers * sizeof(*cpi->workers)));

  CHECK_MEM_ERROR(cm, cpi->tile_thr_data,
                  aom_calloc(num_workers, sizeof(*cpi->tile_thr_data)));

#if CONFIG_MULTITHREAD
  if (cpi->oxcf.row_mt == 1) {
    if (cpi->row_mt_mutex_ == NULL) {
      CHECK_MEM_ERROR(cm, cpi->row_mt_mutex_,
                      aom_malloc(sizeof(*(cpi->row_mt_mutex_))));
      if (cpi->row_mt_mutex_) pthread_mutex_init(cpi->row_mt_mutex_, NULL);
    }
  }
#endif

  for (int i = num_workers - 1; i >= 0; i--) {
    AVxWorker *const worker = &cpi->workers[i];
    EncWorkerData *const thread_data = &cpi->tile_thr_data[i];

    ++cpi->num_workers;
    winterface->init(worker);
    worker->thread_name = "aom enc worker";

    thread_data->cpi = cpi;
    thread_data->thread_id = i;

    if (i > 0) {
      // Allocate thread data.
      CHECK_MEM_ERROR(cm, thread_data->td,
                      aom_memalign(32, sizeof(*thread_data->td)));
      av1_zero(*thread_data->td);

      // Set up pc_tree.
      thread_data->td->pc_tree = NULL;
      av1_setup_pc_tree(cpi, thread_data->td);

      CHECK_MEM_ERROR(cm, thread_data->td->above_pred_buf,
                      (uint8_t *)aom_memalign(
                          16, MAX_MB_PLANE * MAX_SB_SQUARE *
                                  sizeof(*thread_data->td->above_pred_buf)));
      CHECK_MEM_ERROR(cm, thread_data->td->left_pred_buf,
                      (uint8_t *)aom_memalign(
                          16, MAX_MB_PLANE * MAX_SB_SQUARE *
                                  sizeof(*thread_data->td->left_pred_buf)));

      CHECK_MEM_ERROR(
          cm, thread_data->td->wsrc_buf,
          (int32_t *)aom_memalign(
              16, MAX_SB_SQUARE * sizeof(*thread_data->td->wsrc_buf)));

      CHECK_MEM_ERROR(cm, thread_data->td->inter_modes_info,
                      (InterModesInfo *)aom_malloc(
                          sizeof(*thread_data->td->inter_modes_info)));

      for (int x = 0; x < 2; x++)
        for (int y = 0; y < 2; y++)
          CHECK_MEM_ERROR(
              cm, thread_data->td->hash_value_buffer[x][y],
              (uint32_t *)aom_malloc(
                  AOM_BUFFER_SIZE_FOR_BLOCK_HASH *
                  sizeof(*thread_data->td->hash_value_buffer[0][0])));

      CHECK_MEM_ERROR(
          cm, thread_data->td->mask_buf,
          (int32_t *)aom_memalign(
              16, MAX_SB_SQUARE * sizeof(*thread_data->td->mask_buf)));
      // Allocate frame counters in thread data.
      CHECK_MEM_ERROR(cm, thread_data->td->counts,
                      aom_calloc(1, sizeof(*thread_data->td->counts)));

      // Allocate buffers used by palette coding mode.
      CHECK_MEM_ERROR(
          cm, thread_data->td->palette_buffer,
          aom_memalign(16, sizeof(*thread_data->td->palette_buffer)));

      av1_alloc_compound_type_rd_buffers(cm, &thread_data->td->comp_rd_buffer);

      CHECK_MEM_ERROR(
          cm, thread_data->td->tmp_conv_dst,
          aom_memalign(32, MAX_SB_SIZE * MAX_SB_SIZE *
                               sizeof(*thread_data->td->tmp_conv_dst)));
      for (int j = 0; j < 2; ++j) {
        CHECK_MEM_ERROR(
            cm, thread_data->td->tmp_obmc_bufs[j],
            aom_memalign(32, 2 * MAX_MB_PLANE * MAX_SB_SQUARE *
                                 sizeof(*thread_data->td->tmp_obmc_bufs[j])));
      }

      CHECK_MEM_ERROR(
          cm, thread_data->td->mbmi_ext,
          aom_calloc(sb_mi_size, sizeof(*thread_data->td->mbmi_ext)));

      if (cpi->sf.part_sf.partition_search_type == VAR_BASED_PARTITION) {
        const int num_64x64_blocks =
            (cm->seq_params.sb_size == BLOCK_64X64) ? 1 : 4;
        CHECK_MEM_ERROR(
            cm, thread_data->td->vt64x64,
            aom_malloc(sizeof(*thread_data->td->vt64x64) * num_64x64_blocks));
      }

      // Create threads
      if (!winterface->reset(worker))
        aom_internal_error(&cm->error, AOM_CODEC_ERROR,
                           "Tile encoder thread creation failed");
    } else {
      // Main thread acts as a worker and uses the thread data in cpi.
      thread_data->td = &cpi->td;
    }
    if (cpi->oxcf.row_mt == 1)
      CHECK_MEM_ERROR(
          cm, thread_data->td->tctx,
          (FRAME_CONTEXT *)aom_memalign(16, sizeof(*thread_data->td->tctx)));
    winterface->sync(worker);
  }
}

static AOM_INLINE void launch_enc_workers(AV1_COMP *cpi, int num_workers) {
  const AVxWorkerInterface *const winterface = aom_get_worker_interface();
  // Encode a frame
  for (int i = num_workers - 1; i >= 0; i--) {
    AVxWorker *const worker = &cpi->workers[i];
    EncWorkerData *const thread_data = (EncWorkerData *)worker->data1;

    // Set the starting tile for each thread.
    thread_data->start = i;

    if (i == 0)
      winterface->execute(worker);
    else
      winterface->launch(worker);
  }
}

static AOM_INLINE void sync_enc_workers(AV1_COMP *cpi, int num_workers) {
  const AVxWorkerInterface *const winterface = aom_get_worker_interface();
  int had_error = 0;

  // Encoding ends.
  for (int i = num_workers - 1; i >= 0; i--) {
    AVxWorker *const worker = &cpi->workers[i];
    had_error |= !winterface->sync(worker);
  }

  if (had_error)
    aom_internal_error(&cpi->common.error, AOM_CODEC_ERROR,
                       "Failed to encode tile data");
}

static AOM_INLINE void accumulate_counters_enc_workers(AV1_COMP *cpi,
                                                       int num_workers) {
  for (int i = num_workers - 1; i >= 0; i--) {
    AVxWorker *const worker = &cpi->workers[i];
    EncWorkerData *const thread_data = (EncWorkerData *)worker->data1;
    cpi->intrabc_used |= thread_data->td->intrabc_used;
    cpi->deltaq_used |= thread_data->td->deltaq_used;

    // Accumulate counters.
    if (i > 0) {
      av1_accumulate_frame_counts(&cpi->counts, thread_data->td->counts);
      accumulate_rd_opt(&cpi->td, thread_data->td);
      cpi->td.mb.txb_split_count += thread_data->td->mb.txb_split_count;
#if CONFIG_SPEED_STATS
      cpi->td.mb.tx_search_count += thread_data->td->mb.tx_search_count;
#endif  // CONFIG_SPEED_STATS
    }
  }
}

static AOM_INLINE void prepare_enc_workers(AV1_COMP *cpi, AVxWorkerHook hook,
                                           int num_workers) {
  for (int i = num_workers - 1; i >= 0; i--) {
    AVxWorker *const worker = &cpi->workers[i];
    EncWorkerData *const thread_data = &cpi->tile_thr_data[i];

    worker->hook = hook;
    worker->data1 = thread_data;
    worker->data2 = NULL;

    thread_data->td->intrabc_used = 0;
    thread_data->td->deltaq_used = 0;

    // Before encoding a frame, copy the thread data from cpi.
    if (thread_data->td != &cpi->td) {
      thread_data->td->mb = cpi->td.mb;
      thread_data->td->rd_counts = cpi->td.rd_counts;
      thread_data->td->mb.above_pred_buf = thread_data->td->above_pred_buf;
      thread_data->td->mb.left_pred_buf = thread_data->td->left_pred_buf;
      thread_data->td->mb.wsrc_buf = thread_data->td->wsrc_buf;

      thread_data->td->mb.inter_modes_info = thread_data->td->inter_modes_info;
      for (int x = 0; x < 2; x++) {
        for (int y = 0; y < 2; y++) {
          memcpy(thread_data->td->hash_value_buffer[x][y],
                 cpi->td.mb.intrabc_hash_info.hash_value_buffer[x][y],
                 AOM_BUFFER_SIZE_FOR_BLOCK_HASH *
                     sizeof(*thread_data->td->hash_value_buffer[0][0]));
          thread_data->td->mb.intrabc_hash_info.hash_value_buffer[x][y] =
              thread_data->td->hash_value_buffer[x][y];
        }
      }
      thread_data->td->mb.mask_buf = thread_data->td->mask_buf;
      thread_data->td->mb.mbmi_ext = thread_data->td->mbmi_ext;
    }
    if (thread_data->td->counts != &cpi->counts) {
      memcpy(thread_data->td->counts, &cpi->counts, sizeof(cpi->counts));
    }

    if (i > 0) {
      thread_data->td->mb.palette_buffer = thread_data->td->palette_buffer;
      thread_data->td->mb.comp_rd_buffer = thread_data->td->comp_rd_buffer;
      thread_data->td->mb.tmp_conv_dst = thread_data->td->tmp_conv_dst;
      for (int j = 0; j < 2; ++j) {
        thread_data->td->mb.tmp_obmc_bufs[j] =
            thread_data->td->tmp_obmc_bufs[j];
      }

      thread_data->td->mb.e_mbd.tmp_conv_dst = thread_data->td->mb.tmp_conv_dst;
      for (int j = 0; j < 2; ++j) {
        thread_data->td->mb.e_mbd.tmp_obmc_bufs[j] =
            thread_data->td->mb.tmp_obmc_bufs[j];
      }
    }
  }
}

void av1_encode_tiles_mt(AV1_COMP *cpi) {
  AV1_COMMON *const cm = &cpi->common;
  const int tile_cols = cm->tiles.cols;
  const int tile_rows = cm->tiles.rows;
  int num_workers = AOMMIN(cpi->oxcf.max_threads, tile_cols * tile_rows);

  if (cpi->tile_data == NULL || cpi->allocated_tiles < tile_cols * tile_rows)
    av1_alloc_tile_data(cpi);

  av1_init_tile_data(cpi);
  // Only run once to create threads and allocate thread data.
  if (cpi->num_workers == 0) {
    create_enc_workers(cpi, num_workers);
  } else {
    num_workers = AOMMIN(num_workers, cpi->num_workers);
  }
  prepare_enc_workers(cpi, enc_worker_hook, num_workers);
  launch_enc_workers(cpi, num_workers);
  sync_enc_workers(cpi, num_workers);
  accumulate_counters_enc_workers(cpi, num_workers);
}

// Accumulate frame counts. FRAME_COUNTS consist solely of 'unsigned int'
// members, so we treat it as an array, and sum over the whole length.
void av1_accumulate_frame_counts(FRAME_COUNTS *acc_counts,
                                 const FRAME_COUNTS *counts) {
  unsigned int *const acc = (unsigned int *)acc_counts;
  const unsigned int *const cnt = (const unsigned int *)counts;

  const unsigned int n_counts = sizeof(FRAME_COUNTS) / sizeof(unsigned int);

  for (unsigned int i = 0; i < n_counts; i++) acc[i] += cnt[i];
}

void av1_encode_tiles_row_mt(AV1_COMP *cpi) {
  AV1_COMMON *const cm = &cpi->common;
  const int tile_cols = cm->tiles.cols;
  const int tile_rows = cm->tiles.rows;
  MultiThreadHandle *multi_thread_ctxt = &cpi->multi_thread_ctxt;
  int num_workers = 0;
  int total_num_threads_row_mt = 0;
  int max_sb_rows = 0;

  if (cpi->tile_data == NULL || cpi->allocated_tiles < tile_cols * tile_rows) {
    av1_row_mt_mem_dealloc(cpi);
    av1_alloc_tile_data(cpi);
  }

  av1_init_tile_data(cpi);

  for (int row = 0; row < tile_rows; row++) {
    for (int col = 0; col < tile_cols; col++) {
      TileDataEnc *tile_data = &cpi->tile_data[row * cm->tiles.cols + col];
      int num_sb_rows_in_tile =
          av1_get_sb_rows_in_tile(cm, tile_data->tile_info);
      int num_sb_cols_in_tile =
          av1_get_sb_cols_in_tile(cm, tile_data->tile_info);
      total_num_threads_row_mt +=
          AOMMIN((num_sb_cols_in_tile + 1) >> 1, num_sb_rows_in_tile);
      max_sb_rows = AOMMAX(max_sb_rows, num_sb_rows_in_tile);
    }
  }
  // TODO(ravi.chaudhary@ittiam.com): Currently the percentage of
  // post-processing stages in encoder is quiet low, so limiting the number of
  // threads to the theoretical limit in row-mt does not have much impact on
  // post-processing multi-threading stage. Need to revisit this when
  // post-processing time starts shooting up.
  num_workers = AOMMIN(cpi->oxcf.max_threads, total_num_threads_row_mt);

  if (multi_thread_ctxt->allocated_tile_cols != tile_cols ||
      multi_thread_ctxt->allocated_tile_rows != tile_rows ||
      multi_thread_ctxt->allocated_sb_rows != max_sb_rows) {
    av1_row_mt_mem_dealloc(cpi);
    av1_row_mt_mem_alloc(cpi, max_sb_rows);
  }

  memset(multi_thread_ctxt->thread_id_to_tile_id, -1,
         sizeof(*multi_thread_ctxt->thread_id_to_tile_id) * MAX_NUM_THREADS);

  for (int tile_row = 0; tile_row < tile_rows; tile_row++) {
    for (int tile_col = 0; tile_col < tile_cols; tile_col++) {
      int tile_id = tile_row * tile_cols + tile_col;
      TileDataEnc *this_tile = &cpi->tile_data[tile_id];

      // Initialize cur_col to -1 for all rows.
      memset(this_tile->row_mt_sync.cur_col, -1,
             sizeof(*this_tile->row_mt_sync.cur_col) * max_sb_rows);
      this_tile->row_mt_info.current_mi_row = this_tile->tile_info.mi_row_start;
      this_tile->row_mt_info.num_threads_working = 0;

      av1_inter_mode_data_init(this_tile);
      av1_zero_above_context(cm, &cpi->td.mb.e_mbd,
                             this_tile->tile_info.mi_col_start,
                             this_tile->tile_info.mi_col_end, tile_row);
    }
  }

  // Only run once to create threads and allocate thread data.
  if (cpi->num_workers == 0) {
    create_enc_workers(cpi, num_workers);
  } else {
    num_workers = AOMMIN(num_workers, cpi->num_workers);
  }
  assign_tile_to_thread(multi_thread_ctxt, tile_cols * tile_rows, num_workers);
  prepare_enc_workers(cpi, enc_row_mt_worker_hook, num_workers);
  launch_enc_workers(cpi, num_workers);
  sync_enc_workers(cpi, num_workers);
  if (cm->delta_q_info.delta_lf_present_flag) update_delta_lf_for_row_mt(cpi);
  accumulate_counters_enc_workers(cpi, num_workers);
}
