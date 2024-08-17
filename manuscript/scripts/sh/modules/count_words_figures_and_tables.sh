#!/bin/bash

echo -e "$0 ..."

# Prepares a directory
TGT_DIR=./src/wordcounts
mkdir -p $TGT_DIR

# Count tables
table_count=`ls ./src/tables/*.tex | wc -l`
echo $table_count > $TGT_DIR/table_count.txt

# Count figures
figure_count=`ls ./src/figures/*.tex | wc -l`
echo $figure_count > $TGT_DIR/figure_count.txt

# Calculate word counts for each section and save to files
texcount ./src/abstract.tex -inc -1 -sum > $TGT_DIR/abstract_count.txt
texcount ./src/introduction.tex -inc -1 -sum > $TGT_DIR/introduction_count.txt
texcount ./src/methods.tex -inc -1 -sum > $TGT_DIR/methods_count.txt
texcount ./src/results.tex -inc -1 -sum > $TGT_DIR/results_count.txt
texcount ./src/discussion.tex -inc -1 -sum > $TGT_DIR/discussion_count.txt

# # Calculate word count for IMRaD excluding abstract
# (texcount ./src/introduction.tex -inc -1 -sum;
#  texcount ./src/methods.tex -inc -1 -sum;
#  texcount ./src/results.tex -inc -1 -sum;
#  texcount ./src/discussion.tex -inc -1 -sum) | awk '{s+=$1} END {print s}' > $TGT_DIR/imrd_count.txt

# Calculate word count for IMRaD excluding abstract
cat $TGT_DIR/{introduction,methods,results,discussion}_count.txt | awk '{s+=$1} END {print s}' > $TGT_DIR/imrd_count.txt

## EOF
