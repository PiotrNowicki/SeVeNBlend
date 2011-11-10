########################################################
# Copy Yaf(a)ray Exporter 0.0.2 and 0.0.3 scripts (along with 0.0.3 compiled bindings) into blender directory 

print_info 'Copying Export scripts into Blender scripts directory'

if [ -d "$BLENDER_SCRIPTS_DIR" ]; then
	cp "$SEVENBLEND_SCRIPTS"/* "$BLENDER_SCRIPTS_DIR/"
	print_info "-- Copy successful." 
else
	print_warn "-- Directory '$BLENDER_SCRIPTS_DIR' does not exist. Copy failed." 
fi