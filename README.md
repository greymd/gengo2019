# gengo2019

1. clone [rime-aca/character_set](https://github.com/rime-aca/character_set)

2. Create combinations

```sh
cat 常用漢字表.txt | xargs | tr ' ' , | sed 's/^/{/;s/$/}/' | sed 's/.*/\0\0/' | sed 's/^/echo /' | bash | tr ' ' '\n' > list
```

3. Remove negative words

From [link](https://detail.chiebukuro.yahoo.co.jp/qa/question_detail/q13108387538)
And recent previous gengos "明治大正昭和平成"

**ng_kanjis**
```
嘆鈍刑怒砕堕怖愚怠怨崩怪鬱失鬱弱嘲破落屍恐屑荒汚恥恨呪潰罰陰影奴罵酷死災憂沈消禍憎憐暗辛醜負隠劣誤貧悪邪窮悲疲傷隷殺溺憾禿哀濁狂寂駄滅病曇壊淋惑毒忙飢苦惨困惰凶迷明治大正昭和平成
```

```
cat list | grep -v -f ng_kanjis | sponge list
```

4. Remove same word combinations

```
$ cat list | grep -E '(.)\1'
...
靴靴
寡寡
歌歌
箇箇
稼稼
...

$ cat list | grep -vE '(.)\1'  | sponge list
```
