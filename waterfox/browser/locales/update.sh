#!/bin/sh

# Make sure to execute from the scripts directory
cd $(dirname $0)

N=$(getconf _NPROCESSORS_ONLN 2>/dev/null || getconf NPROCESSORS_ONLN)

for AB_CD in ar cs da de el en-GB es-ES es-MX fr hu id it ja ko lt nl nn-NO pl pt-BR pt-PT ru sv-SE th vi zh-CN zh-TW; do
   rm -rf $AB_CD || true
   (
   wget -O $AB_CD.zip https://hg.mozilla.org/l10n-central/$AB_CD/archive/tip.zip
   unzip $AB_CD.zip
   rm $AB_CD.zip
   for DIR in $AB_CD-*;
   do
       if [[ $AB_CD == *"-"* ]]; then
         OUT=$(echo "$DIR" | cut -d '-' -f 1,2);
       else
         OUT=$(echo "$DIR" | cut -d '-' -f 1);
       fi
       mv "$DIR" "$OUT";
       rm -rf "$DIR"
       if [[ -d $OUT/waterfox/browser/branding ]]; then
         mkdir -p "$OUT"/waterfox/browser/branding
         mv "$OUT"/browser/branding/official/* "$OUT"/waterfox/browser/branding
         rm -rf "$OUT"/browser/branding/official "$OUT"/waterfox/browser/branding/official
       else
         mkdir -p "$OUT"/waterfox/browser/branding
         mv "$OUT"/browser/branding/official/* "$OUT"/waterfox/browser/branding
         rm -rf "$OUT"/browser/branding/official
       fi
       grep -rl 'Mozilla Firefox' "$OUT" | LC_ALL=C xargs sed -i '' 's/Mozilla Firefox/Waterfox/g'
       grep -rl 'Mozilla Foundation' "$OUT" | LC_ALL=C xargs sed -i '' 's/Mozilla Foundation/Waterfox Limited/g'
       grep -rl 'Firefox' "$OUT" | LC_ALL=C xargs sed -i '' 's/Firefox/Waterfox/g'
       grep -rl 'Mozilla' "$OUT" | LC_ALL=C xargs sed -i '' 's/Mozilla/Waterfox/g'
   done
   ) &
    if [[ $(jobs -r -p | wc -l) -ge $N ]]; then
        wait -n
    fi
done

wait

echo "Finished"
