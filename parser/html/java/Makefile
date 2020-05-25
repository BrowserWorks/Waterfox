# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

libs:: translator

translator:: javaparser \
; mkdir -p htmlparser/bin && \
  find htmlparser/translator-src/nu/validator/htmlparser -name "*.java" | \
    xargs javac -cp javaparser.jar -g -d htmlparser/bin && \
  jar cfm translator.jar manifest.txt -C htmlparser/bin .

javaparser:: \
; mkdir -p javaparser/bin && find javaparser/src -name "*.java" | \
    xargs javac -encoding ISO-8859-1 -g -d javaparser/bin && \
  jar cf javaparser.jar -C javaparser/bin .

translate:: translator \
; mkdir -p ../javasrc ; \
  java -jar translator.jar \
    htmlparser/src/nu/validator/htmlparser/impl \
    .. ../../../dom/base/nsGkAtomList.h

translate-javasrc:: translator \
; mkdir -p ../javasrc ; \
  java -jar translator.jar \
    ../javasrc \
    .. ../../../dom/base/nsGkAtomList.h

named-characters:: translator \
; java -cp translator.jar \
    nu.validator.htmlparser.generator.GenerateNamedCharactersCpp \
      named-character-references.html ../

clean-javaparser:: \
; rm -rf javaparser/bin javaparser.jar

clean-htmlparser:: \
; rm -rf htmlparser/bin translator.jar

clean-javasrc:: \
; rm -rf ../javasrc

clean:: clean-javaparser clean-htmlparser
