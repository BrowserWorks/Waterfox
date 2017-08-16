#!/bin/sh
##
##  configure.sh
##
##  This script is sourced by the main configure script and contains
##  utility functions and other common bits that aren't strictly libaom
##  related.
##
##  This build system is based in part on the FFmpeg configure script.
##


#
# Logging / Output Functions
#
die_unknown(){
  echo "Unknown option \"$1\"."
  echo "See $0 --help for available options."
  clean_temp_files
  exit 1
}

die() {
  echo "$@"
  echo
  echo "Configuration failed. This could reflect a misconfiguration of your"
  echo "toolchains, improper options selected, or another problem. If you"
  echo "don't see any useful error messages above, the next step is to look"
  echo "at the configure error log file ($logfile) to determine what"
  echo "configure was trying to do when it died."
  clean_temp_files
  exit 1
}

log(){
  echo "$@" >>$logfile
}

log_file(){
  log BEGIN $1
  cat -n $1 >>$logfile
  log END $1
}

log_echo() {
  echo "$@"
  log "$@"
}

fwrite () {
  outfile=$1
  shift
  echo "$@" >> ${outfile}
}

show_help_pre(){
  for opt in ${CMDLINE_SELECT}; do
    opt2=`echo $opt | sed -e 's;_;-;g'`
    if enabled $opt; then
      eval "toggle_${opt}=\"--disable-${opt2}\""
    else
      eval "toggle_${opt}=\"--enable-${opt2} \""
    fi
  done

  cat <<EOF
Usage: configure [options]
Options:

Build options:
  --help                      print this message
  --log=yes|no|FILE           file configure log is written to [config.log]
  --target=TARGET             target platform tuple [generic-gnu]
  --cpu=CPU                   optimize for a specific cpu rather than a family
  --extra-cflags=ECFLAGS      add ECFLAGS to CFLAGS [$CFLAGS]
  --extra-cxxflags=ECXXFLAGS  add ECXXFLAGS to CXXFLAGS [$CXXFLAGS]
  ${toggle_extra_warnings}    emit harmless warnings (always non-fatal)
  ${toggle_werror}            treat warnings as errors, if possible
                              (not available with all compilers)
  ${toggle_optimizations}     turn on/off compiler optimization flags
  ${toggle_pic}               turn on/off Position Independent Code
  ${toggle_ccache}            turn on/off compiler cache
  ${toggle_debug}             enable/disable debug mode
  ${toggle_gprof}             enable/disable gprof profiling instrumentation
  ${toggle_gcov}              enable/disable gcov coverage instrumentation
  ${toggle_thumb}             enable/disable building arm assembly in thumb mode
  ${toggle_dependency_tracking}
                              disable to speed up one-time build

Install options:
  ${toggle_install_docs}      control whether docs are installed
  ${toggle_install_bins}      control whether binaries are installed
  ${toggle_install_libs}      control whether libraries are installed
  ${toggle_install_srcs}      control whether sources are installed


EOF
}

show_help_post(){
  cat <<EOF


NOTES:
    Object files are built at the place where configure is launched.

    All boolean options can be negated. The default value is the opposite
    of that shown above. If the option --disable-foo is listed, then
    the default value for foo is enabled.

Supported targets:
EOF
  show_targets ${all_platforms}
  echo
  exit 1
}

show_targets() {
  while [ -n "$*" ]; do
    if [ "${1%%-*}" = "${2%%-*}" ]; then
      if [ "${2%%-*}" = "${3%%-*}" ]; then
        printf "    %-24s %-24s %-24s\n" "$1" "$2" "$3"
        shift; shift; shift
      else
        printf "    %-24s %-24s\n" "$1" "$2"
        shift; shift
      fi
    else
      printf "    %-24s\n" "$1"
      shift
    fi
  done
}

show_help() {
  show_help_pre
  show_help_post
}

#
# List Processing Functions
#
set_all(){
  value=$1
  shift
  for var in $*; do
    eval $var=$value
  done
}

is_in(){
  value=$1
  shift
  for var in $*; do
    [ $var = $value ] && return 0
  done
  return 1
}

add_cflags() {
  CFLAGS="${CFLAGS} $@"
  CXXFLAGS="${CXXFLAGS} $@"
}

add_cflags_only() {
  CFLAGS="${CFLAGS} $@"
}

add_cxxflags_only() {
  CXXFLAGS="${CXXFLAGS} $@"
}

add_ldflags() {
  LDFLAGS="${LDFLAGS} $@"
}

add_asflags() {
  ASFLAGS="${ASFLAGS} $@"
}

add_extralibs() {
  extralibs="${extralibs} $@"
}

#
# Boolean Manipulation Functions
#

enable_feature(){
  set_all yes $*
}

disable_feature(){
  set_all no $*
}

enabled(){
  eval test "x\$$1" = "xyes"
}

disabled(){
  eval test "x\$$1" = "xno"
}

enable_codec(){
  enabled "${1}" || echo "  enabling ${1}"
  enable_feature "${1}"

  is_in "${1}" av1 && enable_feature "${1}_encoder" "${1}_decoder"
}

disable_codec(){
  disabled "${1}" || echo "  disabling ${1}"
  disable_feature "${1}"

  is_in "${1}" av1 && disable_feature "${1}_encoder" "${1}_decoder"
}

# Iterates through positional parameters, checks to confirm the parameter has
# not been explicitly (force) disabled, and enables the setting controlled by
# the parameter when the setting is not disabled.
# Note: Does NOT alter RTCD generation options ($RTCD_OPTIONS).
soft_enable() {
  for var in $*; do
    if ! disabled $var; then
      enabled $var || log_echo "  enabling $var"
      enable_feature $var
    fi
  done
}

# Iterates through positional parameters, checks to confirm the parameter has
# not been explicitly (force) enabled, and disables the setting controlled by
# the parameter when the setting is not enabled.
# Note: Does NOT alter RTCD generation options ($RTCD_OPTIONS).
soft_disable() {
  for var in $*; do
    if ! enabled $var; then
      disabled $var || log_echo "  disabling $var"
      disable_feature $var
    fi
  done
}

#
# Text Processing Functions
#
toupper(){
  echo "$@" | tr abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ
}

