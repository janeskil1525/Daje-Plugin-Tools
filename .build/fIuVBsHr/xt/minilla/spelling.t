use strict;
use Test::More;
use File::Spec;
eval q{ use Test::Spellunker v0.2.2 };
plan skip_all => "Test::Spellunker is not installed." if $@;

plan skip_all => "no ENV[HOME]" unless $ENV{HOME};
my $spelltest_switchfile = ".spellunker.en";
plan skip_all => "no ~/$spelltest_switchfile" unless -e File::Spec->catfile($ENV{HOME}, $spelltest_switchfile);

add_stopwords('Daje-Plugin-Tools');
add_stopwords(@{["janeskil1525","janeskil1525"]});

all_pod_files_spelling_ok('lib');

