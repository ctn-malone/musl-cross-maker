#!/usr/bin/env bash

###
#
# Build a docker image which can be used to build a static cross compiler
# Image will contain :
# - base package needed to build a cross-compiler
#
###

script_dir="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)" || { echo "Couldn't determine the script's running directory, which probably matters, bailing out" >&2; exit 2; }

# Created by argbash-init v2.10.0
# ARG_OPTIONAL_SINGLE([arch],[a],[target architecture],[x86_64])
# ARG_OPTIONAL_BOOLEAN([force],[f],[rebuild image even if it exists],[off])
# ARG_OPTIONAL_BOOLEAN([verbose],[v],[enable verbose mode],[off])
# ARG_TYPE_GROUP_SET([arch],[type string],[arch],[x86_64,i686,armv7l,aarch64])
# ARG_HELP([Build a docker image which can be used to build a static cross compiler])
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
	local first_option all_short_options='afvh'
	first_option="${1:0:1}"
	test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
}

# THE DEFAULTS INITIALIZATION - OPTIONALS
_arg_arch="x86_64"
_arg_force="off"
_arg_verbose="off"


print_help()
{
	printf '%s\n' "Build a docker image which can be used to build a static cross compiler"
	printf 'Usage: %s [-a|--arch <type string>] [-f|--(no-)force] [-v|--(no-)verbose] [-h|--help]\n' "$0"
	printf '\t%s\n' "-a, --arch: target architecture. Can be one of: 'x86_64', 'i686', 'armv7l' and 'aarch64' (default: 'x86_64')"
	printf '\t%s\n' "-f, --force, --no-force: rebuild image even if it exists (off by default)"
	printf '\t%s\n' "-v, --verbose, --no-verbose: enable verbose mode (off by default)"
	printf '\t%s\n' "-h, --help: Prints help"
}


parse_commandline()
{
	while test $# -gt 0
	do
		_key="$1"
		case "$_key" in
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
			-f|--no-force|--force)
				_arg_force="on"
				test "${1:0:5}" = "--no-" && _arg_force="off"
				;;
			-f*)
				_arg_force="on"
				_next="${_key##-f}"
				if test -n "$_next" -a "$_next" != "$_key"
				then
					{ begins_with_short_option "$_next" && shift && set -- "-f" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
				fi
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

# Build docker image
build_image()
{
    # check if image exist
    _image_name="musl-cross-maker:${_arg_arch}"
    _image=$(docker images --format "{{.ID}}" --filter=reference="${_image_name}" | head -1)

    [ ${_arg_verbose} == "on" ] && echo "Building docker image for '${_arg_arch}'..."

    # no need to build image
    if ! [ -z ${_image} ] && [ $_arg_force == "off" ]
    then
        [ ${_arg_verbose} == "on" ] && echo "No need to build docker image for '${_arg_arch}'..."
    else
        docker build --build-arg arch=${_arg_arch} --no-cache --force-rm=true --rm=true -f ${script_dir}/../Dockerfile -t ${_image_name} ${script_dir}/../.. || return 1
        [ ${_arg_verbose} == "on" ] && echo "Successfully built docker image for '${_arg_arch}'"
    fi

    return 0
}

_PRINT_HELP=no

build_image || die "Could not build docker image for '${_arg_arch}'"

# ^^^  TERMINATE YOUR CODE BEFORE THE BOTTOM ARGBASH MARKER  ^^^

# ] <-- needed because of Argbash