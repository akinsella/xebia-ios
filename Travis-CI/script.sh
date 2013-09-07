#!/bin/sh
set -e

gem update cocoapods
xctool -workspace xebia-ios.xcworkspace -scheme "xebia-ios" clean build test -sdk iphonesimulator -arch i386
