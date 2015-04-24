# jumpstart-install-script
Simple bash script to automate installation of WordPress with jumpstart and some of my favorite settings.

# What
This script downloads and installs the latest core version of WordPress. The installation process dowloads and installs latest version of my jumpstart theme (https://github.com/elimc/jumpstart). It also automates a bunch of other manual things, like deleting the sample page, creating a primary menu, building a list of pages, deleting the `hello dolly` plugin, installing `jetpack`, etc ...

# Dependencies
1. You will need to have WP-CLI installed. This is an easy process. Grab it, here: http://wp-cli.org/
2. You will need to have bash installed. If you are on a Mac, you already have it.
3. AMPS stack of some sort. Personally, I use AMMPS. Apache and MySQL needs to be running.

# Warnings
This script has not been tested on a PC.

# TODO
The Holy Grail is to port this to a Virtual Machine with Vagrant and have a true one-command install process.

# Use
Personally, I put `wpinstall.sh` in a `Scripts` file and then alias it in `bashrc`, like so: `alias wpinstall="~/Scripts/wpinstall.sh"`. When I want to install WordPress, I use the command line to navigate to the folder I want my WordPress site installed and type `bash wpinstall`. The script will ask you a couple questions, and then it will install everything. At this point, you might want to learn a new hobby ... due to all the newfound free time you have.