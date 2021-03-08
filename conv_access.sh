#!/bin/bash

DATE="$(date -d yesterday +%Y%m%d)"
#DATE="$(date +%Y%m%d)"
DIR=/home/coolstay/www/marketing
TOTAL_RAWS=$DIR/total_raws.csv

rm -rf $DIR/${DATE}*
rm -rf $DIR/raws/${DATE}*
if [ ! -d $DIR/raws ]; then
        mkdir $DIR/raws
fi

# pv 산출
info_pv=`grep -o 'GET \/textmk\/info?' /logs/coolstay/web/apache/access-log/access.${DATE}.log | wc -l`
app_pv=`grep -o 'GET \/textmk\/app?' /logs/coolstay/web/apache/access-log/access.${DATE}.log | wc -l`
run_pv=`grep -o 'GET \/textmk\/run?' /logs/coolstay/web/apache/access-log/access.${DATE}.log | wc -l`
echo "info : $info_pv" > $DIR/${DATE}_pv.txt
echo "app : $app_pv" >> $DIR/${DATE}_pv.txt
echo "run : $run_pv" >> $DIR/${DATE}_pv.txt

# array contains 함수
function contains() {
    local n=$#
    local value=${!n}
    for ((i=1;i < $#;i++)) {
        if [ "${!i}" == "${value}" ]; then
            echo "y"
            return 0
        fi
    }
    echo "n"
    return 1
}

# uv 산출
function setUv()
{
	echo $2" : "$1 >> $DIR/${DATE}_uv.txt
}

function write_raws()
{
        S=`echo $2 | cut -d'?' -f2 | cut -d'&' -f1 | cut -d'=' -f2`
        C=`echo $2 | cut -d'?' -f2 | cut -d'&' -f2 | cut -d'=' -f2`
	ID=`echo $2 | cut -d'?' -f2 | cut -d'&' -f3 | cut -d'=' -f2`
	T=`echo $2 | cut -d'?' -f2 | cut -d'&' -f4 | cut -d'=' -f2`
	A=`echo $2 | cut -d'?' -f2 | cut -d'&' -f5 | cut -d'=' -f2`

	case $1 in
	"info")
		echo $DATE,$S,$C,$ID,Y,,, >> $TOTAL_RAWS
		;;
	"app")
		echo $DATE,$S,$C,$ID,Y,Y,, >> $TOTAL_RAWS
		;;
	"run")
		echo $DATE,$S,$C,$ID,Y,Y,$A, >> $TOTAL_RAWS
		;;
	esac
}

function parse()
{
	KEYS1=()
	grep "GET \/textmk\/"$1"?" /logs/coolstay/web/apache/access-log/access.${DATE}.log | while read line
	do
        	QUERY_STRING=`echo $line | awk -F' ' '{print $7}'`
        	ID=`echo $QUERY_STRING | cut -d'?' -f2 | cut -d'&' -f3 | cut -d'=' -f2`
        	if [ $(contains "${KEYS1[@]}" $ID) == "n" ]; then
               		KEYS1+=("$ID")
                	echo $QUERY_STRING >> $DIR"/raws/${DATE}_$1_raws.txt"
        	fi
		write_raws $1 $QUERY_STRING
	done
	if [ -f $DIR"/raws/${DATE}_$1_raws.txt" ]; then
      	 	KEYS1=(`cat $DIR"/raws/${DATE}_$1_raws.txt"`)
	fi
}


TOTAL_JSON='{stats:['
DAILY_JSON='{"'$DATE'":{'
make_json()
{
	DAILY_JSON='"'$1'":{"pv":'$2',"uv":'$3'}'
	echo $DAILY_JSON
}


# 마케팅 수신 동의 페이지
parse "info"
setUv ${#KEYS1[@]} "info"
infoObj=$(make_json "info" $info_pv ${#KEYS1[@]})

# 2차 문자 링크 페이지
parse "app"
setUv ${#KEYS1[@]} "app"
appObj=$(make_json "app" $app_pv ${#KEYS1[@]})

# 앱실행
parse "run"
setUv ${#KEYS1[@]} "run"
runObj=$(make_json "run" $run_pv ${#KEYS1[@]}})

DAILY_RESULT=`echo $DAILY_JSON$infoObj,$appObj,$runObj}`

if [ -f $DIR/stats.json ]; then
	STATS=`cat $DIR/stats.json`
	STATS=`echo "${STATS::-2}"`
	TOTAL_JSON=$STATS,$DAILY_RESULT']}'
else
	TOTAL_JSON='{stats:['$DAILY_RESULT']}'
fi

rm -rf $DIR/stats.json
echo $TOTAL_JSON > $DIR/stats.json
