# SVN repository URL's
URL_BLENDER="https://svn.blender.org/svnroot/bf-blender/trunk/blender"
URL_BLENDER_2_4="https://svn.blender.org/svnroot/bf-blender/branches/blender2.4/"
URL_YAFARAY_CORE="svn://svn.yafaray.org/repo/yafaray/mainline/"
URL_YAFARAY_EXPORTER="svn://svn.yafaray.org/repo/yafaray-blender/mainline"

# Main paths
MAIN_PATH="`pwd`/.sources"
LOGS="$MAIN_PATH/logs"
USER_CONFIGS="`pwd`/user_configs"
ADDONS="`pwd`/addons"

# SVN paths
SVN_BLENDER="$MAIN_PATH/blender"
SVN_YAFARAY_EXPORTER="$MAIN_PATH/yafaray_exporter"
SVN_YAFARAY_CORE="$MAIN_PATH/yafaray_core"

# Some useful files/dirs 
BLENDER_SOURCE="$SVN_BLENDER/source/blender"
BLENDER_SCONS="$SVN_BLENDER/scons/scons.py"
SEVENBLEND_SCRIPTS="$MAIN_PATH/scripts"

BLENDER_YAFRAY="$BLENDER_SOURCE/yafray"
BLENDER_SRC="$BLENDER_SOURCE/src"
YAFARAY_FOR_BLENDER="$SVN_YAFARAY_EXPORTER/yafray"
YAFARAY_002_SCRIPT="$SVN_YAFARAY_EXPORTER/yafaray_ui.py"
YAFARAY_003_SCRIPT_DIR="$SVN_YAFARAY_EXPORTER"
BLENDER_SCRIPTS_DIR="$MAIN_PATH/install/linux2/.blender/scripts"
BLENDER_DATAFILES_DIR="$SVN_BLENDER/release/datafiles"
USER_CONFIG_SCRIPT="$USER_CONFIGS/user-config.py"

# SVN logs files
LOGS_SVN_BLENDER="$LOGS/svn_blender.log"
LOGS_SVN_YAFARAY_CORE="$LOGS/svn_yafaray.log"
LOGS_SVN_YAFARAY_EXPORTER="$LOGS/svn_yafaray_exporter.log"

# Compilation logs files
LOGS_COMPILE_BLENDER="$LOGS/compile_blender.log"
LOGS_COMPILE_YAFARAY="$LOGS/compile_yafaray.log"

LOGS_ERRORS="$LOGS/errors.log"
