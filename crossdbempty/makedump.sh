#!/bin/sh

cd `dirname $0`
fulldirname=`pwd`
dbname=`basename $fulldirname`
echo $dbname

sqlfile=crosstesttemplatedb.sql.gz
sqlbackfile=$sqlfile.bak

mv $sqlfile $sqlbackfile

ssh test-cross3.nikkei-r.local pg_dump -U postgres $dbname | gzip > $sqlfile
