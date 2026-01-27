package Daje::Workflow::Activities::Tools::Generate::SaveCode;
use Mojo::Base 'Daje::Workflow::Activities::Tools::Generate::Base', -base, -signatures;
use v5.42;

use Crypt::Checksum::CRC32 qw{ crc32_data };
use String::Util 'trim';
use Daje::Database::Model::ToolsCodeChecksum;
use Daje::Database::Model::ToolsCode;

sub save_code($self) {

    $self->model->insert_history(
        "Save generated code in db",
        "Daje::Workflow::Activities::Tools::Generate::SaveCode::save_code",
        1
    );
    my $checksum = Daje::Database::Model::ToolsCodeChecksum->new(db => $self->db);
    my $tools_code = Daje::Database::Model::ToolsCode->new(db => $self->db);
    my @tags = split(',', $self->activity_data->{tags});
    my $length = scalar @tags;
    for (my $i = 0; $i < $length; $i++) {
        my $data = $self->context->{context}->{payload}->{$tags[$i]};
        my $len = scalar @{$data};
        for (my $j = 0; $j < $len; $j++) {
            if (exists @{$data}[$j]->{tools_objects_pkey}) {
                my $code = $tools_code->load_tools_code_fkey(@{$data}[$j]->{tools_objects_pkey});
                my $checksum_raw  = crc32_data(@{$data}[$j]->{document});
                if ($code && exists $code->{tools_code_pkey}) {
                    my $checksum_old = $checksum->load_tools_code_checksum_fkey($code->{tools_code_pkey});

                    if ($checksum_raw ne $checksum_old->{checksum}) {

                    }
                }

            }
        }
    }
}

1;