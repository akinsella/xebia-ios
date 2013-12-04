#!/bin/sh
echo "Before Script ..."
#brew update
#brew install ios-sim
#IOS_SIM_DIR=`brew info ios-sim | sed -n '3 p' | awk '{print $1}'`
#mkdir bin
#cp $IOS_SIM_DIR/bin/ios-sim ./bin/ios-sim

echo "=== Uncyphering provisionning profiles"
openssl aes-256-cbc -k "$ENCRYPTION_SECRET" -in "Scripts/Profiles/$PROFILE_UUID.mobileprovision.enc" -d -a -out "Scripts/Profiles/$PROFILE_UUID.mobileprovision"
echo "=== Uncyphering certificates"
openssl aes-256-cbc -k "$ENCRYPTION_SECRET" -in "Scripts/Certs/dev.cer.enc" -d -a -out "Scripts/Certs/dev.cer"
openssl aes-256-cbc -k "$ENCRYPTION_SECRET" -in "Scripts/Certs/dev.p12.enc" -d -a -out "Scripts/Certs/dev.p12"


echo "=== Add Key script ..."
echo "=== Keychain creation"
security create-keychain -p travis ios-build.keychain
echo "=== Update Keychain timeout settings"
security set-keychain-settings -t 1800 -l ~/Library/Keychains/ios-build.keychain
echo "=== Show Keychain infos"
security show-keychain-info ~/Library/Keychains/ios-build.keychain
echo "=== Apple cert import"
security import ./Scripts/Certs/apple.cer -k ~/Library/Keychains/ios-build.keychain -T /usr/bin/codesign
echo "=== Dev cert import"
security import ./Scripts/Certs/dev.cer -k ~/Library/Keychains/ios-build.keychain -T /usr/bin/codesign
echo "=== Dev key import"
security import ./Scripts/Certs/dev.p12 -k ~/Library/Keychains/ios-build.keychain -P $KEY_PASSWORD -T /usr/bin/codesign
echo "=== Provisioning profiles folder creation"
mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
echo "=== Copying Provisioning profiles"
cp ./Scripts/Profiles/* ~/Library/MobileDevice/Provisioning\ Profiles/
echo "=== Add Key script done"


echo "Before Script Done"
