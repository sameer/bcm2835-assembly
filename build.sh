#!/bin/bash
SRC='src'
BIN='bin'

if [ ! -d "$SRC" ]; then
	echo "Directory $SRC does not exist!";
	exit 0;
fi
if [ ! -d "$BIN" ]; then
	mkdir "$BIN"; 
fi

SRC_FILES="`cd $SRC; find * -type f; cd $OLDPWD`"
SRC_DIRS="`cd $SRC; find * -type d; cd $OLDPWD`"

BIN_SRC_FILES=""
# Build new src folder
if [ -d "$BIN/tmp/src/" ]; then
	TMP_SRC_FILES="`cd $BIN/tmp/src/; find * -type f; cd $OLDPWD`"
	for i in $TMP_SRC_FILES; do
		if [ -f "$SRC/$i" ]; then
			if cmp -s "$SRC/$i" "$BIN/tmp/src/$i"; then
				echo "$i is cached";
			else
				BIN_SRC_FILES="$BIN_SRC_FILES
$i";
			fi;
		else
			rm "$BIN/tmp/src/$i";
		fi;
	done;

	for i in $SRC_FILES; do
		if [ ! -f "$BIN/tmp/src/$i" ]; then
			BIN_SRC_FILES="$BIN_SRC_FILES
$i";
		fi;
	done;
else
	BIN_SRC_FILES="$SRC_FILES"
	mkdir -p "$BIN/tmp/src/";
fi

if [ ! -d "$BIN/obj" ]; then
	mkdir "$BIN/obj";
fi

SRC_DIRS=".
$SRC_DIRS";

for i in $SRC_DIRS; do
	if [ ! -d "$BIN/obj/$i" ]; then
		mkdir -p "$BIN/obj/$i";
	fi;
	if [ ! -d "$BIN/exec/$i" ]; then
		mkdir -p "$BIN/exec/$i";
	fi;
done;

for i in $BIN_SRC_FILES; do
	name=`echo $i | rev | cut -d '/' -f 1 | rev | cut -d '.' -f 1`

	echo "Assembling $name...";
	as -o "$BIN/obj/$i.o" "$SRC/$i";
        if [ ! -f "$BIN/obj/$i.o" ]; then
                continue;
        fi

	echo "Linking $name...";
	gcc -o "$BIN/exec/$i" "$BIN/obj/$i.o";
	if [ ! -f "$BIN/exec/$i" ]; then
		continue;
	fi

	echo "Caching $name...";
	cp "$SRC/$i" "$BIN/tmp/src/$i";
done;
echo 'Done!';
