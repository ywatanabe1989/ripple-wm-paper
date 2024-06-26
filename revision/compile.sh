#!/bin/bash

pdflatex main
bibtex main
pdflatex main
pdflatex main

# clean-up
mkdir -p log
mv *.cpt *.log *.out *.spl *.tmp log
