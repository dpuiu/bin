#!/usr/bin/perl -w

use strict;
use Getopt::Long;

my $k=18;	# scalar
my %count;      # hash

#############################################################################

sub countSeqKmers
{
	my ($seq)=@_;

	if($seq)
	{
		$seq=~tr/acgtn/ACGTN/;
		my $len=length($seq);
		foreach my $i (0..$len-$k)
                {
                        my $kmer=substr($seq,$i,$k);
	
                        my $revKmer=$kmer;
                        $revKmer=~tr/ACGT/TGCATGCA/;
                        $revKmer=join "",reverse(split //,$revKmer);

                        $kmer=$revKmer if($kmer gt $revKmer);
                        $count{$kmer}++;
                }
        }
}

sub printKmers
{
	my @kmers=keys %count;	 # list
        foreach my $kmer (@kmers)
        {
                print $kmer," ",$count{$kmer},"\n" ;
        }
}	
		
###############################################################################
#             
# Main program       
#
###############################################################################

MAIN:         
{
	my $seq;				# scalar

	# parse command line arguments
	my $result = GetOptions(
                "k=i" 	=> \$k,
        );
        die "ERROR: $! " if (!$result or $k<=0);

	####################	
	# read STDIN (one line at a time; $_ variable)	
	while (<>)
    	{       
		chomp;

		if(/^>/)
		{
			countSeqKmers($seq);
			$seq="";	
		}
		else
		{
			$seq.=$_;
		}
	}
	#process last seq
	countSeqKmers($seq);

	#print kmers
	printKmers();
	
	exit 0; 
}
