#!/bin/sh
if [ "$1" == "--help" ]; then
    echo "Usage: $0 [--prefix=]"
    echo " "
	echo "--prefix=	Prefix for (un)install. Defaults to /usr/local/bin"
	exit 0
elif [ "`echo $1 | cut -d = -f 1`" == "--prefix" ]; then
	prefix=`echo $1 | cut -d = -f 2-`
else
	prefix=/usr/local
fi

if [ ! -w "$prefix" ]; then
	dirpref=${prefix//\// }
	for dir in $dirpref; do
		lastdir=$fulldir
		fulldir=${fulldir}/$dir
		[ -d "$fulldir" ] || break
	done
	if [ -d "$prefix" ] && [ ! -w "$prefix" ]; then
		echo "$prefix isn't writable."
		echo "Maybe try switching to root?"
		exit 1
	elif [ -w "$lastdir" ]; then
		mkdir -p $prefix
	else
		echo "$prefix doesn't exist."
		echo "$lastdir isn't writable."
		echo "Maybe try switching to root?"
		exit 1
	fi
fi

script=`basename $0`
if [ "$script" == "install.sh" ]; then
	echo -n "Looking for perl... "
	perl=`which perl`
	if [ -x "$perl" ]; then
		echo "found."
		$perl config.perl || exit 1
	else
		echo "failed."
		echo "Perl not found in $PATH"
		exit 1
	fi

	echo "Installing."
	mkdir -p $prefix/
	cp -Rvfp src/* $prefix/ || exit 1
	echo "Done."
	echo "Now you can run gtkchat by typing 'gtkchat'."
	exit 0
elif [ "$script" == "uninstall.sh" ]; then
	echo "Checking if that is correct prefix."
	if [ -e "$prefix/bin/gtkchat" ]; then
		UNINST=1
	else
		echo -n "Can't find '$prefix/bin/gtkchat'. "
		echo -n "Do you still want to uninstall? [y/N] "
		read choice
		[ "$choice" == "y" ] || [ "$choice" == "Y" ] && UNINST=1 || exit 1
	fi
	if [ "$UNINST" == "1" ]; then
		echo "Uninstalling."
		rm -fv $prefix/bin/gtkchat
		rm -rfv $prefix/share/gtkchat
		echo "Done."
		exit 0
	fi
else
	echo "Unknown script, sorry."
	exit 1
fi
