#!/bin/bash

export PATH="`pwd`/bin:$PATH"

cd "$(dirname "$0")/.."
SCRIPT_DIR=Scripts

##
## Configuration Variables
##

# The build configuration to use.
if [ -z "$XCCONFIGURATION" ]
then
    XCCONFIGURATION="Release"
fi

# Extra build settings to pass to xcodebuild.
XCODEBUILD_SETTINGS="TEST_AFTER_BUILD=YES"

##
## Build Process
##

echo "*** Building..."
xcodebuild -workspace xebia-ios.xcworkspace -scheme "xebia-ios" -sdk iphonesimulator -configuration Debug clean build TEST_AFTER_BUILD=YES SL_RUN_UNIT_TESTS=YES | grep "." | awk '{print substr ($0, 0, 196)}'

echo "*** Build done"
