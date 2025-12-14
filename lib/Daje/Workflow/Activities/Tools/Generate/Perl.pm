package Daje::Workflow::Activities::Tools::Generate::Perl;
use Mojo::Base 'Daje::Workflow::Activities::Tools::Generate::Base', -base, -signatures;
use v5.42;


sub generate_perl($self) {
    my $output = ('plugin');
    try {
        my $tools_projects_pkey = $self->context->{context}->{payload}->{tools_projects_fkey};
        if ($self->load_generate_data($tools_projects_pkey)) {
            my $source = $self->get_parameter('Perl', 'Template Source', $tools_projects_pkey);
            my $documents = $self->build_documents($tools_projects_pkey, $source,'sql');
            my $length = scalar @{$documents};
            for (my $i = 0; $i < $length; $i++) {
                my $data->{data} = @{$documents}[$i]->{document};
                my $filename = $self->get_parameter('Sql', 'Output file name', $tools_projects_pkey);
                $data->{file} = $self->get_parameter('Sql', 'Output Path', $tools_projects_pkey) . '/' . $filename;
                $data->{path} = 1;
                push(@data, $data);
            }
            $self->context->{context}->{payload}->{perl} = \@data;
        }
    } catch($e) {
        say $e
            $self->error->add_error($e);
    };
}

sub load_generate_data($self, $tools_projects_pkey) {


}
1;