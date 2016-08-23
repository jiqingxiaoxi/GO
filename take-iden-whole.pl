use strict; use warnings;

my $line;
my @array;
my $flag;
my @store;
my $i;
my $gi;
my %len;

if(@ARGV!=3)
{
	print "perl $0 blast_result fa_file output\n";
	exit;
}

open(IN,"gzip -dc $ARGV[1] |") or die "$ARGV[1]\n";
while(<IN>)
{
	chomp;
	$line=$_;
	if($line=~/^\>/)
	{
		($gi)=$line=~/gi\|(\d+)\|/;
		$len{$gi}=0;
		next;
	}
	$len{$gi}=$len{$gi}+length($line);
}
close IN;

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
		($gi)=$array[0]=~/gi\|(\d+)\|/;
		$i=$array[2]*$array[3]/$len{$gi}*3;
		if($i<=20)
		{
			$store[0]++;
		}
		elsif($i<=30)
                {
                        $store[1]++;
                }
		elsif($i<=40)
                {
                        $store[2]++;
                }
		elsif($i<=50)
                {
                        $store[3]++;
                }
		elsif($i<=60)
                {
                        $store[4]++;
                }
		elsif($i<=80)
                {
                        $store[5]++;
                }
		else
		{
			$store[6]++;
		}
	}
}
close IN;

open(OUT,">$ARGV[2]") or die "can't create $ARGV[2]\n";
for($i=0;$i<=6;$i++)
{
	print OUT "$i\t$store[$i]\n";
}
close OUT;
