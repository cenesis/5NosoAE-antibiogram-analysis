# 5NosoAE Antibiogram Analysis Pipeline

## Overview

This repository provides a reproducible workflow for analyzing large-scale antibiogram data from the 5NosoAE platform, focusing on five major nosocomial pathogens:

* *Acinetobacter baumannii*
* *Enterococcus faecium*
* *Klebsiella pneumoniae*
* *Pseudomonas aeruginosa*
* *Staphylococcus aureus*

The pipeline integrates genomic metadata, antibiotic resistance profiles, and global epidemiological data to characterize resistance patterns, cross-species resistance fingerprints, and their spatial-temporal distributions.

---

## Input Data

* `All.assembly_SRA_species.tsv`: species annotation
* `All.assembly_SRA.biosample`: metadata including geographic and temporal information

---

## Workflow

### Step 1. Resistance fingerprint construction

* Generate antibiogram matrix (isolate × (antibiotics + species))

```bash
perl scripts/01_fingerprint_construction.pl > data/processed/c_100.tsv
```

---

### Step 2. Resistance fingerprint classification

* Add fingerprint class number (isolate × (antibiotics + class_number))

```bash
perl scripts/02_fingerprint_classification.pl > data/processed/c_100_cluster.tsv
```

---

### Step 3. Statistical analysis (Resistance fingerprint patterns)

* Compute the number of resistance patterns for each species, as well as the total number of unique resistance patterns after removing duplicates across all species

```bash
bash scripts/03_statistical_analysis.sh
```

---

### Step 4. Statistical analysis (Co-occurrence fingerprint patterns)

* Compute, for each species, the number of co-occurring resistance patterns and the number of isolates that exhibit these patterns

```bash
bash scripts/04_statistical_analysis_co-occurrence.sh
```

---

### Step 5. Statistical analysis & visualization of antibiotic frequency

* Compute the frequency of resistance to each antibiotic across different species

```bash
perl scripts/05_statistical_analysis_antibiotic_frequency.pl > results/tables/antibiotic_frequency.c100.tsv
```

* Generate heatmaps

```bash
Rscript scripts/06_heatmap_count_c100.R
```

```bash
Rscript scripts/07_heatmap_frequency_c100.R
```

---

### Step 6. Heatmap and frequency distribution of antibiotic resistance fingerprints

* Visualize the heatmap and frequency distribution of antibiotic resistance fingerprints across the five major nosocomial pathogens

```bash
Rscript scripts/08_heatmap_all_species_pattern.R
```

---

<<<<<<< HEAD
### Step 7. Statistical analysis & visualization

| Analysis                      | Script                              |
| ----------------------------- | ----------------------------------- |
| Heatmaps (counts & frequency) | 06_heatmap_count_c100.R             |
|                               | 07_heatmap_frequency_c100.R         |
| Resistance fingerprints       | 03_resistance_profile.R             |
| Venn analysis                 | 05_venn_analysis.R                  |
| Cross-species analysis        | 06_cross_species_analysis.R         |
| Temporal & regional analysis  | 07_temporal_geographical_analysis.R |
| Global maps                   | 08_visualization_maps.R             |

---

## Outputs

### Tables

* Table 1: Distribution of isolates and antibiogram patterns

### Figures

* Figure 1: Global distribution maps
* Figure 2–3: Heatmaps of antibiotic counts and frequencies
* Figure 4: Resistance fingerprint heatmap and frequency
* Figure 5: Venn diagram of resistance profiles
* Figure 6: Cross-species resistance heatmap
* Figure 7: Temporal and regional distribution
* Figure 8: Global distribution of cross-species resistance

---

## Citation

If you use this pipeline, please cite our study.

=======
## Citation

If you use the 5NosoAE pipeline or associated resources, please cite:

Chen, C.-C., Liu, Y.-Y., Yang, Y.-C., & Hsu, C.-Y. (2022).  
5NosoAE: a web server for nosocomial bacterial antibiogram investigation and epidemiological survey.  
*Nucleic Acids Research*, 50(W1), W21–W28.  
https://doi.org/10.1093/nar/gkac423
>>>>>>> 60d3780 (update README.md)
