package Daje::Database::Model::Super::ToolsObjectsTables;
use Mojo::Base 'Daje::Database::Model::Super::Common::Base', -base, -signatures, -async_await;;

has 'fields' => "tools_objects_tables_pkey, editnum, insby, insdatetime, modby, moddatetime, tools_version_fkey, tools_objects_fkey, fieldname, datatype, length, scale, active, visible";
has 'primary_key_name' => "tools_objects_tables_pkey";
has 'table_name' => "tools_objects_tables";



async sub load_tools_objects_tables_fkey_p($self, $tools_objects_pkey) {

    return $self->load_fkey(
        $self->table_name, $self->fields(), "tools_objects_fkey", $tools_objects_pkey
    );
}

sub load_tools_objects_tables_fkey($self, $tools_objects_pkey) {

    return $self->load_fkey(
        $self->table_name, $self->fields(), "tools_objects_fkey", $tools_objects_pkey
    );
}

sub insert_tools_objects_tables($self, $data) {
    my $result = $self->insert($self->table_name, $data, $self->primary_key_name);
    return $result;
}


sub update_tools_objects_tables($self, $data) {
    return $self->update($self->table_name, $data, { $self->primary_key_name() => $data->{$self->primary_key_name()}});
}


1;