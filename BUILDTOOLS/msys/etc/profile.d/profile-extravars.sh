#!/bin/sh

if test -n "$MOZILLABUILD"; then
    MSYS_MOZBUILD=$(cd "$MOZILLABUILD" && pwd)
    PATH="/local/bin:$MSYS_MOZBUILD/7zip:$MSYS_MOZBUILD/info-zip:$MSYS_MOZBUILD/kdiff3:$MSYS_MOZBUILD/mozmake:$MSYS_MOZBUILD/nsis-3.0b1:$MSYS_MOZBUILD/nsis-2.46u:$MSYS_MOZBUILD/python:$MSYS_MOZBUILD/python/Scripts:$MSYS_MOZBUILD/upx391w:$MSYS_MOZBUILD/wget:$MSYS_MOZBUILD/yasm:$PATH"
    EDITOR="emacs.exe"
    export PATH EDITOR
    export HOSTTYPE MACHTYPE OSTYPE SHELL
fi
