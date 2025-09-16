package Daje::Database::Model::Super::ToolsVersion;
use Mojo::Base 'Daje::Database::Model::Super::Common::Base', -base, -signatures, -async_await;;

use Data::Dumper;

has 'fields' => "tools_version_pkey, editnum, insby, insdatetime, modby, moddatetime, tools_projects_fkey, version, locked";
has 'primary_key_name' => "tools_version_pkey";
has 'table_name' => "tools_version";


sub insert_tools_version($self, $data) {

    my $result = $self->insert($self->table_name, $data, $self->primary_key_name);
    return $result;
}

1;