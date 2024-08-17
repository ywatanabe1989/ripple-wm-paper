#!/bin/bash

echo -e "$0 ..."

function compile_main_tex() {
    echo -e "\nCompiling ./main/main.tex..."

    # compile tables and figures
    ./scripts/sh/modules/tables.sh
    ./scripts/sh/modules/figures.sh $no_figs

    # Main
    yes '' | pdflatex -shell-escape ./main/main.tex >/dev/null # this wil problematic sometimes
    bibtex main 2>&1 >/dev/null | grep -E "Warning|Error"
    yes '' | pdflatex -shell-escape ./main/main.tex >/dev/null
    yes '' | pdflatex -shell-escape ./main/main.tex >/dev/null

    # Rename
    cp ./main/main.pdf ./main/manuscript.pdf
}

no_figs=${1:-default_value}
compile_main_tex

# ./scripts/sh/modules/compile_main.tex.sh --no-figs

## EOF
