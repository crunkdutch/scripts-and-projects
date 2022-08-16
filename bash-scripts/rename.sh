#!/bin/sh

f="./*.jpg"
count=1
for fname in $f
do
    mv $fname image_${count}.jpg
    count=$(($count + 1))
done