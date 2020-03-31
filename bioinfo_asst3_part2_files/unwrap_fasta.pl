# unwrap_fasta.pl
# Read a fasta file, unwrap the sequences 
# (i.e., remove all extra line breaks), 
# and save the result to an output file.
my $in_file = shift;
my $out_file = shift;
 
my %seq_hash; # key = seq_name, value = seq;
{
	# redefine the record separator
	local $/ = ">";
	open IN, "<$in_file";
	my $in_line = <IN>; # toss the first record
	while ( $in_line = <IN> ) {
		chomp $in_line; # remove the ">" character in the end 
		my ( $seq_name, $seq ) = split( /\n/, $in_line, 2 );
		$seq =~ tr/ \t\n\r//d;    # Remove whitespace
		$seq_hash{$seq_name} = uc $seq;
	}
	close IN;
}
 
open OUT, ">$out_file";
foreach my $seq_name ( sort keys %seq_hash ) {
	print OUT ">$seq_name\n$seq_hash{$seq_name}\n";
}
close OUT;