#!/bin/bash
shopt -s extglob

source wow.cfg
source lang/$WOW_LANG
source includes/chat.lib.sh
source includes/commons.lib.sh
source includes/inventory.lib.sh
source includes/nav.lib.sh

if test "$1" = "-a"
then
	ADMIN=1
fi

clear

echo "$LANG_WELLCOME_MESSAGE"

load_profile

echo $LAST_LOCATION
if test -z "$LAST_LOCATION"
then
	LAST_LOCATION="world"
fi

enter_room $LAST_LOCATION
read_cmd
while test "$Command" != "$CMD_EXIT"
do
	case "$Command" in
		$CMD_HELP) 	echo "$LANG_HELP_MESSAGE";;
		$CMD_LOOK)  if test -z $Params
			then
				clear
				print_formatted "$LANG_LOOK_AROUND"
				print_description
			else
				look $Params
			fi;;
		$CMD_PICKUP) pickup $Params;;
		$CMD_INVENTORY) inventory_show ;;
		$CMD_USE) 
			if is_in_inventory $Params
			then
				load_item $Params
				use
			else
				print_formatted "$LANG_NO_SUCH_OBJECT"
			fi;;
		$CMD_EDIT) if test -n $ADMIN
			then
				$EDITOR description
			fi;;
		$CMD_EXIT) 	exit_room 
			exit;;
		lw) list_worlds ;;
		cw) world_change $Params ;;
		mkworld) mkworld $Params ;;
		$CMD_SHELL) 	if test -n $ADMIN 
			then 
				bash 
			fi;;
		$CMD_CHAT) write_to_chat "$DirtyParams" ;;
		$CMD_SHOUT) shout_to_chat "$DirtyParams" ;;
		$CMD_GO)	
			found=0
			for Param in $Params
			do
				if test -d $Param && test $Param != ".."
				then
					found=1;
					enter_room $Param
					break
				fi
			done
			if test $found -eq 0
			then
				print_formatted "$LANG_NO_SUCH_PLACE"
			fi
			;;
		$CMD_CREATE)
			case "$Params" in
				$CMD_CREATE_ITEM) create_item;;
				*) create_place $Params;;
			esac;;
		*)	if test -d "$Command" #&& test $Command
			then
				enter_room "$Command"
			elif test -f "$Command" && test -x "$Command"
			then
				source "$Command"
			else
				print_formatted "$LANG_NO_SUCH_PLACE"
			fi;;
	esac
	read_cmd
done
