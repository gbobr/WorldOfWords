#!/bin/bash

function inventory_add() {
	if test -z $INVENTORY
	then	
		INVENTORY="$1"
	else
		INVENTORY="$INVENTORY:$1"
	fi
}

function load_item() {
	ITEMPATH="$BASEPATH/items/$1"
	if test -f "$ITEMPATH"
	then
		source "$ITEMPATH"
	fi
}

function inventory_show() {
	if test -n "$INVENTORY"
	then
		print_formatted "$LANG_INVENTORY_HEADER"
		local IFS=":" 
		for ITEM in $INVENTORY
		do
			load_item $ITEM
			print_formatted "* $INVENTORY_DESCRIPTION"
		done
	else
		print_formatted "$LANG_INVENTORY_EMPTY"
	fi
}

function is_in_inventory() {
	local IFS=":"
	for ITEM in $INVENTORY
	do
		if test $ITEM = $1
		then
			return 0;
		fi;
	done
	return 1;
}

function look() {
	if test -f $1 && test ! -x $1 && test $1 != "description"
	then
		load_item $1
		echo $ITEM_DESCRIPTION
	elif is_in_inventory $1
	then
		load_item $1
		echo $ITEM_DESCRIPTION
	else
		ITEMNAME="$1"
		print_formatted "$LANG_LOOK_NOT_SUCH_ITEM"
	fi
}

function pickup() {
	found=0
	for Param in $Params
	do
		if test -f $Param && test ! -x $Param && test $Param != "description"
		then
			found=1
			load_item $Param
			inventory_add $Param
			echo -e "$PICKUP_MESSAGE"
		fi
	done
	
	if test $found -eq 0
	then
		ITEMNAME="$Params"
		print_formatted "$LANG_PICKUP_NOT_SUCH_ITEM"
	fi
}