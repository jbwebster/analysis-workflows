#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
label: "bam to trimmed fastqs and biscuit alignments"
requirements:
    - class: SubworkflowFeatureRequirement
inputs:
    fastq1:
        type: File
    fastq2:
        type: File
    read_group_id:
        type: string
    reference_index:
        type: string
outputs:
    aligned_bam:
        type: File
        outputSource: biscuit_markdup/markdup_bam
steps:
    biscuit_align:
        run: ../tools/biscuit_align.cwl
        in:
            reference_index: reference_index
            fastq1: trim_fastq/fastq1
            fastq2: trim_fastq/fastq2
            read_group_id: read_group_id
        out:
            [aligned_bam]
    index_bam:
        run: ../tools/index_bam.cwl
        in:
            bam: biscuit_align/aligned_bam
        out:
            [indexed_bam]
    biscuit_markdup:
        run: ../tools/biscuit_markdup.cwl
        in:
           bam: index_bam/indexed_bam
        out:
            [markdup_bam]
