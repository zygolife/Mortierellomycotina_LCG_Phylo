#!/usr/bin/bash

pushd pep
for file in  $(ls ../annotate/*/annotate_results/*.proteins.fa ); 
do 
	b=$(basename $file .proteins.fa | perl -p -e 's/__/_/'); 
	if [ ! -f $b.aa.fasta ]; then
		ln -s $file $b.aa.fasta; 
		perl -i -p -e 's/>([^_]+)_/>$1|$1_/' $b.aa.fasta
	fi
done
popd
