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
```
