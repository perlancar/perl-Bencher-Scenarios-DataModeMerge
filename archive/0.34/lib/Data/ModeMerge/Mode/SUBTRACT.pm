package Data::ModeMerge::Mode::SUBTRACT;

our $DATE = '2016-07-19'; # DATE
our $VERSION = '0.34'; # VERSION

use 5.010;
use strict;
use warnings;
use Mo qw(build default);
extends 'Data::ModeMerge::Mode::NORMAL';

sub name { 'SUBTRACT' }

sub precedence_level { 4 }

sub default_prefix { '-' }

sub default_prefix_re { qr/^-/ }

sub merge_SCALAR_SCALAR {
    my ($self, $key, $l, $r) = @_;
    ($key, $l - $r);
}

sub merge_SCALAR_ARRAY {
    my ($self, $key, $l, $r) = @_;
    $self->merger->push_error("Can't subtract scalar and array");
    return;
}

sub merge_SCALAR_HASH {
    my ($self, $key, $l, $r) = @_;
    $self->merger->push_error("Can't subtract scalar and hash");
    return;
}

sub merge_ARRAY_SCALAR {
    my ($self, $key, $l, $r) = @_;
    $self->merger->push_error("Can't subtract array and scalar");
    return;
}

sub merge_ARRAY_ARRAY {
    my ($self, $key, $l, $r) = @_;
    my @res;
    my $mm = $self->merger;
    for (@$l) {
        push @res, $_ unless $mm->_in($_, $r);
    }
    ($key, \@res);
}

sub merge_ARRAY_HASH {
    my ($self, $key, $l, $r) = @_;
    $self->merger->push_error("Can't subtract array and hash");
    return;
}

sub merge_HASH_SCALAR {
    my ($self, $key, $l, $r) = @_;
    $self->merger->push_error("Can't subtract hash and scalar");
    return;
}

sub merge_HASH_ARRAY {
    my ($self, $key, $l, $r) = @_;
    $self->merger->push_error("Can't subtract hash and array");
    return;
}

sub merge_HASH_HASH {
    my ($self, $key, $l, $r) = @_;
    my $mm = $self->merger;

    my %res;
    my $r2 = {};
    for (keys %$r) {
        my $k = $mm->check_prefix($_) ? $_ : $mm->add_prefix($_, 'DELETE');
        if ($k ne $_ && exists($r->{$k})) {
            $mm->push_error("Conflict when adding DELETE prefix on right-side hash key $_ ".
                            "for SUBTRACT merge: key $k already exists");
            return;
        }
        $r2->{$k} = $r->{$_};
    }
    $mm->_merge($key, $l, $r2, 'NORMAL');
}

1;
# ABSTRACT: Handler for Data::ModeMerge SUBTRACT merge mode

__END__

=pod

=encoding UTF-8

=head1 NAME

Data::ModeMerge::Mode::SUBTRACT - Handler for Data::ModeMerge SUBTRACT merge mode

=head1 VERSION

This document describes version 0.34 of Data::ModeMerge::Mode::SUBTRACT (from Perl distribution Data-ModeMerge), released on 2016-07-19.

=head1 SYNOPSIS

 use Data::ModeMerge;

=head1 DESCRIPTION

This is the class to handle SUBTRACT merge mode.

=for Pod::Coverage ^merge_.*

=head1 HOMEPAGE

Please visit the project's homepage at L<https://metacpan.org/release/Data-ModeMerge>.

=head1 SOURCE

Source repository is at L<https://github.com/perlancar/perl-Data-ModeMerge>.

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website L<https://rt.cpan.org/Public/Dist/Display.html?Name=Data-ModeMerge>

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

perlancar <perlancar@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2016 by perlancar@cpan.org.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
