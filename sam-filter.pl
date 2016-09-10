#!/usr/bin/perl -w

use strict;
use Getopt::Long;

###############################################################################
#             
# Main program       
#
###############################################################################

MAIN:         
{
	my %options;

	my $result = GetOptions(	
		"min_score=s"           => \$options{min_score},
		"min_len=s"             => \$options{min_len},
		"min_pc=s"		=> \$options{min_pc},
		"nh"			=> \$options{nh},
		);
	die "ERROR: $! " if (!$result);
			   
	###########################################

	while(<>)
	{
		if(/^@/) 
		{
			print $_ unless($options{nh}) ;
		}
		elsif(/^\[/) 
		{ 
			next ;
		}
		else
		{
        	        my @F=split /\t/;	
		        next if($F[1] & 0x4);
		
			my $score=$F[4];
			next if($options{min_score} and $score<$options{min_score});
		
			if($options{min_pc} or $options{min_len})
			{
				my $len=0;				
				my $cigar=$F[5];
        		        while($cigar and $cigar=~/(\d+)(\w)(.*)/)
                		{
                       			$len+=$1 if($2 eq "M" or $2 eq "D") ;
	        	                $cigar=$3;
		                }
	
				next if($options{min_len} and $len<$options{min_len});

		                $F[11]=~/NM:i:(\d+)/ or die "ERROR: $_";
		                my $pc=($len-$1)*100/$len;
	        	        next if($options{min_pc} and $pc<$options{min_pc});
			}

			print $_;
		}
	}
     					
	exit 0;
}
