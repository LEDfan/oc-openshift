#!/bin/bash
deploy=false 
apps=()
echo "Generating ownCloud Devel"
echo "====================================="

echo "Cleaning deploy directory"
rm -rf ./deploy

while getopts ":n::o::a:" opt; do
	case $opt in
		n)
			echo "[INSTALL] Creating OpenShift app with name: $OPTARG"
			rhc create-app $OPTARG php-5.4 mysql-5.5
			gitUrl=$(getGitUrl $OPTARG)
			echo $gitUrl
			exit 1
			git clone $gitUrl deploy
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
#wget https://github.com/owncloud/core/archive/master.zip
#unzip master.zip -d ./deploy
#rm -rf master.zip
git clone https://github.com/LEDfan/core master
cd ./master
git submodule update --init
rm -rf 3rdparty/.git
cd ../
cp -r ./master/.git
mv ./master/* ./deploy



echo "[INSTALL] Done!"

echo "[APPS] Installing apps: ${apps[@]}"

#mkdir -p ./deploy/apps #remove me

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

##FUNCTIONS
function getGitUrl(){
	# $1 is the name of the application
	rm -rf output
	rhc show-app $1 >> output
	line=$(grep '\<s.*t\>' output)
	rm -rf output
	url=${line:12}
	echo $url;
}