#!/bin/sh

# Usage: 
# installer.sh -f curl

# Utilities
os_type () {
    # This is a function that aims to check the operating system of the user; 
    # If the user is using MacOS, it returns 1. 
    # Else-if a Linux, it returns 2. 
    # Else-if a Windows 32-bit OS, it returns 3
    # Else-if a Windows 64-bit OS, it returns 4
	if [ "$(uname)" = "Darwin" ]; then
		return 1
	elif [ "$(expr substr $(uname -s) 1 5)" = "Linux" ]; then
		return 2
	elif [ "$(expr substr $(uname -s) 1 10)" = "MINGW32_NT" ]; then
		return 3
	elif [ "$(expr substr $(uname -s) 1 10)" = "MINGW64_NT" ]; then
		return 4
	fi
    # To close an if statement, you use fi (Basically writing if backwards)
}

check_file () {
    # This function is to check if the files we wish to install already exist on the user's system.
    # We create a variable called filename that takes the first argument.
	filename=$1
	
	$filename -V &>/dev/null || $filename -v &>/dev/null
    # This line simply tells the system, "don't pour out to my terminal the output of the command before it. Just do your thing and hold the response." 

	if [ $? -eq 0 ]
    # This checks if the exit status of the last command equates to 0 (i.e is successful)
    # If it is successful, it means that the filename passed already exit on the user's device.
    # This then tells the user that the filename passed is already installed in his/her device.
	then
		echo "$filename is installed"
		exit 0
	fi
}

print_usage () {
    # This is a function that tells the user how to use the installer CLI.
    # It also tells the user the filenames that can be checked for or installed with this CLI.
	echo "Usage: installer.sh <filename>"
	echo "\tfilename This can only be either curl, wget, or node"
	exit 1
}

install_curl () {
    # This is a function that installs curl.
    # It checks to verify that the filename the user entered was curl
	filename=curl
	check_file $filename

	os_type
	case $? in 
		1)
			/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)";;
		2)
			apt-get install $filename;;
		*)
			echo "Environment not supported"
			exit 1;;
	esac
}

install_wget () {
     # This is a function that installs wget.
     # It checks to verify that the filename the user entered was wget
	filename=wget
	check_file $filename

	os_type 
	case $? in
		1)
			brew install $filename;;
		2)
			apt-get install $filename;;
		*)
			echo "Environment not supported"
			exit 1;;
	esac
}

install_nodejs () {
     # This is a function that installs node.
     # It checks to verify that the filename the user entered was node
	filename=node
	check_file $filename

	os_type
	case $? in
		1)
			brew install node;;
		2)
			curl -sL https://deb.nodesource.com/setup_15.x | sudo -E bash -

			if [ $? -eq 0 ]
			then
				apt-get install -y nodejs
			else
				echo "Failed to setup nodesource"
			fi
			;;
		*)
			echo "Environment not supported"
			exit 1;;
	esac
}


main () {
	case $1 in 
		curl)
			echo "Installing curl ..."
			install_curl;;
		wget)
			echo "Installing wget ..."
			install_wget;;
		node)
			echo "Installing nodejs ..."
			install_nodejs;;
		*)
			if [ $# -eq 0 ]
			then
				print_usage
			else
				echo "Error: This installer cannot install $1"
				echo 
				print_usage
			fi
			;;
	esac
}

main "$@"
