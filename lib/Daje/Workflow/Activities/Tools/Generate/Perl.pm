package Daje::Workflow::Activities::Tools::Generate::Perl;
use Mojo::Base 'Daje::Workflow::Activities::Tools::Generate::Base', -base, -signatures;
use v5.42;

use POSIX;
use Mojo::Util qw { camelize };
use String::Util 'trim';
use Data::Dumper;

sub generate_perl($self) {
    $self->model->insert_history(
        "Generate Perl",
        "Daje::Workflow::Activities::Tools::Generate::Perl::generate_perl",
        1
    );

    my $tools_projects_pkey = $self->context->{context}->{payload}->{tools_projects_fkey};
    my @outputs = split /,/,  $self->get_parameter('Perl', 'Outputs', $tools_projects_pkey);;
    try {
        my $documents;
        my $source = $self->get_parameter('Perl', 'Template Source', $tools_projects_pkey);
        foreach my $output (@outputs) {
            my $generate = "generate_" . trim($output);
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
        $self->context->{context}->{payload}->{perl} = \@data;

    } catch($e) {
        say $e;
        $self->error->add_error($e);
    };
}

sub generate_controller($self, $tools_projects_pkey, $source) {
    my $docs;
    my $project_name = $self->load_project_name($tools_projects_pkey);
    if($self->load_active_tables($tools_projects_pkey)) {
        my $length = scalar @{$self->tables};
        for (my $i = 0; $i < $length; $i++) {
            my $table->{table} = @{$self->tables}[$i];
            $table->{project_name} = $project_name;
            $table->{tablename} = $table->{table}->{table_name};
            $table->{project} = camelize $table->{project_name};
            $table->{class_name} = camelize $table->{project_name} . "_" . $table->{table}->{table_name};
            $table->{date_time} = strftime "%Y-%m-%d %H:%M:%S", localtime time;
            $self->versions($table);
            my $documents = $self->build_documents($source,'controller');
            @{ $documents }[0]->{class_name} = $table->{class_name};
            @{ $documents }[0]->{file} = $self->get_parameter('Perl', 'Base file path', $tools_projects_pkey) .  "lib/Daje/Controller/" . $table->{project} . "/" . $table->{class_name} . '.pm';
            @{ $documents }[0]->{new_only} = 1;
            @{ $documents }[0]->{tools_objects_pkey} = $table->{table}->{tools_objects_pkey};
            push @{$docs}, @{ $documents }[0];
            $documents = $self->build_documents($source,'tests_controller');
            @{ $documents }[0]->{class_name} = $table->{class_name};
            @{ $documents }[0]->{file} = $self->get_parameter('Perl', 'Base file path', $tools_projects_pkey) . "t/" . $table->{table}->{table_name} . '.controller.t';
            @{ $documents }[0]->{new_only} = 0;
            @{ $documents }[0]->{tools_objects_pkey} = $table->{table}->{tools_objects_pkey};
            push @{$docs}, @{ $documents }[0];
            $documents = $self->build_documents($source,'controller_list');
            @{ $documents }[0]->{class_name} = $table->{class_name};
            @{ $documents }[0]->{file} = $self->get_parameter('Perl', 'Base file path', $tools_projects_pkey) . "lib/Daje/Controller/" . $table->{project} . "/" . $table->{class_name} . 'List.pm';
            @{ $documents }[0]->{new_only} = 1;
            @{ $documents }[0]->{tools_objects_pkey} = $table->{table}->{tools_objects_pkey};
            push @{$docs}, @{ $documents }[0];
        }
    }

    return $docs;
}

sub generate_super_controller($self, $tools_projects_pkey, $source) {
    my $docs;
    my $project_name = $self->load_project_name($tools_projects_pkey);
    if($self->load_active_tables($tools_projects_pkey)) {
        my $length = scalar @{$self->tables};
        for (my $i = 0; $i < $length; $i++) {
            my $table->{table} = @{$self->tables}[$i];
            $table->{project_name} = $project_name;
            $table->{project} = camelize $table->{project_name};
            $table->{fields} = $self->load_active_table_fields($table->{table}->{tools_objects_pkey});
            $table->{class_name} = camelize $table->{project_name} . "_" . $table->{table}->{table_name};
            $table->{date_time} = strftime "%Y-%m-%d %H:%M:%S", localtime time;
            $self->versions($table);
            my $documents = $self->build_documents($source,'super_controller');
            @{ $documents }[0]->{class_name} = $table->{class_name};
            @{ $documents }[0]->{file} = $self->get_parameter('Perl', 'Base file path', $tools_projects_pkey) . "lib/Daje/Controller/" . $table->{project} . '/Super/' . $table->{class_name} . '.pm';
            @{ $documents }[0]->{new_only} = 0;
            @{ $documents }[0]->{tools_objects_pkey} = $table->{table}->{tools_objects_pkey};
            push @{$docs}, @{ $documents }[0];
            $documents = $self->build_documents($source,'super_controller_list');
            @{ $documents }[0]->{class_name} = $table->{class_name};
            @{ $documents }[0]->{file} = $self->get_parameter('Perl', 'Base file path', $tools_projects_pkey) . "lib/Daje/Controller/" . $table->{project} . '/Super/' . $table->{class_name} . 'List.pm';
            @{ $documents }[0]->{new_only} = 0;
            @{ $documents }[0]->{tools_objects_pkey} = $table->{table}->{tools_objects_pkey};
            push @{$docs}, @{ $documents }[0];

        }
    }

    return $docs;
}

sub generate_helpers($self, $tools_projects_pkey, $source) {
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
        my $documents = $self->build_documents($source,'helpers');
        @{ $documents }[0]->{file} = $self->get_parameter('Perl', 'Base file path', $tools_projects_pkey) . "lib/Daje/Plugin/" . $class_name . "/Helpers.pm";
        @{ $documents }[0]->{new_only} = 0;
        push @{$docs}, @{ $documents }[0];
    }
    return $docs;
}

