use strict;
use warnings;

use Test::More;
use lib 't';
use Util;

{
    my $help_options;

    sub _populate_help_options {
        my ( $output, undef ) = run_ack_with_stderr( '--help' );

        $help_options = [];

        foreach my $line (@{$output}) {
            if ( $line =~ /^\s+-/ ) {
                while ( $line =~ /(-(?:-\[no\])?[-a-zA-Z0-9]+)/g ) {
                    my $option = $1;

                    if ( $option =~ s/^--\[no\]/--/ ) {
                        my $negated_option = $option;
                        substr $negated_option, 2, 0, 'no';
                        push @{$help_options}, $negated_option;
                    }

                    push @{$help_options}, $option;
                }
            }
        }
    }

    sub get_help_options {
        unless ( $help_options ) {
            _populate_help_options();
        }

        return @{ $help_options };
    }
}

sub option_in_usage {
    my ( $expected_option ) = @_;

    my @help_options = get_help_options();
    my $found;

    foreach my $option ( @help_options ) {
        if ( $option eq $expected_option ) {
            $found = 1;
            last;
        }
    }

    ok $found, "Option '$expected_option' found in --help output";
}

my @options = get_options();

plan tests => scalar(@options);

prep_environment();

foreach my $option ( @options ) {
    option_in_usage( $option );
}
