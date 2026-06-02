#!/usr/bin/perl

# output files
#	query_antibiogram.tsv

my $resfinderProgramPath = "FULL_PATH_OF_ResFinder_PROGRAM";

my $resfinderDBPath = "FULL_PATH_OF_ResFinder_DATABASE";

use File::Basename;
my $programName = basename($0);

use FindBin;
my $programPath = $FindBin::Bin;

use Getopt::Long;
my $usage = "
Usage:    $programName -i input_file -o output_dir [-l align_coverage] [-t align_identity] [-p number_of_threads]

Arguments: -i  Input genome sequence file [String]
           -o  Output antibiogram profile directory [String]
           -l  Minimum (breadth-of) coverage of ResFinder within the 0-1 [Real]  Optional
             default = 0.4
           -t  Threshold for identity of ResFinder within the 0-1 [Real]  Optional
             default = 0.4
           -p  Number of threads [Integer]  Optional
             default = 1

Example: Antibiogram generation using 4 threads
         $programName -i ../data/example_assembly/GCA_000740515.1.fna -o ../data/example_antibiogram\n\n\n";


my $inPath = undef;
my $outPath = undef;
my $pident_cut = undef;
my $aligcov_cut = undef;
my $threads = undef;

die $usage unless GetOptions(
		'i|input_file=s'         => \$inPath,
        'o|output_dir=s'        => \$outPath,
        'l|aligcov=f'            => \$aligcov_cut,        
        't|pident=i'             => \$pident_cut,
        'p|threads=i'            => \$threads)
	&& defined $inPath
	&& defined $outPath
#	&& defined $aligcov_cut
#	&& defined $pident_cut
#	&& defined $threads
	&& @ARGV == 0;

$aligcov_cut = 0.4 if($aligcov_cut == undef);
$pident_cut = 0.4 if($pident_cut == undef);
$threads = 1 if($threads == undef);

#print("$dbPath\t$threads\n");

die "\nError in opening contig file $inPath\n\n" if(!-e $inPath);
#die "$!" if(!-e $inPath);

mkdir("$outPath", 0755) || die "$!" if(!-e "$outPath");

system("/usr/bin/python3 $resfinderProgramPath/run_resfinder.py -ifa $inPath -db_res $resfinderDBPath -l 0.4 -t 0.4 -o $outPath --acquired");


##### Parse Phenotype #####
my %id2ABs = ();
my %id2ABs_count = ();

my @list = `cat $programPath/phenotypes.txt`;
foreach my $list(@list) {
	chomp($list);
	next if($list =~ /^Gene_accession/);
#	print("$list\n");

	my @temp = split(/\t/, $list);
#	print("$temp[0]\n");
	
	$temp[0] =~ s/^\s+//g;
	$temp[0] =~ s/\s+$//g;

	my @tmp1 = split(/_[0-9]+_/, $temp[0]);
	my $allele_label = $tmp1[0]."_".$tmp1[1];

	my @tmp2 = split(/,/, $temp[2]);
	foreach my $tmp2(@tmp2) {
		$tmp2 =~ s/^\s+//g;
		$tmp2 =~ s/\s+$//g;
		$tmp2 =~ s/\s/_/g;
		$id2ABs_count{$allele_label}++;
		$id2ABs{$allele_label}[$id2ABs_count{$allele_label}] = $tmp2;
	}

#	print("$tmp1[1]\n");

#	last;
}


open(OUT1, ">$outPath/query_antibiogram.tsv");

