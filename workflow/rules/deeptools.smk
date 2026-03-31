rule pileup:
    input:
        bam = rules.label_nucleosomes.output.bam,
        bai = rules.index_nuc_bam.output.bai
    output:
        pileup=f"{OUTPUT_DIR}/pileups/{{samplename}}/{{samplename}}.pileup.bedgraph"
    log:
        f"{OUTPUT_DIR}/logs/pileup/{{samplename}}.log"
    threads: 8
    resources:
        mem_mb=16000,
        runtime=540
    params:
        outdir=lambda wildcards, output: os.path.dirname(output.pileup)
    conda:
        workflow.source_path("../envs/deeptools.yaml")
    shell:
        """
        set -euxo pipefail
        mkdir -p {params.outdir}
        ft pileup --m6a --cpg -v -o {output.pileup} {input.bam} > {output.pileup}.log 2>&1
        """