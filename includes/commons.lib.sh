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
	USERPUBLICPATH="$USERWORLDS_PATH/$USER"
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
	print_formatted "$LANG_PUBLIC_WORLDS"
	_internal_list_worlds $BASEPATH
	print_formatted "$LANG_PERSONAL_WORLDS"
	_internal_list_worlds $USERPATH
}

function _internal_list_worlds(){
	WORLDSPATH=$1/worlds
	if test -d $WORLDSPATH
	then
		cd $WORLDSPATH
		#WORLDS=$(ls)
		print_formatted "$LANG_WORLD_LIST_HEADER"
		for WORLD in * #"$WORLDS"
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

function player_private_world_exists() {
	WORLD_DIR="$USERPATH/worlds/$1/world"	
	return test -d "$WORLD_DIR"
}

funtion player_public_world_exists() {
	WORLD_DIR="$USERPATH/worlds/$1/world"	
	return test -d "$USERPUBLICPATH/$1"
}

function world_change(){
	WORLD_NAME="worlds/$1/world"
	WORLD_DIR="$BASEPATH/$WORLD_NAME"
	if test -d "$WORLD_DIR"
	then
		enter_room "$WORLD_DIR"
	else
		WORLD_DIR="$USERPATH/$WORLD_NAME"
		if test -d "$WORLD_DIR"
		then
			enter_room "$WORLD_DIR"
		else
			print_formatted "$LANG_WORLD_NOT_FOUND"
		fi
	fi
}

function publish_world(){
	if player_world_exists "$1"
	then
		if public_world_exists $1
		then

		fi
	fi
}
