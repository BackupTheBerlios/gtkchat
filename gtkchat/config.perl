#!/usr/bin/env perl
use strict;
use warnings;

my @modules = ('Net::Vypress::Chat', 'YAML', 'Glib', 'Gtk2', 'Gtk2::GladeXML');

my ($cpan_mods, $hand_mods, $gtk_mods, $broken, $cmdline);

sub try_mod {
	my $mod = shift;
	print "Trying Perl module $mod... ";
	if (eval "require $mod") {
	    print "ok. \n";
	    return 1;
	}
	else {
	    print "failed!\n";
    	return 0;
	}
}

foreach (@modules) {
    unless (try_mod($_)) {
		$broken .= "$_ ";
    }
}

if ($broken) {
    print "\nThese modules you don't have or they don't work:\n$broken\n";
    exit 1;
}
