#!/bin/bash

echo -e "$0 ..."

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

gen_diff_tex

## EOF
