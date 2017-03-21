#!/bin/bash
#
# archive_app.sh
#
# Matcha 1.0, Created by gradyzhuo, enoch_lee.
# Copyright © 2017, Matcha Inc. All rights reserved.
#

declare -r codesign_xcconfig="codesign.xcconfig"

#===== Build =====

phase_print "Setting version"

#get version/build version in project.

if [[ "$VERSION" != "" && "$VERSION" != "$CURRENT_PROJECT_VERSION" ]]; then
  defaults write "$APP_PATH/$INFO_PLIST"  CFBundleShortVersionString "$VERSION"
else
  VERSION="$CURRENT_PROJECT_VERSION"
fi

if [[ "$BUILD_VERSION" != "" && "$BUILD_VERSION" != "$CURRENT_PROJECT_BUILD_VERSION" ]]; then
  defaults write "$APP_PATH/$INFO_PLIST"  CFBundleVersion "$BUILD_VERSION"
else
  BUILD_VERSION="$CURRENT_PROJECT_BUILD_VERSION"
fi

print -c "green" "Version       => $VERSION"
print -c "green" "Build Version => $BUILD_VERSION"

#######產生 codesign.xcconfig

if [[ $AUTOMATICALLY_MANAGE_SIGIN == 0 ]]; then
  echo "DEVELOPMENT_TEAM=$TEAM_ID" >> "$TMP_PATH/$codesign_xcconfig"
else
  if [[ "$UUID" != "" ]]; then
    echo "PROVISIONING_PROFILE=$UUID" >> "$TMP_PATH/$codesign_xcconfig"
  fi

  if [[ "$SIGNING_IDENTITY" != "" ]]; then
    echo "CODE_SIGN_IDENTITY=$SIGNING_IDENTITY" >> "$TMP_PATH/$codesign_xcconfig"
  fi
fi

echo "$TMP_PATH"

#####

will_exec "build_app"

#####

phase_print "Archiving app"

cmd="xcodebuild archive"

if [[ "$PROJ_TYPE" == "workspace" ]]; then
  print -c "green" "using $PROJ_NAME.xcworkspace"
  cmd="$cmd -workspace \"$PROJ_NAME.xcworkspace\""
else
  print -c "green" "using $PROJ_NAME.xcodeproj"
  cmd="$cmd -project \"$PROJ_NAME.xcodeproj\""
fi

cmd="$cmd -scheme $PROJ_SCHEME"
cmd="$cmd -derivedDataPath \"$BUILD_PATH\""
cmd="$cmd -archivePath \"$EXPORT_FOLDER/$ARCHIVE_NAME.xcarchive\""

if [[ "$BUILD_CONFIGURATION" != "" ]]; then
  cmd="$cmd -configuration \"$BUILD_CONFIGURATION\""
fi

cmd="$cmd -sdk iphoneos"
cmd="$cmd -xcconfig \"$TMP_PATH/$codesign_xcconfig\""
if [[ $BUILD_CI != 0 ]]; then
  cmd="$cmd >> \"$LOG_FOLDER/app.log\""
fi

prints "-c magenta Building" "-c magenta -s blink ..."
eval "$cmd || terminate $ARCHIVE_FAIL_CODE 'Archive failed. please checks app.log...'"

delete "$APP_PATH/$codesign_xcconfig"

#如果成功，會略過 exit
phase_print "Archive succeeded"

did_exec "build_app"
