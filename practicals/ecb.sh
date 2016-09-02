#!/bin/bash

PROJECT_DOC=$1
SEP=$2
PROJECT_USER=student
PROJECT_PATH=/home/$PROJECT_USER/
PROJECT_NAME=ecb
PROJECT_REPO=gitlab@git.cs.york.ac.uk:cyber-practicals/practical-ecb-python.git
DOCS_REPO=gitlab@git.cs.york.ac.uk:cyber-practicals/practical-ecb.git

echo "Downloading Python code..."
cd $PROJECT_PATH
rm -rf $PROJECT_NAME
git clone $PROJECT_REPO $PROJECT_NAME

echo "Installing PIP modules..."
cd $PROJECT_NAME/
pip3 install -r requirements.txt --upgrade

echo "Setting permissions..."
chown -R $PROJECT_USER $PROJECT_PATH$PROJECT_NAME

echo "Generating documentation..."
TMPDIR=`mktemp -d`
git clone $DOCS_REPO $TMPDIR
cd $TMPDIR/
make html
mv _build/html $PROJECT_DOC
rm -rf $TMPDIR

echo "$2Done -- Code Installed in...........: $PROJECT_PATH$PROJECT_NAME"
echo "$2        Documentation installed in..: $PROJECT_DOC"
