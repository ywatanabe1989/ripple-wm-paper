#!/bin/bash

pdflatex main/main
bibtex main/main
pdflatex main/main
pdflatex main/main

# clean-up
mkdir -p log
mv *.cpt *.log *.out *.spl *.tmp log
