#! /bin/bash

#if [[ $TRAVIS && $TRAVIS_EVENT_TYPE != "cron" ]]; then
#    echo "Not cron build. Skipping code coverage generation"
#    exit 0
#fi

if [[ $TRAVIS && $TRAVIS_OS_NAME != "osx" ]]; then
    echo "Not osx build. Skipping code coverage generation"
    exit 0
fi

echo "Starting code coverage generation"
uname -a

SDK=macosx
xcodebuild -version
xcodebuild -version -sdk $SDK
if [[ $? != 0 ]]; then
    exit 1
fi

PROJ_CMD="swift package generate-xcodeproj"
echo "Running $PROJ_CMD"
PROJ_OUTPUT=$(eval "$PROJ_CMD")
PROJ_EXIT_CODE=$?
echo "$PROJ_OUTPUT"
if [[ $PROJ_EXIT_CODE != 0 ]]; then
    exit 1
fi

PROJECT="${PROJ_OUTPUT##*/}"
SCHEME="${PROJECT%.xcodeproj}"

TEST_CMD="xcodebuild -project $PROJECT -scheme $SCHEME -sdk $SDK -enableCodeCoverage YES test"
echo "Running $TEST_CMD"
eval "$TEST_CMD"
if [[ $? != 0 ]]; then
    exit 1
fi

echo "Successfully ran xcodebuild test"
