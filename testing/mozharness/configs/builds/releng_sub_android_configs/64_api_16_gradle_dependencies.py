config = {
    'stage_platform': 'android-api-16-gradle-dependencies',
    'src_mozconfig': 'mobile/android/config/mozconfigs/android-api-16-gradle-dependencies/nightly',
     # gradle-dependencies doesn't produce a package. So don't collect package metrics.
    'postflight_build_mach_commands': [
        ['android',
         'gradle-dependencies',
        ],
    ],
    'max_build_output_timeout': 0,
}
