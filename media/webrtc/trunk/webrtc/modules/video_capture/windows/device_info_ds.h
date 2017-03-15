/*
 *  Copyright (c) 2012 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#ifndef WEBRTC_MODULES_VIDEO_CAPTURE_MAIN_SOURCE_WINDOWS_DEVICE_INFO_DS_H_
#define WEBRTC_MODULES_VIDEO_CAPTURE_MAIN_SOURCE_WINDOWS_DEVICE_INFO_DS_H_

#include "webrtc/modules/video_capture/device_info_impl.h"
#include "webrtc/modules/video_capture/video_capture_impl.h"
#include "base/singleton.h"

#include <Dshow.h>
#include <windows.h>

namespace webrtc
{
namespace videocapturemodule
{
struct VideoCaptureCapabilityWindows: public VideoCaptureCapability
{
    uint32_t directShowCapabilityIndex;
    bool supportFrameRateControl;
    VideoCaptureCapabilityWindows()
    {
        directShowCapabilityIndex = 0;
        supportFrameRateControl = false;
    }
};

class DeviceInfoDS: public DeviceInfoImpl
{
public:
    // Factory function.
    static DeviceInfoDS* Create(const int32_t id);

    DeviceInfoDS(const int32_t id);
    virtual ~DeviceInfoDS();

    int32_t Init();
    virtual uint32_t NumberOfDevices();
    int32_t Refresh() { return 0; }

    /*
     * Returns the available capture devices.
     */
    virtual int32_t
        GetDeviceName(uint32_t deviceNumber,
                      char* deviceNameUTF8,
                      uint32_t deviceNameLength,
                      char* deviceUniqueIdUTF8,
                      uint32_t deviceUniqueIdUTF8Length,
                      char* productUniqueIdUTF8,
                      uint32_t productUniqueIdUTF8Length,
                      pid_t* pid);

    /*
     * Display OS /capture device specific settings dialog
     */
    virtual int32_t
        DisplayCaptureSettingsDialogBox(
                                        const char* deviceUniqueIdUTF8,
                                        const char* dialogTitleUTF8,
                                        void* parentWindow,
                                        uint32_t positionX,
                                        uint32_t positionY);

    // Windows specific

    /* Gets a capture device filter
     The user of this API is responsible for releasing the filter when it not needed.
     */
    IBaseFilter * GetDeviceFilter(const char* deviceUniqueIdUTF8,
                                  char* productUniqueIdUTF8 = NULL,
                                  uint32_t productUniqueIdUTF8Length = 0);

    int32_t
        GetWindowsCapability(const int32_t capabilityIndex,
                             VideoCaptureCapabilityWindows& windowsCapability);

    static void GetProductId(const char* devicePath,
                             char* productUniqueIdUTF8,
                             uint32_t productUniqueIdUTF8Length);

protected:
    int32_t GetDeviceInfo(uint32_t deviceNumber,
                          char* deviceNameUTF8,
                          uint32_t deviceNameLength,
                          char* deviceUniqueIdUTF8,
                          uint32_t deviceUniqueIdUTF8Length,
                          char* productUniqueIdUTF8,
                          uint32_t productUniqueIdUTF8Length,
                          pid_t* pid);

    virtual int32_t
        CreateCapabilityMap(const char* deviceUniqueIdUTF8);
private:
    ICreateDevEnum* _dsDevEnum;
    bool _CoUninitializeIsRequired;
    std::vector<VideoCaptureCapabilityWindows> _captureCapabilitiesWindows;
    HWND _hwnd;
    WNDCLASS _wndClass;
    HINSTANCE _hInstance;
};
}  // namespace videocapturemodule
}  // namespace webrtc
#endif // WEBRTC_MODULES_VIDEO_CAPTURE_MAIN_SOURCE_WINDOWS_DEVICE_INFO_DS_H_
