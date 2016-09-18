#!/bin/bash

sed -n '/^---/q;p' \
| sed 's/^\(\w\{1,\}:\)/\x1e\1/' \
| awk ' 
    # strip undesired white spaces
    function tighten(str)
    {
        # remove undesired whitespaces
        str = gensub(/^(\n|[[:blank:]])+/,  "", "g", str) 
        str = gensub(/(\n|[[:blank:]])+$/,  "", "g", str) 
        str = gensub(/(\n|[[:blank:]])+/ , " ", "g", str) 

        # mask single-quote
        str = gensub(/'\''/, "`", "g", str) 

        return str
    }

    BEGIN {
        RS="\x1e"
        FS=":[[:blank:]|\n]"
    }

    /^$/ {next}

    // {
        meta[tolower($1)] = $2
    }

    END {
        for (key in meta) {
            value = tighten(meta[key])
            print "export " key "='\''" value "'\''"
        }
    }'
