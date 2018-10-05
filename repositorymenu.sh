#!/bin/bash

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

ProcessMainMenu(){
#initalise Menu
runMenu=0

while [ "$runMenu" = "0" ] #true
do
	displayMenu
	#Get the users option
	read choice
	#Process the Users Option
	if [ "$choice" = "1" ]
		then
			#Prompt name and create the directory
			echo "Please enter the name of your new repository"
			read repName
			#Check if the repo the user wants to create already exists
			if [ -d $repName ]
			then
				#Display error message that the repo exits already
				echo ""
				echo -e "ERROR:  The repository: $repName already exists\n\tChoose a new name or open that repository"
				echo ""
			else
				#Make the repo
				mkdir $repName
					echo "SUCCESS: $repName has been created"
					echo ""
				#Display menu for the repo
				RepositoryMenu "$repName"
				#End loop
				runMenu=1
			fi
	elif [ "$choice" = "2" ]
		then
			ls -1
			#statements
	elif [ "$choice" = "3" ]
		then
			echo "The program will now exit"
			exit 0
	else
		#The user entered something that was not a valid entry
		echo ""
		echo "ERROR:	Please enter a valid whole number from the selection above"
		echo ""
			#statements
	fi 

done
}


RepositoryMenu(){
#Initalise varaibles
runMenu=0

while [ "$runMenu" = "0" ] #true
do

	#Display the Repo Menu
	echo -e "--------------------------------------------------------\n"
	echo -e "Repository Menu- $1\n"
	echo -e "--------------------------------------------------------\n"
	echo -e "1. Select File\n"
	echo -e "2. Pull\n"
	echo -e "3. Push\n"
	echo -e "4. Exit\n"
	echo -e "--------------------------------------------------------\n"

	#Get the users option
	read choice
	#Process the Users Option
	if [ "$choice" = "1" ]
		then
			echo "Select File Option"
	elif [ "$choice" = "2" ]
		then
			echo "Pull Option"
	elif [ "$choice" = "3" ]
		then
			echo "Push Option"
			#statements
	elif [ "$choice" = "4"]
		then
			runMenu=1 #false
			echo "The program will now exit"
	else
		#The user entered something that was not a valid entry
		echo ""
		echo "ERROR:	Please enter a vaild whole number from the selection above"
		echo ""
	fi 

done
}



#Main Method
ProcessMainMenu