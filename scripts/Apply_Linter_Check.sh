#!/bin/bash
# Script in charge of auditing the released cheatsheets MD files
# with the linter policy defined at project level
cd ..
markdownlint -o linter-result.out cheatsheets
errors=`wc -l linter-result.out | cut -d' ' -f1`
if [[ $errors != "0" ]]
then
    echo "$errors error(s) found:"
    cat linter-result.out
    exit $errors
else
    echo "No error found."
fi