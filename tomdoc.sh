#!/bin/sh
# Shell script for parsing TomDoc and generating pretty documentation from it
#
# Written by Mathias Lafeldt <mathias.lafeldt@gmail.com>
#

file="$1"

sed -E '/(^#\!)|(^$)/d' "$file" |
(
    func=
    doc=

    while read -r line; do
        case "$line" in
        '# Public: '*)
            doc="$doc$line
"
            ;;
        '#'*)
            test -n "$doc" && doc="$doc$line
"
            ;;
        *'()'*)
            test -n "$doc" && func="$(expr "$line" : '\(.*\)()')"
            ;;
        esac

        test -n "$func" -a -n "$doc" && {
            echo "- $func"
            echo
            echo "$doc" | sed -E 's/^#/ /'
            echo
            func=
            doc=
        }
    done
)