tolower(){
  echo "$@" | tr ABCDEFGHIJKLMNOPQRSTUVWXYZ abcdefghijklmnopqrstuvwxyz
}

#
# Temporary File Functions
#
source_path=${0%/*}
enable_feature source_path_used
if [ -z "$source_path" ] || [ "$source_path" = "." ]; then
  source_path="`pwd`"
  disable_feature source_path_used
fi

if test ! -z "$TMPDIR" ; then
  TMPDIRx="${TMPDIR}"
elif test ! -z "$TEMPDIR" ; then
  TMPDIRx="${TEMPDIR}"
else
  TMPDIRx="/tmp"
fi
RAND=$(awk 'BEGIN { srand(); printf "%d\n",(rand() * 32768)}')
TMP_H="${TMPDIRx}/aom-conf-$$-${RAND}.h"
TMP_C="${TMPDIRx}/aom-conf-$$-${RAND}.c"
TMP_CC="${TMPDIRx}/aom-conf-$$-${RAND}.cc"
TMP_O="${TMPDIRx}/aom-conf-$$-${RAND}.o"
TMP_X="${TMPDIRx}/aom-conf-$$-${RAND}.x"
TMP_ASM="${TMPDIRx}/aom-conf-$$-${RAND}.asm"

clean_temp_files() {
  rm -f ${TMP_C} ${TMP_CC} ${TMP_H} ${TMP_O} ${TMP_X} ${TMP_ASM}
  enabled gcov && rm -f ${TMP_C%.c}.gcno ${TMP_CC%.cc}.gcno
}

#
# Toolchain Check Functions
#
check_cmd() {
  enabled external_build && return
  log "$@"
  "$@" >>${logfile} 2>&1
}

check_cc() {
  log check_cc "$@"
  cat >${TMP_C}
  log_file ${TMP_C}
  check_cmd ${CC} ${CFLAGS} "$@" -c -o ${TMP_O} ${TMP_C}
}

check_cxx() {
  log check_cxx "$@"
  cat >${TMP_CC}
  log_file ${TMP_CC}
  check_cmd ${CXX} ${CXXFLAGS} "$@" -c -o ${TMP_O} ${TMP_CC}
}

check_cpp() {
  log check_cpp "$@"
  cat > ${TMP_C}
  log_file ${TMP_C}
  check_cmd ${CC} ${CFLAGS} "$@" -E -o ${TMP_O} ${TMP_C}
}

check_ld() {
  log check_ld "$@"
  check_cc $@ \
    && check_cmd ${LD} ${LDFLAGS} "$@" -o ${TMP_X} ${TMP_O} ${extralibs}
}

check_header(){
  log check_header "$@"
  header=$1
  shift
  var=`echo $header | sed 's/[^A-Za-z0-9_]/_/g'`
  disable_feature $var
  check_cpp "$@" <<EOF && enable_feature $var
#include "$header"
int x;
EOF
}

check_cflags() {
 log check_cflags "$@"
 check_cc -Werror "$@" <<EOF
int x;
EOF
}

check_cxxflags() {
  log check_cxxflags "$@"

  # Catch CFLAGS that trigger CXX warnings
  case "$CXX" in
    *c++-analyzer|*clang++|*g++*)
      check_cxx -Werror "$@" <<EOF
int x;
EOF
      ;;
    *)
      check_cxx -Werror "$@" <<EOF
int x;
EOF
      ;;
    esac
}

check_add_cflags() {
  check_cxxflags "$@" && add_cxxflags_only "$@"
  check_cflags "$@" && add_cflags_only "$@"
}

check_add_cxxflags() {
  check_cxxflags "$@" && add_cxxflags_only "$@"
}

check_add_asflags() {
  log add_asflags "$@"
  add_asflags "$@"
}

check_add_ldflags() {
  log add_ldflags "$@"
  add_ldflags "$@"
}

check_asm_align() {
  log check_asm_align "$@"
  cat >${TMP_ASM} <<EOF
section .rodata
align 16
EOF
  log_file ${TMP_ASM}
  check_cmd ${AS} ${ASFLAGS} -o ${TMP_O} ${TMP_ASM}
  readelf -WS ${TMP_O} >${TMP_X}
  log_file ${TMP_X}
  if ! grep -q '\.rodata .* 16$' ${TMP_X}; then
    die "${AS} ${ASFLAGS} does not support section alignment (nasm <=2.08?)"
  fi
}

# tests for -m$1 toggling the feature given in $2. If $2 is empty $1 is used.
check_gcc_machine_option() {
  opt="$1"
  feature="$2"
  [ -n "$feature" ] || feature="$opt"

  if enabled gcc && ! disabled "$feature" && ! check_cflags "-m$opt"; then
    RTCD_OPTIONS="${RTCD_OPTIONS}--disable-$feature "
  else
    soft_enable "$feature"
  fi
}

write_common_config_banner() {
  print_webm_license config.mk "##" ""
  echo '# This file automatically generated by configure. Do not edit!' >> config.mk
  echo "TOOLCHAIN := ${toolchain}" >> config.mk

  case ${toolchain} in
    *-linux-rvct)
      echo "ALT_LIBC := ${alt_libc}" >> config.mk
      ;;
  esac
}

write_common_config_targets() {
  for t in ${all_targets}; do
    if enabled ${t}; then
      if enabled child; then
        fwrite config.mk "ALL_TARGETS += ${t}-${toolchain}"
      else
        fwrite config.mk "ALL_TARGETS += ${t}"
      fi
    fi
    true;
  done
  true
}

write_common_target_config_mk() {
  saved_CC="${CC}"
  saved_CXX="${CXX}"
  enabled ccache && CC="ccache ${CC}"
  enabled ccache && CXX="ccache ${CXX}"
  print_webm_license $1 "##" ""

  cat >> $1 << EOF
# This file automatically generated by configure. Do not edit!
SRC_PATH="$source_path"
SRC_PATH_BARE=$source_path
BUILD_PFX=${BUILD_PFX}
TOOLCHAIN=${toolchain}
ASM_CONVERSION=${asm_conversion_cmd:-${source_path}/build/make/ads2gas.pl}
GEN_VCPROJ=${gen_vcproj_cmd}
MSVS_ARCH_DIR=${msvs_arch_dir}

CC=${CC}
CXX=${CXX}
AR=${AR}
LD=${LD}
AS=${AS}
STRIP=${STRIP}
NM=${NM}

CFLAGS  = ${CFLAGS}
CXXFLAGS  = ${CXXFLAGS}
ARFLAGS = crs\$(if \$(quiet),,v)
LDFLAGS = ${LDFLAGS}
ASFLAGS = ${ASFLAGS}
extralibs = ${extralibs}
AS_SFX    = ${AS_SFX:-.asm}
EXE_SFX   = ${EXE_SFX}
VCPROJ_SFX = ${VCPROJ_SFX}
RTCD_OPTIONS = ${RTCD_OPTIONS}
WX_CXXFLAGS = ${WX_CXXFLAGS}
WX_LDFLAGS = ${WX_LDFLAGS}
EOF

  if enabled rvct; then cat >> $1 << EOF
fmt_deps = sed -e 's;^__image.axf;\${@:.d=.o} \$@;' #hide
EOF
  else cat >> $1 << EOF
fmt_deps = sed -e 's;^\([a-zA-Z0-9_]*\)\.o;\${@:.d=.o} \$@;'
EOF
  fi

  print_config_mk ARCH   "${1}" ${ARCH_LIST}
  print_config_mk HAVE   "${1}" ${HAVE_LIST}
  print_config_mk CONFIG "${1}" ${CONFIG_LIST}
  print_config_mk HAVE   "${1}" gnu_strip

  enabled msvs && echo "CONFIG_VS_VERSION=${vs_version}" >> "${1}"

  CC="${saved_CC}"
  CXX="${saved_CXX}"
}

write_common_target_config_h() {
  print_webm_license ${TMP_H} "/*" " */"
  cat >> ${TMP_H} << EOF
/* This file automatically generated by configure. Do not edit! */
#ifndef AOM_CONFIG_H
#define AOM_CONFIG_H
#define RESTRICT    ${RESTRICT}
#define INLINE      ${INLINE}
EOF
  print_config_h ARCH   "${TMP_H}" ${ARCH_LIST}
  print_config_h HAVE   "${TMP_H}" ${HAVE_LIST}
  print_config_h CONFIG "${TMP_H}" ${CONFIG_LIST}
  print_config_vars_h   "${TMP_H}" ${VAR_LIST}
  echo "#endif /* AOM_CONFIG_H */" >> ${TMP_H}
  mkdir -p `dirname "$1"`
  cmp "$1" ${TMP_H} >/dev/null 2>&1 || mv ${TMP_H} "$1"
}

