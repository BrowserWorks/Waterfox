/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "WebRenderCompositionRecorder.h"

#include "mozilla/webrender/RenderThread.h"

namespace mozilla {

namespace layers {

class RendererRecordedFrame final : public layers::RecordedFrame {
 public:
  RendererRecordedFrame(const TimeStamp& aTimeStamp, wr::Renderer* aRenderer,
                        const wr::RecordedFrameHandle aHandle,
                        const gfx::IntSize& aSize)
      : RecordedFrame(aTimeStamp),
        mRenderer(aRenderer),
        mSize(aSize),
        mHandle(aHandle) {}

  already_AddRefed<gfx::DataSourceSurface> GetSourceSurface() override {
    if (!mSurface) {
      mSurface = gfx::Factory::CreateDataSourceSurface(
          mSize, gfx::SurfaceFormat::B8G8R8A8, /* aZero = */ false);

      gfx::DataSourceSurface::ScopedMap map(mSurface,
                                            gfx::DataSourceSurface::WRITE);

      if (!wr_renderer_map_recorded_frame(mRenderer, mHandle, map.GetData(),
                                          map.GetStride() * mSize.height,
                                          map.GetStride())) {
        return nullptr;
      }
    }

    return do_AddRef(mSurface);
  }

 private:
  wr::Renderer* mRenderer;
  RefPtr<gfx::DataSourceSurface> mSurface;
  gfx::IntSize mSize;
  wr::RecordedFrameHandle mHandle;
};

void WebRenderCompositionRecorder::MaybeRecordFrame(
    wr::Renderer* aRenderer, const wr::WebRenderPipelineInfo* aFrameEpochs) {
  MOZ_ASSERT(wr::RenderThread::IsInRenderThread());

  if (!aRenderer || !aFrameEpochs || !DidPaintContent(aFrameEpochs)) {
    return;
  }

  wr::RecordedFrameHandle handle{0};
  gfx::IntSize size(0, 0);

  if (wr_renderer_record_frame(aRenderer, wr::ImageFormat::BGRA8, &handle,
                               &size.width, &size.height)) {
    RefPtr<RecordedFrame> frame =
        new RendererRecordedFrame(TimeStamp::Now(), aRenderer, handle, size);

    RecordFrame(frame);
  }
}

bool WebRenderCompositionRecorder::DidPaintContent(
    const wr::WebRenderPipelineInfo* aFrameEpochs) {
  const wr::WrPipelineInfo& info = aFrameEpochs->Raw();
  bool didPaintContent = false;

  for (const auto& epoch : info.epochs) {
    const wr::PipelineId pipelineId = epoch.pipeline_id;

    if (pipelineId == mRootPipelineId) {
      continue;
    }

    const auto it = mContentPipelines.find(AsUint64(pipelineId));
    if (it == mContentPipelines.end() || it->second != epoch.epoch) {
      // This content pipeline has updated list last render or has newly
      // rendered.
      didPaintContent = true;
      mContentPipelines[AsUint64(pipelineId)] = epoch.epoch;
    }
  }

  for (const auto& removedPipeline : info.removed_pipelines) {
    const wr::PipelineId pipelineId = removedPipeline.pipeline_id;
    if (pipelineId == mRootPipelineId) {
      continue;
    }
    mContentPipelines.erase(AsUint64(pipelineId));
  }

  return didPaintContent;
}

}  // namespace layers
}  // namespace mozilla
