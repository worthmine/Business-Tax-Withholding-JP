package Business::Tax::Withholding::JP;
use 5.008001;
use strict;
use warnings;

our $VERSION = "0.01";

use constant { border => 1000000 };

my %consumption = (
    rate => 0.08,
    name => '消費税',
);

my %withholding = (
    rate => 0.10,
    name => '源泉徴収',
);

my %special = (
    rate => 0.0021,
    name => '復興特別所得税',
    from => '2013-01-01',
    until => '2037-12-31',
);

use Moose;
use Time::Piece;
my $t = localtime;

has price => ( is => 'rw', isa => 'Int', required => 1 );
has date => ( is => 'ro', isa => 'Str', default => $t->ymd() );

__PACKAGE__->meta->make_immutable;
no Moose;

sub net {
    my $self = shift;
    return $self->price();
}

sub tax {
    my $self = shift;
    return int( $self->price() * $consumption{'rate'} );
}

sub full {
    my $self = shift;
    return int( $self->price() + $self->tax() );
}

sub withholding {
    my $self = shift;
    my $rate = $self->rate();
    if( $self->price() <= border ) {
        return int( $self->price() * $rate );
    }else{
        my $base = $self->price() - border;
        
        return int( $base * $rate * 2 + border * $rate );
    }
}

sub rate {
    my $self = shift;
    my $rate = $withholding{'rate'};
    my $from = $t->strptime( $special{'from'}, '%Y-%m-%d');
    my $until = $t->strptime( $special{'until'}, '%Y-%m-%d');
    my $date = $t->strptime( $self->date(), '%Y-%m-%d');

    return $rate if $date < $from or $until < $date;
    return $rate + $special{'rate'};
}
sub total {
    my $self = shift;
    return $self->full - $self->withholding;

}

1;
__END__

=encoding utf-8

=head1 NAME

Business::Tax::Withholding::JP - It's new $module

=head1 SYNOPSIS

    use Business::Tax::Withholding::JP;

=head1 DESCRIPTION

Business::Tax::Withholding::JP is ...

=head1 LICENSE

Copyright (C) worthmine.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

worthmine E<lt>worthmine@cpan.orgE<gt>

=cut

