/*
 * Copyright 2015 Google Inc.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

#ifndef GrVkCaps_DEFINED
#define GrVkCaps_DEFINED

#include "GrCaps.h"
#include "GrVkStencilAttachment.h"
#include "vk/GrVkDefines.h"

struct GrVkInterface;
class GrGLSLCaps;

/**
 * Stores some capabilities of a Vk backend.
 */
class GrVkCaps : public GrCaps {
public:
    typedef GrVkStencilAttachment::Format StencilFormat;

    /**
     * Creates a GrVkCaps that is set such that nothing is supported. The init function should
     * be called to fill out the caps.
     */
    GrVkCaps(const GrContextOptions& contextOptions, const GrVkInterface* vkInterface,
             VkPhysicalDevice device, uint32_t featureFlags, uint32_t extensionFlags);

    bool isConfigTexturable(GrPixelConfig config) const override {
        return SkToBool(ConfigInfo::kTextureable_Flag & fConfigTable[config].fOptimalFlags);
    }

    bool isConfigRenderable(GrPixelConfig config, bool withMSAA) const override {
        return SkToBool(ConfigInfo::kRenderable_Flag & fConfigTable[config].fOptimalFlags);
    }

    bool isConfigTexturableLinearly(GrPixelConfig config) const {
        return SkToBool(ConfigInfo::kTextureable_Flag & fConfigTable[config].fLinearFlags);
    }

    bool isConfigRenderableLinearly(GrPixelConfig config, bool withMSAA) const {
        return !withMSAA && SkToBool(ConfigInfo::kRenderable_Flag &
                                     fConfigTable[config].fLinearFlags);
    }

    bool configCanBeDstofBlit(GrPixelConfig config, bool linearTiled) const {
        const uint16_t& flags = linearTiled ? fConfigTable[config].fLinearFlags :
                                              fConfigTable[config].fOptimalFlags;
        return SkToBool(ConfigInfo::kBlitDst_Flag & flags);
    }

    bool configCanBeSrcofBlit(GrPixelConfig config, bool linearTiled) const {
        const uint16_t& flags = linearTiled ? fConfigTable[config].fLinearFlags :
                                              fConfigTable[config].fOptimalFlags;
        return SkToBool(ConfigInfo::kBlitSrc_Flag & flags);
    }

    bool canUseGLSLForShaderModule() const {
        return fCanUseGLSLForShaderModule;
    }

    bool mustDoCopiesFromOrigin() const {
        return fMustDoCopiesFromOrigin;
    }

    bool allowInitializationErrorOnTearDown() const {
        return fAllowInitializationErrorOnTearDown;
    }

    bool supportsCopiesAsDraws() const {
        return fSupportsCopiesAsDraws;
    }

    bool mustSubmitCommandsBeforeCopyOp() const {
        return fMustSubmitCommandsBeforeCopyOp;
    }

    /**
     * Returns both a supported and most prefered stencil format to use in draws.
     */
    const StencilFormat& preferedStencilFormat() const {
        return fPreferedStencilFormat;
    }

    GrGLSLCaps* glslCaps() const { return reinterpret_cast<GrGLSLCaps*>(fShaderCaps.get()); }

private:
    enum VkVendor {
        kQualcomm_VkVendor = 20803,
        kNvidia_VkVendor = 4318,
    };

    void init(const GrContextOptions& contextOptions, const GrVkInterface* vkInterface,
              VkPhysicalDevice device, uint32_t featureFlags, uint32_t extensionFlags);
    void initGrCaps(const VkPhysicalDeviceProperties&,
                    const VkPhysicalDeviceMemoryProperties&,
                    uint32_t featureFlags);
    void initGLSLCaps(const VkPhysicalDeviceProperties&, uint32_t featureFlags);
    void initSampleCount(const VkPhysicalDeviceProperties& properties);


    void initConfigTable(const GrVkInterface*, VkPhysicalDevice);
    void initStencilFormat(const GrVkInterface* iface, VkPhysicalDevice physDev);

    struct ConfigInfo {
        ConfigInfo() : fOptimalFlags(0), fLinearFlags(0) {}

        void init(const GrVkInterface*, VkPhysicalDevice, VkFormat);
        static void InitConfigFlags(VkFormatFeatureFlags, uint16_t* flags);

        enum {
            kTextureable_Flag = 0x1,
            kRenderable_Flag  = 0x2,
            kBlitSrc_Flag     = 0x4,
            kBlitDst_Flag     = 0x8,
        };

        uint16_t fOptimalFlags;
        uint16_t fLinearFlags;
    };
    ConfigInfo fConfigTable[kGrPixelConfigCnt];

    StencilFormat fPreferedStencilFormat;

    // Tells of if we can pass in straight GLSL string into vkCreateShaderModule
    bool fCanUseGLSLForShaderModule;

    // On Adreno vulkan, they do not respect the imageOffset parameter at least in
    // copyImageToBuffer. This flag says that we must do the copy starting from the origin always.
    bool fMustDoCopiesFromOrigin;

    // On Adreno, there is a bug where vkQueueWaitIdle will once in a while return
    // VK_ERROR_INITIALIZATION_FAILED instead of the required VK_SUCCESS or VK_DEVICE_LOST. This
    // flag says we will accept VK_ERROR_INITIALIZATION_FAILED as well.
    bool fAllowInitializationErrorOnTearDown;

    // Check whether we support using draws for copies.
    bool fSupportsCopiesAsDraws;

    // On Nvidia there is a current bug where we must the current command buffer before copy
    // operations or else the copy will not happen. This includes copies, blits, resolves, and copy
    // as draws.
    bool fMustSubmitCommandsBeforeCopyOp;

    typedef GrCaps INHERITED;
};

#endif
