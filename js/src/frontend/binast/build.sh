#!/bin/sh

cargo run -- \
      ../BinAST.webidl_ \
      ../BinAST.yaml \
      --out-class ../BinASTParser-tmp.h    \
      --out-impl ../BinASTParser-tmp.cpp   \
      --out-enum ../BinASTEnum-tmp.h    \
      --out-token ../BinASTToken-tmp.h


(
    cd ../../../../;
    ./mach clang-format -p \
           js/src/frontend/BinASTParser-tmp.h \
           js/src/frontend/BinASTParser-tmp.cpp \
           js/src/frontend/BinASTEnum-tmp.h \
           js/src/frontend/BinASTToken-tmp.h
)

# Usage: update SRC DST
#
# If SRC file and DST file have different content, move SRC file to DST file.
# If not, remove SRC file.
update() {
  SRC=$1
  DST=$2

  if diff -q ${SRC} ${DST} > /dev/null; then
      echo "SKIPPED: ${DST} was not modified"
      rm ${SRC}
  else
      echo "UPDATED: ${DST} was modified"
      mv ${SRC} ${DST}
  fi
}

update ../BinASTParser-tmp.h ../BinASTParser.h
update ../BinASTParser-tmp.cpp ../BinASTParser.cpp
update ../BinASTEnum-tmp.h ../BinASTEnum.h
update ../BinASTToken-tmp.h ../BinASTToken.h
