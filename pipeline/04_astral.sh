#!/usr/bin/bash
#SBATCH -p short -N 1 -n 2 --mem 16gb  --out logs/astral.MP_%A.log

module load ASTRAL/5.14.3
module unload perl

RUNDIR=ASTRAL
INTREES=$RUNDIR/RAXML_gene_trees.tre
mkdir -p $RUNDIR
if [ ! -f $INTREES ]; then
	cat gene_trees/RAxML_bipartitions.* > $INTREES
fi
if [ ! -f $RUNDIR/ASTRAL.consensus.tre ]; then
	time java -Djava.library.path=$ASTRALDIR/lib -jar $ASTRALJAR -i $INTREES -o $RUNDIR/ASTRAL.consensus.tre
fi
if [ ! -f $RUNDIR/ASTRAL.consensus_long.tre ]; then
perl PHYling_unified/util/rename_tree_nodes.pl $RUNDIR/ASTRAL.consensus.tre prefix.tab > $RUNDIR/ASTRAL.consensus_long.tre
fi
