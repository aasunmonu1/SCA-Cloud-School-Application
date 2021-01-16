A simple CLI file installer written with Bash

## Usage
This is a simple Command-Line Interface (CLI) application which installs the following softwares: 
curl, wget, and Node.js on your device.

It runs on MacOS, Linux, Windows 32-bit & 64-bit OS.

The script first checks the operating system of the user, then, it checks if the user has the software (amongst the available 3 softwares this CLI was written to install) he or she desires to install already installed on his or her system.

If the user already has the software installed, it sends a prompt telling the user that the desired software has already been previously installed.
If the user doesn't have it, it proceeds to then install the desired software for the user. The user gets a prompt, "Installing (name of deisred software; curl, wget, or node)..."

Once done, the user is notified that the software has now been installed successfully.

You can use this CLI with the command;

./installer.sh curl 

(If you desire to install curl)

Or

./installer.sh wget

(If you desire to install wget)

Or

./installer.sh node

(If you desire to install node)
