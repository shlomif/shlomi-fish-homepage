#!/usr/bin/perl

use strict;
use warnings;

use Template;

my @documents =
(
    {
        id => "case-for-drug-legalisation",
        path => "philosophy/politics/drug-legalisation",
        base => "case-for-drug-legalisation",
    },
    {
        id => "case-for-file-swapping-rev3",
        path => "philosophy/case-for-file-swapping/revision-3",
        base => "case-for-file-swapping-rev3",
    },
    {
        id => "dealing-with-hypomanias", 
        path => "philosophy/psychology/hypomanias/", 
        base => "dealing-with-hypomanias",
    },
    {
        id => "end-of-it-slavery", 
        path => "philosophy/computers/software-management/end-of-it-slavery", 
        base => "end-of-it-slavery",
    },
    
    {
        id => "foss-and-other-beasts", 
        path => "philosophy/foss-other-beasts/revision-2", 
        base => "foss-and-other-beasts",
    },
    
    {
        id => "introductory-language", 
        path => "philosophy/computers/education/introductory-language", 
        base => "introductory-language",
    },
    
    {
        id => "isr-pales-conflict-solution", 
        path => "philosophy/israel-pales", 
        base => "isr-pales-conflict-solution",
    },
    
    {
        id => "objectivism-and-open-source", 
        path => "philosophy/obj-oss", 
        base => "objectivism-and-open-source",
    },
    
    {
        id => "rindolf-spec", 
        path => "rindolf", 
        base => "rindolf-spec",
    },
    
    {
        id => "the-eternal-jew", 
        path => "philosophy/the-eternal-jew", 
        base => "the-eternal-jew",
    },
    
    {
        id => "what-makes-software-high-quality", 
        path => "philosophy/computers/high-quality-software", 
        base => "what-makes-software-high-quality",
    },
    
    {
        id => "what-makes-software-high-quality-rev2", 
        path => "philosophy/computers/high-quality-software/rev2", 
        base => "what-makes-software-high-quality-rev2",
    },
    {
        id => "perfect-it-workplace", 
        path => "philosophy/computers/software-management/perfect-workplace", 
        base => "perfect-it-workplace",
    },
    {
        id => "foss-licences-wars", 
        path => "philosophy/computers/open-source/foss-licences-wars", 
        base => "foss-licences-wars",
    },
);

my $tt = Template->new({});

open my $make_fh, ">", "lib/make/docbook/sf-homepage-docbooks-generated.mak";
$tt->process(\*DATA, 
    {
        docs => \@documents,
    },
    $make_fh
);
close ($make_fh);
__DATA__
### This file is auto-generated from gen-dobook-make-helpers.pl

[% FOREACH d = docs %]
$(call set,DOCBOOK_DIRS_MAP,[% d.base %],[% d.path %])
[% END %]

