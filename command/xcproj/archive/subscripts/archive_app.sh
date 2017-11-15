#!/bin/bash
#
# archive_app.sh
#
# Matcha 1.0, Created by gradyzhuo, enoch_lee.
# Copyright © 2017, Matcha Inc. All rights reserved.
#

declare -r codesign_xcconfig="codesign.xcconfig"

#===== Build =====

will_exec "build_app"
phase_print "Setting version"

#get version/build version in project.

if [[ "$APP_VERSION" == "" ]]; then
  APP_VERSION="$CURRENT_PROJECT_VERSION"
fi

if [[ "$APP_VERSION" != "" ]]; then
  /usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString \"$APP_VERSION\"" $INFO_PLIST
  #defaults write "$APP_PATH/$INFO_PLIST"  CFBundleShortVersionString "$APP_VERSION"
fi

if [[ "$BUILD_VERSION" == "" ]]; then
  BUILD_VERSION="$CURRENT_PROJECT_BUILD_VERSION"
fi
if [[ "$BUILD_VERSION" != "" ]]; then
  /usr/libexec/PlistBuddy -c "Set :CFBundleVersion \"$BUILD_VERSION\"" $INFO_PLIST
  #defaults write "$APP_PATH/$INFO_PLIST"  CFBundleVersion "$BUILD_VERSION"
fi

print -c "green" "Version       => $APP_VERSION"
print -c "green" "Build Version => $BUILD_VERSION"

#######產生 codesign.xcconfig

if [[ $AUTOMATICALLY_MANAGE_SIGNING == 0 ]]; then
  echo "skip code sign"
  # echo "DEVELOPMENT_TEAM=$TEAM_NAME" >> "$TMP_PATH/$codesign_xcconfig"
  # echo "PROVISIONING_PROFILE_SPECIFIER=Automatic" >> "$TMP_PATH/$codesign_xcconfig"
  # echo "PROVISIONING_PROFILE=Automatic" >> "$TMP_PATH/$codesign_xcconfig"
  # echo "PROVISIONING_STYLE=Automatic" >> "$TMP_PATH/$codesign_xcconfig"
  # echo "CODE_SIGN_STYLE=Automatic" >> "$TMP_PATH/$codesign_xcconfig"
  # echo "CODE_SIGN_IDENTITY=iPhone Developer" >> "$TMP_PATH/$codesign_xcconfig"
else
  if [[ "$PROVISIONING_PROFILE_UUID" != "" ]]; then
    echo "PROVISIONING_PROFILE=$PROVISIONING_PROFILE_UUID" >> "$TMP_PATH/$codesign_xcconfig"
  fi

  if [[ "$SIGNING_IDENTITY" != "" ]]; then
    echo "CODE_SIGN_IDENTITY=$SIGNING_IDENTITY" >> "$TMP_PATH/$codesign_xcconfig"
  fi
fi

echo "$CUSTOM_XCCONFIGS" >> "$TMP_PATH/$codesign_xcconfig"

#####
phase_print "Archiving app"

cmd="xcodebuild"

cmd="$cmd -scheme $PROJ_SCHEME"
check_type=$(basename *.xcworkspace)
if [[ "$check_type" != "*.xcworkspace" ]]; then
  print -c "green" "using $check_type"
  cmd="$cmd -workspace \"$check_type\""
else
  check_type=$(basename *.xcodeproj)
  if [[ "$check_type" != "*.xcodeproj" ]]; then
    print -c "green" "using $check_type"
    cmd="$cmd -project \"$check_type\""
  else
    print -c "red" "xcodeproj not found."
    exit 1
  fi
fi

cmd="$cmd -derivedDataPath \"$BUILD_PATH\""
cmd="$cmd -archivePath \"$EXPORT_FOLDER/$ARCHIVE_NAME.xcarchive\""

if [[ "$BUILD_CONFIGURATION" != "" ]]; then
  cmd="$cmd -configuration \"$BUILD_CONFIGURATION\""
fi
cmd="$cmd -sdk iphoneos"
cmd="$cmd -xcconfig \"$TMP_PATH/$codesign_xcconfig\""

if [[ $AUTOMATICALLY_MANAGE_SIGNING == 0 ]]; then
cmd="$cmd -allowProvisioningUpdates"
fi

cmd="$cmd clean"
cmd="$cmd archive"

if [[ $BUILD_CI != 0 ]]; then
  cmd="$cmd > \"$LOG_FOLDER/app.log\" 2>&1"
fi

@log "$cmd"

prints "-c magenta Building" "-c magenta -s blink ..."
eval "$cmd || terminate $ARCHIVE_FAIL_CODE 'Archive failed. please checks app.log...'"

delete "$APP_PATH/$codesign_xcconfig"

#如果成功，會略過 exit
phase_print "Archive succeeded"

did_exec "build_app"
