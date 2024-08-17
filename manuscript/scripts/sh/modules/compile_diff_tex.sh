#!/bin/bash

echo -e "$0 ..."

function compile_diff_tex() {
    output_diff_tex=./main/diff.tex

    if [ -s $output_diff_tex ]; then
        echo -e "\nCompiling $output_diff_tex..."
        yes '' | pdflatex -shell-escape $output_diff_tex >/dev/null
        bibtex ${output_diff_tex%.tex} >/dev/null 2>&1
        yes '' | pdflatex -shell-escape $output_diff_tex >/dev/null
        yes '' | pdflatex -shell-escape $output_diff_tex >/dev/null

        if [ -f ./diff.pdf ]; then
            echo -e "\n\033[1;33mCompiled: $output_diff_tex\033[0m"
        fi
    else
        echo -e "\n$output_diff_tex is empty. Skip compiling $output_diff_tex"
    fi
}

compile_diff_tex

## EOF
