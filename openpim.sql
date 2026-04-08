\set ON_ERROR_STOP 0
--
-- PostgreSQL database cluster dump
--

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE mts;
ALTER ROLE mts WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'md5c4e91fbcb5503e7b6bac2e86d138427c';
CREATE ROLE openpim;
ALTER ROLE openpim WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'md5056f0ead8207a4a31158a92e4bb68e50';
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'postgres';
--
-- User Configurations
--

--
-- User Config "mts"
--

ALTER ROLE mts SET search_path TO 'mts2', 'mts2sig';


--
-- Role memberships
--

GRANT pg_read_all_stats TO openpim GRANTED BY postgres;




--
-- Databases
--

--
-- Database "template1" dump
--

\connect template1

--
-- PostgreSQL database dump
--

-- Dumped from database version 12.16
-- Dumped by pg_dump version 14.7 (Debian 14.7-1.pgdg110+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: timescaledb; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS timescaledb WITH SCHEMA public;


--
-- Name: EXTENSION timescaledb; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION timescaledb IS 'Enables scalable inserts and complex queries for time-series data (Community Edition)';


--
-- Data for Name: cache_inval_bgw_job; Type: TABLE DATA; Schema: _timescaledb_cache; Owner: postgres
--



--
-- Data for Name: cache_inval_extension; Type: TABLE DATA; Schema: _timescaledb_cache; Owner: postgres
--



--
-- Data for Name: cache_inval_hypertable; Type: TABLE DATA; Schema: _timescaledb_cache; Owner: postgres
--



--
-- Data for Name: hypertable; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: chunk; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: dimension; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: dimension_slice; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: chunk_constraint; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: chunk_data_node; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: chunk_index; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: compression_chunk_size; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: continuous_agg; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: continuous_agg_migrate_plan; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: continuous_agg_migrate_plan_step; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: continuous_aggs_bucket_function; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: continuous_aggs_hypertable_invalidation_log; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: continuous_aggs_invalidation_threshold; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: continuous_aggs_materialization_invalidation_log; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: continuous_aggs_watermark; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: dimension_partition; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: hypertable_compression; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: hypertable_data_node; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: metadata; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: remote_txn; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: tablespace; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: bgw_job; Type: TABLE DATA; Schema: _timescaledb_config; Owner: postgres
--



--
-- Data for Name: job_errors; Type: TABLE DATA; Schema: _timescaledb_internal; Owner: postgres
--



--
-- Name: chunk_constraint_name; Type: SEQUENCE SET; Schema: _timescaledb_catalog; Owner: postgres
--

SELECT pg_catalog.setval('_timescaledb_catalog.chunk_constraint_name', 1, false);


--
-- Name: chunk_id_seq; Type: SEQUENCE SET; Schema: _timescaledb_catalog; Owner: postgres
--

SELECT pg_catalog.setval('_timescaledb_catalog.chunk_id_seq', 1, false);


--
-- Name: continuous_agg_migrate_plan_step_step_id_seq; Type: SEQUENCE SET; Schema: _timescaledb_catalog; Owner: postgres
--

DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM pg_class c
        JOIN pg_namespace n ON n.oid = c.relnamespace
        WHERE c.relname = 'continuous_agg_migrate_plan_step_step_id_seq'
        AND n.nspname = '_timescaledb_catalog'
    ) THEN
        PERFORM pg_catalog.setval('_timescaledb_catalog.continuous_agg_migrate_plan_step_step_id_seq', 1, false);
    END IF;
END $$;


--
-- Name: dimension_id_seq; Type: SEQUENCE SET; Schema: _timescaledb_catalog; Owner: postgres
--

SELECT pg_catalog.setval('_timescaledb_catalog.dimension_id_seq', 1, false);


--
-- Name: dimension_slice_id_seq; Type: SEQUENCE SET; Schema: _timescaledb_catalog; Owner: postgres
--

SELECT pg_catalog.setval('_timescaledb_catalog.dimension_slice_id_seq', 1, false);


--
-- Name: hypertable_id_seq; Type: SEQUENCE SET; Schema: _timescaledb_catalog; Owner: postgres
--

SELECT pg_catalog.setval('_timescaledb_catalog.hypertable_id_seq', 1, false);


--
-- Name: bgw_job_id_seq; Type: SEQUENCE SET; Schema: _timescaledb_config; Owner: postgres
--

SELECT pg_catalog.setval('_timescaledb_config.bgw_job_id_seq', 1000, false);


--
-- PostgreSQL database dump complete
--

