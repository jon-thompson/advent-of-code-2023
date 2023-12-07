#!/bin/bash

fswatch -0 . | while read -d "" event
do
  file=$(basename "$event")
  if [[ $file == *.roc ]]; then
    roc test Day07.roc
  fi
done