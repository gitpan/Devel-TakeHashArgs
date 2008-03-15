package Devel::TakeHashArgs;

use warnings;
use strict;

our $VERSION = '0.001';

require Exporter;
our @ISA = 'Exporter';
our @EXPORT = qw(get_args_as_hash);

use Carp;

sub get_args_as_hash {
    my ( $in_args, $out_args, $opts ) = @_;

    @$in_args & 1
        and $@ = "Must have even number of arguments"
        and return 0;

    %$out_args = @$in_args;
    $out_args->{ +lc } = delete $out_args->{ $_ } for keys %$out_args;

    %$out_args = (
        %{ $opts || {} },

        %$out_args,
    );

    1;
}

1;
__END__

=head1 NAME

Devel::TakeHashArgs - make a hash from @_ and set defaults in subs

=head1 SYNOPSIS

    use Devel::TakeHashArgs;
    use Carp;
    sub foos {
        get_args_as_hash(\@_, \my %args, { foos => 'bars' } )
            or croak $@;

        print map { "$_ => $args{$_}\n" } keys %args;
    }

=head1 DESCRIPTION

The module is a short utility I made after being sick and tired of writing
redundant code to make a hash out of args when they are passed as
key/value pairs including setting their defaults.

=head1 EXPORT

The module has only one sub and it's exported by default.

=head2 get_args_as_hash

    sub foos {
        get_args_as_hash( \@_, \my %args, { some => 'defaults', more => 'defaults!' } )
            or croak $@;
    }

The sub makes out a hash out of C<@_>, assigns optional defaults and fills
the passed hashref. B<Returns> C<1> for success and C<0> for failure,
upon failure the reason for it will be available in C<$@> variable...
actually, the only reason it would fail is if C<@_> would contain uneven
number of arguments.

The sub takes two mandatory arguments: the reference to an array
(the C<@_> but it can be any array), a reference to a hash where you want
your args to go, and third optional hashref argument which would contain
the defaults to assign unless the argument is present in the passed array.

Basically the above code is the same as:

    sub foos {
        croak "Must have even number of arguments to new()"
            if @_ & 1;

        my %args = @_;
        $args{ +lc } = delete $args{ $_ } for keys %args;

        %args = (
            some    => 'defaults',
            more    => 'defaults!',

            %args,
        );
    );

It's not much but you get pretty sick and tired after you type (copy/paste)
that bit over 150 times.

=head1 AUTHOR

Zoffix Znet, C<< <zoffix at cpan.org> >>
(L<http://zoffix.com>, L<http://haslayout.net>)

=head1 BUGS

Please report any bugs or feature requests to C<bug-devel-takehashargs at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Devel-TakeHashArgs>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Devel::TakeHashArgs

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Devel-TakeHashArgs>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Devel-TakeHashArgs>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Devel-TakeHashArgs>

=item * Search CPAN

L<http://search.cpan.org/dist/Devel-TakeHashArgs>

=back

=head1 COPYRIGHT & LICENSE

Copyright 2008 Zoffix Znet, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut
