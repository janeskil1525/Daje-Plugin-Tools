package Daje::Database::Helper::TreeList;
use Mojo::Base  -base, -signatures, -async_await;
use v5.40;

use Data::Dumper;

use Daje::Database::Model::ToolsProjects;
use Daje::Database::Model::ToolsVersion;

has 'db';

async sub load_treelist($self, $tools_projects_pkey) {

    my $treelist;
    # my $project = $self->_load_project($tools_projects_pkey);
    # $self->_add_node($treelist, $project->{data}, 'tools_projects');

    my $versions = $self->_load_versions($tools_projects_pkey);
    say "Daje::Database::Helper::TreeList::load_treelist" . Dumper($versions);
    my $length = scalar @{$versions->{data}};
    for (my $i = 0; $i < $length; $i++) {


        my $node = $self->_add_node($treelist, @{$versions->{data}}[$i], 'tools_version', 0);
        push (@{$treelist->{data}}, $node);

    }

    return $treelist;
}


sub _add_node($self, $treelist, $data, $type, $level) {

    say "Daje::Database::Helper::TreeList::_add_node data " . Dumper($data);
    my $res->{id} = $data->{tools_version_pkey} . "-" . $type;
    $res->{label} = $data->{name} ;
    $res->{data} = $data->{name} . ' ' . $data->{version} ;
    $res->{icon} = 'pi pi-fw pi-inbox';
    $res->{children} = [];
    say "Daje::Database::Helper::TreeList::_add_node res " . Dumper($res);

    my $test = 1;
    return $res;
}

sub _load_versions($self, $tools_projects_pkey) {
    return Daje::Database::Model::ToolsVersion->new(
        db => $self->db
    )->load_tools_version_fkey($tools_projects_pkey)
}

sub _load_project($self, $tools_projects_pkey) {

    return Daje::Database::Model::ToolsProjects->new(
        db => $self->db
    )->load_pkey(
        $tools_projects_pkey
    );
}
1;