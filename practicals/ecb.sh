#!/bin/bash

PROJECT_DOC=$1
PROJECT_USER=student
PROJECT_PATH=/home/$PROJECT_USER/
PROJECT_NAME=ecb
PROJECT_REPO=gitlab@git.cs.york.ac.uk:cyber-practicals/practical-ecb-python.git

echo "Downloading Python code..."
cd $PROJECT_PATH
git clone $PROJECT_REPO $PROJECT_NAME

echo "Installing PIP modules..."
cd $PROJECT_NAME/
pip3 install -r requirements.txt --upgrade

echo "Setting permissions..."
chown -R $PROJECT_USER $PROJECT_PATH$PROJECT_NAME

echo "Generating documentation..."
cd $PROJECT_PATH$PROJECT_NAME/
make html
mv _build/html $PROJECT_DOC

echo "Done -- Code Installed in...........: $PROJECT_PATH$PROJECT_NAME"
echo "        Documentation installed in..: $PROJECT_DOC"
