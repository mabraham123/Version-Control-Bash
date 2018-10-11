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
				# make new repository in current folder
				makeRepository "$repName"
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
	#Display the contents of the repo to the user
	echo "Repository Content:"
	ls
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
			pull
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

updateFile(){
	#true: find the difference and apply them
	diff $1 ../Master/$1 > $1.patch
	patch $1 $1.patch
	rm $1.patch
	#echo "$1 is now up to date"
}


pull(){
	#Show all the files that can be checked out
	cd Master
	echo ""
	echo "What file do you want to check out: "
	ls
	
	#Select file
	echo ""
	echo "filename: "
	read filename
	#Check if the file exists
	if [ -f $filename ]
		then
				#Check if file is in working dir
				cd ../Working
				if [ -f $filename ]
				then
					#true: find the difference and apply them
					# diff $filename ../Master/$filename > $filename.patch
					# patch $filename $filename.patch
					# rm $filename.patch
					


					updateFile "$filename"
					echo "$filename is now up to date"
				else
					#false: copy the files over
					cd ../Master
					cp $filename ../Working
					echo "File is now availbe to work on"

					
				fi
		else
				#Display error message that the repo exits already
				echo ""
				echo -e "ERROR:  The repository: $fileame does not exists\n\tTry Again with an existing file"
				echo ""
				cd ../
	fi
	
	#Send success message
}

push()
{
	echo -e "Please enter a short description of what you have changed (Please do this on one line only)"
	read description

	cd Working
	diff  ../Master/$1 $1 > $1.patch
	patch ../Master/$1 $1.patch
	DATE=`date '+%Y-%m-%d %H:%M:%S'`

	# run the create a log for current push script (args = [filename date description patch_file])
	./log.sh $1 date description $1.patch

	# remove the patch file as it is no longer needed and stored in $1.log anyway
	# rm $1.patch
}

selectFileQuestion()
{
	cd Master
	ls
	echo -e "Please enter the file name of the file you wish to selcet"
	read fileName
	if [ -f $fileName ]
	then 
		echo $fileName
	else 
		echo "The file was not found in the current working directory"
		selectFileQuestion
	fi
	# result = ($selectFileQuestion) 
	# use above to use parameter
}


#Main Method
ProcessMainMenu
