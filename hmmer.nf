// variables declared outside of a workflow are global
output_dir = params.output_dir

process hmmbuild {
    // these options are process directives
    // see full documentation here: https://www.nextflow.io/docs/latest/process.html#directives
    cpus 4
    time '1h'
    memory '1GB'
    container = 'staphb/hmmer:latest'

    input:
        path seq_file
        val seq_type

    output:
        path "*.hmm"

    """
    hmmbuild --${seq_type} --cpu ${task.cpus} ${seq_file.simpleName}.hmm ${seq_file}
    """
}

process hmmpress {
    cpus 1
    time '1h'
    memory '1GB'
    container = 'staphb/hmmer:latest'

    input:
        path hmm_file

    output:
        // the emit keyword names output, so we can access hmm_file with hmmpress.out.hmm
        path hmm_file, emit: hmm
        path "*.h3f", emit: h3f
        path "*.h3i", emit: h3i
        path "*.h3m", emit: h3m
        path "*.h3p", emit: h3p

    """
    hmmpress ${hmm_file}
    """
}

process nhmmscan {
    // dynamically allocated resources allow Nextflow to resubmit a job with increasing resource requests, in case
    // a job dies due to lack of time/memory/etc. Handily, prevents entire workflow from crashing if this occurs
    // unless maxRetries + 1 attempts fail
    cpus {4 * task.attempt}
    time '1h'
    memory {1.Gb * task.attempt}

    // this directive tells Nextflow to put links to (default) or copies of process output in some directory
    publishDir("${output_dir}/", mode: 'copy')

    // these settings are required for dynamic allocations
    errorStrategy 'retry'
    maxRetries 2

    container = 'staphb/hmmer:latest'

    input:
        path hmm_file
        path h3f_file
        path h3i_file
        path h3m_file
        path h3p_file
        path genome_file

    output:
        path "*.tbl"

    """
    nhmmscan --cpu ${task.cpus} --tblout ${genome_file.simpleName}.tbl ${hmm_file} ${genome_file}
    """
}

// named subworkflow that builds a sequence into a HMM
workflow build_hmm {
    take:
        integrase_path
        seq_type

    main:
        // because hmmbuild() output matches hmmpress() input, we can link them with a | character
        hmmbuild(integrase_path, seq_type) | hmmpress

    emit:
        // trying to emit multi-channel output throws an error, so we emit each channel separately
        hmm = hmmpress.out.hmm
        h3f = hmmpress.out.h3f
        h3i = hmmpress.out.h3i
        h3m = hmmpress.out.h3m
        h3p = hmmpress.out.h3p
}

// workflow without name is the default entry point for execution
workflow {
    integrase_path = params.integrase_path
    genomes = Channel.fromPath(params.genome_paths)
    seq_type = params.seq_type
    run_searches = params.run_searches

    hmm_files = build_hmm(integrase_path, seq_type)

    if (run_searches) {
        nhmmscan(hmm_files, genomes)
    }
}