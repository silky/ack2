#!perl

use strict;
use warnings;
use lib 't';

use FilterTest;
use Test::More tests => 2;

use_ok 'App::Ack::Filter::Match';

filter_test(
    [ match => '/^.akefile/' ], [
        't/swamp/Makefile',
        't/swamp/Makefile.PL',
        't/swamp/Rakefile',
    ], 'only files matching /^.akefile/ should be matched',
);
