#! /bin/bash

echo '"alpha3 b","alpha3 t","alpha2","english","french"' > language-codes.csv
curl http://www.loc.gov/standards/iso639-2/ISO-639-2_utf-8.txt | sed 's/|/","/g' | awk '{print "\"" $0"\""}' >> language-codes.csv


