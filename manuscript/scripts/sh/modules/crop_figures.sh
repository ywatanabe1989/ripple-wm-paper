#!/bin/bash

echo -e "$0 ..."

# Crop TIF Figures
for tif_file in ./src/figures/Figure_ID*.tif; do
    ./.env/bin/python ./scripts/py/crop_tif.py -l $tif_file
done

# ./scripts/sh/modules/crop_figures.sh

## EOF
