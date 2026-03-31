#Calls methylatoin, and labels nucleosomes. 
rule label_nucleosomes:
    input:
        bam=rules.sort_bam.output.bam,
        bai=rules.index_bam.output.bai
    output:
        bam=f"{OUTPUT_DIR}/alignments/{{samplename}}/{{samplename}}.sorted.nuc.bam"
    threads:
        8
    resources:
        mem_mb=32000,
        runtime=80
    conda:
        workflow.source_path("../envs/fiberseqqc.yaml")
    shell:
        """
        cd workflow/scripts/fiberseq-qc
        ft predict-m6a -k -t {threads} {input.bam} {output.bam}
        """

rule index_nuc_bam:
    input:
        bam = rules.label_nucleosomes.output.bam
    output:
        bai = f"{OUTPUT_DIR}/alignments/{{samplename}}/{{samplename}}.sorted.nuc.bam.bai"
    threads: 4
    resources:
        mem_mb=16000,
        runtime=100
    conda:
        workflow.source_path("../envs/pbmm2.yaml")
    shell:
        "samtools index -@ {threads} {input.bam}"