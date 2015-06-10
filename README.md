# jumpstart Install Script
Simple bash script to automate installation of WordPress with my [jumpstart theme](https://github.com/elimc/jumpstart) with some of my favorite settings.

# What
This script downloads and installs the latest core version of WordPress. The installation process downloads and installs latest version of my [jumpstart theme](https://github.com/elimc/jumpstart). It also automates a bunch of other manual things, like deleting the sample page, creating a primary menu, building a list of pages, deleting the `hello dolly` plugin, installing `jetpack`, etc ... Inspiration taken from Christopher Geary's [cool script](http://www.ltconsulting.co.uk/automated-wordpress-installation-with-bash-wp-cli/).

# Working with Vagrant
If you work with a team of developers, you might want to use Vagrant. In that case, check out [jVVV](https://github.com/elimc/jumpstart-vvv).

# Dependencies
* You will need to have [WP-CLI](http://wp-cli.org/) installed. This process is so easy, my mother could install it.
* You will need to have bash installed. If you are on a Mac, you already have it.
* AMPS stack of some sort. I use [AAMPS](http://www.ampps.com/). Your site won't load without PHP and MySQL. Duh!
* Optional: If you want to use gulp with your project, you will need to have Node installed.

# Warnings
This script has only been tested on a MacOS.

# Use
Personally, I put `wpinstall.sh` in my custom `Scripts` directory and then alias it in `bashrc`, like so: `alias wpinstall="~/Scripts/wpinstall.sh"`. When I want to install WordPress, I use the command line to navigate to the folder I want my WordPress site installed and type `bash wpinstall`. The script will ask you a couple questions, and then it will install everything. At this point, you might want to learn a new hobby ... due to all the newfound free time you have.

# Gulp
The script will ask if you would like to install gulp and npm. If you choose yes, these will be automatically loaded for you and your site will automatically be loaded in a browser, when the install has finished.

#Author
**Eli McMakin**

* GitHub: https://github.com/elimc
* Web site: www.elimcmakin.com