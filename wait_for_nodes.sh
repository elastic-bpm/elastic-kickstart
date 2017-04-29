#!/bin/bash

c="0"
while [ $c -le 15 ]
do
  sleep 10
  c=`docker node ls | grep -c Ready`
done

echo All ready

