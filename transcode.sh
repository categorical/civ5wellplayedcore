#!/bin/bash

TARGET=`dirname $0`/CvGameCoreSource/CvGameCoreDLL_Expansion2
[ -d "$TARGET" ]||exit 1

TEMPFILE=$(mktemp)
trap '[ -f "$TEMPFILE" ] && (set -x;rm "$TEMPFILE")' EXIT

fs=($(find "$TARGET" -type f))
for f in "${fs[@]}";do
    [ -f "$f" ]||continue
    [[ $f =~ ^.+(\.cpp|\.h)$ ]]||continue
    encoding="$(file -i "$f")";encoding="${encoding##*=}"
    [ "$encoding" == "iso-8859-1" ]||continue 
    
    echo "$f" \
        && iconv -f "$encoding" -t "utf8" "$f" >"$TEMPFILE" \
        && cp "$TEMPFILE" "$f"

done


