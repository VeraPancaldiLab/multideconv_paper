# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository contains the analysis code for the **multideconv** paper — an integrative pipeline combining first and second generation cell type deconvolution methods from bulk RNAseq data. The paper validates that grouped deconvolution features preserve sample clustering structure and predict immunotherapy response.

Paper: https://doi.org/10.1101/2025.04.29.651220

## Environment Setup

This project uses `renv` for R package management (R 4.3.1, Bioconductor 3.18).

```r
renv::activate()   # Activate isolated R environment
renv::restore()    # Install all locked package versions (first time only)
```

Open `scripts/multideconv_paper.Rproj` in RStudio. Scripts are knitted as R Markdown files — there is no CLI build step.

## Repository Structure

- `input/` — Raw data: bulk RNAseq counts (Mariathasan, Gide datasets) and clinical metadata
- `output/` — Cached intermediate deconvolution results (`.RData` files)
- `Results/` — Generated figures (PDFs) and custom cell signatures
- `scripts/` — All analysis as `.Rmd` files

## Analysis Workflow

Scripts should be run in this order:

1. **`Deconvolution_dictionary.Rmd`** — Runs `multideconv::compute.deconvolution()` on raw counts; computes pathway activity via decoupleR
2. **`Subgroups_analysis.Rmd`** — Calls `compute.deconvolution.analysis(corr=0.7)` to group correlated cell types; validates structure preservation
3. **`ML_analysis.Rmd`** — Tests predictive power of raw vs. grouped deconvolution features on Gide immunotherapy response data using pipeML/caret (AUROC)
4. **`Benchmark_Vanderbilt.Rmd`** / **`Benchmark_Zilionis.Rmd`** — Cross-validates deconvolution accuracy against single-cell benchmarks
5. **`Metacells_Vanderbilt.Rmd`** / **`Metacells_Zilionis.Rmd`** — Constructs metacells from scRNAseq for signature validation

Intermediate results are cached as `.RData` files in `output/` so later scripts can load them without rerunning earlier steps.

## Key Parameters

- Correlation threshold for subgrouping: `corr = 0.7` (in `compute.deconvolution.analysis`)
- ML metric: AUROC; response variable: immunotherapy response (Gide dataset)
- Deconvolution methods: multiple first- and second-generation methods combined via the `multideconv` package
