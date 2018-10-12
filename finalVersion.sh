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
#initialise Menu
runMenu=0

while [ $runMenu = 0 ] #true
do
	displayMenu
	#Get the users option
	read choice
	#Process the Users Option
	if [ "$choice" = "1" ]
		then
			#Prompt name and create the directory
			echo ""
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
runRepMenu=0

until [ "$runRepMenu" = "1" ] #true
do

	#Display the Repo Menu
	echo -e "--------------------------------------------------------\n"
	echo -e "Repository Menu- $1\n"
	echo -e "--------------------------------------------------------\n"
	#Display the contents of the repo to the user
	echo "Repository Content:"
	ls

echo -e "--------------------------------------------------------\n"
	echo -e "1. View Files\n"
	echo -e "2. Select File\n"
	echo -e "3. Create New File\n"
	echo -e "4. Pull\n"
	echo -e "5. Push\n"
	echo -e "6. Archive\n"
	echo -e "7. Compile\n"
	echo -e "8. Delete Repository\n"
	echo -e "9. Exit\n"
echo -e "--------------------------------------------------------\n"

	#Get the users option
	read choice
	#Process the Users Option
	if [ "$choice" = "1" ]
		then
		#View Files
				#Display the contents of the repo to the user
				echo "Repository Content:"
					ls
				echo ""
				#Ask the user what folders they want to access
				echo "What directory do you want to view?"
				read folderName
			#CHeck if the fodler exists
			if [ -d $folderName ]
			then
				#Display the folder contents that the user asked for
				cd $folderName
				echo ""
				echo "$folderName Contents:"
				ls
				cd .. 
				sleep 2
			else
				#Error message to let the user know they entered an invalid folder name
				echo ""
				echo "ERROR:	$folderName is not a directory, please try again"
				echo ""
			fi
		elif [ "$choice" = "2" ]
		then
		#Select File
			if [ ! "$(ls -A ./Master)" ]
			then
	    		echo "Error there are no files in this directory"
	    		sleep 2
			else
	    	 	selectFileQuestion
			fi 
	elif [ "$choice" = "3" ]
		then
			#Create new File
			echo ""
			addFile
			echo ""
	elif [ "$choice" = "4" ]
		then
			 #Pull 
			echo "Pull Option"
			pull
			echo ""
			echo "Pull has been successful"		
			
			
	elif [ "$choice" = "5" ] 
		then
			#Push
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

	elif [ "$choice" = "6" ]
		then
			#Archive
			#Move back a directory
 			cd ../
 			#zip the repository
 			zip -r "$1".zip $1
 			#Success button
			echo ""
			echo "Archive Complete"
			runRepMenu=1

	elif [ "$choice" = "7" ]
		then
			#Complie
			compileC

	elif [ "$choice" = "8" ]
		then
		#Delete Repository
			deleteRepository
			runRepMenu=1
	elif [ "$choice" = "9" ]
		then
		#Exit
			echo "The program will now exit"
			runRepMenu=1
			cd ..
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
	echo ""
	echo "SUCCESS: $1 has been created"
	echo ""
	sleep 1
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
	# write data to log file in a structured way: First 4 lines contain information on the file, anything after that is the patch file for that
	echo -e "================================================================================================" >> "$1$2".log
	echo -e "$1" >> "$1$2".log
	echo -e "Date/Time: $2" >> "$1$2".log
	echo -e "Description: $3" >> "$1$2".log
	cd ../
	cat "$1".patch >> Changes/"$1$2".log
}

selectFileQuestion()
{
	cd Working
	ls
	#propts user to enter file name
	echo -e "Please enter the file name of the file you wish to select - Please Note this does not update your repository, so please pull before using this"
	read fileName
	# checks the file exists
	if [ -f $fileName ]
	then 
		echo " "
		cd ..
		selectFile
	else 
		echo "The file was not found in the current working directory"
		cd ..
		selectFileQuestion
	fi
	
}

selectFile()
{
	runSelectMenu=0

while [ "$runSelectMenu" = "0" ] #true
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
				#prompts user to ensure they want to delete
				echo -e "Are you sure you want to delete this file it will be deleted permanently? y/n"
				read input
				#checks for valid files
				if [ $input = 'y' -o $input = 'n' ]
				then 
				#checks for y
				if [ $input = 'y' ]
				then 
					#deletes from working and master
					cd Working
					rm $fileName
					cd ..
					cd Master
					rm $fileName
					cd ..
					#Exit the loop
					runSelectMenu=1
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
			runSelectMenu=1
		else
			echo " "
		fi
	done
			
}

compileC()
{
	#change to working 
	cd Working
	#finds all c files in the directory
	temp=`ls *.c`
	#compiles all .c files found
	gcc $temp
	cd ..
	echo "All c programs have been compiled"
}

addFile()
{
	cd Working
	#opens nano and sets default file name to working 
	
	#Ask user what they want the file name to be
	echo "Name the file: "
	read filename

	if [ ! -f $filename ]
	then
		#Edit the file
		nano $filename
		echo "The file has been saved to working however it has not been pushed"
		cd ..

		#Ask the user if they want to push the file they just created
		echo -e "Would you like to push the changes? y/n"
		read input
		if [ $input = 'y' -o $input = 'n' ]
		then 
			if [ $input = 'y' ]
			then 
				push $filename
			else
				echo " "
		fi 
			sleep 2
			else
				echo "Invalid input please only enter y or n file has not been pushed"
			fi
	else
		echo "error file already exists"
	fi
	

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
	# moves to changes
	cd Changes
	ls
	echo -e "Please enter the file name of the file you wish to select - Please Note this will not show if you have not pulled the repository"
	# reads the user input
	read file
	# checks the file exists in the directory
	if [ -f $file ]
	then 
		echo " "
		cd ..
		#calls reverse patch 
		reversePatch $file
	else 
		#reprompts user
		cd ..
		echo "The file was not found in the current working directory"
		selectRevQuestion

	fi

	
}

revert()
{
	selectRevQuestion
}

deleteRepository()
{
	# ask user if they are really sure they want to delete the repository and read their input (y/n)
	echo "Are you sure that you want to delete the current repository? This will permanently delete the repository and all its files (y/n)"
	read input

	# if y delete the repository and exit the program
	if [ $input = "y" ]
	then
		rm -rf `pwd`
		echo "repository has been deleted"
	# if n return to menu
	elif [ $input = "n" ]
	then
		echo "Returning to menu"
		sleep 2
	# else error message + return to menu 
	else
		echo "Invalid option please enter y/n. Returning to Menu"
		sleep 2
	fi

	cd ..
}


#Main Method
ProcessMainMenu