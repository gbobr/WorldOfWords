#!/bin/bash

function init_chat() {
	if ! test -f .chat
	then
		touch .chat
	fi

	LINE=$(wc -l < .chat)
	let LINE=$LINE+1
	tail --pid=$$ -f -n +$LINE .chat 2>/dev/null&
	CHATPID=$!
}

function stop_chat(){
	kill $CHATPID  &>/dev/null
}

function pause_chat(){
	kill -STOP $CHATPID &>/dev/null
}

function continue_chat() {
	kill -CONT $CHATPID &>/dev/null
}

function get_input() {
	read -s -n1
	tput sc
	pause_chat
	print_formatted "$1"
	read Command Params
	DirtyParams="$Params"
	sanitize Command
	sanitize Params
	tput cuu1
	tput el1 
	tput el
	continue_chat
}

function shout_to_chat(){
	for DIR in $(ls -a)
	do
		if test -d $DIR
		then
			echo "$LANG_HEAR_SHOUTS: $@" >> $DIR/.chat 
		fi
	done 2> /dev/null 
}

function write_to_chat(){
	echo "[$USER] $LANG_SAYS: $@" >> .chat
}

function take_input() {	
	read -s -n1
	tput sc
	pause_chat
	read -p "[$USER]: " -e MSG
	if test "$MSG" != "/salir"
	then
		echo "[$USER]: $MSG" >> .chat
	fi
	tput cuu1
	tput el1 
	tput el
	continue_chat
}

function chat(){
	clear
	echo "* Estas chateando *"
	init_chat
	local MSG=""
	while test "$MSG" != "/salir"
	do
		take_input
	done
	clear
}

#chat
