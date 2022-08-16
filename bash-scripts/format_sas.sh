#!/bin/bash

F="./*.json"
for file in $F
do
N="${file%.*}.json"
xmllint ${file} --format -o ${N}
done