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

echo "=== PROVISIONING_PROFILE: $PROFILE_UUID"
echo "=== CODE_SIGN_IDENTITY: $DEVELOPER_NAME"


if [ -f "tests_failed" ]
then
	rm tests_failed
fi

##
## Build Process
##

echo "=== Building for Debug ..."
START_TIME=$SECONDS
#xcodebuild -workspace Xebia.xcworkspace -scheme "Xebia" -sdk iphonesimulator7.0 -configuration Debug clean build OBJROOT="$PWD/build" SYMROOT="$PWD/build" | grep -E "===|warn|error" | grep -v "ibtool"
xcodebuild -workspace Xebia.xcworkspace -scheme "Xebia" -sdk iphonesimulator7.0 -configuration Debug clean build OBJROOT="$PWD/build" SYMROOT="$PWD/build" PROJECT_TEMP_ROOT="$PWD/build" CONFIGURATION_BUILD_DIR="$PWD/build" > /dev/null
ELAPSED_TIME=$(($SECONDS - $START_TIME))
echo "=== Build for Debug took: $(($ELAPSED_TIME/60)) min $(($ELAPSED_TIME%60)) sec" 

echo "=== Building for Tests ..."
START_TIME=$SECONDS
#xcodebuild -workspace Xebia.xcworkspace -scheme "XebiaTests" -sdk iphonesimulator7.0 -configuration Debug clean build OBJROOT="$PWD/build" SYMROOT="$PWD/build" TEST_AFTER_BUILD=YES SL_RUN_UNIT_TESTS=YES > /dev/null
xcodebuild -workspace Xebia.xcworkspace -scheme "XebiaTests" -sdk iphonesimulator7.0 -configuration Debug clean build OBJROOT="$PWD/build" SYMROOT="$PWD/build" PROJECT_TEMP_ROOT="$PWD/build" CONFIGURATION_BUILD_DIR="$PWD/build" TEST_AFTER_BUILD=YES SL_RUN_UNIT_TESTS=YES > /dev/null
ELAPSED_TIME=$(($SECONDS - $START_TIME))
echo "=== Build for Tests took: $(($ELAPSED_TIME/60)) min $(($ELAPSED_TIME%60)) sec" 

if [ -f "tests_failed" ]
then
	echo "Tests failed. Exiting with code 1."
	exit 1
fi

echo "=== Building for Release ..."
START_TIME=$SECONDS
xcodebuild -workspace Xebia.xcworkspace -scheme "Xebia" -sdk iphoneos7.0 -configuration Release clean build OBJROOT="$PWD/build" SYMROOT="$PWD/build" PROJECT_TEMP_ROOT="$PWD/build" CONFIGURATION_BUILD_DIR="$PWD/build" CODE_SIGN_IDENTITY="${DEVELOPER_NAME}" PROVISIONING_PROFILE="${PROFILE_UUID}" | awk '{print substr($0,0,220)}'
ELAPSED_TIME=$(($SECONDS - $START_TIME))
echo "=== Build for release took: $(($ELAPSED_TIME/60)) min $(($ELAPSED_TIME%60)) sec" 

echo "=== Build script done"