--
-- Database "mts" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 12.16
-- Dumped by pg_dump version 14.7 (Debian 14.7-1.pgdg110+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: mts; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE mts WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.UTF-8';


ALTER DATABASE mts OWNER TO postgres;

\connect mts

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: timescaledb; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS timescaledb WITH SCHEMA public;


--
-- Name: EXTENSION timescaledb; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION timescaledb IS 'Enables scalable inserts and complex queries for time-series data (Community Edition)';


--
-- Name: mts2; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA mts2;


ALTER SCHEMA mts2 OWNER TO postgres;

--
-- Name: mts2sig; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA mts2sig;


ALTER SCHEMA mts2sig OWNER TO postgres;

--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA public;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track execution statistics of all SQL statements executed';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: _compressed_hypertable_2; Type: TABLE; Schema: _timescaledb_internal; Owner: postgres
--

CREATE TABLE _timescaledb_internal._compressed_hypertable_2 (
    "time" _timescaledb_internal.compressed_data,
    signal_id bigint,
    signal_value _timescaledb_internal.compressed_data,
    _ts_meta_count integer,
    _ts_meta_sequence_num integer,
    _ts_meta_min_1 timestamp with time zone,
    _ts_meta_max_1 timestamp with time zone
)
WITH (toast_tuple_target='128');
ALTER TABLE ONLY _timescaledb_internal._compressed_hypertable_2 ALTER COLUMN "time" SET STATISTICS 0;
ALTER TABLE ONLY _timescaledb_internal._compressed_hypertable_2 ALTER COLUMN signal_id SET STATISTICS 1000;
ALTER TABLE ONLY _timescaledb_internal._compressed_hypertable_2 ALTER COLUMN signal_value SET STATISTICS 0;
ALTER TABLE ONLY _timescaledb_internal._compressed_hypertable_2 ALTER COLUMN _ts_meta_count SET STATISTICS 1000;
ALTER TABLE ONLY _timescaledb_internal._compressed_hypertable_2 ALTER COLUMN _ts_meta_sequence_num SET STATISTICS 1000;
ALTER TABLE ONLY _timescaledb_internal._compressed_hypertable_2 ALTER COLUMN _ts_meta_min_1 SET STATISTICS 1000;
ALTER TABLE ONLY _timescaledb_internal._compressed_hypertable_2 ALTER COLUMN _ts_meta_max_1 SET STATISTICS 1000;


ALTER TABLE _timescaledb_internal._compressed_hypertable_2 OWNER TO postgres;

--
-- Name: passport_id_seq; Type: SEQUENCE; Schema: mts2; Owner: postgres
--

CREATE SEQUENCE mts2.passport_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 4294967295
    CACHE 1;


ALTER TABLE mts2.passport_id_seq OWNER TO postgres;

--
-- Name: passport; Type: TABLE; Schema: mts2; Owner: mts
--

CREATE TABLE mts2.passport (
    id bigint DEFAULT nextval('mts2.passport_id_seq'::regclass) NOT NULL,
    unit_id bigint NOT NULL,
    param_id bigint NOT NULL,
    date_reg timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    value_s text,
    value_n numeric,
    value_d timestamp with time zone,
    value_j jsonb,
    etag bigint DEFAULT (date_part('epoch'::text, CURRENT_TIMESTAMP))::bigint NOT NULL
);


ALTER TABLE mts2.passport OWNER TO mts;

--
-- Name: TABLE passport; Type: COMMENT; Schema: mts2; Owner: mts
--

COMMENT ON TABLE mts2.passport IS 'Паспорт (параметры для сущностей)';


--
-- Name: COLUMN passport.id; Type: COMMENT; Schema: mts2; Owner: mts
--

COMMENT ON COLUMN mts2.passport.id IS 'Идентификатор параметра (первичный ключ)';


--
-- Name: COLUMN passport.unit_id; Type: COMMENT; Schema: mts2; Owner: mts
--

COMMENT ON COLUMN mts2.passport.unit_id IS 'Идентификатор сущности';


--
-- Name: COLUMN passport.param_id; Type: COMMENT; Schema: mts2; Owner: mts
--

COMMENT ON COLUMN mts2.passport.param_id IS 'Идентификатор типа параметра';


--
-- Name: COLUMN passport.date_reg; Type: COMMENT; Schema: mts2; Owner: mts
--

COMMENT ON COLUMN mts2.passport.date_reg IS 'Дата создания параметра';


--
-- Name: COLUMN passport.value_s; Type: COMMENT; Schema: mts2; Owner: mts
--

COMMENT ON COLUMN mts2.passport.value_s IS 'Строковое значение';


--
-- Name: COLUMN passport.value_n; Type: COMMENT; Schema: mts2; Owner: mts
--

COMMENT ON COLUMN mts2.passport.value_n IS 'Числовое значение';


--
-- Name: COLUMN passport.value_d; Type: COMMENT; Schema: mts2; Owner: mts
--

COMMENT ON COLUMN mts2.passport.value_d IS 'Значение в формате даты с часовым поясом';


--
-- Name: COLUMN passport.value_j; Type: COMMENT; Schema: mts2; Owner: mts
--

COMMENT ON COLUMN mts2.passport.value_j IS 'Значение в формате json';


--
-- Name: COLUMN passport.etag; Type: COMMENT; Schema: mts2; Owner: mts
--

COMMENT ON COLUMN mts2.passport.etag IS 'Последнее изменение в unix-time';


--
-- Name: passport_param_id_seq; Type: SEQUENCE; Schema: mts2; Owner: postgres
--

CREATE SEQUENCE mts2.passport_param_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 4294967295
    CACHE 1;


ALTER TABLE mts2.passport_param_id_seq OWNER TO postgres;

--
-- Name: passport_param; Type: TABLE; Schema: mts2; Owner: mts
--

CREATE TABLE mts2.passport_param (
    id bigint DEFAULT nextval('mts2.passport_param_id_seq'::regclass) NOT NULL,
    param_name text NOT NULL,
    unit_type_id bigint NOT NULL,
    metadata jsonb,
    alias text NOT NULL,
    CONSTRAINT passport_param_alias_check CHECK ((alias ~ '^[a-z]{1}[a-zA-Z0-9_-]*$'::text))
);


ALTER TABLE mts2.passport_param OWNER TO mts;

--
-- Name: TABLE passport_param; Type: COMMENT; Schema: mts2; Owner: mts
--

COMMENT ON TABLE mts2.passport_param IS 'Типы параметров';


--
-- Name: COLUMN passport_param.id; Type: COMMENT; Schema: mts2; Owner: mts
--

COMMENT ON COLUMN mts2.passport_param.id IS 'Идентификатор типа параметра (первичный ключ)';


--
-- Name: COLUMN passport_param.param_name; Type: COMMENT; Schema: mts2; Owner: mts
--

COMMENT ON COLUMN mts2.passport_param.param_name IS 'Наименование параметра (уникальное в пределах типа)';


--
-- Name: COLUMN passport_param.unit_type_id; Type: COMMENT; Schema: mts2; Owner: mts
--

COMMENT ON COLUMN mts2.passport_param.unit_type_id IS 'Идентификатор типа сущности';


--
-- Name: COLUMN passport_param.metadata; Type: COMMENT; Schema: mts2; Owner: mts
--

COMMENT ON COLUMN mts2.passport_param.metadata IS 'Метаданные параметра';


--
-- Name: COLUMN passport_param.alias; Type: COMMENT; Schema: mts2; Owner: mts
--

COMMENT ON COLUMN mts2.passport_param.alias IS 'Алиас может содержать латинские буквы, цифры, знаки "-" и "_" и должен начинаться с маленькой буквы.
	    Алиас уникален в пределах типа';


--
-- Name: CONSTRAINT passport_param_alias_check ON passport_param; Type: COMMENT; Schema: mts2; Owner: mts
--

COMMENT ON CONSTRAINT passport_param_alias_check ON mts2.passport_param IS 'Алиас может содержать латинские буквы, цифры, знаки "-" и "_" и должен начинаться с маленькой буквы';


--
-- Name: unit_id_seq; Type: SEQUENCE; Schema: mts2; Owner: postgres
--

CREATE SEQUENCE mts2.unit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 4294967295
    CACHE 1;


ALTER TABLE mts2.unit_id_seq OWNER TO postgres;

--
-- Name: unit; Type: TABLE; Schema: mts2; Owner: mts
--

CREATE TABLE mts2.unit (
    id bigint DEFAULT nextval('mts2.unit_id_seq'::regclass) NOT NULL,
    unit_type_id bigint NOT NULL,
    data jsonb,
    date_reg timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    etag bigint DEFAULT (date_part('epoch'::text, CURRENT_TIMESTAMP))::bigint NOT NULL
);


ALTER TABLE mts2.unit OWNER TO mts;

--
-- Name: TABLE unit; Type: COMMENT; Schema: mts2; Owner: mts
--

COMMENT ON TABLE mts2.unit IS 'Сущность (соответствует определенному типу сущности)';


--
-- Name: COLUMN unit.id; Type: COMMENT; Schema: mts2; Owner: mts
--

COMMENT ON COLUMN mts2.unit.id IS 'Идентификатор сущности (первичный ключ)';


--
-- Name: COLUMN unit.unit_type_id; Type: COMMENT; Schema: mts2; Owner: mts
--

COMMENT ON COLUMN mts2.unit.unit_type_id IS 'Идентификатор типа сущности';


--
-- Name: COLUMN unit.data; Type: COMMENT; Schema: mts2; Owner: mts
--

COMMENT ON COLUMN mts2.unit.data IS 'Поле для возможного хранения дополнительной информации';


--
-- Name: COLUMN unit.date_reg; Type: COMMENT; Schema: mts2; Owner: mts
--

COMMENT ON COLUMN mts2.unit.date_reg IS 'Дата создания сущности';


--
-- Name: COLUMN unit.etag; Type: COMMENT; Schema: mts2; Owner: mts
--

COMMENT ON COLUMN mts2.unit.etag IS 'Последнее изменение в unix-time';


--
-- Name: unit_relation_id_seq; Type: SEQUENCE; Schema: mts2; Owner: postgres
--

CREATE SEQUENCE mts2.unit_relation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 4294967295
    CACHE 1;


ALTER TABLE mts2.unit_relation_id_seq OWNER TO postgres;

--
-- Name: unit_relation; Type: TABLE; Schema: mts2; Owner: mts
--

CREATE TABLE mts2.unit_relation (
    id bigint DEFAULT nextval('mts2.unit_relation_id_seq'::regclass) NOT NULL,
    parent_id bigint NOT NULL,
    child_id bigint NOT NULL,
    tm_beg timestamp(6) with time zone,
    tm_end timestamp(6) with time zone,
    unit_type_relation_id bigint NOT NULL,
    date_reg timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE mts2.unit_relation OWNER TO mts;

--
-- Name: TABLE unit_relation; Type: COMMENT; Schema: mts2; Owner: mts
--

COMMENT ON TABLE mts2.unit_relation IS 'Связи (отношения) между сущностями';


--
-- Name: COLUMN unit_relation.id; Type: COMMENT; Schema: mts2; Owner: mts
--

COMMENT ON COLUMN mts2.unit_relation.id IS 'Идентификатор связи между сущностями (первичный ключ)';


--
-- Name: COLUMN unit_relation.parent_id; Type: COMMENT; Schema: mts2; Owner: mts
--

COMMENT ON COLUMN mts2.unit_relation.parent_id IS 'Идентификатор родительской сущности';


--
-- Name: COLUMN unit_relation.child_id; Type: COMMENT; Schema: mts2; Owner: mts
--

COMMENT ON COLUMN mts2.unit_relation.child_id IS 'Идентификатор дочерней сущности';


--
-- Name: COLUMN unit_relation.tm_beg; Type: COMMENT; Schema: mts2; Owner: mts
--

COMMENT ON COLUMN mts2.unit_relation.tm_beg IS 'Начало связи';


--
-- Name: COLUMN unit_relation.tm_end; Type: COMMENT; Schema: mts2; Owner: mts
--

COMMENT ON COLUMN mts2.unit_relation.tm_end IS 'Окончание связи (не может быть более одной открытой связи (tm_end is null) между сущностями с одним типом отношений';


--
-- Name: COLUMN unit_relation.unit_type_relation_id; Type: COMMENT; Schema: mts2; Owner: mts
--

COMMENT ON COLUMN mts2.unit_relation.unit_type_relation_id IS 'Идентификатор типа отношений';


--
-- Name: COLUMN unit_relation.date_reg; Type: COMMENT; Schema: mts2; Owner: mts
--

COMMENT ON COLUMN mts2.unit_relation.date_reg IS 'Дата создания связи между сущностями';


--
-- Name: unit_type_id_seq; Type: SEQUENCE; Schema: mts2; Owner: postgres
--

CREATE SEQUENCE mts2.unit_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 4294967295
    CACHE 1;


ALTER TABLE mts2.unit_type_id_seq OWNER TO postgres;

--
-- Name: unit_type; Type: TABLE; Schema: mts2; Owner: mts
--

CREATE TABLE mts2.unit_type (
    id bigint DEFAULT nextval('mts2.unit_type_id_seq'::regclass) NOT NULL,
    type_name text NOT NULL,
    alias text NOT NULL,
    metadata jsonb,
    CONSTRAINT unit_type_alias_check CHECK ((alias ~ '^[a-z]{1}[a-zA-Z0-9_-]*$'::text))
);


ALTER TABLE mts2.unit_type OWNER TO mts;

--
-- Name: TABLE unit_type; Type: COMMENT; Schema: mts2; Owner: mts
--

COMMENT ON TABLE mts2.unit_type IS 'Типы сущностей';


--
-- Name: COLUMN unit_type.id; Type: COMMENT; Schema: mts2; Owner: mts
--

COMMENT ON COLUMN mts2.unit_type.id IS 'Идентификатор типа сущности (первичный ключ)';


--
-- Name: COLUMN unit_type.type_name; Type: COMMENT; Schema: mts2; Owner: mts
--

COMMENT ON COLUMN mts2.unit_type.type_name IS 'Наименование типа сущности';


--
-- Name: COLUMN unit_type.alias; Type: COMMENT; Schema: mts2; Owner: mts
--

COMMENT ON COLUMN mts2.unit_type.alias IS 'Алиас может содержать латинские буквы, цифры, знаки "-" и "_" и должен начинаться с маленькой буквы';


--
-- Name: COLUMN unit_type.metadata; Type: COMMENT; Schema: mts2; Owner: mts
--

COMMENT ON COLUMN mts2.unit_type.metadata IS 'Метаданные типа сущности';


--
-- Name: CONSTRAINT unit_type_alias_check ON unit_type; Type: COMMENT; Schema: mts2; Owner: mts
--

COMMENT ON CONSTRAINT unit_type_alias_check ON mts2.unit_type IS 'Алиас может содержать латинские буквы, цифры, знаки "-" и "_" и должен начинаться с маленькой буквы';


--
-- Name: unit_type_relation_id_seq; Type: SEQUENCE; Schema: mts2; Owner: postgres
--

CREATE SEQUENCE mts2.unit_type_relation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 4294967295
    CACHE 1;


ALTER TABLE mts2.unit_type_relation_id_seq OWNER TO postgres;

--
-- Name: unit_type_relation; Type: TABLE; Schema: mts2; Owner: mts
--

CREATE TABLE mts2.unit_type_relation (
    id bigint DEFAULT nextval('mts2.unit_type_relation_id_seq'::regclass) NOT NULL,
    parent_type_id bigint NOT NULL,
    child_type_id bigint NOT NULL,
    comment text,
    active boolean DEFAULT true NOT NULL,
    alias text NOT NULL,
    unit_type_relation_class_id integer NOT NULL,
    CONSTRAINT unit_type_relation_alias_check CHECK ((alias ~ '^[a-z]{1}[a-zA-Z0-9_-]*$'::text))
);


ALTER TABLE mts2.unit_type_relation OWNER TO mts;

--
-- Name: TABLE unit_type_relation; Type: COMMENT; Schema: mts2; Owner: mts
--

COMMENT ON TABLE mts2.unit_type_relation IS 'Типы связей сущностей для класса отношений';


--
-- Name: COLUMN unit_type_relation.id; Type: COMMENT; Schema: mts2; Owner: mts
--

COMMENT ON COLUMN mts2.unit_type_relation.id IS 'Идентификатор типа отношений (первичный ключ)';


--
-- Name: COLUMN unit_type_relation.parent_type_id; Type: COMMENT; Schema: mts2; Owner: mts
--

COMMENT ON COLUMN mts2.unit_type_relation.parent_type_id IS 'Идентификатор родительского типа сущности';


--
-- Name: COLUMN unit_type_relation.child_type_id; Type: COMMENT; Schema: mts2; Owner: mts
--

COMMENT ON COLUMN mts2.unit_type_relation.child_type_id IS 'Идентификатор дочернего типа сущности';


--
-- Name: COLUMN unit_type_relation.comment; Type: COMMENT; Schema: mts2; Owner: mts
--

COMMENT ON COLUMN mts2.unit_type_relation.comment IS 'Описание типа связи';


--
-- Name: COLUMN unit_type_relation.active; Type: COMMENT; Schema: mts2; Owner: mts
--

COMMENT ON COLUMN mts2.unit_type_relation.active IS 'Признак активности связи';


--
-- Name: COLUMN unit_type_relation.alias; Type: COMMENT; Schema: mts2; Owner: mts
--

COMMENT ON COLUMN mts2.unit_type_relation.alias IS 'Алиас может содержать латинские буквы, цифры, знаки "-" и "_" и должен начинаться с маленькой буквы';


--
-- Name: COLUMN unit_type_relation.unit_type_relation_class_id; Type: COMMENT; Schema: mts2; Owner: mts
--

COMMENT ON COLUMN mts2.unit_type_relation.unit_type_relation_class_id IS 'Идентификатор класса отношений';


--
-- Name: CONSTRAINT unit_type_relation_alias_check ON unit_type_relation; Type: COMMENT; Schema: mts2; Owner: mts
--

COMMENT ON CONSTRAINT unit_type_relation_alias_check ON mts2.unit_type_relation IS 'Алиас может содержать латинские буквы, цифры, знаки "-" и "_" и должен начинаться с маленькой буквы';


--
-- Name: unit_type_relation_class_id_seq; Type: SEQUENCE; Schema: mts2; Owner: postgres
--

CREATE SEQUENCE mts2.unit_type_relation_class_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 4294967295
    CACHE 1;


ALTER TABLE mts2.unit_type_relation_class_id_seq OWNER TO postgres;

--
-- Name: unit_type_relation_class; Type: TABLE; Schema: mts2; Owner: mts
--

CREATE TABLE mts2.unit_type_relation_class (
    id bigint DEFAULT nextval('mts2.unit_type_relation_class_id_seq'::regclass) NOT NULL,
    name text,
    alias text NOT NULL,
    CONSTRAINT unit_type_relation_class_alias_check CHECK ((alias ~ '^[a-z]{1}[a-zA-Z0-9_-]*$'::text))
);


ALTER TABLE mts2.unit_type_relation_class OWNER TO mts;

--
-- Name: TABLE unit_type_relation_class; Type: COMMENT; Schema: mts2; Owner: mts
--

COMMENT ON TABLE mts2.unit_type_relation_class IS 'Классы отношений';


--
-- Name: COLUMN unit_type_relation_class.id; Type: COMMENT; Schema: mts2; Owner: mts
--

COMMENT ON COLUMN mts2.unit_type_relation_class.id IS 'Идентификатор класса отношений (первичный ключ)';


--
-- Name: COLUMN unit_type_relation_class.name; Type: COMMENT; Schema: mts2; Owner: mts
--

COMMENT ON COLUMN mts2.unit_type_relation_class.name IS 'Наименование класса отношений';


--
-- Name: COLUMN unit_type_relation_class.alias; Type: COMMENT; Schema: mts2; Owner: mts
--

COMMENT ON COLUMN mts2.unit_type_relation_class.alias IS 'Алиас может содержать латинские буквы, цифры, знаки "-" и "_" и должен начинаться с маленькой буквы';


--
-- Name: CONSTRAINT unit_type_relation_class_alias_check ON unit_type_relation_class; Type: COMMENT; Schema: mts2; Owner: mts
--

COMMENT ON CONSTRAINT unit_type_relation_class_alias_check ON mts2.unit_type_relation_class IS 'Алиас может содержать латинские буквы, цифры, знаки "-" и "_" и должен начинаться с маленькой буквы';


--
-- Name: signal; Type: TABLE; Schema: mts2sig; Owner: postgres
--

CREATE TABLE mts2sig.signal (
    "time" timestamp with time zone NOT NULL,
    signal_id bigint NOT NULL,
    signal_value double precision NOT NULL
);


ALTER TABLE mts2sig.signal OWNER TO postgres;

--
-- Data for Name: cache_inval_bgw_job; Type: TABLE DATA; Schema: _timescaledb_cache; Owner: postgres
--



--
-- Data for Name: cache_inval_extension; Type: TABLE DATA; Schema: _timescaledb_cache; Owner: postgres
--



--
-- Data for Name: cache_inval_hypertable; Type: TABLE DATA; Schema: _timescaledb_cache; Owner: postgres
--



--
-- Data for Name: hypertable; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--

INSERT INTO _timescaledb_catalog.hypertable VALUES (2, '_timescaledb_internal', '_compressed_hypertable_2', '_timescaledb_internal', '_hyper_2', 0, '_timescaledb_internal', 'calculate_chunk_interval', 0, 2, NULL, NULL);
INSERT INTO _timescaledb_catalog.hypertable VALUES (1, 'mts2sig', 'signal', '_timescaledb_internal', '_hyper_1', 1, '_timescaledb_internal', 'calculate_chunk_interval', 0, 1, 2, NULL);


--
-- Data for Name: chunk; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: dimension; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--

INSERT INTO _timescaledb_catalog.dimension VALUES (1, 1, 'time', 'timestamp with time zone', true, NULL, NULL, NULL, 604800000000, NULL, NULL, NULL);


--
-- Data for Name: dimension_slice; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: chunk_constraint; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: chunk_data_node; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: chunk_index; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: compression_chunk_size; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: continuous_agg; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: continuous_agg_migrate_plan; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: continuous_agg_migrate_plan_step; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: continuous_aggs_bucket_function; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: continuous_aggs_hypertable_invalidation_log; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: continuous_aggs_invalidation_threshold; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: continuous_aggs_materialization_invalidation_log; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: continuous_aggs_watermark; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: dimension_partition; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: hypertable_compression; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--

INSERT INTO _timescaledb_catalog.hypertable_compression VALUES (1, 'time', 4, NULL, 1, false, true);
INSERT INTO _timescaledb_catalog.hypertable_compression VALUES (1, 'signal_id', 0, 1, NULL, NULL, NULL);
INSERT INTO _timescaledb_catalog.hypertable_compression VALUES (1, 'signal_value', 3, NULL, NULL, NULL, NULL);


--
-- Data for Name: hypertable_data_node; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: metadata; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--

INSERT INTO _timescaledb_catalog.metadata VALUES ('exported_uuid', '0f07a903-a146-406c-bd59-167c33f11188', true);


--
-- Data for Name: remote_txn; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: tablespace; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: bgw_job; Type: TABLE DATA; Schema: _timescaledb_config; Owner: postgres
--

INSERT INTO _timescaledb_config.bgw_job VALUES (1000, 'Compression Policy [1000]', '3 days 12:00:00', '00:00:00', -1, '01:00:00', '_timescaledb_internal', 'policy_compression', 'postgres', true, false, NULL, 1, '{"hypertable_id": 1, "compress_after": "7 days"}', '_timescaledb_internal', 'policy_compression_check', NULL);


--
-- Data for Name: _compressed_hypertable_2; Type: TABLE DATA; Schema: _timescaledb_internal; Owner: postgres
--



--
-- Data for Name: job_errors; Type: TABLE DATA; Schema: _timescaledb_internal; Owner: postgres
--



--
-- Data for Name: passport; Type: TABLE DATA; Schema: mts2; Owner: mts
--



--
-- Data for Name: passport_param; Type: TABLE DATA; Schema: mts2; Owner: mts
--

INSERT INTO mts2.passport_param VALUES (1, 'IPАдресСервераВизуализацииСлежения', 1, '{"general": {"valueType": "valueS"}, "valueType": "valueS"}', 'ipAddress');
INSERT INTO mts2.passport_param VALUES (2, 'ПортСервераВизуализацииСлежения', 1, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'portServerVisualizationTracking');
INSERT INTO mts2.passport_param VALUES (3, 'ПериодНакопленияДанных', 1, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'dataAccumulationPeriod');
INSERT INTO mts2.passport_param VALUES (4, 'ПериодЗаписиДанных', 1, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'dataRecordingPeriod');
INSERT INTO mts2.passport_param VALUES (5, 'РазмерФайлаБуфера', 1, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'sizeFileBuffer');
INSERT INTO mts2.passport_param VALUES (6, 'Имя', 1, '{"general": {"valueType": "valueS"}, "valueType": "valueS"}', 'nameMts');
INSERT INTO mts2.passport_param VALUES (7, 'Комментарий', 1, '{"general": {"valueType": "valueS"}, "valueType": "valueS"}', 'commentary');
INSERT INTO mts2.passport_param VALUES (8, 'ФайлТеговАрхива', 1, '{"general": {"valueType": "valueS"}, "valueType": "valueS"}', 'fileTagsArchive');
INSERT INTO mts2.passport_param VALUES (9, 'IPАдресСервераАрхивов', 1, '{"general": {"valueType": "valueS"}, "valueType": "valueS"}', 'iPAddressServerArchives');
INSERT INTO mts2.passport_param VALUES (10, 'ПортСервераАрхивов', 1, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'portServerArchives');
INSERT INTO mts2.passport_param VALUES (11, 'МаксимальнаяСкоростьОбъекта', 1, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'maximumSpeedObject');
INSERT INTO mts2.passport_param VALUES (12, 'УскорениеОбъекта', 1, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'accelerateObject');
INSERT INTO mts2.passport_param VALUES (13, 'ОкрестностьЗаКлетью', 1, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'neighborhoodBeyondCage');
INSERT INTO mts2.passport_param VALUES (14, 'ОкрестностьДатчикаГолова', 1, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'neighborhoodSensorHead');
INSERT INTO mts2.passport_param VALUES (15, 'ОкрестностьДатчикаХвост', 1, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'neighborhoodSensorTail');
INSERT INTO mts2.passport_param VALUES (16, 'МаксимальноКоличествоЕдиниц', 1, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'maximumNumberOfUnits');
INSERT INTO mts2.passport_param VALUES (17, 'СуммарноеРазмерФайловБуфера', 1, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'totalFileSizeBuffer');
INSERT INTO mts2.passport_param VALUES (18, 'ПериодСохранения', 1, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'periodSave');
INSERT INTO mts2.passport_param VALUES (19, 'Потоки', 1, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'streams');
INSERT INTO mts2.passport_param VALUES (20, 'Порт', 1, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'port');
INSERT INTO mts2.passport_param VALUES (21, 'Настройки', 1, '{"general": {"valueType": "valueJ"}, "valueType": "valueJ"}', 'settings');
INSERT INTO mts2.passport_param VALUES (22, 'Настройки для фронта', 1, '{"general": {"valueType": "valueJ"}, "valueType": "valueJ"}', 'settingsWeb');
INSERT INTO mts2.passport_param VALUES (23, 'Название конфига', 1, '{"general": {"valueType": "valueS"}, "valueType": "valueS"}', 'name');
INSERT INTO mts2.passport_param VALUES (24, 'СохранятьСостояние', 1, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'saveState');
INSERT INTO mts2.passport_param VALUES (25, 'Настройки для фронта', 2, '{"general": {"valueType": "valueJ"}, "valueType": "valueJ"}', 'settingsWeb');
INSERT INTO mts2.passport_param VALUES (26, 'Настройки для фронта', 3, '{"general": {"valueType": "valueJ"}, "valueType": "valueJ"}', 'settingsWeb');
INSERT INTO mts2.passport_param VALUES (27, 'Идентификатор', 3, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'identifier');
INSERT INTO mts2.passport_param VALUES (28, 'Имя', 3, '{"general": {"valueType": "valueS"}, "valueType": "valueS"}', 'name');
INSERT INTO mts2.passport_param VALUES (29, 'Координата начала', 3, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'beginX');
INSERT INTO mts2.passport_param VALUES (30, 'Координата завершения', 3, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'endX');
INSERT INTO mts2.passport_param VALUES (31, 'Номер нити', 3, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'threadNumber');
INSERT INTO mts2.passport_param VALUES (32, 'Номер нити сопровождения', 3, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'supportThreadNumber');
INSERT INTO mts2.passport_param VALUES (33, 'Адрес сопровождения', 3, '{"general": {"valueType": "valueS"}, "valueType": "valueS"}', 'trackingAddress');
INSERT INTO mts2.passport_param VALUES (34, 'Порт сопровождения', 3, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'supportPort');
INSERT INTO mts2.passport_param VALUES (35, 'Счетчик ошибок', 3, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'errorCounter');
INSERT INTO mts2.passport_param VALUES (36, 'Блокировать клиентов', 3, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'blockCustomers');
INSERT INTO mts2.passport_param VALUES (37, 'Начало блокировки', 3, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'startingBlocking');
INSERT INTO mts2.passport_param VALUES (38, 'Конец блокировки', 3, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'endingBlocking');
INSERT INTO mts2.passport_param VALUES (39, 'Максимальное количество ЕУ', 3, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'maximumNumberEU');
INSERT INTO mts2.passport_param VALUES (40, 'Останавливать на концах нити', 3, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'stopEndsThread');
INSERT INTO mts2.passport_param VALUES (41, 'Настройки для фронта', 4, '{"general": {"valueType": "valueJ"}, "valueType": "valueJ"}', 'settingsWeb');
INSERT INTO mts2.passport_param VALUES (42, 'Идентификатор', 4, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'identifier');
INSERT INTO mts2.passport_param VALUES (43, 'Имя', 4, '{"general": {"valueType": "valueS"}, "valueType": "valueS"}', 'name');
INSERT INTO mts2.passport_param VALUES (44, 'Координата начала', 4, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'beginX');
INSERT INTO mts2.passport_param VALUES (45, 'Координата завершения', 4, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'endX');
INSERT INTO mts2.passport_param VALUES (46, 'Номер нити', 4, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'threadNumber');
INSERT INTO mts2.passport_param VALUES (47, 'Сигнал величины движения', 4, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'idSignalMove');
INSERT INTO mts2.passport_param VALUES (146, 'uAUser', 15, '{"general": {"valueType": "valueS"}, "valueType": "valueS"}', 'uAUser');
INSERT INTO mts2.passport_param VALUES (48, 'Сигнал факта движения', 4, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'idSignalSizeMove');
INSERT INTO mts2.passport_param VALUES (49, 'Выход из границ', 4, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'movingOutBounds');
INSERT INTO mts2.passport_param VALUES (50, 'Сигнал энкодера', 4, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'idSignalEncoder');
INSERT INTO mts2.passport_param VALUES (51, 'Сигнал сброса', 4, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'idSignalReset');
INSERT INTO mts2.passport_param VALUES (52, 'Точка Максимума Энкодера', 4, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'maximumEncoderPoint');
INSERT INTO mts2.passport_param VALUES (53, 'Настройки для фронта', 5, '{"general": {"valueType": "valueJ"}, "valueType": "valueJ"}', 'settingsWeb');
INSERT INTO mts2.passport_param VALUES (54, 'Идентификатор', 5, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'identifier');
INSERT INTO mts2.passport_param VALUES (55, 'Имя', 5, '{"general": {"valueType": "valueS"}, "valueType": "valueS"}', 'name');
INSERT INTO mts2.passport_param VALUES (56, 'Выход из границ', 5, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'movingOutBounds');
INSERT INTO mts2.passport_param VALUES (57, 'Номер нити', 5, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'threadNumber');
INSERT INTO mts2.passport_param VALUES (58, 'Настройки для фронта', 6, '{"general": {"valueType": "valueJ"}, "valueType": "valueJ"}', 'settingsWeb');
INSERT INTO mts2.passport_param VALUES (59, 'Имя накопителя', 6, '{"general": {"valueType": "valueS"}, "valueType": "valueS"}', 'name');
INSERT INTO mts2.passport_param VALUES (60, 'Координата начала', 6, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'beginX');
INSERT INTO mts2.passport_param VALUES (61, 'Координата завершения', 6, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'endX');
INSERT INTO mts2.passport_param VALUES (62, 'Номер нити', 6, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'threadNumber');
INSERT INTO mts2.passport_param VALUES (63, 'Номер накопителя', 6, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'numberAccumulator');
INSERT INTO mts2.passport_param VALUES (64, 'Сигнал факта движения накопителя', 6, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'idSignalMove');
INSERT INTO mts2.passport_param VALUES (65, 'Идентификатор', 6, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'identifier');
INSERT INTO mts2.passport_param VALUES (66, 'Настройки для фронта', 7, '{"general": {"valueType": "valueJ"}, "valueType": "valueJ"}', 'settingsWeb');
INSERT INTO mts2.passport_param VALUES (67, 'Идентификатор', 7, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'identifier');
INSERT INTO mts2.passport_param VALUES (68, 'Имя', 7, '{"general": {"valueType": "valueS"}, "valueType": "valueS"}', 'name');
INSERT INTO mts2.passport_param VALUES (69, 'Номер нити', 7, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'threadNumber');
INSERT INTO mts2.passport_param VALUES (70, 'Идентификатор сигнала с датчика', 7, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'idSignal');
INSERT INTO mts2.passport_param VALUES (71, 'Разрешение', 7, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'resolution');
INSERT INTO mts2.passport_param VALUES (72, 'Окрестность датчика для головы ЕУ', 7, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'sensorVicinityHead');
INSERT INTO mts2.passport_param VALUES (73, 'Окрестность датчика для хвоста ЕУ', 7, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'sensorVicinityTail');
INSERT INTO mts2.passport_param VALUES (74, 'Упор', 7, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'stopper');
INSERT INTO mts2.passport_param VALUES (75, 'Координата', 7, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'x');
INSERT INTO mts2.passport_param VALUES (76, 'Настройки для фронта', 8, '{"general": {"valueType": "valueJ"}, "valueType": "valueJ"}', 'settingsWeb');
INSERT INTO mts2.passport_param VALUES (77, 'Идентификатор', 8, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'identifier');
INSERT INTO mts2.passport_param VALUES (78, 'Имя', 8, '{"general": {"valueType": "valueS"}, "valueType": "valueS"}', 'name');
INSERT INTO mts2.passport_param VALUES (79, 'Координата', 8, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'x');
INSERT INTO mts2.passport_param VALUES (80, 'Номер нити', 8, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'threadNumber');
INSERT INTO mts2.passport_param VALUES (81, 'Приблизительный коэффициент опережения', 8, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'advanceRatio');
INSERT INTO mts2.passport_param VALUES (82, 'Приблизительный коэффициент отставания', 8, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'lagRatio');
INSERT INTO mts2.passport_param VALUES (83, 'Тип клети', 8, '{"general": {"valueType": "valueS"}, "valueType": "valueS"}', 'millType');
INSERT INTO mts2.passport_param VALUES (84, 'Идентификатор сигнала клеть в работе', 8, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'idSignalAction');
INSERT INTO mts2.passport_param VALUES (85, 'Идентификатор сигнала скорость', 8, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'idSignalSpeed');
INSERT INTO mts2.passport_param VALUES (86, 'Окрестность за клетью', 8, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'millVicinity');
INSERT INTO mts2.passport_param VALUES (87, 'Настройки для фронта', 9, '{"general": {"valueType": "valueJ"}, "valueType": "valueJ"}', 'settingsWeb');
INSERT INTO mts2.passport_param VALUES (88, 'Идентификатор', 9, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'identifier');
INSERT INTO mts2.passport_param VALUES (89, 'Имя', 9, '{"general": {"valueType": "valueS"}, "valueType": "valueS"}', 'name');
INSERT INTO mts2.passport_param VALUES (90, 'Координата начала', 9, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'beginX');
INSERT INTO mts2.passport_param VALUES (91, 'Номер нити', 9, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'threadNumber');
INSERT INTO mts2.passport_param VALUES (92, 'Координата завершения', 9, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'endX');
INSERT INTO mts2.passport_param VALUES (93, 'Идентификатор сигнала скорость', 9, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'idSignalSpeed');
INSERT INTO mts2.passport_param VALUES (94, 'Идентификатор сигнала скорость назад', 9, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'idSignalSpeedBack');
INSERT INTO mts2.passport_param VALUES (95, 'Константа скорости', 9, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'constSpeed');
INSERT INTO mts2.passport_param VALUES (96, 'Тип сигнала скорость', 9, '{"general": {"valueType": "valueS"}, "valueType": "valueS"}', 'typeSignalSpeed');
INSERT INTO mts2.passport_param VALUES (97, 'Тип сигнала скорость назад', 9, '{"general": {"valueType": "valueS"}, "valueType": "valueS"}', 'typeSignalSpeedBack');
INSERT INTO mts2.passport_param VALUES (98, 'Настройки для фронта', 10, '{"general": {"valueType": "valueJ"}, "valueType": "valueJ"}', 'settingsWeb');
INSERT INTO mts2.passport_param VALUES (99, 'Идентификатор', 10, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'identifier');
INSERT INTO mts2.passport_param VALUES (100, 'Имя', 10, '{"general": {"valueType": "valueS"}, "valueType": "valueS"}', 'name');
INSERT INTO mts2.passport_param VALUES (101, 'Координата', 10, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'x');
INSERT INTO mts2.passport_param VALUES (102, 'Номер нити', 10, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'threadNumber');
INSERT INTO mts2.passport_param VALUES (103, 'Сигнал включения', 10, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'idSignalOn');
INSERT INTO mts2.passport_param VALUES (104, 'Сигнал произведено', 10, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'idSignalProduced');
INSERT INTO mts2.passport_param VALUES (105, 'Время на холостой ход', 10, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'idleTime');
INSERT INTO mts2.passport_param VALUES (106, 'Время на простой', 10, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'downtime');
INSERT INTO mts2.passport_param VALUES (107, 'Уровень работа ', 10, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'workLevel');
INSERT INTO mts2.passport_param VALUES (108, 'Уровень холостой ход', 10, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'idleStrokeLevel');
INSERT INTO mts2.passport_param VALUES (109, 'Производительность холостого', 10, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'idlePerformance');
INSERT INTO mts2.passport_param VALUES (110, 'Сигнал состояния', 10, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'idSignalState');
INSERT INTO mts2.passport_param VALUES (111, 'Сигнал прошло ЕУ', 10, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'idSignalPassedEU');
INSERT INTO mts2.passport_param VALUES (112, 'Настройки для фронта', 11, '{"general": {"valueType": "valueJ"}, "valueType": "valueJ"}', 'settingsWeb');
INSERT INTO mts2.passport_param VALUES (113, 'Идентификатор', 11, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'identifier');
INSERT INTO mts2.passport_param VALUES (114, 'Имя', 11, '{"general": {"valueType": "valueS"}, "valueType": "valueS"}', 'name');
INSERT INTO mts2.passport_param VALUES (115, 'Координата', 11, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'x');
INSERT INTO mts2.passport_param VALUES (116, 'Номер нити', 11, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'threadNumber');
INSERT INTO mts2.passport_param VALUES (117, 'Сигнал упор установлен', 11, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'idSignalSet');
INSERT INTO mts2.passport_param VALUES (118, 'Сигнал смещения', 11, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'idSignalOffsets');
INSERT INTO mts2.passport_param VALUES (119, 'Настройки для фронта', 12, '{"general": {"valueType": "valueJ"}, "valueType": "valueJ"}', 'settingsWeb');
INSERT INTO mts2.passport_param VALUES (120, 'Идентификатор', 12, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'identifier');
INSERT INTO mts2.passport_param VALUES (121, 'Имя', 12, '{"general": {"valueType": "valueS"}, "valueType": "valueS"}', 'name');
INSERT INTO mts2.passport_param VALUES (122, 'Координата', 12, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'x');
INSERT INTO mts2.passport_param VALUES (123, 'Номер нити', 12, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'threadNumber');
INSERT INTO mts2.passport_param VALUES (124, 'Текст', 12, '{"general": {"valueType": "valueS"}, "valueType": "valueS"}', 'text');
INSERT INTO mts2.passport_param VALUES (125, 'Сигнал значения', 12, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'idSignalValue');
INSERT INTO mts2.passport_param VALUES (126, 'Выравнивание', 12, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'alignment');
INSERT INTO mts2.passport_param VALUES (127, 'Уровень отображения', 12, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'displayLevel');
INSERT INTO mts2.passport_param VALUES (128, 'Настройки для фронта', 13, '{"general": {"valueType": "valueJ"}, "valueType": "valueJ"}', 'settingsWeb');
INSERT INTO mts2.passport_param VALUES (129, 'Идентификатор', 13, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'identifier');
INSERT INTO mts2.passport_param VALUES (130, 'Имя', 13, '{"general": {"valueType": "valueS"}, "valueType": "valueS"}', 'name');
INSERT INTO mts2.passport_param VALUES (131, 'Координата начала', 13, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'beginX');
INSERT INTO mts2.passport_param VALUES (132, 'Номер нити', 13, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'threadNumber');
INSERT INTO mts2.passport_param VALUES (133, 'Координата завершения', 13, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'endX');
INSERT INTO mts2.passport_param VALUES (134, 'Настройки для фронта', 14, '{"general": {"valueType": "valueJ"}, "valueType": "valueJ"}', 'settingsWeb');
INSERT INTO mts2.passport_param VALUES (135, 'Идентификатор', 14, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'identifier');
INSERT INTO mts2.passport_param VALUES (136, 'Имя', 14, '{"general": {"valueType": "valueS"}, "valueType": "valueS"}', 'name');
INSERT INTO mts2.passport_param VALUES (137, 'Координата начала', 14, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'beginX');
INSERT INTO mts2.passport_param VALUES (138, 'Номер нити', 14, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'threadNumber');
INSERT INTO mts2.passport_param VALUES (139, 'Координата завершения', 14, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'endX');
INSERT INTO mts2.passport_param VALUES (140, 'Время удаления', 14, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'deleteTime');
INSERT INTO mts2.passport_param VALUES (141, 'Сигнал счетчик удалений', 14, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'idSignalDeleteCount');
INSERT INTO mts2.passport_param VALUES (142, 'Сигнал было удаление', 14, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'idSignalDeleteFact');
INSERT INTO mts2.passport_param VALUES (143, 'Время учета', 14, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'countingTime');
INSERT INTO mts2.passport_param VALUES (144, 'Сигнал  сброса', 14, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'idSignalReset');
INSERT INTO mts2.passport_param VALUES (145, 'uATag', 15, '{"general": {"valueType": "valueS"}, "valueType": "valueS"}', 'uATag');
INSERT INTO mts2.passport_param VALUES (147, 'uAPassword', 15, '{"general": {"valueType": "valueS"}, "valueType": "valueS"}', 'uAPassword');
INSERT INTO mts2.passport_param VALUES (148, 'Настройки для фронта', 15, '{"general": {"valueType": "valueJ"}, "valueType": "valueJ"}', 'settingsWeb');
INSERT INTO mts2.passport_param VALUES (149, 'Идентификатор', 15, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'identifier');
INSERT INTO mts2.passport_param VALUES (150, 'Имя блока данных', 15, '{"general": {"valueType": "valueS"}, "valueType": "valueS"}', 'name');
INSERT INTO mts2.passport_param VALUES (151, 'Размер блока данных', 15, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'dataBlockSize');
INSERT INTO mts2.passport_param VALUES (152, 'Признак перестановки байт', 15, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'byteTranspositionSign');
INSERT INTO mts2.passport_param VALUES (153, 'Порт', 15, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'port');
INSERT INTO mts2.passport_param VALUES (154, 'Порт отправителя', 15, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'senderPort');
INSERT INTO mts2.passport_param VALUES (155, 'IP адрес отправителя', 15, '{"general": {"valueType": "valueS"}, "valueType": "valueS"}', 'senderIpAddress');
INSERT INTO mts2.passport_param VALUES (156, 'Заголовок', 15, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'title');
INSERT INTO mts2.passport_param VALUES (157, 'Максимальное время ожидания', 15, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'maximumWaitingTime');
INSERT INTO mts2.passport_param VALUES (158, 'Сервер', 15, '{"general": {"valueType": "valueS"}, "valueType": "valueS"}', 'server');
INSERT INTO mts2.passport_param VALUES (159, 'Время обновления', 15, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'timeUpdate');
INSERT INTO mts2.passport_param VALUES (160, 'Тип связи', 15, '{"general": {"valueType": "valueS"}, "valueType": "valueS"}', 'typeCommunication');
INSERT INTO mts2.passport_param VALUES (161, 'НомерНити', 16, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'threadNumber');
INSERT INTO mts2.passport_param VALUES (162, 'ИдентификаторБлокаДанных', 16, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'identifierBlockData');
INSERT INTO mts2.passport_param VALUES (163, 'Тип данных', 16, '{"general": {"valueType": "valueS"}, "valueType": "valueS"}', 'typeData');
INSERT INTO mts2.passport_param VALUES (164, 'Настройки для фронта', 16, '{"general": {"valueType": "valueJ"}, "valueType": "valueJ"}', 'settingsWeb');
INSERT INTO mts2.passport_param VALUES (165, 'Имя', 16, '{"general": {"valueType": "valueS"}, "valueType": "valueS"}', 'name');
INSERT INTO mts2.passport_param VALUES (166, 'РазмерОбластиДвоичныхДанных', 16, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'idDataBlock');
INSERT INTO mts2.passport_param VALUES (167, 'Координата', 16, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'x');
INSERT INTO mts2.passport_param VALUES (168, 'КоординатаНачала', 16, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'beginX');
INSERT INTO mts2.passport_param VALUES (169, 'КоординатаЗавершения', 16, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'endX');
INSERT INTO mts2.passport_param VALUES (170, 'СигналДляПривязки', 16, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'signalBinding');
INSERT INTO mts2.passport_param VALUES (171, 'ЗадержкаПолученияСигналаЛокальнойСистемой', 16, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'delayedSignalReceiptByLocalSystem');
INSERT INTO mts2.passport_param VALUES (172, 'СигналЯвляетсяДатчикомНаличияМеталла', 16, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'signalMetalDetector');
INSERT INTO mts2.passport_param VALUES (173, 'МинимальныйПределСигнала', 16, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'minimumSignalLimit');
INSERT INTO mts2.passport_param VALUES (174, 'МаксимальныйПределСигнала', 16, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'maximumSignalLimit');
INSERT INTO mts2.passport_param VALUES (175, 'МинимальныйУровеньАналоговогоСигнала', 16, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'minimumAnalogueLevel');
INSERT INTO mts2.passport_param VALUES (176, 'МаксимальныйУровеньАналоговогоСигнала', 16, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'maximumAnalogueLevel');
INSERT INTO mts2.passport_param VALUES (177, 'КоэффициентСмещения', 16, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'displacementFactor');
INSERT INTO mts2.passport_param VALUES (178, 'КоэффициентМасштабирования', 16, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'scaleFactor');
INSERT INTO mts2.passport_param VALUES (179, 'КоэффициентСмещенияСигнал', 16, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'coefficientDisplacementSignal');
INSERT INTO mts2.passport_param VALUES (180, 'КоэффициентМасштабированияСигнал', 16, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'coefficientScaleSignal');
INSERT INTO mts2.passport_param VALUES (181, 'ИдетификаторСигналаНаличияМеталлаДляТипаBINARY', 16, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'metalSignalIdentifierForBinary');
INSERT INTO mts2.passport_param VALUES (182, 'ИнверсияСигналаТипаBOOL', 16, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'inversionSignalTypeBool');
INSERT INTO mts2.passport_param VALUES (183, 'ЗначениеФильтрации', 16, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'valueFiltering');
INSERT INTO mts2.passport_param VALUES (184, 'ВремяФильтрации', 16, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'timeFiltering');
INSERT INTO mts2.passport_param VALUES (185, 'ПроцентФильтрации', 16, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'percentFilter');
INSERT INTO mts2.passport_param VALUES (186, 'МаксимальноеВремяФильтрации', 16, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'maximumFilterTime');
INSERT INTO mts2.passport_param VALUES (187, 'МаксимальныйПроцентФильтрации', 16, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'maximumFilterPercentage');
INSERT INTO mts2.passport_param VALUES (188, 'СоставнойСигнал', 16, '{"general": {"valueType": "valueS"}, "valueList": ["SIMPLE_SIGNAL", "VIRTUAL_SIGNAL", "COMPLEX_SIGNAL_SUM", "COMPLEX_SIGNAL_AVERAGE", "COMPLEX_SIGNAL_BOOL_AND", "COMPLEX_SIGNAL_BOOL_OR", "COMPLEX_SIGNAL_POINTER", "COMPLEX_SIGNAL_PPOINTER", "COMPLEX_SIGNAL_SELECT", "COMPLEX_SIGNAL_DELAYOFF", "COMPLEX_SIGNAL_DELAYON"], "valueType": "valueS"}', 'compositeSignal');
INSERT INTO mts2.passport_param VALUES (189, 'СигналВыбора', 16, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'signalSelect');
INSERT INTO mts2.passport_param VALUES (190, 'ИдентификаторПодсигнала1', 16, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'identifierSignal1');
INSERT INTO mts2.passport_param VALUES (191, 'ИдентификаторПодсигнала2', 16, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'identifierSignal2');
INSERT INTO mts2.passport_param VALUES (192, 'ИдентификаторПодсигнала3', 16, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'identifierSignal3');
INSERT INTO mts2.passport_param VALUES (193, 'ИдентификаторПодсигнала4', 16, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'identifierSignal4');
INSERT INTO mts2.passport_param VALUES (194, 'ИдентификаторПодсигнала5', 16, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'identifierSignal5');
INSERT INTO mts2.passport_param VALUES (195, 'ИдентификаторПодсигнала6', 16, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'identifierSignal6');
INSERT INTO mts2.passport_param VALUES (196, 'Идентификатор', 16, '{"mts": {}, "general": {"pk": true, "valueType": "valueN"}, "valueType": "valueN"}', 'identifier');
INSERT INTO mts2.passport_param VALUES (197, 'ТипДляАрхивирования', 16, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'binaryDataAreaSize');
INSERT INTO mts2.passport_param VALUES (198, 'ИдентификаторПодсигнала7', 16, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'identifierSignal7');
INSERT INTO mts2.passport_param VALUES (199, 'ИдентификаторПодсигнала8', 16, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'identifierSignal8');
INSERT INTO mts2.passport_param VALUES (200, 'ЗначениеВиртуальногоСигнала', 16, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'valueVirtualSignal');
INSERT INTO mts2.passport_param VALUES (201, 'ЗаписьКлиентами', 16, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'recordingCustomers');
INSERT INTO mts2.passport_param VALUES (202, 'ЛогированиеЗаписи', 16, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'loggingRecords');
INSERT INTO mts2.passport_param VALUES (203, 'ВремяЗадержки', 16, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'timeDelay');
INSERT INTO mts2.passport_param VALUES (204, 'Тип для архивирования', 16, '{"general": {"valueType": "valueS"}, "valueType": "valueS"}', 'typeArchive');
INSERT INTO mts2.passport_param VALUES (205, 'ИмяСервер', 16, '{"general": {"valueType": "valueS"}, "valueType": "valueS"}', 'nameServer');
INSERT INTO mts2.passport_param VALUES (206, 'Адрес (Байт)', 16, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'byte');
INSERT INTO mts2.passport_param VALUES (207, 'Адрес (Бит)', 16, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'bit');
INSERT INTO mts2.passport_param VALUES (208, 'ФильтрБД', 16, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'filterDb');
INSERT INTO mts2.passport_param VALUES (209, 'GUID', 16, '{"mts": {}, "general": {"pk": true, "valueType": "valueS"}, "valueType": "valueS"}', 'mdm_guid');
INSERT INTO mts2.passport_param VALUES (210, 'Выборка', 17, '{"general": {"valueType": "valueJ"}, "valueType": "valueJ"}', 'data');
INSERT INTO mts2.passport_param VALUES (211, 'Название', 17, '{"general": {"valueType": "valueS"}, "valueType": "valueS"}', 'name');
INSERT INTO mts2.passport_param VALUES (212, 'Номер нити', 18, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'threadNumber');
INSERT INTO mts2.passport_param VALUES (213, 'Координата хвоста', 18, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'tailCoordinate');
INSERT INTO mts2.passport_param VALUES (214, 'Длина заготовки', 18, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'billetLength');
INSERT INTO mts2.passport_param VALUES (215, 'Толщина заготовки', 18, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'billetThickness');
INSERT INTO mts2.passport_param VALUES (216, 'Сигнал для создания ЕУ', 18, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'idSignal');
INSERT INTO mts2.passport_param VALUES (217, 'Тип единицы учета', 18, '{"general": {"valueType": "valueS"}, "valueType": "valueS"}', 'accountingUnitType');
INSERT INTO mts2.passport_param VALUES (218, 'Настройки для фронта', 18, '{"general": {"valueType": "valueJ"}, "valueType": "valueJ"}', 'settingsWeb');
INSERT INTO mts2.passport_param VALUES (219, 'Описание - комментарий', 18, '{"general": {"valueType": "valueS"}, "valueType": "valueS"}', 'commentary');
INSERT INTO mts2.passport_param VALUES (220, 'Идентификатор', 18, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'identifier');
INSERT INTO mts2.passport_param VALUES (221, 'Название', 18, '{"general": {"valueType": "valueS"}, "valueType": "valueS"}', 'name');
INSERT INTO mts2.passport_param VALUES (222, 'Сигнал', 19, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'idSignal');
INSERT INTO mts2.passport_param VALUES (223, 'Размер ', 19, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'size');
INSERT INTO mts2.passport_param VALUES (224, 'Период, мс', 19, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'period');
INSERT INTO mts2.passport_param VALUES (225, 'Настройки для фронта', 19, '{"general": {"valueType": "valueJ"}, "valueType": "valueJ"}', 'settingsWeb');
INSERT INTO mts2.passport_param VALUES (226, 'Описание - комментарий', 19, '{"general": {"valueType": "valueS"}, "valueType": "valueS"}', 'commentary');
INSERT INTO mts2.passport_param VALUES (227, 'Идентификатор', 19, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'identifier');
INSERT INTO mts2.passport_param VALUES (228, 'Название', 19, '{"general": {"valueType": "valueS"}, "valueType": "valueS"}', 'name');
INSERT INTO mts2.passport_param VALUES (229, 'Нить источник', 20, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'threadNumberSource');
INSERT INTO mts2.passport_param VALUES (230, 'Нить назначения', 20, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'threadNumberDestination');
INSERT INTO mts2.passport_param VALUES (231, 'Координата нити источника', 20, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'coordinateSourceThread');
INSERT INTO mts2.passport_param VALUES (232, 'Координата хвоста нити назначения', 20, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'coordinateTailDestinationThread');
INSERT INTO mts2.passport_param VALUES (233, 'Поворот на 90°', 20, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'rotation90');
INSERT INTO mts2.passport_param VALUES (234, 'Настройки для фронта', 20, '{"general": {"valueType": "valueJ"}, "valueType": "valueJ"}', 'settingsWeb');
INSERT INTO mts2.passport_param VALUES (235, 'Описание - комментарий', 20, '{"general": {"valueType": "valueS"}, "valueType": "valueS"}', 'commentary');
INSERT INTO mts2.passport_param VALUES (236, 'Идентификатор', 20, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'identifier');
INSERT INTO mts2.passport_param VALUES (237, 'Название', 20, '{"general": {"valueType": "valueS"}, "valueType": "valueS"}', 'name');
INSERT INTO mts2.passport_param VALUES (238, 'Идентификатор', 21, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'identifier');
INSERT INTO mts2.passport_param VALUES (239, 'Имя', 21, '{"general": {"valueType": "valueS"}, "valueType": "valueS"}', 'name');
INSERT INTO mts2.passport_param VALUES (240, 'Сигнал', 21, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'signal');
INSERT INTO mts2.passport_param VALUES (241, 'Дельта', 21, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'delta');
INSERT INTO mts2.passport_param VALUES (242, 'Время', 21, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'time');
INSERT INTO mts2.passport_param VALUES (243, 'СигналОстановка', 21, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'signalStop');
INSERT INTO mts2.passport_param VALUES (244, 'СигналОстановкаЗначение', 21, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'signalStopValue');
INSERT INTO mts2.passport_param VALUES (245, 'Настройки для фронта', 21, '{"general": {"valueType": "valueJ"}, "valueType": "valueJ"}', 'settingsWeb');
INSERT INTO mts2.passport_param VALUES (246, 'Идентификатор (Название)', 22, '{"mts": {"id": 1000}, "general": {"valueType": "valueS"}, "valueType": "valueS"}', 'identifier');
INSERT INTO mts2.passport_param VALUES (247, 'Ширина тележки (x0-x1)', 22, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'width');
INSERT INTO mts2.passport_param VALUES (248, 'Длина моста (y0-y1) (задаётся длина тележки)', 22, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'length');
INSERT INTO mts2.passport_param VALUES (249, 'Номер сигнала определяющий координату X', 22, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'signalPositionX');
INSERT INTO mts2.passport_param VALUES (250, 'Номер сигнала определяющий координату Y', 22, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'signalPositionY');
INSERT INTO mts2.passport_param VALUES (251, 'Номер сигнала определяющий подъем и опускание лебёдки крюка', 22, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'signalWinchDirection');
INSERT INTO mts2.passport_param VALUES (252, 'Номер нити на которой работает кран', 22, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'threadNumber');
INSERT INTO mts2.passport_param VALUES (253, 'Ограничение по X тележки', 22, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'maxPositionX');
INSERT INTO mts2.passport_param VALUES (254, 'Ограничение по X2  тележки', 22, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'maxPositionX2');
INSERT INTO mts2.passport_param VALUES (255, 'Ограничение по Y  тележки', 22, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'maxPositionY');
INSERT INTO mts2.passport_param VALUES (256, 'Ограничение по Y2  тележки', 22, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'maxPositionY2');
INSERT INTO mts2.passport_param VALUES (257, 'Номер нити заготовок находящихся на кране', 22, '{"general": {"valueType": "valueN"}, "valueType": "valueN"}', 'threadNumberCrane');
INSERT INTO mts2.passport_param VALUES (258, 'Настройки для фронта конфигуратора', 22, '{"general": {"valueType": "valueJ"}, "valueType": "valueJ"}', 'settingsWeb');
INSERT INTO mts2.passport_param VALUES (259, 'Выходной вес', 23, '{"mts": {"id": 1004}, "general": {"valueType": "valueN"}, "valueType": "valueN"}', 'outputWeight');
INSERT INTO mts2.passport_param VALUES (260, 'Входной вес', 23, '{"mts": {"id": 1003}, "general": {"valueType": "valueN"}, "valueType": "valueN"}', 'inputWeight');
INSERT INTO mts2.passport_param VALUES (261, 'Место перелива', 24, '{"mts": {"id": 2008}, "general": {"valueType": "valueS"}}', 'overflowPlace');
INSERT INTO mts2.passport_param VALUES (262, 'Время перелива', 24, '{"mts": {"id": 2009}, "general": {"valueType": "valueS"}}', 'overflowTime');
INSERT INTO mts2.passport_param VALUES (263, 'Последнее местоположение', 24, '{"mts": {"id": 1006}, "general": {"valueType": "valueN"}}', 'lastPlace');
INSERT INTO mts2.passport_param VALUES (264, 'Остаток в ковше', 24, '{"mts": {"id": 2011}, "general": {"valueType": "valueN"}}', 'residueInLadle');
INSERT INTO mts2.passport_param VALUES (265, 'id ковша от ВА', 24, '{"mts": {"id": 2013}, "general": {"valueType": "valueN"}}', 'idLadleByVA');
INSERT INTO mts2.passport_param VALUES (266, 'Номер ковша', 24, '{"mts": {"id": 1000}, "general": {"valueType": "valueN"}}', 'number');
INSERT INTO mts2.passport_param VALUES (267, 'Номер крана взявшего ковш', 24, '{"mts": {"id": 2012}, "general": {"valueType": "valueS"}}', 'craneNumber');
INSERT INTO mts2.passport_param VALUES (268, 'Счетчик ошибок переливов ЧЗК', 24, '{"mts": {"id": 3004}, "general": {"valueType": "valueN"}}', 'errorCounter');
INSERT INTO mts2.passport_param VALUES (269, 'Неразлитые ковши при ошибке перелива', 24, '{"mts": {"id": 3005}, "general": {"valueType": "valueS"}}', 'errorListLadle');
INSERT INTO mts2.passport_param VALUES (270, 'Вес слитый в ЧЗК', 24, '{"mts": {"id": 2010}, "general": {"valueType": "valueN"}}', 'weightDrainedIntoChZK');
INSERT INTO mts2.passport_param VALUES (271, 'Состояние пустой/половина/полный (1/2/3 0 - не определено)', 24, '{"mts": {"id": 2001}, "general": {"valueType": "valueN"}}', 'stateOfFullness');
INSERT INTO mts2.passport_param VALUES (272, 'Состояние Корка есть/нет (1/2)', 24, '{"mts": {"id": 2002}, "general": {"valueType": "valueN"}}', 'stateOfCrust');
INSERT INTO mts2.passport_param VALUES (273, 'Место разлива', 24, '{"mts": {"id": 2006}, "general": {"valueType": "valueN"}}', 'spillPlace');
INSERT INTO mts2.passport_param VALUES (274, 'Тест json', 24, '{"mts": {"id": 2014}, "general": {"valueType": "valueJ"}}', 'testJson');
INSERT INTO mts2.passport_param VALUES (275, 'Тест дата', 24, '{"mts": {"id": 2015}, "general": {"valueType": "valueD"}}', 'testDate');


--
-- Data for Name: unit; Type: TABLE DATA; Schema: mts2; Owner: mts
--



--
-- Data for Name: unit_relation; Type: TABLE DATA; Schema: mts2; Owner: mts
--



--
-- Data for Name: unit_type; Type: TABLE DATA; Schema: mts2; Owner: mts
--

INSERT INTO mts2.unit_type VALUES (1, 'Конфигурация MTS.Конфиг', 'config', NULL);
INSERT INTO mts2.unit_type VALUES (2, 'Конфигурация MTS.Схема', 'schema', NULL);
INSERT INTO mts2.unit_type VALUES (3, 'Конфигурация MTS.Нить', 'thread', NULL);
INSERT INTO mts2.unit_type VALUES (4, 'Конфигурация MTS.Агрегат линейного перемещения', 'lineMover', NULL);
INSERT INTO mts2.unit_type VALUES (5, 'Конфигурация MTS.Агрегат шагового перемещения', 'stepMover', NULL);
INSERT INTO mts2.unit_type VALUES (6, 'Конфигурация MTS.Накопитель', 'accumulator', NULL);
INSERT INTO mts2.unit_type VALUES (7, 'Конфигурация MTS.Датчик', 'sensor', NULL);
INSERT INTO mts2.unit_type VALUES (8, 'Конфигурация MTS.Клеть', 'millStand', NULL);
INSERT INTO mts2.unit_type VALUES (9, 'Конфигурация MTS.Рольганг', 'rollerConveyor', NULL);
INSERT INTO mts2.unit_type VALUES (10, 'Конфигурация MTS.Состояние производства', 'stateProduction', NULL);
INSERT INTO mts2.unit_type VALUES (11, 'Конфигурация MTS.Упор', 'stopper', NULL);
INSERT INTO mts2.unit_type VALUES (12, 'Конфигурация MTS.Метка', 'label', NULL);
INSERT INTO mts2.unit_type VALUES (13, 'Конфигурация MTS.Технологический узел', 'techNode', NULL);
INSERT INTO mts2.unit_type VALUES (14, 'Конфигурация MTS.Удаление застрявших', 'removingStucks', NULL);
INSERT INTO mts2.unit_type VALUES (15, 'Конфигурация MTS.Блок данных', 'dataBlock', NULL);
INSERT INTO mts2.unit_type VALUES (16, 'Конфигурация MTS.Сигнал', 'signal', NULL);
INSERT INTO mts2.unit_type VALUES (17, 'ArchiveViewer сохраненная выборка сигналов', 'archiveViewerSavedSelection', NULL);
INSERT INTO mts2.unit_type VALUES (18, 'Конфигурация МТС. Автомат - создание ЕУ', 'dfaCreator', NULL);
INSERT INTO mts2.unit_type VALUES (19, 'Конфигурация МТС. Автомат - генератор инкрементального сигнала', 'dfaIncrementSignal', NULL);
INSERT INTO mts2.unit_type VALUES (20, 'Конфигурация МТС. Автомат - перенос ЕУ', 'dfaTransfer', NULL);
INSERT INTO mts2.unit_type VALUES (21, 'Конфигурация MTS.Определение остановки', 'definitionStop', NULL);
INSERT INTO mts2.unit_type VALUES (22, 'Кран (сущность управляемая автоматом)', 'dfaCrane', '{"mts": {"id": 5}}');
INSERT INTO mts2.unit_type VALUES (23, 'ТестЕу1', 'test1', '{"mts": {"id": 1}}');
INSERT INTO mts2.unit_type VALUES (24, 'Ковш ЧВК', 'ladleChVK', '{"mts": {"id": 6}}');


--
-- Data for Name: unit_type_relation; Type: TABLE DATA; Schema: mts2; Owner: mts
--

INSERT INTO mts2.unit_type_relation VALUES (1, 1, 2, 'Конфиг родитель для схемы', true, 'config_parent_for_schemas', 1);
INSERT INTO mts2.unit_type_relation VALUES (2, 2, 3, 'Схема родитель для нитей', true, 'schema_parent_for_threads', 1);
INSERT INTO mts2.unit_type_relation VALUES (3, 3, 4, 'Нить родитель для агрегата линейного перемещения', true, 'thread_parent_for_lineMovers', 1);
INSERT INTO mts2.unit_type_relation VALUES (4, 3, 5, 'Нить родитель для агрегат шагового перемещения', true, 'thread_parent_for_stepMovers', 1);
INSERT INTO mts2.unit_type_relation VALUES (5, 5, 6, 'Агрегат шагового перемещения родитель для накопителей', true, 'stepMover_parent_for_accumulators', 1);
INSERT INTO mts2.unit_type_relation VALUES (6, 3, 7, 'Нить родитель для датчика', true, 'thread_parent_for_sensors', 1);
INSERT INTO mts2.unit_type_relation VALUES (7, 3, 8, 'Нить родитель для клети', true, 'thread_parent_for_millStands', 1);
INSERT INTO mts2.unit_type_relation VALUES (8, 3, 9, 'Нить родитель для рольганга', true, 'thread_parent_for_rollerConveyors', 1);
INSERT INTO mts2.unit_type_relation VALUES (9, 3, 10, 'Нить родитель для состояния производства', true, 'thread_parent_for_stateProductions', 1);
INSERT INTO mts2.unit_type_relation VALUES (10, 3, 11, 'Нить родитель для упора', true, 'thread_parent_for_stoppers', 1);
INSERT INTO mts2.unit_type_relation VALUES (11, 3, 12, 'Нить родитель для метки', true, 'thread_parent_for_labels', 1);
INSERT INTO mts2.unit_type_relation VALUES (12, 3, 13, 'Нить родитель для технологического узла', true, 'thread_parent_for_techNodes', 1);
INSERT INTO mts2.unit_type_relation VALUES (13, 3, 14, 'Нить родитель для удаления застрявших', true, 'thread_parent_for_removingStucks', 1);
INSERT INTO mts2.unit_type_relation VALUES (14, 1, 15, 'Конфиг родитель для блоков данных', true, 'config_parent_for_dataBlocks', 1);
INSERT INTO mts2.unit_type_relation VALUES (15, 1, 16, 'Конфиг родитель для виртуальных сигналов', true, 'config_parent_for_signals', 1);
INSERT INTO mts2.unit_type_relation VALUES (16, 15, 16, 'Блоки данных родитель для сигналов', true, 'dataBlock_parent_for_signals', 1);
INSERT INTO mts2.unit_type_relation VALUES (17, 2, 16, 'Схема родитель для сопостовляемых сигналов', true, 'schema_parent_for_signals', 1);
INSERT INTO mts2.unit_type_relation VALUES (18, 2, 18, 'Схема родитель для автомата создания ЕУ', true, 'schema_parent_for_dfaCreators', 1);
INSERT INTO mts2.unit_type_relation VALUES (19, 2, 19, 'Схема родитель для автомата генератор инкрементального сигнала', true, 'schema_parent_for_dfaIncrementSignals', 1);
INSERT INTO mts2.unit_type_relation VALUES (20, 2, 20, 'Схема родитель для автомата переноса ЕУ', true, 'schema_parent_for_dfaTransfers', 1);
INSERT INTO mts2.unit_type_relation VALUES (21, 2, 21, 'Схема родитель для определение остановки', true, 'schema_parent_for_definitionStops', 1);
INSERT INTO mts2.unit_type_relation VALUES (22, 2, 22, 'Схема родитель для кранов', true, 'schema_parent_for_dfaCranes', 1);
INSERT INTO mts2.unit_type_relation VALUES (23, 13, 23, 'Тех узел родитель для ЕУ ДТ тест1', true, 'techNode_parent_for_test1', 2);
INSERT INTO mts2.unit_type_relation VALUES (24, 13, 24, 'ковш чвк в ТУ', true, 'ladleChVK_in_tn', 2);


--
-- Data for Name: unit_type_relation_class; Type: TABLE DATA; Schema: mts2; Owner: mts
--

INSERT INTO mts2.unit_type_relation_class VALUES (1, 'Иерархия конфигурации', 'hierarchy_configuration');
INSERT INTO mts2.unit_type_relation_class VALUES (2, 'Еу дт с тех нодами', 'tracing');


--
-- Data for Name: signal; Type: TABLE DATA; Schema: mts2sig; Owner: postgres
--



--
-- Name: chunk_constraint_name; Type: SEQUENCE SET; Schema: _timescaledb_catalog; Owner: postgres
--

SELECT pg_catalog.setval('_timescaledb_catalog.chunk_constraint_name', 1, false);


--
-- Name: chunk_id_seq; Type: SEQUENCE SET; Schema: _timescaledb_catalog; Owner: postgres
--

SELECT pg_catalog.setval('_timescaledb_catalog.chunk_id_seq', 1, false);


--
-- Name: continuous_agg_migrate_plan_step_step_id_seq; Type: SEQUENCE SET; Schema: _timescaledb_catalog; Owner: postgres
--

DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM pg_class c
        JOIN pg_namespace n ON n.oid = c.relnamespace
        WHERE c.relname = 'continuous_agg_migrate_plan_step_step_id_seq'
        AND n.nspname = '_timescaledb_catalog'
    ) THEN
        PERFORM pg_catalog.setval('_timescaledb_catalog.continuous_agg_migrate_plan_step_step_id_seq', 1, false);
    END IF;
END $$;


--
-- Name: dimension_id_seq; Type: SEQUENCE SET; Schema: _timescaledb_catalog; Owner: postgres
--

SELECT pg_catalog.setval('_timescaledb_catalog.dimension_id_seq', 1, true);


--
-- Name: dimension_slice_id_seq; Type: SEQUENCE SET; Schema: _timescaledb_catalog; Owner: postgres
--

SELECT pg_catalog.setval('_timescaledb_catalog.dimension_slice_id_seq', 1, false);


--
-- Name: hypertable_id_seq; Type: SEQUENCE SET; Schema: _timescaledb_catalog; Owner: postgres
--

SELECT pg_catalog.setval('_timescaledb_catalog.hypertable_id_seq', 2, true);


--
-- Name: bgw_job_id_seq; Type: SEQUENCE SET; Schema: _timescaledb_config; Owner: postgres
--

SELECT pg_catalog.setval('_timescaledb_config.bgw_job_id_seq', 1000, true);


--
-- Name: passport_id_seq; Type: SEQUENCE SET; Schema: mts2; Owner: postgres
--

SELECT pg_catalog.setval('mts2.passport_id_seq', 1, false);


--
-- Name: passport_param_id_seq; Type: SEQUENCE SET; Schema: mts2; Owner: postgres
--

SELECT pg_catalog.setval('mts2.passport_param_id_seq', 275, true);


--
-- Name: unit_id_seq; Type: SEQUENCE SET; Schema: mts2; Owner: postgres
--

SELECT pg_catalog.setval('mts2.unit_id_seq', 1, false);


--
-- Name: unit_relation_id_seq; Type: SEQUENCE SET; Schema: mts2; Owner: postgres
--

SELECT pg_catalog.setval('mts2.unit_relation_id_seq', 1, false);


--
-- Name: unit_type_id_seq; Type: SEQUENCE SET; Schema: mts2; Owner: postgres
--

SELECT pg_catalog.setval('mts2.unit_type_id_seq', 24, true);


--
-- Name: unit_type_relation_class_id_seq; Type: SEQUENCE SET; Schema: mts2; Owner: postgres
--

SELECT pg_catalog.setval('mts2.unit_type_relation_class_id_seq', 2, true);


--
-- Name: unit_type_relation_id_seq; Type: SEQUENCE SET; Schema: mts2; Owner: postgres
--

SELECT pg_catalog.setval('mts2.unit_type_relation_id_seq', 24, true);


--
-- Name: passport_param param_pkey; Type: CONSTRAINT; Schema: mts2; Owner: mts
--

ALTER TABLE ONLY mts2.passport_param
    ADD CONSTRAINT param_pkey PRIMARY KEY (id);


--
-- Name: passport_param passport_param_aliasses_unit_type_id_key; Type: CONSTRAINT; Schema: mts2; Owner: mts
--

ALTER TABLE ONLY mts2.passport_param
    ADD CONSTRAINT passport_param_aliasses_unit_type_id_key UNIQUE (alias, unit_type_id);


--
-- Name: passport_param passport_param_param_name_unit_type_id_key; Type: CONSTRAINT; Schema: mts2; Owner: mts
--

ALTER TABLE ONLY mts2.passport_param
    ADD CONSTRAINT passport_param_param_name_unit_type_id_key UNIQUE (param_name, unit_type_id);


--
-- Name: passport passport_pkey; Type: CONSTRAINT; Schema: mts2; Owner: mts
--

ALTER TABLE ONLY mts2.passport
    ADD CONSTRAINT passport_pkey PRIMARY KEY (id);


--
-- Name: passport passport_unit_id_param_id_pk; Type: CONSTRAINT; Schema: mts2; Owner: mts
--

ALTER TABLE ONLY mts2.passport
    ADD CONSTRAINT passport_unit_id_param_id_pk UNIQUE (unit_id, param_id);


--
-- Name: unit_type_relation_class relation_class_pkey; Type: CONSTRAINT; Schema: mts2; Owner: mts
--

ALTER TABLE ONLY mts2.unit_type_relation_class
    ADD CONSTRAINT relation_class_pkey PRIMARY KEY (id);


--
-- Name: unit_relation relation_pkey; Type: CONSTRAINT; Schema: mts2; Owner: mts
--

ALTER TABLE ONLY mts2.unit_relation
    ADD CONSTRAINT relation_pkey PRIMARY KEY (id);


--
-- Name: unit_type_relation type_relation_alias_key; Type: CONSTRAINT; Schema: mts2; Owner: mts
--

ALTER TABLE ONLY mts2.unit_type_relation
    ADD CONSTRAINT type_relation_alias_key UNIQUE (alias);


--
-- Name: unit_type_relation type_relation_pkey; Type: CONSTRAINT; Schema: mts2; Owner: mts
--

ALTER TABLE ONLY mts2.unit_type_relation
    ADD CONSTRAINT type_relation_pkey PRIMARY KEY (id);


--
-- Name: unit unit_pkey; Type: CONSTRAINT; Schema: mts2; Owner: mts
--

ALTER TABLE ONLY mts2.unit
    ADD CONSTRAINT unit_pkey PRIMARY KEY (id);


--
-- Name: unit_type unit_type_alias_key; Type: CONSTRAINT; Schema: mts2; Owner: mts
--

ALTER TABLE ONLY mts2.unit_type
    ADD CONSTRAINT unit_type_alias_key UNIQUE (alias);


--
-- Name: unit_type unit_type_pkey; Type: CONSTRAINT; Schema: mts2; Owner: mts
--

ALTER TABLE ONLY mts2.unit_type
    ADD CONSTRAINT unit_type_pkey PRIMARY KEY (id);


--
-- Name: unit_type_relation_class unit_type_relation_class_alias_key; Type: CONSTRAINT; Schema: mts2; Owner: mts
--

ALTER TABLE ONLY mts2.unit_type_relation_class
    ADD CONSTRAINT unit_type_relation_class_alias_key UNIQUE (alias);


--
-- Name: _compressed_hypertable_2_signal_id__ts_meta_sequence_num_idx; Type: INDEX; Schema: _timescaledb_internal; Owner: postgres
--

CREATE INDEX _compressed_hypertable_2_signal_id__ts_meta_sequence_num_idx ON _timescaledb_internal._compressed_hypertable_2 USING btree (signal_id, _ts_meta_sequence_num);


--
-- Name: passport_param_id_index; Type: INDEX; Schema: mts2; Owner: mts
--

CREATE INDEX passport_param_id_index ON mts2.passport USING btree (param_id);


--
-- Name: unit_relation_child_id_unit_type_relation_id_index; Type: INDEX; Schema: mts2; Owner: mts
--

CREATE INDEX unit_relation_child_id_unit_type_relation_id_index ON mts2.unit_relation USING btree (child_id, unit_type_relation_id);


--
-- Name: unit_relation_parent_child_relation_end_index; Type: INDEX; Schema: mts2; Owner: mts
--

CREATE UNIQUE INDEX unit_relation_parent_child_relation_end_index ON mts2.unit_relation USING btree (parent_id, child_id, unit_type_relation_id) WHERE (tm_end IS NULL);


--
-- Name: unit_relation_parent_id_unit_type_relation_id_index; Type: INDEX; Schema: mts2; Owner: mts
--

CREATE INDEX unit_relation_parent_id_unit_type_relation_id_index ON mts2.unit_relation USING btree (parent_id, unit_type_relation_id);


--
-- Name: signal_index; Type: INDEX; Schema: mts2sig; Owner: postgres
--

CREATE INDEX signal_index ON mts2sig.signal USING btree ("time", signal_id);


--
-- Name: signal_time_idx; Type: INDEX; Schema: mts2sig; Owner: postgres
--

CREATE INDEX signal_time_idx ON mts2sig.signal USING btree ("time" DESC);


--
-- Name: _compressed_hypertable_2 ts_insert_blocker; Type: TRIGGER; Schema: _timescaledb_internal; Owner: postgres
--

CREATE TRIGGER ts_insert_blocker BEFORE INSERT ON _timescaledb_internal._compressed_hypertable_2 FOR EACH ROW EXECUTE FUNCTION _timescaledb_internal.insert_blocker();


--
-- Name: signal ts_insert_blocker; Type: TRIGGER; Schema: mts2sig; Owner: postgres
--

CREATE TRIGGER ts_insert_blocker BEFORE INSERT ON mts2sig.signal FOR EACH ROW EXECUTE FUNCTION _timescaledb_internal.insert_blocker();


--
-- Name: passport passport_param_id_fkey; Type: FK CONSTRAINT; Schema: mts2; Owner: mts
--

ALTER TABLE ONLY mts2.passport
    ADD CONSTRAINT passport_param_id_fkey FOREIGN KEY (param_id) REFERENCES mts2.passport_param(id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: passport_param passport_param_unit_type_id_fkey; Type: FK CONSTRAINT; Schema: mts2; Owner: mts
--

ALTER TABLE ONLY mts2.passport_param
    ADD CONSTRAINT passport_param_unit_type_id_fkey FOREIGN KEY (unit_type_id) REFERENCES mts2.unit_type(id) ON DELETE CASCADE;


--
-- Name: passport passport_unit_id_fkey; Type: FK CONSTRAINT; Schema: mts2; Owner: mts
--

ALTER TABLE ONLY mts2.passport
    ADD CONSTRAINT passport_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES mts2.unit(id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: unit_type_relation unit_type_relation_child_type_id_fkey; Type: FK CONSTRAINT; Schema: mts2; Owner: mts
--

ALTER TABLE ONLY mts2.unit_type_relation
    ADD CONSTRAINT unit_type_relation_child_type_id_fkey FOREIGN KEY (child_type_id) REFERENCES mts2.unit_type(id) ON DELETE RESTRICT;


--
-- Name: unit_type_relation unit_type_relation_parent_type_id_fkey; Type: FK CONSTRAINT; Schema: mts2; Owner: mts
--

ALTER TABLE ONLY mts2.unit_type_relation
    ADD CONSTRAINT unit_type_relation_parent_type_id_fkey FOREIGN KEY (parent_type_id) REFERENCES mts2.unit_type(id) ON DELETE RESTRICT;


--
-- Name: unit_type_relation unit_type_relation_unit_type_relation_class_null_fk; Type: FK CONSTRAINT; Schema: mts2; Owner: mts
--

ALTER TABLE ONLY mts2.unit_type_relation
    ADD CONSTRAINT unit_type_relation_unit_type_relation_class_null_fk FOREIGN KEY (unit_type_relation_class_id) REFERENCES mts2.unit_type_relation_class(id);


--
-- Name: unit unit_unit_type_id_fkey; Type: FK CONSTRAINT; Schema: mts2; Owner: mts
--

ALTER TABLE ONLY mts2.unit
    ADD CONSTRAINT unit_unit_type_id_fkey FOREIGN KEY (unit_type_id) REFERENCES mts2.unit_type(id);


--
-- Name: unit_relation ur_child_id_u_id_fk; Type: FK CONSTRAINT; Schema: mts2; Owner: mts
--

ALTER TABLE ONLY mts2.unit_relation
    ADD CONSTRAINT ur_child_id_u_id_fk FOREIGN KEY (child_id) REFERENCES mts2.unit(id) ON DELETE CASCADE;


--
-- Name: unit_relation ur_parent_id_u_id_fk; Type: FK CONSTRAINT; Schema: mts2; Owner: mts
--

ALTER TABLE ONLY mts2.unit_relation
    ADD CONSTRAINT ur_parent_id_u_id_fk FOREIGN KEY (parent_id) REFERENCES mts2.unit(id) ON DELETE CASCADE;


--
-- Name: unit_relation ur_unit_type_relation_id_ut_id_fk; Type: FK CONSTRAINT; Schema: mts2; Owner: mts
--

ALTER TABLE ONLY mts2.unit_relation
    ADD CONSTRAINT ur_unit_type_relation_id_ut_id_fk FOREIGN KEY (unit_type_relation_id) REFERENCES mts2.unit_type_relation(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: DATABASE mts; Type: ACL; Schema: -; Owner: postgres
--

GRANT CONNECT ON DATABASE mts TO openpim;
GRANT CONNECT ON DATABASE mts TO mts;


--
-- Name: SCHEMA mts2; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA mts2 TO mts;


--
-- Name: SCHEMA mts2sig; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA mts2sig TO mts;


--
-- Name: TABLE _compressed_hypertable_2; Type: ACL; Schema: _timescaledb_internal; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE _timescaledb_internal._compressed_hypertable_2 TO mts;


--
-- Name: SEQUENCE passport_id_seq; Type: ACL; Schema: mts2; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE mts2.passport_id_seq TO mts;


--
-- Name: SEQUENCE passport_param_id_seq; Type: ACL; Schema: mts2; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE mts2.passport_param_id_seq TO mts;


--
-- Name: SEQUENCE unit_id_seq; Type: ACL; Schema: mts2; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE mts2.unit_id_seq TO mts;


--
-- Name: SEQUENCE unit_relation_id_seq; Type: ACL; Schema: mts2; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE mts2.unit_relation_id_seq TO mts;


--
-- Name: SEQUENCE unit_type_id_seq; Type: ACL; Schema: mts2; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE mts2.unit_type_id_seq TO mts;


--
-- Name: SEQUENCE unit_type_relation_id_seq; Type: ACL; Schema: mts2; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE mts2.unit_type_relation_id_seq TO mts;


--
-- Name: SEQUENCE unit_type_relation_class_id_seq; Type: ACL; Schema: mts2; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE mts2.unit_type_relation_class_id_seq TO mts;


--
-- Name: TABLE signal; Type: ACL; Schema: mts2sig; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mts2sig.signal TO mts;


--
-- PostgreSQL database dump complete
--

--
-- Database "openpim" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 12.16
-- Dumped by pg_dump version 14.7 (Debian 14.7-1.pgdg110+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: openpim; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE openpim WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.UTF-8';


ALTER DATABASE openpim OWNER TO postgres;

\connect openpim

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: timescaledb; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS timescaledb WITH SCHEMA public;


--
-- Name: EXTENSION timescaledb; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION timescaledb IS 'Enables scalable inserts and complex queries for time-series data (Community Edition)';


--
-- Name: ltree; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS ltree WITH SCHEMA public;


--
-- Name: EXTENSION ltree; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION ltree IS 'data type for hierarchical tree-like structures';


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA public;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track execution statistics of all SQL statements executed';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: actions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.actions (
    identifier character varying(250) NOT NULL,
    name jsonb NOT NULL,
    code character varying(65535) NOT NULL,
    triggers jsonb NOT NULL,
    id integer NOT NULL,
    "tenantId" character varying(50) NOT NULL,
    "createdBy" character varying(250) NOT NULL,
    "updatedBy" character varying(250) NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone,
    "order" integer DEFAULT 0
);


ALTER TABLE public.actions OWNER TO postgres;

--
-- Name: actions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.actions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.actions_id_seq OWNER TO postgres;

--
-- Name: actions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.actions_id_seq OWNED BY public.actions.id;


--
-- Name: attrGroups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."attrGroups" (
    identifier character varying(250) NOT NULL,
    name jsonb NOT NULL,
    "order" integer NOT NULL,
    visible boolean NOT NULL,
    id integer NOT NULL,
    "tenantId" character varying(50) NOT NULL,
    "createdBy" character varying(250) NOT NULL,
    "updatedBy" character varying(250) NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone,
    options jsonb DEFAULT '[]'::jsonb
);


ALTER TABLE public."attrGroups" OWNER TO postgres;

--
-- Name: attrGroups_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."attrGroups_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."attrGroups_id_seq" OWNER TO postgres;

--
-- Name: attrGroups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."attrGroups_id_seq" OWNED BY public."attrGroups".id;


--
-- Name: attributes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.attributes (
    identifier character varying(250) NOT NULL,
    name jsonb NOT NULL,
    "order" integer NOT NULL,
    valid jsonb,
    visible jsonb,
    relations jsonb,
    "languageDependent" boolean NOT NULL,
    type integer NOT NULL,
    pattern character varying(250),
    "errorMessage" jsonb,
    lov integer,
    "richText" boolean NOT NULL,
    "multiLine" boolean NOT NULL,
    id integer NOT NULL,
    "tenantId" character varying(50) NOT NULL,
    "createdBy" character varying(250) NOT NULL,
    "updatedBy" character varying(250) NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone,
    options jsonb DEFAULT '[]'::jsonb
);


ALTER TABLE public.attributes OWNER TO postgres;

--
-- Name: attributes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.attributes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.attributes_id_seq OWNER TO postgres;

--
-- Name: attributes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.attributes_id_seq OWNED BY public.attributes.id;


--
-- Name: channels_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.channels_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.channels_id_seq OWNER TO postgres;

--
-- Name: channels; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.channels (
    identifier character varying(250) NOT NULL,
    name jsonb NOT NULL,
    active boolean NOT NULL,
    type integer NOT NULL,
    valid jsonb,
    visible jsonb,
    config jsonb NOT NULL,
    mappings jsonb NOT NULL,
    runtime jsonb NOT NULL,
    id integer DEFAULT nextval('public.channels_id_seq'::regclass) NOT NULL,
    "tenantId" character varying(50) NOT NULL,
    "createdBy" character varying(250) NOT NULL,
    "updatedBy" character varying(250) NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone,
    "order" integer DEFAULT 0,
    "parentId" integer DEFAULT 0,
    "group" boolean DEFAULT false
);


ALTER TABLE public.channels OWNER TO postgres;

--
-- Name: channels_exec_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.channels_exec_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.channels_exec_id_seq OWNER TO postgres;

--
-- Name: channels_exec; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.channels_exec (
    "channelId" integer NOT NULL,
    status integer NOT NULL,
    "startTime" timestamp with time zone NOT NULL,
    "finishTime" timestamp with time zone,
    "storagePath" character varying(255),
    log jsonb,
    id integer DEFAULT nextval('public.channels_exec_id_seq'::regclass) NOT NULL,
    "tenantId" character varying(50) NOT NULL,
    "createdBy" character varying(250) NOT NULL,
    "updatedBy" character varying(250) NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone
);


ALTER TABLE public.channels_exec OWNER TO postgres;

--
-- Name: collectionItems_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."collectionItems_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


ALTER TABLE public."collectionItems_id_seq" OWNER TO postgres;

--
-- Name: collectionItems; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."collectionItems" (
    id integer DEFAULT nextval('public."collectionItems_id_seq"'::regclass) NOT NULL,
    "itemId" integer NOT NULL,
    "collectionId" integer NOT NULL,
    "tenantId" character varying(50) NOT NULL,
    "createdBy" character varying(250) NOT NULL,
    "updatedBy" character varying(250) NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."collectionItems" OWNER TO postgres;

--
-- Name: collections_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.collections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


ALTER TABLE public.collections_id_seq OWNER TO postgres;

--
-- Name: collections; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.collections (
    id integer DEFAULT nextval('public.collections_id_seq'::regclass) NOT NULL,
    identifier character varying(250) NOT NULL,
    name jsonb NOT NULL,
    public boolean NOT NULL,
    "user" character varying(250) NOT NULL,
    "tenantId" character varying(50) NOT NULL,
    "createdBy" character varying(250) NOT NULL,
    "updatedBy" character varying(250) NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone
);


ALTER TABLE public.collections OWNER TO postgres;

--
-- Name: dashboards; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dashboards (
    identifier character varying(250) NOT NULL,
    name jsonb NOT NULL,
    users jsonb NOT NULL,
    components jsonb NOT NULL,
    id integer NOT NULL,
    "tenantId" character varying(50) NOT NULL,
    "createdBy" character varying(250) NOT NULL,
    "updatedBy" character varying(250) NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone
);


ALTER TABLE public.dashboards OWNER TO postgres;

--
-- Name: dashboards_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.dashboards_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dashboards_id_seq OWNER TO postgres;

--
-- Name: dashboards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.dashboards_id_seq OWNED BY public.dashboards.id;


--
-- Name: group_attribute; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.group_attribute (
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "AttrGroupId" integer NOT NULL,
    "AttributeId" integer NOT NULL
);


ALTER TABLE public.group_attribute OWNER TO postgres;

--
-- Name: identifier_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.identifier_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.identifier_seq OWNER TO postgres;

--
-- Name: importConfigs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."importConfigs_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


ALTER TABLE public."importConfigs_id_seq" OWNER TO postgres;

--
-- Name: importConfigs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."importConfigs" (
    id integer DEFAULT nextval('public."importConfigs_id_seq"'::regclass) NOT NULL,
    identifier character varying(250) NOT NULL,
    name jsonb NOT NULL,
    type integer NOT NULL,
    mappings jsonb NOT NULL,
    filedata jsonb NOT NULL,
    config jsonb NOT NULL,
    "tenantId" character varying(50) NOT NULL,
    "createdBy" character varying(250) NOT NULL,
    "updatedBy" character varying(250) NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone
);


ALTER TABLE public."importConfigs" OWNER TO postgres;

--
-- Name: itemRelations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."itemRelations" (
    identifier character varying(250) NOT NULL,
    "itemId" integer NOT NULL,
    "itemIdentifier" character varying(250) NOT NULL,
    "relationId" integer NOT NULL,
    "relationIdentifier" character varying(250) NOT NULL,
    "targetId" integer NOT NULL,
    "targetIdentifier" character varying(250) NOT NULL,
    "values" jsonb,
    id integer NOT NULL,
    "tenantId" character varying(50) NOT NULL,
    "createdBy" character varying(250) NOT NULL,
    "updatedBy" character varying(250) NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone
);


ALTER TABLE public."itemRelations" OWNER TO postgres;

--
-- Name: itemRelations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."itemRelations_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."itemRelations_id_seq" OWNER TO postgres;

--
-- Name: itemRelations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."itemRelations_id_seq" OWNED BY public."itemRelations".id;


--
-- Name: items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.items (
    identifier character varying(250) NOT NULL,
    path public.ltree NOT NULL,
    name jsonb NOT NULL,
    "typeId" integer NOT NULL,
    "typeIdentifier" character varying(250) NOT NULL,
    "parentIdentifier" character varying(250) NOT NULL,
    "values" jsonb,
    "fileOrigName" character varying(250) NOT NULL,
    "storagePath" character varying(500) NOT NULL,
    "mimeType" character varying(250) NOT NULL,
    id integer NOT NULL,
    "tenantId" character varying(50) NOT NULL,
    "createdBy" character varying(250) NOT NULL,
    "updatedBy" character varying(250) NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone,
    channels jsonb DEFAULT '{}'::jsonb
);


ALTER TABLE public.items OWNER TO postgres;

--
-- Name: items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.items_id_seq OWNER TO postgres;

--
-- Name: items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.items_id_seq OWNED BY public.items.id;


--
-- Name: languages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.languages (
    identifier character varying(250) NOT NULL,
    name jsonb NOT NULL,
    id integer NOT NULL,
    "tenantId" character varying(50) NOT NULL,
    "createdBy" character varying(250) NOT NULL,
    "updatedBy" character varying(250) NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone
);


ALTER TABLE public.languages OWNER TO postgres;

--
-- Name: languages_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.languages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.languages_id_seq OWNER TO postgres;

--
-- Name: languages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.languages_id_seq OWNED BY public.languages.id;


--
-- Name: lovs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lovs (
    identifier character varying(250) NOT NULL,
    name jsonb NOT NULL,
    "values" jsonb NOT NULL,
    id integer NOT NULL,
    "tenantId" character varying(50) NOT NULL,
    "createdBy" character varying(250) NOT NULL,
    "updatedBy" character varying(250) NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone
);


ALTER TABLE public.lovs OWNER TO postgres;

--
-- Name: lovs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lovs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lovs_id_seq OWNER TO postgres;

--
-- Name: lovs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lovs_id_seq OWNED BY public.lovs.id;


--
-- Name: processes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.processes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


ALTER TABLE public.processes_id_seq OWNER TO postgres;

--
-- Name: processes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.processes (
    id integer DEFAULT nextval('public.processes_id_seq'::regclass) NOT NULL,
    identifier character varying(250) NOT NULL,
    title character varying(2500) NOT NULL,
    active boolean NOT NULL,
    status character varying(250) NOT NULL,
    "finishTime" timestamp with time zone,
    "storagePath" character varying(255),
    "mimeType" character varying(255),
    "fileName" character varying(255),
    log text,
    runtime jsonb NOT NULL,
    "tenantId" character varying(50) NOT NULL,
    "createdBy" character varying(250) NOT NULL,
    "updatedBy" character varying(250) NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone
);


ALTER TABLE public.processes OWNER TO postgres;

--
-- Name: relations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.relations (
    identifier character varying(250) NOT NULL,
    name jsonb NOT NULL,
    sources jsonb,
    targets jsonb,
    child boolean NOT NULL,
    multi boolean NOT NULL,
    id integer NOT NULL,
    "tenantId" character varying(50) NOT NULL,
    "createdBy" character varying(250) NOT NULL,
    "updatedBy" character varying(250) NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone,
    "order" integer DEFAULT 0,
    options jsonb DEFAULT '[]'::jsonb
);


ALTER TABLE public.relations OWNER TO postgres;

--
-- Name: relations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.relations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.relations_id_seq OWNER TO postgres;

--
-- Name: relations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.relations_id_seq OWNED BY public.relations.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    identifier character varying(250) NOT NULL,
    name character varying(250) NOT NULL,
    "configAccess" jsonb NOT NULL,
    "relAccess" jsonb NOT NULL,
    "itemAccess" jsonb NOT NULL,
    "otherAccess" jsonb NOT NULL,
    id integer NOT NULL,
    "tenantId" character varying(50) NOT NULL,
    "createdBy" character varying(250) NOT NULL,
    "updatedBy" character varying(250) NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone,
    "channelAccess" jsonb DEFAULT '[]'::jsonb,
    options jsonb DEFAULT '[]'::jsonb
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.roles_id_seq OWNER TO postgres;

--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- Name: savedColumns; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."savedColumns" (
    identifier character varying(250) NOT NULL,
    name jsonb NOT NULL,
    public boolean NOT NULL,
    columns jsonb NOT NULL,
    "user" character varying(250) NOT NULL,
    id integer NOT NULL,
    "tenantId" character varying(50) NOT NULL,
    "createdBy" character varying(250) NOT NULL,
    "updatedBy" character varying(250) NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone
);


ALTER TABLE public."savedColumns" OWNER TO postgres;

--
-- Name: savedColumns_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."savedColumns_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."savedColumns_id_seq" OWNER TO postgres;

--
-- Name: savedColumns_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."savedColumns_id_seq" OWNED BY public."savedColumns".id;


--
-- Name: savedSearch; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."savedSearch" (
    identifier character varying(250) NOT NULL,
    name jsonb NOT NULL,
    public boolean NOT NULL,
    extended boolean NOT NULL,
    filters jsonb NOT NULL,
    "whereClause" jsonb NOT NULL,
    "user" character varying(250) NOT NULL,
    id integer NOT NULL,
    "tenantId" character varying(50) NOT NULL,
    "createdBy" character varying(250) NOT NULL,
    "updatedBy" character varying(250) NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone,
    entity character varying(100) DEFAULT 'ITEM'::character varying
);


ALTER TABLE public."savedSearch" OWNER TO postgres;

--
-- Name: savedSearch_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."savedSearch_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."savedSearch_id_seq" OWNER TO postgres;

--
-- Name: savedSearch_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."savedSearch_id_seq" OWNED BY public."savedSearch".id;


--
-- Name: types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.types (
    path public.ltree NOT NULL,
    identifier character varying(250) NOT NULL,
    link integer NOT NULL,
    name jsonb NOT NULL,
    icon character varying(50),
    "iconColor" character varying(50),
    file boolean NOT NULL,
    "mainImage" integer NOT NULL,
    images jsonb NOT NULL,
    id integer NOT NULL,
    "tenantId" character varying(50) NOT NULL,
    "createdBy" character varying(250) NOT NULL,
    "updatedBy" character varying(250) NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone,
    options jsonb DEFAULT '[]'::jsonb
);


ALTER TABLE public.types OWNER TO postgres;

--
-- Name: types_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.types_id_seq OWNER TO postgres;

--
-- Name: types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.types_id_seq OWNED BY public.types.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    login character varying(250) NOT NULL,
    name character varying(250) NOT NULL,
    password character varying(250) NOT NULL,
    email character varying(250),
    props jsonb,
    roles jsonb NOT NULL,
    id integer NOT NULL,
    "tenantId" character varying(50) NOT NULL,
    "createdBy" character varying(250) NOT NULL,
    "updatedBy" character varying(250) NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "deletedAt" timestamp with time zone,
    options jsonb DEFAULT '[]'::jsonb
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: actions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actions ALTER COLUMN id SET DEFAULT nextval('public.actions_id_seq'::regclass);


--
-- Name: attrGroups id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."attrGroups" ALTER COLUMN id SET DEFAULT nextval('public."attrGroups_id_seq"'::regclass);


--
-- Name: attributes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attributes ALTER COLUMN id SET DEFAULT nextval('public.attributes_id_seq'::regclass);


--
-- Name: dashboards id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dashboards ALTER COLUMN id SET DEFAULT nextval('public.dashboards_id_seq'::regclass);


--
-- Name: itemRelations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."itemRelations" ALTER COLUMN id SET DEFAULT nextval('public."itemRelations_id_seq"'::regclass);


--
-- Name: items id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items ALTER COLUMN id SET DEFAULT nextval('public.items_id_seq'::regclass);


--
-- Name: languages id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.languages ALTER COLUMN id SET DEFAULT nextval('public.languages_id_seq'::regclass);


--
-- Name: lovs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lovs ALTER COLUMN id SET DEFAULT nextval('public.lovs_id_seq'::regclass);


--
-- Name: relations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.relations ALTER COLUMN id SET DEFAULT nextval('public.relations_id_seq'::regclass);


--
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- Name: savedColumns id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."savedColumns" ALTER COLUMN id SET DEFAULT nextval('public."savedColumns_id_seq"'::regclass);


--
-- Name: savedSearch id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."savedSearch" ALTER COLUMN id SET DEFAULT nextval('public."savedSearch_id_seq"'::regclass);


--
-- Name: types id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.types ALTER COLUMN id SET DEFAULT nextval('public.types_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: cache_inval_bgw_job; Type: TABLE DATA; Schema: _timescaledb_cache; Owner: postgres
--



--
-- Data for Name: cache_inval_extension; Type: TABLE DATA; Schema: _timescaledb_cache; Owner: postgres
--



--
-- Data for Name: cache_inval_hypertable; Type: TABLE DATA; Schema: _timescaledb_cache; Owner: postgres
--



--
-- Data for Name: hypertable; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: chunk; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: dimension; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: dimension_slice; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: chunk_constraint; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: chunk_data_node; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: chunk_index; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: compression_chunk_size; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: continuous_agg; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: continuous_agg_migrate_plan; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: continuous_agg_migrate_plan_step; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: continuous_aggs_bucket_function; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: continuous_aggs_hypertable_invalidation_log; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: continuous_aggs_invalidation_threshold; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: continuous_aggs_materialization_invalidation_log; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: continuous_aggs_watermark; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: dimension_partition; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: hypertable_compression; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: hypertable_data_node; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: metadata; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--

INSERT INTO _timescaledb_catalog.metadata VALUES ('exported_uuid', '9be9558f-0621-4843-abad-3a37c2dd81f6', true);


--
-- Data for Name: remote_txn; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: tablespace; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: bgw_job; Type: TABLE DATA; Schema: _timescaledb_config; Owner: postgres
--



--
-- Data for Name: job_errors; Type: TABLE DATA; Schema: _timescaledb_internal; Owner: postgres
--



--
-- Data for Name: actions; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: attrGroups; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."attrGroups" VALUES ('exampleGroup', '{"ru": "Данные"}', 0, true, 1, 'default', 'admin', 'admin', '2024-10-22 11:52:49.386+00', '2024-10-29 10:05:59.485+00', NULL, '[]');
INSERT INTO public."attrGroups" VALUES ('PieAtt', '{"ru": "Атрибуты труб"}', 0, true, 2, 'default', 'admin', 'admin', '2024-10-30 05:56:38.938+00', '2024-10-30 05:56:43.352+00', NULL, '[]');


--
-- Data for Name: attributes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.attributes VALUES ('length', '{"ru": "Длина"}', 0, '[4]', '[4]', '[]', false, 3, '', '{"ru": ""}', NULL, false, false, 1, 'default', 'admin', 'admin', '2024-10-29 10:06:33.677+00', '2024-10-29 10:06:33.677+00', NULL, '[]');
INSERT INTO public.attributes VALUES ('width', '{"ru": "Ширина"}', 0, '[4]', '[4]', '[]', false, 3, '', '{"ru": ""}', NULL, false, false, 2, 'default', 'admin', 'admin', '2024-10-29 10:06:53.823+00', '2024-10-29 10:06:53.823+00', NULL, '[]');
INSERT INTO public.attributes VALUES ('TypeOfNomenclature_d_1730269063809', '{"ru": "Тип номенклатуры"}', 0, '[7, 5, 6, 3]', '[7]', '[]', false, 1, '', '{"ru": ""}', NULL, false, false, 3, 'default', 'admin', 'admin', '2024-10-30 06:02:50.638+00', '2024-10-30 06:17:43.816+00', '2024-10-30 06:17:43.816+00', '[]');
INSERT INTO public.attributes VALUES ('TypeOfNomenclature', '{"ru": "Тип номенклатуры"}', 0, '[7]', '[7]', '[]', false, 1, '', '{"ru": ""}', NULL, false, false, 4, 'default', 'admin', 'admin', '2024-10-30 06:18:53.44+00', '2024-10-30 06:18:53.44+00', NULL, '[]');


--
-- Data for Name: channels; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: channels_exec; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: collectionItems; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: collections; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: dashboards; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: group_attribute; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.group_attribute VALUES ('2024-10-29 10:06:33.7+00', '2024-10-29 10:06:33.7+00', 1, 1);
INSERT INTO public.group_attribute VALUES ('2024-10-29 10:06:53.835+00', '2024-10-29 10:06:53.835+00', 1, 2);
INSERT INTO public.group_attribute VALUES ('2024-10-30 06:02:50.651+00', '2024-10-30 06:02:50.651+00', 2, 3);
INSERT INTO public.group_attribute VALUES ('2024-10-30 06:18:53.456+00', '2024-10-30 06:18:53.456+00', 2, 4);


--
-- Data for Name: importConfigs; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: itemRelations; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: items; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.items VALUES ('example3_d_1729599335388', '1', '{"ru": "asdasd"}', 1, 'example', '', '{}', '', '', '', 1, 'default', 'admin', 'admin', '2024-10-22 12:04:08.548+00', '2024-10-22 12:15:35.399+00', '2024-10-22 12:15:35.399+00', '{}');
INSERT INTO public.items VALUES ('Metalll42', '7.15.22', '{"en": "Арматура (в мотках) 16-А240С-2"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 22, 'default', 'admin', 'admin', '2024-10-30 06:34:34.922+00', '2024-10-30 06:34:34.922+00', NULL, '{}');
INSERT INTO public.items VALUES ('info', '4', '{"ru": "Информация"}', 3, 'info', '', '{}', '', '', '', 4, 'default', 'admin', 'admin', '2024-10-22 13:24:34.217+00', '2024-10-22 13:24:34.217+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metall22', '7', '{"ru": "Материалы из металла"}', 5, 'Metall', '', '{}', '', '', '', 7, 'default', 'admin', 'admin', '2024-10-23 10:12:08.986+00', '2024-10-23 10:12:08.986+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metall22_sem_440', '440', '{"ru": "Металлические материалы"}', 5, 'Metall', '', '{}', '', '', '', 440, 'default', 'admin', 'admin', '2024-10-23 10:12:08.986+00', '2024-10-23 10:12:08.986+00', NULL, '{}');
INSERT INTO public.items VALUES ('Pie', '7.8', '{"ru": "Трубы"}', 6, 'Category', 'Metall22', '{}', '', '', '', 8, 'default', 'admin', 'admin', '2024-10-23 10:13:01.298+00', '2024-10-23 10:13:01.298+00', NULL, '{}');
INSERT INTO public.items VALUES ('Pie_sem_441', '7.441', '{"ru": "Трубные изделия"}', 6, 'Category', 'Metall22', '{}', '', '', '', 441, 'default', 'admin', 'admin', '2024-10-23 10:13:01.298+00', '2024-10-23 10:13:01.298+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll43', '7.15.23', '{"en": "Арматура (в мотках) 5,5-B240В-P(SAE1006)-УО2"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 23, 'default', 'admin', 'admin', '2024-10-30 06:34:34.942+00', '2024-10-30 06:34:34.942+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll44', '7.15.24', '{"en": "Арматура (в мотках) 5,5-B240В-P(SAE1008)-УО2"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 24, 'default', 'admin', 'admin', '2024-10-30 06:34:34.959+00', '2024-10-30 06:34:34.959+00', NULL, '{}');
INSERT INTO public.items VALUES ('ldsp20', '4.5', '{"ru": "лдсп1"}', 4, 'ldsp', 'info', '{"width": 10, "length": 10}', '', '', '', 5, 'default', 'admin', 'admin', '2024-10-22 13:24:42.961+00', '2024-10-29 10:13:40.897+00', NULL, '{}');
INSERT INTO public.items VALUES ('ldsp21', '4.6', '{"ru": "лдсп2"}', 4, 'ldsp', 'info', '{"width": 20, "length": 20}', '', '', '', 6, 'default', 'admin', 'admin', '2024-10-22 13:24:50.381+00', '2024-10-29 10:13:40.913+00', NULL, '{}');
INSERT INTO public.items VALUES ('new1', '4.11', '{"ru": "лдсп3"}', 4, 'ldsp', 'info', '{"width": 30, "length": 30}', '', '', '', 11, 'default', 'admin', 'admin', '2024-10-29 10:13:40.933+00', '2024-10-29 10:13:40.933+00', NULL, '{}');
INSERT INTO public.items VALUES ('new2', '4.12', '{"ru": "лдсп4"}', 4, 'ldsp', 'info', '{"width": 40, "length": 40}', '', '', '', 12, 'default', 'admin', 'admin', '2024-10-29 10:13:40.951+00', '2024-10-29 10:13:40.951+00', NULL, '{}');
INSERT INTO public.items VALUES ('Board10_d_1730259309296', '2', '{"ru": "тест"}', 2, 'Board', '', '{}', '', '', '', 2, 'default', 'admin', 'admin', '2024-10-22 13:14:49.177+00', '2024-10-30 03:35:09.32+00', '2024-10-30 03:35:09.319+00', '{}');
INSERT INTO public.items VALUES ('Metalll24_d_1730259720598', '7.8.9', '{"ru": "Труба 20х20"}', 7, 'Metalll', 'Pie', '{}', '', '', '', 9, 'default', 'admin', 'admin', '2024-10-23 11:09:08.571+00', '2024-10-30 03:42:00.606+00', '2024-10-30 03:42:00.606+00', '{}');
INSERT INTO public.items VALUES ('Metalll24_sem_442', '7.8.442', '{"ru": "Профильная труба 20х20"}', 7, 'Metalll', 'Pie', '{}', '', '', '', 442, 'default', 'admin', 'admin', '2024-10-23 11:09:08.571+00', '2024-10-30 03:42:00.606+00', '2024-10-30 03:42:00.606+00', '{}');
INSERT INTO public.items VALUES ('Metalll25_d_1730259723977', '7.8.10', '{"ru": "Труба 30х30"}', 7, 'Metalll', 'Pie', '{}', '', '', '', 10, 'default', 'admin', 'admin', '2024-10-23 11:10:56.343+00', '2024-10-30 03:42:03.984+00', '2024-10-30 03:42:03.984+00', '{}');
INSERT INTO public.items VALUES ('Metalll25_sem_443', '7.8.443', '{"ru": "Профильная труба 30х30"}', 7, 'Metalll', 'Pie', '{}', '', '', '', 443, 'default', 'admin', 'admin', '2024-10-23 11:10:56.343+00', '2024-10-30 03:42:03.984+00', '2024-10-30 03:42:03.984+00', '{}');
INSERT INTO public.items VALUES ('Metalll28', '7.8.13', '{"ru": "Арматура (в мотках) 10,0-А240С-2"}', 7, 'Metalll', 'Pie', '{}', '', '', '', 13, 'default', 'admin', 'admin', '2024-10-30 03:42:30.806+00', '2024-10-30 06:07:01.462+00', NULL, '{}');
INSERT INTO public.items VALUES ('Board17_d_1730268864958', '3', '{"ru": "лдсп 12"}', 2, 'Board', '', '{}', '', '', '', 3, 'default', 'admin', 'admin', '2024-10-22 13:16:42.438+00', '2024-10-30 06:14:24.965+00', '2024-10-30 06:14:24.964+00', '{}');
INSERT INTO public.items VALUES ('ldsp33', '4.14', '{"ru": "длолдодлдло"}', 4, 'ldsp', 'info', '{}', '', '', '', 14, 'default', 'admin', 'admin', '2024-10-30 06:16:30.029+00', '2024-10-30 06:16:30.029+00', NULL, '{}');
INSERT INTO public.items VALUES ('NMAb', '7.15', '{"ru": "Номенклатура Абинск"}', 6, 'Category', 'Metall22', '{}', '', '', '', 15, 'default', 'admin', 'admin', '2024-10-30 06:17:06.447+00', '2024-10-30 06:17:06.447+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll45', '7.15.25', '{"en": "Арматура (в мотках) 6-B240A-P-УО2"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 25, 'default', 'admin', 'admin', '2024-10-30 06:34:34.976+00', '2024-10-30 06:34:34.976+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll36', '7.15.16', '{"en": "Арматура (в мотках) 10,0-А240С-2", "ru": "Арматура"}', 7, 'Metalll', 'NMAb', '{"TypeOfNomenclature": "Арматурный прокат"}', '', '', '', 16, 'default', 'admin', 'admin', '2024-10-30 06:20:04.562+00', '2024-10-30 06:34:34.817+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll37', '7.15.17', '{"en": "Арматура (в мотках) 10,5-А240С-1"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 17, 'default', 'admin', 'admin', '2024-10-30 06:34:34.834+00', '2024-10-30 06:34:34.834+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll38', '7.15.18', '{"en": "Арматура (в мотках) 10M-400W"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 18, 'default', 'admin', 'admin', '2024-10-30 06:34:34.849+00', '2024-10-30 06:34:34.849+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll39', '7.15.19', '{"en": "Арматура (в мотках) 11-А240С-1"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 19, 'default', 'admin', 'admin', '2024-10-30 06:34:34.868+00', '2024-10-30 06:34:34.868+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll40', '7.15.20', '{"en": "Арматура (в мотках) 15M-400W"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 20, 'default', 'admin', 'admin', '2024-10-30 06:34:34.889+00', '2024-10-30 06:34:34.889+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll41', '7.15.21', '{"en": "Арматура (в мотках) 16,0-S500W-C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 21, 'default', 'admin', 'admin', '2024-10-30 06:34:34.906+00', '2024-10-30 06:34:34.906+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll46', '7.15.26', '{"en": "Арматура (в мотках) 8,0-B240В-P(SAE1006)-УО2"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 26, 'default', 'admin', 'admin', '2024-10-30 06:34:34.995+00', '2024-10-30 06:34:34.995+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll47', '7.15.27', '{"en": "Арматура (в мотках) 8,0-А240С-1"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 27, 'default', 'admin', 'admin', '2024-10-30 06:34:35.013+00', '2024-10-30 06:34:35.013+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll48', '7.15.28', '{"en": "Арматура (в мотках) 8-B240A-P-УО2"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 28, 'default', 'admin', 'admin', '2024-10-30 06:34:35.033+00', '2024-10-30 06:34:35.033+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll49', '7.15.29', '{"en": "Арматура (в мотках) 8-B240В-P(SAE1008)-УО2"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 29, 'default', 'admin', 'admin', '2024-10-30 06:34:35.051+00', '2024-10-30 06:34:35.051+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll50', '7.15.30', '{"en": "Арматура (в мотках) 9,0-А240С-1"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 30, 'default', 'admin', 'admin', '2024-10-30 06:34:35.068+00', '2024-10-30 06:34:35.068+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll51', '7.15.31', '{"en": "Арматура (в мотках) 9,5-А240С-1"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 31, 'default', 'admin', 'admin', '2024-10-30 06:34:35.087+00', '2024-10-30 06:34:35.087+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll52', '7.15.32', '{"en": "Арматура (в мотках) №10-B500B"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 32, 'default', 'admin', 'admin', '2024-10-30 06:34:35.105+00', '2024-10-30 06:34:35.105+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll53', '7.15.33', '{"en": "Арматура (в мотках) №10-B500B"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 33, 'default', 'admin', 'admin', '2024-10-30 06:34:35.124+00', '2024-10-30 06:34:35.124+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll54', '7.15.34', '{"en": "Арматура (в мотках) №10-B500B"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 34, 'default', 'admin', 'admin', '2024-10-30 06:34:35.14+00', '2024-10-30 06:34:35.14+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll55', '7.15.35', '{"en": "Арматура (в мотках) №10-B500B"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 35, 'default', 'admin', 'admin', '2024-10-30 06:34:35.16+00', '2024-10-30 06:34:35.16+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll56', '7.15.36', '{"en": "Арматура (в мотках) №10-B500B - контракт"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 36, 'default', 'admin', 'admin', '2024-10-30 06:34:35.18+00', '2024-10-30 06:34:35.18+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll57', '7.15.37', '{"en": "Арматура (в мотках) №10-B500C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 37, 'default', 'admin', 'admin', '2024-10-30 06:34:35.195+00', '2024-10-30 06:34:35.195+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll58', '7.15.38', '{"en": "Арматура (в мотках) №10-B500C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 38, 'default', 'admin', 'admin', '2024-10-30 06:34:35.213+00', '2024-10-30 06:34:35.213+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll59', '7.15.39', '{"en": "Арматура (в мотках) №10-GR 40"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 39, 'default', 'admin', 'admin', '2024-10-30 06:34:35.228+00', '2024-10-30 06:34:35.228+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll60', '7.15.40', '{"en": "Арматура (в мотках) №10-GR 40"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 40, 'default', 'admin', 'admin', '2024-10-30 06:34:35.245+00', '2024-10-30 06:34:35.245+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll61', '7.15.41', '{"en": "Арматура (в мотках) №10-S500W-C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 41, 'default', 'admin', 'admin', '2024-10-30 06:34:35.261+00', '2024-10-30 06:34:35.261+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll62', '7.15.42', '{"en": "Арматура (в мотках) №10-WS221"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 42, 'default', 'admin', 'admin', '2024-10-30 06:34:35.274+00', '2024-10-30 06:34:35.274+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll63', '7.15.43', '{"en": "Арматура (в мотках) №10-WS221"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 43, 'default', 'admin', 'admin', '2024-10-30 06:34:35.29+00', '2024-10-30 06:34:35.29+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll64', '7.15.44', '{"en": "Арматура (в мотках) №10-WS221 "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 44, 'default', 'admin', 'admin', '2024-10-30 06:34:35.309+00', '2024-10-30 06:34:35.309+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll65', '7.15.45', '{"en": "Арматура (в мотках) №10-А500С"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 45, 'default', 'admin', 'admin', '2024-10-30 06:34:35.324+00', '2024-10-30 06:34:35.324+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll66', '7.15.46', '{"en": "Арматура (в мотках) №10-А500С"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 46, 'default', 'admin', 'admin', '2024-10-30 06:34:35.339+00', '2024-10-30 06:34:35.339+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll67', '7.15.47', '{"en": "Арматура (в мотках) №10-А500С-2"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 47, 'default', 'admin', 'admin', '2024-10-30 06:34:35.357+00', '2024-10-30 06:34:35.357+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll68', '7.15.48', '{"en": "Арматура (в мотках) №10-В500С"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 48, 'default', 'admin', 'admin', '2024-10-30 06:34:35.371+00', '2024-10-30 06:34:35.371+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll69', '7.15.49', '{"en": "Арматура (в мотках) №10-В500С"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 49, 'default', 'admin', 'admin', '2024-10-30 06:34:35.385+00', '2024-10-30 06:34:35.385+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll70', '7.15.50', '{"en": "Арматура (в мотках) №11-B500B"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 50, 'default', 'admin', 'admin', '2024-10-30 06:34:35.404+00', '2024-10-30 06:34:35.404+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll71', '7.15.51', '{"en": "Арматура (в мотках) №11-GR 40"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 51, 'default', 'admin', 'admin', '2024-10-30 06:34:35.42+00', '2024-10-30 06:34:35.42+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll72', '7.15.52', '{"en": "Арматура (в мотках) №11-GR 40"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 52, 'default', 'admin', 'admin', '2024-10-30 06:34:35.434+00', '2024-10-30 06:34:35.434+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll73', '7.15.53', '{"en": "Арматура (в мотках) №11-GR 60"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 53, 'default', 'admin', 'admin', '2024-10-30 06:34:35.448+00', '2024-10-30 06:34:35.448+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll74', '7.15.54', '{"en": "Арматура (в мотках) №12-"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 54, 'default', 'admin', 'admin', '2024-10-30 06:34:35.461+00', '2024-10-30 06:34:35.461+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll75', '7.15.55', '{"en": "Арматура (в мотках) №12-B500B"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 55, 'default', 'admin', 'admin', '2024-10-30 06:34:35.476+00', '2024-10-30 06:34:35.476+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll76', '7.15.56', '{"en": "Арматура (в мотках) №12-B500B"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 56, 'default', 'admin', 'admin', '2024-10-30 06:34:35.49+00', '2024-10-30 06:34:35.49+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll77', '7.15.57', '{"en": "Арматура (в мотках) №12-B500B"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 57, 'default', 'admin', 'admin', '2024-10-30 06:34:35.507+00', '2024-10-30 06:34:35.507+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll78', '7.15.58', '{"en": "Арматура (в мотках) №12-B500B"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 58, 'default', 'admin', 'admin', '2024-10-30 06:34:35.528+00', '2024-10-30 06:34:35.528+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll79', '7.15.59', '{"en": "Арматура (в мотках) №12-B500C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 59, 'default', 'admin', 'admin', '2024-10-30 06:34:35.543+00', '2024-10-30 06:34:35.543+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll80', '7.15.60', '{"en": "Арматура (в мотках) №12-B500C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 60, 'default', 'admin', 'admin', '2024-10-30 06:34:35.56+00', '2024-10-30 06:34:35.56+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll81', '7.15.61', '{"en": "Арматура (в мотках) №12-GR 40"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 61, 'default', 'admin', 'admin', '2024-10-30 06:34:35.578+00', '2024-10-30 06:34:35.578+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll82', '7.15.62', '{"en": "Арматура (в мотках) №12-GR 40"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 62, 'default', 'admin', 'admin', '2024-10-30 06:34:35.592+00', '2024-10-30 06:34:35.592+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll83', '7.15.63', '{"en": "Арматура (в мотках) №12-K500C-KR-500"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 63, 'default', 'admin', 'admin', '2024-10-30 06:34:35.605+00', '2024-10-30 06:34:35.605+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll84', '7.15.64', '{"en": "Арматура (в мотках) №12-K500C-TR-500"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 64, 'default', 'admin', 'admin', '2024-10-30 06:34:35.617+00', '2024-10-30 06:34:35.617+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll85', '7.15.65', '{"en": "Арматура (в мотках) №12-S500W-C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 65, 'default', 'admin', 'admin', '2024-10-30 06:34:35.63+00', '2024-10-30 06:34:35.63+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll86', '7.15.66', '{"en": "Арматура (в мотках) №12-WS221"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 66, 'default', 'admin', 'admin', '2024-10-30 06:34:35.642+00', '2024-10-30 06:34:35.642+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll87', '7.15.67', '{"en": "Арматура (в мотках) №12-WS221"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 67, 'default', 'admin', 'admin', '2024-10-30 06:34:35.656+00', '2024-10-30 06:34:35.656+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll88', '7.15.68', '{"en": "Арматура (в мотках) №12-WS221 "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 68, 'default', 'admin', 'admin', '2024-10-30 06:34:35.668+00', '2024-10-30 06:34:35.668+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll89', '7.15.69', '{"en": "Арматура (в мотках) №12-А400С-2"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 69, 'default', 'admin', 'admin', '2024-10-30 06:34:35.682+00', '2024-10-30 06:34:35.682+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll90', '7.15.70', '{"en": "Арматура (в мотках) №12-А500-3"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 70, 'default', 'admin', 'admin', '2024-10-30 06:34:35.698+00', '2024-10-30 06:34:35.698+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll91', '7.15.71', '{"en": "Арматура (в мотках) №12-А500С"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 71, 'default', 'admin', 'admin', '2024-10-30 06:34:35.712+00', '2024-10-30 06:34:35.712+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll92', '7.15.72', '{"en": "Арматура (в мотках) №12-А500С"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 72, 'default', 'admin', 'admin', '2024-10-30 06:34:35.728+00', '2024-10-30 06:34:35.728+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll93', '7.15.73', '{"en": "Арматура (в мотках) №12-А500С брак"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 73, 'default', 'admin', 'admin', '2024-10-30 06:34:35.747+00', '2024-10-30 06:34:35.747+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll94', '7.15.74', '{"en": "Арматура (в мотках) №12-А500С брак"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 74, 'default', 'admin', 'admin', '2024-10-30 06:34:35.761+00', '2024-10-30 06:34:35.761+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll95', '7.15.75', '{"en": "Арматура (в мотках) №12-А500С-2"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 75, 'default', 'admin', 'admin', '2024-10-30 06:34:35.777+00', '2024-10-30 06:34:35.777+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll96', '7.15.76', '{"en": "Арматура (в мотках) №12-А500С-2"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 76, 'default', 'admin', 'admin', '2024-10-30 06:34:35.798+00', '2024-10-30 06:34:35.798+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll97', '7.15.77', '{"en": "Арматура (в мотках) №12-В500С"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 77, 'default', 'admin', 'admin', '2024-10-30 06:34:35.819+00', '2024-10-30 06:34:35.819+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll98', '7.15.78', '{"en": "Арматура (в мотках) №12-В500С"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 78, 'default', 'admin', 'admin', '2024-10-30 06:34:35.834+00', '2024-10-30 06:34:35.834+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll99', '7.15.79', '{"en": "Арматура (в мотках) №13-B500B"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 79, 'default', 'admin', 'admin', '2024-10-30 06:34:35.848+00', '2024-10-30 06:34:35.848+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll100', '7.15.80', '{"en": "Арматура (в мотках) №13-B500B - контракт"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 80, 'default', 'admin', 'admin', '2024-10-30 06:34:35.863+00', '2024-10-30 06:34:35.863+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll101', '7.15.81', '{"en": "Арматура (в мотках) №6-А500С-2"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 81, 'default', 'admin', 'admin', '2024-10-30 06:34:35.875+00', '2024-10-30 06:34:35.875+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll102', '7.15.82', '{"en": "Арматура (в мотках) №14-"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 82, 'default', 'admin', 'admin', '2024-10-30 06:34:35.888+00', '2024-10-30 06:34:35.888+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll103', '7.15.83', '{"en": "Арматура (в мотках) №14-A-III(A400)(25Г2С)"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 83, 'default', 'admin', 'admin', '2024-10-30 06:34:35.901+00', '2024-10-30 06:34:35.901+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll104', '7.15.84', '{"en": "Арматура (в мотках) №14-B500C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 84, 'default', 'admin', 'admin', '2024-10-30 06:34:35.915+00', '2024-10-30 06:34:35.915+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll105', '7.15.85', '{"en": "Арматура (в мотках) №14-B500C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 85, 'default', 'admin', 'admin', '2024-10-30 06:34:35.93+00', '2024-10-30 06:34:35.93+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll106', '7.15.86', '{"en": "Арматура (в мотках) №14-GR 40"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 86, 'default', 'admin', 'admin', '2024-10-30 06:34:35.947+00', '2024-10-30 06:34:35.947+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll107', '7.15.87', '{"en": "Арматура (в мотках) №14-GR 40"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 87, 'default', 'admin', 'admin', '2024-10-30 06:34:35.96+00', '2024-10-30 06:34:35.96+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll108', '7.15.88', '{"en": "Арматура (в мотках) №14-S500W-C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 88, 'default', 'admin', 'admin', '2024-10-30 06:34:35.974+00', '2024-10-30 06:34:35.974+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll109', '7.15.89', '{"en": "Арматура (в мотках) №14-А500С"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 89, 'default', 'admin', 'admin', '2024-10-30 06:34:35.989+00', '2024-10-30 06:34:35.989+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll110', '7.15.90', '{"en": "Арматура (в мотках) №14-А500С"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 90, 'default', 'admin', 'admin', '2024-10-30 06:34:36.007+00', '2024-10-30 06:34:36.007+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll111', '7.15.91', '{"en": "Арматура (в мотках) №14-А500С-2"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 91, 'default', 'admin', 'admin', '2024-10-30 06:34:36.025+00', '2024-10-30 06:34:36.025+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll112', '7.15.92', '{"en": "Арматура (в мотках) №16-B500C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 92, 'default', 'admin', 'admin', '2024-10-30 06:34:36.04+00', '2024-10-30 06:34:36.04+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll113', '7.15.93', '{"en": "Арматура (в мотках) №16-B500C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 93, 'default', 'admin', 'admin', '2024-10-30 06:34:36.055+00', '2024-10-30 06:34:36.055+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll114', '7.15.94', '{"en": "Арматура (в мотках) №16-B500C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 94, 'default', 'admin', 'admin', '2024-10-30 06:34:36.069+00', '2024-10-30 06:34:36.069+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll115', '7.15.95', '{"en": "Арматура (в мотках) №16-B500C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 95, 'default', 'admin', 'admin', '2024-10-30 06:34:36.085+00', '2024-10-30 06:34:36.085+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll116', '7.15.96', '{"en": "Арматура (в мотках) №16-GR 40"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 96, 'default', 'admin', 'admin', '2024-10-30 06:34:36.1+00', '2024-10-30 06:34:36.1+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll117', '7.15.97', '{"en": "Арматура (в мотках) №16-S500W-C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 97, 'default', 'admin', 'admin', '2024-10-30 06:34:36.113+00', '2024-10-30 06:34:36.113+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll118', '7.15.98', '{"en": "Арматура (в мотках) №16-WS221"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 98, 'default', 'admin', 'admin', '2024-10-30 06:34:36.129+00', '2024-10-30 06:34:36.129+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll119', '7.15.99', '{"en": "Арматура (в мотках) №16-WS221"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 99, 'default', 'admin', 'admin', '2024-10-30 06:34:36.148+00', '2024-10-30 06:34:36.148+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll120', '7.15.100', '{"en": "Арматура (в мотках) №16-WS221 "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 100, 'default', 'admin', 'admin', '2024-10-30 06:34:36.167+00', '2024-10-30 06:34:36.167+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll121', '7.15.101', '{"en": "Арматура (в мотках) №16-А400С-1"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 101, 'default', 'admin', 'admin', '2024-10-30 06:34:36.184+00', '2024-10-30 06:34:36.184+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll122', '7.15.102', '{"en": "Арматура (в мотках) №16-А400С-2"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 102, 'default', 'admin', 'admin', '2024-10-30 06:34:36.199+00', '2024-10-30 06:34:36.199+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll123', '7.15.103', '{"en": "Арматура (в мотках) №16-А500С"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 103, 'default', 'admin', 'admin', '2024-10-30 06:34:36.211+00', '2024-10-30 06:34:36.211+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll124', '7.15.104', '{"en": "Арматура (в мотках) №16-А500С"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 104, 'default', 'admin', 'admin', '2024-10-30 06:34:36.225+00', '2024-10-30 06:34:36.225+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll125', '7.15.105', '{"en": "Арматура №12х12000-B500B"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 105, 'default', 'admin', 'admin', '2024-10-30 06:34:36.245+00', '2024-10-30 06:34:36.245+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll126', '7.15.106', '{"en": "Арматура (в мотках) №16-А500С-2"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 106, 'default', 'admin', 'admin', '2024-10-30 06:34:36.267+00', '2024-10-30 06:34:36.267+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll127', '7.15.107', '{"en": "Арматура (в мотках) №16-В500С"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 107, 'default', 'admin', 'admin', '2024-10-30 06:34:36.28+00', '2024-10-30 06:34:36.28+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll128', '7.15.108', '{"en": "Арматура (в мотках) №18-B500C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 108, 'default', 'admin', 'admin', '2024-10-30 06:34:36.295+00', '2024-10-30 06:34:36.295+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll129', '7.15.109', '{"en": "Арматура (в мотках) №18-S500W-C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 109, 'default', 'admin', 'admin', '2024-10-30 06:34:36.312+00', '2024-10-30 06:34:36.312+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll130', '7.15.110', '{"en": "Арматура (в мотках) №20-B500C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 110, 'default', 'admin', 'admin', '2024-10-30 06:34:36.327+00', '2024-10-30 06:34:36.327+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll131', '7.15.111', '{"en": "Арматура (в мотках) №20-K500C-KR-500"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 111, 'default', 'admin', 'admin', '2024-10-30 06:34:36.339+00', '2024-10-30 06:34:36.339+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll132', '7.15.112', '{"en": "Арматура (в мотках) №20-K500C-TR-500"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 112, 'default', 'admin', 'admin', '2024-10-30 06:34:36.353+00', '2024-10-30 06:34:36.353+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll133', '7.15.113', '{"en": "Арматура (в мотках) №20-S500W-C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 113, 'default', 'admin', 'admin', '2024-10-30 06:34:36.368+00', '2024-10-30 06:34:36.368+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll134', '7.15.114', '{"en": "Арматура (в мотках) №22-S500W-C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 114, 'default', 'admin', 'admin', '2024-10-30 06:34:36.385+00', '2024-10-30 06:34:36.385+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll135', '7.15.115', '{"en": "Арматура (в мотках) №25-S500W-C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 115, 'default', 'admin', 'admin', '2024-10-30 06:34:36.402+00', '2024-10-30 06:34:36.402+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll136', '7.15.116', '{"en": "Арматура (в мотках) №3\"-GR 60"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 116, 'default', 'admin', 'admin', '2024-10-30 06:34:36.67+00', '2024-10-30 06:34:36.67+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll137', '7.15.117', '{"en": "Арматура (в мотках) №4\"-GR 60"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 117, 'default', 'admin', 'admin', '2024-10-30 06:34:36.684+00', '2024-10-30 06:34:36.684+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll138', '7.15.118', '{"en": "Арматура (в мотках) №5\"-GR 60"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 118, 'default', 'admin', 'admin', '2024-10-30 06:34:36.696+00', '2024-10-30 06:34:36.696+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll139', '7.15.119', '{"en": "Арматура (в мотках) №6-WS221"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 119, 'default', 'admin', 'admin', '2024-10-30 06:34:36.707+00', '2024-10-30 06:34:36.707+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll140', '7.15.120', '{"en": "Арматура (в мотках) №6-WS221"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 120, 'default', 'admin', 'admin', '2024-10-30 06:34:36.72+00', '2024-10-30 06:34:36.72+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll141', '7.15.121', '{"en": "Арматура (в мотках) №6-WS221 "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 121, 'default', 'admin', 'admin', '2024-10-30 06:34:36.732+00', '2024-10-30 06:34:36.732+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll142', '7.15.122', '{"en": "Арматура (в мотках) №6-WS221"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 122, 'default', 'admin', 'admin', '2024-10-30 06:34:36.745+00', '2024-10-30 06:34:36.745+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll143', '7.15.123', '{"en": "Арматура (в мотках) №6-А400С-2"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 123, 'default', 'admin', 'admin', '2024-10-30 06:34:36.756+00', '2024-10-30 06:34:36.756+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll144', '7.15.124', '{"en": "Арматура (в мотках) №6-А500С"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 124, 'default', 'admin', 'admin', '2024-10-30 06:34:36.768+00', '2024-10-30 06:34:36.768+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll145', '7.15.125', '{"en": "Арматура (в мотках) №6-А500С"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 125, 'default', 'admin', 'admin', '2024-10-30 06:34:36.78+00', '2024-10-30 06:34:36.78+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll146', '7.15.126', '{"en": "Арматура (в мотках) №6-А500С брак"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 126, 'default', 'admin', 'admin', '2024-10-30 06:34:36.793+00', '2024-10-30 06:34:36.793+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll147', '7.15.127', '{"en": "Арматура (в мотках) №6-А500С брак"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 127, 'default', 'admin', 'admin', '2024-10-30 06:34:36.805+00', '2024-10-30 06:34:36.805+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll148', '7.15.128', '{"en": "Арматура (в мотках) №8-B500B"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 128, 'default', 'admin', 'admin', '2024-10-30 06:34:36.817+00', '2024-10-30 06:34:36.817+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll149', '7.15.129', '{"en": "Арматура (в мотках) №8-B500B"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 129, 'default', 'admin', 'admin', '2024-10-30 06:34:36.829+00', '2024-10-30 06:34:36.829+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll150', '7.15.130', '{"en": "Арматура (в мотках) №8-B500B"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 130, 'default', 'admin', 'admin', '2024-10-30 06:34:36.842+00', '2024-10-30 06:34:36.842+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll151', '7.15.131', '{"en": "Арматура (в мотках) №8-B500B"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 131, 'default', 'admin', 'admin', '2024-10-30 06:34:36.854+00', '2024-10-30 06:34:36.854+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll152', '7.15.132', '{"en": "Арматура (в мотках) №8-B500C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 132, 'default', 'admin', 'admin', '2024-10-30 06:34:36.868+00', '2024-10-30 06:34:36.868+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll153', '7.15.133', '{"en": "Арматура (в мотках) №8-B500C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 133, 'default', 'admin', 'admin', '2024-10-30 06:34:36.88+00', '2024-10-30 06:34:36.88+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll154', '7.15.134', '{"en": "Арматура (в мотках) №8-GR 40"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 134, 'default', 'admin', 'admin', '2024-10-30 06:34:36.893+00', '2024-10-30 06:34:36.893+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll155', '7.15.135', '{"en": "Арматура (в мотках) №8-GR 40"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 135, 'default', 'admin', 'admin', '2024-10-30 06:34:36.905+00', '2024-10-30 06:34:36.905+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll156', '7.15.136', '{"en": "Арматура (в мотках) №8-GR 60"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 136, 'default', 'admin', 'admin', '2024-10-30 06:34:36.918+00', '2024-10-30 06:34:36.918+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll157', '7.15.137', '{"en": "Арматура (в мотках) №8-K500C-KR-500"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 137, 'default', 'admin', 'admin', '2024-10-30 06:34:36.934+00', '2024-10-30 06:34:36.934+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll158', '7.15.138', '{"en": "Арматура (в мотках) №8-K500C-TR-500"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 138, 'default', 'admin', 'admin', '2024-10-30 06:34:36.95+00', '2024-10-30 06:34:36.95+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll159', '7.15.139', '{"en": "Арматура (в мотках) №8-S500W-C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 139, 'default', 'admin', 'admin', '2024-10-30 06:34:36.965+00', '2024-10-30 06:34:36.965+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll160', '7.15.140', '{"en": "Арматура (в мотках) №8-S500W-Cспулз"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 140, 'default', 'admin', 'admin', '2024-10-30 06:34:36.977+00', '2024-10-30 06:34:36.977+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll161', '7.15.141', '{"en": "Арматура (в мотках) №8-WS221"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 141, 'default', 'admin', 'admin', '2024-10-30 06:34:36.989+00', '2024-10-30 06:34:36.989+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll162', '7.15.142', '{"en": "Арматура (в мотках) №8-WS221"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 142, 'default', 'admin', 'admin', '2024-10-30 06:34:37.003+00', '2024-10-30 06:34:37.003+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll163', '7.15.143', '{"en": "Арматура (в мотках) №8-WS221 "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 143, 'default', 'admin', 'admin', '2024-10-30 06:34:37.013+00', '2024-10-30 06:34:37.013+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll164', '7.15.144', '{"en": "Арматура (в мотках) №8-А300С-1"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 144, 'default', 'admin', 'admin', '2024-10-30 06:34:37.022+00', '2024-10-30 06:34:37.022+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll165', '7.15.145', '{"en": "Арматура (в мотках) №8-А400С-2"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 145, 'default', 'admin', 'admin', '2024-10-30 06:34:37.035+00', '2024-10-30 06:34:37.035+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll166', '7.15.146', '{"en": "Арматура (в мотках) №8-А500С"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 146, 'default', 'admin', 'admin', '2024-10-30 06:34:37.048+00', '2024-10-30 06:34:37.048+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll167', '7.15.147', '{"en": "Арматура (в мотках) №8-А500С"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 147, 'default', 'admin', 'admin', '2024-10-30 06:34:37.062+00', '2024-10-30 06:34:37.062+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll168', '7.15.148', '{"en": "Арматура (в мотках) №8-А500С-2"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 148, 'default', 'admin', 'admin', '2024-10-30 06:34:37.079+00', '2024-10-30 06:34:37.079+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll169', '7.15.149', '{"en": "Арматура (в мотках) №8-В500С"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 149, 'default', 'admin', 'admin', '2024-10-30 06:34:37.093+00', '2024-10-30 06:34:37.093+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll170', '7.15.150', '{"en": "Арматура (в мотках) Д10-А-I(А240)(Ст3пс)"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 150, 'default', 'admin', 'admin', '2024-10-30 06:34:37.106+00', '2024-10-30 06:34:37.106+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll171', '7.15.151', '{"en": "Арматура (в мотках) Д10-А-I(А240)(Ст3сп)"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 151, 'default', 'admin', 'admin', '2024-10-30 06:34:37.124+00', '2024-10-30 06:34:37.124+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll172', '7.15.152', '{"en": "Арматура (в мотках) Д11,0-А240С-1"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 152, 'default', 'admin', 'admin', '2024-10-30 06:34:37.137+00', '2024-10-30 06:34:37.137+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll173', '7.15.153', '{"en": "Арматура (в мотках) Д11,5-А240С-1"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 153, 'default', 'admin', 'admin', '2024-10-30 06:34:37.159+00', '2024-10-30 06:34:37.159+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll174', '7.15.154', '{"en": "Арматура (в мотках) Д12,0-А240С-1"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 154, 'default', 'admin', 'admin', '2024-10-30 06:34:37.175+00', '2024-10-30 06:34:37.175+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll175', '7.15.155', '{"en": "Арматура (в мотках) Д12-А-I(А240)(Ст3пс)"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 155, 'default', 'admin', 'admin', '2024-10-30 06:34:37.187+00', '2024-10-30 06:34:37.187+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll176', '7.15.156', '{"en": "Арматура (в мотках) Д12-А-I(А240)(Ст3сп)"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 156, 'default', 'admin', 'admin', '2024-10-30 06:34:37.199+00', '2024-10-30 06:34:37.199+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll177', '7.15.157', '{"en": "Арматура (в мотках) Д13,0-А240С-1"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 157, 'default', 'admin', 'admin', '2024-10-30 06:34:37.216+00', '2024-10-30 06:34:37.216+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll178', '7.15.158', '{"en": "Арматура (в мотках) Д14-A-I(A240)(Ст3пс)"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 158, 'default', 'admin', 'admin', '2024-10-30 06:34:37.233+00', '2024-10-30 06:34:37.233+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll179', '7.15.159', '{"en": "Арматура (в мотках) Д14-A-I(A240)(Ст3пс)"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 159, 'default', 'admin', 'admin', '2024-10-30 06:34:37.264+00', '2024-10-30 06:34:37.264+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll180', '7.15.160', '{"en": "Арматура (в мотках) Д5.5-(Ст1пс)"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 160, 'default', 'admin', 'admin', '2024-10-30 06:34:37.288+00', '2024-10-30 06:34:37.288+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll181', '7.15.161', '{"en": "Арматура (в мотках) Д6,0-А240С-1"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 161, 'default', 'admin', 'admin', '2024-10-30 06:34:37.318+00', '2024-10-30 06:34:37.318+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll182', '7.15.162', '{"en": "Арматура (в мотках) Д6,0-А240С-1"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 162, 'default', 'admin', 'admin', '2024-10-30 06:34:37.332+00', '2024-10-30 06:34:37.332+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll183', '7.15.163', '{"en": "Арматура (в мотках) Д6-A-I(A240)"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 163, 'default', 'admin', 'admin', '2024-10-30 06:34:37.347+00', '2024-10-30 06:34:37.347+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll184', '7.15.164', '{"en": "Арматура (в мотках) Д6-А-I(А240)(Ст3пс)"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 164, 'default', 'admin', 'admin', '2024-10-30 06:34:37.363+00', '2024-10-30 06:34:37.363+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll185', '7.15.165', '{"en": "Арматура (в мотках) Д6-A-I(A240)(Ст3сп)"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 165, 'default', 'admin', 'admin', '2024-10-30 06:34:37.377+00', '2024-10-30 06:34:37.377+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll186', '7.15.166', '{"en": "Арматура (в мотках) Д8,5-А240С-1"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 166, 'default', 'admin', 'admin', '2024-10-30 06:34:37.391+00', '2024-10-30 06:34:37.391+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll187', '7.15.167', '{"en": "Арматура (в мотках) Д8-А-I(А240)(Ст3пс)"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 167, 'default', 'admin', 'admin', '2024-10-30 06:34:37.404+00', '2024-10-30 06:34:37.404+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll188', '7.15.168', '{"en": "Арматура (в мотках) Д8-А-I(А240)(Ст3сп)"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 168, 'default', 'admin', 'admin', '2024-10-30 06:34:37.417+00', '2024-10-30 06:34:37.417+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll189', '7.15.169', '{"en": "Арматура (в мотках) Д9,0-A-I(A240)"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 169, 'default', 'admin', 'admin', '2024-10-30 06:34:37.429+00', '2024-10-30 06:34:37.429+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll190', '7.15.170', '{"en": "Арматура (в мотках) Д9,0-А240С-1"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 170, 'default', 'admin', 'admin', '2024-10-30 06:34:37.443+00', '2024-10-30 06:34:37.443+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll191', '7.15.171', '{"en": "Арматура (в мотках) Д9,5-А-I(А240)(Ст3сп)"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 171, 'default', 'admin', 'admin', '2024-10-30 06:34:37.456+00', '2024-10-30 06:34:37.456+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll192', '7.15.172', '{"en": "Арматура (в прутках) №10х12000-B500B "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 172, 'default', 'admin', 'admin', '2024-10-30 06:34:37.468+00', '2024-10-30 06:34:37.468+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll193', '7.15.173', '{"en": "Арматура (в прутках) №10х12000-B500C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 173, 'default', 'admin', 'admin', '2024-10-30 06:34:37.482+00', '2024-10-30 06:34:37.482+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll194', '7.15.174', '{"en": "Арматура (в прутках) №10х12000-В500С "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 174, 'default', 'admin', 'admin', '2024-10-30 06:34:37.496+00', '2024-10-30 06:34:37.496+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll195', '7.15.175', '{"en": "Арматура (в прутках) №12х12000-B500C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 175, 'default', 'admin', 'admin', '2024-10-30 06:34:37.509+00', '2024-10-30 06:34:37.509+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll196', '7.15.176', '{"en": "Арматура №14х6000-B500B "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 176, 'default', 'admin', 'admin', '2024-10-30 06:34:37.523+00', '2024-10-30 06:34:37.523+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll197', '7.15.177', '{"en": "Арматура (в прутках) №12х12000-B500C нен назначено"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 177, 'default', 'admin', 'admin', '2024-10-30 06:34:37.535+00', '2024-10-30 06:34:37.535+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll198', '7.15.178', '{"en": "Арматура (в прутках) №12х12000-В500С "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 178, 'default', 'admin', 'admin', '2024-10-30 06:34:37.549+00', '2024-10-30 06:34:37.549+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll199', '7.15.179', '{"en": "Арматура (в прутках) №14х10000-B500C "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 179, 'default', 'admin', 'admin', '2024-10-30 06:34:37.563+00', '2024-10-30 06:34:37.563+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll200', '7.15.180', '{"en": "Арматура (в прутках) №14х11000-B500C "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 180, 'default', 'admin', 'admin', '2024-10-30 06:34:37.579+00', '2024-10-30 06:34:37.579+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll201', '7.15.181', '{"en": "Арматура (в прутках) №14х12000-В500С "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 181, 'default', 'admin', 'admin', '2024-10-30 06:34:37.591+00', '2024-10-30 06:34:37.591+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll202', '7.15.182', '{"en": "Арматура (в прутках) №14х14000-B500C "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 182, 'default', 'admin', 'admin', '2024-10-30 06:34:37.605+00', '2024-10-30 06:34:37.605+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll203', '7.15.183', '{"en": "Арматура (в прутках) №14х9000-B500C "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 183, 'default', 'admin', 'admin', '2024-10-30 06:34:37.616+00', '2024-10-30 06:34:37.616+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll204', '7.15.184', '{"en": "Арматура (в прутках) №16х10000-В500С "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 184, 'default', 'admin', 'admin', '2024-10-30 06:34:37.628+00', '2024-10-30 06:34:37.628+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll205', '7.15.185', '{"en": "Арматура (в прутках) №16х11000-В500С "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 185, 'default', 'admin', 'admin', '2024-10-30 06:34:37.641+00', '2024-10-30 06:34:37.641+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll206', '7.15.186', '{"en": "Арматура (в прутках) №16х12000-B500B "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 186, 'default', 'admin', 'admin', '2024-10-30 06:34:37.657+00', '2024-10-30 06:34:37.657+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll207', '7.15.187', '{"en": "Арматура (в прутках) №16х12000-B500C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 187, 'default', 'admin', 'admin', '2024-10-30 06:34:37.672+00', '2024-10-30 06:34:37.672+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll208', '7.15.188', '{"en": "Арматура (в прутках) №16х12000-В500С "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 188, 'default', 'admin', 'admin', '2024-10-30 06:34:37.689+00', '2024-10-30 06:34:37.689+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll209', '7.15.189', '{"en": "Арматура (в прутках) №16х13000-B500C "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 189, 'default', 'admin', 'admin', '2024-10-30 06:34:37.709+00', '2024-10-30 06:34:37.709+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll210', '7.15.190', '{"en": "Арматура (в прутках) №16х14000-B500C "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 190, 'default', 'admin', 'admin', '2024-10-30 06:34:37.721+00', '2024-10-30 06:34:37.721+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll211', '7.15.191', '{"en": "Арматура (в прутках) №16х9000-В500С "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 191, 'default', 'admin', 'admin', '2024-10-30 06:34:37.737+00', '2024-10-30 06:34:37.737+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll212', '7.15.192', '{"en": "Арматура (в прутках) №18х10000-В500С "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 192, 'default', 'admin', 'admin', '2024-10-30 06:34:37.753+00', '2024-10-30 06:34:37.753+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll213', '7.15.193', '{"en": "Арматура (в прутках) №18х11000-В500С "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 193, 'default', 'admin', 'admin', '2024-10-30 06:34:37.766+00', '2024-10-30 06:34:37.766+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll214', '7.15.194', '{"en": "Арматура (в прутках) №18х12000-В500С "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 194, 'default', 'admin', 'admin', '2024-10-30 06:34:37.779+00', '2024-10-30 06:34:37.779+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll215', '7.15.195', '{"en": "Арматура (в прутках) №18х13000-B500C "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 195, 'default', 'admin', 'admin', '2024-10-30 06:34:37.796+00', '2024-10-30 06:34:37.796+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll216', '7.15.196', '{"en": "Арматура (в прутках) №18х14000-B500C "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 196, 'default', 'admin', 'admin', '2024-10-30 06:34:37.814+00', '2024-10-30 06:34:37.814+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll217', '7.15.197', '{"en": "Арматура (в прутках) №18х9000-В500С "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 197, 'default', 'admin', 'admin', '2024-10-30 06:34:37.829+00', '2024-10-30 06:34:37.829+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll218', '7.15.198', '{"en": "Арматура (в прутках) №20х10000-В500С "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 198, 'default', 'admin', 'admin', '2024-10-30 06:34:37.845+00', '2024-10-30 06:34:37.845+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll219', '7.15.199', '{"en": "Арматура №14х9000-А500С"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 199, 'default', 'admin', 'admin', '2024-10-30 06:34:37.861+00', '2024-10-30 06:34:37.861+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll220', '7.15.200', '{"en": "Арматура (в прутках) №20х11000-В500С "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 200, 'default', 'admin', 'admin', '2024-10-30 06:34:37.876+00', '2024-10-30 06:34:37.876+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll221', '7.15.201', '{"en": "Арматура (в прутках) №20х12000-В500С "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 201, 'default', 'admin', 'admin', '2024-10-30 06:34:37.889+00', '2024-10-30 06:34:37.889+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll222', '7.15.202', '{"en": "Арматура (в прутках) №20х13000-B500C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 202, 'default', 'admin', 'admin', '2024-10-30 06:34:37.905+00', '2024-10-30 06:34:37.905+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll223', '7.15.203', '{"en": "Арматура (в прутках) №20х14000-В500С "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 203, 'default', 'admin', 'admin', '2024-10-30 06:34:37.92+00', '2024-10-30 06:34:37.92+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll224', '7.15.204', '{"en": "Арматура (в прутках) №20х9000-В500С "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 204, 'default', 'admin', 'admin', '2024-10-30 06:34:37.932+00', '2024-10-30 06:34:37.932+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll225', '7.15.205', '{"en": "Арматура (в прутках) №22х10000-В500С "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 205, 'default', 'admin', 'admin', '2024-10-30 06:34:37.945+00', '2024-10-30 06:34:37.945+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll226', '7.15.206', '{"en": "Арматура (в прутках) №22х11000-В500С "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 206, 'default', 'admin', 'admin', '2024-10-30 06:34:37.957+00', '2024-10-30 06:34:37.957+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll227', '7.15.207', '{"en": "Арматура (в прутках) №22х12000-В500С "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 207, 'default', 'admin', 'admin', '2024-10-30 06:34:37.973+00', '2024-10-30 06:34:37.973+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll228', '7.15.208', '{"en": "Арматура (в прутках) №22х13000-B500C "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 208, 'default', 'admin', 'admin', '2024-10-30 06:34:37.989+00', '2024-10-30 06:34:37.989+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll229', '7.15.209', '{"en": "Арматура (в прутках) №22х14000-В500С "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 209, 'default', 'admin', 'admin', '2024-10-30 06:34:38.008+00', '2024-10-30 06:34:38.008+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll230', '7.15.210', '{"en": "Арматура (в прутках) №22х7000-В500С "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 210, 'default', 'admin', 'admin', '2024-10-30 06:34:38.023+00', '2024-10-30 06:34:38.023+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll231', '7.15.211', '{"en": "Арматура (в прутках) №22х9000-В500С "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 211, 'default', 'admin', 'admin', '2024-10-30 06:34:38.037+00', '2024-10-30 06:34:38.037+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll232', '7.15.212', '{"en": "Арматура (в прутках) №25х10000-В500С "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 212, 'default', 'admin', 'admin', '2024-10-30 06:34:38.052+00', '2024-10-30 06:34:38.052+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll233', '7.15.213', '{"en": "Арматура (в прутках) №25х11000-В500С "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 213, 'default', 'admin', 'admin', '2024-10-30 06:34:38.066+00', '2024-10-30 06:34:38.066+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll234', '7.15.214', '{"en": "Арматура (в прутках) №25х12000-В500С "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 214, 'default', 'admin', 'admin', '2024-10-30 06:34:38.083+00', '2024-10-30 06:34:38.083+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll235', '7.15.215', '{"en": "Арматура (в прутках) №25х13000-B500C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 215, 'default', 'admin', 'admin', '2024-10-30 06:34:38.098+00', '2024-10-30 06:34:38.098+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll236', '7.15.216', '{"en": "Арматура (в прутках) №25х14000-В500С "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 216, 'default', 'admin', 'admin', '2024-10-30 06:34:38.282+00', '2024-10-30 06:34:38.282+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll237', '7.15.217', '{"en": "Арматура (в прутках) №25х9000-В500С "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 217, 'default', 'admin', 'admin', '2024-10-30 06:34:38.296+00', '2024-10-30 06:34:38.296+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll238', '7.15.218', '{"en": "Арматура (в прутках) №28х10000-B500C "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 218, 'default', 'admin', 'admin', '2024-10-30 06:34:38.317+00', '2024-10-30 06:34:38.317+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll239', '7.15.219', '{"en": "Арматура (в прутках) №28х11000-B500C "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 219, 'default', 'admin', 'admin', '2024-10-30 06:34:38.33+00', '2024-10-30 06:34:38.33+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll240', '7.15.220', '{"en": "Арматура (в прутках) №28х12000-В500С "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 220, 'default', 'admin', 'admin', '2024-10-30 06:34:38.347+00', '2024-10-30 06:34:38.347+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll241', '7.15.221', '{"en": "Арматура (в прутках) №28х14000-B500C "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 221, 'default', 'admin', 'admin', '2024-10-30 06:34:38.367+00', '2024-10-30 06:34:38.367+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll242', '7.15.222', '{"en": "Арматура (в прутках) №28х9000-B500C "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 222, 'default', 'admin', 'admin', '2024-10-30 06:34:38.381+00', '2024-10-30 06:34:38.381+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll243', '7.15.223', '{"en": "Арматура (в прутках) №32х10000-В500С "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 223, 'default', 'admin', 'admin', '2024-10-30 06:34:38.398+00', '2024-10-30 06:34:38.398+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll244', '7.15.224', '{"en": "Арматура (в прутках) №32х11000-В500С "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 224, 'default', 'admin', 'admin', '2024-10-30 06:34:38.417+00', '2024-10-30 06:34:38.417+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll245', '7.15.225', '{"en": "Арматура (в прутках) №32х12000-В500С "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 225, 'default', 'admin', 'admin', '2024-10-30 06:34:38.43+00', '2024-10-30 06:34:38.43+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll246', '7.15.226', '{"en": "Арматура (в прутках) №32х13000-B500C "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 226, 'default', 'admin', 'admin', '2024-10-30 06:34:38.444+00', '2024-10-30 06:34:38.444+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll247', '7.15.227', '{"en": "Арматура (в прутках) №32х14000-B500C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 227, 'default', 'admin', 'admin', '2024-10-30 06:34:38.458+00', '2024-10-30 06:34:38.458+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll248', '7.15.228', '{"en": "Арматура (в прутках) №32х9000-B500C "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 228, 'default', 'admin', 'admin', '2024-10-30 06:34:38.473+00', '2024-10-30 06:34:38.473+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll249', '7.15.229', '{"en": "Арматура (в прутках) №36х12000-B500C "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 229, 'default', 'admin', 'admin', '2024-10-30 06:34:38.49+00', '2024-10-30 06:34:38.49+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll250', '7.15.230', '{"en": "Арматура (в прутках) №40х12000-B500B "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 230, 'default', 'admin', 'admin', '2024-10-30 06:34:38.508+00', '2024-10-30 06:34:38.508+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll251', '7.15.231', '{"en": "Арматура (в прутках) х- "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 231, 'default', 'admin', 'admin', '2024-10-30 06:34:38.524+00', '2024-10-30 06:34:38.524+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll252', '7.15.232', '{"en": "Арматура (в спулзах) №10-B500B"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 232, 'default', 'admin', 'admin', '2024-10-30 06:34:38.544+00', '2024-10-30 06:34:38.544+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll253', '7.15.233', '{"en": "Арматура (в спулзах) №10-B500C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 233, 'default', 'admin', 'admin', '2024-10-30 06:34:38.558+00', '2024-10-30 06:34:38.558+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll254', '7.15.234', '{"en": "Арматура (в спулзах) №10-B500C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 234, 'default', 'admin', 'admin', '2024-10-30 06:34:38.573+00', '2024-10-30 06:34:38.573+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll255', '7.15.235', '{"en": "Арматура (в спулзах) №10-S500W-C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 235, 'default', 'admin', 'admin', '2024-10-30 06:34:38.589+00', '2024-10-30 06:34:38.589+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll256', '7.15.236', '{"en": "Арматура (в спулзах) №12-B500B"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 236, 'default', 'admin', 'admin', '2024-10-30 06:34:38.602+00', '2024-10-30 06:34:38.602+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll257', '7.15.237', '{"en": "Арматура (в спулзах) №12-B500C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 237, 'default', 'admin', 'admin', '2024-10-30 06:34:38.615+00', '2024-10-30 06:34:38.615+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll258', '7.15.238', '{"en": "Арматура (в спулзах) №12-B500C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 238, 'default', 'admin', 'admin', '2024-10-30 06:34:38.628+00', '2024-10-30 06:34:38.628+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll259', '7.15.239', '{"en": "Арматура (в спулзах) №12-K500C-KR-500"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 239, 'default', 'admin', 'admin', '2024-10-30 06:34:38.644+00', '2024-10-30 06:34:38.644+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll260', '7.15.240', '{"en": "Арматура (в спулзах) №12-S500W-C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 240, 'default', 'admin', 'admin', '2024-10-30 06:34:38.66+00', '2024-10-30 06:34:38.66+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll261', '7.15.241', '{"en": "Арматура (в спулзах) №14-B500C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 241, 'default', 'admin', 'admin', '2024-10-30 06:34:38.674+00', '2024-10-30 06:34:38.674+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll262', '7.15.242', '{"en": "Арматура №14х9000-А500С сортировка"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 242, 'default', 'admin', 'admin', '2024-10-30 06:34:38.687+00', '2024-10-30 06:34:38.687+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll263', '7.15.243', '{"en": "Арматура (в спулзах) №14-B500C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 243, 'default', 'admin', 'admin', '2024-10-30 06:34:38.702+00', '2024-10-30 06:34:38.702+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll264', '7.15.244', '{"en": "Арматура (в спулзах) №14-S500W-C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 244, 'default', 'admin', 'admin', '2024-10-30 06:34:38.718+00', '2024-10-30 06:34:38.718+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll265', '7.15.245', '{"en": "Арматура (в спулзах) №16-B500C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 245, 'default', 'admin', 'admin', '2024-10-30 06:34:38.733+00', '2024-10-30 06:34:38.733+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll266', '7.15.246', '{"en": "Арматура (в спулзах) №16-B500C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 246, 'default', 'admin', 'admin', '2024-10-30 06:34:38.748+00', '2024-10-30 06:34:38.748+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll267', '7.15.247', '{"en": "Арматура (в спулзах) №16-B500C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 247, 'default', 'admin', 'admin', '2024-10-30 06:34:38.764+00', '2024-10-30 06:34:38.764+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll268', '7.15.248', '{"en": "Арматура (в спулзах) №16-S500W-C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 248, 'default', 'admin', 'admin', '2024-10-30 06:34:38.782+00', '2024-10-30 06:34:38.782+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll269', '7.15.249', '{"en": "Арматура (в спулзах) №18-B500C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 249, 'default', 'admin', 'admin', '2024-10-30 06:34:38.798+00', '2024-10-30 06:34:38.798+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll270', '7.15.250', '{"en": "Арматура (в спулзах) №18-S500W-C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 250, 'default', 'admin', 'admin', '2024-10-30 06:34:38.815+00', '2024-10-30 06:34:38.815+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll271', '7.15.251', '{"en": "Арматура (в спулзах) №20-B500C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 251, 'default', 'admin', 'admin', '2024-10-30 06:34:38.827+00', '2024-10-30 06:34:38.827+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll272', '7.15.252', '{"en": "Арматура (в спулзах) №20-K500C-KR-500"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 252, 'default', 'admin', 'admin', '2024-10-30 06:34:38.842+00', '2024-10-30 06:34:38.842+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll273', '7.15.253', '{"en": "Арматура (в спулзах) №20-S500W-C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 253, 'default', 'admin', 'admin', '2024-10-30 06:34:38.855+00', '2024-10-30 06:34:38.855+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll274', '7.15.254', '{"en": "Арматура (в спулзах) №8-B500B"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 254, 'default', 'admin', 'admin', '2024-10-30 06:34:38.875+00', '2024-10-30 06:34:38.875+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll275', '7.15.255', '{"en": "Арматура (в спулзах) №8-B500C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 255, 'default', 'admin', 'admin', '2024-10-30 06:34:38.891+00', '2024-10-30 06:34:38.891+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll276', '7.15.256', '{"en": "Арматура (в спулзах) №8-B500C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 256, 'default', 'admin', 'admin', '2024-10-30 06:34:38.908+00', '2024-10-30 06:34:38.908+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll277', '7.15.257', '{"en": "Арматура (в спулзах) №8-K500C-KR-500"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 257, 'default', 'admin', 'admin', '2024-10-30 06:34:38.922+00', '2024-10-30 06:34:38.922+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll278', '7.15.258', '{"en": "Арматура (в спулзах) №8-S500W-C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 258, 'default', 'admin', 'admin', '2024-10-30 06:34:38.938+00', '2024-10-30 06:34:38.938+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll279', '7.15.259', '{"en": "Арматура (в спулзах) №8-А400С-2"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 259, 'default', 'admin', 'admin', '2024-10-30 06:34:38.954+00', '2024-10-30 06:34:38.954+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll280', '7.15.260', '{"en": "Арматура 10Mх12000-400W"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 260, 'default', 'admin', 'admin', '2024-10-30 06:34:38.968+00', '2024-10-30 06:34:38.968+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll281', '7.15.261', '{"en": "Арматура 10Mх6000-400W"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 261, 'default', 'admin', 'admin', '2024-10-30 06:34:38.982+00', '2024-10-30 06:34:38.982+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll282', '7.15.262', '{"en": "Арматура 11,5х2600-SAE1010"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 262, 'default', 'admin', 'admin', '2024-10-30 06:34:38.996+00', '2024-10-30 06:34:38.996+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll283', '7.15.263', '{"en": "Арматура 12,5х11700-А240С-1"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 263, 'default', 'admin', 'admin', '2024-10-30 06:34:39.008+00', '2024-10-30 06:34:39.008+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll284', '7.15.264', '{"en": "Арматура 12,5х6000-А240С-1"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 264, 'default', 'admin', 'admin', '2024-10-30 06:34:39.02+00', '2024-10-30 06:34:39.02+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll285', '7.15.265', '{"en": "Арматура 12х12000-А240С"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 265, 'default', 'admin', 'admin', '2024-10-30 06:34:39.033+00', '2024-10-30 06:34:39.033+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll286', '7.15.266', '{"en": "Арматура 12х6000-S235J2+N"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 266, 'default', 'admin', 'admin', '2024-10-30 06:34:39.045+00', '2024-10-30 06:34:39.045+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll287', '7.15.267', '{"en": "Арматура 14х11700-А240С-1"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 267, 'default', 'admin', 'admin', '2024-10-30 06:34:39.059+00', '2024-10-30 06:34:39.059+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll288', '7.15.268', '{"en": "Арматура 14х11700-А240С-2"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 268, 'default', 'admin', 'admin', '2024-10-30 06:34:39.073+00', '2024-10-30 06:34:39.073+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll289', '7.15.269', '{"en": "Арматура 15Mх12000-400W"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 269, 'default', 'admin', 'admin', '2024-10-30 06:34:39.088+00', '2024-10-30 06:34:39.088+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll290', '7.15.270', '{"en": "Арматура 15Mх6000-400W"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 270, 'default', 'admin', 'admin', '2024-10-30 06:34:39.101+00', '2024-10-30 06:34:39.101+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll291', '7.15.271', '{"en": "Арматура 15Mх9000-400W"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 271, 'default', 'admin', 'admin', '2024-10-30 06:34:39.114+00', '2024-10-30 06:34:39.114+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll292', '7.15.272', '{"en": "Арматура 16х11700-А240С-2"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 272, 'default', 'admin', 'admin', '2024-10-30 06:34:39.127+00', '2024-10-30 06:34:39.127+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll293', '7.15.273', '{"en": "Арматура 16х6000-S235J2+N"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 273, 'default', 'admin', 'admin', '2024-10-30 06:34:39.142+00', '2024-10-30 06:34:39.142+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll294', '7.15.274', '{"en": "Арматура 18х11700-А240С-2"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 274, 'default', 'admin', 'admin', '2024-10-30 06:34:39.159+00', '2024-10-30 06:34:39.159+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll295', '7.15.275', '{"en": "Арматура 20Mх12000-400W"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 275, 'default', 'admin', 'admin', '2024-10-30 06:34:39.178+00', '2024-10-30 06:34:39.178+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll296', '7.15.276', '{"en": "Арматура 20Mх14000-400W"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 276, 'default', 'admin', 'admin', '2024-10-30 06:34:39.198+00', '2024-10-30 06:34:39.198+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll297', '7.15.277', '{"en": "Арматура 20Mх6000-400W"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 277, 'default', 'admin', 'admin', '2024-10-30 06:34:39.211+00', '2024-10-30 06:34:39.211+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll298', '7.15.278', '{"en": "Арматура 20Mх9000-400W"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 278, 'default', 'admin', 'admin', '2024-10-30 06:34:39.223+00', '2024-10-30 06:34:39.223+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll299', '7.15.279', '{"en": "Арматура 20х12000-S235J2+N"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 279, 'default', 'admin', 'admin', '2024-10-30 06:34:39.236+00', '2024-10-30 06:34:39.236+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll300', '7.15.280', '{"en": "Арматура 20х12000-Ат800(25Г2С)"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 280, 'default', 'admin', 'admin', '2024-10-30 06:34:39.25+00', '2024-10-30 06:34:39.25+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll301', '7.15.281', '{"en": "Арматура 20х6000-S235J2+N"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 281, 'default', 'admin', 'admin', '2024-10-30 06:34:39.263+00', '2024-10-30 06:34:39.263+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll302', '7.15.282', '{"en": "Арматура 25Mх12000-400W"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 282, 'default', 'admin', 'admin', '2024-10-30 06:34:39.277+00', '2024-10-30 06:34:39.277+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll303', '7.15.283', '{"en": "Арматура 25Mх14000-400W"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 283, 'default', 'admin', 'admin', '2024-10-30 06:34:39.29+00', '2024-10-30 06:34:39.29+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll304', '7.15.284', '{"en": "Арматура 25х12000-S235J2+N"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 284, 'default', 'admin', 'admin', '2024-10-30 06:34:39.307+00', '2024-10-30 06:34:39.307+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll305', '7.15.285', '{"en": "Арматура 25х6000-S235J2+N"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 285, 'default', 'admin', 'admin', '2024-10-30 06:34:39.321+00', '2024-10-30 06:34:39.321+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll306', '7.15.286', '{"en": "Арматура 28х6000-S235J2+N"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 286, 'default', 'admin', 'admin', '2024-10-30 06:34:39.335+00', '2024-10-30 06:34:39.335+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll307', '7.15.287', '{"en": "Арматура 32х12000-S235J2+N"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 287, 'default', 'admin', 'admin', '2024-10-30 06:34:39.348+00', '2024-10-30 06:34:39.348+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll308', '7.15.288', '{"en": "Арматура 32х6000-S235J2+N"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 288, 'default', 'admin', 'admin', '2024-10-30 06:34:39.36+00', '2024-10-30 06:34:39.36+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll309', '7.15.289', '{"en": "Арматура 5,5х6000-А240С-1"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 289, 'default', 'admin', 'admin', '2024-10-30 06:34:39.374+00', '2024-10-30 06:34:39.374+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll310', '7.15.290', '{"en": "Арматура 5,5х6000-Ст1пс"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 290, 'default', 'admin', 'admin', '2024-10-30 06:34:39.387+00', '2024-10-30 06:34:39.387+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll311', '7.15.291', '{"en": "Арматура 5.5х6000-А-I(А240)"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 291, 'default', 'admin', 'admin', '2024-10-30 06:34:39.402+00', '2024-10-30 06:34:39.402+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll312', '7.15.292', '{"en": "Арматура 6,0х6000-А240С-1"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 292, 'default', 'admin', 'admin', '2024-10-30 06:34:39.416+00', '2024-10-30 06:34:39.416+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll313', '7.15.293', '{"en": "Арматура 6,0х6000-А240С-1"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 293, 'default', 'admin', 'admin', '2024-10-30 06:34:39.432+00', '2024-10-30 06:34:39.432+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll314', '7.15.294', '{"en": "Арматура 6,0х7000-А240С-1"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 294, 'default', 'admin', 'admin', '2024-10-30 06:34:39.446+00', '2024-10-30 06:34:39.446+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll315', '7.15.295', '{"en": "Арматура 6,5х6000-Ст1пс"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 295, 'default', 'admin', 'admin', '2024-10-30 06:34:39.459+00', '2024-10-30 06:34:39.459+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll316', '7.15.296', '{"en": "Арматура 6,5х6000-Ст3пс"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 296, 'default', 'admin', 'admin', '2024-10-30 06:34:39.471+00', '2024-10-30 06:34:39.471+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll317', '7.15.297', '{"en": "Арматура 6х11700-А-I(А240)(Ст3пс)"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 297, 'default', 'admin', 'admin', '2024-10-30 06:34:39.483+00', '2024-10-30 06:34:39.483+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll318', '7.15.298', '{"en": "Арматура 7,5х11700-А400С-2"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 298, 'default', 'admin', 'admin', '2024-10-30 06:34:39.495+00', '2024-10-30 06:34:39.495+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll319', '7.15.299', '{"en": "Арматура 7,5х6000-А240С-1"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 299, 'default', 'admin', 'admin', '2024-10-30 06:34:39.51+00', '2024-10-30 06:34:39.51+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll320', '7.15.300', '{"en": "Арматура 8,5х6000-А240С-1"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 300, 'default', 'admin', 'admin', '2024-10-30 06:34:39.523+00', '2024-10-30 06:34:39.523+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll321', '7.15.301', '{"en": "Арматура 8х11700-A-I(A240)(Ст3сп)"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 301, 'default', 'admin', 'admin', '2024-10-30 06:34:39.537+00', '2024-10-30 06:34:39.537+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll322', '7.15.302', '{"en": "Арматура 8х6000-А240С-1"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 302, 'default', 'admin', 'admin', '2024-10-30 06:34:39.55+00', '2024-10-30 06:34:39.55+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll323', '7.15.303', '{"en": "Арматура №10\"х12000-420(60)"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 303, 'default', 'admin', 'admin', '2024-10-30 06:34:39.562+00', '2024-10-30 06:34:39.562+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll324', '7.15.304', '{"en": "Арматура №10x10000-S500W-C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 304, 'default', 'admin', 'admin', '2024-10-30 06:34:39.578+00', '2024-10-30 06:34:39.578+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll325', '7.15.305', '{"en": "Арматура №10x12000"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 305, 'default', 'admin', 'admin', '2024-10-30 06:34:39.591+00', '2024-10-30 06:34:39.591+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll326', '7.15.306', '{"en": "Арматура №10x12000"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 306, 'default', 'admin', 'admin', '2024-10-30 06:34:39.603+00', '2024-10-30 06:34:39.603+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll327', '7.15.307', '{"en": "Арматура №10x12000-S500W-C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 307, 'default', 'admin', 'admin', '2024-10-30 06:34:39.616+00', '2024-10-30 06:34:39.616+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll328', '7.15.308', '{"en": "Арматура №10x50-S500W-C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 308, 'default', 'admin', 'admin', '2024-10-30 06:34:39.628+00', '2024-10-30 06:34:39.628+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll329', '7.15.309', '{"en": "Арматура №10x6000-S500W-C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 309, 'default', 'admin', 'admin', '2024-10-30 06:34:39.643+00', '2024-10-30 06:34:39.643+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll330', '7.15.310', '{"en": "Арматура №10x600-S500W-C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 310, 'default', 'admin', 'admin', '2024-10-30 06:34:39.658+00', '2024-10-30 06:34:39.658+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll331', '7.15.311', '{"en": "Арматура №10х10000-А500С"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 311, 'default', 'admin', 'admin', '2024-10-30 06:34:39.669+00', '2024-10-30 06:34:39.669+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll332', '7.15.312', '{"en": "Арматура №10х10000-А500С"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 312, 'default', 'admin', 'admin', '2024-10-30 06:34:39.681+00', '2024-10-30 06:34:39.681+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll333', '7.15.313', '{"en": "Арматура №10х10000-Ат800(28С)"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 313, 'default', 'admin', 'admin', '2024-10-30 06:34:39.695+00', '2024-10-30 06:34:39.695+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll334', '7.15.314', '{"en": "Арматура №10х1000-B500B"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 314, 'default', 'admin', 'admin', '2024-10-30 06:34:39.707+00', '2024-10-30 06:34:39.707+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll335', '7.15.315', '{"en": "Арматура №10х1000-B500B"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 315, 'default', 'admin', 'admin', '2024-10-30 06:34:39.723+00', '2024-10-30 06:34:39.723+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll336', '7.15.316', '{"en": "Арматура №10х1000-B500C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 316, 'default', 'admin', 'admin', '2024-10-30 06:34:39.882+00', '2024-10-30 06:34:39.882+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll337', '7.15.317', '{"en": "Арматура №10х10050-Ат800(25Г2С)"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 317, 'default', 'admin', 'admin', '2024-10-30 06:34:39.896+00', '2024-10-30 06:34:39.896+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll338', '7.15.318', '{"en": "Арматура №10х10050-Ат800(28С)"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 318, 'default', 'admin', 'admin', '2024-10-30 06:34:39.912+00', '2024-10-30 06:34:39.912+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll339', '7.15.319', '{"en": "Арматура №10х10100-А500С"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 319, 'default', 'admin', 'admin', '2024-10-30 06:34:39.925+00', '2024-10-30 06:34:39.925+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll340', '7.15.320', '{"en": "Арматура №10х10100-А500С"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 320, 'default', 'admin', 'admin', '2024-10-30 06:34:39.938+00', '2024-10-30 06:34:39.938+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll341', '7.15.321', '{"en": "Арматура №10х10100-Ат800(25Г2С)"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 321, 'default', 'admin', 'admin', '2024-10-30 06:34:39.95+00', '2024-10-30 06:34:39.95+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll342', '7.15.322', '{"en": "Арматура №10х10150-Ат800(25Г2С)"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 322, 'default', 'admin', 'admin', '2024-10-30 06:34:39.962+00', '2024-10-30 06:34:39.962+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll343', '7.15.323', '{"en": "Арматура №10х10200-Ат800(25Г2С)"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 323, 'default', 'admin', 'admin', '2024-10-30 06:34:39.975+00', '2024-10-30 06:34:39.975+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll344', '7.15.324', '{"en": "Арматура №10х10300-Ат800(25Г2С)"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 324, 'default', 'admin', 'admin', '2024-10-30 06:34:39.988+00', '2024-10-30 06:34:39.988+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll345', '7.15.325', '{"en": "Арматура №10х10300-Ат800(28С)"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 325, 'default', 'admin', 'admin', '2024-10-30 06:34:40.002+00', '2024-10-30 06:34:40.002+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll346', '7.15.326', '{"en": "Арматура №10х10600-Ат800(25Г2С)"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 326, 'default', 'admin', 'admin', '2024-10-30 06:34:40.018+00', '2024-10-30 06:34:40.018+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll347', '7.15.327', '{"en": "Арматура №16х9000-А500С сортировка"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 327, 'default', 'admin', 'admin', '2024-10-30 06:34:40.03+00', '2024-10-30 06:34:40.03+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll348', '7.15.328', '{"en": "Арматура №10х10850-Ат800(28С)"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 328, 'default', 'admin', 'admin', '2024-10-30 06:34:40.043+00', '2024-10-30 06:34:40.043+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll349', '7.15.329', '{"en": "Арматура №10х10900-А500С"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 329, 'default', 'admin', 'admin', '2024-10-30 06:34:40.055+00', '2024-10-30 06:34:40.055+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll350', '7.15.330', '{"en": "Арматура №10х10900-А500С"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 330, 'default', 'admin', 'admin', '2024-10-30 06:34:40.068+00', '2024-10-30 06:34:40.068+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll351', '7.15.331', '{"en": "Арматура №10х11350-Ат800(25Г2С)"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 331, 'default', 'admin', 'admin', '2024-10-30 06:34:40.079+00', '2024-10-30 06:34:40.079+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll352', '7.15.332', '{"en": "Арматура №10х11350-Ат800(28С)"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 332, 'default', 'admin', 'admin', '2024-10-30 06:34:40.091+00', '2024-10-30 06:34:40.091+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll353', '7.15.333', '{"en": "Арматура №10х11450-Ат800(25Г2С)"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 333, 'default', 'admin', 'admin', '2024-10-30 06:34:40.104+00', '2024-10-30 06:34:40.104+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll354', '7.15.334', '{"en": "Арматура №10х11450-Ат800(28С)"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 334, 'default', 'admin', 'admin', '2024-10-30 06:34:40.116+00', '2024-10-30 06:34:40.116+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll355', '7.15.335', '{"en": "Арматура №10х11500-А500С"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 335, 'default', 'admin', 'admin', '2024-10-30 06:34:40.129+00', '2024-10-30 06:34:40.129+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll356', '7.15.336', '{"en": "Арматура №10х11550-Ат800(25Г2С)"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 336, 'default', 'admin', 'admin', '2024-10-30 06:34:40.142+00', '2024-10-30 06:34:40.142+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll357', '7.15.337', '{"en": "Арматура №10х11550-Ат800(28С)"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 337, 'default', 'admin', 'admin', '2024-10-30 06:34:40.153+00', '2024-10-30 06:34:40.153+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll358', '7.15.338', '{"en": "Арматура №10х11600-А500С"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 338, 'default', 'admin', 'admin', '2024-10-30 06:34:40.165+00', '2024-10-30 06:34:40.165+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll359', '7.15.339', '{"en": "Арматура №10х11600-А500С"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 339, 'default', 'admin', 'admin', '2024-10-30 06:34:40.18+00', '2024-10-30 06:34:40.18+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll360', '7.15.340', '{"en": "Арматура №10х11700-??500??"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 340, 'default', 'admin', 'admin', '2024-10-30 06:34:40.193+00', '2024-10-30 06:34:40.193+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll361', '7.15.341', '{"en": "Арматура №10х11700-A800-3"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 341, 'default', 'admin', 'admin', '2024-10-30 06:34:40.208+00', '2024-10-30 06:34:40.208+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll362', '7.15.342', '{"en": "Арматура №10х11700-A-III(A400)"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 342, 'default', 'admin', 'admin', '2024-10-30 06:34:40.226+00', '2024-10-30 06:34:40.226+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll363', '7.15.343', '{"en": "Арматура №10х11700-A-III(A400)(25Г2С)"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 343, 'default', 'admin', 'admin', '2024-10-30 06:34:40.238+00', '2024-10-30 06:34:40.238+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll364', '7.15.344', '{"en": "Арматура №10х11700-B500B"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 344, 'default', 'admin', 'admin', '2024-10-30 06:34:40.252+00', '2024-10-30 06:34:40.252+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll365', '7.15.345', '{"en": "Арматура №10х11700-B500B "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 345, 'default', 'admin', 'admin', '2024-10-30 06:34:40.265+00', '2024-10-30 06:34:40.265+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll366', '7.15.346', '{"en": "Арматура №10х11700-B500B "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 346, 'default', 'admin', 'admin', '2024-10-30 06:34:40.278+00', '2024-10-30 06:34:40.278+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll367', '7.15.347', '{"en": "Арматура №10х11700-B500B"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 347, 'default', 'admin', 'admin', '2024-10-30 06:34:40.292+00', '2024-10-30 06:34:40.292+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll368', '7.15.348', '{"en": "Арматура №10х11700-B500B"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 348, 'default', 'admin', 'admin', '2024-10-30 06:34:40.306+00', '2024-10-30 06:34:40.306+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll369', '7.15.349', '{"en": "Арматура №10х11700-B500NC"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 349, 'default', 'admin', 'admin', '2024-10-30 06:34:40.317+00', '2024-10-30 06:34:40.317+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll370', '7.15.350', '{"en": "Арматура №10х11700-S60"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 350, 'default', 'admin', 'admin', '2024-10-30 06:34:40.327+00', '2024-10-30 06:34:40.327+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll371', '7.15.351', '{"en": "Арматура №10х11700-WS221"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 351, 'default', 'admin', 'admin', '2024-10-30 06:34:40.34+00', '2024-10-30 06:34:40.34+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll372', '7.15.352', '{"en": "Арматура №10х11700-А300С-2"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 352, 'default', 'admin', 'admin', '2024-10-30 06:34:40.357+00', '2024-10-30 06:34:40.357+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll373', '7.15.353', '{"en": "Арматура №10х11700-А400С"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 353, 'default', 'admin', 'admin', '2024-10-30 06:34:40.371+00', '2024-10-30 06:34:40.371+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll374', '7.15.354', '{"en": "Арматура №10х11700-А400С-1"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 354, 'default', 'admin', 'admin', '2024-10-30 06:34:40.385+00', '2024-10-30 06:34:40.385+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll375', '7.15.355', '{"en": "Арматура №10х11700-А400С-2"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 355, 'default', 'admin', 'admin', '2024-10-30 06:34:40.397+00', '2024-10-30 06:34:40.397+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll376', '7.15.356', '{"en": "Арматура №10х11700-А500-3"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 356, 'default', 'admin', 'admin', '2024-10-30 06:34:40.41+00', '2024-10-30 06:34:40.41+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll377', '7.15.357', '{"en": "Арматура №10х11700-А500С"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 357, 'default', 'admin', 'admin', '2024-10-30 06:34:40.425+00', '2024-10-30 06:34:40.425+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll378', '7.15.358', '{"en": "Арматура №10х11700-А500С"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 358, 'default', 'admin', 'admin', '2024-10-30 06:34:40.438+00', '2024-10-30 06:34:40.438+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll379', '7.15.359', '{"en": "Арматура №10х11700-А500С сертификация"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 359, 'default', 'admin', 'admin', '2024-10-30 06:34:40.451+00', '2024-10-30 06:34:40.451+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll380', '7.15.360', '{"en": "Арматура №10х11700-А500С сортировка"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 360, 'default', 'admin', 'admin', '2024-10-30 06:34:40.463+00', '2024-10-30 06:34:40.463+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll381', '7.15.361', '{"en": "Арматура №10х11700-А500С сортировка"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 361, 'default', 'admin', 'admin', '2024-10-30 06:34:40.478+00', '2024-10-30 06:34:40.478+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll382', '7.15.362', '{"en": "Арматура №10х11700-А500С-1"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 362, 'default', 'admin', 'admin', '2024-10-30 06:34:40.492+00', '2024-10-30 06:34:40.492+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll383', '7.15.363', '{"en": "Арматура №10х11700-А500С-2"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 363, 'default', 'admin', 'admin', '2024-10-30 06:34:40.506+00', '2024-10-30 06:34:40.506+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll384', '7.15.364', '{"en": "Арматура №10х11700-А500С-2"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 364, 'default', 'admin', 'admin', '2024-10-30 06:34:40.519+00', '2024-10-30 06:34:40.519+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll385', '7.15.365', '{"en": "Арматура №10х11700-А500С-3"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 365, 'default', 'admin', 'admin', '2024-10-30 06:34:40.531+00', '2024-10-30 06:34:40.531+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll386', '7.15.366', '{"en": "Арматура №10х11700-А500С-3"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 366, 'default', 'admin', 'admin', '2024-10-30 06:34:40.543+00', '2024-10-30 06:34:40.543+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll387', '7.15.367', '{"en": "Арматура №10х11700-А600С"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 367, 'default', 'admin', 'admin', '2024-10-30 06:34:40.557+00', '2024-10-30 06:34:40.557+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll388', '7.15.368', '{"en": "Арматура №10х11700-А-I(А240)"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 368, 'default', 'admin', 'admin', '2024-10-30 06:34:40.569+00', '2024-10-30 06:34:40.569+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll389', '7.15.369', '{"en": "Арматура №10х11700-Ат500С"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 369, 'default', 'admin', 'admin', '2024-10-30 06:34:40.584+00', '2024-10-30 06:34:40.584+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll390', '7.15.370', '{"en": "Арматура №10х11700-Ат800(25Г2С)"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 370, 'default', 'admin', 'admin', '2024-10-30 06:34:40.596+00', '2024-10-30 06:34:40.596+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll391', '7.15.371', '{"en": "Арматура №10х11700-Ат800(28С)"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 371, 'default', 'admin', 'admin', '2024-10-30 06:34:40.612+00', '2024-10-30 06:34:40.612+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll392', '7.15.372', '{"en": "Арматура №10х11700-В500А"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 372, 'default', 'admin', 'admin', '2024-10-30 06:34:40.625+00', '2024-10-30 06:34:40.625+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll393', '7.15.373', '{"en": "Арматура №10х11700-В500С"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 373, 'default', 'admin', 'admin', '2024-10-30 06:34:40.637+00', '2024-10-30 06:34:40.637+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll394', '7.15.374', '{"en": "Арматура №10х11700-В500С Архив"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 374, 'default', 'admin', 'admin', '2024-10-30 06:34:40.649+00', '2024-10-30 06:34:40.649+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll395', '7.15.375', '{"en": "Арматура №10х11700-В500С"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 375, 'default', 'admin', 'admin', '2024-10-30 06:34:40.66+00', '2024-10-30 06:34:40.66+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll396', '7.15.376', '{"en": "Арматура №10х11960-B500B "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 376, 'default', 'admin', 'admin', '2024-10-30 06:34:40.673+00', '2024-10-30 06:34:40.673+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll397', '7.15.377', '{"en": "Арматура №10х12000-B500B "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 377, 'default', 'admin', 'admin', '2024-10-30 06:34:40.687+00', '2024-10-30 06:34:40.687+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll398', '7.15.378', '{"en": "Арматура №10х12000-B500B "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 378, 'default', 'admin', 'admin', '2024-10-30 06:34:40.702+00', '2024-10-30 06:34:40.702+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll399', '7.15.379', '{"en": "Арматура №10х12000-B500B"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 379, 'default', 'admin', 'admin', '2024-10-30 06:34:40.714+00', '2024-10-30 06:34:40.714+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll400', '7.15.380', '{"en": "Арматура №10х12000-B500B"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 380, 'default', 'admin', 'admin', '2024-10-30 06:34:40.727+00', '2024-10-30 06:34:40.727+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll401', '7.15.381', '{"en": "Арматура №10х12000-B500B"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 381, 'default', 'admin', 'admin', '2024-10-30 06:34:40.738+00', '2024-10-30 06:34:40.738+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll402', '7.15.382', '{"en": "Арматура №10х12000-B500B"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 382, 'default', 'admin', 'admin', '2024-10-30 06:34:40.75+00', '2024-10-30 06:34:40.75+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll403', '7.15.383', '{"en": "Арматура №10х12000-B500B"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 383, 'default', 'admin', 'admin', '2024-10-30 06:34:40.761+00', '2024-10-30 06:34:40.761+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll404', '7.15.384', '{"en": "Арматура №10х12000-B500B"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 384, 'default', 'admin', 'admin', '2024-10-30 06:34:40.774+00', '2024-10-30 06:34:40.774+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll405', '7.15.385', '{"en": "Арматура №10х12000-B500B"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 385, 'default', 'admin', 'admin', '2024-10-30 06:34:40.786+00', '2024-10-30 06:34:40.786+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll406', '7.15.386', '{"en": "Арматура №10х12000-B500B/K500B-T"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 386, 'default', 'admin', 'admin', '2024-10-30 06:34:40.8+00', '2024-10-30 06:34:40.8+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll407', '7.15.387', '{"en": "Арматура №10х12000-B500C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 387, 'default', 'admin', 'admin', '2024-10-30 06:34:40.812+00', '2024-10-30 06:34:40.812+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll408', '7.15.388', '{"en": "Арматура №10х12000-B500C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 388, 'default', 'admin', 'admin', '2024-10-30 06:34:40.823+00', '2024-10-30 06:34:40.823+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll409', '7.15.389', '{"en": "Арматура №10х12000-B500C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 389, 'default', 'admin', 'admin', '2024-10-30 06:34:40.834+00', '2024-10-30 06:34:40.834+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll410', '7.15.390', '{"en": "Арматура №10х12000-B500NB/B500B/K500B-T"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 390, 'default', 'admin', 'admin', '2024-10-30 06:34:40.847+00', '2024-10-30 06:34:40.847+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll411', '7.15.391', '{"en": "Арматура №10х12000-B500NC "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 391, 'default', 'admin', 'admin', '2024-10-30 06:34:40.858+00', '2024-10-30 06:34:40.858+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll412', '7.15.392', '{"en": "Арматура №10х12000-B500NC/K500C-T"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 392, 'default', 'admin', 'admin', '2024-10-30 06:34:40.872+00', '2024-10-30 06:34:40.872+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll413', '7.15.393', '{"en": "Арматура №10х12000-А400С"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 393, 'default', 'admin', 'admin', '2024-10-30 06:34:40.883+00', '2024-10-30 06:34:40.883+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll414', '7.15.394', '{"en": "Арматура №10х12000-А500С"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 394, 'default', 'admin', 'admin', '2024-10-30 06:34:40.896+00', '2024-10-30 06:34:40.896+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll415', '7.15.395', '{"en": "Арматура №10х12000-А500С"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 395, 'default', 'admin', 'admin', '2024-10-30 06:34:40.908+00', '2024-10-30 06:34:40.908+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll416', '7.15.396', '{"en": "Арматура №10х12000-В500С"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 396, 'default', 'admin', 'admin', '2024-10-30 06:34:40.924+00', '2024-10-30 06:34:40.924+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll417', '7.15.397', '{"en": "Арматура №10х12000-В500С"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 397, 'default', 'admin', 'admin', '2024-10-30 06:34:40.94+00', '2024-10-30 06:34:40.94+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll418', '7.15.398', '{"en": "Арматура №10х12000-В500С class C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 398, 'default', 'admin', 'admin', '2024-10-30 06:34:40.958+00', '2024-10-30 06:34:40.958+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll419', '7.15.399', '{"en": "Арматура №10х13000-А500-3"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 399, 'default', 'admin', 'admin', '2024-10-30 06:34:40.972+00', '2024-10-30 06:34:40.972+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll420', '7.15.400', '{"en": "Арматура №10х13000-А500С"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 400, 'default', 'admin', 'admin', '2024-10-30 06:34:40.985+00', '2024-10-30 06:34:40.985+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll421', '7.15.401', '{"en": "Арматура №10х13000-А500С"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 401, 'default', 'admin', 'admin', '2024-10-30 06:34:40.999+00', '2024-10-30 06:34:40.999+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll422', '7.15.402', '{"en": "Арматура №10х13000-А500С сортировка"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 402, 'default', 'admin', 'admin', '2024-10-30 06:34:41.012+00', '2024-10-30 06:34:41.012+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll423', '7.15.403', '{"en": "Арматура №10х13000-А500С сортировка"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 403, 'default', 'admin', 'admin', '2024-10-30 06:34:41.025+00', '2024-10-30 06:34:41.025+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll424', '7.15.404', '{"en": "Арматура №10х13000-Ат800(28С)"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 404, 'default', 'admin', 'admin', '2024-10-30 06:34:41.037+00', '2024-10-30 06:34:41.037+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll425', '7.15.405', '{"en": "Арматура №10х14000-А500С"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 405, 'default', 'admin', 'admin', '2024-10-30 06:34:41.058+00', '2024-10-30 06:34:41.058+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll426', '7.15.406', '{"en": "Арматура №10х14000-А500С"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 406, 'default', 'admin', 'admin', '2024-10-30 06:34:41.071+00', '2024-10-30 06:34:41.071+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll427', '7.15.407', '{"en": "Арматура №10х1400-А500С"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 407, 'default', 'admin', 'admin', '2024-10-30 06:34:41.085+00', '2024-10-30 06:34:41.085+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll428', '7.15.408', '{"en": "Арматура №10х1400-А500С"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 408, 'default', 'admin', 'admin', '2024-10-30 06:34:41.098+00', '2024-10-30 06:34:41.098+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll429', '7.15.409', '{"en": "Арматура №10х1500-B500B"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 409, 'default', 'admin', 'admin', '2024-10-30 06:34:41.11+00', '2024-10-30 06:34:41.11+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll430', '7.15.410', '{"en": "Арматура №10х1500-В500А"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 410, 'default', 'admin', 'admin', '2024-10-30 06:34:41.122+00', '2024-10-30 06:34:41.122+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll431', '7.15.411', '{"en": "Арматура №10х1700-B500B"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 411, 'default', 'admin', 'admin', '2024-10-30 06:34:41.134+00', '2024-10-30 06:34:41.134+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll432', '7.15.412', '{"en": "Арматура №10х1700-B500B "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 412, 'default', 'admin', 'admin', '2024-10-30 06:34:41.146+00', '2024-10-30 06:34:41.146+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll433', '7.15.413', '{"en": "Арматура №10х3000-А500С"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 413, 'default', 'admin', 'admin', '2024-10-30 06:34:41.159+00', '2024-10-30 06:34:41.159+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll434', '7.15.414', '{"en": "Арматура №10х3000-А500С"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 414, 'default', 'admin', 'admin', '2024-10-30 06:34:41.169+00', '2024-10-30 06:34:41.169+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll435', '7.15.415', '{"en": "Арматура №10х4000-А500С"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 415, 'default', 'admin', 'admin', '2024-10-30 06:34:41.185+00', '2024-10-30 06:34:41.185+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll436', '7.15.416', '{"en": "Арматура №10х4000-А500С"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 416, 'default', 'admin', 'admin', '2024-10-30 06:34:41.333+00', '2024-10-30 06:34:41.333+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll437', '7.15.417', '{"en": "Арматура №10х5000-А500С"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 417, 'default', 'admin', 'admin', '2024-10-30 06:34:41.346+00', '2024-10-30 06:34:41.346+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll438', '7.15.418', '{"en": "Арматура №10х5000-А500С"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 418, 'default', 'admin', 'admin', '2024-10-30 06:34:41.359+00', '2024-10-30 06:34:41.359+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll439', '7.15.419', '{"en": "Арматура №10х6000-B500B "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 419, 'default', 'admin', 'admin', '2024-10-30 06:34:41.371+00', '2024-10-30 06:34:41.371+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll440', '7.15.420', '{"en": "Арматура №10х6000-B500B"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 420, 'default', 'admin', 'admin', '2024-10-30 06:34:41.384+00', '2024-10-30 06:34:41.384+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll441', '7.15.421', '{"en": "Арматура №10х6000-B500B/K500B-T"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 421, 'default', 'admin', 'admin', '2024-10-30 06:34:41.396+00', '2024-10-30 06:34:41.396+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll442', '7.15.422', '{"en": "Арматура №10х6000-B500NB/B500B/K500B-T"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 422, 'default', 'admin', 'admin', '2024-10-30 06:34:41.41+00', '2024-10-30 06:34:41.41+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll443', '7.15.423', '{"en": "Арматура №10х6000-B500NC "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 423, 'default', 'admin', 'admin', '2024-10-30 06:34:41.422+00', '2024-10-30 06:34:41.422+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll444', '7.15.424', '{"en": "Арматура №10х6000-А400С-1"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 424, 'default', 'admin', 'admin', '2024-10-30 06:34:41.435+00', '2024-10-30 06:34:41.435+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll445', '7.15.425', '{"en": "Арматура №10х6000-А400С-2"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 425, 'default', 'admin', 'admin', '2024-10-30 06:34:41.446+00', '2024-10-30 06:34:41.446+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll446', '7.15.426', '{"en": "Арматура №10х6000-А500С"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 426, 'default', 'admin', 'admin', '2024-10-30 06:34:41.461+00', '2024-10-30 06:34:41.461+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll447', '7.15.427', '{"en": "Арматура №10х6000-А500С"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 427, 'default', 'admin', 'admin', '2024-10-30 06:34:41.473+00', '2024-10-30 06:34:41.473+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll448', '7.15.428', '{"en": "Арматура №10х6000-А500С-2"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 428, 'default', 'admin', 'admin', '2024-10-30 06:34:41.487+00', '2024-10-30 06:34:41.487+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll449', '7.15.429', '{"en": "Арматура №10х600-B500B"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 429, 'default', 'admin', 'admin', '2024-10-30 06:34:41.503+00', '2024-10-30 06:34:41.503+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll450', '7.15.430', '{"en": "Арматура №10х600-B500B "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 430, 'default', 'admin', 'admin', '2024-10-30 06:34:41.519+00', '2024-10-30 06:34:41.519+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll451', '7.15.431', '{"en": "Арматура №10х600-B500C"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 431, 'default', 'admin', 'admin', '2024-10-30 06:34:41.531+00', '2024-10-30 06:34:41.531+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll452', '7.15.432', '{"en": "Арматура №10х600-В500А "}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 432, 'default', 'admin', 'admin', '2024-10-30 06:34:41.546+00', '2024-10-30 06:34:41.546+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll453', '7.15.433', '{"en": "Арматура №10х6300-Ат800(28С)"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 433, 'default', 'admin', 'admin', '2024-10-30 06:34:41.558+00', '2024-10-30 06:34:41.558+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll454', '7.15.434', '{"en": "Арматура №10х6350-Ат800(25Г2С)"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 434, 'default', 'admin', 'admin', '2024-10-30 06:34:41.57+00', '2024-10-30 06:34:41.57+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll455', '7.15.435', '{"en": "Арматура №10х6350-Ат800(28С)"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 435, 'default', 'admin', 'admin', '2024-10-30 06:34:41.581+00', '2024-10-30 06:34:41.581+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll456', '7.15.436', '{"en": "Арматура №10х6400-Ат800(25Г2С)"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 436, 'default', 'admin', 'admin', '2024-10-30 06:34:41.594+00', '2024-10-30 06:34:41.594+00', NULL, '{}');
INSERT INTO public.items VALUES ('Metalll457', '7.15.437', '{"en": "Арматура №10х6400-Ат800(28С)"}', 7, 'Metalll', 'NMAb', '{}', '', '', '', 437, 'default', 'admin', 'admin', '2024-10-30 06:34:41.609+00', '2024-10-30 06:34:41.609+00', NULL, '{}');
INSERT INTO public.items VALUES ('BulkMaterials38_d_1730271442968', '438', '{"ru": "вввв"}', 9, 'BulkMaterials', '', '{}', '', '', '', 438, 'default', 'admin', 'admin', '2024-10-30 06:57:07.556+00', '2024-10-30 06:57:22.974+00', '2024-10-30 06:57:22.974+00', '{}');
INSERT INTO public.items VALUES ('BulkMaterials46_d_1730271667301', '439', '{"ru": "Сыпучие материалы"}', 9, 'BulkMaterials', '', '{}', '', '', '', 439, 'default', 'admin', 'admin', '2024-10-30 06:59:45.108+00', '2024-10-30 07:01:07.306+00', '2024-10-30 07:01:07.306+00', '{}');
INSERT INTO public.items VALUES ('BulkMaterials46_sem_444', '444', '{"ru": "Сыпучие товарные материалы"}', 9, 'BulkMaterials', '', '{}', '', '', '', 444, 'default', 'admin', 'admin', '2024-10-30 06:59:45.108+00', '2024-10-30 07:01:07.306+00', '2024-10-30 07:01:07.306+00', '{}');


--
-- Data for Name: languages; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.languages VALUES ('ru', '{"ru": "Русский"}', 1, 'default', 'system', 'admin', '2020-09-16 11:22:49.124158+00', '2024-10-23 11:19:42.935+00', NULL);


--
-- Data for Name: lovs; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: processes; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: relations; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.roles VALUES ('user', 'User', '{"lovs": 0, "roles": 0, "types": 0, "users": 0, "actions": 0, "channels": 0, "languages": 0, "relations": 0, "attributes": 0, "dashboards": 0, "importConfigs": 0}', '{"access": 0, "groups": [], "relations": []}', '{"valid": [], "access": 0, "groups": [], "fromItems": []}', '{"audit": false, "search": true, "imports": 0, "exportCSV": true, "exportXLS": true, "importXLS": false}', 2, 'default', 'system', 'system', '2020-09-16 11:23:32.909034+00', '2020-09-16 11:23:32.909034+00', NULL, '[]', '[]');
INSERT INTO public.roles VALUES ('admin', 'Administrator', '{"lovs": 2, "roles": 2, "types": 2, "users": 2, "actions": 2, "channels": 2, "languages": 2, "relations": 2, "attributes": 2, "dashboards": 2, "importConfigs": 2}', '{"access": 0, "groups": [], "relations": []}', '{"valid": [], "access": 0, "groups": [], "fromItems": []}', '{"audit": true, "search": true, "imports": 2, "exportCSV": true, "exportXLS": true, "importXLS": true, "searchRelations": true, "exportRelationsXLS": true, "importRelationsXLS": true}', 1, 'default', 'system', 'system', '2020-09-16 11:23:32.909034+00', '2020-09-16 11:23:32.909034+00', NULL, '[]', '[]');


--
-- Data for Name: savedColumns; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: savedSearch; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: types; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.types VALUES ('1', 'example', 0, '{"ru": "Новый тип"}', '', '', false, 0, '[]', 1, 'default', 'admin', 'admin', '2024-10-22 11:52:27.868+00', '2024-10-22 11:52:27.868+00', NULL, '[]');
INSERT INTO public.types VALUES ('3', 'info', 0, '{"ru": "Информация"}', 'folder-multiple', '', false, 0, '[]', 3, 'default', 'admin', 'admin', '2024-10-22 13:23:59.709+00', '2024-10-22 13:23:59.709+00', NULL, '[]');
INSERT INTO public.types VALUES ('3.4', 'ldsp', 0, '{"ru": "ЛДСП2"}', '', '', false, 0, '[]', 4, 'default', 'admin', 'admin', '2024-10-22 13:24:21.78+00', '2024-10-22 13:24:21.78+00', NULL, '[]');
INSERT INTO public.types VALUES ('5.6', 'Category', 0, '{"ru": "Категории"}', '', '', false, 0, '[]', 6, 'default', 'admin', 'admin', '2024-10-23 10:10:21.41+00', '2024-10-23 10:10:21.41+00', NULL, '[]');
INSERT INTO public.types VALUES ('5.6.7', 'Metalll', 0, '{"ru": "Металл"}', '', '', false, 0, '[]', 7, 'default', 'admin', 'admin', '2024-10-23 10:11:20.765+00', '2024-10-23 11:10:23.14+00', NULL, '[{"name": "Поставщик", "type": 1, "value": ""}]');
INSERT INTO public.types VALUES ('8', 'Nomenclature_deleted_1730259700689', 0, '{"ru": "Номенклатура"}', '', '', false, 0, '[]', 8, 'default', 'admin', 'admin', '2024-10-30 03:38:49.282+00', '2024-10-30 03:41:40.697+00', '2024-10-30 03:41:40.697+00', '[]');
INSERT INTO public.types VALUES ('2', 'Board', 0, '{"ru": "Номенклатура"}', '', '', false, 0, '[]', 2, 'default', 'admin', 'admin', '2024-10-22 12:14:02.211+00', '2024-10-30 06:14:08.972+00', NULL, '[]');
INSERT INTO public.types VALUES ('9', 'BulkMaterials_deleted_1730271859311', 0, '{"ru": "Сыпучие материалы"}', '', '', false, 0, '[]', 9, 'default', 'admin', 'admin', '2024-10-30 06:56:09.045+00', '2024-10-30 07:04:19.316+00', '2024-10-30 07:04:19.315+00', '[]');
INSERT INTO public.types VALUES ('5', 'Metall', 0, '{"ru": "Номенклатура"}', 'folder-multiple', 'brown', false, 0, '[]', 5, 'default', 'admin', 'admin', '2024-10-23 10:08:43.759+00', '2024-10-30 07:09:36.997+00', NULL, '[]');
INSERT INTO public.types VALUES ('5.6.10', 'Bulk', 0, '{"ru": "Сыпучие материалы"}', 'folder', '', false, 0, '[]', 10, 'default', 'admin', 'admin', '2024-10-30 07:10:57.971+00', '2024-10-30 07:10:57.971+00', NULL, '[]');


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.users VALUES ('admin', 'Administrator', '$2b$10$WtKEm5gspljprGVuHAj4QeO.QwzWiDmdEFN9VzXRbxyrSpQi9m4Fq', NULL, NULL, '[1]', 1, 'default', 'system', 'system', '2020-09-16 11:24:07.636836+00', '2020-09-16 11:24:07.636836+00', NULL, '[]');


--
-- Name: chunk_constraint_name; Type: SEQUENCE SET; Schema: _timescaledb_catalog; Owner: postgres
--

SELECT pg_catalog.setval('_timescaledb_catalog.chunk_constraint_name', 1, false);


--
-- Name: chunk_id_seq; Type: SEQUENCE SET; Schema: _timescaledb_catalog; Owner: postgres
--

SELECT pg_catalog.setval('_timescaledb_catalog.chunk_id_seq', 1, false);


--
-- Name: continuous_agg_migrate_plan_step_step_id_seq; Type: SEQUENCE SET; Schema: _timescaledb_catalog; Owner: postgres
--

DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM pg_class c
        JOIN pg_namespace n ON n.oid = c.relnamespace
        WHERE c.relname = 'continuous_agg_migrate_plan_step_step_id_seq'
        AND n.nspname = '_timescaledb_catalog'
    ) THEN
        PERFORM pg_catalog.setval('_timescaledb_catalog.continuous_agg_migrate_plan_step_step_id_seq', 1, false);
    END IF;
END $$;


--
-- Name: dimension_id_seq; Type: SEQUENCE SET; Schema: _timescaledb_catalog; Owner: postgres
--

SELECT pg_catalog.setval('_timescaledb_catalog.dimension_id_seq', 1, false);


--
-- Name: dimension_slice_id_seq; Type: SEQUENCE SET; Schema: _timescaledb_catalog; Owner: postgres
--

SELECT pg_catalog.setval('_timescaledb_catalog.dimension_slice_id_seq', 1, false);


--
-- Name: hypertable_id_seq; Type: SEQUENCE SET; Schema: _timescaledb_catalog; Owner: postgres
--

SELECT pg_catalog.setval('_timescaledb_catalog.hypertable_id_seq', 1, false);


--
-- Name: bgw_job_id_seq; Type: SEQUENCE SET; Schema: _timescaledb_config; Owner: postgres
--

SELECT pg_catalog.setval('_timescaledb_config.bgw_job_id_seq', 1000, false);


--
-- Name: actions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.actions_id_seq', 1, false);


--
-- Name: attrGroups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."attrGroups_id_seq"', 2, true);


--
-- Name: attributes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.attributes_id_seq', 4, true);


--
-- Name: channels_exec_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.channels_exec_id_seq', 1, false);


--
-- Name: channels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.channels_id_seq', 1, false);


--
-- Name: collectionItems_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."collectionItems_id_seq"', 1, false);


--
-- Name: collections_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.collections_id_seq', 1, false);


--
-- Name: dashboards_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dashboards_id_seq', 1, false);


--
-- Name: identifier_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.identifier_seq', 50, true);


--
-- Name: importConfigs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."importConfigs_id_seq"', 1, false);


--
-- Name: itemRelations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."itemRelations_id_seq"', 1, false);


--
-- Name: items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.items_id_seq', 444, true);


--
-- Name: languages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.languages_id_seq', 1, true);


--
-- Name: lovs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lovs_id_seq', 1, false);


--
-- Name: processes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.processes_id_seq', 1, false);


--
-- Name: relations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.relations_id_seq', 1, false);


--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_seq', 2, true);


--
-- Name: savedColumns_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."savedColumns_id_seq"', 1, true);


--
-- Name: savedSearch_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."savedSearch_id_seq"', 1, false);


--
-- Name: types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.types_id_seq', 10, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 1, true);


--
-- Name: actions actions_identifier_tenantId_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actions
    ADD CONSTRAINT "actions_identifier_tenantId_key" UNIQUE (identifier, "tenantId");


--
-- Name: actions actions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actions
    ADD CONSTRAINT actions_pkey PRIMARY KEY (id);


--
-- Name: attrGroups attrGroups_identifier_tenantId_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."attrGroups"
    ADD CONSTRAINT "attrGroups_identifier_tenantId_key" UNIQUE (identifier, "tenantId");


--
-- Name: attrGroups attrGroups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."attrGroups"
    ADD CONSTRAINT "attrGroups_pkey" PRIMARY KEY (id);


--
-- Name: attributes attributes_identifier_tenantId_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attributes
    ADD CONSTRAINT "attributes_identifier_tenantId_key" UNIQUE (identifier, "tenantId");


--
-- Name: attributes attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attributes
    ADD CONSTRAINT attributes_pkey PRIMARY KEY (id);


--
-- Name: channels_exec channels_exec_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.channels_exec
    ADD CONSTRAINT channels_exec_pkey PRIMARY KEY (id);


--
-- Name: channels channels_identifier_tenantId_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.channels
    ADD CONSTRAINT "channels_identifier_tenantId_key" UNIQUE (identifier, "tenantId");


--
-- Name: channels channels_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.channels
    ADD CONSTRAINT channels_pkey PRIMARY KEY (id);


--
-- Name: collectionItems collectionItems_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."collectionItems"
    ADD CONSTRAINT "collectionItems_pkey" PRIMARY KEY (id);


--
-- Name: collections collections_identifier_tenantId_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collections
    ADD CONSTRAINT "collections_identifier_tenantId_key" UNIQUE (identifier, "tenantId");


--
-- Name: collections collections_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collections
    ADD CONSTRAINT collections_pkey PRIMARY KEY (id);


--
-- Name: dashboards dashboards_identifier_tenantId_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dashboards
    ADD CONSTRAINT "dashboards_identifier_tenantId_key" UNIQUE (identifier, "tenantId");


--
-- Name: dashboards dashboards_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dashboards
    ADD CONSTRAINT dashboards_pkey PRIMARY KEY (id);


--
-- Name: group_attribute group_attribute_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_attribute
    ADD CONSTRAINT group_attribute_pkey PRIMARY KEY ("AttrGroupId", "AttributeId");


--
-- Name: collections importConfigs_identifier_tenantId_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collections
    ADD CONSTRAINT "importConfigs_identifier_tenantId_key" UNIQUE (identifier, "tenantId");


--
-- Name: importConfigs importConfigs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."importConfigs"
    ADD CONSTRAINT "importConfigs_pkey" PRIMARY KEY (id);


--
-- Name: itemRelations itemRelations_identifier_tenantId_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."itemRelations"
    ADD CONSTRAINT "itemRelations_identifier_tenantId_key" UNIQUE (identifier, "tenantId");


--
-- Name: itemRelations itemRelations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."itemRelations"
    ADD CONSTRAINT "itemRelations_pkey" PRIMARY KEY (id);


--
-- Name: items items_identifier_tenantId_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT "items_identifier_tenantId_key" UNIQUE (identifier, "tenantId");


--
-- Name: items items_path_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT items_path_key UNIQUE (path);


--
-- Name: items items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT items_pkey PRIMARY KEY (id);


--
-- Name: languages languages_identifier_tenantId_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.languages
    ADD CONSTRAINT "languages_identifier_tenantId_key" UNIQUE (identifier, "tenantId");


--
-- Name: languages languages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.languages
    ADD CONSTRAINT languages_pkey PRIMARY KEY (id);


--
-- Name: lovs lovs_identifier_tenantId_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lovs
    ADD CONSTRAINT "lovs_identifier_tenantId_key" UNIQUE (identifier, "tenantId");


--
-- Name: lovs lovs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lovs
    ADD CONSTRAINT lovs_pkey PRIMARY KEY (id);


--
-- Name: processes processes_identifier_tenantId_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.processes
    ADD CONSTRAINT "processes_identifier_tenantId_key" UNIQUE (identifier, "tenantId");


--
-- Name: processes processes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.processes
    ADD CONSTRAINT processes_pkey PRIMARY KEY (id);


--
-- Name: relations relations_identifier_tenantId_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.relations
    ADD CONSTRAINT "relations_identifier_tenantId_key" UNIQUE (identifier, "tenantId");


--
-- Name: relations relations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.relations
    ADD CONSTRAINT relations_pkey PRIMARY KEY (id);


--
-- Name: roles roles_identifier_tenantId_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT "roles_identifier_tenantId_key" UNIQUE (identifier, "tenantId");


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: savedColumns savedColumns_identifier_tenantId_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."savedColumns"
    ADD CONSTRAINT "savedColumns_identifier_tenantId_key" UNIQUE (identifier, "tenantId");


--
-- Name: savedColumns savedColumns_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."savedColumns"
    ADD CONSTRAINT "savedColumns_pkey" PRIMARY KEY (id);


--
-- Name: savedSearch savedSearch_identifier_tenantId_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."savedSearch"
    ADD CONSTRAINT "savedSearch_identifier_tenantId_key" UNIQUE (identifier, "tenantId");


--
-- Name: savedSearch savedSearch_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."savedSearch"
    ADD CONSTRAINT "savedSearch_pkey" PRIMARY KEY (id);


--
-- Name: types types_identifier_tenantId_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.types
    ADD CONSTRAINT "types_identifier_tenantId_key" UNIQUE (identifier, "tenantId");


--
-- Name: types types_path_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.types
    ADD CONSTRAINT types_path_key UNIQUE (path);


--
-- Name: types types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.types
    ADD CONSTRAINT types_pkey PRIMARY KEY (id);


--
-- Name: users users_login_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_login_key UNIQUE (login);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: collectionItems collectionItems_itemId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."collectionItems"
    ADD CONSTRAINT "collectionItems_itemId_fkey" FOREIGN KEY ("itemId") REFERENCES public.items(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: group_attribute group_attribute_AttrGroupId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_attribute
    ADD CONSTRAINT "group_attribute_AttrGroupId_fkey" FOREIGN KEY ("AttrGroupId") REFERENCES public."attrGroups"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: group_attribute group_attribute_AttributeId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_attribute
    ADD CONSTRAINT "group_attribute_AttributeId_fkey" FOREIGN KEY ("AttributeId") REFERENCES public.attributes(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: DATABASE openpim; Type: ACL; Schema: -; Owner: postgres
--

GRANT CONNECT ON DATABASE openpim TO openpim;


--
-- Name: FUNCTION lquery_in(cstring); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.lquery_in(cstring) TO openpim;


--
-- Name: FUNCTION lquery_out(public.lquery); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.lquery_out(public.lquery) TO openpim;


--
-- Name: FUNCTION ltree_in(cstring); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltree_in(cstring) TO openpim;


--
-- Name: FUNCTION ltree_out(public.ltree); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltree_out(public.ltree) TO openpim;


--
-- Name: FUNCTION ltree_gist_in(cstring); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltree_gist_in(cstring) TO openpim;


--
-- Name: FUNCTION ltree_gist_out(public.ltree_gist); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltree_gist_out(public.ltree_gist) TO openpim;


--
-- Name: FUNCTION ltxtq_in(cstring); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltxtq_in(cstring) TO openpim;


--
-- Name: FUNCTION ltxtq_out(public.ltxtquery); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltxtq_out(public.ltxtquery) TO openpim;


--
-- Name: FUNCTION _lt_q_regex(public.ltree[], public.lquery[]); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public._lt_q_regex(public.ltree[], public.lquery[]) TO openpim;


--
-- Name: FUNCTION _lt_q_rregex(public.lquery[], public.ltree[]); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public._lt_q_rregex(public.lquery[], public.ltree[]) TO openpim;


--
-- Name: FUNCTION _ltq_extract_regex(public.ltree[], public.lquery); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public._ltq_extract_regex(public.ltree[], public.lquery) TO openpim;


--
-- Name: FUNCTION _ltq_regex(public.ltree[], public.lquery); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public._ltq_regex(public.ltree[], public.lquery) TO openpim;


--
-- Name: FUNCTION _ltq_rregex(public.lquery, public.ltree[]); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public._ltq_rregex(public.lquery, public.ltree[]) TO openpim;


--
-- Name: FUNCTION _ltree_compress(internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public._ltree_compress(internal) TO openpim;


--
-- Name: FUNCTION _ltree_consistent(internal, public.ltree[], smallint, oid, internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public._ltree_consistent(internal, public.ltree[], smallint, oid, internal) TO openpim;


--
-- Name: FUNCTION _ltree_extract_isparent(public.ltree[], public.ltree); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public._ltree_extract_isparent(public.ltree[], public.ltree) TO openpim;


--
-- Name: FUNCTION _ltree_extract_risparent(public.ltree[], public.ltree); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public._ltree_extract_risparent(public.ltree[], public.ltree) TO openpim;


--
-- Name: FUNCTION _ltree_isparent(public.ltree[], public.ltree); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public._ltree_isparent(public.ltree[], public.ltree) TO openpim;


--
-- Name: FUNCTION _ltree_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public._ltree_penalty(internal, internal, internal) TO openpim;


--
-- Name: FUNCTION _ltree_picksplit(internal, internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public._ltree_picksplit(internal, internal) TO openpim;


--
-- Name: FUNCTION _ltree_r_isparent(public.ltree, public.ltree[]); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public._ltree_r_isparent(public.ltree, public.ltree[]) TO openpim;


--
-- Name: FUNCTION _ltree_r_risparent(public.ltree, public.ltree[]); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public._ltree_r_risparent(public.ltree, public.ltree[]) TO openpim;


--
-- Name: FUNCTION _ltree_risparent(public.ltree[], public.ltree); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public._ltree_risparent(public.ltree[], public.ltree) TO openpim;


--
-- Name: FUNCTION _ltree_same(public.ltree_gist, public.ltree_gist, internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public._ltree_same(public.ltree_gist, public.ltree_gist, internal) TO openpim;


--
-- Name: FUNCTION _ltree_union(internal, internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public._ltree_union(internal, internal) TO openpim;


--
-- Name: FUNCTION _ltxtq_exec(public.ltree[], public.ltxtquery); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public._ltxtq_exec(public.ltree[], public.ltxtquery) TO openpim;


--
-- Name: FUNCTION _ltxtq_extract_exec(public.ltree[], public.ltxtquery); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public._ltxtq_extract_exec(public.ltree[], public.ltxtquery) TO openpim;


--
-- Name: FUNCTION _ltxtq_rexec(public.ltxtquery, public.ltree[]); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public._ltxtq_rexec(public.ltxtquery, public.ltree[]) TO openpim;


--
-- Name: FUNCTION add_compression_policy(hypertable regclass, compress_after "any", if_not_exists boolean, schedule_interval interval, initial_start timestamp with time zone, timezone text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.add_compression_policy(hypertable regclass, compress_after "any", if_not_exists boolean, schedule_interval interval, initial_start timestamp with time zone, timezone text) TO openpim;


--
-- Name: FUNCTION add_continuous_aggregate_policy(continuous_aggregate regclass, start_offset "any", end_offset "any", schedule_interval interval, if_not_exists boolean, initial_start timestamp with time zone, timezone text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.add_continuous_aggregate_policy(continuous_aggregate regclass, start_offset "any", end_offset "any", schedule_interval interval, if_not_exists boolean, initial_start timestamp with time zone, timezone text) TO openpim;


--
-- Name: FUNCTION add_data_node(node_name name, host text, database name, port integer, if_not_exists boolean, bootstrap boolean, password text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.add_data_node(node_name name, host text, database name, port integer, if_not_exists boolean, bootstrap boolean, password text) TO openpim;


--
-- Name: FUNCTION add_dimension(hypertable regclass, column_name name, number_partitions integer, chunk_time_interval anyelement, partitioning_func regproc, if_not_exists boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.add_dimension(hypertable regclass, column_name name, number_partitions integer, chunk_time_interval anyelement, partitioning_func regproc, if_not_exists boolean) TO openpim;


--
-- Name: FUNCTION add_job(proc regproc, schedule_interval interval, config jsonb, initial_start timestamp with time zone, scheduled boolean, check_config regproc, fixed_schedule boolean, timezone text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.add_job(proc regproc, schedule_interval interval, config jsonb, initial_start timestamp with time zone, scheduled boolean, check_config regproc, fixed_schedule boolean, timezone text) TO openpim;


--
-- Name: FUNCTION add_reorder_policy(hypertable regclass, index_name name, if_not_exists boolean, initial_start timestamp with time zone, timezone text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.add_reorder_policy(hypertable regclass, index_name name, if_not_exists boolean, initial_start timestamp with time zone, timezone text) TO openpim;


--
-- Name: FUNCTION add_retention_policy(relation regclass, drop_after "any", if_not_exists boolean, schedule_interval interval, initial_start timestamp with time zone, timezone text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.add_retention_policy(relation regclass, drop_after "any", if_not_exists boolean, schedule_interval interval, initial_start timestamp with time zone, timezone text) TO openpim;


--
-- Name: FUNCTION alter_data_node(node_name name, host text, database name, port integer, available boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.alter_data_node(node_name name, host text, database name, port integer, available boolean) TO openpim;


--
-- Name: FUNCTION alter_job(job_id integer, schedule_interval interval, max_runtime interval, max_retries integer, retry_period interval, scheduled boolean, config jsonb, next_start timestamp with time zone, if_exists boolean, check_config regproc); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.alter_job(job_id integer, schedule_interval interval, max_runtime interval, max_retries integer, retry_period interval, scheduled boolean, config jsonb, next_start timestamp with time zone, if_exists boolean, check_config regproc) TO openpim;


--
-- Name: FUNCTION approximate_row_count(relation regclass); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.approximate_row_count(relation regclass) TO openpim;


--
-- Name: FUNCTION attach_data_node(node_name name, hypertable regclass, if_not_attached boolean, repartition boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.attach_data_node(node_name name, hypertable regclass, if_not_attached boolean, repartition boolean) TO openpim;


--
-- Name: FUNCTION attach_tablespace(tablespace name, hypertable regclass, if_not_attached boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.attach_tablespace(tablespace name, hypertable regclass, if_not_attached boolean) TO openpim;


--
-- Name: FUNCTION chunk_compression_stats(hypertable regclass); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.chunk_compression_stats(hypertable regclass) TO openpim;


--
-- Name: FUNCTION chunks_detailed_size(hypertable regclass); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.chunks_detailed_size(hypertable regclass) TO openpim;


--
-- Name: FUNCTION compress_chunk(uncompressed_chunk regclass, if_not_compressed boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.compress_chunk(uncompressed_chunk regclass, if_not_compressed boolean) TO openpim;


--
-- Name: FUNCTION create_distributed_hypertable(relation regclass, time_column_name name, partitioning_column name, number_partitions integer, associated_schema_name name, associated_table_prefix name, chunk_time_interval anyelement, create_default_indexes boolean, if_not_exists boolean, partitioning_func regproc, migrate_data boolean, chunk_target_size text, chunk_sizing_func regproc, time_partitioning_func regproc, replication_factor integer, data_nodes name[]); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.create_distributed_hypertable(relation regclass, time_column_name name, partitioning_column name, number_partitions integer, associated_schema_name name, associated_table_prefix name, chunk_time_interval anyelement, create_default_indexes boolean, if_not_exists boolean, partitioning_func regproc, migrate_data boolean, chunk_target_size text, chunk_sizing_func regproc, time_partitioning_func regproc, replication_factor integer, data_nodes name[]) TO openpim;


--
-- Name: FUNCTION create_distributed_restore_point(name text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.create_distributed_restore_point(name text) TO openpim;


--
-- Name: FUNCTION create_hypertable(relation regclass, time_column_name name, partitioning_column name, number_partitions integer, associated_schema_name name, associated_table_prefix name, chunk_time_interval anyelement, create_default_indexes boolean, if_not_exists boolean, partitioning_func regproc, migrate_data boolean, chunk_target_size text, chunk_sizing_func regproc, time_partitioning_func regproc, replication_factor integer, data_nodes name[], distributed boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.create_hypertable(relation regclass, time_column_name name, partitioning_column name, number_partitions integer, associated_schema_name name, associated_table_prefix name, chunk_time_interval anyelement, create_default_indexes boolean, if_not_exists boolean, partitioning_func regproc, migrate_data boolean, chunk_target_size text, chunk_sizing_func regproc, time_partitioning_func regproc, replication_factor integer, data_nodes name[], distributed boolean) TO openpim;


--
-- Name: FUNCTION decompress_chunk(uncompressed_chunk regclass, if_compressed boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.decompress_chunk(uncompressed_chunk regclass, if_compressed boolean) TO openpim;


--
-- Name: FUNCTION delete_data_node(node_name name, if_exists boolean, force boolean, repartition boolean, drop_database boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.delete_data_node(node_name name, if_exists boolean, force boolean, repartition boolean, drop_database boolean) TO openpim;


--
-- Name: FUNCTION delete_job(job_id integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.delete_job(job_id integer) TO openpim;


--
-- Name: FUNCTION detach_data_node(node_name name, hypertable regclass, if_attached boolean, force boolean, repartition boolean, drop_remote_data boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.detach_data_node(node_name name, hypertable regclass, if_attached boolean, force boolean, repartition boolean, drop_remote_data boolean) TO openpim;


--
-- Name: FUNCTION detach_tablespace(tablespace name, hypertable regclass, if_attached boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.detach_tablespace(tablespace name, hypertable regclass, if_attached boolean) TO openpim;


--
-- Name: FUNCTION detach_tablespaces(hypertable regclass); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.detach_tablespaces(hypertable regclass) TO openpim;


--
-- Name: FUNCTION drop_chunks(relation regclass, older_than "any", newer_than "any", "verbose" boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.drop_chunks(relation regclass, older_than "any", newer_than "any", "verbose" boolean) TO openpim;


--
-- Name: FUNCTION get_telemetry_report(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_telemetry_report() TO openpim;


--
-- Name: FUNCTION hypertable_compression_stats(hypertable regclass); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.hypertable_compression_stats(hypertable regclass) TO openpim;


--
-- Name: FUNCTION hypertable_detailed_size(hypertable regclass); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.hypertable_detailed_size(hypertable regclass) TO openpim;


--
-- Name: FUNCTION hypertable_index_size(index_name regclass); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.hypertable_index_size(index_name regclass) TO openpim;


--
-- Name: FUNCTION hypertable_size(hypertable regclass); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.hypertable_size(hypertable regclass) TO openpim;


--
-- Name: FUNCTION index(public.ltree, public.ltree); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.index(public.ltree, public.ltree) TO openpim;


--
-- Name: FUNCTION index(public.ltree, public.ltree, integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.index(public.ltree, public.ltree, integer) TO openpim;


--
-- Name: FUNCTION interpolate(value real, prev record, next record); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.interpolate(value real, prev record, next record) TO openpim;


--
-- Name: FUNCTION interpolate(value double precision, prev record, next record); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.interpolate(value double precision, prev record, next record) TO openpim;


--
-- Name: FUNCTION interpolate(value smallint, prev record, next record); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.interpolate(value smallint, prev record, next record) TO openpim;


--
-- Name: FUNCTION interpolate(value integer, prev record, next record); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.interpolate(value integer, prev record, next record) TO openpim;


--
-- Name: FUNCTION interpolate(value bigint, prev record, next record); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.interpolate(value bigint, prev record, next record) TO openpim;


--
-- Name: FUNCTION lca(public.ltree[]); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.lca(public.ltree[]) TO openpim;


--
-- Name: FUNCTION lca(public.ltree, public.ltree); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.lca(public.ltree, public.ltree) TO openpim;


--
-- Name: FUNCTION lca(public.ltree, public.ltree, public.ltree); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.lca(public.ltree, public.ltree, public.ltree) TO openpim;


--
-- Name: FUNCTION lca(public.ltree, public.ltree, public.ltree, public.ltree); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.lca(public.ltree, public.ltree, public.ltree, public.ltree) TO openpim;


--
-- Name: FUNCTION lca(public.ltree, public.ltree, public.ltree, public.ltree, public.ltree); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.lca(public.ltree, public.ltree, public.ltree, public.ltree, public.ltree) TO openpim;


--
-- Name: FUNCTION lca(public.ltree, public.ltree, public.ltree, public.ltree, public.ltree, public.ltree); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.lca(public.ltree, public.ltree, public.ltree, public.ltree, public.ltree, public.ltree) TO openpim;


--
-- Name: FUNCTION lca(public.ltree, public.ltree, public.ltree, public.ltree, public.ltree, public.ltree, public.ltree); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.lca(public.ltree, public.ltree, public.ltree, public.ltree, public.ltree, public.ltree, public.ltree) TO openpim;


--
-- Name: FUNCTION lca(public.ltree, public.ltree, public.ltree, public.ltree, public.ltree, public.ltree, public.ltree, public.ltree); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.lca(public.ltree, public.ltree, public.ltree, public.ltree, public.ltree, public.ltree, public.ltree, public.ltree) TO openpim;


--
-- Name: FUNCTION locf(value anyelement, prev anyelement, treat_null_as_missing boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.locf(value anyelement, prev anyelement, treat_null_as_missing boolean) TO openpim;


--
-- Name: FUNCTION lt_q_regex(public.ltree, public.lquery[]); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.lt_q_regex(public.ltree, public.lquery[]) TO openpim;


--
-- Name: FUNCTION lt_q_rregex(public.lquery[], public.ltree); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.lt_q_rregex(public.lquery[], public.ltree) TO openpim;


--
-- Name: FUNCTION ltq_regex(public.ltree, public.lquery); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltq_regex(public.ltree, public.lquery) TO openpim;


--
-- Name: FUNCTION ltq_rregex(public.lquery, public.ltree); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltq_rregex(public.lquery, public.ltree) TO openpim;


--
-- Name: FUNCTION ltree2text(public.ltree); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltree2text(public.ltree) TO openpim;


--
-- Name: FUNCTION ltree_addltree(public.ltree, public.ltree); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltree_addltree(public.ltree, public.ltree) TO openpim;


--
-- Name: FUNCTION ltree_addtext(public.ltree, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltree_addtext(public.ltree, text) TO openpim;


--
-- Name: FUNCTION ltree_cmp(public.ltree, public.ltree); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltree_cmp(public.ltree, public.ltree) TO openpim;


--
-- Name: FUNCTION ltree_compress(internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltree_compress(internal) TO openpim;


--
-- Name: FUNCTION ltree_consistent(internal, public.ltree, smallint, oid, internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltree_consistent(internal, public.ltree, smallint, oid, internal) TO openpim;


--
-- Name: FUNCTION ltree_decompress(internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltree_decompress(internal) TO openpim;


--
-- Name: FUNCTION ltree_eq(public.ltree, public.ltree); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltree_eq(public.ltree, public.ltree) TO openpim;


--
-- Name: FUNCTION ltree_ge(public.ltree, public.ltree); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltree_ge(public.ltree, public.ltree) TO openpim;


--
-- Name: FUNCTION ltree_gt(public.ltree, public.ltree); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltree_gt(public.ltree, public.ltree) TO openpim;


--
-- Name: FUNCTION ltree_isparent(public.ltree, public.ltree); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltree_isparent(public.ltree, public.ltree) TO openpim;


--
-- Name: FUNCTION ltree_le(public.ltree, public.ltree); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltree_le(public.ltree, public.ltree) TO openpim;


--
-- Name: FUNCTION ltree_lt(public.ltree, public.ltree); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltree_lt(public.ltree, public.ltree) TO openpim;


--
-- Name: FUNCTION ltree_ne(public.ltree, public.ltree); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltree_ne(public.ltree, public.ltree) TO openpim;


--
-- Name: FUNCTION ltree_penalty(internal, internal, internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltree_penalty(internal, internal, internal) TO openpim;


--
-- Name: FUNCTION ltree_picksplit(internal, internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltree_picksplit(internal, internal) TO openpim;


--
-- Name: FUNCTION ltree_risparent(public.ltree, public.ltree); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltree_risparent(public.ltree, public.ltree) TO openpim;


--
-- Name: FUNCTION ltree_same(public.ltree_gist, public.ltree_gist, internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltree_same(public.ltree_gist, public.ltree_gist, internal) TO openpim;


--
-- Name: FUNCTION ltree_textadd(text, public.ltree); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltree_textadd(text, public.ltree) TO openpim;


--
-- Name: FUNCTION ltree_union(internal, internal); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltree_union(internal, internal) TO openpim;


--
-- Name: FUNCTION ltreeparentsel(internal, oid, internal, integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltreeparentsel(internal, oid, internal, integer) TO openpim;


--
-- Name: FUNCTION ltxtq_exec(public.ltree, public.ltxtquery); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltxtq_exec(public.ltree, public.ltxtquery) TO openpim;


--
-- Name: FUNCTION ltxtq_rexec(public.ltxtquery, public.ltree); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ltxtq_rexec(public.ltxtquery, public.ltree) TO openpim;


--
-- Name: FUNCTION move_chunk(chunk regclass, destination_tablespace name, index_destination_tablespace name, reorder_index regclass, "verbose" boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.move_chunk(chunk regclass, destination_tablespace name, index_destination_tablespace name, reorder_index regclass, "verbose" boolean) TO openpim;


--
-- Name: FUNCTION nlevel(public.ltree); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.nlevel(public.ltree) TO openpim;


--
-- Name: FUNCTION pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT queryid bigint, OUT query text, OUT calls bigint, OUT total_time double precision, OUT min_time double precision, OUT max_time double precision, OUT mean_time double precision, OUT stddev_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT blk_read_time double precision, OUT blk_write_time double precision); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT queryid bigint, OUT query text, OUT calls bigint, OUT total_time double precision, OUT min_time double precision, OUT max_time double precision, OUT mean_time double precision, OUT stddev_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT blk_read_time double precision, OUT blk_write_time double precision) TO openpim;


--
-- Name: FUNCTION pg_stat_statements_reset(userid oid, dbid oid, queryid bigint); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint) TO openpim;


--
-- Name: FUNCTION remove_compression_policy(hypertable regclass, if_exists boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.remove_compression_policy(hypertable regclass, if_exists boolean) TO openpim;


--
-- Name: FUNCTION remove_continuous_aggregate_policy(continuous_aggregate regclass, if_not_exists boolean, if_exists boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.remove_continuous_aggregate_policy(continuous_aggregate regclass, if_not_exists boolean, if_exists boolean) TO openpim;


--
-- Name: FUNCTION remove_reorder_policy(hypertable regclass, if_exists boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.remove_reorder_policy(hypertable regclass, if_exists boolean) TO openpim;


--
-- Name: FUNCTION remove_retention_policy(relation regclass, if_exists boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.remove_retention_policy(relation regclass, if_exists boolean) TO openpim;


--
-- Name: FUNCTION reorder_chunk(chunk regclass, index regclass, "verbose" boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.reorder_chunk(chunk regclass, index regclass, "verbose" boolean) TO openpim;


--
-- Name: FUNCTION set_adaptive_chunking(hypertable regclass, chunk_target_size text, INOUT chunk_sizing_func regproc, OUT chunk_target_size bigint); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.set_adaptive_chunking(hypertable regclass, chunk_target_size text, INOUT chunk_sizing_func regproc, OUT chunk_target_size bigint) TO openpim;


--
-- Name: FUNCTION set_chunk_time_interval(hypertable regclass, chunk_time_interval anyelement, dimension_name name); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.set_chunk_time_interval(hypertable regclass, chunk_time_interval anyelement, dimension_name name) TO openpim;


--
-- Name: FUNCTION set_integer_now_func(hypertable regclass, integer_now_func regproc, replace_if_exists boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.set_integer_now_func(hypertable regclass, integer_now_func regproc, replace_if_exists boolean) TO openpim;


--
-- Name: FUNCTION set_number_partitions(hypertable regclass, number_partitions integer, dimension_name name); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.set_number_partitions(hypertable regclass, number_partitions integer, dimension_name name) TO openpim;


--
-- Name: FUNCTION set_replication_factor(hypertable regclass, replication_factor integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.set_replication_factor(hypertable regclass, replication_factor integer) TO openpim;


--
-- Name: FUNCTION show_chunks(relation regclass, older_than "any", newer_than "any"); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.show_chunks(relation regclass, older_than "any", newer_than "any") TO openpim;


--
-- Name: FUNCTION show_tablespaces(hypertable regclass); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.show_tablespaces(hypertable regclass) TO openpim;


--
-- Name: FUNCTION subltree(public.ltree, integer, integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.subltree(public.ltree, integer, integer) TO openpim;


--
-- Name: FUNCTION subpath(public.ltree, integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.subpath(public.ltree, integer) TO openpim;


--
-- Name: FUNCTION subpath(public.ltree, integer, integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.subpath(public.ltree, integer, integer) TO openpim;


--
-- Name: FUNCTION text2ltree(text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.text2ltree(text) TO openpim;


--
-- Name: FUNCTION time_bucket(bucket_width smallint, ts smallint); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.time_bucket(bucket_width smallint, ts smallint) TO openpim;


--
-- Name: FUNCTION time_bucket(bucket_width integer, ts integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.time_bucket(bucket_width integer, ts integer) TO openpim;


--
-- Name: FUNCTION time_bucket(bucket_width bigint, ts bigint); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.time_bucket(bucket_width bigint, ts bigint) TO openpim;


--
-- Name: FUNCTION time_bucket(bucket_width interval, ts date); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.time_bucket(bucket_width interval, ts date) TO openpim;


--
-- Name: FUNCTION time_bucket(bucket_width interval, ts timestamp without time zone); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.time_bucket(bucket_width interval, ts timestamp without time zone) TO openpim;


--
-- Name: FUNCTION time_bucket(bucket_width interval, ts timestamp with time zone); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.time_bucket(bucket_width interval, ts timestamp with time zone) TO openpim;


--
-- Name: FUNCTION time_bucket(bucket_width smallint, ts smallint, "offset" smallint); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.time_bucket(bucket_width smallint, ts smallint, "offset" smallint) TO openpim;


--
-- Name: FUNCTION time_bucket(bucket_width integer, ts integer, "offset" integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.time_bucket(bucket_width integer, ts integer, "offset" integer) TO openpim;


--
-- Name: FUNCTION time_bucket(bucket_width bigint, ts bigint, "offset" bigint); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.time_bucket(bucket_width bigint, ts bigint, "offset" bigint) TO openpim;


--
-- Name: FUNCTION time_bucket(bucket_width interval, ts date, origin date); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.time_bucket(bucket_width interval, ts date, origin date) TO openpim;


--
-- Name: FUNCTION time_bucket(bucket_width interval, ts date, "offset" interval); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.time_bucket(bucket_width interval, ts date, "offset" interval) TO openpim;


--
-- Name: FUNCTION time_bucket(bucket_width interval, ts timestamp without time zone, "offset" interval); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.time_bucket(bucket_width interval, ts timestamp without time zone, "offset" interval) TO openpim;


--
-- Name: FUNCTION time_bucket(bucket_width interval, ts timestamp without time zone, origin timestamp without time zone); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.time_bucket(bucket_width interval, ts timestamp without time zone, origin timestamp without time zone) TO openpim;


--
-- Name: FUNCTION time_bucket(bucket_width interval, ts timestamp with time zone, "offset" interval); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.time_bucket(bucket_width interval, ts timestamp with time zone, "offset" interval) TO openpim;


--
-- Name: FUNCTION time_bucket(bucket_width interval, ts timestamp with time zone, origin timestamp with time zone); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.time_bucket(bucket_width interval, ts timestamp with time zone, origin timestamp with time zone) TO openpim;


--
-- Name: FUNCTION time_bucket(bucket_width interval, ts timestamp with time zone, timezone text, origin timestamp with time zone, "offset" interval); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.time_bucket(bucket_width interval, ts timestamp with time zone, timezone text, origin timestamp with time zone, "offset" interval) TO openpim;


--
-- Name: FUNCTION time_bucket_gapfill(bucket_width smallint, ts smallint, start smallint, finish smallint); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.time_bucket_gapfill(bucket_width smallint, ts smallint, start smallint, finish smallint) TO openpim;


--
-- Name: FUNCTION time_bucket_gapfill(bucket_width integer, ts integer, start integer, finish integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.time_bucket_gapfill(bucket_width integer, ts integer, start integer, finish integer) TO openpim;


--
-- Name: FUNCTION time_bucket_gapfill(bucket_width bigint, ts bigint, start bigint, finish bigint); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.time_bucket_gapfill(bucket_width bigint, ts bigint, start bigint, finish bigint) TO openpim;


--
-- Name: FUNCTION time_bucket_gapfill(bucket_width interval, ts date, start date, finish date); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.time_bucket_gapfill(bucket_width interval, ts date, start date, finish date) TO openpim;


--
-- Name: FUNCTION time_bucket_gapfill(bucket_width interval, ts timestamp without time zone, start timestamp without time zone, finish timestamp without time zone); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.time_bucket_gapfill(bucket_width interval, ts timestamp without time zone, start timestamp without time zone, finish timestamp without time zone) TO openpim;


--
-- Name: FUNCTION time_bucket_gapfill(bucket_width interval, ts timestamp with time zone, start timestamp with time zone, finish timestamp with time zone); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.time_bucket_gapfill(bucket_width interval, ts timestamp with time zone, start timestamp with time zone, finish timestamp with time zone) TO openpim;


--
-- Name: FUNCTION time_bucket_gapfill(bucket_width interval, ts timestamp with time zone, timezone text, start timestamp with time zone, finish timestamp with time zone); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.time_bucket_gapfill(bucket_width interval, ts timestamp with time zone, timezone text, start timestamp with time zone, finish timestamp with time zone) TO openpim;


--
-- Name: FUNCTION timescaledb_fdw_handler(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.timescaledb_fdw_handler() TO openpim;


--
-- Name: FUNCTION timescaledb_fdw_validator(text[], oid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.timescaledb_fdw_validator(text[], oid) TO openpim;


--
-- Name: FUNCTION timescaledb_post_restore(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.timescaledb_post_restore() TO openpim;


--
-- Name: FUNCTION timescaledb_pre_restore(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.timescaledb_pre_restore() TO openpim;


--
-- Name: FUNCTION first(anyelement, "any"); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.first(anyelement, "any") TO openpim;


--
-- Name: FUNCTION histogram(double precision, double precision, double precision, integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.histogram(double precision, double precision, double precision, integer) TO openpim;


--
-- Name: FUNCTION last(anyelement, "any"); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.last(anyelement, "any") TO openpim;


--
-- Name: TABLE actions; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.actions TO openpim;


--
-- Name: SEQUENCE actions_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.actions_id_seq TO openpim;


--
-- Name: TABLE "attrGroups"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public."attrGroups" TO openpim;


--
-- Name: SEQUENCE "attrGroups_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public."attrGroups_id_seq" TO openpim;


--
-- Name: TABLE attributes; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.attributes TO openpim;


--
-- Name: SEQUENCE attributes_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.attributes_id_seq TO openpim;


--
-- Name: SEQUENCE channels_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.channels_id_seq TO openpim;


--
-- Name: TABLE channels; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.channels TO openpim;


--
-- Name: SEQUENCE channels_exec_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.channels_exec_id_seq TO openpim;


--
-- Name: TABLE channels_exec; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.channels_exec TO openpim;


--
-- Name: SEQUENCE "collectionItems_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public."collectionItems_id_seq" TO openpim;


--
-- Name: TABLE "collectionItems"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public."collectionItems" TO openpim;


--
-- Name: SEQUENCE collections_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.collections_id_seq TO openpim;


--
-- Name: TABLE collections; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.collections TO openpim;


--
-- Name: TABLE dashboards; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.dashboards TO openpim;


--
-- Name: SEQUENCE dashboards_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.dashboards_id_seq TO openpim;


--
-- Name: TABLE group_attribute; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.group_attribute TO openpim;


--
-- Name: SEQUENCE identifier_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.identifier_seq TO openpim;


--
-- Name: SEQUENCE "importConfigs_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public."importConfigs_id_seq" TO openpim;


--
-- Name: TABLE "importConfigs"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public."importConfigs" TO openpim;


--
-- Name: TABLE "itemRelations"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public."itemRelations" TO openpim;


--
-- Name: SEQUENCE "itemRelations_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public."itemRelations_id_seq" TO openpim;


--
-- Name: TABLE items; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.items TO openpim;


--
-- Name: SEQUENCE items_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.items_id_seq TO openpim;


--
-- Name: TABLE languages; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.languages TO openpim;


--
-- Name: SEQUENCE languages_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.languages_id_seq TO openpim;


--
-- Name: TABLE lovs; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.lovs TO openpim;


--
-- Name: SEQUENCE lovs_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.lovs_id_seq TO openpim;


--
-- Name: TABLE pg_stat_statements; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.pg_stat_statements TO openpim;


--
-- Name: SEQUENCE processes_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.processes_id_seq TO openpim;


--
-- Name: TABLE processes; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.processes TO openpim;


--
-- Name: TABLE relations; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.relations TO openpim;


--
-- Name: SEQUENCE relations_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.relations_id_seq TO openpim;


--
-- Name: TABLE roles; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.roles TO openpim;


--
-- Name: SEQUENCE roles_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.roles_id_seq TO openpim;


--
-- Name: TABLE "savedColumns"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public."savedColumns" TO openpim;


--
-- Name: SEQUENCE "savedColumns_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public."savedColumns_id_seq" TO openpim;


--
-- Name: TABLE "savedSearch"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public."savedSearch" TO openpim;


--
-- Name: SEQUENCE "savedSearch_id_seq"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public."savedSearch_id_seq" TO openpim;


--
-- Name: TABLE types; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.types TO openpim;


--
-- Name: SEQUENCE types_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.types_id_seq TO openpim;


--
-- Name: TABLE users; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.users TO openpim;


--
-- Name: SEQUENCE users_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.users_id_seq TO openpim;


--
-- PostgreSQL database dump complete
--

--
-- Database "postgres" dump
--

\connect postgres

--
-- PostgreSQL database dump
--

-- Dumped from database version 12.16
-- Dumped by pg_dump version 14.7 (Debian 14.7-1.pgdg110+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: timescaledb; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS timescaledb WITH SCHEMA public;


--
-- Name: EXTENSION timescaledb; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION timescaledb IS 'Enables scalable inserts and complex queries for time-series data (Community Edition)';


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA public;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track execution statistics of all SQL statements executed';


--
-- Data for Name: cache_inval_bgw_job; Type: TABLE DATA; Schema: _timescaledb_cache; Owner: postgres
--



--
-- Data for Name: cache_inval_extension; Type: TABLE DATA; Schema: _timescaledb_cache; Owner: postgres
--



--
-- Data for Name: cache_inval_hypertable; Type: TABLE DATA; Schema: _timescaledb_cache; Owner: postgres
--



--
-- Data for Name: hypertable; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: chunk; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: dimension; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: dimension_slice; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: chunk_constraint; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: chunk_data_node; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: chunk_index; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: compression_chunk_size; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: continuous_agg; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: continuous_agg_migrate_plan; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: continuous_agg_migrate_plan_step; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: continuous_aggs_bucket_function; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: continuous_aggs_hypertable_invalidation_log; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: continuous_aggs_invalidation_threshold; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: continuous_aggs_materialization_invalidation_log; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: continuous_aggs_watermark; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: dimension_partition; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: hypertable_compression; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: hypertable_data_node; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: metadata; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--

INSERT INTO _timescaledb_catalog.metadata VALUES ('exported_uuid', 'dfe1ad0d-0790-41d0-851f-50a7edab569d', true);


--
-- Data for Name: remote_txn; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: tablespace; Type: TABLE DATA; Schema: _timescaledb_catalog; Owner: postgres
--



--
-- Data for Name: bgw_job; Type: TABLE DATA; Schema: _timescaledb_config; Owner: postgres
--



--
-- Data for Name: job_errors; Type: TABLE DATA; Schema: _timescaledb_internal; Owner: postgres
--



--
-- Name: chunk_constraint_name; Type: SEQUENCE SET; Schema: _timescaledb_catalog; Owner: postgres
--

SELECT pg_catalog.setval('_timescaledb_catalog.chunk_constraint_name', 1, false);


--
-- Name: chunk_id_seq; Type: SEQUENCE SET; Schema: _timescaledb_catalog; Owner: postgres
--

SELECT pg_catalog.setval('_timescaledb_catalog.chunk_id_seq', 1, false);


--
-- Name: continuous_agg_migrate_plan_step_step_id_seq; Type: SEQUENCE SET; Schema: _timescaledb_catalog; Owner: postgres
--

DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM pg_class c
        JOIN pg_namespace n ON n.oid = c.relnamespace
        WHERE c.relname = 'continuous_agg_migrate_plan_step_step_id_seq'
        AND n.nspname = '_timescaledb_catalog'
    ) THEN
        PERFORM pg_catalog.setval('_timescaledb_catalog.continuous_agg_migrate_plan_step_step_id_seq', 1, false);
    END IF;
END $$;


--
-- Name: dimension_id_seq; Type: SEQUENCE SET; Schema: _timescaledb_catalog; Owner: postgres
--

SELECT pg_catalog.setval('_timescaledb_catalog.dimension_id_seq', 1, false);


--
-- Name: dimension_slice_id_seq; Type: SEQUENCE SET; Schema: _timescaledb_catalog; Owner: postgres
--

SELECT pg_catalog.setval('_timescaledb_catalog.dimension_slice_id_seq', 1, false);


--
-- Name: hypertable_id_seq; Type: SEQUENCE SET; Schema: _timescaledb_catalog; Owner: postgres
--

SELECT pg_catalog.setval('_timescaledb_catalog.hypertable_id_seq', 1, false);


--
-- Name: bgw_job_id_seq; Type: SEQUENCE SET; Schema: _timescaledb_config; Owner: postgres
--

SELECT pg_catalog.setval('_timescaledb_config.bgw_job_id_seq', 1000, false);


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database cluster dump complete
--
