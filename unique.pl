#!/usr/bin/perl
#unique.pl dir
### extract the tissue-specific circRNA information

use strict;
use warnings;


my $dir=shift;

my %hash;


open(RESULT,'>unique_'.$dir.'.txt') or die;
opendir(DIR,$dir) or die;
while(my $file=readdir(DIR)){
	if($file ne '.' and $file ne '..'){
		my $sum=0;
		my @file=split /\./,$file;
		open(FILE,$dir."\\".$file) or die;
		while(<FILE>){
			chomp;
			if(/^circRNA_ID/i){
			}else{
				my $key=$file[0]."\t".$_;
				$hash{$key}=1;
			}
		}
		close(FILE);
	}
}
closedir(DIR);

my %hash2;
my %hash3;
foreach  (keys %hash) {
	my @row=split /\t/;
	my @name=split /_/,$row[0];
	$name[0]=uc $name[0];
	my $key=$row[1];  ###circRNA ID: chr18:19752092|19761469
	push @{$hash2{$key}},$name[0];  ###$name[0] is sample name which before the first '_' in the file name,eg, brain, heart, etc.
	push @{$hash3{$key}},$_;
}


foreach my $jj (keys %hash2) {
	my @num=@{$hash2{$jj}};
	my %count;
	@num=grep {++$count{$_}<2} @num;   
	if(@num==1){                       
		my @num3=@{$hash3{$jj}};
		for(my $i=0;$i<@num3;$i++){
			print RESULT "$num3[$i]\n";
		}
	}
}

close(RESULT);