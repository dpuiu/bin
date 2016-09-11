#!/usr/bin/perl -w
 
use strict;
use warnings;
use Getopt::Long;

###############################################################################
#
# Main program
#
###############################################################################

MAIN:
{
	my $i=0;
	my $i2;
	my $j=0;	 
	my %h;
	my $filter;
	my $ignoreVersion;
	my $s='\s+';
	
	# validate input parameters
        my $result = GetOptions(
		"i=i"	=> \$i,
		"i2=i"	=> \$i2,
		"j=i"	=> \$j,
		"f=s"	=> \$filter,
		"s=s"	=>\$s,
		"ignoreVersion"	=> \$ignoreVersion
		
	);

	die "ERROR: $! " if (!$result);
	
	#########################################
	
	if(defined($filter)) { open(FILTER,$filter)  or die("ERROR: Cannot open input file".$!) ; }
	else                 { open(FILTER,$ARGV[1]) or die("ERROR: Cannot open input file".$!) ; }
	
	while(<FILTER>)
	{
    		my @f=split /$s/;
		shift @f if(@f and $f[0] eq "");

		next unless(defined($f[$j])); 

		$f[$j]=$1 if($ignoreVersion and $f[$j]=~/(.+)\.\d+$/);		
    		$h{$f[$j]}=1;
	}
	close(FILTER);
	last unless(%h);

	#########################################
	
	open(STDIN,$ARGV[0]) or die("ERROR: Cannot open input file".$!) ;	
	
	while(<STDIN>)
	{
		chomp;

    		my @f=split /$s/;
		shift @f if(@f and $f[0] eq "");

		next if(!defined($f[$i]));
		next if(defined($i2) and !defined($f[$i2]));	
		$f[$i]=$1 if($ignoreVersion and $f[$i]=~/(.+)\.\d+$/);
    		if(defined($h{$f[$i]})) { print $_,"\n" }
	}
	
	exit 0;
}
