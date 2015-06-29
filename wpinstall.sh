## 
# jumpstart install script
# 
# Simple bash script to automate installation of WordPress with jumpstart and some of my favorite settings.
# 
# Dependencies:
# 1: WP-CLI
# 2: Bash
##
clear

# Set up the shell variables for colors
# http://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux
yellow=`tput setaf 3`;
green=`tput setaf 2`;
clear=`tput sgr0`;

# Start it up ...
echo "${green}"
echo "============================================"
echo ""
echo "Begin install"
echo ""
echo "============================================"
echo "${clear}"

# accept the name of our website
echo "${yellow}Site Name:${clear}"
read -e sitename
echo ""

# accept admin username
echo "${yellow}Admin Username:${clear}"
read -e wpuser
echo ""

# accept admin password
echo "${yellow}Admin Password:${clear}"
read -e pass
echo ""

# accept admin email
echo "${yellow}Admin email:${clear}"
read -e admin_email
echo ""

# accept a comma separated list of pages
echo "${yellow}Add a comma separated list of pages that you want in your site:${clear}"
read -e allpages
echo ""

# accept user input for the databse name
echo "${yellow}Database Name:${clear}"
read -e dbname
echo ""

# accept user input for the databse user
echo "${yellow}Database User:${clear}"
read -e dbuser
echo ""

# accept user input for the databse password
echo "${yellow}Database Password:${clear}"
read -e dbpass
echo ""

# Set up gulp.js?
echo "${yellow}Do you want to use npm and gulp? (y/n)${clear}"
read -e npmandgulp
echo ""

if [ "$npmandgulp" == y ] ; then
	# add a simple yes/no confirmation before we proceed
	echo "${yellow}What is the url path of your install?${clear}"
	echo "${yellow}Example: 127.0.0.1/my_path/jump_start/ would mean you enter my_path/jumpstart${clear}"
	read -e urlpath
	echo ""
fi

# add a simple yes/no confirmation before we proceed
echo "${yellow}Run Install? (y/n)${clear}"
read -e run
echo ""

# if the user didn't say no, then go ahead an install
if [ "$run" == n ] ; then
	exit
fi

clear
echo ""

# download the WordPress core files
wp core download

# create the wp-config file with our standard setup
wp core config --dbname=$dbname --dbuser=$dbuser --dbpass=mysql --extra-php <<PHP
define( 'WP_DEBUG', true );
define( 'DISALLOW_FILE_EDIT', true );
PHP

# parse the current directory name
currentdirectory=${PWD##*/}

# generate random 12 character password
password=$(LC_CTYPE=C tr -dc A-Za-z0-9_\!\@\#\$\%\^\&\*\(\)-+= < /dev/urandom | head -c 12)

# copy password to clipboard
echo $password | pbcopy

# parse the current directory name
currentdirectory=${PWD##*/}

# create database, and install WordPress
wp db create
wp core install --url="http://localhost/$currentdirectory" --title="$sitename" --admin_user="$wpuser" --admin_password="$pass" --admin_email="$admin_email"

# discourage search engines
wp option update blog_public 0

# delete sample page, and create homepage
wp post delete $(wp post list --post_type=page --posts_per_page=1 --post_status=publish --pagename="sample-page" --field=ID --format=ids)
wp post create --post_type=page --post_title=Home --post_status=publish --post_author=$(wp user get $wpuser --field=ID --format=ids)

# set homepage as front page
wp option update show_on_front 'page'

# set homepage to be the new page
wp option update page_on_front $(wp post list --post_type=page --post_status=publish --posts_per_page=1 --pagename=home --field=ID --format=ids)

# create all of the pages
export IFS=","
for page in $allpages; do
	wp post create --post_type=page --post_status=publish --post_author=$(wp user get $wpuser --field=ID --format=ids) --post_title="$(echo $page | sed -e 's/^ *//' -e 's/ *$//')"
done

# Delete sample post
wp post delete 1 --force

# set pretty urls
wp rewrite structure '/%postname%/'
wp rewrite flush

# delete hello dolly
wp plugin delete hello

# Install jetpack
wp plugin install jetpack

# Install jumpstart theme from a remote zip file
wp theme install https://github.com/elimc/jumpstart/archive/master.zip --activate

# create a navigation bar
wp menu create "Main Navigation"

# add pages to navigation
export IFS=" "
for pageid in $(wp post list --order="ASC" --orderby="date" --post_type=page --post_status=publish --posts_per_page=-1 --field=ID --format=ids); do
	wp menu item add-post main-navigation $pageid
done

# Install gulp.js dependencies and starg the gulp server.
if [ "$npmandgulp" == y ] ; then

	# Change to the theme that contains gulpfile.js
	cd wp-content/themes/jumpstart-master
	echo ""	
	echo "${yellow}Changing directories to:${clear}"
	PWD
	echo ""

	# Install npm dependencies.
	npm install
	echo ""
	echo "${yellow}Finished npm install :)${clear}"

	# Set up path for Browsersync.
	sed -i ".bak" "s#jump_start#$urlpath#" gulpfile.js;
	echo "${yellow}Changing URL path to 127.0.0.1/${urlpath} ${clear}"
	echo ""
	echo "${green}"
	echo "================================================================="
	echo ""
	echo "Installation is complete. :)"
	echo ""
	echo "Username: $wpuser"
	echo "Password: $pass"
	echo ""
	echo "================================================================="
	echo ""

	# Start the gulp server. Loads site in browser.
	echo "${yellow}Starting the gulp server.${clear}"
	echo "${clear}"
	gulp
else
	clear

	echo "${green}"
	echo "================================================================="
	echo ""
	echo "Installation is complete. :)"
	echo ""
	echo "Username: $wpuser"
	echo "Password: $pass"
	echo ""
	echo "================================================================="
	echo "${clear}"
fi