package Daje::Workflow::Activity::Tools::GenerateSQL;
use Mojo::Base 'Daje::Workflow::Common::Activity::Base', -base, -signatures;
use v5.42;

# NAME
# ====
#
# Daje::Workflow::Activity::Tools::GenerateSQL - Generate SQL
# migration files for Mojo::Pg
#
# SYNOPSIS
# ========
#
#     use Daje::Workflow::Activity::Tools::GenerateSQL
#
# DESCRIPTION
# ===========
#
# Daje::Workflow::Activity::Tools::GenerateSQL is a module that generates SQL
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

sub generate_sql($self) {
    $self->model->insert_history(
        "New project",
        "Daje::Workflow::Activity::Tools::GenerateSQL::generate_sql",
        1
    );
    my $tools_projects_pkey = $self->context->{context}->{payload}->{tools_projects_pkey};

}
1;