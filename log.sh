#!/bin/bash

writeToLog()
{
	echo -e "================================================================================================" >> $1$2.log
	echo -e "File: $1" >> $1$2.log
	echo -e "Date/Time: $2" >> $1$2.log
	echo -e "Description: $3" >> $1$2.log
	cat "$4" >> $1$2.log
}

# Example ========================================
diff test test2 > test.patch
writeToLog "test" "2106" "hello hello" "test.patch"

# readFromLog()
# {
# 	# while Read line, use counter for first 4 lines, reset counter on seeing ========================================
# }