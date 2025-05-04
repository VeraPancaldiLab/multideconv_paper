# multideconv

An integrative pipeline for combining first and second generation cell type deconvolution results 

This repository contains the code to reproduce the analysis of the paper:

*Hurtado, M., Essabbar, A., Khajavi, L., & Pancaldi, V. (2025). multideconv – Integrative pipeline for cell type deconvolution from bulk RNAseq using first and second generation methods. bioRxiv. https://doi.org/10.1101/2025.04.29.651220*

### Install from source
Clone the repository:
```
git clone https://github.com/VeraPancaldiLab/multideconv_paper
```

## Project organization
- **input/**: Input files used during analysis (e.g. raw counts, metadata).
- **output/**: Intermediate files generated (e.g. deconvolution, subgroups).
- **scripts/**: Codes used for analysis.
  -  `Subgroups_analysis.Rmd`: Subgroup analysis (**Result: Grouped features preserve sample clustering structure and Grouping features preserves original data structure**).
  -  `ML_analysis.Rmd`: Analysis for Vanderbilt early stages samples (**Result: Grouped features are highly predictive of immunotherapy response**).
  -  `Metacells.Rmd`: Metacell construction based on single cell data (**Result: Validating subgrouped features using scRNAseq datasets**).
  -  `Deconvolution_SC.Rmd`: Deconvolution based on single cell (**Result: Validating subgrouped features using scRNAseq datasets**). 
- **Results/**: Figures and generated cell signatures used in the paper. 

## Environment

If you would like to reproduce the analysis done here, we invite you to use our provided r-environment. Setting it up will install all the neccessary packages, along with their specific versions in an isolated environment.

For this, open the project `multideconv_paper.Rproj` inside the scripts/ folder and in the R console run:

```r
# To activate the R environment (if you are using it for the first time)
renv::activate()
# To download and install all the require libraries and packages (if you are using it for the first time)
renv::restore() 
```

Once all packages have been installed, you can start testing the scripts but be sure to still be inside the .Rproj!

Note that this is an **once-step** only when running `multideconv_paper` for the **first time**. For the following times, you will only need to open the `multideconv_paper.Rproj` and you are ready to go!

Once all packages have been installed, you can start reproducing the analysis using the scripts inside the `scripts/` folder.

Make sure to run `renv::deactivate()` when finishing, to avoid conflicts whenever you start a different R project.

For more information about how R-environments work, visit the main page of the tool [renv](https://rstudio.github.io/renv/articles/renv.html).

## R package

The multideconv R package and tutorials can be found at: https://github.com/VeraPancaldiLab/multideconv

## Contributing

If you are interested or have questions about the analysis done in this project, we invite you to open an issue in https://github.com/VeraPancaldiLab/multideconv_paper/issues or contact Marcelo Hurtado (marcelo.hurtado@inserm.fr) for more information.

## Acknowledgements

This repository was created by [Marcelo Hurtado](https://github.com/mhurtado13) in the [Network Biology for Immuno-oncology (NetB(IO)²)](https://www.crct-inserm.fr/en/netbio2_en/) group at the Cancer Research Center of Toulouse in supervision of [Vera Pancaldi](https://github.com/VeraPancaldi).