process_common_cmdline() {
  for opt in "$@"; do
    optval="${opt#*=}"
    case "$opt" in
      --child)
        enable_feature child
        ;;
      --log*)
        logging="$optval"
        if ! disabled logging ; then
          enabled logging || logfile="$logging"
        else
          logfile=/dev/null
        fi
        ;;
      --target=*)
        toolchain="${toolchain:-${optval}}"
        ;;
      --force-target=*)
        toolchain="${toolchain:-${optval}}"
        enable_feature force_toolchain
        ;;
      --cpu=*)
        tune_cpu="$optval"
        ;;
      --extra-cflags=*)
        extra_cflags="${optval}"
        ;;
      --extra-cxxflags=*)
        extra_cxxflags="${optval}"
        ;;
      --enable-?*|--disable-?*)
        eval `echo "$opt" | sed 's/--/action=/;s/-/ option=/;s/-/_/g'`
        if is_in ${option} ${ARCH_EXT_LIST}; then
          [ $action = "disable" ] && RTCD_OPTIONS="${RTCD_OPTIONS}--disable-${option} "
        elif [ $action = "disable" ] && ! disabled $option ; then
          is_in ${option} ${CMDLINE_SELECT} || die_unknown $opt
          log_echo "  disabling $option"
        elif [ $action = "enable" ] && ! enabled $option ; then
          is_in ${option} ${CMDLINE_SELECT} || die_unknown $opt
          log_echo "  enabling $option"
        fi
        ${action}_feature $option
        ;;
      --require-?*)
        eval `echo "$opt" | sed 's/--/action=/;s/-/ option=/;s/-/_/g'`
        if is_in ${option} ${ARCH_EXT_LIST}; then
            RTCD_OPTIONS="${RTCD_OPTIONS}${opt} "
        else
            die_unknown $opt
        fi
        ;;
      --force-enable-?*|--force-disable-?*)
        eval `echo "$opt" | sed 's/--force-/action=/;s/-/ option=/;s/-/_/g'`
        ${action}_feature $option
        ;;
      --libc=*)
        [ -d "${optval}" ] || die "Not a directory: ${optval}"
        disable_feature builtin_libc
        alt_libc="${optval}"
        ;;
      --as=*)
        [ "${optval}" = yasm ] || [ "${optval}" = nasm ] \
          || [ "${optval}" = auto ] \
          || die "Must be yasm, nasm or auto: ${optval}"
        alt_as="${optval}"
        ;;
      --size-limit=*)
        w="${optval%%x*}"
        h="${optval##*x}"
        VAR_LIST="DECODE_WIDTH_LIMIT ${w} DECODE_HEIGHT_LIMIT ${h}"
        [ ${w} -gt 0 ] && [ ${h} -gt 0 ] || die "Invalid size-limit: too small."
        [ ${w} -lt 65536 ] && [ ${h} -lt 65536 ] \
            || die "Invalid size-limit: too big."
        enable_feature size_limit
        ;;
      --prefix=*)
        prefix="${optval}"
        ;;
      --libdir=*)
        libdir="${optval}"
        ;;
      --sdk-path=*)
        [ -d "${optval}" ] || die "Not a directory: ${optval}"
        sdk_path="${optval}"
        ;;
      --libc|--as|--prefix|--libdir|--sdk-path)
        die "Option ${opt} requires argument"
        ;;
      --help|-h)
        show_help
        ;;
      *)
        die_unknown $opt
        ;;
    esac
  done
}

process_cmdline() {
  for opt do
    optval="${opt#*=}"
    case "$opt" in
      *)
        process_common_cmdline $opt
        ;;
    esac
  done
}

