#!/usr/bin/bash
# Author Gaurav
# Universitat Potsdam
# Date 2024-6-6
# https://anaconda.org/
# A way to connect to the conda and search for the terms and get the conda generators.
# a pure implementation of regular expression.
read -r -p "please provide the search term:" term
wget -F "https://anaconda.org/search?q=${term}" -O condasearch.txt 
echo "all term fetched"
cat condasearch.txt | grep ${term} | \
         grep href | cut -f 2 -d "=" \
              | cut -f 1 -d ">" | grep -w ${term} > saveintermediate.txt  
echo "all intermediate generated"              
for i in $(cat saveintermediate.txt); do echo \
        "https@//anaconda.org$i"; done | \
                     sed "s/\"//g" | sed "s/@/:/g" > downloadlinks.txt 
echo "moving into intermediate"                     
mkdir intermediate
cp -r downloadlinks.txt ./intermediate
cd intermediate
cat downloadlinks.txt | while read line; \
          do wget -F ${line}; done
cat * | grep -w install | grep ${term} > newsave.txt
cat newsave.txt | grep code | cut -f 2 -d ">" | cut -f 1 -d "<"
cd ..
rm -rf intermediate
rm -rf saveintermediate.txt finaltext.txt downloadlinks.txt condasearch.txt
