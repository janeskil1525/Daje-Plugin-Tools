requires 'perl', '5.042000';
requires 'Mojo::Base', '0';
requires 'Scalar::Util', '0';
requires 'Future::AsyncAwait', '0.52';
requires 'Template', '3.102';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

