# bash_scripts
### grep -A -B 옵션
```bash
# grep 대상 문자열이 포함된 열을 포함해서 위 아래로 내용을 함께 출력.
# -An : 대상 열 포함 다음 n열 까지 출력
# -Bn : 대상 열 포함 이전 n열 까지 출력
cat *.log | grep -A10 -B10 "test grep"
```
