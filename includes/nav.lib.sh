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
		print_formatted "\n-A tu alrededor puedes ver a otras -$PEOPLECOUNT- personas-..."
	fi
	
	init_chat
	
}

function print_description() {
	print_formatted "$(<description)"
}

function create_room(){

	if test -n $ADMIN; then
		echo "El lugar ingresado no existe, deseas crearlo? [s/n]"
		read CONF
		if test $CONF = "s"; then
			mkdir $1
			vim $1/description
			echo "Desea agregar una acción para volver? [s/n]"
			read CONF
			if test $CONF = "s"; then
				echo "Ingrese el nombre de la acción de volver: "
				read ACTION
				ln -s .. $1/$ACTION
			fi 
			enter_room $1
		fi
	fi

}