post_process_common_cmdline() {
  prefix="${prefix:-/usr/local}"
  prefix="${prefix%/}"
  libdir="${libdir:-${prefix}/lib}"
  libdir="${libdir%/}"
  if [ "${libdir#${prefix}}" = "${libdir}" ]; then
    die "Libdir ${libdir} must be a subdirectory of ${prefix}"
  fi
}

post_process_cmdline() {
  true;
}

setup_gnu_toolchain() {
  CC=${CC:-${CROSS}gcc}
  CXX=${CXX:-${CROSS}g++}
  AR=${AR:-${CROSS}ar}
  LD=${LD:-${CROSS}${link_with_cc:-ld}}
  AS=${AS:-${CROSS}as}
  STRIP=${STRIP:-${CROSS}strip}
  NM=${NM:-${CROSS}nm}
  AS_SFX=.s
  EXE_SFX=
}

# Reliably find the newest available Darwin SDKs. (Older versions of
# xcrun don't support --show-sdk-path.)
show_darwin_sdk_path() {
  xcrun --sdk $1 --show-sdk-path 2>/dev/null ||
    xcodebuild -sdk $1 -version Path 2>/dev/null
}

# Print the major version number of the Darwin SDK specified by $1.
show_darwin_sdk_major_version() {
  xcrun --sdk $1 --show-sdk-version 2>/dev/null | cut -d. -f1
}

# Print the Xcode version.
show_xcode_version() {
  xcodebuild -version | head -n1 | cut -d' ' -f2
}

# Fails when Xcode version is less than 6.3.
check_xcode_minimum_version() {
  xcode_major=$(show_xcode_version | cut -f1 -d.)
  xcode_minor=$(show_xcode_version | cut -f2 -d.)
  xcode_min_major=6
  xcode_min_minor=3
  if [ ${xcode_major} -lt ${xcode_min_major} ]; then
    return 1
  fi
  if [ ${xcode_major} -eq ${xcode_min_major} ] \
    && [ ${xcode_minor} -lt ${xcode_min_minor} ]; then
    return 1
  fi
}

