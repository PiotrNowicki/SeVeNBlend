if [ $CLEAN_BUILD -gt 0 ]; then
	print_info "Cleaning build directories"
	
	rm -rf "$MAIN_PATH/install"
	rm -rf "$MAIN_PATH/build"
	rm -rf "$SVN_YAFARAY_CORE/build"
fi

if [ $CLEAN_ALL -gt 0 ]; then
	print_info "Cleaning all resource directories (src + build + logs)"
	
	rm -rf "$MAIN_PATH"
fi

#if [ $? -ne 0 ]; then
#	print_info 'Clean successful'
#else
#	print_warn 'Clean unsuccessful'
#fi