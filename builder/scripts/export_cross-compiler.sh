#!/usr/bin/env bash

###
#
# Export static cross compiler
# - generate an archive compressed with xz
#
###

script_dir="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)" || { echo "Couldn't determine the script's running directory, which probably matters, bailing out" >&2; exit 2; }
source "${script_dir}/../env/musl-cross-make"

# Created by argbash-init v2.10.0
# ARG_OPTIONAL_SINGLE([packages-dir],[p],[directory where package will be exported],[$script_dir/../../packages])
# ARG_OPTIONAL_BOOLEAN([verbose],[v],[enable verbose mode],[off])
# ARG_OPTIONAL_SINGLE([arch],[a],[target architecture],[x86_64])
# ARG_TYPE_GROUP_SET([arch],[type string],[arch],[x86_64,i686,armv7l,aarch64])
# ARG_HELP([Export a tarball containing a static cross compiler])
# ARGBASH_GO()
# needed because of Argbash --> m4_ignore([
### START OF CODE GENERATED BY Argbash v2.10.0 one line above ###
# Argbash is a bash code generator used to get arguments parsing right.
# Argbash is FREE SOFTWARE, see https://argbash.io for more info


die()
{
	local _ret="${2:-1}"
	test "${_PRINT_HELP:-no}" = yes && print_help >&2
	echo "$1" >&2
	exit "${_ret}"
}

# validators

arch()
{
	local _allowed=("x86_64" "i686" "armv7l" "aarch64") _seeking="$1"
	for element in "${_allowed[@]}"
	do
		test "$element" = "$_seeking" && echo "$element" && return 0
	done
	die "Value '$_seeking' (of argument '$2') doesn't match the list of allowed values: 'x86_64', 'i686', 'armv7l' and 'aarch64'" 4
}


begins_with_short_option()
{
	local first_option all_short_options='pvah'
	first_option="${1:0:1}"
	test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
}

# THE DEFAULTS INITIALIZATION - OPTIONALS
_arg_packages_dir="$script_dir/../../packages"
_arg_verbose="off"
_arg_arch="x86_64"


print_help()
{
	printf '%s\n' "Export a tarball containing a static cross compiler"
	printf 'Usage: %s [-p|--packages-dir <arg>] [-v|--(no-)verbose] [-a|--arch <type string>] [-h|--help]\n' "$0"
	printf '\t%s\n' "-p, --packages-dir: directory where package will be exported (default: '$script_dir/../../packages')"
	printf '\t%s\n' "-v, --verbose, --no-verbose: enable verbose mode (off by default)"
	printf '\t%s\n' "-a, --arch: target architecture. Can be one of: 'x86_64', 'i686', 'armv7l' and 'aarch64' (default: 'x86_64')"
	printf '\t%s\n' "-h, --help: Prints help"
}


parse_commandline()
{
	while test $# -gt 0
	do
		_key="$1"
		case "$_key" in
			-p|--packages-dir)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_packages_dir="$2"
				shift
				;;
			--packages-dir=*)
				_arg_packages_dir="${_key##--packages-dir=}"
				;;
			-p*)
				_arg_packages_dir="${_key##-p}"
				;;
			-v|--no-verbose|--verbose)
				_arg_verbose="on"
				test "${1:0:5}" = "--no-" && _arg_verbose="off"
				;;
			-v*)
				_arg_verbose="on"
				_next="${_key##-v}"
				if test -n "$_next" -a "$_next" != "$_key"
				then
					{ begins_with_short_option "$_next" && shift && set -- "-v" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
				fi
				;;
			-a|--arch)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_arch="$(arch "$2" "arch")" || exit 1
				shift
				;;
			--arch=*)
				_arg_arch="$(arch "${_key##--arch=}" "arch")" || exit 1
				;;
			-a*)
				_arg_arch="$(arch "${_key##-a}" "arch")" || exit 1
				;;
			-h|--help)
				print_help
				exit 0
				;;
			-h*)
				print_help
				exit 0
				;;
			*)
				_PRINT_HELP=yes die "FATAL ERROR: Got an unexpected argument '$1'" 1
				;;
		esac
		shift
	done
}

parse_commandline "$@"

# OTHER STUFF GENERATED BY Argbash
# Validation of values


### END OF CODE GENERATED BY Argbash (sortof) ### ])
# [ <-- needed because of Argbash


# vvv  PLACE YOUR CODE HERE  vvv

# export cross compiler
export_cross_compiler()
{
    [ ${_arg_verbose} == "on" ] && echo "Exporting cross compiler for '${_arg_arch}'..."

    if ! [ -d ${repo_dir} ]
    then
        echo "Local repository does not exist. Run 'checkout_musl-cross-make.sh' script first" 1>&2
        return 1
    fi

    _target="${arch_target_mapping[${_arg_arch}]}"
    if [ -z ${_target} ]
    then
        echo "Architecture '${_arg_arch}' is not supported"  1>&2
        return 1
    fi

    # directory where cross compiler was copied after being built
    _dist_dir="${repo_dir}/dist/${_target}-cross"
    # used to keep track of whether or not compiler was already built
    _built_marker="${repo_dir}/.built-${_arg_arch}"

    # ensure version was built
    if ! [ -f ${_built_marker} ]
    then
        echo "Cross compiler for '${_arg_arch}' was not built. Run 'build_cross_compiler.sh' script first" 1>&2
        return 1
    fi

    # ensure dist directory exists
    if ! [ -d ${_dist_dir} ]
    then
        echo "Directory '${_dist_dir}' does not exist. Run 'build_cross_compiler.sh' script first" 1>&2
        return 1
    fi

    # name of the package which will be exported
    _package_name="$(basename ${_dist_dir})"
    # name of the exported tarball
    _package_tarball_filename="${_package_name}.tgz"
    # location of the final tarball
    _package_tarball="${packages_dir}/${_package_tarball_filename}"

    # compress directory
    (cd ${packages_dir} &&
        tar -C $(dirname ${_dist_dir}) -czf ${_package_tarball_filename} $(basename ${_dist_dir}) && \
			chmod 666 ${_package_tarball_filename}) || return 1

    [ ${_arg_verbose} == "on" ] && echo "Cross compiler successfully exported for '${_arg_arch}' to '${_package_tarball}'"

    return 0
}

_PRINT_HELP=no
repo_dir="${script_dir}/../../musl-cross-make-repo"
packages_dir=${_arg_packages_dir}

mkdir -p ${packages_dir}

export_cross_compiler || die "Could not export cross compiler for '${_arg_arch}'"

# ^^^  TERMINATE YOUR CODE BEFORE THE BOTTOM ARGBASH MARKER  ^^^

# ] <-- needed because of Argbash