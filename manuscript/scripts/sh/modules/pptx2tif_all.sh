#!/bin/bash

echo -e "$0 ..."

# PowerPoint to TIF
for pptx_file in ./src/figures/Figure_ID_*.pptx; do
    ./scripts/sh/modules/pptx2tif.sh $pptx_file
done

## EOF
