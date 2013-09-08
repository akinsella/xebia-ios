#!/bin/bash
security create-keychain -p travis ios-build.keychain
security import ./Scripts/Certs/apple.cer -k ~/Library/Keychains/ios-build.keychain -T /usr/bin/codesign
security import ./Scripts/Certs/dev.cer -k ~/Library/Keychains/ios-build.keychain -T /usr/bin/codesign
security import ./Scripts/Certs/dev.p12 -k ~/Library/Keychains/ios-build.keychain -P $KEY_PASSWORD -T /usr/bin/codesign
mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
cp ./Scripts/Profiles/* ~/Library/MobileDevice/Provisioning\ Profiles/
