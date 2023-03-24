# Examples-for-Nextflow-DSL2
Two simple example Nextflow DSL2 scripts. Made with version 22.10.6 build 5843

Disclaimer: I don't make Nextflow and I'm not affiliated with Nextflow's developers. These are just some simple examples trying to demonstrate the basics of Nextflow DSL2.

Commands to run:
- `nextflow run calculator.nf -params-file calculator_params.yaml -profile local`
- `nextflow run hmmer.nf -params-file hmmer_params.yaml -profile local_docker`

Note: These workflows were written on Ubuntu 2020 LTS. The first script (calculator.nf) assumes you have bc installed.

[Nextflow Documentation here](https://www.nextflow.io/docs/latest/getstarted.html#)

Thanks to [StaPH-B](https://staphb.org/) for their HMMER container

Integrase sequence sourced from [NCBI](https://www.ncbi.nlm.nih.gov/protein/NP_251832.1)

Pseudomonas genomes sourced from [pseudomonas.com](https://pseudomonas.com/)

Winsor GL, Griffiths EJ, Lo R, Dhillon BK, Shay JA, Brinkman FS. Enhanced annotations and features for comparing thousands of Pseudomonas genomes in the Pseudomonas genome database. Nucleic Acids Res. 2016 Jan 4;44(D1):D646-53. doi: 10.1093/nar/gkv1227. Epub 2015 Nov 17. PMID: 26578582; PMCID: PMC4702867.
