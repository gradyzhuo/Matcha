#!/bin/bash
#
# setup_codesign.sh
#
# Matcha 1.0, Created by gradyzhuo, enoch_lee.
# Copyright © 2017, Matcha Inc. All rights reserved.
#

will_exec "setup_codesign"

configure_signing_identity

#===== Provision Profile =====

if [[ $NEED_DOWNLOAD_PROVISION_PROFILE == 0 ]]; then
  phase_print "Downloading provision profile"
 profile download -fetch "$PROVISIONING_PROFILE_NAME" -option "$EXPORT_OPTION" -id "$APPLE_ID" -passwd "$APPLE_ID_PASSWORD" -app_id "$APP_ID" -team "$TEAM_NAME" -output "$PROVISIONING_FOLDER/profile"
fi

if [[ $AUTOMATICALLY_MANAGE_SIGIN != 0 && "$UUID" == "" ]]; then
  phase_print "Fetching UUID"
  UUID=$(profile showUUID)
  print -c green "using provision profile: $PROVISIONING_PROFILE($UUID)"
fi

if [[ $NEED_DOWNLOAD_PROVISION_PROFILE == 0 ]]; then
  clean provision_profile
fi

did_exec "setup_codesign"
