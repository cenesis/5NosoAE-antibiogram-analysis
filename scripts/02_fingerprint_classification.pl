#!/usr/bin/perl

my $cluster_num = 0;
my %hash = ();

my @list = `cat data/processed/c_100.tsv`;

foreach my $list(@list) {
	chomp($list);

	if($list =~ /^Genome_ID/) {
		print ("$list\tClass_ID\n");
		next;
	}

	my @temp = split('\t', $list);
	pop(@temp);
	shift(@temp);

	my $string = join('', @temp);

	if($hash{$string} eq "") {
		$cluster_num++;
		$hash{$string} = $cluster_num;
		print ("$list\t$hash{$string}\n");
	} else {
		print ("$list\t$hash{$string}\n");
	}

}

