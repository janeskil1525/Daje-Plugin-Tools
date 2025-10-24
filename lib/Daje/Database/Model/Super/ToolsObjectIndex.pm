package Daje::Database::Model::Super::ToolsObjectIndex;
use Mojo::Base 'Daje::Database::Model::Super::Common::Base', -base, -signatures, -async_await;;

has 'fields' => "tools_object_index_pkey, editnum, insby, insdatetime, modby, moddatetime, tools_version_fkey, tools_objects_fkey, table_name, fields, index_unique";
has 'primary_key_name' => "tools_object_index_pkey";
has 'table_name' => "tools_object_index";



async sub load_tools_object_fkey_p($self, $tools_objects_fkey) {
    return $self->load_tools_objects_fkey($tools_objects_fkey);
}

async sub load_tools_object_index_pkey_p($self, $tools_object_index_pkey) {
    return $self->load_tools_object_pkey($tools_object_index_pkey)
}

sub load_tools_object_index_pkey($self, $tools_object_index_pkey) {
    return $self->load_pk(
        $self->table_name, $self->fields(), $self->primary_key_name(), $tools_object_index_pkey
    );
}

sub load_tools_objects_fkey($self, $tools_objects_fkey) {
    return $self->load_fkey(
        $self->table_name, $self->fields(), "tools_objects_fkey", $tools_objects_fkey
    );
}

sub load_tools_objects_index_fkey($self, $tools_object_index_pkey) {
    return $self->load_fkey(
        $self->table_name, $self->fields(), "tools_version_fkey", $tools_object_index_pkey
    );
}

sub insert_tools_objects_index($self, $data) {
    my $result = $self->insert($self->table_name, $data, $self->primary_key_name);
    return $result;
}


sub update_tools_objects_index($self, $data) {
    return $self->update($self->table_name, $data, { $self->primary_key_name() => $data->{$self->primary_key_name()}});
}


1;