# bash_scripts
### grep -A -B 옵션
```bash
# grep 대상 문자열이 포함된 열을 포함해서 위 아래로 내용을 함께 출력.
# -An : 대상 열 포함 다음 n열 까지 출력
# -Bn : 대상 열 포함 이전 n열 까지 출력
cat *.log | grep -A10 -B10 "test grep"
```

### 문자열 자르기
```bash
# 문자열 데이터에서 원하는 부분만 자르기
# ${'대상문자열데이터':시작INDEX:자를개수}
STR="service.20220427.log"
DATE=${STR:8:8}

echo $DATE
# -> 20220427
```

### 반복문
```bash
# find의 결과물을 반복
for file in $(find . -name "*.log")
do
	echo $file
done

# 명령어의 결과물을 배열에 담고 배열을 순환하기
req_times=(`cat $file | grep -A9 -B1 "safenumber" | grep -A1 -B9 "internal exception" | grep "REQUEST TIME" | awk -F' ' '{ print $5 }'`)
elapsed=(`cat $file | grep -A9 -B1 "safenumber" | grep -A1 -B9 "internal exception" | grep "ELAPSED" | awk -F' ' '{ print $4 }'`)

for ((  i = 0 ; i < ${#req_times[@]} ; i++ )) ; do
    echo ${req_times[$i]} ${elapsed[$i]}ms >> safenumber_error_list.txt
done
```

### 찾기
```bash
# 디렉토리에서 특정 문자열을 포함하는 파일을 찾고, 해당 부분을 출력
find commonStore/statLog/2022* -type f -print | xargs grep "APICODE_007"

```
