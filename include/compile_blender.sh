#####################
# Recompile Blender

if [ $SHOULD_COMPILE_BLENDER -eq 1 ]; then
	print_info "Compiling Blender. Please be patient. It might take a while."
	
	# If we should use user-config.py for scons to optimize build...
	if [ $SHOULD_OPTIMIZE -eq 1 ]; then
		cp "$USER_CONFIG_SCRIPT" "$SVN_BLENDER"
		if [ $? -ne 0 ]; then
			print_warn "user-config.py couldn't be copied properly! Creating unoptimized build of Blender."			
		else
			print_info "user-config.py copied properly. Creating optimized build of Blender."	
		fi
	fi
	
	# If we should install customized icons...
	if [ $SHOULD_INSTALL_ICONS -eq 1 ]; then
		# Copy icons to proper directory in blender tree
		cp "$ADDONS/blenderbuttons.png" "$BLENDER_DATAFILES_DIR/blenderbuttons"

		if [ $? -ne 0 ]; then
			print_warn "Couldn't copy '$ADDONS/blenderbuttons.png' to '$BLENDER_DATAFILES_DIR/blenderbuttons'!"
		else
			print_info "'$ADDONS/blenderbuttons.png' successfully copied to '$BLENDER_DATAFILES_DIR/blenderbuttons'!"
		fi
		
		cd "$BLENDER_DATAFILES_DIR"

		# Create proper icons C file
		gcc datatoc.c 1>"$LOGS_COMPILE_BLENDER" 2>&1
		./a.out blenderbuttons 1>"$LOGS_COMPILE_BLENDER" 2>&1
		
		cd - 1>/dev/null
	
		# Tell Blender to use it when building
		cp "$BLENDER_DATAFILES_DIR/blenderbuttons.c" "$BLENDER_SRC"
	fi
	
	if [ ! -d $INSTALLED_BLENDER ]; then
		print_warn "! \"$INSTALLED_BLENDER\" directory not found - presuming it's your first compilation. It will take a REALLY LONG while [around 9 minutes on Intel C2D E6750 2,66 Ghz, 2 GB RAM]. Go for a walk or something ;)"
	fi
	
	# Hot fix for missing nasm.inc file (provided by 'stiv' from Blender.org forums)
	print_info "-- Fixing missing 'nasm.inc' file bug, by copying 'nasm.inc' into subdirs."
	
	cd "$SVN_BLENDER/extern/xvidcore/src/"
	find . -type d -exec cp nasm.inc '{}' \;
	
	print_info "-- (open another terminal and type: 'tail -f \"$LOGS_COMPILE_BLENDER\"' if you want to see the progress."
	
	cd -
	
	# compile Blender
	cd "$SVN_BLENDER"
	
	if [ $USE_INTERNAL_SCONS -eq 1 ]; then
		python "$BLENDER_SCONS" -j $THREADS_NUM 1>"$LOGS_COMPILE_BLENDER" 2>&1
	else	
		scons -j $THREADS_NUM 1>"$LOGS_COMPILE_BLENDER" 2>&1
	fi
	
	# Check the status of compilation
	if [ $? -ne 0 ]; then
		print_warn "********** Blender compilation error. **********"
		print_warn "********** Last '$LINES_TO_DUMP' lines auto-dump **********"
		tail -n "$LINES_TO_DUMP" "$LOGS_COMPILE_BLENDER"
		print_warn "********** Check all logs in $LOGS_COMPILE_BLENDER **********"
		print_warn "************************************************************"
		print_fatal "Blender compilation error"
	fi
	
	# Return to our main directory
	cd - 1>/dev/null
	
	print_info "-- Compilation of Blender successfull!"
	
fi