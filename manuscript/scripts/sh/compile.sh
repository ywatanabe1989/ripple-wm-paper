#!/bin/bash

LOG_FILE="./.logs/compile.log"

echo_splitter() {
    echo -e "\n----------------------------------------"
    }

parse_arguments() {
    do_insert_citations=false
    do_revise=false
    do_push=false
    do_term_check=false
    do_p2t=false
    no_figs=true

    while [[ "$#" -gt 0 ]]; do
        case $1 in
            -h|--help) display_usage ;;
            -p|--push) do_push=true ;;
            -r|--revise) do_revise=true ;;
            -t|--terms) do_term_check=true ;;
            -p2t|--ppt2tif) do_p2t=true ;;
            -c|--citations) do_insert_citations=true ;;
            -f|--figs) no_figs=false ;;
        esac
        shift
    done
}

display_usage() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -p,   --push          Enables push action"
    echo "  -r,   --revise        Enables revision process with GPT"
    echo "  -t,   --terms         Enables term checking with GPT"
    echo "  -p2t, --ppt2tif       Converts Power Point to TIF (on WSL on Windows)"
    echo "  -c,   --citations     Inserts citations with GPT"
    echo "  -f,  --figs           Includes figures"
    exit 0
}

log_command() {
    echo_splitter
    echo "./compile.sh" \
         $(if $do_push; then echo "--push "; fi) \
         $(if $do_revise; then echo "--revise "; fi) \
         $(if $do_term_check; then echo "--terms "; fi) \
         $(if $do_p2t; then echo "--ppt2tif "; fi) \
         $(if $do_insert_citations; then echo "--citations "; fi) \
         $(if $no_figs; then echo "--no-figs"; fi)
    echo_splitter
}


clear_main_directory() {
    # Usage: clear_main_directory
    for f in main.pdf diff.pdf manuscript.pdf manuscript.tex diff.tex; do
        rm ./main/$f 2>/dev/null
    done
}

run_checks() {
    echo_splitter
    ./scripts/sh/modules/check.sh
    echo_splitter
}

convert_pptx_to_tif() {
    if [ "$do_p2t" = "true" ] && [ "$no_figs" = "false" ]; then
        echo_splitter
        ./scripts/sh/modules/pptx2tif_all.sh
        echo_splitter
    fi
}

crop_figures() {
    if [ "$no_figs" = false ]; then
        echo_splitter
        ./scripts/sh/modules/crop_figures.sh
        echo_splitter
    fi
}

revise_tex_files() {
    if [ "$do_revise" = true ]; then
        echo_splitter
        ./scripts/sh/revise.sh
        echo_splitter
    fi
}

insert_citations() {
    if [ "$do_insert_citations" = true ]; then
        echo_splitter
        ./scripts/sh/insert_citations.sh
        echo_splitter
    fi
}

count_words_figures_tables() {
    echo_splitter
    ./scripts/sh/modules/count_words_figures_and_tables.sh
    echo_splitter
}

compile_main_tex() {
    echo_splitter
    if $no_figs; then
        ./scripts/sh/modules/compile_main_tex.sh --no-figs
    else
        ./scripts/sh/modules/compile_main_tex.sh
    fi
    echo_splitter
}

generate_compiled_tex() {
    echo_splitter
    ./scripts/sh/modules/gen_compiled.tex.sh
    echo_splitter
}

generate_diff_tex() {
    echo_splitter
    ./scripts/sh/modules/gen_diff_tex.sh
    echo_splitter
}

compile_diff_tex() {
    echo_splitter
    ./scripts/sh/modules/compile_diff_tex.sh
    echo_splitter
}

# generate_and_compile_diff() {
#     echo_splitter
#     ./scripts/sh/modules/gen_and_compile_diff.sh
#     echo_splitter
# }

cleanup() {
    echo_splitter
    ./scripts/sh/modules/cleanup.sh
    echo_splitter
}

versioning() {
    echo_splitter
    ./scripts/sh/modules/versioning.sh
    echo_splitter
}

print_success() {
    echo_splitter
    ./scripts/sh/modules/print_success.sh
    echo_splitter
}

check_terms() {
    if [ "$do_term_check" = true ]; then
        echo_splitter
        ./scripts/sh/modules/check_terms.sh
        echo_splitter
    fi
}

custom_tree() {
    echo_splitter
    ./scripts/sh/modules/custom_tree.sh
    echo_splitter
}

git_push() {
    if [ "$do_push" = true ]; then
        echo_splitter
        ./scripts/sh/modules/git_push.sh
        echo_splitter
    fi

}


main() {
    parse_arguments "$@"
    log_command
    run_checks
    convert_pptx_to_tif
    crop_figures
    revise_tex_files
    insert_citations
    count_words_figures_tables
    compile_main_tex
    generate_compiled_tex
    generate_diff_tex
    compile_diff_tex
    cleanup
    versioning
    print_success
    check_terms
    custom_tree
    echo -e "\nLog saved to $LOG_FILE\n"
    git_push
}

