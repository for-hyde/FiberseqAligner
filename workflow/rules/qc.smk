# rule longqc: Needs work
#     input:
#         query=lambda wc: f"{SAMPLES[wc.samplename]}"
#     output:
#         folder=directory(f"{OUTPUT_DIR}/qc/{{samplename}}/")
#     log:
#         log=f"{LOGS}/longqc/{{samplename}}.log"
#     threads: 8
#     resources:
#         mem_mb=32000,
#         runtime=100
#     conda:
#         workflow.source_path("../envs/longqc.yaml")
#     shell:
#         """
#         cd workflow/scripts/LongQC
#         python longQC.py sampleqc -x pb-rs2 -o {output.folder}\
#         -p {threads} {input.query}
#         """

#Add after adding the nucleosome labeling
rule fiberqc:
    input:
        bam = rules.label_nucleosomes.output.bam,
        bai = rules.index_nuc_bam.output.bai
    output:
        folder = directory(f"{OUTPUT_DIR}/qc/fiberqc/{{samplename}}")
    threads: 8
    resources:
        mem_mb=16000,
        runtime=80
    conda:
        workflow.source_path("../envs/fiberseqqc.yaml")
    shell:
        """
        git clone https://github.com/fiberseq/fiberseq-qc.git
        cd fiberseq-qc
        tcsh src/runall-qc.tcsh {output.folder} {{samplename}} {input.bam}

        """
