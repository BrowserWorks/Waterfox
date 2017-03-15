/*
* Copyright 2016 Google Inc.
*
* Use of this source code is governed by a BSD-style license that can be
* found in the LICENSE file.
*/

#include "vk/GrVkPipelineStateBuilder.h"

#include "vk/GrVkDescriptorSetManager.h"
#include "vk/GrVkGpu.h"
#include "vk/GrVkRenderPass.h"

GrVkPipelineState* GrVkPipelineStateBuilder::CreatePipelineState(
                                                               GrVkGpu* gpu,
                                                               const GrPipeline& pipeline,
                                                               const GrPrimitiveProcessor& primProc,
                                                               GrPrimitiveType primitiveType,
                                                               const GrVkPipelineState::Desc& desc,
                                                               const GrVkRenderPass& renderPass) {
    // create a builder.  This will be handed off to effects so they can use it to add
    // uniforms, varyings, textures, etc
    GrVkPipelineStateBuilder builder(gpu, pipeline, primProc, desc);

    GrGLSLExpr4 inputColor;
    GrGLSLExpr4 inputCoverage;

    if (!builder.emitAndInstallProcs(&inputColor, &inputCoverage)) {
        builder.cleanupFragmentProcessors();
        return nullptr;
    }

    return builder.finalize(primitiveType, renderPass, desc);
}

GrVkPipelineStateBuilder::GrVkPipelineStateBuilder(GrVkGpu* gpu,
                                                   const GrPipeline& pipeline,
                                                   const GrPrimitiveProcessor& primProc,
                                                   const GrProgramDesc& desc)
    : INHERITED(pipeline, primProc, desc)
    , fGpu(gpu)
    , fVaryingHandler(this)
    , fUniformHandler(this) {
}

const GrCaps* GrVkPipelineStateBuilder::caps() const {
    return fGpu->caps();
}
const GrGLSLCaps* GrVkPipelineStateBuilder::glslCaps() const {
    return fGpu->vkCaps().glslCaps();
}

void GrVkPipelineStateBuilder::finalizeFragmentOutputColor(GrGLSLShaderVar& outputColor) {
    outputColor.setLayoutQualifier("location = 0, index = 0");
}

void GrVkPipelineStateBuilder::finalizeFragmentSecondaryColor(GrGLSLShaderVar& outputColor) {
    outputColor.setLayoutQualifier("location = 0, index = 1");
}

bool GrVkPipelineStateBuilder::CreateVkShaderModule(const GrVkGpu* gpu,
                                                    VkShaderStageFlagBits stage,
                                                    const GrGLSLShaderBuilder& builder,
                                                    VkShaderModule* shaderModule,
                                                    VkPipelineShaderStageCreateInfo* stageInfo) {
    SkString shaderString;
    for (int i = 0; i < builder.fCompilerStrings.count(); ++i) {
        if (builder.fCompilerStrings[i]) {
            shaderString.append(builder.fCompilerStrings[i]);
            shaderString.append("\n");
        }
    }
    return GrCompileVkShaderModule(gpu, shaderString.c_str(), stage, shaderModule, stageInfo);
}

GrVkPipelineState* GrVkPipelineStateBuilder::finalize(GrPrimitiveType primitiveType,
                                                      const GrVkRenderPass& renderPass,
                                                      const GrVkPipelineState::Desc& desc) {
    VkDescriptorSetLayout dsLayout[2];
    VkPipelineLayout pipelineLayout;
    VkShaderModule vertShaderModule;
    VkShaderModule fragShaderModule;

    GrVkResourceProvider& resourceProvider = fGpu->resourceProvider();
    // This layout is not owned by the PipelineStateBuilder and thus should no be destroyed
    dsLayout[GrVkUniformHandler::kUniformBufferDescSet] = resourceProvider.getUniformDSLayout();

    GrVkDescriptorSetManager::Handle samplerDSHandle;
    resourceProvider.getSamplerDescriptorSetHandle(fUniformHandler, &samplerDSHandle);
    dsLayout[GrVkUniformHandler::kSamplerDescSet] =
            resourceProvider.getSamplerDSLayout(samplerDSHandle);

    // Create the VkPipelineLayout
    VkPipelineLayoutCreateInfo layoutCreateInfo;
    memset(&layoutCreateInfo, 0, sizeof(VkPipelineLayoutCreateFlags));
    layoutCreateInfo.sType = VK_STRUCTURE_TYPE_PIPELINE_LAYOUT_CREATE_INFO;
    layoutCreateInfo.pNext = 0;
    layoutCreateInfo.flags = 0;
    layoutCreateInfo.setLayoutCount = 2;
    layoutCreateInfo.pSetLayouts = dsLayout;
    layoutCreateInfo.pushConstantRangeCount = 0;
    layoutCreateInfo.pPushConstantRanges = nullptr;

    GR_VK_CALL_ERRCHECK(fGpu->vkInterface(), CreatePipelineLayout(fGpu->device(),
                                                                  &layoutCreateInfo,
                                                                  nullptr,
                                                                  &pipelineLayout));

    // We need to enable the following extensions so that the compiler can correctly make spir-v
    // from our glsl shaders.
    fVS.extensions().appendf("#extension GL_ARB_separate_shader_objects : enable\n");
    fFS.extensions().appendf("#extension GL_ARB_separate_shader_objects : enable\n");
    fVS.extensions().appendf("#extension GL_ARB_shading_language_420pack : enable\n");
    fFS.extensions().appendf("#extension GL_ARB_shading_language_420pack : enable\n");

    this->finalizeShaders();

    VkPipelineShaderStageCreateInfo shaderStageInfo[2];
    SkAssertResult(CreateVkShaderModule(fGpu,
                                        VK_SHADER_STAGE_VERTEX_BIT,
                                        fVS,
                                        &vertShaderModule,
                                        &shaderStageInfo[0]));

    SkAssertResult(CreateVkShaderModule(fGpu,
                                        VK_SHADER_STAGE_FRAGMENT_BIT,
                                        fFS,
                                        &fragShaderModule,
                                        &shaderStageInfo[1]));

    GrVkPipeline* pipeline = resourceProvider.createPipeline(fPipeline,
                                                             fPrimProc,
                                                             shaderStageInfo,
                                                             2,
                                                             primitiveType,
                                                             renderPass,
                                                             pipelineLayout);
    GR_VK_CALL(fGpu->vkInterface(), DestroyShaderModule(fGpu->device(), vertShaderModule,
                                                        nullptr));
    GR_VK_CALL(fGpu->vkInterface(), DestroyShaderModule(fGpu->device(), fragShaderModule,
                                                        nullptr));

    if (!pipeline) {
        GR_VK_CALL(fGpu->vkInterface(), DestroyPipelineLayout(fGpu->device(), pipelineLayout,
                                                              nullptr));
        GR_VK_CALL(fGpu->vkInterface(),
                   DestroyDescriptorSetLayout(fGpu->device(),
                                              dsLayout[GrVkUniformHandler::kSamplerDescSet],
                                              nullptr));

        this->cleanupFragmentProcessors();
        return nullptr;
    }

    return new GrVkPipelineState(fGpu,
                                 desc,
                                 pipeline,
                                 pipelineLayout,
                                 samplerDSHandle,
                                 fUniformHandles,
                                 fUniformHandler.fUniforms,
                                 fUniformHandler.fCurrentVertexUBOOffset,
                                 fUniformHandler.fCurrentFragmentUBOOffset,
                                 (uint32_t)fUniformHandler.numSamplers(),
                                 fGeometryProcessor,
                                 fXferProcessor,
                                 fFragmentProcessors);
}

