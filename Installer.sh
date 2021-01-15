#!/bin/sh

# Usage: 
# installer.sh -f curl

# Utilities
os_type () {
    # This is a function that aims to check the operating system of the user; 
    # If the user is using MacOS, it returns 1. 
    # If a Linux, it returns 2. 
    # If a Windows 32-bit OS, it returns 3
    # If a Windows 64-bit OS, it returns 4
	if [ "$(uname)" = "Darwin" ]; then
		return 1
	elif [ "$(expr substr $(uname -s) 1 5)" = "Linux" ]; then
		return 2
	elif [ "$(expr substr $(uname -s) 1 10)" = "MINGW32_NT" ]; then
		return 3
	elif [ "$(expr substr $(uname -s) 1 10)" = "MINGW64_NT" ]; then
		return 4
	fi
}

check_file () {
	filename=$1

	$filename -V &>/dev/null || $filename -v &>/dev/null

	if [ $? -eq 0 ]
	then
		echo "$filename is installed"
		exit 0
	fi
}

print_usage () {
	echo "Usage: installer.sh <filename>"
	echo "\tfilename This can only be either curl, wget, or node"
	exit 1
}

install_curl () {
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
