#!/usr/bin/bash
#SBATCH --ntasks 32 --mem 48G --time 2:00:00 -p short -N 1

module load hmmer/3
module load python/3
module load parallel
module unload perl
if [ ! -f config.txt ]; then
	echo "Need config.txt for PHYling"
	exit
fi

source config.txt
if [ ! -z $PREFIX ]; then
	rm -rf aln/$PREFIX
fi
# probably should check to see if allseq is newer than newest file in the folder?

./PHYling_unified/PHYling init
./PHYling_unified/PHYling search -q parallel
./PHYling_unified/PHYling aln -c -q parallel
pushd phylo
sbatch --time 2:00:00 -p short fast_run.sh
