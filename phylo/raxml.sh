#!/usr/bin/bash
#SBATCH -p intel -n 24 -N 1 --mem 32gb --out raxml.protein.log

CPU=1
if [ $SLURM_CPUS_ON_NODE ]; then
    CPU=$SLURM_CPUS_ON_NODE
fi
module load RAxML

module unload miniconda2
module unload miniconda3
module load perl
source ../config.txt

if [ -z $OUT ]; then
	echo "need config with outgroup"
fi
NUM=$(wc -l ../expected_prefixes.lst | awk '{print $1}')
ALN=../$PREFIX.${NUM}_taxa.$HMM.aa.fasaln
raxmlHPC-PTHREADS-AVX2 -f a -m PROTGAMMAAUTO -# autoMRE -T $CPU -s $ALN -o $OUT -n $PREFIX.${NUM}_taxa.RAPIDBS -x 1217 -p 1331

