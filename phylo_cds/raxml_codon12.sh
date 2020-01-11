#!/usr/bin/bash
#SBATCH -N 1 -n 24 -p intel --out raxml.cds.%A.log --time 6-0:00:00 --mem 32gb

module load RAxML
CPU=$SLURM_CPUS_ON_NODE
NUM=$(wc -l ../expected_prefixes.lst | awk '{print $1}')
source ../config.txt

ALN=../$PREFIX.${NUM}_taxa.$HMM.cds.fasaln

if [ -z $OUT ]; then
	echo "need config with outgroup"
fi
if [ ! -f RAxML_info.$PREFIX.${NUM}.codon2_part_BEST ]; then
	raxmlHPC-PTHREADS-AVX2 -m GTRGAMMA -p 12345 -# 20 -o $OUT -T $CPU -q $PREFIX.${NUM}_taxa.codons.txt -n $PREFIX.${NUM}.codon2_part_BEST -s $ALN
fi
if [ ! -f RAxML_info.$PREFIX.${NUM}.codon2_part ]; then
	raxmlHPC-PTHREADS-AVX2 -T $CPU -x 227 -p 771 -o $OUT -m GTRGAMMA -s $ALN -n $PREFIX.${NUM}.codon2_part -q $PREFIX.${NUM}_taxa.codons.txt -# 100
fi

if [[ -f RAxML_bootstrap.$PREFIX.${NUM}.codon2_part && -f RAxML_bestTree.$PREFIX.${NUM}.codon2_part_BEST ]]; then
 raxmlHPC-PTHREADS-AVX2 -m GTRCAT -p 12345 -f b -t RAxML_bestTree.$PREFIX.${NUM}.codon2_part_BEST \
	 -z RAxML_bootstrap.$PREFIX.${NUM}.codon2_part -n $PREFIX.${NUM}.codon2_part_BOOTBEST
fi
