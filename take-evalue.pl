use strict; use warnings;

my $line;
my @array;
my $flag;
my @store;
my $i;

if(@ARGV!=2)
{
	print "perl $0 blast_result  output\n";
	exit;
}

for($i=0;$i<=7;$i++)
{
	$store[$i]=0;
}

open(IN,"gzip -dc $ARGV[0] |") or die "$ARGV[0]\n";
while(<IN>)
{
	$line=$_;
	if($line=~/^\# Query/)
	{
		$flag=0;
		next;
	}
	if($line=~/^gi\|\d+/&&$flag==0)
	{
		$flag=1;
		@array=split("\t",$line);
		if($array[10]>=1e-04)
		{
			$i=0;
		}
		elsif($array[10]>=1e-05)
                {
                        $i=1;
                }
		elsif($array[10]>=1e-06)
                {
                        $i=2;
                }
		elsif($array[10]>=1e-07)
                {
                        $i=3;
                }
		elsif($array[10]>=1e-08)
                {
                        $i=4;
                }
		elsif($array[10]>=1e-09)
                {
                        $i=5;
                }
		elsif($array[10]>=1e-10)
                {
                        $i=6;
                }
		else
		{
			$i=7;
		}
		$store[$i]++;
	}
}
close IN;

open(OUT,">$ARGV[1]") or die "can't create $ARGV[1]\n";
for($i=0;$i<=7;$i++)
{
	print OUT "$i\t$store[$i]\n";
}
close OUT;
