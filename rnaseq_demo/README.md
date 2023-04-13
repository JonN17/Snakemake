# RNA-Sequencing Demo for Proof of Concept Only
Author: Jonathan Nowacki

This is for demonstration purposes only.  It is not a functional pipeline and simply demonstrates good coding practices and knowledge of common bioinformatics tools.

## Description
This RNA pipeline performs the following functions:
* Trimming
* Gene Level Alignment
* transcript-level alignment
* Fusion calling

The final deliverables include:
* A multiqc report
* A table of read counts at gene level
* A table of read counts at fusion level

## Software requirement
* [Conda](https://conda.io/projects/conda/en/latest/user-guide/install/index.html)
* [Fastp](https://github.com/OpenGene/fastp)
* [FastqQC](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)
* [Samtools](http://www.htslib.org/)
* [Snakemake](https://snakemake.readthedocs.io/en/stable/)
* [STAR](https://github.com/alexdobin/STAR)
* [MultiQC](https://multiqc.info/)

## Other tools of interest outside of this demo
* [DeepTools](https://deeptools.readthedocs.io/en/develop/index.html)
* [GffCompare](https://ccb.jhu.edu/software/stringtie/gffcompare.shtml)
* [GffRead](https://github.com/gpertea/gffread)
* [QualiMap](http://qualimap.conesalab.org/)
* [RNASeQC](https://github.com/getzlab/rnaseqc)
* [Salmon](https://salmon.readthedocs.io/en/latest/)
* [STAR-Fusion](https://github.com/STAR-Fusion/STAR-Fusion/wiki)
* [Singularity](https://sylabs.io/guides/3.0/user-guide/quick_start.html)
* [StringTie](https://github.com/gpertea/stringtie)

## User's Guide
### I. Input Requirements

### II. Edititng the config.yaml
#### Mandatory - Must be edited and considered for each run
* `project_id`: The name of the project, this will be the prefix of the deliverables file.

#### Optional - The need to modify is dependent on the analysis requirements.
* `fastp`: The trimming paramaters for fastp.
* `fastq`: The directory that will be searched for fastq files
* `fastq_ext_r1`: Suffix of R1 fastq.gz file.  If the file is {sample}_R1.fastq.gz then enter "_R1.fastq.gz"

#### Other Parameters of Special Interest
* `cpu_aligner`: The number of threads to be allocated to the aligner.  This is will be applied to bwa, bowtie, STAR and any other aligner.

### III. How to Run
#### Environment
##### Note:
***If environment is available SKIP the installation instructions***
* Install Conda if not pre-installed.
* Install Mamba if not pre-installed.  Mamba will often solve dependencies conda is unable to.
* If not pre-installed, create a conda environment in the appropriate directory using the provided yaml file from the git cloned directory `envs/` and activate it after installation:
```
mamba env create -f rnaseq.yaml
conda activate rnaseq
```
* To activate the conda environment on a local group server:
```
source <path_to>/anaconda3/bin/activate
conda activate rnaseq
```
* To activate the conda environment on the cluster:
```
source <path_to>/anaconda3/bin/activate
conda activate rnaseq
```
* Install Singularity if not pre-installed
##### Note:
***Apple M1 platform is based on ARM, in Reduced Instruction Set Computing (RISC) and may require Parallels Desktop for Mac.***
* [Parallels](https://https://www.parallels.com/)

### III. Cod Documentation
* To view the snakemake rule graph:
```
snakemake --rulegraph | dot -T png > rulegraph_rnaseq.png
```
* To view a color coded rule graph execute:
```
bash 
```