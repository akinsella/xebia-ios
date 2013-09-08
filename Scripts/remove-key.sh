#!/bin/bash
echo "Remove Key script ..."

echo "Key chain deletion"
security delete-keychain ios-build.keychain
echo "Provisioning profile folder deletion"
rm -f ~/Library/MobileDevice/Provisioning\ Profiles/*

echo "Remove Key script done"
