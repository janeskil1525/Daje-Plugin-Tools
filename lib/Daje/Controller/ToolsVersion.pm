package Daje::Controller::ToolsVersion;
use Mojo::Base 'Mojolicious::Controller', -signatures;
use v5.40;


# NAME
# ====
#
# Daje::Controller::ToolsVersion - Mojolicious Plugin
#
# SYNOPSIS
# ========
#
#
#
# DESCRIPTION
# ===========
#
# Daje::Controller::ToolsVersion is a Mojolicious Controller.
#
# METHODS
# =======
#
#
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

sub load_versions_list ($self) {

    $self->app->log->debug('Daje::Controller::ToolsVersion::load_versions_list');
    $self->render_later;
    # my ($companies_pkey, $users_pkey) = $self->jwt->companies_users_pkey(
    #     $self->req->headers->header('X-Token-Check')
    # );

    $self->app->log->debug($self->req->headers->header('X-Token-Check'));
    # my $setting = $self->param('setting');
    $self->v_tools_versions->load_full_list_p()->then(sub($result) {
        $self->render(json => $result->{data});
    })->catch(sub($err) {
        $self->render(json => { 'result' => 'failed', data => $err });
    })->wait;
}

sub load_versions ($self) {

    $self->app->log->debug('Daje::Controller::ToolsVersion::load_versions');
    my $tools_version_pkey = $self->param('tools_version_pkey');
    $self->render_later;
    # my ($companies_pkey, $users_pkey) = $self->jwt->companies_users_pkey(
    #     $self->req->headers->header('X-Token-Check')
    # );

    $self->app->log->debug($self->req->headers->header('X-Token-Check'));
    # my $setting = $self->param('setting');
    $self->v_tools_versions->load_pkey_p($tools_version_pkey)->then(sub($result) {
        $self->render(json => $result->{data});
    })->catch(sub($err) {
        $self->render(json => { 'result' => 'failed', data => $err });
    })->wait;
}
1;