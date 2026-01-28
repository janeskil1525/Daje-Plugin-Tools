#!/usr/bin/perl
use FindBin;
BEGIN { unshift @INC, "$FindBin::Bin/../lib" }

use v5.42;
use Moo;
use MooX::Options;
use Cwd;
use Mojo::Pg;

use feature 'say';
use feature 'signatures';
use Daje::Workflow::Activities::Tools::Generate::Workflow;
use Daje::Workflow::Database::Model;
use Daje::Workflow::Errors::Error;

use namespace::clean -except => [qw/_options_data _options_config/];

sub save_code() {

    my $pg = Mojo::Pg->new()->dsn(
        "dbi:Pg:dbname=daje;host=192.168.1.124;port=5432;user=daje;password=PV58nova64"
    );

    my $model = Daje::Workflow::Database::Model->new(db => $pg->db);

    my $context->{context}->{payload}->{tools_projects_fkey} = 1;
    # $context->{context}->{payload}->{workflows} = \@data;
    my $generate = Daje::Workflow::Activities::Tools::Generate::SaveCode->new(
        db      => $pg->db,
        context => $context,
        model   => $model,
        error   => Daje::Workflow::Errors::Error->new(),
    );


    try {
        $generate->save_code();
    } catch ($e) {
        say $e;
    };

}

save_code();
