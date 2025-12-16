package Daje::Document::Templates::Tools::Generate::Perl;
use Mojo::Base 'Daje::Document::Templates::Base', -base;
use v5.42;

# NAME
# ====
#
# Daje::Templates::Tools::Generate::Perl; - It creates perl code
#
# SYNOPSIS
# ========
#
#     use Daje::Templates::Tools::Generate::Perl;
#
#     Provides a method for the template to be loaded into the data structure
#
#     sub length_default_calc($self) returns a sub for setting details in template.
#
#
# DESCRIPTION
# ===========
#
# Daje::Templates::Tools::Generate::Perl; is a module that retrieves data from a View
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

sub set_subs($self) {
    $self->subs('');
}

1;

__DATA__

@@ db_model_super
package Daje::Database::Model::Super[% table_name %];
use Mojo::Base 'Daje::Database::Model::Super::Common::Base', -base, -signatures, -async_await;;
v5.42;


@@ plugin

package Daje::Plugin::[% plugin_name %];
use Mojo::Base 'Mojolicious::Plugin', -signatures;
use v5.42;

# NAME
# ====
#
# Daje::Plugin::[% plugin_name %] - Mojolicious Plugin
#
# SYNOPSIS
# ========
#
# Mojolicious
# ===========
#
#      $self->plugin('[% plugin_name %]');
#
# Mojolicious::Lite
# =================
#
#      plugin '[% plugin_name %]';
#
# DESCRIPTION
# ===========
#
# Daje::Plugin::[% plugin_name %] is a Mojolicious plugin.
#
# METHODS
# =======
#
# Daje::Plugin::[% plugin_name %] inherits all methods from
# Mojolicious::Plugin and implements the following new ones.
#
# register
# ========
#  $plugin->register(Mojolicious->new);
#
# Register plugin in L<Mojolicious> application.
#
# SEE ALSO
# ========
#
# Mojolicious, Mojolicious::Guides, https://mojolicious.org.
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
# janeskil1525 E<lt>janeskil1525@gmail.com
#

# This file is generated once automatically by Daje Tools [% date_time %].
# It will not be touched by Daje Tools again.


use Daje::Plugin::[% plugin_name %]::Routes;
use Daje::Plugin::[% plugin_name %]::Helpers;

our $VERSION = '0.01';

sub register ($self, $app, $config) {
    $app->log->debug("Daje::Plugin::[% plugin_name %]::register start");

    Daje::Plugin::[% plugin_name %]::Routes->new()->routes($app, $config);
    Daje::Plugin::[% plugin_name %]::Helpers->new()->helpers($app, $config);


    $app->log->debug("Daje::Plugin::[% plugin_name %]::register ends");
}

1;


