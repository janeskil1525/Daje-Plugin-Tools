package Daje::Controller::Tools;
use Mojo::Base 'Mojolicious::Controller', -signatures;
use v5.40;

# NAME
# ====
#
# Daje::Controller::Tools - Mojolicious Plugin
#
# SYNOPSIS
# ========
#
#
#
# DESCRIPTION
# ===========
#
# Daje::Controller::Tools is a Mojolicious plugin.
#
# METHODS
# =======
#
# Register plugin in L<Mojolicious> application.
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


sub load_projects {

    $self->render_later;
    # my ($companies_pkey, $users_pkey) = $self->jwt->companies_users_pkey(
    #     $self->req->headers->header('X-Token-Check')
    # );

    my $setting = $self->param('setting');
    $self->projects->load_projects()->then(sub($result) {
        $self->render(json => { 'result' => 'success', data => $result });
    })->catch(sub($err) {
        $self->render(json => { 'result' => 'failed', data => $err });
    })->wait;
}

sub save_projects {
    $self->render_later;

    my $json_hash = decode_json ($self->req->body);
    $self->projects->save_projects($json_hash)->then(sub ($result) {
        $self->render(json => {'result' => $result});
    })->catch( sub ($err) {
        $self->render(json => {'result' => $err});
    })->wait;
}


1;