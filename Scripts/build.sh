#!/bin/bash

echo "=== Build script ..."

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

#echo "=== Building for Debug ..."
#START_TIME=$SECONDS
#xcodebuild -workspace xebia-ios.xcworkspace -scheme "xebia-ios" -sdk iphonesimulator -configuration Debug clean build OBJROOT="$PWD/build" SYMROOT="$PWD/build" | grep -E "===|warn|error" | grep -v "ibtool"
#ELAPSED_TIME=$(($SECONDS - $START_TIME))
#echo "=== Build for Debug took: $(($ELAPSED_TIME/60)) min $(($ELAPSED_TIME%60)) sec" 
#
#echo "=== Building for Tests ..."
#START_TIME=$SECONDS
#xcodebuild -workspace xebia-ios.xcworkspace -scheme "xebia-iosTests" -sdk iphonesimulator -configuration Debug clean build OBJROOT="$PWD/build" SYMROOT="$PWD/build" TEST_AFTER_BUILD=YES SL_RUN_UNIT_TESTS=YES | grep -E "===|warn|error" | grep -v "ibtool"
#ELAPSED_TIME=$(($SECONDS - $START_TIME))
#echo "=== Build for Tests took: $(($ELAPSED_TIME/60)) min $(($ELAPSED_TIME%60)) sec" 

echo "=== Building for Release ..."
START_TIME=$SECONDS
xcodebuild -workspace xebia-ios.xcworkspace -scheme "xebia-ios" -sdk iphoneos -configuration Release clean build OBJROOT="$PWD/build" SYMROOT="$PWD/build" | awk '{print substr($0,0,120)'
ELAPSED_TIME=$(($SECONDS - $START_TIME))
echo "=== Build for release took: $(($ELAPSED_TIME/60)) min $(($ELAPSED_TIME%60)) sec" 

echo "=== Build script done"
