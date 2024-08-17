#!/bin/bash

echo -e "$0 ..."

function compile_diff_tex() {
    input_diff_tex=./main/diff.tex
    output_diff_pdf=./main/diff.pdf

    if [ -s $input_diff_tex ]; then
        echo -e "\nCompiling $input_diff_tex..."

        # ./scripts/sh/modules/my-pdflatex.sh $input_diff_tex
        pdflatex -interaction=nonstopmode $input_diff_tex 2>&1 >/dev/null
        # yes '' | pdflatex -shell-escape $input_diff_tex 2&1> /dev/null
        # mv diff.aux main
        bibtex diff 2>&1 > /dev/null
        # bibtex ${input_diff_tex%.tex} 2&1> /dev/null
        yes '' | pdflatex -shell-escape $input_diff_tex 2>&1 > /dev/null
        yes '' | pdflatex -shell-escape $input_diff_tex 2>&1 > /dev/null

        mv ./diff.pdf ./main/diff.pdf -f

        if [ -f $output_diff_pdf ]; then
            echo -e "\n\033[1;33mCompiled: $output_diff_pdf\033[0m"
        fi
    else
        echo -e "\n$input_diff_tex is empty. Skip compiling $input_diff_tex"
    fi
}

compile_diff_tex

## EOF
