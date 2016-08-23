use strict; use warnings;

my $line;
my @array;
my $flag=0;
my @store;
my $i;
my $go;
my $value;
my %space;
my %hash;
my %store;
my %ref;
my %turn;
my $whole=0;

if(@ARGV!=4)
{
	print "perl $0 blast_result  go-name  go.obo output\n";
	exit;
}

open(IN,"<$ARGV[1]") or die "$ARGV[1]\n";
while(<IN>)
{
	chomp;
	$line=$_;
	@array=split("\t",$line);
	$store{$array[0]}=$line;
}
close IN;

open(IN,"<$ARGV[2]") or die "$ARGV[2]\n";
while(<IN>)
{
        chomp;
        $line=$_;
        if($line=~/^id\: GO/)
        {       
                $flag=1;
                ($go)=$line=~/id\: (GO\:\d+)$/;
                next;
        }

        if($line=~/^namespace\: /&&$flag==1)
        {
                $flag=0;
                ($value)=$line=~/namespace\: (.+)$/;
                $space{$go}=$value;
                $turn{$value}=1;
        }
}
close IN;

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
		if($array[10]>1e-5)
		{
			next;
		}
		if($array[2]<30)
		{
			next;
		}
		$whole++;
		if(exists $ref{$array[1]})
		{
			$ref{$array[1]}++;
		}
		else
		{
			$ref{$array[1]}=1;
		}
	}
}
close IN;

foreach $line (keys %ref)
{
	@array=split("\t",$store{$line});
	for($i=1;$i<@array;$i++)
	{
		($go,$value)=$array[$i]=~/^(.+)\_(.+)$/;
		if(exists $hash{$go})
		{
			$hash{$go}=$hash{$go}+$ref{$line}*$value;
		}
		else
		{
			$hash{$go}=$ref{$line}*$value;
		}
	}
}

open(OUT,">$ARGV[3]") or die "can't create $ARGV[1]\n";
print OUT "whole align is $whole\n";
foreach $value (keys %turn)
{
	print OUT "The level of $value\:\n";
	foreach $go (sort{$hash{$b}<=>$hash{$a}} keys %hash)
	{
		if($space{$go} ne $value)
		{
			next;
		}
		print OUT "$go\t$hash{$go}\n";
	}
}
close OUT;
