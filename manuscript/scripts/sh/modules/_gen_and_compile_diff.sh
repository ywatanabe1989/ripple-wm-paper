#!/bin/bash

function gen_diff_tex() {
    base_tex=$(ls -v ./old/compiled_v*base.tex 2>/dev/null | tail -n 1)
    latest_tex=$(ls -v ./old/compiled_v[0-9]*.tex 2>/dev/null | tail -n 1)
    output_diff_tex=./main/diff.tex

    if [[ -n "$base_tex" ]]; then
        base_tex=$base_tex
    else
        base_tex=$latest_tex
    fi

    current_tex="./main/manuscript.tex"

    if [ -n "$base_tex" ] && [ -f "$current_tex" ]; then
        echo -e "\nTaking diff between $base_tex & $current_tex"
        latexdiff "$base_tex" "$current_tex" > $output_diff_tex 2> /dev/null
    fi

    if [ -s $output_diff_tex ]; then
        echo -e "\n$output_diff_tex was created."
    else
        echo -e "\n$output_diff_tex is empty."
    fi
}

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

gen_diff_tex
compile_diff_tex

## EOF

# function gen_and_compile_diff() {
#     base_tex=$(ls -v ./old/compiled_v*base.tex 2>/dev/null | tail -n 1)
#     latest_tex=$(ls -v ./old/compiled_v[0-9]*.tex 2>/dev/null | tail -n 1)
#     output_diff_tex=./main/diff.tex

#     # Check if base_tex file exists and is not empty
#     if [[ -n "$base_tex" ]]; then
#         # echo -e "\nBase .tex file found: $base_tex"
#         base_tex=$base_tex
#     else
#         # echo "\nNo base .tex file found."
#         base_tex=$latest_tex
#     fi

#     current_tex="./main/manuscript.tex"

#     if [ -n "$base_tex" ] && [ -f "$current_tex" ]; then
#         echo -e "\nTaking diff between $base_tex & $current_tex"
#         latexdiff "$base_tex" "$current_tex" > $output_diff_tex 2> /dev/null
#     fi

#     if [ -s $output_diff_tex ]; then
#         echo -e "\n$output_diff_tex was created."
#         echo -e "\nCompiling $output_diff_tex..."
#         yes '' | pdflatex -shell-escape $output_diff_tex >/dev/null
#         # bibtex diff >/dev/null 2>&1
#         bibtex ${output_diff_tex%.tex} >/dev/null 2>&1
#         yes '' | pdflatex -shell-escape $output_diff_tex >/dev/null
#         yes '' | pdflatex -shell-escape $output_diff_tex >/dev/null
#     else
#         echo -e "\n$output_diff_tex is empty. Skip compiling $output_diff_tex"
#     fi

#     if [ -f ./diff.pdf ]; then
#         echo -e "\n\033[1;33mCompiled: $output_diff_tex\033[0m"
#     fi
# }

# gen_and_compile_diff

## EOF