main "$@" 2>&1 | tee "$LOG_FILE"



# main() {
#     log_command
#     run_checks
#     convert_pptx_to_tif
#     crop_figures
#     revise_tex_files
#     insert_citations
#     count_words_figures_tables
#     compile_main_tex
#     generate_compiled_tex
#     generate_and_compile_diff
#     cleanup
#     versioning
#     print_success
#     check_terms
#     custom_tree
#     echo -e "\nLog saved to $LOG_FILE\n"
#     git_push
# } 2>&1 | tee "$LOG_FILE"

# main "$@"


# {
#     ################################################################################
#     # Argparsing
#     ################################################################################
#     # rm ./.manuscript.tex > /dev/null 2>&1
#     # rm ./.manuscript.pdf > /dev/null 2>&1
#     # rm ./.diff.tex > /dev/null 2>&1

#     # Default parameters
#     do_insert_citations=false
#     do_revise=false
#     do_push=false
#     do_term_check=false
#     do_p2t=false
#     no_figs=true

#     # Function to display help message
#     usage() {
#         echo "Usage: $0 [options]"
#         echo "Options:"
#         echo "  -p,   --push          Enables push action"
#         echo "  -r,   --revise        Enables revision process with GPT"
#         echo "  -t,   --terms         Enables term checking with GPT"
#         echo "  -p2t, --ppt2tif       Converts Power Point to TIF (on WSL on Windows)"
#         echo "  -c,   --citations     Inserts citations with GPT"
#         echo "  -f,  --figs           Includes figures"
#         exit 0
#     }

#     while [[ "$#" -gt 0 ]]; do
#         case $1 in
#             -h|--help) usage ;;
#             -p|--push) do_push=true ;;
#             -r|--revise) do_revise=true ;;
#             -t|--terms) do_term_check=true ;;
#             -p2t|--ppt2tif) do_p2t=true ;;
#             -c|--citations) do_insert_citations=true ;;
#             -f|--figs) no_figs=false ;;
#             # *) echo "Unknown parameter passed: $1"; exit 1 ;;
#         esac
#         shift
#     done

#     options=""

#     # for logging
#     echo "./compile.sh" \
#          $(if $do_push; then echo "--push "; fi) \
#          $(if $do_revise; then echo "--revise "; fi) \
#          $(if $do_term_check; then echo "--terms "; fi) \
#          $(if $do_p2t; then echo "--ppt2tif "; fi) \
#          $(if $do_insert_citations; then echo "--citations "; fi) \
#          $(if $no_figs; then echo "--no-figs"; fi)
#     echo

#     # Checks
#     ./scripts/sh/modules/check.sh

#     # PowerPoint to Tiff (default: false)
#     if [ "$do_p2t" = "true" ] && [ "$no_figs" = "false" ]; then
#     ./scripts/sh/modules/pptx2tif_all.sh
#     fi

#     # Crop figures
#     if [ "$no_figs" = false ]; then
#         ./scripts/sh/modules/crop_figures.sh
#     fi

#     # Revise tex files if requested (default: false)
#     if [ "$do_revise" = true ]; then
#         ./scripts/sh/revise.sh
#     fi

#     # Insert citations if requested (default: false)
#     if [ "$do_insert_citations" = true ]; then
#         ./scripts/sh/insert_citations.sh
#     fi

#     # Word count
#     ./scripts/sh/modules/count_words_figures_and_tables.sh

#     # Main
#     if $no_figs; then
#         ./scripts/sh/modules/compile_manuscript.tex.sh --no-figs
#     else
#         ./scripts/sh/modules/compile_manuscript.tex.sh
#     fi

#     ./scripts/sh/modules/gen_manuscript.tex.sh # -> manuscript.tex

#     # Take diff if requested (default: false)
#     ./scripts/sh/modules/gen_and_compile_diff.sh

#     # Move unnecessary files
#     ./scripts/sh/modules/cleanup.sh

#     # Store compiled files
#     ./scripts/sh/modules/versioning.sh

#     # Success message
#     ./scripts/sh/modules/print_success.sh

#     # Check terms
#     if [ "$do_term_check" = true ]; then
#         ./scripts/sh/modules/check_terms.sh
#     fi

#     # Tree
#     ./scripts/sh/modules/custom_tree.sh

#     echo -e "\nLog saved to $LOG_FILE\n"

#     if [ "$do_push" = true ]; then
#         ./scripts/sh/modules/git_push.sh
#     fi

# } 2>&1 | tee "$LOG_FILE"



# # # Open the compiled pdf
# # if [ "$(echo $USER)" = "ywatanabe" ]; then
# #     # open_pdf_or_exit ./manuscript.pdf
# #     if [ "$do_take_diff" = false ]; then
# #         PDF_PATH=./.manuscript.pdf
# #     else
# #         PDF_PATH=./.diff.pdf
# #     fi
# #     ./scripts/sh/modules/open_pdf_or_exit.sh $PDF_PATH
# # fi

# ## EOF
