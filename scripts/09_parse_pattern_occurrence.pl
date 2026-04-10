#!/usr/bin/perl


my %SP_hash = ();


my @list = `cat data/processed/all.c100.pattern.crossNum.tsv`;
foreach my $list(@list) {
	chomp($list);
	if ($list =~ /Genome_ID/) {
#		$head = $list;
#		$head = $head . "\tAB\tEF\tKP\tPA\tSA";

#		my @temp = split(/\t/, $list);
#		print("$temp[92]\n");
		next;

	} else {
		my @temp = split(/\t/, $list);
#		print("$temp[92]\n");

		$species = $temp[93];
		$class_id = $temp[0];
		$cross_num = $temp[94];

		$SP_hash{$class_id}{"AB"}++ if($species eq "Acinetobacter baumannii");
		$SP_hash{$class_id}{"EF"}++ if($species eq "Enterococcus faecium");
		$SP_hash{$class_id}{"KP"}++ if($species eq "Klebsiella pneumoniae");
		$SP_hash{$class_id}{"PA"}++ if($species eq "Pseudomonas aeruginosa");
		$SP_hash{$class_id}{"SA"}++ if($species eq "Staphylococcus aureus");

#		last;

	}
}

#exit;

open(OUT, ">data/processed/all.c100.pattern.crossNum.occurrence.tsv");

my $head = "";

my @pattern_list = `cat data/processed/all.c100.pattern.crossNum.tsv`;
foreach my $pattern_list(@pattern_list) {
	chomp($pattern_list);
	if ($pattern_list =~ /Genome_ID/) {
		$head = $pattern_list;
		$head = $head . "\tAB\tEF\tKP\tPA\tSA";

#		my @temp = split(/\t/, $pattern_list);
#		print("$temp[93]\n");

		print OUT ("$head\n");

	} else {
		my @temp = split(/\t/, $pattern_list);

#		print("$temp[93]\n");

#		last;


		my $ClassID = $temp[0];

		$SP_hash{$ClassID}{'AB'} = 0 if($SP_hash{$ClassID}{'AB'} eq "");
		$SP_hash{$ClassID}{'EF'} = 0 if($SP_hash{$ClassID}{'EF'} eq "");
		$SP_hash{$ClassID}{'KP'} = 0 if($SP_hash{$ClassID}{'KP'} eq "");
		$SP_hash{$ClassID}{'PA'} = 0 if($SP_hash{$ClassID}{'PA'} eq "");
		$SP_hash{$ClassID}{'SA'} = 0 if($SP_hash{$ClassID}{'SA'} eq "");

		print OUT ("$pattern_list\t$SP_hash{$ClassID}{'AB'}\t$SP_hash{$ClassID}{'EF'}\t$SP_hash{$ClassID}{'KP'}\t$SP_hash{$ClassID}{'PA'}\t$SP_hash{$ClassID}{'SA'}\n");

	}

}

close(OUT);