process_common_toolchain() {
  case "$toolchain" in
    *-vs*) ;;
    *) add_cflags_only -std=c99 ;;
  esac

  if [ -z "$toolchain" ]; then
    gcctarget="${CHOST:-$(gcc -dumpmachine 2> /dev/null)}"

    # detect tgt_isa
    case "$gcctarget" in
      aarch64*)
        tgt_isa=arm64
        ;;
      armv7*-hardfloat* | armv7*-gnueabihf | arm-*-gnueabihf)
        tgt_isa=armv7
        float_abi=hard
        ;;
      armv7*)
        tgt_isa=armv7
        float_abi=softfp
        ;;
      *x86_64*|*amd64*)
        tgt_isa=x86_64
        ;;
      *i[3456]86*)
        tgt_isa=x86
        ;;
      *sparc*)
        tgt_isa=sparc
        ;;
    esac

    # detect tgt_os
    case "$gcctarget" in
      *darwin10*)
        tgt_isa=x86_64
        tgt_os=darwin10
        ;;
      *darwin11*)
        tgt_isa=x86_64
        tgt_os=darwin11
        ;;
      *darwin12*)
        tgt_isa=x86_64
        tgt_os=darwin12
        ;;
      *darwin13*)
        tgt_isa=x86_64
        tgt_os=darwin13
        ;;
      *darwin14*)
        tgt_isa=x86_64
        tgt_os=darwin14
        ;;
      *darwin15*)
        tgt_isa=x86_64
        tgt_os=darwin15
        ;;
       *darwin16*)
        tgt_isa=x86_64
        tgt_os=darwin16
        ;;
      x86_64*mingw32*)
        tgt_os=win64
        ;;
      *mingw32*|*cygwin*)
        [ -z "$tgt_isa" ] && tgt_isa=x86
        tgt_os=win32
        ;;
      *linux*|*bsd*)
        tgt_os=linux
        ;;
      *solaris2.10)
        tgt_os=solaris
        ;;
      *os2*)
        tgt_os=os2
        ;;
    esac

    if [ -n "$tgt_isa" ] && [ -n "$tgt_os" ]; then
      toolchain=${tgt_isa}-${tgt_os}-gcc
    fi
  fi

  toolchain=${toolchain:-generic-gnu}

  is_in ${toolchain} ${all_platforms} || enabled force_toolchain \
    || die "Unrecognized toolchain '${toolchain}'"

  enabled child || log_echo "Configuring for target '${toolchain}'"

  #
  # Set up toolchain variables
  #
  tgt_isa=$(echo ${toolchain} | awk 'BEGIN{FS="-"}{print $1}')
  tgt_os=$(echo ${toolchain} | awk 'BEGIN{FS="-"}{print $2}')
  tgt_cc=$(echo ${toolchain} | awk 'BEGIN{FS="-"}{print $3}')

  # Mark the specific ISA requested as enabled
  soft_enable ${tgt_isa}
  enable_feature ${tgt_os}
  enable_feature ${tgt_cc}

  # Enable the architecture family
  case ${tgt_isa} in
    arm*)
      enable_feature arm
      ;;
    mips*)
      enable_feature mips
      ;;
  esac

  # PIC is probably what we want when building shared libs
  enabled shared && soft_enable pic

  # Minimum iOS version for all target platforms (darwin and iphonesimulator).
  # Shared library framework builds are only possible on iOS 8 and later.
  if enabled shared; then
    IOS_VERSION_OPTIONS="--enable-shared"
    IOS_VERSION_MIN="8.0"
  else
    IOS_VERSION_OPTIONS=""
    IOS_VERSION_MIN="6.0"
  fi

  # Handle darwin variants. Newer SDKs allow targeting older
  # platforms, so use the newest one available.
  case ${toolchain} in
    arm*-darwin*)
      add_cflags "-miphoneos-version-min=${IOS_VERSION_MIN}"
      iphoneos_sdk_dir="$(show_darwin_sdk_path iphoneos)"
      if [ -d "${iphoneos_sdk_dir}" ]; then
        add_cflags  "-isysroot ${iphoneos_sdk_dir}"
        add_ldflags "-isysroot ${iphoneos_sdk_dir}"
      fi
      ;;
    x86*-darwin*)
      osx_sdk_dir="$(show_darwin_sdk_path macosx)"
      if [ -d "${osx_sdk_dir}" ]; then
        add_cflags  "-isysroot ${osx_sdk_dir}"
        add_ldflags "-isysroot ${osx_sdk_dir}"
      fi
      ;;
  esac

  case ${toolchain} in
    *-darwin8-*)
      add_cflags  "-mmacosx-version-min=10.4"
      add_ldflags "-mmacosx-version-min=10.4"
      ;;
    *-darwin9-*)
      add_cflags  "-mmacosx-version-min=10.5"
      add_ldflags "-mmacosx-version-min=10.5"
      ;;
    *-darwin10-*)
      add_cflags  "-mmacosx-version-min=10.6"
      add_ldflags "-mmacosx-version-min=10.6"
      ;;
    *-darwin11-*)
      add_cflags  "-mmacosx-version-min=10.7"
      add_ldflags "-mmacosx-version-min=10.7"
      ;;
    *-darwin12-*)
      add_cflags  "-mmacosx-version-min=10.8"
      add_ldflags "-mmacosx-version-min=10.8"
      ;;
    *-darwin13-*)
      add_cflags  "-mmacosx-version-min=10.9"
      add_ldflags "-mmacosx-version-min=10.9"
      ;;
    *-darwin14-*)
      add_cflags  "-mmacosx-version-min=10.10"
      add_ldflags "-mmacosx-version-min=10.10"
      ;;
    *-darwin15-*)
      add_cflags  "-mmacosx-version-min=10.11"
      add_ldflags "-mmacosx-version-min=10.11"
      ;;
    *-darwin16-*)
      add_cflags  "-mmacosx-version-min=10.12"
      add_ldflags "-mmacosx-version-min=10.12"
      ;;
    *-iphonesimulator-*)
      add_cflags  "-miphoneos-version-min=${IOS_VERSION_MIN}"
      add_ldflags "-miphoneos-version-min=${IOS_VERSION_MIN}"
      iossim_sdk_dir="$(show_darwin_sdk_path iphonesimulator)"
      if [ -d "${iossim_sdk_dir}" ]; then
        add_cflags  "-isysroot ${iossim_sdk_dir}"
        add_ldflags "-isysroot ${iossim_sdk_dir}"
      fi
      ;;
  esac

  # Handle Solaris variants. Solaris 10 needs -lposix4
  case ${toolchain} in
    sparc-solaris-*)
      add_extralibs -lposix4
      ;;
    *-solaris-*)
      add_extralibs -lposix4
      ;;
  esac

  # Process ARM architecture variants
  case ${toolchain} in
    arm*)
      # on arm, isa versions are supersets
      case ${tgt_isa} in
        arm64|armv8)
          soft_enable neon
          ;;
        armv7|armv7s)
          soft_enable neon
          # Only enable neon_asm when neon is also enabled.
          enabled neon && soft_enable neon_asm
          # If someone tries to force it through, die.
          if disabled neon && enabled neon_asm; then
            die "Disabling neon while keeping neon-asm is not supported"
          fi
      esac

      asm_conversion_cmd="cat"

      case ${tgt_cc} in
        gcc)
          link_with_cc=gcc
          setup_gnu_toolchain
          arch_int=${tgt_isa##armv}
          arch_int=${arch_int%%te}
          check_add_asflags --defsym ARCHITECTURE=${arch_int}
          tune_cflags="-mtune="
          if [ ${tgt_isa} = "armv7" ] || [ ${tgt_isa} = "armv7s" ]; then
            if [ -z "${float_abi}" ]; then
              check_cpp <<EOF && float_abi=hard || float_abi=softfp
#ifndef __ARM_PCS_VFP
#error "not hardfp"
#endif
EOF
            fi
            check_add_cflags  -march=armv7-a -mfloat-abi=${float_abi}
            check_add_asflags -march=armv7-a -mfloat-abi=${float_abi}

            if enabled neon || enabled neon_asm; then
              check_add_cflags -mfpu=neon #-ftree-vectorize
              check_add_asflags -mfpu=neon
            fi
          elif [ ${tgt_isa} = "arm64" ] || [ ${tgt_isa} = "armv8" ]; then
            check_add_cflags -march=armv8-a
            check_add_asflags -march=armv8-a
          else
            check_add_cflags -march=${tgt_isa}
            check_add_asflags -march=${tgt_isa}
          fi

          enabled debug && add_asflags -g
          asm_conversion_cmd="${source_path}/build/make/ads2gas.pl"
          if enabled thumb; then
            asm_conversion_cmd="$asm_conversion_cmd -thumb"
            check_add_cflags -mthumb
            check_add_asflags -mthumb -mimplicit-it=always
          fi
          ;;
        vs*)
          asm_conversion_cmd="${source_path}/build/make/ads2armasm_ms.pl"
          AS_SFX=.s
          msvs_arch_dir=arm-msvs
          disable_feature multithread
          disable_feature unit_tests
          vs_version=${tgt_cc##vs}
          # MSVC 2013 doesn't allow doing plain .exe projects for ARM,
          # only "AppContainerApplication" which requires an AppxManifest.
          # Therefore disable the examples, just build the library.
          disable_feature examples
          ;;
        rvct)
          CC=armcc
          AR=armar
          AS=armasm
          LD="${source_path}/build/make/armlink_adapter.sh"
          STRIP=arm-none-linux-gnueabi-strip
          NM=arm-none-linux-gnueabi-nm
          tune_cflags="--cpu="
          tune_asflags="--cpu="
          if [ -z "${tune_cpu}" ]; then
            if [ ${tgt_isa} = "armv7" ]; then
              if enabled neon || enabled neon_asm
              then
                check_add_cflags --fpu=softvfp+vfpv3
                check_add_asflags --fpu=softvfp+vfpv3
              fi
              check_add_cflags --cpu=Cortex-A8
              check_add_asflags --cpu=Cortex-A8
            else
              check_add_cflags --cpu=${tgt_isa##armv}
              check_add_asflags --cpu=${tgt_isa##armv}
            fi
          fi
          arch_int=${tgt_isa##armv}
          arch_int=${arch_int%%te}
          check_add_asflags --pd "\"ARCHITECTURE SETA ${arch_int}\""
          enabled debug && add_asflags -g
          add_cflags --gnu
          add_cflags --enum_is_int
          add_cflags --wchar32
          ;;
      esac

      case ${tgt_os} in
        none*)
          disable_feature multithread
          disable_feature os_support
          ;;

        android*)
          if [ -z "${sdk_path}" ]; then
            die "Must specify --sdk-path for Android builds."
          fi

          SDK_PATH=${sdk_path}
          COMPILER_LOCATION=`find "${SDK_PATH}" \
                             -name "arm-linux-androideabi-gcc*" -print -quit`
          TOOLCHAIN_PATH=${COMPILER_LOCATION%/*}/arm-linux-androideabi-
          CC=${TOOLCHAIN_PATH}gcc
          CXX=${TOOLCHAIN_PATH}g++
          AR=${TOOLCHAIN_PATH}ar
          LD=${TOOLCHAIN_PATH}gcc
          AS=${TOOLCHAIN_PATH}as
          STRIP=${TOOLCHAIN_PATH}strip
          NM=${TOOLCHAIN_PATH}nm

          if [ -z "${alt_libc}" ]; then
            alt_libc=`find "${SDK_PATH}" -name arch-arm -print | \
              awk '{n = split($0,a,"/"); \
                split(a[n-1],b,"-"); \
                print $0 " " b[2]}' | \
                sort -g -k 2 | \
                awk '{ print $1 }' | tail -1`
          fi

          if [ -d "${alt_libc}" ]; then
            add_cflags "--sysroot=${alt_libc}"
            add_ldflags "--sysroot=${alt_libc}"
          fi

          # linker flag that routes around a CPU bug in some
          # Cortex-A8 implementations (NDK Dev Guide)
          add_ldflags "-Wl,--fix-cortex-a8"

          enable_feature pic
          soft_enable realtime_only
          if [ ${tgt_isa} = "armv7" ]; then
            soft_enable runtime_cpu_detect
          fi
          if enabled runtime_cpu_detect; then
            add_cflags "-I${SDK_PATH}/sources/android/cpufeatures"
          fi
          ;;

        darwin*)
          XCRUN_FIND="xcrun --sdk iphoneos --find"
          CXX="$(${XCRUN_FIND} clang++)"
          CC="$(${XCRUN_FIND} clang)"
          AR="$(${XCRUN_FIND} ar)"
          AS="$(${XCRUN_FIND} as)"
          STRIP="$(${XCRUN_FIND} strip)"
          NM="$(${XCRUN_FIND} nm)"
          RANLIB="$(${XCRUN_FIND} ranlib)"
          AS_SFX=.s
          LD="${CXX:-$(${XCRUN_FIND} ld)}"

          # ASFLAGS is written here instead of using check_add_asflags
          # because we need to overwrite all of ASFLAGS and purge the
          # options that were put in above
          ASFLAGS="-arch ${tgt_isa} -g"

          add_cflags -arch ${tgt_isa}
          add_ldflags -arch ${tgt_isa}

          alt_libc="$(show_darwin_sdk_path iphoneos)"
          if [ -d "${alt_libc}" ]; then
            add_cflags -isysroot ${alt_libc}
          fi

          if [ "${LD}" = "${CXX}" ]; then
            add_ldflags -miphoneos-version-min="${IOS_VERSION_MIN}"
          else
            add_ldflags -ios_version_min "${IOS_VERSION_MIN}"
          fi

          for d in lib usr/lib usr/lib/system; do
            try_dir="${alt_libc}/${d}"
            [ -d "${try_dir}" ] && add_ldflags -L"${try_dir}"
          done

          case ${tgt_isa} in
            armv7|armv7s|armv8|arm64)
              if enabled neon && ! check_xcode_minimum_version; then
                soft_disable neon
                log_echo "  neon disabled: upgrade Xcode (need v6.3+)."
                if enabled neon_asm; then
                  soft_disable neon_asm
                  log_echo "  neon_asm disabled: upgrade Xcode (need v6.3+)."
                fi
              fi
              ;;
          esac

          asm_conversion_cmd="${source_path}/build/make/ads2gas_apple.pl"

          if [ "$(show_darwin_sdk_major_version iphoneos)" -gt 8 ]; then
            check_add_cflags -fembed-bitcode
            check_add_asflags -fembed-bitcode
            check_add_ldflags -fembed-bitcode
          fi
          ;;

        linux*)
          enable_feature linux
          if enabled rvct; then
            # Check if we have CodeSourcery GCC in PATH. Needed for
            # libraries
            which arm-none-linux-gnueabi-gcc 2>&- || \
              die "Couldn't find CodeSourcery GCC from PATH"

            # Use armcc as a linker to enable translation of
            # some gcc specific options such as -lm and -lpthread.
            LD="armcc --translate_gcc"

            # create configuration file (uses path to CodeSourcery GCC)
            armcc --arm_linux_configure --arm_linux_config_file=arm_linux.cfg

            add_cflags --arm_linux_paths --arm_linux_config_file=arm_linux.cfg
            add_asflags --no_hide_all --apcs=/interwork
            add_ldflags --arm_linux_paths --arm_linux_config_file=arm_linux.cfg
            enabled pic && add_cflags --apcs=/fpic
            enabled pic && add_asflags --apcs=/fpic
            enabled shared && add_cflags --shared
          fi
          ;;
      esac
      ;;
    mips*)
      link_with_cc=gcc
      setup_gnu_toolchain
      tune_cflags="-mtune="
      if enabled dspr2; then
        check_add_cflags -mips32r2 -mdspr2
      fi

      if enabled runtime_cpu_detect; then
        disable_feature runtime_cpu_detect
      fi

      if [ -n "${tune_cpu}" ]; then
        case ${tune_cpu} in
          p5600)
            check_add_cflags -mips32r5 -mload-store-pairs
            check_add_cflags -msched-weight -mhard-float -mfp64
            check_add_asflags -mips32r5 -mhard-float -mfp64
            check_add_ldflags -mfp64
            ;;
          i6400|p6600)
            check_add_cflags -mips64r6 -mabi=64 -msched-weight
            check_add_cflags  -mload-store-pairs -mhard-float -mfp64
            check_add_asflags -mips64r6 -mabi=64 -mhard-float -mfp64
            check_add_ldflags -mips64r6 -mabi=64 -mfp64
            ;;
        esac

        if enabled msa; then
          add_cflags -mmsa
          add_asflags -mmsa
          add_ldflags -mmsa
        fi
      fi

      check_add_cflags -march=${tgt_isa}
      check_add_asflags -march=${tgt_isa}
      check_add_asflags -KPIC
      ;;
    x86*)
      case  ${tgt_os} in
        win*)
          enabled gcc && add_cflags -fno-common
          ;;
        solaris*)
          CC=${CC:-${CROSS}gcc}
          CXX=${CXX:-${CROSS}g++}
          LD=${LD:-${CROSS}gcc}
          CROSS=${CROSS-g}
          ;;
        os2)
          disable_feature pic
          AS=${AS:-nasm}
          add_ldflags -Zhigh-mem
          ;;
      esac

      AS="${alt_as:-${AS:-auto}}"
      case  ${tgt_cc} in
        icc*)
          CC=${CC:-icc}
          LD=${LD:-icc}
          setup_gnu_toolchain
          add_cflags -use-msasm  # remove -use-msasm too?
          # add -no-intel-extensions to suppress warning #10237
          # refer to http://software.intel.com/en-us/forums/topic/280199
          add_ldflags -i-static -no-intel-extensions
          enabled x86_64 && add_cflags -ipo -static -O3 -no-prec-div
          enabled x86_64 && AR=xiar
          case ${tune_cpu} in
            atom*)
              tune_cflags="-x"
              tune_cpu="SSE3_ATOM"
              ;;
            *)
              tune_cflags="-march="
              ;;
          esac
          ;;
        gcc*)
          link_with_cc=gcc
          tune_cflags="-march="
          setup_gnu_toolchain
          #for 32 bit x86 builds, -O3 did not turn on this flag
          enabled optimizations && disabled gprof && check_add_cflags -fomit-frame-pointer
          ;;
        vs*)
          # When building with Microsoft Visual Studio the assembler is
          # invoked directly. Checking at configure time is unnecessary.
          # Skip the check by setting AS arbitrarily
          AS=msvs
          msvs_arch_dir=x86-msvs
          vc_version=${tgt_cc##vs}
          ;;
      esac

      bits=32
      enabled x86_64 && bits=64
      check_cpp <<EOF && bits=x32
#if !defined(__ILP32__) || !defined(__x86_64__)
#error "not x32"
#endif
EOF
      case ${tgt_cc} in
        gcc*)
          add_cflags -m${bits}
          add_ldflags -m${bits}
          ;;
      esac

      soft_enable runtime_cpu_detect
      # We can't use 'check_cflags' until the compiler is configured and CC is
      # populated.
      for ext in ${ARCH_EXT_LIST_X86}; do
        # disable higher order extensions to simplify asm dependencies
        if [ "$disable_exts" = "yes" ]; then
          if ! disabled $ext; then
            RTCD_OPTIONS="${RTCD_OPTIONS}--disable-${ext} "
            disable_feature $ext
          fi
        elif disabled $ext; then
          disable_exts="yes"
        else
          # use the shortened version for the flag: sse4_1 -> sse4
          check_gcc_machine_option ${ext%_*} $ext
        fi
      done

      if enabled external_build; then
        log_echo "  skipping assembler detection"
      else
        case "${AS}" in
          auto|"")
            which nasm >/dev/null 2>&1 && AS=nasm
            which yasm >/dev/null 2>&1 && AS=yasm
            if [ "${AS}" = nasm ] ; then
              # Apple ships version 0.98 of nasm through at least Xcode 6. Revisit
              # this check if they start shipping a compatible version.
              apple=`nasm -v | grep "Apple"`
              [ -n "${apple}" ] \
                && echo "Unsupported version of nasm: ${apple}" \
                && AS=""
            fi
            [ "${AS}" = auto ] || [ -z "${AS}" ] \
              && die "Neither yasm nor nasm have been found." \
                     "See the prerequisites section in the README for more info."
            ;;
        esac
        log_echo "  using $AS"
      fi
      [ "${AS##*/}" = nasm ] && add_asflags -Ox
      AS_SFX=.asm
      case  ${tgt_os} in
        win32)
          add_asflags -f win32
          enabled debug && add_asflags -g cv8
          EXE_SFX=.exe
          ;;
        win64)
          add_asflags -f x64
          enabled debug && add_asflags -g cv8
          EXE_SFX=.exe
          ;;
        linux*|solaris*|android*)
          add_asflags -f elf${bits}
          enabled debug && [ "${AS}" = yasm ] && add_asflags -g dwarf2
          enabled debug && [ "${AS}" = nasm ] && add_asflags -g
          [ "${AS##*/}" = nasm ] && check_asm_align
          ;;
        darwin*)
          add_asflags -f macho${bits}
          enabled x86 && darwin_arch="-arch i386" || darwin_arch="-arch x86_64"
          add_cflags  ${darwin_arch}
          add_ldflags ${darwin_arch}
          # -mdynamic-no-pic is still a bit of voodoo -- it was required at
          # one time, but does not seem to be now, and it breaks some of the
          # code that still relies on inline assembly.
          # enabled icc && ! enabled pic && add_cflags -fno-pic -mdynamic-no-pic
          enabled icc && ! enabled pic && add_cflags -fno-pic
          ;;
        iphonesimulator)
          add_asflags -f macho${bits}
          enabled x86 && sim_arch="-arch i386" || sim_arch="-arch x86_64"
          add_cflags  ${sim_arch}
          add_ldflags ${sim_arch}

          if [ "$(show_darwin_sdk_major_version iphonesimulator)" -gt 8 ]; then
            # yasm v1.3.0 doesn't know what -fembed-bitcode means, so turning it
            # on is pointless (unless building a C-only lib). Warn the user, but
            # do nothing here.
            log "Warning: Bitcode embed disabled for simulator targets."
          fi
          ;;
        os2)
          add_asflags -f aout
          enabled debug && add_asflags -g
          EXE_SFX=.exe
          ;;
        *)
          log "Warning: Unknown os $tgt_os while setting up $AS flags"
          ;;
      esac
      ;;
    *-gcc|generic-gnu)
      link_with_cc=gcc
      enable_feature gcc
      setup_gnu_toolchain
      ;;
  esac

  # Try to enable CPU specific tuning
  if [ -n "${tune_cpu}" ]; then
    if [ -n "${tune_cflags}" ]; then
      check_add_cflags ${tune_cflags}${tune_cpu} || \
        die "Requested CPU '${tune_cpu}' not supported by compiler"
    fi
    if [ -n "${tune_asflags}" ]; then
      check_add_asflags ${tune_asflags}${tune_cpu} || \
        die "Requested CPU '${tune_cpu}' not supported by assembler"
    fi
    if [ -z "${tune_cflags}${tune_asflags}" ]; then
      log_echo "Warning: CPU tuning not supported by this toolchain"
    fi
  fi

  if enabled debug; then
    check_add_cflags -g && check_add_ldflags -g
  else
    check_add_cflags -DNDEBUG
  fi

  enabled gprof && check_add_cflags -pg && check_add_ldflags -pg
  enabled gcov &&
    check_add_cflags -fprofile-arcs -ftest-coverage &&
    check_add_ldflags -fprofile-arcs -ftest-coverage

  if enabled optimizations; then
    if enabled rvct; then
      enabled small && check_add_cflags -Ospace || check_add_cflags -Otime
    else
      enabled small && check_add_cflags -O2 ||  check_add_cflags -O3
    fi
  fi

  # Position Independent Code (PIC) support, for building relocatable
  # shared objects
  enabled gcc && enabled pic && check_add_cflags -fPIC

  # Work around longjmp interception on glibc >= 2.11, to improve binary
  # compatibility. See http://code.google.com/p/webm/issues/detail?id=166
  enabled linux && check_add_cflags -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=0

  # Check for strip utility variant
  ${STRIP} -V 2>/dev/null | grep GNU >/dev/null && enable_feature gnu_strip

  # Try to determine target endianness
  check_cc <<EOF
