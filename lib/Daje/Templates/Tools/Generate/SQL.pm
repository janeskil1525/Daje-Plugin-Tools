package Daje::Templates::Tools::Generate::SQL;
use v5.42;


1;

__DATA__

@@ sql


[% FOREACH version IN versions %]
-- up [% version.version %]
    [% FOREACH table IN version.tables %]
CREATE TABLE IF NOT EXISTS [% table.table_name %]
(
    [% table.table_name %]_pkey  SERIAL NOT NULL,
    editnum bigint NOT NULL DEFAULT 1,
    insby character varying COLLATE pg_catalog."default" NOT NULL DEFAULT 'System'::character varying,
    insdatetime timestamp without time zone NOT NULL DEFAULT now(),
    modby character varying COLLATE pg_catalog."default" NOT NULL DEFAULT 'System'::character varying,
    moddatetime timestamp without time zone NOT NULL DEFAULT now(),
    [% FOREACH field IN table.fields %]
    [% field.fieldname %]  [% field.datatype %] [% length_default_calc(field.length, field.scale, field.notnull, field.default) %],
    [% END %]
    CONSTRAINT [% table.table_name %]_pkey PRIMARY KEY ([% table.table_name %]_pkey)
);
    [% END %]

-- down [% version.version %]

[% END %]

