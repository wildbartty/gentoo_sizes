#!/usr/bin/perl

use strict;
use warnings;
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

sub parse_atom {
#TODO: write specific parsers for ut2004 and xfce4 and amazon-ec2 r10k cli53 
    my %ret;
    my ($atom) = @_;
    if ($atom =~ /(.+)\/(.+)/) {
        print "$atom\t$1\t$2\n"
    };
}

my @x = read_world;
@x = (
'>=sys-libs/ncurses-5.9-r3:0/6',
'app-admin/pass',
'acct-user/gnupg-pkcs11-scd-proxy',
'sys-libs/libstdc++');

for(@x) { parse_atom($_); }
