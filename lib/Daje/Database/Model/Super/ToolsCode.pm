package Daje::Database::Model::Super::ToolsCode;
use Mojo::Base 'Daje::Database::Model::Super::Common::Base', -base, -signatures, -async_await;;
use v5.42;

has 'fields' => 'tools_code_pkey, editnum, insby, insdatetime, modby, moddatetime, tools_objects_fkey, filename, filetype, content';
has 'primary_key_name' => "tools_code_pkey";
has 'table_name' => "tools_code";
has 'workflow' => '';


1;