#!/bin/sh
prefix=testpostgres_

for dir in *
do
    if [ ! -d $dir ]
    then
       continue
    fi
    cd $dir
    docker build -t ${prefix}${dir} .
    cd ..
done

