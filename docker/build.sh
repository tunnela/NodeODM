read -p "Give version number for the new docker image release: " version

if [ "$version" = "" ]
then
	echo "Please give a version number!"
	exit
fi

docker login

cd ..

docker build -f ./Dockerfile -t tunnela/nodeodm:$version -t tunnela/nodeodm:latest .

cd ./docker

docker push tunnela/nodeodm:$version
docker push tunnela/nodeodm:latest