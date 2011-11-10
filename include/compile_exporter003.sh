##########################################
# Compile Yaf(a)ray Exporter 0.0.3 scripts and stubs using swig and copy results into SeVeNblend scripts

print_info "Compiling Yaf(a)ray Exporter 0.0.3 bindings using swig."

# compile
cd "$SVN_YAFARAY_CORE"

if [ $USE_INTERNAL_SCONS -eq 1 ]; then
	python "$BLENDER_SCONS" -j $THREADS_NUM swig 1>>$LOGS_COMPILE_YAFARAY 2>&1
else
	scons -j $THREADS_NUM swig 1>>$LOGS_COMPILE_YAFARAY 2>&1
fi

# Check the status of compilation
if [ $? -ne 0 ]; then
	print_warn "********** Yaf(a)ray 0.0.3 Exporter bindings compilation error. **********"
	print_warn "********** Last '$LINES_TO_DUMP' lines auto-dump **********"
	tail -n "$LINES_TO_DUMP" "$LOGS_COMPILE_YAFARAY"
	print_warn "********** Check all logs in $LOGS_COMPILE_YAFARAY **********"
	print_warn "********************************************************************"
	print_fatal "Yaf(a)ray 0.0.3 Exporter bindings compilation error."
fi

if [ -d "$SEVENBLEND_SCRIPTS" ]; then	
	print_info "Copying Yaf(a)ray Exporter 0.0.3 library and python bindings to SeVeNblend scripts directory."
	cp $INSTALLED_YAFARAY/bindings/*.py "$SEVENBLEND_SCRIPTS"
	cp $INSTALLED_YAFARAY/bindings/*.so "$SEVENBLEND_SCRIPTS"
	print_info "-- Copy successful."
	
	print_info "Copying Yaf(a)ray Exporter 0.0.3 scripts to SeVeNblend scripts directory."
	cp "$YAFARAY_003_SCRIPT_DIR"/*.py "$SEVENBLEND_SCRIPTS"
	print_info "-- Copy successful."	
else
	print_warn "No SeVeNblend scripts directory found in '$SEVENBLEND_SCRIPTS'. Exporter scripts will not be copied!"
fi

# Return to our main directory
cd - 1>/dev/null

print_info "-- Compilation and copying of Yaf(a)ray 0.0.3 Exporter bindings successful!"
