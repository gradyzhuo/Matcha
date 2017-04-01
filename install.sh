#!/bin/bash
#
# install
#
# Matcha 1.0, Created by gradyzhuo, enoch_lee.
# Copyright © 2017, Matcha Inc. All rights reserved.
#



source "./matcha" "$@" >/dev/null 2>&1

@import Prints --silent
@import Files --silent

@log "Preparing Matcha $MATCHA_VERSION ..."

@log "Draining ..."
# Match 的捷徑
declare MATCHA_BIN_LINKER="$INSTALL_LIB_TARGET/bin/matcha"
# Matcha 的安裝路徑
declare CURRENT_SOURCE=$(readlink "$MATCHA_BIN_LINKER")
declare CURRENT_SOURCE_DIR=$(dirname "$CURRENT_SOURCE")
if [[ "$CURRENT_SOURCE" != "$INSTALL_LIB_TARGET/matcha" ]]; then
  delete "$MATCHA_BIN_LINKER"
fi

if [[ -d "$CURRENT_SOURCE_DIR/usr" ]]; then
  mkdirFolder "$HOME/.matcha_tmp"
  cp -R "$CURRENT_SOURCE_DIR/usr" "$HOME/.matcha_tmp/"
fi

#如果 CURRENT_SOURCE 不為空字串，且 CURRENT_SOURCE_DIR 也存在，就先移除現在的資料夾
if [[ -d "$CURRENT_SOURCE_DIR" ]]; then
  delete "$CURRENT_SOURCE_DIR"
fi


if [[ ! -d  "$INSTALL_LIB_TARGET/bin" ]]; then
  mkdirFolder "$INSTALL_LIB_TARGET/bin"
fi

if [[ ! -e "$MATCHA_BIN_LINKER" ]]; then
  ln -s "$INSTALL_LIB_TARGET/matcha" "$MATCHA_BIN_LINKER"
fi

BASH_LINK=$(echo 'export "PATH=$HOME/.matcha/bin:$PATH"')
EXPORT_IN_BASH_PROFILE=$(grep "$BASH_LINK" "$HOME/.bash_profile")
if [[ -z $EXPORT_IN_BASH_PROFILE ]]; then
  echo "$BASH_LINK"  >> "$HOME/.bash_profile"
  echo '[[ -s "$HOME/.matcha/matcha" ]] && source "$HOME/.matcha/matcha"' >> "$HOME/.bash_profile"
fi

@log "Bubbling Matcha ..."
mkdirFolder "$INSTALL_LIB_TARGET"

declare EXEC_PATH=$(readlink "$BASH_SOURCE")
declare EXEC_DIR=$(dirname "$EXEC_PATH")

SHOULD_COPY="command modules .prefix matcha"
for item in $SHOULD_COPY
do
    cp -R "$EXEC_DIR/$item" "$INSTALL_LIB_TARGET/"
done


cd "$INSTALL_LIB_TARGET"
source "matcha" >> /dev/null

@log "Installing modules..."
BUILTIN_MODULES_FOLDER="$INSTALL_LIB_TARGET/modules"
BUILTIN_MODULES_TO_INSTAll=$(ls "$BUILTIN_MODULES_FOLDER")
export BUILTIN_MODULE=0
for module_name in $BUILTIN_MODULES_TO_INSTAll
do
  if [[ -d "$BUILTIN_MODULES_FOLDER/$module_name" ]]; then
    matcha module install "$BUILTIN_MODULES_FOLDER/$module_name" >/dev/null 2>&1
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
      @exec module install "$USR_MODULES_FOLDER/$module_name" >/dev/null 2>&1
    fi
  done
fi


@log "Cleaning..."
if [[ -d "$HOME/.matcha_tmp/usr" ]]; then
  delete "$HOME/.matcha_tmp"
fi

cd - >> /dev/null

print -c 'green' -s 'bold' "\nBubbling succeed to \`$INSTALL_LIB_TARGET\`!🍵 🍵 🍵"
print -c 'green' -s 'bold' "You can start by \`matcha help\`".
