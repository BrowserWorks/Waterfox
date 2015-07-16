#!/bin/sh

# $MOZILLABUILD should always be set by start-shell.bat.
echo "MozillaBuild Install Directory: ${MOZILLABUILD}"

# These will only be set if start-shell.bat is invoked via
# one of the start-shell-msvc*.bat scripts.
if test -n "$VCDIR"; then
  echo "Visual C++ ${MOZ_MSVCYEAR} Directory: ${VCDIR}"
fi
if test -n "$SDKDIR"; then
  echo "Windows SDK Directory: ${SDKDIR}"
fi
if test -n "$TOOLCHAIN"; then
  echo "Using the MSVC ${MOZ_MSVCYEAR} ${TOOLCHAIN} toolchain."
fi
