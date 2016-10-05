#!/bin/bash

#
# This script converts markdown into html, to be used with vimwiki's
# "customwiki2html" option.
#
# Code from Vimwiki's example file with additions by Prodhe
#

PANDOC=pandoc

FORCE="$1"
SYNTAX="$2"
EXTENSION="$3"
OUTPUTDIR="$4"
INPUT="$5"
CSSFILE="$6"

FORCEFLAG=

[ $FORCE -eq 0 ] || { FORCEFLAG="-f"; };
[ $SYNTAX = "markdown" ] || { echo "Error: Unsupported syntax"; exit -2; };

OUTPUT="$OUTPUTDIR"/$(basename "$INPUT" .$EXTENSION).html

DIRNAME=$(dirname "$INPUT")
ROOT_PATH=./

# find vimwiki root (need file vimwiki/.root)
until [[ -e "$DIRNAME/.root" ]]; do
    DIRNAME=$(dirname "$DIRNAME")
    ROOT_PATH=${ROOT_PATH}../
done

# transform vimwiki-internal links to markdown format
TMP1=/tmp/vw-tmp1
TMP2=/tmp/vw-tmp2
sed -e 's#\[\[\(.*\)|\(.*\)\]\]#[\2](\1.html)#g' "$INPUT" > $TMP1
sed -e 's#\[\[\(.*\)\/\]\]#[\1](\1\/index.html)#g' "$TMP1" > $TMP2
sed -e 's#\[\[\(.*\)\]\]#[\1](\1.html)#g' "$TMP2" > $TMP1
INPUT=$TMP1

# pandoc [-f FORMAT] [-t FORMAT] [-c CSS] [--toc] [--smart] -s -o OUTPUT INPUT
# "-s" for stand-alone and complete HTML document with headers
# "--smart" for correct typography

$PANDOC -f markdown -t html5 -c "${ROOT_PATH}markdown.css" \
    --smart -s -o "$OUTPUT" "$INPUT"

# remove temp files
rm /tmp/vw-tmp1
rm /tmp/vw-tmp2
