#!/bin/bash

cd $(dirname $0)

bundle exec ruby scraper.rb $(jq -r .source meta.json) | qsv select name,alternate,party,constituency > all-scraped.csv

qsv select name,party,constituency all-scraped.csv     | qsv rename itemLabel,partyLabel,areaLabel | qsv search -s itemLabel . > scraped.csv
qsv select alternate,party,constituency all-scraped.csv| qsv rename itemLabel,partyLabel,areaLabel | qsv search -s itemLabel . > alternates/scraped.csv

wd sparql -f csv wikidata.js | sed -e 's/T00:00:00Z//g' -e 's#http://www.wikidata.org/entity/##g' | qsv dedup -s psid | qsv sort -s itemLabel,startDate > all-wikidata.csv

qsv search Q21295980  all-wikidata.csv > wikidata.csv
qsv search Q112567889 all-wikidata.csv > alternates/wikidata.csv

bundle exec ruby diff.rb | qsv sort -s itemlabel | tee diff.csv

pushd alternates
bundle exec ruby diff.rb | qsv sort -s itemlabel | tee diff.csv
popd

cd ~-
