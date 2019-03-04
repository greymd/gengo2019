#!/bin/bash

## Post tweets
## $ nohup bash gengo2019.sh >> $HOME/gengo2019.log &

## Delete tweets
## $ cat gengo2019.log  | grep tweet_id | awk '{print "t delete status -f "$NF"; sleep 1"}'  | bash

ZWS1=$'\u200b'
ZWS2=$'\u200c'
ZWS3=$'\u200d'
# ZWS4=$'\ufeff'

readonly THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-${(%):-%N}}")" && pwd)"
_post=
_res=
while read -r id gengo; do
  echo "[$id] $gengo is start" >&2
  ## Post command
  _post="@tos 新${ZWS1}し${ZWS2}い${ZWS3}元${ZWS1}号${ZWS2}は${ZWS3}「$gengo」${ZWS1}か${ZWS2}・${ZWS3}・${ZWS1}・${ZWS2}（${ZWS3}ネ${ZWS1}タ${ZWS2}バ${ZWS3}レ${ZWS1}）"
  _status="$?"
  _res=$(tweet.sh post "${_post}")
  tweet_id=$(echo "${_res}" | jq .id)
  if [[ ${_status} -ne 0 ]] || ! [[ "$tweet_id" =~ ^[0-9]*$  ]];then
    echo "[$id][$gengo] is skipped"
  else
    echo "[$id][$gengo] is posted"
    echo "[$id][$gengo] tweet_id $tweet_id"
  fi
  sleep 3
done < "${THIS_DIR}"/shuf_filtered4
