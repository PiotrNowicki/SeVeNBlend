##########################################
# Recompile Yaf(a)ray Core and install it

if [ $SHOULD_COMPILE_YAFARAY -eq 1 ]; then

	# If we should use user-config.py for scons to optimize build...
	if [ $SHOULD_OPTIMIZE -eq 1 ]; then
		cp "$USER_CONFIG_SCRIPT" "$SVN_YAFARAY_CORE"
		if [ $? -ne 0 ]; then
			print_warn "user-config.py couldn't be copied properly! Creating unoptimized build of Yaf(a)ray Core."			
		else
			print_info "user-config.py copied properly. Creating optimized build of Yaf(a)ray Core."	
		fi
	fi
	
	# Add proper flag to build YF QT
	if [ $NO_QT_GUI -eq 0 ]; then
		print_info "Adding flag to user-config.py for QT Yafaray GUI".
		
		if [ ! -f "$SVN_YAFARAY_CORE"/user-config.py ]; then
			print_info "user-config.py doesn't exists in '$SVN_YAFARAY_CORE/'. Creating it."
			touch "$SVN_YAFARAY_CORE"/user-config.py
		fi
		
		if [ `grep -iE "WITH_YF_QT.+(true)|(1).*$" "$SVN_YAFARAY_CORE/user-config.py"|wc -l` -gt 0 ]; then
			print_warn "WITH_YF_QT flag already set to 'true' value!"
		elif [ `grep -iE "WITH_YF_QT.+(false)|(0).*$" "$SVN_YAFARAY_CORE/user-config.py"|wc -l` -gt 0 ]; then
			print_warn "WITH_YF_QT flag already set to 'false' value by user! DO NOT OVERWRITING!"
		else
			echo "WITH_YF_QT = 'true'" > "$SVN_YAFARAY_CORE"/user-config.py
			print_info "WITH_YF_QT flag set to 'true' value."
		fi
	fi

	print_info "Compiling Yaf(a)ray Core. Please be patient. It will take a while."
	print_info "-- (open another terminal and type: 'tail -f \"$LOGS_COMPILE_YAFARAY\"' if you want to see the progress."

	print_info "-- The sudo line which should appear below is for installing of Yaf(a)ray Core and running ldconfig purposes only."

	# compile and install Yaf(a)ray
	cd "$SVN_YAFARAY_CORE"
	
	if [ $USE_INTERNAL_SCONS -eq 1 ]; then
		python "$BLENDER_SCONS" -j $THREADS_NUM 1>$LOGS_COMPILE_YAFARAY 2>&1
		sudo python "$BLENDER_SCONS" -j $THREADS_NUM install 1>>$LOGS_COMPILE_YAFARAY 2>&1
	else
		scons -j $THREADS_NUM 1>$LOGS_COMPILE_YAFARAY 2>&1		
		sudo scons -j $THREADS_NUM install 1>>$LOGS_COMPILE_YAFARAY 2>&1
	fi
	
	# Check the status of compilation
	if [ $? -ne 0 ]; then
		print_warn "************************* Yaf(a)ray compilation error. **************************"
		print_warn "************************* Last '$LINES_TO_DUMP' lines auto-dump **************************"
		tail -n "$LINES_TO_DUMP" "$LOGS_COMPILE_YAFARAY"
		print_warn "************************** Check all logs in $LOGS_COMPILE_YAFARAY ******************"
		print_warn "************************************************************************************"
		print_fatal "Yaf(a)ray compilation error."
	fi

	# We've used 'sudo' to be able to install Yaf(a)ray into /usr/local/bin
	# Right now we can safely change the owner of built files back to user
	sudo chown -R `whoami` "$SVN_YAFARAY_CORE/"*
		
	# Return to our main directory
	cd - 1>/dev/null

	print_info "-- Compilation and installation of Yaf(a)ray Core successful!"
	print_info "Running ldconfig to link yaf(a)ray libraries."

	# Run LDConfig - without it when typing "yafaray-xml" it said that couldn't find yafaraycore.so library. 
	# You can set $LD_LIBRARY_PATH (depreciated) or run ldconfig
	sudo ldconfig

		# Check the status of compilation
	if [ $? -ne 0 ]; then
		print_warn "-- Ldconfig didn't end successfull! Yaf(a)ray core could not work properly (try running 'sudo ldconfig' on your own or setting environment variable '\$LD_LIBRARY_PATH' to '/usr/local/lib'"
	fi

fi