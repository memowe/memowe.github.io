#!/usr/bin/env perl

use strict;
use warnings;
use FindBin '$Bin';

# slurp header
my $header_fn = "$Bin/header.md";
open my $header_fh, '<', $header_fn
    or die "Couldn't open $header_fn: $!\n";
my $header = do {local $/; <$header_fh>} . "\n";
close $header_fh;

# slurp footer
my $footer_fn = "$Bin/footer.md";
open my $footer_fh, '<', $footer_fn
    or die "Couldn't open $footer_fn: $!\n";
my $footer = "\n" . do {local $/; <$footer_fh>};
close $footer_fh;

# pre-process
my $year = (localtime)[5] + 1900;
$footer =~ s/#YEAR#/$year/;

# work on all markdown files
while (defined(my $content_fn = glob "$Bin/*.md")) {
    next if $content_fn eq $header_fn or $content_fn eq $footer_fn;

    # load
    open my $content_fh, '<', $content_fn
        or die "Couldn't open $content_fn: $!\n";
    my $content = do {local $/; <$content_fh>};
    close $content_fh;

    my $new_content = $content;

    # no header at the beginning: prepend
    if (index($content, $header) != 0) {
        $new_content = $header . $new_content;
        print "header added to $content_fn\n";
    }

    # no footer at the end: append
    if (index($content, $footer) != length($content) - length($footer)) {
        $new_content = $new_content . $footer;
        print "footer added to $content_fn\n";
    }

    # action
    if ($new_content ne $content) {
        open $content_fh, '>', $content_fn
            or die "Couldn't open $content_fn: $!\n";
        print $content_fh $new_content;
        close $content_fh;
    }

    # no action
    else {
        print "nothing changed in $content_fn\n";
    }
}

__END__
