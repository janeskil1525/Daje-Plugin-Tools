[![Actions Status](https://github.com/janeskil1525/Daje-Plugin-Tools/actions/workflows/test.yml/badge.svg?branch=master)](https://github.com/janeskil1525/Daje-Plugin-Tools/actions?workflow=test)
# NAME

Daje::Plugin::Tools - Mojolicious Plugin

# SYNOPSIS

# DESCRIPTION

Daje::Plugin::Tools is a Mojolicious plugin.

# REQUIRES

[Daje::Database::Migrator](https://metacpan.org/pod/Daje%3A%3ADatabase%3A%3AMigrator) 

[Daje::Database::Helper::ParameterTreelist](https://metacpan.org/pod/Daje%3A%3ADatabase%3A%3AHelper%3A%3AParameterTreelist) 

[Daje::Database::Model::ToolsObjectViews](https://metacpan.org/pod/Daje%3A%3ADatabase%3A%3AModel%3A%3AToolsObjectViews) 

[Daje::Database::Model::ToolsParameterValues](https://metacpan.org/pod/Daje%3A%3ADatabase%3A%3AModel%3A%3AToolsParameterValues) 

[Daje::Database::Model::Super::ToolsParameters](https://metacpan.org/pod/Daje%3A%3ADatabase%3A%3AModel%3A%3ASuper%3A%3AToolsParameters) 

[Daje::Database::Model::ToolsObjectSQL](https://metacpan.org/pod/Daje%3A%3ADatabase%3A%3AModel%3A%3AToolsObjectSQL) 

[Daje::Database::Model::ToolsObjectIndex](https://metacpan.org/pod/Daje%3A%3ADatabase%3A%3AModel%3A%3AToolsObjectIndex) 

[Daje::Database::Model::ToolsObjectTypes](https://metacpan.org/pod/Daje%3A%3ADatabase%3A%3AModel%3A%3AToolsObjectTypes) 

[Daje::Database::Model::ToolsObjects](https://metacpan.org/pod/Daje%3A%3ADatabase%3A%3AModel%3A%3AToolsObjects) 

[Daje::Database::Model::ToolsObjectsTablesDatatypes](https://metacpan.org/pod/Daje%3A%3ADatabase%3A%3AModel%3A%3AToolsObjectsTablesDatatypes) 

[Daje::Database::Model::ToolsObjectsTables](https://metacpan.org/pod/Daje%3A%3ADatabase%3A%3AModel%3A%3AToolsObjectsTables) 

[Daje::Database::Model::ToolsVersion](https://metacpan.org/pod/Daje%3A%3ADatabase%3A%3AModel%3A%3AToolsVersion) 

[Daje::Database::View::VToolsVersion](https://metacpan.org/pod/Daje%3A%3ADatabase%3A%3AView%3A%3AVToolsVersion) 

[Daje::Database::View::VToolsProjects](https://metacpan.org/pod/Daje%3A%3ADatabase%3A%3AView%3A%3AVToolsProjects) 

[Daje::Database::Helper::TreeList](https://metacpan.org/pod/Daje%3A%3ADatabase%3A%3AHelper%3A%3ATreeList) 

[Daje::Database::Model::ToolsProjects](https://metacpan.org/pod/Daje%3A%3ADatabase%3A%3AModel%3A%3AToolsProjects) 

[Data::Dumper](https://metacpan.org/pod/Data%3A%3ADumper) 

[v5.42](https://metacpan.org/pod/v5.42) 

[Mojo::Base](https://metacpan.org/pod/Mojo%3A%3ABase) 

# METHODS

Daje::Plugin::Tools inherits all methods from
Mojolicious::Plugin and implements the following new ones.

# register

    $plugin->register(Mojolicious->new);

Register plugin in [Mojolicious](https://metacpan.org/pod/Mojolicious) application.

# Mojolicious::Lite

     plugin 'Tools';

# Mojolicious

     $self->plugin('Tools');

# SEE ALSO

Mojolicious, Mojolicious::Guides, https://mojolicious.org.

# AUTHOR

janeskil1525 &lt;janeskil1525@gmail.com

# LICENSE

Copyright (C) janeskil1525.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
