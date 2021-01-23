#!/usr/bin/env sh
set -ex

html/canvas/tools/build.sh
infrastructure/assumptions/tools/build.sh
html/tools/build.sh
python mimesniff/mime-types/resources/generated-mime-types.py
python3 css/css-ui/tools/appearance-build-webkit-reftests.py
python3 WebIDL/tools/generate-setlike.py
