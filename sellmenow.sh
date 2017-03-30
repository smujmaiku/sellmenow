#!/bin/bash

if [ ! -f dictionary.txt ]
then
	echo 'Updating dictionary ...'
	curl -sq 'https://raw.githubusercontent.com/dwyl/english-words/master/words2.txt' > dictionary.txt
fi

words="$(cat dictionary.txt | awk 'length($0)>3' | shuf -n 3 | xargs)"
domain="$(echo ${words} | sed 's/ //g')"
tld="$(printf 'com\nnet\norg\nedu\ngov' | shuf -n 1)"
echo "Selling: ${domain}.${tld}"

data="$(head -c $(shuf -i 2000-8000 -n 1) /dev/urandom | base64)"
res=$(curl -sq --data "${data}" "http://${domain}.${tld}")

if [ -z "$res" ]
then
	echo "Lets try a search '${words}' instead"
	curl -sq "http://www.google.com/#q=${words}" > /dev/null 2>&1
fi

echo "Done, sell that ISP!"
