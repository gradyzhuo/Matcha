#!/bin/bash
#
# install
#
# Matcha 1.0, Created by gradyzhuo, enoch_lee.
# Copyright © 2017, Matcha Inc. All rights reserved.
#

source "./matcha" >> /dev/null
@import Prints --silent
@import Files --silent

@log "Preparing Matcha $VERSION ..."

@log "Draining ..."
#Match 在 /usr/local/bin 的捷徑
declare MATCHA_BIN_LINKER="/usr/local/bin/matcha"
#Matcha 的安裝路徑
declare CURRENT_SOURCE=$(readlink "$MATCHA_BIN_LINKER")
declare CURRENT_SOURCE_DIR=$(dirname "$CURRENT_SOURCE")
if [[ -n $CURRENT_SOURCE && "$CURRENT_SOURCE" != "$INSTALL_LIB_TARGET/matcha" ]]; then
  delete "$MATCHA_BIN_LINKER"
  ln -s "$INSTALL_LIB_TARGET/matcha" "$MATCHA_BIN_LINKER"
fi

if [[ -d "$CURRENT_SOURCE_DIR/usr" ]]; then
  mkdirFolder "$HOME/.matcha_tmp"
  cp -R "$CURRENT_SOURCE_DIR/usr" "$HOME/.matcha_tmp/"
fi

delete "$CURRENT_SOURCE_DIR"

@log "Bubbling Matcha ..."
mkdirFolder "$INSTALL_LIB_TARGET"

if [[ -d "$HOME/.matcha_tmp/usr" ]]; then
  cp -R "$HOME/.matcha_tmp/usr" "$INSTALL_LIB_TARGET/"
  delete "$HOME/.matcha_tmp"
fi

declare EXEC_PATH=$(readlink "$BASH_SOURCE")
declare EXEC_DIR=$(dirname "$EXEC_PATH")

SHOULD_COPY="exec modules .prefix matcha README.md"
for item in $SHOULD_COPY
do
    cp -R "$EXEC_DIR/$item" "$INSTALL_LIB_TARGET/$item"
done

source matcha >> /dev/null

export BUILTIN_MODULE=0

@log "Installing modules..."
_MODULES_FOLDER="$INSTALL_LIB_TARGET/modules"
_MODULES_TO_INSTAll=$(ls "$INSTALL_LIB_TARGET/modules")

for module_name in $_MODULES_TO_INSTAll
do
  if [[ -d "$_MODULES_FOLDER/$module_name" ]]; then
    @exec module install "$_MODULES_FOLDER/$module_name" >> /dev/null
  fi
done

print -c 'green' -s 'bold' "Bubbling succeed to \`$INSTALL_LIB_TARGET\`!"
print -c 'green' -s 'bold' "You can start by \`matcha help\`"
