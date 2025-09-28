package Daje::Database::View::Super::VToolsVersion;
use Mojo::Base 'Daje::Database::Model::Super::Common::Base', -base, -signatures, -async_await;
use v5.40;

# NAME
# ====
#
# Daje::Database::View::Super::VToolsVersion - It creates perl code
#
# SYNOPSIS
# ========
#
#     use Daje::Database::View::Super::VToolsVersion;
#
# DESCRIPTION
# ===========
#
# Daje::Database::View::Super::VToolsVersion is a module that retrieves data from a View
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

has 'fields' => "tools_version_pkey, editnum, insby, insdatetime, modby, moddatetime, tools_projects_fkey, version, locked, name, workflow_fkey";
has 'primary_keys' => "tools_version_pkey";
has 'foreign_keys' => "tools_projects_fkey, workflow_fkey";
has 'view_name' => "v_tools_objects_workflow_fkey";


async sub load_full_list_p($self) {
    my $result = $self->load_a_full_list(
        $self->view_name,
        $self->fields
    );
    return $result;
}

async sub load_full_list($self) {
    my $result = $self->load_a_full_list(
        $self->view_name,
        $self->fields
    );
    return $result;
}

sub load_pkey($self, $tools_version_pkey) {

    my $result = $self->load_pk(
        $self->view_name,
        $self->fields,
        $self->primary_keys,
        $tools_version_pkey
    );
    return $result;
}

sub load_tools_version_fkey($self, $tools_projects_pkey) {

    return $self->load_fkey(
        $self->view_name, $self->fields(), "tools_projects_fkey", $tools_projects_pkey
    );
}
1;