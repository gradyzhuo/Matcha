#!/bin/bash
#
# setup_codesign.sh
#
# Matcha 1.0, Created by gradyzhuo, enoch_lee.
# Copyright © 2017, Matcha Inc. All rights reserved.
#

will_exec "setup_codesign"

configure_signing_identity

PROVISIONING_PROFILE="profile"

#===== Provision Profile =====

if [[ $NEED_DOWNLOAD_PROVISION_PROFILE == 0 ]]; then
  phase_print "Downloading provision profile"
  profile download -fetch "$PROVISIONING_PROFILE_NAME" -option "$EXPORT_OPTION" -id "$APPLE_ID" -passwd "$APPLE_ID_PASSWORD" -app_id "$APP_ID" -team "$TEAM_NAME" -output "$PROVISIONING_FOLDER/$PROVISIONING_PROFILE"
  profile install -profile "$PROVISIONING_FOLDER/$PROVISIONING_PROFILE"
fi

if [[ $AUTOMATICALLY_MANAGE_SIGNING != 0 && "$UUID" == "" ]]; then
  phase_print "Fetching UUID"
  UUID=$(profile showUUID -profile "$PROVISIONING_FOLDER/$PROVISIONING_PROFILE")
  print -c green "using provision profile: $PROVISIONING_PROFILE($UUID)"
fi

if [[ $NEED_DOWNLOAD_PROVISION_PROFILE == 0 ]]; then
  profile clean -profile "$PROVISIONING_FOLDER/$PROVISIONING_PROFILE"
fi

did_exec "setup_codesign"
