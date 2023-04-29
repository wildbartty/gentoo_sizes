#!/usr/bin/perl

use strict;
use warnings;
use diagnostics;
use Config::IniFiles;
use Data::Dumper;


sub parse_conf {
    opendir my $file, "/etc/portage/repos.conf/" or die "failed to open file";

    sub parse_file {
        my ($file) = @_;
        my @ret;
        my $cfg = Config::IniFiles->new( -file => "$file" );
        for($cfg->Sections) {
            if($cfg->exists($_, "location")) {
                my $x = $cfg->val($_, "location");
                push @ret, $x;
            }
        }
        return @ret;
    }

    while( my $line = readdir $file)  {   
        my @arr;
        if ($line =~ /^[a-zA-Z0-9].*$/) {
            push @arr, parse_file("/etc/portage/repos.conf/$line");
        }
        for(@arr) {
            print "$_\n";
        }
    }
}

sub read_world {
    open my $file, "/var/lib/portage/world";
    my @ret = <$file>;
    return @ret;
}

sub split_version {
    #loop in repo folders til you get a package that matches
    my $pkg = $_[0];
    my $class = $_[1];
    if (defined $class) {
        print("Got class\t","$pkg $class\n");
    } 
    else {
        print("Ain't no fashon on those hoes\t","pkg: $pkg class: $class\n");
    }
}

sub parse_atom {
#TODO: write specific parsers for ut2004 and xfce4 and amazon-ec2 r10k cli53 
    #Parsed atom format is [name, class, version, operator, slot] in
    #an array
    my @ret = ("","","","","");
    my $atom = $_[0];
    my @split_slot = split(/:/, $atom);
    my @split_class = split(/\//, $split_slot[0]);
    
    my ($oper, $class);
    if(scalar(@split_class) != 1) {
        $split_class[0] =~ /([<=>]{0,2})(.+)/;
        my $oper = "$1";
        my $class = "$2";
    } else {
        #this is so split version works if no class was given
        $split_class[1] = $split_class[0];
        $split_class[0] = undef;
    }

    $ret[4] = $split_slot[1];
    $ret[1] = $class;
    $ret[3] = $oper;
    my @split_version = split_version($split_class[1], $split_class[0]);
    print(Dumper \@split_class);
}

my @x = (
'>=sys-libs/ncurses-5.9-r3:0/6',
'app-admin/pass',
'gcc',
'acct-user/gnupg-pkcs11-scd-proxy',
'sys-libs/libstdc++');

for(@x) { parse_atom($_); }
