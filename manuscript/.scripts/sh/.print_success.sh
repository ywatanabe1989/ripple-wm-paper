#!/bin/bash

function print_success() {
    declare -a files_to_check=("compiled.pdf" "diff.pdf")

    for pattern in "${files_to_check[@]}"; do
        files_found=$(ls ./${pattern} 2> /dev/null)
        if [ -n "$files_found" ]; then
            for file in $files_found; do
                # echo -e "\nCongratulations! ${file} is ready."
                echo -e "\n\033[1;33mCongratulations! ${file} is ready.\033[0m"                
            done
        else
            echo -e "\n\033[1;33mUnfortunately, no files matching ${pattern} were created.\033[0m"
        fi
    done
}

print_success

## EOF
