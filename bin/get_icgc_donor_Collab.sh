#!/bin/bash

donor=$1
tumor=$2
normal=$3

base_dir=$(dirname $(dirname $(readlink -f bin/get_gnos_donor.sh)))
data_dir="$base_dir/data"
donor_dir="$data_dir/$donor"
tmp_dir="$data_dir/tmp/"
tumor_tmp="$tmp_dir/$donor/tumor"
normal_tmp="$tmp_dir/$donor/normal"

mkdir -p $tumor_tmp
mkdir -p $normal_tmp
mkdir -p $donor_dir

docker pull icgc/icgc-storage-client:latest
echo "Downloading tumor data for $donor. Tumor: $tumor - Normal: $normal"

echo "Downloading tumor BAM: $tumor"
docker run --rm -v $PWD/logs:/icgc/icgc-storage-client/logs -v $PWD:/data -v /root/PCAWG-Docker-Test/icgc-storage-client-1.0.21/conf/application.properties:/icgc/icgc-storage-client/conf/application.properties --privileged icgc/icgc-storage-client bin/icgc-storage-client --profile collab download --object-id $tumor --output-dir /data
mv $tumor_tmp/*.bam/* "$donor_dir/tumor.bam"
mv $tumor_tmp/*.bam.bai/* "$donor_dir/tumor.bam.bai"
mv $tumor_tmp/*.bam.bas/* "$donor_dir/tumor.bam.bas"

echo "Downloading normal BAM: $normal"
docker run --rm -v $PWD/logs:/icgc/icgc-storage-client/logs -v $PWD:/data -v /root/PCAWG-Docker-Test/icgc-storage-client-1.0.21/conf/application.properties:/icgc/icgc-storage-client/conf/application.properties --privileged icgc/icgc-storage-client bin/icgc-storage-client --profile collab download --object-id $normal --output-dir /data
mv $normal_tmp/*.bam/* "$donor_dir/normal.bam"
mv $normal_tmp/*.bam.bai/* "$donor_dir/normal.bam.bai"
mv $normal_tmp/*.bam.bas/* "$donor_dir/normal.bam.bas"
