[![Build Status](https://travis-ci.com/worthmine/Business-Tax-Withholding-JP.svg?branch=master)](https://travis-ci.com/worthmine/Business-Tax-Withholding-JP) [![MetaCPAN Release](https://badge.fury.io/pl/Business-Tax-Withholding-JP.svg)](https://metacpan.org/release/Business-Tax-Withholding-JP)
# NAME

Business::Tax::Withholding::JP - auto calculation for Japanese tax and withholding

Business::Tax::Withholding::JP - 日本の消費税と源泉徴収のややこしい計算を自動化します。

# SYNOPSIS

    use Business::Tax::Withholding::JP;
    my $calc = Business::Tax::Withholding::JP->new( price => 10000 );

    $calc->net();          # 10000
    $calc->amount();       # 1
    $calc->tax();          # 800
    $calc->full();         # 10800
    $calc->withholding();  # 1021
    $calc->subtotal();     # 9779

    # Or you can set the date in period of special tax being expired
    $calc = Business::Tax::Withholding::JP->new( date => '2038-01-01' );
    $calc->price(10000);
    $calc->withholding();  # 1000
    $calc->subtotal();     # 9800

    # And you may ignore the withholings
    $calc = Business::Tax::Withholding::JP->new( no_wh => 1 );
    $calc->price(10000);   # 10000
    $calc->amount(2);      # 2
    $calc->tax();          # 1600
    $calc->withholding();  # 0
    $calc->subtotal();     # 21600

# DESCRIPTION

Business::Tax::Withholding::JP
is useful calculator for long term in Japanese Business.

You can get correctly taxes and withholdings from price in your context
without worrying about the special tax for reconstructing from the Earthquake.

the consumption tax **rate is 8%**

You can also ignore the withholings. It means this module can be a tax calculator

Business::Tax::Withholding::JP は日本のビジネスで長期的に使えるモジュールです。
特別復興所得税の期限を心配することなく、請求価格から正しく税金額と源泉徴収額を計算できます。
なお、源泉徴収をしない経理にも対応します。**消費税率は8％** です。

## Constructor

### new( price => _Int_, amount => _Int_, date => _Date_, no\_wh => _Bool_ );

You can omit these paramators.

パラメータは指定しなくて構いません。

- price

    the price of your products will be set. defaults 0.

    税抜価格を指定してください。指定しなければ0です。

- amount

    the amount of your products will be set. defaults 1.

    数量を指定してください。指定しなければ1です。

- date

    You can set payday. the net of withholding depends on this. default is today.

    支払日を指定してください。源泉徴収額が変動することがあります。指定しなければ今日として計算します。

- no\_wh

    If you set this flag, the all you can get is only tax and subtotal. defaults 0 and this is read-only.

    このフラグを立てるとこのモジュールの長所を台無しにできます。初期値はもちろん0で、あとから変えることはできません。

## Methods and subroutine

- price

    You can reset the price.

    price に値を代入可能です。

- amount

    You can reset the amount.

    amount に値を代入可能です。

- date

    You can reset the payday like 'YYYY-MM-DD'

    date にも値を代入可能です。フォーマットは'YYYY-MM-DD'（-区切り）です。

- net

    You can get the net of your pay. it's equal to the price.
    So it's the alias of price().

    net は price と同じ働きをします。

- tax

    You can get the net of your tax.

    税額のみを取得したい場合はこちらを

- full

    You can get the net of your pay including tax.

    税込金額を知りたい場合はこちらを

- withholding

    You can get the net of your withholding from your pay.

    源泉徴収額を知りたい場合はこちらを

- subtotal

    You can get the subtotal of your pay including tax without withholding

    源泉徴収額を差し引いた税込支払額を知りたい場合はこちらをお使いください。

- total **(will be abolished)**

    just staying for compatibility with old versions

# LICENSE

Copyright (C) worthmine.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

worthmine <worthmine@cpan.org>
