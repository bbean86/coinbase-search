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
-- Name: fuzzystrmatch; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS fuzzystrmatch WITH SCHEMA public;


--
-- Name: EXTENSION fuzzystrmatch; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- Name: pg_search_dmetaphone(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.pg_search_dmetaphone(text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT array_to_string(ARRAY(SELECT dmetaphone(unnest(regexp_split_to_array($1, E'\\s+')))), ' ') $_$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: coinbase_currencies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.coinbase_currencies (
    id bigint NOT NULL,
    name character varying NOT NULL,
    symbol character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: coinbase_currencies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.coinbase_currencies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: coinbase_currencies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.coinbase_currencies_id_seq OWNED BY public.coinbase_currencies.id;


--
-- Name: coinbase_pairs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.coinbase_pairs (
    id bigint NOT NULL,
    symbols character varying NOT NULL,
    base_currency_id bigint NOT NULL,
    quote_currency_id bigint NOT NULL,
    status character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: coinbase_pairs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.coinbase_pairs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: coinbase_pairs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.coinbase_pairs_id_seq OWNED BY public.coinbase_pairs.id;


--
-- Name: coinbase_rates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.coinbase_rates (
    id bigint NOT NULL,
    pair_id bigint NOT NULL,
    "time" timestamp without time zone,
    low numeric,
    high numeric,
    open numeric,
    close numeric,
    volume numeric,
    "interval" integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: coinbase_rates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.coinbase_rates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: coinbase_rates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.coinbase_rates_id_seq OWNED BY public.coinbase_rates.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: searches; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.searches (
    id bigint NOT NULL,
    query_params jsonb NOT NULL,
    search_type character varying NOT NULL,
    result jsonb,
    expires_at timestamp without time zone NOT NULL,
    cursor character varying,
    sort character varying,
    "limit" integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: searches_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.searches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: searches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.searches_id_seq OWNED BY public.searches.id;


--
-- Name: coinbase_currencies id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coinbase_currencies ALTER COLUMN id SET DEFAULT nextval('public.coinbase_currencies_id_seq'::regclass);


--
-- Name: coinbase_pairs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coinbase_pairs ALTER COLUMN id SET DEFAULT nextval('public.coinbase_pairs_id_seq'::regclass);


--
-- Name: coinbase_rates id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coinbase_rates ALTER COLUMN id SET DEFAULT nextval('public.coinbase_rates_id_seq'::regclass);


--
-- Name: searches id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.searches ALTER COLUMN id SET DEFAULT nextval('public.searches_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: coinbase_currencies coinbase_currencies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coinbase_currencies
    ADD CONSTRAINT coinbase_currencies_pkey PRIMARY KEY (id);


--
-- Name: coinbase_pairs coinbase_pairs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coinbase_pairs
    ADD CONSTRAINT coinbase_pairs_pkey PRIMARY KEY (id);


--
-- Name: coinbase_rates coinbase_rates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coinbase_rates
    ADD CONSTRAINT coinbase_rates_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: searches searches_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.searches
    ADD CONSTRAINT searches_pkey PRIMARY KEY (id);


--
-- Name: idx_searches_on_multiple_columns; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_searches_on_multiple_columns ON public.searches USING btree (query_params, search_type, cursor, "limit", sort);


--
-- Name: index_coinbase_currencies_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_coinbase_currencies_on_name ON public.coinbase_currencies USING btree (name);


--
-- Name: index_coinbase_pairs_on_base_currency_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_coinbase_pairs_on_base_currency_id ON public.coinbase_pairs USING btree (base_currency_id);


--
-- Name: index_coinbase_pairs_on_quote_currency_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_coinbase_pairs_on_quote_currency_id ON public.coinbase_pairs USING btree (quote_currency_id);


--
-- Name: index_coinbase_rates_on_pair_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_coinbase_rates_on_pair_id ON public.coinbase_rates USING btree (pair_id);


--
-- Name: index_coinbase_rates_on_time_and_interval; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_coinbase_rates_on_time_and_interval ON public.coinbase_rates USING btree ("time", "interval");


--
-- Name: coinbase_pairs fk_rails_47856eb3e3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coinbase_pairs
    ADD CONSTRAINT fk_rails_47856eb3e3 FOREIGN KEY (quote_currency_id) REFERENCES public.coinbase_currencies(id);


--
-- Name: coinbase_rates fk_rails_7a1c561627; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coinbase_rates
    ADD CONSTRAINT fk_rails_7a1c561627 FOREIGN KEY (pair_id) REFERENCES public.coinbase_pairs(id);


--
-- Name: coinbase_pairs fk_rails_b5b3a8ce9c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coinbase_pairs
    ADD CONSTRAINT fk_rails_b5b3a8ce9c FOREIGN KEY (base_currency_id) REFERENCES public.coinbase_currencies(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20210123134457'),
('20210123182136'),
('20210123184318'),
('20210123185328'),
('20210124005425'),
('20210124220943');


