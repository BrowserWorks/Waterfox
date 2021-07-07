To upgrade to a new revision of the l10n files, do the following:

```
for AB_CD in ar cs da de el fr hu id it ja ko lt nl pl ru th vi; do
   wget -O $AB_CD.zip https://hg.mozilla.org/l10n-central/$AB_CD/archive/tip.zip
   unzip $AB_CD.zip
   rm $AB_CD.zip
   for DIR in $AB_CD-*
      do
      mv "$DIR" "${DIR/-*/}"
    done
done
```

```
for AB_CD in en-GB es-ES es-MX nn-NO pt-BR pt-PT sv-SE zh-CN zh-TW; do
   wget -O $AB_CD.zip https://hg.mozilla.org/l10n-central/$AB_CD/archive/tip.zip
   unzip $AB_CD.zip
   rm $AB_CD.zip
   for DIR in $AB_CD*;
   do
       OUT=`echo $DIR | cut -d '-' -f 1,2`;
       mv "$DIR" "$OUT";
   done
done
```

To make use of the l10n files, you need to add the absolute directory path to the `.mozconfig` used to build:

```
ac_add_options --with-l10n-base=/absolute/path/browser/locales/l10n
```

Then you need to package the installer and then package the language directories:

```
./mach package
./mach package-multi-locale --locales ar cs da de el en-GB en-US es-ES es-MX fr hu id it ja ko lt nl nn-NO pl pt-BR pt-PT ru sv-SE th vi zh-CN zh-TW
```