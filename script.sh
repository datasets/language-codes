#! /bin/bash

mkdir -p data
echo '"alpha3-b","alpha3-t","alpha2","English","French"' > data/language-codes-full.csv
echo '"alpha2","english"' > data/language-codes.csv
curl http://www.loc.gov/standards/iso639-2/ISO-639-2_utf-8.txt > tmp.csv 

cat tmp.csv | sed 's/|/","/g' | awk '{print "\"" $0"\""}' >> data/language-codes-full.csv
cat tmp.csv | cut -d'|' -f3,4 | awk -F'|' '$1{print "\"" $0"\""}' | sed 's/|/","/g' | sort  >> data/language-codes.csv

rm tmp.csv


