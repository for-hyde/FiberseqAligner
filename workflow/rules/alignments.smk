rule index_reference_genome:
    input:
        ref = REF_FILE
    output:
        index = REF_FILE + ".mmi"
    log:
        log = f"{LOGS}/pbmm2/index_reference.log"        
    resources:
        mem_mb=16000,
        runtime=60
    threads: 4
    conda:
        workflow.source_path("../envs/pbmm2.yaml")
    shell:
        """
        pbmm2 index {input.ref} {output.index} 2>&1 | tee {log.log}
        """

rule pbmm2_align:
    input:
        reference=REF_FILE,
        ref_index = REF_FILE + ".mmi",
        query=lambda wc: f"{SAMPLES[wc.samplename]}"
    output:
        bam=f"{OUTPUT_DIR}/alignments/{{samplename}}/{{samplename}}.bam",
    log:
        log=f"{LOGS}/pbmm2/{{samplename}}.log"
    params:
        preset=config["pbmm2_alignment"]["mode"],
        sample=lambda wc: wc.samplename,
        loglevel="INFO"
    threads: 16
    conda:
        workflow.source_path("../envs/pbmm2.yaml")
    resources:
        mem_mb=64000,
        runtime=720
    shell:
        """
        pbmm2 align \
            --preset {params.preset} \
            --log-level {params.loglevel} \
            -j {threads} \
            {input.reference} {input.query} {output.bam} \
            2>&1 | tee {log.log}
        """

rule sort_bam:
    input:
        bam=rules.pbmm2_align.output.bam
    output:
        bam=f"{OUTPUT_DIR}/alignments/{{samplename}}/{{samplename}}.sorted.bam"
    threads: 8
    conda:
        workflow.source_path("../envs/pbmm2.yaml")
    resources:
        mem_mb=32000,
        runtime=100
    shell:
        "samtools sort -@ {threads} -o {output.bam} {input.bam}"

rule index_bam:
    input:
        bam=rules.sort_bam.output.bam
    output:
        bai=f"{OUTPUT_DIR}/alignments/{{samplename}}/{{samplename}}.sorted.bam.bai"
    threads: 4
    resources:
        mem_mb=16000,
        runtime=100
    conda:
        workflow.source_path("../envs/pbmm2.yaml")
    shell:
        "samtools index -@ {threads} {input.bam}"
