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

	$options{i}=0;
	$options{j}=1;

	# validate input parameters
        my $result = GetOptions(
		"i=s"		=> 	\$options{i},
		"j=s"           =>      \$options{j},
		"min=s"		=> 	\$options{min},
		"Max=s"	   	=>      \$options{max},
	);
	die "ERROR" if (!$result);


	######################################################
	
	while(<>)
	{
		chomp;
		next if(/^$/) ;                     
		my @f=split;

		my $key=$f[$options{i}];
		my $val=$f[$options{j}];
			
		$count{$key}+=$val;
	}

	##########################################################

	foreach my $key (sort {$count{$b}<=>$count{$a}} keys %count)
	{
		next if (defined($options{min}) and $count{$key}<$options{min});
		next if (defined($options{max}) and $count{$key}>$options{max});

                print $key,"\t", $count{$key};
                print "\n";
	}

	exit 0;
}
