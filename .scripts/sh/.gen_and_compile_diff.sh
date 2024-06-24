#!/bin/bash

function gen_and_compile_diff() {
    base_tex=$(ls -v ./old/compiled_v*base.tex 2>/dev/null | tail -n 1)    
    latest_tex=$(ls -v ./old/compiled_v*.tex 2>/dev/null | tail -n 1)    

    # Check if base_tex file exists and is not empty
    if [[ -n "$base_tex" ]]; then
        echo -e "\nBase .tex file found: $base_tex"
        base_tex=$base_tex
    else
        echo "\nNo base .tex file found."
        base_tex=$latest_tex        
    fi

    current_tex="./compiled.tex"

    if [ -n "$base_tex" ] && [ -f "$current_tex" ]; then
        echo -e "\nTaking diff between $base_tex & $current_tex"
        latexdiff "$base_tex" "$current_tex" > ./diff.tex 2> /dev/null
    fi

    if [ -s diff.tex ]; then
        echo -e "\n./diff.tex was created."
        echo -e "\nCompiling ./diff.tex..."
        yes '' | pdflatex -shell-escape ./diff.tex >/dev/null
        bibtex diff >/dev/null 2>&1
        yes '' | pdflatex -shell-escape ./diff.tex >/dev/null
        yes '' | pdflatex -shell-escape ./diff.tex >/dev/null
    else
        echo -e "\ndiff.tex is empty. Skip compiling .diff.tex"
    fi

    if [ -f ./diff.pdf ]; then
        echo -e "\nCompiled: ./diff.tex"
    fi
}

gen_and_compile_diff

## EOF
