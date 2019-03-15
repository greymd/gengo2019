# gengo2019

### Background

常用漢字の組み合わせ全部列挙してつぶやいて、新元号公開されたあと、正解以外のツイート全部消せば予知能力者じゃんｗｗｗ俺天才ｗｗｗｗ

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

### 8. ランダム化する

```
gshuf filtered4 | nl -nln > shuf_filtered4
```

### 9. スクリプトを実行する

[tweet.sh](https://github.com/piroor/tweet.sh) を利用したスクリプトである gengo2019.sh を用意。

### 10. 実行

```
$ nohup bash ./gengo2019.sh &
```

### 11. API 制限常にギリギリなのでツイ禁状態

### 結果: 耐えられず終わり

```

                              糸冬
                      --------------------
                        制作・著作 ＮＨＫ

```
From [owari](https://github.com/xztaityozx/owari)
