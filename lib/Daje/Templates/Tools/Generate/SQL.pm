package Daje::Templates::Tools::Generate::SQL;
use v5.42;


1;

__DATA__

@@ table

CREATE TABLE IF NOT EXISTS [% tablename %]
(
    [% tablename %]_pkey SERIAL NOT NULL,
    editnum bigint NOT NULL DEFAULT 1,
    insby character varying COLLATE pg_catalog."default" NOT NULL DEFAULT 'System'::character varying,
    insdatetime timestamp without time zone NOT NULL DEFAULT now(),
    modby character varying COLLATE pg_catalog."default" NOT NULL DEFAULT 'System'::character varying,
    moddatetime timestamp without time zone NOT NULL DEFAULT now(),
    [% FOREACH team = teams -%]
        [% team.name %] [% team.played -%]
        [% team.won %] [% team.drawn %] [% team.lost %]
    [% END %]
    CONSTRAINT [% tablename %]_pkey PRIMARY KEY ([% tablename %]_pkey)
);

__END__