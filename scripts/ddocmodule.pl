#!/usr/bin/perl
@file=<>;
$all="@file";
$all=~s/\s+\// /g;
$all=~s/\//\./g;
@modules=split(/\s+/, $all);
print "MODULES=\n";
foreach (@modules) {
    $_=~s/\.d$//;
    print "    \$(MODULE $_)\n";
}
