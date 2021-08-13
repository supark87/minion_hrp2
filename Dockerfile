FROM ubuntu:18.04 
COPY . /data/
WORKDIR /data/


RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git
RUN apt-get install -y wget
RUN apt-get update && apt-get install -y \
  curl \
  unzip \
  perl \
  openjdk-11-jre-headless
RUN apt-get update && apt-get install -y zlib1g-dev \
 bzip2 \
 libbz2-dev \
 liblzma-dev \
 libcurl4-gnutls-dev \
 libncurses5-dev \
 libssl-dev \
 python3 \
 python3-pip \
 python3-setuptools \
 locales && \
 locale-gen en_US.UTF-8 && \
 apt-get autoclean && rm -rf /var/lib/apt/lists/*
RUN python3 -m pip install -U pip
RUN pip3 install matplotlib==3.1.3 
RUN pip3 install NanoPlot==1.33.0


RUN pip3 install nanofilt
RUN curl -s https://get.nextflow.io | bash
#RUN apt install -y picard-tools
#RUN chmod +x ./nextflow
#RUN chmod 777 ./nextflow
#RUN mv nextflow /bin/
RUN apt-get update && apt-get install -y bowtie2
RUN apt-get install -y emboss
RUN wget https://github.com/samtools/samtools/releases/download/1.11/samtools-1.11.tar.bz2 && \
	tar jxf samtools-1.11.tar.bz2 && \
	rm samtools-1.11.tar.bz2 && \
	cd samtools-1.11 && \
	./configure --prefix $(pwd) && \
	make
RUN wget https://github.com/samtools/bcftools/releases/download/1.9/bcftools-1.9.tar.bz2 && \
	tar jxf bcftools-1.9.tar.bz2 && \
	rm bcftools-1.9.tar.bz2 && \
	cd bcftools-1.9 && \
	make install
RUN apt-get update && apt-get install -y locales
RUN locale-gen "en_US.UTF-8"
RUN update-locale LC_ALL="en_US.UTF-8"
ENV LANG="en_US.UTF-8"
ENV PATH=/data/samtools-1.11/:$PATH
