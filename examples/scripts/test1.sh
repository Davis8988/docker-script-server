#!/bin/ash
echo $1
echo $2

echo PWD=$(pwd)

echo mkdir results
mkdir results
echo cd results
cd results
echo pwd
pwd
echo ls -l
ls -l
echo echo "Hello World" > hello.txt
echo "Hello World" > hello.txt

touch david.txt
echo $(date) > david.txt
echo cat david.txt
cat david.txt

echo Done