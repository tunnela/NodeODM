@echo off
setlocal enableDelayedExpansion

set /P version="Give version number for the new docker image release: "

if not defined version (
    call npx echo-cli "Please give a version number."
    exit
)

cd ..

call docker build -f ./Dockerfile -t tunnela/nodeodm:!version! .

cd ./docker

set /P publish="Would you like to publish the new docker image? [y|n]: "

if not !publish! equ yes if not !publish! equ y (
    exit
)

call docker login
call docker tag tunnela/nodeodm:!version! tunnela/nodeodm:latest
call docker push tunnela/nodeodm:!version!
call docker push tunnela/nodeodm:latest
