package Daje::Workflow::Activity::Tools::Project;
use Mojo::Base 'Daje::Workflow::Common::Activity::Base', -base, -signatures;
use v5.42;

# NAME
# ====
#
# Daje::Workflow::Activity::Tools::Project - It creates perl code
#
# SYNOPSIS
# ========
#
#     use Daje::Workflow::Activity::Tools::Project
#
# DESCRIPTION
# ===========
#
# Daje::Workflow::Activity::Tools::Project is a module that generates perl code
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

use Data::Dumper;
use Daje::Database::Model::ToolsProjects;
use Daje::Database::Model::ToolsVersion;

sub new_project ($self) {

    try {
        $self->model->insert_history(
                "New project",
            "Daje::Workflow::Activity::Tools::Project::new_project",
            1
        );
        my $data = $self->context->{context}->{payload};
        my $tools_projects_pkey = Daje::Database::Model::ToolsProjects->new(
            db => $self->db
        )->insert_tools_projects($data);

        my $connection->{connector} = $self->context->{context}->{workflow}->{connector};
        $connection->{workflow_fkey} = $self->model->workflow_pkey();
        $connection->{connector_fkey} = $tools_projects_pkey->{data}->{tools_projects_pkey};
        $self->model->insert_connector($connection);

        my $tools_projects->{tools_projects_fkey} = $tools_projects_pkey->{data}->{tools_projects_pkey};
        Daje::Database::Model::ToolsVersion->new(
            db => $self->db
        )->insert_tools_version($tools_projects);

    } catch ($e) {
        $self->error->add_error($e);
    };

    return 1;
}
1;