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
	echo -e "4. Archive\n"
	echo -e "5. Compile\n"
	echo -e "6. Add New File\n"
	echo -e "7. Delete Repository\n"
	echo -e "8. Exit\n"
echo -e "--------------------------------------------------------\n"

	# echo -e "1. Select File\n"
	# echo -e "2. Pull\n"
	# echo -e "3. Push\n"
	# echo -e "4. Compile C Programs in the Repository\n"
	# echo -e "5. Add new file"
	# echo -e "6. Add new file"
	# echo -e "7. Exit\n"
	# echo -e "--------------------------------------------------------\n"



	#Get the users option
	read choice
	#Process the Users Option
		if [ "$choice" = "1" ]
		then
			echo "Select File Option"
			ls

			
		if [ ! "$(ls -A ./Master)" ]
		then
    		echo "Error there are no files in this directory"
    		sleep 2
		else
			 echo " somehing "
    	 	selectFileQuestion
    		
		fi 
	elif [ "$choice" = "2" ]
		then
			echo "Pull Option"
			pull
			echo ""
			echo "Pull has been successful"
	elif [ "$choice" = "3" ]
		then
			echo "Push Option"
				cd Working
				ls
				echo -e "Please enter the file name of the file you wish to selcet"
				read filename
				cd ..
				if [ -f Working/$filename ]
				then 
					push "$filename"
					#cd $1
				else 
					echo "ERROR:	$filename does not exist, try a different file or create a new file called $filename"
				fi
	elif [ "$choice" = "4" ]
		then
			#Archive
			#Move back a directory
			cd ../
			#zip the repository
			zip -r "$1".zip $1
			#Success button
			echo ""
			echo "Archive Complete"			
			
			
	elif [ "$choice" = "5" ] 
		then
		compileC

	elif [ "$choice" = "6" ]
		then
			addFile

	elif [ "$choice" = "7" ]
		then
			deleteRepository

	elif [ "$choice" = "8" ]
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
	
	cd ../
	#Send success message
	echo ""
	echo "Pull has been successful"
}




push()
{
	echo -e "Please enter a short description of what you have changed (Please do this on one line only)"
	read description

	pwd
	cd Master
	touch "$1"
	cd ..
	diff Master/"$1" Working/"$1" > "$1".patch
	patch Master/"$1" "$1".patch
	DATE=`date '+%Y-%m-%d-%H:%M:%S'`

	# run the create a log for current push script (args = [filename date description patch_file])
	cd Changes
	writeToLog "$1" "$DATE" "$description"
	rm $1.patch

			echo ""
			echo "Push has been successful"
}




writeToLog()
{
	# echo -e "================================================================================================" >> "$1$2.log"
	# echo -e "File: $1" >> "$1$2.log"
	# echo -e "Date/Time: $2" >> "$1$2.log"
	# echo -e "Description: $3" >> "$1$2.log"
	# cat "$1.patch" >> "$1$2.log"

	echo -e "================================================================================================" >> "$1$2".log
	echo -e "$1" >> "$1$2".log
	echo -e "Date/Time: $2" >> "$1$2".log
	echo -e "Description: $3" >> "$1$2".log
	cd ../
	cat "$1".patch >> Changes/"$1$2".log
}

selectFileQuestion()
{
	pwd
	cd Working
	ls
	echo -e "Please enter the file name of the file you wish to selcet - Please Note this will not show if you have not pulled the repository"
	read fileName
	if [ -f $fileName ]
	then 
		echo " "
		selectFile
	else 
		echo "The file was not found in the current working directory"
		selectFileQuestion
	fi
	# result = ($selectFileQuestion) 
	# use above to use parameter
}

selectFile()
{
	runMenu=0

while [ "$runMenu" = "0" ] #true
do

	#Display the Repo Menu
	# echo -e "--------------------------------------------------------\n"
	# echo -e "Repository Menu- $1\n"
	# echo -e "--------------------------------------------------------\n"
	#Display the contents of the repo to the user
	echo "Please select an option from the list below \n"
	ls
	echo -e "--------------------------------------------------------\n"
	echo -e "1. Open file in Nano text editor\n"
	echo -e "2. Remove file\n"
	echo -e "3. Revert previous patch - Please revert in chronological order\n"
	echo -e "4. Exit"
	echo -e "--------------------------------------------------------\n"

	#Get the users option
	read choice
	#Process the Users Option
	if [ "$choice" = "1" ]
		then
			cd Working
			echo "Opening the file in nano"
			nano $fileName 
			cd ..
			echo -e "Would you like to push the changes? y/n"
			read input
			if [ $input = 'y' -o $input = 'n' ]
			then 
				if [ $input = 'y' ]
				then 
				push $fileName
				else
				echo " "
				fi 
			else
				echo "Invalid input please only enter y or n file has not been pushed"
			fi

		elif [ "$choice" = "2" ] 
		then
				echo -e "Are you sure you want to delete this file it will be deleted permanently? y/n"
				read input
				if [ $input = 'y' -o $input = 'n' ]
				then 
				if [ $input = 'y' ]
				then 
				cd Working
				rm $fileName
				cd ..
				cd Master
				rm $fileName
				cd ..
				cd Changes	
				rm *$fileName  ############################################################################
				cd ..
				else
				echo " "
				fi
			fi

		elif [ "$choice" = "3" ] 
		then
			revert
				
		elif [ "$choice" = "4" ]
		then
			echo "The program will now exit"
			exit 0
		else
			echo " "
		fi
	done
			
}

compileC()
{
	cd Working

	temp=`ls *.c`
	gcc $temp
	cd ..
	echo "All c programs have been compiled"
}

addFile()
{
	cd Working
	nano new
	echo "The file has been saved to working however it has not been pushed"
	cd ..
}

reversePatch()
{
	# set file to be path to log file
	file=$1

	# set lineCounter to 0
	lineCounter=0

	# create the empty .patch file
	cd Master
	touch "$1".patch
	cd ..

	# read log file line by line
	while IFS= read -r line
	do
		# store fileName 
		if [ "$lineCounter" = "1" ]
		then
			fileName="$line"
		fi

		# if on patch bit of log file, read to patch file
		if [ "$lineCounter" -gt "3" ]
		then
			echo "$line" >> Master/"$file".patch
		fi

		# increment lineCounter
		((lineCounter++))

	# reading from log file
	done < "Changes/$file"

	# reverse patch
	patch -R "Master/$fileName" "Master/$file.patch"

	# remove patch and log files
	rm -f Master/"$file".patch
	rm -f Changes/$file

	echo "patch reversed"
}

selectRevQuestion()
{
	pwd
	cd ../Changes
	ls
	echo -e "Please enter the file name of the file you wish to selcet - Please Note this will not show if you have not pulled the repository"
	read file
	if [ -f $file ]
	then 
		echo " "
		cd ..
		reversePatch $file
	else 
		echo "The file was not found in the current working directory"
		selectRevQuestion
	fi
	# result = ($selectFileQuestion) 
	# use above to use parameter
}

revert()
{
	selectRevQuestion
}

deleteRepository()
{
	echo "Are you sure that you want to delete the current repository? This will permanently delete the repository and all its files (y/n)"
	read input
	if [ $input = "y" ]
	then
		rm -rf `pwd`
		echo "$path has been deleted Please restart the program"
		exit 0
	elif [ $input = "n" ]
	then
		echo "Returning to repository menu"
		sleep 2
	else
		echo "Invalid option please enter y/n. Returning to Menu"
		sleep 2
	fi
}


#Main Method
ProcessMainMenu
