requires 'perl', '5.008001';
requires 'Moose';
requires 'Time::Piece';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

