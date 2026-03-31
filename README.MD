This is a simplified snakemake pipeline for the automated alignment and annotation of Fiberseq data. The pipeline relies on conda environments to run and includes a local and slurm profile for running. 

# Setting up for analysis
## Setting up the repo
The first step is configuring the repo to work. To begin, copy the repo using git or another method.
```
git clone git@github.com:for-hyde/FiberseqAligner.git
```
Next, you will need to set up the profile and configuration for your files. 
For the profile, there are two included in the repo. The first is a default profile for executing the script locally, while the other is specifically for a slurm managed HPC. The slurm profile may require specification of the USER and the PARTITION it is to be run on. I would recommend trying without first, but this can be adjusted. Another change to the SLURM profile is the number of jobs to be exected at a time. It is currently set to a low count of 4 but can be adjusted depending on the compute resources available to you. 

The config is the primary place you will need to make adjustments. There are two key files you will need to always adjust for your samples: the samples.csv and the config.yaml files. The samples.csv is simply a csv file with the name of the samples in the first column, the full path to the samples in the second column, and the type of PacBio sequencing used in the third. Keep the headers the same as in the example file for the workflow to execute correctly. The config file has inputs to adjust: the path to the samples.csv file, the path to the desired output directory, and the path to the reference genome. The standard would be to place your reference genome in the resources folder and reference the results folder for the output. 

Once those files have been set up, all that remains is configuring the snakemake environment. 

## Setting up the environment


The only requirement to run is conda and snakemake. Snakemake v9.16.2 was used in the development and testing of the workflow. To install, run the command
```
conda create -c conda-forge -c bioconda -c nodefaults -n snakemake snakemake
conda activate snakemake
```
If you are using the slurm profile, ensure that your snakemake environment has the slurm executor added. This can be done by running the followign in the created snakemake environment. 
```
conda install snakemake-slurm-executor
```

# Running the workflow.
Once the profile, configuration, and snakemake workflow have all been set up, the workflow can be executed with the following. 
```
snakemake --profile profiles/(profile) --configfile config/(config).yaml 
```
It is recommended to first attempt a dry run using the "-n" at the end. 

