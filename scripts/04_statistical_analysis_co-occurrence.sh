#/bin/bash

# Add co-occurrence number to resistance patterns file (all.c100.pattern.tsv)
join -t$'\t' -a 1 -1 94 -2 2 <(grep -v "Genome_ID" data/processed/all.c100.pattern.tsv | sort -t$'\t' -k94,94n) <(grep -v "Genome_ID" data/processed/all.c100.pattern.tsv | sort -t$'\t' -k94,94n | awk -F$'\t' '{print $94}' | uniq -c | sed -E 's/^[[:space:]]+//g' | sed -E 's/[[:space:]]+/\t/g') > data/processed/all.c100.pattern.crossNum.tsv
(printf "Class_ID\t"; head -n 1 data/processed/all.c100.pattern.tsv | sed 's/Class_ID/Cross_num/g'; cat data/processed/all.c100.pattern.crossNum.tsv) > tmp && mv tmp data/processed/all.c100.pattern.crossNum.tsv

# Compute the number of co-occurring resistance patterns
printf "Number of co-occurring resistance patterns for each species\n"
printf "Acinetobacter baumannii: "
grep "Acinetobacter baumannii" data/processed/all.c100.pattern.crossNum.tsv | awk -F'\t' '{if($95>=2) {print $0}}' | wc | awk '{print $1}'

printf "Enterococcus faecium: "
grep "Enterococcus faecium" data/processed/all.c100.pattern.crossNum.tsv | awk -F'\t' '{if($95>=2) {print $0}}' | wc | awk '{print $1}'

printf "Klebsiella pneumoniae: "
grep "Klebsiella pneumoniae" data/processed/all.c100.pattern.crossNum.tsv | awk -F'\t' '{if($95>=2) {print $0}}' | wc | awk '{print $1}'

printf "Pseudomonas aeruginosa: "
grep "Pseudomonas aeruginosa" data/processed/all.c100.pattern.crossNum.tsv | awk -F'\t' '{if($95>=2) {print $0}}' | wc | awk '{print $1}'

printf "Staphylococcus aureus: "
grep "Staphylococcus aureus" data/processed/all.c100.pattern.crossNum.tsv | awk -F'\t' '{if($95>=2) {print $0}}' | wc | awk '{print $1}'


# Compute the total number of co-occurring resistance patterns after removing duplicates across all species
printf "\nThe total number of co-occurring resistance patterns after removing duplicates across all species\n"
cat data/processed/all.c100.pattern.crossNum.tsv | grep -v "^Class_ID" | sort -t$'\t' -k1,1n -u | awk -F'\t' '{if($95>=2) {print $0}}' | wc | awk '{print $1}'

printf "\n"



# Add co-occurrence number to resistance fingerprint file (c_100_cluster.tsv)
join -t$'\t' -a 1 -1 94 -2 2 <(grep -v "Genome_ID" data/processed/c_100_cluster.tsv | sort -t$'\t' -k94,94n) <(grep -v "Genome_ID" data/processed/all.c100.pattern.tsv | sort -t$'\t' -k94,94n | awk -F$'\t' '{print $94}' | uniq -c | sed -E 's/^[[:space:]]+//g' | sed -E 's/[[:space:]]+/\t/g') > data/processed/c_100_cluster.crossNum.tsv
(printf "Class_ID\t"; head -n 1 data/processed/all.c100.pattern.tsv | sed 's/Class_ID/Cross_num/g'; cat data/processed/c_100_cluster.crossNum.tsv) > tmp && mv tmp data/processed/c_100_cluster.crossNum.tsv


# Compute the number of isolates exhibiting co-occurring resistance patterns
printf "Number of isolates exhibiting co-occurring resistance patterns for each species\n"
printf "Acinetobacter baumannii: "
grep "Acinetobacter baumannii" data/processed/c_100_cluster.crossNum.tsv | awk -F'\t' '{if($95>=2) {print $0}}' | wc | awk '{print $1}'

printf "Enterococcus faecium: "
grep "Enterococcus faecium" data/processed/c_100_cluster.crossNum.tsv | awk -F'\t' '{if($95>=2) {print $0}}' | wc | awk '{print $1}'

printf "Klebsiella pneumoniae: "
grep "Klebsiella pneumoniae" data/processed/c_100_cluster.crossNum.tsv | awk -F'\t' '{if($95>=2) {print $0}}' | wc | awk '{print $1}'

printf "Pseudomonas aeruginosa: "
grep "Pseudomonas aeruginosa" data/processed/c_100_cluster.crossNum.tsv | awk -F'\t' '{if($95>=2) {print $0}}' | wc | awk '{print $1}'

printf "Staphylococcus aureus: "
grep "Staphylococcus aureus" data/processed/c_100_cluster.crossNum.tsv | awk -F'\t' '{if($95>=2) {print $0}}' | wc | awk '{print $1}'


# Compute the total number of isolates exhibiting co-occurring resistance patterns
printf "\nThe total number of isolates exhibiting co-occurring resistance patterns\n"
cat data/processed/c_100_cluster.crossNum.tsv | grep -v "^Class_ID" |  awk -F'\t' '{if($95>=2) {print $0}}' | wc | awk '{print $1}'

printf "\n"

