#!/bin/bash

rm -rf ./result.txt

TOTAL_COUNT=`cat test.txt | wc -l`
COUNT=1

cat test.txt | while read line
do
	API=`curl -s \
    		--data-urlencode "resultType=json" \
    		--data-urlencode "currentPage=1" \
    		--data-urlencode "countPerPage=1" \
    		--data-urlencode "keyword=$line" \
    		--data-urlencode "confmKey=U01TX0FVVEgyMDIwMDYwNDExMzEwOTEwOTgyODk=" \
	    	http://www.juso.go.kr/addrlink/addrLinkApi.do`
	echo $API | jq -r '.results.juso[0].jibunAddr' >> result.txt

	echo $COUNT / $TOTAL_COUNT
	COUNT=$((COUNT+1))
done
