#!/bin/bash

echo -e "$0 ..."

function check_commands() {
    echo -e "\nChecking necessary commands..."
    for COMMAND in "$@"; do
        if ! command -v $COMMAND &> /dev/null; then
            echo "${COMMAND} could not be found. Please install the necessary package. (e.g., sudo apt-get install ${COMMAND} -y)"
            exit 1
        fi
    done
    echo -e "\nOK."
}

check_commands pdflatex bibtex xlsx2csv csv2latex
chktex -v0 ./main/main.tex > ./.logs/syntax_warnings.log 2>&1

## EOF
