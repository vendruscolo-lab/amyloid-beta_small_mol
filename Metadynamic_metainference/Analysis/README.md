
# Small molecule sequestration of amyloid-β as a drug discovery strategy for Alzheimer's disease

This repository contains scripts to reproduce analysis of the trajectories from metadynamic metainference simulations as reported in https://doi.org/10.1101/729392

## Reproducibility information
For input files to generate trajectories, see ../PLUMED_input_files or PLUMED NEST (plumID:20.014, https://www.plumed-nest.org/eggs/20/014/).

## This repository contains: 
#### Scripts 
1. Scripts to perform solvent-accessible surface area calculations in sasa/
2. Scripts to perform hydrogen bonding calculations in water_shell/
3. Scripts to perform GROMOS clustering in gromos_clustering/ (contributed by maxbonomi)

#### Jupyter Notebook 
4. A Jupyter Notebook detailing the analysis performed to reproduce the figures as reported in the manuscript is included as `Metadynamic_metainference_analysis.ipynb`. The easiest way to try out the notebooks is by using [`conda`](https://www.anaconda.com/products/individual). We include the environment `environment.yml`, which specifies the packages needed for the analysis and plotting of the results. To create the environment, run `conda env create -f environment.yml` and activate the new environment with `conda activate analysis`. Large data files referenced in the Notebook (including trajectories, metadynamics weights, and Lennard Jones/Coulomb interaction energies) are hosted on Zenodo here: https://zenodo.org/record/3865919#.XtbMtZ5Kgch. They should be downloaded placed in a directory called `Zenodo`, in the same diectory as   `Metadynamic_metainference_analysis.ipynb`.
