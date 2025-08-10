package Daje::Plugin::Tools;
use Mojo::Base 'Mojolicious::Plugin', -signatures;

# NAME

# Mojolicious::Plugin::Daje-Plugin-Tools - Mojolicious Plugin

# SYNOPSIS

  # Mojolicious
#      $self->plugin('Daje-Plugin-Tools');

  # Mojolicious::Lite
#      plugin 'Daje-Plugin-Tools';

# DESCRIPTION

# Mojolicious::Plugin::Daje-Plugin-Tools is a Mojolicious plugin.

# METHODS

# Daje-Plugin-Tools inherits all methods from
# Mojolicious::Plugin and implements the following new ones.

# register

#  $plugin->register(Mojolicious->new);

# Register plugin in L<Mojolicious> application.

# SEE ALSO

# Mojolicious, Mojolicious::Guides, https://mojolicious.org.

# LICENSE

# Copyright (C) janeskil1525.

# This library is free software; you can redistribute it and/or modify
# it under the same terms as Perl itself.

# AUTHOR

# janeskil1525 E<lt>janeskil1525@gmail.comE<gt>


our $VERSION = '0.01';

sub register ($self, $app) {

    try {
        Daje::Workflow::Database->new(
            pg         => $app->pg,
            migrations => $app->config('migrations'),
        )->migrate();
    } catch ($e) {
        $app->log->error($e);
    };

}

1;

