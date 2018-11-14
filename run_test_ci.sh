#!/bin/bash

current_time=$(date "+%Y%m%d%H%M%S")
echo "Current Time : $current_time"
output=test_$current_time.log
DIR=found

if ! [ -d $DIR ]; then
   mkdir $DIR
fi

make test-ci -j 8 > $output 2>&1

if grep 'not ok' test.tap | grep -q -e tls -e https; then
  mv $output $DIR
else
  rm $output
fi
