package Daje::Database::Model::Super::ToolsParameterValues;
use Mojo::Base 'Daje::Database::Model::Super::Common::Base', -base, -signatures, -async_await;;

has 'fields' => "tools_parameter_values_pkey, editnum, insby, insdatetime, modby, moddatetime, tools_parameters_fkey, name, parameter_value";
has 'primary_key_name' => "tools_parameter_values_pkey";
has 'table_name' => "tools_parameter_values";


async sub load_tools_parameter_values_pkey_p($self, $tools_parameters_pkey) {
    return $self->load_tools_parameter_values_pkey($self, $tools_parameters_pkey);
}

sub load_tools_parameter_values_pkey($self, $tools_parameters_pkey) {

    return $self->load_pk(
        $self->table_name, $self->fields(), $self->primary_key_name(), $tools_parameters_pkey
    );
}

sub load_tools_parameters_fkey($self, $tools_parameters_fkey) {

    return $self->load_fkey(
        $self->table_name, $self->fields(), "tools_parameters_fkey", $tools_parameters_fkey
    );
}

sub insert_tools_parameter_values($self, $data) {
    my $result = $self->insert($self->table_name, $data, $self->primary_key_name);
    return $result;
}


sub update_tools_parameter_values($self, $data) {
    return $self->update($self->table_name, $data, { $self->primary_key_name() => $data->{$self->primary_key_name()}});
}


1;