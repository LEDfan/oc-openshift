#!/bin/bash
deploy=false 
apps=()
echo "Generating ownCloud Devel"
echo "====================================="

echo "Cleaning deploy directory"
rm -rf ./deploy

while getopts ":o::a:" opt; do
	case $opt in
	    	o)
	    		echo "[INSTALL] Cloning OpenShift App Repo: $OPTARG"
			git clone $OPTARG ./deploy
			;;
		a)
			echo "installing apps: $OPTARG"
			apps+=($OPTARG)
			;;	
	esac
done

echo "[INSTALL] Remove contents in deploy dir"
rm -rf ./deploy/*

echo "[INSTALL] Downloading ownCloud Core"
wget https://github.com/owncloud/core/archive/master.zip
unzip master.zip -d ./deploy
rm -rf master.zip
mv ./deploy/core-master/* ./deploy
rm -rf ./deploy/core-master

echo "[INSTALL] Downloading 3rpdarty"
rm -rf ./deploy/3rdparty
git clone https://github.com/owncloud/3rdparty ./deploy/3rdparty
rm -rf ./deploy/3rdparty/.git

echo "[INSTALL] Done!"

echo "[APPS] Installing apps: ${apps[@]}"

mkdir -p ./deploy/apps #remove me

cd ./deploy/apps
for app in "${apps[@]}"
do
	echo "[APP] Installing $app"
	git clone https://github.com/owncloud/$app
	rm -rf $app/.git
done

echo "Deploying on OpenShift"
echo "====================================="
cd ../
git add . -A
git commit -m "Deploy"
git push
