# gengo2019

### 1. `moreutils` をインストールする

### 2. 組み合わせを作る

```
cat 常用漢字表.txt | xargs | tr ' ' , | sed 's/^/{/;s/$/}/' | sed 's/.*/\0\0/' | sed 's/^/echo /' | bash | tr ' ' '\n' > comb

$ wc -l comb
 4562496 comb
```

### 3. ネガティブな漢字を除く

From [link](https://detail.chiebukuro.yahoo.co.jp/qa/question_detail/q13108387538)

**ng_kanjis**
```
嘆鈍刑怒砕堕怖愚怠怨崩怪鬱失鬱弱嘲破落屍恐屑荒汚恥恨呪潰罰陰影奴罵酷死災憂沈消禍憎憐暗辛醜負隠劣誤貧悪邪窮悲疲傷隷殺溺憾禿哀濁狂寂駄滅病曇壊淋惑毒忙飢苦惨困惰凶迷
```

```
cat comb | grep -v -f ng_kanjis > filtered
```

### 4. 同じ漢字の連続を除く

```
$ cat filtered | grep -E '(.)\1'
...
靴靴
寡寡
歌歌
箇箇
稼稼
...

$ cat filtered | grep -vE '(.)\1'  | sponge filtered

$ wc -l filtered
 4245660 filtered
```

### 5. 特定の子音を除く

```
明治 -- マミムメモ
大正 -- タチツテト
昭和 -- サシスセソ
平成 -- ハヒフヘホ
```

```
$ cat filtered | mecab | tr '\t' ',' | awk -F, 'NF>1{gen=gen""$1;yomi=yomi""$(NF)};/EOS/{print yomi,gen;gen="";yomi=""}' | grep -vf shiin > filtered2
$ cut -d ' ' -f2 filtered2 | sponge filtered2
```

### 6. 比較的用途が特殊な漢字を除く

```
$ cat special
凹
凸

$ grep -vf special filtered2 | sponge filtered2
```

### 6. すでに存在する一般名詞・固有名詞は除く

```
$ cat filtered2 | mecab | awk '/EOS/{if(count > 1){print gen};gen="";count=0}!/EOS/{gen=gen""$1;count++}' > filtered3
```

### 7. 更に文化的に避けられている用語や、ジェンダーに関連する用語を除く

```
$ cat filtered3 | grep -vf ng_kanjis2 > filtered4
```

### ランダム化する

```
gshuf filtered4 | nl -nln > shuf_filtered4
```

### スクリプト

[t](https://github.com/sferik/t) を利用したスクリプトである gengo2019.sh を用意。

## 25 日間につぶやけるか ?

9000 windows 存在 (1 window = 15 分)

```
$ echo '25*24*15' | bc -l
9000
```

API 制限は [300 per window](https://developer.twitter.com/en/docs/basics/rate-limits.html).

余裕をもって15分に250投稿とする。
3秒に1回は投稿したい。

```
$ wc -l filtered4
 1726465 filtered4

$ echo 1726465/9000 | bc -l
191.82944444444444444444
```

なんとかいける？
