package Daje::Workflow::Activities::Tools::Generate::Angular;
use Mojo::Base 'Daje::Workflow::Activities::Tools::Generate::Base', -base, -signatures;
use v5.42;

use POSIX;
use Mojo::Util qw { camelize };


sub generate_angular($self) {
    my @outputs = ('interface');

    try {
        my $documents;
        my $tools_projects_pkey = $self->context->{context}->{payload}->{tools_projects_fkey};
        my $source = $self->get_parameter('Angular', 'Template Source', $tools_projects_pkey);
        foreach my $output (@outputs) {
            my $generate = "generate_$output";
            my $doc = $self->$generate($tools_projects_pkey, $source);
            if (ref $doc eq 'ARRAY') {
                my $length = scalar @{ $doc };
                for (my $i = 0; $i < $length; $i++) {
                    push @{$documents}, @{ $doc }[$i];
                }
            } else {
                push @{$documents}, $doc;
            }

        }
        my @data;
        my $length = scalar @{$documents};
        for (my $i = 0; $i < $length; $i++) {
            my $data->{data} = @{$documents}[$i]->{document};
            $data->{file} = @{ $documents }[$i]->{file};
            $data->{new_only} = @{ $documents }[$i]->{new_only}
                if exists @{ $documents }[$i]->{new_only};
            $data->{path} = 1;
            push(@data, $data);
        }
        $self->context->{context}->{payload}->{perl} = \@data;

    } catch($e) {
        say $e
            $self->error->add_error($e);
    };

}

sub generate_interface($self, $tools_projects_pkey, $source) {
    my $docs;
    my $project_name = $self->load_project_name($tools_projects_pkey);
    if($self->load_active_tables($tools_projects_pkey)) {
        my $length = scalar @{$self->tables};
        for (my $i = 0; $i < $length; $i++) {
            my $table->{table} = @{$self->tables}[$i];
            $table->{project_name} = $project_name;
            $table->{fields} = $self->load_active_table_fields($table->{table}->{tools_objects_pkey});
            $table->{class_name} = camelize $table->{project_name} . "_" . $table->{table}->{table_name};
            $self->versions($table);
            my $documents = $self->build_documents($source,'interface');
            @{ $documents }[0]->{class_name} = $table->{class_name};
            @{ $documents }[0]->{file} = $self->get_parameter('Angular', 'Interface file path', $tools_projects_pkey) . 'Super/' . $table->{class_name} . '.pm';
            @{ $documents }[0]->{new_only} = 0;
            push @{$docs}, @{ $documents }[0];
        }
    }

}
1;