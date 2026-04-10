#!/usr/bin/perl
my $count = 0;

my @list = `cat data/raw/All.assembly_SRA_species.tsv`;
foreach my $list(@list) {
	chomp($list);
	my $string = "";
	$count++;
	if($list =~ /^Genome_ID/) {
#		print("$list\n");
		$string = $string . "$list\n";
		print("$string");

	} else {
		my @temp = split('\t', $list);
		my $sum = 0;
		my $n = @temp;
		for($i=0;$i<$n;$i++) {
			if($i==0) {
#				print("$temp[0]");
				$string = $string . "$temp[0]";
			} elsif ($i>0 && $i<92) {
				if($temp[$i] >= 100) {
#					print("\t1");
					$string = $string . "\t1";
					$sum = $sum + 1;
				} else {
#					print("\t0");
					$string = $string . "\t0";
				}
			} elsif ($i == 92) {
				if($temp[$i] eq "Acinetobacter baumannii") {
#					print("\tAB");
#					$string = $string . "\tAB";
					$string = $string . "\tAcinetobacter baumannii";
				} elsif($temp[$i] eq "Enterococcus faecium") {
#					print("\tEF");
#					$string = $string . "\tEF";
					$string = $string . "\tEnterococcus faecium";
				} elsif($temp[$i] eq "Klebsiella pneumoniae") {
#					print("\tKP");
#					$string = $string . "\tKP";
					$string = $string . "\tKlebsiella pneumoniae";
				} elsif($temp[$i] eq "Pseudomonas aeruginosa") {
#					print("\tPA");
#					$string = $string . "\tPA";
					$string = $string . "\tPseudomonas aeruginosa";
				} elsif($temp[$i] eq "Staphylococcus aureus") {
#					print("\tSA");
#					$string = $string . "\tSA";
					$string = $string . "\tStaphylococcus aureus";
				}

			}

		}
#		print("\n");
		$string = $string . "\n";
		print("$string") if ($sum > 0);
	}
#	last if($count == 3);
}