unsigned int e = 'O'<<24 | '2'<<16 | 'B'<<8 | 'E';
EOF
    [ -f "${TMP_O}" ] && od -A n -t x1 "${TMP_O}" | tr -d '\n' |
        grep '4f *32 *42 *45' >/dev/null 2>&1 && enable_feature big_endian

    # Try to find which inline keywords are supported
    check_cc <<EOF && INLINE="inline"
static inline function() {}
EOF

  # Almost every platform uses pthreads.
  if enabled multithread; then
    case ${toolchain} in
      *-win*-vs*)
        ;;
      *-android-gcc)
        ;;
      *)
        check_header pthread.h && add_extralibs -lpthread
        ;;
    esac
  fi

  # only for MIPS platforms
  case ${toolchain} in
    mips*)
      if enabled big_endian; then
        if enabled dspr2; then
          echo "dspr2 optimizations are available only for little endian platforms"
          disable_feature dspr2
        fi
        if enabled msa; then
          echo "msa optimizations are available only for little endian platforms"
          disable_feature msa
        fi
      fi
      ;;
  esac

  # glibc needs these
  if enabled linux || [ "$toolchain" = "generic-gnu" ]; then
    add_cflags -D_LARGEFILE_SOURCE
    add_cflags -D_FILE_OFFSET_BITS=64
  fi
}

