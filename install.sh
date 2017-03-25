#!/bin/bash
#
# install
#
# Matcha 1.0, Created by gradyzhuo, enoch_lee.
# Copyright © 2017, Matcha Inc. All rights reserved.
#

source "$(pwd)/matcha" >> /dev/null

declare INSTALL_TARGET="/usr/local/bin/matcha"

declare CURRENT_SOURCE=$(readlink "$INSTALL_TARGET")
if [[ -n $CURRENT_SOURCE && "$CURRENT_SOURCE" != "$INSTALL_TARGET" ]]; then
  delete $(dirname "$CURRENT_SOURCE")
  delete "$INSTALL_TARGET"
fi

if [[ -e $INSTALL_LIB_TARGET ]]; then
  delete "$INSTALL_LIB_TARGET"
fi

mkdirFolder "$INSTALL_LIB_TARGET"

declare EXEC_PATH=$(readlink "$BASH_SOURCE")
declare EXEC_DIR=$(dirname "$EXEC_PATH")

SHOULD_COPY="exec modules .prefix matcha README.md"
for item in $SHOULD_COPY
do
    cp -R "$EXEC_DIR/$item" "$INSTALL_LIB_TARGET/$item"
done
ln -s "$INSTALL_LIB_TARGET/matcha" "$INSTALL_TARGET"
