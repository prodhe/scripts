#!/bin/sh

# -a		archive
# -h		hardlinks
# -z		compression
# --delete	delete file from target dir if not present in source dir
# --exclude	exclude mac specific file
# [source]	source directories
# [target]	target directory

rsync -avhz --delete --exclude '.DS_Store' \
/Users/petter/Code \
/Users/petter/Sites \
/Users/petter/Cloud/bkp/
