##############################
# Checkout the Blender source

print_info "... Checking out Blender tree. Please be patient - it might take a long while if it's initial checkout [around 10 minutes on 1 Mbps]."

# If Blender revision number was specified, checkout it
if [ $COMPILE_BLENDER_2_4 -gt 0 ]; then
	if [ $REV_BLENDER -gt 0 ]; then
		svn co "$URL_BLENDER_2_4" "$SVN_BLENDER" -r $REV_BLENDER > "$LOGS_SVN_BLENDER"
	else
		svn co "$URL_BLENDER_2_4" "$SVN_BLENDER" > "$LOGS_SVN_BLENDER"
	fi
else
	if [ $REV_BLENDER -gt 0 ]; then
		svn co "$URL_BLENDER" "$SVN_BLENDER" -r $REV_BLENDER > "$LOGS_SVN_BLENDER"
	else
		svn co "$URL_BLENDER" "$SVN_BLENDER" > "$LOGS_SVN_BLENDER"
	fi
fi


if [ $? -ne 0 ]; then
	print_fatal "Error while checkout on Blender tree! (try typing 'rm -rf $SVN_BLENDER' to remove whole directory')" 
fi

# Check if there were any changes in blender sources besides the yafray
if [ `grep -v "source/blender/yafray" "$LOGS_SVN_BLENDER"|grep "^[UAD]"|wc -l` -ne 0 ]; then
	print_info 'Changes in Blender tree.'
	SHOULD_COMPILE_BLENDER=1
else
	print_info 'No changes in Blender tree.'
	if [ ! -d "$INSTALLED_BLENDER" ]; then
		print_info "-- No build dir found! Presuming last script run ended unsuccessfull. Will compile Blender."
		SHOULD_COMPILE_BLENDER=1
	fi
fi

###############################
# Checkout the Yaf(a)ray source

print_info '... Checking out Yaf(a)ray core'

# If Yafaray core revision number was specified, checkout it
if [ $REV_YAF_CORE -gt 0 ]; then
	svn co "$URL_YAFARAY_CORE" "$SVN_YAFARAY_CORE" -r $REV_YAF_CORE > "$LOGS_SVN_YAFARAY_CORE"
else
	svn co "$URL_YAFARAY_CORE" "$SVN_YAFARAY_CORE" > "$LOGS_SVN_YAFARAY_CORE"
fi

if [ $? -ne 0 ]; then
	print_fatal "Error while checkout on Yaf(a)ray Core! (try typing 'rm -rf $SVN_YAFARAY_CORE' to remove whole directory')" 
fi

# Check if there were any changes in yaf(a)ray core
if [ `grep "^[UAD]" "$LOGS_SVN_YAFARAY_CORE" |wc -l` -ne 0 ]; then
	print_info 'Changes in Yaf(a)ray core.'
	SHOULD_COMPILE_YAFARAY=1
	SHOULD_COMPILE_BLENDER=1
else
	print_info 'No changes in Yaf(a)ray core.'
	if [ ! -d "$INSTALLED_YAFARAY" ]; then
		print_info "-- No build dir found! Presuming last script run ended unsuccessfull. Will compile Yaf(a)ray Core."
		SHOULD_COMPILE_YAFARAY=1
		SHOULD_COMPILE_BLENDER=1
	fi
fi

#################################
# Checkout the Yaf(a)ray exporter

print_info '... Checking out Yaf(a)ray exporter'

	
# If Yafaray exporter revision number was specified, checkout it
if [ $REV_YAF_EXP -gt 0 ]; then
	svn co "$URL_YAFARAY_EXPORTER" "$SVN_YAFARAY_EXPORTER" -r $REV_YAF_EXP > "$LOGS_SVN_YAFARAY_EXPORTER"
else
	svn co "$URL_YAFARAY_EXPORTER" "$SVN_YAFARAY_EXPORTER" > "$LOGS_SVN_YAFARAY_EXPORTER"
fi
	


if [ $? -ne 0 ]; then
	print_fatal "Error while checkout on Yaf(a)ray Exporter! (try typing 'rm -rf $SVN_YAFARAY_EXPORTER' to remove whole directory')" 
fi

# Check if there were any changes other than in yaf(a)ray exporter script (which is always redone)
if [ `grep -v "yafaray_ui.py" "$LOGS_SVN_YAFARAY_EXPORTER"|grep "^[UAD]"|wc -l` -ne 0 ]; then
	print_info 'Changes in Yaf(a)ray exporter.'
	SHOULD_COMPILE_BLENDER=1

else
	print_info 'No changes in Yaf(a)ray exporter.'
fi
