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
git clone https://github.com/owncloud/core master
cd ./master
git submodule update --init
rm -rf 3rdparty/.git
cd ../
cp -r ./master/.git
mv ./master/* ./deploy

echo "[INSTALL] Done!"

echo "[APPS] Installing apps: ${apps[@]}"


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
git add --all
git commit -m "Deploy"
git push origin master

