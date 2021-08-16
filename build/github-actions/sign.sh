set -ex

cd $GITHUB_WORKSPACE

BROWSER_VERSION=`cat browser/config/version_display.txt`
TOPDIR=$GITHUB_WORKSPACE

pushd objdir-classic/dist/install/sea/
7z x waterfox-classic-$BROWSER_VERSION.en-US.win64.installer.exe
rm -f waterfox-classic-$BROWSER_VERSION.en-US.win64.installer.exe
az login --service-principal --username $AZURE_USER_ID --password $AZURE_USER_PWD --tenant $AZURE_TENANT_ID
find ./ -type f -name "*.exe" -exec $JAVA_PATH -jar $JSIGN_PATH --storetype AZUREKEYVAULT --keystore "$AZURE_VAULT_ID" --alias "$AZURE_CRT" --tsaurl "http://rfc3161timestamp.globalsign.com/advanced" --tsmode RFC3161 --alg SHA-256 --storepass "$(az account get-access-token --resource "https://vault.azure.net" --tenant $AZURE_TENANT_ID | jq -r .accessToken)" {} \;
find ./ -type f -name "*.dll" -exec $JAVA_PATH -jar $JSIGN_PATH --storetype AZUREKEYVAULT --keystore "$AZURE_VAULT_ID" --alias "$AZURE_CRT" --tsaurl "http://rfc3161timestamp.globalsign.com/advanced" --tsmode RFC3161 --alg SHA-256 --storepass "$(az account get-access-token --resource "https://vault.azure.net" --tenant $AZURE_TENANT_ID | jq -r .accessToken)" {} \;
7z a -r -t7z app.7z -mx -m0=BCJ2 -m1=LZMA:d25 -m2=LZMA:d19 -m3=LZMA:d19 -mb0:1 -mb0s1:2 -mb0s2:3
cp $BUILD_DIR/browser/installer/windows/app.tag .
cp $BUILD_DIR/other-licenses/7zstub/firefox/7zSD.sfx .
cat 7zSD.sfx app.tag app.7z > "Waterfox Classic $BROWSER_VERSION Setup.exe"
$JAVA_PATH -jar $JSIGN_PATH --storetype AZUREKEYVAULT --keystore "$AZURE_VAULT_ID" --alias "$AZURE_CRT" --tsaurl "http://rfc3161timestamp.globalsign.com/advanced" --tsmode RFC3161 --alg SHA-256 --storepass "$(az account get-access-token --resource "https://vault.azure.net" --tenant $AZURE_TENANT_ID | jq -r .accessToken)" "Waterfox Classic $BROWSER_VERSION Setup.exe"
az logout
rm -rf core 7zSD.sfx app.tag app.7z setup.exe
popd