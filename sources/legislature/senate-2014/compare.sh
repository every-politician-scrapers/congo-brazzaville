#!/bin/bash

cd $(dirname $0)

# scraped.csv manually created from source

# This was the final "refresh half the senate every 3 years" election, so these
# ones only served a half term before a full refresh in the 2017 election.

wd sparql -f csv wikidata.js | sed -e 's/T00:00:00Z//g' -e 's#http://www.wikidata.org/entity/##g' | qsv dedup -s psid | qsv sort -s itemLabel,startDate > wikidata.csv
bundle exec ruby diff.rb | qsv sort -s itemlabel | tee diff.csv

cd ~-
