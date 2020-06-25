import sys
import os
import re
import tempfile
sys.path.append(os.path.join(os.path.dirname(os.path.abspath(workflow.snakefile)),"scripts"))

configfile: "config.yaml"

workdir: config["workdir"]

onsuccess:
    print("Workflow finished, no error")

onerror:
    print("An error occurred")

onstart:
    fasta = config["fasta"]
    long_reads = config["long_reads"].strip().split()
    short_reads_1 = config["short_reads_1"].strip().split()
    short_reads_2 = config["short_reads_2"].strip().split()
    batch_file = config["batch_file"]
    # gtdbtk_folder = config["gtdbtk_folder"]
    # busco_folder = config["busco_folder"]
    import os
    if fasta[0] == "none" and batch_file == "none":
        sys.exit("Need at least one of fasta or batch_file")
    # if gtdbtk_folder != "none" and not os.path.exists(gtdbtk_folder):
    #     sys.stderr.write("gtdbtk_folder does not point to a folder\n")
    # if busco_folder != "none" and not os.path.exists(busco_folder):
    #     sys.stderr.write("busco_folder does not point to a folder\n")

rule rename_contigs:
    input:
        fasta = config["fasta"]
    output:
        "data/renamed_contigs.fasta"
    params:
        input_basename = os.path.basename(config["fasta"]).split(".")[0]
    shell:
        "sed 's/>/>{params.input_basename}__/' {input.fasta} | sed 's/\s.*//'  > {output}"

rule run_virsorter:
    input:
        fasta = "data/renamed_contigs.fasta",
        virsorter_data = config["virsorter_data"]
    output:
        "data/viral_predict/virsorter/done"
    conda:
        "envs/virsorter.yaml"
    threads:
        config["max_threads"]
    shell:
        "virsorter run --seqfile {input.fasta} --working-dir data/viral_predict/virsorter " \
        "--db-dir {input.virsorter_data} --jobs {threads} all && " \
        "touch {output}"

rule run_vibrant:
    input:
        fasta = "data/renamed_contigs.fasta",
        vibrant_data = config["vibrant_data"]
    output:
        "data/viral_predict/vibrant/done"
    conda:
        "envs/vibrant.yaml"
    threads:
        config["max_threads"]
    shell:
         "VIBRANT_run.py -i {input.fasta} -folder data/viral_predict/vibrant -t {threads} -d {input.vibrant_data} && " \
         "touch {output}"

rule run_virfinder:
    input:
        fasta = "data/renamed_contigs.fasta"
    output:
        "data/viral_predict/virfinder/done"
    conda:
        "envs/virfinder.yaml"
    threads:
        config["max_threads"]
    shell:
         "Rscript --vanilla scripts/virfinder.R {input.fasta} data/viral_predict/virfinder/virfinder.tsv &&" \
         "touch {output}"

rule viral_predict:
    input:
         virsorter_done = "data/viral_predict/virsorter/done",
         virfinder_done = "data/viral_predict/virfinder/done",
         vibrant_done = "data/viral_predict/vibrant/done"
    output:
          "data/viral_predict/done"
    shell:
         "touch {output}"