#!/usr/bin/bash
#SBATCH -p short -N 1 -n 4 --mem 16gb  --out logs/astral.MP_score_%A.log

module load ASTRAL/5.14.3
CPU=$SLURM_CPUS_ON_NODE
if [ -z $CPU ]; then
	CPU=1
fi
NUM=$(wc -l expected_prefixes.lst | awk '{print $1}')
source config.txt
PHYLODIR=phylo
RUNDIR=ASTRAL
FTREE=$PHYLODIR/$PREFIX.${NUM}_taxa.$HMM.ft_lg.tre
INTREES=$RUNDIR/RAXML_gene_trees.tre
mkdir -p $RUNDIR
if [ ! -f $INTREES ]; then
	cat gene_trees/RAxML_bipartitions.* > $INTREES
fi
java -Djava.library.path=$ASTRALDIR/lib -jar $ASTRALDIR/native_library_tester.jar
time java -Djava.library.path=$ASTRALDIR/lib -jar $ASTRALJAR -q $FTREE -i $INTREES -o $RUNDIR/ASTRAL.FT_scored.tre -T $CPU
time java -Djava.library.path=$ASTRALDIR/lib -jar $ASTRALJAR -q $FTREE -i $INTREES -o $RUNDIR/ASTRAL.FT_scored-t2.tre -t 2 -T $CPU
time java -Djava.library.path=$ASTRALDIR/lib -jar $ASTRALJAR -q $FTREE -i $INTREES -o $RUNDIR/ASTRAL.FT_scored-t4.tre -t 4 -T $CPU
time java -Djava.library.path=$ASTRALDIR/lib -jar $ASTRALJAR -q $FTREE -i $INTREES -o $RUNDIR/ASTRAL.FT_scored-t8.tre -t 8 -T $CPU
time java -Djava.library.path=$ASTRALDIR/lib -jar $ASTRALJAR -q $FTREE -i $INTREES -o $RUNDIR/ASTRAL.FT_scored-t10.tre -t 10 -T $CPU

module unload perl
for f in $(ls $RUNDIR/ASTRAL.FT_scored*.tre | grep -v long)
do
	b=$(basename $f .tre)
	perl PHYling_unified/util/rename_tree_nodes.pl $f prefix.tab > $RUNDIR/${b}_long.tre 
done
