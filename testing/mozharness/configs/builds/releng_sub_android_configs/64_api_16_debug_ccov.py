config = {
    'stage_platform': 'android-api-16-debug-ccov',
    'src_mozconfig': 'mobile/android/config/mozconfigs/android-api-16/debug-ccov',
    'debug_build': True,
    'postflight_build_mach_commands': [
        ['android',
         'archive-coverage-artifacts',
        ],
    ],
}
