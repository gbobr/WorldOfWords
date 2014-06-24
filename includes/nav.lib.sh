#!/bin/bash

function exit_room(){
	if test -f .users 
	then 
		sed -i /^$USER\$/d .users 
	fi
	
	stop_chat
}

function enter_room(){
	exit_room
	clear
	cd $1

	if test -f description; then
		print_description
	else
		echo "No hay una descripción para este lugar"
		if test -n $ADMIN; then
			echo "¿Desea agregar una? [s/n]"
			read OPT
			if test OPT = "s"; then
				vim description	
			fi	
		fi
	fi
	echo $USER >> .users
	
	PEOPLECOUNT=$(wc -l < .users)
	if test $PEOPLECOUNT -gt 1
	then
		print_formatted "$LANG_PEOPLE_ARROUND"
	fi

	LAST_LOCATION=$(pwd)

	save_profile	
	init_chat
	
}

function print_description() {
	if test -f description
	then
		print_formatted "$(<description)"
	fi
}

function create_place(){

		if test -z $1
		then
			print_formatted "$LANG_INVALID_ARGUMENT"
			return 1
		fi
			
		if test -d $1
		then
			print_formatted "$LANG_PLACE_EXISTS"
			return 1
		fi
				
		mkdir $1
		vim $1/description
		print_formatted "$LANG_CREATE_BACK_ACTION"
		read CONF
		if test "$CONF" = "$INPUT_YES"; then
			echo "$LANG_INPUT_BACK_ACTION_NAME"
			read ACTION
			if test -z "$ACTION"
			then
				ACTION="$LANG_DEFAULT_BACK_ACTION"
			fi

			ln -s .. $1/$ACTION
		fi 

}
