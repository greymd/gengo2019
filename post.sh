#!/bin/bash

_post=
_res=
while read -r id gengo; do
  echo "[$id] $gengo is start" >&2
  ## Post command
  _post="@tos $gengo かぁ（ネタバレ）"
  if ! _res=$(t update "${_post}");then
    echo "[$id] $gengo is skipped" >&2
  else
    echo "[$id] $gengo is finished" >&2
    tweet_id=$(echo "${_res}" | grep screen_id)
    echo "[$id] tweet_id $tweet_id" >&2
  fi
  sleep 3
done < shuf_filtered4
