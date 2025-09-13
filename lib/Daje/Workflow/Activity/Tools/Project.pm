package Daje::Workflow::Activity::Tools::Project;
use Mojo::Base 'Daje::Workflow::Common::Activity::Base', -base, -signatures;
use v5.40;

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

sub execute ($self) {

    say Dumper("Inside Daje::Workflow::Activity::Tools::Project::execute " . $self->context->{context});

    return 1;
}
1;