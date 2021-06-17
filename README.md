# minion_hrp2

1. Download docker containers for tools used in nextflow script
   In your terminal, pull docker containers using these command lines

` docker pull nanozoo/nanoplot `
` docker pull mcfonsecalab/nanofilt `
` docker pull alexeyebi/bowtie2_samtools `
` docker pull supark87/minion `
` docker pull pegi3s/emboss `
` docker pull supark87/tools `
` docker pull nextflow/nextflow `

2. Run nextflow script

` docker run -v /var/run/docker.sock:/var/run/docker.sock -v $PWD:$PWD -w $PWD -ti nextflow/nextflow nextflow hrp2_cons_multi.nf -c nextflowconfig.config  -with-docker container `
