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
				makeRepository "$repName"

				# #Make the repo
				# mkdir $repName
				# 	echo "SUCCESS: $repName has been created"
				# 	echo ""
				# #Display menu for the repo
				# cd $repName
				# RepositoryMenu "$repName"
				# mkdir "Master"
				# mkdir "Working"
				# mkdir "Changes"
				#End loop
				runMenu=1
			fi
	elif [ "$choice" = "2" ]
		then
			#Display the repositories
			echo "Repositories: "
			ls -1d */

			#Ask the user for what repository they want to open
			echo ""
			echo "Type the name of the repository you want to open"
			read repName

			if [ -d $repName ]
			then
				cd $repName
				RepositoryMenu "$repName"
				runMenu=1
			else
				#Display error message that the repo exits already
				echo ""
				echo -e "ERROR:  The repository: $repName does not exists\n\tTry Again with a current repository or make a new one with the name: $repName"
				echo ""
			fi
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
			ls
	elif [ "$choice" = "2" ]
		then
			echo "Pull Option"
	elif [ "$choice" = "3" ]
		then
			echo "Push Option"
			#statements
	elif [ "$choice" = "4" ]
		then
			echo "The program will now exit"
			exit 0
	else
		#The user entered something that was not a valid entry
		echo ""
		echo "ERROR:	Please enter a vaild whole number from the selection above"
		echo ""
	fi 

done
}


makeRepository(){
	#Make the repo
	mkdir $1
		echo "SUCCESS: $1 has been created"
		echo ""
	#Move into the new repository
	cd $1
	
	#Create the sub folders
	mkdir Master
	mkdir Working
	mkdir Changes
	#Display the menu for the repository
	RepositoryMenu "$1"		
}


#Main Method
ProcessMainMenu