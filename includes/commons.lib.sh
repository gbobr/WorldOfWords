#!/bin/bash

function print_formatted(){
	echo -n -e "$(echo "$@" | sed -f "$BASEPATH"/includes/sed/formatter.sed)"
}

function read_cmd(){
	get_input "$LANG_PROMPT"
}

function sanitize() {
	eval "local val=\$$1"
	local val=$(sed -f "$BASEPATH/includes/sed/sanitizer.sed" <<< "$val" | tr '[:upper:]' '[:lower:]')
	eval "$1='$val'"
}

function load_profile() {
	USERPATH="$HOME/.worldofwords"
	if test -d $USERPATH
	then
		if test -f $USERPATH/profile
		then
			source $USERPATH/profile
		fi
	else
		create_profile
	fi
}

function create_profile(){
	USERPATH="$HOME/.worldofwords"
	mkdir $USERPATH
}

function save_profile(){
	echo "LAST_LOCATION=$LAST_LOCATION" > $USERPATH/profile
	echo "INVENTORY=$INVENTORY" >> $USERPATH/profile
}

function list_worlds(){
	if test -d $USERPATH/worlds
	then
		cd $USERPATH/worlds
		WORLDS=$(ls)
		print_formatted "$LANG_WORLD_LIST_HEADER"
		for WORLD in "$WORLDS"
		do
			print_formatted "\n-\*- *$WORLD*"
		done
		cd $LAST_LOCATION
	else
		print_formatted "$LANG_WORLD_LIST_EMPTY"
	fi
}

function mkworld(){
	WORLD_DIR="$USERPATH/worlds/$1/world"
	mkdir -p "$WORLD_DIR"
	cp "$BASEPATH/lang/briefing.$WOW_LANG" "$WORLD_DIR/description"
	enter_room "$WORLD_DIR"
}

function change_world(){
	WORLD_DIR="$USERPATH/worlds/$1/world"
	if test -d "$WORLD_DIR"
	then
		enter_room "$WORLD_DIR"
	else
		print_formatted "$LANG_WORLD_NOT_FOUND"
	fi
}
