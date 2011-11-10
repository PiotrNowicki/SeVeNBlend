######################
# Useful functions

function print_info
{
	echo `date "+%T"` '[INFO] ' "$1"
}

function print_warn
{
	echo `date "+%T"` '[WARN] *** ' "$1"
}

function print_fatal
{
	echo `date "+%T"` '[FATAL] !!! ' "$1"
	exit 1
}

function print_separator
{
	echo
	echo "======================================$1============================================="
	echo
}

# Gets the revision number
function get_revision
{
	FOO=`svn info $1/`
	print_info "---- `echo \"$FOO\"|grep \"Rev:\"`"
	print_info "---- `echo \"$FOO\"|grep \"Date:\"`"
}

# Checks if argument is digit
function is_digit
{
	if echo "$1"|cut -f 2 -d '='|grep -qE ^[0-9]+$; then
		true
	else
		false
	fi
}
