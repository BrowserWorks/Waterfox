for AB_CD in ar cs da de el en-GB es-ES es-MX fr hu id it ja ko lt nl nn-NO pl pt-BR pt-PT ru sv-SE th vi zh-CN zh-TW; do
   rm -rf $AB_CD || true
   wget -O $AB_CD.zip https://hg.mozilla.org/l10n-central/$AB_CD/archive/tip.zip
   unzip $AB_CD.zip
   rm $AB_CD.zip
   for DIR in $AB_CD-*;
   do
       if [[ $AB_CD == *"-"* ]]; then
         OUT=`echo $DIR | cut -d '-' -f 1,2`;
       else
         OUT=`echo $DIR | cut -d '-' -f 1`;
       fi
       mv $DIR $OUT;
       rm -rf $DIR
       if [[ -d $OUT/browser/branding/waterfox ]]; then
         mv $OUT/browser/branding/official/* $OUT/browser/branding/waterfox
         rm -rf $OUT/browser/branding/official $OUT/browser/branding/waterfox/official
       else
         mv $OUT/browser/branding/official $OUT/browser/branding/waterfox
       fi
       grep -rl 'Mozilla Firefox' $OUT | LC_ALL=C xargs sed -i '' 's/"Mozilla Firefox"/Waterfox/g'
       grep -rl 'Firefox' $OUT | LC_ALL=C xargs sed -i '' 's/Firefox/Waterfox/g'
       grep -rl 'Mozilla' $OUT | LC_ALL=C xargs sed -i '' 's/Mozilla/Waterfox/g'
   done
done