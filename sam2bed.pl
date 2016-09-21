#!/usr/bin/perl -w
 
use strict;
use warnings;

use Getopt::Long;

# help info
my $HELPTEXT = qq~
Program that ...

Usage: PRG file [options]
	  
  INPUT:   
  
  file:	
  
  options:

	-h|help		- Print this help and exit;
	-V|version	- Print the version and exit;
	-depend		- Print the program and database dependency list;
	-debug <level>	- Set the debug <level> (0, non-debug by default); 
 
  OUTPUT:  
~;

my $MOREHELP = qq~
Return Codes:   0 - on success, 1 - on failure.
~;


###############################################################################
#
# Main program
#
###############################################################################

MAIN:
{
	# define variables
	my %options;
	my %len;

  my $result = GetOptions(
		"addSuffix"	=> \$options{addSuffix},
		"qry"		=> \$options{qry}
	);
	die "ERROR" if (!$result);	

	####################################
	
	while(<>)
	{
		# sam > bed

		# 0                   1   2          3        4    5    6  7  8  9                                     10                                    11...		
		# SRR022906.1.1       0   NC_000913  4579753  255  36M  *  0  0  TGGTCGGTGTTTTTGTTCTCTTCGCTGTCTGCCACT  IIIIIIIDIIIIII1IIIIIIIIIII%III?I&8II  XA:i:0  MD:Z:29G2A3         NM:i:2  
		# =>
		# NC_000913 4579753 4579788 NC_000913:4579753-4579788

		my ($ref,$begin,$end,$cigar,$qry,$score,$strand);

		if(/^\@SQ\s+SN:(\S+)\s+LN:(\S+)/)
		{
			$len{$1}=$2;
			next;
		}
		elsif(/^\@/)
    {
       next;
    }


		my @f=split;
		next if($f[1] & 0x4 );
		next if($options{mated} and !($f[1] & 0x2) );
		next if($f[2] eq "*");
		next if($f[1] and $f[1] & 0x100  ) ;  #secondary alignment

		$qry=$f[0];
                if($options{addSuffix})
                {
                        $qry=$qry."/1" if($f[1] & 0x40);
                        $qry=$qry."/2" if($f[1] & 0x80);
                }

                $strand=($f[1] & 0x10 )?"-":"+";
		$ref=$f[2];	

		$score=0;
		$cigar=$f[5];

		if(!$options{qry})
		{
			$begin=$end=$f[3]-1;
		        while($cigar and $cigar=~/(\d+)(\w)(.*)/)
        		{                	        
				$score+=$1 if($2 eq "M");
				$end+=$1 if($2 eq "M" or $2 eq "D") ;
				$cigar=$3;
        		}
		}
		else
		{
			($ref,$qry)=($qry,$ref);
			$begin=$end=0;

			my $qry_dir=($f[1] & 0x10 )?"-":"+";
			if($qry_dir eq "+")
			{

				$begin=$end=$1 if($cigar=~/^(\d+)[HS]/);
	
        	                while($cigar and $cigar=~/(\d+)(\w)(.*)/)
                	        {
                        	        $score+=$1 if($2 eq "M");
                                	$end+=$1 if($2 eq "M" or $2 eq "I") ;
	                                $cigar=$3;
        	                }
			}
			else
			{
				$begin=$end=$1 if($cigar=~/(\d+)[HS]$/);

                                while($cigar and $cigar=~/(.*?)(\d+)(\w)$/)
                               	{
                                        $score+=$2 if($3 eq "M");
                                        $end+=$2 if($3 eq "M" or $3 eq "I") ;
                                        $cigar=$1;
                               	}
			}
		}

		my $len=$end-$begin;
    
    /\s+NM:i:(\d+)\s+/ or die "ERROR: $_";
		my $pid=int(($len-$1)*10000/$len+.5)/100;
		$score="$score:$pid";
		#$score=$pid;

	  print join "\t",($ref,$begin,$end,$qry,$score,$strand);
    print "\n";
	}
	
	exit 0;
}
