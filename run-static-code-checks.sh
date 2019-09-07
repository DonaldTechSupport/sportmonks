#!/usr/bin/env bash

set -o nounset      # exit with non-zero status if expansion is attempted on an unset variable
set -o errexit      # exit immediatelly if a pipeline, a list, or a compound command fails
set -o pipefail     # failures in pipe in the commands before last one, also count as failures

# Trapping non-zero exit codes:
on_error() {
    line_num="$1"
    echo "Caught error on line $line_num"
}

on_exit() {
    true
}

on_interrupt() {
    true
}
trap 'on_error $LINENO' ERR
trap on_exit EXIT
trap on_interrupt INT

echo "Run pylava on package code"
find ~/sportmonks/sportmonks/ -name '*.py' | xargs ~/sportmonks/venv/bin/pylava --options ~/sportmonks/setup.cfg --format pep8 --verbose

echo "Run mypy"

for f in ~/sportmonks/sportmonks/*.py; do
    echo Check file "$f"
    mypy --config-file ~/sportmonks/setup.cfg "$f"
done

