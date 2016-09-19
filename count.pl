#!/usr/bin/env perl 
 
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
	my %options;

	my %count;
	my $count;
	$options{percentage}=0;
	
	# validate input parameters

       my $result = GetOptions(
		"percentage=s"	=>	\$options{percentage},		
		"i|col=s"		=> 	\$options{col},
		"min=s"		=> 	\$options{min},
		"Max=s"	   	=>      \$options{max},
	);
	die "ERROR" if (!$result);


	######################################################
	
	while(<>)
	{
		chomp;
		next if(/^$/) ;                     
		my $key=$_;

		if(defined($options{col}))
		{
			my @f=split;
			$key=""; 
			$key=$f[$options{col}] if(defined($f[$options{col}]));
		}

		$count{$key}++;
		$count++;
	}

	##########################################################

	foreach my $key (sort {$count{$b}<=>$count{$a}} keys %count)
	{
		next if (defined($options{min}) and $count{$key}<$options{min});
		next if (defined($options{max}) and $count{$key}>$options{max});

                print $key,"\t", $count{$key};
                printf("\t%.4f",$count{$key}/$count) if($options{percentage});
                print "\n";
	}

	exit 0;
}
