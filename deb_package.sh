#!/bin/bash

DISTRO="unstable" # TODO lister les valeurs possibles (debian ? ubuntu ?
# elementary ? mint ?) il est probable qu'on s'en tape, car si ce script est
# fait pour un usage local, les vraies distros changent ça comme des grandes.
PACKAGE_NAME="drawing" # XXX et pour elementary ? osef je pense, flemme.
VERSION="0.5"

echo "targeted distribution: $DISTRO"
echo "package name: $PACKAGE_NAME"
echo "package version: $VERSION"
echo ""
echo "Is it correct? [Return/^C]"
read confirmation

# remember current directory (theorically, the project's root) to bring the
# package here in the end
previous_dir=`pwd`

# mettre en place la structure à la con voulue par les scripts de debian
DIR_NAME=$PACKAGE_NAME'-'$VERSION
FILE_NAME=$PACKAGE_NAME'_'$VERSION
DIR_PATH=/tmp/building-dir
mkdir -p $DIR_PATH/$DIR_NAME/
cp -r build-aux $DIR_PATH/$DIR_NAME/
cp -r data $DIR_PATH/$DIR_NAME/
cp -r debian $DIR_PATH/$DIR_NAME/
cp -r help $DIR_PATH/$DIR_NAME/
cp -r po $DIR_PATH/$DIR_NAME/
cp -r src $DIR_PATH/$DIR_NAME/
cp meson.build $DIR_PATH/$DIR_NAME/
cd $DIR_PATH/
tar -Jcvf $FILE_NAME.orig.tar.xz $DIR_NAME
cd $DIR_PATH/$DIR_NAME/

# création automatique des fichiers supplémentaires pour la construction
dh_make -i -y

# actually building the package
dpkg-buildpackage -i -us -uc -b

# get the package in /tmp and move it where the user is
cp $DIR_PATH/*.deb $previous_dir

# cleaning
ls $DIR_PATH
ls $DIR_PATH/$DIR_NAME
rm -r $DIR_PATH
cd $previous_dir

