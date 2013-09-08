#!/bin/bash
echo "=== Remove Key script ..."

echo "=== Key chain deletion"
security delete-keychain ios-build.keychain

echo "=== Remove Key script done"
