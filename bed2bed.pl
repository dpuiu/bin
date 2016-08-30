#!/usr/bin/env perl
 
use strict;
use warnings;
use Getopt::Long;

# help info
my $HELPTEXT = qq~
Program that c...

Usage: $0 files [options]
	  
  INPUT:   
  
  files:	
  
  options:
 
  OUTPUT:  
~;

###############################################################################
#
# Main program
#
###############################################################################

MAIN:
{
	# define variables
	my %opt;
	$opt{S}=".";
	
        my $result = GetOptions(
		"min=i"	=>	\$opt{min},
		"-1"	=>      \$opt{-1},
		"S=s"	=>	\$opt{S},
		"N"	=>	\$opt{N}
        );
        die "ERROR: $HELPTEXT " if (!$result);

	while(<>)
	{
		next if(/^$/ or /^#/);

		my @F=split;
		die "ERROR: $_" if(@F<3);

		push @F,"$F[0]:$F[1]-$F[2]" if(@F==3); 
		push @F,$F[2]-$F[1] if(@F==4);
		push @F,$opt{S} if(@F==5); 
		$F[4]=$F[2]-$F[1];
		$F[4]-- if($opt{-1});
		$F[3]="." if($opt{N});

		next if($opt{min} and $F[4]<$opt{min});
		print join "\t",@F[0..5]; print "\n";
	}
			
	exit 0;
}
