#!/bin/bash

echo -e "$0 ..."

function refresh_figure_legends () {
    rm ./src/figures/tex/*.tex -f > /dev/null 2>&1
    rm ./src/figures/.tex/*.tex -f > /dev/null 2>&1
}

function compile_legends () {

    # Generates ./src/figures/tex/Figure_ID_*.tex files from ./src/figures/Figure_ID_*.tex files
    legend_dir="./src/figures/"
    tgt_dir="./src/figures/tex"
    figures_dir="./src/figures/png"

    mkdir -p "$tgt_dir"  > /dev/null

    ii=0
    for caption_file in "$legend_dir"Figure_ID_*.tex; do
        fname=$(basename "$caption_file")
        figure_content=$(cat "$caption_file")
        tgt_file="$tgt_dir/$fname"

        figure_id=$(echo "$fname" | grep -oP '(?<=Figure_ID_)[^\.]+')
        figure_id=$(echo "$figure_id" | tr '[:upper:]' '[:lower:]')
        width=$(grep -oP '(?<=width=)[0-9.]+\\textwidth' "$caption_file")

        rm "$tgt_file" -f > /dev/null 2>&1
        touch "$tgt_file"
        if [ $ii -gt 0 ]; then
            echo "\\clearpage" > "$tgt_file"
        fi
        ii=$((ii+1))

        cat <<EOF > "$tgt_file"
        \clearpage
        \begin{figure*}[ht]
            \pdfbookmark[2]{ID $figure_id}{figure_id_$figure_id}
        	\centering
            \includegraphics[width=$width]{$figures_dir/${fname%.tex}.png}
        	$figure_content
        	\label{fig:$figure_id}
        \end{figure*}
EOF
    done

}

function hide_figures () {
    echo -e "\nHiding figures in .tex files..."
    for fig_tex in ./src/figures/tex/*.tex; do
        sed -i 's/^\(\s*\)\\includegraphics/%\1\\includegraphics/g' "$fig_tex"
    done
}

function add_figures () {
    echo -e "\nAdding figures in .tex files..."
    for fig_tex in ./src/figures/tex/*.tex; do
        sed -i 's/^%\(\s*\\includegraphics\)/\1/g' "$fig_tex"
    done
}

function tif2png () {
    mkdir -p ./src/figures/png/
    for file in ./src/figures/*.tif; do
        if [ -f "$file" ]; then
            convert "$file" -resample 100x100 "./src/figures/png/$(basename "$file" .tif).png" # [REVISED]
        fi
    done
}

function handle_figure_visibility () {
    if [ "$1" == "--no-figs" ]; then
        hide_figures
    else
        tif2png
        if ls ./src/figures/png/*.png 1> /dev/null 2>&1; then
            add_figures
        else
            hide_figures
        fi
    fi
}

function gather_figures () {
    output_file="./src/figures/.tex/.All_Figures.tex"
    echo "" > "$output_file"
	for fig_tex in ./src/figures/tex/Figure_*.tex; do
	    fname="${fig_tex%.tex}"
        echo "\input{${fname}}" >> "$output_file"
    done
}

function main () {
    refresh_figure_legends
    compile_legends # "$@"
    handle_figure_visibility "$@"
    gather_figures
    }


main "$@"

# function hide_figures() {
#     for fig_tex in ./src/figures/.tex/Figure_*.tex; do
#         sed -i 's/\\includegraphics/% \\includegraphics/g' $fig_tex
#     done
# }

# function add_figures() {
#     for fig_tex in ./src/figures/.tex/Figure_*.tex; do
#         sed -i 's/% \\includegraphics/\\includegraphics/g' $fig_tex
#     done
# }

# function tif2png() {
#     mkdir -p ./src/figures/.png/
#     for file in ./src/figures/*.tif; do
#         if [ -f "$file" ]; then
#             convert "$file" -resample 100x100 "./src/figures/.png/$(basename "$file" .tif).png"
#         fi
#     done
# }

# function handle_figure_visibility() {
#     if [ "$1" == "--no-figs" ]; then
#         echo nofigs
#         hide_figures
#     else
#         echo compiling figs
#         tif2png
#         if ls ./src/figures/.png/*.png 1> /dev/null 2>&1; then
#             add_figures
#         else
#             hide_figures
#         fi
#     fi
# }

# function compile_legend() {

#     legend_dir="./src/figures/"
#     tgt_dir="./src/figures/.tex"
#     figures_dir="./src/figures/.png"

#     mkdir -p "$tgt_dir"  > /dev/null

#     ii=0
#     for caption_file in "$legend_dir"Figure_ID_*.tex; do
#         fname=$(basename "$caption_file")
#         figure_content=$(cat "$caption_file")
#         tgt_file="$tgt_dir/$fname"

#         figure_id=$(echo "$fname" | grep -oP '(?<=Figure_ID_)[^\.]+')  # [REVISED]
#         figure_id=$(echo $figure_id | tr '[:upper:]' '[:lower:]')
#         width=$(grep -oP '(?<=width=)[0-9.]+\\textwidth' "$caption_file")  # [REVISED]

#         rm $tgt_file -f > /dev/null 2>&1
#         if [ $ii -gt 0 ]; then
#             echo "\\clearpage" > "$tgt_file"
#         fi
#         ii=$((ii+1)) # [REVISED]

#         cat <<EOF > "$tgt_file"
#         \clearpage
#         \begin{figure*}[ht]
#             \pdfbookmark[2]{ID $figure_id}{figure_id_$figure_id}
#         	\centering
#             \includegraphics[width=$width]{$figures_dir/${fname%.tex}.png}
#         	$figure_content
#         	\label{fig:$figure_id}
#         \end{figure*}
# EOF
#     done

#     handle_figure_visibility

# }

# function gather_figures() {
#     rm ./src/figures/.tex/.All_Figures.tex -f > /dev/null 2>&1
#     rm ./src/figures/.tex/*.tex -f > /dev/null 2>&1

#     compile_legend $1

# 	for fig_tex in ./src/figures/.tex/Figure_*.tex; do
# 	    fname="${fig_tex%.tex}"
#         echo "\input{${fname}}" >> ./src/figures/.tex/.All_Figures.tex
#     done
# }

# gather_figures "$@"

# ./scripts/sh/modules/figures.sh --no-figs # this does not work. why?
# cat ./src/figures/.tex/.All_Figures.tex
# cat ./src/figures/tex/Figure_ID_01.tex


## EOF
