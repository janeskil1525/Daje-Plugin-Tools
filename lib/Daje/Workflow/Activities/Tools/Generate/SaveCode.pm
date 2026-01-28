package Daje::Workflow::Activities::Tools::Generate::SaveCode;
use Mojo::Base 'Daje::Workflow::Activities::Tools::Generate::Base', -base, -signatures;
use v5.42;

use Crypt::Checksum::CRC32 qw{ crc32_data_hex };
use String::Util 'trim';
use Mojo::File;
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
                my $checksum_old;
                my $tools_code_pkey = 0;
                my $checksum_raw  = crc32_data_hex(@{$data}[$j]->{data});
                my $code = $tools_code->load_tools_code_pkey_from_filename(@{$data}[$j]->{file})->{data};
                $code->{content} = @{$data}[$j]->{data};
                if(!exists $code->{tools_code_pkey}) {
                    $code->{tools_objects_fkey} = @{$data}[$j]->{tools_objects_pkey};
                    $code->{filename} = @{$data}[$j]->{file};
                    $code->{filetype} = Mojo::File->new(@{$data}[$j]->{file})->extname();
                    $tools_code_pkey = $tools_code->insert($code)->{data}->{tools_code_pkey};
                    my $checksum_data->{tools_code_fkey} = $tools_code_pkey;
                    $checksum_data->{checksum} = $checksum_raw;
                    $checksum->insert($checksum_data);
                } else {
                    $checksum_old = $checksum->load_tools_code_checksum_fkey($code->{tools_code_pkey})->{data}[0];
                    if ($checksum_raw ne $checksum_old->{checksum}) {
                        $tools_code->update($code);
                        $checksum_old->{checksum} = $checksum_raw;
                        $checksum->update($checksum_old);
                    }
                    $checksum_old = {};
                }
                $code = {};
            }
        }
    }
}


1;