print OUT1 ("Genome_ID");
my @ABs_array_classNum = qw(1.Gentamicin 1.Tobramycin 1.Streptomycin 1.Amikacin 1.Isepamicin 1.Dibekacin 1.Kanamycin 1.Neomycin 1.Lividomycin 1.Paromomycin 1.Ribostamycin 1.Butiromycin 1.Butirosin 1.Hygromycin 1.Netilmicin 1.Apramycin 1.Sisomicin 1.Arbekacin 1.Kasugamycin 1.Astromicin 1.Fortimicin 2.Spectinomycin 3.Fluoroquinolone 3.Ciprofloxacin 3.Nalidixic_acid 4.Amoxicillin 4.Amoxicillin+Clavulanic_acid 4.Ampicillin 4.Ampicillin+Clavulanic_acid 4.Cefepime 4.Cefixime 4.Cefotaxime 4.Cefoxitin 4.Ceftazidime 4.Ertapenem 4.Imipenem 4.Meropenem 4.Piperacillin 4.Piperacillin+Tazobactam 4.Aztreonam 4.Cefotaxime+Clavulanic_acid 4.Temocillin 4.Ticarcillin 4.Ceftazidime+Avibactam 4.Penicillin 4.Ceftriaxone 4.Ticarcillin+Clavulanic_acid 4.Cephalothin 4.Cephalotin 4.Piperacillin+Clavulanic_acid 5.Sulfamethoxazole 5.Trimethoprim 6.Fosfomycin 7.Vancomycin 7.Teicoplanin 8.Lincomycin 8.Clindamycin 9.Dalfopristin 9.Pristinamycin_IIA 9.Virginiamycin_M 9.Quinupristin+Dalfopristin 10.Tiamulin 11.Carbomycin 11.Erythromycin 11.Azithromycin 11.Oleandomycin 11.Spiramycin 11.Tylosin 11.Telithromycin 12.Tetracycline 12.Doxycycline 12.Minocycline 12.Tigecycline 13.Chloramphenicol 13.Florfenicol 14.Rifampicin 15.Quinupristin 15.Pristinamycin_IA 15.Virginiamycin_S 16.Linezolid 17.Colistin 18.Fusidic_acid 19.Mupirocin 20.Metronidazole 21.Formaldehyde 22.Benzylkonium_Chloride 22.Ethidium_Bromide 22.Chlorhexidine 22.Cetylpyridinium_Chloride 23.Hydrogen_peroxide 24.Temperature);
my @ABs_array = qw(Gentamicin Tobramycin Streptomycin Amikacin Isepamicin Dibekacin Kanamycin Neomycin Lividomycin Paromomycin Ribostamycin Butiromycin Butirosin Hygromycin Netilmicin Apramycin Sisomicin Arbekacin Kasugamycin Astromicin Fortimicin Spectinomycin Fluoroquinolone Ciprofloxacin Nalidixic_acid Amoxicillin Amoxicillin+Clavulanic_acid Ampicillin Ampicillin+Clavulanic_acid Cefepime Cefixime Cefotaxime Cefoxitin Ceftazidime Ertapenem Imipenem Meropenem Piperacillin Piperacillin+Tazobactam Aztreonam Cefotaxime+Clavulanic_acid Temocillin Ticarcillin Ceftazidime+Avibactam Penicillin Ceftriaxone Ticarcillin+Clavulanic_acid Cephalothin Cephalotin Piperacillin+Clavulanic_acid Sulfamethoxazole Trimethoprim Fosfomycin Vancomycin Teicoplanin Lincomycin Clindamycin Dalfopristin Pristinamycin_IIA Virginiamycin_M Quinupristin+Dalfopristin Tiamulin Carbomycin Erythromycin Azithromycin Oleandomycin Spiramycin Tylosin Telithromycin Tetracycline Doxycycline Minocycline Tigecycline Chloramphenicol Florfenicol Rifampicin Quinupristin Pristinamycin_IA Virginiamycin_S Linezolid Colistin Fusidic_acid Mupirocin Metronidazole Formaldehyde Benzylkonium_Chloride Ethidium_Bromide Chlorhexidine Cetylpyridinium_Chloride Hydrogen_peroxide Temperature);
foreach my $ABs_array_classNum (@ABs_array_classNum) {
  print OUT1 ("\t$ABs_array_classNum");
}
print OUT1 ("\n");

