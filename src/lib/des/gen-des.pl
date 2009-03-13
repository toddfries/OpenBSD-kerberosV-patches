#!/usr/pkg/bin/perl
#
# $KTH: gen-des.pl,v 1.2 2005/03/01 11:43:01 lha Exp $

use strict;

print "/* GENERATE FILE from gen-des.pl, do not edit */\n\n";

my $gen = 1;

sub gen_pattern
{
    my $n = shift;
    my $r = shift;
    my $a = shift;
    my $o = shift;
    my $s = shift;
    print "/* $n bit pattern ";
    foreach my $k (@$a) {
	print "$k ";
    }
    print "*/\n";
    print "static int $n\[", $r + 1, "\] = {\n    ";
    foreach my $i (0..$r) {
	my $j = 0;
	my $b = 1;
	foreach my $k (reverse @$a) {
	    if ($i & $b) {
		$j |= ($s >>($k - $o - 1));
	    }
	    $b = $b << 1;
	}
        printf "0x%08x", $j; 
	print ", " if ($i != $r);
        if (($i % 4) == 3) {
		print "\n";
		print "    " if ($i != $r);
	}
    }
    print "};\n";
}

if ($gen) {
    gen_pattern("pc1_c_3", 7,  [ 5, 13, 21 ], 0, 0x1000000);
    gen_pattern("pc1_c_4", 15, [ 1, 9, 17, 25 ], 0, 0x1000000);
    gen_pattern("pc1_d_3", 7, [ 49, 41, 33 ], 32, 0x1000000);
    gen_pattern("pc1_d_4", 15, [ 57, 53, 45, 37 ], 32, 0x1000000);
    
    gen_pattern("pc2_c_1", 63, [  5, 24,  7, 16,  6, 10 ], 0, 0x800000);
    gen_pattern("pc2_c_2", 63, [ 20, 18, 12,  3, 15, 23 ], 0, 0x800000);
    gen_pattern("pc2_c_3", 63, [  1,  9, 19,  2, 14, 22 ], 0, 0x800000);
    gen_pattern("pc2_c_4", 63, [ 11, 13,  4, 17, 21,  8 ], 0, 0x800000);
    
    gen_pattern("pc2_d_1", 63, [ 51, 35, 31, 52, 39, 45 ], 28, 0x800000);
    gen_pattern("pc2_d_2", 63, [ 50, 32, 43, 36, 29, 48 ], 28, 0x800000);
    gen_pattern("pc2_d_3", 63, [ 41, 38, 47, 33, 40, 42 ], 28, 0x800000);
    gen_pattern("pc2_d_4", 63, [ 49, 37, 30, 46, 34, 44 ], 28, 0x800000);
}

sub
pbox_mutation
{
    my $n = shift;
    my $res = 0;
    
    my @pbox = (
		16,   7,  20,  21,
		29,  12,  28,  17,
		1,   15,  23,  26,
		5,   18,  31,  10,
		2,    8,  24,  14,
		32,  27,   3,   9,
		19,  13,  30,   6,
		22,  11,   4,  25
		);

    foreach my $i (0..31) {
	if ($n & (1 << ($pbox[$i] - 1))) {
#	    print "$i ", ($pbox[$i] - 1), "\n";
	    $res |= 1 << $i;
	}
    }

    return $res;
}


my @S1 = (
	  14, 4, 13, 1, 2, 15, 11, 8, 3, 10, 6, 12, 5, 9, 0, 7, 
	  0, 15, 7, 4, 14, 2, 13, 1, 10, 6, 12, 11, 9, 5, 3, 8, 
	  4, 1, 14, 8, 13, 6, 2, 11, 15, 12, 9, 7, 3, 10, 5, 0, 
	  15, 12, 8, 2, 4, 9, 1, 7, 5, 11, 3, 14, 10, 0, 6, 13, 
	  );
my @S2 = (
	  15, 1, 8, 14, 6, 11, 3, 4, 9, 7, 2, 13, 12, 0, 5, 10, 
	  3, 13, 4, 7, 15, 2, 8, 14, 12, 0, 1, 10, 6, 9, 11, 5, 
	  0, 14, 7, 11, 10, 4, 13, 1, 5, 8, 12, 6, 9, 3, 2, 15, 
	  13, 8, 10, 1, 3, 15, 4, 2, 11, 6, 7, 12, 0, 5, 14, 9, 
	  );
my @S3 = (
	  10, 0, 9, 14, 6, 3, 15, 5, 1, 13, 12, 7, 11, 4, 2, 8, 
	  13, 7, 0, 9, 3, 4, 6, 10, 2, 8, 5, 14, 12, 11, 15, 1, 
	  13, 6, 4, 9, 8, 15, 3, 0, 11, 1, 2, 12, 5, 10, 14, 7, 
	  1, 10, 13, 0, 6, 9, 8, 7, 4, 15, 14, 3, 11, 5, 2, 12, 
	  );
