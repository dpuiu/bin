#!/usr/bin/env perl
 
use strict;
use warnings;
use Getopt::Long;

MAIN:
{
	# define variables
	my %opt;
	
        my $result = GetOptions(
                "file=s" 	=> \$opt{file},
        );
        die "ERROR: $! " if (!$result);

	print "##fileformat=VCFv4.2\n";
	while(<>)
	{
		#IN
		#col#:   0     1 2   3         4      5        6    7    8    9  10 11 12 13         14	
		#        711   T C   1253      |      181      711  |    0    0  |  1  1  Chr1       CM004359.1

                #OUT
		#col#:   0     1   2   3 	       4      5        6      7    
                #        CHROM POS ID  REF             ALT   QUAL      FILTER INFO

		my @F=split;
		next unless(@F==15);
		
		my $qual=100;
		print join "\t",($F[13],$F[0],".",$F[1],$F[2],$qual);  			#".","DP=20;"); 
		print "\n";
	}
			
	exit 0;
}
