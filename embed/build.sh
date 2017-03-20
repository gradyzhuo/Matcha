#!/bin/bash -l
#
# embed.build.sh
#
# Matcha 1.0, Created by gradyzhuo, enoch_lee.
# Copyright © 2017, Matcha Inc. All rights reserved.
#

declare builder="builder"
declare embed_path=$(pwd)
declare app_path="$embed_path/.."
declare delegate_path="$embed_path/delegate"

#git setting
declare builder_git_tag="2.0"
declare builder_git_branch="auto_build"
declare builder_git="git@gitlab.hq.hiiir:kalvar_lin/ios-ci-scripts.git"
declare builder_git_target="$builder"

if [ -e $builder_git_target ]; then
  rm -rf $builder_git_target
fi

if [[ "$WORKSPACE" == "" ]]; then
  export WORKSPACE="$app_path"
fi

mkdir -p "$builder"
#clone ci_script
git clone -b master "$builder_git" "$builder_git_target"

pushd "$builder_git_target" >> /dev/null

if [[ "$builder_git_tag" != "" && `git tag -l $builder_git_tag` == $builder_git_tag ]]; then
		git checkout tags/$builder_git_tag
fi

if [[ "$1" == "basic" ]]; then
  ./matcha basic $@
else
  ./matcha build -path "$app_path" -delegate "$delegate_path" $@
fi

popd >> /dev/null
