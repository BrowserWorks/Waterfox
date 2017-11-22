# Copyright (c) 2014 The WebRTC project authors. All Rights Reserved.
#
# Use of this source code is governed by a BSD-style license
# that can be found in the LICENSE file in the root of the source
# tree. An additional intellectual property rights grant can be found
# in the file PATENTS.  All contributing project authors may
# be found in the AUTHORS file in the root of the source tree.
{
  'includes': ['build/common.gypi'],
  'targets': [
    {
      'target_name': 'webrtc_common',
      'type': 'static_library',
      'sources': [
        'common_types.cc',
        'common_types.h',
        'config.h',
        'config.cc',
        'engine_configurations.h',
        'typedefs.h',
      ],
    },
  ],
}
