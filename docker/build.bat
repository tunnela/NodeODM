@echo off
setlocal enableDelayedExpansion

set /P version="Give version number for the new docker image release: "

if not defined version (
	call npx echo-cli "Please give a version number."
	exit
)

cd ..

call docker build -f ./Dockerfile -t tunnela/nodeodm:!version! -t tunnela/nodeodm:latest .

cd ./docker

call docker push tunnela/nodeodm:!version!
call docker push tunnela/nodeodm:latest
