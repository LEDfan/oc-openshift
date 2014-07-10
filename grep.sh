function getGitUrl(){
	# $1 is the name of the application
	rm -rf output
	rhc show-app $1 >> output
	line=$(grep '\<s.*t\>' output)
	rm -rf output
	url=${line:12}
	echo $url;
}

gitUrl=$(getGitUrl chat)
echo $gitUrl

