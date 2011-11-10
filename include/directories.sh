######################
# Prepare directories

if [ ! -d "$MAIN_PATH" ]; then
	mkdir "$MAIN_PATH"
	if [ $? -ne 0 ]; then 
		print_fatal 'Cannot create main path!'
	else
		print_info 'Main path created'
	fi
fi

if [ ! -d "$LOGS" ]; then
	mkdir "$LOGS"
		if [ $? -ne 0 ]; then 
		print_fatal 'Cannot create logs path!'
	else
		print_info 'Logs path created'
	fi
fi

if [ ! -d "$SEVENBLEND_SCRIPTS" ]; then
	mkdir "$SEVENBLEND_SCRIPTS"
		if [ $? -ne 0 ]; then 
		print_fatal 'Cannot create SeVeNblend scripts path!'
	else
		print_info 'SeVeNblend scripts path created.'
	fi
else
	rm -f "$SEVENBLEND_SCRIPTS"/*
	
	#if [ $? -ne 0 ]; then
		print_info 'SeVeNblend scripts resources removed.'
	#else
	#	print_warn 'SeVeNblend scripts could not be removed successfuly.'
	#fi
fi


# We must remove the yaf(a)ray files because we want Blender to checkout it's own version - later we will overwrite it again	
if [ -d "$BLENDER_YAFRAY" ]; then
	rm -fr "$BLENDER_YAFRAY"
	
	if [ $? -ne 0 ]; then
		print_fatal "Cannot remove Yafray from Blender tree!" 
	fi
	
	print_info 'Yafray removed from Blender tree.' 
fi