process_toolchain() {
  process_common_toolchain
}

print_config_mk() {
  saved_prefix="${prefix}"
  prefix=$1
  makefile=$2
  shift 2
  for cfg; do
    if enabled $cfg; then
      upname="`toupper $cfg`"
      echo "${prefix}_${upname}=yes" >> $makefile
    fi
  done
  prefix="${saved_prefix}"
}

print_config_h() {
  saved_prefix="${prefix}"
  prefix=$1
  header=$2
  shift 2
  for cfg; do
    upname="`toupper $cfg`"
    if enabled $cfg; then
      echo "#define ${prefix}_${upname} 1" >> $header
    else
      echo "#define ${prefix}_${upname} 0" >> $header
    fi
  done
  prefix="${saved_prefix}"
}

print_config_vars_h() {
  header=$1
  shift
  while [ $# -gt 0 ]; do
    upname="`toupper $1`"
    echo "#define ${upname} $2" >> $header
    shift 2
  done
}

print_webm_license() {
  saved_prefix="${prefix}"
  destination=$1
  prefix="$2"
  suffix="$3"
  shift 3
  cat <<EOF > ${destination}
${prefix} Copyright (c) 2016, Alliance for Open Media. All rights reserved.${suffix}
${prefix} ${suffix}
${prefix} This source code is subject to the terms of the BSD 2 Clause License and${suffix}
${prefix} the Alliance for Open Media Patent License 1.0. If the BSD 2 Clause License${suffix}
${prefix} was not distributed with this source code in the LICENSE file, you can${suffix}
${prefix} obtain it at www.aomedia.org/license/software. If the Alliance for Open${suffix}
${prefix} Media Patent License 1.0 was not distributed with this source code in the${suffix}
${prefix} PATENTS file, you can obtain it at www.aomedia.org/license/patent.${suffix}
EOF
  prefix="${saved_prefix}"
}

process_targets() {
  true;
}

process_detect() {
  true;
}

enable_feature logging
logfile="config.log"
self=$0
process() {
  cmdline_args="$@"
  process_cmdline "$@"
  if enabled child; then
    echo "# ${self} $@" >> ${logfile}
  else
    echo "# ${self} $@" > ${logfile}
  fi
  post_process_common_cmdline
  post_process_cmdline
  process_toolchain
  process_detect
  process_targets

  OOT_INSTALLS="${OOT_INSTALLS}"
  if enabled source_path_used; then
  # Prepare the PWD for building.
  for f in ${OOT_INSTALLS}; do
    install -D "${source_path}/$f" "$f"
  done
  fi
  cp "${source_path}/build/make/Makefile" .

  clean_temp_files
  true
}
