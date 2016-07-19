package Data::ModeMerge::Mode::CONCAT;
BEGIN {
  $Data::ModeMerge::Mode::CONCAT::VERSION = '0.26';
}
# ABSTRACT: Handler for Data::ModeMerge CONCAT merge mode


use 5.010;
use strict;
use warnings;

use Moo;
extends 'Data::ModeMerge::Mode::ADD';

sub name { 'CONCAT' }

sub precedence_level { 2 }

sub default_prefix { '.' }

sub default_prefix_re { qr/^\./ }

sub merge_SCALAR_SCALAR {
    my ($self, $key, $l, $r) = @_;
    ($key, ($l // "") . $r);
}

1;

__END__
=pod

=head1 NAME

Data::ModeMerge::Mode::CONCAT - Handler for Data::ModeMerge CONCAT merge mode

=head1 VERSION

version 0.26

=head1 SYNOPSIS

    use Data::ModeMerge;

=head1 DESCRIPTION

This is the class to handle CONCAT merge mode.

=for Pod::Coverage ^merge_.*

=head1 AUTHOR

Steven Haryanto <stevenharyanto@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Steven Haryanto.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

