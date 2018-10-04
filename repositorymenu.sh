#!/bin/bash
clear
displayMenu()
{
	echo -e "--------------------------------------------------------\n"
	echo -e "Main Menu\n"
	echo -e "--------------------------------------------------------\n"
	echo -e "1. Create New Repository\n"
	echo -e "2. View Repository\n"
	echo -e "3. Quit\n"
	echo -e "--------------------------------------------------------\n"
}

runMenu=0
while [ "$runMenu" = "0" ] #true
do
	echo "$runMenu"
	displayMenu
	read choice
	if [ "$choice" = "1" ]
		then
			#Prompt name and create the directory
			echo "Please enter the name of your new repository"
			read repName
			mkdir $repName
			echo "$repName has been created"
	elif [ "$choice" = "2" ]
		then
			ls -1
			#statements
	elif [ "$choice" = "3" ]
		then
			runMenu=1 #false
			echo "The program will now exit"
			#statements
	else
		echo "$choice"
		echo "error"
			#statements
	fi 

done









