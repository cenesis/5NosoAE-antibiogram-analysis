#!/usr/bin/perl
my $count = 0;

my @num2name = ();
my %name2num = ();
my %hash_db = ();

my @list = `cat data/processed/c_100.tsv`;
foreach my $list(@list) {
	chomp($list);
	my @temp = split('\t', $list);

	if($list =~ /^Genome_ID/) {

		for($i=1;$i<=91;$i++) {
			$num2name[$i] = $temp[$i];
			$name2num{$temp[$i]} = $i;
		}

	} else {

		$temp[92] = "A. baumannii" if($temp[92] eq "Acinetobacter baumannii");
		$temp[92] = "E. faecium" if($temp[92] eq "Enterococcus faecium");
		$temp[92] = "K. pneumoniae" if($temp[92] eq "Klebsiella pneumoniae");
		$temp[92] = "P. aeruginosa" if($temp[92] eq "Pseudomonas aeruginosa");
		$temp[92] = "S. aureus" if($temp[92] eq "Staphylococcus aureus");

		for($i=1;$i<=91;$i++) {
			$hash_db{$temp[92]}{$num2name[$i]} = $hash_db{$temp[92]}{$num2name[$i]} + $temp[$i];
		}
	
	}
}


print("Species");
for($i=1;$i<=91;$i++) {
	print("\t$num2name[$i]");
}
print("\n");

print("A. baumannii");
for($i=1;$i<=91;$i++) {
	print("\t$hash_db{'A. baumannii'}{$num2name[$i]}");
}
print("\n");

print("E. faecium");
for($i=1;$i<=91;$i++) {
	print("\t$hash_db{'E. faecium'}{$num2name[$i]}");
}
print("\n");

print("K. pneumoniae");
for($i=1;$i<=91;$i++) {
	print("\t$hash_db{'K. pneumoniae'}{$num2name[$i]}");
}
print("\n");

print("P. aeruginosa");
for($i=1;$i<=91;$i++) {
	print("\t$hash_db{'P. aeruginosa'}{$num2name[$i]}");
}
print("\n");

print("S. aureus");
for($i=1;$i<=91;$i++) {
	print("\t$hash_db{'S. aureus'}{$num2name[$i]}");
}
print("\n");

