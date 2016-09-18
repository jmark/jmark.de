title: Parsing http header style config files in shell scripts

author: Johannes Markert

published: September 2016

synopsis:
    Sometimes I need a cheap-cheesy-dirty but flexible http header style
    parser. This gem proposes one way.

---

Our test case file looks like this:

    title: Chuck Norris Jokes
    author: Chuck Norris
    published: September, 2016

    keywords:
        jokes, chuck norris, 2016, ...

    ---

    * Chuck Norris can skip the copyright notices on his DVDs.
    * Chuck Norris doesn't dial the wrong number, you pick up the wrong phone.
    * ...

The '\-\-\-' line is just an arbitrary delimiter which devides header from content.

Now comes the sed-awk - kungfu!

    cat test-file \
        | sed -n '/^---/q;p' \                                      # (1)
        | sed 's/^\(\w\{1,\}:\)/\x1e\1/' \                          # (2)
        | awk -v RS='\x1e' -F':[ |\n]' '/^$/{next}; {print $1}'     # (3)

In (1) we clip the header from the rest of the file. Line (2) prepends the
'group separator' control charactor '\x1e' to every keyword of the format
'^\[\[:alpha:\]\]:', which means an 'ordinary word' at the beginning of a line
concluded by a colon. The record control characters serves as the 'record
separator' in line (3). Splitting the record at the 'colon' you have the
keyword in the variable '$1' and the value in '$2'. Nice!

Most possibly you have to strip whitespaces and newlines from the 'values'. Do
it like so within an awk script:

    function stripws(str)
    {
        str = gensub(/^(\n|[[:blank:]])+/,"","g",str)   # strip at the beginning
        str = gensub(/(\n|[[:blank:]])+$/,"","g",str)   # strip at the end
        return str
    }

Finally, a complete script might look like this.

    #!/bin/sh

    sed -n '/^---/q;p' \
    | sed 's/^\(\w\{1,\}:\)/\x1e\1/' \
    | awk '
        function tighten(str)
        { 
            # remove undesired whitespaces
            str = gensub(/^(\n|[[:blank:]])+/,  "" , "g", str) 
            str = gensub(/(\n|[[:blank:]])+$/,  "" , "g", str) 
            str = gensub(/(\n|[[:blank:]])+/ , " " , "g", str) 

            # handle single-quotes
            str = gensub(/'\''/ , "`", "g", str) 

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
