#!/bin/sh

CONTENT="$1"
HEADER="$2"
FOOTER="$3"

eval $(cat $CONTENT | ./stasi/extract-meta.sh)

cat $HEADER | envsubst
sed '1,/^---/d' $CONTENT | kramdown --smart-quotes apos,apos,quot,quot
cat $FOOTER | envsubst
