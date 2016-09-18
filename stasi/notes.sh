#!/bin/bash

HEADER=stasi/templates/default/header.html
FOOTER=stasi/templates/default/footer.html

export title="jmark.de - Notes"

cat <(cat $HEADER | envsubst)

echo "<dl>"
for file in $(find notes -type f -name "*.md" | sort)
do
    eval $(cat $file | ./stasi/extract-meta.sh)
	echo "<dt>/${file%/*}: <a href=\"/${file%.*}.html\">${title}</a></dt>"
	echo "<dd> ${synopsis} </dd>"
    echo "<hr/>"
done
echo "</dl>"

cat <(cat $FOOTER | envsubst)
