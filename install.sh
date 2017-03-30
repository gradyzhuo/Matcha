#!/bin/bash
#
# install
#
# Matcha 1.0, Created by gradyzhuo, enoch_lee.
# Copyright © 2017, Matcha Inc. All rights reserved.
#

if [[ "$@" == *"-ci"* ]]; then
  source "./matcha" -ci >> /dev/null
else
  source "./matcha" >> /dev/null
fi

@import Prints --silent
@import Files --silent

@log "Preparing Matcha $MATCHA_VERSION ..."

@log "Draining ..."
#Matcha 的安裝路徑

if [[ -d "$INSTALL_LIB_TARGET/usr" ]]; then
  mkdirFolder "$HOME/.matcha_tmp/usr"
  cp -R "$INSTALL_LIB_TARGET/usr" "$HOME/.matcha_tmp"
fi

#如果 CURRENT_SOURCE 不為空字串，且 CURRENT_SOURCE_DIR 也存在，就先移除現在的資料夾
if [[ -d "$INSTALL_LIB_TARGET" ]]; then
  delete "$INSTALL_LIB_TARGET"
fi

EXPORT_IN_BASH_PROFILE=$(grep 'export PATH="$MATCHA_BASE:$PATH"' "$HOME/.bash_profile")
if [[ -z $EXPORT_IN_BASH_PROFILE ]]; then
  echo 'export MATCHA_BASE="$HOME/.Matcha"' >> "$HOME/.bash_profile"
  echo 'export PATH="$MATCHA_BASE:$PATH"' >> "$HOME/.bash_profile"
fi

@log "Bubbling Matcha ..."
mkdirFolder "$INSTALL_LIB_TARGET"

declare EXEC_PATH=$(readlink "$BASH_SOURCE")
declare EXEC_DIR=$(dirname "$EXEC_PATH")

SHOULD_COPY="exec modules .prefix matcha"
for item in $SHOULD_COPY
do
    cp -R "$EXEC_DIR/$item" "$INSTALL_LIB_TARGET/$item"
done

#安裝Modules
export MATCHA_BASE="$INSTALL_LIB_TARGET"
source "matcha" >> /dev/null

@log "Installing modules..."
BUILTIN_MODULES_FOLDER="$INSTALL_LIB_TARGET/modules"
BUILTIN_MODULES_TO_INSTAll=$(ls "$BUILTIN_MODULES_FOLDER")
export BUILTIN_MODULE=0
for module_name in $BUILTIN_MODULES_TO_INSTAll
do
  if [[ -d "$BUILTIN_MODULES_FOLDER/$module_name" ]]; then
    @exec module install "$BUILTIN_MODULES_FOLDER/$module_name" >> /dev/null
  fi
done

#Usr installed Module

USR_MODULES_FOLDER="$HOME/.matcha_tmp/usr/modules"
if [[ -d "$USR_MODULES_FOLDER" ]]; then
  USR_MODULES_TO_INSTAll=$(ls "$USR_MODULES_FOLDER")

  export BUILTIN_MODULE=1
  for module_name in $USR_MODULES_TO_INSTAll
  do
    if [[ -d "$USR_MODULES_FOLDER/$module_name" ]]; then
      @exec module install "$USR_MODULES_FOLDER/$module_name" >> /dev/null
    fi
  done
fi


@log "Cleaning..."
if [[ -d "$HOME/.matcha_tmp/usr" ]]; then
  delete "$HOME/.matcha_tmp/usr"
fi


print -c 'green' -s 'bold' "\nBubbling succeed to \`$INSTALL_LIB_TARGET\`!🍵 🍵 🍵"
print -c 'green' -s 'bold' "You can start by \`matcha help\`".