sub generate_routes($self, $tools_projects_pkey, $source) {
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
        my $documents = $self->build_documents($source,'routes');
        @{ $documents }[0]->{file} = $self->get_parameter('Perl', 'Base file path', $tools_projects_pkey) . "lib/Daje/Plugin/" . $class_name ."/Routes.pm";
        @{ $documents }[0]->{new_only} = 0;
        push @{$docs}, @{ $documents }[0];
        $documents = $self->build_documents($source,'authorities');
        @{ $documents }[0]->{file} = $self->get_parameter('Perl', 'Base file path', $tools_projects_pkey) . "lib/Daje/Plugin/" . $class_name ."/Authorities.pm";
        @{ $documents }[0]->{new_only} = 0;
        push @{$docs}, @{ $documents }[0];
        $documents = $self->build_documents($source,'languages');
        @{ $documents }[0]->{file} = $self->get_parameter('Perl', 'Base file path', $tools_projects_pkey) . "lib/Daje/Plugin/" . $class_name ."/Languages.pm";
        @{ $documents }[0]->{new_only} = 0;
        push @{$docs}, @{ $documents }[0];


    }
    return $docs;
}

sub generate_db_model($self, $tools_projects_pkey, $source) {
    my $docs;
    my $project_name = $self->load_project_name($tools_projects_pkey);
    if($self->load_active_tables($tools_projects_pkey)) {
        my $length = scalar @{$self->tables};
        for (my $i = 0; $i < $length; $i++) {
            my $table->{table} = @{$self->tables}[$i];
            $table->{class_name} = camelize $project_name . "_" . $table->{table}->{table_name};
            $table->{date_time} = strftime "%Y-%m-%d %H:%M:%S", localtime time;
            $self->versions($table);

            my $documents = $self->build_documents($source,'db_model');
            @{ $documents }[0]->{class_name} = $table->{class_name};
            @{ $documents }[0]->{file} = $self->get_parameter('Perl', 'Base file path', $tools_projects_pkey) . "lib/Daje/Database/Model/" . $table->{class_name} . '.pm';
            @{ $documents }[0]->{new_only} = 1;
            @{ $documents }[0]->{tools_objects_pkey} = $table->{table}->{tools_objects_pkey};
            push @{$docs}, @{ $documents }[0];
            $documents = $self->build_documents($source,'tests_database_model');
            @{ $documents }[0]->{class_name} = $table->{class_name};
            @{ $documents }[0]->{file} = $self->get_parameter('Perl', 'Base file path', $tools_projects_pkey) . "t/" . $table->{table}->{table_name} . '.model.t';
            @{ $documents }[0]->{new_only} = 0;
            @{ $documents }[0]->{tools_objects_pkey} = $table->{table}->{tools_objects_pkey};
            push @{$docs}, @{ $documents }[0];
            $documents = $self->build_documents($source,'db_view_list');
            @{ $documents }[0]->{class_name} = $table->{class_name};
            @{ $documents }[0]->{file} = $self->get_parameter('Perl', 'Base file path', $tools_projects_pkey) . "lib/Daje/Database/View/" . '/v' . $table->{class_name} . 'List.pm';
            @{ $documents }[0]->{new_only} = 1;
            @{ $documents }[0]->{tools_objects_pkey} = $table->{table}->{tools_objects_pkey};
            push @{$docs}, @{ $documents }[0];
            $documents = $self->build_documents($source,'db_view');
            @{ $documents }[0]->{class_name} = $table->{class_name};
            @{ $documents }[0]->{file} = $self->get_parameter('Perl', 'Base file path', $tools_projects_pkey) . "lib/Daje/Database/View/" . '/v' . $table->{class_name} . '.pm';
            @{ $documents }[0]->{new_only} = 1;
            @{ $documents }[0]->{tools_objects_pkey} = $table->{table}->{tools_objects_pkey};
            push @{$docs}, @{ $documents }[0];
        }
    }
    return $docs;
}

