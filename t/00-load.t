#!/usr/bin/env perl

use strict;
use warnings;
use Test::More tests => 14;

BEGIN {
    use_ok('Exporter');
	use_ok( 'Devel::TakeHashArgs' );
}

diag( "Testing Devel::TakeHashArgs $Devel::TakeHashArgs::VERSION, Perl $], $^X" );

my $args = {};
get_args_as_hash([], $args);

is(scalar keys %$args, 0, 'no args with empty arrayref');

$args = {};
get_args_as_hash([], $args, { foos => 'bars' } );
is(scalar keys %$args, 1, '1 arg with 1 default and empty arrayref');
is( $args->{foos}, 'bars', 'default arg');

$args = {};
get_args_as_hash([1..4], $args, { foos => 'bars' } );
is(scalar keys %$args, 3, '3 args with 1 default and 4 els in arrayref');
is_deeply(
    $args,
    {
        foos => 'bars',
        1..4,
    },
    'deep check on correct %args',
);

$args = {};
get_args_as_hash([foos => 'beers'], $args, { foos => 'bars' } );
is(scalar keys %$args, 1, '1 args with 1 default and 1 override in arrayref');
is( $args->{foos}, 'beers', 'override is working' );

$args={};
is( get_args_as_hash([1], $args), 0, 'must fail with odd number of els');
is ( $@, "Must have even number of arguments", '$@ must be set' );

$args={};
is( get_args_as_hash([1..2], $args, {}, ['a']), 0,
        'must fail with missing mandatory arguments');
is( $@, "Missing mandatory argument `a`", '$@ must be set approprietaly');

$args={};
is( get_args_as_hash([a => 'b'], $args, {}, ['a']), 1,
        'must not fail, we supplied mandatory arguments');