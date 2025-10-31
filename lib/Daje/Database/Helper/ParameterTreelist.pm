package Daje::Database::Helper::ParameterTreelist;
use Mojo::Base  -base, -signatures, -async_await;
use v5.42;

use Data::Dumper;

use Daje::Database::Model::ToolsParameterGroups;
use Daje::Database::Model::ToolsParameters;

has 'db';

async sub load_treelist($self) {
    my $treelist;
    my $groups = Daje::Database::Model::ToolsParameterGroups->new(
        db => $self->db
    )->load_tools_parameter_groups();

    my $length = scalar @{$groups};
    for( my $i = 0; $i < $groups; $i++) {
        my $node = $self->_add_groups(
            @{$groups->{data}}[$i], 'tools_parameter_groups'
        );
        $self->add_parameters($node,)
        push (@{$treelist->{data}}, $node);
    }

    return $treelist;
}

sub add_parameters($self, $node, $tools_parameter_groups_fkey) {
    my $parameters = Daje::Database::Model::ToolsParameters->new(
        db => $self->db
    )->load_tools_parameters_fkey(
        $tools_parameter_groups_fkey
    );

    my $length = scalar @{$parameters};
    for (my $i = 0; $i < $length; $i++) {
        my $res->{id} = @{$parameters->{data}}[$i]->{tools_parameter_pkey} . "-tools_parameters";
        $res->{label} = @{$parameters->{data}}[$i]->{parameter_group};
        $res->{data} = @{$parameters->{data}}[$i];
        $res->{icon} = 'pi pi-fw pi-folder';
        $res->{children} = [];
        push(@{$node->{children}}, $res);
    }
}

sub _add_groups($self, $data, $type ) {

    my $res->{id} = $data->{tools_parameter_groups_pkey} . "-" . $type;
    $res->{label} = $data->{parameter_group} ;
    $res->{data} = $data ;
    $res->{icon} = 'pi pi-fw pi-folder';
    $res->{children} = [];
    return $res;
}

1;