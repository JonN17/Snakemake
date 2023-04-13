if pretrim_fastqc == "Y":
  # INPUT: 1) R1_fastq.gz
  #        2) R1_fastq.gz
  # OUTPUT: 1) R1_fastqc.zip
  #         2) R2_fastqc.zip
  # Description: Runs quality control on pre-trimmed *.FASTQ.GZ files and produces *.FASTQC.ZIP
  rule Pretrim_Fastqc:
      input:
            fastq + "/{sample}_R1.fastq.gz",
            fastq + "/{sample}_R2.fastq.gz"
      output:
            out + "/pretrim_fastqc/{sample}_R1_fastqc.zip",
            out + "/pretrim_fastqc/{sample}_R2_fastqc.zip"
      threads: 8
      log: 
            std_err = out + "logs/pretrim_fastqc/{sample}_pretrimqc_std_error.log"
      shell:
            """
            fastqc {input} \
                   -o {out}/pretrim_fastqc \
                   -f fastq \
                   --noextract \
                   -t {threads} \
                   2> {log.std_err}
            """

# INPUT: 1) R1_fastq.gz
#        2) R1_fastq.gz
# OUTPUT: 1) _trimmed_R1.fastq.gz
#         2) _trimmed_R2.fastq.gz
#         3) json file of quality metrics
#         4) *.HTML files for quality metics
# Description: Performes trimming on *.FASTQ.GZ files and produces trimming *.FASTQ.GZ files as well as metrics in *.JSON and *HTML
rule Trim:
    input:
          fastq + "/{sample}_R1.fastq.gz",
          fastq + "/{sample}_R2.fastq.gz"
    output:
          r1 = out + "/trimmed/{sample}/{sample}_trimmed_R1.fastq.gz",
          r2 = out + "/trimmed/{sample}/{sample}_trimmed_R2.fastq.gz",
          json = out + "/trimmed/{sample}/{sample}_trimming.fastp.json",
          html = out + "/trimmed/{sample}/{sample}_trimming.fastp.html"
    params:
          fastp_setting = fastp
    threads: 8
    log: 
          std_err = out + "logs/trim/{sample}_trim_std_error.log"
    shell:
          """
          fastp -i {input[0]} -I {input[1]} \
                -o {output.r1} -O {output.r2} \
                -w {threads} \
                -j {output.json} \
                -h {output.html} \
                {params.fastp_setting} \
                2>{log.std_err}
          """

# INPUT: 1) _trimmed_R1.fastq.gz
#        2) _trimmed_R2.fastq.gz
# OUTPUT: 1) R1_fastqc.zip
#         2) R2_fastqc.zip
# Description: Runs quality control on post-trimmed *.FASTQ.GZ files and produces *.FASTQC.ZIP
rule Posttrim_Fastqc:
    input:
          rules.Trim.output.r1,
          rules.Trim.output.r2
    output:
          out + "/posttrim_fastqc/{sample}_trimmed_R1_fastqc.zip",
          out + "/posttrim_fastqc/{sample}_trimmed_R2_fastqc.zip",
    threads: cpu_fastq
    log: 
          std_err = out + "logs/posttrim_fastqc/{sample}_posttrim_fastqc_std_error.log"
    shell:
          """
          fastqc {input} \
                 -o {out}/posttrim_fastqc \
                 -f fastq \
                 --noextract \
                 -t {threads} \
                 2>{log.std_err}
          """

# INPUT: 1) _trimmed_R1.fastq.gz
#        2) _trimmed_R2.fastq.gz
# OUTPUT: 1) aligned reads .BAM
#         2) reads per gene .TAB 
#         3) empty file to confirm job completion .TXT
# Description: Aligns RNA-seq data using a strategy to account for spliced alignments 
rule Align:
    input:
          r1,
          r2
    output:
          bam = out + "/align/{sample}/{sample}_aligned.sortedByCoord.out.bam",
          counts = out + "/align/{sample}/{sample}_ReadsPerGene.out.tab",
          txt = out + "/align/{sample}/job_complete.txt"
    threads: cpu_align
    params:
          indice = star_indice,
          gtf = gtf,
          star = star
    log:
          star = out + "logs/align/{sample}_align_std_error.log",
          samtools = out + "logs/align/{sample}_index_std_error.log"
    shell:
          """
          STAR --runThreadN {threads} \
               --genomeDir {params.indice} \
               --sjdbGTFfile {params.gtf} \
               --readFilesIn {input[0]} {input[1]} \
               --readFilesCommand zcat \
               --outFileNamePrefix {out}/align/{wildcards.sample}/{wildcards.sample}_ \
               --outSAMtype BAM SortedByCoordinate \
               --quantMode GeneCounts \
               --twopassMode Basic \
               {params.star} \
               2>{log.star}
          samtools index {output.bam} 2>{log.samtools}
          touch {output.txt}
          """