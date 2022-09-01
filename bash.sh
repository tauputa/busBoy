#!/usr/bin/bash -e

# Variabale definitions
busBoyDir="busboy"                                     # build directory of busboy
Binaries=( "go" "helm" "make" "kubectl" "docker" )     # binaries that need to be installed
busBoyPort="8085"                                      # busboy port
version="v1.0"                                         # docker image version
Dockerfile="Dockerfile"                                # name of docker file to build image from
Files="files"

# Function definitions:
function checkBinaryInPath(){
	# check for binaries like go, helm, make and kubectl are in users PATH
	binaryName=$1
	BINARY_PATH=$(which $binaryName)
	if [ ! -x "$BINARY_PATH" ];then
		echo "Cant find: $binaryName in your PATH exiting"
		exit 1
	fi
}

# loop over binaries and check they exist
for binary in ${Binaries[@]};do
	checkBinaryInPath $binary
done

# check docker daemon is running
ps -ef |grep docker |grep -v grep > /dev/null 2>&1
dockerResult=$?
if [ $dockerResult -ne 0 ];then
	echo "Docker Daemon is not running, exiting"
	exit 1
fi

# check if the docker image already exists
docker images |grep busboy |grep $version |grep -v grep
dockerImageResult=$?

if [ $dockerImageResult -ne 0 ];then
	if [ ! -d "$busBoyDir" ];then
        	echo "Cant find the directory $busBoyDir, exiting"
	        exit 1
	fi

	if [ ! -d "$Files" ];then
        	echo "Cant find the directory $Files, exiting"
	        exit 1
	fi

        if [ ! -f "$Files/index.html" ];then
                echo "Cant find the index file $Files/index.html, exiting"
                exit 1
        fi

	cd $busBoyDir

	echo "Cleaning old builds of busboy"
	make clean
	echo "Building busboy Now"
	make

	cd ..

	if [ ! -f "$busBoyDir/build/busboy" ];then
	        echo "Cant find the $busBoyDir/build/busboy binary, exiting"
        	exit 1
	fi

	if [ -f "$Dockerfile" ];then
  	      echo "Found $Dockerfile, building image now"
        	docker build -t busboy:$version -f Dockerfile .
	else
	        echo "Cant find $Dockerfile exiting"
        	exit 1
	fi
else
        echo "Docker Image busboy:$version already exists skipping build of docker image using verwion $version"
fi

echo "Completed script sucessfully"
