#!/usr/bin/env nextflow

params.file_dir = 'data/fastas/*.fasta'
params.out_dir = 'data/'
params.out_file = 'histogram.png'

file_channel = Channel.fromPath( params.file_dir )

process get_seq_length {
    container 'bioconductor/release_core2:R3.5.0_Bioc3.7'

    input:
    file f from file_channel

    output:
    stdout lengths

    """
    #!/usr/local/bin/Rscript

    suppressMessages(library(Biostrings))

    s = readDNAStringSet('$f')
    l = length(s[[1]])

    cat(l)
    """
}

process python_transform_list {
    container 'python:3.7-slim'

    input:
    val l from lengths.collect()

    output:
    stdout lengths_transformed

    """
    #!/usr/local/bin/python

    numbers = $l
    lstring = 'c(' + ','.join([str(x) for x in numbers]) + ')'
    print(lstring)
    """
}

process plot_lengths_hist {
    container 'rocker/tidyverse:3.5'
    publishDir params.out_dir, mode: 'copy'

    input:
    val l from lengths_transformed

    output:
    file params.out_file into last_fig

    """
    #!/usr/local/bin/Rscript

    library(tidyverse)
    numbers = tibble(n = $l)

    ggplot(numbers, aes(x=n)) +
        geom_histogram() +
        xlab('sequence length') +
        ylab('count') +
        theme_bw()
    ggsave('$params.out_file', width = 10, height = 8, units = 'cm')
    """
}

lengths_transformed.subscribe {  println it  }
