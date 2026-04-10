#/bin/bash

# Remove processed files
rm -rf data/processed/*.c100.pattern.tsv


# Compute the number of resistance patterns for each species
grep "Acinetobacter baumannii" data/processed/c_100_cluster.tsv | sort -t$'\t' -k94,94n -u > data/processed/Acinetobacter_baumannii.c100.pattern.tsv
(head -n 1 data/processed/c_100_cluster.tsv; cat data/processed/Acinetobacter_baumannii.c100.pattern.tsv) > tmp && mv tmp data/processed/Acinetobacter_baumannii.c100.pattern.tsv

grep "Enterococcus faecium" data/processed/c_100_cluster.tsv | sort -t$'\t' -k94,94n -u > data/processed/Enterococcus_faecium.c100.pattern.tsv
(head -n 1 data/processed/c_100_cluster.tsv; cat data/processed/Enterococcus_faecium.c100.pattern.tsv) > tmp && mv tmp data/processed/Enterococcus_faecium.c100.pattern.tsv

grep "Klebsiella pneumoniae" data/processed/c_100_cluster.tsv | sort -t$'\t' -k94,94n -u > data/processed/Klebsiella_pneumoniae.c100.pattern.tsv
(head -n 1 data/processed/c_100_cluster.tsv; cat data/processed/Klebsiella_pneumoniae.c100.pattern.tsv) > tmp && mv tmp data/processed/Klebsiella_pneumoniae.c100.pattern.tsv

grep "Pseudomonas aeruginosa" data/processed/c_100_cluster.tsv | sort -t$'\t' -k94,94n -u > data/processed/Pseudomonas_aeruginosa.c100.pattern.tsv
(head -n 1 data/processed/c_100_cluster.tsv; cat data/processed/Pseudomonas_aeruginosa.c100.pattern.tsv) > tmp && mv tmp data/processed/Pseudomonas_aeruginosa.c100.pattern.tsv

grep "Staphylococcus aureus" data/processed/c_100_cluster.tsv | sort -t$'\t' -k94,94n -u > data/processed/Staphylococcus_aureus.c100.pattern.tsv
(head -n 1 data/processed/c_100_cluster.tsv; cat data/processed/Staphylococcus_aureus.c100.pattern.tsv) > tmp && mv tmp data/processed/Staphylococcus_aureus.c100.pattern.tsv

printf "Number of resistance patterns for each species\n"
printf "Acinetobacter baumannii: "
grep -v "^Genome_ID" data/processed/Acinetobacter_baumannii.c100.pattern.tsv | wc | awk '{print $1}'

printf "Enterococcus faecium: "
grep -v "^Genome_ID" data/processed/Enterococcus_faecium.c100.pattern.tsv | wc | awk '{print $1}'

printf "Klebsiella pneumoniae: "
grep -v "^Genome_ID" data/processed/Klebsiella_pneumoniae.c100.pattern.tsv | wc | awk '{print $1}'

printf "Pseudomonas aeruginosa: "
grep -v "^Genome_ID" data/processed/Pseudomonas_aeruginosa.c100.pattern.tsv | wc | awk '{print $1}'

printf "Staphylococcus aureus: "
grep -v "^Genome_ID" data/processed/Staphylococcus_aureus.c100.pattern.tsv | wc | awk '{print $1}'


# Merge data from different species into a single file
cat data/processed/*.c100.pattern.tsv | grep -v "^Genome_ID" > data/processed/all.c100.pattern.tsv
(head -n 1 data/processed/c_100_cluster.tsv; cat data/processed/all.c100.pattern.tsv) > tmp && mv tmp data/processed/all.c100.pattern.tsv


# Compute the total number of unique resistance patterns after removing duplicates across all species
printf "\nThe total number of unique resistance patterns\n"
cat data/processed/all.c100.pattern.tsv | grep -v "^Genome_ID" | sort -t$'\t' -k94,94n -u | wc | awk '{print $1}'

printf "\n"

