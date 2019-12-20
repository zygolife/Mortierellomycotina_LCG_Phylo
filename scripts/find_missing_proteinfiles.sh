#!/usr/bin/bash

for a in $(cut -d, -f 1 Mortierellaceae_BioProjects.csv | tail -n +2); 
do 
	if [ ! -f pep/$a ]; then  
		echo $a; 
	fi; 
done
