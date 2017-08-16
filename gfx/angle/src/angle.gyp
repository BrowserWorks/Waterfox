# Copyright (c) 2012 The ANGLE Project Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

{
    'variables':
    {
        'angle_code': 1,
        'angle_gen_path': '<(SHARED_INTERMEDIATE_DIR)/angle',
        'angle_id_script_base': 'commit_id.py',
        'angle_id_script': '<(angle_gen_path)/<(angle_id_script_base)',
        'angle_id_header_base': 'commit.h',
        'angle_id_header': '<(angle_gen_path)/id/<(angle_id_header_base)',
        'angle_use_commit_id%': '<!(python <(angle_id_script_base) check ..)',
        'angle_enable_d3d9%': 0,
        'angle_enable_d3d11%': 0,
        'angle_enable_gl%': 0,
        'angle_enable_vulkan%': 0,
        'angle_enable_essl%': 1, # Enable this for all configs by default
        'angle_enable_glsl%': 1, # Enable this for all configs by default
        'angle_enable_hlsl%': 0,
        'angle_link_glx%': 0,
        'angle_gl_library_type%': 'shared_library',
        'dcheck_always_on%': 0,
        'conditions':
        [
            ['OS=="win"',
            {
                'angle_enable_gl%': 1,
                'angle_enable_d3d9%': 1,
                'angle_enable_d3d11%': 1,
                'angle_enable_hlsl%': 1,
                'angle_enable_vulkan%': 1,
            }],
            ['OS=="linux" and use_x11==1 and chromeos==0',
            {
                'angle_enable_gl%': 1,
            }],
            ['OS=="mac"',
            {
                'angle_enable_gl%': 1,
            }],
            ['use_ozone==1',
            {
                'angle_enable_gl%': 1,
            }],
        ],
        'angle_enable_null%': 1, # Available on all platforms
    },
    'includes':
    [
        'compiler.gypi',
        'libGLESv2.gypi',
        'libEGL.gypi'
    ],

    'targets':
    [
        {
            'target_name': 'angle_common',
            'type': 'static_library',
            'includes': [ '../gyp/common_defines.gypi', ],
            'sources':
            [
                '<@(libangle_common_sources)',
            ],
            'include_dirs':
            [
                '.',
                '../include',
                'common/third_party/numerics',
            ],
            'dependencies':
            [
                'commit_id',
            ],
            'direct_dependent_settings':
            {
                'include_dirs':
                [
                    '<(angle_path)/include',
                    '<(angle_path)/src',
                    '<(angle_path)/src/common/third_party/numerics',
                ],
                'conditions':
                [
                    ['dcheck_always_on==1',
                    {
                        'configurations':
                        {
                            'Release_Base':
                            {
                                'defines':
                                [
                                    'ANGLE_ENABLE_RELEASE_ASSERTS',
                                ],
                            },
                        },
                    }],
                    ['OS=="win"',
                    {
                        'configurations':
                        {
                            'Debug_Base':
                            {
                                'defines':
                                [
                                    'ANGLE_ENABLE_DEBUG_ANNOTATIONS'
                                ],
                            },
                        },
                    }],
                ],
            },
            'conditions':
            [
                ['dcheck_always_on==1',
                {
                    'configurations':
                    {
                        'Release_Base':
                        {
                            'defines':
                            [
                                'ANGLE_ENABLE_RELEASE_ASSERTS',
                            ],
                        },
                    },
                }],
                ['OS=="win"',
                {
                    'configurations':
                    {
                        'Debug_Base':
                        {
                            'defines':
                            [
                                'ANGLE_ENABLE_DEBUG_ANNOTATIONS'
                            ],
                        },
                    },
                }],
            ],
        },

        {
            'target_name': 'angle_image_util',
            'type': 'static_library',
            'includes': [ '../gyp/common_defines.gypi', ],
            'sources':
            [
                '<@(libangle_image_util_sources)',
            ],
            'include_dirs':
            [
                '.',
                '../include',
            ],
            'dependencies':
            [
                'angle_common',
            ],
            'direct_dependent_settings':
            {
                'include_dirs':
                [
                    '<(angle_path)/include',
                    '<(angle_path)/src',
                ],
            },
        },

        {
            'target_name': 'copy_scripts',
            'type': 'none',
            'includes': [ '../gyp/common_defines.gypi', ],
            'hard_dependency': 1,
            'copies':
            [
                {
                    'destination': '<(angle_gen_path)',
                    'files': [ 'copy_compiler_dll.bat', '<(angle_id_script_base)' ],
                },
            ],
            'conditions':
            [
                ['angle_build_winrt==1',
                {
                    'type' : 'shared_library',
                }],
            ],
        },
    ],
    'conditions':
    [
        ['angle_use_commit_id!=0',
        {
            'targets':
            [
                {
                    'target_name': 'commit_id',
                    'type': 'none',
                    'includes': [ '../gyp/common_defines.gypi', ],
                    'dependencies': [ 'copy_scripts', ],
                    'hard_dependency': 1,
                    'actions':
                    [
                        {
                            'action_name': 'Generate ANGLE Commit ID Header',
                            'message': 'Generating ANGLE Commit ID',
                            # reference the git index as an input, so we rebuild on changes to the index
                            'inputs': [ '<(angle_id_script)', '<(angle_path)/.git/index' ],
                            'outputs': [ '<(angle_id_header)' ],
                            'msvs_cygwin_shell': 0,
                            'action':
                            [
                                'python', '<(angle_id_script)', 'gen', '<(angle_path)', '<(angle_id_header)'
                            ],
                        },
                    ],
                    'all_dependent_settings':
                    {
                        'include_dirs':
                        [
                            '<(angle_gen_path)',
                        ],
                    },
                    'conditions':
                    [
                        ['angle_build_winrt==1',
                        {
                            'type' : 'shared_library',
                        }],
                    ],
                }
            ]
        },
        { # angle_use_commit_id==0
            'targets':
            [
                {
                    'target_name': 'commit_id',
                    'type': 'none',
                    'hard_dependency': 1,
                    'includes': [ '../gyp/common_defines.gypi', ],
                    'copies':
                    [
                        {
                            'destination': '<(angle_gen_path)/id',
                            'files': [ '<(angle_id_header_base)' ]
                        }
                    ],
                    'all_dependent_settings':
                    {
                        'include_dirs':
                        [
                            '<(angle_gen_path)',
                        ],
                    },
                    'conditions':
                    [
                        ['angle_build_winrt==1',
                        {
                            'type' : 'shared_library',
                        }],
                    ],
                }
            ]
        }],
        ['OS=="win"',
        {
            'targets':
            [
                {
                    'target_name': 'copy_compiler_dll',
                    'type': 'none',
                    'dependencies': [ 'copy_scripts', ],
                    'includes': [ '../gyp/common_defines.gypi', ],
                    'conditions':
                    [
                        ['angle_build_winrt==0',
                        {
                            'actions':
                            [
                                {
                                    'action_name': 'copy_dll',
                                    'message': 'Copying D3D Compiler DLL...',
                                    'msvs_cygwin_shell': 0,
                                    'inputs': [ 'copy_compiler_dll.bat' ],
                                    'outputs': [ '<(PRODUCT_DIR)/d3dcompiler_47.dll' ],
                                    'action':
                                    [
                                        "<(angle_gen_path)/copy_compiler_dll.bat",
                                        "$(PlatformName)",
                                        "<(windows_sdk_path)",
                                        "<(PRODUCT_DIR)"
                                    ],
                                },
                            ], #actions
                        }],
                        ['angle_build_winrt==1',
                        {
                            'type' : 'shared_library',
                        }],
                    ]
                },
            ], # targets
        }],
    ] # conditions
}
