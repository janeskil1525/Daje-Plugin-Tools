package Daje::Workflow::Activity::Tools::GenerateBase;
use Mojo::Base 'Daje::Workflow::Common::Activity::Base', -base, -signatures;
use v5.42;

# NAME
# ====
#
# Daje::Workflow::Activity::Tools::GenerateBase - Base class fro generate activities
#
# SYNOPSIS
# ========
#
#     use Daje::Workflow::Activity::Tools::GenerateBase
#
# DESCRIPTION
# ===========
#
# Daje::Workflow::Activity::Tools::GenerateBase is a base class holding common methods
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

use Daje::Database::View::VToolsParameterValues;

has 'parameters';

sub load_parameters($self, $group, $tools_projects_pkey) {
    my $parameters = Daje::Database::View::VToolsParameterValues->new(
        db => $self->db
    )->load_parameters_from_group(
        $group, $tools_projects_pkey
    );

    $self->parameters($parameters->{data}) if ($parameters->{result} == 1) ;

    return $parameters->{result};
}

1;