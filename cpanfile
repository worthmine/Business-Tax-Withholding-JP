requires 'perl', '5.008001';
requires 'Moose';
requires 'Time::Piece';
requires 'Module::Build::Tiny';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

