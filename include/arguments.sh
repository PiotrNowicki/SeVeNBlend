for ARGUMENT in "$@"
do
	if [ $ARGUMENT = "HELP" ]; then
    	print_info "Usage: $0 [OPTION]'"
    	print_info "-- INSTALL_PCKGS - installs packages used by Blender and Yafaray core + exporter compilation (uses apt-get tool)"
    	print_info "-- NO_QT - do not build Yafaray QT GUI"
    	print_info "-- WITH_OPTIM - use compilation optimalization using user-script.py scripts"
		print_info "-- WITH_BUTT - put user-created icons as default ones"
		print_info "-- FORCE - force recompilation even if there is no need (code is up to date)"
		print_info "-- REV_BLENDER=[num] - checkout Blender revision [num] (default = latest)"
		print_info "-- REV_YAF_CORE=[num] - checkout Yaf(a)ray core revision [num] (default = latest)"
		print_info "-- REV_YAF_EXP=[num] - checkout Yaf(a)ray exporter revision [num] (default = latest)"
		print_info "-- THREADS_NUM=[num] - use [num] threads when building with scons (default = 2)"
		print_info "-- LINES_TO_DUMP=[num] - dump last [num] lines from log file when compilation fails (default = 15)"
		print_info "-- USE_INTERNAL_SCONS - use internal (Blender's) scons instead of system's"
		print_info "-- BLENDER2.4 - compile Blender 2.4 line (removed from trunk)"
		print_info "-- CLEAN - delete all compiled resources and quits"
		print_info "-- CLEAN_ALL - delete everything (sources + build + logs) and quits"
		print_info "-- HELP - shows this information"

		echo
		print_info "Example 1.: '$0 WITH_OPTIM FORCE' will force to recompile Blender using optimalization script"
		print_info "Example 2.: '$0 INSTALL_PCKGS LINES_TO_DUMP=25 USE_INTERNAL_SCONS' will download needed packages using apt-get and then build Blender using internal scons from Blender repository and in case of compilation error it will list last 25 lines on the screen."
		echo
		
		# We've told how the script works - so we can safely exit ;)
		exit 1
	
	#######
	# SWITCH - DO NOT INSTALL YAFARAY QT GUI
    #
    elif [ $ARGUMENT = "NO_QT" ]; then
    	print_info "Not building Yafaray QT GUI."
     	NO_QT_GUI=1
  
 	#######
	# SWITCH - INSTALL PACKAGES NEEDED FOR COMPILATION USING APT-GET
    #
    elif [ $ARGUMENT = "INSTALL_PCKGS" ]; then
    	print_info "Installing needed packages."
     	INSTALL_PACKAGES=1
     	    
     	        	    
	#######
	# SWITCH - OPTIMALIZATION
    #
    elif [ $ARGUMENT = "WITH_OPTIM" ]; then
    	print_info "Optimalization should be turned ON: using '$USER_CONFIG_SCRIPT'"
    	if [ -f "$USER_CONFIG_SCRIPT" ]; then
    		print_info "-- File '$USER_CONFIG_SCRIPT' found! Using it." 
    		SHOULD_OPTIMIZE=1
    	else
    		print_warn "-- File '$USER_CONFIG_SCRIPT' NOT found! Turning optimalization OFF!" 
    		SHOULD_OPTIMIZE=0
    	fi
    	
	#######
	# SWITCH - BUTTONS
    #
    elif [ $ARGUMENT = "WITH_BUTT" ]; then
    	print_info "Modified icons will be included into Blender build."
    	if [ -f "$ADDONS/blenderbuttons.png" ]; then
    		print_info "-- File '$ADDONS/blenderbuttons.png' found! Using it!" 
    		SHOULD_INSTALL_ICONS=1
    		#SHOULD_COMPILE_BLENDER=1
    	else
    		print_warn "-- File '$ADDONS/blenderbuttons.png' NOT found! Modified icons not included!" 
    		SHOULD_INSTALL_ICONS=0
    	fi
    	
    #######
	# SWITCH - FORCE RECOMPILATION
    #
  	elif [ $ARGUMENT = "FORCE" ]; then
    	print_info "Forcing recompiling of Blender and Yaf(a)ray Core."
     	SHOULD_COMPILE_BLENDER=1
		SHOULD_COMPILE_YAFARAY=1

	#######
	# SWITCH - USE INTERNAL BLENDER SCONS
    #
    elif [ $ARGUMENT = "USE_INTERNAL_SCONS" ]; then
    	print_info "Using internal Blender scons."
     	USE_INTERNAL_SCONS=1
     	
	#######
	# SWITCH - CLEAN BUILD DIRECTORIES
    #
    elif [ $ARGUMENT = "CLEAN" ]; then
    	print_info "Will clean build directories."
     	CLEAN_BUILD=1
     	    
	#######
	# SWITCH - CLEAN SRC+BUILD DIRECTORIES
    #
    elif [ $ARGUMENT = "CLEAN_ALL" ]; then
    	print_info "Will clean all files."
     	CLEAN_ALL=1    
     	      	         	     	
	#######
	# VALUE - BLENDER REVISION
    #
    elif [ `echo "$ARGUMENT"|cut -f 1 -d '='` = "REV_BLENDER" ]; then
    	print_info "Specified Blender Revision."
    	REV_BLENDER=`echo "$ARGUMENT"|cut -f 2 -d '='`

		if echo "$REV_BLENDER"|cut -f 2 -d '='|grep -qE ^[0-9]+$; then 
			print_info "-- Revision number $REV_BLENDER will be compiled."
		else
			print_warn " Revision number '$REV_BLENDER' is in wrong format (only digits are accepted). Newest revision will be compiled."
			REV_BLENDER=0
		fi
     	
   
   	#######
	# VALUE - YAFARAY CORE REVISION
    #
    elif [ `echo "$ARGUMENT"|cut -f 1 -d '='` = "REV_YAF_CORE" ]; then
    	print_info "Specified Yaf(a)ray Core Revision."
    	REV_YAF_CORE_TMP=`echo "$ARGUMENT"|cut -f 2 -d '='`

		if is_digit "$REV_YAF_CORE_TMP"; then 
			print_info "-- Revision number $REV_YAF_CORE_TMP will be compiled."
			REV_YAF_CORE=$REV_YAF_CORE_TMP
		else
			print_warn " Revision number '$REV_YAF_CORE_TMP' is in wrong format (only digits are accepted). Newest revision will be compiled."
		fi
		
   	#######
	# VALUE - YAFARAY EXPORTER REVISION
    #
	elif [ `echo "$ARGUMENT"|cut -f 1 -d '='` = "REV_YAF_EXP" ]; then
    	print_info "Specified Yaf(a)ray Exporter Revision."
    	REV_YAF_EXP_TMP=`echo "$ARGUMENT"|cut -f 2 -d '='`

		if is_digit "$REV_YAF_EXP_TMP"; then 
			print_info "-- Revision number $REV_YAF_EXP_TMP will be compiled."
			REV_YAF_EXP=$REV_YAF_EXP_TMP
		else
			print_warn " Revision number '$REV_YAF_EXP_TMP' is in wrong format (only digits are accepted). Newest revision will be compiled."
		fi
		
	#######
	# VALUE - SCONS THREADS NUMBER
    #
	elif [ `echo "$ARGUMENT"|cut -f 1 -d '='` = "THREADS_NUM" ]; then
    	print_info "Specified Scons parrarel target to be built."
    	THREADS_NUM_TMP=`echo "$ARGUMENT"|cut -f 2 -d '='`

		if is_digit "$THREADS_NUM_TMP"; then 
			print_info "-- $THREADS_NUM_TMP targets will be built parrarel."
			THREADS_NUM=$THREADS_NUM_TMP
		else
			print_warn " Number '$THREADS_NUM_TMP' is in wrong format (only digits are accepted). 2 targets will be build simultaneously."
		fi
 
	#######
	# VALUE - LINES OF LOGS TO BE DUMPED
    #
	elif [ `echo "$ARGUMENT"|cut -f 1 -d '='` = "LINES_TO_DUMP" ]; then
    	print_info "Specified lines of logs to be dumped."
    	LINES_TO_DUMP_TMP=`echo "$ARGUMENT"|cut -f 2 -d '='`

		if is_digit "$LINES_TO_DUMP_TMP"; then 
			print_info "-- Last $LINES_TO_DUMP_TMP will be dumped."
			LINES_TO_DUMP=$LINES_TO_DUMP_TMP
		else
			print_warn " Number '$LINES_TO_DUMP_TMP' is in wrong format (only digits are accepted). Default numer for dumped line is 15."
		fi
		
	#######
	# SWITCH - SHOULD WE COMPILE BLENDER 2.4 (WHICH IS NOT IN TRUNK ANYMORE)
    #
	elif [ `echo "$ARGUMENT"|cut -f 1 -d '='` = "BLENDER2.4" ]; then
    	print_info "Compiling Blender 2.4 line. This will not be the latest version of Blender!"
    	COMPILE_BLENDER_2_4=1 	         	  	     	    	     
     	       	     	
    #######
	# SWITCH - UNKNOWN
    #
    else
    	print_info "Unknown argument '$ARGUMENT'. Ommiting."
    fi
done