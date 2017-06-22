#!/bin/sh

set -e

# NBSP breaks scripts and cfengine code, they should never appear

# Build fine arguments
FIND_ARGS="-type f -not -wholename */.git/* -not -wholename */api/flask/* -not -name *.png -not -name *.eot -not -name *.ttf -not -name *.woff -not -name *.otf -not -name *.ico"

# Automatically exclude anything from the .gitignore file
while read line
do
  export FIND_ARGS="${FIND_ARGS} -not -wholename */${line}"
done < ${NCF_TREE}/../.gitignore

ALL_TESTS=`find ${NCF_TREE}/.. ${FIND_ARGS}`

ERRORS=0
for file in ${ALL_TESTS}
do
  # allow nbsp in comments
  if grep -P '^[^#]*\xA0' ${file} > /dev/null; then
    ERRORS=`expr ${ERRORS} + 1`
    echo "Test ${file} has a non breaking space in it"
  fi
done

if [ ${ERRORS} -eq 0 ]; then
  echo "R: $0 Pass"
else
  echo "R: $0 FAIL"
fi
exit ${ERRORS}
