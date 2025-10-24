package Daje::Database::Model::Super::ToolsParameters;
use Mojo::Base 'Daje::Database::Model::Super::Common::Base', -base, -signatures, -async_await;;

has 'fields' => "tools_parameters_pkey, editnum, insby, insdatetime, modby, moddatetime, tools_projects_fkey, parameter";
has 'primary_key_name' => "tools_parameters_pkey";
has 'table_name' => "tools_parameters";


async sub load_tools_parameters_pkey_p($self, $tools_parameters_pkey) {
    return $self->load_tools_parameters_pkey($self, $tools_parameters_pkey);
}

sub load_tools_parameters_pkey($self, $tools_parameters_pkey) {

    return $self->load_pk(
        $self->table_name, $self->fields(), $self->primary_key_name(), $tools_parameters_pkey
    );
}

sub load_tools_projects_fkey($self, $tools_projects_pkey) {

    return $self->load_fkey(
        $self->table_name, $self->fields(), "tools_projects_fkey", $tools_projects_pkey
    );
}

sub insert_tools_parameters($self, $data) {
    my $result = $self->insert($self->table_name, $data, $self->primary_key_name);
    return $result;
}


sub update_tools_parameters($self, $data) {
    return $self->update($self->table_name, $data, { $self->primary_key_name() => $data->{$self->primary_key_name()}});
}


1;