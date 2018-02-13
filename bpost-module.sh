#!/bin/bash

# Boeffla Kernel Build Script extension
# for special module handling during build process
#
# Version 1.1, 22.08.2018
#
# (C) Lord Boeffla (aka andip71)

echo -e ">>> post module handling\n"

# retrieve path to modules folder
MODULES_PATH="$1"

# do special handling
mv $MODULES_PATH/wlan.ko $MODULES_PATH/qca_cld3_wlan.ko
