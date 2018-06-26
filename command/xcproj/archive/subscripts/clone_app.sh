#!/bin/bash
#
# git.sh
#
# Matcha 1.0, Created by gradyzhuo, enoch_lee.
# Copyright © 2017, Matcha Inc. All rights reserved.
#

will_exec "git"

@phase "Cloning app"

clone -r "${GIT_APP}" -b "${GIT_BRANCH_APP}" -t "${APP_PATH}" -tag $GIT_TAG_APP || \
terminate "$GIT_CLOME_FAIL_CODE 'Git clone failed."

did_exec "git"