my @S4 = (
	  7, 13, 14, 3, 0, 6, 9, 10, 1, 2, 8, 5, 11, 12, 4, 15, 
	  13, 8, 11, 5, 6, 15, 0, 3, 4, 7, 2, 12, 1, 10, 14, 9, 
	  10, 6, 9, 0, 12, 11, 7, 13, 15, 1, 3, 14, 5, 2, 8, 4, 
	  3, 15, 0, 6, 10, 1, 13, 8, 9, 4, 5, 11, 12, 7, 2, 14, 
	  );
my @S5 = (
	  2, 12, 4, 1, 7, 10, 11, 6, 8, 5, 3, 15, 13, 0, 14, 9, 
	  14, 11, 2, 12, 4, 7, 13, 1, 5, 0, 15, 10, 3, 9, 8, 6, 
	  4, 2, 1, 11, 10, 13, 7, 8, 15, 9, 12, 5, 6, 3, 0, 14, 
	  11, 8, 12, 7, 1, 14, 2, 13, 6, 15, 0, 9, 10, 4, 5, 3, 
	  );
my @S6 = (
	  12, 1, 10, 15, 9, 2, 6, 8, 0, 13, 3, 4, 14, 7, 5, 11, 
	  10, 15, 4, 2, 7, 12, 9, 5, 6, 1, 13, 14, 0, 11, 3, 8, 
	  9, 14, 15, 5, 2, 8, 12, 3, 7, 0, 4, 10, 1, 13, 11, 6, 
	  4, 3, 2, 12, 9, 5, 15, 10, 11, 14, 1, 7, 6, 0, 8, 13, 
	  );
my @S7 = (
	  4, 11, 2, 14, 15, 0, 8, 13, 3, 12, 9, 7, 5, 10, 6, 1, 
	  13, 0, 11, 7, 4, 9, 1, 10, 14, 3, 5, 12, 2, 15, 8, 6, 
	  1, 4, 11, 13, 12, 3, 7, 14, 10, 15, 6, 8, 0, 5, 9, 2, 
	  6, 11, 13, 8, 1, 4, 10, 7, 9, 5, 0, 15, 14, 2, 3, 12, 
	  );

my @S8 = (
	  13, 2, 8, 4, 6, 15, 11, 1, 10, 9, 3, 14, 5, 0, 12, 7, 
	  1, 15, 13, 8, 10, 3, 7, 4, 12, 5, 6, 11, 0, 14, 9, 2, 
	  7, 11, 4, 1, 9, 12, 14, 2, 0, 6, 10, 13, 15, 3, 5, 8, 
	  2, 1, 14, 7, 4, 10, 8, 13, 15, 12, 9, 0, 3, 5, 6, 11, 
	  );

my @SBox = ( \@S1, \@S2, \@S3, \@S4, \@S5, \@S6, \@S7, \@S8 );

sub
one_num_in_one_sbox
{
    my $i = shift;
    my $n = shift;
    my $r = shift;

    my $index = (($n & 1) << 4) | (($n & 0x20)) |
	(($n >> 1) & 0x1) << 0 |
	(($n >> 2) & 0x1) << 1 |
	(($n >> 3) & 0x1) << 2 |
	(($n >> 4) & 0x1) << 3;

    die "argh" if ($index > 63 || $index < 0);

    my $S = $SBox[$i - 1];
    my $val = $$S[$index];

    my $res = $val << (($i - 1) * 4);

    my $p = &pbox_mutation($res);

    print " $r ";

#    $p = ($p >> $r) | ($p << (32 - $r - 1));

    printf "0x%08x", $p;
    print ", " if ($n != 63 or 1);
    if (($n % 4) == 3) {
	print " /* $i */" if ($n == 3);
	print "\n";
	print "\t" if ($n != 63);
    }
}

sub
one_sbox
{
    my $i = shift;
    my $s = 0;
    
#    print "static uint32_t sbox". $i ."[] = {\n\t";
    print "\t";
    foreach my $n (0..63) {
	one_num_in_one_sbox($i, $n, $s);
    }
    print "\n";
#    print "};\n";
}

if ($gen and 0) {
    foreach my $sbox (7, 1, 3, 5, 4, 6, 8, 2) {
	one_sbox($sbox, 1);
    }
}

#my $num = 1;
#printf "pbox: %d -> 0x%08x\n", $num, pbox_mutation($num);
#$num = 0xc000000;
#printf "pbox: 0x%08x -> 0x%08x\n", $num, pbox_mutation($num);

print "static unsigned char odd_parity[256] = { \n";
foreach my $i (0..255) {
    my $num = 0;
    foreach my $b (1..7) {
	$num++ if (($i >> $b) & 1);
    }
    my $t;
    if (($num & 1) == 0) {
	$t = $i | 1;
    } else {
	$t = 0xfe & $i;
    }
    printf "%3d,", $t; 
    printf "\n" if (($i % 16) == 15);
	
};
print " };\n";
