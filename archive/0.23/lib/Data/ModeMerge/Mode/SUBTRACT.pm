package Data::ModeMerge::Mode::SUBTRACT;
our $VERSION = '0.23';
# ABSTRACT: Handler for Data::ModeMerge SUBTRACT merge mode


use Any::Moose;
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

__PACKAGE__->meta->make_immutable;
no Any::Moose;
1;

__END__
=pod

=head1 NAME

Data::ModeMerge::Mode::SUBTRACT - Handler for Data::ModeMerge SUBTRACT merge mode

=head1 VERSION

version 0.23

=head1 SYNOPSIS

    use Data::ModeMerge;

=head1 DESCRIPTION

This is the class to handle SUBTRACT merge mode.

=head1 AUTHOR

  Steven Haryanto <stevenharyanto@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Steven Haryanto.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

