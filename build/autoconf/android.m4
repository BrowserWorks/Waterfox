dnl This Source Code Form is subject to the terms of the Mozilla Public
dnl License, v. 2.0. If a copy of the MPL was not distributed with this
dnl file, You can obtain one at http://mozilla.org/MPL/2.0/.

AC_DEFUN([MOZ_ANDROID_NDK],
[

MOZ_ARG_WITH_STRING(android-cxx-stl,
[  --with-android-cxx-stl=VALUE
                          use the specified C++ STL (libstdc++, libc++)],
    android_cxx_stl=$withval,
    android_cxx_stl=libc++)

case "$target" in
*-android*|*-linuxandroid*)
    dnl $android_platform will be set for us by Python configure.
    CPPFLAGS="-idirafter $android_platform/usr/include $CPPFLAGS"
    CFLAGS="-fno-short-enums -fno-exceptions $CFLAGS"
    CXXFLAGS="-fno-short-enums -fno-exceptions $CXXFLAGS"
    ASFLAGS="-idirafter $android_platform/usr/include -DANDROID $ASFLAGS"

    dnl Add --allow-shlib-undefined, because libGLESv2 links to an
    dnl undefined symbol (present on the hardware, just not in the
    dnl NDK.)
    LDFLAGS="-L$android_platform/usr/lib -Wl,-rpath-link=$android_platform/usr/lib --sysroot=$android_platform -Wl,--allow-shlib-undefined $LDFLAGS"
    dnl Add -llog by default, since we use it all over the place.
    LIBS="-llog $LIBS"
    ANDROID_PLATFORM="${android_platform}"

    AC_DEFINE(ANDROID)
    AC_SUBST(ANDROID_PLATFORM)

    ;;
esac

])

AC_DEFUN([MOZ_ANDROID_CPU_ARCH],
[

if test "$OS_TARGET" = "Android"; then
    case "${CPU_ARCH}-${MOZ_ARCH}" in
    arm-armv7*)
        ANDROID_CPU_ARCH=armeabi-v7a
        ;;
    arm-*)
        ANDROID_CPU_ARCH=armeabi
        ;;
    x86-*)
        ANDROID_CPU_ARCH=x86
        ;;
    mips32-*) # When target_cpu is mipsel, CPU_ARCH is mips32
        ANDROID_CPU_ARCH=mips
        ;;
    aarch64-*)
        ANDROID_CPU_ARCH=arm64-v8a
        ;;
    esac

    AC_SUBST(ANDROID_CPU_ARCH)
fi
])