sub generate_db_model_super($self, $tools_projects_pkey, $source) {
    my $docs;
    my $project_name = $self->load_project_name($tools_projects_pkey);
    if($self->load_active_tables($tools_projects_pkey)) {
        my $length = scalar @{$self->tables};
        for (my $i = 0; $i < $length; $i++) {
            my $table->{table} = @{$self->tables}[$i];
            $table->{project_name} = $project_name;
            $table->{fields} = $self->load_active_table_fields($table->{table}->{tools_objects_pkey});
            $table->{has_company} = 0;
            my $len = scalar @{$table->{fields}};
            for (my $j = 0; $j < $len; $j++) {
                if(@{$table->{fields}}[$j]->{fieldname} eq 'companies' && @{$table->{fields}}[$j]->{foreign_key} == 1) {
                    $table->{has_company} = 1;
                    say "Has company";
                    say Dumper($table->{table});
                }
            }
            $table->{class_name} = camelize $table->{project_name} . "_" . $table->{table}->{table_name};
            $table->{date_time} = strftime "%Y-%m-%d %H:%M:%S", localtime time;
            $self->versions($table);
            my $documents = $self->build_documents($source,'db_model_super');
            @{ $documents }[0]->{class_name} = $table->{class_name};
            @{ $documents }[0]->{file} = $self->get_parameter('Perl', 'Base file path', $tools_projects_pkey) . "lib/Daje/Database/Model/Super/" . $table->{class_name} . '.pm';
            @{ $documents }[0]->{new_only} = 0;
            @{ $documents }[0]->{tools_objects_pkey} = $table->{table}->{tools_objects_pkey};
            push @{$docs}, @{ $documents }[0];
            $documents = $self->build_documents($source,'db_view_super_list');
            @{ $documents }[0]->{class_name} = $table->{class_name};
            @{ $documents }[0]->{file} = $self->get_parameter('Perl', 'Base file path', $tools_projects_pkey) . "lib/Daje/Database/View/Super/v" . $table->{class_name} . 'List.pm';
            @{ $documents }[0]->{new_only} = 0;
            @{ $documents }[0]->{tools_objects_pkey} = $table->{table}->{tools_objects_pkey};
            push @{$docs}, @{ $documents }[0];
            $documents = $self->build_documents($source,'db_view_super');
            @{ $documents }[0]->{class_name} = $table->{class_name};
            @{ $documents }[0]->{file} = $self->get_parameter('Perl', 'Base file path', $tools_projects_pkey) . "lib/Daje/Database/View/Super/v" . $table->{class_name} . '.pm';
            @{ $documents }[0]->{new_only} = 0;
            @{ $documents }[0]->{tools_objects_pkey} = $table->{table}->{tools_objects_pkey};
            push @{$docs}, @{ $documents }[0];

        }
    }

    return $docs;
}

sub generate_plugin($self, $tools_projects_pkey, $source) {
    my $docs;
    my $versions->{project_name} = $self->load_project_name($tools_projects_pkey);
    $versions->{section_name} = $self->load_project_name($tools_projects_pkey);
    $versions->{plugin_name} = camelize $versions->{project_name};
    $versions->{date_time} = strftime "%Y-%m-%d %H:%M:%S", localtime time;
    $self->versions($versions);
    my $documents = $self->build_documents($source,'plugin');
    @{ $documents }[0]->{file} = $self->get_parameter('Perl', 'Base file path', $tools_projects_pkey) .  "lib/Daje/Plugin/" . $versions->{plugin_name} . '.pm';
    @{ $documents }[0]->{new_only} = 1;
    push @{$docs}, @{ $documents }[0];
    $documents = $self->build_documents($source,'activity');
    @{ $documents }[0]->{file} = $self->get_parameter('Perl', 'Base file path', $tools_projects_pkey) .  "lib/Daje/Workflow/Activities/" . $versions->{plugin_name} . '/Activity.pm';
    @{ $documents }[0]->{new_only} = 1;
    push @{$docs}, @{ $documents }[0];

    return $docs;
}
1;
#################### pod generated by Pod::Autopod - keep this line to make pod updates possible ####################

=head1 NAME

Daje::Workflow::Activities::Tools::Generate::Perl


=head1 REQUIRES

L<String::Util> 

L<Mojo::Util> 

L<POSIX> 

L<v5.42> 

L<Mojo::Base> 


=head1 METHODS

=head2 generate_controller($self,

 generate_controller($self,();

=head2 generate_db_model($self,

 generate_db_model($self,();

=head2 generate_db_model_super($self,

 generate_db_model_super($self,();

=head2 generate_helpers($self,

 generate_helpers($self,();

=head2 generate_perl($self)

 generate_perl($self)();

=head2 generate_plugin($self,

 generate_plugin($self,();

=head2 generate_routes($self,

 generate_routes($self,();

=head2 generate_super_controller($self,

 generate_super_controller($self,();


=cut

