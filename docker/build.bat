@echo off
setlocal enableDelayedExpansion

if not exist build.bat (
    call npx echo-cli "\n\nPlease run the \`build.bat\` command inside the \`docker\` folder!\n\n"
    exit /B
)

where docker >nul 2>nul
if not %ERRORLEVEL% equ 0 (
    call npx echo-cli "\n\nPlease install docker!\n\n"
    exit /B
)

set pass=true

where npm >nul 2>nul
if not %ERRORLEVEL% equ 0 (
    call npx echo-cli "\n\nPlease install \`npm\` command line tool before running this script!\n\n"
    set pass=false
)

docker info >nul 2>nul
if not %ERRORLEVEL% equ 0 (
    call npx echo-cli "\n\nPlease start the docker engine!\n\n"
    set pass=false
)

if %pass% equ false (
    exit /B
)

set /P version="Give version number for the new docker image release or press ENTER to create a local test image: "

if not defined version (
    set version=local
)

cd ..

call docker build -f ./Dockerfile -t tunnela/nodeodm:!version! .

if !version! equ local (
    call npm install --production
)

cd ./docker

if !version! equ local (
    exit
)

set /P publish="Would you like to publish the new docker image? [y|n]: "

if not !publish! equ yes if not !publish! equ y (
    exit
)

call docker login
call docker tag tunnela/nodeodm:!version! tunnela/nodeodm:latest
call docker push tunnela/nodeodm:!version!
call docker push tunnela/nodeodm:latest
