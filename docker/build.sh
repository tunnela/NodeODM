#!/bin/bash
set -e

if [[ ! -f "build.sh" ]]
then
    echo "\n\nPlease run the \`sh build.sh\` command inside the \`docker\` folder!\n\n"
    exit
fi

pass=true

if ! command -v npm &> /dev/null
then
    echo "\n\nPlease install \`npm\` command line tool before running this script!\n\n"
    pass=false
fi

if ! docker info > /dev/null 2>&1
then
    echo "\n\nPlease start the docker engine!\n\n"
    pass=false
fi

if [ "$pass" = false ]
then
    exit
fi

read -p "Give version number for the new docker image release or press ENTER to create a local test image: " version

if [ "$version" = "" ]
then
    version=local
fi

cd ..

if [ "$version" = "local" ]
then
    npm install --production
    
    docker build --label "nodeodm.path=$(pwd)" -f ./Dockerfile -t tunnela/nodeodm:$version .
else 
    docker build -f ./Dockerfile -t tunnela/nodeodm:$version .
fi

cd ./docker

if [ "$version" = "local" ]
then
    exit
fi

read -p "Would you like to publish the new docker image? [y|n]: " publish

if [[ "$publish" != "y" && "$matches" != "yes" ]]
then
    exit
fi

docker login
docker tag tunnela/nodeodm:$version tunnela/nodeodm:latest
docker push tunnela/nodeodm:$version
docker push tunnela/nodeodm:latest