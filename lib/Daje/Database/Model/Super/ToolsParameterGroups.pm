package Daje::Database::Model::Super::ToolsParameterGroups;
use Mojo::Base 'Daje::Database::Model::Super::Common::Base', -base, -signatures, -async_await;;

has 'fields' => "tools_parameter_groups_pkey, editnum, insby, insdatetime, modby, moddatetime, parameter_group";
has 'primary_key_name' => "tools_parameter_groups_pkey";
has 'table_name' => "tools_parameter_groups";


async sub load_tools_parameter_groups_pkey_p($self, $tools_parameter_groups_pkey) {
    return $self->load_tools_parameter_groups_pkey($self, $tools_parameter_groups_pkey);
}

sub load_tools_parameter_groups_pkey($self, $tools_parameter_groups_pkey) {
    return $self->load_pk(
        $self->table_name, $self->fields(), $self->primary_key_name(), $tools_parameter_groups_pkey
    );
}

sub load_tools_parameter_groups($self) {
    return $self->load_a_full_list(
        $self->table_name, $self->fields()
    );
}

sub insert($self, $data) {
    my $result = $self->SUPER::insert($self->table_name, $data, $self->primary_key_name);
    return $result;
}


sub update($self, $data) {
    return $self->SUPER::update($self->table_name, $data, { $self->primary_key_name() => $data->{$self->primary_key_name()}});
}


1;