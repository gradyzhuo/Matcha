#!/bin/bash
#
# _init.sh
#
# Matcha 1.0, Created by gradyzhuo, enoch_lee.
# Copyright © 2017, Matcha Inc. All rights reserved.
#

will_exec "init"
# 如果不存在 rvm 這個指令
if [[ $(@exists -c rvm) == 1 ]]; then
	gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
	\curl -sSL https://get.rvm.io | bash

	rvm install 2.3.1
	rvm use 2.3.1 --default
fi

# 如果不存在 sigh 這個指令
if [[ $(@exists -c fastlane) == 1 ]]; then
	sudo gem install fastlane -NV
fi

did_exec "init"
