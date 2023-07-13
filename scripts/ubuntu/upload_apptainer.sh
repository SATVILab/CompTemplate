#!/bin/bash
GH_R_VERSION=423
gh release create r${GH_R_VERSION} sif/r${GH_R_VERSION}.sif --title "r${GH_R_VERSION}" --notes "Apptainer/Singularity container for R${GH_R_VERSION}"
