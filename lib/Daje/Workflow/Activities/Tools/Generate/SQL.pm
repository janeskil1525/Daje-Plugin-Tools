package Daje::Workflow::Activities::Tools::Generate::SQL;
use Mojo::Base 'Daje::Workflow::Activities::Tools::Generate::Base', -base, -signatures;
use v5.42;

# NAME
# ====
#
# Daje::Workflow::Activities::Tools::Generate::SQL - Generate SQL
# migration files for Mojo::Pg
#
# SYNOPSIS
# ========
#
#     use Daje::Workflow::Activities::Tools::Generate::SQL
#
# DESCRIPTION
# ===========
#
# Daje::Workflow::Activities::Tools::Generate::SQL is a module that generates SQL
#
# LICENSE
# =======
#
# Copyright (C) janeskil1525.
#
# This library is free software; you can redistribute it and/or modify
# it under the same terms as Perl itself.
#
# AUTHOR
# ======
#
# janeskil1525 E<lt>janeskil1525@gmail.comE<gt>
#


use Daje::Database::View::VToolsVersion;
use Daje::Database::View::VToolsObjectsTypes;
use Daje::Database::View::VToolsObjectsTables;;

has 'versions';
has 'tables';

sub generate_sql($self) {
    my $versions;
    # $self->model->insert_history(
    #     "New project",
    #     "Daje::Workflow::Activity::Tools::Generate::SQL::generate_sql",
    #     1
    # );

    try {
        my $tools_projects_pkey = $self->context->{context}->{payload}->{tools_projects_pkey};
        if ($self->load_parameters('Sql', $tools_projects_pkey)) {
            if ($self->load_versions($tools_projects_pkey)) {
                my $length = scalar @{$self->versions};
                for (my $i = 0; $i < $length; $i++) {
                    my $data->{version} = @{$self->versions}[$i]->{version};
                    if ($self->load_tables($tools_projects_pkey, @{$self->versions}[$i]->{tools_version_pkey})) {
                        my $tables;
                        my $len = scalar @{$self->tables};
                        for (my $j = 0; $j < $len; $j++) {
                            my $table = $self->process_table(@{$self->tables}[$j], @{$self->versions}[$i]);
                            push @{$tables}, $table;
                        }
                        $data->{tables} = $tables;
                    }
                    push @{$versions->{data}}, $data;
                }
            }
        }
    } catch ($e) {
        say $e
        #$self->error->add_error($e);
    };
}

sub create_sql_string($self, $template, $data) {

}

sub process_table($self, $table, $tools_version) {
    my $fields = Daje::Database::View::VToolsObjectsTables->new(
        db => $self->db
    )->load_objects_tables(
        $table->{tools_objects_pkey}, $tools_version->{tools_version_pkey}
    );

    $table->{fields} = $fields;
    return $table;
}

sub load_tables($self, $tools_projects_pkey, $tools_version_pkey) {
    my $objects = Daje::Database::View::VToolsObjectsTypes->new(
        db => $self->db
    )->load_objects_type(
        1,$tools_projects_pkey,$tools_version_pkey
    );
    $self->tables($objects->{data});
    return $objects->{result};
}

sub load_versions($self, $tools_projects_pkey) {
    my $versions = Daje::Database::View::VToolsVersion->new(
        db => $self->db
    )->load_tools_version_fkey(
        $tools_projects_pkey
    );
    $self->versions($versions->{data});
    return $versions->{result};
}

1;