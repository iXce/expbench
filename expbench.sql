--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: experiments; Type: TABLE; Schema: public; Owner: gseguin; Tablespace: 
--

CREATE TABLE experiments (
    id integer NOT NULL,
    apt_taskid integer,
    created timestamp without time zone DEFAULT now(),
    updated timestamp without time zone DEFAULT now(),
    name text,
    status text DEFAULT 'Created'::text,
    njobs integer,
    nruns integer,
    suffix text,
    params text DEFAULT ''::text,
    report text DEFAULT ''::text,
    reportdata bytea DEFAULT ''::bytea,
    explink text DEFAULT ''::text,
    gitcommit text DEFAULT ''::text
);


ALTER TABLE public.experiments OWNER TO gseguin;

--
-- Name: experiments_id_seq; Type: SEQUENCE; Schema: public; Owner: gseguin
--

CREATE SEQUENCE experiments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.experiments_id_seq OWNER TO gseguin;

--
-- Name: experiments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gseguin
--

ALTER SEQUENCE experiments_id_seq OWNED BY experiments.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: gseguin
--

ALTER TABLE ONLY experiments ALTER COLUMN id SET DEFAULT nextval('experiments_id_seq'::regclass);


--
-- Name: experiments_pkey; Type: CONSTRAINT; Schema: public; Owner: gseguin; Tablespace: 
--

ALTER TABLE ONLY experiments
    ADD CONSTRAINT experiments_pkey PRIMARY KEY (id);


--
-- Name: update_experiments_modtime; Type: TRIGGER; Schema: public; Owner: gseguin
--

CREATE TRIGGER update_experiments_modtime
    BEFORE UPDATE ON experiments
    FOR EACH ROW
    EXECUTE PROCEDURE update_updated_column();


--
-- PostgreSQL database dump complete
--

