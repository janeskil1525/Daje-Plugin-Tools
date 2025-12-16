package Daje::Workflow::Activities::Tools::Generate::Perl;
use Mojo::Base 'Daje::Workflow::Activities::Tools::Generate::Base', -base, -signatures;
use v5.42;

use POSIX;
use Mojo::Util qw { camelize };


sub generate_perl($self) {
    # $self->model->insert_history(
    #     "Generate SQL",
    #     "Daje::Workflow::Activity::Tools::Generate::Perl::generate_perl",
    #     1
    # );
    my @outputs = ('plugin', 'db_model_super');
    try {
        my $documents;
        my $tools_projects_pkey = $self->context->{context}->{payload}->{tools_projects_fkey};
        my $source = $self->get_parameter('Perl', 'Template Source', $tools_projects_pkey);
        foreach my $output (@outputs) {
            my $generate = "generate_$output";
            my $doc = $self->$generate($tools_projects_pkey, $source);
            push @{$documents}, $doc;
        }
    my @data;
        my $length = scalar @{$documents};
        for (my $i = 0; $i < $length; $i++) {
            my $data->{data} = @{$documents}[$i]->{document};
            my $filename = $self->get_parameter('Sql', 'Output file name', $tools_projects_pkey);
            $data->{file} = $self->get_parameter('Sql', 'Output Path', $tools_projects_pkey) . '/' . $filename;
            $data->{path} = 1;
            push(@data, $data);
        }
        $self->context->{context}->{payload}->{perl} = \@data;

    } catch($e) {
        say $e
            $self->error->add_error($e);
    };
}

sub generate_db_model_super($self, $tools_projects_pkey, $source) {
    my $tables;
    my $versions->{project_name} = $self->load_project_name($tools_projects_pkey);
    if($self->load_active_tables($tools_projects_pkey)) {
        my $length = scalar @{$self->tables};
        for (my $i = 0; $i < $length; $i++) {
            my $table = @{$self->tables}[$i];
            my $fields = $self->load_active_table_fields($table->{tools_objects_pkey});
            $table->{fields} = $fields;
            push @{$tables}, $table;
        }
    }
    $tables->{project_name} = $versions->{project_name};
    $self->versions($tables);

    my $documents = $self->build_documents($source,'db_model_super');
    return $documents;
}

sub generate_plugin($self, $tools_projects_pkey, $source) {

    my $versions->{project_name} = $self->load_project_name($tools_projects_pkey);

    $versions->{plugin_name} = camelize $versions->{project_name};
    $versions->{date_time} = strftime "%Y-%m-%d %H:%M:%S", localtime time;
    $self->versions($versions);
    my $documents = $self->build_documents($source,'plugin');
    return $documents;
}
1;