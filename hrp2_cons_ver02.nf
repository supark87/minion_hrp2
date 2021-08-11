
params.reads = params.input.fastq_path+'/*.fastq'
Channel
    .fromPath(params.reads)
    .map { file -> tuple(file.baseName, file) }
    .set{fastq_path}
Channel
    .fromPath(params.reads)
    .map { file -> tuple(file.baseName, file) }
    .set{fastq_path2}
    

params.genome = "$baseDir/ref/XM_002808697.2.fasta"
pyscripts="$baseDir/pyscripts"
ref_dir="$baseDir/ref"
process plot{
    container 'supark87/minion'
    publishDir "$params.output.folder/raw_summary/", mode : "copy"
    input:
    file("*") from fastq_path.collect()
    output:
        file("NanoStats.txt")
        file("LengthvsQualityScatterPlot_dot.png")
        file("Yield_By_Length.png")
        file("NanoPlot-report.html")
       
    script:
        """
        NanoPlot --fastq *fastq --plots dot hex
        """
}


process trim_nanofilt {
    container 'supark87/minion'
    publishDir "$params.output.folder/trimmedfastq/${id}", pattern: "*.fq", mode : "copy"
    
    input:
        tuple val(id), file(fastq_group) from fastq_path2
 
    output:
        set val(id), file("${id}_trimmed.fq") into trim_out1
     
    script:
        """
        
        NanoFilt  ${id}.fastq -l 1000 -q 10  > ${id}_trimmed.fq
       
        """



 }



process maptoreference {
    container 'supark87/minion'

    publishDir "$params.output.folder/samfiles/", pattern: "*.sam", mode : "copy"

      input:
  
        path(ref_dir) from ref_dir
        file("*") from trim_out1.collect()


       
    output:
       
       file("bowtie.sam") into sam

    script:
        """
     cat *.fq >> all.fq
     bowtie2-build-s $ref_dir/XM_002808697.2.fasta myIndex
     bowtie2-align-s -I 0 -X 800 -p 16 --fast --dovetail --met-file bmet.txt -x myIndex -U all.fq -S bowtie.sam


        """

}

process consensus{
    container 'supark87/minion'
    publishDir "$params.output.folder/cns/", pattern: "*.fastq", mode : "copy"
    
    input:
    file(samfile) from sam
    path(ref_dir) from ref_dir
    path(pyscripts_path) from pyscripts


    output:
    file("cns.fastq") into csn_seq
    script:
    """
     samtools view -S -b $samfile > bamfile1.bam
     samtools sort bamfile1.bam -o sorted.bam
     bcftools mpileup -Ou -f $ref_dir/XM_002808697.2.fasta sorted.bam | bcftools call -mv -Oz -o calls.vcf.gz
     bcftools index calls.vcf.gz
     bcftools norm -f $ref_dir/XM_002808697.2.fasta calls.vcf.gz -Ob -o calls.norm.bcf
     bcftools filter --IndelGap 5 calls.norm.bcf -Ob -o calls.norm.flt-indels.bcf
     cat $ref_dir/XM_002808697.2.fasta | bcftools consensus calls.vcf.gz > cns.fastq

    """
}


process translate {
    container 'supark87/minion'

    publishDir "$params.output.folder/translated_sequences/", mode : "copy"
    input:
        //file(assembly) from assemblyout
       file(cns_seq) from csn_seq


    output:
        file("final_reads.fasta") into translatedseq
        file("cons_reads.fasta")
    script:
        """
       seqret -sequence $cns_seq -outseq cons_reads.fasta
       transeq cons_reads.fasta final_reads.fasta
        """
}

process countpattern {

    container 'supark87/minion'

    publishDir "$params.output.folder/resultfiles/", mode : "copy"
    input:
        file(transfasta) from translatedseq
        path(pyscripts_path) from pyscripts

    output:
        file("results.csv")
    
    script:
        """
        python ${pyscripts_path}/hrp2_correctedpath.py ${transfasta} > results.csv
        """
}

