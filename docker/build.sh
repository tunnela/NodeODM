read -p "Give version number for the new docker image: " version

if [ "$version" = "" ]
then
    echo "Please give a version number!"
    exit
fi

cd ..

docker build -f ./Dockerfile -t tunnela/nodeodm:$version -t tunnela/nodeodm:latest .

cd ./docker

read -p "Would you like to publish the new docker image? [y|n]: " publish

if [[ "$publish" != "y" && "$matches" != "yes" ]]
then
    exit
fi

docker login
docker push tunnela/nodeodm:$version
docker push tunnela/nodeodm:latest