package Daje::Workflow::Activities::Tools::Generate::Angular;
use Mojo::Base 'Daje::Workflow::Activities::Tools::Generate::Base', -base, -signatures;
use v5.42;

use POSIX;
use Mojo::Util qw { camelize };
use String::Util 'trim';
use Data::Dumper;

sub generate_angular($self) {
    $self->model->insert_history(
        "Generate Angular",
        "Daje::Workflow::Activities::Tools::Generate::Angular::generate_angular",
        1
    );

    my $tools_projects_pkey = $self->context->{context}->{payload}->{tools_projects_fkey};
    my @outputs = split /,/,  $self->get_parameter('Angular', 'Outputs', $tools_projects_pkey);;
    try {
        my $documents;
        my $source = $self->get_parameter('Angular', 'Template Source', $tools_projects_pkey);
        foreach my $output (@outputs) {
            my $generate = "generate_" . trim($output);
            say Dumper($generate);
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
            $data->{tools_objects_pkey} = @{ $documents }[$i]->{tools_objects_pkey}
                if(exists @{ $documents }[$i]->{tools_objects_pkey});
            $data->{path} = 1;
            push(@data, $data);
        }
        $self->context->{context}->{payload}->{angular} = \@data;

    } catch($e) {
        say $e
            $self->error->add_error($e);
    };
}

sub generate_endpoints($self, $tools_projects_pkey, $source) {
    my $docs;
    my $tables;
    my $project_name = $self->load_project_name($tools_projects_pkey);
    my $class_name = camelize $project_name;
    if($self->load_active_tables($tools_projects_pkey)) {
        $tables->{project_name} = $project_name;
        $tables->{class_name} = $class_name;
        $tables->{date_time} = strftime "%Y-%m-%d %H:%M:%S", localtime time;
        my $length = scalar @{$self->tables};
        for (my $i = 0; $i < $length; $i++) {
            my $table = @{$self->tables}[$i];
            $table->{class_name} = camelize $project_name . "_" . $table->{table_name};
            $table->{fields} = $self->load_active_table_fields($table->{tools_objects_pkey});
            push @{$tables->{tables}}, $table;
        }
        $self->versions($tables);
        my $documents = $self->build_documents($source,'endpoints');
        @{ $documents }[0]->{file} = $self->get_parameter('Angular', 'Component file path', $tools_projects_pkey) .  $tables->{project_name}  . '_endpoints/' . $tables->{project_name} . '.endpoints.ts';
        @{ $documents }[0]->{new_only} = 0;
        push @{$docs}, @{ $documents }[0];
    }
    return $docs;
}


sub generate_component($self, $tools_projects_pkey, $source) {
    my $docs;
    my $project_name = $self->load_project_name($tools_projects_pkey);
    if($self->load_active_tables($tools_projects_pkey)) {
        my $length = scalar @{$self->tables};
        for (my $i = 0; $i < $length; $i++) {
            my $table->{table} = @{$self->tables}[$i];
            $table->{date_time} = strftime "%Y-%m-%d %H:%M:%S", localtime time;
            $table->{project_name} = $project_name;
            $table->{fields} = $self->load_active_table_fields($table->{table}->{tools_objects_pkey});
            $table->{class_name} = camelize $table->{project_name} . "_" . $table->{table}->{table_name};
            $self->versions($table);
            my $documents = $self->build_documents($source,'component');
            @{ $documents }[0]->{class_name} = $table->{class_name};
            @{ $documents }[0]->{file} = $self->get_parameter('Angular', 'Component file path', $tools_projects_pkey) . $table->{table}->{table_name} . '/' . $table->{table}->{table_name} . '.component.ts';
            @{ $documents }[0]->{new_only} = 1;
            @{ $documents }[0]->{new_only} = 0 if( $table->{table}->{generate_file} == 1 );
            @{ $documents }[0]->{tools_objects_pkey} = $table->{table}->{tools_objects_pkey};
            push @{$docs}, @{ $documents }[0];
            $documents = $self->build_documents($source,'component_html');
            @{ $documents }[0]->{class_name} = $table->{class_name};
            @{ $documents }[0]->{file} = $self->get_parameter('Angular', 'Component file path', $tools_projects_pkey) . $table->{table}->{table_name} . '/' . $table->{table}->{table_name} . '.component.html';
            @{ $documents }[0]->{new_only} = 1;
            @{ $documents }[0]->{new_only} = 0 if( $table->{table}->{generate_file} == 1 );
            @{ $documents }[0]->{tools_objects_pkey} = $table->{table}->{tools_objects_pkey};
            push @{$docs}, @{ $documents }[0];
            $documents = $self->build_documents($source,'interface');
            @{ $documents }[0]->{class_name} = $table->{class_name};
            @{ $documents }[0]->{file} = $self->get_parameter('Angular', 'Component file path', $tools_projects_pkey) .  $table->{table}->{table_name}  . '/' . $table->{table}->{table_name}. '.interface.ts';
            @{ $documents }[0]->{new_only} = 0;
            @{ $documents }[0]->{tools_objects_pkey} = $table->{table}->{tools_objects_pkey};
            push @{$docs}, @{ $documents }[0];
            $documents = $self->build_documents($source,'css');
            @{ $documents }[0]->{class_name} = $table->{class_name};
            @{ $documents }[0]->{file} = $self->get_parameter('Angular', 'Component file path', $tools_projects_pkey) .  $table->{table}->{table_name}  . '/' . $table->{table}->{table_name}. '.component.css';
            @{ $documents }[0]->{new_only} = 0;
            @{ $documents }[0]->{tools_objects_pkey} = $table->{table}->{tools_objects_pkey};
            push @{$docs}, @{ $documents }[0];

        }
    }

    return $docs;
}
1;
#################### pod generated by Pod::Autopod - keep this line to make pod updates possible ####################

=head1 NAME

Daje::Workflow::Activities::Tools::Generate::Angular


=head1 DESCRIPTION

$self->model->insert_history(
    "Generate Angular",
    "Daje::Workflow::Activities::Tools::Generate::Angular::generate_angular",
    1
);


=head1 REQUIRES

L<String::Util> 

L<Mojo::Util> 

L<POSIX> 

L<v5.42> 

L<Mojo::Base> 


=head1 METHODS

=head2 generate_angular($self)

 generate_angular($self)();

=head2 generate_component($self,

 generate_component($self,();

=head2 generate_endpoints($self,

 generate_endpoints($self,();


=cut

