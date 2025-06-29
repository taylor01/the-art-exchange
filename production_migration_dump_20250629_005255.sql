--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1
-- Dumped by pg_dump version 16.1

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
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: active_storage_attachments; Type: TABLE; Schema: public; Owner: roberttaylor
--

CREATE TABLE public.active_storage_attachments (
    id bigint NOT NULL,
    name character varying NOT NULL,
    record_type character varying NOT NULL,
    record_id bigint NOT NULL,
    blob_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.active_storage_attachments OWNER TO roberttaylor;

--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: roberttaylor
--

CREATE SEQUENCE public.active_storage_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.active_storage_attachments_id_seq OWNER TO roberttaylor;

--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: roberttaylor
--

ALTER SEQUENCE public.active_storage_attachments_id_seq OWNED BY public.active_storage_attachments.id;


--
-- Name: active_storage_blobs; Type: TABLE; Schema: public; Owner: roberttaylor
--

CREATE TABLE public.active_storage_blobs (
    id bigint NOT NULL,
    key character varying NOT NULL,
    filename character varying NOT NULL,
    content_type character varying,
    metadata text,
    service_name character varying NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying,
    created_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.active_storage_blobs OWNER TO roberttaylor;

--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE; Schema: public; Owner: roberttaylor
--

CREATE SEQUENCE public.active_storage_blobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.active_storage_blobs_id_seq OWNER TO roberttaylor;

--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: roberttaylor
--

ALTER SEQUENCE public.active_storage_blobs_id_seq OWNED BY public.active_storage_blobs.id;


--
-- Name: active_storage_variant_records; Type: TABLE; Schema: public; Owner: roberttaylor
--

CREATE TABLE public.active_storage_variant_records (
    id bigint NOT NULL,
    blob_id bigint NOT NULL,
    variation_digest character varying NOT NULL
);


ALTER TABLE public.active_storage_variant_records OWNER TO roberttaylor;

--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE; Schema: public; Owner: roberttaylor
--

CREATE SEQUENCE public.active_storage_variant_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.active_storage_variant_records_id_seq OWNER TO roberttaylor;

--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: roberttaylor
--

ALTER SEQUENCE public.active_storage_variant_records_id_seq OWNED BY public.active_storage_variant_records.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: roberttaylor
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.ar_internal_metadata OWNER TO roberttaylor;

--
-- Name: artists; Type: TABLE; Schema: public; Owner: roberttaylor
--

CREATE TABLE public.artists (
    id bigint NOT NULL,
    name character varying NOT NULL,
    website character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.artists OWNER TO roberttaylor;

--
-- Name: artists_id_seq; Type: SEQUENCE; Schema: public; Owner: roberttaylor
--

CREATE SEQUENCE public.artists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.artists_id_seq OWNER TO roberttaylor;

--
-- Name: artists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: roberttaylor
--

ALTER SEQUENCE public.artists_id_seq OWNED BY public.artists.id;


--
-- Name: artists_posters; Type: TABLE; Schema: public; Owner: roberttaylor
--

CREATE TABLE public.artists_posters (
    id bigint NOT NULL,
    artist_id bigint NOT NULL,
    poster_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.artists_posters OWNER TO roberttaylor;

--
-- Name: artists_posters_id_seq; Type: SEQUENCE; Schema: public; Owner: roberttaylor
--

CREATE SEQUENCE public.artists_posters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.artists_posters_id_seq OWNER TO roberttaylor;

--
-- Name: artists_posters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: roberttaylor
--

ALTER SEQUENCE public.artists_posters_id_seq OWNED BY public.artists_posters.id;


--
-- Name: bands; Type: TABLE; Schema: public; Owner: roberttaylor
--

CREATE TABLE public.bands (
    id bigint NOT NULL,
    name character varying NOT NULL,
    website character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.bands OWNER TO roberttaylor;

--
-- Name: bands_id_seq; Type: SEQUENCE; Schema: public; Owner: roberttaylor
--

CREATE SEQUENCE public.bands_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.bands_id_seq OWNER TO roberttaylor;

--
-- Name: bands_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: roberttaylor
--

ALTER SEQUENCE public.bands_id_seq OWNED BY public.bands.id;


--
-- Name: poster_slug_redirects; Type: TABLE; Schema: public; Owner: roberttaylor
--

CREATE TABLE public.poster_slug_redirects (
    id bigint NOT NULL,
    old_slug character varying,
    poster_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.poster_slug_redirects OWNER TO roberttaylor;

--
-- Name: poster_slug_redirects_id_seq; Type: SEQUENCE; Schema: public; Owner: roberttaylor
--

CREATE SEQUENCE public.poster_slug_redirects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.poster_slug_redirects_id_seq OWNER TO roberttaylor;

--
-- Name: poster_slug_redirects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: roberttaylor
--

ALTER SEQUENCE public.poster_slug_redirects_id_seq OWNED BY public.poster_slug_redirects.id;


--
-- Name: posters; Type: TABLE; Schema: public; Owner: roberttaylor
--

CREATE TABLE public.posters (
    id bigint NOT NULL,
    name character varying NOT NULL,
    description text,
    release_date date,
    original_price numeric(8,2),
    band_id bigint,
    venue_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    edition_size integer,
    visual_metadata json,
    metadata_version character varying,
    slug character varying
);


ALTER TABLE public.posters OWNER TO roberttaylor;

--
-- Name: posters_id_seq; Type: SEQUENCE; Schema: public; Owner: roberttaylor
--

CREATE SEQUENCE public.posters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.posters_id_seq OWNER TO roberttaylor;

--
-- Name: posters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: roberttaylor
--

ALTER SEQUENCE public.posters_id_seq OWNED BY public.posters.id;


--
-- Name: posters_series; Type: TABLE; Schema: public; Owner: roberttaylor
--

CREATE TABLE public.posters_series (
    poster_id bigint NOT NULL,
    series_id bigint NOT NULL
);


ALTER TABLE public.posters_series OWNER TO roberttaylor;

--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: roberttaylor
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO roberttaylor;

--
-- Name: search_analytics; Type: TABLE; Schema: public; Owner: roberttaylor
--

CREATE TABLE public.search_analytics (
    id bigint NOT NULL,
    query character varying,
    facet_filters json,
    results_count integer,
    user_id bigint,
    performed_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.search_analytics OWNER TO roberttaylor;

--
-- Name: search_analytics_id_seq; Type: SEQUENCE; Schema: public; Owner: roberttaylor
--

CREATE SEQUENCE public.search_analytics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.search_analytics_id_seq OWNER TO roberttaylor;

--
-- Name: search_analytics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: roberttaylor
--

ALTER SEQUENCE public.search_analytics_id_seq OWNED BY public.search_analytics.id;


--
-- Name: search_shares; Type: TABLE; Schema: public; Owner: roberttaylor
--

CREATE TABLE public.search_shares (
    id bigint NOT NULL,
    token character varying,
    search_params text,
    expires_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.search_shares OWNER TO roberttaylor;

--
-- Name: search_shares_id_seq; Type: SEQUENCE; Schema: public; Owner: roberttaylor
--

CREATE SEQUENCE public.search_shares_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.search_shares_id_seq OWNER TO roberttaylor;

--
-- Name: search_shares_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: roberttaylor
--

ALTER SEQUENCE public.search_shares_id_seq OWNED BY public.search_shares.id;


--
-- Name: series; Type: TABLE; Schema: public; Owner: roberttaylor
--

CREATE TABLE public.series (
    id bigint NOT NULL,
    name character varying NOT NULL,
    description text,
    year integer,
    total_count integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.series OWNER TO roberttaylor;

--
-- Name: series_id_seq; Type: SEQUENCE; Schema: public; Owner: roberttaylor
--

CREATE SEQUENCE public.series_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.series_id_seq OWNER TO roberttaylor;

--
-- Name: series_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: roberttaylor
--

ALTER SEQUENCE public.series_id_seq OWNED BY public.series.id;


--
-- Name: solid_cable_messages; Type: TABLE; Schema: public; Owner: roberttaylor
--

CREATE TABLE public.solid_cable_messages (
    id bigint NOT NULL,
    channel bytea NOT NULL,
    payload bytea NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    channel_hash bigint NOT NULL
);


ALTER TABLE public.solid_cable_messages OWNER TO roberttaylor;

--
-- Name: solid_cable_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: roberttaylor
--

CREATE SEQUENCE public.solid_cable_messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.solid_cable_messages_id_seq OWNER TO roberttaylor;

--
-- Name: solid_cable_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: roberttaylor
--

ALTER SEQUENCE public.solid_cable_messages_id_seq OWNED BY public.solid_cable_messages.id;


--
-- Name: solid_cache_entries; Type: TABLE; Schema: public; Owner: roberttaylor
--

CREATE TABLE public.solid_cache_entries (
    id bigint NOT NULL,
    key bytea NOT NULL,
    value bytea NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    key_hash bigint NOT NULL,
    byte_size integer NOT NULL
);


ALTER TABLE public.solid_cache_entries OWNER TO roberttaylor;

--
-- Name: solid_cache_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: roberttaylor
--

CREATE SEQUENCE public.solid_cache_entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.solid_cache_entries_id_seq OWNER TO roberttaylor;

--
-- Name: solid_cache_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: roberttaylor
--

ALTER SEQUENCE public.solid_cache_entries_id_seq OWNED BY public.solid_cache_entries.id;


--
-- Name: solid_queue_blocked_executions; Type: TABLE; Schema: public; Owner: roberttaylor
--

CREATE TABLE public.solid_queue_blocked_executions (
    id bigint NOT NULL,
    job_id bigint NOT NULL,
    queue_name character varying NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    concurrency_key character varying NOT NULL,
    expires_at timestamp(6) without time zone NOT NULL,
    created_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.solid_queue_blocked_executions OWNER TO roberttaylor;

--
-- Name: solid_queue_blocked_executions_id_seq; Type: SEQUENCE; Schema: public; Owner: roberttaylor
--

CREATE SEQUENCE public.solid_queue_blocked_executions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.solid_queue_blocked_executions_id_seq OWNER TO roberttaylor;

--
-- Name: solid_queue_blocked_executions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: roberttaylor
--

ALTER SEQUENCE public.solid_queue_blocked_executions_id_seq OWNED BY public.solid_queue_blocked_executions.id;


--
-- Name: solid_queue_claimed_executions; Type: TABLE; Schema: public; Owner: roberttaylor
--

CREATE TABLE public.solid_queue_claimed_executions (
    id bigint NOT NULL,
    job_id bigint NOT NULL,
    process_id bigint,
    created_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.solid_queue_claimed_executions OWNER TO roberttaylor;

--
-- Name: solid_queue_claimed_executions_id_seq; Type: SEQUENCE; Schema: public; Owner: roberttaylor
--

CREATE SEQUENCE public.solid_queue_claimed_executions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.solid_queue_claimed_executions_id_seq OWNER TO roberttaylor;

--
-- Name: solid_queue_claimed_executions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: roberttaylor
--

ALTER SEQUENCE public.solid_queue_claimed_executions_id_seq OWNED BY public.solid_queue_claimed_executions.id;


--
-- Name: solid_queue_failed_executions; Type: TABLE; Schema: public; Owner: roberttaylor
--

CREATE TABLE public.solid_queue_failed_executions (
    id bigint NOT NULL,
    job_id bigint NOT NULL,
    error text,
    created_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.solid_queue_failed_executions OWNER TO roberttaylor;

--
-- Name: solid_queue_failed_executions_id_seq; Type: SEQUENCE; Schema: public; Owner: roberttaylor
--

CREATE SEQUENCE public.solid_queue_failed_executions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.solid_queue_failed_executions_id_seq OWNER TO roberttaylor;

--
-- Name: solid_queue_failed_executions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: roberttaylor
--

ALTER SEQUENCE public.solid_queue_failed_executions_id_seq OWNED BY public.solid_queue_failed_executions.id;


--
-- Name: solid_queue_jobs; Type: TABLE; Schema: public; Owner: roberttaylor
--

CREATE TABLE public.solid_queue_jobs (
    id bigint NOT NULL,
    queue_name character varying NOT NULL,
    class_name character varying NOT NULL,
    arguments text,
    priority integer DEFAULT 0 NOT NULL,
    active_job_id character varying,
    scheduled_at timestamp(6) without time zone,
    finished_at timestamp(6) without time zone,
    concurrency_key character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.solid_queue_jobs OWNER TO roberttaylor;

--
-- Name: solid_queue_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: roberttaylor
--

CREATE SEQUENCE public.solid_queue_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.solid_queue_jobs_id_seq OWNER TO roberttaylor;

--
-- Name: solid_queue_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: roberttaylor
--

ALTER SEQUENCE public.solid_queue_jobs_id_seq OWNED BY public.solid_queue_jobs.id;


--
-- Name: solid_queue_pauses; Type: TABLE; Schema: public; Owner: roberttaylor
--

CREATE TABLE public.solid_queue_pauses (
    id bigint NOT NULL,
    queue_name character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.solid_queue_pauses OWNER TO roberttaylor;

--
-- Name: solid_queue_pauses_id_seq; Type: SEQUENCE; Schema: public; Owner: roberttaylor
--

CREATE SEQUENCE public.solid_queue_pauses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.solid_queue_pauses_id_seq OWNER TO roberttaylor;

--
-- Name: solid_queue_pauses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: roberttaylor
--

ALTER SEQUENCE public.solid_queue_pauses_id_seq OWNED BY public.solid_queue_pauses.id;


--
-- Name: solid_queue_processes; Type: TABLE; Schema: public; Owner: roberttaylor
--

CREATE TABLE public.solid_queue_processes (
    id bigint NOT NULL,
    kind character varying NOT NULL,
    last_heartbeat_at timestamp(6) without time zone NOT NULL,
    supervisor_id bigint,
    pid integer NOT NULL,
    hostname character varying,
    metadata text,
    created_at timestamp(6) without time zone NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE public.solid_queue_processes OWNER TO roberttaylor;

--
-- Name: solid_queue_processes_id_seq; Type: SEQUENCE; Schema: public; Owner: roberttaylor
--

CREATE SEQUENCE public.solid_queue_processes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.solid_queue_processes_id_seq OWNER TO roberttaylor;

--
-- Name: solid_queue_processes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: roberttaylor
--

ALTER SEQUENCE public.solid_queue_processes_id_seq OWNED BY public.solid_queue_processes.id;


--
-- Name: solid_queue_ready_executions; Type: TABLE; Schema: public; Owner: roberttaylor
--

CREATE TABLE public.solid_queue_ready_executions (
    id bigint NOT NULL,
    job_id bigint NOT NULL,
    queue_name character varying NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.solid_queue_ready_executions OWNER TO roberttaylor;

--
-- Name: solid_queue_ready_executions_id_seq; Type: SEQUENCE; Schema: public; Owner: roberttaylor
--

CREATE SEQUENCE public.solid_queue_ready_executions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.solid_queue_ready_executions_id_seq OWNER TO roberttaylor;

--
-- Name: solid_queue_ready_executions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: roberttaylor
--

ALTER SEQUENCE public.solid_queue_ready_executions_id_seq OWNED BY public.solid_queue_ready_executions.id;


--
-- Name: solid_queue_recurring_executions; Type: TABLE; Schema: public; Owner: roberttaylor
--

CREATE TABLE public.solid_queue_recurring_executions (
    id bigint NOT NULL,
    job_id bigint NOT NULL,
    task_key character varying NOT NULL,
    run_at timestamp(6) without time zone NOT NULL,
    created_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.solid_queue_recurring_executions OWNER TO roberttaylor;

--
-- Name: solid_queue_recurring_executions_id_seq; Type: SEQUENCE; Schema: public; Owner: roberttaylor
--

CREATE SEQUENCE public.solid_queue_recurring_executions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.solid_queue_recurring_executions_id_seq OWNER TO roberttaylor;

--
-- Name: solid_queue_recurring_executions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: roberttaylor
--

ALTER SEQUENCE public.solid_queue_recurring_executions_id_seq OWNED BY public.solid_queue_recurring_executions.id;


--
-- Name: solid_queue_recurring_tasks; Type: TABLE; Schema: public; Owner: roberttaylor
--

CREATE TABLE public.solid_queue_recurring_tasks (
    id bigint NOT NULL,
    key character varying NOT NULL,
    schedule character varying NOT NULL,
    command character varying(2048),
    class_name character varying,
    arguments text,
    queue_name character varying,
    priority integer DEFAULT 0,
    static boolean DEFAULT true NOT NULL,
    description text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.solid_queue_recurring_tasks OWNER TO roberttaylor;

--
-- Name: solid_queue_recurring_tasks_id_seq; Type: SEQUENCE; Schema: public; Owner: roberttaylor
--

CREATE SEQUENCE public.solid_queue_recurring_tasks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.solid_queue_recurring_tasks_id_seq OWNER TO roberttaylor;

--
-- Name: solid_queue_recurring_tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: roberttaylor
--

ALTER SEQUENCE public.solid_queue_recurring_tasks_id_seq OWNED BY public.solid_queue_recurring_tasks.id;


--
-- Name: solid_queue_scheduled_executions; Type: TABLE; Schema: public; Owner: roberttaylor
--

CREATE TABLE public.solid_queue_scheduled_executions (
    id bigint NOT NULL,
    job_id bigint NOT NULL,
    queue_name character varying NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    scheduled_at timestamp(6) without time zone NOT NULL,
    created_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.solid_queue_scheduled_executions OWNER TO roberttaylor;

--
-- Name: solid_queue_scheduled_executions_id_seq; Type: SEQUENCE; Schema: public; Owner: roberttaylor
--

CREATE SEQUENCE public.solid_queue_scheduled_executions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.solid_queue_scheduled_executions_id_seq OWNER TO roberttaylor;

--
-- Name: solid_queue_scheduled_executions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: roberttaylor
--

ALTER SEQUENCE public.solid_queue_scheduled_executions_id_seq OWNED BY public.solid_queue_scheduled_executions.id;


--
-- Name: solid_queue_semaphores; Type: TABLE; Schema: public; Owner: roberttaylor
--

CREATE TABLE public.solid_queue_semaphores (
    id bigint NOT NULL,
    key character varying NOT NULL,
    value integer DEFAULT 1 NOT NULL,
    expires_at timestamp(6) without time zone NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.solid_queue_semaphores OWNER TO roberttaylor;

--
-- Name: solid_queue_semaphores_id_seq; Type: SEQUENCE; Schema: public; Owner: roberttaylor
--

CREATE SEQUENCE public.solid_queue_semaphores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.solid_queue_semaphores_id_seq OWNER TO roberttaylor;

--
-- Name: solid_queue_semaphores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: roberttaylor
--

ALTER SEQUENCE public.solid_queue_semaphores_id_seq OWNED BY public.solid_queue_semaphores.id;


--
-- Name: user_posters; Type: TABLE; Schema: public; Owner: roberttaylor
--

CREATE TABLE public.user_posters (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    poster_id bigint NOT NULL,
    status character varying DEFAULT 'watching'::character varying NOT NULL,
    edition_number character varying,
    notes text,
    purchase_price numeric(8,2),
    purchase_date date,
    condition character varying,
    for_sale boolean DEFAULT false,
    asking_price numeric(8,2),
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    edition_type character varying
);


ALTER TABLE public.user_posters OWNER TO roberttaylor;

--
-- Name: user_posters_id_seq; Type: SEQUENCE; Schema: public; Owner: roberttaylor
--

CREATE SEQUENCE public.user_posters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_posters_id_seq OWNER TO roberttaylor;

--
-- Name: user_posters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: roberttaylor
--

ALTER SEQUENCE public.user_posters_id_seq OWNED BY public.user_posters.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: roberttaylor
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email character varying NOT NULL,
    first_name character varying,
    last_name character varying,
    confirmed_at timestamp(6) without time zone,
    confirmation_token character varying,
    confirmation_sent_at timestamp(6) without time zone,
    otp_secret_key character varying,
    otp_sent_at timestamp(6) without time zone,
    otp_used_at timestamp(6) without time zone,
    otp_attempts_count integer DEFAULT 0,
    otp_locked_until timestamp(6) without time zone,
    password_digest character varying,
    reset_password_token character varying,
    reset_password_sent_at timestamp(6) without time zone,
    failed_login_attempts integer DEFAULT 0,
    locked_until timestamp(6) without time zone,
    last_login_at timestamp(6) without time zone,
    provider character varying,
    uid character varying,
    provider_data json,
    admin boolean DEFAULT false,
    showcase_settings json DEFAULT '{}'::json,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    bio text,
    location character varying,
    website character varying,
    phone character varying,
    collector_since date,
    preferred_contact_method character varying DEFAULT 'email'::character varying,
    instagram_handle character varying,
    twitter_handle character varying,
    terms_accepted_at timestamp without time zone,
    terms_version character varying
);


ALTER TABLE public.users OWNER TO roberttaylor;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: roberttaylor
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO roberttaylor;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: roberttaylor
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: venues; Type: TABLE; Schema: public; Owner: roberttaylor
--

CREATE TABLE public.venues (
    id bigint NOT NULL,
    name character varying NOT NULL,
    address text,
    city character varying,
    administrative_area character varying,
    postal_code character varying,
    country character varying DEFAULT 'US'::character varying,
    latitude numeric(10,6),
    longitude numeric(10,6),
    website character varying,
    email character varying,
    telephone_number character varying,
    capacity integer,
    venue_type character varying DEFAULT 'other'::character varying,
    status character varying DEFAULT 'active'::character varying,
    description text,
    previous_names json DEFAULT '[]'::json,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.venues OWNER TO roberttaylor;

--
-- Name: venues_id_seq; Type: SEQUENCE; Schema: public; Owner: roberttaylor
--

CREATE SEQUENCE public.venues_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.venues_id_seq OWNER TO roberttaylor;

--
-- Name: venues_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: roberttaylor
--

ALTER SEQUENCE public.venues_id_seq OWNED BY public.venues.id;


--
-- Name: active_storage_attachments id; Type: DEFAULT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.active_storage_attachments ALTER COLUMN id SET DEFAULT nextval('public.active_storage_attachments_id_seq'::regclass);


--
-- Name: active_storage_blobs id; Type: DEFAULT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.active_storage_blobs ALTER COLUMN id SET DEFAULT nextval('public.active_storage_blobs_id_seq'::regclass);


--
-- Name: active_storage_variant_records id; Type: DEFAULT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.active_storage_variant_records ALTER COLUMN id SET DEFAULT nextval('public.active_storage_variant_records_id_seq'::regclass);


--
-- Name: artists id; Type: DEFAULT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.artists ALTER COLUMN id SET DEFAULT nextval('public.artists_id_seq'::regclass);


--
-- Name: artists_posters id; Type: DEFAULT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.artists_posters ALTER COLUMN id SET DEFAULT nextval('public.artists_posters_id_seq'::regclass);


--
-- Name: bands id; Type: DEFAULT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.bands ALTER COLUMN id SET DEFAULT nextval('public.bands_id_seq'::regclass);


--
-- Name: poster_slug_redirects id; Type: DEFAULT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.poster_slug_redirects ALTER COLUMN id SET DEFAULT nextval('public.poster_slug_redirects_id_seq'::regclass);


--
-- Name: posters id; Type: DEFAULT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.posters ALTER COLUMN id SET DEFAULT nextval('public.posters_id_seq'::regclass);


--
-- Name: search_analytics id; Type: DEFAULT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.search_analytics ALTER COLUMN id SET DEFAULT nextval('public.search_analytics_id_seq'::regclass);


--
-- Name: search_shares id; Type: DEFAULT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.search_shares ALTER COLUMN id SET DEFAULT nextval('public.search_shares_id_seq'::regclass);


--
-- Name: series id; Type: DEFAULT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.series ALTER COLUMN id SET DEFAULT nextval('public.series_id_seq'::regclass);


--
-- Name: solid_cable_messages id; Type: DEFAULT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.solid_cable_messages ALTER COLUMN id SET DEFAULT nextval('public.solid_cable_messages_id_seq'::regclass);


--
-- Name: solid_cache_entries id; Type: DEFAULT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.solid_cache_entries ALTER COLUMN id SET DEFAULT nextval('public.solid_cache_entries_id_seq'::regclass);


--
-- Name: solid_queue_blocked_executions id; Type: DEFAULT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.solid_queue_blocked_executions ALTER COLUMN id SET DEFAULT nextval('public.solid_queue_blocked_executions_id_seq'::regclass);


--
-- Name: solid_queue_claimed_executions id; Type: DEFAULT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.solid_queue_claimed_executions ALTER COLUMN id SET DEFAULT nextval('public.solid_queue_claimed_executions_id_seq'::regclass);


--
-- Name: solid_queue_failed_executions id; Type: DEFAULT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.solid_queue_failed_executions ALTER COLUMN id SET DEFAULT nextval('public.solid_queue_failed_executions_id_seq'::regclass);


--
-- Name: solid_queue_jobs id; Type: DEFAULT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.solid_queue_jobs ALTER COLUMN id SET DEFAULT nextval('public.solid_queue_jobs_id_seq'::regclass);


--
-- Name: solid_queue_pauses id; Type: DEFAULT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.solid_queue_pauses ALTER COLUMN id SET DEFAULT nextval('public.solid_queue_pauses_id_seq'::regclass);


--
-- Name: solid_queue_processes id; Type: DEFAULT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.solid_queue_processes ALTER COLUMN id SET DEFAULT nextval('public.solid_queue_processes_id_seq'::regclass);


--
-- Name: solid_queue_ready_executions id; Type: DEFAULT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.solid_queue_ready_executions ALTER COLUMN id SET DEFAULT nextval('public.solid_queue_ready_executions_id_seq'::regclass);


--
-- Name: solid_queue_recurring_executions id; Type: DEFAULT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.solid_queue_recurring_executions ALTER COLUMN id SET DEFAULT nextval('public.solid_queue_recurring_executions_id_seq'::regclass);


--
-- Name: solid_queue_recurring_tasks id; Type: DEFAULT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.solid_queue_recurring_tasks ALTER COLUMN id SET DEFAULT nextval('public.solid_queue_recurring_tasks_id_seq'::regclass);


--
-- Name: solid_queue_scheduled_executions id; Type: DEFAULT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.solid_queue_scheduled_executions ALTER COLUMN id SET DEFAULT nextval('public.solid_queue_scheduled_executions_id_seq'::regclass);


--
-- Name: solid_queue_semaphores id; Type: DEFAULT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.solid_queue_semaphores ALTER COLUMN id SET DEFAULT nextval('public.solid_queue_semaphores_id_seq'::regclass);


--
-- Name: user_posters id; Type: DEFAULT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.user_posters ALTER COLUMN id SET DEFAULT nextval('public.user_posters_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: venues id; Type: DEFAULT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.venues ALTER COLUMN id SET DEFAULT nextval('public.venues_id_seq'::regclass);


--
-- Data for Name: active_storage_attachments; Type: TABLE DATA; Schema: public; Owner: roberttaylor
--

COPY public.active_storage_attachments (id, name, record_type, record_id, blob_id, created_at) FROM stdin;
\.


--
-- Data for Name: active_storage_blobs; Type: TABLE DATA; Schema: public; Owner: roberttaylor
--

COPY public.active_storage_blobs (id, key, filename, content_type, metadata, service_name, byte_size, checksum, created_at) FROM stdin;
\.


--
-- Data for Name: active_storage_variant_records; Type: TABLE DATA; Schema: public; Owner: roberttaylor
--

COPY public.active_storage_variant_records (id, blob_id, variation_digest) FROM stdin;
\.


--
-- Data for Name: ar_internal_metadata; Type: TABLE DATA; Schema: public; Owner: roberttaylor
--

COPY public.ar_internal_metadata (key, value, created_at, updated_at) FROM stdin;
environment	development	2025-06-29 00:49:44.085425	2025-06-29 00:49:44.085425
schema_sha1	9134092b1b44faed9211890b9c9126ee15233724	2025-06-29 00:49:44.086649	2025-06-29 00:49:44.08665
\.


--
-- Data for Name: artists; Type: TABLE DATA; Schema: public; Owner: roberttaylor
--

COPY public.artists (id, name, website, created_at, updated_at) FROM stdin;
1	Methane Studios	http://www.methanestudios.com	2018-03-24 16:58:47.552048	2018-03-24 16:58:47.552048
2	LandLand	http://www.landland.net	2018-03-24 16:58:47.626819	2018-03-24 16:58:47.626819
3	James Flames	http://www.jamesflames.com	2018-03-24 16:58:47.562047	2018-03-24 16:58:47.562047
4	The Half and Half	http://www.thehalfandhalf.com	2018-03-24 16:58:47.609044	2018-03-24 16:58:47.609044
5	Chuck Sperry	http://www.chucksperry.net	2018-03-24 16:58:47.571284	2018-03-24 16:58:47.571284
6	Rich Kelly	http://www.rfkelly.com	2018-03-24 16:58:47.580974	2018-03-24 16:58:47.580974
7	Erica Williams	http://www.ericawilliamsillustration.com	2018-03-24 16:58:47.618011	2018-03-24 16:58:47.618011
8	Ken Taylor	http://www.kentaylor.com.au	2018-03-24 16:58:47.590565	2018-03-24 16:58:47.590565
9	DKNG	http://www.dkngstudios.com	2018-03-24 16:58:47.600176	2018-03-24 16:58:47.600176
10	The Bungaloo	http://www.thebungaloo.com	2018-03-24 16:58:47.636131	2018-03-24 16:58:47.636131
11	Graham Erwin	http://www.grahamerwin.com	2018-03-24 16:58:47.644988	2018-03-24 16:58:47.644988
12	Marq Spusta	http://www.marqspusta.com	2018-03-24 16:58:47.65565	2018-03-24 16:58:47.65565
13	Fur Turtle	http://www.furturtle.com	2018-03-24 16:58:47.664943	2018-03-24 16:58:47.664943
14	Crosshair	http://www.crosshairchicago.com	2018-03-24 16:58:47.673955	2018-03-24 16:58:47.673955
15	Doublenaut	http://www.doublenaut.com	2018-03-24 16:58:47.683895	2018-03-24 16:58:47.683895
16	FarmBarn Art Co.	\N	2018-03-24 16:58:47.693447	2018-03-24 16:58:47.693447
17	Status Serigraph	http://www.statusserigraph.com	2018-03-24 16:58:47.70357	2018-03-24 16:58:47.70357
18	Two Arms Inc.	http://www.twoarmsinc.com	2018-03-24 16:58:47.715033	2018-06-25 12:30:38.496338
19	James R. Eads	http://www.jamesreads.com	2018-03-24 16:58:47.725083	2018-03-24 16:58:47.725083
20	Nate Duval	http://www.nateduval.com	2018-03-24 16:58:47.734736	2018-03-24 16:58:47.734736
21	Neal Williams	http://www.epicproblems.com	2018-03-24 16:58:47.743894	2018-03-24 16:58:47.743894
22	Todd Slater	http://www.toddslater.net	2018-03-24 16:58:47.753947	2018-03-24 16:58:47.753947
23	Miles Tsang	http://www.milestsang.com	2018-03-24 16:58:47.763708	2018-03-24 16:58:47.763708
24	Matt Fleming	http://www.matthewjayfleming.com	2018-03-24 16:58:47.773821	2018-03-24 16:58:47.773821
25	Gary Houston	\N	2018-03-24 16:58:47.784043	2018-03-24 16:58:47.784043
26	Dave Matthews	http://www.davematthewsband.com	2018-03-24 16:58:47.793226	2018-03-24 16:58:47.793226
27	Nathaniel Deas	http://www.bourbonsunday.com	2018-03-24 16:58:47.80257	2018-03-24 16:58:47.80257
28	Brad Klausen	http://www.artillerydesign.com	2018-03-24 16:58:47.812408	2018-03-24 16:58:47.812408
29	Carpenter Collective	http://www.carpentercollective.com	2018-03-24 16:58:47.822164	2018-03-24 16:58:47.822164
30	John Vogl	http://www.thebungaloo.com	2018-03-24 16:58:47.831583	2018-03-24 16:58:47.831583
31	Brosmind Studio	http://www.brosmind.com	2018-03-24 16:58:47.841339	2018-03-24 16:58:47.841339
32	The Decoder Ring	http://www.thedecoderring.com	2018-03-24 16:58:47.851277	2018-03-24 16:58:47.851277
33	Lure Design Inc.	http://www.luredesigninc.com	2018-03-24 16:58:47.860454	2018-03-24 16:58:47.860454
34	Drowning Creek	http://www.drowningcreek.com	2018-03-24 16:58:47.869789	2018-03-24 16:58:47.869789
35	Patent Pending	http://www.thepatentpending.com	2018-03-24 16:58:47.880535	2018-03-24 16:58:47.880535
36	Ames Design	\N	2018-03-24 16:58:47.891313	2018-03-24 16:58:47.891313
37	Dean Welshman	\N	2018-03-24 16:58:47.903077	2018-03-24 16:58:47.903077
38	Jon Marro	http://www.jonmarro.com	2018-03-24 16:58:47.912686	2018-03-24 16:58:47.912686
39	EMEK	http://www.emekstudios.com	2018-03-24 16:58:47.922419	2018-03-24 16:58:47.922419
40	Marta Cerda Alimbau	http://www.martacerda.com	2018-03-24 16:58:47.933522	2018-03-24 16:58:47.933522
41	Steve Keene	http://www.stevekeene.com	2018-03-24 16:58:47.945071	2018-03-24 16:58:47.945071
42	Chris Peterson	http://www.petersonland.com	2018-03-24 16:58:47.955104	2018-03-24 16:58:47.955104
43	Blunt Graffix	http://mattdye.com	2018-03-24 16:58:47.965809	2018-03-24 16:58:47.965809
44	The Silent P	http://thesilentp.com	2018-03-24 16:58:47.975653	2018-03-24 16:58:47.975653
45	Kat Lamp	http://www.katlamp.com	2018-03-24 16:58:47.986244	2018-03-24 16:58:47.986244
46	Scott Avett	http://www.theavettbrothers.com	2018-03-24 16:58:47.997776	2018-03-24 16:58:47.997776
47	Kyler Martz	http://www.kylermartz.com	2018-03-24 16:58:48.008582	2018-03-24 16:58:48.008582
48	MID Goods	http://www.midgoods.com	2018-03-24 16:58:48.01922	2018-03-24 16:58:48.01922
49	Delicious Design League	http://www.deliciousdesignleague.com	2018-03-24 23:16:25.630776	2018-05-23 00:54:13.730591
50	Roamcouch	http://www.roamcouch.com	2018-03-25 15:05:08.116148	2018-03-25 15:05:08.116148
51	Dig My Chili	http://www.digmychili.com	2018-04-08 01:55:47.528725	2018-04-08 01:55:53.198838
52	Steely Works	http://www.steelyworks.com	2018-05-23 00:42:52.855817	2018-05-23 00:42:52.855817
53	Nicholas Moegly	http://www.nicholasmoegly.com	2018-06-08 00:58:56.398765	2018-06-08 00:58:56.398765
54	Ivan Minsloff	http://www.ivanminsloff.com	2018-06-18 01:26:38.98464	2018-06-18 01:26:48.647196
55	Half Hazard Press	http://halfhazardpress.com	2018-06-27 11:31:05.323205	2018-06-27 11:31:05.323205
56	Zoca Studio	http://zoca.ca	2018-07-21 18:13:06.943092	2018-07-21 18:13:06.943092
57	Draplin Design Company	http://www.draplin.com	2018-09-04 19:53:46.546005	2018-09-04 19:53:46.546005
58	27 Design Co.	http://www.27designco.com	2019-01-01 16:43:37.754799	2019-01-01 16:43:37.754799
59	Pavlov Visuals	http://www.pavlovvisuals.com	2019-03-18 14:50:15.569527	2019-03-18 14:50:15.569527
60	Suburban Avenger	http://www.suburbanavengerart.com	2021-05-11 14:10:30.691704	2021-05-11 14:10:40.096036
61	Jeff Soto	http://jeffsoto.com	2021-07-25 13:56:49.413719	2021-07-25 13:56:49.413719
62	Kevin Tong	http://tragicsunshine.com	2021-07-28 23:04:40.043206	2021-07-28 23:04:40.043206
63	Max Löffler	http://maxloeffler.com	2021-07-30 14:06:30.909086	2021-07-30 14:06:30.909086
64	Paul Kreizenbeck	http://paulkreizenbeck.com	2021-08-12 13:49:17.761982	2021-08-12 13:53:18.690648
65	Ben Kwok	http://bioworkz.com	2021-08-14 19:41:32.238176	2021-08-14 19:41:32.238176
66	Dan Mumford	http://www.dan-mumford.com	2021-08-20 14:33:31.548762	2021-08-20 14:33:31.548762
67	Bailey Race	http://raileybaceprints.com	2021-08-26 12:48:10.062302	2021-08-26 12:48:10.062302
68	Arno Kiss	http://www.arno-kiss.com	2021-08-30 12:18:29.270108	2021-08-30 12:18:29.270108
\.


--
-- Data for Name: artists_posters; Type: TABLE DATA; Schema: public; Owner: roberttaylor
--

COPY public.artists_posters (id, artist_id, poster_id, created_at, updated_at) FROM stdin;
1	34	1076	2025-06-29 00:51:30.759075	2025-06-29 00:51:30.759075
2	39	1077	2025-06-29 00:51:30.764834	2025-06-29 00:51:30.764834
3	37	1079	2025-06-29 00:51:30.769837	2025-06-29 00:51:30.769837
4	35	1080	2025-06-29 00:51:30.774872	2025-06-29 00:51:30.774872
5	39	1082	2025-06-29 00:51:30.779814	2025-06-29 00:51:30.779814
6	33	1083	2025-06-29 00:51:30.784897	2025-06-29 00:51:30.784897
7	35	1084	2025-06-29 00:51:30.79038	2025-06-29 00:51:30.79038
8	42	1085	2025-06-29 00:51:30.796097	2025-06-29 00:51:30.796097
9	35	1086	2025-06-29 00:51:30.804288	2025-06-29 00:51:30.804288
10	35	1087	2025-06-29 00:51:30.810846	2025-06-29 00:51:30.810846
11	1	1088	2025-06-29 00:51:30.817156	2025-06-29 00:51:30.817156
12	1	1089	2025-06-29 00:51:30.822909	2025-06-29 00:51:30.822909
13	36	1090	2025-06-29 00:51:30.828494	2025-06-29 00:51:30.828494
14	32	1091	2025-06-29 00:51:30.835658	2025-06-29 00:51:30.835658
15	32	1092	2025-06-29 00:51:30.842834	2025-06-29 00:51:30.842834
16	32	1093	2025-06-29 00:51:30.850243	2025-06-29 00:51:30.850243
17	32	1094	2025-06-29 00:51:30.857322	2025-06-29 00:51:30.857322
18	32	1095	2025-06-29 00:51:30.86513	2025-06-29 00:51:30.86513
19	1	1096	2025-06-29 00:51:30.872006	2025-06-29 00:51:30.872006
20	1	1097	2025-06-29 00:51:30.878284	2025-06-29 00:51:30.878284
21	1	1098	2025-06-29 00:51:30.884449	2025-06-29 00:51:30.884449
22	1	1099	2025-06-29 00:51:30.8898	2025-06-29 00:51:30.8898
23	1	1100	2025-06-29 00:51:30.89513	2025-06-29 00:51:30.89513
24	1	1101	2025-06-29 00:51:30.900099	2025-06-29 00:51:30.900099
25	32	1102	2025-06-29 00:51:30.904812	2025-06-29 00:51:30.904812
26	32	1103	2025-06-29 00:51:30.909694	2025-06-29 00:51:30.909694
27	1	1104	2025-06-29 00:51:30.915051	2025-06-29 00:51:30.915051
28	1	1105	2025-06-29 00:51:30.920053	2025-06-29 00:51:30.920053
29	1	1106	2025-06-29 00:51:30.92666	2025-06-29 00:51:30.92666
30	16	1107	2025-06-29 00:51:30.932973	2025-06-29 00:51:30.932973
31	1	1108	2025-06-29 00:51:30.938814	2025-06-29 00:51:30.938814
32	32	1110	2025-06-29 00:51:30.944168	2025-06-29 00:51:30.944168
33	1	1111	2025-06-29 00:51:30.949518	2025-06-29 00:51:30.949518
34	1	1112	2025-06-29 00:51:30.955144	2025-06-29 00:51:30.955144
35	32	1113	2025-06-29 00:51:30.960843	2025-06-29 00:51:30.960843
36	1	1114	2025-06-29 00:51:30.967019	2025-06-29 00:51:30.967019
37	1	1115	2025-06-29 00:51:30.972353	2025-06-29 00:51:30.972353
38	1	1116	2025-06-29 00:51:30.977138	2025-06-29 00:51:30.977138
39	38	1117	2025-06-29 00:51:30.982097	2025-06-29 00:51:30.982097
40	1	1118	2025-06-29 00:51:30.986798	2025-06-29 00:51:30.986798
41	1	1119	2025-06-29 00:51:30.991675	2025-06-29 00:51:30.991675
42	1	1120	2025-06-29 00:51:30.995534	2025-06-29 00:51:30.995534
43	1	1121	2025-06-29 00:51:31.000098	2025-06-29 00:51:31.000098
44	1	1122	2025-06-29 00:51:31.004875	2025-06-29 00:51:31.004875
45	1	1123	2025-06-29 00:51:31.009353	2025-06-29 00:51:31.009353
46	1	1124	2025-06-29 00:51:31.013709	2025-06-29 00:51:31.013709
47	15	1125	2025-06-29 00:51:31.018276	2025-06-29 00:51:31.018276
48	1	1126	2025-06-29 00:51:31.022699	2025-06-29 00:51:31.022699
49	1	1127	2025-06-29 00:51:31.027208	2025-06-29 00:51:31.027208
50	15	1128	2025-06-29 00:51:31.031546	2025-06-29 00:51:31.031546
51	1	1129	2025-06-29 00:51:31.038415	2025-06-29 00:51:31.038415
52	15	1130	2025-06-29 00:51:31.042746	2025-06-29 00:51:31.042746
53	1	1131	2025-06-29 00:51:31.047033	2025-06-29 00:51:31.047033
54	1	1132	2025-06-29 00:51:31.051287	2025-06-29 00:51:31.051287
55	1	1133	2025-06-29 00:51:31.055758	2025-06-29 00:51:31.055758
56	1	1134	2025-06-29 00:51:31.059917	2025-06-29 00:51:31.059917
57	1	1136	2025-06-29 00:51:31.064069	2025-06-29 00:51:31.064069
58	1	1137	2025-06-29 00:51:31.068125	2025-06-29 00:51:31.068125
59	26	1138	2025-06-29 00:51:31.072452	2025-06-29 00:51:31.072452
60	1	1139	2025-06-29 00:51:31.081155	2025-06-29 00:51:31.081155
61	1	1140	2025-06-29 00:51:31.085213	2025-06-29 00:51:31.085213
62	1	1141	2025-06-29 00:51:31.090617	2025-06-29 00:51:31.090617
63	1	1142	2025-06-29 00:51:31.094941	2025-06-29 00:51:31.094941
64	1	1143	2025-06-29 00:51:31.099031	2025-06-29 00:51:31.099031
65	1	1144	2025-06-29 00:51:31.103168	2025-06-29 00:51:31.103168
66	1	1145	2025-06-29 00:51:31.107271	2025-06-29 00:51:31.107271
67	1	1146	2025-06-29 00:51:31.111715	2025-06-29 00:51:31.111715
68	1	1147	2025-06-29 00:51:31.115229	2025-06-29 00:51:31.115229
69	1	1148	2025-06-29 00:51:31.119432	2025-06-29 00:51:31.119432
70	1	1149	2025-06-29 00:51:31.123663	2025-06-29 00:51:31.123663
71	1	1150	2025-06-29 00:51:31.128108	2025-06-29 00:51:31.128108
72	1	1151	2025-06-29 00:51:31.132452	2025-06-29 00:51:31.132452
73	1	1152	2025-06-29 00:51:31.136643	2025-06-29 00:51:31.136643
74	1	1153	2025-06-29 00:51:31.145522	2025-06-29 00:51:31.145522
75	1	1154	2025-06-29 00:51:31.149894	2025-06-29 00:51:31.149894
76	1	1155	2025-06-29 00:51:31.1543	2025-06-29 00:51:31.1543
77	1	1156	2025-06-29 00:51:31.159209	2025-06-29 00:51:31.159209
78	1	1157	2025-06-29 00:51:31.165182	2025-06-29 00:51:31.165182
79	1	1158	2025-06-29 00:51:31.169602	2025-06-29 00:51:31.169602
80	1	1159	2025-06-29 00:51:31.174072	2025-06-29 00:51:31.174072
81	1	1160	2025-06-29 00:51:31.178871	2025-06-29 00:51:31.178871
82	16	1161	2025-06-29 00:51:31.185144	2025-06-29 00:51:31.185144
83	16	1162	2025-06-29 00:51:31.189732	2025-06-29 00:51:31.189732
84	16	1163	2025-06-29 00:51:31.194197	2025-06-29 00:51:31.194197
85	1	1164	2025-06-29 00:51:31.198268	2025-06-29 00:51:31.198268
86	1	1165	2025-06-29 00:51:31.204061	2025-06-29 00:51:31.204061
87	1	1166	2025-06-29 00:51:31.21042	2025-06-29 00:51:31.21042
88	1	1167	2025-06-29 00:51:31.214929	2025-06-29 00:51:31.214929
89	1	1168	2025-06-29 00:51:31.219819	2025-06-29 00:51:31.219819
90	1	1169	2025-06-29 00:51:31.225568	2025-06-29 00:51:31.225568
91	1	1170	2025-06-29 00:51:31.231815	2025-06-29 00:51:31.231815
92	1	1171	2025-06-29 00:51:31.238236	2025-06-29 00:51:31.238236
93	1	1172	2025-06-29 00:51:31.242948	2025-06-29 00:51:31.242948
94	1	1173	2025-06-29 00:51:31.250179	2025-06-29 00:51:31.250179
95	1	1175	2025-06-29 00:51:31.254238	2025-06-29 00:51:31.254238
96	1	1176	2025-06-29 00:51:31.259554	2025-06-29 00:51:31.259554
97	1	1177	2025-06-29 00:51:31.264838	2025-06-29 00:51:31.264838
98	1	1178	2025-06-29 00:51:31.268812	2025-06-29 00:51:31.268812
99	1	1179	2025-06-29 00:51:31.275103	2025-06-29 00:51:31.275103
100	1	1180	2025-06-29 00:51:31.280151	2025-06-29 00:51:31.280151
101	1	1181	2025-06-29 00:51:31.286659	2025-06-29 00:51:31.286659
102	1	1182	2025-06-29 00:51:31.291194	2025-06-29 00:51:31.291194
103	1	1183	2025-06-29 00:51:31.296675	2025-06-29 00:51:31.296675
104	1	1184	2025-06-29 00:51:31.302428	2025-06-29 00:51:31.302428
105	1	1185	2025-06-29 00:51:31.30828	2025-06-29 00:51:31.30828
106	1	1186	2025-06-29 00:51:31.314053	2025-06-29 00:51:31.314053
107	1	1187	2025-06-29 00:51:31.318639	2025-06-29 00:51:31.318639
108	1	1188	2025-06-29 00:51:31.323226	2025-06-29 00:51:31.323226
109	1	1189	2025-06-29 00:51:31.327502	2025-06-29 00:51:31.327502
110	1	1190	2025-06-29 00:51:31.332046	2025-06-29 00:51:31.332046
111	1	1191	2025-06-29 00:51:31.336348	2025-06-29 00:51:31.336348
112	1	1192	2025-06-29 00:51:31.340501	2025-06-29 00:51:31.340501
113	1	1193	2025-06-29 00:51:31.344669	2025-06-29 00:51:31.344669
114	1	1194	2025-06-29 00:51:31.348715	2025-06-29 00:51:31.348715
115	1	1195	2025-06-29 00:51:31.352724	2025-06-29 00:51:31.352724
116	1	1196	2025-06-29 00:51:31.357166	2025-06-29 00:51:31.357166
117	1	1197	2025-06-29 00:51:31.360565	2025-06-29 00:51:31.360565
118	1	1198	2025-06-29 00:51:31.364865	2025-06-29 00:51:31.364865
119	1	1199	2025-06-29 00:51:31.369886	2025-06-29 00:51:31.369886
120	1	1200	2025-06-29 00:51:31.375275	2025-06-29 00:51:31.375275
121	1	1201	2025-06-29 00:51:31.379356	2025-06-29 00:51:31.379356
122	1	1202	2025-06-29 00:51:31.383853	2025-06-29 00:51:31.383853
123	1	1203	2025-06-29 00:51:31.387936	2025-06-29 00:51:31.387936
124	1	1204	2025-06-29 00:51:31.395169	2025-06-29 00:51:31.395169
125	1	1205	2025-06-29 00:51:31.399622	2025-06-29 00:51:31.399622
126	26	1205	2025-06-29 00:51:31.400178	2025-06-29 00:51:31.400178
127	1	1206	2025-06-29 00:51:31.404524	2025-06-29 00:51:31.404524
128	1	1207	2025-06-29 00:51:31.410276	2025-06-29 00:51:31.410276
129	1	1208	2025-06-29 00:51:31.415401	2025-06-29 00:51:31.415401
130	26	1208	2025-06-29 00:51:31.415975	2025-06-29 00:51:31.415975
131	1	1209	2025-06-29 00:51:31.42076	2025-06-29 00:51:31.42076
132	1	1210	2025-06-29 00:51:31.425351	2025-06-29 00:51:31.425351
133	1	1211	2025-06-29 00:51:31.429705	2025-06-29 00:51:31.429705
134	1	1212	2025-06-29 00:51:31.434167	2025-06-29 00:51:31.434167
135	1	1213	2025-06-29 00:51:31.438647	2025-06-29 00:51:31.438647
136	1	1214	2025-06-29 00:51:31.443079	2025-06-29 00:51:31.443079
137	1	1215	2025-06-29 00:51:31.448803	2025-06-29 00:51:31.448803
138	1	1216	2025-06-29 00:51:31.453917	2025-06-29 00:51:31.453917
139	1	1217	2025-06-29 00:51:31.458541	2025-06-29 00:51:31.458541
140	1	1218	2025-06-29 00:51:31.46305	2025-06-29 00:51:31.46305
141	1	1219	2025-06-29 00:51:31.467697	2025-06-29 00:51:31.467697
142	1	1220	2025-06-29 00:51:31.473372	2025-06-29 00:51:31.473372
143	1	1221	2025-06-29 00:51:31.477738	2025-06-29 00:51:31.477738
144	1	1222	2025-06-29 00:51:31.482098	2025-06-29 00:51:31.482098
145	1	1223	2025-06-29 00:51:31.488059	2025-06-29 00:51:31.488059
146	1	1224	2025-06-29 00:51:31.492764	2025-06-29 00:51:31.492764
147	1	1225	2025-06-29 00:51:31.497116	2025-06-29 00:51:31.497116
148	1	1226	2025-06-29 00:51:31.50161	2025-06-29 00:51:31.50161
149	1	1227	2025-06-29 00:51:31.505775	2025-06-29 00:51:31.505775
150	1	1228	2025-06-29 00:51:31.511889	2025-06-29 00:51:31.511889
151	1	1229	2025-06-29 00:51:31.516162	2025-06-29 00:51:31.516162
152	1	1230	2025-06-29 00:51:31.520165	2025-06-29 00:51:31.520165
153	1	1231	2025-06-29 00:51:31.526733	2025-06-29 00:51:31.526733
154	1	1232	2025-06-29 00:51:31.530941	2025-06-29 00:51:31.530941
155	1	1233	2025-06-29 00:51:31.535229	2025-06-29 00:51:31.535229
156	1	1234	2025-06-29 00:51:31.539908	2025-06-29 00:51:31.539908
157	1	1235	2025-06-29 00:51:31.544173	2025-06-29 00:51:31.544173
158	1	1236	2025-06-29 00:51:31.550134	2025-06-29 00:51:31.550134
159	1	1237	2025-06-29 00:51:31.556	2025-06-29 00:51:31.556
160	1	1238	2025-06-29 00:51:31.561537	2025-06-29 00:51:31.561537
161	1	1239	2025-06-29 00:51:31.567383	2025-06-29 00:51:31.567383
162	1	1240	2025-06-29 00:51:31.572066	2025-06-29 00:51:31.572066
163	1	1241	2025-06-29 00:51:31.577463	2025-06-29 00:51:31.577463
164	1	1242	2025-06-29 00:51:31.581579	2025-06-29 00:51:31.581579
165	1	1243	2025-06-29 00:51:31.585982	2025-06-29 00:51:31.585982
166	25	1244	2025-06-29 00:51:31.590197	2025-06-29 00:51:31.590197
167	1	1245	2025-06-29 00:51:31.594287	2025-06-29 00:51:31.594287
168	1	1246	2025-06-29 00:51:31.598875	2025-06-29 00:51:31.598875
169	1	1247	2025-06-29 00:51:31.602969	2025-06-29 00:51:31.602969
170	1	1248	2025-06-29 00:51:31.607318	2025-06-29 00:51:31.607318
171	1	1249	2025-06-29 00:51:31.611398	2025-06-29 00:51:31.611398
172	1	1250	2025-06-29 00:51:31.615557	2025-06-29 00:51:31.615557
173	13	1251	2025-06-29 00:51:31.619586	2025-06-29 00:51:31.619586
174	1	1252	2025-06-29 00:51:31.624011	2025-06-29 00:51:31.624011
175	1	1253	2025-06-29 00:51:31.629909	2025-06-29 00:51:31.629909
176	1	1254	2025-06-29 00:51:31.634578	2025-06-29 00:51:31.634578
177	1	1255	2025-06-29 00:51:31.639036	2025-06-29 00:51:31.639036
178	1	1257	2025-06-29 00:51:31.643757	2025-06-29 00:51:31.643757
179	1	1262	2025-06-29 00:51:31.648276	2025-06-29 00:51:31.648276
180	1	1263	2025-06-29 00:51:31.653329	2025-06-29 00:51:31.653329
181	1	1264	2025-06-29 00:51:31.659088	2025-06-29 00:51:31.659088
182	1	1265	2025-06-29 00:51:31.663656	2025-06-29 00:51:31.663656
183	1	1266	2025-06-29 00:51:31.667997	2025-06-29 00:51:31.667997
184	1	1268	2025-06-29 00:51:31.672056	2025-06-29 00:51:31.672056
185	1	1269	2025-06-29 00:51:31.676786	2025-06-29 00:51:31.676786
186	1	1270	2025-06-29 00:51:31.681168	2025-06-29 00:51:31.681168
187	1	1271	2025-06-29 00:51:31.68556	2025-06-29 00:51:31.68556
188	1	1272	2025-06-29 00:51:31.690078	2025-06-29 00:51:31.690078
189	1	1273	2025-06-29 00:51:31.694564	2025-06-29 00:51:31.694564
190	1	1274	2025-06-29 00:51:31.699077	2025-06-29 00:51:31.699077
191	1	1275	2025-06-29 00:51:31.703596	2025-06-29 00:51:31.703596
192	1	1276	2025-06-29 00:51:31.708008	2025-06-29 00:51:31.708008
193	1	1277	2025-06-29 00:51:31.712377	2025-06-29 00:51:31.712377
194	1	1278	2025-06-29 00:51:31.71673	2025-06-29 00:51:31.71673
195	31	1279	2025-06-29 00:51:31.721029	2025-06-29 00:51:31.721029
196	1	1280	2025-06-29 00:51:31.725624	2025-06-29 00:51:31.725624
197	1	1281	2025-06-29 00:51:31.729743	2025-06-29 00:51:31.729743
198	40	1282	2025-06-29 00:51:31.73415	2025-06-29 00:51:31.73415
199	1	1283	2025-06-29 00:51:31.738459	2025-06-29 00:51:31.738459
200	1	1284	2025-06-29 00:51:31.744055	2025-06-29 00:51:31.744055
201	1	1285	2025-06-29 00:51:31.748418	2025-06-29 00:51:31.748418
202	1	1286	2025-06-29 00:51:31.752193	2025-06-29 00:51:31.752193
203	1	1287	2025-06-29 00:51:31.758917	2025-06-29 00:51:31.758917
204	1	1288	2025-06-29 00:51:31.763087	2025-06-29 00:51:31.763087
205	1	1289	2025-06-29 00:51:31.768596	2025-06-29 00:51:31.768596
206	1	1290	2025-06-29 00:51:31.773184	2025-06-29 00:51:31.773184
207	1	1291	2025-06-29 00:51:31.777663	2025-06-29 00:51:31.777663
208	1	1292	2025-06-29 00:51:31.781011	2025-06-29 00:51:31.781011
209	1	1293	2025-06-29 00:51:31.785168	2025-06-29 00:51:31.785168
210	1	1294	2025-06-29 00:51:31.789327	2025-06-29 00:51:31.789327
211	1	1295	2025-06-29 00:51:31.79374	2025-06-29 00:51:31.79374
212	1	1296	2025-06-29 00:51:31.797931	2025-06-29 00:51:31.797931
213	1	1297	2025-06-29 00:51:31.80208	2025-06-29 00:51:31.80208
214	1	1298	2025-06-29 00:51:31.806187	2025-06-29 00:51:31.806187
215	1	1299	2025-06-29 00:51:31.810236	2025-06-29 00:51:31.810236
216	1	1300	2025-06-29 00:51:31.814554	2025-06-29 00:51:31.814554
217	16	1301	2025-06-29 00:51:31.818543	2025-06-29 00:51:31.818543
218	1	1302	2025-06-29 00:51:31.822656	2025-06-29 00:51:31.822656
219	1	1303	2025-06-29 00:51:31.826824	2025-06-29 00:51:31.826824
220	1	1304	2025-06-29 00:51:31.832486	2025-06-29 00:51:31.832486
221	1	1305	2025-06-29 00:51:31.837875	2025-06-29 00:51:31.837875
222	1	1306	2025-06-29 00:51:31.84365	2025-06-29 00:51:31.84365
223	1	1307	2025-06-29 00:51:31.847778	2025-06-29 00:51:31.847778
224	1	1308	2025-06-29 00:51:31.853163	2025-06-29 00:51:31.853163
225	1	1309	2025-06-29 00:51:31.85753	2025-06-29 00:51:31.85753
226	1	1310	2025-06-29 00:51:31.861612	2025-06-29 00:51:31.861612
227	1	1311	2025-06-29 00:51:31.865751	2025-06-29 00:51:31.865751
228	1	1312	2025-06-29 00:51:31.871522	2025-06-29 00:51:31.871522
229	1	1313	2025-06-29 00:51:31.87708	2025-06-29 00:51:31.87708
230	1	1314	2025-06-29 00:51:31.8815	2025-06-29 00:51:31.8815
231	1	1315	2025-06-29 00:51:31.88588	2025-06-29 00:51:31.88588
232	1	1316	2025-06-29 00:51:31.890427	2025-06-29 00:51:31.890427
233	1	1317	2025-06-29 00:51:31.894867	2025-06-29 00:51:31.894867
234	1	1318	2025-06-29 00:51:31.900898	2025-06-29 00:51:31.900898
235	1	1319	2025-06-29 00:51:31.906535	2025-06-29 00:51:31.906535
236	1	1320	2025-06-29 00:51:31.91098	2025-06-29 00:51:31.91098
237	1	1321	2025-06-29 00:51:31.915764	2025-06-29 00:51:31.915764
238	1	1322	2025-06-29 00:51:31.920177	2025-06-29 00:51:31.920177
239	1	1323	2025-06-29 00:51:31.924694	2025-06-29 00:51:31.924694
240	1	1324	2025-06-29 00:51:31.929479	2025-06-29 00:51:31.929479
241	1	1325	2025-06-29 00:51:31.933529	2025-06-29 00:51:31.933529
242	1	1326	2025-06-29 00:51:31.938019	2025-06-29 00:51:31.938019
243	1	1327	2025-06-29 00:51:31.942392	2025-06-29 00:51:31.942392
244	1	1328	2025-06-29 00:51:31.946368	2025-06-29 00:51:31.946368
245	1	1329	2025-06-29 00:51:31.950744	2025-06-29 00:51:31.950744
246	1	1330	2025-06-29 00:51:31.955396	2025-06-29 00:51:31.955396
247	1	1331	2025-06-29 00:51:31.960086	2025-06-29 00:51:31.960086
248	1	1332	2025-06-29 00:51:31.965758	2025-06-29 00:51:31.965758
249	1	1333	2025-06-29 00:51:31.970631	2025-06-29 00:51:31.970631
250	1	1334	2025-06-29 00:51:31.97484	2025-06-29 00:51:31.97484
251	1	1335	2025-06-29 00:51:31.978949	2025-06-29 00:51:31.978949
252	13	1336	2025-06-29 00:51:31.984346	2025-06-29 00:51:31.984346
253	1	1337	2025-06-29 00:51:31.9905	2025-06-29 00:51:31.9905
254	1	1338	2025-06-29 00:51:31.995118	2025-06-29 00:51:31.995118
255	1	1339	2025-06-29 00:51:31.999222	2025-06-29 00:51:31.999222
256	1	1340	2025-06-29 00:51:32.003268	2025-06-29 00:51:32.003268
257	1	1341	2025-06-29 00:51:32.009611	2025-06-29 00:51:32.009611
258	1	1342	2025-06-29 00:51:32.013829	2025-06-29 00:51:32.013829
259	1	1343	2025-06-29 00:51:32.017724	2025-06-29 00:51:32.017724
260	13	1344	2025-06-29 00:51:32.021828	2025-06-29 00:51:32.021828
261	1	1345	2025-06-29 00:51:32.025901	2025-06-29 00:51:32.025901
262	1	1346	2025-06-29 00:51:32.029963	2025-06-29 00:51:32.029963
263	1	1347	2025-06-29 00:51:32.034298	2025-06-29 00:51:32.034298
264	1	1348	2025-06-29 00:51:32.038862	2025-06-29 00:51:32.038862
265	1	1349	2025-06-29 00:51:32.042967	2025-06-29 00:51:32.042967
266	1	1350	2025-06-29 00:51:32.047021	2025-06-29 00:51:32.047021
267	1	1351	2025-06-29 00:51:32.052465	2025-06-29 00:51:32.052465
268	1	1352	2025-06-29 00:51:32.0569	2025-06-29 00:51:32.0569
269	1	1353	2025-06-29 00:51:32.061323	2025-06-29 00:51:32.061323
270	1	1354	2025-06-29 00:51:32.06558	2025-06-29 00:51:32.06558
271	1	1355	2025-06-29 00:51:32.069628	2025-06-29 00:51:32.069628
272	1	1356	2025-06-29 00:51:32.073876	2025-06-29 00:51:32.073876
273	1	1357	2025-06-29 00:51:32.078164	2025-06-29 00:51:32.078164
274	1	1358	2025-06-29 00:51:32.082892	2025-06-29 00:51:32.082892
275	1	1359	2025-06-29 00:51:32.086911	2025-06-29 00:51:32.086911
276	1	1360	2025-06-29 00:51:32.092782	2025-06-29 00:51:32.092782
277	1	1361	2025-06-29 00:51:32.097372	2025-06-29 00:51:32.097372
278	1	1362	2025-06-29 00:51:32.101565	2025-06-29 00:51:32.101565
279	1	1363	2025-06-29 00:51:32.107396	2025-06-29 00:51:32.107396
280	1	1364	2025-06-29 00:51:32.112269	2025-06-29 00:51:32.112269
281	1	1365	2025-06-29 00:51:32.117204	2025-06-29 00:51:32.117204
282	1	1366	2025-06-29 00:51:32.121136	2025-06-29 00:51:32.121136
283	1	1367	2025-06-29 00:51:32.125908	2025-06-29 00:51:32.125908
284	1	1368	2025-06-29 00:51:32.130309	2025-06-29 00:51:32.130309
285	1	1369	2025-06-29 00:51:32.135569	2025-06-29 00:51:32.135569
286	1	1370	2025-06-29 00:51:32.140238	2025-06-29 00:51:32.140238
287	1	1371	2025-06-29 00:51:32.145349	2025-06-29 00:51:32.145349
288	1	1372	2025-06-29 00:51:32.150342	2025-06-29 00:51:32.150342
289	1	1373	2025-06-29 00:51:32.155261	2025-06-29 00:51:32.155261
290	1	1374	2025-06-29 00:51:32.158913	2025-06-29 00:51:32.158913
291	1	1375	2025-06-29 00:51:32.164216	2025-06-29 00:51:32.164216
292	1	1376	2025-06-29 00:51:32.169733	2025-06-29 00:51:32.169733
293	1	1377	2025-06-29 00:51:32.176234	2025-06-29 00:51:32.176234
294	12	1378	2025-06-29 00:51:32.183687	2025-06-29 00:51:32.183687
295	1	1379	2025-06-29 00:51:32.190674	2025-06-29 00:51:32.190674
296	1	1380	2025-06-29 00:51:32.196246	2025-06-29 00:51:32.196246
297	1	1381	2025-06-29 00:51:32.201465	2025-06-29 00:51:32.201465
298	1	1382	2025-06-29 00:51:32.206649	2025-06-29 00:51:32.206649
299	1	1383	2025-06-29 00:51:32.212612	2025-06-29 00:51:32.212612
300	1	1384	2025-06-29 00:51:32.21951	2025-06-29 00:51:32.21951
301	1	1385	2025-06-29 00:51:32.22515	2025-06-29 00:51:32.22515
302	1	1386	2025-06-29 00:51:32.230672	2025-06-29 00:51:32.230672
303	1	1387	2025-06-29 00:51:32.239577	2025-06-29 00:51:32.239577
304	1	1388	2025-06-29 00:51:32.244764	2025-06-29 00:51:32.244764
305	1	1389	2025-06-29 00:51:32.250181	2025-06-29 00:51:32.250181
306	1	1390	2025-06-29 00:51:32.257008	2025-06-29 00:51:32.257008
307	1	1391	2025-06-29 00:51:32.261313	2025-06-29 00:51:32.261313
308	1	1392	2025-06-29 00:51:32.266016	2025-06-29 00:51:32.266016
309	1	1393	2025-06-29 00:51:32.272834	2025-06-29 00:51:32.272834
310	1	1394	2025-06-29 00:51:32.277889	2025-06-29 00:51:32.277889
311	1	1395	2025-06-29 00:51:32.283229	2025-06-29 00:51:32.283229
312	1	1396	2025-06-29 00:51:32.28906	2025-06-29 00:51:32.28906
313	1	1397	2025-06-29 00:51:32.294637	2025-06-29 00:51:32.294637
314	1	1398	2025-06-29 00:51:32.299813	2025-06-29 00:51:32.299813
315	1	1399	2025-06-29 00:51:32.305153	2025-06-29 00:51:32.305153
316	1	1400	2025-06-29 00:51:32.31019	2025-06-29 00:51:32.31019
317	1	1401	2025-06-29 00:51:32.316398	2025-06-29 00:51:32.316398
318	1	1402	2025-06-29 00:51:32.321915	2025-06-29 00:51:32.321915
319	1	1403	2025-06-29 00:51:32.328402	2025-06-29 00:51:32.328402
320	1	1404	2025-06-29 00:51:32.333556	2025-06-29 00:51:32.333556
321	1	1405	2025-06-29 00:51:32.338854	2025-06-29 00:51:32.338854
322	1	1406	2025-06-29 00:51:32.345213	2025-06-29 00:51:32.345213
323	1	1407	2025-06-29 00:51:32.352256	2025-06-29 00:51:32.352256
324	1	1409	2025-06-29 00:51:32.358393	2025-06-29 00:51:32.358393
325	1	1410	2025-06-29 00:51:32.365164	2025-06-29 00:51:32.365164
326	1	1411	2025-06-29 00:51:32.373394	2025-06-29 00:51:32.373394
327	1	1412	2025-06-29 00:51:32.380439	2025-06-29 00:51:32.380439
328	1	1413	2025-06-29 00:51:32.387328	2025-06-29 00:51:32.387328
329	1	1414	2025-06-29 00:51:32.393858	2025-06-29 00:51:32.393858
330	1	1415	2025-06-29 00:51:32.404603	2025-06-29 00:51:32.404603
331	6	1416	2025-06-29 00:51:32.419377	2025-06-29 00:51:32.419377
332	9	1417	2025-06-29 00:51:32.424204	2025-06-29 00:51:32.424204
333	1	1418	2025-06-29 00:51:32.431877	2025-06-29 00:51:32.431877
334	1	1419	2025-06-29 00:51:32.440053	2025-06-29 00:51:32.440053
335	1	1420	2025-06-29 00:51:32.446737	2025-06-29 00:51:32.446737
336	9	1421	2025-06-29 00:51:32.452217	2025-06-29 00:51:32.452217
337	1	1422	2025-06-29 00:51:32.461321	2025-06-29 00:51:32.461321
338	12	1423	2025-06-29 00:51:32.469292	2025-06-29 00:51:32.469292
339	1	1424	2025-06-29 00:51:32.475457	2025-06-29 00:51:32.475457
340	1	1425	2025-06-29 00:51:32.485637	2025-06-29 00:51:32.485637
341	1	1426	2025-06-29 00:51:32.493213	2025-06-29 00:51:32.493213
342	1	1427	2025-06-29 00:51:32.499891	2025-06-29 00:51:32.499891
343	2	1428	2025-06-29 00:51:32.506173	2025-06-29 00:51:32.506173
344	1	1429	2025-06-29 00:51:32.51256	2025-06-29 00:51:32.51256
345	1	1430	2025-06-29 00:51:32.518788	2025-06-29 00:51:32.518788
346	1	1435	2025-06-29 00:51:32.524824	2025-06-29 00:51:32.524824
347	1	1439	2025-06-29 00:51:32.530658	2025-06-29 00:51:32.530658
348	26	1441	2025-06-29 00:51:32.535439	2025-06-29 00:51:32.535439
349	1	1442	2025-06-29 00:51:32.541019	2025-06-29 00:51:32.541019
350	1	1443	2025-06-29 00:51:32.546844	2025-06-29 00:51:32.546844
351	1	1444	2025-06-29 00:51:32.552358	2025-06-29 00:51:32.552358
352	1	1445	2025-06-29 00:51:32.558335	2025-06-29 00:51:32.558335
353	9	1446	2025-06-29 00:51:32.566545	2025-06-29 00:51:32.566545
354	10	1447	2025-06-29 00:51:32.572315	2025-06-29 00:51:32.572315
355	1	1448	2025-06-29 00:51:32.578589	2025-06-29 00:51:32.578589
356	1	1449	2025-06-29 00:51:32.584045	2025-06-29 00:51:32.584045
357	1	1450	2025-06-29 00:51:32.590044	2025-06-29 00:51:32.590044
358	1	1451	2025-06-29 00:51:32.595735	2025-06-29 00:51:32.595735
359	13	1452	2025-06-29 00:51:32.601317	2025-06-29 00:51:32.601317
360	1	1453	2025-06-29 00:51:32.606694	2025-06-29 00:51:32.606694
361	1	1454	2025-06-29 00:51:32.612292	2025-06-29 00:51:32.612292
362	1	1455	2025-06-29 00:51:32.617982	2025-06-29 00:51:32.617982
363	1	1456	2025-06-29 00:51:32.623191	2025-06-29 00:51:32.623191
364	2	1457	2025-06-29 00:51:32.628575	2025-06-29 00:51:32.628575
365	41	1458	2025-06-29 00:51:32.633939	2025-06-29 00:51:32.633939
366	6	1459	2025-06-29 00:51:32.639443	2025-06-29 00:51:32.639443
367	2	1460	2025-06-29 00:51:32.645181	2025-06-29 00:51:32.645181
368	1	1461	2025-06-29 00:51:32.650462	2025-06-29 00:51:32.650462
369	1	1462	2025-06-29 00:51:32.65603	2025-06-29 00:51:32.65603
370	12	1463	2025-06-29 00:51:32.661512	2025-06-29 00:51:32.661512
371	20	1464	2025-06-29 00:51:32.667505	2025-06-29 00:51:32.667505
372	9	1465	2025-06-29 00:51:32.673108	2025-06-29 00:51:32.673108
373	1	1466	2025-06-29 00:51:32.678109	2025-06-29 00:51:32.678109
374	1	1467	2025-06-29 00:51:32.683739	2025-06-29 00:51:32.683739
375	1	1468	2025-06-29 00:51:32.689256	2025-06-29 00:51:32.689256
376	30	1469	2025-06-29 00:51:32.694937	2025-06-29 00:51:32.694937
377	17	1470	2025-06-29 00:51:32.700171	2025-06-29 00:51:32.700171
378	1	1471	2025-06-29 00:51:32.705471	2025-06-29 00:51:32.705471
379	1	1472	2025-06-29 00:51:32.710699	2025-06-29 00:51:32.710699
380	11	1473	2025-06-29 00:51:32.714988	2025-06-29 00:51:32.714988
381	1	1474	2025-06-29 00:51:32.720383	2025-06-29 00:51:32.720383
382	3	1475	2025-06-29 00:51:32.725983	2025-06-29 00:51:32.725983
383	1	1476	2025-06-29 00:51:32.733051	2025-06-29 00:51:32.733051
384	1	1477	2025-06-29 00:51:32.73912	2025-06-29 00:51:32.73912
385	1	1481	2025-06-29 00:51:32.745018	2025-06-29 00:51:32.745018
386	1	1482	2025-06-29 00:51:32.750939	2025-06-29 00:51:32.750939
387	9	1516	2025-06-29 00:51:32.756898	2025-06-29 00:51:32.756898
388	1	1517	2025-06-29 00:51:32.763191	2025-06-29 00:51:32.763191
389	1	1518	2025-06-29 00:51:32.768796	2025-06-29 00:51:32.768796
390	1	1519	2025-06-29 00:51:32.774492	2025-06-29 00:51:32.774492
391	6	1521	2025-06-29 00:51:32.781148	2025-06-29 00:51:32.781148
392	6	1522	2025-06-29 00:51:32.787272	2025-06-29 00:51:32.787272
393	1	1523	2025-06-29 00:51:32.793542	2025-06-29 00:51:32.793542
394	34	1524	2025-06-29 00:51:32.799142	2025-06-29 00:51:32.799142
395	15	1525	2025-06-29 00:51:32.804443	2025-06-29 00:51:32.804443
396	1	1526	2025-06-29 00:51:32.809834	2025-06-29 00:51:32.809834
397	18	1527	2025-06-29 00:51:32.815362	2025-06-29 00:51:32.815362
398	15	1528	2025-06-29 00:51:32.821292	2025-06-29 00:51:32.821292
399	1	1529	2025-06-29 00:51:32.827117	2025-06-29 00:51:32.827117
400	13	1530	2025-06-29 00:51:32.832093	2025-06-29 00:51:32.832093
401	1	1531	2025-06-29 00:51:32.837466	2025-06-29 00:51:32.837466
402	22	1532	2025-06-29 00:51:32.84246	2025-06-29 00:51:32.84246
403	4	1533	2025-06-29 00:51:32.850092	2025-06-29 00:51:32.850092
404	6	1534	2025-06-29 00:51:32.854468	2025-06-29 00:51:32.854468
405	22	1535	2025-06-29 00:51:32.859475	2025-06-29 00:51:32.859475
406	6	1536	2025-06-29 00:51:32.864946	2025-06-29 00:51:32.864946
407	2	1537	2025-06-29 00:51:32.87029	2025-06-29 00:51:32.87029
408	1	1538	2025-06-29 00:51:32.875348	2025-06-29 00:51:32.875348
409	1	1539	2025-06-29 00:51:32.880727	2025-06-29 00:51:32.880727
410	1	1540	2025-06-29 00:51:32.886263	2025-06-29 00:51:32.886263
411	14	1541	2025-06-29 00:51:32.891382	2025-06-29 00:51:32.891382
412	1	1542	2025-06-29 00:51:32.896427	2025-06-29 00:51:32.896427
413	1	1543	2025-06-29 00:51:32.901513	2025-06-29 00:51:32.901513
414	21	1544	2025-06-29 00:51:32.908328	2025-06-29 00:51:32.908328
415	1	1545	2025-06-29 00:51:32.913005	2025-06-29 00:51:32.913005
416	8	1546	2025-06-29 00:51:32.918191	2025-06-29 00:51:32.918191
417	21	1547	2025-06-29 00:51:32.923062	2025-06-29 00:51:32.923062
418	1	1549	2025-06-29 00:51:32.928142	2025-06-29 00:51:32.928142
419	6	1550	2025-06-29 00:51:32.934718	2025-06-29 00:51:32.934718
420	1	1551	2025-06-29 00:51:32.93998	2025-06-29 00:51:32.93998
421	1	1552	2025-06-29 00:51:32.94463	2025-06-29 00:51:32.94463
422	10	1553	2025-06-29 00:51:32.948865	2025-06-29 00:51:32.948865
423	1	1554	2025-06-29 00:51:32.953137	2025-06-29 00:51:32.953137
424	28	1555	2025-06-29 00:51:32.957502	2025-06-29 00:51:32.957502
425	1	1556	2025-06-29 00:51:32.961686	2025-06-29 00:51:32.961686
426	1	1557	2025-06-29 00:51:32.965995	2025-06-29 00:51:32.965995
427	6	1558	2025-06-29 00:51:32.970002	2025-06-29 00:51:32.970002
428	1	1559	2025-06-29 00:51:32.979459	2025-06-29 00:51:32.979459
429	7	1560	2025-06-29 00:51:32.983472	2025-06-29 00:51:32.983472
430	1	1561	2025-06-29 00:51:32.987535	2025-06-29 00:51:32.987535
431	1	1562	2025-06-29 00:51:32.991703	2025-06-29 00:51:32.991703
432	20	1563	2025-06-29 00:51:32.99716	2025-06-29 00:51:32.99716
433	1	1564	2025-06-29 00:51:33.002742	2025-06-29 00:51:33.002742
434	27	1566	2025-06-29 00:51:33.008459	2025-06-29 00:51:33.008459
435	6	1567	2025-06-29 00:51:33.012135	2025-06-29 00:51:33.012135
436	19	1568	2025-06-29 00:51:33.016607	2025-06-29 00:51:33.016607
437	7	1569	2025-06-29 00:51:33.021065	2025-06-29 00:51:33.021065
438	1	1570	2025-06-29 00:51:33.025852	2025-06-29 00:51:33.025852
439	1	1571	2025-06-29 00:51:33.030403	2025-06-29 00:51:33.030403
440	1	1572	2025-06-29 00:51:33.033923	2025-06-29 00:51:33.033923
441	21	1573	2025-06-29 00:51:33.038289	2025-06-29 00:51:33.038289
442	1	1574	2025-06-29 00:51:33.042807	2025-06-29 00:51:33.042807
443	1	1575	2025-06-29 00:51:33.047541	2025-06-29 00:51:33.047541
444	1	1576	2025-06-29 00:51:33.053777	2025-06-29 00:51:33.053777
445	3	1577	2025-06-29 00:51:33.059517	2025-06-29 00:51:33.059517
446	7	1578	2025-06-29 00:51:33.06494	2025-06-29 00:51:33.06494
447	8	1579	2025-06-29 00:51:33.07024	2025-06-29 00:51:33.07024
448	20	1580	2025-06-29 00:51:33.07563	2025-06-29 00:51:33.07563
449	19	1581	2025-06-29 00:51:33.080862	2025-06-29 00:51:33.080862
450	1	1582	2025-06-29 00:51:33.086034	2025-06-29 00:51:33.086034
451	6	1583	2025-06-29 00:51:33.091423	2025-06-29 00:51:33.091423
452	1	1584	2025-06-29 00:51:33.096383	2025-06-29 00:51:33.096383
453	1	1585	2025-06-29 00:51:33.103106	2025-06-29 00:51:33.103106
454	1	1586	2025-06-29 00:51:33.108177	2025-06-29 00:51:33.108177
455	1	1587	2025-06-29 00:51:33.112109	2025-06-29 00:51:33.112109
456	1	1588	2025-06-29 00:51:33.1169	2025-06-29 00:51:33.1169
457	2	1589	2025-06-29 00:51:33.1219	2025-06-29 00:51:33.1219
458	29	1590	2025-06-29 00:51:33.126724	2025-06-29 00:51:33.126724
459	24	1591	2025-06-29 00:51:33.131359	2025-06-29 00:51:33.131359
460	1	1592	2025-06-29 00:51:33.135763	2025-06-29 00:51:33.135763
461	1	1593	2025-06-29 00:51:33.140012	2025-06-29 00:51:33.140012
462	1	1594	2025-06-29 00:51:33.14413	2025-06-29 00:51:33.14413
463	6	1595	2025-06-29 00:51:33.148322	2025-06-29 00:51:33.148322
464	17	1596	2025-06-29 00:51:33.152398	2025-06-29 00:51:33.152398
465	2	1597	2025-06-29 00:51:33.156448	2025-06-29 00:51:33.156448
466	1	1598	2025-06-29 00:51:33.161008	2025-06-29 00:51:33.161008
467	1	1599	2025-06-29 00:51:33.165343	2025-06-29 00:51:33.165343
468	1	1600	2025-06-29 00:51:33.169375	2025-06-29 00:51:33.169375
469	1	1601	2025-06-29 00:51:33.173513	2025-06-29 00:51:33.173513
470	7	1602	2025-06-29 00:51:33.177823	2025-06-29 00:51:33.177823
471	1	1603	2025-06-29 00:51:33.182287	2025-06-29 00:51:33.182287
472	1	1604	2025-06-29 00:51:33.186313	2025-06-29 00:51:33.186313
473	23	1605	2025-06-29 00:51:33.190536	2025-06-29 00:51:33.190536
474	8	1606	2025-06-29 00:51:33.194873	2025-06-29 00:51:33.194873
475	24	1607	2025-06-29 00:51:33.198943	2025-06-29 00:51:33.198943
476	2	1608	2025-06-29 00:51:33.20302	2025-06-29 00:51:33.20302
477	1	1609	2025-06-29 00:51:33.207167	2025-06-29 00:51:33.207167
478	6	1610	2025-06-29 00:51:33.211696	2025-06-29 00:51:33.211696
479	1	1611	2025-06-29 00:51:33.216016	2025-06-29 00:51:33.216016
480	4	1613	2025-06-29 00:51:33.220135	2025-06-29 00:51:33.220135
481	5	1614	2025-06-29 00:51:33.224378	2025-06-29 00:51:33.224378
482	5	1615	2025-06-29 00:51:33.22862	2025-06-29 00:51:33.22862
483	5	1616	2025-06-29 00:51:33.233238	2025-06-29 00:51:33.233238
484	1	1617	2025-06-29 00:51:33.238759	2025-06-29 00:51:33.238759
485	1	1618	2025-06-29 00:51:33.243745	2025-06-29 00:51:33.243745
486	19	1619	2025-06-29 00:51:33.248587	2025-06-29 00:51:33.248587
487	19	1620	2025-06-29 00:51:33.253531	2025-06-29 00:51:33.253531
488	19	1621	2025-06-29 00:51:33.258004	2025-06-29 00:51:33.258004
489	27	1622	2025-06-29 00:51:33.262676	2025-06-29 00:51:33.262676
490	2	1623	2025-06-29 00:51:33.267674	2025-06-29 00:51:33.267674
491	1	1624	2025-06-29 00:51:33.273016	2025-06-29 00:51:33.273016
492	9	1625	2025-06-29 00:51:33.278209	2025-06-29 00:51:33.278209
493	1	1626	2025-06-29 00:51:33.282627	2025-06-29 00:51:33.282627
494	19	1627	2025-06-29 00:51:33.287142	2025-06-29 00:51:33.287142
495	19	1628	2025-06-29 00:51:33.291807	2025-06-29 00:51:33.291807
496	19	1629	2025-06-29 00:51:33.296265	2025-06-29 00:51:33.296265
497	19	1630	2025-06-29 00:51:33.300657	2025-06-29 00:51:33.300657
498	19	1631	2025-06-29 00:51:33.305199	2025-06-29 00:51:33.305199
499	19	1632	2025-06-29 00:51:33.309912	2025-06-29 00:51:33.309912
500	19	1633	2025-06-29 00:51:33.314871	2025-06-29 00:51:33.314871
501	19	1634	2025-06-29 00:51:33.319311	2025-06-29 00:51:33.319311
502	19	1635	2025-06-29 00:51:33.323845	2025-06-29 00:51:33.323845
503	15	1636	2025-06-29 00:51:33.329399	2025-06-29 00:51:33.329399
504	15	1637	2025-06-29 00:51:33.333797	2025-06-29 00:51:33.333797
505	15	1638	2025-06-29 00:51:33.338453	2025-06-29 00:51:33.338453
506	1	1639	2025-06-29 00:51:33.342467	2025-06-29 00:51:33.342467
507	1	1640	2025-06-29 00:51:33.346794	2025-06-29 00:51:33.346794
508	1	1641	2025-06-29 00:51:33.351001	2025-06-29 00:51:33.351001
509	1	1642	2025-06-29 00:51:33.355402	2025-06-29 00:51:33.355402
510	1	1643	2025-06-29 00:51:33.359596	2025-06-29 00:51:33.359596
511	35	1644	2025-06-29 00:51:33.364034	2025-06-29 00:51:33.364034
512	16	1645	2025-06-29 00:51:33.368476	2025-06-29 00:51:33.368476
513	9	1646	2025-06-29 00:51:33.372669	2025-06-29 00:51:33.372669
514	19	1647	2025-06-29 00:51:33.37561	2025-06-29 00:51:33.37561
515	19	1648	2025-06-29 00:51:33.380397	2025-06-29 00:51:33.380397
516	19	1649	2025-06-29 00:51:33.3846	2025-06-29 00:51:33.3846
517	19	1650	2025-06-29 00:51:33.388676	2025-06-29 00:51:33.388676
518	19	1651	2025-06-29 00:51:33.392881	2025-06-29 00:51:33.392881
519	19	1652	2025-06-29 00:51:33.397033	2025-06-29 00:51:33.397033
520	19	1653	2025-06-29 00:51:33.401153	2025-06-29 00:51:33.401153
521	19	1654	2025-06-29 00:51:33.405287	2025-06-29 00:51:33.405287
522	19	1655	2025-06-29 00:51:33.409315	2025-06-29 00:51:33.409315
523	5	1656	2025-06-29 00:51:33.413336	2025-06-29 00:51:33.413336
524	24	1657	2025-06-29 00:51:33.417498	2025-06-29 00:51:33.417498
525	19	1658	2025-06-29 00:51:33.42025	2025-06-29 00:51:33.42025
526	1	1659	2025-06-29 00:51:33.424386	2025-06-29 00:51:33.424386
527	1	1660	2025-06-29 00:51:33.428511	2025-06-29 00:51:33.428511
528	17	1661	2025-06-29 00:51:33.432843	2025-06-29 00:51:33.432843
529	1	1662	2025-06-29 00:51:33.436995	2025-06-29 00:51:33.436995
530	17	1664	2025-06-29 00:51:33.441544	2025-06-29 00:51:33.441544
531	27	1665	2025-06-29 00:51:33.446233	2025-06-29 00:51:33.446233
532	43	1666	2025-06-29 00:51:33.449039	2025-06-29 00:51:33.449039
533	5	1667	2025-06-29 00:51:33.453121	2025-06-29 00:51:33.453121
534	43	1668	2025-06-29 00:51:33.457481	2025-06-29 00:51:33.457481
535	43	1669	2025-06-29 00:51:33.460715	2025-06-29 00:51:33.460715
536	5	1670	2025-06-29 00:51:33.464405	2025-06-29 00:51:33.464405
537	5	1671	2025-06-29 00:51:33.468318	2025-06-29 00:51:33.468318
538	5	1672	2025-06-29 00:51:33.471422	2025-06-29 00:51:33.471422
539	5	1673	2025-06-29 00:51:33.475108	2025-06-29 00:51:33.475108
540	5	1674	2025-06-29 00:51:33.478648	2025-06-29 00:51:33.478648
541	23	1675	2025-06-29 00:51:33.482333	2025-06-29 00:51:33.482333
542	44	1676	2025-06-29 00:51:33.486701	2025-06-29 00:51:33.486701
543	19	1678	2025-06-29 00:51:33.489965	2025-06-29 00:51:33.489965
544	19	1679	2025-06-29 00:51:33.493259	2025-06-29 00:51:33.493259
545	5	1680	2025-06-29 00:51:33.497057	2025-06-29 00:51:33.497057
546	19	1681	2025-06-29 00:51:33.500348	2025-06-29 00:51:33.500348
547	19	1682	2025-06-29 00:51:33.503478	2025-06-29 00:51:33.503478
548	45	1683	2025-06-29 00:51:33.507584	2025-06-29 00:51:33.507584
549	45	1684	2025-06-29 00:51:33.511988	2025-06-29 00:51:33.511988
550	45	1685	2025-06-29 00:51:33.5159	2025-06-29 00:51:33.5159
551	1	1686	2025-06-29 00:51:33.519799	2025-06-29 00:51:33.519799
552	46	1687	2025-06-29 00:51:33.524769	2025-06-29 00:51:33.524769
553	22	1688	2025-06-29 00:51:33.530801	2025-06-29 00:51:33.530801
554	5	1689	2025-06-29 00:51:33.535023	2025-06-29 00:51:33.535023
555	1	1690	2025-06-29 00:51:33.539512	2025-06-29 00:51:33.539512
556	5	1691	2025-06-29 00:51:33.544634	2025-06-29 00:51:33.544634
557	1	1692	2025-06-29 00:51:33.548942	2025-06-29 00:51:33.548942
558	3	1694	2025-06-29 00:51:33.553223	2025-06-29 00:51:33.553223
559	1	1695	2025-06-29 00:51:33.55793	2025-06-29 00:51:33.55793
560	1	1696	2025-06-29 00:51:33.561325	2025-06-29 00:51:33.561325
561	2	1697	2025-06-29 00:51:33.565365	2025-06-29 00:51:33.565365
562	20	1698	2025-06-29 00:51:33.569577	2025-06-29 00:51:33.569577
563	24	1699	2025-06-29 00:51:33.574117	2025-06-29 00:51:33.574117
564	47	1700	2025-06-29 00:51:33.578381	2025-06-29 00:51:33.578381
565	21	1701	2025-06-29 00:51:33.582533	2025-06-29 00:51:33.582533
566	48	1702	2025-06-29 00:51:33.586753	2025-06-29 00:51:33.586753
567	3	1703	2025-06-29 00:51:33.591428	2025-06-29 00:51:33.591428
568	7	1704	2025-06-29 00:51:33.595704	2025-06-29 00:51:33.595704
569	1	1705	2025-06-29 00:51:33.599952	2025-06-29 00:51:33.599952
570	1	1706	2025-06-29 00:51:33.604277	2025-06-29 00:51:33.604277
571	1	1707	2025-06-29 00:51:33.60836	2025-06-29 00:51:33.60836
572	1	1708	2025-06-29 00:51:33.612357	2025-06-29 00:51:33.612357
573	1	1709	2025-06-29 00:51:33.616365	2025-06-29 00:51:33.616365
574	10	1710	2025-06-29 00:51:33.620364	2025-06-29 00:51:33.620364
575	1	1712	2025-06-29 00:51:33.624659	2025-06-29 00:51:33.624659
576	1	1713	2025-06-29 00:51:33.62884	2025-06-29 00:51:33.62884
577	17	1714	2025-06-29 00:51:33.633043	2025-06-29 00:51:33.633043
578	6	1715	2025-06-29 00:51:33.637542	2025-06-29 00:51:33.637542
579	1	1716	2025-06-29 00:51:33.642136	2025-06-29 00:51:33.642136
580	19	1717	2025-06-29 00:51:33.647413	2025-06-29 00:51:33.647413
581	1	1718	2025-06-29 00:51:33.651486	2025-06-29 00:51:33.651486
582	19	1719	2025-06-29 00:51:33.655812	2025-06-29 00:51:33.655812
583	49	1720	2025-06-29 00:51:33.659935	2025-06-29 00:51:33.659935
584	4	1721	2025-06-29 00:51:33.664131	2025-06-29 00:51:33.664131
585	5	1722	2025-06-29 00:51:33.666923	2025-06-29 00:51:33.666923
586	5	1723	2025-06-29 00:51:33.669693	2025-06-29 00:51:33.669693
587	5	1724	2025-06-29 00:51:33.673815	2025-06-29 00:51:33.673815
588	5	1725	2025-06-29 00:51:33.678999	2025-06-29 00:51:33.678999
589	5	1726	2025-06-29 00:51:33.683498	2025-06-29 00:51:33.683498
590	19	1727	2025-06-29 00:51:33.6882	2025-06-29 00:51:33.6882
591	19	1728	2025-06-29 00:51:33.691268	2025-06-29 00:51:33.691268
592	50	1729	2025-06-29 00:51:33.696145	2025-06-29 00:51:33.696145
593	1	1730	2025-06-29 00:51:33.701125	2025-06-29 00:51:33.701125
594	24	1731	2025-06-29 00:51:33.706376	2025-06-29 00:51:33.706376
595	20	1732	2025-06-29 00:51:33.712988	2025-06-29 00:51:33.712988
596	2	1733	2025-06-29 00:51:33.717184	2025-06-29 00:51:33.717184
597	30	1734	2025-06-29 00:51:33.722813	2025-06-29 00:51:33.722813
598	9	1735	2025-06-29 00:51:33.729079	2025-06-29 00:51:33.729079
599	1	1736	2025-06-29 00:51:33.734856	2025-06-29 00:51:33.734856
600	1	1737	2025-06-29 00:51:33.739615	2025-06-29 00:51:33.739615
601	2	1738	2025-06-29 00:51:33.74458	2025-06-29 00:51:33.74458
602	22	1739	2025-06-29 00:51:33.750455	2025-06-29 00:51:33.750455
603	1	1740	2025-06-29 00:51:33.756168	2025-06-29 00:51:33.756168
604	1	1741	2025-06-29 00:51:33.760883	2025-06-29 00:51:33.760883
605	1	1742	2025-06-29 00:51:33.766355	2025-06-29 00:51:33.766355
606	1	1743	2025-06-29 00:51:33.771868	2025-06-29 00:51:33.771868
607	2	1744	2025-06-29 00:51:33.777857	2025-06-29 00:51:33.777857
608	1	1745	2025-06-29 00:51:33.784546	2025-06-29 00:51:33.784546
609	1	1746	2025-06-29 00:51:33.790171	2025-06-29 00:51:33.790171
610	8	1747	2025-06-29 00:51:33.795682	2025-06-29 00:51:33.795682
611	51	1748	2025-06-29 00:51:33.800911	2025-06-29 00:51:33.800911
612	20	1749	2025-06-29 00:51:33.806442	2025-06-29 00:51:33.806442
613	12	1750	2025-06-29 00:51:33.811806	2025-06-29 00:51:33.811806
614	1	1751	2025-06-29 00:51:33.816821	2025-06-29 00:51:33.816821
615	1	1752	2025-06-29 00:51:33.821605	2025-06-29 00:51:33.821605
616	1	1753	2025-06-29 00:51:33.826963	2025-06-29 00:51:33.826963
617	21	1754	2025-06-29 00:51:33.83183	2025-06-29 00:51:33.83183
618	1	1755	2025-06-29 00:51:33.836962	2025-06-29 00:51:33.836962
619	1	1756	2025-06-29 00:51:33.841792	2025-06-29 00:51:33.841792
620	48	1757	2025-06-29 00:51:33.84714	2025-06-29 00:51:33.84714
621	1	1758	2025-06-29 00:51:33.851237	2025-06-29 00:51:33.851237
622	1	1759	2025-06-29 00:51:33.855788	2025-06-29 00:51:33.855788
623	6	1760	2025-06-29 00:51:33.861784	2025-06-29 00:51:33.861784
624	45	1761	2025-06-29 00:51:33.866018	2025-06-29 00:51:33.866018
625	45	1762	2025-06-29 00:51:33.870259	2025-06-29 00:51:33.870259
626	45	1763	2025-06-29 00:51:33.874888	2025-06-29 00:51:33.874888
627	45	1764	2025-06-29 00:51:33.879688	2025-06-29 00:51:33.879688
628	45	1765	2025-06-29 00:51:33.884807	2025-06-29 00:51:33.884807
629	19	1766	2025-06-29 00:51:33.88779	2025-06-29 00:51:33.88779
630	5	1767	2025-06-29 00:51:33.891899	2025-06-29 00:51:33.891899
631	5	1768	2025-06-29 00:51:33.895621	2025-06-29 00:51:33.895621
632	5	1769	2025-06-29 00:51:33.899303	2025-06-29 00:51:33.899303
633	5	1770	2025-06-29 00:51:33.902966	2025-06-29 00:51:33.902966
634	5	1771	2025-06-29 00:51:33.906581	2025-06-29 00:51:33.906581
635	19	1772	2025-06-29 00:51:33.909348	2025-06-29 00:51:33.909348
636	1	1773	2025-06-29 00:51:33.913367	2025-06-29 00:51:33.913367
637	2	1774	2025-06-29 00:51:33.917545	2025-06-29 00:51:33.917545
638	2	1775	2025-06-29 00:51:33.921863	2025-06-29 00:51:33.921863
639	2	1776	2025-06-29 00:51:33.928094	2025-06-29 00:51:33.928094
640	1	1777	2025-06-29 00:51:33.932516	2025-06-29 00:51:33.932516
641	1	1778	2025-06-29 00:51:33.936922	2025-06-29 00:51:33.936922
642	9	1779	2025-06-29 00:51:33.941429	2025-06-29 00:51:33.941429
643	50	1780	2025-06-29 00:51:33.944535	2025-06-29 00:51:33.944535
644	3	1781	2025-06-29 00:51:33.949001	2025-06-29 00:51:33.949001
645	1	1782	2025-06-29 00:51:33.953357	2025-06-29 00:51:33.953357
646	52	1783	2025-06-29 00:51:33.958268	2025-06-29 00:51:33.958268
647	1	1784	2025-06-29 00:51:33.962711	2025-06-29 00:51:33.962711
648	1	1785	2025-06-29 00:51:33.967151	2025-06-29 00:51:33.967151
649	21	1786	2025-06-29 00:51:33.971595	2025-06-29 00:51:33.971595
650	1	1787	2025-06-29 00:51:33.97604	2025-06-29 00:51:33.97604
651	1	1788	2025-06-29 00:51:33.980833	2025-06-29 00:51:33.980833
652	2	1789	2025-06-29 00:51:33.985461	2025-06-29 00:51:33.985461
653	1	1791	2025-06-29 00:51:33.99057	2025-06-29 00:51:33.99057
654	1	1792	2025-06-29 00:51:33.994989	2025-06-29 00:51:33.994989
655	1	1793	2025-06-29 00:51:33.998255	2025-06-29 00:51:33.998255
656	2	1794	2025-06-29 00:51:34.00145	2025-06-29 00:51:34.00145
657	2	1795	2025-06-29 00:51:34.005133	2025-06-29 00:51:34.005133
658	17	1796	2025-06-29 00:51:34.009666	2025-06-29 00:51:34.009666
659	19	1797	2025-06-29 00:51:34.012589	2025-06-29 00:51:34.012589
660	19	1798	2025-06-29 00:51:34.015639	2025-06-29 00:51:34.015639
661	1	1799	2025-06-29 00:51:34.019103	2025-06-29 00:51:34.019103
662	1	1800	2025-06-29 00:51:34.023626	2025-06-29 00:51:34.023626
663	1	1801	2025-06-29 00:51:34.027733	2025-06-29 00:51:34.027733
664	53	1802	2025-06-29 00:51:34.032276	2025-06-29 00:51:34.032276
665	1	1803	2025-06-29 00:51:34.036773	2025-06-29 00:51:34.036773
666	3	1804	2025-06-29 00:51:34.041062	2025-06-29 00:51:34.041062
667	1	1805	2025-06-29 00:51:34.045255	2025-06-29 00:51:34.045255
668	1	1806	2025-06-29 00:51:34.049447	2025-06-29 00:51:34.049447
669	9	1807	2025-06-29 00:51:34.053869	2025-06-29 00:51:34.053869
670	1	1808	2025-06-29 00:51:34.058255	2025-06-29 00:51:34.058255
671	54	1809	2025-06-29 00:51:34.064252	2025-06-29 00:51:34.064252
672	52	1810	2025-06-29 00:51:34.068385	2025-06-29 00:51:34.068385
673	1	1811	2025-06-29 00:51:34.072465	2025-06-29 00:51:34.072465
674	1	1812	2025-06-29 00:51:34.076579	2025-06-29 00:51:34.076579
675	55	1813	2025-06-29 00:51:34.080651	2025-06-29 00:51:34.080651
676	1	1814	2025-06-29 00:51:34.084742	2025-06-29 00:51:34.084742
677	1	1815	2025-06-29 00:51:34.088679	2025-06-29 00:51:34.088679
678	6	1816	2025-06-29 00:51:34.094349	2025-06-29 00:51:34.094349
679	1	1817	2025-06-29 00:51:34.098455	2025-06-29 00:51:34.098455
680	1	1818	2025-06-29 00:51:34.102845	2025-06-29 00:51:34.102845
681	19	1819	2025-06-29 00:51:34.105671	2025-06-29 00:51:34.105671
682	1	1820	2025-06-29 00:51:34.109721	2025-06-29 00:51:34.109721
683	9	1821	2025-06-29 00:51:34.114189	2025-06-29 00:51:34.114189
684	1	1822	2025-06-29 00:51:34.117967	2025-06-29 00:51:34.117967
685	1	1823	2025-06-29 00:51:34.122696	2025-06-29 00:51:34.122696
686	19	1824	2025-06-29 00:51:34.127244	2025-06-29 00:51:34.127244
687	24	1825	2025-06-29 00:51:34.130834	2025-06-29 00:51:34.130834
688	56	1826	2025-06-29 00:51:34.134934	2025-06-29 00:51:34.134934
689	23	1827	2025-06-29 00:51:34.138999	2025-06-29 00:51:34.138999
690	1	1828	2025-06-29 00:51:34.142494	2025-06-29 00:51:34.142494
691	20	1829	2025-06-29 00:51:34.147956	2025-06-29 00:51:34.147956
692	1	1830	2025-06-29 00:51:34.15285	2025-06-29 00:51:34.15285
693	1	1831	2025-06-29 00:51:34.158722	2025-06-29 00:51:34.158722
694	3	1832	2025-06-29 00:51:34.163188	2025-06-29 00:51:34.163188
695	47	1833	2025-06-29 00:51:34.167646	2025-06-29 00:51:34.167646
696	6	1834	2025-06-29 00:51:34.171992	2025-06-29 00:51:34.171992
697	1	1835	2025-06-29 00:51:34.17635	2025-06-29 00:51:34.17635
698	1	1836	2025-06-29 00:51:34.180833	2025-06-29 00:51:34.180833
699	19	1837	2025-06-29 00:51:34.186372	2025-06-29 00:51:34.186372
700	1	1838	2025-06-29 00:51:34.191119	2025-06-29 00:51:34.191119
701	17	1839	2025-06-29 00:51:34.195874	2025-06-29 00:51:34.195874
702	19	1840	2025-06-29 00:51:34.200565	2025-06-29 00:51:34.200565
703	1	1841	2025-06-29 00:51:34.207032	2025-06-29 00:51:34.207032
704	52	1842	2025-06-29 00:51:34.211982	2025-06-29 00:51:34.211982
705	3	1843	2025-06-29 00:51:34.21775	2025-06-29 00:51:34.21775
706	57	1844	2025-06-29 00:51:34.222518	2025-06-29 00:51:34.222518
707	1	1845	2025-06-29 00:51:34.227184	2025-06-29 00:51:34.227184
708	1	1846	2025-06-29 00:51:34.231476	2025-06-29 00:51:34.231476
709	19	1847	2025-06-29 00:51:34.235847	2025-06-29 00:51:34.235847
710	24	1848	2025-06-29 00:51:34.241322	2025-06-29 00:51:34.241322
711	1	1849	2025-06-29 00:51:34.245676	2025-06-29 00:51:34.245676
712	2	1850	2025-06-29 00:51:34.24931	2025-06-29 00:51:34.24931
713	2	1851	2025-06-29 00:51:34.252444	2025-06-29 00:51:34.252444
714	2	1852	2025-06-29 00:51:34.255184	2025-06-29 00:51:34.255184
715	2	1853	2025-06-29 00:51:34.258705	2025-06-29 00:51:34.258705
716	2	1854	2025-06-29 00:51:34.261709	2025-06-29 00:51:34.261709
717	1	1855	2025-06-29 00:51:34.266003	2025-06-29 00:51:34.266003
718	55	1856	2025-06-29 00:51:34.270135	2025-06-29 00:51:34.270135
719	1	1857	2025-06-29 00:51:34.274525	2025-06-29 00:51:34.274525
720	6	1858	2025-06-29 00:51:34.278713	2025-06-29 00:51:34.278713
721	1	1859	2025-06-29 00:51:34.283266	2025-06-29 00:51:34.283266
722	1	1860	2025-06-29 00:51:34.287078	2025-06-29 00:51:34.287078
723	1	1861	2025-06-29 00:51:34.291191	2025-06-29 00:51:34.291191
724	9	1862	2025-06-29 00:51:34.295258	2025-06-29 00:51:34.295258
725	4	1863	2025-06-29 00:51:34.299401	2025-06-29 00:51:34.299401
726	2	1864	2025-06-29 00:51:34.303457	2025-06-29 00:51:34.303457
727	58	1865	2025-06-29 00:51:34.307732	2025-06-29 00:51:34.307732
728	58	1866	2025-06-29 00:51:34.312047	2025-06-29 00:51:34.312047
729	58	1867	2025-06-29 00:51:34.316362	2025-06-29 00:51:34.316362
730	9	1868	2025-06-29 00:51:34.321228	2025-06-29 00:51:34.321228
731	3	1869	2025-06-29 00:51:34.325509	2025-06-29 00:51:34.325509
732	1	1870	2025-06-29 00:51:34.329774	2025-06-29 00:51:34.329774
733	1	1871	2025-06-29 00:51:34.334381	2025-06-29 00:51:34.334381
734	1	1872	2025-06-29 00:51:34.339328	2025-06-29 00:51:34.339328
735	23	1873	2025-06-29 00:51:34.344472	2025-06-29 00:51:34.344472
736	56	1874	2025-06-29 00:51:34.348588	2025-06-29 00:51:34.348588
737	56	1875	2025-06-29 00:51:34.352002	2025-06-29 00:51:34.352002
738	24	1876	2025-06-29 00:51:34.355402	2025-06-29 00:51:34.355402
739	1	1877	2025-06-29 00:51:34.35969	2025-06-29 00:51:34.35969
740	53	1878	2025-06-29 00:51:34.364144	2025-06-29 00:51:34.364144
741	9	1879	2025-06-29 00:51:34.370164	2025-06-29 00:51:34.370164
742	59	1880	2025-06-29 00:51:34.374921	2025-06-29 00:51:34.374921
743	55	1881	2025-06-29 00:51:34.378879	2025-06-29 00:51:34.378879
744	6	1882	2025-06-29 00:51:34.383215	2025-06-29 00:51:34.383215
745	3	1883	2025-06-29 00:51:34.387844	2025-06-29 00:51:34.387844
746	19	1884	2025-06-29 00:51:34.390833	2025-06-29 00:51:34.390833
747	60	1885	2025-06-29 00:51:34.395257	2025-06-29 00:51:34.395257
748	61	1886	2025-06-29 00:51:34.401534	2025-06-29 00:51:34.401534
749	3	1887	2025-06-29 00:51:34.405992	2025-06-29 00:51:34.405992
750	60	1888	2025-06-29 00:51:34.409773	2025-06-29 00:51:34.409773
751	3	1889	2025-06-29 00:51:34.413964	2025-06-29 00:51:34.413964
752	62	1890	2025-06-29 00:51:34.418356	2025-06-29 00:51:34.418356
753	1	1891	2025-06-29 00:51:34.425366	2025-06-29 00:51:34.425366
754	63	1892	2025-06-29 00:51:34.429698	2025-06-29 00:51:34.429698
755	1	1893	2025-06-29 00:51:34.43479	2025-06-29 00:51:34.43479
756	3	1894	2025-06-29 00:51:34.43947	2025-06-29 00:51:34.43947
757	8	1895	2025-06-29 00:51:34.44403	2025-06-29 00:51:34.44403
758	1	1896	2025-06-29 00:51:34.448728	2025-06-29 00:51:34.448728
759	64	1897	2025-06-29 00:51:34.453021	2025-06-29 00:51:34.453021
760	1	1898	2025-06-29 00:51:34.457672	2025-06-29 00:51:34.457672
761	65	1899	2025-06-29 00:51:34.462511	2025-06-29 00:51:34.462511
762	60	1900	2025-06-29 00:51:34.466907	2025-06-29 00:51:34.466907
763	60	1901	2025-06-29 00:51:34.473689	2025-06-29 00:51:34.473689
764	1	1902	2025-06-29 00:51:34.479332	2025-06-29 00:51:34.479332
765	1	1903	2025-06-29 00:51:34.483706	2025-06-29 00:51:34.483706
766	66	1904	2025-06-29 00:51:34.487846	2025-06-29 00:51:34.487846
767	66	1905	2025-06-29 00:51:34.492191	2025-06-29 00:51:34.492191
768	1	1906	2025-06-29 00:51:34.496413	2025-06-29 00:51:34.496413
769	17	1907	2025-06-29 00:51:34.500414	2025-06-29 00:51:34.500414
770	1	1908	2025-06-29 00:51:34.504559	2025-06-29 00:51:34.504559
771	67	1909	2025-06-29 00:51:34.508683	2025-06-29 00:51:34.508683
772	1	1910	2025-06-29 00:51:34.51359	2025-06-29 00:51:34.51359
773	60	1911	2025-06-29 00:51:34.517646	2025-06-29 00:51:34.517646
774	1	1912	2025-06-29 00:51:34.521615	2025-06-29 00:51:34.521615
775	68	1913	2025-06-29 00:51:34.526169	2025-06-29 00:51:34.526169
\.


--
-- Data for Name: bands; Type: TABLE DATA; Schema: public; Owner: roberttaylor
--

COPY public.bands (id, name, website, created_at, updated_at) FROM stdin;
1	Dave Matthews Band	http://www.davematthewsband.com	2018-03-24 17:02:16.947125	2018-03-24 17:02:16.947125
2	Dave Matthews & Tim Reynolds	http://www.davematthewsband.com	2018-03-24 17:02:16.930308	2018-03-24 17:02:16.930308
3	Dave Matthews	http://www.davematthewsband.com	2018-03-24 17:02:16.954677	2018-03-24 17:02:16.954677
4	Foo Fighters	http://www.foofighters.com	2018-03-24 17:02:16.961511	2018-03-24 17:02:16.961511
5	Edward Sharpe and the Magnetic Zeros	http://www.edwardsharpeandthemagneticzeros.com	2018-03-24 17:02:16.973146	2018-03-24 17:02:16.973146
6	Dave Matthews and Friends	http://www.davematthewsband.com	2018-03-24 17:02:16.982091	2018-03-24 17:02:16.982091
7	Wide Spread Panic	http://widespreadpanic.com	2018-03-24 17:02:16.990269	2018-03-24 17:02:16.990269
8	The Head and the Heart	http://www.theheadandtheheart.com	2018-03-24 17:02:16.997567	2018-03-24 17:02:16.997567
9	The Avett Brothers	http://www.theavettbrothers.com	2018-03-24 17:02:17.004812	2018-03-24 17:02:17.004812
10	Trey Anastasio	\N	2018-03-24 17:02:17.012672	2018-03-24 17:02:17.012672
11	Chris Thile & Brad Mehldau	\N	2018-04-03 12:59:46.465209	2018-04-03 12:59:46.465209
12	My Morning Jacket	http://www.mymorningjacket.com	2018-05-07 20:30:53.784862	2018-05-07 20:30:53.784862
13	Umphrey's McGee	\N	2018-09-30 19:44:56.81936	2018-09-30 19:44:56.81936
14	Kishi Bashi	\N	2018-09-30 20:29:11.832954	2018-09-30 20:29:11.832954
\.


--
-- Data for Name: poster_slug_redirects; Type: TABLE DATA; Schema: public; Owner: roberttaylor
--

COPY public.poster_slug_redirects (id, old_slug, poster_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: posters; Type: TABLE DATA; Schema: public; Owner: roberttaylor
--

COPY public.posters (id, name, description, release_date, original_price, band_id, venue_id, created_at, updated_at, edition_size, visual_metadata, metadata_version, slug) FROM stdin;
1076	Dave Matthews and Friends - Bryce Jordan Center - 2003	\N	2003-12-12	4000.00	6	146	2018-03-24 16:58:30.460003	2018-03-24 16:59:15.97731	\N	\N	\N	dave-matthews-and-friends-bryce-jordan-center-dave-matthews-and-friends-bryce-jordan-center-2003-2003
1077	Dave Matthews Band - 2004	\N	2004-06-17	4000.00	1	\N	2018-03-24 16:58:33.691313	2018-03-24 16:59:51.697558	\N	\N	\N	dave-matthews-band-dave-matthews-band-2004-2004
1079	Dave Matthews Band - Gorge Amphitheatre - 2004	\N	2004-09-03	4000.00	1	9	2018-03-24 16:58:45.0503	2018-03-24 17:01:49.317948	\N	\N	\N	dave-matthews-band-gorge-amphitheatre-dave-matthews-band-gorge-amphitheatre-2004-2004
1080	Dave Matthews Band - Roseland Theatre - 2005	\N	2005-05-09	4000.00	1	159	2018-03-24 16:58:31.305086	2018-03-24 16:59:25.67669	\N	\N	\N	dave-matthews-band-roseland-theatre-dave-matthews-band-roseland-theatre-2005-2005
1082	Dave Matthews Band - Hollywood Casino Amphitheatre - 2004	\N	2004-06-18	4000.00	1	138	2018-03-24 16:58:36.164043	2018-03-24 17:00:14.746081	\N	\N	\N	dave-matthews-band-hollywood-casino-amphitheatre-dave-matthews-band-hollywood-casino-amphitheatre-2004-2004
1083	Dave Matthews Band - First Niagara Pavilion - 2005	\N	2005-06-04	4000.00	1	78	2018-03-24 16:58:38.211464	2018-03-24 17:00:33.190814	\N	\N	\N	dave-matthews-band-first-niagara-pavilion-dave-matthews-band-first-niagara-pavilion-2005-2005
1084	Dave Matthews Band - Alpine Valley Music Theatre - 2005	\N	2005-07-23	4000.00	1	12	2018-03-24 16:58:31.531886	2018-03-24 16:59:27.599528	\N	\N	\N	dave-matthews-band-alpine-valley-music-theatre-dave-matthews-band-alpine-valley-music-theatre-2005-2005
1085	A Concert to Benefit Bay Area Charities	\N	2004-09-04	1000.00	1	98	2018-03-24 16:58:45.481433	2018-03-24 17:01:53.485628	\N	\N	\N	dave-matthews-band-golden-gate-park-a-concert-to-benefit-bay-area-charities-2004
1086	Dave Matthews Band - Saratoga Springs Performing Arts Center - 2005	\N	2005-07-02	4000.00	1	5	2018-03-24 16:58:37.457126	2018-03-24 17:00:25.749548	\N	\N	\N	dave-matthews-band-saratoga-springs-performing-arts-center-dave-matthews-band-saratoga-springs-performing-arts-center-2005-2005
1087	Dave Matthews Band - BB&T Pavilion - 2005	\N	2005-07-05	4000.00	1	29	2018-03-24 16:58:34.98909	2018-03-24 17:00:04.694898	\N	\N	\N	dave-matthews-band-bb-t-pavilion-dave-matthews-band-bb-t-pavilion-2005-2005
1088	Dave Matthews Band - Xfinity Center - 2005	\N	2005-07-09	4000.00	1	41	2018-03-24 16:58:38.620742	2018-03-24 17:00:41.318551	\N	\N	\N	dave-matthews-band-xfinity-center-dave-matthews-band-xfinity-center-2005-2005
1089	Dave Matthews Band - Randalls Island - 2005	\N	2005-07-30	4000.00	1	42	2018-03-24 16:58:37.596602	2018-03-24 17:00:27.031435	\N	\N	\N	dave-matthews-band-randalls-island-dave-matthews-band-randalls-island-2005-2005
1090	Dave Matthews Band - Lakewood Amphitheatre - 2005	\N	2005-07-13	4000.00	1	54	2018-03-24 16:58:32.338949	2018-03-24 16:59:35.879202	\N	\N	\N	dave-matthews-band-lakewood-amphitheatre-dave-matthews-band-lakewood-amphitheatre-2005-2005
1091	Dave Matthews Band - AT&T Park - 2005	\N	2005-08-13	4000.00	1	151	2018-03-24 16:58:31.337629	2018-03-24 16:59:25.876828	\N	\N	\N	dave-matthews-band-at-t-park-dave-matthews-band-at-t-park-2005-2005
1092	Dave Matthews Band - Gorge Amphitheatre - 2005	\N	2005-08-19	4000.00	1	9	2018-03-24 16:58:33.565249	2018-03-24 16:59:50.047929	\N	\N	\N	dave-matthews-band-gorge-amphitheatre-dave-matthews-band-gorge-amphitheatre-2005-2005
1093	Dave Matthews Band - Cynthia Woods Mitchell Pavilion - 2005	\N	2005-09-05	4000.00	1	2	2018-03-24 16:58:44.777808	2018-03-24 17:01:46.408118	\N	\N	\N	dave-matthews-band-cynthia-woods-mitchell-pavilion-dave-matthews-band-cynthia-woods-mitchell-pavilion-2005-2005
1094	Dave Matthews Band - CenturyLink Center Omaha - 2005	\N	2005-11-27	4000.00	1	67	2018-03-24 16:58:36.538567	2018-03-24 17:00:18.062083	\N	\N	\N	dave-matthews-band-centurylink-center-omaha-dave-matthews-band-centurylink-center-omaha-2005-2005
1095	Dave Matthews Band - Joe Louis Arena - 2005	\N	2005-12-03	4000.00	1	149	2018-03-24 16:58:32.713676	2018-03-24 16:59:40.421031	400	\N	\N	dave-matthews-band-joe-louis-arena-dave-matthews-band-joe-louis-arena-2005-2005
1096	Dave Matthews Band - TD Garden - 2005	\N	2005-12-15	4000.00	1	20	2018-03-24 16:58:29.926904	2018-03-24 16:59:08.883125	\N	\N	\N	dave-matthews-band-td-garden-dave-matthews-band-td-garden-2005-2005
1097	Dave Matthews and Friends - Caribean Cruise - 2006	\N	2006-02-03	4000.00	6	145	2018-03-24 16:58:43.027579	2018-03-24 17:01:30.347169	1100	\N	\N	dave-matthews-and-friends-caribean-cruise-dave-matthews-and-friends-caribean-cruise-2006-2006
1098	Dave Matthews Band - Bryce Jordan Center - 2005	\N	2005-12-06	4000.00	1	146	2018-03-24 16:58:33.533758	2018-03-24 16:59:49.67063	400	\N	\N	dave-matthews-band-bryce-jordan-center-dave-matthews-band-bryce-jordan-center-2005-2005
1099	Dave Matthews Band - Jiffy Lube Live - 2005	\N	2005-06-28	4000.00	1	33	2018-03-24 16:58:32.426871	2018-03-24 16:59:37.041498	\N	\N	\N	dave-matthews-band-jiffy-lube-live-dave-matthews-band-jiffy-lube-live-2005-2005
1100	Dave Matthews Band - Cricket Wireless Amphitheatre - 2006	\N	2006-05-31	4000.00	1	116	2018-03-24 16:58:37.788988	2018-03-24 17:00:28.977796	\N	\N	\N	dave-matthews-band-cricket-wireless-amphitheatre-dave-matthews-band-cricket-wireless-amphitheatre-2006-2006
1101	Dave Matthews - Manchester Academy - 2006	\N	2006-05-12	4000.00	3	21	2018-03-24 16:58:29.083801	2018-03-24 16:58:55.176246	\N	\N	\N	dave-matthews-manchester-academy-dave-matthews-manchester-academy-2006-2006
1102	Dave Matthews Band - Jiffy Lube Live - 2006	\N	2006-06-24	4000.00	1	33	2018-03-24 16:58:35.015152	2018-03-24 17:00:04.826486	\N	\N	\N	dave-matthews-band-jiffy-lube-live-dave-matthews-band-jiffy-lube-live-2006-2006
1103	Dave Matthews Band - Veterans United Home Loans Amphitheatre - 2006	\N	2006-07-04	4000.00	1	11	2018-03-24 16:58:29.594235	2018-03-24 16:59:02.151028	\N	\N	\N	dave-matthews-band-veterans-united-home-loans-amphitheatre-dave-matthews-band-veterans-united-home-loans-amphitheatre-2006-2006
1104	Dave Matthews Band - Alpine Valley Music Theatre - 2006		2006-07-01	4000.00	1	12	2018-03-24 16:58:32.485477	2018-07-23 02:22:00.861627	900	\N	\N	dave-matthews-band-alpine-valley-music-theatre-dave-matthews-band-alpine-valley-music-theatre-2006-2006
1105	Dave Matthews Band - Perfect Vodka Amphitheatre - 2006	\N	2006-08-11	4000.00	1	17	2018-03-24 16:58:43.884439	2018-03-24 17:01:37.683211	\N	\N	\N	dave-matthews-band-perfect-vodka-amphitheatre-dave-matthews-band-perfect-vodka-amphitheatre-2006-2006
1106	Dave Matthews Band - Lakewood Amphitheatre - 2006	\N	2006-08-15	4000.00	1	54	2018-03-24 16:58:37.842284	2018-03-24 17:00:29.511901	\N	\N	\N	dave-matthews-band-lakewood-amphitheatre-dave-matthews-band-lakewood-amphitheatre-2006-2006
1107	Dave Matthews Band - Randalls Island - 2006	\N	2006-08-05	4000.00	1	42	2018-03-24 16:58:36.009191	2018-03-24 17:00:12.786722	\N	\N	\N	dave-matthews-band-randalls-island-dave-matthews-band-randalls-island-2006-2006
1108	Dave Matthews Band - Pepsi Center - 2006	\N	2006-09-12	4000.00	1	139	2018-03-24 16:58:34.139887	2018-03-24 16:59:55.807672	\N	\N	\N	dave-matthews-band-pepsi-center-dave-matthews-band-pepsi-center-2006-2006
1110	Dave Matthews Band - Germain Amphitheatre - 2006	\N	2006-06-07	4000.00	1	142	2018-03-24 16:58:32.368433	2018-03-24 16:59:36.564165	\N	\N	\N	dave-matthews-band-germain-amphitheatre-dave-matthews-band-germain-amphitheatre-2006-2006
1111	Dave Matthews Band - Cynthia Woods Mitchell Pavilion - 2006	\N	2006-08-16	4000.00	1	2	2018-03-24 16:58:34.171662	2018-03-24 16:59:55.927365	\N	\N	\N	dave-matthews-band-cynthia-woods-mitchell-pavilion-dave-matthews-band-cynthia-woods-mitchell-pavilion-2006-2006
1112	Dave Matthews Band - USANA Amphitheater - 2006	\N	2006-08-30	4000.00	1	19	2018-03-24 16:58:39.587012	2018-03-24 17:00:50.367666	\N	\N	\N	dave-matthews-band-usana-amphitheater-dave-matthews-band-usana-amphitheater-2006-2006
1113	Dave Matthews Band - Budweiser Stage - 2006	\N	2006-06-13	4000.00	1	4	2018-03-24 16:58:36.081888	2018-03-24 17:00:13.674566	\N	\N	\N	dave-matthews-band-budweiser-stage-dave-matthews-band-budweiser-stage-2006-2006
1114	Dave Matthews Band - Hollywood Casino Amphitheatre - 2006	\N	2006-09-15	4000.00	1	138	2018-03-24 16:58:37.762228	2018-03-24 17:00:28.781517	\N	\N	\N	dave-matthews-band-hollywood-casino-amphitheatre-dave-matthews-band-hollywood-casino-amphitheatre-2006-2006
1115	Dave Matthews Band - Starwood Amphitheatre - 2006	\N	2006-08-16	4000.00	1	144	2018-03-24 16:58:30.669428	2018-03-24 16:59:18.163384	\N	\N	\N	dave-matthews-band-starwood-amphitheatre-dave-matthews-band-starwood-amphitheatre-2006-2006
1116	Dave Matthews Band - Gorge Amphitheatre - 2006	\N	2006-09-01	4000.00	1	9	2018-03-24 16:58:38.041154	2018-03-24 17:00:31.445643	\N	\N	\N	dave-matthews-band-gorge-amphitheatre-dave-matthews-band-gorge-amphitheatre-2006-2006
1117	Dave Matthews Band - Newcastle City Hall - 2007	\N	2007-02-23	4000.00	1	175	2018-03-24 16:58:36.244706	2018-03-24 17:00:15.580315	150	\N	\N	dave-matthews-band-newcastle-city-hall-dave-matthews-band-newcastle-city-hall-2007-2007
1118	Dave Matthews & Tim Reynolds - Santa Barbara Bowl - 2006	\N	2006-10-28	4000.00	2	173	2018-03-24 16:58:30.700874	2018-03-24 16:59:19.175269	800	\N	\N	dave-matthews-tim-reynolds-santa-barbara-bowl-dave-matthews-tim-reynolds-santa-barbara-bowl-2006-2006
1119	Dave Matthews & Tim Reynolds - Citi Performing Arts Center - 2007	\N	2007-04-20	4000.00	2	150	2018-03-24 16:58:44.254668	2018-03-24 17:01:41.27647	500	\N	\N	dave-matthews-tim-reynolds-citi-performing-arts-center-dave-matthews-tim-reynolds-citi-performing-arts-center-2007-2007
1120	Dave Matthews Band - 2007	\N	2007-05-31	4000.00	1	\N	2018-03-24 16:58:29.67832	2018-03-24 16:59:03.129908	\N	\N	\N	dave-matthews-band-dave-matthews-band-2007-2007
1121	Dave Matthews Band - Alpine Valley Music Theatre - 2007	\N	2007-08-25	4000.00	1	12	2018-03-24 16:58:37.960172	2018-03-24 17:00:30.453735	\N	\N	\N	dave-matthews-band-alpine-valley-music-theatre-dave-matthews-band-alpine-valley-music-theatre-2007-2007
1122	Dave Matthews Band - DTE Energy Music Theatre - 2007	\N	2007-08-23	4000.00	1	55	2018-03-24 16:58:35.0469	2018-03-24 17:00:05.145913	\N	\N	\N	dave-matthews-band-dte-energy-music-theatre-dave-matthews-band-dte-energy-music-theatre-2007-2007
1123	Dave Matthews Band - First Niagara Pavilion - 2007	\N	2007-08-10	4000.00	1	78	2018-03-24 16:58:30.727126	2018-03-24 16:59:19.501488	\N	\N	\N	dave-matthews-band-first-niagara-pavilion-dave-matthews-band-first-niagara-pavilion-2007-2007
1124	Dave Matthews Band - Xfinity Center - 2007	\N	2007-08-01	4000.00	1	41	2018-03-24 16:58:36.135142	2018-03-24 17:00:14.107303	\N	\N	\N	dave-matthews-band-xfinity-center-dave-matthews-band-xfinity-center-2007-2007
1125	Dave Matthews Band - Blossom Music Center - 2007	\N	2007-08-20	4000.00	1	39	2018-03-24 16:58:29.409957	2018-03-24 16:58:58.761719	\N	\N	\N	dave-matthews-band-blossom-music-center-dave-matthews-band-blossom-music-center-2007-2007
1126	Dave Matthews Band - Toyota Park - 2008	\N	2008-07-08	4000.00	1	104	2018-03-24 16:58:40.643161	2018-03-24 17:01:01.943355	\N	\N	\N	dave-matthews-band-toyota-park-dave-matthews-band-toyota-park-2008-2008
1127	Dave Matthews Band - Perfect Vodka Amphitheatre - 2007	\N	2007-09-14	4000.00	1	17	2018-03-24 16:58:34.245573	2018-03-24 16:59:56.229946	\N	\N	\N	dave-matthews-band-perfect-vodka-amphitheatre-dave-matthews-band-perfect-vodka-amphitheatre-2007-2007
1128	Dave Matthews Band - Cynthia Woods Mitchell Pavilion - 2007	\N	2007-09-21	4000.00	1	2	2018-03-24 16:58:42.608073	2018-03-24 17:01:26.13679	\N	\N	\N	dave-matthews-band-cynthia-woods-mitchell-pavilion-dave-matthews-band-cynthia-woods-mitchell-pavilion-2007-2007
1129	Dave Matthews Band - 2007	\N	2007-11-14	4000.00	1	\N	2018-03-24 16:58:30.489101	2018-03-24 16:59:16.369166	\N	\N	\N	dave-matthews-band-dave-matthews-band-2007-2007-1
1130	Dave Matthews Band - 2007	\N	2007-08-22	4000.00	1	\N	2018-03-24 16:58:46.087179	2018-03-24 17:01:58.560656	\N	\N	\N	dave-matthews-band-dave-matthews-band-2007-2007-2
1131	Dave Matthews Band - Gorge Amphitheatre - 2007	\N	2007-08-31	4000.00	1	9	2018-03-24 16:58:32.454021	2018-03-24 16:59:37.499628	\N	\N	\N	dave-matthews-band-gorge-amphitheatre-dave-matthews-band-gorge-amphitheatre-2007-2007
1132	Dave Matthews Band - First Niagara Pavilion - 2008	\N	2008-05-30	4000.00	1	78	2018-03-24 16:58:34.278133	2018-03-24 16:59:56.496381	\N	\N	\N	dave-matthews-band-first-niagara-pavilion-dave-matthews-band-first-niagara-pavilion-2008-2008
1133	Dave Matthews Band - First Niagara Pavilion - 2008	\N	2008-05-31	4000.00	1	78	2018-03-24 16:58:34.307465	2018-03-24 16:59:56.754786	\N	\N	\N	dave-matthews-band-first-niagara-pavilion-dave-matthews-band-first-niagara-pavilion-2008-2008-1
1134	Dave Matthews Band - BB&T Pavilion - 2008	\N	2008-06-03	4000.00	1	29	2018-03-24 16:58:45.687884	2018-03-24 17:01:56.446939	\N	\N	\N	dave-matthews-band-bb-t-pavilion-dave-matthews-band-bb-t-pavilion-2008-2008
1136	Dave Matthews Band - BB&T Pavilion - 2008	\N	2008-06-04	4000.00	1	29	2018-03-24 16:58:30.789543	2018-03-24 16:59:20.621509	\N	\N	\N	dave-matthews-band-bb-t-pavilion-dave-matthews-band-bb-t-pavilion-2008-2008-1
1137	Dave Matthews Band - DTE Energy Music Theatre - 2008	\N	2008-06-09	4000.00	1	55	2018-03-24 16:58:30.824133	2018-03-24 16:59:20.8754	\N	\N	\N	dave-matthews-band-dte-energy-music-theatre-dave-matthews-band-dte-energy-music-theatre-2008-2008
1138	Dave Matthews Band - Toyota Park - 2008	\N	2008-06-06	4000.00	1	104	2018-03-24 16:58:44.718952	2018-03-24 17:01:45.864751	\N	\N	\N	dave-matthews-band-toyota-park-dave-matthews-band-toyota-park-2008-2008-1
1139	Dave Matthews Band - Busch Stadium - 2008	\N	2008-06-07	4000.00	1	90	2018-03-24 16:58:28.727296	2018-03-24 16:58:53.612521	\N	\N	\N	dave-matthews-band-busch-stadium-dave-matthews-band-busch-stadium-2008-2008
1140	Dave Matthews Band - The Pavilion at Montage Mountain - 2008	\N	2008-06-10	4000.00	1	86	2018-03-24 16:58:33.13551	2018-03-24 16:59:44.521467	\N	\N	\N	dave-matthews-band-the-pavilion-at-montage-mountain-dave-matthews-band-the-pavilion-at-montage-mountain-2008-2008
1141	Dave Matthews Band - XFINITY Theatre - 2008	\N	2008-06-13	4000.00	1	46	2018-03-24 16:58:39.30358	2018-03-24 17:00:46.930652	\N	\N	\N	dave-matthews-band-xfinity-theatre-dave-matthews-band-xfinity-theatre-2008-2008
1142	Dave Matthews Band - XFINITY Theatre - 2008	\N	2008-06-14	4000.00	1	46	2018-03-24 16:58:31.725343	2018-03-24 16:59:30.318086	\N	\N	\N	dave-matthews-band-xfinity-theatre-dave-matthews-band-xfinity-theatre-2008-2008-1
1143	Dave Matthews Band - Darien Lake Performing Arts Center - 2008	\N	2008-06-17	4000.00	1	76	2018-03-24 16:58:34.336591	2018-03-24 16:59:57.004887	\N	\N	\N	dave-matthews-band-darien-lake-performing-arts-center-dave-matthews-band-darien-lake-performing-arts-center-2008-2008
1144	Dave Matthews Band - Saratoga Springs Performing Arts Center - 2008	\N	2008-06-20	4000.00	1	5	2018-03-24 16:58:46.533797	2018-03-24 17:02:03.937845	\N	\N	\N	dave-matthews-band-saratoga-springs-performing-arts-center-dave-matthews-band-saratoga-springs-performing-arts-center-2008-2008
1145	Dave Matthews Band - Xfinity Center - 2008	\N	2008-06-24	4000.00	1	41	2018-03-24 16:58:34.030115	2018-03-24 16:59:54.479314	\N	\N	\N	dave-matthews-band-xfinity-center-dave-matthews-band-xfinity-center-2008-2008
1146	Dave Matthews Band - Saratoga Springs Performing Arts Center - 2008	\N	2008-06-21	4000.00	1	5	2018-03-24 16:58:28.946436	2018-03-24 16:58:53.966979	\N	\N	\N	dave-matthews-band-saratoga-springs-performing-arts-center-dave-matthews-band-saratoga-springs-performing-arts-center-2008-2008-1
1147	Dave Matthews Band - 2008	\N	2008-06-25	4000.00	1	\N	2018-03-24 16:58:43.810847	2018-03-24 17:01:36.871766	\N	\N	\N	dave-matthews-band-dave-matthews-band-2008-2008
1148	Dave Matthews Band - Jiffy Lube Live - 2008		2008-06-28	4000.00	1	33	2018-03-24 16:58:33.715316	2021-08-23 11:57:08.725154	\N	\N	\N	dave-matthews-band-jiffy-lube-live-dave-matthews-band-jiffy-lube-live-2008-2008
1149	Dave Matthews Band - Hershey Park Stadium - 2008		2008-06-27	4000.00	1	79	2018-03-24 16:58:34.371585	2018-06-24 02:18:20.526385	700	\N	\N	dave-matthews-band-hershey-park-stadium-dave-matthews-band-hershey-park-stadium-2008-2008
1150	Dave Matthews Band - Coastal Credit Union Music Park - 2008	\N	2008-07-02	4000.00	1	105	2018-03-24 16:58:40.426072	2018-03-24 17:00:59.463615	\N	\N	\N	dave-matthews-band-coastal-credit-union-music-park-dave-matthews-band-coastal-credit-union-music-park-2008-2008
1151	Dave Matthews Band - Budweiser Stage - 2008	\N	2008-06-18	4000.00	1	4	2018-03-24 16:58:30.897229	2018-03-24 16:59:21.411728	\N	\N	\N	dave-matthews-band-budweiser-stage-dave-matthews-band-budweiser-stage-2008-2008
1152	Dave Matthews Band - Perfect Vodka Amphitheatre - 2008	\N	2008-07-11	4000.00	1	17	2018-03-24 16:58:36.509459	2018-03-24 17:00:17.919376	\N	\N	\N	dave-matthews-band-perfect-vodka-amphitheatre-dave-matthews-band-perfect-vodka-amphitheatre-2008-2008
1153	Dave Matthews Band - Joseph P. Riley Jr. Park - 2008	\N	2008-07-04	4000.00	1	37	2018-03-24 16:58:32.625784	2018-03-24 16:59:39.297632	\N	\N	\N	dave-matthews-band-joseph-p-riley-jr-park-dave-matthews-band-joseph-p-riley-jr-park-2008-2008
1154	Dave Matthews Band - PNC Music Pavillion - 2008	\N	2008-07-01	4000.00	1	1	2018-03-24 16:58:43.730898	2018-03-24 17:01:35.888469	\N	\N	\N	dave-matthews-band-pnc-music-pavillion-dave-matthews-band-pnc-music-pavillion-2008-2008
1155	Dave Matthews Band - Lakewood Amphitheatre - 2008	\N	2008-07-07	4000.00	1	54	2018-03-24 16:58:39.357631	2018-03-24 17:00:47.634716	\N	\N	\N	dave-matthews-band-lakewood-amphitheatre-dave-matthews-band-lakewood-amphitheatre-2008-2008
1156	Dave Matthews Band - Perfect Vodka Amphitheatre - 2008	\N	2008-07-12	4000.00	1	17	2018-03-24 16:58:41.732292	2018-03-24 17:01:14.923945	\N	\N	\N	dave-matthews-band-perfect-vodka-amphitheatre-dave-matthews-band-perfect-vodka-amphitheatre-2008-2008-1
1157	Dave Matthews Band - Dick's Sporting Goods Park - 2008	\N	2008-07-20	4000.00	1	140	2018-03-24 16:58:30.984228	2018-03-24 16:59:22.29659	\N	\N	\N	dave-matthews-band-dick-s-sporting-goods-park-dave-matthews-band-dick-s-sporting-goods-park-2008-2008
1158	Dave Matthews Band - Ruoff Home Mortgage Music Center - 2008	\N	2008-07-25	4000.00	1	16	2018-03-24 16:58:33.872457	2018-03-24 16:59:53.023181	\N	\N	\N	dave-matthews-band-ruoff-home-mortgage-music-center-dave-matthews-band-ruoff-home-mortgage-music-center-2008-2008
1159	Dave Matthews Band - CenturyLink Center Omaha - 2008	\N	2008-07-22	4000.00	1	67	2018-03-24 16:58:38.530667	2018-03-24 17:00:39.019139	425	\N	\N	dave-matthews-band-centurylink-center-omaha-dave-matthews-band-centurylink-center-omaha-2008-2008
1160	Dave Matthews Band - Ruoff Home Mortgage Music Center - 2008	\N	2008-07-26	4000.00	1	16	2018-03-24 16:58:31.816367	2018-03-24 16:59:31.30389	\N	\N	\N	dave-matthews-band-ruoff-home-mortgage-music-center-dave-matthews-band-ruoff-home-mortgage-music-center-2008-2008-1
1161	Dave Matthews Band - Mapfre Stadium - 2008	\N	2008-07-29	4000.00	1	69	2018-03-24 16:58:38.398921	2018-03-24 17:00:37.67782	350	\N	\N	dave-matthews-band-mapfre-stadium-dave-matthews-band-mapfre-stadium-2008-2008
1162	Dave Matthews Band - Blossom Music Center - 2008	\N	2008-07-30	4000.00	1	39	2018-03-24 16:58:32.573181	2018-03-24 16:59:38.589057	350	\N	\N	dave-matthews-band-blossom-music-center-dave-matthews-band-blossom-music-center-2008-2008
1163	Dave Matthews Band - Riverbend Music Center - 2008	\N	2008-08-05	4000.00	1	44	2018-03-24 16:58:31.69671	2018-03-24 16:59:30.024582	350	\N	\N	dave-matthews-band-riverbend-music-center-dave-matthews-band-riverbend-music-center-2008-2008
1164	Dave Matthews Band - 2008	\N	2008-08-01	4000.00	1	\N	2018-03-24 16:58:31.119359	2018-03-24 16:59:23.986974	\N	\N	\N	dave-matthews-band-dave-matthews-band-2008-2008-1
1165	Dave Matthews Band - 2008	\N	2008-08-02	4000.00	1	\N	2018-03-24 16:58:32.68989	2018-03-24 16:59:40.140082	\N	\N	\N	dave-matthews-band-dave-matthews-band-2008-2008-2
1166	Dave Matthews Band - 2008	\N	2008-07-07	4000.00	1	\N	2018-03-24 16:58:31.035884	2018-03-24 16:59:22.767433	\N	\N	\N	dave-matthews-band-dave-matthews-band-2008-2008-3
1167	Dave Matthews Band - Alpine Valley Music Theatre - 2008	\N	2008-08-10	4000.00	1	12	2018-03-24 16:58:37.900601	2018-03-24 17:00:30.020848	\N	\N	\N	dave-matthews-band-alpine-valley-music-theatre-dave-matthews-band-alpine-valley-music-theatre-2008-2008
1168	Dave Matthews Band - Alpine Valley Music Theatre - 2008	\N	2008-08-09	4000.00	1	12	2018-03-24 16:58:44.80884	2018-04-16 11:49:17.674164	940	\N	\N	dave-matthews-band-alpine-valley-music-theatre-dave-matthews-band-alpine-valley-music-theatre-2008-2008-1
1169	Dave Matthews Band - Chickasaw Bricktown Ballpark - 2008	\N	2008-08-13	4000.00	1	136	2018-03-24 16:58:32.747142	2018-03-24 16:59:40.697504	\N	\N	\N	dave-matthews-band-chickasaw-bricktown-ballpark-dave-matthews-band-chickasaw-bricktown-ballpark-2008-2008
1170	Dave Matthews Band - Gexa Energy Pavilion - 2008		2008-08-16	4000.00	1	66	2018-03-24 16:58:31.009674	2018-07-04 17:55:11.746896	\N	\N	\N	dave-matthews-band-gexa-energy-pavilion-dave-matthews-band-gexa-energy-pavilion-2008-2008
1171	Dave Matthews Band - Staples Center - 2008	\N	2008-08-19	4000.00	1	122	2018-03-24 16:58:37.514711	2018-03-24 17:00:26.450448	\N	\N	\N	dave-matthews-band-staples-center-dave-matthews-band-staples-center-2008-2008
1172	Dave Matthews Band - Staples Center - 2008	\N	2008-08-20	4000.00	1	122	2018-03-24 16:58:34.217269	2018-03-24 16:59:56.101907	\N	\N	\N	dave-matthews-band-staples-center-dave-matthews-band-staples-center-2008-2008-1
1173	Dave Matthews Band - Cynthia Woods Mitchell Pavilion - 2008	\N	2008-08-15	4000.00	1	2	2018-03-24 16:58:39.979311	2018-03-24 17:00:54.206072	\N	\N	\N	dave-matthews-band-cynthia-woods-mitchell-pavilion-dave-matthews-band-cynthia-woods-mitchell-pavilion-2008-2008
1175	Dave Matthews Band - Raley Field - 2008	\N	2008-08-25	4000.00	1	132	2018-03-24 16:58:32.806183	2018-03-24 16:59:41.544053	\N	\N	\N	dave-matthews-band-raley-field-dave-matthews-band-raley-field-2008-2008
1176	Dave Matthews Band - Sleep Train Amphitheatre - 2008		2008-08-22	4000.00	1	61	2018-03-24 16:58:36.216685	2018-07-04 17:57:09.759369	\N	\N	\N	dave-matthews-band-sleep-train-amphitheatre-dave-matthews-band-sleep-train-amphitheatre-2008-2008
1177	Dave Matthews Band - Gorge Amphitheatre - 2008	\N	2008-08-29	4000.00	1	9	2018-03-24 16:58:35.657619	2018-03-24 17:00:11.343995	\N	\N	\N	dave-matthews-band-gorge-amphitheatre-dave-matthews-band-gorge-amphitheatre-2008-2008
1178	Dave Matthews Band - Greek Theatre - 2008	\N	2008-10-07	4000.00	1	13	2018-03-24 16:58:33.767823	2018-03-24 16:59:52.341112	\N	\N	\N	dave-matthews-band-greek-theatre-dave-matthews-band-greek-theatre-2008-2008
1179	Dave Matthews Band - Greek Theatre - 2008	\N	2008-09-05	4000.00	1	13	2018-03-24 16:58:40.983326	2018-03-24 17:01:05.485691	\N	\N	\N	dave-matthews-band-greek-theatre-dave-matthews-band-greek-theatre-2008-2008-1
1180	Dave Matthews Band - Madison Square Garden - 2008	\N	2008-09-10	4000.00	1	23	2018-03-24 16:58:31.088878	2018-03-24 16:59:23.582757	\N	\N	\N	dave-matthews-band-madison-square-garden-dave-matthews-band-madison-square-garden-2008-2008
1181	Dave Matthews Band - USANA Amphitheater - 2008	\N	2008-08-27	4000.00	1	19	2018-03-24 16:58:33.971559	2018-03-24 16:59:53.864514	\N	\N	\N	dave-matthews-band-usana-amphitheater-dave-matthews-band-usana-amphitheater-2008-2008
1182	Last Chance for Change	\N	2008-10-26	4000.00	1	172	2018-03-24 16:58:37.729928	2018-03-24 17:00:28.628244	590	\N	\N	dave-matthews-band-verizon-wireless-arena-at-vcu-last-chance-for-change-2008
1183	Dave Matthews Band - Gorge Amphitheatre - 2008	\N	2008-08-31	4000.00	1	9	2018-03-24 16:58:41.121509	2018-03-24 17:01:06.999065	\N	\N	\N	dave-matthews-band-gorge-amphitheatre-dave-matthews-band-gorge-amphitheatre-2008-2008-1
1184	Dave Matthews Band - Gorge Amphitheatre - 2008	\N	2008-08-30	4000.00	1	9	2018-03-24 16:58:37.933199	2018-03-24 17:00:30.239318	\N	\N	\N	dave-matthews-band-gorge-amphitheatre-dave-matthews-band-gorge-amphitheatre-2008-2008-2
1185	Dave Matthews Band - 2008	\N	2008-12-15	4000.00	1	\N	2018-03-24 16:58:35.791442	2018-03-24 17:00:12.604661	\N	\N	\N	dave-matthews-band-dave-matthews-band-2008-2008-4
1186	Dave Matthews Band - 2008	\N	2008-12-15	4000.00	1	\N	2018-03-24 16:58:36.383616	2018-03-24 17:00:16.915215	325	\N	\N	dave-matthews-band-dave-matthews-band-2008-2008-5
1187	Dave Matthews Band - Izod Center - 2009	\N	2009-04-15	4000.00	1	25	2018-03-24 16:58:34.460368	2018-03-24 16:59:58.414889	\N	\N	\N	dave-matthews-band-izod-center-dave-matthews-band-izod-center-2009-2009
1188	Dave Matthews Band - Madison Square Garden - 2009	\N	2009-04-14	4000.00	1	23	2018-03-24 16:58:32.899782	2018-03-24 16:59:42.44755	\N	\N	\N	dave-matthews-band-madison-square-garden-dave-matthews-band-madison-square-garden-2009-2009
1189	Dave Matthews Band - John Paul Jones Arena - 2009	\N	2009-04-17	4000.00	1	30	2018-03-24 16:58:39.493828	2018-03-24 17:00:49.457395	\N	\N	\N	dave-matthews-band-john-paul-jones-arena-dave-matthews-band-john-paul-jones-arena-2009-2009
1190	Dave Matthews Band - John Paul Jones Arena - 2009	\N	2009-04-18	4000.00	1	30	2018-03-24 16:58:34.488904	2018-03-24 16:59:59.232508	\N	\N	\N	dave-matthews-band-john-paul-jones-arena-dave-matthews-band-john-paul-jones-arena-2009-2009-1
1191	Dave Matthews Band - Oak Mountain Amphitheatre - 2009	\N	2009-04-20	4000.00	1	56	2018-03-24 16:58:36.406767	2018-03-24 17:00:17.126095	\N	\N	\N	dave-matthews-band-oak-mountain-amphitheatre-dave-matthews-band-oak-mountain-amphitheatre-2009-2009
1192	Dave Matthews Band - Coastal Credit Union Music Park - 2009	\N	2009-04-22	4000.00	1	105	2018-03-24 16:58:32.931335	2018-03-24 16:59:42.786855	\N	\N	\N	dave-matthews-band-coastal-credit-union-music-park-dave-matthews-band-coastal-credit-union-music-park-2009-2009
1193	Dave Matthews Band - Verizon Wireless Amphitheatre at Encore Park - 2009	\N	2009-04-08	4000.00	1	24	2018-03-24 16:58:28.669508	2018-03-24 16:58:52.765523	\N	\N	\N	dave-matthews-band-verizon-wireless-amphitheatre-at-encore-park-dave-matthews-band-verizon-wireless-amphitheatre-at-encore-park-2009-2009
1194	Dave Matthews Band - PNC Music Pavillion - 2009	\N	2009-04-24	4000.00	1	1	2018-03-24 16:58:34.519283	2018-03-24 16:59:59.499013	\N	\N	\N	dave-matthews-band-pnc-music-pavillion-dave-matthews-band-pnc-music-pavillion-2009-2009
1195	Dave Matthews Band - Gexa Energy Pavilion - 2009	\N	2009-05-02	4000.00	1	66	2018-03-24 16:58:38.016177	2018-03-24 17:00:31.257733	\N	\N	\N	dave-matthews-band-gexa-energy-pavilion-dave-matthews-band-gexa-energy-pavilion-2009-2009
1196	Dave Matthews Band - Verizon Wireless Amphitheatre at Encore Park - 2009	\N	2009-04-29	4000.00	1	24	2018-03-24 16:58:34.546621	2018-03-24 16:59:59.941628	\N	\N	\N	dave-matthews-band-verizon-wireless-amphitheatre-at-encore-park-dave-matthews-band-verizon-wireless-amphitheatre-at-encore-park-2009-2009-1
1197	Dave Matthews Band - 2009	\N	2009-05-05	4000.00	1	\N	2018-03-24 16:58:31.981842	2018-03-24 16:59:33.496269	\N	\N	\N	dave-matthews-band-dave-matthews-band-2009-2009
1198	Dave Matthews Band - MGM Grand Garden - 2009	\N	2009-05-09	4000.00	1	88	2018-03-24 16:58:30.513713	2018-03-24 16:59:16.820533	\N	\N	\N	dave-matthews-band-mgm-grand-garden-dave-matthews-band-mgm-grand-garden-2009-2009
1199	Dave Matthews Band - 2009	\N	2009-05-08	4000.00	1	\N	2018-03-24 16:58:39.443296	2018-03-24 17:00:48.591463	\N	\N	\N	dave-matthews-band-dave-matthews-band-2009-2009-1
1200	Dave Matthews Band - Vanderbilt Stadium - 2009	\N	2009-04-25	4000.00	1	125	2018-03-24 16:58:34.577008	2018-03-24 17:00:00.327638	\N	\N	\N	dave-matthews-band-vanderbilt-stadium-dave-matthews-band-vanderbilt-stadium-2009-2009
1201	Dave Matthews Band - Cynthia Woods Mitchell Pavilion - 2009	\N	2009-05-01	4000.00	1	2	2018-03-24 16:58:38.066632	2018-03-24 17:00:31.684207	\N	\N	\N	dave-matthews-band-cynthia-woods-mitchell-pavilion-dave-matthews-band-cynthia-woods-mitchell-pavilion-2009-2009
1202	Dave Matthews Band - Darien Lake Performing Arts Center - 2009	\N	2009-05-27	4000.00	1	76	2018-03-24 16:58:34.642741	2018-03-24 17:00:00.91273	\N	\N	\N	dave-matthews-band-darien-lake-performing-arts-center-dave-matthews-band-darien-lake-performing-arts-center-2009-2009
1203	Dave Matthews Band - Fenway Park - 2009	\N	2009-05-29	4000.00	1	57	2018-03-24 16:58:38.09395	2018-03-24 17:00:32.294272	\N	\N	\N	dave-matthews-band-fenway-park-dave-matthews-band-fenway-park-2009-2009
1204	Dave Matthews Band - Fenway Park - 2009	\N	2009-05-30	4000.00	1	57	2018-03-24 16:58:35.076579	2018-03-24 17:00:05.441271	\N	\N	\N	dave-matthews-band-fenway-park-dave-matthews-band-fenway-park-2009-2009-1
1205	Dave Matthews Band - XFINITY Theatre - 2009	\N	2009-06-06	4000.00	1	46	2018-03-24 16:58:29.042186	2018-03-24 16:58:54.963895	\N	\N	\N	dave-matthews-band-xfinity-theatre-dave-matthews-band-xfinity-theatre-2009-2009
1206	Dave Matthews Band - Parc Jean-Drapeau - 2009	\N	2009-06-10	4000.00	1	6	2018-03-24 16:58:38.125039	2018-03-24 17:00:32.517576	\N	\N	\N	dave-matthews-band-parc-jean-drapeau-dave-matthews-band-parc-jean-drapeau-2009-2009
1207	Dave Matthews Band - Saratoga Springs Performing Arts Center - 2009	\N	2009-07-12	4000.00	1	5	2018-03-24 16:58:34.675749	2018-03-24 17:00:01.2533	\N	\N	\N	dave-matthews-band-saratoga-springs-performing-arts-center-dave-matthews-band-saratoga-springs-performing-arts-center-2009-2009
1208	Dave Matthews Band - XFINITY Theatre - 2009	\N	2009-06-05	4000.00	1	46	2018-03-24 16:58:32.972675	2018-03-24 16:59:43.095893	\N	\N	\N	dave-matthews-band-xfinity-theatre-dave-matthews-band-xfinity-theatre-2009-2009-1
1209	Dave Matthews Band - Saratoga Springs Performing Arts Center - 2009	\N	2009-06-13	4000.00	1	5	2018-03-24 16:58:36.432951	2018-03-24 17:00:17.311865	\N	\N	\N	dave-matthews-band-saratoga-springs-performing-arts-center-dave-matthews-band-saratoga-springs-performing-arts-center-2009-2009-1
1210	Dave Matthews Band - Ak-Chin Pavilion - 2009	\N	2009-05-06	4000.00	1	103	2018-03-24 16:58:31.148911	2018-03-24 16:59:24.381115	\N	\N	\N	dave-matthews-band-ak-chin-pavilion-dave-matthews-band-ak-chin-pavilion-2009-2009
1211	Dave Matthews Band - Hollywood Casino Amphitheatre - 2009	\N	2009-06-17	4000.00	1	71	2018-03-24 16:58:36.458019	2018-03-24 17:00:17.537488	\N	\N	\N	dave-matthews-band-hollywood-casino-amphitheatre-dave-matthews-band-hollywood-casino-amphitheatre-2009-2009
1212	Dave Matthews Band - Riverbend Music Center - 2009	\N	2009-06-16	4000.00	1	44	2018-03-24 16:58:40.614263	2018-03-24 17:01:01.629384	\N	\N	\N	dave-matthews-band-riverbend-music-center-dave-matthews-band-riverbend-music-center-2009-2009
1213	Dave Matthews Band - First Niagara Pavilion - 2009	\N	2009-06-20	4000.00	1	78	2018-03-24 16:58:38.150804	2018-03-24 17:00:32.671625	\N	\N	\N	dave-matthews-band-first-niagara-pavilion-dave-matthews-band-first-niagara-pavilion-2009-2009
1214	Dave Matthews Band - Budweiser Stage - 2009	\N	2009-06-09	4000.00	1	4	2018-03-24 16:58:42.940247	2018-03-24 17:01:29.550434	\N	\N	\N	dave-matthews-band-budweiser-stage-dave-matthews-band-budweiser-stage-2009-2009
1215	Dave Matthews Band - Brixton Academy - 2009	\N	2009-06-25	4000.00	1	27	2018-03-24 16:58:45.304862	2018-03-24 17:01:51.040187	\N	\N	\N	dave-matthews-band-brixton-academy-dave-matthews-band-brixton-academy-2009-2009
1216	Dave Matthews Band - Brixton Academy - 2009	\N	2009-06-26	4000.00	1	27	2018-03-24 16:58:29.568487	2018-03-24 16:59:01.938992	\N	\N	\N	dave-matthews-band-brixton-academy-dave-matthews-band-brixton-academy-2009-2009-1
1217	Dave Matthews Band - Wolverhampton Civic Hall - 2009	\N	2009-06-29	4000.00	1	50	2018-03-24 16:58:33.01163	2018-03-24 16:59:43.446967	\N	\N	\N	dave-matthews-band-wolverhampton-civic-hall-dave-matthews-band-wolverhampton-civic-hall-2009-2009
1218	Dave Matthews Band - AFAS Live - 2009	\N	2009-07-07	4000.00	1	22	2018-03-24 16:58:34.732914	2018-03-24 17:00:01.790567	\N	\N	\N	dave-matthews-band-afas-live-dave-matthews-band-afas-live-2009-2009
1219	Dave Matthews Band - First Niagara Pavilion - 2009	\N	2009-07-19	4000.00	1	78	2018-03-24 16:58:36.484134	2018-03-24 17:00:17.756436	\N	\N	\N	dave-matthews-band-first-niagara-pavilion-dave-matthews-band-first-niagara-pavilion-2009-2009-1
1220	Dave Matthews Band - Piazza Napoleone - 2009	\N	2009-07-05	4000.00	1	143	2018-03-24 16:58:39.521161	2018-03-24 17:00:49.914103	\N	\N	\N	dave-matthews-band-piazza-napoleone-dave-matthews-band-piazza-napoleone-2009-2009
1221	Dave Matthews Band - Olympia Bruno Coquatrix - 2009	\N	2009-07-01	4000.00	1	26	2018-03-24 16:58:28.409727	2018-03-24 16:58:52.416097	\N	\N	\N	dave-matthews-band-olympia-bruno-coquatrix-dave-matthews-band-olympia-bruno-coquatrix-2009-2009
1222	Dave Matthews Band - Alpine Valley Music Theatre - 2009	\N	2009-07-18	4000.00	1	12	2018-03-24 16:58:37.681583	2018-03-24 17:00:27.778101	\N	\N	\N	dave-matthews-band-alpine-valley-music-theatre-dave-matthews-band-alpine-valley-music-theatre-2009-2009
1223	Dave Matthews Band - Alpine Valley Music Theatre - 2009	\N	2009-07-18	4000.00	1	12	2018-03-24 16:58:33.045867	2018-03-24 16:59:43.67587	\N	\N	\N	dave-matthews-band-alpine-valley-music-theatre-dave-matthews-band-alpine-valley-music-theatre-2009-2009-1
1224	Dave Matthews Band - Hershey Park Stadium - 2008	\N	2008-07-24	4000.00	1	79	2018-03-24 16:58:35.414565	2018-03-24 17:00:09.140471	\N	\N	\N	dave-matthews-band-hershey-park-stadium-dave-matthews-band-hershey-park-stadium-2008-2008-1
1225	Dave Matthews Band - Nikon at Jones Beach Theater - 2009	\N	2009-07-21	4000.00	1	14	2018-03-24 16:58:33.074055	2018-03-24 16:59:43.964387	\N	\N	\N	dave-matthews-band-nikon-at-jones-beach-theater-dave-matthews-band-nikon-at-jones-beach-theater-2009-2009
1226	Dave Matthews Band - Nikon at Jones Beach Theater - 2009	\N	2009-07-22	4000.00	1	14	2018-03-24 16:58:31.198245	2018-03-24 16:59:24.698759	\N	\N	\N	dave-matthews-band-nikon-at-jones-beach-theater-dave-matthews-band-nikon-at-jones-beach-theater-2009-2009-1
1227	Dave Matthews Band - Ruoff Home Mortgage Music Center - 2009	\N	2009-07-31	4000.00	1	16	2018-03-24 16:58:37.321089	2018-03-24 17:00:24.727267	\N	\N	\N	dave-matthews-band-ruoff-home-mortgage-music-center-dave-matthews-band-ruoff-home-mortgage-music-center-2009-2009
1228	Dave Matthews Band - 10,000 Lakes Festival - 2009	\N	2009-07-25	4000.00	1	123	2018-03-24 16:58:34.760004	2018-03-24 17:00:02.155577	\N	\N	\N	dave-matthews-band-10-000-lakes-festival-dave-matthews-band-10-000-lakes-festival-2009-2009
1229	Dave Matthews Band - NBT Bank Stadium - 2008	\N	2008-04-09	4000.00	1	114	2018-03-24 16:58:32.777627	2018-03-24 16:59:41.275816	\N	\N	\N	dave-matthews-band-nbt-bank-stadium-dave-matthews-band-nbt-bank-stadium-2008-2008
1230	Dave Matthews Band - 2009	\N	2009-03-07	4000.00	1	\N	2018-03-24 16:58:42.709769	2018-03-24 17:01:27.239583	\N	\N	\N	dave-matthews-band-dave-matthews-band-2009-2009-2
1231	Dave Matthews Band - Blossom Music Center - 2009	\N	2009-07-29	4000.00	1	39	2018-03-24 16:58:31.0605	2018-03-24 16:59:23.277646	\N	\N	\N	dave-matthews-band-blossom-music-center-dave-matthews-band-blossom-music-center-2009-2009
1232	Dave Matthews Band - Bethel Woods Center for the Arts - 2009	\N	2009-08-05	4000.00	1	97	2018-03-24 16:58:36.190519	2018-03-24 17:00:15.016987	\N	\N	\N	dave-matthews-band-bethel-woods-center-for-the-arts-dave-matthews-band-bethel-woods-center-for-the-arts-2009-2009
1233	Dave Matthews Band - DTE Energy Music Theatre - 2009	\N	2009-07-28	4000.00	1	55	2018-03-24 16:58:34.821265	2018-03-24 17:00:02.68863	\N	\N	\N	dave-matthews-band-dte-energy-music-theatre-dave-matthews-band-dte-energy-music-theatre-2009-2009
1234	Dave Matthews Band - MidFlorida Credit Union Amphitheatre - 2009	\N	2009-08-12	4000.00	1	43	2018-03-24 16:58:39.412957	2018-03-24 17:00:48.328223	\N	\N	\N	dave-matthews-band-midflorida-credit-union-amphitheatre-dave-matthews-band-midflorida-credit-union-amphitheatre-2009-2009
1235	Dave Matthews Band - Perfect Vodka Amphitheatre - 2009	\N	2009-08-14	4000.00	1	17	2018-03-24 16:58:31.561657	2018-03-24 16:59:27.898817	\N	\N	\N	dave-matthews-band-perfect-vodka-amphitheatre-dave-matthews-band-perfect-vodka-amphitheatre-2009-2009
1236	Dave Matthews Band - Perfect Vodka Amphitheatre - 2009	\N	2009-08-15	4000.00	1	17	2018-03-24 16:58:36.596592	2018-03-24 17:00:18.605034	\N	\N	\N	dave-matthews-band-perfect-vodka-amphitheatre-dave-matthews-band-perfect-vodka-amphitheatre-2009-2009-1
1237	Dave Matthews Band - Ruoff Home Mortgage Music Center - 2009	\N	2009-08-01	4000.00	1	16	2018-03-24 16:58:43.34969	2018-03-24 17:01:31.855822	\N	\N	\N	dave-matthews-band-ruoff-home-mortgage-music-center-dave-matthews-band-ruoff-home-mortgage-music-center-2009-2009-1
1238	Dave Matthews Band - Gorge Amphitheatre - 2009	\N	2009-09-04	4000.00	1	9	2018-03-24 16:58:42.525809	2018-03-24 17:01:25.244892	\N	\N	\N	dave-matthews-band-gorge-amphitheatre-dave-matthews-band-gorge-amphitheatre-2009-2009
1239	Dave Matthews Band - Gorge Amphitheatre - 2009	\N	2009-09-05	4000.00	1	9	2018-03-24 16:58:42.734389	2018-03-24 17:01:27.430907	\N	\N	\N	dave-matthews-band-gorge-amphitheatre-dave-matthews-band-gorge-amphitheatre-2009-2009-1
1240	Dave Matthews Band - Gorge Amphitheatre - 2009		2009-09-06	4000.00	1	9	2018-03-24 16:58:44.869634	2018-05-21 00:28:51.573129	1100	\N	\N	dave-matthews-band-gorge-amphitheatre-dave-matthews-band-gorge-amphitheatre-2009-2009-2
1241	Dave Matthews Band - Golden Gate Park - 2009	\N	2009-08-29	4000.00	1	98	2018-03-24 16:58:35.69313	2018-03-24 17:00:11.624709	\N	\N	\N	dave-matthews-band-golden-gate-park-dave-matthews-band-golden-gate-park-2009-2009
1242	Dave Matthews Band - Greek Theatre - 2009	\N	2009-09-09	4000.00	1	59	2018-03-24 16:58:40.714756	2018-03-24 17:01:02.485025	\N	\N	\N	dave-matthews-band-greek-theatre-dave-matthews-band-greek-theatre-2009-2009
1243	Dave Matthews Band - Greek Theatre - 2009	\N	2009-09-10	4000.00	1	59	2018-03-24 16:58:34.882922	2018-03-24 17:00:03.175973	\N	\N	\N	dave-matthews-band-greek-theatre-dave-matthews-band-greek-theatre-2009-2009-1
1244	Dave Matthews Band - Save Mart Center - 2009	\N	2009-08-30	4000.00	1	102	2018-03-24 16:58:31.271139	2018-03-24 16:59:25.254324	\N	\N	\N	dave-matthews-band-save-mart-center-dave-matthews-band-save-mart-center-2009-2009
1245	Dave Matthews Band - BB&T Pavilion - 2009	\N	2009-09-20	4000.00	1	29	2018-03-24 16:58:44.928493	2018-03-24 17:01:47.91764	\N	\N	\N	dave-matthews-band-bb-t-pavilion-dave-matthews-band-bb-t-pavilion-2009-2009
1246	Dave Matthews Band - Hollywood Casino Amphitheatre - 2009	\N	2009-09-26	4000.00	1	138	2018-03-24 16:58:34.915442	2018-03-24 17:00:03.380647	\N	\N	\N	dave-matthews-band-hollywood-casino-amphitheatre-dave-matthews-band-hollywood-casino-amphitheatre-2009-2009-1
1247	Dave Matthews Band - The Pavilion at Montage Mountain - 2009	\N	2009-09-23	4000.00	1	86	2018-03-24 16:58:34.961847	2018-03-24 17:00:04.273602	\N	\N	\N	dave-matthews-band-the-pavilion-at-montage-mountain-dave-matthews-band-the-pavilion-at-montage-mountain-2009-2009
1248	Dave Matthews Band - BB&T Pavilion - 2009	\N	2009-09-19	4000.00	1	29	2018-03-24 16:58:39.5578	2018-03-24 17:00:50.184059	\N	\N	\N	dave-matthews-band-bb-t-pavilion-dave-matthews-band-bb-t-pavilion-2009-2009-1
1249	Dave Matthews Band - Sprint Center - 2009		2009-09-30	4000.00	1	100	2018-03-24 16:58:32.060525	2018-05-12 15:27:51.243154	550	\N	\N	dave-matthews-band-sprint-center-dave-matthews-band-sprint-center-2009-2009
1250	Dave Matthews Band - Principal Park - 2009	\N	2009-09-25	4000.00	1	95	2018-03-24 16:58:36.054289	2018-03-24 17:00:13.135289	\N	\N	\N	dave-matthews-band-principal-park-dave-matthews-band-principal-park-2009-2009
1251	Dave Matthews Band - USANA Amphitheater - 2009	\N	2009-09-01	4000.00	1	19	2018-03-24 16:58:29.150428	2018-03-24 16:58:56.06436	\N	\N	\N	dave-matthews-band-usana-amphitheater-dave-matthews-band-usana-amphitheater-2009-2009
1252	Dave Matthews Band - Zilker Park - 2009	\N	2009-10-03	4000.00	1	10	2018-03-24 16:58:42.412274	2018-04-26 00:43:09.292521	500	\N	\N	dave-matthews-band-zilker-park-dave-matthews-band-zilker-park-2009-2009
1253	Dave Matthews Band - BOK Center - 2009	\N	2009-10-02	4000.00	1	73	2018-03-24 16:58:36.107911	2018-03-24 17:00:13.893412	\N	\N	\N	dave-matthews-band-bok-center-dave-matthews-band-bok-center-2009-2009
1254	Dave Matthews Band - Dickey-Stephens Park - 2009	\N	2009-09-29	4000.00	1	162	2018-03-24 16:58:32.54679	2018-03-24 16:59:38.365288	\N	\N	\N	dave-matthews-band-dickey-stephens-park-dave-matthews-band-dickey-stephens-park-2009-2009
1255	Dave Matthews Band - Coco Cay - 2009	\N	2009-10-25	4000.00	1	28	2018-03-24 16:58:36.272099	2018-03-24 17:00:15.808315	\N	\N	\N	dave-matthews-band-coco-cay-dave-matthews-band-coco-cay-2009-2009
1257	Dave Matthews Band - Coco Cay - 2009	\N	2009-10-25	4000.00	1	28	2018-03-24 16:58:43.499526	2018-03-24 17:01:33.404718	\N	\N	\N	dave-matthews-band-coco-cay-dave-matthews-band-coco-cay-2009-2009-1
1262	Dave Matthews & Tim Reynolds - Planet Hollywood Resort & Casino - 2009	\N	2009-12-10	4000.00	2	35	2018-03-24 16:58:40.304827	2018-03-24 17:00:58.463262	\N	\N	\N	dave-matthews-tim-reynolds-planet-hollywood-resort-casino-dave-matthews-tim-reynolds-planet-hollywood-resort-casino-2009-2009
1263	Dave Matthews & Tim Reynolds - Planet Hollywood Resort & Casino - 2009	\N	2009-12-11	4000.00	2	35	2018-03-24 16:58:34.792092	2018-03-24 17:00:02.404134	\N	\N	\N	dave-matthews-tim-reynolds-planet-hollywood-resort-casino-dave-matthews-tim-reynolds-planet-hollywood-resort-casino-2009-2009-1
1264	Dave Matthews & Tim Reynolds - Planet Hollywood Resort & Casino - 2009	\N	2009-12-12	4000.00	2	35	2018-03-24 16:58:40.005249	2018-03-24 17:00:54.437513	\N	\N	\N	dave-matthews-tim-reynolds-planet-hollywood-resort-casino-dave-matthews-tim-reynolds-planet-hollywood-resort-casino-2009-2009-2
1265	Dave Matthews Band - Tempodrom - 2010	\N	2010-02-17	4000.00	1	117	2018-03-24 16:58:36.567473	2018-03-24 17:00:18.397256	\N	\N	\N	dave-matthews-band-tempodrom-dave-matthews-band-tempodrom-2010-2010
1266	Dave Matthews Band - Gasometer - 2010	\N	2010-02-19	4000.00	1	152	2018-03-24 16:58:33.105272	2018-03-24 16:59:44.207882	\N	\N	\N	dave-matthews-band-gasometer-dave-matthews-band-gasometer-2010-2010
1268	Dave Matthews Band - Zenith - 2010	\N	2010-02-20	4000.00	1	166	2018-03-24 16:58:35.759967	2018-03-24 17:00:12.203821	\N	\N	\N	dave-matthews-band-zenith-dave-matthews-band-zenith-2010-2010
1269	Dave Matthews Band - Palatrussadri - 2010	\N	2010-02-22	4000.00	1	110	2018-03-24 16:58:31.233457	2018-03-24 16:59:24.966135	\N	\N	\N	dave-matthews-band-palatrussadri-dave-matthews-band-palatrussadri-2010-2010
1270	Dave Matthews Band - PalaLottomatica - 2010	\N	2010-02-23	4000.00	1	164	2018-03-24 16:58:37.626932	2018-03-24 17:00:27.238491	\N	\N	\N	dave-matthews-band-palalottomatica-dave-matthews-band-palalottomatica-2010-2010
1271	Dave Matthews Band - Palladium Cologne - 2010	\N	2010-02-28	4000.00	1	156	2018-03-24 16:58:39.655727	2018-03-24 17:00:50.897696	\N	\N	\N	dave-matthews-band-palladium-cologne-dave-matthews-band-palladium-cologne-2010-2010
1272	Dave Matthews Band - Falkoner Center - 2010	\N	2010-02-14	4000.00	1	153	2018-03-24 16:58:34.704392	2018-03-24 17:00:01.555449	\N	\N	\N	dave-matthews-band-falkoner-center-dave-matthews-band-falkoner-center-2010-2010
1273	Dave Matthews Band - Arenan - 2010	\N	2010-02-13	4000.00	1	47	2018-03-24 16:58:28.980638	2018-03-24 16:58:54.184106	\N	\N	\N	dave-matthews-band-arenan-dave-matthews-band-arenan-2010-2010
1274	Dave Matthews Band - Kioene Arena - 2010	\N	2010-02-25	4000.00	1	121	2018-03-24 16:58:36.684575	2018-03-24 17:00:19.328516	\N	\N	\N	dave-matthews-band-kioene-arena-dave-matthews-band-kioene-arena-2010-2010
1275	Dave Matthews Band - Congress Center Hamburg Hall 1 - 2010	\N	2010-02-16	4000.00	1	148	2018-03-24 16:58:35.145086	2018-03-24 17:00:06.420746	\N	\N	\N	dave-matthews-band-congress-center-hamburg-hall-1-dave-matthews-band-congress-center-hamburg-hall-1-2010-2010
1276	Dave Matthews Band - Lotto Arena - 2010	\N	2010-01-03	4000.00	1	126	2018-03-24 16:58:31.37532	2018-03-24 16:59:26.248295	\N	\N	\N	dave-matthews-band-lotto-arena-dave-matthews-band-lotto-arena-2010-2010
1277	Dave Matthews Band - AFAS Live - 2010	\N	2010-03-30	4000.00	1	22	2018-03-24 16:58:29.223503	2018-03-24 16:58:56.601768	\N	\N	\N	dave-matthews-band-afas-live-dave-matthews-band-afas-live-2010-2010
1278	Dave Matthews Band - Jahrhunderthalle - 2010	\N	2010-04-03	4000.00	1	120	2018-03-24 16:58:38.64779	2018-03-24 17:00:41.659147	\N	\N	\N	dave-matthews-band-jahrhunderthalle-dave-matthews-band-jahrhunderthalle-2010-2010
1279	Dave Matthews Band - Irvine Meadows Amphitheatre - 2009	\N	2009-09-13	4000.00	1	96	2018-03-24 16:58:33.165728	2018-03-24 16:59:44.868168	\N	\N	\N	dave-matthews-band-irvine-meadows-amphitheatre-dave-matthews-band-irvine-meadows-amphitheatre-2009-2009
1280	Dave Matthews Band - Scottish Exhibition and Conference Centre - 2010	\N	2010-11-03	4000.00	1	158	2018-03-24 16:58:35.17758	2018-03-24 17:00:06.720274	\N	\N	\N	dave-matthews-band-scottish-exhibition-and-conference-centre-dave-matthews-band-scottish-exhibition-and-conference-centre-2010-2010
1281	Dave Matthews Band - Apollo Theatre - 2010	\N	2010-07-03	4000.00	1	48	2018-03-24 16:58:29.255285	2018-03-24 16:58:56.896326	\N	\N	\N	dave-matthews-band-apollo-theatre-dave-matthews-band-apollo-theatre-2010-2010
1282	Dave Matthews Band - Sleep Train Amphitheatre - 2009	\N	2009-09-12	4000.00	1	61	2018-03-24 16:58:39.330877	2018-03-24 17:00:47.282989	\N	\N	\N	dave-matthews-band-sleep-train-amphitheatre-dave-matthews-band-sleep-train-amphitheatre-2009-2009
1283	Dave Matthews Band - The O2 Arena - 2010	\N	2010-06-03	4000.00	1	74	2018-03-24 16:58:44.663713	2018-03-24 17:01:45.465225	\N	\N	\N	dave-matthews-band-the-o2-arena-dave-matthews-band-the-o2-arena-2010-2010
1284	Dave Matthews Band - 3Arena - 2010	\N	2010-09-03	4000.00	1	130	2018-03-24 16:58:35.210972	2018-03-24 17:00:06.980031	\N	\N	\N	dave-matthews-band-3arena-dave-matthews-band-3arena-2010-2010
1285	Dave Matthews Band - O2 Academy Birmingham - 2010	\N	2010-12-03	4000.00	1	141	2018-03-24 16:58:33.234933	2018-03-24 16:59:45.145356	\N	\N	\N	dave-matthews-band-o2-academy-birmingham-dave-matthews-band-o2-academy-birmingham-2010-2010
1286	A Benefit For The Jane Goodall Institute	\N	2010-05-20	4000.00	2	165	2018-03-24 16:58:38.263881	2018-03-24 17:00:33.851772	\N	\N	\N	dave-matthews-tim-reynolds-dar-constitution-hall-a-benefit-for-the-jane-goodall-institute-2010
1287	Dave Matthews Band - XFINITY Theatre - 2010	\N	2010-05-28	4000.00	1	46	2018-03-24 16:58:43.985413	2018-03-24 17:01:38.590548	\N	\N	\N	dave-matthews-band-xfinity-theatre-dave-matthews-band-xfinity-theatre-2010-2010
1288	Dave Matthews Band - Saratoga Springs Performing Arts Center - 2010	\N	2010-06-04	4000.00	1	5	2018-03-24 16:58:31.408706	2018-03-24 16:59:26.497716	\N	\N	\N	dave-matthews-band-saratoga-springs-performing-arts-center-dave-matthews-band-saratoga-springs-performing-arts-center-2010-2010
1289	Dave Matthews Band - Budweiser Stage - 2010	\N	2010-06-01	4000.00	1	4	2018-03-24 16:58:33.268278	2018-04-06 22:37:07.032993	475	\N	\N	dave-matthews-band-budweiser-stage-dave-matthews-band-budweiser-stage-2010-2010
1290	Dave Matthews Band - XFINITY Theatre - 2010	\N	2010-05-29	4000.00	1	46	2018-03-24 16:58:39.684356	2018-03-24 17:00:51.098796	\N	\N	\N	dave-matthews-band-xfinity-theatre-dave-matthews-band-xfinity-theatre-2010-2010-1
1291	Dave Matthews Band - Saratoga Springs Performing Arts Center - 2010	\N	2010-06-05	4000.00	1	5	2018-03-24 16:58:35.531996	2018-03-24 17:00:10.338769	\N	\N	\N	dave-matthews-band-saratoga-springs-performing-arts-center-dave-matthews-band-saratoga-springs-performing-arts-center-2010-2010-1
1292	Dave Matthews Band - 2010	\N	2010-06-02	4000.00	1	\N	2018-03-24 16:58:33.81625	2018-03-24 16:59:52.567524	\N	\N	\N	dave-matthews-band-dave-matthews-band-2010-2010
1293	Dave Matthews Band - Xfinity Center - 2010	\N	2010-06-07	4000.00	1	41	2018-03-24 16:58:38.289491	2018-03-24 17:00:35.185479	\N	\N	\N	dave-matthews-band-xfinity-center-dave-matthews-band-xfinity-center-2010-2010
1294	Dave Matthews Band - Hollywood Casino Amphitheatre - 2010	\N	2010-06-16	4000.00	1	71	2018-03-24 16:58:42.76025	2018-03-24 17:01:27.823982	\N	\N	\N	dave-matthews-band-hollywood-casino-amphitheatre-dave-matthews-band-hollywood-casino-amphitheatre-2010-2010
1295	Dave Matthews Band - Xfinity Center - 2010	\N	2010-06-08	4000.00	1	41	2018-03-24 16:58:35.239252	2018-03-24 17:00:07.407099	\N	\N	\N	dave-matthews-band-xfinity-center-dave-matthews-band-xfinity-center-2010-2010-1
1296	Dave Matthews Band - Riverbend Music Center - 2010	\N	2010-06-15	4000.00	1	44	2018-03-24 16:58:40.745309	2018-06-02 16:51:04.290189	\N	\N	\N	dave-matthews-band-riverbend-music-center-dave-matthews-band-riverbend-music-center-2010-2010
1297	Dave Matthews Band - Bonnaroo Arts & Music Festival - 2010	\N	2010-06-13	4000.00	1	163	2018-03-24 16:58:32.66152	2018-03-24 16:59:39.945804	\N	\N	\N	dave-matthews-band-bonnaroo-arts-music-festival-dave-matthews-band-bonnaroo-arts-music-festival-2010-2010
1298	Dave Matthews Band - DTE Energy Music Theatre - 2010	\N	2010-06-23	4000.00	1	55	2018-03-24 16:58:36.624537	2018-03-24 17:00:18.81718	\N	\N	\N	dave-matthews-band-dte-energy-music-theatre-dave-matthews-band-dte-energy-music-theatre-2010-2010
1299	Dave Matthews Band - Ruoff Home Mortgage Music Center - 2010	\N	2010-06-19	4000.00	1	16	2018-03-24 16:58:31.441538	2018-03-24 16:59:26.777264	\N	\N	\N	dave-matthews-band-ruoff-home-mortgage-music-center-dave-matthews-band-ruoff-home-mortgage-music-center-2010-2010
1300	Dave Matthews Band - Ruoff Home Mortgage Music Center - 2010	\N	2010-06-18	4000.00	1	16	2018-03-24 16:58:39.746083	2018-03-24 17:00:51.862816	\N	\N	\N	dave-matthews-band-ruoff-home-mortgage-music-center-dave-matthews-band-ruoff-home-mortgage-music-center-2010-2010-1
1301	Dave Matthews Band - Huntington Park - 2010	\N	2010-06-22	4000.00	1	171	2018-03-24 16:58:34.853742	2018-03-24 17:00:02.912175	\N	\N	\N	dave-matthews-band-huntington-park-dave-matthews-band-huntington-park-2010-2010
1302	Dave Matthews Band - Blossom Music Center - 2010	\N	2010-06-25	4000.00	1	39	2018-03-24 16:58:45.088573	2018-03-24 17:01:49.519603	\N	\N	\N	dave-matthews-band-blossom-music-center-dave-matthews-band-blossom-music-center-2010-2010
1303	Dave Matthews Band - BB&T Pavilion - 2010	\N	2010-07-01	4000.00	1	29	2018-03-24 16:58:42.81288	2018-03-24 17:01:28.396248	\N	\N	\N	dave-matthews-band-bb-t-pavilion-dave-matthews-band-bb-t-pavilion-2010-2010
1304	Dave Matthews Band - BB&T Pavilion - 2010	\N	2010-06-30	4000.00	1	29	2018-03-24 16:58:29.284521	2018-03-24 16:58:57.412351	\N	\N	\N	dave-matthews-band-bb-t-pavilion-dave-matthews-band-bb-t-pavilion-2010-2010-1
1305	Dave Matthews Band - Alpine Valley Music Theatre - 2010	\N	2010-07-03	4000.00	1	12	2018-03-24 16:58:35.266597	2018-03-24 17:00:07.611597	\N	\N	\N	dave-matthews-band-alpine-valley-music-theatre-dave-matthews-band-alpine-valley-music-theatre-2010-2010
1306	Dave Matthews Band - Alpine Valley Music Theatre - 2010	\N	2010-07-04	4000.00	1	12	2018-03-24 16:58:39.772373	2018-03-24 17:00:52.119288	\N	\N	\N	dave-matthews-band-alpine-valley-music-theatre-dave-matthews-band-alpine-valley-music-theatre-2010-2010-1
1307	Dave Matthews Band - Hershey Park Stadium - 2010	\N	2010-07-09	4000.00	1	79	2018-03-24 16:58:45.864619	2018-03-24 17:01:58.176287	\N	\N	\N	dave-matthews-band-hershey-park-stadium-dave-matthews-band-hershey-park-stadium-2010-2010
1308	Dave Matthews Band - PNC Park - 2010	\N	2010-07-10	4000.00	1	99	2018-03-24 16:58:32.399665	2018-03-24 16:59:36.826679	\N	\N	\N	dave-matthews-band-pnc-park-dave-matthews-band-pnc-park-2010-2010
1309	Dave Matthews Band - Bethel Woods Center for the Arts - 2010	\N	2010-07-13	4000.00	1	97	2018-03-24 16:58:32.515782	2018-03-24 16:59:38.039745	\N	\N	\N	dave-matthews-band-bethel-woods-center-for-the-arts-dave-matthews-band-bethel-woods-center-for-the-arts-2010-2010
1310	Dave Matthews & Tim Reynolds - CMAC - 2010	\N	2010-07-06	4000.00	2	82	2018-03-24 16:58:33.330511	2018-03-24 16:59:47.574841	\N	\N	\N	dave-matthews-tim-reynolds-cmac-dave-matthews-tim-reynolds-cmac-2010-2010
1311	Dave Matthews Band - Citi Field - 2010	\N	2010-07-17	4000.00	1	65	2018-03-24 16:58:36.710323	2018-03-24 17:00:19.582055	\N	\N	\N	dave-matthews-band-citi-field-dave-matthews-band-citi-field-2010-2010
1312	Dave Matthews Band - Citi Field - 2010	\N	2010-07-16	4000.00	1	65	2018-03-24 16:58:39.799236	2018-03-24 17:00:52.359226	\N	\N	\N	dave-matthews-band-citi-field-dave-matthews-band-citi-field-2010-2010-1
1313	Dave Matthews Band - The Pavilion at Montage Mountain - 2010	\N	2010-07-14	4000.00	1	86	2018-03-24 16:58:31.475716	2018-03-24 16:59:27.108505	\N	\N	\N	dave-matthews-band-the-pavilion-at-montage-mountain-dave-matthews-band-the-pavilion-at-montage-mountain-2010-2010
1314	Dave Matthews Band - Veterans United Home Loans Amphitheatre - 2010	\N	2010-07-20	4000.00	1	11	2018-03-24 16:58:33.401069	2018-03-24 16:59:48.206681	\N	\N	\N	dave-matthews-band-veterans-united-home-loans-amphitheatre-dave-matthews-band-veterans-united-home-loans-amphitheatre-2010-2010
1315	Dave Matthews Band - PNC Music Pavillion - 2010	\N	2010-07-21	4000.00	1	1	2018-03-24 16:58:42.839756	2018-03-24 17:01:28.781095	\N	\N	\N	dave-matthews-band-pnc-music-pavillion-dave-matthews-band-pnc-music-pavillion-2010-2010
1316	Dave Matthews Band - Nationals Park - 2010	\N	2010-07-23	4000.00	1	64	2018-03-24 16:58:36.735127	2018-03-24 17:00:19.841529	\N	\N	\N	dave-matthews-band-nationals-park-dave-matthews-band-nationals-park-2010-2010
1317	Dave Matthews Band - Hullabalou Festival - 2010	\N	2010-07-25	4000.00	1	112	2018-03-24 16:58:31.504374	2018-03-24 16:59:27.415042	\N	\N	\N	dave-matthews-band-hullabalou-festival-dave-matthews-band-hullabalou-festival-2010-2010
1318	Dave Matthews Band - Lakewood Amphitheatre - 2010	\N	2010-07-27	4000.00	1	54	2018-03-24 16:58:33.301592	2018-03-24 16:59:47.25619	\N	\N	\N	dave-matthews-band-lakewood-amphitheatre-dave-matthews-band-lakewood-amphitheatre-2010-2010
1319	Dave Matthews Band - MidFlorida Credit Union Amphitheatre - 2010	\N	2010-06-28	4000.00	1	43	2018-03-24 16:58:33.452574	2018-03-24 16:59:48.935719	\N	\N	\N	dave-matthews-band-midflorida-credit-union-amphitheatre-dave-matthews-band-midflorida-credit-union-amphitheatre-2010-2010
1320	Dave Matthews Band - Perfect Vodka Amphitheatre - 2010	\N	2010-07-31	4000.00	1	17	2018-03-24 16:58:42.913904	2018-03-24 17:01:29.305312	\N	\N	\N	dave-matthews-band-perfect-vodka-amphitheatre-dave-matthews-band-perfect-vodka-amphitheatre-2010-2010
1321	Dave Matthews Band - Perfect Vodka Amphitheatre - 2010	\N	2010-07-30	4000.00	1	17	2018-03-24 16:58:44.130702	2018-03-24 17:01:40.109866	\N	\N	\N	dave-matthews-band-perfect-vodka-amphitheatre-dave-matthews-band-perfect-vodka-amphitheatre-2010-2010-1
1322	Dave Matthews Band - Dick's Sporting Goods Park - 2010		2010-08-05	4000.00	1	140	2018-03-24 16:58:35.320969	2018-05-12 15:19:11.001568	550	\N	\N	dave-matthews-band-dick-s-sporting-goods-park-dave-matthews-band-dick-s-sporting-goods-park-2010-2010
1323	Dave Matthews Band - Irvine Meadows Amphitheatre - 2010	\N	2010-08-21	4000.00	1	96	2018-03-24 16:58:36.761804	2018-03-24 17:00:20.096075	\N	\N	\N	dave-matthews-band-irvine-meadows-amphitheatre-dave-matthews-band-irvine-meadows-amphitheatre-2010-2010
1324	Dave Matthews Band - Intrust Bank Arena - 2010	\N	2010-08-14	4000.00	1	53	2018-03-24 16:58:29.113771	2018-03-24 16:58:55.540556	\N	\N	\N	dave-matthews-band-intrust-bank-arena-dave-matthews-band-intrust-bank-arena-2010-2010
1325	Dave Matthews Band - 2010	\N	2010-08-28	4000.00	1	\N	2018-03-24 16:58:30.645246	2018-03-24 16:59:17.958318	\N	\N	\N	dave-matthews-band-dave-matthews-band-2010-2010-1
1326	Dave Matthews Band - Hollywood Bowl - 2010	\N	2010-08-23	4000.00	1	133	2018-03-24 16:58:39.825841	2018-03-24 17:00:52.619591	\N	\N	\N	dave-matthews-band-hollywood-bowl-dave-matthews-band-hollywood-bowl-2010-2010
1327	Dave Matthews Band - Sleep Train Amphitheatre - 2010	\N	2010-08-20	4000.00	1	61	2018-03-24 16:58:29.325451	2018-03-24 16:58:57.773808	\N	\N	\N	dave-matthews-band-sleep-train-amphitheatre-dave-matthews-band-sleep-train-amphitheatre-2010-2010
1328	Dave Matthews Band - Concord Pavilion - 2010	\N	2010-08-25	4000.00	1	52	2018-03-24 16:58:31.923041	2018-03-24 16:59:32.64364	\N	\N	\N	dave-matthews-band-concord-pavilion-dave-matthews-band-concord-pavilion-2010-2010
1329	Dave Matthews Band - Toyota Amphitheatre - 2010	\N	2010-08-27	4000.00	1	170	2018-03-24 16:58:38.316752	2018-03-24 17:00:35.665575	\N	\N	\N	dave-matthews-band-toyota-amphitheatre-dave-matthews-band-toyota-amphitheatre-2010-2010
1330	Dave Matthews Band - Gorge Amphitheatre - 2010		2010-09-03	4000.00	1	9	2018-03-24 16:58:31.625787	2018-09-29 12:46:20.532628	1200	\N	\N	dave-matthews-band-gorge-amphitheatre-dave-matthews-band-gorge-amphitheatre-2010-2010
1331	Dave Matthews Band - Gorge Amphitheatre - 2010		2010-09-04	4000.00	1	9	2018-03-24 16:58:35.110886	2018-05-31 00:51:49.738068	1200	\N	\N	dave-matthews-band-gorge-amphitheatre-dave-matthews-band-gorge-amphitheatre-2010-2010-1
1332	Dave Matthews Band - Cynthia Woods Mitchell Pavilion - 2010	\N	2010-09-10	4000.00	1	2	2018-03-24 16:58:39.628213	2018-03-24 17:00:50.62708	\N	\N	\N	dave-matthews-band-cynthia-woods-mitchell-pavilion-dave-matthews-band-cynthia-woods-mitchell-pavilion-2010-2010
1333	Dave Matthews Band - Gorge Amphitheatre - 2010	\N	2010-09-05	4000.00	1	9	2018-03-24 16:58:31.871919	2018-03-24 16:59:32.023896	\N	\N	\N	dave-matthews-band-gorge-amphitheatre-dave-matthews-band-gorge-amphitheatre-2010-2010-2
1334	Dave Matthews Band - Taco Bell Arena - 2010	\N	2010-08-31	4000.00	1	147	2018-03-24 16:58:37.349236	2018-03-24 17:00:25.023487	\N	\N	\N	dave-matthews-band-taco-bell-arena-dave-matthews-band-taco-bell-arena-2010-2010
1335	Dave Matthews Band - Wrigley Field - 2010	\N	2010-09-17	4000.00	1	7	2018-03-24 16:58:33.478547	2018-03-24 16:59:49.171312	\N	\N	\N	dave-matthews-band-wrigley-field-dave-matthews-band-wrigley-field-2010-2010
1336	Dave Matthews Band - CenturyLink Center Omaha - 2010	\N	2010-09-14	4000.00	1	67	2018-03-24 16:58:35.292754	2018-03-24 17:00:07.840658	\N	\N	\N	dave-matthews-band-centurylink-center-omaha-dave-matthews-band-centurylink-center-omaha-2010-2010
1337	Dave Matthews Band - Jackson Square - 2010	\N	2010-09-09	4000.00	1	131	2018-03-24 16:58:39.859104	2018-03-24 17:00:52.874994	\N	\N	\N	dave-matthews-band-jackson-square-dave-matthews-band-jackson-square-2010-2010
1338	Dave Matthews Band - Wrigley Field - 2010	\N	2010-09-18	4000.00	1	7	2018-03-24 16:58:30.752997	2018-03-24 16:59:20.317712	\N	\N	\N	dave-matthews-band-wrigley-field-dave-matthews-band-wrigley-field-2010-2010-1
1339	Dave Matthews Band - SWU Music & Arts - 2010	\N	2010-10-10	4000.00	1	167	2018-03-24 16:58:38.341774	2018-03-24 17:00:37.252727	\N	\N	\N	dave-matthews-band-swu-music-arts-dave-matthews-band-swu-music-arts-2010-2010
1340	Dave Matthews Band - HSBC Arena - 2010	\N	2010-10-08	4000.00	1	124	2018-03-24 16:58:35.353492	2018-03-24 17:00:08.449754	\N	\N	\N	dave-matthews-band-hsbc-arena-dave-matthews-band-hsbc-arena-2010-2010
1341	Dave Matthews Band - First Niagara Center - 2010	\N	2010-11-02	4000.00	1	129	2018-03-24 16:58:33.505692	2018-03-24 16:59:49.470475	\N	\N	\N	dave-matthews-band-first-niagara-center-dave-matthews-band-first-niagara-center-2010-2010
1342	Dave Matthews Band - The Times Union Center - 2010	\N	2010-11-05	4000.00	1	157	2018-03-24 16:58:39.890695	2018-03-24 17:00:53.22693	\N	\N	\N	dave-matthews-band-the-times-union-center-dave-matthews-band-the-times-union-center-2010-2010
1343	Dave Matthews Band - 2010	\N	2010-11-03	4000.00	1	\N	2018-03-24 16:58:34.055188	2018-03-24 16:59:54.773549	\N	\N	\N	dave-matthews-band-dave-matthews-band-2010-2010-2
1344	Dave Matthews Band - Gexa Energy Pavilion - 2010	\N	2010-09-11	4000.00	1	66	2018-03-24 16:58:36.787646	2018-03-24 17:00:20.401303	\N	\N	\N	dave-matthews-band-gexa-energy-pavilion-dave-matthews-band-gexa-energy-pavilion-2010-2010
1345	Dave Matthews Band - Xcel Energy Center - 2010	\N	2010-09-15	4000.00	1	109	2018-03-24 16:58:33.905162	2018-03-24 16:59:53.274633	\N	\N	\N	dave-matthews-band-xcel-energy-center-dave-matthews-band-xcel-energy-center-2010-2010
1346	Dave Matthews Band - Madison Square Garden - 2010	\N	2010-11-12	4000.00	1	23	2018-03-24 16:58:41.095903	2018-03-24 17:01:06.745292	\N	\N	\N	dave-matthews-band-madison-square-garden-dave-matthews-band-madison-square-garden-2010-2010
1347	Dave Matthews Band - Madison Square Garden - 2010	\N	2010-11-13	4000.00	1	23	2018-03-24 16:58:30.862164	2018-03-24 16:59:21.12984	\N	\N	\N	dave-matthews-band-madison-square-garden-dave-matthews-band-madison-square-garden-2010-2010-1
1348	Dave Matthews Band - Wells Fargo Center - 2010	\N	2010-11-06	4000.00	1	36	2018-03-24 16:58:45.17335	2018-03-24 17:01:50.079788	\N	\N	\N	dave-matthews-band-wells-fargo-center-dave-matthews-band-wells-fargo-center-2010-2010
1349	Dave Matthews Band - Philips Arena - 2010	\N	2010-11-16	4000.00	1	83	2018-03-24 16:58:37.81529	2018-03-24 17:00:29.345706	\N	\N	\N	dave-matthews-band-philips-arena-dave-matthews-band-philips-arena-2010-2010
1350	Dave Matthews Band - TD Garden - 2010	\N	2010-11-09	4000.00	1	20	2018-03-24 16:58:44.19224	2018-03-24 17:01:40.686421	\N	\N	\N	dave-matthews-band-td-garden-dave-matthews-band-td-garden-2010-2010
1351	Dave Matthews Band - John Paul Jones Arena - 2010	\N	2010-11-19	4000.00	1	30	2018-03-24 16:58:40.339772	2018-03-24 17:00:58.726689	\N	\N	\N	dave-matthews-band-john-paul-jones-arena-dave-matthews-band-john-paul-jones-arena-2010-2010
1352	Dave Matthews - Microsoft Store - 2010	\N	2010-11-18	4000.00	3	32	2018-03-24 16:58:42.969646	2018-03-24 17:01:29.84738	\N	\N	\N	dave-matthews-microsoft-store-dave-matthews-microsoft-store-2010-2010
1353	Dave Matthews Band - John Paul Jones Arena - 2010	\N	2010-11-20	4000.00	1	30	2018-03-24 16:58:44.283659	2018-03-24 17:01:41.558307	\N	\N	\N	dave-matthews-band-john-paul-jones-arena-dave-matthews-band-john-paul-jones-arena-2010-2010-1
1354	Dave Matthews Band - North Charleston Coliseum - 2010	\N	2010-11-17	4000.00	1	31	2018-03-24 16:58:35.383123	2018-03-24 17:00:08.918871	\N	\N	\N	dave-matthews-band-north-charleston-coliseum-dave-matthews-band-north-charleston-coliseum-2010-2010
1355	Dave Matthews & Tim Reynolds - Marion Oliver McCaw Hall - 2010	\N	2010-12-06	4000.00	2	45	2018-03-24 16:58:41.174967	2018-03-24 17:01:07.784108	\N	\N	\N	dave-matthews-tim-reynolds-marion-oliver-mccaw-hall-dave-matthews-tim-reynolds-marion-oliver-mccaw-hall-2010-2010
1356	Dave Matthews Band - TD Garden - 2010		2010-11-10	4000.00	1	20	2018-03-24 16:58:40.505352	2018-05-16 16:40:09.394299	550	\N	\N	dave-matthews-band-td-garden-dave-matthews-band-td-garden-2010-2010-1
1357	Dave Matthews & Tim Reynolds - 1st Bank Center - 2010	\N	2010-12-09	4000.00	2	34	2018-03-24 16:58:31.755469	2018-03-24 16:59:30.64158	\N	\N	\N	dave-matthews-tim-reynolds-1st-bank-center-dave-matthews-tim-reynolds-1st-bank-center-2010-2010
1358	Dave Matthews & Tim Reynolds - Marion Oliver McCaw Hall - 2010	\N	2010-12-07	4000.00	2	45	2018-03-24 16:58:36.871974	2018-03-24 17:00:21.697306	\N	\N	\N	dave-matthews-tim-reynolds-marion-oliver-mccaw-hall-dave-matthews-tim-reynolds-marion-oliver-mccaw-hall-2010-2010-1
1359	Dave Matthews & Tim Reynolds - Planet Hollywood Resort & Casino - 2010	\N	2010-12-11	4000.00	2	35	2018-03-24 16:58:45.272721	2018-03-24 17:01:50.818471	\N	\N	\N	dave-matthews-tim-reynolds-planet-hollywood-resort-casino-dave-matthews-tim-reynolds-planet-hollywood-resort-casino-2010-2010
1360	Dave Matthews & Tim Reynolds - Planet Hollywood Resort & Casino - 2010	\N	2010-12-10	4000.00	2	35	2018-03-24 16:58:35.453269	2018-03-24 17:00:09.470554	\N	\N	\N	dave-matthews-tim-reynolds-planet-hollywood-resort-casino-dave-matthews-tim-reynolds-planet-hollywood-resort-casino-2010-2010-1
1361	Dave Matthews & Tim Reynolds - Planet Hollywood Resort & Casino - 2010	\N	2010-12-11	4000.00	2	35	2018-03-24 16:58:29.38479	2018-03-24 16:58:58.45199	\N	\N	\N	dave-matthews-tim-reynolds-planet-hollywood-resort-casino-dave-matthews-tim-reynolds-planet-hollywood-resort-casino-2010-2010-2
1362	Dave Matthews Band - Bader Field - 2011	\N	2011-06-24	4000.00	1	38	2018-03-24 16:58:44.455024	2018-03-24 17:01:43.364621	\N	\N	\N	dave-matthews-band-bader-field-dave-matthews-band-bader-field-2011-2011
1363	Dave Matthews Band - Bader Field - 2011	\N	2011-06-26	4000.00	1	38	2018-03-24 16:58:36.65249	2018-03-24 17:00:19.129461	\N	\N	\N	dave-matthews-band-bader-field-dave-matthews-band-bader-field-2011-2011-1
1364	Dave Matthews Band - Bader Field - 2011	\N	2011-06-25	4000.00	1	38	2018-03-24 16:58:36.900358	2018-03-24 17:00:21.950322	\N	\N	\N	dave-matthews-band-bader-field-dave-matthews-band-bader-field-2011-2011-2
1365	Dave Matthews Band - Lakeside - 2011	\N	2011-07-08	4000.00	1	93	2018-03-24 16:58:34.609591	2018-03-24 17:00:00.663873	\N	\N	\N	dave-matthews-band-lakeside-dave-matthews-band-lakeside-2011-2011
1366	Dave Matthews Band - 2011	\N	2011-07-09	4000.00	1	\N	2018-03-24 16:58:31.898816	2018-03-24 16:59:32.346448	\N	\N	\N	dave-matthews-band-dave-matthews-band-2011-2011
1367	Dave Matthews Band - Lakeside - 2011	\N	2011-07-10	4000.00	1	93	2018-03-24 16:58:38.372082	2018-03-24 17:00:37.499576	\N	\N	\N	dave-matthews-band-lakeside-dave-matthews-band-lakeside-2011-2011-1
1368	Dave Matthews Band - Governors Island - 2011	\N	2011-08-28	4000.00	1	49	2018-03-24 16:58:35.494513	2018-03-24 17:00:10.095947	\N	\N	\N	dave-matthews-band-governors-island-dave-matthews-band-governors-island-2011-2011
1369	Dave Matthews Band - Bader Field - 2011	\N	2011-07-24	4000.00	1	38	2018-03-24 16:58:33.937047	2018-03-24 16:59:53.583191	\N	\N	\N	dave-matthews-band-bader-field-dave-matthews-band-bader-field-2011-2011-3
1370	Dave Matthews Band - Governors Island - 2011	\N	2011-08-06	4000.00	1	49	2018-03-24 16:58:33.426326	2018-03-24 16:59:48.54669	\N	\N	\N	dave-matthews-band-governors-island-dave-matthews-band-governors-island-2011-2011-1
1371	Dave Matthews Band - Lakeside - 2011	\N	2011-07-08	4000.00	1	93	2018-03-24 16:58:40.585191	2018-04-16 11:57:04.744837	1050	\N	\N	dave-matthews-band-lakeside-dave-matthews-band-lakeside-2011-2011-2
1372	Dave Matthews Band - Governors Island - 2011	\N	2011-08-27	4000.00	1	49	2018-03-24 16:58:35.727809	2018-03-24 17:00:11.895992	\N	\N	\N	dave-matthews-band-governors-island-dave-matthews-band-governors-island-2011-2011-2
1373	Dave Matthews Band - Gorge Amphitheatre - 2011		2011-09-02	4000.00	1	9	2018-03-24 16:58:33.360921	2018-05-12 15:34:18.024739	1150	\N	\N	dave-matthews-band-gorge-amphitheatre-dave-matthews-band-gorge-amphitheatre-2011-2011
1374	Randalls Island - 2011	\N	2011-09-16	4000.00	\N	42	2018-03-24 16:58:42.579929	2018-03-24 17:01:25.853108	\N	\N	\N	randalls-island-randalls-island-2011-2011
1375	Dave Matthews Band - Gorge Amphitheatre - 2011	\N	2011-09-03	4000.00	1	9	2018-03-24 16:58:33.660293	2018-03-24 16:59:51.515061	\N	\N	\N	dave-matthews-band-gorge-amphitheatre-dave-matthews-band-gorge-amphitheatre-2011-2011-1
1376	Dave Matthews Band - Governors Island - 2011	\N	2011-08-26	4000.00	1	49	2018-03-24 16:58:40.062149	2018-03-24 17:00:55.148287	\N	\N	\N	dave-matthews-band-governors-island-dave-matthews-band-governors-island-2011-2011-3
1377	Dave Matthews Band - Gorge Amphitheatre - 2011	\N	2011-09-04	4000.00	1	9	2018-03-24 16:58:40.451618	2018-03-24 17:00:59.771666	\N	\N	\N	dave-matthews-band-gorge-amphitheatre-dave-matthews-band-gorge-amphitheatre-2011-2011-2
1378	Dave Matthews Band - Gorge Amphitheatre - 2011	\N	2011-09-02	4000.00	1	9	2018-03-24 16:58:38.179707	2018-03-24 17:00:33.018553	\N	\N	\N	dave-matthews-band-gorge-amphitheatre-dave-matthews-band-gorge-amphitheatre-2011-2011-3
1379	Dave Matthews Band - Randalls Island - 2011	\N	2011-09-18	4000.00	1	42	2018-03-24 16:58:29.356954	2018-03-24 16:58:58.134974	\N	\N	\N	dave-matthews-band-randalls-island-dave-matthews-band-randalls-island-2011-2011
1380	Dave Matthews Band - PNC Music Pavillion - 2012	\N	2012-05-23	4000.00	1	1	2018-03-24 16:58:44.374522	2018-03-24 17:01:42.638935	\N	\N	\N	dave-matthews-band-pnc-music-pavillion-dave-matthews-band-pnc-music-pavillion-2012-2012
1381	Dave Matthews Band - Randalls Island - 2011	\N	2011-09-12	4000.00	1	42	2018-03-24 16:58:41.010629	2018-03-24 17:01:05.738693	\N	\N	\N	dave-matthews-band-randalls-island-dave-matthews-band-randalls-island-2011-2011-1
1382	Dave Matthews & Tim Reynolds - United Palace Theatre - 2011	\N	2011-11-18	4000.00	2	51	2018-03-24 16:58:44.315112	2018-03-24 17:01:42.112631	\N	\N	\N	dave-matthews-tim-reynolds-united-palace-theatre-dave-matthews-tim-reynolds-united-palace-theatre-2011-2011
1383	Dave Matthews Band - Cynthia Woods Mitchell Pavilion - 2012	\N	2012-05-18	4000.00	1	2	2018-03-24 16:58:38.712942	2018-03-24 17:00:42.35083	\N	\N	\N	dave-matthews-band-cynthia-woods-mitchell-pavilion-dave-matthews-band-cynthia-woods-mitchell-pavilion-2012-2012
1384	Dave Matthews & Tim Reynolds - Oakdale Theatre - 2011	\N	2011-11-19	4000.00	2	60	2018-03-24 16:58:44.160043	2018-03-24 17:01:40.490233	\N	\N	\N	dave-matthews-tim-reynolds-oakdale-theatre-dave-matthews-tim-reynolds-oakdale-theatre-2011-2011
1385	Dave Matthews Band - Blossom Music Center - 2012	\N	2012-05-25	4000.00	1	39	2018-03-24 16:58:44.099044	2018-03-24 17:01:39.842429	\N	\N	\N	dave-matthews-band-blossom-music-center-dave-matthews-band-blossom-music-center-2012-2012
1386	Dave Matthews Band - Gexa Energy Pavilion - 2012	\N	2012-05-19	4000.00	1	66	2018-03-24 16:58:37.654291	2018-03-24 17:00:27.506412	\N	\N	\N	dave-matthews-band-gexa-energy-pavilion-dave-matthews-band-gexa-energy-pavilion-2012-2012
1387	Dave Matthews Band - Budweiser Stage - 2012	\N	2012-06-02	4000.00	1	4	2018-03-24 16:58:33.59332	2018-03-24 16:59:50.699765	\N	\N	\N	dave-matthews-band-budweiser-stage-dave-matthews-band-budweiser-stage-2012-2012
1388	Dave Matthews Band - The Pavilion at Montage Mountain - 2012	\N	2012-05-28	4000.00	1	86	2018-03-24 16:58:39.273608	2018-03-24 17:00:46.72958	\N	\N	\N	dave-matthews-band-the-pavilion-at-montage-mountain-dave-matthews-band-the-pavilion-at-montage-mountain-2012-2012
1389	Dave Matthews Band - Riverbend Music Center - 2012	\N	2012-05-29	4000.00	1	44	2018-03-24 16:58:32.109637	2018-03-24 16:59:35.686069	\N	\N	\N	dave-matthews-band-riverbend-music-center-dave-matthews-band-riverbend-music-center-2012-2012
1390	Dave Matthews Band - Lakewood Amphitheatre - 2012	\N	2012-05-22	4000.00	1	54	2018-03-24 16:58:39.710481	2018-03-24 17:00:51.538322	\N	\N	\N	dave-matthews-band-lakewood-amphitheatre-dave-matthews-band-lakewood-amphitheatre-2012-2012
1391	Dave Matthews Band - 2012	\N	2012-06-03	4000.00	1	\N	2018-03-24 16:58:41.785768	2018-03-24 17:01:15.539615	\N	\N	\N	dave-matthews-band-dave-matthews-band-2012-2012
1392	Dave Matthews Band - 2012	\N	2012-06-05	4000.00	1	\N	2018-03-24 16:58:32.599855	2018-03-24 16:59:39.016056	\N	\N	\N	dave-matthews-band-dave-matthews-band-2012-2012-1
1393	Dave Matthews Band - Nikon at Jones Beach Theater - 2012	\N	2012-06-13	4000.00	1	14	2018-03-24 16:58:37.868829	2018-03-24 17:00:29.867437	\N	\N	\N	dave-matthews-band-nikon-at-jones-beach-theater-dave-matthews-band-nikon-at-jones-beach-theater-2012-2012
1394	Dave Matthews Band - Saratoga Springs Performing Arts Center - 2012	\N	2012-06-08	4000.00	1	5	2018-03-24 16:58:30.922974	2018-03-24 16:59:21.727694	\N	\N	\N	dave-matthews-band-saratoga-springs-performing-arts-center-dave-matthews-band-saratoga-springs-performing-arts-center-2012-2012
1395	Dave Matthews Band - XFINITY Theatre - 2012	\N	2012-05-26	4000.00	1	46	2018-03-24 16:58:41.065758	2018-03-24 17:01:06.511293	\N	\N	\N	dave-matthews-band-xfinity-theatre-dave-matthews-band-xfinity-theatre-2012-2012
1396	Dave Matthews Band - Nikon at Jones Beach Theater - 2012	\N	2012-06-12	4000.00	1	14	2018-03-24 16:58:36.845186	2018-03-24 17:00:21.457644	\N	\N	\N	dave-matthews-band-nikon-at-jones-beach-theater-dave-matthews-band-nikon-at-jones-beach-theater-2012-2012-1
1397	Dave Matthews Band - Saratoga Springs Performing Arts Center - 2012	\N	2012-06-09	4000.00	1	5	2018-03-24 16:58:33.630883	2018-03-24 16:59:51.114614	\N	\N	\N	dave-matthews-band-saratoga-springs-performing-arts-center-dave-matthews-band-saratoga-springs-performing-arts-center-2012-2012-1
1398	Dave Matthews Band - Xfinity Center - 2012	\N	2012-06-06	4000.00	1	41	2018-03-24 16:58:41.896636	2018-03-24 17:01:16.707708	\N	\N	\N	dave-matthews-band-xfinity-center-dave-matthews-band-xfinity-center-2012-2012
1399	Dave Matthews Band - Ruoff Home Mortgage Music Center - 2012	\N	2012-06-23	4000.00	1	16	2018-03-24 16:58:40.121266	2018-03-24 17:00:55.936412	\N	\N	\N	dave-matthews-band-ruoff-home-mortgage-music-center-dave-matthews-band-ruoff-home-mortgage-music-center-2012-2012
1400	Dave Matthews Band - Jiffy Lube Live - 2012	\N	2012-06-16	4000.00	1	33	2018-03-24 16:58:36.301884	2018-03-24 17:00:16.09869	\N	\N	\N	dave-matthews-band-jiffy-lube-live-dave-matthews-band-jiffy-lube-live-2012-2012
1401	Dave Matthews Band - River's Edge Music Festival - 2012	\N	2012-05-24	4000.00	1	77	2018-03-24 16:58:39.113587	2018-03-24 17:00:45.038432	\N	\N	\N	dave-matthews-band-river-s-edge-music-festival-dave-matthews-band-river-s-edge-music-festival-2012-2012
1402	Dave Matthews Band - Veterans United Home Loans Amphitheatre - 2012	\N	2012-06-17	4000.00	1	11	2018-03-24 16:58:32.032944	2018-04-11 01:23:32.224207	650	\N	\N	dave-matthews-band-veterans-united-home-loans-amphitheatre-dave-matthews-band-veterans-united-home-loans-amphitheatre-2012-2012
1403	Dave Matthews Band - BB&T Pavilion - 2012	\N	2012-06-27	4000.00	1	29	2018-03-24 16:58:44.691233	2018-03-24 17:01:45.689996	\N	\N	\N	dave-matthews-band-bb-t-pavilion-dave-matthews-band-bb-t-pavilion-2012-2012
1404	Dave Matthews Band - BB&T Pavilion - 2012	\N	2012-06-06	4000.00	1	29	2018-03-24 16:58:40.174118	2018-03-24 17:00:56.940009	\N	\N	\N	dave-matthews-band-bb-t-pavilion-dave-matthews-band-bb-t-pavilion-2012-2012-1
1405	Dave Matthews Band - Ruoff Home Mortgage Music Center - 2012		2012-06-22	4000.00	1	16	2018-03-24 16:58:36.977914	2018-05-12 15:36:48.233344	900	\N	\N	dave-matthews-band-ruoff-home-mortgage-music-center-dave-matthews-band-ruoff-home-mortgage-music-center-2012-2012-1
1406	Dave Matthews Band - BB&T Pavilion - 2012	\N	2012-06-27	4000.00	1	29	2018-03-24 16:58:42.633547	2018-03-24 17:01:26.339198	\N	\N	\N	dave-matthews-band-bb-t-pavilion-dave-matthews-band-bb-t-pavilion-2012-2012-2
1407	Dave Matthews Band - Hershey Park Stadium - 2012	\N	2012-06-29	4000.00	1	79	2018-03-24 16:58:39.948593	2018-03-24 17:00:53.954095	\N	\N	\N	dave-matthews-band-hershey-park-stadium-dave-matthews-band-hershey-park-stadium-2012-2012
1409	Dave Matthews Band - Alpine Valley Music Theatre - 2012	\N	2012-07-07	4000.00	1	12	2018-03-24 16:58:35.572859	2018-03-24 17:00:10.597194	\N	\N	\N	dave-matthews-band-alpine-valley-music-theatre-dave-matthews-band-alpine-valley-music-theatre-2012-2012
1410	Dave Matthews Band - Darien Lake Performing Arts Center - 2012	\N	2012-07-03	4000.00	1	76	2018-03-24 16:58:39.167366	2018-03-24 17:00:45.67158	\N	\N	\N	dave-matthews-band-darien-lake-performing-arts-center-dave-matthews-band-darien-lake-performing-arts-center-2012-2012
1411	Dave Matthews Band - DTE Energy Music Theatre - 2012	\N	2012-07-10	4000.00	1	55	2018-03-24 16:58:37.028781	2018-03-24 17:00:23.499119	\N	\N	\N	dave-matthews-band-dte-energy-music-theatre-dave-matthews-band-dte-energy-music-theatre-2012-2012
1412	Dave Matthews Band - Alpine Valley Music Theatre - 2012	\N	2012-07-06	4000.00	1	12	2018-03-24 16:58:38.850668	2018-03-24 17:00:44.102644	\N	\N	\N	dave-matthews-band-alpine-valley-music-theatre-dave-matthews-band-alpine-valley-music-theatre-2012-2012-1
1413	Dave Matthews Band - Bethel Woods Center for the Arts - 2012	\N	2012-06-30	4000.00	1	97	2018-03-24 16:58:42.785105	2018-03-24 17:01:28.007717	\N	\N	\N	dave-matthews-band-bethel-woods-center-for-the-arts-dave-matthews-band-bethel-woods-center-for-the-arts-2012-2012
1414	Dave Matthews Band - First Niagara Pavilion - 2012	\N	2012-07-13	4000.00	1	78	2018-03-24 16:58:36.928816	2018-03-24 17:00:22.291492	\N	\N	\N	dave-matthews-band-first-niagara-pavilion-dave-matthews-band-first-niagara-pavilion-2012-2012
1415	Dave Matthews Band - First Niagara Pavilion - 2012	\N	2012-07-01	4000.00	1	78	2018-03-24 16:58:40.199474	2018-03-24 17:00:57.264871	\N	\N	\N	dave-matthews-band-first-niagara-pavilion-dave-matthews-band-first-niagara-pavilion-2012-2012-1
1416	Dave Matthews & Tim Reynolds - CMAC - 2012	\N	2012-07-15	4000.00	2	82	2018-03-24 16:58:38.55746	2018-03-24 17:00:40.611523	\N	\N	\N	dave-matthews-tim-reynolds-cmac-dave-matthews-tim-reynolds-cmac-2012-2012
1417	Dave Matthews Band - Perfect Vodka Amphitheatre - 2012	\N	2012-07-20	4000.00	1	17	2018-03-24 16:58:37.483353	2018-03-24 17:00:26.162424	\N	\N	\N	dave-matthews-band-perfect-vodka-amphitheatre-dave-matthews-band-perfect-vodka-amphitheatre-2012-2012
1418	Dave Matthews Band - Gorge Amphitheatre - 2012	\N	2012-09-01	4000.00	1	9	2018-03-24 16:58:37.057076	2018-04-06 22:39:06.279003	1350	\N	\N	dave-matthews-band-gorge-amphitheatre-dave-matthews-band-gorge-amphitheatre-2012-2012
1419	Dave Matthews Band - 2012	\N	2012-05-18	4000.00	1	\N	2018-03-24 16:58:38.425796	2018-03-24 17:00:37.951711	\N	\N	\N	dave-matthews-band-dave-matthews-band-2012-2012-2
1420	Dave Matthews Band - Gorge Amphitheatre - 2012	\N	2012-09-02	4000.00	1	9	2018-03-24 16:58:31.784979	2018-03-24 16:59:30.939157	\N	\N	\N	dave-matthews-band-gorge-amphitheatre-dave-matthews-band-gorge-amphitheatre-2012-2012-1
1421	Dave Matthews Band - Perfect Vodka Amphitheatre - 2012	\N	2012-07-21	4000.00	1	17	2018-03-24 16:58:40.092922	2018-03-24 17:00:55.509829	\N	\N	\N	dave-matthews-band-perfect-vodka-amphitheatre-dave-matthews-band-perfect-vodka-amphitheatre-2012-2012-1
1422	Dave Matthews Band - MidFlorida Credit Union Amphitheatre - 2012	\N	2012-07-18	4000.00	1	43	2018-03-24 16:58:42.356902	2018-03-24 17:01:23.779257	\N	\N	\N	dave-matthews-band-midflorida-credit-union-amphitheatre-dave-matthews-band-midflorida-credit-union-amphitheatre-2012-2012
1423	Dave Matthews Band - Gorge Amphitheatre - 2012	\N	2012-08-31	4000.00	1	9	2018-03-24 16:58:44.841871	2018-03-24 17:01:47.114267	\N	\N	\N	dave-matthews-band-gorge-amphitheatre-dave-matthews-band-gorge-amphitheatre-2012-2012-2
1424	Dave Matthews Band - 2012	\N	2012-09-08	4000.00	1	\N	2018-03-24 16:58:36.955988	2018-03-24 17:00:22.485275	\N	\N	\N	dave-matthews-band-dave-matthews-band-2012-2012-3
1425	Dave Matthews Band - 2012	\N	2012-09-09	4000.00	1	\N	2018-03-24 16:58:32.086576	2018-03-24 16:59:35.367798	\N	\N	\N	dave-matthews-band-dave-matthews-band-2012-2012-4
1426	Dave Matthews Band - SNHU Arena - 2012	\N	2012-12-19	4000.00	1	118	2018-03-24 16:58:40.25307	2018-03-24 17:00:57.788039	\N	\N	\N	dave-matthews-band-snhu-arena-dave-matthews-band-snhu-arena-2012-2012
1427	Dave Matthews Band - Hollywood Bowl - 2012	\N	2012-09-12	4000.00	1	133	2018-03-24 16:58:40.032826	2018-03-24 17:00:54.800499	\N	\N	\N	dave-matthews-band-hollywood-bowl-dave-matthews-band-hollywood-bowl-2012-2012
1428	Dave Matthews Band - Sleep Train Amphitheatre - 2012	\N	2012-09-07	4000.00	1	61	2018-03-24 16:58:38.450604	2018-03-24 17:00:38.237671	\N	\N	\N	dave-matthews-band-sleep-train-amphitheatre-dave-matthews-band-sleep-train-amphitheatre-2012-2012
1429	Dave Matthews & Tim Reynolds - Prowse Farm - 2012	\N	2012-09-23	4000.00	2	87	2018-03-24 16:58:43.054925	2018-03-24 17:01:30.629611	\N	\N	\N	dave-matthews-tim-reynolds-prowse-farm-dave-matthews-tim-reynolds-prowse-farm-2012-2012
1430	Dave Matthews Band - Wells Fargo Center - 2012	\N	2012-12-22	4000.00	1	36	2018-03-24 16:58:31.843012	2018-03-24 16:59:31.621562	\N	\N	\N	dave-matthews-band-wells-fargo-center-dave-matthews-band-wells-fargo-center-2012-2012
1435	Dave Matthews Band - Barclays Center - 2012	\N	2012-12-21	4000.00	1	68	2018-03-24 16:58:37.003257	2018-03-24 17:00:23.214588	\N	\N	\N	dave-matthews-band-barclays-center-dave-matthews-band-barclays-center-2012-2012
1439	Dave Matthews Band - Oak Mountain Amphitheatre - 2013	\N	2013-04-06	4000.00	1	56	2018-03-24 16:58:33.741717	2018-03-24 16:59:52.13147	\N	\N	\N	dave-matthews-band-oak-mountain-amphitheatre-dave-matthews-band-oak-mountain-amphitheatre-2013-2013
1441	Dave Matthews - 2013	\N	2013-05-03	4000.00	3	\N	2018-03-24 16:58:30.019209	2018-03-24 16:59:10.070469	\N	\N	\N	dave-matthews-dave-matthews-2013-2013
1442	Dave Matthews Band - Jazz Fest - 2013	\N	2013-04-28	4000.00	1	111	2018-03-24 16:58:42.658225	2018-03-24 17:01:26.611446	\N	\N	\N	dave-matthews-band-jazz-fest-dave-matthews-band-jazz-fest-2013-2013
1443	Dave Matthews Band - Centennial Olympic Park - 2013	\N	2013-04-07	4000.00	1	63	2018-03-24 16:58:42.330594	2018-03-24 17:01:23.238611	\N	\N	\N	dave-matthews-band-centennial-olympic-park-dave-matthews-band-centennial-olympic-park-2013-2013
1444	Dave Matthews Band - BankPlus Amphitheater at Snowden Grove - 2013		2013-04-27	4000.00	1	58	2018-03-24 16:58:34.3997	2018-06-02 16:36:48.073784	\N	\N	\N	dave-matthews-band-bankplus-amphitheater-at-snowden-grove-dave-matthews-band-bankplus-amphitheater-at-snowden-grove-2013-2013
1445	Dave Matthews Band - Cynthia Woods Mitchell Pavilion - 2013	\N	2013-05-17	4000.00	1	2	2018-03-24 16:58:31.65687	2018-03-24 16:59:29.806444	\N	\N	\N	dave-matthews-band-cynthia-woods-mitchell-pavilion-dave-matthews-band-cynthia-woods-mitchell-pavilion-2013-2013
1446	Dave Matthews Band - The Pavilion at Montage Mountain - 2012	\N	2012-05-20	4000.00	1	86	2018-03-24 16:58:42.491342	2018-03-24 17:01:25.092511	\N	\N	\N	dave-matthews-band-the-pavilion-at-montage-mountain-dave-matthews-band-the-pavilion-at-montage-mountain-2012-2012-1
1447	Dave Matthews Band - Saratoga Springs Performing Arts Center - 2013	\N	2013-05-25	4000.00	1	5	2018-03-24 16:58:41.863077	2018-03-24 17:01:16.306636	\N	\N	\N	dave-matthews-band-saratoga-springs-performing-arts-center-dave-matthews-band-saratoga-springs-performing-arts-center-2013-2013
1448	Dave Matthews Band - Saratoga Springs Performing Arts Center - 2013	\N	2013-05-26	4000.00	1	5	2018-03-24 16:58:38.504683	2018-03-24 17:00:38.851929	\N	\N	\N	dave-matthews-band-saratoga-springs-performing-arts-center-dave-matthews-band-saratoga-springs-performing-arts-center-2013-2013-1
1449	Dave Matthews Band - Budweiser Stage - 2013	\N	2013-05-28	4000.00	1	4	2018-03-24 16:58:29.012823	2018-03-24 16:58:54.674394	\N	\N	\N	dave-matthews-band-budweiser-stage-dave-matthews-band-budweiser-stage-2013-2013
1450	Dave Matthews Band - Gexa Energy Pavilion - 2013		2013-05-18	4000.00	1	66	2018-03-24 16:58:34.429891	2018-05-12 15:21:47.390213	685	\N	\N	dave-matthews-band-gexa-energy-pavilion-dave-matthews-band-gexa-energy-pavilion-2013-2013
1451	Dave Matthews Band - Austin360 Amphitheater - 2013	\N	2013-05-21	4000.00	1	80	2018-03-24 16:58:30.952364	2018-03-24 16:59:22.062115	\N	\N	\N	dave-matthews-band-austin360-amphitheater-dave-matthews-band-austin360-amphitheater-2013-2013
1452	Dave Matthews Band - XFINITY Theatre - 2013	\N	2013-06-07	4000.00	1	46	2018-03-24 16:58:41.622115	2018-03-24 17:01:13.191105	\N	\N	\N	dave-matthews-band-xfinity-theatre-dave-matthews-band-xfinity-theatre-2013-2013
1453	Dave Matthews Band - Blossom Music Center - 2013	\N	2013-06-01	4000.00	1	39	2018-03-24 16:58:37.087285	2018-03-24 17:00:24.084214	\N	\N	\N	dave-matthews-band-blossom-music-center-dave-matthews-band-blossom-music-center-2013-2013
1454	Dave Matthews Band - First Niagara Pavilion - 2013	\N	2013-05-31	4000.00	1	78	2018-03-24 16:58:32.005113	2018-03-24 16:59:34.036032	\N	\N	\N	dave-matthews-band-first-niagara-pavilion-dave-matthews-band-first-niagara-pavilion-2013-2013
1455	Dave Matthews Band - PNC Banks Art Center - 2013	\N	2013-06-06	4000.00	1	85	2018-03-24 16:58:35.613815	2018-03-24 17:00:11.131662	\N	\N	\N	dave-matthews-band-pnc-banks-art-center-dave-matthews-band-pnc-banks-art-center-2013-2013
1456	Dave Matthews Band - XFINITY Theatre - 2014	\N	2014-06-08	4000.00	1	46	2018-03-24 16:58:42.244508	2018-03-24 17:01:22.467991	\N	\N	\N	dave-matthews-band-xfinity-theatre-dave-matthews-band-xfinity-theatre-2014-2014
1457	Dave Matthews Band - Xfinity Center - 2013	\N	2013-06-16	4000.00	1	41	2018-03-24 16:58:41.258903	2018-03-24 17:01:08.940528	\N	\N	\N	dave-matthews-band-xfinity-center-dave-matthews-band-xfinity-center-2013-2013
1458	Dave Matthews Band - Toyota Amphitheatre - 2003	\N	2003-07-30	4000.00	1	170	2018-03-24 16:58:43.107197	2018-03-24 17:01:31.29494	\N	\N	\N	dave-matthews-band-toyota-amphitheatre-dave-matthews-band-toyota-amphitheatre-2003-2003
1459	Dave Matthews Band - Ruoff Home Mortgage Music Center - 2013	\N	2013-06-21	4000.00	1	16	2018-03-24 16:58:42.683336	2018-03-24 17:01:26.901938	\N	\N	\N	dave-matthews-band-ruoff-home-mortgage-music-center-dave-matthews-band-ruoff-home-mortgage-music-center-2013-2013
1460	Dave Matthews Band - Xfinity Center - 2013	\N	2013-06-15	4000.00	1	41	2018-03-24 16:58:41.284831	2018-03-24 17:01:09.360623	\N	\N	\N	dave-matthews-band-xfinity-center-dave-matthews-band-xfinity-center-2013-2013-1
1461	Dave Matthews Band - Nikon at Jones Beach Theater - 2013	\N	2013-06-26	4000.00	1	14	2018-03-24 16:58:44.015774	2018-03-24 17:01:38.844869	\N	\N	\N	dave-matthews-band-nikon-at-jones-beach-theater-dave-matthews-band-nikon-at-jones-beach-theater-2013-2013
1462	Dave Matthews Band - Ruoff Home Mortgage Music Center - 2013	\N	2013-06-22	4000.00	1	16	2018-03-24 16:58:41.360471	2018-03-24 17:01:10.108976	\N	\N	\N	dave-matthews-band-ruoff-home-mortgage-music-center-dave-matthews-band-ruoff-home-mortgage-music-center-2013-2013-1
1463	Dave Matthews Band - Alpine Valley Music Theatre - 2013	\N	2013-07-05	4000.00	1	12	2018-03-24 16:58:41.412011	2018-03-24 17:01:10.861876	\N	\N	\N	dave-matthews-band-alpine-valley-music-theatre-dave-matthews-band-alpine-valley-music-theatre-2013-2013
1464	Dave Matthews Band - Nikon at Jones Beach Theater - 2013	\N	2013-06-25	4000.00	1	14	2018-03-24 16:58:43.322916	2018-03-24 17:01:31.661865	\N	\N	\N	dave-matthews-band-nikon-at-jones-beach-theater-dave-matthews-band-nikon-at-jones-beach-theater-2013-2013-1
1465	Dave Matthews Band - Alpine Valley Music Theatre - 2013	\N	2013-07-06	4000.00	1	12	2018-03-24 16:58:43.375553	2018-03-24 17:01:32.121042	\N	\N	\N	dave-matthews-band-alpine-valley-music-theatre-dave-matthews-band-alpine-valley-music-theatre-2013-2013-1
1466	Dave Matthews Band - Darien Lake Performing Arts Center - 2013	\N	2013-07-03	4000.00	1	76	2018-03-24 16:58:43.43475	2018-03-24 17:01:32.755913	\N	\N	\N	dave-matthews-band-darien-lake-performing-arts-center-dave-matthews-band-darien-lake-performing-arts-center-2013-2013
1467	Dave Matthews Band - Bethel Woods Center for the Arts - 2013	\N	2013-07-02	4000.00	1	97	2018-03-24 16:58:43.469752	2018-03-24 17:01:33.011302	\N	\N	\N	dave-matthews-band-bethel-woods-center-for-the-arts-dave-matthews-band-bethel-woods-center-for-the-arts-2013-2013
1468	Dave Matthews Band - DTE Energy Music Theatre - 2013	\N	2013-07-09	4000.00	1	55	2018-03-24 16:58:41.312977	2018-03-24 17:01:09.621189	\N	\N	\N	dave-matthews-band-dte-energy-music-theatre-dave-matthews-band-dte-energy-music-theatre-2013-2013
1469	Dave Matthews Band - Riverbend Music Center - 2013	\N	2013-07-12	4000.00	1	44	2018-03-24 16:58:41.203974	2018-03-24 17:01:08.005384	\N	\N	\N	dave-matthews-band-riverbend-music-center-dave-matthews-band-riverbend-music-center-2013-2013
1470	Dave Matthews Band - Hollywood Casino Amphitheatre - 2013	\N	2013-07-10	4000.00	1	71	2018-03-24 16:58:44.223276	2018-03-24 17:01:40.91165	\N	\N	\N	dave-matthews-band-hollywood-casino-amphitheatre-dave-matthews-band-hollywood-casino-amphitheatre-2013-2013
1471	Dave Matthews Band - Jiffy Lube Live - 2013		2013-07-27	4000.00	1	33	2018-03-24 16:58:42.16462	2018-05-12 15:25:41.283775	655	\N	\N	dave-matthews-band-jiffy-lube-live-dave-matthews-band-jiffy-lube-live-2013-2013
1472	Dave Matthews Band - MidFlorida Credit Union Amphitheatre - 2013	\N	2013-07-17	4000.00	1	43	2018-03-24 16:58:43.402982	2018-03-24 17:01:32.438659	\N	\N	\N	dave-matthews-band-midflorida-credit-union-amphitheatre-dave-matthews-band-midflorida-credit-union-amphitheatre-2013-2013
1473	Dave Matthews Band - 2013	\N	2013-06-13	4000.00	1	\N	2018-03-24 16:58:41.46353	2018-03-24 17:01:11.097222	\N	\N	\N	dave-matthews-band-dave-matthews-band-2013-2013
1474	Dave Matthews Band - The Amphitheater At the Wharf - 2013	\N	2013-07-23	4000.00	1	107	2018-03-24 16:58:41.491605	2018-03-24 17:01:11.320987	\N	\N	\N	dave-matthews-band-the-amphitheater-at-the-wharf-dave-matthews-band-the-amphitheater-at-the-wharf-2013-2013
1475	Dave Matthews Band - PNC Music Pavillion - 2013	\N	2013-07-23	4000.00	1	1	2018-03-24 16:58:43.552124	2018-03-24 17:01:33.880632	\N	\N	\N	dave-matthews-band-pnc-music-pavillion-dave-matthews-band-pnc-music-pavillion-2013-2013
1476	Dave Matthews Band - USANA Amphitheater - 2013	\N	2013-08-27	4000.00	1	19	2018-03-24 16:58:42.105501	2018-03-24 17:01:19.014751	\N	\N	\N	dave-matthews-band-usana-amphitheater-dave-matthews-band-usana-amphitheater-2013-2013
1477	Dave Matthews Band - Lake Tahoe Outdoor Arena - 2013	\N	2013-09-04	4000.00	1	70	2018-03-24 16:58:43.607294	2018-03-24 17:01:34.331816	\N	\N	\N	dave-matthews-band-lake-tahoe-outdoor-arena-dave-matthews-band-lake-tahoe-outdoor-arena-2013-2013
1481	Dave Matthews Band - Irvine Meadows Amphitheatre - 2013	\N	2013-09-07	4000.00	1	96	2018-03-24 16:58:47.325053	2018-03-24 17:02:13.785934	\N	\N	\N	dave-matthews-band-irvine-meadows-amphitheatre-dave-matthews-band-irvine-meadows-amphitheatre-2013-2013
1482	Dave Matthews Band - Sleep Train Amphitheatre - 2013	\N	2013-09-06	4000.00	1	61	2018-03-24 16:58:41.999304	2018-03-24 17:01:17.91073	\N	\N	\N	dave-matthews-band-sleep-train-amphitheatre-dave-matthews-band-sleep-train-amphitheatre-2013-2013
1516	Dave Matthews & Tim Reynolds - Saenger Theatre - 2014	\N	2014-01-15	4000.00	2	62	2018-03-24 16:58:43.578439	2018-03-24 17:01:34.127999	\N	\N	\N	dave-matthews-tim-reynolds-saenger-theatre-dave-matthews-tim-reynolds-saenger-theatre-2014-2014
1517	Dave Matthews & Tim Reynolds - Saenger Theatre - 2014	\N	2014-01-16	4000.00	2	62	2018-03-24 16:58:42.55265	2018-03-24 17:01:25.432592	\N	\N	\N	dave-matthews-tim-reynolds-saenger-theatre-dave-matthews-tim-reynolds-saenger-theatre-2014-2014-1
1518	Dave Matthews Band - Sydney Entertainment Centre - 2014	\N	2014-04-15	5000.00	1	160	2018-03-24 16:58:43.666841	2018-04-22 13:26:30.369412	120	\N	\N	dave-matthews-band-sydney-entertainment-centre-dave-matthews-band-sydney-entertainment-centre-2014-2014
1519	Dave Matthews Band - 2013	\N	2013-05-17	4000.00	1	\N	2018-03-24 16:58:41.338216	2018-03-24 17:01:09.83173	\N	\N	\N	dave-matthews-band-dave-matthews-band-2013-2013-1
1521	Dave Matthews Band - Gexa Energy Pavilion - 2014	\N	2014-05-17	4000.00	1	66	2018-03-24 16:58:43.524037	2018-03-24 17:01:33.580625	\N	\N	\N	dave-matthews-band-gexa-energy-pavilion-dave-matthews-band-gexa-energy-pavilion-2014-2014
1522	Dave Matthews Band - Cynthia Woods Mitchell Pavilion - 2014	\N	2014-05-16	4000.00	1	2	2018-03-24 16:58:42.871517	2018-03-24 17:01:29.04289	\N	\N	\N	dave-matthews-band-cynthia-woods-mitchell-pavilion-dave-matthews-band-cynthia-woods-mitchell-pavilion-2014-2014
1523	Dave Matthews Band - Lakewood Amphitheatre - 2014		2014-05-24	4000.00	1	54	2018-03-24 16:58:46.283269	2018-05-15 11:53:01.101921	845	\N	\N	dave-matthews-band-lakewood-amphitheatre-dave-matthews-band-lakewood-amphitheatre-2014-2014
1524	Dave Matthews and Friends - Staples Center - 2004	\N	2004-07-15	4000.00	6	122	2018-03-24 16:58:41.385593	2018-03-24 17:01:10.483115	\N	\N	\N	dave-matthews-and-friends-staples-center-dave-matthews-and-friends-staples-center-2004-2004
1525	Dave Matthews Band - 3Arena - 2007	\N	2007-05-23	4000.00	1	130	2018-03-24 16:58:44.043077	2018-03-24 17:01:39.32081	\N	\N	\N	dave-matthews-band-3arena-dave-matthews-band-3arena-2007-2007
1526	Dave Matthews & Tim Reynolds - The AXIS - 2005	\N	2005-10-28	4000.00	2	72	2018-03-24 16:58:43.636377	2018-03-24 17:01:34.724164	\N	\N	\N	dave-matthews-tim-reynolds-the-axis-dave-matthews-tim-reynolds-the-axis-2005-2005
1527	Dave Matthews Band - DTE Energy Music Theatre - 2014	\N	2014-06-25	4000.00	1	55	2018-03-24 16:58:43.859507	2018-04-08 02:23:32.827292	\N	\N	\N	dave-matthews-band-dte-energy-music-theatre-dave-matthews-band-dte-energy-music-theatre-2014-2014
1528	Dave Matthews Band - Sleep Train Amphitheatre - 2007	\N	2007-09-28	4000.00	1	61	2018-03-24 16:58:41.676509	2018-03-24 17:01:14.406308	\N	\N	\N	dave-matthews-band-sleep-train-amphitheatre-dave-matthews-band-sleep-train-amphitheatre-2007-2007
1529	Dave Matthews Band - BOK Center - 2014	\N	2014-05-21	4000.00	1	73	2018-03-24 16:58:41.595744	2018-03-24 17:01:12.91558	\N	\N	\N	dave-matthews-band-bok-center-dave-matthews-band-bok-center-2014-2014
1530	Dave Matthews Band - USANA Amphitheater - 2010	\N	2010-08-17	4000.00	1	19	2018-03-24 16:58:43.912374	2018-03-24 17:01:38.019966	\N	\N	\N	dave-matthews-band-usana-amphitheater-dave-matthews-band-usana-amphitheater-2010-2010
1531	Dave Matthews Band - Beacon Theatre - 2009	\N	2009-06-01	4000.00	1	101	2018-03-24 16:58:43.705012	2018-03-24 17:01:35.502225	\N	\N	\N	dave-matthews-band-beacon-theatre-dave-matthews-band-beacon-theatre-2009-2009
1532	Dave Matthews Band - Foro Sol - 2015	\N	2015-05-15	4000.00	1	115	2018-03-24 16:58:38.477832	2018-03-24 17:00:38.529031	\N	\N	\N	dave-matthews-band-foro-sol-dave-matthews-band-foro-sol-2015-2015
1533	Dave Matthews Band - 2015	\N	2015-05-13	5000.00	1	\N	2018-03-24 16:58:46.320716	2018-03-24 17:02:00.957434	\N	\N	\N	dave-matthews-band-dave-matthews-band-2015-2015
1534	Dave Matthews Band - Austin360 Amphitheater - 2015	\N	2015-05-13	4000.00	1	80	2018-03-24 16:58:40.278888	2018-03-24 17:00:58.204284	\N	\N	\N	dave-matthews-band-austin360-amphitheater-dave-matthews-band-austin360-amphitheater-2015-2015
1535	Dave Matthews Band - Gexa Energy Pavilion - 2015	\N	2015-05-15	5000.00	1	66	2018-03-24 16:58:41.56886	2018-03-24 17:01:12.586932	\N	\N	\N	dave-matthews-band-gexa-energy-pavilion-dave-matthews-band-gexa-energy-pavilion-2015-2015
1536	Dave Matthews Band - Nikon at Jones Beach Theater - 2015	\N	2015-06-09	5000.00	1	14	2018-03-24 16:58:45.364109	2018-03-24 17:01:51.893736	\N	\N	\N	dave-matthews-band-nikon-at-jones-beach-theater-dave-matthews-band-nikon-at-jones-beach-theater-2015-2015
1537	Dave Matthews Band - XFINITY Theatre - 2015	\N	2015-06-12	5000.00	1	46	2018-03-24 16:58:46.347847	2018-03-24 17:02:01.42389	\N	\N	\N	dave-matthews-band-xfinity-theatre-dave-matthews-band-xfinity-theatre-2015-2015
1538	Dave Matthews Band - Wells Fargo Arena - 2015	\N	2015-06-30	5000.00	1	92	2018-03-24 16:58:41.038318	2018-03-24 17:01:06.274607	\N	\N	\N	dave-matthews-band-wells-fargo-arena-dave-matthews-band-wells-fargo-arena-2015-2015
1539	Dave Matthews Band - Xcel Energy Center - 2015	\N	2015-07-01	4000.00	1	109	2018-03-24 16:58:41.518265	2018-03-24 17:01:11.89894	\N	\N	\N	dave-matthews-band-xcel-energy-center-dave-matthews-band-xcel-energy-center-2015-2015
1540	Dave Matthews Band - PNC Music Pavillion - 2015	\N	2015-07-10	5000.00	1	1	2018-03-24 16:58:39.387156	2018-03-24 17:00:48.12362	\N	\N	\N	dave-matthews-band-pnc-music-pavillion-dave-matthews-band-pnc-music-pavillion-2015-2015
1541	Dave Matthews Band - DTE Energy Music Theatre - 2015	\N	2015-07-07	5000.00	1	55	2018-03-24 16:58:41.809	2018-03-24 17:01:15.829607	\N	\N	\N	dave-matthews-band-dte-energy-music-theatre-dave-matthews-band-dte-energy-music-theatre-2015-2015
1542	Dave Matthews Band - Cricket Wireless Amphitheatre - 2015	\N	2015-07-14	4000.00	1	116	2018-03-24 16:58:38.591326	2018-03-24 17:00:40.883886	\N	\N	\N	dave-matthews-band-cricket-wireless-amphitheatre-dave-matthews-band-cricket-wireless-amphitheatre-2015-2015
1543	Dave Matthews Band - Hollywood Casino Amphitheatre - 2015	\N	2015-07-15	5000.00	1	71	2018-03-24 16:58:41.702171	2018-03-24 17:01:14.759613	\N	\N	\N	dave-matthews-band-hollywood-casino-amphitheatre-dave-matthews-band-hollywood-casino-amphitheatre-2015-2015
1544	Dave Matthews Band - Saratoga Springs Performing Arts Center - 2015	\N	2015-07-03	5000.00	1	5	2018-03-24 16:58:40.22631	2018-03-24 17:00:57.528377	\N	\N	\N	dave-matthews-band-saratoga-springs-performing-arts-center-dave-matthews-band-saratoga-springs-performing-arts-center-2015-2015
1545	Dave Matthews Band - Ruoff Home Mortgage Music Center - 2015	\N	2015-07-17	4000.00	1	16	2018-03-24 16:58:38.685679	2018-03-24 17:00:42.011982	\N	\N	\N	dave-matthews-band-ruoff-home-mortgage-music-center-dave-matthews-band-ruoff-home-mortgage-music-center-2015-2015
1546	Dave Matthews Band - Ruoff Home Mortgage Music Center - 2015		2015-07-18	5000.00	1	16	2018-03-24 16:58:41.835956	2018-06-02 22:29:26.413349	1080	\N	\N	dave-matthews-band-ruoff-home-mortgage-music-center-dave-matthews-band-ruoff-home-mortgage-music-center-2015-2015-1
1547	Dave Matthews Band - Budweiser Stage - 2015	\N	2015-07-21	5000.00	1	4	2018-03-24 16:58:36.327606	2018-03-24 17:00:16.314089	\N	\N	\N	dave-matthews-band-budweiser-stage-dave-matthews-band-budweiser-stage-2015-2015
1549	Dave Matthews Band - Fiddler's Green Amphitheatre - 2015	\N	2015-08-29	5000.00	1	18	2018-03-24 16:58:38.237047	2018-03-24 17:00:33.416075	\N	\N	\N	dave-matthews-band-fiddler-s-green-amphitheatre-dave-matthews-band-fiddler-s-green-amphitheatre-2015-2015
1550	Dave Matthews Band - Centre Bell - 2015	\N	2015-07-23	4000.00	1	94	2018-03-24 16:58:40.367102	2018-03-24 17:00:59.015513	\N	\N	\N	dave-matthews-band-centre-bell-dave-matthews-band-centre-bell-2015-2015
1551	Dave Matthews Band - Fiddler's Green Amphitheatre - 2015	\N	2015-08-28	5000.00	1	18	2018-03-24 16:58:41.923434	2018-03-24 17:01:16.904186	\N	\N	\N	dave-matthews-band-fiddler-s-green-amphitheatre-dave-matthews-band-fiddler-s-green-amphitheatre-2015-2015-1
1552	Dave Matthews Band - MEO Arena - 2015	\N	2015-11-10	5000.00	1	135	2018-03-24 16:58:38.795052	2018-03-24 17:00:43.396653	\N	\N	\N	dave-matthews-band-meo-arena-dave-matthews-band-meo-arena-2015-2015
1553	Dave Matthews Band - 2015	\N	2015-07-29	5000.00	1	\N	2018-03-24 16:58:41.760409	2018-03-24 17:01:15.193256	\N	\N	\N	dave-matthews-band-dave-matthews-band-2015-2015-1
1554	Dave Matthews Band - 2015	\N	2015-10-17	4000.00	1	\N	2018-03-24 16:58:40.151109	2018-03-24 17:00:56.236746	\N	\N	\N	dave-matthews-band-dave-matthews-band-2015-2015-2
1555	Dave Matthews Band - Rogers Arena - 2015	\N	2015-09-01	4000.00	1	128	2018-03-24 16:58:43.942514	2018-03-24 17:01:38.309634	\N	\N	\N	dave-matthews-band-rogers-arena-dave-matthews-band-rogers-arena-2015-2015
1556	Dave Matthews Band - AFAS Live - 2015	\N	2015-11-02	4000.00	1	22	2018-03-24 16:58:40.399984	2018-03-24 17:00:59.294076	\N	\N	\N	dave-matthews-band-afas-live-dave-matthews-band-afas-live-2015-2015
1557	Dave Matthews Band - 2015	\N	2015-10-28	5000.00	1	\N	2018-03-24 16:58:41.949109	2018-03-24 17:01:17.217182	\N	\N	\N	dave-matthews-band-dave-matthews-band-2015-2015-3
1558	Dave Matthews Band - Lake Tahoe Outdoor Arena - 2015	\N	2015-09-09	4000.00	1	70	2018-03-24 16:58:37.117461	2018-03-24 17:00:24.383621	\N	\N	\N	dave-matthews-band-lake-tahoe-outdoor-arena-dave-matthews-band-lake-tahoe-outdoor-arena-2015-2015
1559	Dave Matthews Band - Le Zénith - 2015	\N	2015-11-05	4000.00	1	137	2018-03-24 16:58:38.740646	2018-03-24 17:00:42.727832	\N	\N	\N	dave-matthews-band-le-zenith-dave-matthews-band-le-zenith-2015-2015
1560	Dave Matthews Band - Shoreline Amphitheater - 2015	\N	2015-09-11	5000.00	1	40	2018-03-24 16:58:44.344804	2018-03-24 17:01:42.376453	\N	\N	\N	dave-matthews-band-shoreline-amphitheater-dave-matthews-band-shoreline-amphitheater-2015-2015
1561	Dave Matthews Band - Pier 70 - 2016	\N	2016-02-04	5000.00	1	89	2018-03-24 16:58:40.955771	2018-03-24 17:01:05.021945	\N	\N	\N	dave-matthews-band-pier-70-dave-matthews-band-pier-70-2016-2016
1562	Dave Matthews Band - Mitsubishi Electric Halle - 2015	\N	2015-11-01	5000.00	1	113	2018-03-24 16:58:41.147547	2018-03-24 17:01:07.302704	\N	\N	\N	dave-matthews-band-mitsubishi-electric-halle-dave-matthews-band-mitsubishi-electric-halle-2015-2015
1563	Dave Matthews Band - Forest National - 2015	\N	2015-11-04	5000.00	1	134	2018-03-24 16:58:37.428273	2018-03-24 17:00:25.576268	\N	\N	\N	dave-matthews-band-forest-national-dave-matthews-band-forest-national-2015-2015
1564	Dave Matthews Band - Columbiahalle - 2015	\N	2015-10-27	5000.00	1	154	2018-03-24 16:58:39.244674	2018-03-24 17:00:46.494788	\N	\N	\N	dave-matthews-band-columbiahalle-dave-matthews-band-columbiahalle-2015-2015
1566	Dave Matthews Band - 3Arena - 2015	\N	2015-11-13	4000.00	1	130	2018-03-24 16:58:40.477549	2018-03-24 17:01:00.141482	\N	\N	\N	dave-matthews-band-3arena-dave-matthews-band-3arena-2015-2015
1567	Live Trax Promotion	\N	2016-08-01	4000.00	1	\N	2018-03-24 16:58:44.428611	2018-03-24 17:01:43.126459	\N	\N	\N	dave-matthews-band-live-trax-promotion-2016
1568	Dave Matthews Band - Cynthia Woods Mitchell Pavilion - 2016	\N	2016-05-13	5000.00	1	2	2018-03-24 16:58:37.400822	2018-03-24 17:00:25.262314	\N	\N	\N	dave-matthews-band-cynthia-woods-mitchell-pavilion-dave-matthews-band-cynthia-woods-mitchell-pavilion-2016-2016
1569	Dave Matthews Band - The O2 Arena - 2016	\N	2016-11-02	4000.00	1	74	2018-03-24 16:58:43.080101	2018-03-24 17:01:30.949181	\N	\N	\N	dave-matthews-band-the-o2-arena-dave-matthews-band-the-o2-arena-2016-2016
1570	Dave Matthews Band - Verizon Center - 2016	\N	2016-05-18	4000.00	1	84	2018-03-24 16:58:38.820955	2018-03-24 17:00:43.880719	\N	\N	\N	dave-matthews-band-verizon-center-dave-matthews-band-verizon-center-2016-2016
1571	Dave Matthews Band - Intrust Bank Arena - 2016	\N	2016-05-11	5000.00	1	53	2018-03-24 16:58:40.531217	2018-03-24 17:01:00.685264	\N	\N	\N	dave-matthews-band-intrust-bank-arena-dave-matthews-band-intrust-bank-arena-2016-2016
1572	Dave Matthews Band - 2016	\N	2016-05-17	5000.00	1	\N	2018-03-24 16:58:42.02733	2018-03-24 17:01:18.169981	\N	\N	\N	dave-matthews-band-dave-matthews-band-2016-2016
1573	Dave Matthews Band - The O2 Arena - 2015	\N	2015-11-07	5000.00	1	74	2018-03-24 16:58:39.466751	2018-03-24 17:00:49.125233	\N	\N	\N	dave-matthews-band-the-o2-arena-dave-matthews-band-the-o2-arena-2015-2015
1574	Dave Matthews Band - PNC Music Pavillion - 2016	\N	2016-05-27	5000.00	1	1	2018-03-24 16:58:37.987161	2018-03-24 17:00:30.767531	\N	\N	\N	dave-matthews-band-pnc-music-pavillion-dave-matthews-band-pnc-music-pavillion-2016-2016
1575	Dave Matthews Band - Blossom Music Center - 2016	\N	2016-05-21	5000.00	1	39	2018-03-24 16:58:42.438151	2018-03-24 17:01:24.557581	\N	\N	\N	dave-matthews-band-blossom-music-center-dave-matthews-band-blossom-music-center-2016-2016
1576	Dave Matthews Band - Oak Mountain Amphitheatre - 2016	\N	2016-05-24	5000.00	1	56	2018-03-24 16:58:39.920746	2018-03-24 17:00:53.597249	\N	\N	\N	dave-matthews-band-oak-mountain-amphitheatre-dave-matthews-band-oak-mountain-amphitheatre-2016-2016
1577	Dave Matthews Band - Riverbend Music Center - 2016		2016-05-20	5000.00	1	44	2018-03-24 16:58:42.054748	2018-05-19 13:55:49.193149	\N	\N	\N	dave-matthews-band-riverbend-music-center-dave-matthews-band-riverbend-music-center-2016-2016
1578	Dave Matthews Band - Hollywood Casino Amphitheatre - 2016	\N	2016-05-29	5000.00	1	71	2018-03-24 16:58:39.219417	2018-03-24 17:00:46.160047	\N	\N	\N	dave-matthews-band-hollywood-casino-amphitheatre-dave-matthews-band-hollywood-casino-amphitheatre-2016-2016
1579	Dave Matthews Band - XFINITY Theatre - 2016	\N	2016-06-11	5000.00	1	46	2018-03-24 16:58:40.684051	2018-03-24 17:01:02.264665	\N	\N	\N	dave-matthews-band-xfinity-theatre-dave-matthews-band-xfinity-theatre-2016-2016
1580	Dave Matthews Band - Darling's Waterfront Pavillion - 2016	\N	2016-06-08	4000.00	1	127	2018-03-24 16:58:41.650298	2018-03-24 17:01:13.493651	\N	\N	\N	dave-matthews-band-darling-s-waterfront-pavillion-dave-matthews-band-darling-s-waterfront-pavillion-2016-2016
1581	Dave Matthews Band - Veterans United Home Loans Amphitheatre - 2016	\N	2016-06-17	5000.00	1	11	2018-03-24 16:58:37.541291	2018-03-24 17:00:26.646671	\N	\N	\N	dave-matthews-band-veterans-united-home-loans-amphitheatre-dave-matthews-band-veterans-united-home-loans-amphitheatre-2016-2016
1582	Dave Matthews Band - PNC Banks Art Center - 2016	\N	2016-08-17	4000.00	1	85	2018-03-24 16:58:38.877223	2018-03-24 17:00:44.398892	\N	\N	\N	dave-matthews-band-pnc-banks-art-center-dave-matthews-band-pnc-banks-art-center-2016-2016
1583	Dave Matthews Band - Jiffy Lube Live - 2016	\N	2016-06-18	5000.00	1	33	2018-03-24 16:58:42.078756	2018-03-24 17:01:18.755237	\N	\N	\N	dave-matthews-band-jiffy-lube-live-dave-matthews-band-jiffy-lube-live-2016-2016
1584	Dave Matthews Band - Nikon at Jones Beach Theater - 2016	\N	2016-06-21	5000.00	1	14	2018-03-24 16:58:40.839932	2018-03-24 17:01:03.730793	\N	\N	\N	dave-matthews-band-nikon-at-jones-beach-theater-dave-matthews-band-nikon-at-jones-beach-theater-2016-2016
1585	Dave Matthews Band - Xfinity Center - 2016	\N	2016-06-10	5000.00	1	41	2018-03-24 16:58:42.1916	2018-03-24 17:01:21.838156	\N	\N	\N	dave-matthews-band-xfinity-center-dave-matthews-band-xfinity-center-2016-2016
1586	Dave Matthews Band - Lakeview Amphitheater - 2016	\N	2016-06-26	5000.00	1	81	2018-03-24 16:58:38.768177	2018-03-24 17:00:43.023369	\N	\N	\N	dave-matthews-band-lakeview-amphitheater-dave-matthews-band-lakeview-amphitheater-2016-2016
1587	Dave Matthews Band - 2016	\N	2016-06-28	5000.00	1	\N	2018-03-24 16:58:42.26962	2018-03-24 17:01:22.726152	\N	\N	\N	dave-matthews-band-dave-matthews-band-2016-2016-1
1588	Dave Matthews Band - BB&T Pavilion - 2016	\N	2016-06-25	5000.00	1	29	2018-03-24 16:58:39.14009	2018-03-24 17:00:45.408015	\N	\N	\N	dave-matthews-band-bb-t-pavilion-dave-matthews-band-bb-t-pavilion-2016-2016
1589	Dave Matthews Band - BB&T Pavilion - 2016	\N	2016-06-24	5000.00	1	29	2018-03-24 16:58:40.557152	2018-03-24 17:01:01.080646	\N	\N	\N	dave-matthews-band-bb-t-pavilion-dave-matthews-band-bb-t-pavilion-2016-2016-1
1590	Dave Matthews Band - Cricket Wireless Amphitheatre - 2016	\N	2016-06-29	5000.00	1	116	2018-03-24 16:58:43.756831	2018-03-24 17:01:36.258537	\N	\N	\N	dave-matthews-band-cricket-wireless-amphitheatre-dave-matthews-band-cricket-wireless-amphitheatre-2016-2016
1591	Dave Matthews & Tim Reynolds - CMAC - 2016	\N	2016-07-06	4000.00	2	82	2018-03-24 16:58:45.567155	2018-03-24 17:01:54.989752	\N	\N	\N	dave-matthews-tim-reynolds-cmac-dave-matthews-tim-reynolds-cmac-2016-2016
1592	Dave Matthews Band - Nationwide Arena - 2016	\N	2016-07-08	5000.00	1	75	2018-03-24 16:58:42.217641	2018-03-24 17:01:22.217201	\N	\N	\N	dave-matthews-band-nationwide-arena-dave-matthews-band-nationwide-arena-2016-2016
1593	Dave Matthews Band - Bank of New Hampshire Pavilion - 2016	\N	2016-07-12	5000.00	1	119	2018-03-24 16:58:40.773031	2018-03-24 17:01:03.07307	\N	\N	\N	dave-matthews-band-bank-of-new-hampshire-pavilion-dave-matthews-band-bank-of-new-hampshire-pavilion-2016-2016
1594	Dave Matthews Band - Alpine Valley Music Theatre - 2016	\N	2016-07-01	5000.00	1	12	2018-03-24 16:58:38.90566	2018-03-24 17:00:44.670905	\N	\N	\N	dave-matthews-band-alpine-valley-music-theatre-dave-matthews-band-alpine-valley-music-theatre-2016-2016
1595	Dave Matthews Band - First Niagara Pavilion - 2016		2016-07-09	5000.00	1	78	2018-03-24 16:58:43.782092	2018-07-02 12:40:33.755619	735	\N	\N	dave-matthews-band-first-niagara-pavilion-dave-matthews-band-first-niagara-pavilion-2016-2016
1596	Dave Matthews Band - Budweiser Stage - 2016	\N	2016-07-19	5000.00	1	4	2018-03-24 16:58:37.56869	2018-03-24 17:00:26.888175	\N	\N	\N	dave-matthews-band-budweiser-stage-dave-matthews-band-budweiser-stage-2016-2016
1597	Dave Matthews Band - 2016	\N	2016-07-13	5000.00	1	\N	2018-03-24 16:58:41.544943	2018-03-24 17:01:12.21672	\N	\N	\N	dave-matthews-band-dave-matthews-band-2016-2016-2
1598	Dave Matthews Band - Saratoga Springs Performing Arts Center - 2016	\N	2016-07-15	5000.00	1	5	2018-03-24 16:58:41.972364	2018-03-24 17:01:17.649874	\N	\N	\N	dave-matthews-band-saratoga-springs-performing-arts-center-dave-matthews-band-saratoga-springs-performing-arts-center-2016-2016
1599	Dave Matthews Band - Saratoga Springs Performing Arts Center - 2016	\N	2016-07-16	5000.00	1	5	2018-03-24 16:58:40.811679	2018-03-24 17:01:03.465294	\N	\N	\N	dave-matthews-band-saratoga-springs-performing-arts-center-dave-matthews-band-saratoga-springs-performing-arts-center-2016-2016-1
1600	Dave Matthews Band - DTE Energy Music Theatre - 2016	\N	2016-07-20	5000.00	1	55	2018-03-24 16:58:39.193883	2018-03-24 17:00:45.91566	\N	\N	\N	dave-matthews-band-dte-energy-music-theatre-dave-matthews-band-dte-energy-music-theatre-2016-2016
1601	Dave Matthews Band - North Charleston Coliseum - 2016	\N	2016-07-26	5000.00	1	31	2018-03-24 16:58:36.815739	2018-03-24 17:00:20.703685	\N	\N	\N	dave-matthews-band-north-charleston-coliseum-dave-matthews-band-north-charleston-coliseum-2016-2016
1602	Dave Matthews Band - Ruoff Home Mortgage Music Center - 2016	\N	2016-07-22	5000.00	1	16	2018-03-24 16:58:42.294956	2018-03-24 17:01:22.981376	\N	\N	\N	dave-matthews-band-ruoff-home-mortgage-music-center-dave-matthews-band-ruoff-home-mortgage-music-center-2016-2016
1603	Dave Matthews Band - Ruoff Home Mortgage Music Center - 2016	\N	2016-07-23	5000.00	1	16	2018-03-24 16:58:40.927943	2018-03-24 17:01:04.70081	\N	\N	\N	dave-matthews-band-ruoff-home-mortgage-music-center-dave-matthews-band-ruoff-home-mortgage-music-center-2016-2016-1
1604	Dave Matthews Band - Perfect Vodka Amphitheatre - 2016	\N	2016-07-29	5000.00	1	17	2018-03-24 16:58:41.232876	2018-03-24 17:01:08.580008	\N	\N	\N	dave-matthews-band-perfect-vodka-amphitheatre-dave-matthews-band-perfect-vodka-amphitheatre-2016-2016
1605	Dave Matthews Band - MidFlorida Credit Union Amphitheatre - 2016		2016-07-27	5000.00	1	43	2018-03-24 16:58:45.39634	2018-07-02 12:50:27.486537	600	\N	\N	dave-matthews-band-midflorida-credit-union-amphitheatre-dave-matthews-band-midflorida-credit-union-amphitheatre-2016-2016
1606	Dave Matthews Band - Perfect Vodka Amphitheatre - 2016	\N	2016-07-30	5000.00	1	17	2018-03-24 16:58:42.38363	2018-03-24 17:01:24.044904	\N	\N	\N	dave-matthews-band-perfect-vodka-amphitheatre-dave-matthews-band-perfect-vodka-amphitheatre-2016-2016-1
1607	Dave Matthews Band - Sleep Train Amphitheatre - 2016	\N	2016-08-26	5000.00	1	61	2018-03-24 16:58:40.869462	2018-03-24 17:01:04.044595	\N	\N	\N	dave-matthews-band-sleep-train-amphitheatre-dave-matthews-band-sleep-train-amphitheatre-2016-2016
1608	Dave Matthews Band - Gorge Amphitheatre - 2016	\N	2016-09-02	5000.00	1	9	2018-03-24 16:58:40.897667	2018-03-24 17:01:04.405761	\N	\N	\N	dave-matthews-band-gorge-amphitheatre-dave-matthews-band-gorge-amphitheatre-2016-2016
1609	Dave Matthews Band - Greek Theatre - 2016	\N	2016-08-29	5000.00	1	13	2018-03-24 16:58:43.83359	2018-03-24 17:01:37.14701	\N	\N	\N	dave-matthews-band-greek-theatre-dave-matthews-band-greek-theatre-2016-2016
1610	Dave Matthews Band - Greek Theatre - 2016	\N	2016-08-30	5000.00	1	13	2018-03-24 16:58:36.356888	2018-03-24 17:00:16.633153	\N	\N	\N	dave-matthews-band-greek-theatre-dave-matthews-band-greek-theatre-2016-2016-1
1611	Dave Matthews Band - Gorge Amphitheatre - 2016	\N	2016-09-03	5000.00	1	9	2018-03-24 16:58:42.131757	2018-03-24 17:01:19.241402	\N	\N	\N	dave-matthews-band-gorge-amphitheatre-dave-matthews-band-gorge-amphitheatre-2016-2016-1
1613	Dave Matthews Band - PNC Music Pavillion - 2014	\N	2014-07-22	4000.00	1	1	2018-03-24 16:58:44.06942	2018-04-07 22:23:18.856205	\N	\N	\N	dave-matthews-band-pnc-music-pavillion-dave-matthews-band-pnc-music-pavillion-2014-2014
1614	Dave Matthews Band - Veterans United Home Loans Amphitheatre - 2015		2015-07-11	5000.00	1	11	2018-03-24 16:58:44.959638	2018-05-16 02:04:38.467417	750	\N	\N	dave-matthews-band-veterans-united-home-loans-amphitheatre-dave-matthews-band-veterans-united-home-loans-amphitheatre-2015-2015
1615	Dave Matthews Band - Greek Theatre - 2014		2014-08-23	4000.00	1	13	2018-03-24 16:58:30.329199	2018-05-15 11:53:50.700106	1200	\N	\N	dave-matthews-band-greek-theatre-dave-matthews-band-greek-theatre-2014-2014
1616	Dave Matthews Band - Alpine Valley Music Theatre - 2016	\N	2016-07-02	5000.00	1	12	2018-03-24 16:58:42.463826	2018-03-24 17:01:24.842157	\N	\N	\N	dave-matthews-band-alpine-valley-music-theatre-dave-matthews-band-alpine-valley-music-theatre-2016-2016-1
1617	Dave Matthews Band - Alpine Valley Music Theatre - 2015	\N	2015-07-26	5000.00	1	12	2018-03-24 16:58:34.083112	2018-03-24 16:59:55.273908	\N	\N	\N	dave-matthews-band-alpine-valley-music-theatre-dave-matthews-band-alpine-valley-music-theatre-2015-2015
1618	Dave Matthews Band - 2016	\N	2016-05-11	5000.00	1	\N	2018-03-24 16:58:37.707651	2018-03-24 17:00:28.131846	\N	\N	\N	dave-matthews-band-dave-matthews-band-2016-2016-3
1619	Dave Matthews Band - Saratoga Springs Performing Arts Center - 2015	\N	2015-07-04	5000.00	1	5	2018-03-24 16:58:29.64818	2018-03-24 16:59:02.797269	\N	\N	\N	dave-matthews-band-saratoga-springs-performing-arts-center-dave-matthews-band-saratoga-springs-performing-arts-center-2015-2015-1
1620	Dave Matthews Band - Gorge Amphitheatre - 2016	\N	2016-09-04	5000.00	1	9	2018-03-24 16:58:45.510586	2018-03-24 17:01:53.77118	\N	\N	\N	dave-matthews-band-gorge-amphitheatre-dave-matthews-band-gorge-amphitheatre-2016-2016-2
1621	Dave Matthews Band - Gorge Amphitheatre - 2015	\N	2015-09-04	5000.00	1	9	2018-03-24 16:58:29.497097	2018-03-24 16:59:01.306745	\N	\N	\N	dave-matthews-band-gorge-amphitheatre-dave-matthews-band-gorge-amphitheatre-2015-2015
1622	Dave Matthews Band - Gorge Amphitheatre - 2015	\N	2015-09-04	5000.00	1	9	2018-03-24 16:58:29.979744	2018-03-24 16:59:09.624337	\N	\N	\N	dave-matthews-band-gorge-amphitheatre-dave-matthews-band-gorge-amphitheatre-2015-2015-1
1623	Dave Matthews Band - Gorge Amphitheatre - 2015	\N	2015-09-06	5000.00	1	9	2018-03-24 16:58:30.547621	2018-03-24 16:59:17.181785	\N	\N	\N	dave-matthews-band-gorge-amphitheatre-dave-matthews-band-gorge-amphitheatre-2015-2015-2
1624	Dave Matthews Band - Gorge Amphitheatre - 2015	\N	2015-09-05	5000.00	1	9	2018-03-24 16:58:30.615355	2018-03-24 16:59:17.698084	\N	\N	\N	dave-matthews-band-gorge-amphitheatre-dave-matthews-band-gorge-amphitheatre-2015-2015-3
1625	Dave Matthews Band - Gorge Amphitheatre - 2016	\N	2016-09-02	5000.00	1	9	2018-03-24 16:58:29.702701	2018-03-24 16:59:03.354193	\N	\N	\N	dave-matthews-band-gorge-amphitheatre-dave-matthews-band-gorge-amphitheatre-2016-2016-3
1626	Dave Matthews Band - Red Rocks Amphitheatre - 2005		2005-09-09	4000.00	1	106	2018-03-24 16:58:28.699119	2018-06-09 13:50:15.825465	\N	\N	\N	dave-matthews-band-red-rocks-amphitheatre-dave-matthews-band-red-rocks-amphitheatre-2005-2005
1627	Dave Matthews Band - MidFlorida Credit Union Amphitheatre - 2014	\N	2014-07-16	4000.00	1	43	2018-03-24 16:58:30.429344	2018-03-24 16:59:15.438935	\N	\N	\N	dave-matthews-band-midflorida-credit-union-amphitheatre-dave-matthews-band-midflorida-credit-union-amphitheatre-2014-2014
1628	Dave Matthews Band - The Amphitheater At the Wharf - 2015	\N	2015-06-02	5000.00	1	107	2018-03-24 16:58:31.954169	2018-04-22 20:22:46.508471	525	\N	\N	dave-matthews-band-the-amphitheater-at-the-wharf-dave-matthews-band-the-amphitheater-at-the-wharf-2015-2015
1629	Dave Matthews Band - Perfect Vodka Amphitheatre - 2015	\N	2015-08-01	5000.00	1	17	2018-03-24 16:58:31.597966	2018-03-24 16:59:28.290895	\N	\N	\N	dave-matthews-band-perfect-vodka-amphitheatre-dave-matthews-band-perfect-vodka-amphitheatre-2015-2015
1630	Foo Fighters - Fiddler's Green Amphitheatre - 2015	\N	2015-08-17	4000.00	4	18	2018-03-24 16:58:32.832885	2018-03-24 16:59:41.817114	\N	\N	\N	foo-fighters-fiddler-s-green-amphitheatre-foo-fighters-fiddler-s-green-amphitheatre-2015-2015
1631	Foo Fighters - Citi Field - 2015	\N	2015-07-15	5000.00	4	65	2018-03-24 16:58:32.869307	2018-03-24 16:59:42.178083	150	\N	\N	foo-fighters-citi-field-foo-fighters-citi-field-2015-2015
1632	Foo Fighters - Citi Field - 2015	\N	2015-07-15	5000.00	4	65	2018-03-24 16:58:33.84207	2018-03-24 16:59:52.781698	180	\N	\N	foo-fighters-citi-field-foo-fighters-citi-field-2015-2015-1
1633	Foo Fighters - Citi Field - 2015	\N	2015-07-15	5000.00	4	65	2018-03-24 16:58:46.377918	2018-03-24 17:02:01.923116	150	\N	\N	foo-fighters-citi-field-foo-fighters-citi-field-2015-2015-2
1634	Dave Matthews Band - Sleep Train Amphitheatre - 2014	\N	2014-09-05	4000.00	1	61	2018-03-24 16:58:34.113991	2018-03-24 16:59:55.611851	610	\N	\N	dave-matthews-band-sleep-train-amphitheatre-dave-matthews-band-sleep-train-amphitheatre-2014-2014
1635	Edward Sharpe and the Magnetic Zeros - Erie Canal Harbor - 2013	\N	2013-06-13	4000.00	5	108	2018-03-24 16:58:34.003644	2018-03-24 16:59:54.233114	155	\N	\N	edward-sharpe-and-the-magnetic-zeros-erie-canal-harbor-edward-sharpe-and-the-magnetic-zeros-erie-canal-harbor-2013-2013
1636	Dave Matthews Band - MEO Arena - 2007	\N	2007-05-25	4000.00	1	135	2018-03-24 16:58:29.952883	2018-03-24 16:59:09.266012	\N	\N	\N	dave-matthews-band-meo-arena-dave-matthews-band-meo-arena-2007-2007
1637	Dave Matthews Band - Forest National - 2007	\N	2007-05-27	4000.00	1	134	2018-03-24 16:58:29.764983	2018-03-24 16:59:05.273547	\N	\N	\N	dave-matthews-band-forest-national-dave-matthews-band-forest-national-2007-2007
1638	Dave Matthews Band - Wembley Arena - 2007	\N	2007-05-30	4000.00	1	155	2018-03-24 16:58:30.050128	2018-03-24 16:59:10.401834	\N	\N	\N	dave-matthews-band-wembley-arena-dave-matthews-band-wembley-arena-2007-2007
1639	Sidney Myer Music Bowl	\N	2014-04-17	5000.00	1	161	2018-03-24 16:58:29.463684	2018-03-24 16:59:00.938871	\N	\N	\N	dave-matthews-band-sidney-myer-music-bowl-sidney-myer-music-bowl-2014
1640	Dave Matthews Band - Estadio Luna Park - 2010	\N	2010-10-14	4000.00	1	168	2018-03-24 16:58:29.87544	2018-03-24 16:59:08.365432	\N	\N	\N	dave-matthews-band-estadio-luna-park-dave-matthews-band-estadio-luna-park-2010-2010
1641	Dave Matthews Band - Movistar Arena - 2010	\N	2010-10-16	4000.00	1	169	2018-03-24 16:58:30.103487	2018-03-24 16:59:12.294117	\N	\N	\N	dave-matthews-band-movistar-arena-dave-matthews-band-movistar-arena-2010-2010
1642	Dave Matthews & Tim Reynolds - Santa Barbara Bowl - 2006	\N	2006-10-29	4000.00	2	173	2018-03-24 16:58:29.531925	2018-03-24 16:59:01.562836	800	\N	\N	dave-matthews-tim-reynolds-santa-barbara-bowl-dave-matthews-tim-reynolds-santa-barbara-bowl-2006-2006-1
1643	Dave Matthews & Tim Reynolds - Wiltern Theatre - 2006	\N	2006-10-30	4000.00	2	174	2018-03-24 16:58:29.620879	2018-03-24 16:59:02.442825	800	\N	\N	dave-matthews-tim-reynolds-wiltern-theatre-dave-matthews-tim-reynolds-wiltern-theatre-2006-2006
1644	Dave Matthews Band - BB&T Pavilion - 2005	\N	2005-07-06	4000.00	1	29	2018-03-24 16:58:29.189112	2018-03-24 16:58:56.322149	\N	\N	\N	dave-matthews-band-bb-t-pavilion-dave-matthews-band-bb-t-pavilion-2005-2005-1
1645	Dave Matthews Band - Randalls Island - 2006	\N	2006-08-06	4000.00	1	42	2018-03-24 16:58:30.583192	2018-03-24 16:59:17.433405	\N	\N	\N	dave-matthews-band-randalls-island-dave-matthews-band-randalls-island-2006-2006-1
1646	Dave Matthews Band - John Paul Jones Arena - 2016	\N	2016-05-07	5000.00	1	30	2018-03-24 16:58:29.900802	2018-03-24 16:59:08.692178	\N	\N	\N	dave-matthews-band-john-paul-jones-arena-dave-matthews-band-john-paul-jones-arena-2016-2016
1647	Only The Fish Know	\N	2014-07-01	4000.00	\N	\N	2018-03-24 16:58:29.827449	2018-03-25 15:14:33.643858	40	\N	\N	only-the-fish-know-2014
1648	Floating Bottles #1	\N	2014-09-03	6000.00	\N	\N	2018-03-24 16:58:29.439147	2018-03-25 15:25:14.799067	15	\N	\N	floating-bottles-1-2014
1649	Floating Bottles #2	\N	2014-09-03	6000.00	\N	\N	2018-03-24 16:58:29.732995	2018-03-25 15:25:27.359448	15	\N	\N	floating-bottles-2-2014
1650	The Game	\N	2014-09-03	4000.00	\N	\N	2018-03-24 16:58:30.363979	2018-03-25 15:15:47.727736	25	\N	\N	the-game-2014
1651	Remember Me As a Time of Day	\N	2014-09-03	4000.00	\N	\N	2018-03-24 16:58:46.414792	2018-03-25 15:15:31.745409	25	\N	\N	remember-me-as-a-time-of-day-2014
1652	Blue Dream	\N	2014-09-03	4000.00	\N	\N	2018-03-24 16:58:30.081045	2018-03-25 15:15:18.619824	25	\N	\N	blue-dream-2014
1653	Spin the Bottle	\N	2014-09-03	2500.00	\N	\N	2018-03-24 16:58:30.388302	2018-03-25 15:15:00.963066	25	\N	\N	spin-the-bottle-2014
1654	Memory Elixir	\N	2014-09-03	2500.00	\N	\N	2018-03-24 16:58:29.853265	2018-03-25 15:14:47.470124	25	\N	\N	memory-elixir-2014
1655	Dreamy in a Bottle	\N	2014-09-03	2500.00	\N	\N	2018-03-24 16:58:30.40843	2018-03-25 15:14:18.863634	25	\N	\N	dreamy-in-a-bottle-2014
1656	Morgana	\N	2016-07-16	10000.00	\N	\N	2018-03-24 16:58:45.541285	2018-03-24 17:01:54.400509	150	\N	\N	morgana-2016
1657	Dave Matthews Band - Madison Square Garden - 2002	\N	2002-12-21	5000.00	1	23	2018-03-24 16:58:29.797155	2018-03-24 16:59:05.583719	\N	\N	\N	dave-matthews-band-madison-square-garden-dave-matthews-band-madison-square-garden-2002-2002
1658	The Sands of the Shimmering Sea	\N	2017-02-02	6500.00	\N	\N	2018-03-24 16:58:46.196276	2018-03-24 17:01:59.628207	46	\N	\N	the-sands-of-the-shimmering-sea-2017
1659	Dave Matthews & Tim Reynolds - DAR Constitution Hall - 2016	\N	2016-11-27	5000.00	2	165	2018-03-24 16:58:44.748218	2018-03-24 17:01:46.236891	\N	\N	\N	dave-matthews-tim-reynolds-dar-constitution-hall-dave-matthews-tim-reynolds-dar-constitution-hall-2016-2016
1660	Dave Matthews & Tim Reynolds - Smart Financial Centre at Sugar Land - 2017	\N	2017-01-25	5000.00	2	176	2018-03-24 16:58:45.240956	2018-03-24 17:01:50.578076	\N	\N	\N	dave-matthews-tim-reynolds-smart-financial-centre-at-sugar-land-dave-matthews-tim-reynolds-smart-financial-centre-at-sugar-land-2017-2017
1704	Dave Matthews & Tim Reynolds - Daily's Place - 2017	\N	2017-05-30	5000.00	2	192	2018-03-24 16:58:47.197613	2018-03-24 20:52:31.141571	\N	\N	\N	dave-matthews-tim-reynolds-daily-s-place-dave-matthews-tim-reynolds-daily-s-place-2017-2017
1661	Dave Matthews & Tim Reynolds - Verizon Theatre at Grand Prairie - 2017	\N	2017-01-26	5000.00	2	177	2018-03-24 16:58:45.799907	2018-03-24 17:01:57.485575	\N	\N	\N	dave-matthews-tim-reynolds-verizon-theatre-at-grand-prairie-dave-matthews-tim-reynolds-verizon-theatre-at-grand-prairie-2017-2017
1662	Dave Matthews & Tim Reynolds - Riviera Maya - 2017	\N	2017-02-23	5000.00	2	178	2018-03-24 16:58:44.48349	2018-03-24 17:01:43.789367	\N	\N	\N	dave-matthews-tim-reynolds-riviera-maya-dave-matthews-tim-reynolds-riviera-maya-2017-2017
1664	Dave Matthews & Tim Reynolds - Riviera Maya - 2017	\N	2017-02-24	5000.00	2	178	2018-03-24 16:58:45.631558	2018-03-24 17:01:55.822307	\N	\N	\N	dave-matthews-tim-reynolds-riviera-maya-dave-matthews-tim-reynolds-riviera-maya-2017-2017-1
1665	Dave Matthews & Tim Reynolds - Riviera Maya - 2017	\N	2017-02-25	5000.00	2	178	2018-03-24 16:58:45.659778	2018-03-24 17:01:56.234086	\N	\N	\N	dave-matthews-tim-reynolds-riviera-maya-dave-matthews-tim-reynolds-riviera-maya-2017-2017-2
1666	Change Into a Truck	\N	2025-06-29	7500.00	\N	\N	2018-03-24 16:58:44.611123	2018-03-24 17:01:44.944002	75	\N	\N	change-into-a-truck-2025
1667	Wide Spread Panic - The Fox Theatre - 2016	\N	2016-07-14	11000.00	7	179	2018-03-24 16:58:45.827691	2018-03-24 17:01:57.738675	100	\N	\N	wide-spread-panic-the-fox-theatre-wide-spread-panic-the-fox-theatre-2016-2016
1668	Blown Away Guy - Black Silk	\N	2025-06-29	10000.00	\N	\N	2018-03-24 16:58:45.74842	2018-03-24 17:01:56.876828	200	\N	\N	blown-away-guy-black-silk-2025
1669	Blown Away Guy - Foil	\N	2025-06-29	7500.00	\N	\N	2018-03-24 16:58:46.222994	2018-03-24 17:01:59.934316	\N	\N	\N	blown-away-guy-foil-2025
1670	DMB Virginia Beach - Blue Linen	\N	2015-07-11	\N	1	\N	2018-03-24 16:58:44.549026	2018-04-01 23:46:56.368913	30	\N	\N	dave-matthews-band-dmb-virginia-beach-blue-linen-2015
1671	DMB Virginia Beach - Blue Opal		2015-07-11	\N	1	11	2018-03-24 16:58:45.133669	2018-11-23 03:01:18.800834	20	\N	\N	dave-matthews-band-veterans-united-home-loans-amphitheatre-dmb-virginia-beach-blue-opal-2015
1672	DMB Virginia Beach - Parchment	\N	2015-07-11	\N	1	\N	2018-03-24 16:58:45.601259	2018-03-24 17:01:55.344106	\N	\N	\N	dave-matthews-band-dmb-virginia-beach-parchment-2015
1673	DMB Virginia Beach - Rose Hair	\N	2015-07-11	\N	1	\N	2018-03-24 16:58:44.580942	2018-04-01 23:43:57.946476	25	\N	\N	dave-matthews-band-dmb-virginia-beach-rose-hair-2015
1674	DMB Virginia Beach - Black Satin	\N	2015-07-11	\N	1	\N	2018-03-24 16:58:44.899052	2018-04-01 13:34:42.874486	20	\N	\N	dave-matthews-band-dmb-virginia-beach-black-satin-2015
1675	DMB Tampa Dawn	\N	2016-07-27	5000.00	1	43	2018-03-24 16:58:44.514842	2018-03-24 17:01:44.213597	50	\N	\N	dave-matthews-band-midflorida-credit-union-amphitheatre-dmb-tampa-dawn-2016
1676	The Head and the Heart - Red Rocks Amphitheatre - 2016	\N	2016-08-28	3500.00	8	106	2018-03-24 16:58:45.719548	2018-03-24 17:01:56.673793	\N	\N	\N	the-head-and-the-heart-red-rocks-amphitheatre-the-head-and-the-heart-red-rocks-amphitheatre-2016-2016
1678	The Summoning Portals	\N	2017-03-07	5000.00	\N	\N	2018-03-24 16:58:44.998628	2018-03-24 17:01:49.171435	70	\N	\N	the-summoning-portals-2017
1679	Okeechobee Music and Arts Festival	\N	2017-03-02	4000.00	\N	180	2018-03-24 16:58:44.637437	2018-03-24 17:01:45.29178	\N	\N	\N	okeechobee-music-and-arts-festival-okeechobee-music-and-arts-festival-2017
1680	SXSW - 2017	\N	2017-03-10	7500.00	\N	181	2018-03-24 16:58:44.404062	2018-03-24 17:01:42.880947	300	\N	\N	sxsw-sxsw-2017-2017
1681	And in the End Was the Beginning	\N	2013-08-01	10000.00	\N	\N	2018-03-24 16:58:45.456463	2018-03-24 17:01:52.869085	\N	\N	\N	and-in-the-end-was-the-beginning-2013
1682	Mermaid Weather	\N	2014-04-18	6000.00	\N	\N	2018-03-24 16:58:45.335993	2018-03-24 17:01:51.410918	25	\N	\N	mermaid-weather-2014
1683	The Avett Brothers - Bojangles Coliseum - 2016	\N	2016-12-31	4000.00	9	182	2018-03-24 16:58:45.77032	2018-03-24 17:01:57.185064	\N	\N	\N	the-avett-brothers-bojangles-coliseum-the-avett-brothers-bojangles-coliseum-2016-2016
1684	Avett Brothers VIP Poster Silver Shimmer	\N	2016-12-31	5000.00	9	182	2018-03-24 16:58:45.203482	2018-03-24 17:01:50.318765	10	\N	\N	the-avett-brothers-bojangles-coliseum-avett-brothers-vip-poster-silver-shimmer-2016
1685	Avett Brothers VIP Poster Foil	\N	2016-12-31	10000.00	9	182	2018-03-24 16:58:46.114695	2018-03-24 17:01:58.913239	10	\N	\N	the-avett-brothers-bojangles-coliseum-avett-brothers-vip-poster-foil-2016
1686	Dave Matthews Band SPAC Pearlescent		2016-07-15	10000.00	1	5	2018-03-24 16:58:46.150469	2018-11-30 01:17:43.251731	100	\N	\N	dave-matthews-band-saratoga-springs-performing-arts-center-dave-matthews-band-spac-pearlescent-2016
1687	The Avett Brothers - Bojangles Coliseum - 2016	\N	2016-12-31	4000.00	9	182	2018-03-24 16:58:46.487801	2018-03-24 17:02:03.540592	150	\N	\N	the-avett-brothers-bojangles-coliseum-the-avett-brothers-bojangles-coliseum-2016-2016-1
1688	Dave Matthews Band - Irvine Meadows Amphitheatre - 2014	\N	2014-09-06	4000.00	1	96	2018-03-24 16:58:46.599783	2018-03-24 17:02:04.207496	755	\N	\N	dave-matthews-band-irvine-meadows-amphitheatre-dave-matthews-band-irvine-meadows-amphitheatre-2014-2014
1689	SXSW - 2017	\N	2017-03-19	15000.00	\N	181	2018-03-24 16:58:46.663506	2018-03-24 17:02:05.793545	40	\N	\N	sxsw-sxsw-2017-2017-1
1690	Dave Matthews & Tim Reynolds - Eventim Apollo - 2017	\N	2017-03-20	3500.00	2	183	2018-03-24 16:58:46.703846	2018-03-24 17:02:06.100282	325	\N	\N	dave-matthews-tim-reynolds-eventim-apollo-dave-matthews-tim-reynolds-eventim-apollo-2017-2017
1691	Dave Matthews & Tim Reynolds - Eventim Apollo - 2017	\N	2017-03-21	4000.00	2	183	2018-03-24 16:58:46.978442	2018-03-24 17:02:07.05601	350	\N	\N	dave-matthews-tim-reynolds-eventim-apollo-dave-matthews-tim-reynolds-eventim-apollo-2017-2017-1
1692	Dave Matthews & Tim Reynolds - Royal Arena - 2017	\N	2017-03-29	4000.00	2	184	2018-03-24 16:58:47.163774	2018-03-24 17:02:11.40481	\N	\N	\N	dave-matthews-tim-reynolds-royal-arena-dave-matthews-tim-reynolds-royal-arena-2017-2017
1694	Dave Matthews & Tim Reynolds - Olympia Theatre - 2017	\N	2017-03-23	4000.00	2	185	2018-03-24 16:58:47.261236	2018-03-24 17:02:12.923775	\N	\N	\N	dave-matthews-tim-reynolds-olympia-theatre-dave-matthews-tim-reynolds-olympia-theatre-2017-2017
1695	Dave Matthews & Tim Reynolds - De Oosterpoort - 2017	\N	2017-03-25	4000.00	2	186	2018-03-24 16:58:47.380615	2018-03-24 17:02:14.694936	\N	\N	\N	dave-matthews-tim-reynolds-de-oosterpoort-dave-matthews-tim-reynolds-de-oosterpoort-2017-2017
1696	Dave Matthews & Tim Reynolds - 2017	\N	2017-04-04	4000.00	2	\N	2018-03-24 16:58:47.408883	2018-03-24 17:02:15.144672	\N	\N	\N	dave-matthews-tim-reynolds-dave-matthews-tim-reynolds-2017-2017
1697	Dave Matthews & Tim Reynolds - 2017	\N	2017-03-27	4000.00	2	\N	2018-03-24 16:58:47.436916	2018-03-24 17:02:15.52189	\N	\N	\N	dave-matthews-tim-reynolds-dave-matthews-tim-reynolds-2017-2017-1
1698	Dave Matthews & Tim Reynolds - AFAS Live - 2017		2017-03-26	4000.00	2	22	2018-03-24 16:58:47.511905	2018-05-17 01:29:49.116496	340	\N	\N	dave-matthews-tim-reynolds-afas-live-dave-matthews-tim-reynolds-afas-live-2017-2017
1699	Dave Matthews & Tim Reynolds - 2017	\N	2017-04-01	4000.00	2	\N	2018-03-24 16:58:47.489014	2018-03-24 17:02:16.255856	\N	\N	\N	dave-matthews-tim-reynolds-dave-matthews-tim-reynolds-2017-2017-2
1700	Dave Matthews & Tim Reynolds - 2017	\N	2017-04-10	4000.00	2	\N	2018-03-24 16:58:47.462806	2018-03-24 17:02:15.890231	\N	\N	\N	dave-matthews-tim-reynolds-dave-matthews-tim-reynolds-2017-2017-3
1701	Dave Matthews & Tim Reynolds - Tuscaloosa Amphitheater - 2017	\N	2017-05-03	5000.00	2	193	2018-03-24 16:58:47.355614	2018-03-24 20:55:12.397492	\N	\N	\N	dave-matthews-tim-reynolds-tuscaloosa-amphitheater-dave-matthews-tim-reynolds-tuscaloosa-amphitheater-2017-2017
1702	Dave Matthews & Tim Reynolds - Ascend Amphitheatre - 2017		2017-05-06	5000.00	2	191	2018-03-24 16:58:47.293784	2018-05-08 12:06:20.931126	660	\N	\N	dave-matthews-tim-reynolds-ascend-amphitheatre-dave-matthews-tim-reynolds-ascend-amphitheatre-2017-2017
1703	Dave Matthews & Tim Reynolds - Ascend Amphitheatre - 2017	\N	2017-05-07	5000.00	2	191	2018-03-24 16:58:47.229642	2018-04-03 13:09:46.468643	715	\N	\N	dave-matthews-tim-reynolds-ascend-amphitheatre-dave-matthews-tim-reynolds-ascend-amphitheatre-2017-2017-1
1705	Dave Matthews & Tim Reynolds - Verizon Wireless Amphitheatre at Encore Park - 2017	\N	2017-05-31	5000.00	2	24	2018-03-24 16:58:47.13196	2018-03-24 20:34:33.122659	\N	\N	\N	dave-matthews-tim-reynolds-verizon-wireless-amphitheatre-at-encore-park-dave-matthews-tim-reynolds-verizon-wireless-amphitheatre-at-encore-park-2017-2017
1706	Dave Matthews & Tim Reynolds - Saratoga Springs Performing Arts Center - 2017	All prints have an error in the name of the city & state.  The poster should read Saratoga Springs, NY however it reads Saratoga, FL.	2017-06-16	5000.00	2	5	2018-03-24 16:58:47.100465	2018-06-03 15:45:04.153556	\N	\N	\N	dave-matthews-tim-reynolds-saratoga-springs-performing-arts-center-dave-matthews-tim-reynolds-saratoga-springs-performing-arts-center-2017-2017
1707	Dave Matthews & Tim Reynolds - Blossom Music Center - 2017	\N	2017-06-14	5000.00	2	39	2018-03-24 16:58:47.067956	2018-03-24 17:02:09.243192	\N	\N	\N	dave-matthews-tim-reynolds-blossom-music-center-dave-matthews-tim-reynolds-blossom-music-center-2017-2017
1708	Dave Matthews & Tim Reynolds - CMAC - 2017	\N	2017-06-04	5000.00	2	82	2018-03-24 16:58:47.024781	2018-03-24 17:02:08.846446	\N	\N	\N	dave-matthews-tim-reynolds-cmac-dave-matthews-tim-reynolds-cmac-2017-2017
1709	Dave Matthews & Tim Reynolds - Mann Center for the Performing Arts - 2017	\N	2017-06-02	5000.00	2	190	2018-03-24 16:58:46.93836	2018-03-24 20:47:21.05315	\N	\N	\N	dave-matthews-tim-reynolds-mann-center-for-the-performing-arts-dave-matthews-tim-reynolds-mann-center-for-the-performing-arts-2017-2017
1710	Trey Anastasio - Knight Theatre - 2018	\N	2018-02-17	4000.00	10	187	2018-03-24 16:58:46.250156	2018-03-24 17:02:00.224749	225	\N	\N	trey-anastasio-knight-theatre-trey-anastasio-knight-theatre-2018-2018
1712	Dave Matthews Band - Xcel Energy Center - 2018		2018-02-03	5000.00	1	109	2018-03-24 17:39:47.13606	2018-09-29 15:28:36.322444	650	\N	\N	dave-matthews-band-xcel-energy-center-dave-matthews-band-xcel-energy-center-2018-2018
1713	Dave Matthews & Tim Reynolds - Irving Plaza - 2018	\N	2018-01-28	5000.00	2	188	2018-03-24 18:20:34.558593	2018-03-24 18:25:19.33594	\N	\N	\N	dave-matthews-tim-reynolds-irving-plaza-dave-matthews-tim-reynolds-irving-plaza-2018-2018
1714	Dave Matthews & Tim Reynolds - Riviera Maya - 2018	\N	2018-01-14	5000.00	2	178	2018-03-24 19:40:04.100548	2018-03-24 19:40:04.113387	\N	\N	\N	dave-matthews-tim-reynolds-riviera-maya-dave-matthews-tim-reynolds-riviera-maya-2018-2018
1715	Dave Matthews & Tim Reynolds - Riviera Maya - 2018	\N	2018-01-13	5000.00	2	178	2018-03-24 19:41:32.282217	2018-04-01 13:38:08.051821	690	\N	\N	dave-matthews-tim-reynolds-riviera-maya-dave-matthews-tim-reynolds-riviera-maya-2018-2018-1
1716	Dave Matthews & Tim Reynolds - Riviera Maya - 2018	\N	2018-01-12	5000.00	2	178	2018-03-24 19:43:44.281424	2018-03-24 19:43:44.299408	\N	\N	\N	dave-matthews-tim-reynolds-riviera-maya-dave-matthews-tim-reynolds-riviera-maya-2018-2018-2
1717	Dave Matthews Band - Gorge Amphitheatre - 2016	\N	2016-09-04	5000.00	1	9	2018-03-24 19:44:50.238722	2018-03-24 19:48:03.556156	\N	\N	\N	dave-matthews-band-gorge-amphitheatre-dave-matthews-band-gorge-amphitheatre-2016-2016-4
1718	Dave Matthews & Tim Reynolds - Merriweather Post Pavillion - 2017	\N	2017-06-18	5000.00	2	189	2018-03-24 19:50:18.282843	2018-03-24 20:32:11.232897	\N	\N	\N	dave-matthews-tim-reynolds-merriweather-post-pavillion-dave-matthews-tim-reynolds-merriweather-post-pavillion-2017-2017
1719	Dave Matthews & Tim Reynolds - Saratoga Springs Performing Arts Center - 2017	\N	2017-06-17	5000.00	2	5	2018-03-24 19:51:42.158855	2018-03-24 19:52:14.439708	\N	\N	\N	dave-matthews-tim-reynolds-saratoga-springs-performing-arts-center-dave-matthews-tim-reynolds-saratoga-springs-performing-arts-center-2017-2017-1
1720	Dave Matthews & Tim Reynolds - Huntington Bank Pavilion - 2017	\N	2017-06-11	5000.00	2	194	2018-03-24 20:11:30.981851	2018-03-24 23:23:05.596951	\N	\N	\N	dave-matthews-tim-reynolds-huntington-bank-pavilion-dave-matthews-tim-reynolds-huntington-bank-pavilion-2017-2017
1721	Dave Matthews & Tim Reynolds - PNC Banks Art Center - 2017	\N	2017-06-07	5000.00	2	85	2018-03-24 20:14:12.859732	2018-03-24 20:14:12.876827	\N	\N	\N	dave-matthews-tim-reynolds-pnc-banks-art-center-dave-matthews-tim-reynolds-pnc-banks-art-center-2017-2017
1722	Vivien	\N	2016-04-26	\N	\N	\N	2018-03-24 23:47:43.481861	2018-03-25 15:36:31.802958	100	\N	\N	vivien-2016
1723	Built to Last	\N	2017-11-21	\N	\N	\N	2018-03-24 23:50:39.670578	2018-03-24 23:51:46.970932	500	\N	\N	built-to-last-2017
1724	Tangled Up In Blue	\N	2017-09-01	\N	\N	\N	2018-03-24 23:53:15.849525	2018-03-24 23:53:44.696018	500	\N	\N	tangled-up-in-blue-2017
1725	Orpheus	\N	2017-07-01	\N	\N	\N	2018-03-24 23:55:01.85845	2018-03-24 23:55:21.268692	500	\N	\N	orpheus-2017
1726	2016	\N	2016-11-01	\N	\N	\N	2018-03-24 23:56:32.8798	2018-03-24 23:56:32.884437	\N	\N	\N	2016-2016
1727	2013	\N	2013-09-27	\N	\N	\N	2018-03-25 14:04:16.318188	2018-03-25 14:04:16.328167	\N	\N	\N	2013-2013
1728	2015	\N	2015-07-19	\N	\N	\N	2018-03-25 14:12:27.510142	2018-03-25 14:12:27.537972	\N	\N	\N	2015-2015
1729	When You Wish Upon A Star – Venice	\N	2016-04-01	25000.00	\N	\N	2018-03-25 15:06:09.77245	2018-03-25 15:06:38.921171	100	\N	\N	when-you-wish-upon-a-star-venice-2016
1730	Dave Matthews Band - First Niagara Pavilion - 2015	\N	2015-06-16	\N	1	78	2018-03-25 19:31:27.374278	2018-03-25 19:31:27.403531	\N	\N	\N	dave-matthews-band-first-niagara-pavilion-dave-matthews-band-first-niagara-pavilion-2015-2015
1731	Dave Matthews & Tim Reynolds - DTE Energy Music Theatre - 2017	\N	2017-06-13	\N	2	55	2018-03-26 01:39:11.794443	2018-03-26 01:39:11.805544	\N	\N	\N	dave-matthews-tim-reynolds-dte-energy-music-theatre-dave-matthews-tim-reynolds-dte-energy-music-theatre-2017-2017
1732	Dave Matthews Band - 2012	\N	2012-07-18	4000.00	1	\N	2018-03-29 12:36:54.537752	2018-03-29 12:37:57.880261	\N	\N	\N	dave-matthews-band-dave-matthews-band-2012-2012-5
1733	Chris Thile & Brad Mehldau - 2013	\N	2013-04-09	\N	11	\N	2018-04-03 12:57:13.342091	2018-04-03 13:00:14.874563	250	\N	\N	chris-thile-brad-mehldau-chris-thile-brad-mehldau-2013-2013
1734	Dave Matthews Band - XFINITY Theatre - 2014	\N	2014-07-11	4000.00	1	46	2018-04-07 21:52:45.342802	2018-04-07 21:55:29.941807	\N	\N	\N	dave-matthews-band-xfinity-theatre-dave-matthews-band-xfinity-theatre-2014-2014-1
1735	Dave Matthews Band - Greek Theatre - 2014	\N	2014-08-22	4000.00	1	13	2018-04-07 22:26:35.580167	2018-04-16 11:53:41.011731	1075	\N	\N	dave-matthews-band-greek-theatre-dave-matthews-band-greek-theatre-2014-2014-1
1736	Dave Matthews Band - XFINITY Theatre - 2014	\N	2014-07-12	4000.00	1	46	2018-04-07 22:37:13.044434	2018-04-07 22:37:13.049335	\N	\N	\N	dave-matthews-band-xfinity-theatre-dave-matthews-band-xfinity-theatre-2014-2014-2
1737	Dave Matthews Band - Les Schwab Amphitheatre - 2014	\N	2014-08-26	\N	1	195	2018-04-07 22:38:24.548805	2018-04-07 22:42:01.92906	\N	\N	\N	dave-matthews-band-les-schwab-amphitheatre-dave-matthews-band-les-schwab-amphitheatre-2014-2014
1738	Dave Matthews Band - Perfect Vodka Amphitheatre - 2014	\N	2014-07-19	4000.00	1	17	2018-04-07 22:44:31.562537	2018-04-07 22:44:31.566118	\N	\N	\N	dave-matthews-band-perfect-vodka-amphitheatre-dave-matthews-band-perfect-vodka-amphitheatre-2014-2014
1739	Dave Matthews Band - Darien Lake Performing Arts Center - 2014		2014-06-11	4000.00	1	76	2018-04-07 22:47:11.347904	2018-05-21 00:32:24.299064	600	\N	\N	dave-matthews-band-darien-lake-performing-arts-center-dave-matthews-band-darien-lake-performing-arts-center-2014-2014
1740	Dave Matthews Band - BB&T Pavilion - 2014	\N	2014-06-13	4000.00	1	29	2018-04-07 22:49:21.162463	2018-04-07 22:49:21.166934	\N	\N	\N	dave-matthews-band-bb-t-pavilion-dave-matthews-band-bb-t-pavilion-2014-2014
1741	Dave Matthews Band - Gorge Amphitheatre - 2014	\N	2014-08-31	4000.00	1	9	2018-04-07 22:52:13.363073	2018-04-07 22:52:13.367381	\N	\N	\N	dave-matthews-band-gorge-amphitheatre-dave-matthews-band-gorge-amphitheatre-2014-2014
1742	Dave Matthews Band - Blossom Music Center - 2014		2014-06-27	4000.00	1	39	2018-04-07 23:59:41.252743	2018-12-26 21:11:28.850546	1700	\N	\N	dave-matthews-band-blossom-music-center-dave-matthews-band-blossom-music-center-2014-2014
1743	Dave Matthews Band - Coastal Credit Union Music Park - 2014	\N	2014-07-23	4000.00	1	105	2018-04-08 01:41:30.866067	2018-04-08 01:41:30.876997	\N	\N	\N	dave-matthews-band-coastal-credit-union-music-park-dave-matthews-band-coastal-credit-union-music-park-2014-2014
1744	Dave Matthews Band - Perfect Vodka Amphitheatre - 2014	\N	2014-07-18	4000.00	1	17	2018-04-08 01:42:46.472975	2018-04-08 02:22:04.671719	\N	\N	\N	dave-matthews-band-perfect-vodka-amphitheatre-dave-matthews-band-perfect-vodka-amphitheatre-2014-2014-1
1745	Dave Matthews Band - First Niagara Pavilion - 2014	\N	2014-06-28	4000.00	1	78	2018-04-08 01:47:04.982654	2018-04-08 02:21:27.490319	\N	\N	\N	dave-matthews-band-first-niagara-pavilion-dave-matthews-band-first-niagara-pavilion-2014-2014
1746	Dave Matthews Band - Ruoff Home Mortgage Music Center - 2014	\N	2014-06-20	4000.00	1	16	2018-04-08 01:48:40.483233	2018-04-08 01:48:40.490625	\N	\N	\N	dave-matthews-band-ruoff-home-mortgage-music-center-dave-matthews-band-ruoff-home-mortgage-music-center-2014-2014
1747	Dave Matthews Band - Veterans United Home Loans Amphitheatre - 2014	\N	2014-07-25	4000.00	1	11	2018-04-08 01:51:00.238807	2018-04-08 01:52:20.555133	675	\N	\N	dave-matthews-band-veterans-united-home-loans-amphitheatre-dave-matthews-band-veterans-united-home-loans-amphitheatre-2014-2014
1748	Dave Matthews Band - Huntington Bank Pavilion - 2014	\N	2014-07-05	4000.00	1	194	2018-04-08 01:54:07.52693	2018-05-07 20:22:36.465589	1405	\N	\N	dave-matthews-band-huntington-bank-pavilion-dave-matthews-band-huntington-bank-pavilion-2014-2014
1749	Dave Matthews Band - BB&T Pavilion - 2014	\N	2014-06-14	4000.00	1	29	2018-04-08 01:58:39.760239	2018-04-08 02:24:18.446542	40	\N	\N	dave-matthews-band-bb-t-pavilion-dave-matthews-band-bb-t-pavilion-2014-2014-1
1750	Dave Matthews Band - Gorge Amphitheatre - 2014	\N	2014-08-29	4000.00	1	9	2018-04-08 02:01:50.416288	2018-04-08 02:01:50.42507	\N	\N	\N	dave-matthews-band-gorge-amphitheatre-dave-matthews-band-gorge-amphitheatre-2014-2014-1
1751	Dave Matthews Band - Ruoff Home Mortgage Music Center - 2014	\N	2014-06-21	4000.00	1	16	2018-04-08 02:03:00.306545	2018-04-08 02:03:00.319575	\N	\N	\N	dave-matthews-band-ruoff-home-mortgage-music-center-dave-matthews-band-ruoff-home-mortgage-music-center-2014-2014-1
1752	Dave Matthews Band - Jacksonville Veterans Memorial Arena - 2014	\N	2014-07-15	4000.00	1	196	2018-04-08 02:04:13.366811	2018-04-08 02:05:50.500701	\N	\N	\N	dave-matthews-band-jacksonville-veterans-memorial-arena-dave-matthews-band-jacksonville-veterans-memorial-arena-2014-2014
1753	Dave Matthews Band - Greek Theatre - 2014	\N	2014-08-24	4000.00	1	13	2018-04-08 02:09:00.684551	2018-04-08 02:09:00.691669	\N	\N	\N	dave-matthews-band-greek-theatre-dave-matthews-band-greek-theatre-2014-2014-2
1754	Dave Matthews Band - Riverbend Music Center - 2014	\N	2014-07-09	4000.00	1	44	2018-04-08 02:10:05.93029	2018-04-08 02:10:05.940349	\N	\N	\N	dave-matthews-band-riverbend-music-center-dave-matthews-band-riverbend-music-center-2014-2014
1755	Dave Matthews Band - Huntington Bank Pavilion - 2014	\N	2014-07-04	4000.00	1	194	2018-04-08 02:11:25.490651	2018-04-08 02:11:25.498859	\N	\N	\N	dave-matthews-band-huntington-bank-pavilion-dave-matthews-band-huntington-bank-pavilion-2014-2014-1
1756	Dave Matthews Band - Jiffy Lube Live - 2014	\N	2014-07-26	4000.00	1	33	2018-04-08 02:12:15.031258	2018-04-08 02:12:15.047349	\N	\N	\N	dave-matthews-band-jiffy-lube-live-dave-matthews-band-jiffy-lube-live-2014-2014
1757	Dave Matthews Band - Gorge Amphitheatre - 2014	\N	2014-08-29	4000.00	1	9	2018-04-08 02:13:15.552883	2018-04-08 02:13:15.561501	\N	\N	\N	dave-matthews-band-gorge-amphitheatre-dave-matthews-band-gorge-amphitheatre-2014-2014-2
1758	Summerfest		2014-07-02	4000.00	1	197	2018-04-08 02:15:14.971021	2018-07-29 22:13:39.749657	\N	\N	\N	dave-matthews-band-american-family-insurance-amphitheater-summerfest-2014
1759	Dave Matthews Band - Budweiser Stage - 2014	\N	2014-06-24	4000.00	1	4	2018-04-08 02:18:28.697754	2018-04-08 02:18:28.705298	\N	\N	\N	dave-matthews-band-budweiser-stage-dave-matthews-band-budweiser-stage-2014-2014
1760	Dave Matthews Band - Gorge Amphitheatre - 2014	\N	2014-08-30	4000.00	1	9	2018-04-08 02:19:09.328723	2018-04-08 02:19:09.336733	\N	\N	\N	dave-matthews-band-gorge-amphitheatre-dave-matthews-band-gorge-amphitheatre-2014-2014-3
1761	Uncut Three Day Artwork	\N	2018-03-15	10000.00	9	198	2018-04-08 03:25:33.687561	2018-04-08 03:44:01.4722	80	\N	\N	the-avett-brothers-the-house-of-blues-uncut-three-day-artwork-2018
1762	Uncut Three Day Artwork Foil	\N	2018-03-15	15000.00	9	198	2018-04-08 03:28:25.826628	2018-04-08 03:44:38.554206	10	\N	\N	the-avett-brothers-the-house-of-blues-uncut-three-day-artwork-foil-2018
1763	The Avett Brothers - The House of Blues - 2018	\N	2018-03-15	3000.00	9	198	2018-04-08 03:39:49.353152	2018-04-08 03:39:49.377157	200	\N	\N	the-avett-brothers-the-house-of-blues-the-avett-brothers-the-house-of-blues-2018-2018
1764	The Avett Brothers - The House of Blues - 2018	\N	2018-03-16	3000.00	9	198	2018-04-08 03:40:48.39438	2018-04-08 03:40:48.419872	200	\N	\N	the-avett-brothers-the-house-of-blues-the-avett-brothers-the-house-of-blues-2018-2018-1
1765	The Avett Brothers - The House of Blues - 2018	\N	2018-03-17	3000.00	9	198	2018-04-08 03:41:45.733204	2018-04-08 03:41:45.757215	200	\N	\N	the-avett-brothers-the-house-of-blues-the-avett-brothers-the-house-of-blues-2018-2018-2
1766	The Twenty-Third Hour	\N	2018-04-20	10000.00	\N	\N	2018-04-22 16:16:40.584867	2018-04-22 16:18:26.69976	60	\N	\N	the-twenty-third-hour-2018
1767	Green Metallic	\N	2014-08-23	\N	1	13	2018-05-03 12:05:05.605533	2018-05-03 12:17:18.086533	15	\N	\N	dave-matthews-band-greek-theatre-green-metallic-2014
1768	Orange Metallic	\N	2014-08-23	\N	1	13	2018-05-03 12:08:00.114877	2018-05-03 12:16:47.580645	15	\N	\N	dave-matthews-band-greek-theatre-orange-metallic-2014
1769	Mirror Foil	\N	2014-08-23	\N	1	13	2018-05-03 12:08:55.522737	2018-05-03 12:16:47.58429	15	\N	\N	dave-matthews-band-greek-theatre-mirror-foil-2014
1770	Green Mirror Foil	\N	2014-08-23	\N	1	13	2018-05-03 12:09:45.480497	2018-05-03 12:16:47.587652	15	\N	\N	dave-matthews-band-greek-theatre-green-mirror-foil-2014
1771	Gold	\N	2014-08-23	\N	1	13	2018-05-03 12:27:39.004423	2018-05-03 12:28:42.260525	300	\N	\N	dave-matthews-band-greek-theatre-gold-2014
1772	The Dawning Hour	\N	2018-05-02	10000.00	\N	\N	2018-05-03 12:36:46.874603	2018-05-03 12:36:46.879979	175	\N	\N	the-dawning-hour-2018
1773	Dave Matthews Band - PNC Arena - 2012	\N	2012-12-12	4000.00	1	199	2018-05-06 13:22:31.744927	2018-05-06 13:27:19.740837	490	\N	\N	dave-matthews-band-pnc-arena-dave-matthews-band-pnc-arena-2012-2012
1774	My Morning Jacket - 1st Bank Center - 2017	\N	2017-12-29	3000.00	12	34	2018-05-07 20:28:48.795169	2018-05-07 20:31:12.770148	\N	\N	\N	my-morning-jacket-1st-bank-center-my-morning-jacket-1st-bank-center-2017-2017
1775	My Morning Jacket - 1st Bank Center - 2017	\N	2017-12-30	3000.00	12	34	2018-05-07 20:31:49.646596	2018-05-07 20:31:49.653484	\N	\N	\N	my-morning-jacket-1st-bank-center-my-morning-jacket-1st-bank-center-2017-2017-1
1776	My Morning Jacket - 1st Bank Center - 2017	\N	2017-12-31	3000.00	12	34	2018-05-07 20:32:23.837551	2018-05-07 20:32:23.84478	\N	\N	\N	my-morning-jacket-1st-bank-center-my-morning-jacket-1st-bank-center-2017-2017-2
1777	Dave Matthews Band - Ak-Chin Pavilion - 2008	\N	2008-08-23	4000.00	1	103	2018-05-07 20:39:52.801077	2018-05-07 20:41:29.51904	\N	\N	\N	dave-matthews-band-ak-chin-pavilion-dave-matthews-band-ak-chin-pavilion-2008-2008
1778	Dave Matthews Band - Saratoga Springs Performing Arts Center - 2014		2014-05-30	4000.00	1	5	2018-05-13 04:27:26.435246	2018-05-13 04:27:26.442383	920	\N	\N	dave-matthews-band-saratoga-springs-performing-arts-center-dave-matthews-band-saratoga-springs-performing-arts-center-2014-2014
1779	Dave Matthews Band - Air Canada Centre - 2012		2012-12-07	4000.00	1	200	2018-05-18 01:14:00.476614	2018-05-18 01:23:47.298568	575	\N	\N	dave-matthews-band-air-canada-centre-dave-matthews-band-air-canada-centre-2012-2012
1780	2018		2018-05-18	25000.00	\N	\N	2018-05-18 12:04:14.816353	2018-05-18 12:04:14.827175	85	\N	\N	2018-2018
1781	Dave Matthews Band - Cynthia Woods Mitchell Pavilion - 2018		2018-05-18	5000.00	1	2	2018-05-18 21:01:59.093116	2018-05-28 21:42:05.363872	765	\N	\N	dave-matthews-band-cynthia-woods-mitchell-pavilion-dave-matthews-band-cynthia-woods-mitchell-pavilion-2018-2018
1782	Dave Matthews Band - Gexa Energy Pavilion - 2018		2018-05-19	5000.00	1	66	2018-05-21 00:25:07.591955	2018-05-21 00:25:07.599344	870	\N	\N	dave-matthews-band-gexa-energy-pavilion-dave-matthews-band-gexa-energy-pavilion-2018-2018
1783	Dave Matthews Band - Austin360 Amphitheater - 2018		2018-05-22	5000.00	1	80	2018-05-23 00:39:28.580651	2018-05-23 00:53:55.988288	620	\N	\N	dave-matthews-band-austin360-amphitheater-dave-matthews-band-austin360-amphitheater-2018-2018
1784	Dave Matthews Band - Lakewood Amphitheatre - 2018		2018-05-27	5000.00	1	54	2018-05-28 21:36:32.661192	2018-05-28 23:15:39.095202	900	\N	\N	dave-matthews-band-lakewood-amphitheatre-dave-matthews-band-lakewood-amphitheatre-2018-2018
1785	Dave Matthews Band - Brandon Amphitheater - 2018		2018-05-29	5000.00	1	202	2018-05-30 20:55:51.62588	2018-06-02 02:46:37.133573	525	\N	\N	dave-matthews-band-brandon-amphitheater-dave-matthews-band-brandon-amphitheater-2018-2018
1786	Dave Matthews Band - Walmart Arkansas Music Pavilion - 2018		2018-05-30	5000.00	1	201	2018-05-30 21:01:35.372026	2018-06-02 02:44:48.471183	\N	\N	\N	dave-matthews-band-walmart-arkansas-music-pavilion-dave-matthews-band-walmart-arkansas-music-pavilion-2018-2018
1787	Dave Matthews Band - Riverbend Music Center - 2015		2015-06-05	4000.00	1	44	2018-06-01 00:43:42.736409	2018-06-01 00:43:57.00329	\N	\N	\N	dave-matthews-band-riverbend-music-center-dave-matthews-band-riverbend-music-center-2015-2015
1788	Dave Matthews Band - Riverbend Music Center - 2015		2015-06-05	4000.00	1	44	2018-06-01 00:49:42.798705	2018-06-01 00:52:51.378019	\N	\N	\N	dave-matthews-band-riverbend-music-center-dave-matthews-band-riverbend-music-center-2015-2015-1
1789	Dave Matthews Band - First Niagara Pavilion - 2018		2018-06-01	5000.00	1	78	2018-06-01 22:01:23.253417	2018-06-01 22:01:23.261019	\N	\N	\N	dave-matthews-band-first-niagara-pavilion-dave-matthews-band-first-niagara-pavilion-2018-2018
1791	2016 Summer Tour Poster (Green)		2016-05-11	5000.00	1	\N	2018-06-02 16:38:37.03127	2018-06-02 22:41:55.701004	\N	\N	\N	dave-matthews-band-2016-summer-tour-poster-green-2016
1792	Dave Matthews Band - Darien Lake Performing Arts Center - 2010	Also came with fortune teller cards with the fire dancer logo on them.	2010-06-06	4000.00	1	76	2018-06-02 16:48:27.360453	2018-06-02 16:49:44.8291	\N	\N	\N	dave-matthews-band-darien-lake-performing-arts-center-dave-matthews-band-darien-lake-performing-arts-center-2010-2010
1793	2016 Summer Tour Poster (Blue)		2016-05-11	5000.00	1	\N	2018-06-02 16:53:28.396318	2018-06-02 16:53:28.410042	\N	\N	\N	dave-matthews-band-2016-summer-tour-poster-blue-2016
1794	2017	A poster for Dario Argento's Phenomena, made for Mondo\r\n\r\nNine-color screenprint on 100# Cougar cover stock • 18" x 24"	2017-05-10	4500.00	\N	\N	2018-06-02 22:07:28.50762	2018-06-02 22:07:28.515091	225	\N	\N	2017-2017
1795	2017	A poster for Dario Argento's Phenomena, made for Mondo\r\n\r\nNine-color screenprint on 100# Cougar cover stock • 18" x 24"\r\n\r\nPurple colorway	2017-05-10	6500.00	\N	\N	2018-06-02 22:09:16.041426	2018-06-02 22:10:10.308489	125	\N	\N	2017-2017-1
1796	Dave Matthews Band - Blossom Music Center - 2018		2018-06-02	5000.00	1	39	2018-06-02 22:36:22.347507	2018-06-02 22:36:22.353904	\N	\N	\N	dave-matthews-band-blossom-music-center-dave-matthews-band-blossom-music-center-2018-2018
1797	Flowers for Vincent		2013-11-15	7500.00	\N	\N	2018-06-03 16:19:37.823052	2018-06-03 16:31:34.242659	50	\N	\N	flowers-for-vincent-2013
1798	You Bring Light In		2017-11-24	10000.00	\N	\N	2018-06-03 17:17:09.644612	2018-06-03 17:23:57.209968	36	\N	\N	you-bring-light-in-2017
1799	2018 Tour Poster		2018-05-18	5000.00	1	\N	2018-06-05 11:54:24.55082	2018-06-06 20:10:33.798077	1565	\N	\N	dave-matthews-band-2018-tour-poster-2018
1800	Dave Matthews Band - Lakeview Amphitheater - 2018		2018-06-05	5000.00	1	81	2018-06-06 19:39:49.464211	2018-06-06 19:39:49.493612	755	\N	\N	dave-matthews-band-lakeview-amphitheater-dave-matthews-band-lakeview-amphitheater-2018-2018
1801	Dave Matthews Band - DTE Energy Music Theatre - 2018		2018-06-06	5000.00	1	55	2018-06-06 19:40:26.388514	2018-06-11 12:08:08.205657	650	\N	\N	dave-matthews-band-dte-energy-music-theatre-dave-matthews-band-dte-energy-music-theatre-2018-2018
1802	Dave Matthews Band - Riverbend Music Center - 2018		2018-06-07	5000.00	1	44	2018-06-08 01:01:21.783312	2018-06-08 01:01:21.796791	\N	\N	\N	dave-matthews-band-riverbend-music-center-dave-matthews-band-riverbend-music-center-2018-2018
1803	Dave Matthews Band - Jiffy Lube Live - 2015		2015-05-23	5000.00	1	33	2018-06-09 13:48:56.605548	2018-06-09 13:48:56.615041	\N	\N	\N	dave-matthews-band-jiffy-lube-live-dave-matthews-band-jiffy-lube-live-2015-2015
1804	Dave Matthews Band - Jiffy Lube Live - 2018		2018-06-09	5000.00	1	33	2018-06-09 18:00:44.45597	2018-06-09 18:00:44.470091	\N	\N	\N	dave-matthews-band-jiffy-lube-live-dave-matthews-band-jiffy-lube-live-2018-2018
1805	Dave Matthews Band - Irvine Meadows Amphitheatre - 2015		2015-09-12	5000.00	1	96	2018-06-11 00:03:42.308818	2018-06-11 00:05:40.250429	785	\N	\N	dave-matthews-band-irvine-meadows-amphitheatre-dave-matthews-band-irvine-meadows-amphitheatre-2015-2015
1806	Dave Matthews Band - Bank of New Hampshire Pavilion - 2018		2018-06-12	5000.00	1	119	2018-06-15 01:48:47.582391	2018-09-30 17:16:34.224091	570	\N	\N	dave-matthews-band-bank-of-new-hampshire-pavilion-dave-matthews-band-bank-of-new-hampshire-pavilion-2018-2018
1807	Dave Matthews Band - Bank of New Hampshire Pavilion - 2018		2018-06-13	5000.00	1	119	2018-06-15 01:49:43.674988	2018-07-04 14:52:13.071818	500	\N	\N	dave-matthews-band-bank-of-new-hampshire-pavilion-dave-matthews-band-bank-of-new-hampshire-pavilion-2018-2018-1
1808	Dave Matthews Band - BB&T Pavilion - 2018		2018-06-15	5000.00	1	29	2018-06-15 18:34:19.832737	2018-07-09 14:42:58.248477	960	\N	\N	dave-matthews-band-bb-t-pavilion-dave-matthews-band-bb-t-pavilion-2018-2018
1809	Dave Matthews Band - BB&T Pavilion - 2018		2018-06-16	5000.00	1	29	2018-06-18 01:20:52.137202	2018-06-23 18:27:05.779479	\N	\N	\N	dave-matthews-band-bb-t-pavilion-dave-matthews-band-bb-t-pavilion-2018-2018-1
1810	Dave Matthews Band - Xfinity Center - 2018		2018-06-22	5000.00	1	41	2018-06-22 20:10:52.862492	2018-06-22 20:10:52.869833	\N	\N	\N	dave-matthews-band-xfinity-center-dave-matthews-band-xfinity-center-2018-2018
1811	Dave Matthews Band - XFINITY Theatre - 2018		2018-06-23	5000.00	1	46	2018-06-23 19:10:04.340403	2018-06-23 22:20:34.011518	860	\N	\N	dave-matthews-band-xfinity-theatre-dave-matthews-band-xfinity-theatre-2018-2018
1812	Dave Matthews Band - Gorge Amphitheatre - 2013		2013-08-31	4000.00	1	9	2018-06-24 02:10:48.545393	2018-06-24 02:13:07.63804	1180	\N	\N	dave-matthews-band-gorge-amphitheatre-dave-matthews-band-gorge-amphitheatre-2013-2013
1813	Dave Matthews & Tim Reynolds - CMAC - 2018		2018-06-26	5000.00	2	82	2018-06-27 11:30:24.353197	2018-07-09 14:36:08.229755	625	\N	\N	dave-matthews-tim-reynolds-cmac-dave-matthews-tim-reynolds-cmac-2018-2018
1814	Dave Matthews Band - Darien Lake Performing Arts Center - 2018		2018-06-27	5000.00	1	76	2018-06-29 14:47:18.83154	2018-06-29 14:47:18.837382	\N	\N	\N	dave-matthews-band-darien-lake-performing-arts-center-dave-matthews-band-darien-lake-performing-arts-center-2018-2018
1815	Dave Matthews Band - Huntington Bank Pavilion - 2018		2018-06-29	5000.00	1	194	2018-06-29 20:15:20.393978	2018-07-09 17:23:19.287392	1225	\N	\N	dave-matthews-band-huntington-bank-pavilion-dave-matthews-band-huntington-bank-pavilion-2018-2018
1816	Dave Matthews Band - Huntington Bank Pavilion - 2018		2018-06-30	5000.00	1	194	2018-06-30 19:25:40.422028	2018-07-01 00:18:59.519383	1250	\N	\N	dave-matthews-band-huntington-bank-pavilion-dave-matthews-band-huntington-bank-pavilion-2018-2018-1
1817	Dave Matthews Band - American Family Insurance Amphitheater - 2018		2018-07-01	5000.00	1	197	2018-07-02 01:54:48.029243	2018-07-03 02:27:24.011798	900	\N	\N	dave-matthews-band-american-family-insurance-amphitheater-dave-matthews-band-american-family-insurance-amphitheater-2018-2018
1818	Dave Matthews Band - Gexa Energy Pavilion - 2009		2009-05-02	4000.00	1	66	2018-07-04 17:51:34.662267	2018-07-04 17:51:34.669745	\N	\N	\N	dave-matthews-band-gexa-energy-pavilion-dave-matthews-band-gexa-energy-pavilion-2009-2009-1
1819	Only the Rain Knows		2018-07-10	12500.00	\N	\N	2018-07-06 16:05:26.694802	2018-07-06 16:05:26.737899	150	\N	\N	only-the-rain-knows-2018
1820	Dave Matthews Band - Ruoff Home Mortgage Music Center - 2018		2018-07-06	5000.00	1	16	2018-07-06 21:40:21.651309	2018-07-06 22:21:23.64096	1035	\N	\N	dave-matthews-band-ruoff-home-mortgage-music-center-dave-matthews-band-ruoff-home-mortgage-music-center-2018-2018
1821	Dave Matthews Band - Ruoff Home Mortgage Music Center - 2018		2018-07-07	5000.00	1	16	2018-07-07 19:02:05.517516	2018-07-08 11:57:04.054548	1000	\N	\N	dave-matthews-band-ruoff-home-mortgage-music-center-dave-matthews-band-ruoff-home-mortgage-music-center-2018-2018-1
1822	RBC Bluesfest		2018-07-11	5000.00	1	203	2018-07-12 11:23:33.658395	2018-07-12 11:25:55.37107	\N	\N	\N	dave-matthews-band-lebreton-flats-park-rbc-bluesfest-2018
1823	Dave Matthews Band - Saratoga Springs Performing Arts Center - 2018		2018-07-13	5000.00	1	5	2018-07-13 18:50:59.720418	2018-07-13 23:14:49.247952	1050	\N	\N	dave-matthews-band-saratoga-springs-performing-arts-center-dave-matthews-band-saratoga-springs-performing-arts-center-2018-2018
1824	Dave Matthews Band - Saratoga Springs Performing Arts Center - 2018		2018-07-14	5000.00	1	5	2018-07-14 19:08:15.485481	2018-07-14 23:07:41.615631	1100	\N	\N	dave-matthews-band-saratoga-springs-performing-arts-center-dave-matthews-band-saratoga-springs-performing-arts-center-2018-2018-1
1825	Festival d'été de Québec		2018-07-15	5000.00	1	204	2018-07-16 14:04:18.00931	2018-07-16 14:15:21.630858	\N	\N	\N	dave-matthews-band-festival-d-ete-de-quebec-festival-d-ete-de-quebec-2018
1826	Dave Matthews Band - Budweiser Stage - 2018		2018-07-10	5000.00	1	4	2018-07-20 01:57:15.150836	2018-07-21 18:16:13.428872	\N	\N	\N	dave-matthews-band-budweiser-stage-dave-matthews-band-budweiser-stage-2018-2018
1827	Dave Matthews Band - Veterans United Home Loans Amphitheatre - 2018		2018-07-21	5000.00	1	11	2018-07-21 18:30:00.757631	2018-09-30 17:04:18.222038	750	\N	\N	dave-matthews-band-veterans-united-home-loans-amphitheatre-dave-matthews-band-veterans-united-home-loans-amphitheatre-2018-2018
1828	Dave Matthews Band - 2018	Tour Poster Variant - Blue	2018-07-22	5000.00	1	\N	2018-07-22 12:42:06.634355	2018-07-22 13:05:27.811727	1500	\N	\N	dave-matthews-band-dave-matthews-band-2018-2018
1829	Dave Matthews Band - Xfinity Center - 2015		2015-07-13	5000.00	1	41	2018-07-22 13:56:41.330849	2018-07-22 13:56:41.338805	\N	\N	\N	dave-matthews-band-xfinity-center-dave-matthews-band-xfinity-center-2015-2015
1830	Dave Matthews Band - Coastal Credit Union Music Park - 2018		2018-07-20	5000.00	1	105	2018-07-22 15:14:02.089357	2018-07-22 15:14:02.09637	\N	\N	\N	dave-matthews-band-coastal-credit-union-music-park-dave-matthews-band-coastal-credit-union-music-park-2018-2018
1831	Dave Matthews Band - Scott Stadium - 2017		2017-09-24	5000.00	1	205	2018-07-22 15:30:20.247307	2018-07-22 15:32:21.36689	\N	\N	\N	dave-matthews-band-scott-stadium-dave-matthews-band-scott-stadium-2017-2017
1832	Dave Matthews Band - PNC Banks Art Center - 2018		2018-07-18	5000.00	1	85	2018-07-23 00:35:16.742368	2018-07-23 00:35:16.76787	\N	\N	\N	dave-matthews-band-pnc-banks-art-center-dave-matthews-band-pnc-banks-art-center-2018-2018
1833	Dave Matthews Band - Nikon at Jones Beach Theater - 2018		2018-07-17	5000.00	1	14	2018-07-23 00:39:02.838861	2018-07-23 00:39:02.845639	\N	\N	\N	dave-matthews-band-nikon-at-jones-beach-theater-dave-matthews-band-nikon-at-jones-beach-theater-2018-2018
1834	Dave Matthews Band - PNC Music Pavillion - 2018		2018-07-24	5000.00	1	1	2018-07-26 14:25:51.807601	2018-07-26 14:30:12.371387	\N	\N	\N	dave-matthews-band-pnc-music-pavillion-dave-matthews-band-pnc-music-pavillion-2018-2018
1835	Dave Matthews Band - MidFlorida Credit Union Amphitheatre - 2018		2018-07-25	5000.00	1	43	2018-07-26 14:26:43.436988	2018-07-26 14:26:43.443807	\N	\N	\N	dave-matthews-band-midflorida-credit-union-amphitheatre-dave-matthews-band-midflorida-credit-union-amphitheatre-2018-2018
1836	Dave Matthews Band - Perfect Vodka Amphitheatre - 2018		2018-07-27	5000.00	1	17	2018-07-27 19:42:08.781656	2018-07-27 19:42:29.837442	\N	\N	\N	dave-matthews-band-perfect-vodka-amphitheatre-dave-matthews-band-perfect-vodka-amphitheatre-2018-2018
1837	Dave Matthews Band - Perfect Vodka Amphitheatre - 2018		2018-07-28	6000.00	1	17	2018-07-28 19:37:06.083642	2018-07-30 14:58:43.962197	\N	\N	\N	dave-matthews-band-perfect-vodka-amphitheatre-dave-matthews-band-perfect-vodka-amphitheatre-2018-2018-1
1838	Dave Matthews Band - Fiddler's Green Amphitheatre - 2018		2018-08-24	5000.00	1	18	2018-08-26 15:37:57.593215	2018-08-26 15:37:57.608526	\N	\N	\N	dave-matthews-band-fiddler-s-green-amphitheatre-dave-matthews-band-fiddler-s-green-amphitheatre-2018-2018
1839	Dave Matthews Band - Fiddler's Green Amphitheatre - 2018		2018-08-25	5000.00	1	18	2018-08-26 15:38:55.600718	2018-09-30 22:32:07.062347	1080	\N	\N	dave-matthews-band-fiddler-s-green-amphitheatre-dave-matthews-band-fiddler-s-green-amphitheatre-2018-2018-1
1840	Dave Matthews Band - Gorge Amphitheatre - 2018	Event poster	2018-08-31	6000.00	1	9	2018-09-04 19:32:08.605346	2018-09-04 19:32:08.625738	\N	\N	\N	dave-matthews-band-gorge-amphitheatre-dave-matthews-band-gorge-amphitheatre-2018-2018
1841	Dave Matthews Band - Gorge Amphitheatre - 2018		2018-08-31	5000.00	1	9	2018-09-04 19:40:44.306624	2018-09-30 15:56:51.392641	1700	\N	\N	dave-matthews-band-gorge-amphitheatre-dave-matthews-band-gorge-amphitheatre-2018-2018-1
1842	Dave Matthews Band - Gorge Amphitheatre - 2018		2018-09-02	5000.00	1	9	2018-09-04 19:41:57.260593	2018-09-04 19:42:16.488851	\N	\N	\N	dave-matthews-band-gorge-amphitheatre-dave-matthews-band-gorge-amphitheatre-2018-2018-2
1843	Dave Matthews Band - Gorge Amphitheatre - 2018		2018-09-01	5000.00	1	9	2018-09-04 19:43:21.782667	2018-09-04 19:43:21.815889	\N	\N	\N	dave-matthews-band-gorge-amphitheatre-dave-matthews-band-gorge-amphitheatre-2018-2018-3
1844	Dave Matthews Band - Les Schwab Amphitheatre - 2018		2018-08-28	5000.00	1	195	2018-09-04 19:56:30.920552	2018-09-04 19:59:01.259366	675	\N	\N	dave-matthews-band-les-schwab-amphitheatre-dave-matthews-band-les-schwab-amphitheatre-2018-2018
1845	Dave Matthews Band - Shoreline Amphitheater - 2018		2018-09-08	5000.00	1	40	2018-09-08 15:33:04.369594	2018-09-08 15:33:04.405859	\N	\N	\N	dave-matthews-band-shoreline-amphitheater-dave-matthews-band-shoreline-amphitheater-2018-2018
1846	Dave Matthews Band - Lake Tahoe Outdoor Arena - 2018		2018-09-07	5000.00	1	70	2018-09-08 15:36:50.233047	2018-09-29 16:51:07.656806	740	\N	\N	dave-matthews-band-lake-tahoe-outdoor-arena-dave-matthews-band-lake-tahoe-outdoor-arena-2018-2018
1847	Dave Matthews Band - Hollywood Bowl - 2018		2018-09-10	5000.00	1	133	2018-09-10 20:20:21.233554	2018-09-11 00:21:29.902066	960	\N	\N	dave-matthews-band-hollywood-bowl-dave-matthews-band-hollywood-bowl-2018-2018
1848	Dave Matthews Band - Gorge Amphitheatre - 2018	This was a promotional poster that originally came with a set of Dave Matthews Band crayons so that the poster could be colored by individuals.  There was a very limited (5) AP run.	2018-08-31	2000.00	1	9	2018-09-11 14:37:40.994276	2018-09-11 14:37:41.017231	\N	\N	\N	dave-matthews-band-gorge-amphitheatre-dave-matthews-band-gorge-amphitheatre-2018-2018-4
1849	Dave Matthews & Tim Reynolds - The Park At Harlinsdale Farm - 2018		2018-09-23	5000.00	2	206	2018-09-23 23:16:43.916462	2018-09-23 23:21:10.506806	\N	\N	\N	dave-matthews-tim-reynolds-the-park-at-harlinsdale-farm-dave-matthews-tim-reynolds-the-park-at-harlinsdale-farm-2018-2018
1850	Umphrey's McGee - 2016		2016-12-29	3000.00	13	\N	2018-09-30 19:46:06.042978	2018-09-30 19:46:06.052232	\N	\N	\N	umphrey-s-mcgee-umphrey-s-mcgee-2016-2016
1851	A Collection of Anachronisms [from] No Country For Old Men		2017-11-01	3000.00	\N	\N	2018-09-30 19:54:14.912991	2018-09-30 19:54:14.921084	100	\N	\N	a-collection-of-anachronisms-from-no-country-for-old-men-2017
1852	Jerry Garcia Symphonic Celebration (ft. Warren Haynes)		2016-08-08	4500.00	\N	\N	2018-09-30 20:03:17.939989	2018-09-30 20:03:17.960017	150	\N	\N	jerry-garcia-symphonic-celebration-ft-warren-haynes-2016
1853	2017 Winter Tour Poster		2017-11-05	\N	14	\N	2018-09-30 20:28:15.511041	2018-09-30 20:29:21.996719	\N	\N	\N	kishi-bashi-2017-winter-tour-poster-2017
1854	Untitled (Logan Hardware, Chicago)		2017-11-28	2500.00	\N	\N	2018-09-30 22:25:34.366754	2018-09-30 22:25:34.386926	275	\N	\N	untitled-logan-hardware-chicago-2017
1855	Dave Matthews Band - Jerome Schottenstein Center - 2018		2018-11-27	5000.00	1	207	2018-12-01 18:12:35.267922	2018-12-01 18:25:25.273696	755	\N	\N	dave-matthews-band-jerome-schottenstein-center-dave-matthews-band-jerome-schottenstein-center-2018-2018
1856	Dave Matthews Band - SNHU Arena - 2018		2018-12-04	5000.00	1	118	2018-12-04 23:04:41.501513	2018-12-04 23:04:41.524925	\N	\N	\N	dave-matthews-band-snhu-arena-dave-matthews-band-snhu-arena-2018-2018
1857	Dave Matthews Band - Mohegan Sun Arena - 2018		2018-12-02	5000.00	1	208	2018-12-04 23:24:28.573952	2018-12-04 23:26:56.443458	\N	\N	\N	dave-matthews-band-mohegan-sun-arena-dave-matthews-band-mohegan-sun-arena-2018-2018
1858	Dave Matthews Band - Madison Square Garden - 2018		2018-11-30	5000.00	1	23	2018-12-04 23:35:10.003244	2018-12-04 23:35:10.013328	\N	\N	\N	dave-matthews-band-madison-square-garden-dave-matthews-band-madison-square-garden-2018-2018
1859	Dave Matthews Band - Madison Square Garden - 2018		2018-11-29	5000.00	1	23	2018-12-04 23:38:04.2423	2018-12-04 23:38:04.250335	\N	\N	\N	dave-matthews-band-madison-square-garden-dave-matthews-band-madison-square-garden-2018-2018-1
1860	Dave Matthews Band - 2018	2018 Fall Tour Poster	2018-11-27	5000.00	1	\N	2018-12-05 13:49:39.251101	2018-12-05 13:50:02.806325	1200	\N	\N	dave-matthews-band-dave-matthews-band-2018-2018-1
1861	Dave Matthews Band - The Times Union Center - 2018		2018-12-05	5000.00	1	157	2018-12-05 22:53:46.09545	2018-12-05 22:53:46.10707	\N	\N	\N	dave-matthews-band-the-times-union-center-dave-matthews-band-the-times-union-center-2018-2018
1862	Dave Matthews Band - TD Garden - 2018		2018-12-07	5000.00	1	20	2018-12-07 16:01:23.197278	2018-12-07 16:01:23.21287	\N	\N	\N	dave-matthews-band-td-garden-dave-matthews-band-td-garden-2018-2018
1863	Dave Matthews Band - Centre Bell - 2018		2018-12-08	5000.00	1	94	2018-12-08 16:17:22.340021	2018-12-08 16:17:57.782644	\N	\N	\N	dave-matthews-band-centre-bell-dave-matthews-band-centre-bell-2018-2018
1864	Dave Matthews Band - Wells Fargo Center - 2018		2018-12-11	5000.00	1	36	2018-12-12 13:27:40.658752	2018-12-12 13:27:40.671492	\N	\N	\N	dave-matthews-band-wells-fargo-center-dave-matthews-band-wells-fargo-center-2018-2018
1865	The Avett Brothers - Bojangles Coliseum - 2018		2018-12-30	4000.00	9	182	2019-01-01 16:46:37.445386	2019-01-01 16:46:37.460242	450	\N	\N	the-avett-brothers-bojangles-coliseum-the-avett-brothers-bojangles-coliseum-2018-2018
1866	The Avett Brothers - Bojangles Coliseum - 2018		2018-12-31	4000.00	9	182	2019-01-01 16:48:35.484498	2019-01-01 16:48:35.490865	450	\N	\N	the-avett-brothers-bojangles-coliseum-the-avett-brothers-bojangles-coliseum-2018-2018-1
1867	The Avett Brothers - Bojangles Coliseum - 2019	uncut Avett Brothers NYE diptych	2019-01-01	7500.00	9	182	2019-01-01 16:54:22.906616	2019-01-01 17:06:29.710708	150	\N	\N	the-avett-brothers-bojangles-coliseum-the-avett-brothers-bojangles-coliseum-2019-2019
1868	Dave Matthews Band - Ruoff Home Mortgage Music Center - 2018	This print was re-released and printed on gold paper as part of the Live Trax 46 release.	2018-07-07	5000.00	1	16	2019-01-01 20:07:16.26662	2019-01-01 20:07:16.271773	1415	\N	\N	dave-matthews-band-ruoff-home-mortgage-music-center-dave-matthews-band-ruoff-home-mortgage-music-center-2018-2018-2
1869	Dave Matthews & Tim Reynolds - Riviera Maya - 2019		2019-02-16	5000.00	2	178	2019-02-24 00:40:06.140554	2019-02-24 00:40:06.151952	\N	\N	\N	dave-matthews-tim-reynolds-riviera-maya-dave-matthews-tim-reynolds-riviera-maya-2019-2019
1870	Dave Matthews & Tim Reynolds - Riviera Maya - 2019		2019-02-15	5000.00	2	178	2019-02-24 00:46:21.253038	2019-02-24 00:46:21.259267	\N	\N	\N	dave-matthews-tim-reynolds-riviera-maya-dave-matthews-tim-reynolds-riviera-maya-2019-2019-1
1871	Dave Matthews & Tim Reynolds - Riviera Maya - 2019		2019-02-15	5000.00	2	178	2019-02-24 00:49:21.100309	2019-02-24 00:49:21.105556	\N	\N	\N	dave-matthews-tim-reynolds-riviera-maya-dave-matthews-tim-reynolds-riviera-maya-2019-2019-2
1872	Dave Matthews & Tim Reynolds - Riviera Maya - 2019	Foil edition of N1	2019-02-15	5000.00	2	178	2019-02-24 00:54:26.477847	2019-03-10 16:42:16.502506	40	\N	\N	dave-matthews-tim-reynolds-riviera-maya-dave-matthews-tim-reynolds-riviera-maya-2019-2019-3
1873	Dave Matthews & Tim Reynolds - Riviera Maya - 2019		2019-02-17	5000.00	2	178	2019-02-24 00:57:03.920741	2019-02-24 00:57:03.925293	\N	\N	\N	dave-matthews-tim-reynolds-riviera-maya-dave-matthews-tim-reynolds-riviera-maya-2019-2019-4
1874	Dave Matthews & Tim Reynolds - Nikon at Jones Beach Theater - 2017		2017-06-06	\N	2	14	2019-03-04 19:13:11.937255	2019-03-04 19:13:11.957029	\N	\N	\N	dave-matthews-tim-reynolds-nikon-at-jones-beach-theater-dave-matthews-tim-reynolds-nikon-at-jones-beach-theater-2017-2017
1875	Scott Stadium - 2017		2017-09-24	5000.00	\N	205	2019-03-04 19:16:50.256952	2019-03-04 19:16:50.266412	\N	\N	\N	scott-stadium-scott-stadium-2017-2017
1876	Dave Matthews Band - 2019	2019 Europe Tour Poster	2019-03-06	5000.00	1	\N	2019-03-08 18:42:21.452671	2019-03-08 18:42:21.464553	700	\N	\N	dave-matthews-band-dave-matthews-band-2019-2019
1877	Dave Matthews Band - Xfinity Center - 2014		2014-06-07	5000.00	1	41	2019-03-10 15:02:36.953014	2019-03-10 15:02:36.965262	770	\N	\N	dave-matthews-band-xfinity-center-dave-matthews-band-xfinity-center-2014-2014
1878	Dave Matthews Band - Salle Pleyel - 2019		2019-03-10	5000.00	1	209	2019-03-12 12:44:38.637692	2019-03-12 12:51:16.833033	\N	\N	\N	dave-matthews-band-salle-pleyel-dave-matthews-band-salle-pleyel-2019-2019
1879	Dave Matthews Band - Perfect Vodka Amphitheatre - 2012		2012-07-20	30000.00	1	17	2019-03-15 15:38:40.114476	2019-03-15 15:38:40.127655	10	\N	\N	dave-matthews-band-perfect-vodka-amphitheatre-dave-matthews-band-perfect-vodka-amphitheatre-2012-2012-2
1880	Dave Matthews Band - AFAS Live - 2019		2019-03-15	5000.00	1	22	2019-03-15 21:01:01.567307	2019-03-18 14:55:07.504536	250	\N	\N	dave-matthews-band-afas-live-dave-matthews-band-afas-live-2019-2019
1881	Dave Matthews Band - 2019	Same poster used for 3/6 and 3/8 shows in 2019.	2019-03-06	5000.00	1	\N	2019-03-15 21:06:57.231295	2019-03-15 21:07:48.608475	\N	\N	\N	dave-matthews-band-dave-matthews-band-2019-2019-1
1882	Dave Matthews Band - Eventim Apollo - 2019		2019-03-12	5000.00	1	183	2019-03-15 21:11:14.656307	2019-03-15 21:11:14.67941	\N	\N	\N	dave-matthews-band-eventim-apollo-dave-matthews-band-eventim-apollo-2019-2019
1883	Dave Matthews Band - Eventim Apollo - 2019		2019-03-13	5000.00	1	183	2019-03-15 21:13:51.321544	2019-03-15 21:13:51.343167	\N	\N	\N	dave-matthews-band-eventim-apollo-dave-matthews-band-eventim-apollo-2019-2019-1
1884	So Far Away in Only a Day	“So Far Away in Only a Day” is a high quality giclee print on 12" x 36" archival paper. Prints are hand signed and numbered in limited edition of 100 and embossed in the corner of the 1.5" white border. 	2019-03-05	8500.00	\N	\N	2019-03-25 13:54:03.317519	2019-03-25 13:54:48.399361	100	\N	\N	so-far-away-in-only-a-day-2019
1885	Dave Matthews & Tim Reynolds - Riviera Maya - 2020		2020-02-14	5000.00	2	178	2021-05-11 14:05:07.849752	2021-08-17 23:36:37.813411	\N	\N	\N	dave-matthews-tim-reynolds-riviera-maya-dave-matthews-tim-reynolds-riviera-maya-2020-2020
1886	Dave Matthews Band - PNC Music Pavillion - 2021		2021-07-24	6000.00	1	1	2021-07-25 13:44:07.491634	2021-07-25 13:57:08.701629	\N	\N	\N	dave-matthews-band-pnc-music-pavillion-dave-matthews-band-pnc-music-pavillion-2021-2021
1887	Dave Matthews Band - Coastal Credit Union Music Park - 2021		2021-07-23	6000.00	1	105	2021-07-25 14:00:52.049124	2021-07-25 14:00:52.068192	750	\N	\N	dave-matthews-band-coastal-credit-union-music-park-dave-matthews-band-coastal-credit-union-music-park-2021-2021
1888	Dave Matthews Band - 2021		2021-07-01	6000.00	1	\N	2021-07-25 14:16:22.494438	2021-07-25 14:16:22.863388	500	\N	\N	dave-matthews-band-dave-matthews-band-2021-2021
1889	Dave Matthews Band - 2021	The first release in a series of song inspired designs. This limited edition 18x24” screen printed, rainbow foil poster is based on “Everyday”. \r\nEach print is hand numbered and includes printed lyrics on back. \r\nDesigned by James Flames. \r\n\r\n“Pick me up from the bottom \r\nUp to the top love everyday \r\nPay no mind to taunts or advances \r\nI take my chances on everyday” 	2021-07-01	6000.00	1	\N	2021-07-25 14:32:51.060878	2021-07-25 14:33:40.78138	300	\N	\N	dave-matthews-band-dave-matthews-band-2021-2021-1
1890	Dave Matthews Band - MidFlorida Credit Union Amphitheatre - 2021		2021-07-28	6000.00	1	43	2021-07-28 23:07:22.317517	2021-08-01 21:56:05.909311	820	\N	\N	dave-matthews-band-midflorida-credit-union-amphitheatre-dave-matthews-band-midflorida-credit-union-amphitheatre-2021-2021
1891	Dave Matthews Band - Verizon Wireless Amphitheatre at Encore Park - 2021		2021-07-27	6000.00	1	24	2021-07-28 23:13:03.950075	2021-07-28 23:13:03.97407	\N	\N	\N	dave-matthews-band-verizon-wireless-amphitheatre-at-encore-park-dave-matthews-band-verizon-wireless-amphitheatre-at-encore-park-2021-2021
1892	Dave Matthews Band - Perfect Vodka Amphitheatre - 2021		2021-07-30	6000.00	1	17	2021-07-30 14:07:25.044735	2021-07-30 14:07:25.063693	\N	\N	\N	dave-matthews-band-perfect-vodka-amphitheatre-dave-matthews-band-perfect-vodka-amphitheatre-2021-2021
1893	Dave Matthews Band - Perfect Vodka Amphitheatre - 2021		2021-07-31	6000.00	1	17	2021-08-01 23:59:01.231515	2021-08-01 23:59:01.262221	\N	\N	\N	dave-matthews-band-perfect-vodka-amphitheatre-dave-matthews-band-perfect-vodka-amphitheatre-2021-2021-1
1894	Dave Matthews & Tim Reynolds - Credit One Stadium - 2019		2019-04-20	5000.00	2	210	2021-08-03 12:49:53.979952	2021-08-03 12:57:29.118992	\N	\N	\N	dave-matthews-tim-reynolds-credit-one-stadium-dave-matthews-tim-reynolds-credit-one-stadium-2019-2019
1895	Dave Matthews Band - Huntington Bank Pavilion - 2021		2021-08-06	6000.00	1	194	2021-08-06 16:18:59.864328	2021-08-06 16:18:59.89946	\N	\N	\N	dave-matthews-band-huntington-bank-pavilion-dave-matthews-band-huntington-bank-pavilion-2021-2021
1896	Dave Matthews Band - Huntington Bank Pavilion - 2021		2021-08-07	6000.00	1	194	2021-08-09 13:03:29.319016	2021-08-09 13:03:29.372817	\N	\N	\N	dave-matthews-band-huntington-bank-pavilion-dave-matthews-band-huntington-bank-pavilion-2021-2021-1
1897	Dave Matthews Band - DTE Energy Music Theatre - 2021		2021-08-11	6000.00	1	55	2021-08-12 13:50:15.982211	2021-08-12 13:50:16.004665	\N	\N	\N	dave-matthews-band-dte-energy-music-theatre-dave-matthews-band-dte-energy-music-theatre-2021-2021
1898	Dave Matthews Band - Ruoff Home Mortgage Music Center - 2021		2021-08-13	6000.00	1	16	2021-08-14 19:38:04.988893	2021-08-14 19:38:05.041731	\N	\N	\N	dave-matthews-band-ruoff-home-mortgage-music-center-dave-matthews-band-ruoff-home-mortgage-music-center-2021-2021
1899	Dave Matthews Band - Ruoff Home Mortgage Music Center - 2021		2021-08-14	6000.00	1	16	2021-08-14 19:42:43.162337	2021-08-14 19:43:46.272822	\N	\N	\N	dave-matthews-band-ruoff-home-mortgage-music-center-dave-matthews-band-ruoff-home-mortgage-music-center-2021-2021-1
1900	Dave Matthews & Tim Reynolds - Riviera Maya - 2020		2020-02-15	6000.00	2	178	2021-08-17 23:33:29.535252	2021-08-17 23:33:29.580119	\N	\N	\N	dave-matthews-tim-reynolds-riviera-maya-dave-matthews-tim-reynolds-riviera-maya-2020-2020-1
1901	Dave Matthews & Tim Reynolds - Riviera Maya - 2020		2020-02-16	6000.00	2	178	2021-08-17 23:39:46.804767	2021-08-17 23:39:46.821119	\N	\N	\N	dave-matthews-tim-reynolds-riviera-maya-dave-matthews-tim-reynolds-riviera-maya-2020-2020-2
1902	Dave Matthews Band - 2021		2021-07-23	6000.00	1	\N	2021-08-18 00:09:34.526791	2021-08-18 00:12:16.773704	1600	\N	\N	dave-matthews-band-dave-matthews-band-2021-2021-2
1903	Dave Matthews Band - Lakeview Amphitheater - 2021		2021-08-18	6000.00	1	81	2021-08-18 19:01:00.315442	2021-08-18 19:01:26.031059	\N	\N	\N	dave-matthews-band-lakeview-amphitheater-dave-matthews-band-lakeview-amphitheater-2021-2021
1904	Dave Matthews Band - Xfinity Center - 2021		2021-08-20	6000.00	1	41	2021-08-20 14:34:31.098257	2021-08-20 20:14:42.959362	1000	\N	\N	dave-matthews-band-xfinity-center-dave-matthews-band-xfinity-center-2021-2021
1905	Dave Matthews Band - Jacksonville Veterans Memorial Arena - 2019		2019-05-11	6000.00	1	196	2021-08-20 14:56:45.762365	2021-08-20 14:56:45.778446	\N	\N	\N	dave-matthews-band-jacksonville-veterans-memorial-arena-dave-matthews-band-jacksonville-veterans-memorial-arena-2019-2019
1906	Dave Matthews Band - Merriweather Post Pavillion - 2021		2021-08-21	6000.00	1	189	2021-08-21 18:14:03.107761	2021-08-21 18:14:03.143034	\N	\N	\N	dave-matthews-band-merriweather-post-pavillion-dave-matthews-band-merriweather-post-pavillion-2021-2021
1907	Dave Matthews Band - 2019		2019-03-30	5000.00	1	\N	2021-08-23 23:05:13.988877	2021-08-23 23:05:14.032822	\N	\N	\N	dave-matthews-band-dave-matthews-band-2019-2019-2
1908	Dave Matthews Band - Pensacola Bay Center - 2019		2019-04-19	5000.00	1	211	2021-08-23 23:08:32.323149	2021-08-23 23:10:21.99246	\N	\N	\N	dave-matthews-band-pensacola-bay-center-dave-matthews-band-pensacola-bay-center-2019-2019
1909	Dave Matthews Band - Bank of New Hampshire Pavilion - 2021		2021-08-24	6000.00	1	119	2021-08-26 12:48:41.194071	2021-08-26 12:48:41.216269	\N	\N	\N	dave-matthews-band-bank-of-new-hampshire-pavilion-dave-matthews-band-bank-of-new-hampshire-pavilion-2021-2021
1910	Dave Matthews Band - Bank of New Hampshire Pavilion - 2021		2021-08-25	6000.00	1	119	2021-08-26 12:49:14.576812	2021-08-26 12:49:32.066907	\N	\N	\N	dave-matthews-band-bank-of-new-hampshire-pavilion-dave-matthews-band-bank-of-new-hampshire-pavilion-2021-2021-1
1911	Dave Matthews Band - Veterans United Home Loans Amphitheatre - 2021		2021-08-28	6000.00	1	11	2021-08-30 12:09:04.330379	2021-08-30 12:09:28.158425	\N	\N	\N	dave-matthews-band-veterans-united-home-loans-amphitheatre-dave-matthews-band-veterans-united-home-loans-amphitheatre-2021-2021
1912	Dave Matthews Band - The Grounds at Keeneland - 2021		2021-08-29	6000.00	1	212	2021-08-30 12:13:27.705466	2021-08-30 12:13:27.734531	\N	\N	\N	dave-matthews-band-the-grounds-at-keeneland-dave-matthews-band-the-grounds-at-keeneland-2021-2021
1913	Dave Matthews Band - First Niagara Pavilion - 2021		2021-08-27	6000.00	1	78	2021-08-30 12:19:22.949152	2021-08-30 12:19:22.96454	\N	\N	\N	dave-matthews-band-first-niagara-pavilion-dave-matthews-band-first-niagara-pavilion-2021-2021
\.


--
-- Data for Name: posters_series; Type: TABLE DATA; Schema: public; Owner: roberttaylor
--

COPY public.posters_series (poster_id, series_id) FROM stdin;
1138	2
1140	1
1152	17
1156	17
1160	1
1164	5
1165	5
1168	1
1169	5
1170	2
1172	1
1175	5
1176	2
1178	1
1198	3
1199	3
1206	20
1214	20
1219	3
1222	3
1227	18
1235	16
1236	16
1237	18
1238	3
1240	3
1283	4
1288	6
1303	12
1304	12
1305	6
1307	4
1312	4
1317	4
1318	6
1331	6
1335	4
1340	6
1350	6
1359	6
1389	7
1392	7
1402	7
1417	15
1418	7
1421	15
1424	7
1543	10
1549	10
1562	10
1564	10
1647	9
1648	9
1649	9
1650	9
1651	9
1652	9
1653	9
1654	9
1655	9
1723	8
1724	8
1725	8
1726	8
1728	9
1738	13
1744	13
1808	11
1815	11
1830	11
1885	19
1900	19
1901	19
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: roberttaylor
--

COPY public.schema_migrations (version) FROM stdin;
20250628190024
20250628020704
20250626230243
20250626222816
20250625225333
20250625224639
20250625224005
20250625223949
20250625215612
20250625032331
20250625020622
20250625014649
20250624192821
20250624023225
20250624020104
20250623015027
20250623015023
20250623014958
20250623014042
20250623013543
20250623013432
20250623010950
20250623005531
20250622221150
20250629004648
20250629004653
20250629004658
\.


--
-- Data for Name: search_analytics; Type: TABLE DATA; Schema: public; Owner: roberttaylor
--

COPY public.search_analytics (id, query, facet_filters, results_count, user_id, performed_at, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: search_shares; Type: TABLE DATA; Schema: public; Owner: roberttaylor
--

COPY public.search_shares (id, token, search_params, expires_at, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: series; Type: TABLE DATA; Schema: public; Owner: roberttaylor
--

COPY public.series (id, name, description, year, total_count, created_at, updated_at) FROM stdin;
1	Flower Series	\N	2000	\N	2018-03-24 17:26:51.719638	2018-03-24 17:26:51.719638
2	Smoker Series	\N	2000	\N	2018-03-24 17:26:51.870061	2018-03-24 17:26:51.870061
3	Playing Cards	\N	2000	\N	2018-03-24 17:26:51.931531	2018-03-24 17:26:51.931531
4	Chess Series	\N	2000	\N	2018-03-24 17:26:52.003901	2018-03-24 17:26:52.003901
5	Baseball Series	\N	2000	\N	2018-03-24 17:26:52.080805	2018-03-24 17:26:52.080805
6	Constellation Series	\N	2000	\N	2018-03-24 17:26:52.128981	2018-03-24 17:26:52.128981
7	Profile Series	\N	2000	\N	2018-03-24 20:42:09.135845	2018-03-24 20:42:09.135845
8	Sperry Jerry Garcia	\N	2000	\N	2018-03-24 23:57:47.428001	2018-03-24 23:57:47.428001
9	The Truth About Magic	\N	2000	\N	2018-03-25 14:45:39.36289	2018-03-25 14:45:39.36289
10	Beer Cans	\N	2000	\N	2018-03-25 19:27:08.385759	2018-03-25 19:27:08.385759
11	Matchbooks	\N	2000	\N	2018-06-29 20:19:17.216089	2018-06-29 20:19:17.216089
12	Camden 2010 Weekend	\N	2000	\N	2021-08-20 00:00:57.543566	2021-08-20 00:00:57.543566
13	West Palm Beach 2014 Weekend	\N	2000	\N	2021-08-20 00:03:28.251352	2021-08-20 00:03:28.251352
15	West Palm Beach 2012 Weekend	\N	2000	\N	2021-08-20 00:06:12.295533	2021-08-20 00:06:12.295533
16	West Palm Beach 2009 Weekend	\N	2000	\N	2021-08-20 00:07:34.862064	2021-08-20 00:07:34.862064
17	West Palm Beach 2008 Weekend	\N	2000	\N	2021-08-20 00:08:15.148202	2021-08-20 00:08:15.148202
18	Noblesville 2009 Weekend	\N	2000	\N	2021-08-20 00:22:23.81482	2021-08-20 00:22:23.81482
19	Riviera Maya 2020 Weekend	\N	2000	\N	2021-08-20 00:25:19.179318	2021-08-20 00:25:19.179318
20	2009 Canada Moons	\N	2000	\N	2021-08-21 18:50:23.502991	2021-08-21 18:50:23.502991
\.


--
-- Data for Name: solid_cable_messages; Type: TABLE DATA; Schema: public; Owner: roberttaylor
--

COPY public.solid_cable_messages (id, channel, payload, created_at, channel_hash) FROM stdin;
\.


--
-- Data for Name: solid_cache_entries; Type: TABLE DATA; Schema: public; Owner: roberttaylor
--

COPY public.solid_cache_entries (id, key, value, created_at, key_hash, byte_size) FROM stdin;
\.


--
-- Data for Name: solid_queue_blocked_executions; Type: TABLE DATA; Schema: public; Owner: roberttaylor
--

COPY public.solid_queue_blocked_executions (id, job_id, queue_name, priority, concurrency_key, expires_at, created_at) FROM stdin;
\.


--
-- Data for Name: solid_queue_claimed_executions; Type: TABLE DATA; Schema: public; Owner: roberttaylor
--

COPY public.solid_queue_claimed_executions (id, job_id, process_id, created_at) FROM stdin;
\.


--
-- Data for Name: solid_queue_failed_executions; Type: TABLE DATA; Schema: public; Owner: roberttaylor
--

COPY public.solid_queue_failed_executions (id, job_id, error, created_at) FROM stdin;
\.


--
-- Data for Name: solid_queue_jobs; Type: TABLE DATA; Schema: public; Owner: roberttaylor
--

COPY public.solid_queue_jobs (id, queue_name, class_name, arguments, priority, active_job_id, scheduled_at, finished_at, concurrency_key, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: solid_queue_pauses; Type: TABLE DATA; Schema: public; Owner: roberttaylor
--

COPY public.solid_queue_pauses (id, queue_name, created_at) FROM stdin;
\.


--
-- Data for Name: solid_queue_processes; Type: TABLE DATA; Schema: public; Owner: roberttaylor
--

COPY public.solid_queue_processes (id, kind, last_heartbeat_at, supervisor_id, pid, hostname, metadata, created_at, name) FROM stdin;
\.


--
-- Data for Name: solid_queue_ready_executions; Type: TABLE DATA; Schema: public; Owner: roberttaylor
--

COPY public.solid_queue_ready_executions (id, job_id, queue_name, priority, created_at) FROM stdin;
\.


--
-- Data for Name: solid_queue_recurring_executions; Type: TABLE DATA; Schema: public; Owner: roberttaylor
--

COPY public.solid_queue_recurring_executions (id, job_id, task_key, run_at, created_at) FROM stdin;
\.


--
-- Data for Name: solid_queue_recurring_tasks; Type: TABLE DATA; Schema: public; Owner: roberttaylor
--

COPY public.solid_queue_recurring_tasks (id, key, schedule, command, class_name, arguments, queue_name, priority, static, description, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: solid_queue_scheduled_executions; Type: TABLE DATA; Schema: public; Owner: roberttaylor
--

COPY public.solid_queue_scheduled_executions (id, job_id, queue_name, priority, scheduled_at, created_at) FROM stdin;
\.


--
-- Data for Name: solid_queue_semaphores; Type: TABLE DATA; Schema: public; Owner: roberttaylor
--

COPY public.solid_queue_semaphores (id, key, value, expires_at, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: user_posters; Type: TABLE DATA; Schema: public; Owner: roberttaylor
--

COPY public.user_posters (id, user_id, poster_id, status, edition_number, notes, purchase_price, purchase_date, condition, for_sale, asking_price, created_at, updated_at, edition_type) FROM stdin;
1	1	1124	owned	\N	\N	12500.00	2017-05-19	near_mint	f	\N	2018-09-04 22:19:33.222265	2018-09-04 22:19:33.222265	AP
2	1	1144	owned	\N	\N	\N	\N	mint	f	\N	2018-09-04 22:19:30.464281	2018-09-04 22:19:30.464281	\N
3	1	1146	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:29.260495	2018-09-04 22:19:29.260495	\N
4	1	1148	owned	\N	\N	45000.00	2018-03-18	near_mint	f	\N	2018-09-29 15:34:28.237862	2018-09-29 15:34:28.274213	AP
5	1	1153	owned	AP	Never rolled	12500.00	2018-09-29	mint	f	\N	2018-09-29 14:19:53.698079	2018-09-29 14:19:53.810158	AP
6	1	1154	owned	\N	\N	4000.00	2008-07-01	\N	f	\N	2018-09-04 22:19:30.220605	2018-09-04 22:19:30.220605	\N
7	1	1185	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:29.246663	2018-09-04 22:19:29.246663	\N
8	1	1194	owned	\N	\N	4000.00	2009-04-24	\N	f	\N	2018-09-04 22:19:29.326876	2018-09-04 22:19:29.326876	\N
9	1	1209	owned	\N	\N	\N	\N	mint	f	\N	2018-09-04 22:19:30.288619	2018-09-04 22:19:30.288619	AP
10	1	1215	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:28.794046	2018-09-04 22:19:28.794046	\N
11	1	1216	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:28.825942	2018-09-04 22:19:28.825942	\N
12	1	1243	owned	\N	\N	7500.00	2018-03-18	near_mint	f	\N	2018-09-29 15:32:27.243762	2018-09-29 15:32:27.267763	AP
13	1	1252	owned	18	\N	12500.00	\N	near_mint	f	\N	2018-09-04 22:19:30.554856	2018-09-04 22:19:30.554856	SE
14	1	1262	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:30.589872	2018-09-04 22:19:30.589872	\N
15	1	1283	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:29.274006	2018-09-04 22:19:29.274006	\N
16	1	1303	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:28.858568	2018-09-04 22:19:28.858568	\N
17	1	1304	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:28.84178	2018-09-04 22:19:28.84178	\N
18	1	1307	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:28.873328	2018-09-04 22:19:28.873328	\N
19	1	1312	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:29.287323	2018-09-04 22:19:29.287323	\N
20	1	1315	owned	\N	\N	4000.00	2010-07-21	\N	f	\N	2018-09-04 22:19:29.353731	2018-09-04 22:19:29.353731	\N
21	1	1316	owned	\N	\N	\N	\N	mint	f	\N	2018-09-04 22:19:30.255576	2018-09-04 22:19:30.255576	\N
22	1	1317	owned	\N	\N	15000.00	2017-05-19	near_mint	f	\N	2018-09-04 22:19:33.252817	2018-09-04 22:19:33.252817	SE
23	1	1324	owned	\N	\N	4000.00	\N	\N	f	\N	2018-09-04 22:19:29.421646	2018-09-04 22:19:29.421646	\N
24	1	1330	owned	26	never rolled.  Bought from Methane in Raleigh, NC at Wide Open Bluegrass Festival.	10000.00	2018-09-29	mint	f	\N	2018-09-29 12:46:08.7569	2018-09-29 12:47:37.371201	SE
25	1	1335	owned	\N	\N	4000.00	2010-09-17	\N	f	\N	2018-09-04 22:19:29.366921	2018-09-04 22:19:29.366921	\N
26	1	1335	owned	\N	\N	15000.00	2017-05-19	very_good	f	\N	2018-09-04 22:19:33.237597	2018-09-04 22:19:33.237597	SE
27	1	1338	owned	21	\N	45000.00	2017-03-17	near_mint	f	\N	2018-09-04 22:19:31.557218	2018-09-04 22:19:31.557218	SE
28	1	1338	owned	\N	\N	4000.00	2010-09-18	\N	f	\N	2018-09-04 22:19:29.34056	2018-09-04 22:19:29.34056	\N
29	1	1352	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:28.887912	2018-09-04 22:19:28.887912	\N
30	1	1353	owned	23	\N	45000.00	2017-03-17	near_mint	f	\N	2018-09-04 22:19:31.541027	2018-09-04 22:19:31.541027	SE
31	1	1364	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:31.268427	2018-09-04 22:19:31.268427	\N
32	1	1371	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:31.283402	2018-09-04 22:19:31.283402	\N
33	1	1380	owned	\N	\N	4000.00	\N	\N	f	\N	2018-09-04 22:19:29.448838	2018-09-04 22:19:29.448838	\N
34	1	1382	owned	\N	\N	4000.00	\N	\N	f	\N	2018-09-04 22:19:29.489762	2018-09-04 22:19:29.489762	\N
35	1	1390	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:28.915363	2018-09-04 22:19:28.915363	\N
36	1	1394	owned	\N	\N	4000.00	\N	\N	f	\N	2018-09-04 22:19:29.476328	2018-09-04 22:19:29.476328	\N
37	1	1397	owned	\N	\N	4000.00	\N	\N	f	\N	2018-09-04 22:19:29.462659	2018-09-04 22:19:29.462659	\N
38	1	1399	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:29.300539	2018-09-04 22:19:29.300539	\N
39	1	1400	owned	\N	\N	9000.00	\N	near_mint	f	\N	2018-09-04 22:19:30.30425	2018-09-04 22:19:30.30425	SE
40	1	1404	owned	\N	\N	5000.00	\N	\N	f	\N	2018-09-04 22:19:29.789751	2018-09-04 22:19:29.789751	\N
41	1	1417	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:28.929552	2018-09-04 22:19:28.929552	\N
42	1	1419	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:28.901795	2018-09-04 22:19:28.901795	\N
43	1	1420	owned	\N	\N	7500.00	\N	\N	f	\N	2018-09-04 22:19:29.856999	2018-09-04 22:19:29.856999	\N
44	1	1421	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:28.943199	2018-09-04 22:19:28.943199	\N
45	1	1428	owned	\N	\N	5000.00	\N	\N	f	\N	2018-09-04 22:19:29.380257	2018-09-04 22:19:29.380257	\N
46	1	1447	owned	\N	\N	4000.00	\N	\N	f	\N	2018-09-04 22:19:29.435282	2018-09-04 22:19:29.435282	\N
47	1	1448	owned	\N	\N	4000.00	\N	\N	f	\N	2018-09-04 22:19:29.503492	2018-09-04 22:19:29.503492	\N
48	1	1456	owned	\N	\N	4000.00	\N	\N	f	\N	2018-09-04 22:19:29.393824	2018-09-04 22:19:29.393824	\N
49	1	1457	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:28.970002	2018-09-04 22:19:28.970002	\N
50	1	1460	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:29.313704	2018-09-04 22:19:29.313704	\N
51	1	1471	owned	\N	\N	\N	\N	mint	f	\N	2018-09-04 22:19:30.273004	2018-09-04 22:19:30.273004	\N
52	1	1475	owned	\N	\N	4000.00	\N	\N	f	\N	2018-09-04 22:19:29.516886	2018-09-04 22:19:29.516886	\N
53	1	1518	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:28.983352	2018-09-04 22:19:28.983352	\N
54	1	1519	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:28.956714	2018-09-04 22:19:28.956714	\N
55	1	1521	owned	\N	\N	5000.00	\N	\N	f	\N	2018-09-04 22:19:29.544975	2018-09-04 22:19:29.544975	\N
56	1	1532	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:28.996849	2018-09-04 22:19:28.996849	\N
57	1	1533	owned	\N	\N	5000.00	\N	\N	f	\N	2018-09-04 22:19:30.171813	2018-09-04 22:19:30.171813	\N
58	1	1534	owned	\N	\N	5000.00	\N	\N	f	\N	2018-09-04 22:19:29.612746	2018-09-04 22:19:29.612746	\N
59	1	1536	owned	\N	\N	5000.00	\N	\N	f	\N	2018-09-04 22:19:30.370964	2018-09-04 22:19:30.370964	\N
60	1	1537	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:29.011385	2018-09-04 22:19:29.011385	\N
61	1	1538	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:29.146083	2018-09-04 22:19:29.146083	\N
62	1	1539	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:29.18542	2018-09-04 22:19:29.18542	\N
63	1	1540	owned	\N	\N	5000.00	\N	\N	f	\N	2018-09-04 22:19:29.530362	2018-09-04 22:19:29.530362	\N
64	1	1542	owned	\N	\N	5000.00	\N	\N	f	\N	2018-09-04 22:19:30.101247	2018-09-04 22:19:30.101247	\N
65	1	1543	owned	\N	\N	4000.00	\N	\N	f	\N	2018-09-04 22:19:29.573196	2018-09-04 22:19:29.573196	\N
66	1	1544	owned	\N	\N	5000.00	\N	\N	f	\N	2018-09-04 22:19:29.951288	2018-09-04 22:19:29.951288	\N
67	1	1545	owned	\N	\N	5000.00	\N	\N	f	\N	2018-09-04 22:19:30.186066	2018-09-04 22:19:30.186066	\N
68	1	1546	owned	\N	\N	5000.00	\N	\N	f	\N	2018-09-04 22:19:29.653686	2018-09-04 22:19:29.653686	\N
69	1	1549	owned	\N	\N	4000.00	\N	\N	f	\N	2018-09-04 22:19:29.59238	2018-09-04 22:19:29.59238	\N
70	1	1550	owned	\N	\N	5000.00	\N	\N	f	\N	2018-09-04 22:19:30.387822	2018-09-04 22:19:30.387822	\N
71	1	1551	owned	\N	\N	5000.00	\N	\N	f	\N	2018-09-04 22:19:29.816969	2018-09-04 22:19:29.816969	\N
72	1	1552	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:29.025113	2018-09-04 22:19:29.025113	\N
73	1	1553	owned	\N	\N	4000.00	\N	\N	f	\N	2018-09-04 22:19:29.558966	2018-09-04 22:19:29.558966	\N
74	1	1554	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:29.064609	2018-09-04 22:19:29.064609	\N
75	1	1555	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:29.225347	2018-09-04 22:19:29.225347	\N
76	1	1556	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:29.133037	2018-09-04 22:19:29.133037	\N
77	1	1558	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:29.038418	2018-09-04 22:19:29.038418	\N
78	1	1561	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:29.15927	2018-09-04 22:19:29.15927	\N
79	1	1562	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:29.198924	2018-09-04 22:19:29.198924	\N
80	1	1563	owned	\N	\N	5000.00	\N	\N	f	\N	2018-09-04 22:19:30.114248	2018-09-04 22:19:30.114248	\N
81	1	1564	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:29.077352	2018-09-04 22:19:29.077352	\N
82	1	1566	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:29.17226	2018-09-04 22:19:29.17226	\N
83	1	1567	owned	\N	\N	5000.00	\N	\N	f	\N	2018-09-04 22:19:29.672805	2018-09-04 22:19:29.672805	\N
84	1	1568	owned	\N	\N	5000.00	\N	\N	f	\N	2018-09-04 22:19:29.896831	2018-09-04 22:19:29.896831	\N
85	1	1569	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:29.212199	2018-09-04 22:19:29.212199	\N
86	1	1570	owned	\N	\N	5000.00	\N	\N	f	\N	2018-09-04 22:19:30.203894	2018-09-04 22:19:30.203894	\N
87	1	1571	owned	\N	\N	5000.00	\N	\N	f	\N	2018-09-04 22:19:29.728732	2018-09-04 22:19:29.728732	\N
88	1	1573	owned	\N	\N	5000.00	\N	\N	f	\N	2018-09-04 22:19:29.773301	2018-09-04 22:19:29.773301	\N
89	1	1574	owned	\N	\N	5000.00	\N	\N	f	\N	2018-09-04 22:19:29.909859	2018-09-04 22:19:29.909859	\N
90	1	1575	owned	\N	\N	5000.00	\N	\N	f	\N	2018-09-04 22:19:29.715274	2018-09-04 22:19:29.715274	\N
91	1	1581	owned	\N	\N	5000.00	\N	\N	f	\N	2018-09-04 22:19:29.937379	2018-09-04 22:19:29.937379	\N
92	1	1582	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:29.106266	2018-09-04 22:19:29.106266	\N
93	1	1584	owned	\N	\N	5000.00	\N	\N	f	\N	2018-09-04 22:19:29.923063	2018-09-04 22:19:29.923063	\N
94	1	1585	owned	\N	\N	5000.00	\N	\N	f	\N	2018-09-04 22:19:29.990879	2018-09-04 22:19:29.990879	\N
95	1	1586	owned	\N	\N	5000.00	\N	\N	f	\N	2018-09-04 22:19:30.140998	2018-09-04 22:19:30.140998	\N
96	1	1588	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:29.091631	2018-09-04 22:19:29.091631	\N
97	1	1589	owned	\N	\N	5000.00	\N	\N	f	\N	2018-09-04 22:19:29.977571	2018-09-04 22:19:29.977571	\N
98	1	1590	owned	\N	\N	4000.00	\N	\N	f	\N	2018-09-04 22:19:29.407765	2018-09-04 22:19:29.407765	\N
99	1	1591	owned	\N	\N	5000.00	\N	\N	f	\N	2018-09-04 22:19:30.127227	2018-09-04 22:19:30.127227	\N
100	1	1592	owned	\N	\N	5000.00	\N	\N	f	\N	2018-09-04 22:19:29.803528	2018-09-04 22:19:29.803528	\N
101	1	1594	owned	\N	\N	5000.00	\N	\N	f	\N	2018-09-04 22:19:30.019416	2018-09-04 22:19:30.019416	\N
102	1	1595	owned	\N	\N	5000.00	\N	\N	f	\N	2018-09-04 22:19:30.073158	2018-09-04 22:19:30.073158	\N
103	1	1596	owned	\N	\N	5000.00	\N	\N	f	\N	2018-09-04 22:19:29.870389	2018-09-04 22:19:29.870389	\N
104	1	1597	owned	\N	\N	5000.00	\N	\N	f	\N	2018-09-04 22:19:30.355218	2018-09-04 22:19:30.355218	\N
105	1	1598	owned	\N	\N	5000.00	\N	\N	f	\N	2018-09-04 22:19:29.757832	2018-09-04 22:19:29.757832	\N
106	1	1599	owned	\N	\N	5000.00	\N	\N	f	\N	2018-09-04 22:19:30.004578	2018-09-04 22:19:30.004578	\N
107	1	1600	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:29.119062	2018-09-04 22:19:29.119062	\N
108	1	1601	owned	\N	\N	5000.00	\N	\N	f	\N	2018-09-04 22:19:30.046088	2018-09-04 22:19:30.046088	\N
109	1	1603	owned	\N	\N	5000.00	\N	\N	f	\N	2018-09-04 22:19:30.033062	2018-09-04 22:19:30.033062	\N
110	1	1605	owned	\N	\N	5000.00	\N	\N	f	\N	2018-09-04 22:19:30.155503	2018-09-04 22:19:30.155503	\N
111	1	1606	owned	\N	\N	5000.00	\N	\N	f	\N	2018-09-04 22:19:29.843835	2018-09-04 22:19:29.843835	\N
112	1	1607	owned	151	\N	5000.00	2016-08-26	\N	f	\N	2018-09-04 22:19:30.237766	2018-09-04 22:19:30.237766	\N
113	1	1608	owned	\N	\N	5000.00	\N	\N	f	\N	2018-09-04 22:19:29.700752	2018-09-04 22:19:29.700752	\N
114	1	1609	owned	\N	\N	5000.00	\N	\N	f	\N	2018-09-04 22:19:30.059145	2018-09-04 22:19:30.059145	\N
115	1	1610	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:29.051743	2018-09-04 22:19:29.051743	\N
116	1	1611	owned	\N	\N	5000.00	\N	\N	f	\N	2018-09-04 22:19:30.087873	2018-09-04 22:19:30.087873	\N
117	1	1613	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:30.419548	2018-09-04 22:19:30.419548	\N
118	1	1614	owned	\N	\N	5000.00	\N	\N	f	\N	2018-09-04 22:19:29.742589	2018-09-04 22:19:29.742589	\N
119	1	1615	owned	\N	\N	5000.00	\N	\N	f	\N	2018-09-04 22:19:29.883041	2018-09-04 22:19:29.883041	\N
120	1	1616	owned	\N	\N	5000.00	\N	\N	f	\N	2018-09-04 22:19:29.964633	2018-09-04 22:19:29.964633	\N
121	1	1617	owned	\N	\N	5000.00	\N	\N	f	\N	2018-09-04 22:19:29.633582	2018-09-04 22:19:29.633582	\N
122	1	1618	owned	\N	\N	5000.00	\N	\N	f	\N	2018-09-04 22:19:29.830866	2018-09-04 22:19:29.830866	\N
123	1	1619	owned	\N	\N	5000.00	\N	\N	f	\N	2018-09-04 22:19:30.403904	2018-09-04 22:19:30.403904	\N
124	1	1620	owned	\N	\N	5000.00	2016-09-04	near_mint	f	\N	2018-09-04 22:19:30.725207	2018-09-04 22:19:30.725207	SE
125	1	1620	owned	\N	\N	5000.00	\N	near_mint	f	\N	2018-09-04 22:19:30.507327	2018-09-04 22:19:30.507327	SE
126	1	1621	owned	\N	\N	5000.00	2015-09-04	near_mint	f	\N	2018-09-04 22:19:30.574808	2018-09-04 22:19:30.574808	SE
127	1	1622	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:30.679381	2018-09-04 22:19:30.679381	\N
128	1	1623	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:30.663568	2018-09-04 22:19:30.663568	\N
129	1	1624	owned	\N	\N	5000.00	\N	near_mint	f	\N	2018-09-04 22:19:30.710577	2018-09-04 22:19:30.710577	SE
130	1	1625	owned	\N	\N	5000.00	\N	near_mint	f	\N	2018-09-04 22:19:30.693918	2018-09-04 22:19:30.693918	SE
131	1	1626	owned	\N	\N	25000.00	\N	mint	f	\N	2018-09-04 22:19:30.478774	2018-09-04 22:19:30.478774	\N
132	1	1627	owned	\N	\N	7000.00	\N	near_mint	f	\N	2018-09-04 22:19:30.537563	2018-09-04 22:19:30.537563	SE
133	1	1628	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:30.604488	2018-09-04 22:19:30.604488	\N
134	1	1629	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:30.633289	2018-09-04 22:19:30.633289	\N
135	1	1630	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:30.648548	2018-09-04 22:19:30.648548	\N
136	1	1631	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:30.61888	2018-09-04 22:19:30.61888	\N
137	1	1646	owned	\N	\N	5000.00	2016-05-07	near_mint	f	\N	2018-09-04 22:19:30.742312	2018-09-04 22:19:30.742312	SE
138	1	1647	owned	\N	\N	5000.00	\N	near_mint	f	\N	2018-09-04 22:19:30.759093	2018-09-04 22:19:30.759093	AE
139	1	1648	owned	\N	\N	6000.00	\N	near_mint	f	\N	2018-09-04 22:19:30.798798	2018-09-04 22:19:30.798798	AE
140	1	1649	owned	\N	\N	6000.00	\N	near_mint	f	\N	2018-09-04 22:19:30.779467	2018-09-04 22:19:30.779467	AE
141	1	1650	owned	\N	\N	4000.00	\N	near_mint	f	\N	2018-09-04 22:19:30.81339	2018-09-04 22:19:30.81339	AE
142	1	1653	owned	\N	\N	2500.00	\N	near_mint	f	\N	2018-09-04 22:19:30.829373	2018-09-04 22:19:30.829373	AE
143	1	1654	owned	\N	\N	2500.00	\N	near_mint	f	\N	2018-09-04 22:19:30.859818	2018-09-04 22:19:30.859818	AE
144	1	1655	owned	\N	\N	2500.00	\N	near_mint	f	\N	2018-09-04 22:19:30.844586	2018-09-04 22:19:30.844586	AE
145	1	1656	owned	101	\N	20000.00	2016-10-24	near_mint	f	\N	2018-09-04 22:19:30.87422	2018-09-04 22:19:30.87422	AE
146	1	1659	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:31.298584	2018-09-04 22:19:31.298584	\N
147	1	1664	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:31.314313	2018-09-04 22:19:31.314313	\N
148	1	1666	owned	\N	\N	7500.00	\N	near_mint	f	\N	2018-09-04 22:19:31.329429	2018-09-04 22:19:31.329429	\N
149	1	1667	owned	\N	\N	11000.00	\N	near_mint	f	\N	2018-09-04 22:19:31.346023	2018-09-04 22:19:31.346023	\N
150	1	1668	owned	\N	\N	10000.00	\N	near_mint	f	\N	2018-09-04 22:19:31.360744	2018-09-04 22:19:31.360744	\N
151	1	1680	owned	\N	\N	7500.00	2017-03-17	near_mint	f	\N	2018-09-04 22:19:31.577016	2018-09-04 22:19:31.577016	AE
152	1	1681	owned	\N	\N	10000.00	\N	near_mint	f	\N	2018-09-04 22:19:30.434465	2018-09-04 22:19:30.434465	AE
153	1	1682	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:30.449833	2018-09-04 22:19:30.449833	\N
154	1	1685	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:30.493371	2018-09-04 22:19:30.493371	\N
155	1	1686	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:30.522629	2018-09-04 22:19:30.522629	\N
156	1	1687	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:31.525648	2018-09-04 22:19:31.525648	\N
157	1	1689	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:33.05525	2018-09-04 22:19:33.05525	\N
158	1	1690	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:33.109388	2018-09-04 22:19:33.109388	\N
159	1	1691	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:33.090606	2018-09-04 22:19:33.090606	\N
160	1	1695	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:33.072758	2018-09-04 22:19:33.072758	\N
161	1	1697	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:34.038066	2018-09-04 22:19:34.038066	\N
162	1	1698	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:34.01718	2018-09-04 22:19:34.01718	\N
163	1	1699	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:34.058192	2018-09-04 22:19:34.058192	\N
164	1	1702	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:33.998491	2018-09-04 22:19:33.998491	\N
165	1	1703	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:33.977821	2018-09-04 22:19:33.977821	\N
166	1	1704	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:33.956189	2018-09-04 22:19:33.956189	\N
167	1	1705	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:33.269304	2018-09-04 22:19:33.269304	\N
168	1	1706	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:34.100551	2018-09-04 22:19:34.100551	\N
169	1	1708	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:34.122737	2018-09-04 22:19:34.122737	\N
170	1	1709	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:34.079182	2018-09-04 22:19:34.079182	\N
171	1	1710	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:34.145271	2018-09-04 22:19:34.145271	\N
172	1	1712	owned	650	Slight mark in lower left corner	5000.00	2018-02-03	near_mint	f	\N	2018-09-29 15:28:01.073918	2018-09-29 15:28:01.098138	SE
173	1	1712	owned	AP	\N	5000.00	2018-02-03	near_mint	f	\N	2018-09-29 15:26:09.8484	2018-09-29 15:26:09.877185	AP
174	1	1713	owned	73	\N	5000.00	2018-01-28	near_mint	f	\N	2018-09-29 20:05:59.185732	2018-09-29 20:07:00.344456	SE
175	1	1714	owned	\N	\N	5000.00	2018-01-14	near_mint	f	\N	2018-09-29 20:01:25.980944	2018-09-29 20:01:26.014741	SE
176	1	1716	owned	824	\N	5000.00	2018-01-12	near_mint	f	\N	2018-09-29 19:55:46.753326	2018-09-29 19:55:46.772694	SE
177	1	1723	owned	159	\N	10000.00	2017-11-21	near_mint	f	\N	2018-09-29 20:16:18.27076	2018-09-29 20:17:04.249314	SE
178	1	1774	owned	51	Matching number AE	2400.00	2018-09-30	near_mint	f	\N	2018-09-30 21:20:10.543027	2018-09-30 21:20:10.62157	AE
179	1	1775	owned	AE51	Matching number set of AE	2400.00	2018-04-19	near_mint	f	\N	2018-09-30 21:12:22.361896	2018-09-30 21:12:22.392526	AE
180	1	1776	owned	AE51	matching number set of AE	2400.00	2018-04-19	near_mint	f	\N	2018-09-30 21:09:00.798876	2018-09-30 21:09:00.93541	AE
181	1	1781	owned	751	\N	5000.00	2018-05-18	near_mint	f	\N	2018-09-14 21:13:20.673128	2018-09-14 21:13:20.790139	SE
182	1	1784	owned	233	\N	5000.00	2018-05-26	near_mint	f	\N	2018-09-30 16:57:12.592723	2018-09-30 16:59:36.691314	SE
183	1	1784	owned	165	\N	5000.00	2018-05-26	near_mint	f	\N	2018-09-30 16:46:52.117258	2018-09-30 16:48:28.301047	SE
184	1	1785	owned	460	\N	5000.00	2018-05-29	near_mint	f	\N	2018-09-30 17:17:57.50106	2018-09-30 17:17:57.566959	SE
185	1	1789	owned	AE 8	\N	5000.00	2018-06-01	near_mint	f	\N	2018-09-30 17:19:44.160808	2018-09-30 17:19:44.207791	AE
186	1	1799	owned	AP	Never rolled 	7500.00	2018-09-29	mint	f	\N	2018-09-29 14:16:00.870747	2018-09-29 14:16:01.056402	AP
187	1	1801	owned	138	\N	5000.00	2018-06-06	near_mint	f	\N	2018-09-30 16:50:44.15698	2018-09-30 16:52:12.201596	SE
188	1	1806	owned	501	\N	5000.00	2018-06-12	near_mint	f	\N	2018-09-30 17:16:00.508959	2018-09-30 17:16:00.563701	SE
189	1	1807	owned	490	\N	5000.00	2018-06-13	near_mint	f	\N	2018-09-30 17:20:55.302418	2018-09-30 17:20:55.325424	SE
190	1	1822	owned	398	\N	5000.00	2018-06-11	near_mint	f	\N	2018-09-30 19:26:19.037909	2018-09-30 19:26:19.037909	SE
191	1	1827	owned	654	\N	5000.00	2018-07-21	near_mint	f	\N	2018-09-30 17:04:08.165124	2018-09-30 17:09:16.722194	SE
192	1	1827	owned	\N	\N	5000.00	2018-07-21	near_mint	f	\N	2018-09-30 17:13:19.150248	2018-09-30 17:13:52.906399	SE
193	1	1828	owned	869	Never rolled	7500.00	2018-09-29	mint	f	\N	2018-09-29 14:13:13.643074	2018-09-29 14:13:13.665641	SE
194	1	1837	owned	\N	\N	5000.00	2018-07-28	near_mint	f	\N	2018-09-05 12:15:46.552622	2018-09-05 12:15:46.552622	SE
195	1	1838	owned	\N	\N	5000.00	2018-08-24	near_mint	f	\N	2018-09-05 12:13:02.038312	2018-09-05 12:13:02.038312	SE
196	1	1839	owned	973	\N	5000.00	2018-08-25	near_mint	f	\N	2018-09-05 12:09:14.008698	2018-09-30 22:31:53.281266	SE
197	1	1840	owned	\N	\N	6000.00	2018-09-02	near_mint	f	\N	2018-09-04 22:34:30.990319	2018-09-04 22:34:30.990319	SE
198	1	1840	owned	\N	\N	6000.00	2018-09-02	near_mint	f	\N	2018-09-04 22:34:51.198086	2018-09-04 22:34:51.198086	SE
199	1	1841	owned	1686	\N	5500.00	2018-08-31	near_mint	f	\N	2018-09-04 22:32:29.849463	2018-09-30 15:56:03.695029	SE
200	1	1842	owned	\N	\N	5000.00	2018-09-02	\N	f	\N	2018-09-04 22:17:13.179	2018-09-04 22:17:13.179	SE
201	1	1842	owned	\N	\N	5000.00	2018-09-02	\N	f	\N	2018-09-04 22:17:39.513463	2018-09-04 22:17:39.513463	SE
202	1	1843	owned	\N	\N	5000.00	2018-09-01	near_mint	f	\N	2018-09-04 22:24:04.377503	2018-09-04 22:31:38.140517	SE
203	1	1843	owned	\N	\N	5000.00	2018-09-01	near_mint	f	\N	2018-09-04 22:23:07.728434	2018-09-04 22:31:14.568552	SE
204	1	1844	owned	668	\N	5000.00	2018-08-28	near_mint	f	\N	2018-09-29 16:57:39.221828	2018-09-29 16:57:39.233918	SE
205	1	1844	owned	667	\N	5000.00	2018-08-28	near_mint	f	\N	2018-09-29 16:54:46.542193	2018-09-29 16:55:19.836414	SE
206	1	1845	owned	733	\N	5000.00	2018-09-08	near_mint	f	\N	2018-09-29 16:47:56.465755	2018-09-29 16:48:56.052531	SE
207	1	1846	owned	146	\N	5000.00	2018-09-08	near_mint	f	\N	2018-09-08 15:37:39.738093	2018-09-29 16:50:17.248936	SE
208	1	1850	owned	AE54	Black Friday 2017 print	4500.00	2017-11-28	near_mint	f	\N	2018-09-30 22:21:09.412735	2018-09-30 22:21:09.532245	AE
209	1	1851	owned	34	Received in the 2017 Black Friday sale as part of the "Robert Taylor Vertical Only" mystery tube.	3000.00	2017-11-28	near_mint	f	\N	2018-09-30 19:55:12.904117	2018-09-30 22:23:03.442639	AE
210	1	1852	owned	AP40	Purchased in Black Friday mystery tube.	4500.00	2017-11-28	near_mint	f	\N	2018-09-30 20:04:06.342693	2018-09-30 22:08:14.734091	AE
211	1	1853	owned	AP74	Purchased in Black Friday mystery tube	4500.00	2017-11-28	near_mint	f	\N	2018-09-30 20:30:02.622169	2018-09-30 20:59:00.987961	AE
212	1	1854	owned	166	\N	2500.00	2017-11-28	near_mint	f	\N	2018-09-30 22:26:32.812905	2018-09-30 22:26:32.911374	AE
213	1	1860	owned	\N	\N	5000.00	2018-12-20	near_mint	f	\N	2019-03-04 01:12:02.178055	2019-03-04 01:12:02.178055	AE
214	1	1867	owned	\N	\N	10000.00	2018-12-30	near_mint	f	\N	2019-03-04 01:08:54.965626	2019-03-04 01:08:54.965626	AE
215	1	1868	owned	1047	\N	5000.00	2019-01-01	near_mint	f	\N	2019-01-01 20:07:48.60082	2019-01-01 20:07:48.622891	SE
216	1	1879	owned	6	purchased at flatstock69 in 2019	30000.00	2019-03-15	near_mint	f	\N	2019-03-15 15:42:42.924799	2019-03-15 15:42:42.953898	AE
217	3	1141	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:30.919125	2018-09-04 22:19:30.919125	\N
218	3	1142	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:30.934964	2018-09-04 22:19:30.934964	\N
219	3	1205	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:31.01872	2018-09-04 22:19:31.01872	\N
220	3	1208	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:30.949906	2018-09-04 22:19:30.949906	\N
221	3	1287	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:31.001045	2018-09-04 22:19:31.001045	\N
222	3	1290	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:30.98208	2018-09-04 22:19:30.98208	\N
223	3	1346	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:31.109137	2018-09-04 22:19:31.109137	\N
224	3	1347	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:31.093933	2018-09-04 22:19:31.093933	\N
225	3	1395	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:30.96789	2018-09-04 22:19:30.96789	\N
226	3	1397	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:31.210776	2018-09-04 22:19:31.210776	\N
227	3	1452	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:31.033163	2018-09-04 22:19:31.033163	\N
228	3	1456	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:31.047178	2018-09-04 22:19:31.047178	\N
229	3	1537	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:31.061652	2018-09-04 22:19:31.061652	\N
230	3	1579	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:31.077273	2018-09-04 22:19:31.077273	\N
231	3	1585	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:30.904103	2018-09-04 22:19:30.904103	\N
232	3	1608	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:31.15615	2018-09-04 22:19:31.15615	\N
233	3	1611	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:31.141023	2018-09-04 22:19:31.141023	\N
234	3	1620	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:31.124686	2018-09-04 22:19:31.124686	\N
235	3	1625	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:31.191068	2018-09-04 22:19:31.191068	\N
236	4	1626	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:30.889366	2018-09-04 22:19:30.889366	\N
237	5	1199	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:31.237786	2018-09-04 22:19:31.237786	\N
238	6	1595	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:31.253548	2018-09-04 22:19:31.253548	\N
239	8	1616	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:31.391405	2018-09-04 22:19:31.391405	\N
240	8	1616	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:31.376359	2018-09-04 22:19:31.376359	\N
241	8	1616	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:31.406592	2018-09-04 22:19:31.406592	\N
242	8	1616	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:31.428818	2018-09-04 22:19:31.428818	\N
243	8	1616	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:31.45611	2018-09-04 22:19:31.45611	\N
244	8	1616	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:31.476833	2018-09-04 22:19:31.476833	\N
245	8	1616	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:31.496114	2018-09-04 22:19:31.496114	\N
246	8	1616	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:31.511181	2018-09-04 22:19:31.511181	\N
247	13	1140	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:31.655221	2018-09-04 22:19:31.655221	\N
248	13	1150	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:31.669643	2018-09-04 22:19:31.669643	\N
249	13	1191	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:31.700622	2018-09-04 22:19:31.700622	\N
250	13	1193	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:31.683489	2018-09-04 22:19:31.683489	\N
251	13	1196	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:31.726519	2018-09-04 22:19:31.726519	\N
252	13	1206	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:31.764147	2018-09-04 22:19:31.764147	\N
253	13	1214	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:31.744537	2018-09-04 22:19:31.744537	\N
254	13	1220	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:31.783597	2018-09-04 22:19:31.783597	\N
255	13	1227	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:31.823376	2018-09-04 22:19:31.823376	\N
256	13	1228	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:31.802048	2018-09-04 22:19:31.802048	\N
257	13	1237	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:31.842861	2018-09-04 22:19:31.842861	\N
258	13	1239	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:31.862311	2018-09-04 22:19:31.862311	\N
259	13	1250	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:31.879628	2018-09-04 22:19:31.879628	\N
260	13	1255	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:31.912575	2018-09-04 22:19:31.912575	\N
261	13	1257	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:31.895826	2018-09-04 22:19:31.895826	\N
262	13	1265	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:31.947596	2018-09-04 22:19:31.947596	\N
263	13	1266	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:31.98088	2018-09-04 22:19:31.98088	\N
264	13	1266	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:31.963285	2018-09-04 22:19:31.963285	\N
265	13	1270	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:31.999956	2018-09-04 22:19:31.999956	\N
266	13	1273	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:31.92989	2018-09-04 22:19:31.92989	\N
267	13	1277	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:32.020052	2018-09-04 22:19:32.020052	\N
268	13	1283	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:32.043639	2018-09-04 22:19:32.043639	\N
269	13	1295	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:32.061571	2018-09-04 22:19:32.061571	\N
270	13	1297	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:32.086333	2018-09-04 22:19:32.086333	\N
271	13	1299	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:32.13461	2018-09-04 22:19:32.13461	\N
272	13	1300	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:32.108407	2018-09-04 22:19:32.108407	\N
273	13	1303	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:30.338062	2018-09-04 22:19:30.338062	\N
274	13	1304	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:30.321153	2018-09-04 22:19:30.321153	\N
275	13	1305	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:32.180564	2018-09-04 22:19:32.180564	\N
276	13	1306	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:32.219984	2018-09-04 22:19:32.219984	\N
277	13	1307	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:32.235106	2018-09-04 22:19:32.235106	\N
278	13	1312	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:32.250188	2018-09-04 22:19:32.250188	\N
279	13	1315	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:32.201929	2018-09-04 22:19:32.201929	\N
280	13	1316	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:32.264377	2018-09-04 22:19:32.264377	\N
281	13	1317	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:32.277897	2018-09-04 22:19:32.277897	\N
282	13	1318	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:32.292935	2018-09-04 22:19:32.292935	\N
283	13	1319	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:32.158708	2018-09-04 22:19:32.158708	\N
284	13	1320	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:32.445813	2018-09-04 22:19:32.445813	\N
285	13	1321	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:32.429838	2018-09-04 22:19:32.429838	\N
286	13	1324	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:32.461902	2018-09-04 22:19:32.461902	\N
287	13	1325	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:32.507959	2018-09-04 22:19:32.507959	\N
288	13	1326	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:32.492326	2018-09-04 22:19:32.492326	\N
289	13	1327	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:32.47699	2018-09-04 22:19:32.47699	\N
290	13	1333	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:32.522468	2018-09-04 22:19:32.522468	\N
291	13	1335	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:32.55687	2018-09-04 22:19:32.55687	\N
292	13	1337	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:32.539226	2018-09-04 22:19:32.539226	\N
293	13	1338	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:32.588388	2018-09-04 22:19:32.588388	\N
294	13	1340	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:32.603126	2018-09-04 22:19:32.603126	\N
295	13	1340	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:32.618749	2018-09-04 22:19:32.618749	\N
296	13	1345	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:32.573132	2018-09-04 22:19:32.573132	\N
297	13	1350	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:32.63338	2018-09-04 22:19:32.63338	\N
298	13	1351	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:32.665117	2018-09-04 22:19:32.665117	\N
299	13	1353	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:32.679392	2018-09-04 22:19:32.679392	\N
300	13	1356	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:32.648813	2018-09-04 22:19:32.648813	\N
301	13	1362	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:32.694194	2018-09-04 22:19:32.694194	\N
302	13	1365	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:32.710271	2018-09-04 22:19:32.710271	\N
303	13	1366	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:32.724904	2018-09-04 22:19:32.724904	\N
304	13	1367	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:32.738891	2018-09-04 22:19:32.738891	\N
305	13	1369	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:32.753891	2018-09-04 22:19:32.753891	\N
306	13	1369	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:32.768765	2018-09-04 22:19:32.768765	\N
307	13	1401	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:32.784554	2018-09-04 22:19:32.784554	\N
308	13	1463	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:32.822972	2018-09-04 22:19:32.822972	\N
309	13	1465	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:32.841818	2018-09-04 22:19:32.841818	\N
310	13	1472	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:32.861626	2018-09-04 22:19:32.861626	\N
311	13	1528	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:31.640962	2018-09-04 22:19:31.640962	\N
312	13	1539	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:32.879661	2018-09-04 22:19:32.879661	\N
313	13	1567	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:32.954598	2018-09-04 22:19:32.954598	\N
314	13	1594	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:32.925293	2018-09-04 22:19:32.925293	\N
315	13	1608	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:32.983057	2018-09-04 22:19:32.983057	\N
316	13	1608	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:32.998473	2018-09-04 22:19:32.998473	\N
317	13	1611	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:33.015629	2018-09-04 22:19:33.015629	\N
318	13	1616	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:32.939569	2018-09-04 22:19:32.939569	\N
319	13	1617	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:32.89524	2018-09-04 22:19:32.89524	\N
320	13	1620	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:33.034992	2018-09-04 22:19:33.034992	\N
321	13	1625	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:32.968999	2018-09-04 22:19:32.968999	\N
322	13	1642	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:31.593941	2018-09-04 22:19:31.593941	\N
323	13	1646	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:32.910516	2018-09-04 22:19:32.910516	\N
324	13	1657	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:31.608835	2018-09-04 22:19:31.608835	\N
325	13	1657	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:31.625013	2018-09-04 22:19:31.625013	\N
326	14	1164	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:32.412674	2018-09-04 22:19:32.412674	\N
327	14	1308	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:32.39613	2018-09-04 22:19:32.39613	\N
328	14	1389	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:32.380584	2018-09-04 22:19:32.380584	\N
329	14	1469	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:32.365425	2018-09-04 22:19:32.365425	\N
330	14	1533	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:32.350981	2018-09-04 22:19:32.350981	\N
331	14	1577	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:32.336839	2018-09-04 22:19:32.336839	\N
332	14	1595	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:32.321637	2018-09-04 22:19:32.321637	\N
333	14	1618	owned	\N	\N	5000.00	\N	near_mint	f	\N	2018-09-04 22:19:32.306989	2018-09-04 22:19:32.306989	SE
334	16	1150	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:33.72567	2018-09-04 22:19:33.72567	\N
335	16	1153	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:33.710846	2018-09-04 22:19:33.710846	\N
336	16	1193	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:33.756724	2018-09-04 22:19:33.756724	\N
337	16	1194	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:33.772484	2018-09-04 22:19:33.772484	\N
338	16	1196	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:33.740985	2018-09-04 22:19:33.740985	\N
339	16	1280	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:33.803259	2018-09-04 22:19:33.803259	\N
340	16	1315	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:33.788469	2018-09-04 22:19:33.788469	\N
341	16	1380	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:33.868489	2018-09-04 22:19:33.868489	\N
342	16	1427	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:33.842105	2018-09-04 22:19:33.842105	\N
343	16	1446	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:33.818813	2018-09-04 22:19:33.818813	\N
344	16	1464	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:33.915544	2018-09-04 22:19:33.915544	\N
345	16	1467	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:33.897849	2018-09-04 22:19:33.897849	\N
346	16	1475	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:33.884156	2018-09-04 22:19:33.884156	\N
347	16	1516	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:33.171244	2018-09-04 22:19:33.171244	\N
348	16	1549	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:33.195598	2018-09-04 22:19:33.195598	\N
349	16	1561	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:33.694569	2018-09-04 22:19:33.694569	\N
350	16	1571	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:33.680607	2018-09-04 22:19:33.680607	\N
351	16	1574	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:33.665617	2018-09-04 22:19:33.665617	\N
352	16	1575	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:33.64864	2018-09-04 22:19:33.64864	\N
353	16	1577	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:33.62989	2018-09-04 22:19:33.62989	\N
354	16	1578	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:33.611143	2018-09-04 22:19:33.611143	\N
355	16	1580	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:33.595188	2018-09-04 22:19:33.595188	\N
356	16	1581	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:33.576098	2018-09-04 22:19:33.576098	\N
357	16	1582	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:33.559328	2018-09-04 22:19:33.559328	\N
358	16	1585	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:33.544553	2018-09-04 22:19:33.544553	\N
359	16	1589	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:33.527192	2018-09-04 22:19:33.527192	\N
360	16	1596	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:33.508088	2018-09-04 22:19:33.508088	\N
361	16	1601	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:33.492415	2018-09-04 22:19:33.492415	\N
362	16	1602	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:33.475708	2018-09-04 22:19:33.475708	\N
363	16	1603	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:33.457776	2018-09-04 22:19:33.457776	\N
364	16	1604	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:33.435879	2018-09-04 22:19:33.435879	\N
365	16	1606	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:33.415637	2018-09-04 22:19:33.415637	\N
366	16	1607	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:33.394275	2018-09-04 22:19:33.394275	\N
367	16	1608	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:33.378333	2018-09-04 22:19:33.378333	\N
368	16	1609	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:33.361355	2018-09-04 22:19:33.361355	\N
369	16	1610	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:33.343509	2018-09-04 22:19:33.343509	\N
370	16	1611	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:33.323376	2018-09-04 22:19:33.323376	\N
371	16	1613	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:33.144609	2018-09-04 22:19:33.144609	\N
372	16	1615	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:33.936146	2018-09-04 22:19:33.936146	\N
373	16	1616	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:33.302884	2018-09-04 22:19:33.302884	\N
374	16	1704	owned	\N	\N	\N	\N	\N	f	\N	2018-09-04 22:19:33.285548	2018-09-04 22:19:33.285548	\N
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: roberttaylor
--

COPY public.users (id, email, first_name, last_name, confirmed_at, confirmation_token, confirmation_sent_at, otp_secret_key, otp_sent_at, otp_used_at, otp_attempts_count, otp_locked_until, password_digest, reset_password_token, reset_password_sent_at, failed_login_attempts, locked_until, last_login_at, provider, uid, provider_data, admin, showcase_settings, created_at, updated_at, bio, location, website, phone, collector_since, preferred_contact_method, instagram_handle, twitter_handle, terms_accepted_at, terms_version) FROM stdin;
1	robert@taylorcrib.com	Robert	Taylor	\N	BJXsZDtiszWjcx_5G6qVqL4aQb1TrKP2YXkz5JiCiN8	2025-06-29 00:51:29.581876	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	t	{}	2018-03-24 16:58:26.910675	2025-06-24 01:48:39.050489	\N	\N	\N	\N	\N	email	\N	\N	2018-03-24 16:58:26.910675	legacy-import
2	kennyblair78@yahoo.com	Kenny	Blair	\N	j9mlUTT4Co8muFKJx4EVNnUrMgwV9JVbIio-u4rhJnQ	2025-06-29 00:51:29.585778	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2018-03-24 16:58:24.630945	2018-03-24 16:58:24.630945	\N	\N	\N	\N	\N	email	\N	\N	2018-03-24 16:58:24.630945	legacy-import
3	mjgallicchio@gmail.com	Matt	Gallicchio	\N	-OU3O7G8Pff0o_L7BUL0Ymks3eOFU7FTd1mqhPNpvXA	2025-06-29 00:51:29.587624	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2018-03-24 16:58:25.134002	2019-03-19 00:55:48.011981	\N	\N	\N	\N	\N	email	\N	\N	2018-03-24 16:58:25.134002	legacy-import
4	robert.taylor@hendrickauto.com	Robert	Taylor	\N	RXAHFxjXLN6F0FsuXI_AuYYPvCfABh471uoY6kkopLU	2025-06-29 00:51:29.589109	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2018-03-24 16:58:25.300676	2018-03-24 16:58:25.300676	\N	\N	\N	\N	\N	email	\N	\N	2018-03-24 16:58:25.300676	legacy-import
5	steve_0626@yahoo.com	Stefano	Bosco	\N	XGXvKGB7eL4sFh5Aa0iYKeff3W_4N4wHaEZqV677S4I	2025-06-29 00:51:29.590604	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2018-03-24 16:58:25.62165	2018-03-24 16:58:25.62165	\N	\N	\N	\N	\N	email	\N	\N	2018-03-24 16:58:25.62165	legacy-import
6	derekdenunzio@comcast.net	Derek	Denunzio	\N	2a4hwe-CzTUFcJBVTzE135HJbew1MVBn1rmqXcxbktg	2025-06-29 00:51:29.592021	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2018-03-24 16:58:25.782825	2018-03-24 16:58:25.782825	\N	\N	\N	\N	\N	email	\N	\N	2018-03-24 16:58:25.782825	legacy-import
7	jarod.waybright@gmail.com	Jarod	Waybright	\N	Kqio0GoAc8P35aQXMAfheeruV7aKN91Od19mf-Um4M8	2025-06-29 00:51:29.593791	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2018-03-24 16:58:24.462165	2018-03-24 16:58:24.462165	\N	\N	\N	\N	\N	email	\N	\N	2018-03-24 16:58:24.462165	legacy-import
8	harvey.l.kathryn@gmail.com	Katie	Harvey	\N	sdbS_cGyLYkzQrtI0106BAYJ1nC0I14CES4mXQrHov4	2025-06-29 00:51:29.595211	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2018-03-24 16:58:24.970707	2018-03-24 16:58:24.970707	\N	\N	\N	\N	\N	email	\N	\N	2018-03-24 16:58:24.970707	legacy-import
9	kwecker19@gmail.com	Kyle	Ecker	\N	DgObomtl9qyfZw36AJCv8mZhRTX_I2KtJj8a6TMjs2w	2025-06-29 00:51:29.596686	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2018-03-24 16:58:26.114212	2018-03-24 16:58:26.114212	\N	\N	\N	\N	\N	email	\N	\N	2018-03-24 16:58:26.114212	legacy-import
10	cdv407@gmail.com	Charles 	Vance 	\N	ovIrbYMEVqfotOAxol73H8Q6RCXVrKH-TDDhhpasYQ0	2025-06-29 00:51:29.598389	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2018-03-24 16:58:24.787619	2018-03-24 16:58:24.787619	\N	\N	\N	\N	\N	email	\N	\N	2018-03-24 16:58:24.787619	legacy-import
11	my3catsdaddy@yahoo.com	Adin	Perl	\N	FlGgZXU7xQ2WnVaQN1GFnTtBgAr1vpU9txoknaz4nuI	2025-06-29 00:51:29.599793	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2018-03-24 16:58:25.461569	2018-07-30 00:36:01.225081	\N	\N	\N	\N	\N	email	\N	\N	2018-03-24 16:58:25.461569	legacy-import
12	bw.lingerfelt@yahoo.com	BRANDON	LINGERFELT	\N	Vv49hn4ZXYNQEu2zbpCOOX552CN0wYZLmWOAfCniM5g	2025-06-29 00:51:29.601205	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2018-03-24 16:58:25.959663	2018-03-24 16:58:25.959663	\N	\N	\N	\N	\N	email	\N	\N	2018-03-24 16:58:25.959663	legacy-import
13	wmg21@hotmail.com	william	gardner	\N	kvuK7Nom4bsfakKbv_LcvT_Cpl3NUfXNuXp5QVx6FJI	2025-06-29 00:51:29.602619	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2018-03-24 16:58:26.268653	2019-02-18 16:55:03.184706	\N	\N	\N	\N	\N	email	\N	\N	2018-03-24 16:58:26.268653	legacy-import
14	babiigrand88@aol.com	Kathryn	Garrett	\N	r846i3vPE3NemLGgWMJnCyg99-MSggGhX3ppqxeyLBc	2025-06-29 00:51:29.604312	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2018-03-24 16:58:26.4217	2018-03-24 16:58:26.4217	\N	\N	\N	\N	\N	email	\N	\N	2018-03-24 16:58:26.4217	legacy-import
15	kidalex10@gmail.com	Alex	Willard	\N	0u7jX795TN_2lwKBw8K2bEF1N2xp0n_wW6-AXJjQgaI	2025-06-29 00:51:29.605777	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2018-03-24 16:58:26.747237	2018-03-24 16:58:26.747237	\N	\N	\N	\N	\N	email	\N	\N	2018-03-24 16:58:26.747237	legacy-import
16	kyleclayton09@gmail.com	Kyle	Clayton	\N	hUaVip1K3CkPMqXF-QEgi8GBkThgkOf3Q4q-0TWtrl0	2025-06-29 00:51:29.607237	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2018-03-24 16:58:26.592532	2018-03-24 16:58:26.592532	\N	\N	\N	\N	\N	email	\N	\N	2018-03-24 16:58:26.592532	legacy-import
19	fividgentsiw@gmail.com	hDLwGCvTmy	LHWpDhZzGs	\N	HweBa3R4-aTvkAlg0aDBrb-EQrkzevpraIl0AbtxCTo	2025-06-29 00:51:29.691324	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2021-07-24 21:15:38.169277	2021-07-24 21:15:38.169277	\N	\N	\N	\N	\N	email	\N	\N	2021-07-24 21:15:38.169277	legacy-import
20	everodo6@mail.ru	Wem:theartexch.com Ich mag  www.audi.com	Wem:theartexch.com Ich mag  www.audi.com	\N	938_mdxVvzzmBjRYCS2EGvWuGboFzQpvTlBYuMuBQzU	2025-06-29 00:51:29.693174	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2021-08-23 05:06:32.348257	2021-08-23 05:06:32.348257	\N	\N	\N	\N	\N	email	\N	\N	2021-08-23 05:06:32.348257	legacy-import
21	jmfogg75@gmail.com	Jessica 	Fogg	\N	zmNRkyGH96-F7gxfsmm2zKqJ0uZVyub-46lnPV6BXJ0	2025-06-29 00:51:29.694761	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2021-09-17 07:01:14.497978	2021-09-17 07:01:14.497978	\N	\N	\N	\N	\N	email	\N	\N	2021-09-17 07:01:14.497978	legacy-import
22	bimmerchick@gmail.com	Jessica	Fogg	\N	qqZq8sPedd-eAurql3gDkIH4i_K31ORmg8jVSv_xX6Y	2025-06-29 00:51:29.696421	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2021-09-17 07:02:13.097282	2021-09-17 07:02:13.097282	\N	\N	\N	\N	\N	email	\N	\N	2021-09-17 07:02:13.097282	legacy-import
23	jan.sanford@yahoo.com	Burdette	Becker	\N	oHkcCTiD_j3wPsPRHMBt5IVbkZa-EHfRKxPTpMkG6Wg	2025-06-29 00:51:29.698171	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2021-10-04 04:27:41.565467	2021-10-04 04:27:41.565467	\N	\N	\N	\N	\N	email	\N	\N	2021-10-04 04:27:41.565467	legacy-import
24	mm.arki.z.de.sa.n.d.@gmail.com	JulieGom	JulieGom	\N	1Hf6guwfcaSN2lpPSRxRcUhzqZTIDv3VeOVXtfBlrpo	2025-06-29 00:51:29.699727	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2021-10-11 15:11:31.08922	2021-10-11 15:11:31.08922	\N	\N	\N	\N	\N	email	\N	\N	2021-10-11 15:11:31.08922	legacy-import
57	aunfleming86@gmail.com	Rubye	Dooley	\N	xv70WyP_0Nrew7LddOOTPrKJyW2EJ-5ncbR-zN7WHi0	2025-06-29 00:51:29.701537	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2021-10-24 04:09:53.792847	2021-10-24 04:09:53.792847	\N	\N	\N	\N	\N	email	\N	\N	2021-10-24 04:09:53.792847	legacy-import
58	lambertnaomi189@gmail.com	bGvRUMsEZDl	rAKHEZqh	\N	suLMA5Ki9lG1WnyDlacBPOuF9TDsykS6G0SHxv_WPuk	2025-06-29 00:51:29.703073	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2021-10-29 21:05:49.935522	2021-10-29 21:05:49.935522	\N	\N	\N	\N	\N	email	\N	\N	2021-10-29 21:05:49.935522	legacy-import
59	chrystalbarker23@gmail.com	JGpoPMDcxmVjL	DMycWANYGlHRnjv	\N	U7lzuZP0sK8OvLYmfagiRG52QgDVpHtaJHuGouZiQJQ	2025-06-29 00:51:29.704807	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2021-11-10 13:14:41.855053	2021-11-10 13:14:41.855053	\N	\N	\N	\N	\N	email	\N	\N	2021-11-10 13:14:41.855053	legacy-import
60	abbiegrace2009@yahoo.com	Sadie	Satterfield	\N	k76HL1Xlz6DsNdctIiCD08UPR7ssMTFAmxLsGZJnpG4	2025-06-29 00:51:29.706325	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2021-11-12 09:29:56.823612	2021-11-12 09:29:56.823612	\N	\N	\N	\N	\N	email	\N	\N	2021-11-12 09:29:56.823612	legacy-import
61	djmansour@rogers.com	Luz	Cartwright	\N	UApyVQ6yiT6iXzrxQUjgk_OLhElylRtR5dzrJoK6Cb4	2025-06-29 00:51:29.70798	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2021-11-17 16:47:57.842764	2021-11-17 16:47:57.842764	\N	\N	\N	\N	\N	email	\N	\N	2021-11-17 16:47:57.842764	legacy-import
62	nuttermegan@gmail.com	Kathleen	Nicolas	\N	naj7SDvpyddiOsAjaxVk9xAoQmL8NsDnF57Zp1QSeu0	2025-06-29 00:51:29.709497	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2021-11-19 03:47:57.750887	2021-11-19 03:47:57.750887	\N	\N	\N	\N	\N	email	\N	\N	2021-11-19 03:47:57.750887	legacy-import
63	danwmc@gmail.com	Carrie	Larson	\N	kK4JL7pnM8lKiZnnssk3q81BzdaCT3EDLiJzQRkRwDI	2025-06-29 00:51:29.711051	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2021-11-19 22:08:13.191514	2021-11-19 22:08:13.191514	\N	\N	\N	\N	\N	email	\N	\N	2021-11-19 22:08:13.191514	legacy-import
64	booker_olivia@live.com	Olivia	Booker	\N	HusPD41YInpE3fiG-zzDdvqdPILmA20Kqx4itS6hDnI	2025-06-29 00:51:29.712749	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2021-11-26 05:29:45.564202	2021-11-26 05:30:34.04964	\N	\N	\N	\N	\N	email	\N	\N	2021-11-26 05:29:45.564202	legacy-import
65	jeffwright706517@gmail.com	TjvepgBPZwOyJARI	ymHdrakVjKsQI	\N	Yka1x-Tt-79pWJ1doHx9LA_BQmtPi4sb0WM-uD7pkbk	2025-06-29 00:51:29.714341	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2021-12-07 00:16:05.148778	2021-12-07 00:16:05.148778	\N	\N	\N	\N	\N	email	\N	\N	2021-12-07 00:16:05.148778	legacy-import
66	dadayehya90@gmail.com	Jaquan	Mayer	\N	ab5gAX1LkhSbY-4dcZWRMMjdPYXa9YimD43CziERdkg	2025-06-29 00:51:29.715992	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2021-12-10 06:35:16.7903	2021-12-10 06:35:16.7903	\N	\N	\N	\N	\N	email	\N	\N	2021-12-10 06:35:16.7903	legacy-import
67	isonntorai99@gmail.com	uNzvCVOMhGFre	XkrsflFmhMve	\N	3C_kBV2qBOddhLT2dPGS7BawantMJKO3_O9YWCvuarA	2025-06-29 00:51:29.717562	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2021-12-15 11:19:24.266236	2021-12-15 11:19:24.266236	\N	\N	\N	\N	\N	email	\N	\N	2021-12-15 11:19:24.266236	legacy-import
68	sufi.safavi@kultur.goteborg.se	Sufi	af Safavi	\N	Ff_J6Y1RpSDqhuL2LSxsnm62MjJn78nuCCe-BzD7XWw	2025-06-29 00:51:29.719221	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2021-12-17 07:08:32.439425	2021-12-17 07:08:32.439425	\N	\N	\N	\N	\N	email	\N	\N	2021-12-17 07:08:32.439425	legacy-import
69	catherinemandras@gmail.com	Dino	Roob	\N	0c7QjmBthgsTlsESx6jsfxVKHmOpXosvd-3v67ugk4k	2025-06-29 00:51:29.720988	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2021-12-21 11:05:47.238502	2021-12-21 11:05:47.238502	\N	\N	\N	\N	\N	email	\N	\N	2021-12-21 11:05:47.238502	legacy-import
70	wasondemp29559@gmail.com	dXvzkSBRwEo	SGovlyFnLb	\N	XFzW5qVBcGZXScHjd1LjJO-DLlAHfj5KoKYD4G0ZB88	2025-06-29 00:51:29.722622	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2021-12-24 14:31:04.596434	2021-12-24 14:31:04.596434	\N	\N	\N	\N	\N	email	\N	\N	2021-12-24 14:31:04.596434	legacy-import
71	ekatz8869@yahoo.com	Anna	Dare	\N	VSIfmpWL5MuroKtknCpb2DzNaYxIv9iK6N63N6YW6QI	2025-06-29 00:51:29.72433	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2021-12-29 05:39:31.076827	2021-12-29 05:39:31.076827	\N	\N	\N	\N	\N	email	\N	\N	2021-12-29 05:39:31.076827	legacy-import
72	vrdz2006@yahoo.com	Eli	Dickens	\N	rrPA6DVk0sZW9D6SyODhdz38CYsCuVbnwV2EXGDWC8I	2025-06-29 00:51:29.725887	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2022-01-05 08:13:18.286867	2022-01-05 08:13:18.286867	\N	\N	\N	\N	\N	email	\N	\N	2022-01-05 08:13:18.286867	legacy-import
73	shaungrinnell@hotmail.com	Immanuel	Volkman	\N	QMV0KYtg3-88q4srjPfrIzik-bR_8VQxGnNHadF7-fI	2025-06-29 00:51:29.727397	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2022-01-06 01:47:23.436803	2022-01-06 01:47:23.436803	\N	\N	\N	\N	\N	email	\N	\N	2022-01-06 01:47:23.436803	legacy-import
207	dsn@cgocable.ca	Dasia	Leannon	\N	Vy2wvUeLjQbTDq6LK48eg3QQssIQYh0x7Sjg01ip-54	2025-06-29 00:51:29.798922	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2022-08-30 15:47:07.30421	2022-08-30 15:47:07.30421	\N	\N	\N	\N	\N	email	\N	\N	2022-08-30 15:47:07.30421	legacy-import
106	jenzuknick@yahoo.com	Josianne	Corwin	\N	_8hpQi87AGMN7Tk7NrN7z4kNJG90-9u9UnLi_N1kr4E	2025-06-29 00:51:29.728914	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2022-01-09 12:52:13.954763	2022-01-09 12:52:13.954763	\N	\N	\N	\N	\N	email	\N	\N	2022-01-09 12:52:13.954763	legacy-import
107	miascanrukodavo@mail.com	DavidprisT	DavidprisT	\N	_lCDU12A-3Smkaz1C0Ak5MZ0IUU0KU8GVIoJEKocar0	2025-06-29 00:51:29.731265	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2022-01-14 21:34:57.055021	2022-01-14 21:34:57.055021	\N	\N	\N	\N	\N	email	\N	\N	2022-01-14 21:34:57.055021	legacy-import
108	mw946923@gmail.com	kjbcmGJUPp	mMvKBgbHIOaD	\N	mSsQ4wsnmU049HKB0GxNX2_gZCB_VLhjCjr78dsQGNE	2025-06-29 00:51:29.732807	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2022-01-17 01:18:19.8338	2022-01-17 01:18:19.8338	\N	\N	\N	\N	\N	email	\N	\N	2022-01-17 01:18:19.8338	legacy-import
109	premecnusupawnwb@mail.com	Donaldheant	Donaldheant	\N	f6Sa2Oju-LUM0_YcoNJ8yFXwCp2uovWGsjLQNLSyZus	2025-06-29 00:51:29.742693	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2022-01-18 01:39:09.936544	2022-01-18 01:39:09.936544	\N	\N	\N	\N	\N	email	\N	\N	2022-01-18 01:39:09.936544	legacy-import
110	clarsukigedramzh@mail.com	MatthewMum	MatthewMum	\N	f3uyXwWDgQHY8fVGVmfUyemHjTU1sr-9Q5OaDFrW94o	2025-06-29 00:51:29.744616	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2022-01-18 19:46:43.506186	2022-01-18 19:46:43.506186	\N	\N	\N	\N	\N	email	\N	\N	2022-01-18 19:46:43.506186	legacy-import
111	gaubagszokuspeechxl@mail.com	Hectorraf	Hectorraf	\N	iylK_anjvA7eDaFPdA7AF-TXqqrDLERAP5ZoMQ-ISSI	2025-06-29 00:51:29.746226	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2022-01-19 19:44:36.119821	2022-01-19 19:44:36.119821	\N	\N	\N	\N	\N	email	\N	\N	2022-01-19 19:44:36.119821	legacy-import
112	manningbowman651768@gmail.com	AfXgLiUWnvZabsc	IRdZitJU	\N	CSZ5CWWBqqalOjRjY1xAcGMg2nQw-nmZPw445CegqkM	2025-06-29 00:51:29.74805	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2022-01-25 11:57:49.480175	2022-01-25 11:57:49.480175	\N	\N	\N	\N	\N	email	\N	\N	2022-01-25 11:57:49.480175	legacy-import
113	alice.moody.87@mail.ru	SandTor drtyuiofghjkasdwertylkmnbvcz https://clover.page.link/kNgm	SandTor drtyuiofghjkasdwertylkmnbvcz https://clover.page.link/kNgm	\N	KZ1l9pTS9VmjEhxbGxobeIpHr8tgE6EXVzTpm5tXFVQ	2025-06-29 00:51:29.749663	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2022-02-03 09:10:22.339347	2022-02-03 09:10:22.339347	\N	\N	\N	\N	\N	email	\N	\N	2022-02-03 09:10:22.339347	legacy-import
114	psykoxypher@yahoo.com	Derrick	Runolfsdottir	\N	zqSz8AXDka0rIlU_ZZhU_f298KO9kUfKfFdUDOG7mUo	2025-06-29 00:51:29.75165	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2022-02-07 06:01:32.318155	2022-02-07 06:01:32.318155	\N	\N	\N	\N	\N	email	\N	\N	2022-02-07 06:01:32.318155	legacy-import
115	plk9912@yahoo.com	Louvenia	Kemmer	\N	_2tuWCeZ98mG4LjGO7gd7ZdaMwPSFj0KrYgJErzea8s	2025-06-29 00:51:29.753208	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2022-02-08 03:12:13.774447	2022-02-08 03:12:13.774447	\N	\N	\N	\N	\N	email	\N	\N	2022-02-08 03:12:13.774447	legacy-import
116	rosettaklmannchen254@gmail.com	tXqTmNDHoWdxC	nogOTBtCJWxSNp	\N	EZEaq9AOsKgmAr3Lyy4OD538luNGvyBNJfx7-FVkwGo	2025-06-29 00:51:29.754852	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2022-02-10 08:30:15.581884	2022-02-10 08:30:15.581884	\N	\N	\N	\N	\N	email	\N	\N	2022-02-10 08:30:15.581884	legacy-import
117	sotira79@yahoo.com	Murray	Mayert	\N	2OrdtmMEoroYFqND8BUZ3dzP6i5uxsf-so4dzuuJsv0	2025-06-29 00:51:29.75662	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2022-02-14 01:07:21.404738	2022-02-14 01:07:21.404738	\N	\N	\N	\N	\N	email	\N	\N	2022-02-14 01:07:21.404738	legacy-import
118	latinkaria92@gmail.com	chneaYOXG	aAwHpxJVkqBD	\N	r0ewW1JajnQp3ETbsSBv1gE8EE55kP7D8CjcxLa2HCI	2025-06-29 00:51:29.758278	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2022-02-18 16:37:16.319635	2022-02-18 16:37:16.319635	\N	\N	\N	\N	\N	email	\N	\N	2022-02-18 16:37:16.319635	legacy-import
119	kim197712kyla@yahoo.com	Candida	Green	\N	YV0VoHQ-BhlKPbEIQ_rR-Yguk_-SgW7a1IglHlHNS_I	2025-06-29 00:51:29.759888	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2022-02-20 23:22:35.858028	2022-02-20 23:22:35.858028	\N	\N	\N	\N	\N	email	\N	\N	2022-02-20 23:22:35.858028	legacy-import
120	ramdane85@gmail.com	Frieda	Metz	\N	DJA3hmKwNRsQbWnkSoauSsT3e2g8NnaYfB90sggC3lA	2025-06-29 00:51:29.761593	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2022-02-21 14:51:42.451065	2022-02-21 14:51:42.451065	\N	\N	\N	\N	\N	email	\N	\N	2022-02-21 14:51:42.451065	legacy-import
121	tracy.yip21@gmail.com	Nyasia	Waters	\N	Orgk1B9_EKwrBjVuUwTGtut2I1je9Moee2gtsnnkbIc	2025-06-29 00:51:29.763182	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2022-02-26 09:05:10.887914	2022-02-26 09:05:10.887914	\N	\N	\N	\N	\N	email	\N	\N	2022-02-26 09:05:10.887914	legacy-import
122	zachary_raybourn@yahoo.com	Darren	Schneider	\N	41ORvF1RSCQZ43Z9hRLZOg4RJXaOf3cBoQzQsyjo6ZA	2025-06-29 00:51:29.764764	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2022-02-27 11:04:11.772161	2022-02-27 11:04:11.772161	\N	\N	\N	\N	\N	email	\N	\N	2022-02-27 11:04:11.772161	legacy-import
123	phildo1954@gmail.com	Amya	Daugherty	\N	MZx-403YdhywOUkWmWvAxGwUYqdq2Iwa8cHHk2ywKyo	2025-06-29 00:51:29.766384	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2022-03-01 18:26:22.658182	2022-03-01 18:26:22.658182	\N	\N	\N	\N	\N	email	\N	\N	2022-03-01 18:26:22.658182	legacy-import
124	justicecoronziazhgz@gmail.com	NhcaQTBU	SpfAQnGJTo	\N	H7Bh6AjV1434HfhY0icovQ7dto8lbZYLP4xFQptQeVY	2025-06-29 00:51:29.767917	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2022-03-02 16:35:47.860372	2022-03-02 16:35:47.860372	\N	\N	\N	\N	\N	email	\N	\N	2022-03-02 16:35:47.860372	legacy-import
125	alexandra.kuit@yahoo.co.uk	Raymundo	Braun	\N	1k8PYbzM6LCiTrD3ypXwCc8ejYl89jeeplo4GkcBvB8	2025-06-29 00:51:29.769629	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2022-03-08 01:51:57.768774	2022-03-08 01:51:57.768774	\N	\N	\N	\N	\N	email	\N	\N	2022-03-08 01:51:57.768774	legacy-import
126	babuklhakim0@gmail.com	Ixizkbuynw	YZVuODLXUwoMv	\N	wRXDPGFPRJB-ljqKc2IO3jbfPLjvcPGR-LdL-_2RLVQ	2025-06-29 00:51:29.771307	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2022-03-16 14:58:47.820943	2022-03-16 14:58:47.820943	\N	\N	\N	\N	\N	email	\N	\N	2022-03-16 14:58:47.820943	legacy-import
159	linh58746584@gmail.com	vUkqBTnzlHtxYu	YUhLAOploTR	\N	JHCstXcTuSFgjcwdSxm19Lv7tZbU7q-mRP9GzvjrhSs	2025-06-29 00:51:29.772999	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2022-03-22 18:52:37.282781	2022-03-22 18:52:37.282781	\N	\N	\N	\N	\N	email	\N	\N	2022-03-22 18:52:37.282781	legacy-import
160	kunzekati2@gmail.com	RWGifrQa	zoBbrucZVOHY	\N	Dj5VTCYs-oic5Elw1iyXSpRPyx2ZHfOMmAE85Ll1SK0	2025-06-29 00:51:29.774836	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2022-04-04 14:16:48.769367	2022-04-04 14:16:48.769367	\N	\N	\N	\N	\N	email	\N	\N	2022-04-04 14:16:48.769367	legacy-import
161	khdfejwvwi@gmail.com	svieMRnjpJy	xUoEVihmGMeCrqJn	\N	V47IyEr6xB444I9emZ6HxincX1b2e7mNIbYXXiWbo-Q	2025-06-29 00:51:29.776686	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2022-04-11 20:20:50.371114	2022-04-11 20:20:50.371114	\N	\N	\N	\N	\N	email	\N	\N	2022-04-11 20:20:50.371114	legacy-import
162	ksenofontmaidanov+4t2t@mail.ru	theartexch.com ugrfeiohofidsksmvnjdbvsijf94t9u5t0i4r94ijgrjght9y84r49t64rkowf0ereiuguejdkwdiweofuehdskodjjdgofjsoddggfsidj	theartexch.com ugrfeiohofidsksmvnjdbvsijf94t9u5t0i4r94ijgrjght9y84r49t64rkowf0ereiuguejdkwdiweofuehdskodjjdgofjsoddggfsidj	\N	n-D9mrbVfB5cMFfk_ywf0xKKmvgsNid6S-P76AJC3nw	2025-06-29 00:51:29.778392	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2022-04-16 01:34:25.380016	2022-04-16 01:34:25.380016	\N	\N	\N	\N	\N	email	\N	\N	2022-04-16 01:34:25.380016	legacy-import
163	onscheithhc@gmail.com	VYjhtXCOwev	qXPBNVJhkoZUWlzS	\N	xn5lYoNk5hK9YJ6T2vYrVJmgcH8s68HcSAseJcaJNFw	2025-06-29 00:51:29.780373	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2022-04-25 14:18:02.252237	2022-04-25 14:18:02.252237	\N	\N	\N	\N	\N	email	\N	\N	2022-04-25 14:18:02.252237	legacy-import
164	shakoriifarhad6@gmail.com	RnrcfQSHxwMmVlbI	XMsYWupcZJTAUoSh	\N	ZSkrz7hLRAV920KTY1WKxA2FqkQyyFjfbL6aluTwij8	2025-06-29 00:51:29.781991	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2022-05-02 00:36:39.570546	2022-05-02 00:36:39.570546	\N	\N	\N	\N	\N	email	\N	\N	2022-05-02 00:36:39.570546	legacy-import
165	adekunle1e4vbo295i@outlook.com	DlRCSPyY	gGDfvIdpNhbrw	\N	ap5ptL_4pI2auCKP_nqF3mW5loEoxGfac194Iu_0EV4	2025-06-29 00:51:29.783582	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2022-06-16 15:44:21.063223	2022-06-16 15:44:21.063223	\N	\N	\N	\N	\N	email	\N	\N	2022-06-16 15:44:21.063223	legacy-import
166	ejefrey7o83424ew17@outlook.com	ZoSktqMlQKGLiHJE	NIYkDjhcRipzMETb	\N	rDdZ93VpZTi9s0uz8VxTU0QzSf-cq93_p4XmhF3_dy8	2025-06-29 00:51:29.785192	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2022-06-23 23:37:03.66141	2022-06-23 23:37:03.66141	\N	\N	\N	\N	\N	email	\N	\N	2022-06-23 23:37:03.66141	legacy-import
167	corinthianu03196l@outlook.com	fVNCrdcqPUsa	qAYdaQDebjiSsO	\N	7-k-30fX5S0--eQwam6YOcfI7qKs5SRAo7PKi6VcL-0	2025-06-29 00:51:29.786788	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2022-07-15 07:33:32.722343	2022-07-15 07:33:32.722343	\N	\N	\N	\N	\N	email	\N	\N	2022-07-15 07:33:32.722343	legacy-import
168	ktristyn5il4k2aj1@outlook.com	WmveQfdOiXhRNwx	TUiLYIbfkhnXr	\N	neQngsoactlhbtYB_b-1ehFfU6zMDG24RS7QqzBYegM	2025-06-29 00:51:29.78841	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2022-08-01 13:48:26.938251	2022-08-01 13:48:26.938251	\N	\N	\N	\N	\N	email	\N	\N	2022-08-01 13:48:26.938251	legacy-import
201	xnnenna81y4ho0xu@outlook.com	FOvEHIRifM	HPCDVtuMgv	\N	QYvJtQZ5bQ-mmjOY_-wlhU9HTWdmEB5sUdq3P1QVHyc	2025-06-29 00:51:29.790035	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2022-08-07 11:44:43.377307	2022-08-07 11:44:43.377307	\N	\N	\N	\N	\N	email	\N	\N	2022-08-07 11:44:43.377307	legacy-import
202	uandreaiw2wuyu4@outlook.com	tpHxkQInesD	lFhzYTtJCxqd	\N	YL_UEKhBscaFDSFHFCQ87i6oARmYCZ26NwSXPmJXsuY	2025-06-29 00:51:29.791551	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2022-08-18 23:30:50.725842	2022-08-18 23:30:50.725842	\N	\N	\N	\N	\N	email	\N	\N	2022-08-18 23:30:50.725842	legacy-import
203	johnpaul842_rath.1964@alabamahomenetwoks.com	London	Dickinson	\N	PS7qpTqjxB_DQ4Rfr1WCC3hjFVugvVHTa5agX_llhXw	2025-06-29 00:51:29.793025	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2022-08-28 15:18:28.103954	2022-08-28 15:18:28.103954	\N	\N	\N	\N	\N	email	\N	\N	2022-08-28 15:18:28.103954	legacy-import
204	johanna536schulist.1997@alabamahomenetwoks.com	Maia	Schulist	\N	YtEgesojcjJHUGoXlkVVECX98mXO-0Quwc-px_mn8gs	2025-06-29 00:51:29.79448	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2022-08-28 15:18:33.870183	2022-08-28 15:18:33.870183	\N	\N	\N	\N	\N	email	\N	\N	2022-08-28 15:18:33.870183	legacy-import
205	korinnex48y82i9@outlook.com	mGQdlKaMghxkN	UIfKhBemGbDLMY	\N	xO6arjKo7qyLc2unBVhEyFre-xr8Md0-JP6qET8GesU	2025-06-29 00:51:29.795929	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2022-08-29 18:24:42.793617	2022-08-29 18:24:42.793617	\N	\N	\N	\N	\N	email	\N	\N	2022-08-29 18:24:42.793617	legacy-import
206	jeanniet71@gmail.com	Clovis	Jaskolski	\N	Zm1tYK98Km7Fg2s-NpX6tTHrfRF2kO2Qak1bL4AIYps	2025-06-29 00:51:29.797439	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2022-08-30 05:56:35.520735	2022-08-30 05:56:35.520735	\N	\N	\N	\N	\N	email	\N	\N	2022-08-30 05:56:35.520735	legacy-import
208	kennethiaz646ycbao@outlook.com	xJgiLnRbTtuFY	wtYlMxFvhoCDn	\N	ihWfYwpXRqj0TKRuNGLk_cNkEwSlwE4t8-qiybB0pVU	2025-06-29 00:51:29.800408	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2022-09-10 06:47:10.318004	2022-09-10 06:47:10.318004	\N	\N	\N	\N	\N	email	\N	\N	2022-09-10 06:47:10.318004	legacy-import
209	uerinikt150u@outlook.com	AVkFPtKidewU	iDzSCAbXeQkt	\N	zBV0DT4tBpesr3HUHBVlsvWc6Rzi0nb6BXM8c66EZZc	2025-06-29 00:51:29.801984	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2022-09-17 19:52:49.452023	2022-09-17 19:52:49.452023	\N	\N	\N	\N	\N	email	\N	\N	2022-09-17 19:52:49.452023	legacy-import
210	antonkovpt5@outlook.com	KasIVypCjDJ	GumUeFwIErfVBNj	\N	QxwYcY426dO0YtuMmbChujEfZ820e2B1p20kDpLFPCw	2025-06-29 00:51:29.80338	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2022-10-11 19:49:13.932534	2022-10-11 19:49:13.932534	\N	\N	\N	\N	\N	email	\N	\N	2022-10-11 19:49:13.932534	legacy-import
211	sergeyshahn1@outlook.com	iXyvkPVwRW	EtxsOgVw	\N	u2_o9Lq0XwBgJ9h6jYBKUy4pyOS7Gu-0mmHTaNrteAE	2025-06-29 00:51:29.804813	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2022-10-19 00:13:01.139099	2022-10-19 00:13:01.139099	\N	\N	\N	\N	\N	email	\N	\N	2022-10-19 00:13:01.139099	legacy-import
244	ivankak9s@outlook.com	zCGDfTmpdiq	RcxAEFid	\N	WK8q0r-E6dE5ZYCyCV9Jt5WcTb9BzHEkkn-X1bZW9IY	2025-06-29 00:51:29.806202	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2022-10-22 06:42:52.065885	2022-10-22 06:42:52.065885	\N	\N	\N	\N	\N	email	\N	\N	2022-10-22 06:42:52.065885	legacy-import
245	fedorkisgl45@outlook.com	KdCSrRzlyHpNvn	XfrcbVlIm	\N	nBd33j6Hm6HrjLpnohWVXN5AD9DHwcVNWLI1J0qPJmE	2025-06-29 00:51:29.807613	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2022-10-25 13:13:28.110009	2022-10-25 13:13:28.110009	\N	\N	\N	\N	\N	email	\N	\N	2022-10-25 13:13:28.110009	legacy-import
246	g.e.r.al.dku.m.s.ert@gmail.com	<html><a href="https://google.com"><img src="https://blogger.googleusercontent.com/img/a/AVvXsEgXM4xrSRAnQQOLZImSaLdACcB-BosbLfsYEsXB-lLBl71Ma4AFA4xbB22ruqkub9W8nQCJVUXuXvJQeNLG2yoUL-OxTbhSvuyduxRSQI5RsQSu6DbfkMCVMuCuRB1uzs4KNkp3gZjcKQeubD_3RZ6p3xDAEpOwy6LnNnGhSa3h4V04dq3zc3oZajp_=s16000"></a></br> theartexch.com fgiufhew9ew9f8weufjw9h8egfewjf0werhgerufjwe9g0ter8fewpwjf9ew084hge5ugt4ew4tj048hyte54r</html>	<html><a href="https://google.com"><img src="https://blogger.googleusercontent.com/img/a/AVvXsEgXM4xrSRAnQQOLZImSaLdACcB-BosbLfsYEsXB-lLBl71Ma4AFA4xbB22ruqkub9W8nQCJVUXuXvJQeNLG2yoUL-OxTbhSvuyduxRSQI5RsQSu6DbfkMCVMuCuRB1uzs4KNkp3gZjcKQeubD_3RZ6p3xDAEpOwy6LnNnGhSa3h4V04dq3zc3oZajp_=s16000"></a></br> theartexch.com fgiufhew9ew9f8weufjw9h8egfewjf0werhgerufjwe9g0ter8fewpwjf9ew084hge5ugt4ew4tj048hyte54r</html>	\N	3wINJEXh7znqUu0GH1Ytdd5BZSf1qbSTgjOwZQfTsC4	2025-06-29 00:51:29.809034	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2022-10-26 21:15:05.641797	2022-10-26 21:15:05.641797	\N	\N	\N	\N	\N	email	\N	\N	2022-10-26 21:15:05.641797	legacy-import
247	marisa6sf6millie@outlook.com	kHsbQrgOCURT	VfROsDoixyQqNlAZ	\N	f0zv8gBk74ZBVybre7PzPLSRiMPQT4YpPbjOWSaJ_Ac	2025-06-29 00:51:29.810435	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2022-11-08 07:30:48.054281	2022-11-08 07:30:48.054281	\N	\N	\N	\N	\N	email	\N	\N	2022-11-08 07:30:48.054281	legacy-import
248	g.e.ral.d.ku.ms.e.rt@gmail.com	NufhedjiwidjwjdwihdisjadhuijdaodejguhweikabfdJIDHWIAUFAWFAWHFAAJDIHIjifheifjeifhwodjssfhuiifiwswhdusfi theartexch.com	NufhedjiwidjwjdwihdisjadhuijdaodejguhweikabfdJIDHWIAUFAWFAWHFAAJDIHIjifheifjeifhwodjssfhuiifiwswhdusfi theartexch.com	\N	ci1au-wJyO8WwC0QdnylXG6wmEoNq8qdF9NaOq9Sgi8	2025-06-29 00:51:29.812024	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2022-11-11 09:51:04.176174	2022-11-11 09:51:04.176174	\N	\N	\N	\N	\N	email	\N	\N	2022-11-11 09:51:04.176174	legacy-import
249	fuwwurosep@outlook.com	YBfjkrVMg	SaInEqxNp	\N	aueRIHYMi7RYzu3REyE-zDQdoMcPm5-px_VutyGpzAI	2025-06-29 00:51:29.813494	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2022-11-15 18:47:55.549683	2022-11-15 18:47:55.549683	\N	\N	\N	\N	\N	email	\N	\N	2022-11-15 18:47:55.549683	legacy-import
250	muibecomp1992@mail.ru	Backi to in WLRISS902610WLRISS2 eon02. UEARMYT misxlx sitee http://apple.com	Backi to in WLRISS902610WLRISS2 eon02. UEARMYT misxlx sitee http://apple.com	\N	oTUZTTrzz5qGgDUJloYOyOgi-DTDq86qX42jLr4FcV0	2025-06-29 00:51:29.814872	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2022-11-21 17:10:19.472308	2022-11-21 17:10:19.472308	\N	\N	\N	\N	\N	email	\N	\N	2022-11-21 17:10:19.472308	legacy-import
251	tolbopujar@outlook.com	HFlnhJVCGLpy	rvPbULsBQigh	\N	-isPqJXSObjE5KW6JqwN71m6z6VDagmVDfNcdxy21mM	2025-06-29 00:51:29.816316	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2022-11-21 19:26:42.641447	2022-11-21 19:26:42.641447	\N	\N	\N	\N	\N	email	\N	\N	2022-11-21 19:26:42.641447	legacy-import
252	x01mp3rx0z@mailto.plus	Hello World! https://ri27je.com?hs=8f26f3b6baf9e61878c9711069f43247&	7bi2df	\N	oygKF0mB927jj4qiUXCS1_X0uoRD9vgPFUNCoTbPABs	2025-06-29 00:51:29.817696	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2022-11-24 13:14:24.818935	2022-11-24 13:14:24.818935	\N	\N	\N	\N	\N	email	\N	\N	2022-11-24 13:14:24.818935	legacy-import
253	vijdogodek@outlook.com	pYosStRJ	xcSVTQfWrJNYzbsB	\N	ytxx8DejgDQZyY7HbUz9fcuY66wGAqaR0da1422bVl0	2025-06-29 00:51:29.81904	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2022-11-25 21:04:08.679091	2022-11-25 21:04:08.679091	\N	\N	\N	\N	\N	email	\N	\N	2022-11-25 21:04:08.679091	legacy-import
254	lefwokevic@outlook.com	lieonJRkm	jOhvfAdGSHuD	\N	JnclvUutIR_tvXDJb5rSKMqYv6_e-Sdf_pdALX0DI78	2025-06-29 00:51:29.820386	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2022-12-05 07:39:25.175526	2022-12-05 07:39:25.175526	\N	\N	\N	\N	\N	email	\N	\N	2022-12-05 07:39:25.175526	legacy-import
255	betluyonuv@outlook.com	CXiStGDvBa	IySNjJaUYLABwrd	\N	Y0lX9CcBbi6lR8BbgaibusrEgRC89RRI8PJjM3RBlak	2025-06-29 00:51:29.821886	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2022-12-10 23:50:29.453069	2022-12-10 23:50:29.453069	\N	\N	\N	\N	\N	email	\N	\N	2022-12-10 23:50:29.453069	legacy-import
256	baptijeseg@outlook.com	IjUPMlGbQJxqVZwX	kpQFEGSalx	\N	4UQ6bh9SrOwsOt8_1ALkJYMHHTVn7hKyso9okTysyrk	2025-06-29 00:51:29.823415	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2022-12-19 17:38:51.483364	2022-12-19 17:38:51.483364	\N	\N	\N	\N	\N	email	\N	\N	2022-12-19 17:38:51.483364	legacy-import
257	yakhasogen@outlook.com	hMRkbDBcP	nMcgoAtOCDNSU	\N	pzPVbM9N0KMsLWo2UqU5tlR5LZYMuDkyd9hqOxy_FuA	2025-06-29 00:51:29.824767	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2022-12-28 09:03:03.335897	2022-12-28 09:03:03.335897	\N	\N	\N	\N	\N	email	\N	\N	2022-12-28 09:03:03.335897	legacy-import
258	delia4qterry@outlook.com	duHQqtJc	kdBlUOnhLuSiD	\N	zlj7pUT9WE0wMZwQFetOxKyJtQySwk44N-Xc171A7KQ	2025-06-29 00:51:29.826142	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-01-21 13:01:06.171014	2023-01-21 13:01:06.171014	\N	\N	\N	\N	\N	email	\N	\N	2023-01-21 13:01:06.171014	legacy-import
291	eveiedus@emailler.tk	nem7811892tetcher	nem7811892tetcher	\N	U9PO_CLzUUZP3J15Pz3e55oLWev8bZG94mwcuKsibMo	2025-06-29 00:51:29.827542	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-02-07 01:46:49.162275	2023-02-07 01:46:49.162275	\N	\N	\N	\N	\N	email	\N	\N	2023-02-07 01:46:49.162275	legacy-import
292	puwjiqukit@outlook.com	zbmcSICVxhjY	SRNIsTVqzmHD	\N	mLQHgFxJQQO0X2rZLaJZ1PUe9AjC_dia-sx2oCfoK2k	2025-06-29 00:51:29.828901	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-02-15 22:02:57.982086	2023-02-15 22:02:57.982086	\N	\N	\N	\N	\N	email	\N	\N	2023-02-15 22:02:57.982086	legacy-import
293	loriflxe5@outlook.com	AyznmibsDQ	QuIhTwEmW	\N	YiJAnPSDNWVYZMALBpYFHDiRfp-VhtUafd-PRbesbxc	2025-06-29 00:51:29.830229	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-02-24 03:48:48.399857	2023-02-24 03:48:48.399857	\N	\N	\N	\N	\N	email	\N	\N	2023-02-24 03:48:48.399857	legacy-import
294	al.be.rtha.nsh.in.49@gmail.com	Mefijwdihwdjwsjdhwjqsqodkwfk fjebfhjhdjwshfewifejqwwqfewjfewhgewu kfwejfwefhewgeuwh:jfefehfejfjehfie//NJjdshdjwfhwu оаипруафравгпшцурафцоварквшпругвыовапцушгысвыарршрпшц jcsafsafhawfjewoifhe ufhdfwjdhewifgewiufhjadwfewi theartexch.com	Mefijwdihwdjwsjdhwjqsqodkwfk fjebfhjhdjwshfewifejqwwqfewjfewhgewu kfwejfwefhewgeuwh:jfefehfejfjehfie//NJjdshdjwfhwu оаипруафравгпшцурафцоварквшпругвыовапцушгысвыарршрпшц jcsafsafhawfjewoifhe ufhdfwjdhewifgewiufhjadwfewi theartexch.com	\N	hZ7RVkdKUyYZ_aq92rqc51Wg3X6A2JaRKuwFCcQ905U	2025-06-29 00:51:29.833042	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-03-09 17:29:14.396369	2023-03-09 17:29:14.396369	\N	\N	\N	\N	\N	email	\N	\N	2023-03-09 17:29:14.396369	legacy-import
295	snyderderrek@yahoo.com	nTzdtwBirQpRD	sfXYbriVwhRTUKoS	\N	keBFScaMoIr8IueCMcUnZCpQbXVplJKJpJBR6PF0SME	2025-06-29 00:51:29.834464	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-04-05 16:00:04.920483	2023-04-05 16:00:04.920483	\N	\N	\N	\N	\N	email	\N	\N	2023-04-05 16:00:04.920483	legacy-import
328	alber.th.a.nsh.i.n4.9@gmail.com	Opfkeodjwihefjwdwhf ifefkqwjioehfuewfwejfksfhweo ifoejkfdpwjfweoihfiewfowfowejfi fjewifjweighjvmhfewifjoepfjpwijgiowrh feiqjfweijfoiwhguhfwkdwjewfgeruhgrujfweij hfiohewifohwuighewuh theartexch.com	Opfkeodjwihefjwdwhf ifefkqwjioehfuewfwejfksfhweo ifoejkfdpwjfweoihfiewfowfowejfi fjewifjweighjvmhfewifjoepfjpwijgiowrh feiqjfweijfoiwhguhfwkdwjewfgeruhgrujfweij hfiohewifohwuighewuh theartexch.com	\N	2pDcfJQWV2mtftFXVAuE6SBHW4SJJRp-kmw_l5HJoA0	2025-06-29 00:51:29.835801	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-04-21 01:06:19.070677	2023-04-21 01:06:19.070677	\N	\N	\N	\N	\N	email	\N	\N	2023-04-21 01:06:19.070677	legacy-import
329	djacobson2303@gmail.com	David	Jacobson	\N	Sh6SmLsMmGr2zbKSx6m-pZUkOx6S-SGoUjjT_UGm1sc	2025-06-29 00:51:29.837154	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-04-23 18:56:34.860944	2023-04-23 18:56:34.860944	\N	\N	\N	\N	\N	email	\N	\N	2023-04-23 18:56:34.860944	legacy-import
330	ayfkuh@tofeat.com	Hello World! https://racetrack.top/go/giywczjtmm5dinbs?hs=8f26f3b6baf9e61878c9711069f43247&	nhzzup	\N	TeeJ05QPtzG3BruXGZuocPn9wwTcclbIyWTPZ0lMBXs	2025-06-29 00:51:29.838574	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-04-26 09:20:12.988021	2023-04-26 09:20:12.988021	\N	\N	\N	\N	\N	email	\N	\N	2023-04-26 09:20:12.988021	legacy-import
331	ziwtiboyuw@outlook.com	zCVdgGbE	PWUlaJtGAEDNzy	\N	YtyfAA_kML9WLPHM7fYlSVy7oE0NuOLmaeuoT5Msy1k	2025-06-29 00:51:29.839929	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-06-04 18:55:44.791477	2023-06-04 18:55:44.791477	\N	\N	\N	\N	\N	email	\N	\N	2023-06-04 18:55:44.791477	legacy-import
332	rebeccasturniolo@gmail.com	Rebecca	Sturniolo	\N	hAMIEVizJGjBeb8wGjp_9BIButT1l3fdRXdGD6ZBpL0	2025-06-29 00:51:29.841264	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-06-16 12:42:43.49669	2023-06-16 12:42:43.49669	\N	\N	\N	\N	\N	email	\N	\N	2023-06-16 12:42:43.49669	legacy-import
333	janeneibarra92@aol.com	NHZTnlYPMsJUoi	eSZVzTlECA	\N	E6qSnBoB3eawzU3c3Wizo9B0my5yNQqYb0S1EWOwJDU	2025-06-29 00:51:29.842742	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-07-04 21:15:50.568699	2023-07-04 21:15:50.568699	\N	\N	\N	\N	\N	email	\N	\N	2023-07-04 21:15:50.568699	legacy-import
334	joecl9@yahoo.com.hk	Chelsea	O'Hara	\N	Ae44uGaotThZNIgUYjw2X-cyqNy46PYYMaDia4ZVSes	2025-06-29 00:51:29.844179	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-07-10 06:21:31.234457	2023-07-10 06:21:31.234457	\N	\N	\N	\N	\N	email	\N	\N	2023-07-10 06:21:31.234457	legacy-import
335	sal@inventionsinstock.com	Dayne	Lebsack	\N	GgoZXcaQ_u0Er9pQB301RhetI9wJsi9rkBDYO6Eg6PI	2025-06-29 00:51:29.845554	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-07-10 09:01:00.404186	2023-07-10 09:01:00.404186	\N	\N	\N	\N	\N	email	\N	\N	2023-07-10 09:01:00.404186	legacy-import
336	chlorisngai@yahoo.com.hk	Efrain	Homenick	\N	teChfKV9jyu1C9fAvNmA47h9X1ZEsWXd4oLOHMu6wj0	2025-06-29 00:51:29.846913	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-07-10 18:03:31.668601	2023-07-10 18:03:31.668601	\N	\N	\N	\N	\N	email	\N	\N	2023-07-10 18:03:31.668601	legacy-import
337	golfluvor@aol.com	Eldridge	Beahan	\N	ezurZChsBYjFdsE6peW0vJpNVuyKpDReoiI-hHv15AU	2025-06-29 00:51:29.848384	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-07-11 22:19:18.772999	2023-07-11 22:19:18.772999	\N	\N	\N	\N	\N	email	\N	\N	2023-07-11 22:19:18.772999	legacy-import
338	xzy0342102@sina.com	Ward	Okuneva	\N	2rUTdqBZ4IBwYn7Z7-ja3Pelx_XfhycxaNJrWKCvc8s	2025-06-29 00:51:29.849963	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-07-12 04:43:22.132272	2023-07-12 04:43:22.132272	\N	\N	\N	\N	\N	email	\N	\N	2023-07-12 04:43:22.132272	legacy-import
339	maytalolsha@gmail.com	Carlo	Morar	\N	C4NmxH8TIWX59M0mNIEnzPYIbJHNyfQfDO__V1xq26g	2025-06-29 00:51:29.851432	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-07-12 08:03:40.176665	2023-07-12 08:03:40.176665	\N	\N	\N	\N	\N	email	\N	\N	2023-07-12 08:03:40.176665	legacy-import
340	nadella.gs@gmail.com	Virgie	Murazik	\N	YRi2XsAn4vLWRGhpsxgzvFLaIYCA8fSlroYOrO9XKOc	2025-06-29 00:51:29.852885	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-07-12 17:04:48.976286	2023-07-12 17:04:48.976286	\N	\N	\N	\N	\N	email	\N	\N	2023-07-12 17:04:48.976286	legacy-import
341	austin20117@gmail.com	Eveline	Tromp	\N	OXaKy2qHv0Yn6eYL7xcuWXxXYM-q8bmf-TZN63EORok	2025-06-29 00:51:29.854242	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-07-12 19:42:23.05368	2023-07-12 19:42:23.05368	\N	\N	\N	\N	\N	email	\N	\N	2023-07-12 19:42:23.05368	legacy-import
342	jamesmanfredi@gmail.com	Oliver	Rath	\N	wEIkTAehmHmk_Q7Z9KQDlE0h0d9QyWyVhkWWa7RL90U	2025-06-29 00:51:29.863647	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-07-14 16:01:11.274119	2023-07-14 16:01:11.274119	\N	\N	\N	\N	\N	email	\N	\N	2023-07-14 16:01:11.274119	legacy-import
343	abrooks@maywoodfire-il.org	Remington	Ruecker	\N	cmR4HA0C_AYpdkL6bdxcSjdWTxhLT4Wr9XgRZQU1bT0	2025-06-29 00:51:29.865421	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-07-16 15:11:32.672634	2023-07-16 15:11:32.672634	\N	\N	\N	\N	\N	email	\N	\N	2023-07-16 15:11:32.672634	legacy-import
344	billhet@live.com	Tania	Jenkins	\N	KsUEqaP7gB9A1NyyiawXa9DOFwO_fpmNuS04w4sJpJU	2025-06-29 00:51:29.867509	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-07-16 22:01:01.823197	2023-07-16 22:01:01.823197	\N	\N	\N	\N	\N	email	\N	\N	2023-07-16 22:01:01.823197	legacy-import
345	mcpenney@hotmail.com	Jose	Abbott	\N	4FjVW63h1RqRyjerialn1U0L7oWQyZ9hynk6zCvIBJk	2025-06-29 00:51:29.869242	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-07-20 10:26:03.392008	2023-07-20 10:26:03.392008	\N	\N	\N	\N	\N	email	\N	\N	2023-07-20 10:26:03.392008	legacy-import
346	dtapparo@comcast.net	Holden	Beier	\N	XhYxrRUmKB6g3a5qsvYGN1DOIt3a4P1A3ZFuXiIqDTM	2025-06-29 00:51:29.870949	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-07-22 08:13:17.146702	2023-07-22 08:13:17.146702	\N	\N	\N	\N	\N	email	\N	\N	2023-07-22 08:13:17.146702	legacy-import
347	davpau2@cox.net	Adriel	Glover	\N	2MT7t7FNiQSmCLuuNrwXpW5GaSW3HIOS-R_oe5z5maM	2025-06-29 00:51:29.873043	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-07-24 03:48:46.588497	2023-07-24 03:48:46.588497	\N	\N	\N	\N	\N	email	\N	\N	2023-07-24 03:48:46.588497	legacy-import
348	csportsnut@excite.com	Daija	Zboncak	\N	tpiy1BqNsowP3v_xJsstWrJqgZdKrr8K8czGdt31XaA	2025-06-29 00:51:29.874693	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-07-27 07:28:06.149574	2023-07-27 07:28:06.149574	\N	\N	\N	\N	\N	email	\N	\N	2023-07-27 07:28:06.149574	legacy-import
349	kimicopan@yahoo.com.tw	Tatum	Grady	\N	oSt62ShWh349QquOmgu56xy1uadCdCdsKOeuM6M7E2o	2025-06-29 00:51:29.876742	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-07-27 21:36:39.330119	2023-07-27 21:36:39.330119	\N	\N	\N	\N	\N	email	\N	\N	2023-07-27 21:36:39.330119	legacy-import
350	varun@kreoscapital.com	Graham	Denesik	\N	YWmJgEcwbVq6Uua91h5o79VWWkNupAeLEA5I95swVG4	2025-06-29 00:51:29.878352	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-08-01 09:32:04.633826	2023-08-01 09:32:04.633826	\N	\N	\N	\N	\N	email	\N	\N	2023-08-01 09:32:04.633826	legacy-import
351	willafishman351@yahoo.com	quNFUoKQD	bZqDeMxNOTrLHgK	\N	zPQ7yxi0qxnbztDHgl5zO8AFRPqOtkc6c2IYNfT6Ym4	2025-06-29 00:51:29.880019	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-08-02 02:25:09.644364	2023-08-02 02:25:09.644364	\N	\N	\N	\N	\N	email	\N	\N	2023-08-02 02:25:09.644364	legacy-import
352	discountkeyandsupply@gmail.com	Jonathon	Gerhold	\N	AK15g9AMN4YffDQE7ziEbRby_-Yu6qOnzMWi81IK4UA	2025-06-29 00:51:29.882176	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-08-02 05:41:12.202911	2023-08-02 05:41:12.202911	\N	\N	\N	\N	\N	email	\N	\N	2023-08-02 05:41:12.202911	legacy-import
353	cchindiac@gmail.com	Lesly	Hayes	\N	iDkQqyz6hZSZG12HzoWKtzarU4sNghNd4hVG9Pz_D10	2025-06-29 00:51:29.883835	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-08-02 12:57:38.152515	2023-08-02 12:57:38.152515	\N	\N	\N	\N	\N	email	\N	\N	2023-08-02 12:57:38.152515	legacy-import
354	vietcongo41@gmail.com	Jake	Mills	\N	bqvUlzSbla3YwFbBKd6k6M-uUfbW5OshyIhgIGra30E	2025-06-29 00:51:29.885479	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-08-03 11:39:15.605696	2023-08-03 11:39:15.605696	\N	\N	\N	\N	\N	email	\N	\N	2023-08-03 11:39:15.605696	legacy-import
355	mariasmarket@hotmail.com	Bridget	Marvin	\N	hIKO10G7AXf3P_W2gezh4DqeDVnrNVv4ajQJ_MsJ3rM	2025-06-29 00:51:29.887119	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-08-04 00:22:36.80838	2023-08-04 00:22:36.80838	\N	\N	\N	\N	\N	email	\N	\N	2023-08-04 00:22:36.80838	legacy-import
356	sofiane.elahib@gmail.com	Bartholome	Homenick	\N	_AOGUyW_mJ26lo2XFVh5IfeywHGx9ioeofm20MfUOqI	2025-06-29 00:51:29.889344	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-08-05 03:06:03.084951	2023-08-05 03:06:03.084951	\N	\N	\N	\N	\N	email	\N	\N	2023-08-05 03:06:03.084951	legacy-import
357	jennifer.deoliveira@karlstorz.com	Olin	Blanda	\N	KXleFxWbrNl_zFTU1w-uPxd1DXpigRYWbsLLrpKXxa4	2025-06-29 00:51:29.891095	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-08-06 05:21:27.85157	2023-08-06 05:21:27.85157	\N	\N	\N	\N	\N	email	\N	\N	2023-08-06 05:21:27.85157	legacy-import
358	slavass@verizon.net	Elliot	Hills	\N	q2RRUOBQFEpFFsTJ3PZ9cA8f07D6BdJQuWP3qmUEUic	2025-06-29 00:51:29.893191	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-08-06 09:49:25.105748	2023-08-06 09:49:25.105748	\N	\N	\N	\N	\N	email	\N	\N	2023-08-06 09:49:25.105748	legacy-import
359	alka3bi5@hotmail.com	Halle	Mertz	\N	QyA6ReWrkktNIt_LUbfZHBtrDNQEy_bNg0QMqU-7wjI	2025-06-29 00:51:29.894833	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-08-06 12:39:45.022222	2023-08-06 12:39:45.022222	\N	\N	\N	\N	\N	email	\N	\N	2023-08-06 12:39:45.022222	legacy-import
360	sleger1979@yahoo.com	Sedrick	Braun	\N	a8clSegSYFERB1p7cneJ1J6cxhOuGDWqTZCwk4DOyvU	2025-06-29 00:51:29.896506	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-08-09 14:49:45.917018	2023-08-09 14:49:45.917018	\N	\N	\N	\N	\N	email	\N	\N	2023-08-09 14:49:45.917018	legacy-import
361	janelybo@gmail.com	Rickie	Halvorson	\N	Xa-85dJ8AMFPiGdq1qdRF_MXR1w6ZM0JvkU8NU-_1XI	2025-06-29 00:51:29.898574	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-08-10 22:10:49.343911	2023-08-10 22:10:49.343911	\N	\N	\N	\N	\N	email	\N	\N	2023-08-10 22:10:49.343911	legacy-import
362	lainechavis46@aol.com	GUuMmcsE	vCjXVMopGAauB	\N	k88iGaVXsHtitmuGM07QbUxJBgBNAtKAoJj5s1lxqFM	2025-06-29 00:51:29.900299	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-08-15 21:47:48.082182	2023-08-15 21:47:48.082182	\N	\N	\N	\N	\N	email	\N	\N	2023-08-15 21:47:48.082182	legacy-import
363	innocentheart01@gmail.com	Amos	Gislason	\N	31vICzwbpMACRZbKidroSEdwrla7C7N2_-ITq4kgSRA	2025-06-29 00:51:29.9021	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-08-16 04:16:20.555555	2023-08-16 04:16:20.555555	\N	\N	\N	\N	\N	email	\N	\N	2023-08-16 04:16:20.555555	legacy-import
364	rh@littleparmoor.com	Pauline	Auer	\N	zm37RZWlaWZCv0ywSEa-_Cd7lrjJ60q9lHcFxD5rvas	2025-06-29 00:51:29.903664	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-08-16 10:39:31.576892	2023-08-16 10:39:31.576892	\N	\N	\N	\N	\N	email	\N	\N	2023-08-16 10:39:31.576892	legacy-import
365	kimgratiot@isu.edu	Drake	Feest	\N	VuyeJg6exXq4zT9MbBwLNvFChG3bnl6SXmyz4acbL4E	2025-06-29 00:51:29.905579	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-08-18 09:22:44.611707	2023-08-18 09:22:44.611707	\N	\N	\N	\N	\N	email	\N	\N	2023-08-18 09:22:44.611707	legacy-import
366	jadj@datumate.com	Christophe	Hickle	\N	XZJt1Fce7w1pSiznYjqiD7mtZKJU2A9NOBunXMcJvh0	2025-06-29 00:51:29.907137	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-08-19 02:29:03.347149	2023-08-19 02:29:03.347149	\N	\N	\N	\N	\N	email	\N	\N	2023-08-19 02:29:03.347149	legacy-import
367	jaimekoy@gmail.com	Dave	Erdman	\N	aeBVBDSAeIE6v9tF9f5uZ5jK-j6UZm1tCoxfsowLniw	2025-06-29 00:51:29.908686	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-08-21 16:26:41.033805	2023-08-21 16:26:41.033805	\N	\N	\N	\N	\N	email	\N	\N	2023-08-21 16:26:41.033805	legacy-import
368	p102376@yahoo.com.tw	Adeline	Durgan	\N	zpiOiWn5paTijt6Pwa5k9PWvnu-6gB5YONkWoWoxJ5w	2025-06-29 00:51:29.91056	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-08-22 19:36:07.04694	2023-08-22 19:36:07.04694	\N	\N	\N	\N	\N	email	\N	\N	2023-08-22 19:36:07.04694	legacy-import
369	liz.mace@driveplanning.com	Emerson	Rosenbaum	\N	Kz11LnhxO-FDhhTrtlebnIYPO2mQT7iEPfdv7O5U4wQ	2025-06-29 00:51:29.912104	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-08-23 12:06:18.254617	2023-08-23 12:06:18.254617	\N	\N	\N	\N	\N	email	\N	\N	2023-08-23 12:06:18.254617	legacy-import
370	yuderkis@aol.com	Maryjane	Parisian	\N	hHZRRmzAazOaw6DA10lUcDJ_I_14-FdFEPstcQd6XH8	2025-06-29 00:51:29.913547	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-08-26 09:38:48.009204	2023-08-26 09:38:48.009204	\N	\N	\N	\N	\N	email	\N	\N	2023-08-26 09:38:48.009204	legacy-import
371	jonovisions13@hotmail.com	Mayra	Ziemann	\N	2Lo413kZthOUeW6w651SO6b_67redM8Jqc7MvVmIHFo	2025-06-29 00:51:29.914993	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-08-29 17:30:19.777844	2023-08-29 17:30:19.777844	\N	\N	\N	\N	\N	email	\N	\N	2023-08-29 17:30:19.777844	legacy-import
372	fastesthonda@gmail.com	Zola	Bernier	\N	y1laLEI-YzifFlvXcplPs--MuSZobAaITE5nUYEvSw8	2025-06-29 00:51:29.9166	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-08-30 00:20:16.427857	2023-08-30 00:20:16.427857	\N	\N	\N	\N	\N	email	\N	\N	2023-08-30 00:20:16.427857	legacy-import
373	hawss31@gmail.com	Ebba	Heathcote	\N	kUGKwAo1Kj-vfJGoUZv91ufn_9sMQ86Z4Png_HUPsh0	2025-06-29 00:51:29.918093	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-08-31 09:26:10.321812	2023-08-31 09:26:10.321812	\N	\N	\N	\N	\N	email	\N	\N	2023-08-31 09:26:10.321812	legacy-import
374	hlfoote@ns.sympatico.ca	Leonardo	Mante	\N	ollRLPNc2F7OG7wnI9ZPkRzPJJeTYcp-19h5AUYDsk4	2025-06-29 00:51:29.919618	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-09-02 18:19:55.680578	2023-09-02 18:19:55.680578	\N	\N	\N	\N	\N	email	\N	\N	2023-09-02 18:19:55.680578	legacy-import
375	joebrittany965@yahoo.com	Gaylord	Nienow	\N	yrvQGzllFOofL0VO2wVIJu2KN7fFL9v4W7H9cmBKO30	2025-06-29 00:51:29.921059	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-09-06 21:07:39.690266	2023-09-06 21:07:39.690266	\N	\N	\N	\N	\N	email	\N	\N	2023-09-06 21:07:39.690266	legacy-import
408	conleybusuniss@yahoo.com	Paul	Hilll	\N	QDE4MophVlD97jr0DAPA7REJyGBmPzH5B_EcOvq03jQ	2025-06-29 00:51:29.922555	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-09-08 15:54:09.44459	2023-09-08 15:54:09.44459	\N	\N	\N	\N	\N	email	\N	\N	2023-09-08 15:54:09.44459	legacy-import
409	gardenstateking@yahoo.com	Jennifer	Bednar	\N	CiLlHpi5WbqeGwAvsOspKS5PDJYkkMV_AQQUMcmhUeg	2025-06-29 00:51:29.924166	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-09-12 21:53:03.809064	2023-09-12 21:53:03.809064	\N	\N	\N	\N	\N	email	\N	\N	2023-09-12 21:53:03.809064	legacy-import
410	eelini09@gmail.com	Tom	Wyman	\N	_s_DjDyJNJyAOJsOKcEXYyx6CYyL-sAildEC9kggEF8	2025-06-29 00:51:29.92556	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-09-13 14:48:32.91911	2023-09-13 14:48:32.91911	\N	\N	\N	\N	\N	email	\N	\N	2023-09-13 14:48:32.91911	legacy-import
411	z7183030@yahoo.com.tw	Raleigh	Ondricka	\N	kQcsD_b14HX3gy57RteXMOD2cfzZKEHFlTPMZFxzysA	2025-06-29 00:51:29.926932	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-09-15 03:31:29.898026	2023-09-15 03:31:29.898026	\N	\N	\N	\N	\N	email	\N	\N	2023-09-15 03:31:29.898026	legacy-import
412	pateln127@gmail.com	Hallie	Wilkinson	\N	Z_h6DqMjmIO8RtrnEZtJDTrRK8OFmc_OvUJPQgis34I	2025-06-29 00:51:29.928536	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-09-15 13:02:23.919961	2023-09-15 13:02:23.919961	\N	\N	\N	\N	\N	email	\N	\N	2023-09-15 13:02:23.919961	legacy-import
413	mytazzey1@yahoo.com	Frida	Gottlieb	\N	hqJ10upRqH5RmOfHZdPrUv2bR4KPUvG3Fg4G1-dN_MY	2025-06-29 00:51:29.929886	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-09-18 14:06:57.424056	2023-09-18 14:06:57.424056	\N	\N	\N	\N	\N	email	\N	\N	2023-09-18 14:06:57.424056	legacy-import
414	info@lagunadentalandortho.com	Charles	Effertz	\N	Gz4deS26Mq7I6dNicdaBVS875CnZMhwjhfPIZUKBtVM	2025-06-29 00:51:29.931266	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-09-19 20:07:51.032657	2023-09-19 20:07:51.032657	\N	\N	\N	\N	\N	email	\N	\N	2023-09-19 20:07:51.032657	legacy-import
415	sirfak@yandex.com	SiterWek	SiterWek	\N	uFPqXwxCzjSTtOwp6lPCAbO3MAjNxt-bQiHzNBS0iXQ	2025-06-29 00:51:29.932835	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-09-21 14:09:11.48606	2023-09-21 14:09:11.48606	\N	\N	\N	\N	\N	email	\N	\N	2023-09-21 14:09:11.48606	legacy-import
416	jordisfalk@yandex.com	Kennethmof	Kennethmof	\N	KTLz3KeV0wxC_axLJcquRl5fAIq_dyjjzXsT-7NRExU	2025-06-29 00:51:29.934662	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-09-25 18:35:56.610144	2023-09-25 18:35:56.610144	\N	\N	\N	\N	\N	email	\N	\N	2023-09-25 18:35:56.610144	legacy-import
417	familyzoo10@yahoo.com	Elenor	Nienow	\N	mGR8SdJhm7DEJYX07il3emuORyMBCPij55sgDEn_phQ	2025-06-29 00:51:29.93644	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-09-29 02:08:03.248705	2023-09-29 02:08:03.248705	\N	\N	\N	\N	\N	email	\N	\N	2023-09-29 02:08:03.248705	legacy-import
418	aerosolyani@yahoo.co.uk	Laurence	Wisoky	\N	HRwdThyyZZD66F3K9ex4PU_dvMMlRL6WIG4dzZwDa-E	2025-06-29 00:51:29.938112	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-09-29 06:19:54.414692	2023-09-29 06:19:54.414692	\N	\N	\N	\N	\N	email	\N	\N	2023-09-29 06:19:54.414692	legacy-import
419	xxtashaxx89@gmail.com	Dortha	Monahan	\N	GFSn2fmBdwzJLpwZvOFkHf-frwQOK9ZziOx0TwU34Xs	2025-06-29 00:51:29.939808	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-10-01 16:55:51.25113	2023-10-01 16:55:51.25113	\N	\N	\N	\N	\N	email	\N	\N	2023-10-01 16:55:51.25113	legacy-import
420	maxherrlander@gmail.com	Sophia	Hegmann	\N	odt-MalTh9RtJFUMDDja9FT1UBMN1ld44CmsqbGoGF8	2025-06-29 00:51:29.941503	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-10-03 22:56:58.592822	2023-10-03 22:56:58.592822	\N	\N	\N	\N	\N	email	\N	\N	2023-10-03 22:56:58.592822	legacy-import
421	jessenix44@gmail.com	Julio	Bruen	\N	8SXj7i6qn9BBwHyC43deEGx-pfYYyEQZ1m-SIQexTh0	2025-06-29 00:51:29.943196	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-10-04 08:53:34.638816	2023-10-04 08:53:34.638816	\N	\N	\N	\N	\N	email	\N	\N	2023-10-04 08:53:34.638816	legacy-import
422	malinoleg91@mail.ru	skyreverymug	skyreverymug	\N	Q8-jVW-FZLk_-uFkcQl5QyjBTck7ciFWzLzfo5WbOSA	2025-06-29 00:51:29.944886	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-10-22 06:30:12.115258	2023-10-22 06:30:12.115258	\N	\N	\N	\N	\N	email	\N	\N	2023-10-22 06:30:12.115258	legacy-import
423	daphnee806_christiansen1998@alabamahomenetwoks.com	Daron	Hansen	\N	MRhlavOM4p9Njh--Orp5J6J5zu0nBL8VOuhbplPsjJ8	2025-06-29 00:51:29.946561	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-10-23 02:13:17.612396	2023-10-23 02:13:17.612396	\N	\N	\N	\N	\N	email	\N	\N	2023-10-23 02:13:17.612396	legacy-import
424	axbkkq.mwdcmj@chiffon.fun	EpdxmQVeJPyP	EpdxmQVeJPyP	\N	t2eCICWjIEjO8yzkwPlhDUVpoLOMQrrOOpnA5k5bVzA	2025-06-29 00:51:29.948301	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-10-23 16:59:02.16124	2023-10-23 16:59:02.16124	\N	\N	\N	\N	\N	email	\N	\N	2023-10-23 16:59:02.16124	legacy-import
425	timpickens2002@yahoo.com	mpywPXEOYV	QULxcmGhWDq	\N	kxbz1n2dHNklgO8W5oAw3c0d4w9qzrV5uxylAo6iau8	2025-06-29 00:51:29.950019	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-11-12 07:42:54.791049	2023-11-12 07:43:36.294943	\N	\N	\N	\N	\N	email	\N	\N	2023-11-12 07:42:54.791049	legacy-import
426	arturzhgko@outlook.com	JckNYTLIZyiEf	gOBNCqImybcP	\N	8iWIgQsyZ582Sd5NNYpmOnnXPyl2saPaGsVGZZJs2fE	2025-06-29 00:51:29.951747	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-11-19 15:44:02.009036	2023-11-19 15:44:02.009036	\N	\N	\N	\N	\N	email	\N	\N	2023-11-19 15:44:02.009036	legacy-import
427	beupzs.qdqdmwd@borasca.xyz	tlsxcUlnpEpCXQ	tlsxcUlnpEpCXQ	\N	9NZqKNAWznO6XFeJ9HC1MZRJw7JaGPtlnpJiRP7M_Vc	2025-06-29 00:51:29.953429	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-11-19 19:38:14.894722	2023-11-19 19:38:14.894722	\N	\N	\N	\N	\N	email	\N	\N	2023-11-19 19:38:14.894722	legacy-import
460	yubcelerog@outlook.com	OtcqMkUYTBG	kBvedFfIT	\N	FXUneX0ZaGhqgcJYS7g6s48BOFyQ3boRaq7ULQx9t3I	2025-06-29 00:51:29.955151	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-11-28 00:09:10.500558	2023-11-28 00:09:14.95896	\N	\N	\N	\N	\N	email	\N	\N	2023-11-28 00:09:10.500558	legacy-import
461	lewfxh.ddtqwhb@usufruct.bar	iEnfjCnfKls	iEnfjCnfKls	\N	6FbZbtEysQnA-DubdNt-2hXwFCEykWd3JMChLOzDx3s	2025-06-29 00:51:29.957016	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-11-29 18:30:29.055993	2023-11-29 18:30:29.055993	\N	\N	\N	\N	\N	email	\N	\N	2023-11-29 18:30:29.055993	legacy-import
462	timyvh.hqqcmjb@tarboosh.shop	oOqndJaBeWjqbJH	oOqndJaBeWjqbJH	\N	riXvR8JQm7QS5B4kJLgRmLSwddxYkxVIY7E5DFlc2ek	2025-06-29 00:51:29.958783	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-12-01 06:39:56.708057	2023-12-01 06:39:56.708057	\N	\N	\N	\N	\N	email	\N	\N	2023-12-01 06:39:56.708057	legacy-import
463	kennethallen915030333@outlook.com	PImEpYvaGA	cRzSoyCmreBpUiNE	\N	qj4GxU8a9nSUHUAxVLsSvr40I56DQhZmLi2HzX5YdYE	2025-06-29 00:51:29.960526	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-12-05 06:30:36.978299	2023-12-05 06:30:46.45951	\N	\N	\N	\N	\N	email	\N	\N	2023-12-05 06:30:36.978299	legacy-import
464	wtijwy.hqpptbq@gemination.hair	WTIjwY.hqpptbq	WTIjwY.hqpptbq	\N	zzrqS_waM13jaW-6qPnuHmrrSBDfu1ki4GZ35ayrMHQ	2025-06-29 00:51:29.962339	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-12-05 20:07:42.852145	2023-12-05 20:07:42.852145	\N	\N	\N	\N	\N	email	\N	\N	2023-12-05 20:07:42.852145	legacy-import
465	vladimirkn54n@outlook.com	aWtkCfbd	XAlxbQiWS	\N	iBXnXjf2JXvG63IsH0Im0VP4fK7JmxmLmMbO8zrQ-0I	2025-06-29 00:51:29.964091	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-12-12 19:47:47.950854	2023-12-12 19:47:47.950854	\N	\N	\N	\N	\N	email	\N	\N	2023-12-12 19:47:47.950854	legacy-import
466	laplumetammera76@hotmail.com	SxvbRnJfXCl	ZjvFGCqWo	\N	qsH2eca_LrL_Yciy9tbqy6dhJudCMUg7kGFsU5YHY0s	2025-06-29 00:51:29.965821	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-12-25 08:03:48.390257	2023-12-25 08:03:53.439449	\N	\N	\N	\N	\N	email	\N	\N	2023-12-25 08:03:48.390257	legacy-import
467	zltztd.dctttcw@purline.top	zLTzTD.dctttcw	zLTzTD.dctttcw	\N	-fugnu-QhvPVwxDRJEL9oFTV2X5TX5TZ_qemRu6zXRA	2025-06-29 00:51:29.967615	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2023-12-29 06:35:51.766642	2023-12-29 06:35:51.766642	\N	\N	\N	\N	\N	email	\N	\N	2023-12-29 06:35:51.766642	legacy-import
468	rnewrinfise1974@outlook.com	OWnRDExporuqSs	UxdaWCNRHvwFEXQh	\N	PWSxbVKipVsOeyIV06j8wmFXTLMWFyR-yb1N6kGo664	2025-06-29 00:51:29.96933	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-01-23 16:51:49.038042	2024-01-23 16:51:59.464077	\N	\N	\N	\N	\N	email	\N	\N	2024-01-23 16:51:49.038042	legacy-import
469	vjurnf.qtqbdmwm@anaphora.team	vJurnf.qtqbdmwm	vJurnf.qtqbdmwm	\N	4dUqUCYMhHLYF5gJeY4OedlZzto-WcD7JHSuhpRRpdk	2025-06-29 00:51:29.971072	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-01-27 21:35:46.864826	2024-01-27 21:35:46.864826	\N	\N	\N	\N	\N	email	\N	\N	2024-01-27 21:35:46.864826	legacy-import
470	antonettegilliland902@aol.com	NExGDsleX	ZPxFhLjJ	\N	1XpouguZGVp3FIZOyLV2UmRk33VwI4ozdGB5351mhrs	2025-06-29 00:51:29.972659	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-02-02 04:56:09.478796	2024-02-02 04:56:29.096089	\N	\N	\N	\N	\N	email	\N	\N	2024-02-02 04:56:09.478796	legacy-import
503	vxnekc.dhtmwwp@silesia.life	vXnEKc.dhtmwwp	vXnEKc.dhtmwwp	\N	8GKdJNvK961q-o0cU5fgYRt6QW7mTno4Uw_lCmtU1wg	2025-06-29 00:51:29.974239	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-02-12 08:29:13.309023	2024-02-12 08:29:13.309023	\N	\N	\N	\N	\N	email	\N	\N	2024-02-12 08:29:13.309023	legacy-import
504	fnjcnc.htpjbtq@sandcress.xyz	FNjcnC.htpjbtq	FNjcnC.htpjbtq	\N	f8YcLVPLkNAaqdIE1iskOpLX47_wsLJtbM7GVGLOVLQ	2025-06-29 00:51:29.975813	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-02-13 12:45:13.929932	2024-02-13 12:45:13.929932	\N	\N	\N	\N	\N	email	\N	\N	2024-02-13 12:45:13.929932	legacy-import
505	vdhhjk.qhcwpjwt@spectrail.world	VdhHjK.qhcwpjwt	VdhHjK.qhcwpjwt	\N	2YtNWIG6cZ44ZjMbghYe3yyX4krRUZsNtTl98NUUV00	2025-06-29 00:51:29.97738	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-02-27 05:10:25.54463	2024-02-27 05:10:25.54463	\N	\N	\N	\N	\N	email	\N	\N	2024-02-27 05:10:25.54463	legacy-import
506	elbkri.dbqjhbw@carnana.art	ELbkRi.dbqjhbw	ELbkRi.dbqjhbw	\N	fbMfq_tISc096pWddI8nGiOF4YlXyXNE8lNovFdxh5Y	2025-06-29 00:51:29.978995	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-03-08 07:16:04.988381	2024-03-08 07:16:04.988381	\N	\N	\N	\N	\N	email	\N	\N	2024-03-08 07:16:04.988381	legacy-import
507	qcbwbdctt.j@monochord.xyz	qcbwbdctt.j	qcbwbdctt.j	\N	_bvRDe75IGwLWX9YA2nxvQaQWxZ_cQTArgrCiL2XmHw	2025-06-29 00:51:29.980649	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-03-15 16:37:20.453277	2024-03-15 16:37:20.453277	\N	\N	\N	\N	\N	email	\N	\N	2024-03-15 16:37:20.453277	legacy-import
508	dchmhhbmq.j@monochord.xyz	dchmhhbmq.j	dchmhhbmq.j	\N	YrtyAHAP5Az1GxQIf_BQEVb5YRsOwFhQ-EVFYBKn8iQ	2025-06-29 00:51:29.982247	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-03-18 15:42:21.236087	2024-03-18 15:42:21.236087	\N	\N	\N	\N	\N	email	\N	\N	2024-03-18 15:42:21.236087	legacy-import
509	pbmmmjbdm.j@monochord.xyz	pbmmmjbdm.j	pbmmmjbdm.j	\N	DcNRPAtc_u-RhSgaqn_3-2YwMWhNSVnl9bq7ONStoq0	2025-06-29 00:51:29.995146	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-03-21 17:27:42.325978	2024-03-21 17:27:42.325978	\N	\N	\N	\N	\N	email	\N	\N	2024-03-21 17:27:42.325978	legacy-import
510	qjbpjbwbjp.j@monochord.xyz	qjbpjbwbjp.j	qjbpjbwbjp.j	\N	cH5xt24qKnwV3ZiJ3mhVHlpL43qymXQDQZdOXo_UmjE	2025-06-29 00:51:29.997314	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-03-24 09:33:39.195067	2024-03-24 09:33:39.195067	\N	\N	\N	\N	\N	email	\N	\N	2024-03-24 09:33:39.195067	legacy-import
511	jillian_hanson3766@yahoo.com	hvSXrsWcpgAntKD	ZmQavCSIkB	\N	OIARx7JNu-X7rXfJXFCqb2GxykEAXsPb3IHLVHrB72w	2025-06-29 00:51:29.999092	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-03-27 01:55:25.04341	2024-03-27 01:55:43.631106	\N	\N	\N	\N	\N	email	\N	\N	2024-03-27 01:55:25.04341	legacy-import
512	qtbdqhcdcb.j@monochord.xyz	qtbdqhcdcb.j	qtbdqhcdcb.j	\N	XGU9njHgS-vnX6FHMeYVZo7_8a8aC763Lo2Ur9a-4x0	2025-06-29 00:51:30.001004	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-03-27 13:55:55.488027	2024-03-27 13:55:55.488027	\N	\N	\N	\N	\N	email	\N	\N	2024-03-27 13:55:55.488027	legacy-import
513	garrett_cassandra2798@yahoo.com	LXYZuTSjHKQ	WdFoZEvNxV	\N	hNjcF1dqLjjhKJP6GQCbEpAY7Glf85dKLBurpgOZXts	2025-06-29 00:51:30.002845	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-04-02 12:04:59.800862	2024-04-02 12:04:59.800862	\N	\N	\N	\N	\N	email	\N	\N	2024-04-02 12:04:59.800862	legacy-import
514	valeriekelly44783@outlook.com	wgovAFMN	DBCwAfUsL	\N	sObFXaPGl3KxUhhpY5KpMXfwvXxHR1Ph7SdizpN5hHQ	2025-06-29 00:51:30.005469	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-04-07 02:05:54.657645	2024-04-07 02:05:54.657645	\N	\N	\N	\N	\N	email	\N	\N	2024-04-07 02:05:54.657645	legacy-import
515	qcbqqmddht.j@rightbliss.beauty	qcbqqmddht.j	qcbqqmddht.j	\N	EYHjcQyCIWOk7WLtpzYaqE2YW5Qu6-kbjCEwNNoR9Mo	2025-06-29 00:51:30.007521	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-04-07 02:13:22.479064	2024-04-07 02:13:22.479064	\N	\N	\N	\N	\N	email	\N	\N	2024-04-07 02:13:22.479064	legacy-import
516	donnang_graggsi@outlook.com	IkQUbdEOpsFMwc	fdtxGzbMJiScE	\N	yBDeCoP15QBf55CsIq81sNvgsxrM_3D_tEu2zKAJ0W8	2025-06-29 00:51:30.010485	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-04-11 00:20:37.332641	2024-04-11 00:20:55.139151	\N	\N	\N	\N	\N	email	\N	\N	2024-04-11 00:20:37.332641	legacy-import
517	sheila.nelson1999@yahoo.com	tPKnLMeQF	fcmjrVRFKksZBq	\N	bxMLywDPOQRGcMUvrrdODid4orFrUeaO6iCVA8lSlsQ	2025-06-29 00:51:30.012776	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-04-13 13:31:55.788893	2024-04-13 13:31:55.788893	\N	\N	\N	\N	\N	email	\N	\N	2024-04-13 13:31:55.788893	legacy-import
518	chris.suek3167@yahoo.com	fnEOqPwHCepkZLR	unvRcIzhfiL	\N	oV-NRq7sbMHZChoOscEQ0biyH0FKWUh42ESUS5f5ulU	2025-06-29 00:51:30.014872	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-04-19 07:09:44.868887	2024-04-19 07:09:44.868887	\N	\N	\N	\N	\N	email	\N	\N	2024-04-19 07:09:44.868887	legacy-import
519	dana_boazotlo@outlook.com	vdSmEWIq	MScbnDaCAmdk	\N	KS8SAmG2mjVTNivtnlyl7JP05E4wWg5EY27gaGHtDlc	2025-06-29 00:51:30.016632	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-04-25 09:21:21.380133	2024-04-25 09:21:36.503248	\N	\N	\N	\N	\N	email	\N	\N	2024-04-25 09:21:21.380133	legacy-import
552	claudine_hardy9156@yahoo.com	eFtCjPsqRKAOzDS	SxmoqdkYBgOHGEX	\N	Zz2GV-jRMYvVhmEqSiUgN9WTQa1Z1prq_3TJaoTHe2s	2025-06-29 00:51:30.019171	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-05-08 10:15:49.38948	2024-05-08 10:15:49.38948	\N	\N	\N	\N	\N	email	\N	\N	2024-05-08 10:15:49.38948	legacy-import
553	vadimnea66+656x@list.ru	Nfejdekofhofjwdoe jirekdwjfreohogjkerwkrj rekwlrkfekjgoperrkfoek ojeopkfwkferjgiejfwk okfepjfgrihgoiejfklegjroi jeiokferfekfrjgiorjofeko jeoighirhgioejfoekforjgijriogjeo foefojeigjrigklej jkrjfkrejgkrhglrlrk theartexch.com	Nfejdekofhofjwdoe jirekdwjfreohogjkerwkrj rekwlrkfekjgoperrkfoek ojeopkfwkferjgiejfwk okfepjfgrihgoiejfklegjroi jeiokferfekfrjgiorjofeko jeoighirhgioejfoekforjgijriogjeo foefojeigjrigklej jkrjfkrejgkrhglrlrk theartexch.com	\N	YghIbCs58KkkzGxOJZ58Wo3BLTwSvdgcwN16XFoQoco	2025-06-29 00:51:30.021261	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-05-09 14:13:11.596239	2024-05-09 14:13:11.596239	\N	\N	\N	\N	\N	email	\N	\N	2024-05-09 14:13:11.596239	legacy-import
554	nelicesafoine@outlook.com	knaItcRZpvAPlex	zaAtdUYBSNh	\N	92beovhV0wLSsGloe5oTrnrsQyXMvNSzHJDRDsbNoO0	2025-06-29 00:51:30.025192	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-05-11 16:53:23.486582	2024-05-11 16:54:05.721283	\N	\N	\N	\N	\N	email	\N	\N	2024-05-11 16:53:23.486582	legacy-import
555	dana50holcombrty@outlook.com	uKhPVkGljgIXfFW	MHkcfPWUjO	\N	kZXpmgJjtIqLIsquW9DOcN3qKv362xPIb_A86Re-x8E	2025-06-29 00:51:30.027145	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-05-18 19:45:05.482839	2024-05-18 19:45:05.482839	\N	\N	\N	\N	\N	email	\N	\N	2024-05-18 19:45:05.482839	legacy-import
556	charlotte.jones5343@yahoo.com	pOJkVSwFKt	GHdgEkqcfYVPI	\N	7RZGaNTccda9XdEjKQHKTfFE1Oq_nLlpFZ7Y2M06X9E	2025-06-29 00:51:30.028914	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-05-22 06:01:29.117455	2024-05-22 06:01:29.117455	\N	\N	\N	\N	\N	email	\N	\N	2024-05-22 06:01:29.117455	legacy-import
557	evans.ryan1989@aol.com	CvWeYLjH	KzPEbHNfCspwyUY	\N	3hwsIoogkoRnxY4M-YTlyc0wrxyJ47t3QsL46_s0EEU	2025-06-29 00:51:30.030861	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-05-25 22:49:50.236337	2024-05-25 22:50:07.412666	\N	\N	\N	\N	\N	email	\N	\N	2024-05-25 22:49:50.236337	legacy-import
558	lhobwl2004@gmail.com	KDekcQruO	ENpDIOXzla	\N	BTDUhwyEWCV8IMXXrf52U9mEn5k1PYYiq37orCLEoL0	2025-06-29 00:51:30.032545	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-05-29 15:38:59.429013	2024-05-29 15:39:16.387579	\N	\N	\N	\N	\N	email	\N	\N	2024-05-29 15:38:59.429013	legacy-import
559	qeqmulateb@hotmail.com	bOshYPLqyzSvilIV	bmngMefjIUJXixR	\N	tpMVMo-AcHj-W65YjwPxr-VKq7RrJbMjuGAy8rI5JBY	2025-06-29 00:51:30.034247	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-06-03 11:00:40.908069	2024-06-03 11:00:40.908069	\N	\N	\N	\N	\N	email	\N	\N	2024-06-03 11:00:40.908069	legacy-import
560	brian_washburn1996@yahoo.com	WiregoqEzlh	tcbfFXBVdjnlhS	\N	_xq5DkeX5IdtvgYkyE5OPWNa2NR8qLUwFzyXAff-rO4	2025-06-29 00:51:30.03642	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-06-07 03:08:11.259355	2024-06-07 03:08:11.259355	\N	\N	\N	\N	\N	email	\N	\N	2024-06-07 03:08:11.259355	legacy-import
561	johnson7068oiz@outlook.com	isCXlWnh	dhQPvjqTLcuyitY	\N	OvvDp-g2WuypxtIHYMdVovl1c8vYXYSfMQHMZCMWBnE	2025-06-29 00:51:30.038381	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-06-13 12:36:11.170302	2024-06-13 12:36:11.170302	\N	\N	\N	\N	\N	email	\N	\N	2024-06-13 12:36:11.170302	legacy-import
562	donnellhm_tancrediku@outlook.com	KeAhySTCdiUPvIWM	feCEyiQUzxJ	\N	ycOv5wmKUGhTMPaA6XHQyZLhK69HY2B5GCVg_bt83DI	2025-06-29 00:51:30.040319	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-06-20 00:27:53.6547	2024-06-20 00:27:53.6547	\N	\N	\N	\N	\N	email	\N	\N	2024-06-20 00:27:53.6547	legacy-import
563	mollywatson1128@yahoo.com	SWOtCcxma	rDnsPhwieYUMOJld	\N	YMflynlEVJoBs204OwB8Ilpg3Bb9ZdYDrMCUwmeL_OQ	2025-06-29 00:51:30.042308	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-06-27 06:33:58.98287	2024-06-27 06:34:11.327337	\N	\N	\N	\N	\N	email	\N	\N	2024-06-27 06:33:58.98287	legacy-import
564	floretm586@gmail.com	LAPUghyJfnrG	medEaVNW	\N	I5FYxLWsG8zhMjdvWaiucbRuqoXDRF3pG6n_Jmqw_zA	2025-06-29 00:51:30.044306	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-07-16 03:02:26.765029	2024-07-16 03:02:26.765029	\N	\N	\N	\N	\N	email	\N	\N	2024-07-16 03:02:26.765029	legacy-import
565	glatzel.dwight7256@yahoo.com	jlnDQJeSqHxLsm	tHsVlyXMkBafNu	\N	EMA5cKX35wM9bXPabqqwWLziznmQUPzcW0faC6DAC8w	2025-06-29 00:51:30.046164	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-07-21 14:52:51.580591	2024-07-21 14:53:01.397668	\N	\N	\N	\N	\N	email	\N	\N	2024-07-21 14:52:51.580591	legacy-import
566	mellonwhitnd41@gmail.com	bZygwsBFXPm	lgknFQMXhCvs	\N	Scx9w7gtrfGRbf3A5Ih1OFGUe-WmMjkOzGxstsGHXPY	2025-06-29 00:51:30.048062	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-07-24 07:35:00.552015	2024-07-24 07:35:00.552015	\N	\N	\N	\N	\N	email	\N	\N	2024-07-24 07:35:00.552015	legacy-import
567	brianwisell1982@yahoo.com	FxaULXADQvGC	jbwnhutYy	\N	ore8Zm_Z-EWkwFgpVvQ7Rp2DnQjAMUmnrFO2Ea08DDI	2025-06-29 00:51:30.049909	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-07-26 19:08:23.448518	2024-07-26 19:08:23.448518	\N	\N	\N	\N	\N	email	\N	\N	2024-07-26 19:08:23.448518	legacy-import
568	thomaslykiln1578@gmail.com	yYPJckDoN	QUApIMBSRwTPJzjN	\N	pAAq1pDtyERKV_nb4BVp2FBMePcmesip938Kbh3i7RE	2025-06-29 00:51:30.051747	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-08-01 00:52:28.750493	2024-08-01 00:52:28.750493	\N	\N	\N	\N	\N	email	\N	\N	2024-08-01 00:52:28.750493	legacy-import
569	jimmy34hensleymnt@outlook.com	UTMPlNaAG	jPYtXdMQZxf	\N	btacVXr9H-Awsdr6VPDk04yj4gj90w6mhZ21YAr7qL0	2025-06-29 00:51:30.053722	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-08-03 20:01:18.670272	2024-08-03 20:01:18.670272	\N	\N	\N	\N	\N	email	\N	\N	2024-08-03 20:01:18.670272	legacy-import
570	larissah8493@gmail.com	STmXzeNlq	aRNmcplL	\N	jO1ZpSN7HIc9q0uUx_kDgUNNftbLtnzkniVujys61C4	2025-06-29 00:51:30.055652	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-08-07 03:34:47.583978	2024-08-07 03:34:47.583978	\N	\N	\N	\N	\N	email	\N	\N	2024-08-07 03:34:47.583978	legacy-import
571	matthew11wright4st@outlook.com	RVzAeqSkmPcG	bPSMhXtjvyOdT	\N	MweBekwaFYH18bTH-nAJVAkODVOe87sVRvZZMRlgkuI	2025-06-29 00:51:30.057503	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-08-10 05:49:38.230074	2024-08-10 05:49:57.879373	\N	\N	\N	\N	\N	email	\N	\N	2024-08-10 05:49:38.230074	legacy-import
572	berryalan9973@yahoo.com	iwAMVLJZqmWGhQzE	JKGntuxocNShYjeg	\N	FuawJjI27kM-udYbTMCz6rFRzUl5eCHcHb1Bmy6Ef0k	2025-06-29 00:51:30.059374	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-08-16 14:33:06.536258	2024-08-16 14:33:06.536258	\N	\N	\N	\N	\N	email	\N	\N	2024-08-16 14:33:06.536258	legacy-import
573	martha_adkinsv0sq@outlook.com	kmDKfLjczEX	keEhBuoPSvGHK	\N	yQRGv9VUpijuc9quO5fz6hwDIT_EOlIIUt-j6zoZt4k	2025-06-29 00:51:30.061272	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-08-24 17:51:13.084242	2024-08-24 17:51:27.7888	\N	\N	\N	\N	\N	email	\N	\N	2024-08-24 17:51:13.084242	legacy-import
574	barbara42rehlgah@outlook.com	YohclRLbsjkdt	njgkwcXpVm	\N	lm20aEFTaVcRlnpM-MEHAGaCcjNLmNJ_xMd3sDfN3WE	2025-06-29 00:51:30.063307	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-09-05 09:35:12.68084	2024-09-05 09:35:26.46001	\N	\N	\N	\N	\N	email	\N	\N	2024-09-05 09:35:12.68084	legacy-import
575	leosmythx5i@outlook.com	GjvlYrKDyPAi	NDuRfMQLSoEO	\N	6454WzYVJ_b7tHqd2EqxXzD1cOCRO6ojvrTiURe4mJA	2025-06-29 00:51:30.065233	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-09-08 14:42:34.345886	2024-09-08 14:42:34.345886	\N	\N	\N	\N	\N	email	\N	\N	2024-09-08 14:42:34.345886	legacy-import
576	sebastyanayi854@gmail.com	qOBoTQAXSM	WczHvCbXZE	\N	SUQVpL1k8U3PWcbzIuaUT3S1IcxHZiPTu3-DVraqwDU	2025-06-29 00:51:30.067242	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-09-08 14:57:40.176049	2024-09-08 14:57:40.176049	\N	\N	\N	\N	\N	email	\N	\N	2024-09-08 14:57:40.176049	legacy-import
577	elizabeth24krikorianssv@outlook.com	vtWLeZKo	bgvRUbkkjVXpVu	\N	YVnBW2vRREPweVO43ITs8Xw1aHEs8z9cDPMRUlvelEY	2025-06-29 00:51:30.069336	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-09-12 00:05:32.001682	2024-09-12 00:05:32.001682	\N	\N	\N	\N	\N	email	\N	\N	2024-09-12 00:05:32.001682	legacy-import
578	norrisnettis1996@gmail.com	MgQVbLtDARHwxsd	qKuFrEVDXtpdz	\N	AE-ffVoyaQp3X1C05oWtFG8vJjALmfjl22nu_QSF2ZE	2025-06-29 00:51:30.071363	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-09-14 10:20:11.851899	2024-09-14 10:20:11.851899	\N	\N	\N	\N	\N	email	\N	\N	2024-09-14 10:20:11.851899	legacy-import
579	bjsemzslbuj@dont-reply.me	Augusta	Reuman	\N	XHnErviRSBm8ncr1FZjjF4iz41JS9yJvGqI_fCj8Eug	2025-06-29 00:51:30.073296	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-09-15 17:55:25.091684	2024-09-15 17:55:25.091684	\N	\N	\N	\N	\N	email	\N	\N	2024-09-15 17:55:25.091684	legacy-import
580	lorettauu_reyeswq@outlook.com	taPZvYdEiSwNIb	DIdUqdvl	\N	BZbxPDh48esEUDFNvGKme2Sy3fw9ifF7Ekh-ct9BdHc	2025-06-29 00:51:30.075595	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-09-25 11:49:30.588362	2024-09-25 11:49:30.588362	\N	\N	\N	\N	\N	email	\N	\N	2024-09-25 11:49:30.588362	legacy-import
613	kim_arini@yahoo.com	FtYESScRBjYAPHh	tRXgigzU	\N	7QGNHYVF1K3TosxZjsS0lQLsrXauCYx0Yxk6fHj5st8	2025-06-29 00:51:30.077647	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-09-28 05:59:46.956294	2024-09-28 05:59:46.956294	\N	\N	\N	\N	\N	email	\N	\N	2024-09-28 05:59:46.956294	legacy-import
614	iiisjrsbmuj@dont-reply.me	Jennipher	Simbi	\N	wkMFA7OROserrFi0R4S4uZezDnc9BM39FnrEDCD87JI	2025-06-29 00:51:30.079633	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-10-14 15:37:44.623118	2024-10-14 15:37:44.623118	\N	\N	\N	\N	\N	email	\N	\N	2024-10-14 15:37:44.623118	legacy-import
647	aholio1894@gmail.com	brIRqsrlVJm	wyeFlxbC	\N	aulypWyAHDbZ9-njiXq9T2J7wSsiUjlNR5zGI7E_wLI	2025-06-29 00:51:30.081576	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-10-18 04:39:25.222216	2024-10-18 04:39:25.222216	\N	\N	\N	\N	\N	email	\N	\N	2024-10-18 04:39:25.222216	legacy-import
648	pazapz@mailbox.in.ua	* * * Unlock Free Spins Today: https://wessometals.com/uploaded/rnyk4u.php?zo8cey * * * hs=8f26f3b6baf9e61878c9711069f43247*	7nl5jl	\N	Sd4a5X6AQtNq9kIyO-bdAh_wSai0isOI529SiIbYspo	2025-06-29 00:51:30.083573	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-10-19 11:14:11.161971	2024-10-19 11:14:11.161971	\N	\N	\N	\N	\N	email	\N	\N	2024-10-19 11:14:11.161971	legacy-import
649	zjeizzsimauj@dont-reply.me	Leeor	Drover	\N	pkAxXwpIzc-iLHkitMbh3ZszQ1E8zjKQwLfKNuzu8rQ	2025-06-29 00:51:30.085575	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-10-23 09:10:48.690318	2024-10-23 09:10:48.690318	\N	\N	\N	\N	\N	email	\N	\N	2024-10-23 09:10:48.690318	legacy-import
650	kloganem19@gmail.com	wWCDIbsiyCamn	TTRDOiEvDsscC	\N	6_W0vbSxNKzXjyJV_jb8t4wjvEbQxD2_Ugp8EXv9MEc	2025-06-29 00:51:30.08734	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-10-25 21:36:59.655837	2024-10-25 21:36:59.655837	\N	\N	\N	\N	\N	email	\N	\N	2024-10-25 21:36:59.655837	legacy-import
651	zblaabjiazuj@dont-reply.me	Arno	Queiros	\N	rDhOYYiP26z7gasKeI_xDry7FIx80Mo0moTXtnXgT-Y	2025-06-29 00:51:30.089136	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-11-02 20:08:38.169184	2024-11-02 20:08:38.169184	\N	\N	\N	\N	\N	email	\N	\N	2024-11-02 20:08:38.169184	legacy-import
652	goitinh.1980@yahoo.com	ODebnueg	fNANynbkbig	\N	T0kkavnDt4POdzk7Re7baiooh4QqWD5x-eV6d8T2KWc	2025-06-29 00:51:30.091034	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-11-06 00:10:02.015305	2024-11-06 00:10:02.015305	\N	\N	\N	\N	\N	email	\N	\N	2024-11-06 00:10:02.015305	legacy-import
653	v2enued8hsvy@yahoo.com	EFXboRBgQJ	TttQbmOm	\N	7Ch-43eEdGoym9B2WUUShpZNe2IpPhz6oy-C6YAG3cc	2025-06-29 00:51:30.092926	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-11-08 23:44:27.72725	2024-11-08 23:44:27.72725	\N	\N	\N	\N	\N	email	\N	\N	2024-11-08 23:44:27.72725	legacy-import
654	flecherkc2482@gmail.com	aqzzDOer	KvgDjpOdZhi	\N	buTgd1brEAzXMGsX7teWC805mzr0U8YRCvyCk6qXoZk	2025-06-29 00:51:30.094768	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-11-09 17:51:27.828502	2024-11-09 17:51:27.828502	\N	\N	\N	\N	\N	email	\N	\N	2024-11-09 17:51:27.828502	legacy-import
655	allissariosm1981@gmail.com	xExCWBJKjIUTB	PxQdzaRssNepw	\N	en5ONFNKIXDzNLqHyjcjU5tJSpE4uly5Fk53lWgu-5w	2025-06-29 00:51:30.096698	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-11-10 10:51:08.782454	2024-11-10 10:51:08.782454	\N	\N	\N	\N	\N	email	\N	\N	2024-11-10 10:51:08.782454	legacy-import
656	zsrrmrbijsuj@dont-reply.me	Abigaelle	Fernandez Labriola	\N	IgbtyN5UKQ-5wcWXTBe87CspZN6u_dzb_r-wIFO9G9k	2025-06-29 00:51:30.098389	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-11-11 13:19:56.54912	2024-11-11 13:19:56.54912	\N	\N	\N	\N	\N	email	\N	\N	2024-11-11 13:19:56.54912	legacy-import
657	hojekckimey@yahoo.com	wcuKFsDJKgJHPb	OBMCzBmEEk	\N	9r9hgZNZoZhjlXn0QsyzcglDaxXQSW0pC03dBpi8owI	2025-06-29 00:51:30.100372	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-11-11 23:26:57.183491	2024-11-11 23:26:57.183491	\N	\N	\N	\N	\N	email	\N	\N	2024-11-11 23:26:57.183491	legacy-import
658	kaliakjazynk@yahoo.com	vRPVSyxbYs	jZtjSsqiPFBJj	\N	1BxYoybm_fGxWUEZ8Mx3PM4F6mx2NleefZ3v5SG_Qjs	2025-06-29 00:51:30.102343	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-11-13 18:54:59.730116	2024-11-13 18:54:59.730116	\N	\N	\N	\N	\N	email	\N	\N	2024-11-13 18:54:59.730116	legacy-import
659	siseliyacochranp@gmail.com	CpRRoiSzqYa	TShhLcVltkvVQ	\N	VYNwGVl3mIk4bIJIeLwsjjnwgM1V_Bm3GKLxOYJa8nc	2025-06-29 00:51:30.104179	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-11-14 15:42:11.382142	2024-11-14 15:42:11.382142	\N	\N	\N	\N	\N	email	\N	\N	2024-11-14 15:42:11.382142	legacy-import
660	rxknufppswkol@yahoo.com	xtcokzffjnN	OsvzodCuhq	\N	zQ5La4U-sXXFUkOIo5WNT2wuxdmUG5PUnqI4mHbRKSA	2025-06-29 00:51:30.106188	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-11-15 11:49:35.675012	2024-11-15 11:49:35.675012	\N	\N	\N	\N	\N	email	\N	\N	2024-11-15 11:49:35.675012	legacy-import
661	dario.1955@yahoo.com	foCHyDdvxWePXm	ZmbFMWjYlsbl	\N	09uo2FWFAF8UrMe-ccQkz_lso905UYUJ1UpKcB3koxU	2025-06-29 00:51:30.108086	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-11-16 09:21:51.877719	2024-11-16 09:21:51.877719	\N	\N	\N	\N	\N	email	\N	\N	2024-11-16 09:21:51.877719	legacy-import
662	paola.bucciarelli@yahoo.com	PQkMZlLNjK	YUZekQOexRUmWgz	\N	7P1IONHu6dQQ3fsCl9imWwqBka3aIxuEXk1GVy2IsPQ	2025-06-29 00:51:30.11007	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-11-17 17:03:35.874443	2024-11-17 17:03:35.874443	\N	\N	\N	\N	\N	email	\N	\N	2024-11-17 17:03:35.874443	legacy-import
663	richaredynvl913@gmail.com	zuGvxIRTv	yyXbsEUaNJmicq	\N	Jr2stu4rLpqSmfkOQournuPzzwUunWx-Npoh56LiZGE	2025-06-29 00:51:30.112033	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-11-21 20:31:49.204472	2024-11-21 20:31:49.204472	\N	\N	\N	\N	\N	email	\N	\N	2024-11-21 20:31:49.204472	legacy-import
664	oskuimiskovch@yahoo.com	bwuMAYwymQrQwpk	mmBCJBXsht	\N	H6whI8z_GALvHQOq1qeMWdGAgips_zJ0TRGxiZHpEEw	2025-06-29 00:51:30.11379	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-11-23 22:23:06.763937	2024-11-23 22:23:06.763937	\N	\N	\N	\N	\N	email	\N	\N	2024-11-23 22:23:06.763937	legacy-import
665	blmxpefufae@yahoo.com	nYSPYvLbrs	voqSmmmEqa	\N	o2dr-ohjVWVl9LmkIq0rXE0p0SzIIODedklgM44DV2s	2025-06-29 00:51:30.115504	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-11-24 18:02:20.550372	2024-11-24 18:02:20.550372	\N	\N	\N	\N	\N	email	\N	\N	2024-11-24 18:02:20.550372	legacy-import
666	yasen.krasen.13+74517@mail.ru	Nfejdekofhofjwdoe jirekdwjfreohogjkerwkrj rekwlrkfekjgoperrkfoek ojeopkfwkferjgiejfwk okfepjfgrihgoiejfklegjroi jeiokferfekfrjgiorjofeko jeoighirhgioejfoekforjgijriogjeo foefojeigjrigklej jkrjfkrejgkrhglrlrk theartexch.com	Nfejdekofhofjwdoe jirekdwjfreohogjkerwkrj rekwlrkfekjgoperrkfoek ojeopkfwkferjgiejfwk okfepjfgrihgoiejfklegjroi jeiokferfekfrjgiorjofeko jeoighirhgioejfoekforjgijriogjeo foefojeigjrigklej jkrjfkrejgkrhglrlrk theartexch.com	\N	ldqlbtqdppI4q-nVOZBxgWzDVNPnZqpIVy4DNO9EFDo	2025-06-29 00:51:30.117475	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-11-24 23:14:34.525502	2024-11-24 23:14:34.525502	\N	\N	\N	\N	\N	email	\N	\N	2024-11-24 23:14:34.525502	legacy-import
667	nw9uhs4ai@yahoo.com	FBNTmycXA	oRNbplnz	\N	2nV9DJGB5ay_9fCx5V3bZIjR-xTocYeR1YKh12KCFHU	2025-06-29 00:51:30.119449	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-11-25 15:13:17.069033	2024-11-25 15:13:17.069033	\N	\N	\N	\N	\N	email	\N	\N	2024-11-25 15:13:17.069033	legacy-import
668	santoslorisd6544@gmail.com	XpsLCKUsIxosW	zfcAkYGqWLKK	\N	HYOE5DKe_w32VcEVg8c_IGNac23RZo-TOlr3VbMCTcc	2025-06-29 00:51:30.121432	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-11-26 13:50:13.768414	2024-11-26 13:50:13.768414	\N	\N	\N	\N	\N	email	\N	\N	2024-11-26 13:50:13.768414	legacy-import
669	ebemjaerbeuj@dont-reply.me	Keland	Coetzer	\N	ePjvJd2kgxcmgi-Tl3j1XLs63giS7Fi58LdR8lpRszw	2025-06-29 00:51:30.123501	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-11-27 00:24:12.766418	2024-11-27 00:24:12.766418	\N	\N	\N	\N	\N	email	\N	\N	2024-11-27 00:24:12.766418	legacy-import
670	y0tituadglqbs@yahoo.com	HrSVRUpRYPz	levIKLaJyaoVhAN	\N	XahpcB4qv_uEVD0grsBpl8LwAHm5Ua1I3UFkK5k-cv8	2025-06-29 00:51:30.125601	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-11-27 12:18:10.296747	2024-11-27 12:18:10.296747	\N	\N	\N	\N	\N	email	\N	\N	2024-11-27 12:18:10.296747	legacy-import
671	yejxvtvdixi@yahoo.com	cshRHdSB	csxiGMhhOPP	\N	xJopRBD5h9ad3zrj15uN3e771rfmdqm3SYXcKooV-2k	2025-06-29 00:51:30.127303	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-11-29 07:08:16.285984	2024-11-29 07:08:16.285984	\N	\N	\N	\N	\N	email	\N	\N	2024-11-29 07:08:16.285984	legacy-import
672	princereik2000@gmail.com	CHOssgmqTrYuHmx	brgjWBWXwSE	\N	V-wrKew8r1mo6Cz4CAYflW1ZSmk4G_DMlRBrFthr27s	2025-06-29 00:51:30.129284	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-11-30 01:46:55.732685	2024-11-30 01:46:55.732685	\N	\N	\N	\N	\N	email	\N	\N	2024-11-30 01:46:55.732685	legacy-import
673	nshsndpqjmpxd@yahoo.com	QaFjyeXO	VUcyMcBw	\N	3rETORKLRBKr3XoF_p-QDEfw9t0DOr0QP8GOlNE-E2E	2025-06-29 00:51:30.131389	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-11-30 20:27:43.388082	2024-11-30 20:27:43.388082	\N	\N	\N	\N	\N	email	\N	\N	2024-11-30 20:27:43.388082	legacy-import
674	riliw582@gmail.com	cWzsdJyY	dvqKLsQaTNGfI	\N	u0-dAScB6E9cEv2F-nlZaW7vMbm-_8g9JDaF2k8Awns	2025-06-29 00:51:30.133433	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-12-01 14:40:17.313254	2024-12-01 14:40:17.313254	\N	\N	\N	\N	\N	email	\N	\N	2024-12-01 14:40:17.313254	legacy-import
675	ellihrerco@yahoo.com	LIpkFxhLakKkoRV	rstyoHzdQdKcHhV	\N	-zcoAwvdqIjL2mQqpN3qoR0YI9z4w8l0WbMD8O8Mtrg	2025-06-29 00:51:30.135177	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-12-03 01:25:40.827155	2024-12-03 01:25:40.827155	\N	\N	\N	\N	\N	email	\N	\N	2024-12-03 01:25:40.827155	legacy-import
676	wqwbudiykxhgpojx@yahoo.com	mXePauFEbtNkK	tKnPxYJpuqiL	\N	cJxaJ2vByhIhBZDZN7WTcmCSOSAjAuVZPJmaw8TmIBU	2025-06-29 00:51:30.136973	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-12-03 19:33:22.148569	2024-12-03 19:33:22.148569	\N	\N	\N	\N	\N	email	\N	\N	2024-12-03 19:33:22.148569	legacy-import
677	lllbnwidgqeerdyi@yahoo.com	eqfpXYHQiJexzP	zOabEwTGGkU	\N	PzWDfwrGYkZ848AgLINlEtd6ZVyaXevLZRYt5eSl5yA	2025-06-29 00:51:30.138851	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-12-04 10:50:39.565334	2024-12-04 10:50:39.565334	\N	\N	\N	\N	\N	email	\N	\N	2024-12-04 10:50:39.565334	legacy-import
678	egbertwg43@gmail.com	RKzCSIipZOJn	oIlLMZWBHaYeqQf	\N	ONGxyW8K0GIMUYvcmJwFIQF3q9ix69Nyi6WCVZOacxQ	2025-06-29 00:51:30.140955	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-12-05 05:05:49.212346	2024-12-05 05:05:49.212346	\N	\N	\N	\N	\N	email	\N	\N	2024-12-05 05:05:49.212346	legacy-import
679	eiljraessiuj@dont-reply.me	Dilon	Grifoni	\N	H6O80G93oM9NIMdQvf1LjVfWlI55K4M7dk2_SgKzxuY	2025-06-29 00:51:30.142709	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-12-05 07:30:40.435086	2024-12-05 07:30:40.435086	\N	\N	\N	\N	\N	email	\N	\N	2024-12-05 07:30:40.435086	legacy-import
680	demihaelovinski@yahoo.com	rKxLPdlaAtwwHa	BNdTSsNDpwxs	\N	e6E7OgbD-VlvFA76uHdXgppBIiky3PZxKwRy14qb0dI	2025-06-29 00:51:30.144688	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-12-06 19:22:07.627529	2024-12-06 19:22:07.627529	\N	\N	\N	\N	\N	email	\N	\N	2024-12-06 19:22:07.627529	legacy-import
681	theophilegarage@gmail.com	FdxiZiCdD	yKBylMDjKSAlCj	\N	PbtishgB33QEMwXiunajQ-el0FeELvAGSo4h8nPRUs0	2025-06-29 00:51:30.146747	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-12-07 13:31:03.422137	2024-12-07 13:31:03.422137	\N	\N	\N	\N	\N	email	\N	\N	2024-12-07 13:31:03.422137	legacy-import
682	yonderu62delveu@gmail.com	tycoRUeRVV	AMcKedIZfWL	\N	EWcNQHg55kxKHlBy6WuUflWOlvVngLNJIjOjh4KHH3g	2025-06-29 00:51:30.148812	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-12-08 07:41:03.850185	2024-12-08 07:41:03.850185	\N	\N	\N	\N	\N	email	\N	\N	2024-12-08 07:41:03.850185	legacy-import
683	vhhokrwtf@yahoo.com	kZrJvuPIUj	YUVaCkPg	\N	DQIKTUe4vJJtfg0Ac0tSb-fH8xkXN49uf63wCs3Q3QI	2025-06-29 00:51:30.150797	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-12-09 00:23:09.695972	2024-12-09 00:23:09.695972	\N	\N	\N	\N	\N	email	\N	\N	2024-12-09 00:23:09.695972	legacy-import
684	ljqnulqdy@yahoo.com	lNcXQRVbUNWqG	OAPPWhVVrLjm	\N	KlridkwDV2Y4A0B265HCEFdOAw3-FtnVIhqLLkYCRM4	2025-06-29 00:51:30.152751	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-12-10 01:51:40.465253	2024-12-10 01:51:40.465253	\N	\N	\N	\N	\N	email	\N	\N	2024-12-10 01:51:40.465253	legacy-import
685	stoloskvrieze@yahoo.com	HBcRDUligojOVtd	CrGtmBcMtMgNYsk	\N	UH_HYRB4aZ78MWnaXnhEQN1qPEBe1DSCPLynu2HAtcE	2025-06-29 00:51:30.154742	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-12-10 01:52:51.729874	2024-12-10 01:52:51.729874	\N	\N	\N	\N	\N	email	\N	\N	2024-12-10 01:52:51.729874	legacy-import
686	emjlmambriuj@do-not-respond.me	Silverio	Mandelstam	\N	TSGiibSI-dC-ohTJpA0QHoqJAcsDZa_cV-vSaTxiSyM	2025-06-29 00:51:30.156839	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-12-10 12:50:01.426577	2024-12-10 12:50:01.426577	\N	\N	\N	\N	\N	email	\N	\N	2024-12-10 12:50:01.426577	legacy-import
687	singletonkareikt26@gmail.com	SjXiZsPqzY	EqtWEMjtejch	\N	Mqoajljkw4zJNMd1WJ8hdv6toUzO7PZKLTe53L-hLOw	2025-06-29 00:51:30.158977	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-12-11 02:37:26.471012	2024-12-11 02:37:26.471012	\N	\N	\N	\N	\N	email	\N	\N	2024-12-11 02:37:26.471012	legacy-import
688	gainechob15@gmail.com	qmMKriSOexEf	KfqFbGhBvtj	\N	3p6opugnENYPPySb9nefgwrpndnYbG84vwgs_ONyjGc	2025-06-29 00:51:30.160985	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-12-12 06:47:46.340663	2024-12-12 06:47:46.340663	\N	\N	\N	\N	\N	email	\N	\N	2024-12-12 06:47:46.340663	legacy-import
689	fowlermeibellb2006@gmail.com	NxLAAaRCpjYZ	SgjvrGHl	\N	2HDT0GMDrLshEm8gV34PVQSl4OqK60mSBVajQV-VVrA	2025-06-29 00:51:30.162967	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-12-13 10:02:26.138834	2024-12-13 10:02:26.138834	\N	\N	\N	\N	\N	email	\N	\N	2024-12-13 10:02:26.138834	legacy-import
690	mpmvksmrw@yahoo.com	WXpADfhJsHcRv	FUzLwworgM	\N	R8Qy5O4E2U8DbLfhd8fTvOtnt3qnCIcT_WwnJ4SOzsQ	2025-06-29 00:51:30.164998	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-12-14 09:18:18.920694	2024-12-14 09:18:18.920694	\N	\N	\N	\N	\N	email	\N	\N	2024-12-14 09:18:18.920694	legacy-import
691	sblxuajgbvphvryn@yahoo.com	GKgSbQQqIhjsp	HLjLaxlTloeenZH	\N	h4uoxIEN92nG7B1D2JocrVsIbzB6xbGQ8LZQQv7k_1w	2025-06-29 00:51:30.167077	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-12-15 05:16:05.795609	2024-12-15 05:16:05.795609	\N	\N	\N	\N	\N	email	\N	\N	2024-12-15 05:16:05.795609	legacy-import
692	bzbsriamziuj@do-not-respond.me	Marnina	Tinning	\N	K1IZpYb2oWr3_X-fdMBpF8CQO2WsAbI48sxIYJo5rLo	2025-06-29 00:51:30.169176	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-12-15 22:09:15.294092	2024-12-15 22:09:15.294092	\N	\N	\N	\N	\N	email	\N	\N	2024-12-15 22:09:15.294092	legacy-import
693	mjerchore@yahoo.com	bVQkWdqsIyKeHVs	VinbKsGRxbodAo	\N	_4Dw0uopKN7igXR0sxnTf2gNxbVzvPOfUiUeLfcL6ac	2025-06-29 00:51:30.171268	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-12-16 03:51:32.469931	2024-12-16 03:51:32.469931	\N	\N	\N	\N	\N	email	\N	\N	2024-12-16 03:51:32.469931	legacy-import
694	fitzharnschsa@yahoo.com	EtYuJoLkjhrEa	MiPmwebrhdM	\N	DUDn8BFoiJRcw2WKBahT0hK3d2LzTQSfDkOJC3ZQvbY	2025-06-29 00:51:30.17326	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-12-17 09:14:55.132081	2024-12-17 09:14:55.132081	\N	\N	\N	\N	\N	email	\N	\N	2024-12-17 09:14:55.132081	legacy-import
695	gosegita644@gmail.com	xOpPLygWVlAiBcL	UphxLLbyxbMmg	\N	GSjvvh7cuwiurgNTLgJ9_wHaiW-EnAiQ8JKIMpUphnE	2025-06-29 00:51:30.175129	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-12-19 13:11:45.751685	2024-12-19 13:11:45.751685	\N	\N	\N	\N	\N	email	\N	\N	2024-12-19 13:11:45.751685	legacy-import
696	ddaviesxy@gmail.com	SnqJPxCtLlXxTr	DAHlaMyqeMAeEOW	\N	cV-IO0WeHax_UpNyTcl2TGHcNBPY45Gnh8qNZIDAMY4	2025-06-29 00:51:30.176975	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-12-20 12:45:23.369437	2024-12-20 12:45:23.369437	\N	\N	\N	\N	\N	email	\N	\N	2024-12-20 12:45:23.369437	legacy-import
697	bbiamserliuj@dont-reply.me	Lamica	Ceresani	\N	dq6fYHjAy0PKPiyktMzPi_92EQjJ8y2aRWxj4lt3ujk	2025-06-29 00:51:30.178892	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-12-20 18:53:17.841793	2024-12-20 18:53:17.841793	\N	\N	\N	\N	\N	email	\N	\N	2024-12-20 18:53:17.841793	legacy-import
698	ezabucor28@gmail.com	nLAuFQCHlNBU	vgyxLfrQ	\N	ZyZCp_veqNEV0JPCo2oY2fgQ5P8Sr86Pbe3w1KZlz8M	2025-06-29 00:51:30.180957	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-12-21 09:34:30.305009	2024-12-21 09:34:30.305009	\N	\N	\N	\N	\N	email	\N	\N	2024-12-21 09:34:30.305009	legacy-import
699	ikiqotolox91@gmail.com	gFTboFHux	fDGimxFMmeFrpA	\N	4mOFqqrw5_48Se3q7C-TnPU5-jfszLvIX5EAdM2gANQ	2025-06-29 00:51:30.182849	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-12-22 04:39:30.881811	2024-12-22 04:39:30.881811	\N	\N	\N	\N	\N	email	\N	\N	2024-12-22 04:39:30.881811	legacy-import
700	tucizavarow02@gmail.com	JSZxlWaFrgoNQ	EClkMiQFnUTeY	\N	RIF8kPK1Qw9UiiN5jmbiaNP4P07aJJfO8O91K2hh2y8	2025-06-29 00:51:30.184743	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-12-22 23:30:02.488264	2024-12-22 23:30:02.488264	\N	\N	\N	\N	\N	email	\N	\N	2024-12-22 23:30:02.488264	legacy-import
701	wyx7wogryumvunv1@yahoo.com	OeWeUlRYvUKJ	DagGbvShJDorP	\N	I-BVnVw13LlQd3W32ZS7-_wRYcd4EvcRYSdBopm53z8	2025-06-29 00:51:30.186501	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-12-23 19:43:50.401204	2024-12-23 19:43:50.401204	\N	\N	\N	\N	\N	email	\N	\N	2024-12-23 19:43:50.401204	legacy-import
702	epd1qwvabny9et1i7@yahoo.com	SlwXzWtvnjMfHK	ATRxctqLnpL	\N	jVXhN07tXCQDgbZrQ4-j-_CnGKcLH4Q6gqcKvP8X8sc	2025-06-29 00:51:30.188256	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-12-24 22:10:44.642879	2024-12-24 22:10:44.642879	\N	\N	\N	\N	\N	email	\N	\N	2024-12-24 22:10:44.642879	legacy-import
703	tezepewu93@gmail.com	uPVcvWVF	aZtWmpkFu	\N	QW0PCv561kfmCXPENwttahUC08MPC7RJ4iz3Crh_3_A	2025-06-29 00:51:30.190162	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-12-25 17:44:51.865845	2024-12-25 17:44:51.865845	\N	\N	\N	\N	\N	email	\N	\N	2024-12-25 17:44:51.865845	legacy-import
704	bamrrsmjaiuj@do-not-respond.me	Dilin	Michelazzo Ceroni	\N	MWz_BKDX8acLhld7-mCuP64qNmLMNOLSAe4cWDd1TcE	2025-06-29 00:51:30.19191	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-12-25 20:22:45.608165	2024-12-25 20:22:45.608165	\N	\N	\N	\N	\N	email	\N	\N	2024-12-25 20:22:45.608165	legacy-import
705	gegozoluwete16@gmail.com	cGHaVdGQkKpSPHi	rjtoHNBeaNweZE	\N	yVFhRxFXDt-wemy5Za_HWyak7PqLgZPh32eI2BrCfrE	2025-06-29 00:51:30.193664	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-12-26 12:43:15.554061	2024-12-26 12:43:15.554061	\N	\N	\N	\N	\N	email	\N	\N	2024-12-26 12:43:15.554061	legacy-import
706	lsfkawoudqauvc@yahoo.com	woYgyYURhVIFDQj	csVDksUyWpxQ	\N	iWQX3cH-6ABF-e6McfWf1BXpQLukS90JsR0eh2RQ4cI	2025-06-29 00:51:30.195419	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-12-27 13:33:32.480039	2024-12-27 13:33:32.480039	\N	\N	\N	\N	\N	email	\N	\N	2024-12-27 13:33:32.480039	legacy-import
707	usaceyi458@gmail.com	qhOIptUHy	PdDihIhISB	\N	SB-sLtAFg2YJQdqrxqFe9E_QIG_OfFatk5GMHy_8dT4	2025-06-29 00:51:30.19717	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-12-31 04:32:43.151984	2024-12-31 04:32:43.151984	\N	\N	\N	\N	\N	email	\N	\N	2024-12-31 04:32:43.151984	legacy-import
708	ehipijido02@gmail.com	BAFQdzttCV	RkrJzBYZGjX	\N	n2SU7HN3ENC1f-3sjYuCOluyiDSBpqK4hUTGlenYJS8	2025-06-29 00:51:30.198946	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2024-12-31 22:51:24.573716	2024-12-31 22:51:24.573716	\N	\N	\N	\N	\N	email	\N	\N	2024-12-31 22:51:24.573716	legacy-import
709	ixucupaci96@gmail.com	xYixxLNDfy	EgCjvllp	\N	LPpbxaPITa1Tem5SbMkBc1pcoRM5ocun7cGBznp2MOU	2025-06-29 00:51:30.200693	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2025-01-01 15:46:09.932345	2025-01-01 15:46:09.932345	\N	\N	\N	\N	\N	email	\N	\N	2025-01-01 15:46:09.932345	legacy-import
710	alunuvagog048@gmail.com	GAqFurWI	dgDSoNZMuHKtIFe	\N	8h8gx2A41D7va6_bkJ8Vwpy8UBF9Wq9vOIx1GbXFoEE	2025-06-29 00:51:30.202473	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2025-01-02 09:00:10.493836	2025-01-02 09:00:10.493836	\N	\N	\N	\N	\N	email	\N	\N	2025-01-02 09:00:10.493836	legacy-import
711	danesipapsavs@yahoo.com	lOwuRxGyN	enQmAjqcJMDg	\N	rrYF2FYqyX5wGGY0r5Nfy90rRrTLuZ6jcTv4ElSasSA	2025-06-29 00:51:30.204337	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2025-01-03 05:42:23.927669	2025-01-03 05:42:23.927669	\N	\N	\N	\N	\N	email	\N	\N	2025-01-03 05:42:23.927669	legacy-import
712	yukiyahowof100@gmail.com	ligMwXTBVyEbhY	xGDePejKiYuhVn	\N	rJMzjcpj5JJa068AbxYWWt_yxW76W74NBIajkBWueXA	2025-06-29 00:51:30.206007	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2025-01-04 05:10:31.463985	2025-01-04 05:10:31.463985	\N	\N	\N	\N	\N	email	\N	\N	2025-01-04 05:10:31.463985	legacy-import
713	julowagexu335@gmail.com	macCYdTFk	pwNShqWpyAr	\N	VrReOBQN3x3uPGSUIAqy8pao4Dd4Iu6WarfBaW3QTMk	2025-06-29 00:51:30.207674	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2025-01-05 05:14:50.921359	2025-01-05 05:14:50.921359	\N	\N	\N	\N	\N	email	\N	\N	2025-01-05 05:14:50.921359	legacy-import
714	rjazrmezmiuj@do-not-respond.me	Ovich	Zayasbazan	\N	KlQi2fEeB68YfYA24Q8hsO56toxnqCevG5Mnswnbmw0	2025-06-29 00:51:30.209341	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2025-01-05 21:44:24.993159	2025-01-05 21:44:24.993159	\N	\N	\N	\N	\N	email	\N	\N	2025-01-05 21:44:24.993159	legacy-import
715	vjekrcdaqyjwohmh@yahoo.com	aOMVTPoU	lPRBylXLmYrq	\N	ek--mdx4JfF_qf7uC1xeL4_Xs6tomnzNEbyipNHa3QQ	2025-06-29 00:51:30.211173	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2025-01-07 12:28:15.804701	2025-01-07 12:28:15.804701	\N	\N	\N	\N	\N	email	\N	\N	2025-01-07 12:28:15.804701	legacy-import
716	hidenenizix78@gmail.com	jCpRgPKsaioJwRZ	ygkeoRQx	\N	nLTjM89kodvwdTqy3DtRsVLkqZcsTneAv-6ztyxJWi4	2025-06-29 00:51:30.212952	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2025-01-09 18:08:02.555914	2025-01-09 18:08:02.555914	\N	\N	\N	\N	\N	email	\N	\N	2025-01-09 18:08:02.555914	legacy-import
749	fizakoffvoneschen@yahoo.com	MHoEoiuDQ	OqedNRKmOLu	\N	RjxdgpylCuXl6cicEh0VP35CiWb9IJCUiNl5eC3ceu0	2025-06-29 00:51:30.214588	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2025-01-10 16:08:53.420405	2025-01-10 16:08:53.420405	\N	\N	\N	\N	\N	email	\N	\N	2025-01-10 16:08:53.420405	legacy-import
750	meichertyrna@yahoo.com	fHttYyqOVgU	gWGbJxijerAN	\N	67c4EYhnIRtV_uAvYyVsY5buTSSvE_CjXjabM-hYFgk	2025-06-29 00:51:30.217824	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2025-01-11 14:02:01.962128	2025-01-11 14:02:01.962128	\N	\N	\N	\N	\N	email	\N	\N	2025-01-11 14:02:01.962128	legacy-import
751	mpaxztpcnxpeaz@yahoo.com	eJZpUxkEgMXs	tVGcDncJTDHBPi	\N	0_btz2Da0BoruYXgg3ILL5JVZ-8ka86EflnmBoOG4bM	2025-06-29 00:51:30.219687	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2025-01-12 16:23:15.821156	2025-01-12 16:23:15.821156	\N	\N	\N	\N	\N	email	\N	\N	2025-01-12 16:23:15.821156	legacy-import
752	ccxufkxqwd@yahoo.com	gobOOSpn	gyZiIYvgvccx	\N	-_v1g-KK9cPYZyHpYSI-Li7feu4o2p9bFRXMjw_KJdU	2025-06-29 00:51:30.221468	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2025-01-14 01:50:19.041774	2025-01-14 01:50:19.041774	\N	\N	\N	\N	\N	email	\N	\N	2025-01-14 01:50:19.041774	legacy-import
753	utdsnmfwsh@yahoo.com	LQAXDMjG	nRgHvQiVHZD	\N	w8ORR5IpyXQm_Nns6-fDRqOoJnl11fxJpqH6_K4C-ys	2025-06-29 00:51:30.223615	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2025-01-15 11:12:15.377031	2025-01-15 11:12:15.377031	\N	\N	\N	\N	\N	email	\N	\N	2025-01-15 11:12:15.377031	legacy-import
754	ievortexea77glyph@gmail.com	OYExzKpULAPIvkZ	UNALSkcq	\N	klFKdeyMYdVePvQ2EYV-wiOEc4VVOH7_VA-pvZNPojI	2025-06-29 00:51:30.225653	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2025-01-18 06:05:44.632713	2025-01-18 06:05:44.632713	\N	\N	\N	\N	\N	email	\N	\N	2025-01-18 06:05:44.632713	legacy-import
755	rsbsjzzmjiuj@dont-reply.me	Eliyah	Famble	\N	9xT3KS1AdALZW2-XITs45UTaZKftD8jaF91Z0oxoSOg	2025-06-29 00:51:30.227621	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2025-01-19 01:35:40.055931	2025-01-19 01:35:40.055931	\N	\N	\N	\N	\N	email	\N	\N	2025-01-19 01:35:40.055931	legacy-import
756	reverieiquartzio@gmail.com	guLDmCtFpP	AoOzicOqqPPYt	\N	EKY1_n8zxIfaD1hxQHSlSaYMJZaMuHOCnsKx6nfUk-U	2025-06-29 00:51:30.229594	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2025-01-19 03:28:44.287589	2025-01-19 03:28:44.287589	\N	\N	\N	\N	\N	email	\N	\N	2025-01-19 03:28:44.287589	legacy-import
757	ouphantomeo30rift@gmail.com	tbGbNRpPJGt	hXkoSFYjYEhZ	\N	eCXrZQFS7ZMYvZx2xcTAd3O2CzxpGMJ43ETf3-aVFVM	2025-06-29 00:51:30.231582	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2025-01-20 00:13:13.167259	2025-01-20 00:13:13.167259	\N	\N	\N	\N	\N	email	\N	\N	2025-01-20 00:13:13.167259	legacy-import
758	uvortexoechime83@gmail.com	dlwJKdnISfu	erQoAKZJKHI	\N	_GA5E7bOX8xgIBjEPBAGPtFqNYNmD_PalxWBg5luPe4	2025-06-29 00:51:30.23371	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2025-01-21 01:50:08.566548	2025-01-21 01:50:08.566548	\N	\N	\N	\N	\N	email	\N	\N	2025-01-21 01:50:08.566548	legacy-import
759	rmiaazlrsiuj@dont-reply.me	Ayaka	Weeman	\N	UuJyl-t5egiU2Di2-dKPBowV4Pm_xBpwo3RcOa4b2Lo	2025-06-29 00:51:30.235704	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2025-01-21 20:33:44.05895	2025-01-21 20:33:44.05895	\N	\N	\N	\N	\N	email	\N	\N	2025-01-21 20:33:44.05895	legacy-import
760	guvbwwfmeem@yahoo.com	NQifuKhNquCANZ	UuSRMylfFcniN	\N	7P7vW17JcOFirhaCkvWcgBAY5VWFyDUv1mjRycPWKNw	2025-06-29 00:51:30.241771	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2025-01-22 12:13:38.418624	2025-01-22 12:13:38.418624	\N	\N	\N	\N	\N	email	\N	\N	2025-01-22 12:13:38.418624	legacy-import
761	azmrjeajriuj@dont-reply.me	Marieliz	Esono	\N	ZMp5pVbe0Jpwd2N7rzeRvIUZBtiOjlFNByFIttcJH3Q	2025-06-29 00:51:30.244275	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2025-01-24 12:55:32.554973	2025-01-24 12:55:32.554973	\N	\N	\N	\N	\N	email	\N	\N	2025-01-24 12:55:32.554973	legacy-import
762	kristen6munoz6024@gmail.com	RsdIDHEzfQj	DXCQHMvdIFNZ	\N	U2FiwP36731fD26Ij_W41-z87puC4luwViTbZQ3S3VY	2025-06-29 00:51:30.246355	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2025-01-25 11:48:41.95989	2025-01-25 11:48:41.95989	\N	\N	\N	\N	\N	email	\N	\N	2025-01-25 11:48:41.95989	legacy-import
763	areeabziziuj@dont-reply.me	Jaxper	Arvola	\N	yg10VGqKG60PdRz4aJR75xGN019HYBbn35_GK_PN1bM	2025-06-29 00:51:30.248985	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2025-01-27 02:37:34.174273	2025-01-27 02:37:34.174273	\N	\N	\N	\N	\N	email	\N	\N	2025-01-27 02:37:34.174273	legacy-import
764	fmppiqnecntyoh@yahoo.com	YzfDEwaXIqOulnI	uXRnVJQYOZI	\N	mo26jtqSAZE3S5mLbi4_PA4Fi51eUnoGbw0gnjc9P54	2025-06-29 00:51:30.251182	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2025-01-27 08:10:31.327691	2025-01-27 08:10:31.327691	\N	\N	\N	\N	\N	email	\N	\N	2025-01-27 08:10:31.327691	legacy-import
765	aiazjblzliuj@dont-reply.me	Duvan	Potkay	\N	4NvDYxoUt1hkQOE7afgQYdwDBRWfTe72QkylfWQtxxI	2025-06-29 00:51:30.253728	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2025-01-29 02:09:02.087054	2025-01-29 02:09:02.087054	\N	\N	\N	\N	\N	email	\N	\N	2025-01-29 02:09:02.087054	legacy-import
766	jacques5conors8709@gmail.com	GQyfwVfrZ	nUHYExOJeyQ	\N	8LETVAFvtwt4QKIKF2XwdLAxr0wGHjzUY0P43na3ts4	2025-06-29 00:51:30.255799	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2025-01-30 02:10:51.900616	2025-01-30 02:10:51.900616	\N	\N	\N	\N	\N	email	\N	\N	2025-01-30 02:10:51.900616	legacy-import
767	renee3wilkins7013@gmail.com	rwDBsMbszKE	mvjcXEobCYyChxJ	\N	eKPYnQ-fObQJSAEAncSb4OadJzCHxK12SKfNUkuvDW0	2025-06-29 00:51:30.257966	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2025-01-31 07:14:49.167375	2025-01-31 07:14:49.167375	\N	\N	\N	\N	\N	email	\N	\N	2025-01-31 07:14:49.167375	legacy-import
768	nkkajdyajvtt@yahoo.com	GpBRiMyagxjIeP	BatilZYI	\N	NNS-V0PztGmHgv9gxzZ6ky5MwZXLZSb1QHOTynvhiYc	2025-06-29 00:51:30.260535	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2025-02-01 12:48:25.121253	2025-02-01 12:48:25.121253	\N	\N	\N	\N	\N	email	\N	\N	2025-02-01 12:48:25.121253	legacy-import
769	izjljazbeiuj@dont-reply.me	Ardelle	Ramirez Vallicenti	\N	a4NCIFlUfytv_BRTgAS0RyBaUwKOyv9H3lA9Tvuq7vg	2025-06-29 00:51:30.262521	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2025-02-02 00:46:46.260386	2025-02-02 00:46:46.260386	\N	\N	\N	\N	\N	email	\N	\N	2025-02-02 00:46:46.260386	legacy-import
770	amkumanikienk@yahoo.com	SDzOteLEXMH	AcEvSEDjwEOUjx	\N	DxX0NZ5zUAnWKWsqEdwN1uiUHYHvgl_YcTSiNFu_484	2025-06-29 00:51:30.264657	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2025-02-02 10:19:42.407927	2025-02-02 10:19:42.407927	\N	\N	\N	\N	\N	email	\N	\N	2025-02-02 10:19:42.407927	legacy-import
771	zenithio56xenon61@gmail.com	lBSfrTZRHIsG	zFJkrudcHZ	\N	f3LX5jiiZMBAI8HnApPaY3-16zVvoqljvxyadChrKZI	2025-06-29 00:51:30.267251	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2025-02-03 08:38:14.302951	2025-02-03 08:38:14.302951	\N	\N	\N	\N	\N	email	\N	\N	2025-02-03 08:38:14.302951	legacy-import
772	ibbiaaslmiuj@dont-reply.me	Alexxia	Fremke	\N	bqLWLbgG0GPTw1fYy-NkQF_lhzmS1gF6fWfr2Dc7EEQ	2025-06-29 00:51:30.26928	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2025-02-04 03:36:16.141022	2025-02-04 03:36:16.141022	\N	\N	\N	\N	\N	email	\N	\N	2025-02-04 03:36:16.141022	legacy-import
773	oonirvanatalismanuo@gmail.com	eTiaYmQU	mffZPfkoEEPZKn	\N	_uPJesViUu_wiuk9wDzrPhMhTxacxZXg87SrjdCvsV0	2025-06-29 00:51:30.271339	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2025-02-04 10:07:44.26125	2025-02-04 10:07:44.26125	\N	\N	\N	\N	\N	email	\N	\N	2025-02-04 10:07:44.26125	legacy-import
774	yonderuy46nexus@gmail.com	qGsPBVrA	ikZMIAcKj	\N	r529xtxV4q5uT9UAals8Gqd38wXJIEOjOjAX5OpDkxQ	2025-06-29 00:51:30.273898	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2025-02-05 10:29:30.945517	2025-02-05 10:29:30.945517	\N	\N	\N	\N	\N	email	\N	\N	2025-02-05 10:29:30.945517	legacy-import
775	mementouedelve@gmail.com	DyZBDewMmPfqvN	csWasjie	\N	qTu1Q5obQpO0uA8eDr04uUFzpyJczUVN4AC4-vJr8KM	2025-06-29 00:51:30.275918	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2025-02-06 10:36:49.170437	2025-02-06 10:36:49.170437	\N	\N	\N	\N	\N	email	\N	\N	2025-02-06 10:36:49.170437	legacy-import
776	borealie18oracle37i@gmail.com	xhqPigFp	tOsyCNcNiZRRyho	\N	Pfhhk1AEqleZT2j4gbyad2GqG5BulvhUvlw6-QSVszg	2025-06-29 00:51:30.277998	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2025-02-07 08:52:39.403741	2025-02-07 08:52:39.403741	\N	\N	\N	\N	\N	email	\N	\N	2025-02-07 08:52:39.403741	legacy-import
777	abraxaskaleidoscope17@gmail.com	NUoPabika	wjlxtdzHxjUc	\N	zXMJEwG8dY_jn7u1f2n9H00SKGAyjSZWROwyFKNwgaw	2025-06-29 00:51:30.280571	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2025-02-09 05:44:40.320735	2025-02-09 05:44:40.320735	\N	\N	\N	\N	\N	email	\N	\N	2025-02-09 05:44:40.320735	legacy-import
778	eclipsey67glyph6@gmail.com	vdvgsXZcENl	fARHbFfjpoRVSNM	\N	J-Smah5MPkFIHI88I3sbhuLSDKAlPlPWWmMWljjrHDg	2025-06-29 00:51:30.282622	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2025-02-10 12:50:42.720351	2025-02-10 12:50:42.720351	\N	\N	\N	\N	\N	email	\N	\N	2025-02-10 12:50:42.720351	legacy-import
779	oxunirig74@gmail.com	LCoZRqMXxXZddwj	kXjpeNnziS	\N	sp6SIF6P2eQMCi7LbkXk9k-QLaLAhXNXGtgIJlr5JlY	2025-06-29 00:51:30.285355	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2025-02-14 12:34:15.644675	2025-02-14 12:34:15.644675	\N	\N	\N	\N	\N	email	\N	\N	2025-02-14 12:34:15.644675	legacy-import
780	abraxasey10glyph@gmail.com	zatWthwXdZvXU	UPzcKuCZVm	\N	IvO7bv7tM5IMV-4ZjbYPgBcAS8-DJwsC5vjLSRTexdk	2025-06-29 00:51:30.287507	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2025-02-15 06:55:55.410771	2025-02-15 06:55:55.410771	\N	\N	\N	\N	\N	email	\N	\N	2025-02-15 06:55:55.410771	legacy-import
781	stivilynts17@gmail.com	YxLUwDjDT	veyKjBJWqZmQO	\N	-vTjdjWxCz26lo5yLwvoJ_6IwlIWNNJo9twz4Lh0o5I	2025-06-29 00:51:30.289748	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2025-02-15 23:48:28.152429	2025-02-15 23:48:28.152429	\N	\N	\N	\N	\N	email	\N	\N	2025-02-15 23:48:28.152429	legacy-import
782	paeprlea@yahoo.com	MJamDPfaIVjg	grrpFiPxuvx	\N	bHflcs-iArfBFd78UOjWLCUzVfpNedwZHIbCz7yNHnc	2025-06-29 00:51:30.291899	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2025-02-16 15:16:35.575544	2025-02-16 15:16:35.575544	\N	\N	\N	\N	\N	email	\N	\N	2025-02-16 15:16:35.575544	legacy-import
783	ierbzrmbluj@dont-reply.me	Carlosantonio	Jalak	\N	re7ZHk8wNUXWtPqlpLOJ6rTh3woBJmGRP1ECdKLFM7o	2025-06-29 00:51:30.294532	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2025-02-16 21:03:40.274381	2025-02-16 21:03:40.274381	\N	\N	\N	\N	\N	email	\N	\N	2025-02-16 21:03:40.274381	legacy-import
784	nadgristemon@yahoo.com	HESrZDxr	WGQoBEfgWts	\N	ySfIMQlGvqipQNkIAANoMlbR3kqPsuKoB5qcFTGLokQ	2025-06-29 00:51:30.29673	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2025-02-20 01:27:00.454613	2025-02-20 01:27:00.454613	\N	\N	\N	\N	\N	email	\N	\N	2025-02-20 01:27:00.454613	legacy-import
785	lysettas1@gmail.com	XPtiOedcP	ekNbrYJkKjriK	\N	QqfiG3uNJqGSoXltpGV93ijbrxVTOFWaAg6Sh8VVH48	2025-06-29 00:51:30.298895	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2025-02-21 00:50:22.928358	2025-02-21 00:50:22.928358	\N	\N	\N	\N	\N	email	\N	\N	2025-02-21 00:50:22.928358	legacy-import
786	zjlzbeljsluj@dont-reply.me	Aujah	Milich	\N	t8uMbtmTcplJgayJMqah-AMdtDtU2NeZpfk3zsXVYAA	2025-06-29 00:51:30.301596	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2025-02-22 18:12:43.880698	2025-02-22 18:12:43.880698	\N	\N	\N	\N	\N	email	\N	\N	2025-02-22 18:12:43.880698	legacy-import
787	xuequzco@do-not-respond.me	TestUser	Alice	\N	_MUke7VboQ-h26a90s_jA2AzDldMkitaR-_a2qW5xMY	2025-06-29 00:51:30.303757	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2025-03-05 08:08:54.45524	2025-03-05 08:08:54.45524	\N	\N	\N	\N	\N	email	\N	\N	2025-03-05 08:08:54.45524	legacy-import
788	yugrmcws@do-not-respond.me	Alice	Hello	\N	ar7SFgBSHS0haNPsk2RKGkSOxMbxE1SOGZCs64ucVtw	2025-06-29 00:51:30.305861	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2025-03-07 22:54:20.631219	2025-03-07 22:54:20.631219	\N	\N	\N	\N	\N	email	\N	\N	2025-03-07 22:54:20.631219	legacy-import
789	kertyucds@onet.eu	Migueldaync	Migueldaync	\N	dWtbd4e5OdZJ9V0c6nJ4tbusa5tAuLY1hhshzeTatF0	2025-06-29 00:51:30.307929	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2025-03-09 03:35:59.258626	2025-03-09 03:35:59.258626	\N	\N	\N	\N	\N	email	\N	\N	2025-03-09 03:35:59.258626	legacy-import
790	barbour.sundin@gmail.com	Williamexase	Williamexase	\N	9B7BiGgTilGTWXK6ejr_N9w0MUpESAGhcdRVizLTBQ4	2025-06-29 00:51:30.310547	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2025-03-13 13:02:02.279431	2025-03-13 13:02:02.279431	\N	\N	\N	\N	\N	email	\N	\N	2025-03-13 13:02:02.279431	legacy-import
791	cxtkarow@do-not-respond.me	MyName	MyName	\N	hQ0E7HD0_3S3QxF4_OBsG80yXrNKz82LZEkdLeqbU5w	2025-06-29 00:51:30.312622	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2025-03-21 04:41:01.306041	2025-03-21 04:41:01.306041	\N	\N	\N	\N	\N	email	\N	\N	2025-03-21 04:41:01.306041	legacy-import
824	nomin.momin+108b3@mail.ru	Opdwodowkdwiidwok djwkqdwqofhjqwlsqj jfkmclasdkjfjewlfjkwkdjoiqw fnedkwdkowfwhi jiowjiowhfiwkj rohriowjropwjrofwjrijeiwo theartexch.com	Opdwodowkdwiidwok djwkqdwqofhjqwlsqj jfkmclasdkjfjewlfjkwkdjoiqw fnedkwdkowfwhi jiowjiowhfiwkj rohriowjropwjrofwjrijeiwo theartexch.com	\N	swujBwL6kkqHZN1hCFqymTG1dtIDc048WW916PQEfMw	2025-06-29 00:51:30.315301	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2025-03-29 16:45:16.214493	2025-03-29 16:45:16.214493	\N	\N	\N	\N	\N	email	\N	\N	2025-03-29 16:45:16.214493	legacy-import
825	vpwyleah@formtest.guru	John	John	\N	6WOr8micbKezvGHabqtBDCQx6-d7lhrhjlduSqvv-Xw	2025-06-29 00:51:30.317461	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2025-04-17 06:40:24.936557	2025-04-17 06:40:24.936557	\N	\N	\N	\N	\N	email	\N	\N	2025-04-17 06:40:24.936557	legacy-import
826	louratug@mail.ru	vortexpromabinc	vortexpromabinc	\N	REqfptUWq0yOwJF7IWn0i9z7uNBY0YgZ2Eg7Fdg2RvI	2025-06-29 00:51:30.319603	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2025-04-23 20:53:07.036479	2025-04-23 20:53:07.036479	\N	\N	\N	\N	\N	email	\N	\N	2025-04-23 20:53:07.036479	legacy-import
827	jvgppham@formtest.guru	Hello	Hello	\N	0o7_auzMJ1fo8nqDQulY-vRoy322ySgejFehX764Puo	2025-06-29 00:51:30.322355	\N	\N	\N	0	\N	\N	\N	\N	0	\N	\N	\N	\N	\N	f	{}	2025-05-03 14:33:55.110555	2025-05-03 14:33:55.110555	\N	\N	\N	\N	\N	email	\N	\N	2025-05-03 14:33:55.110555	legacy-import
\.


--
-- Data for Name: venues; Type: TABLE DATA; Schema: public; Owner: roberttaylor
--

COPY public.venues (id, name, address, city, administrative_area, postal_code, country, latitude, longitude, website, email, telephone_number, capacity, venue_type, status, description, previous_names, created_at, updated_at) FROM stdin;
1	PNC Music Pavillion	707 Pavilion Blvd	Charlotte	NC	28262	US	35.327991	-80.711207	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:26.954127	2021-08-16 15:36:01.828737
2	Cynthia Woods Mitchell Pavilion	2005 Lake Robbins Dr	The Woodlands	TX	77380	US	30.161472	-95.463916	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:26.962707	2021-08-16 15:35:20.973969
4	Budweiser Stage	909 Lake Shore Blvd W	Toronto	ON	M6K 3B9	CA	43.629270	-79.415079	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:26.970702	2021-08-16 15:35:24.733769
5	Saratoga Springs Performing Arts Center	108 Avenue of the Pines	Saratoga Springs	NY	12866	US	43.053070	-73.798730	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:26.978588	2021-08-16 15:35:18.105216
6	Parc Jean-Drapeau	1 Circuit Gilles Villeneuve	Montreal	QC	H3C 1A9	CA	45.498768	-73.522229	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:26.986256	2021-08-16 15:35:17.343599
7	Wrigley Field	1060 W Addison St	Chicago	IL	60613	US	41.947630	-87.656376	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:26.99373	2021-08-16 15:35:09.115126
9	Gorge Amphitheatre	754 Silica Road	Aberdeen	WA	98848	US	47.100606	-119.993611	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.014924	2021-08-16 15:35:09.375573
10	Zilker Park	2100 Barton Springs Rd	Austin	TX	78704	US	30.267767	-97.767905	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.022279	2021-08-16 15:35:21.608721
11	Veterans United Home Loans Amphitheatre	3550 Cellar Door Way	Virginia Beach	VA	23456	US	36.769109	-76.103678	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.029203	2021-08-30 12:10:12.348047
12	Alpine Valley Music Theatre	W2699 County Road D	East Troy	WI	53121	US	42.742095	-88.469645	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.03592	2021-08-16 15:35:08.324109
13	Greek Theatre	2001 Gayley Rd	Berkeley	CA	94720	US	37.869760	-122.250630	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.042871	2021-08-16 15:35:15.255389
14	Nikon at Jones Beach Theater	1000 Ocean Pkwy	Wantagh	NY	11793	US	40.662690	-73.510980	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.049793	2021-08-16 15:35:18.653488
16	Ruoff Home Mortgage Music Center	12880 E 146th St	Noblesville	IN	46060	US	40.005289	-85.930843	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.056811	2021-08-16 15:36:03.254462
17	Perfect Vodka Amphitheatre	601-7 Sansburys Way	West Palm Beach	FL	33411	US	26.684050	-80.184360	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.063531	2021-08-16 15:36:10.190909
18	Fiddler's Green Amphitheatre	6350 Greenwood Plaza Blvd	Englewood	CO	80111	US	39.601273	-104.894505	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.070263	2021-08-16 15:35:09.875684
19	USANA Amphitheater	5150 South 6055 West	West Valley City	UT	84118	US	40.684273	-112.035881	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.077472	2021-08-16 15:35:21.319472
20	TD Garden	100 Legends Way	Boston	MA	02114	US	42.366276	-71.062188	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.084536	2021-08-16 15:35:11.581443
21	Manchester Academy	Moss Ln E	Manchester	ENG		GB	53.458076	-2.237083	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.261481	2021-08-16 15:35:24.312881
22	AFAS Live	Arena Boulevard 590	Amsterdam	NH		NL	52.312322	4.944225	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.092592	2021-08-16 15:35:53.745217
23	Madison Square Garden	4 Pennsylvania Plaza	New York	NY	10001	US	40.750470	-73.993370	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.099861	2021-08-16 15:35:16.064858
24	Verizon Wireless Amphitheatre at Encore Park	2200 Encore Pkwy	Alpharetta	GA	30009	US	34.054351	-84.306086	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.107741	2021-08-16 15:36:02.751315
25	Izod Center	Meadowlands Sports Complex, 50 NJ-120	East Rutherford	NJ	07073	US	40.812626	-74.065248	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.122109	2021-08-16 15:35:11.359969
26	Olympia Bruno Coquatrix	28 Boulevard des Capucines	Paris	IDF	75009	FR	48.870152	2.328364	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.133277	2021-08-16 15:35:23.466016
27	Brixton Academy	211 Stockwell Rd	London	ENG	SW9 9SL	GB	51.465119	-0.115148	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.141099	2021-08-16 15:35:21.949651
28	Coco Cay		Chub Cay	BY		BS	25.417961	-77.882828	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.148858	2021-08-16 15:35:24.919242
29	BB&T Pavilion	1 Harbour Blvd	Camden	NJ	80103	US	39.942333	-75.128549	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.156647	2021-08-16 15:35:11.791728
30	John Paul Jones Arena	295 Massie Rd	Charlottesville	VA	22903	US	38.045976	-78.509913	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.164444	2021-08-16 15:35:20.523676
31	North Charleston Coliseum	5001 Coliseum Drive	North Charleston	SC	29418	US	32.865501	-80.022429	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.171074	2021-08-16 15:35:18.302054
32	Microsoft Store	116 Bellevue Way NE	Bellevue	WA	98004	US	47.615740	-122.203490	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.177839	2021-08-16 15:35:19.963953
33	Jiffy Lube Live	7800 Cellar Door Dr	Bristow	VA	20136	US	38.786022	-77.587846	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.185057	2021-08-16 15:35:20.787379
34	1st Bank Center	11450 Broomfield Ln	Agate	CO	80021	US	39.904570	-105.085440	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.191792	2021-08-16 15:35:13.279014
35	Planet Hollywood Resort & Casino	3667 S Las Vegas Blvd	Las Vegas	NV	89109	US	36.110127	-115.171091	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.198564	2021-08-16 15:36:02.271808
36	Wells Fargo Center	3601 S Broad St	Aaronsburg	PA	19148	US	39.901858	-75.171807	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.20547	2021-08-16 15:35:19.325822
37	Joseph P. Riley Jr. Park	360 Fishburne Street	Charleston	SC	29403	US	32.790721	-79.961049	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.212464	2021-08-16 15:35:19.162473
38	Bader Field	545 N Albany Ave	Atlantic City	NJ	08401	US	39.358470	-74.460500	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.219546	2021-08-16 15:35:20.257627
39	Blossom Music Center	1145 W Steels Corners Rd,	Cuyahoga Falls	OH	44223	US	41.180980	-81.549800	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.226513	2021-08-16 15:35:16.811334
40	Shoreline Amphitheater	1 Amphitheatre Pkwy	Mountain View	CA	94043	US	37.426767	-122.080678	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.233226	2021-08-16 15:35:10.319311
41	Xfinity Center	885 S Main St	Mansfield	MA	02048	US	41.992503	-71.219974	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.23985	2021-08-16 15:35:12.385758
42	Randalls Island	20 Randall’s Island Park	New York	NY	10035	US	40.794629	-73.924455	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.429259	2021-08-16 15:35:32.631871
43	MidFlorida Credit Union Amphitheatre	4802 N U.S. Hwy 301	Tampa	FL	33610	US	27.993216	-82.365020	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.246751	2021-08-16 15:35:14.817001
44	Riverbend Music Center	6295 Kellogg Avenue	Cincinnati	OH	45230	US	39.052080	-84.418884	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.254244	2021-08-16 15:35:16.578036
45	Marion Oliver McCaw Hall	321 Mercer Street	Seattle	WA	98109	US	47.623954	-122.350765	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.268516	2021-08-16 15:36:08.513204
46	XFINITY Theatre	61 Savitt Way	Hartford	CT	06120	US	41.780215	-72.669230	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.275531	2021-08-16 15:35:12.617846
47	Arenan	Mårtensdalsgatan 2-8	Stockholm	AB		SE	59.300923	18.090173	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.282363	2021-08-16 15:35:22.582869
48	Apollo Theatre	Shaftesbury Avenue	London	ENG		GB	51.657077	-0.042423	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.289422	2021-08-16 15:35:23.217963
49	Governors Island	Ferry Line Rd	New York	NY	10004	US	40.730600	-73.986600	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.29638	2021-08-16 15:36:11.28051
50	Wolverhampton Civic Hall	North Street	Wolverhampton	ENG		GB	52.586260	-2.129925	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.000896	2021-08-16 15:35:24.471172
51	United Palace Theatre	4140 Broadway	New York	NY	4140 Broadway	US	42.871108	-77.885561	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.007702	2021-08-16 15:35:18.991244
52	Concord Pavilion	2000 Kirker Pass Road	Concord	CA	94521	US	37.960355	-121.939656	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.303155	2021-08-16 15:35:10.894747
53	Intrust Bank Arena	500 East Waterman Street	Wichita	KS	67202	US	37.683271	-97.331636	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.3101	2021-08-16 15:35:09.643178
54	Lakewood Amphitheatre	2002 Lakewood Ave SE	Atlanta	GA	30315	US	33.701760	-84.385510	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.317811	2021-08-16 15:35:15.549685
55	DTE Energy Music Theatre	7774 Sashabaw Road	Ada	MI	48348	US	42.747045	-83.373497	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.325566	2021-08-16 15:35:10.597971
56	Oak Mountain Amphitheatre	1000 Amphitheater Rd	Pelham	AL	35124	US	33.331685	-86.783222	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.332574	2021-08-16 15:35:11.127369
57	Fenway Park	4 Yawkey Way	Boston	MA	02215	US	42.346742	-71.098643	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.339644	2021-08-16 15:35:10.10376
58	BankPlus Amphitheater at Snowden Grove	6285 Snowden Lane	Southaven	MS		US	34.961119	-89.932510	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.348852	2021-08-16 15:35:14.552999
59	Greek Theatre	2700 North Vermont Avenue	Los Angeles	CA		US	34.030208	-118.291218	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.356501	2021-08-16 15:35:13.583582
60	Oakdale Theatre	95 South Turnpike Rd	Wallingford	CT	06492	US	41.448666	-72.846221	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.364875	2021-08-16 15:35:13.804034
61	Sleep Train Amphitheatre	2050 Entertainment Cir	Chula Vista	CA	91911	US	32.588081	-117.006309	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.57066	2021-08-16 15:36:04.110894
62	Saenger Theatre	1111 Canal St	New Orleans	LA	70112	US	29.956054	-90.072828	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.375155	2021-08-16 15:35:14.088681
63	Centennial Olympic Park	265 Park Ave W NW	Atlanta	GA	30313	US	33.760080	-84.398350	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.383028	2021-08-16 15:35:12.113745
64	Nationals Park	1500 S Capitol St SE	Washington	DC	20003	US	38.872367	-77.008529	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.390176	2021-08-16 15:36:10.828443
65	Citi Field	123-01 Roosevelt Ave	New York	NY	11368	US	40.746810	-73.860540	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.398037	2021-08-16 15:35:31.890464
66	Gexa Energy Pavilion	3839 S Fitzhugh Ave	Dallas	TX	75210	US	32.769290	-96.745010	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.404938	2021-08-16 15:35:39.032422
67	CenturyLink Center Omaha	455 North 10th Street	Omaha	NE	68102	US	41.263814	-95.928788	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.414258	2021-08-16 15:35:32.878463
68	Barclays Center	620 Atlantic Ave	Brooklyn	NY	11217	US	40.683074	-73.975985	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.421475	2021-08-16 15:35:35.525858
69	Mapfre Stadium	1 Black and Gold Boulevard	Columbus	OH	43211	US	40.008760	-82.991203	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.43663	2021-08-16 15:35:37.5598
70	Lake Tahoe Outdoor Arena	15 Highway 50	Stateline	NV	89449	US	38.959096	-119.939674	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.443615	2021-08-16 15:35:35.003904
71	Hollywood Casino Amphitheatre	14141 Riverport Dr	Maryland Heights	MO	63043	US	38.745794	-90.470049	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.450629	2021-08-16 15:35:31.142057
72	The AXIS	3667 Las Vegas Boulevard South	Alamo	NV		US	36.166300	-115.149200	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.45782	2021-08-16 15:35:38.596309
73	BOK Center	200 South Denver Ave W	Tulsa	OK	74103	US	36.152768	-95.996231	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.469511	2021-08-16 15:35:39.484219
74	The O2 Arena	Peninsula Square	London	ENG		GB	51.501135	0.005036	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.47705	2021-08-16 15:35:56.587575
75	Nationwide Arena	200 W Nationwide Blvd	Columbus	OH	43215	US	39.968836	-83.006953	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.484378	2021-08-16 15:35:36.679564
76	Darien Lake Performing Arts Center	9993 Alleghany Road	Accord	NY	14040	US	42.927267	-78.375024	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.497692	2021-08-16 15:36:06.233023
77	River's Edge Music Festival	200 Dr Justus Ohage Blvd	Ada	MN	55017	US	44.935622	-93.098744	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.506924	2021-08-16 15:35:39.699913
78	First Niagara Pavilion	665 Route 18	Burgettstown	PA	15021	US	40.419665	-80.434156	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.513918	2021-08-16 15:35:36.453925
79	Hershey Park Stadium	100 West Hersheypark Drive	Hershey	PA	17033	US	40.287090	-76.662988	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.521014	2021-08-16 15:35:30.617062
80	Austin360 Amphitheater	9201 Circuit of the Americas Blvd	Austin	TX	78617	US	30.135637	-97.644048	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.527921	2021-08-16 15:35:38.296916
81	Lakeview Amphitheater	490 Restoration Way	Syracuse	NY	13209	US	43.088414	-76.222915	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.534731	2021-08-16 15:35:30.362551
82	CMAC	3355 Marvin Sands Dr	Canandaigua	NY	14424	US	42.866668	-77.243647	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.541466	2021-08-16 15:35:38.054647
83	Philips Arena	1 Philips Drive	Atlanta	GA	30303	US	33.757320	-84.394090	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.5489	2021-08-16 15:35:33.237477
84	Verizon Center	1 Verizon Arena Way	North Little Rock	AR	72114	US	34.765460	-92.265870	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.557071	2021-08-16 15:35:28.421092
85	PNC Banks Art Center	Exit 116, Garden State Parkway	Holmdel	NJ	07733	US	40.392582	-74.176899	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.563757	2021-08-16 15:35:31.371973
86	The Pavilion at Montage Mountain	1000 Montage Mountain Rd	Scranton	PA	18507	US	41.352785	-75.658616	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.57797	2021-08-16 15:35:37.375056
87	Prowse Farm	5 Blue Hill River Rd	Canton	MA	02021	US	42.206729	-71.114420	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:28.062237	2021-08-16 15:35:44.966158
88	MGM Grand Garden	3799 Las Vegas Blvd S	Las Vegas	NV	89109	US	36.103827	-115.167805	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.585439	2021-08-16 15:35:34.791248
89	Pier 70	420 22nd St	San Francisco	CA	94107	US	37.754200	-122.396240	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.59229	2021-08-16 15:35:29.011039
90	Busch Stadium	700 Clark Ave	Adrian	MO	63102	US	38.626960	-90.190750	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.600087	2021-08-16 15:35:33.736438
92	Wells Fargo Arena	233 Center St	Des Moines	IA	50309	US	41.592115	-93.620973	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.607742	2021-08-16 15:35:29.307268
93	Lakeside		Chicago	IL	60649	US	41.770000	-87.570000	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.614766	2021-08-16 15:35:39.98453
94	Centre Bell	1909, Avenue Des Canadiens-de-Montréal	Montreal	QC	H3C 5L2	CA	45.496039	-73.569438	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.622814	2021-08-16 15:35:37.152962
95	Principal Park	1 Line Dr	Des Moines	IA	50309	US	41.581522	-93.616962	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.630741	2021-08-16 15:35:28.06753
96	Irvine Meadows Amphitheatre	8808 Irvine Center Drive	Irvine	CA	92618	US	33.637964	-117.750233	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.637868	2021-08-16 15:36:10.550167
97	Bethel Woods Center for the Arts	200 Hurd Rd	Accord	NY	12720	US	41.697753	-74.880804	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.64521	2021-08-16 15:35:39.28168
98	Golden Gate Park		San Francisco	CA		US	37.764800	-122.463000	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.652929	2021-08-16 15:35:35.252032
99	PNC Park	115 Federal St	Pittsburgh	PA	15212	US	40.446967	-80.005825	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.660643	2021-08-16 15:35:35.751639
100	Sprint Center	1407 Grand Blvd	Kansas City	MO	64106	US	39.096800	-94.580680	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.668436	2021-08-16 15:35:34.036297
101	Beacon Theatre	2124 Broadway	New York	NY	10009	US	40.780473	-73.981170	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.675671	2021-08-16 15:35:37.844352
102	Save Mart Center	2650 E Shaw Ave	Fresno	CA	93710	US	36.809027	-119.739799	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.683004	2021-08-16 15:35:34.539379
103	Ak-Chin Pavilion	2121 N 83rd Ave	Phoenix	AZ	85035	US	33.470827	-112.232880	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.690909	2021-08-16 15:35:40.902069
104	Toyota Park	7000 Harlem Ave	Bridgeview	IL	60455	US	41.764860	-87.800670	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.699967	2021-08-16 15:35:30.932999
105	Coastal Credit Union Music Park	3801 Rock Quarry Road	Raleigh	NC	27610	US	35.750188	-78.578850	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.70794	2021-08-16 15:36:01.666376
106	Red Rocks Amphitheatre	18300 W Alameda Pkwy	Morrison	CO	80465	US	39.667694	-105.208936	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.71533	2021-08-16 15:35:36.898088
107	The Amphitheater At the Wharf	23325 Amphitheater Dr	Orange Beach	AL	36561	US	30.270000	-87.590000	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.72245	2021-08-16 15:35:32.147994
108	Erie Canal Harbor	44 Prime Street	Buffalo	NY	14202	US	42.881330	-78.877560	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.729487	2021-08-16 15:35:29.925639
109	Xcel Energy Center	 199 W Kellogg Blvd	Ada	MN	55102	US	44.943727	-93.094282	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.736639	2021-08-16 15:35:25.821417
110	Palatrussadri	Via Antonio Sant'Elia	Milan	25	33 20151	IT	45.487300	9.130105	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.743981	2021-08-16 15:35:27.285768
111	Jazz Fest		New Orleans	LA	70130	US	29.955372	-90.068445	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.752428	2021-08-16 15:35:28.689643
112	Hullabalou Festival	700 Central Ave	Louisville	KY	40215	US	38.204162	-85.771772	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.759896	2021-08-16 15:35:29.559617
113	Mitsubishi Electric Halle	Siegburger Str. 15	Düsseldorf	NW	40591	DE	51.206402	6.808941	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.7672	2021-08-16 15:35:40.200939
114	NBT Bank Stadium	1 Tex Simone Drive	Syracuse	NY	13208	US	43.077223	-76.167580	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.781747	2021-08-16 15:35:35.979274
115	Foro Sol	Av. Viaducto Río Piedad y Río Churubusco	Mexico City	CMX	08400	MX	19.400000	-99.090000	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.78882	2021-08-16 15:35:41.056147
116	Cricket Wireless Amphitheatre	633 N 130th St	Bonner Springs	KS	66012	US	39.112718	-94.876840	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.79584	2021-08-16 15:35:34.271355
117	Tempodrom	Möckernstraße 1	Berlin	BE	10963	DE	52.516670	13.383330	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.802899	2021-08-16 15:35:27.064338
118	SNHU Arena	555 Elm St	Manchester	NH	03101	US	42.986451	-71.461785	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.809844	2021-08-16 15:35:30.198688
119	Bank of New Hampshire Pavilion	72 Meadowbrook Ln	Gilford	NH	03249	US	43.579066	-71.415799	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.817031	2021-08-16 15:36:09.418006
120	Jahrhunderthalle	Pfaffenwiese 301	Frankfurt am Main	HE	65929	DE	50.099078	8.519066	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.824393	2021-08-16 15:35:26.134884
121	Kioene Arena	Via S. Marco, 53	Padova	34		IT	45.367478	12.012269	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.831981	2021-08-16 15:35:40.427437
122	Staples Center	1111 S Figueroa St	Los Angeles	CA	90015	US	34.043125	-118.267118	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.845384	2021-08-16 15:35:59.709724
123	10,000 Lakes Festival	500 Pass Ranch	Detroit Lakes	MN		US	46.817200	-95.845300	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.852406	2021-08-16 15:35:16.329927
124	HSBC Arena	Av. Embaixador Abelardo Bueno	Rio de Janeiro	RJ	22775	BR	-22.972870	-43.385168	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.859141	2021-08-16 15:35:42.033702
125	Vanderbilt Stadium	Jess Neely Dr	Nashville	TN	37203	US	36.141530	-86.808369	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.838674	2021-08-16 15:35:36.190678
126	Lotto Arena	Schijnpoortweg 119	Antwerp	VLG		BE	51.230236	4.441756	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.866094	2021-08-16 15:36:03.625583
127	Darling's Waterfront Pavillion	1 Railroad St	Bangor	ME	04401	US	44.793329	-68.774659	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.930221	2021-08-16 15:35:45.691348
128	Rogers Arena	800 Griffiths Way	Vancouver	BC	V6B 6G1	CA	49.277742	-123.108877	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.937731	2021-08-16 15:36:00.572079
129	First Niagara Center	1 Seymour H Knox III Plaza	Buffalo	NY	14203	US	42.875005	-78.876412	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.944838	2021-08-16 15:35:50.113676
130	3Arena	N Wall Quay	Dublin	L		IE	53.348091	-6.239544	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.953925	2021-08-16 15:35:44.076228
131	Jackson Square	700 Decatur St	New Orleans	LA	70116	US	29.957005	-90.062249	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.873575	2021-08-16 15:35:50.800112
132	Raley Field	400 Ballpark Dr	Sacramento	CA	95691	US	38.580203	-121.514039	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.961164	2021-08-16 15:35:48.912018
133	Hollywood Bowl	2301 Highland Avenue	Los Angeles	CA	90068	US	34.111258	-118.336438	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.968746	2021-08-16 15:35:46.664216
134	Forest National	Avenue Victor Rousseau 208	Brussels	BRU	1190	BE	50.809992	4.326016	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.880568	2021-08-16 15:35:54.868413
135	MEO Arena	Rossio dos Olivais	Lisbon	11	1990-231	PT	38.767556	-9.093749	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.976384	2021-08-16 15:35:58.520825
136	Chickasaw Bricktown Ballpark	2 S Mickey Mantle Dr	Oklahoma City	OK	73104	US	35.464959	-97.508260	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.983801	2021-08-16 15:35:51.651315
137	Le Zénith	211 Avenue Jean Jaurès	Paris	IDF		FR	48.690240	2.175993	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.991686	2021-08-16 15:35:56.919465
138	Hollywood Casino Amphitheatre	19100 Ridgeland Ave	Tinley Park	IL	60477	US	41.544431	-87.778399	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:28.008529	2021-08-16 15:35:45.199436
139	Pepsi Center	1000 Chopper Cir	Denver	CO	80204	US	39.746779	-105.011883	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.887175	2021-08-16 15:35:48.361477
140	Dick's Sporting Goods Park	6000 Victory Way	Commerce City	CO	80022	US	39.806332	-104.892140	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.893854	2021-08-16 15:36:11.055258
141	O2 Academy Birmingham	16-18 Horsefair	Birmingham	ENG	B1 1DB	GB	52.474504	-1.899896	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:28.015805	2021-08-16 15:35:44.770475
142	Germain Amphitheatre	2200 Polaris Parkway	Columbus	OH	43240	US	40.148973	-82.958412	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.901097	2021-08-16 15:35:49.383767
143	Piazza Napoleone	Piazza Napoleone	Lucca	52	55100	IT	43.841429	10.502531	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.90793	2021-08-16 15:35:57.351885
144	Starwood Amphitheatre	3839 Murfreesboro Rd	Nashville	TN	37013	US	36.038710	-86.607040	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.914916	2021-08-16 15:35:48.683883
145	Caribean Cruise		\N	\N		US	\N	\N	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:27.922225	2021-08-14 22:12:32.627979
146	Bryce Jordan Center	127 Bryce Jordan Center	University Park	PA	16802	US	40.808833	-77.855740	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:28.02405	2021-08-16 15:35:50.56318
147	Taco Bell Arena	1401 Bronco Lane	Boise	ID	83725	US	43.603640	-116.201300	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:28.031359	2021-08-16 15:35:48.121533
148	Congress Center Hamburg Hall 1	Am Dammtor / Marseiller Straße	Hamburg	HH	20355	DE	53.550000	10.000000	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:28.038907	2021-08-16 15:35:56.360237
149	Joe Louis Arena	19 Steve Yzerman Drive	Detroit	MI	48226	US	42.328780	-83.044920	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:28.046968	2021-08-16 15:35:49.882309
150	Citi Performing Arts Center	270 Tremont Street	Boston	MA	02116	US	42.350474	-71.064228	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:28.054068	2021-08-16 15:35:45.43679
151	AT&T Park	24 Willie Mays Plaza	San Francisco	CA	94107	US	37.778900	-122.390480	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:28.069912	2021-08-16 15:35:47.628587
152	Gasometer	Guglgasse 6	Vienna	9		AT	48.185545	16.418428	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:28.077819	2021-08-16 15:35:52.962288
153	Falkoner Center	Falkoner Alle 7	Copenhagen	84		DK	55.679459	12.533369	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:28.086507	2021-08-16 15:35:43.325503
154	Columbiahalle	Columbiadamm 13-21	Berlin	BE	10965	DE	52.516670	13.383330	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:28.094666	2021-08-16 15:36:01.233485
155	Wembley Arena	Arena Square, Engineers Way	London	ENG	HA9 0AA	GB	51.558277	-0.281430	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:28.10519	2021-08-16 15:35:54.721814
156	Palladium Cologne	Schanzenstraße 40	Cologne	NW	51063	DE	50.969479	7.017791	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:28.113464	2021-08-16 15:35:56.132393
157	The Times Union Center	51 S Pearl St	Albany	NY	12207	US	42.648250	-73.754816	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:28.12112	2021-08-16 15:35:45.911693
158	Scottish Exhibition and Conference Centre	Exhibition Way	Glasgow	SCT	G3 8YW	GB	55.860982	-4.248879	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:28.128685	2021-08-16 15:35:54.486169
159	Roseland Theatre	239 W 52nd S	New York	NY	10019	US	40.763230	-73.984230	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:28.135784	2021-08-16 15:35:51.438334
160	Sydney Entertainment Centre	35 Harbour St	Sydney	NSW		AU	-33.826345	151.239451	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:28.142928	2021-08-16 15:35:57.631122
161	Sidney Myer Music Bowl	Kings Domain Gardens	Melbourne	VIC	3000	AU	-37.823768	144.974628	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:28.150523	2021-08-16 15:55:01.680906
162	Dickey-Stephens Park	400 W Broadway St	North Little Rock	AR	72114	US	34.755862	-92.272880	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:28.158119	2021-08-16 15:35:46.129644
163	Bonnaroo Arts & Music Festival	Great Stage Park	Manchester	TN	37349	US	35.481677	-86.088610	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:28.165615	2021-08-16 15:35:52.247526
164	PalaLottomatica	Piazzale Pier Luigi Nervi	Rome	62	00144	IT	41.823984	12.465906	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:28.173388	2021-08-16 15:35:58.369813
165	DAR Constitution Hall	1776 D St NW	Washington	DC	20006	US	38.893966	-77.039999	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:28.180496	2021-08-16 15:35:46.902552
166	Zenith	Lilienthalallee 29	Munich	BY	80939	DE	48.194690	11.607848	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:28.189216	2021-08-16 15:35:55.872087
167	SWU Music & Arts		Itu	SP		BR	-23.263900	-47.298900	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:28.196926	2021-08-16 15:35:55.56433
168	Estadio Luna Park	Avenida Madero 420	San Nicolás de los Arroyos	B		AR	-34.602249	-58.368628	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:28.204799	2021-08-16 23:02:17.224237
169	Movistar Arena	Av. Beaucheff 1204	Santiago	RM		CL	-33.462303	-70.661172	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:28.212391	2021-08-16 15:35:42.698875
170	Toyota Amphitheatre	2677 Forty Mile Road	Wheatland	CA	95692	US	39.030752	-121.513136	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:28.220464	2021-08-16 15:35:49.178275
171	Huntington Park	330 Huntington Park Ln	Columbus	OH	43215	US	39.968106	-83.011955	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:28.228211	2021-08-16 15:35:52.732697
172	Verizon Wireless Arena at VCU	1200 West Broad Street	Richmond	VA	23284	US	37.539364	-77.430728	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:28.235894	2021-08-16 15:35:52.016873
173	Santa Barbara Bowl	1122 N Milpas St	Santa Barbara	CA	93103	US	34.433262	-119.693304	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:28.243277	2021-08-14 22:16:01.530923
174	Wiltern Theatre	3790 Wilshire Blvd	Los Angeles	CA	90010	US	34.061530	-118.308608	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:28.251073	2021-08-16 15:35:46.389319
175	Newcastle City Hall	100 Grey Street	Newcastle upon Tyne	ENG		GB	54.972689	-1.612454	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:28.258592	2021-08-16 15:36:08.768652
176	Smart Financial Centre at Sugar Land	18111 Lexington Blvd	Sugar Land	TX	77479	US	29.577028	-95.642550	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:28.265635	2021-08-16 15:35:52.474047
177	Verizon Theatre at Grand Prairie	1001 Performance Pl	Grand Prairie	TX	75050	US	32.766945	-96.983379	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:28.274719	2021-08-16 15:35:51.048061
178	Riviera Maya	Callle 5 Sur (Av. Apto.) Mz 29 Lt 3	Cancún	ROO	77710	MX	21.137850	-86.847500	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:28.282692	2021-08-20 00:27:46.498342
179	The Fox Theatre	1807 Telegraph Ave	Oakland	CA	94612	US	37.808087	-122.270640	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:28.290229	2021-08-16 15:35:47.15052
180	Okeechobee Music and Arts Festival	12517 NE 91ST Ave	Okeechobee	FL	34972	US	27.359491	-80.730703	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:28.297882	2021-08-16 15:35:47.411126
181	SXSW		Austin	TX	78701	US	30.270000	-97.740000	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:28.305651	2021-08-16 15:35:59.188124
182	Bojangles Coliseum	2700 East Independence Boulevard	Charlotte	NC	28205	US	35.204172	-80.795254	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:28.312615	2021-08-16 15:36:04.470004
183	Eventim Apollo	 45 Queen Caroline Street	London	ENG		GB	51.490521	-0.225492	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:28.319971	2021-08-16 15:35:57.115822
184	Royal Arena	Hannemanns Allé 18	Aabybro	81	2300	DK	57.162500	9.730560	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:28.327481	2021-08-16 15:36:01.455331
185	Olympia Theatre	72 Dame Street	Dublin	L		IE	53.344180	-6.266080	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:28.334969	2021-08-16 15:36:08.977175
186	De Oosterpoort	Trompsingel 27	Groningen	GR	9724	NL	53.214189	6.575594	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:28.342892	2021-08-16 15:36:06.455119
187	Knight Theatre	430 S Tryon Street	Charlotte	NC	28202	US	35.224683	-80.847785	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 16:58:28.350655	2021-08-16 15:36:02.96119
188	Irving Plaza	17 Irving Plaza	New York	NY	10003	US	40.734625	-73.988581	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 18:22:48.51958	2021-08-16 15:36:04.344776
189	Merriweather Post Pavillion	10475 Little Patuxent Pkwy	Columbia	MD	21044	US	39.208933	-76.862619	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 20:31:40.96198	2021-08-16 15:36:01.980703
190	Mann Center for the Performing Arts	5201 Parkside Ave	Philadelphia	PA	19131	US	39.990113	-75.221413	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 20:46:40.102277	2021-08-16 15:36:07.397833
191	Ascend Amphitheatre	301 1st Avenue S	Nashville	TN	37201	US	36.160239	-86.773107	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 20:49:38.421454	2021-08-16 15:36:06.982616
192	Daily's Place	1 EverBank Field	Jacksonville	FL	32202	US	30.324760	-81.638320	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 20:52:13.210552	2021-08-16 15:36:02.530958
193	Tuscaloosa Amphitheater	2710 Jack Warner Pkwy	Tuscaloosa	AL	35401	US	33.212409	-87.574460	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 20:54:50.425891	2021-08-16 15:36:03.419173
194	Huntington Bank Pavilion	1300 S Linn White Drive	Chicago	IL	60605	US	41.861580	-87.609250	\N	\N	\N	\N	other	active	\N	[]	2018-03-24 23:22:44.10478	2021-08-16 15:36:05.135764
195	Les Schwab Amphitheatre	344 SW Shevlin Hixon Dr	Bend	OR	97702	US	44.046513	-121.317995	\N	\N	\N	\N	other	active	\N	[]	2018-04-07 22:41:27.728553	2021-08-16 15:36:05.989458
196	Jacksonville Veterans Memorial Arena	300 A Philip Randolph Blvd	Jacksonville	FL	32202	US	30.326252	-81.645706	\N	\N	\N	\N	other	active	\N	[]	2018-04-08 02:05:25.17214	2021-08-16 15:36:05.263588
197	American Family Insurance Amphitheater	200 N Harbor Dr	Milwaukee	WI	53202	US	43.029190	-87.897809	\N	\N	\N	\N	other	active	\N	[]	2018-04-08 02:16:58.687764	2021-08-16 15:36:10.351934
198	The House of Blues	4640 Highway 17 S	North Myrtle Beach	SC	29582	US	33.799580	-78.736750	\N	\N	\N	\N	other	active	\N	[]	2018-04-08 03:26:49.617461	2021-08-16 15:36:04.721055
199	PNC Arena	1400 Edwards Mill Rd	Raleigh	NC	27607	US	35.803152	-78.723178	\N	\N	\N	\N	other	active	\N	[]	2018-05-06 13:24:48.539874	2021-08-16 15:36:00.289155
200	Air Canada Centre	40 Bay Street	Toronto	ON	M5J 2L2	CA	43.657283	-79.383897	\N	\N	\N	\N	other	active	\N	[]	2018-05-18 01:22:23.861374	2021-08-16 15:36:01.011341
201	Walmart Arkansas Music Pavilion	5079 W Northgate Rd	Rogers	AR	72758	US	36.302924	-94.183792	\N	\N	\N	\N	other	active	\N	[]	2018-06-02 02:44:17.162784	2021-08-16 15:36:03.861361
202	Brandon Amphitheater	8190 Rock Way	Brandon	MS	39042	US	32.275155	-90.023317	\N	\N	\N	\N	other	active	\N	[]	2018-06-02 02:46:16.038081	2021-08-16 15:36:00.166694
203	LeBreton Flats Park	Sir John A. Macdonald Parkway	Ottawa	ON	K1A 0M8	CA	45.396657	-75.762078	\N	\N	\N	\N	other	active	\N	[]	2018-07-12 11:24:42.991999	2021-08-16 15:36:05.768173
204	Festival d'été de Québec		Québec	QC		CA	46.816667	-71.216667	\N	\N	\N	\N	other	active	\N	[]	2018-07-16 14:14:59.362654	2021-08-16 15:36:09.245748
205	Scott Stadium	1815 Stadium Road	Charlottesville	VA	22903	US	38.030891	-78.514436	\N	\N	\N	\N	other	active	\N	[]	2018-07-22 15:31:35.380599	2021-08-16 15:35:59.94063
206	The Park At Harlinsdale Farm	239 Franklin Road	Franklin	TN	37064	US	35.934768	-86.861359	\N	\N	\N	\N	other	active	\N	[]	2018-09-23 23:20:38.229709	2021-08-16 15:36:07.152811
207	Jerome Schottenstein Center	555 Borror Drive	Columbus	OH	43210	US	40.007589	-83.025030	\N	\N	\N	\N	other	active	\N	[]	2018-12-01 18:25:04.211467	2021-08-16 15:36:05.511311
208	Mohegan Sun Arena	1 Mohegan Sun Boulevard	Uncasville	CT	06382	US	41.489590	-72.089130	\N	\N	\N	\N	other	active	\N	[]	2018-12-04 23:26:30.11123	2021-08-16 15:35:12.974242
209	Salle Pleyel	252 rue du Faubourg Saint-Honor	Paris	IDF		FR	48.849007	2.390791	\N	\N	\N	\N	other	active	\N	[]	2019-03-12 12:49:23.113795	2021-08-16 15:35:40.658606
210	Credit One Stadium	161 Seven Farms Road	Charleston	SC	29492	US	32.861480	-79.901640	\N	\N	\N	\N	other	active	\N	[]	2021-08-03 12:54:32.534556	2021-08-16 15:35:59.4603
211	Pensacola Bay Center	201 E Gregory Street	Pensacola	FL	32502	US	30.416362	-87.208459	\N	\N	\N	\N	other	active	\N	[]	2021-08-23 23:09:49.796432	2021-08-23 23:09:49.796432
212	The Grounds at Keeneland	4201 Versailles Road	Lexington	KY	40510	US	38.045741	-84.602652	\N	\N	\N	\N	other	active	\N	[]	2021-08-30 12:12:29.948961	2021-08-30 12:12:29.948961
\.


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: roberttaylor
--

SELECT pg_catalog.setval('public.active_storage_attachments_id_seq', 1, false);


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: roberttaylor
--

SELECT pg_catalog.setval('public.active_storage_blobs_id_seq', 1, false);


--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE SET; Schema: public; Owner: roberttaylor
--

SELECT pg_catalog.setval('public.active_storage_variant_records_id_seq', 1, false);


--
-- Name: artists_id_seq; Type: SEQUENCE SET; Schema: public; Owner: roberttaylor
--

SELECT pg_catalog.setval('public.artists_id_seq', 1, false);


--
-- Name: artists_posters_id_seq; Type: SEQUENCE SET; Schema: public; Owner: roberttaylor
--

SELECT pg_catalog.setval('public.artists_posters_id_seq', 775, true);


--
-- Name: bands_id_seq; Type: SEQUENCE SET; Schema: public; Owner: roberttaylor
--

SELECT pg_catalog.setval('public.bands_id_seq', 1, false);


--
-- Name: poster_slug_redirects_id_seq; Type: SEQUENCE SET; Schema: public; Owner: roberttaylor
--

SELECT pg_catalog.setval('public.poster_slug_redirects_id_seq', 1, false);


--
-- Name: posters_id_seq; Type: SEQUENCE SET; Schema: public; Owner: roberttaylor
--

SELECT pg_catalog.setval('public.posters_id_seq', 1, false);


--
-- Name: search_analytics_id_seq; Type: SEQUENCE SET; Schema: public; Owner: roberttaylor
--

SELECT pg_catalog.setval('public.search_analytics_id_seq', 1, false);


--
-- Name: search_shares_id_seq; Type: SEQUENCE SET; Schema: public; Owner: roberttaylor
--

SELECT pg_catalog.setval('public.search_shares_id_seq', 1, false);


--
-- Name: series_id_seq; Type: SEQUENCE SET; Schema: public; Owner: roberttaylor
--

SELECT pg_catalog.setval('public.series_id_seq', 1, false);


--
-- Name: solid_cable_messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: roberttaylor
--

SELECT pg_catalog.setval('public.solid_cable_messages_id_seq', 1, false);


--
-- Name: solid_cache_entries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: roberttaylor
--

SELECT pg_catalog.setval('public.solid_cache_entries_id_seq', 1, false);


--
-- Name: solid_queue_blocked_executions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: roberttaylor
--

SELECT pg_catalog.setval('public.solid_queue_blocked_executions_id_seq', 1, false);


--
-- Name: solid_queue_claimed_executions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: roberttaylor
--

SELECT pg_catalog.setval('public.solid_queue_claimed_executions_id_seq', 1, false);


--
-- Name: solid_queue_failed_executions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: roberttaylor
--

SELECT pg_catalog.setval('public.solid_queue_failed_executions_id_seq', 1, false);


--
-- Name: solid_queue_jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: roberttaylor
--

SELECT pg_catalog.setval('public.solid_queue_jobs_id_seq', 1, false);


--
-- Name: solid_queue_pauses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: roberttaylor
--

SELECT pg_catalog.setval('public.solid_queue_pauses_id_seq', 1, false);


--
-- Name: solid_queue_processes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: roberttaylor
--

SELECT pg_catalog.setval('public.solid_queue_processes_id_seq', 1, false);


--
-- Name: solid_queue_ready_executions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: roberttaylor
--

SELECT pg_catalog.setval('public.solid_queue_ready_executions_id_seq', 1, false);


--
-- Name: solid_queue_recurring_executions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: roberttaylor
--

SELECT pg_catalog.setval('public.solid_queue_recurring_executions_id_seq', 1, false);


--
-- Name: solid_queue_recurring_tasks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: roberttaylor
--

SELECT pg_catalog.setval('public.solid_queue_recurring_tasks_id_seq', 1, false);


--
-- Name: solid_queue_scheduled_executions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: roberttaylor
--

SELECT pg_catalog.setval('public.solid_queue_scheduled_executions_id_seq', 1, false);


--
-- Name: solid_queue_semaphores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: roberttaylor
--

SELECT pg_catalog.setval('public.solid_queue_semaphores_id_seq', 1, false);


--
-- Name: user_posters_id_seq; Type: SEQUENCE SET; Schema: public; Owner: roberttaylor
--

SELECT pg_catalog.setval('public.user_posters_id_seq', 374, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: roberttaylor
--

SELECT pg_catalog.setval('public.users_id_seq', 1, false);


--
-- Name: venues_id_seq; Type: SEQUENCE SET; Schema: public; Owner: roberttaylor
--

SELECT pg_catalog.setval('public.venues_id_seq', 1, false);


--
-- Name: active_storage_attachments active_storage_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT active_storage_attachments_pkey PRIMARY KEY (id);


--
-- Name: active_storage_blobs active_storage_blobs_pkey; Type: CONSTRAINT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.active_storage_blobs
    ADD CONSTRAINT active_storage_blobs_pkey PRIMARY KEY (id);


--
-- Name: active_storage_variant_records active_storage_variant_records_pkey; Type: CONSTRAINT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT active_storage_variant_records_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: artists artists_pkey; Type: CONSTRAINT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.artists
    ADD CONSTRAINT artists_pkey PRIMARY KEY (id);


--
-- Name: artists_posters artists_posters_pkey; Type: CONSTRAINT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.artists_posters
    ADD CONSTRAINT artists_posters_pkey PRIMARY KEY (id);


--
-- Name: bands bands_pkey; Type: CONSTRAINT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.bands
    ADD CONSTRAINT bands_pkey PRIMARY KEY (id);


--
-- Name: poster_slug_redirects poster_slug_redirects_pkey; Type: CONSTRAINT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.poster_slug_redirects
    ADD CONSTRAINT poster_slug_redirects_pkey PRIMARY KEY (id);


--
-- Name: posters posters_pkey; Type: CONSTRAINT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.posters
    ADD CONSTRAINT posters_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: search_analytics search_analytics_pkey; Type: CONSTRAINT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.search_analytics
    ADD CONSTRAINT search_analytics_pkey PRIMARY KEY (id);


--
-- Name: search_shares search_shares_pkey; Type: CONSTRAINT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.search_shares
    ADD CONSTRAINT search_shares_pkey PRIMARY KEY (id);


--
-- Name: series series_pkey; Type: CONSTRAINT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.series
    ADD CONSTRAINT series_pkey PRIMARY KEY (id);


--
-- Name: solid_cable_messages solid_cable_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.solid_cable_messages
    ADD CONSTRAINT solid_cable_messages_pkey PRIMARY KEY (id);


--
-- Name: solid_cache_entries solid_cache_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.solid_cache_entries
    ADD CONSTRAINT solid_cache_entries_pkey PRIMARY KEY (id);


--
-- Name: solid_queue_blocked_executions solid_queue_blocked_executions_pkey; Type: CONSTRAINT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.solid_queue_blocked_executions
    ADD CONSTRAINT solid_queue_blocked_executions_pkey PRIMARY KEY (id);


--
-- Name: solid_queue_claimed_executions solid_queue_claimed_executions_pkey; Type: CONSTRAINT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.solid_queue_claimed_executions
    ADD CONSTRAINT solid_queue_claimed_executions_pkey PRIMARY KEY (id);


--
-- Name: solid_queue_failed_executions solid_queue_failed_executions_pkey; Type: CONSTRAINT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.solid_queue_failed_executions
    ADD CONSTRAINT solid_queue_failed_executions_pkey PRIMARY KEY (id);


--
-- Name: solid_queue_jobs solid_queue_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.solid_queue_jobs
    ADD CONSTRAINT solid_queue_jobs_pkey PRIMARY KEY (id);


--
-- Name: solid_queue_pauses solid_queue_pauses_pkey; Type: CONSTRAINT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.solid_queue_pauses
    ADD CONSTRAINT solid_queue_pauses_pkey PRIMARY KEY (id);


--
-- Name: solid_queue_processes solid_queue_processes_pkey; Type: CONSTRAINT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.solid_queue_processes
    ADD CONSTRAINT solid_queue_processes_pkey PRIMARY KEY (id);


--
-- Name: solid_queue_ready_executions solid_queue_ready_executions_pkey; Type: CONSTRAINT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.solid_queue_ready_executions
    ADD CONSTRAINT solid_queue_ready_executions_pkey PRIMARY KEY (id);


--
-- Name: solid_queue_recurring_executions solid_queue_recurring_executions_pkey; Type: CONSTRAINT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.solid_queue_recurring_executions
    ADD CONSTRAINT solid_queue_recurring_executions_pkey PRIMARY KEY (id);


--
-- Name: solid_queue_recurring_tasks solid_queue_recurring_tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.solid_queue_recurring_tasks
    ADD CONSTRAINT solid_queue_recurring_tasks_pkey PRIMARY KEY (id);


--
-- Name: solid_queue_scheduled_executions solid_queue_scheduled_executions_pkey; Type: CONSTRAINT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.solid_queue_scheduled_executions
    ADD CONSTRAINT solid_queue_scheduled_executions_pkey PRIMARY KEY (id);


--
-- Name: solid_queue_semaphores solid_queue_semaphores_pkey; Type: CONSTRAINT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.solid_queue_semaphores
    ADD CONSTRAINT solid_queue_semaphores_pkey PRIMARY KEY (id);


--
-- Name: user_posters user_posters_pkey; Type: CONSTRAINT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.user_posters
    ADD CONSTRAINT user_posters_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: venues venues_pkey; Type: CONSTRAINT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.venues
    ADD CONSTRAINT venues_pkey PRIMARY KEY (id);


--
-- Name: index_active_storage_attachments_on_blob_id; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_active_storage_attachments_on_blob_id ON public.active_storage_attachments USING btree (blob_id);


--
-- Name: index_active_storage_attachments_uniqueness; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE UNIQUE INDEX index_active_storage_attachments_uniqueness ON public.active_storage_attachments USING btree (record_type, record_id, name, blob_id);


--
-- Name: index_active_storage_blobs_on_key; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE UNIQUE INDEX index_active_storage_blobs_on_key ON public.active_storage_blobs USING btree (key);


--
-- Name: index_active_storage_variant_records_uniqueness; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE UNIQUE INDEX index_active_storage_variant_records_uniqueness ON public.active_storage_variant_records USING btree (blob_id, variation_digest);


--
-- Name: index_artists_on_name; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE UNIQUE INDEX index_artists_on_name ON public.artists USING btree (name);


--
-- Name: index_artists_posters_on_artist_id; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_artists_posters_on_artist_id ON public.artists_posters USING btree (artist_id);


--
-- Name: index_artists_posters_on_artist_id_and_poster_id; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE UNIQUE INDEX index_artists_posters_on_artist_id_and_poster_id ON public.artists_posters USING btree (artist_id, poster_id);


--
-- Name: index_artists_posters_on_poster_id; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_artists_posters_on_poster_id ON public.artists_posters USING btree (poster_id);


--
-- Name: index_artists_posters_on_poster_id_and_artist_id; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_artists_posters_on_poster_id_and_artist_id ON public.artists_posters USING btree (poster_id, artist_id);


--
-- Name: index_bands_on_name; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE UNIQUE INDEX index_bands_on_name ON public.bands USING btree (name);


--
-- Name: index_poster_slug_redirects_on_old_slug; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE UNIQUE INDEX index_poster_slug_redirects_on_old_slug ON public.poster_slug_redirects USING btree (old_slug);


--
-- Name: index_poster_slug_redirects_on_poster_id; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_poster_slug_redirects_on_poster_id ON public.poster_slug_redirects USING btree (poster_id);


--
-- Name: index_posters_on_band_id; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_posters_on_band_id ON public.posters USING btree (band_id);


--
-- Name: index_posters_on_band_id_and_release_date; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_posters_on_band_id_and_release_date ON public.posters USING btree (band_id, release_date);


--
-- Name: index_posters_on_band_id_and_venue_id; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_posters_on_band_id_and_venue_id ON public.posters USING btree (band_id, venue_id);


--
-- Name: index_posters_on_description; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_posters_on_description ON public.posters USING gin (description public.gin_trgm_ops);


--
-- Name: index_posters_on_name; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_posters_on_name ON public.posters USING btree (name);


--
-- Name: index_posters_on_name_gin; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_posters_on_name_gin ON public.posters USING gin (name public.gin_trgm_ops);


--
-- Name: index_posters_on_release_date; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_posters_on_release_date ON public.posters USING btree (release_date);


--
-- Name: index_posters_on_release_date_and_band_id; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_posters_on_release_date_and_band_id ON public.posters USING btree (release_date, band_id);


--
-- Name: index_posters_on_slug; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE UNIQUE INDEX index_posters_on_slug ON public.posters USING btree (slug);


--
-- Name: index_posters_on_venue_id; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_posters_on_venue_id ON public.posters USING btree (venue_id);


--
-- Name: index_posters_on_venue_id_and_release_date; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_posters_on_venue_id_and_release_date ON public.posters USING btree (venue_id, release_date);


--
-- Name: index_posters_on_year; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_posters_on_year ON public.posters USING btree (EXTRACT(year FROM release_date));


--
-- Name: index_posters_series_on_poster_id_and_series_id; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE UNIQUE INDEX index_posters_series_on_poster_id_and_series_id ON public.posters_series USING btree (poster_id, series_id);


--
-- Name: index_posters_series_on_series_id_and_poster_id; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_posters_series_on_series_id_and_poster_id ON public.posters_series USING btree (series_id, poster_id);


--
-- Name: index_search_analytics_on_performed_at; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_search_analytics_on_performed_at ON public.search_analytics USING btree (performed_at);


--
-- Name: index_search_analytics_on_query; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_search_analytics_on_query ON public.search_analytics USING btree (query);


--
-- Name: index_search_analytics_on_query_and_performed_at; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_search_analytics_on_query_and_performed_at ON public.search_analytics USING btree (query, performed_at);


--
-- Name: index_search_analytics_on_user_id; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_search_analytics_on_user_id ON public.search_analytics USING btree (user_id);


--
-- Name: index_search_shares_on_expires_at; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_search_shares_on_expires_at ON public.search_shares USING btree (expires_at);


--
-- Name: index_search_shares_on_token; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE UNIQUE INDEX index_search_shares_on_token ON public.search_shares USING btree (token);


--
-- Name: index_search_shares_on_token_and_expires_at; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_search_shares_on_token_and_expires_at ON public.search_shares USING btree (token, expires_at);


--
-- Name: index_series_on_name; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_series_on_name ON public.series USING btree (name);


--
-- Name: index_series_on_year; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_series_on_year ON public.series USING btree (year);


--
-- Name: index_solid_cable_messages_on_channel; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_solid_cable_messages_on_channel ON public.solid_cable_messages USING btree (channel);


--
-- Name: index_solid_cable_messages_on_channel_hash; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_solid_cable_messages_on_channel_hash ON public.solid_cable_messages USING btree (channel_hash);


--
-- Name: index_solid_cable_messages_on_created_at; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_solid_cable_messages_on_created_at ON public.solid_cable_messages USING btree (created_at);


--
-- Name: index_solid_cache_entries_on_byte_size; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_solid_cache_entries_on_byte_size ON public.solid_cache_entries USING btree (byte_size);


--
-- Name: index_solid_cache_entries_on_key_hash; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE UNIQUE INDEX index_solid_cache_entries_on_key_hash ON public.solid_cache_entries USING btree (key_hash);


--
-- Name: index_solid_cache_entries_on_key_hash_and_byte_size; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_solid_cache_entries_on_key_hash_and_byte_size ON public.solid_cache_entries USING btree (key_hash, byte_size);


--
-- Name: index_solid_queue_blocked_executions_for_maintenance; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_solid_queue_blocked_executions_for_maintenance ON public.solid_queue_blocked_executions USING btree (expires_at, concurrency_key);


--
-- Name: index_solid_queue_blocked_executions_for_release; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_solid_queue_blocked_executions_for_release ON public.solid_queue_blocked_executions USING btree (concurrency_key, priority, job_id);


--
-- Name: index_solid_queue_blocked_executions_on_job_id; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE UNIQUE INDEX index_solid_queue_blocked_executions_on_job_id ON public.solid_queue_blocked_executions USING btree (job_id);


--
-- Name: index_solid_queue_claimed_executions_on_job_id; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE UNIQUE INDEX index_solid_queue_claimed_executions_on_job_id ON public.solid_queue_claimed_executions USING btree (job_id);


--
-- Name: index_solid_queue_claimed_executions_on_process_id_and_job_id; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_solid_queue_claimed_executions_on_process_id_and_job_id ON public.solid_queue_claimed_executions USING btree (process_id, job_id);


--
-- Name: index_solid_queue_dispatch_all; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_solid_queue_dispatch_all ON public.solid_queue_scheduled_executions USING btree (scheduled_at, priority, job_id);


--
-- Name: index_solid_queue_failed_executions_on_job_id; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE UNIQUE INDEX index_solid_queue_failed_executions_on_job_id ON public.solid_queue_failed_executions USING btree (job_id);


--
-- Name: index_solid_queue_jobs_for_alerting; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_solid_queue_jobs_for_alerting ON public.solid_queue_jobs USING btree (scheduled_at, finished_at);


--
-- Name: index_solid_queue_jobs_for_filtering; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_solid_queue_jobs_for_filtering ON public.solid_queue_jobs USING btree (queue_name, finished_at);


--
-- Name: index_solid_queue_jobs_on_active_job_id; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_solid_queue_jobs_on_active_job_id ON public.solid_queue_jobs USING btree (active_job_id);


--
-- Name: index_solid_queue_jobs_on_class_name; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_solid_queue_jobs_on_class_name ON public.solid_queue_jobs USING btree (class_name);


--
-- Name: index_solid_queue_jobs_on_finished_at; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_solid_queue_jobs_on_finished_at ON public.solid_queue_jobs USING btree (finished_at);


--
-- Name: index_solid_queue_pauses_on_queue_name; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE UNIQUE INDEX index_solid_queue_pauses_on_queue_name ON public.solid_queue_pauses USING btree (queue_name);


--
-- Name: index_solid_queue_poll_all; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_solid_queue_poll_all ON public.solid_queue_ready_executions USING btree (priority, job_id);


--
-- Name: index_solid_queue_poll_by_queue; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_solid_queue_poll_by_queue ON public.solid_queue_ready_executions USING btree (queue_name, priority, job_id);


--
-- Name: index_solid_queue_processes_on_last_heartbeat_at; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_solid_queue_processes_on_last_heartbeat_at ON public.solid_queue_processes USING btree (last_heartbeat_at);


--
-- Name: index_solid_queue_processes_on_name_and_supervisor_id; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE UNIQUE INDEX index_solid_queue_processes_on_name_and_supervisor_id ON public.solid_queue_processes USING btree (name, supervisor_id);


--
-- Name: index_solid_queue_processes_on_supervisor_id; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_solid_queue_processes_on_supervisor_id ON public.solid_queue_processes USING btree (supervisor_id);


--
-- Name: index_solid_queue_ready_executions_on_job_id; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE UNIQUE INDEX index_solid_queue_ready_executions_on_job_id ON public.solid_queue_ready_executions USING btree (job_id);


--
-- Name: index_solid_queue_recurring_executions_on_job_id; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE UNIQUE INDEX index_solid_queue_recurring_executions_on_job_id ON public.solid_queue_recurring_executions USING btree (job_id);


--
-- Name: index_solid_queue_recurring_executions_on_task_key_and_run_at; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE UNIQUE INDEX index_solid_queue_recurring_executions_on_task_key_and_run_at ON public.solid_queue_recurring_executions USING btree (task_key, run_at);


--
-- Name: index_solid_queue_recurring_tasks_on_key; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE UNIQUE INDEX index_solid_queue_recurring_tasks_on_key ON public.solid_queue_recurring_tasks USING btree (key);


--
-- Name: index_solid_queue_recurring_tasks_on_static; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_solid_queue_recurring_tasks_on_static ON public.solid_queue_recurring_tasks USING btree (static);


--
-- Name: index_solid_queue_scheduled_executions_on_job_id; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE UNIQUE INDEX index_solid_queue_scheduled_executions_on_job_id ON public.solid_queue_scheduled_executions USING btree (job_id);


--
-- Name: index_solid_queue_semaphores_on_expires_at; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_solid_queue_semaphores_on_expires_at ON public.solid_queue_semaphores USING btree (expires_at);


--
-- Name: index_solid_queue_semaphores_on_key; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE UNIQUE INDEX index_solid_queue_semaphores_on_key ON public.solid_queue_semaphores USING btree (key);


--
-- Name: index_solid_queue_semaphores_on_key_and_value; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_solid_queue_semaphores_on_key_and_value ON public.solid_queue_semaphores USING btree (key, value);


--
-- Name: index_user_posters_on_for_sale; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_user_posters_on_for_sale ON public.user_posters USING btree (for_sale);


--
-- Name: index_user_posters_on_poster_id; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_user_posters_on_poster_id ON public.user_posters USING btree (poster_id);


--
-- Name: index_user_posters_on_status; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_user_posters_on_status ON public.user_posters USING btree (status);


--
-- Name: index_user_posters_on_user_id; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_user_posters_on_user_id ON public.user_posters USING btree (user_id);


--
-- Name: index_user_posters_on_user_id_and_poster_id; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_user_posters_on_user_id_and_poster_id ON public.user_posters USING btree (user_id, poster_id);


--
-- Name: index_users_on_collector_since; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_users_on_collector_since ON public.users USING btree (collector_since);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON public.users USING btree (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_location; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_users_on_location ON public.users USING btree (location);


--
-- Name: index_users_on_otp_secret_key; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE UNIQUE INDEX index_users_on_otp_secret_key ON public.users USING btree (otp_secret_key);


--
-- Name: index_users_on_provider_and_uid; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE UNIQUE INDEX index_users_on_provider_and_uid ON public.users USING btree (provider, uid);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: index_venues_on_city_and_administrative_area; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_venues_on_city_and_administrative_area ON public.venues USING btree (city, administrative_area);


--
-- Name: index_venues_on_country; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_venues_on_country ON public.venues USING btree (country);


--
-- Name: index_venues_on_latitude_and_longitude; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_venues_on_latitude_and_longitude ON public.venues USING btree (latitude, longitude);


--
-- Name: index_venues_on_name; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_venues_on_name ON public.venues USING btree (name);


--
-- Name: index_venues_on_status; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_venues_on_status ON public.venues USING btree (status);


--
-- Name: index_venues_on_venue_type; Type: INDEX; Schema: public; Owner: roberttaylor
--

CREATE INDEX index_venues_on_venue_type ON public.venues USING btree (venue_type);


--
-- Name: poster_slug_redirects fk_rails_03a82ed6ac; Type: FK CONSTRAINT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.poster_slug_redirects
    ADD CONSTRAINT fk_rails_03a82ed6ac FOREIGN KEY (poster_id) REFERENCES public.posters(id);


--
-- Name: posters fk_rails_12167a338b; Type: FK CONSTRAINT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.posters
    ADD CONSTRAINT fk_rails_12167a338b FOREIGN KEY (band_id) REFERENCES public.bands(id);


--
-- Name: posters_series fk_rails_1bb950b5d5; Type: FK CONSTRAINT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.posters_series
    ADD CONSTRAINT fk_rails_1bb950b5d5 FOREIGN KEY (poster_id) REFERENCES public.posters(id);


--
-- Name: posters fk_rails_2f41b9b8d4; Type: FK CONSTRAINT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.posters
    ADD CONSTRAINT fk_rails_2f41b9b8d4 FOREIGN KEY (venue_id) REFERENCES public.venues(id);


--
-- Name: solid_queue_recurring_executions fk_rails_318a5533ed; Type: FK CONSTRAINT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.solid_queue_recurring_executions
    ADD CONSTRAINT fk_rails_318a5533ed FOREIGN KEY (job_id) REFERENCES public.solid_queue_jobs(id) ON DELETE CASCADE;


--
-- Name: solid_queue_failed_executions fk_rails_39bbc7a631; Type: FK CONSTRAINT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.solid_queue_failed_executions
    ADD CONSTRAINT fk_rails_39bbc7a631 FOREIGN KEY (job_id) REFERENCES public.solid_queue_jobs(id) ON DELETE CASCADE;


--
-- Name: solid_queue_blocked_executions fk_rails_4cd34e2228; Type: FK CONSTRAINT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.solid_queue_blocked_executions
    ADD CONSTRAINT fk_rails_4cd34e2228 FOREIGN KEY (job_id) REFERENCES public.solid_queue_jobs(id) ON DELETE CASCADE;


--
-- Name: user_posters fk_rails_5be0f84a81; Type: FK CONSTRAINT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.user_posters
    ADD CONSTRAINT fk_rails_5be0f84a81 FOREIGN KEY (poster_id) REFERENCES public.posters(id);


--
-- Name: artists_posters fk_rails_5fd3587a0e; Type: FK CONSTRAINT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.artists_posters
    ADD CONSTRAINT fk_rails_5fd3587a0e FOREIGN KEY (artist_id) REFERENCES public.artists(id);


--
-- Name: solid_queue_ready_executions fk_rails_81fcbd66af; Type: FK CONSTRAINT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.solid_queue_ready_executions
    ADD CONSTRAINT fk_rails_81fcbd66af FOREIGN KEY (job_id) REFERENCES public.solid_queue_jobs(id) ON DELETE CASCADE;


--
-- Name: search_analytics fk_rails_8cc6046cd3; Type: FK CONSTRAINT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.search_analytics
    ADD CONSTRAINT fk_rails_8cc6046cd3 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: active_storage_variant_records fk_rails_993965df05; Type: FK CONSTRAINT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT fk_rails_993965df05 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: solid_queue_claimed_executions fk_rails_9cfe4d4944; Type: FK CONSTRAINT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.solid_queue_claimed_executions
    ADD CONSTRAINT fk_rails_9cfe4d4944 FOREIGN KEY (job_id) REFERENCES public.solid_queue_jobs(id) ON DELETE CASCADE;


--
-- Name: posters_series fk_rails_a2b1295796; Type: FK CONSTRAINT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.posters_series
    ADD CONSTRAINT fk_rails_a2b1295796 FOREIGN KEY (series_id) REFERENCES public.series(id);


--
-- Name: active_storage_attachments fk_rails_c3b3935057; Type: FK CONSTRAINT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT fk_rails_c3b3935057 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: solid_queue_scheduled_executions fk_rails_c4316f352d; Type: FK CONSTRAINT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.solid_queue_scheduled_executions
    ADD CONSTRAINT fk_rails_c4316f352d FOREIGN KEY (job_id) REFERENCES public.solid_queue_jobs(id) ON DELETE CASCADE;


--
-- Name: artists_posters fk_rails_c602f2837a; Type: FK CONSTRAINT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.artists_posters
    ADD CONSTRAINT fk_rails_c602f2837a FOREIGN KEY (poster_id) REFERENCES public.posters(id);


--
-- Name: user_posters fk_rails_e893477ec4; Type: FK CONSTRAINT; Schema: public; Owner: roberttaylor
--

ALTER TABLE ONLY public.user_posters
    ADD CONSTRAINT fk_rails_e893477ec4 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

