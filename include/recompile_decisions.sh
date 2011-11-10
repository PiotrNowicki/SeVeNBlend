#############################
# What should be recompiled?

if [ $SHOULD_COMPILE_BLENDER -eq 1 ]; then
	print_info '-- [TO COMPILE] Blender.'
else
	print_info '-- [UP TO DATE] Blender.'	
fi

get_revision "$SVN_BLENDER"

if [ $SHOULD_COMPILE_YAFARAY -eq 1 ]; then
	print_info '-- [TO COMPILE] Yaf(a)ray core.'
else
	print_info '-- [UP TO DATE] Yaf(a)ray core.'	
fi

get_revision "$SVN_YAFARAY_CORE"

print_info "-- [TO REDO] Yaf(a)ray Exporter Script. (we always redo it...)"

get_revision "$SVN_YAFARAY_EXPORTER"