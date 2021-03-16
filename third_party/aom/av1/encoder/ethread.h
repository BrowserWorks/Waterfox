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

#ifndef AOM_AV1_ENCODER_ETHREAD_H_
#define AOM_AV1_ENCODER_ETHREAD_H_

#ifdef __cplusplus
extern "C" {
#endif

struct AV1_COMP;
struct ThreadData;
struct AV1RowMTSyncData;

typedef struct EncWorkerData {
  struct AV1_COMP *cpi;
  struct ThreadData *td;
  int start;
  int thread_id;
} EncWorkerData;

void av1_row_mt_sync_read(AV1RowMTSync *const row_mt_sync, int r, int c);
void av1_row_mt_sync_write(AV1RowMTSync *const row_mt_sync, int r, int c,
                           const int cols);

void av1_row_mt_sync_read_dummy(struct AV1RowMTSyncData *const row_mt_sync,
                                int r, int c);
void av1_row_mt_sync_write_dummy(struct AV1RowMTSyncData *const row_mt_sync,
                                 int r, int c, const int cols);

void av1_row_mt_sync_mem_dealloc(AV1RowMTSync *row_mt_sync);
// Allocate memory for row based multi-threading synchronization.
void av1_row_mt_sync_mem_alloc(AV1RowMTSync *row_mt_sync, struct AV1Common *cm,
                               int rows);

void av1_encode_tiles_mt(struct AV1_COMP *cpi);
void av1_encode_tiles_row_mt(struct AV1_COMP *cpi);

void av1_accumulate_frame_counts(struct FRAME_COUNTS *acc_counts,
                                 const struct FRAME_COUNTS *counts);

#ifdef __cplusplus
}  // extern "C"
#endif

#endif  // AOM_AV1_ENCODER_ETHREAD_H_