my %ABs_tmp = ();
my %query_table = (); #add
my %locus_similarity = (); # add
my %hit_antibiotic = (); # add
my @hit_antibiotic = (); # add
my %hit_locus = (); # add
my @hit_locus = (); #add
my %antibiotic2classNum = (Gentamicin => "1", Tobramycin => "1", Streptomycin => "1", Amikacin => "1", Isepamicin => "1", Dibekacin => "1", Kanamycin => "1", Neomycin => "1", Lividomycin => "1", Paromomycin => "1", Ribostamycin => "1", Butiromycin => "1", Butirosin => "1", Hygromycin => "1", Netilmicin => "1", Apramycin => "1", Sisomicin => "1", Arbekacin => "1", Kasugamycin => "1", Astromicin => "1", Fortimicin => "1", Spectinomycin => "2", Fluoroquinolone => "3", Ciprofloxacin => "3", Nalidixic_acid => "3", Amoxicillin => "4", "Amoxicillin+Clavulanic_acid" => "4", Ampicillin => "4", "Ampicillin+Clavulanic_acid" => "4", Cefepime => "4", Cefixime => "4", Cefotaxime => "4", Cefoxitin => "4", Ceftazidime => "4", Ertapenem => "4", Imipenem => "4", Meropenem => "4", Piperacillin => "4", "Piperacillin+Tazobactam" => "4", Aztreonam => "4", "Cefotaxime+Clavulanic_acid" => "4", Temocillin => "4", Ticarcillin => "4", "Ceftazidime+Avibactam" => "4", Penicillin => "4", Ceftriaxone => "4", "Ticarcillin+Clavulanic_acid" => "4", Cephalothin => "4", Cephalotin => "4", "Piperacillin+Clavulanic_acid" => "4", Sulfamethoxazole => "5", Trimethoprim => "5", Fosfomycin => "6", Vancomycin => "7", Teicoplanin => "7", Lincomycin => "8", Clindamycin => "8", Dalfopristin => "9", Pristinamycin_IIA => "9", Virginiamycin_M => "9", "Quinupristin+Dalfopristin" => "9", Tiamulin => "10", Carbomycin => "11", Erythromycin => "11", Azithromycin => "11", Oleandomycin => "11", Spiramycin => "11", Tylosin => "11", Telithromycin => "11", Tetracycline => "12", Doxycycline => "12", Minocycline => "12", Tigecycline => "12", Chloramphenicol => "13", Florfenicol => "13", Rifampicin => "14", Quinupristin => "15", Pristinamycin_IA => "15", Virginiamycin_S => "15", Linezolid => "16", Colistin => "17", Fusidic_acid => "18", Mupirocin => "19", Metronidazole => "20", Formaldehyde => "21", Benzylkonium_Chloride => "22", Ethidium_Bromide => "22", Chlorhexidine => "22", Cetylpyridinium_Chloride => "22", Hydrogen_peroxide => "23", Temperature => "24"); # add

my @ResFinder_results = `cat $outPath/ResFinder_results_tab.txt`;
foreach my $ResFinder_results(@ResFinder_results) {
	chomp($ResFinder_results);
	next if($ResFinder_results =~ /^Resistance gene/);
	my @temp = split(/\t/, $ResFinder_results);
	my $similarity = ($temp[1]+$temp[3])/2;
	$similarity = sprintf("%.3f", $similarity); 
	$temp[0] =~ s/^\s+//g;
	$temp[0] =~ s/\s+$//g;
	$temp[8] =~ s/^\s+//g;
	$temp[8] =~ s/\s+$//g;
	my $allele_label = $temp[0]."_".$temp[8];
	my $locus_label = $temp[0]; #add
#	print("$temp[1]\t$temp[3]\t$temp[8]\t$similarity\n");
	for($i=1;$i<=$id2ABs_count{$allele_label};$i++) {
		if($ABs_tmp{$id2ABs{$allele_label}[$i]} eq "" || $similarity > $ABs_tmp{$id2ABs{$allele_label}[$i]}) {
			$ABs_tmp{$id2ABs{$allele_label}[$i]} = $similarity;
		}
		$hit_antibiotic{$id2ABs{$allele_label}[$i]} = 1; # add
		$query_table{$locus_label}{$id2ABs{$allele_label}[$i]} = V; #add
	}

	if($locus_similarity{$locus_label} eq "" || $similarity > $locus_similarity{$locus_label}) {
		$locus_similarity{$locus_label} = $similarity; # add
	}
	if($hit_locus{$locus_label} eq "") {
		foreach my $ABs_array (@ABs_array) {
			if($query_table{$locus_label}{$ABs_array} eq "V") {
				push(@hit_locus, $locus_label); # add
				$hit_locus{$locus_label} = 1; # add
				last; # add
			}
		}
	}
}

print OUT1 ("Query");
foreach my $ABs_array (@ABs_array) {
	$ABs_tmp{$ABs_array} = 0 if($ABs_tmp{$ABs_array} eq "");
	print OUT1 ("\t$ABs_tmp{$ABs_array}");

	push(@hit_antibiotic, $ABs_array) if($hit_antibiotic{$ABs_array} == 1); # add

}
print OUT1 ("\n");

close(OUT1);

############


