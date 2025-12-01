package Daje::Database::Tools;
use Mojo::Base  -base;
use v5.42;


1;

__DATA__

@@ tools

-- 1 up
CREATE TABLE IF NOT EXISTS tools_projects
(
    tools_projects_pkey integer NOT NULL DEFAULT nextval('tools_projects_tools_projects_pkey_seq'::regclass),
    editnum bigint NOT NULL DEFAULT 1,
    insby character varying COLLATE pg_catalog."default" NOT NULL DEFAULT 'System'::character varying,
    insdatetime timestamp without time zone NOT NULL DEFAULT now(),
    modby character varying COLLATE pg_catalog."default" NOT NULL DEFAULT 'System'::character varying,
    moddatetime timestamp without time zone NOT NULL DEFAULT now(),
    name character varying COLLATE pg_catalog."default" NOT NULL,
    state character varying COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT tools_projects_pkey PRIMARY KEY (tools_projects_pkey)
);

CREATE TABLE IF NOT EXISTS tools_version
(
    tools_version_pkey integer NOT NULL DEFAULT nextval('tools_version_tools_version_pkey_seq'::regclass),
    editnum bigint NOT NULL DEFAULT 1,
    insby character varying COLLATE pg_catalog."default" NOT NULL DEFAULT 'System'::character varying,
    insdatetime timestamp without time zone NOT NULL DEFAULT now(),
    modby character varying COLLATE pg_catalog."default" NOT NULL DEFAULT 'System'::character varying,
    moddatetime timestamp without time zone NOT NULL DEFAULT now(),
    tools_projects_fkey bigint NOT NULL,
    version bigint NOT NULL DEFAULT 1,
    name character varying COLLATE pg_catalog."default" NOT NULL DEFAULT ''::character varying,
    locked boolean NOT NULL DEFAULT false,
    CONSTRAINT tools_version_pkey PRIMARY KEY (tools_version_pkey),
    CONSTRAINT tools_version_tools_projects_fkey FOREIGN KEY (tools_projects_fkey)
        REFERENCES tools_projects (tools_projects_pkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        DEFERRABLE
);

CREATE UNIQUE INDEX IF NOT EXISTS tools_version_pkey_tools_projects_fkey
    ON tools_version USING btree
    (tools_projects_fkey ASC NULLS LAST, version ASC NULLS LAST)
    WITH (fillfactor=100, deduplicate_items=True);

CREATE TABLE IF NOT EXISTS tools_objects
(
    tools_objects_pkey integer NOT NULL DEFAULT nextval('tools_objects_tools_objects_pkey_seq'::regclass),
    editnum bigint NOT NULL DEFAULT 1,
    insby character varying COLLATE pg_catalog."default" NOT NULL DEFAULT 'System'::character varying,
    insdatetime timestamp without time zone NOT NULL DEFAULT now(),
    modby character varying COLLATE pg_catalog."default" NOT NULL DEFAULT 'System'::character varying,
    moddatetime timestamp without time zone NOT NULL DEFAULT now(),
    tools_version_fkey bigint NOT NULL,
    name character varying COLLATE pg_catalog."default" NOT NULL,
    active boolean NOT NULL DEFAULT true,
    tools_object_types_fkey bigint NOT NULL DEFAULT 0,
    tools_projects_fkey bigint NOT NULL DEFAULT 0,
    CONSTRAINT tools_objects_pkey PRIMARY KEY (tools_objects_pkey),
    CONSTRAINT tools_objects_name_key UNIQUE (name),
    CONSTRAINT tools_objects_tools_object_types_fkey FOREIGN KEY (tools_object_types_fkey)
        REFERENCES tools_object_types (tools_object_types_pkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT tools_objects_tools_projects_fkey FOREIGN KEY (tools_projects_fkey)
        REFERENCES tools_projects (tools_projects_pkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT tools_objects_tools_version_fkey FOREIGN KEY (tools_version_fkey)
        REFERENCES tools_version (tools_version_pkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        DEFERRABLE
);

CREATE TABLE IF NOT EXISTS tools_object_tables
(
    tools_object_tables_pkey integer NOT NULL DEFAULT nextval('tools_object_tables_tools_object_tables_pkey_seq'::regclass),
    editnum bigint NOT NULL DEFAULT 1,
    insby character varying COLLATE pg_catalog."default" NOT NULL DEFAULT 'System'::character varying,
    insdatetime timestamp without time zone NOT NULL DEFAULT now(),
    modby character varying COLLATE pg_catalog."default" NOT NULL DEFAULT 'System'::character varying,
    moddatetime timestamp without time zone NOT NULL DEFAULT now(),
    tools_version_fkey bigint NOT NULL,
    tools_objects_fkey bigint NOT NULL,
    fieldname character varying COLLATE pg_catalog."default" NOT NULL,
    length bigint NOT NULL DEFAULT 0,
    scale bigint NOT NULL DEFAULT 0,
    tools_objects_tables_datatypes_fkey bigint NOT NULL,
    active boolean NOT NULL DEFAULT true,
    visible boolean NOT NULL DEFAULT true,
    "notnull" boolean NOT NULL DEFAULT false,
    "default" character varying COLLATE pg_catalog."default" NOT NULL DEFAULT ''::character varying,
    CONSTRAINT tools_object_tables_pkey PRIMARY KEY (tools_object_tables_pkey),
    CONSTRAINT tools_object_tables_tools_objects_fkey FOREIGN KEY (tools_objects_fkey)
        REFERENCES tools_objects (tools_objects_pkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        DEFERRABLE,
    CONSTRAINT tools_object_tables_tools_objects_tables_datatypes_fkey FOREIGN KEY (tools_objects_tables_datatypes_fkey)
        REFERENCES tools_objects_tables_datatypes (tools_objects_tables_datatypes_pkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT tools_object_tables_tools_version_fkey FOREIGN KEY (tools_version_fkey)
        REFERENCES tools_version (tools_version_pkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        DEFERRABLE
);

CREATE UNIQUE INDEX IF NOT EXISTS tools_object_tables_fieldbname_tools_objects_fkey
    ON tools_object_tables USING btree
    (tools_objects_fkey ASC NULLS LAST, fieldname COLLATE pg_catalog."default" ASC NULLS LAST)
    WITH (fillfactor=100, deduplicate_items=True);


CREATE TABLE IF NOT EXISTS tools_object_types
(
    tools_object_types_pkey integer NOT NULL DEFAULT nextval('tools_object_types_tools_object_types_pkey_seq'::regclass),
    editnum bigint NOT NULL DEFAULT 1,
    insby character varying COLLATE pg_catalog."default" NOT NULL DEFAULT 'System'::character varying,
    insdatetime timestamp without time zone NOT NULL DEFAULT now(),
    modby character varying COLLATE pg_catalog."default" NOT NULL DEFAULT 'System'::character varying,
    moddatetime timestamp without time zone NOT NULL DEFAULT now(),
    type_name character varying COLLATE pg_catalog."default" NOT NULL,
    type bigint NOT NULL DEFAULT 0,
    CONSTRAINT tools_object_types_pkey PRIMARY KEY (tools_object_types_pkey),
    CONSTRAINT tools_object_types_type_name_key UNIQUE (type_name)
);

CREATE TABLE IF NOT EXISTS tools_objects_tables_datatypes
(
    tools_objects_tables_datatypes_pkey integer NOT NULL DEFAULT nextval('tools_objects_tables_datatype_tools_objects_tables_datatype_seq'::regclass),
    editnum bigint NOT NULL DEFAULT 1,
    insby character varying COLLATE pg_catalog."default" NOT NULL DEFAULT 'System'::character varying,
    insdatetime timestamp without time zone NOT NULL DEFAULT now(),
    modby character varying COLLATE pg_catalog."default" NOT NULL DEFAULT 'System'::character varying,
    moddatetime timestamp without time zone NOT NULL DEFAULT now(),
    name character varying COLLATE pg_catalog."default" NOT NULL,
    length bigint NOT NULL DEFAULT 0,
    scale bigint NOT NULL DEFAULT 0,
    CONSTRAINT tools_objects_tables_datatypes_pkey PRIMARY KEY (tools_objects_tables_datatypes_pkey)
);

CREATE TABLE IF NOT EXISTS tools_parameter_groups
(
    tools_parameter_groups_pkey integer NOT NULL DEFAULT nextval('tools_parameter_groups_tools_parameter_groups_pkey_seq'::regclass),
    editnum bigint NOT NULL DEFAULT 1,
    insby character varying COLLATE pg_catalog."default" NOT NULL DEFAULT 'System'::character varying,
    insdatetime timestamp without time zone NOT NULL DEFAULT now(),
    modby character varying COLLATE pg_catalog."default" NOT NULL DEFAULT 'System'::character varying,
    moddatetime timestamp without time zone NOT NULL DEFAULT now(),
    parameter_group character varying COLLATE pg_catalog."default" NOT NULL DEFAULT ''::character varying,
    CONSTRAINT tools_parameter_groups_pkey PRIMARY KEY (tools_parameter_groups_pkey),
    CONSTRAINT tools_parameter_groups_parameter_group_key UNIQUE (parameter_group)
);

CREATE TABLE IF NOT EXISTS tools_parameters
(
    tools_parameters_pkey integer NOT NULL DEFAULT nextval('tools_parameters_tools_parameters_pkey_seq'::regclass),
    editnum bigint NOT NULL DEFAULT 1,
    insby character varying COLLATE pg_catalog."default" NOT NULL DEFAULT 'System'::character varying,
    insdatetime timestamp without time zone NOT NULL DEFAULT now(),
    modby character varying COLLATE pg_catalog."default" NOT NULL DEFAULT 'System'::character varying,
    moddatetime timestamp without time zone NOT NULL DEFAULT now(),
    tools_parameter_groups_fkey bigint NOT NULL,
    parameter character varying COLLATE pg_catalog."default" NOT NULL DEFAULT ''::character varying,
    CONSTRAINT tools_parameters_pkey PRIMARY KEY (tools_parameters_pkey),
    CONSTRAINT tools_parameters_parameter_key UNIQUE (parameter),
    CONSTRAINT tools_parameters_tools_parameter_groups_fkey FOREIGN KEY (tools_parameter_groups_fkey)
        REFERENCES tools_parameter_groups (tools_parameter_groups_pkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        DEFERRABLE
);

CREATE TABLE IF NOT EXISTS tools_parameter_values
(
    tools_parameter_values_pkey integer NOT NULL DEFAULT nextval('tools_parameter_values_tools_parameter_values_pkey_seq'::regclass),
    editnum bigint NOT NULL DEFAULT 1,
    insby character varying COLLATE pg_catalog."default" NOT NULL DEFAULT 'System'::character varying,
    insdatetime timestamp without time zone NOT NULL DEFAULT now(),
    modby character varying COLLATE pg_catalog."default" NOT NULL DEFAULT 'System'::character varying,
    moddatetime timestamp without time zone NOT NULL DEFAULT now(),
    tools_parameters_fkey bigint NOT NULL,
    tools_projects_fkey bigint NOT NULL,
    "value" character varying COLLATE pg_catalog."default" NOT NULL DEFAULT ''::character varying,
    description character varying COLLATE pg_catalog."default" NOT NULL DEFAULT ''::character varying,
    active boolean NOT NULL DEFAULT false,
    CONSTRAINT tools_parameter_values_pkey PRIMARY KEY (tools_parameter_values_pkey),
    CONSTRAINT tools_parameter_values_tools_parameters_fkey FOREIGN KEY (tools_parameters_fkey)
        REFERENCES tools_parameters (tools_parameters_pkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        DEFERRABLE,
    CONSTRAINT tools_parameter_values_tools_projects_fkey FOREIGN KEY (tools_projects_fkey)
        REFERENCES tools_projects (tools_projects_pkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        DEFERRABLE
);


-- 1 down