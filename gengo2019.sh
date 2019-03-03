#!/bin/bash
## nohup bash gengo2019.sh >> $HOME/gengo2019.log &

# run script like
readonly THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-${(%):-%N}}")" && pwd)"
_post=
_res=
while read -r id gengo; do
  echo "[$id] $gengo is start" >&2
  ## Post command
  _post="@tos 次の元号は $gengo （ネタバレ）"
  _res=$(t update "${_post}")
  tweet_id=$(echo "${_res}" | tail -n 1 | tr -d '`' | awk '{print $5}')
  if ! [[ "$tweet_id" =~ ^[0-9]*$  ]];then
    echo "[$id] $gengo is skipped"
  else
    echo "[$id] $gengo is posted"
    echo "[$id] tweet_id $tweet_id"
  fi
  sleep 3
done < "${THIS_DIR}"/shuf_filtered4
