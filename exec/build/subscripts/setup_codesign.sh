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
  download provision_profile
fi

if [[ $AUTOMATICALLY_MANAGE_SIGIN != 0 && "$UUID" == "" ]]; then
  phase_print "Fetching UUID"
  setupUUID
  print -c green "using provision profile: $PROVISIONING_PROFILE($UUID)"
fi

if [[ $NEED_DOWNLOAD_PROVISION_PROFILE == 0 ]]; then
  clean provision_profile
fi

did_exec "setup_codesign"
