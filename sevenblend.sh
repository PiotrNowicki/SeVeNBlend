#! /bin/bash

#############################################
# 
# SeVeNblend by Palli
#
# Last changed: 7.10.2009
# 
# This Program is a free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; version 2 of the License. 
# This Program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. 
#############################################


###########################
# Policy of recompiling / changes; rows => what has changed - columns => what need to be recompiled 
# (ex. Yaf(a)ray Core changes - we need to recompile Blender and Yaf(a)ray Core itself)
 
#                 | Blender | Yaf(a)ray Core | Yaf(a)ray Exporter | Yaf(a)ray Script |
#------------------------------------------------------------------------------------|
#| Blender        |   YES   |                |                    |                  |
#|----------------|---------|----------------|--------------------|------------------|
#| Yaf(a)ray Core |   YES   |      YES       |                    |                  |
#|----------------|---------|----------------|--------------------|------------------|
#| Yaf(a)ray Exp. |   YES   |                |                    |                  |
#|----------------|---------|----------------|--------------------|------------------|
#| Yaf(a)ray Scr. |         |                |                    |      copy        |
#|----------------|---------|----------------|--------------------|------------------|

##########################
VER="0.2.2  "
IS_GCC_4_3=`gcc -v 2>&1|egrep "gcc version 4.3."|wc -l`

# Libraries needed for compiling (used especially for Ubuntu users
PCKGS_TO_INSTALL=(subversion
libqt4-dev
binutils
swig
scons
libpng12-dev
gcc
g++
libalut-dev
libsdl-sound1.2-dev
libopenexr-dev
libjpeg62-dev
python2.5-dev
libtiff4-dev
gettext
libxi-dev
libfreetype6-dev
libxml2-dev
yasm
libsamplerate0-dev
nasm
)

# Bunch of path variables
. include/paths.sh

#####################################
# What revisions should be ckecked out
REV_BLENDER=0
REV_YAF_CORE=0
REV_YAF_EXP=0

#####################################
# To know what should be done

SHOULD_COMPILE_BLENDER=0
SHOULD_COMPILE_YAFARAY=0
SHOULD_OPTIMIZE=0
SHOULD_INSTALL_ICONS=0

#####################################################
# To know what are the indicators of previous build

INSTALLED_BLENDER="$MAIN_PATH/install"
INSTALLED_YAFARAY="$SVN_YAFARAY_CORE/build"

#####################################################
# Misc vars

# Number of threads for scons to use
THREADS_NUM=2

# How many lines will be dumped from log file when compilation fails
LINES_TO_DUMP=15

# Should we use Blender source scons or our system one?
USE_INTERNAL_SCONS=0

# Should we download packages needed for compilation?
INSTALL_PACKAGES=0

# Do not build Yafaray QT GUI
NO_QT_GUI=0

# Should we clean all build directories?
CLEAN_BUILD=0

# Should we clean all files (src + build + logs)?
CLEAN_ALL=0

# Should Blender from blender2.4 branch be compiled?
COMPILE_BLENDER_2_4=0

# Common functions
. include/common.sh

######################
# Starting script

clear

echo '/----------------------------------\'
echo "|         SeVeNblend v$VER      |"
echo '|==================================|'
echo '|   Blender + Yaf(a)ray from SVN   |'
echo '|               SVN                |'
echo '|----------------------------------|'
echo '|                                  |'
echo '|         Script running...        |'
echo '\----------------------------------/'
echo ''

#################################################
# Parse arguments and tell user which are wrong

print_separator " Parsing script arguments "
	
	# Include definition of arguments and their acctions
	. include/arguments.sh

if [ $CLEAN_BUILD -gt 0 -o $CLEAN_ALL -gt 0 ]; then
	print_separator " Cleaning resources "
	
	. include/clean.sh

	exit 0
fi

if [ $INSTALL_PACKAGES -gt 0 ]; then
	print_separator " Downloading packages "

	sudo apt-get install ${PCKGS_TO_INSTALL[@]:0}
fi

print_separator " Preparing directories "

	# Prepare directories
	. include/directories.sh

print_separator " Checking out sources "

	# Checkout sources of Blender and Yafaray (core + exporter)
	. include/checkouts.sh

print_separator " What should be recompiled decisions "
	
	# What should be recompiled?
	. include/recompile_decisions.sh

print_separator " Yaf(a)ray Core compilation "

	# Recompile Yaf(a)ray Core and install it
	. include/compile_yafaray.sh
	
print_separator " Blender compilation "
	
	# Recompile Blender
	. include/compile_blender.sh
	
print_separator " Building Yaf(a)ray Exporter bindings "
	
	# Compile Yaf(a)ray Exporter 0.0.3 scripts and stubs using swig and copy results into SeVeNblend scripts
	. include/compile_exporter003.sh

print_separator " Copying exporter scripts to Blender directory "

	# Copy Yaf(a)ray Exporter 0.0.3 scripts (along with compiled bindings) into blender directory 
	. include/copy_scripts.sh

print_separator " Post-process "

##########################################
# Creating symbolic link to Blender Build

ln -fs "$MAIN_PATH/install/linux2/blender" "$HOME/sevenblend"


###########
# Finish 

echo '----------------------------------------------------------'
if [ $? -ne 0 ]; then
	echo "Script didn't end successfully."
else
	echo "Script end successfully."
	echo "Please remember to set 'scripts' file path in Blender to '$BLENDER_SCRIPTS_DIR'"
fi

echo

