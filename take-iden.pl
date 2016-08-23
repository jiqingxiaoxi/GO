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

for($i=0;$i<=6;$i++)
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
		if($array[2]<=20)
		{
			$i=0;
		}
		elsif($array[2]<=30)
                {
                        $i=1;
                }
		elsif($array[2]<=40)
                {
                        $i=2;
                }
		elsif($array[2]<=50)
                {
                        $i=3;
                }
		elsif($array[2]<=60)
                {
                        $i=4;
                }
		elsif($array[2]<=80)
                {
                        $i=5;
                }
		else
		{
			$i=6;
		}
		$store[$i]++;
	}
}
close IN;

open(OUT,">$ARGV[1]") or die "can't create $ARGV[1]\n";
for($i=0;$i<=6;$i++)
{
	print OUT "$i\t$store[$i]\n";
}
close OUT;
