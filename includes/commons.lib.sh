#!/bin/bash

function print_formatted(){
	echo -n -e "$(echo "$@" | sed -f "$BASEPATH"/includes/sed/formatter.sed)"
}

function read_cmd(){
	#print_formatted "$LANG_PROMPT"
	#read Command Params
	#sanitize Command
	#sanitize Params
	get_input "$LANG_PROMPT"
}

function sanitize() {
	eval "local val=\$$1"
	local val=$(sed -f "$BASEPATH/includes/sed/sanitizer.sed" <<< "$val")
	eval "$1='$val'"
}

function load_player() {
	if test -f users
}