AC_DEFUN([MOZ_ANDROID_STLPORT],
[

if test "$OS_TARGET" = "Android"; then
    cpu_arch_dir="$ANDROID_CPU_ARCH"
    # NDK r12 removed the arm/thumb library split and just made everything
    # thumb by default.  Attempt to compensate.
    if test "$MOZ_THUMB2" = 1 -a -d "$cpu_arch_dir/thumb"; then
        cpu_arch_dir="$cpu_arch_dir/thumb"
    fi

    if test -z "$STLPORT_CPPFLAGS$STLPORT_LIBS"; then
        case "$android_cxx_stl" in
        libstdc++)
            # android-ndk-r8b and later
            ndk_base="$android_ndk/sources/cxx-stl/gnu-libstdc++/$android_gnu_compiler_version"
            ndk_libs_include="$ndk_base/libs/$ANDROID_CPU_ARCH"
            ndk_libs="$ndk_base/libs/$cpu_arch_dir"
            ndk_include="$ndk_base/include"

            if ! test -e "$ndk_libs/libgnustl_static.a"; then
                AC_MSG_ERROR([Couldn't find path to gnu-libstdc++ in the android ndk])
            fi

            STLPORT_LIBS="-L$ndk_libs -lgnustl_static"
            STLPORT_CPPFLAGS="-I$ndk_include -I$ndk_include/backward -I$ndk_libs_include/include"
            ;;
        libc++)
            # android-ndk-r8b and later
            ndk_base="$android_ndk/sources/cxx-stl"
            cxx_base="$ndk_base/llvm-libc++"
            cxx_libs="$cxx_base/libs/$cpu_arch_dir"
            cxx_include="$cxx_base/libcxx/include"
            cxxabi_base="$ndk_base/llvm-libc++abi"
            cxxabi_include="$cxxabi_base/libcxxabi/include"

            if ! test -e "$cxx_libs/libc++_static.a"; then
                AC_MSG_ERROR([Couldn't find path to llvm-libc++ in the android ndk])
            fi

            STLPORT_LIBS="-L$cxx_libs -lc++_static"
            # NDK r12 split the libc++ runtime libraries into pieces.
            for lib in c++abi unwind android_support; do
                if test -e "$cxx_libs/lib${lib}.a"; then
                     STLPORT_LIBS="$STLPORT_LIBS -l${lib}"
                fi
            done
            # Add android/support/include/ for prototyping long double math
            # functions, locale-specific C library functions, multibyte support,
            # etc.
            STLPORT_CPPFLAGS="-I$android_ndk/sources/android/support/include -I$cxx_include -I$cxxabi_include"
            ;;
        *)
            AC_MSG_ERROR([Bad value for --enable-android-cxx-stl])
            ;;
        esac
    fi
    CXXFLAGS="$CXXFLAGS $STLPORT_CPPFLAGS"
fi
MOZ_ANDROID_CXX_STL=$android_cxx_stl
AC_SUBST([MOZ_ANDROID_CXX_STL])
AC_SUBST([STLPORT_LIBS])

])


AC_DEFUN([concat],[$1$2$3$4])

dnl Find a component of an AAR.
dnl Arg 1: variable name to expose, like ANDROID_SUPPORT_V4_LIB.
dnl Arg 2: path to component.
dnl Arg 3: if non-empty, expect and require component.
AC_DEFUN([MOZ_ANDROID_AAR_COMPONENT], [
  ifelse([$3], ,
  [
    if test -e "$$1" ; then
      AC_MSG_ERROR([Found unexpected exploded $1!])
    fi
  ],
  [
    AC_MSG_CHECKING([for $1])
    $1="$2"
    if ! test -e "$$1" ; then
      AC_MSG_ERROR([Could not find required exploded $1!])
    fi
    AC_MSG_RESULT([$$1])
    AC_SUBST($1)
  ])
])

dnl Find an AAR and expose variables representing its exploded components.
dnl AC_SUBSTs ANDROID_NAME_{AAR,AAR_RES,AAR_LIB,AAR_INTERNAL_LIB}.
dnl Arg 1: name, like play-services-base
dnl Arg 2: version, like 7.8.0
dnl Arg 3: extras subdirectory, either android or google
dnl Arg 4: package subdirectory, like com/google/android/gms
dnl Arg 5: if non-empty, expect and require internal_impl JAR.
dnl Arg 6: if non-empty, expect and require assets/ directory.
AC_DEFUN([MOZ_ANDROID_AAR],[
  define([local_aar_var_base], translit($1, [-a-z], [_A-Z]))
  define([local_aar_var], concat(ANDROID_, local_aar_var_base, _AAR))
  local_aar_var="$ANDROID_SDK_ROOT/extras/$3/m2repository/$4/$1/$2/$1-$2.aar"
  AC_MSG_CHECKING([for $1 AAR])
  if ! test -e "$local_aar_var" ; then
    AC_MSG_ERROR([You must download the $1 AAR.  Run the Android SDK tool and install the Android and Google Support Repositories under Extras.  See https://developer.android.com/tools/extras/support-library.html for more info. (Looked for $local_aar_var)])
  fi
  AC_SUBST(local_aar_var)
  AC_MSG_RESULT([$local_aar_var])

  if ! $PYTHON -m mozbuild.action.explode_aar --destdir=$MOZ_BUILD_ROOT/dist/exploded-aar $local_aar_var ; then
    AC_MSG_ERROR([Could not explode $local_aar_var!])
  fi

  define([root], $MOZ_BUILD_ROOT/dist/exploded-aar/$1-$2/)
  MOZ_ANDROID_AAR_COMPONENT(concat(local_aar_var, _LIB), concat(root, $1-$2-classes.jar), REQUIRED)
  MOZ_ANDROID_AAR_COMPONENT(concat(local_aar_var, _RES), concat(root, res), REQUIRED)
  MOZ_ANDROID_AAR_COMPONENT(concat(local_aar_var, _INTERNAL_LIB), concat(root, libs/$1-$2-internal_impl-$2.jar), $5)
  MOZ_ANDROID_AAR_COMPONENT(concat(local_aar_var, _ASSETS), concat(root, assets), $6)
])

AC_DEFUN([MOZ_ANDROID_GOOGLE_PLAY_SERVICES],
[

if test -n "$MOZ_NATIVE_DEVICES" ; then
    AC_SUBST(MOZ_NATIVE_DEVICES)

    MOZ_ANDROID_AAR(play-services-base, $ANDROID_GOOGLE_PLAY_SERVICES_VERSION, google, com/google/android/gms)
    MOZ_ANDROID_AAR(play-services-basement, $ANDROID_GOOGLE_PLAY_SERVICES_VERSION, google, com/google/android/gms)
    MOZ_ANDROID_AAR(play-services-cast, $ANDROID_GOOGLE_PLAY_SERVICES_VERSION, google, com/google/android/gms)
    MOZ_ANDROID_AAR(mediarouter-v7, $ANDROID_SUPPORT_LIBRARY_VERSION, android, com/android/support, REQUIRED_INTERNAL_IMPL)
fi

])

AC_DEFUN([MOZ_ANDROID_GOOGLE_CLOUD_MESSAGING],
[

if test -n "$MOZ_ANDROID_GCM" ; then
    MOZ_ANDROID_AAR(play-services-base, $ANDROID_GOOGLE_PLAY_SERVICES_VERSION, google, com/google/android/gms)
    MOZ_ANDROID_AAR(play-services-basement, $ANDROID_GOOGLE_PLAY_SERVICES_VERSION, google, com/google/android/gms)
    MOZ_ANDROID_AAR(play-services-gcm, $ANDROID_GOOGLE_PLAY_SERVICES_VERSION, google, com/google/android/gms)
    MOZ_ANDROID_AAR(play-services-measurement, $ANDROID_GOOGLE_PLAY_SERVICES_VERSION, google, com/google/android/gms)
fi

])

AC_DEFUN([MOZ_ANDROID_INSTALL_TRACKING],
[

if test -n "$MOZ_INSTALL_TRACKING"; then
    AC_SUBST(MOZ_INSTALL_TRACKING)
    MOZ_ANDROID_AAR(play-services-ads, $ANDROID_GOOGLE_PLAY_SERVICES_VERSION, google, com/google/android/gms)
    MOZ_ANDROID_AAR(play-services-basement, $ANDROID_GOOGLE_PLAY_SERVICES_VERSION, google, com/google/android/gms)
fi

])

dnl Configure an Android SDK.
dnl Arg 1: target SDK version, like 23.
dnl Arg 2: list of build-tools versions, like "23.0.3 23.0.1".
AC_DEFUN([MOZ_ANDROID_SDK],
[

MOZ_ARG_WITH_STRING(android-sdk,
[  --with-android-sdk=DIR
                          location where the Android SDK can be found (like ~/.mozbuild/android-sdk-linux)],
    android_sdk_root=$withval)

android_sdk_root=${withval%/platforms/android-*}

case "$target" in
*-android*|*-linuxandroid*)
    if test -z "$android_sdk_root" ; then
        AC_MSG_ERROR([You must specify --with-android-sdk=/path/to/sdk when targeting Android.])
    fi

    # We were given an old-style
    # --with-android-sdk=/path/to/sdk/platforms/android-*.  We could warn, but
    # we'll get compliance by forcing the issue.
    if test -e "$withval"/source.properties ; then
        AC_MSG_ERROR([Including platforms/android-* in --with-android-sdk arguments is deprecated.  Use --with-android-sdk=$android_sdk_root.])
    fi

    android_target_sdk=$1
    AC_MSG_CHECKING([for Android SDK platform version $android_target_sdk])
    android_sdk=$android_sdk_root/platforms/android-$android_target_sdk
    if ! test -e "$android_sdk/source.properties" ; then
        AC_MSG_ERROR([You must download Android SDK platform version $android_target_sdk.  Try |mach bootstrap|.  (Looked for $android_sdk)])
    fi
    AC_MSG_RESULT([$android_sdk])

    AC_MSG_CHECKING([for Android build-tools])
    android_build_tools_base="$android_sdk_root"/build-tools
    android_build_tools_version=""
    for version in $2; do
        android_build_tools="$android_build_tools_base"/$version
        if test -d "$android_build_tools" -a -f "$android_build_tools/aapt"; then
            android_build_tools_version=$version
            AC_MSG_RESULT([$android_build_tools])
            break
        fi
    done
    if test "$android_build_tools_version" = ""; then
        version=$(echo $2 | cut -d" " -f1)
        AC_MSG_ERROR([You must install the Android build-tools version $version.  Try |mach bootstrap|.  (Looked for "$android_build_tools_base"/$version)])
    fi

    MOZ_PATH_PROG(ZIPALIGN, zipalign, :, [$android_build_tools])
    MOZ_PATH_PROG(DX, dx, :, [$android_build_tools])
    MOZ_PATH_PROG(AAPT, aapt, :, [$android_build_tools])
    MOZ_PATH_PROG(AIDL, aidl, :, [$android_build_tools])
    if test -z "$ZIPALIGN" -o "$ZIPALIGN" = ":"; then
      AC_MSG_ERROR([The program zipalign was not found.  Try |mach bootstrap|.])
    fi
    if test -z "$DX" -o "$DX" = ":"; then
      AC_MSG_ERROR([The program dx was not found.  Try |mach bootstrap|.])
    fi
    if test -z "$AAPT" -o "$AAPT" = ":"; then
      AC_MSG_ERROR([The program aapt was not found.  Try |mach bootstrap|.])
    fi
    if test -z "$AIDL" -o "$AIDL" = ":"; then
      AC_MSG_ERROR([The program aidl was not found.  Try |mach bootstrap|.])
    fi

    android_platform_tools="$android_sdk_root"/platform-tools
    AC_MSG_CHECKING([for Android platform-tools])
    if test -d "$android_platform_tools" -a -f "$android_platform_tools/adb"; then
        AC_MSG_RESULT([$android_platform_tools])
    else
        AC_MSG_ERROR([You must install the Android platform-tools.  Try |mach bootstrap|.  (Looked for $android_platform_tools)])
    fi

    MOZ_PATH_PROG(ADB, adb, :, [$android_platform_tools])
    if test -z "$ADB" -o "$ADB" = ":"; then
      AC_MSG_ERROR([The program adb was not found.  Try |mach bootstrap|.])
    fi

    android_tools="$android_sdk_root"/tools
    AC_MSG_CHECKING([for Android tools])
    if test -d "$android_tools" -a -f "$android_tools/emulator"; then
        AC_MSG_RESULT([$android_tools])
    else
        AC_MSG_ERROR([You must install the Android tools.  Try |mach bootstrap|.  (Looked for $android_tools)])
    fi

    MOZ_PATH_PROG(EMULATOR, emulator, :, [$android_tools])
    if test -z "$EMULATOR" -o "$EMULATOR" = ":"; then
      AC_MSG_ERROR([The program emulator was not found.  Try |mach bootstrap|.])
    fi

    ANDROID_TARGET_SDK="${android_target_sdk}"
    ANDROID_SDK="${android_sdk}"
    ANDROID_SDK_ROOT="${android_sdk_root}"
    ANDROID_TOOLS="${android_tools}"
    ANDROID_BUILD_TOOLS_VERSION="$android_build_tools_version"
    AC_DEFINE_UNQUOTED(ANDROID_TARGET_SDK,$ANDROID_TARGET_SDK)
    AC_SUBST(ANDROID_TARGET_SDK)
    AC_SUBST(ANDROID_SDK_ROOT)
    AC_SUBST(ANDROID_SDK)
    AC_SUBST(ANDROID_TOOLS)
    AC_SUBST(ANDROID_BUILD_TOOLS_VERSION)

    MOZ_ANDROID_AAR(customtabs, $ANDROID_SUPPORT_LIBRARY_VERSION, android, com/android/support)
    MOZ_ANDROID_AAR(appcompat-v7, $ANDROID_SUPPORT_LIBRARY_VERSION, android, com/android/support)
    MOZ_ANDROID_AAR(support-vector-drawable, $ANDROID_SUPPORT_LIBRARY_VERSION, android, com/android/support)
    MOZ_ANDROID_AAR(animated-vector-drawable, $ANDROID_SUPPORT_LIBRARY_VERSION, android, com/android/support)
    MOZ_ANDROID_AAR(cardview-v7, $ANDROID_SUPPORT_LIBRARY_VERSION, android, com/android/support)
    MOZ_ANDROID_AAR(design, $ANDROID_SUPPORT_LIBRARY_VERSION, android, com/android/support)
    MOZ_ANDROID_AAR(recyclerview-v7, $ANDROID_SUPPORT_LIBRARY_VERSION, android, com/android/support)
    MOZ_ANDROID_AAR(support-v4, $ANDROID_SUPPORT_LIBRARY_VERSION, android, com/android/support, REQUIRED_INTERNAL_IMPL)
    MOZ_ANDROID_AAR(palette-v7, $ANDROID_SUPPORT_LIBRARY_VERSION, android, com/android/support)

    ANDROID_SUPPORT_ANNOTATIONS_JAR="$ANDROID_SDK_ROOT/extras/android/m2repository/com/android/support/support-annotations/$ANDROID_SUPPORT_LIBRARY_VERSION/support-annotations-$ANDROID_SUPPORT_LIBRARY_VERSION.jar"
    AC_MSG_CHECKING([for support-annotations JAR])
    if ! test -e $ANDROID_SUPPORT_ANNOTATIONS_JAR ; then
        AC_MSG_ERROR([You must download the support-annotations lib.  Run the Android SDK tool and install the Android Support Repository under Extras.  See https://developer.android.com/tools/extras/support-library.html for more info. (looked for $ANDROID_SUPPORT_ANNOTATIONS_JAR)])
    fi
    AC_MSG_RESULT([$ANDROID_SUPPORT_ANNOTATIONS_JAR])
    AC_SUBST(ANDROID_SUPPORT_ANNOTATIONS_JAR)
    ANDROID_SUPPORT_ANNOTATIONS_JAR_LIB=$ANDROID_SUPPORT_ANNOTATIONS_JAR
    AC_SUBST(ANDROID_SUPPORT_ANNOTATIONS_JAR_LIB)
    ;;
esac

MOZ_ARG_WITH_STRING(android-min-sdk,
[  --with-android-min-sdk=[VER]     Impose a minimum Firefox for Android SDK version],
[ MOZ_ANDROID_MIN_SDK_VERSION=$withval ])

MOZ_ARG_WITH_STRING(android-max-sdk,
[  --with-android-max-sdk=[VER]     Impose a maximum Firefox for Android SDK version],
[ MOZ_ANDROID_MAX_SDK_VERSION=$withval ])

if test -n "$MOZ_ANDROID_MIN_SDK_VERSION"; then
    if test -n "$MOZ_ANDROID_MAX_SDK_VERSION"; then
        if test $MOZ_ANDROID_MAX_SDK_VERSION -lt $MOZ_ANDROID_MIN_SDK_VERSION ; then
            AC_MSG_ERROR([--with-android-max-sdk must be at least the value of --with-android-min-sdk.])
        fi
    fi

    if test $MOZ_ANDROID_MIN_SDK_VERSION -gt $ANDROID_TARGET_SDK ; then
        AC_MSG_ERROR([--with-android-min-sdk is expected to be less than $ANDROID_TARGET_SDK])
    fi

    AC_DEFINE_UNQUOTED(MOZ_ANDROID_MIN_SDK_VERSION, $MOZ_ANDROID_MIN_SDK_VERSION)
    AC_SUBST(MOZ_ANDROID_MIN_SDK_VERSION)
fi

if test -n "$MOZ_ANDROID_MAX_SDK_VERSION"; then
    AC_DEFINE_UNQUOTED(MOZ_ANDROID_MAX_SDK_VERSION, $MOZ_ANDROID_MAX_SDK_VERSION)
    AC_SUBST(MOZ_ANDROID_MAX_SDK_VERSION)
fi

])
