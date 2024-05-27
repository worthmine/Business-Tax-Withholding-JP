package Business::Tax::Withholding::JP;
use 5.008001;
use strict;
use warnings;
use Time::Seconds;

our $VERSION = "0.92";

use constant { border => 1000000 };

my %consumption = (
    rate => 0.10,
    name => '消費税',
);

my @history = ({
    rate => 0.03,
    since => '1989-04-01',
    until => '1997-03-31',
},{
    rate => 0.05,
    since => '1997-04-01',
    until => '2014-03-31',
},{
    rate => 0.08,
    since => '2014-04-01',
    until => '2019-09-30',
});

my %withholding = (
    rate => 0.10,
    name => '源泉徴収',
);

my %special = (
    rate => 0.0021,
    name => '復興特別所得税',
    since => '2013-01-01',
    until => '2037-12-31',
);

use Time::Piece;
my $t = localtime();

# rewrite with Type::Tiny
use Moo;
use Types::Standard qw( Int Str Bool );
use Type::Params qw( signature );
use namespace::clean;

has 'price' => ( is => 'rw', isa => Int, default => 0 );
has 'amount' => ( is => 'rw', isa => Int, default => 1 );
has 'date' => ( is => 'rw', isa => Str, default => sub { $t->ymd() } );
has 'no_wh' => ( is => 'ro', isa => Bool, default => 0 );

sub net {
    my $self = shift;
    return $self->price(@_);
}

sub subtotal {
    my $self = shift;
    return $self->price() * $self->amount();
}

sub tax {
    my $self = shift;
    return int( $self->subtotal() * $self->tax_rate() );
}

sub full {
    my $self = shift;
    return int( $self->subtotal() + $self->tax() );
}

sub withholding {
    my $self = shift;
    return 0 if $self->no_wh();
    my $rate = $self->wh_rate();
    if( $self->subtotal() <= border ) {
        return int( $self->subtotal() * $rate );
    }else{
        my $base = $self->subtotal() - border;
        return int( $base * $rate * 2 + border * $rate );
    }
}

sub tax_rate {
    my $self = shift;
    my $date = $t->strptime( $self->date(), '%Y-%m-%d' );
    return 0 if $date < $t->strptime( $history[0]{'since'}, '%Y-%m-%d' );
    return $consumption{'rate'} if $date > $t->strptime( $history[-1]{'until'}, '%Y-%m-%d' ) + ONE_DAY;

    foreach my $h (@history) {
        next unless $date < $t->strptime( $h->{'until'}, '%Y-%m-%d' ) + ONE_DAY;
        return $h->{'rate'} if $date >= $t->strptime( $h->{'since'}, '%Y-%m-%d' );
    }
    return $consumption{'rate'};
}

sub wh_rate {
    my $self = shift;
    my $rate = $withholding{'rate'};
    my $since = $t->strptime( $special{'since'}, '%Y-%m-%d' );
    my $until = $t->strptime( $special{'until'}, '%Y-%m-%d' );
    my $date = $t->strptime( $self->date(), '%Y-%m-%d' );

    return $rate if $date < $since or $until < $date;
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

Business::Tax::Withholding::JP - auto calculation for Japanese tax and withholding

Business::Tax::Withholding::JP - 日本の消費税と源泉徴収のややこしい計算を自動化します。
 
=head1 SYNOPSIS

 use Business::Tax::Withholding::JP;
 my $calc = Business::Tax::Withholding::JP->new( price => 10000 );

 $calc->net();          # 10000
 $calc->amount();       # 1
 $calc->subtotal();     # 10000
 $calc->tax();          # 800
 $calc->full();         # 10800
 $calc->withholding();  # 1021
 $calc->total();        # 9779

 # Or you can set the date in period of special tax will expire
 $calc = Business::Tax::Withholding::JP->new( date => '2038-01-01' );
 $calc->price(10000);
 $calc->withholding();  # 1000
 $calc->total();        # 9800

 # And you may ignore the withholdings
 $calc = Business::Tax::Withholding::JP->new( no_wh => 1 );
 $calc->price(10000);   # 10000
 $calc->amount(2);      # 2
 $calc->subtotal();     # 20000
 $calc->tax();          # 1600
 $calc->withholding();  # 0
 $calc->total();        # 21600

 # After 2019/10/01, this module will calculate with 10% consumption tax
 $calc = Business::Tax::Withholding::JP->new( price => 10000 );
 $calc->net();          # 10000
 $calc->amount(2);      # 2
 $calc->subtotal();     # 20000
 $calc->tax();          # 2000
 $calc->withholding();  # 2042
 $calc->total();        # 19958

=head1 DESCRIPTION

Business::Tax::Withholding::JP
is useful calculator for long term in Japanese Business.

You can get correctly taxes and withholdings from price in your context
without worrying about the special tax for reconstructing from the Earthquake.

the consumption tax B<rate is 8% (automatically up to 10% after 2019/10/01)>
 
You can also ignore the withholings. It means this module can be a tax calculator

Business::Tax::Withholding::JP は日本のビジネスで長期的に使えるモジュールです。
特別復興所得税の期限を心配することなく、請求価格から正しく税金額と源泉徴収額を計算できます。
なお、源泉徴収をしない経理にも対応します。B<消費税率は8%、2019年10月1日から自動的に10％> です。
 
=head2 Constructor

=head3 new( price => I<Int>, amount => I<Int>, date => I<Date>, no_wh => I<Bool> );

You can omit these paramators.

パラメータは指定しなくて構いません。
 
=over
 
=item price
 
the price of your products will be set. defaults 0.
 
税抜価格を指定してください。指定しなければ0です。

=item amount
 
the amount of your products will be set. defaults 1.
 
数量を指定してください。指定しなければ1です。

=item date

You can set payday. the net of tax and withholding depends on this. default is today.
 
支払日を指定してください。消費税額と源泉徴収額が変動します。指定しなければ今日として計算します。
 
=item no_wh
 
If you set this flag, the all you can get is only tax and total. defaults 0 and this is read-only.

このフラグを立てるとこのモジュールの長所を台無しにできます。初期値はもちろん0で、あとから変えることはできません。
 
=back
 
=head2 Methods and subroutine

=over

=item price

You can reset the price.

price に値を代入可能です。
 
=item amount
 
You can reset the amount.
 
amount に値を代入可能です。

=item date

You can reset the payday like 'YYYY-MM-DD'

date にも値を代入可能です。フォーマットは'YYYY-MM-DD'（-区切り）です。

=item net

You can get the net of your pay. it's equal to the price.
So it's the alias of price().
 
net は price と同じ働きをします。
 
=item subtotal
 
it returns price() * amount()

subtotal は値と数量の積（小計）を返します。
 
=item tax
 
You can get the net of your tax.
 
税額のみを取得したい場合はこちらを

=item full
 
You can get the net of your pay including tax.

税込金額を知りたい場合はこちらを
 
=item withholding
 
You can get the net of your withholding from your pay.

源泉徴収額を知りたい場合はこちらを
 
=item total

You can get the total of your pay including tax without withholding
 
源泉徴収額を差し引いた税込支払額を知りたい場合はこちらをお使いください。
 
=back

=head1 LICENSE

Copyright (C) Yuki Yoshida(worthmine).

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Yuki Yoshida E<lt>worthmine@gmail.comE<gt>

=cut
