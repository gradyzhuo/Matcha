#!/bin/bash
#
# export_ipa.sh
#
# Matcha 1.0, Created by gradyzhuo, enoch_lee.
# Copyright © 2017, Matcha Inc. All rights reserved.
#

will_exec "export_ipa"

phase_print "Exporting app"

declare EXPORT_OPTION_FILE_NAME="$EXPORT_OPTION.plist"
output_tmp_folder=".output"

#set teamID
mkdirFolder "$EXPORT_OPTION_PLIST_FOLDER"
$EXPORT_OPTION "$EXPORT_OPTION_PLIST_FOLDER/$EXPORT_OPTION_FILE_NAME" @teamID "$TEAM_ID"

#xcode 9 needed
defaults write "$EXPORT_OPTION_PLIST_FOLDER/$EXPORT_OPTION_FILE_NAME" provisioningProfiles -dict "$APP_ID" "$PROVISIONING_PROFILE_UUID"

print -c green "using export option: $EXPORT_OPTION ($EXPORT_OPTION_PLIST_FOLDER/$EXPORT_OPTION_FILE_NAME)"

rvm use system

mkdirFolder "$EXPORT_FOLDER/$output_tmp_folder"

# Export Archive project
cmd="xcodebuild  -exportArchive"
cmd="$cmd -archivePath \"$EXPORT_FOLDER/$ARCHIVE_NAME.xcarchive\""
cmd="$cmd -exportOptionsPlist \"$EXPORT_OPTION_PLIST_FOLDER/$EXPORT_OPTION_FILE_NAME\""
cmd="$cmd -exportPath \"$EXPORT_FOLDER/$output_tmp_folder\""

if [[ $AUTOMATICALLY_MANAGE_SIGNING == 0 ]]; then
cmd="$cmd -allowProvisioningUpdates"
fi

if [[ $BUILD_CI != 0 ]]; then
  cmd="$cmd >> \"$LOG_FOLDER/export.log\""
fi

eval "$cmd || terminate $EXPORT_FAIL_CODE 'Export failed. please checks export.log...'"

rvm default

#如果成功會略過 exit
if [[ "$EXPORT_IPA_NAME" == "" ]]; then
	EXPORT_IPA_NAME="${PROJ_NAME}_${BUILD_CONFIGURATION} $APP_VERSION($BUILD_VERSION)"
fi

if [[ $BUILD_CI == 0 ]]; then
  mv "$EXPORT_FOLDER/$output_tmp_folder/${PROJ_SCHEME}.ipa" "${EXPORT_FOLDER}/${EXPORT_IPA_NAME}.ipa"
else
	mv "$EXPORT_FOLDER/$output_tmp_folder/${PROJ_SCHEME}.ipa" "${EXPORT_FOLDER}/${EXPORT_IPA_NAME}.ipa"
fi

delete "$EXPORT_FOLDER/$ARCHIVE_NAME.xcarchive"
delete "${EXPORT_FOLDER}/$output_tmp_folder"

phase_print "Export suceeded"
print -c green "exported to ${EXPORT_FOLDER}/${EXPORT_IPA_NAME}.ipa"

did_exec "export_ipa"
