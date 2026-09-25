--
-- PostgreSQL database dump
--

-- Dumped from database version 13.14 (Debian 13.14-1.pgdg120+2)
-- Dumped by pg_dump version 13.14 (Debian 13.14-1.pgdg120+2)

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
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA extensions;


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: getnextid(character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.getnextid(character varying) RETURNS integer
    LANGUAGE sql
    AS $_$SELECT CAST (nextval($1 || '_seq') AS INTEGER) AS RESULT;$_$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: bitstream; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bitstream (
    bitstream_id integer,
    bitstream_format_id integer,
    checksum character varying(64),
    checksum_algorithm character varying(32),
    internal_id character varying(256),
    deleted boolean,
    store_number integer,
    sequence_id integer,
    size_bytes bigint,
    uuid uuid DEFAULT extensions.gen_random_uuid() NOT NULL
);


--
-- Name: bitstreamformatregistry; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bitstreamformatregistry (
    bitstream_format_id integer NOT NULL,
    mimetype character varying(256),
    short_description character varying(128),
    description text,
    support_level integer,
    internal boolean
);


--
-- Name: bitstreamformatregistry_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bitstreamformatregistry_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bundle; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bundle (
    bundle_id integer,
    uuid uuid DEFAULT extensions.gen_random_uuid() NOT NULL,
    primary_bitstream_id uuid
);


--
-- Name: bundle2bitstream; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bundle2bitstream (
    bitstream_order_legacy integer,
    bundle_id uuid NOT NULL,
    bitstream_id uuid NOT NULL,
    bitstream_order integer NOT NULL
);


--
-- Name: checksum_history; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.checksum_history (
    check_id bigint NOT NULL,
    process_start_date timestamp without time zone,
    process_end_date timestamp without time zone,
    checksum_expected character varying,
    checksum_calculated character varying,
    result character varying,
    bitstream_id uuid
);


--
-- Name: checksum_history_check_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.checksum_history_check_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: checksum_history_check_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.checksum_history_check_id_seq OWNED BY public.checksum_history.check_id;


--
-- Name: checksum_results; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.checksum_results (
    result_code character varying NOT NULL,
    result_description character varying
);


--
-- Name: collection; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.collection (
    collection_id integer,
    uuid uuid DEFAULT extensions.gen_random_uuid() NOT NULL,
    workflow_step_1 uuid,
    workflow_step_2 uuid,
    workflow_step_3 uuid,
    submitter uuid,
    template_item_id uuid,
    logo_bitstream_id uuid,
    admin uuid
);


--
-- Name: collection2item; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.collection2item (
    collection_id uuid NOT NULL,
    item_id uuid NOT NULL
);


--
-- Name: community; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.community (
    community_id integer,
    uuid uuid DEFAULT extensions.gen_random_uuid() NOT NULL,
    admin uuid,
    logo_bitstream_id uuid
);


--
-- Name: community2collection; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.community2collection (
    collection_id uuid NOT NULL,
    community_id uuid NOT NULL
);


--
-- Name: community2community; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.community2community (
    parent_comm_id uuid NOT NULL,
    child_comm_id uuid NOT NULL
);


--
-- Name: doi; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.doi (
    doi_id integer NOT NULL,
    doi character varying(256),
    resource_type_id integer,
    resource_id integer,
    status integer,
    dspace_object uuid
);


--
-- Name: doi_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.doi_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dspaceobject; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dspaceobject (
    uuid uuid NOT NULL
);


--
-- Name: eperson; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.eperson (
    eperson_id integer,
    email character varying(64),
    password character varying(128),
    can_log_in boolean,
    require_certificate boolean,
    self_registered boolean,
    last_active timestamp without time zone,
    sub_frequency integer,
    netid character varying(64),
    salt character varying(32),
    digest_algorithm character varying(16),
    uuid uuid DEFAULT extensions.gen_random_uuid() NOT NULL
);


--
-- Name: epersongroup; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.epersongroup (
    eperson_group_id integer,
    uuid uuid DEFAULT extensions.gen_random_uuid() NOT NULL,
    permanent boolean DEFAULT false,
    name character varying(250)
);


--
-- Name: epersongroup2eperson; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.epersongroup2eperson (
    eperson_group_id uuid NOT NULL,
    eperson_id uuid NOT NULL
);


--
-- Name: epersongroup2workspaceitem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.epersongroup2workspaceitem (
    workspace_item_id integer NOT NULL,
    eperson_group_id uuid NOT NULL
);


--
-- Name: fileextension; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fileextension (
    file_extension_id integer NOT NULL,
    bitstream_format_id integer,
    extension character varying(16)
);


--
-- Name: fileextension_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.fileextension_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: group2group; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.group2group (
    parent_id uuid NOT NULL,
    child_id uuid NOT NULL
);


--
-- Name: group2groupcache; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.group2groupcache (
    parent_id uuid NOT NULL,
    child_id uuid NOT NULL
);


--
-- Name: handle; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.handle (
    handle_id integer NOT NULL,
    handle character varying(256),
    resource_type_id integer,
    resource_legacy_id integer,
    resource_id uuid
);


--
-- Name: handle_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.handle_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: handle_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.handle_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: harvested_collection; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.harvested_collection (
    harvest_type integer,
    oai_source character varying,
    oai_set_id character varying,
    harvest_message character varying,
    metadata_config_id character varying,
    harvest_status integer,
    harvest_start_time timestamp with time zone,
    last_harvested timestamp with time zone,
    id integer NOT NULL,
    collection_id uuid
);


--
-- Name: harvested_collection_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.harvested_collection_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: harvested_item; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.harvested_item (
    last_harvested timestamp with time zone,
    oai_id character varying,
    id integer NOT NULL,
    item_id uuid
);


--
-- Name: harvested_item_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.harvested_item_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: history_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.history_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: item; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.item (
    item_id integer,
    in_archive boolean,
    withdrawn boolean,
    last_modified timestamp with time zone,
    discoverable boolean,
    uuid uuid DEFAULT extensions.gen_random_uuid() NOT NULL,
    submitter_id uuid,
    owning_collection uuid
);


--
-- Name: item2bundle; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.item2bundle (
    bundle_id uuid NOT NULL,
    item_id uuid NOT NULL
);


--
-- Name: metadatafieldregistry_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.metadatafieldregistry_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: metadatafieldregistry; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.metadatafieldregistry (
    metadata_field_id integer DEFAULT nextval('public.metadatafieldregistry_seq'::regclass) NOT NULL,
    metadata_schema_id integer NOT NULL,
    element character varying(64),
    qualifier character varying(64),
    scope_note text
);


--
-- Name: metadataschemaregistry_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.metadataschemaregistry_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: metadataschemaregistry; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.metadataschemaregistry (
    metadata_schema_id integer DEFAULT nextval('public.metadataschemaregistry_seq'::regclass) NOT NULL,
    namespace character varying(256),
    short_id character varying(32)
);


--
-- Name: metadatavalue_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.metadatavalue_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: metadatavalue; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.metadatavalue (
    metadata_value_id integer DEFAULT nextval('public.metadatavalue_seq'::regclass) NOT NULL,
    metadata_field_id integer,
    text_value text,
    text_lang character varying(24),
    place integer,
    authority character varying(100),
    confidence integer DEFAULT '-1'::integer,
    dspace_object_id uuid
);


--
-- Name: most_recent_checksum; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.most_recent_checksum (
    to_be_processed boolean NOT NULL,
    expected_checksum character varying NOT NULL,
    current_checksum character varying NOT NULL,
    last_process_start_date timestamp without time zone NOT NULL,
    last_process_end_date timestamp without time zone NOT NULL,
    checksum_algorithm character varying NOT NULL,
    matched_prev_checksum boolean NOT NULL,
    result character varying,
    bitstream_id uuid
);


--
-- Name: registrationdata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.registrationdata (
    registrationdata_id integer NOT NULL,
    email character varying(64),
    token character varying(48),
    expires timestamp without time zone
);


--
-- Name: registrationdata_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.registrationdata_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: requestitem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.requestitem (
    requestitem_id integer NOT NULL,
    token character varying(48),
    allfiles boolean,
    request_email character varying(64),
    request_name character varying(64),
    request_date timestamp without time zone,
    accept_request boolean,
    decision_date timestamp without time zone,
    expires timestamp without time zone,
    request_message text,
    item_id uuid,
    bitstream_id uuid
);


--
-- Name: requestitem_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.requestitem_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: resourcepolicy; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.resourcepolicy (
    policy_id integer NOT NULL,
    resource_type_id integer,
    resource_id integer,
    action_id integer,
    start_date date,
    end_date date,
    rpname character varying(30),
    rptype character varying(30),
    rpdescription text,
    eperson_id uuid,
    epersongroup_id uuid,
    dspace_object uuid
);


--
-- Name: resourcepolicy_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.resourcepolicy_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: schema_version; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_version (
    installed_rank integer NOT NULL,
    version character varying(50),
    description character varying(200) NOT NULL,
    type character varying(20) NOT NULL,
    script character varying(1000) NOT NULL,
    checksum integer,
    installed_by character varying(100) NOT NULL,
    installed_on timestamp without time zone DEFAULT now() NOT NULL,
    execution_time integer NOT NULL,
    success boolean NOT NULL
);


--
-- Name: site; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.site (
    uuid uuid NOT NULL
);


--
-- Name: subscription; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.subscription (
    subscription_id integer NOT NULL,
    eperson_id uuid,
    collection_id uuid
);


--
-- Name: subscription_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.subscription_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tasklistitem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tasklistitem (
    tasklist_id integer NOT NULL,
    workflow_id integer,
    eperson_id uuid
);


--
-- Name: tasklistitem_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tasklistitem_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: versionhistory; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.versionhistory (
    versionhistory_id integer NOT NULL
);


--
-- Name: versionhistory_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.versionhistory_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: versionitem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.versionitem (
    versionitem_id integer NOT NULL,
    version_number integer,
    version_date timestamp without time zone,
    version_summary character varying(255),
    versionhistory_id integer,
    eperson_id uuid,
    item_id uuid
);


--
-- Name: versionitem_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.versionitem_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: webapp; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.webapp (
    webapp_id integer NOT NULL,
    appname character varying(32),
    url character varying,
    started timestamp without time zone,
    isui integer
);


--
-- Name: webapp_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.webapp_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: workflowitem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.workflowitem (
    workflow_id integer NOT NULL,
    state integer,
    multiple_titles boolean,
    published_before boolean,
    multiple_files boolean,
    item_id uuid,
    collection_id uuid,
    owner uuid
);


--
-- Name: workflowitem_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.workflowitem_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: workspaceitem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.workspaceitem (
    workspace_item_id integer NOT NULL,
    multiple_titles boolean,
    published_before boolean,
    multiple_files boolean,
    stage_reached integer,
    page_reached integer,
    item_id uuid,
    collection_id uuid
);


--
-- Name: workspaceitem_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.workspaceitem_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: checksum_history check_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.checksum_history ALTER COLUMN check_id SET DEFAULT nextval('public.checksum_history_check_id_seq'::regclass);


--
-- Data for Name: bitstream; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.bitstream (bitstream_id, bitstream_format_id, checksum, checksum_algorithm, internal_id, deleted, store_number, sequence_id, size_bytes, uuid) FROM stdin;
\N	16	c30f00f3f6f6d78b2b03faecdf2808b0	MD5	149622620903634997429808448874585538081	t	0	-1	194113	55e591b9-f933-4b9f-aaac-a33dc775f60f
\N	16	c30f00f3f6f6d78b2b03faecdf2808b0	MD5	78267654044706104932879677256321462058	f	0	-1	194113	84d2756c-8775-4c78-bbc9-351601ea3744
\N	16	ba3419d5d31b913e35b5252583c03d31	MD5	167256884699416989935220977444202946331	t	0	-1	758369	9a1f7bb7-6d07-4a42-8c2f-044b8a8b6ff5
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	103307553501199920086793611262505308930	f	0	2	1748	6976abc2-963e-4646-9a1a-0b84cf194e14
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	108079876627409179102370006665581248132	f	0	2	1748	6279e756-d48b-47ab-ab4a-7c263086ef91
\N	4	2684ca8f94542f262e73c65bef7ee6b6	MD5	160749902885279313228899871168129482385	f	0	1	10153433	442733cd-6e42-4067-aec3-7ab56c0400b2
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	57947247204797178516493432951661294477	f	0	2	1748	7ecddc58-7be4-4c9b-afb6-7cf47980bdbb
\N	4	2f6bdb3ac081833b1d3c1dddd9a4090c	MD5	20179092322160622328590709789641975469	f	0	1	7905242	cb96ce77-f592-45b1-9134-e7edc95a6fc3
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	158287267568054284277703826647842985056	f	0	2	1748	9d699cab-947c-4a96-b7fb-6095ae6a853a
\N	4	e23d5b05b24a5b245f93077c3d19b302	MD5	74472267214114999606606511723212395044	t	0	1	11290129	a0c4b57b-cb3d-4ad1-9dc2-42eccc20a656
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	135413298407067158354788244487033696883	f	0	2	1748	f0ea2228-0bac-4d69-8132-9064c1d74396
\N	4	e23d5b05b24a5b245f93077c3d19b302	MD5	104501828211543472087688790522992530270	t	0	3	11290129	3aa79369-e6ac-4cde-9da1-78f0e0416693
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	107516918315467270200609813572316420089	f	0	2	1748	b0a816ce-64d0-4b01-924e-28a4a5b85d4e
\N	4	c3242b733f09a7626ab4fdee9b0a4bcb	MD5	101719948481871583658791165816498585476	t	0	-1	5762908	f9f4ab05-ca6f-416c-a2cb-e42ff8a3ddef
\N	4	e23d5b05b24a5b245f93077c3d19b302	MD5	34809227317126485728484923799347108676	f	0	3	11290129	80aeeef4-8b4a-44e5-a67b-60331f5e20c5
\N	4	c3242b733f09a7626ab4fdee9b0a4bcb	MD5	92617869141538693811273609859050573776	t	0	-1	5762908	932c0dc4-ff45-48a4-863b-1c937b3ee33c
\N	4	a441f69ee22e595946db6162948b6824	MD5	94292148872711253259962841753893828572	t	0	3	12365504	7729b272-7cc6-40d9-aadb-4736c2f96d13
\N	4	a441f69ee22e595946db6162948b6824	MD5	30325692705625144608564930125928864626	t	0	3	12365504	2f1b5720-6de1-4cff-8dc6-2b54514544a7
\N	16	c30f00f3f6f6d78b2b03faecdf2808b0	MD5	159950634591674920991008852481821809043	f	0	-1	194113	8afdd918-d2e2-4888-aefc-9b94ce7a3aac
\N	16	c30f00f3f6f6d78b2b03faecdf2808b0	MD5	10274306274989537213805608710027404387	t	0	-1	194113	42590e9d-eaf5-4479-ab2c-810b7e0ce06e
\N	16	6ee9cf5df06412d2d0b266cd79edce8f	MD5	44204289943492963198940933958188354948	t	0	-1	45731	04526745-5792-4bc4-902a-13833602fb16
\N	16	1ec130c7c143cf8fd996eb87089acad3	MD5	169058866475150006889674266026990977815	t	0	-1	130999	c74beb9b-1608-4a6f-b5aa-6cc228a98877
\N	16	c30f00f3f6f6d78b2b03faecdf2808b0	MD5	91114766756382090518214110545860448415	t	0	-1	194113	12f32e5e-3f28-40ba-bdbb-9264ab53f973
\N	16	c30f00f3f6f6d78b2b03faecdf2808b0	MD5	37563677677414844525562087811822872036	t	0	-1	194113	e9ebf740-9ec2-4a98-a222-5612230b070a
\N	4	d4c237ab0d4ab14172c7d037e1cb2640	MD5	78841073346971126005302163808494502595	t	0	1	10218276	8aaa2fc1-c519-4138-aa02-4fc9f86930f4
\N	4	a441f69ee22e595946db6162948b6824	MD5	22598614484971594249483715024102053587	f	0	1	12365504	82c95a58-2f95-4e10-a39e-1fc04934dc2b
\N	4	e435f767abc36c8b94f4bdc22538356f	MD5	159433902537588077567726716632015746320	f	0	3	9602837	e19de17d-d456-4b3b-8102-d1a012594d36
\N	4	a441f69ee22e595946db6162948b6824	MD5	168224643249596767325174505176400719633	t	0	3	12365504	c9e00944-6772-4ac8-93d3-b768ed3e73d5
\N	4	993ceccd9a4a1933d4c7196a7c77544a	MD5	9185949528696100106922165206108308842	t	0	1	9173825	4fdacc55-3668-4314-91dc-08b6b61cd9cd
\N	4	a441f69ee22e595946db6162948b6824	MD5	156178707466576412048419451671940340874	f	0	3	12365504	b9d4ea49-d4b5-41b8-9891-0c65ff4bcbae
\N	4	e0b6d31d9c32677f97b3f164f059e4e2	MD5	153379322129048319175642913875624155333	f	0	3	9018210	c54a90fa-33e6-4c0b-b3c5-39e52d0a6887
\N	4	4020d5a038a28e7decb814074e5400d1	MD5	11785706993094648650608696880065830446	f	0	1	10002502	25d02dc5-8249-4146-a65a-1da2b0d306f9
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	153208421376835172200800698629337340983	f	0	2	1748	439c20e0-ca26-4687-899f-81ff3d3b8ff2
\N	16	1ec130c7c143cf8fd996eb87089acad3	MD5	84243510961656687813365772856049795977	t	0	-1	130999	96b11f13-ad11-4e20-abb1-1b59f0ad90bb
\N	2	8a4605be74aa9ea9d79846c1fba20a33	MD5	119092154232234216994033046937812162958	f	0	2	1748	e518be93-fac4-433f-84c0-32533ec7b4ac
\N	16	44d4581fe066b64da198f538a983696b	MD5	155844979793485573479085071742416601993	t	0	-1	139771	f137eb4c-450f-40c0-81e5-48ffda8caf2b
\N	16	3aba812c69f7cf4a7d86b6acfef83c16	MD5	130266850871458519389411494327118873659	t	0	-1	163618	32421ac4-1a07-4150-973f-a5437265af4e
\N	16	9012f52742397f7bf853d5f31a8f56da	MD5	35238966594884258770342775614774631923	t	0	-1	129426	089ec672-8120-4e7b-9f52-9cd4d44a514b
\N	16	05bf086dec359fbbed364c841bf26169	MD5	16527816405004692853308691638257065731	t	0	-1	154415	46dc8de4-2feb-4f76-bcf8-38d8c795a614
\N	4	128341e7d22222dc276be099616155e3	MD5	104810124339026692465633519847333693026	t	0	1	13182359	b756ceae-057c-4796-997e-16374744e2e7
\N	16	b9f1a971ea5dba1a47ef7b5fbfb42b70	MD5	81425134253640889995207714118019034991	t	0	-1	137133	9ddaf20e-e6cd-49d4-95c8-9f5bf19cabfc
\N	16	78a8fe0806342ee70dcdfae20bb05599	MD5	26704006042646151203004741936315427876	t	0	-1	107517	c9b59794-1d5c-4196-aff1-cc87e2ca115b
\N	4	bf93375e5d5f80c73ed6800d96dceb6f	MD5	113353010430133362752482616389007941112	f	0	1	15736243	85b1a7ac-ea04-472b-8b18-e5aec342eaea
\N	2	57667f7d11008c6df4243ea3fe71636b	MD5	69654131148000456742098429507507764765	f	0	2	2304	b67582cb-62e9-43df-90b5-ce80eec4b405
\N	4	f9b5c6896f86fa89043078106d8b6d7e	MD5	93022156370785126344881109955597020767	f	0	1	12958783	7e55a9ff-7590-4b90-87ea-06b90c938f18
\N	2	57667f7d11008c6df4243ea3fe71636b	MD5	132346254687796855675880717545942627609	f	0	2	2304	2460d158-bd7a-47c3-a3a6-fb74f16068a5
\N	4	d8bb8174bf7c9b1b7df92c79b60d2fc7	MD5	48543100176701036828959461033302134915	f	0	1	7707788	64fe4985-27fe-4f22-8639-86bc96f20fb4
\N	2	57667f7d11008c6df4243ea3fe71636b	MD5	113210898768846195656591798321693648102	f	0	2	2304	f1370e88-0940-4e2f-9e70-15d072d03075
\N	4	f3dbe1b44bd002393e029bddc3db6510	MD5	43145664490299266494693713097178706034	f	0	1	7734114	c7fbb171-128e-4d32-989f-f60e9aa4c3a2
\N	2	57667f7d11008c6df4243ea3fe71636b	MD5	97597398189596221168015251374368156574	f	0	2	2304	ada7ba6e-80fa-483d-b889-0d18aa72c26d
\N	4	2a2ace89841c880ea677d852a7931217	MD5	136337815964475205358218227906363270378	f	0	1	11494250	244b6155-22e3-4579-b2f0-f4e1b459e62a
\N	2	57667f7d11008c6df4243ea3fe71636b	MD5	60575348220661331090176985696895335825	f	0	2	2304	55793605-81eb-4525-be84-bb56dedb1703
\.


--
-- Data for Name: bitstreamformatregistry; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.bitstreamformatregistry (bitstream_format_id, mimetype, short_description, description, support_level, internal) FROM stdin;
1	application/octet-stream	Unknown	Unknown data format	0	f
2	text/plain; charset=utf-8	License	Item-specific license agreed upon to submission	1	t
3	text/html; charset=utf-8	CC License	Item-specific Creative Commons license agreed upon to submission	1	t
4	application/pdf	Adobe PDF	Adobe Portable Document Format	1	f
5	text/xml	XML	Extensible Markup Language	1	f
6	text/plain	Text	Plain Text	1	f
7	text/html	HTML	Hypertext Markup Language	1	f
8	text/css	CSS	Cascading Style Sheets	1	f
9	application/msword	Microsoft Word	Microsoft Word	1	f
10	application/vnd.openxmlformats-officedocument.wordprocessingml.document	Microsoft Word XML	Microsoft Word XML	1	f
11	application/vnd.ms-powerpoint	Microsoft Powerpoint	Microsoft Powerpoint	1	f
12	application/vnd.openxmlformats-officedocument.presentationml.presentation	Microsoft Powerpoint XML	Microsoft Powerpoint XML	1	f
13	application/vnd.ms-excel	Microsoft Excel	Microsoft Excel	1	f
14	application/vnd.openxmlformats-officedocument.spreadsheetml.sheet	Microsoft Excel XML	Microsoft Excel XML	1	f
15	application/marc	MARC	Machine-Readable Cataloging records	1	f
16	image/jpeg	JPEG	Joint Photographic Experts Group/JPEG File Interchange Format (JFIF)	1	f
17	image/gif	GIF	Graphics Interchange Format	1	f
18	image/png	image/png	Portable Network Graphics	1	f
19	image/tiff	TIFF	Tag Image File Format	1	f
20	audio/x-aiff	AIFF	Audio Interchange File Format	1	f
21	audio/basic	audio/basic	Basic Audio	1	f
22	audio/x-wav	WAV	Broadcase Wave Format	1	f
23	video/mpeg	MPEG	Moving Picture Experts Group	1	f
24	text/richtext	RTF	Rich Text Format	1	f
25	application/vnd.visio	Microsoft Visio	Microsoft Visio	1	f
26	application/x-filemaker	FMP3	Filemaker Pro	1	f
27	image/x-ms-bmp	BMP	Microsoft Windows bitmap	1	f
28	application/x-photoshop	Photoshop	Photoshop	1	f
29	application/postscript	Postscript	Postscript Files	1	f
30	video/quicktime	Video Quicktime	Video Quicktime	1	f
31	audio/x-mpeg	MPEG Audio	MPEG Audio	1	f
32	application/vnd.ms-project	Microsoft Project	Microsoft Project	1	f
33	application/mathematica	Mathematica	Mathematica Notebook	1	f
34	application/x-latex	LateX	LaTeX document	1	f
35	application/x-tex	TeX	Tex/LateX document	1	f
36	application/x-dvi	TeX dvi	TeX dvi format	1	f
37	application/sgml	SGML	SGML application (RFC 1874)	1	f
38	application/wordperfect5.1	WordPerfect	WordPerfect 5.1 document	1	f
39	audio/x-pn-realaudio	RealAudio	RealAudio file	1	f
40	image/x-photo-cd	Photo CD	Kodak Photo CD image	1	f
41	application/vnd.oasis.opendocument.text	OpenDocument Text	OpenDocument Text	1	f
42	application/vnd.oasis.opendocument.text-template	OpenDocument Text Template	OpenDocument Text Template	1	f
43	application/vnd.oasis.opendocument.text-web	OpenDocument HTML Template	OpenDocument HTML Template	1	f
44	application/vnd.oasis.opendocument.text-master	OpenDocument Master Document	OpenDocument Master Document	1	f
45	application/vnd.oasis.opendocument.graphics	OpenDocument Drawing	OpenDocument Drawing	1	f
46	application/vnd.oasis.opendocument.graphics-template	OpenDocument Drawing Template	OpenDocument Drawing Template	1	f
47	application/vnd.oasis.opendocument.presentation	OpenDocument Presentation	OpenDocument Presentation	1	f
48	application/vnd.oasis.opendocument.presentation-template	OpenDocument Presentation Template	OpenDocument Presentation Template	1	f
49	application/vnd.oasis.opendocument.spreadsheet	OpenDocument Spreadsheet	OpenDocument Spreadsheet	1	f
50	application/vnd.oasis.opendocument.spreadsheet-template	OpenDocument Spreadsheet Template	OpenDocument Spreadsheet Template	1	f
51	application/vnd.oasis.opendocument.chart	OpenDocument Chart	OpenDocument Chart	1	f
52	application/vnd.oasis.opendocument.formula	OpenDocument Formula	OpenDocument Formula	1	f
53	application/vnd.oasis.opendocument.database	OpenDocument Database	OpenDocument Database	1	f
54	application/vnd.oasis.opendocument.image	OpenDocument Image	OpenDocument Image	1	f
55	application/vnd.openofficeorg.extension	OpenOffice.org extension	OpenOffice.org extension (since OOo 2.1)	1	f
56	application/vnd.sun.xml.writer	Writer 6.0 documents	Writer 6.0 documents	1	f
57	application/vnd.sun.xml.writer.template	Writer 6.0 templates	Writer 6.0 templates	1	f
58	application/vnd.sun.xml.calc	Calc 6.0 spreadsheets	Calc 6.0 spreadsheets	1	f
59	application/vnd.sun.xml.calc.template	Calc 6.0 templates	Calc 6.0 templates	1	f
60	application/vnd.sun.xml.draw	Draw 6.0 documents	Draw 6.0 documents	1	f
61	application/vnd.sun.xml.draw.template	Draw 6.0 templates	Draw 6.0 templates	1	f
62	application/vnd.sun.xml.impress	Impress 6.0 presentations	Impress 6.0 presentations	1	f
63	application/vnd.sun.xml.impress.template	Impress 6.0 templates	Impress 6.0 templates	1	f
64	application/vnd.sun.xml.writer.global	Writer 6.0 global documents	Writer 6.0 global documents	1	f
65	application/vnd.sun.xml.math	Math 6.0 documents	Math 6.0 documents	1	f
66	application/vnd.stardivision.writer	StarWriter 5.x documents	StarWriter 5.x documents	1	f
67	application/vnd.stardivision.writer-global	StarWriter 5.x global documents	StarWriter 5.x global documents	1	f
68	application/vnd.stardivision.calc	StarCalc 5.x spreadsheets	StarCalc 5.x spreadsheets	1	f
69	application/vnd.stardivision.draw	StarDraw 5.x documents	StarDraw 5.x documents	1	f
70	application/vnd.stardivision.impress	StarImpress 5.x presentations	StarImpress 5.x presentations	1	f
71	application/vnd.stardivision.impress-packed	StarImpress Packed 5.x files	StarImpress Packed 5.x files	1	f
72	application/vnd.stardivision.math	StarMath 5.x documents	StarMath 5.x documents	1	f
73	application/vnd.stardivision.chart	StarChart 5.x documents	StarChart 5.x documents	1	f
74	application/vnd.stardivision.mail	StarMail 5.x mail files	StarMail 5.x mail files	1	f
75	application/rdf+xml; charset=utf-8	RDF XML	RDF serialized in XML	1	f
76	application/epub+zip	EPUB	Electronic publishing	1	f
77	application/pdf	TERMO	TERMO AUTORIZACAO	1	t
\.


--
-- Data for Name: bundle; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.bundle (bundle_id, uuid, primary_bitstream_id) FROM stdin;
\N	b69846db-0436-4b43-9f3c-8c32473591cd	\N
\N	9151f169-1522-4613-92cc-c524bbddde5d	\N
\N	3fadcab8-0741-48bb-a6d4-e2498776b884	\N
\N	41004cb5-139b-460e-972d-cab8cb44c811	\N
\N	4401ba15-c530-48ee-b0af-d4e57e7fc0cb	\N
\N	1ad028c5-ca62-409c-96d0-e90b9a547216	\N
\N	2a464f3f-cc84-40cb-b21b-9892d70707ac	\N
\N	6c633236-b142-42a6-9bbc-421e3e921a75	\N
\N	67a933ee-2067-4da6-ae2b-2a0e5cf7e8ad	\N
\N	ff7d7cea-0e22-4c0a-8736-5c21a1cbe947	\N
\N	faf47611-7203-4c82-aedb-c5333d5e84a0	\N
\N	cfec0436-26af-4ba7-80d0-4fbdfd6220f7	\N
\N	9ac5b3f1-5be2-4f9f-a995-846b11e10e1e	\N
\N	efe24c20-53cd-4a4f-8f72-d599f8df7e1a	\N
\N	a46768eb-dec3-44f6-84bb-e1a1496c616f	\N
\N	4def91f3-d15d-49b2-9fd8-2227cc555bf5	\N
\N	62807404-015a-42e4-bc1e-bdeb2501f94e	\N
\N	880da050-40ba-4eaf-a68c-edada75594a9	\N
\N	b97b63ea-ce0a-4c12-9e6b-1a4b3bb3876e	\N
\N	9e7d3c2a-c897-4e5c-98d9-1751e8e50f47	\N
\N	d836e6c1-1fc3-4658-af3a-8d368eb81fa3	\N
\N	047efc13-5570-4018-a045-52dcc92d44da	\N
\N	4b984d79-4db8-4fb5-a070-a18248c660ff	\N
\N	1d9e8682-269c-4484-ad0c-423f98fed95c	\N
\N	6b8fb088-d396-4c9d-bd8b-94e2f38ec447	\N
\N	aaf93d7b-4387-450c-9b08-0da85be3df6a	\N
\.


--
-- Data for Name: bundle2bitstream; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.bundle2bitstream (bitstream_order_legacy, bundle_id, bitstream_id, bitstream_order) FROM stdin;
\N	b69846db-0436-4b43-9f3c-8c32473591cd	6976abc2-963e-4646-9a1a-0b84cf194e14	0
\N	9151f169-1522-4613-92cc-c524bbddde5d	7ecddc58-7be4-4c9b-afb6-7cf47980bdbb	0
\N	3fadcab8-0741-48bb-a6d4-e2498776b884	cb96ce77-f592-45b1-9134-e7edc95a6fc3	0
\N	41004cb5-139b-460e-972d-cab8cb44c811	f0ea2228-0bac-4d69-8132-9064c1d74396	0
\N	4401ba15-c530-48ee-b0af-d4e57e7fc0cb	b0a816ce-64d0-4b01-924e-28a4a5b85d4e	0
\N	1ad028c5-ca62-409c-96d0-e90b9a547216	e19de17d-d456-4b3b-8102-d1a012594d36	0
\N	2a464f3f-cc84-40cb-b21b-9892d70707ac	c54a90fa-33e6-4c0b-b3c5-39e52d0a6887	0
\N	6c633236-b142-42a6-9bbc-421e3e921a75	25d02dc5-8249-4146-a65a-1da2b0d306f9	0
\N	67a933ee-2067-4da6-ae2b-2a0e5cf7e8ad	e518be93-fac4-433f-84c0-32533ec7b4ac	0
\N	ff7d7cea-0e22-4c0a-8736-5c21a1cbe947	6279e756-d48b-47ab-ab4a-7c263086ef91	0
\N	faf47611-7203-4c82-aedb-c5333d5e84a0	442733cd-6e42-4067-aec3-7ab56c0400b2	0
\N	cfec0436-26af-4ba7-80d0-4fbdfd6220f7	9d699cab-947c-4a96-b7fb-6095ae6a853a	0
\N	9ac5b3f1-5be2-4f9f-a995-846b11e10e1e	80aeeef4-8b4a-44e5-a67b-60331f5e20c5	0
\N	efe24c20-53cd-4a4f-8f72-d599f8df7e1a	b9d4ea49-d4b5-41b8-9891-0c65ff4bcbae	0
\N	a46768eb-dec3-44f6-84bb-e1a1496c616f	82c95a58-2f95-4e10-a39e-1fc04934dc2b	0
\N	4def91f3-d15d-49b2-9fd8-2227cc555bf5	439c20e0-ca26-4687-899f-81ff3d3b8ff2	0
\N	62807404-015a-42e4-bc1e-bdeb2501f94e	85b1a7ac-ea04-472b-8b18-e5aec342eaea	0
\N	880da050-40ba-4eaf-a68c-edada75594a9	b67582cb-62e9-43df-90b5-ce80eec4b405	0
\N	b97b63ea-ce0a-4c12-9e6b-1a4b3bb3876e	7e55a9ff-7590-4b90-87ea-06b90c938f18	0
\N	9e7d3c2a-c897-4e5c-98d9-1751e8e50f47	2460d158-bd7a-47c3-a3a6-fb74f16068a5	0
\N	d836e6c1-1fc3-4658-af3a-8d368eb81fa3	64fe4985-27fe-4f22-8639-86bc96f20fb4	0
\N	047efc13-5570-4018-a045-52dcc92d44da	f1370e88-0940-4e2f-9e70-15d072d03075	0
\N	4b984d79-4db8-4fb5-a070-a18248c660ff	c7fbb171-128e-4d32-989f-f60e9aa4c3a2	0
\N	1d9e8682-269c-4484-ad0c-423f98fed95c	ada7ba6e-80fa-483d-b889-0d18aa72c26d	0
\N	6b8fb088-d396-4c9d-bd8b-94e2f38ec447	244b6155-22e3-4579-b2f0-f4e1b459e62a	0
\N	aaf93d7b-4387-450c-9b08-0da85be3df6a	55793605-81eb-4525-be84-bb56dedb1703	0
\.


--
-- Data for Name: checksum_history; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.checksum_history (check_id, process_start_date, process_end_date, checksum_expected, checksum_calculated, result, bitstream_id) FROM stdin;
\.


--
-- Data for Name: checksum_results; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.checksum_results (result_code, result_description) FROM stdin;
INVALID_HISTORY	Install of the cheksum checking code do not consider this history as valid
BITSTREAM_NOT_FOUND	The bitstream could not be found
CHECKSUM_MATCH	Current checksum matched previous checksum
CHECKSUM_NO_MATCH	Current checksum does not match previous checksum
CHECKSUM_PREV_NOT_FOUND	Previous checksum was not found: no comparison possible
BITSTREAM_INFO_NOT_FOUND	Bitstream info not found
CHECKSUM_ALGORITHM_INVALID	Invalid checksum algorithm
BITSTREAM_NOT_PROCESSED	Bitstream marked to_be_processed=false
BITSTREAM_MARKED_DELETED	Bitstream marked deleted in bitstream table
\.


--
-- Data for Name: collection; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.collection (collection_id, uuid, workflow_step_1, workflow_step_2, workflow_step_3, submitter, template_item_id, logo_bitstream_id, admin) FROM stdin;
\N	fb0a9847-448b-412a-b5fc-ca8dda1e957c	\N	\N	\N	\N	74942b10-1340-4fbc-bbb8-7a868ec2bccb	8afdd918-d2e2-4888-aefc-9b94ce7a3aac	\N
\N	e77edf9c-1dbb-4794-90d7-19b281d804b5	\N	\N	\N	\N	\N	\N	\N
\.


--
-- Data for Name: collection2item; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.collection2item (collection_id, item_id) FROM stdin;
fb0a9847-448b-412a-b5fc-ca8dda1e957c	ac978e1a-ecdd-4409-982d-ad9f2c9d2933
fb0a9847-448b-412a-b5fc-ca8dda1e957c	32d21a1d-acae-42b9-9edf-4e47710a340a
fb0a9847-448b-412a-b5fc-ca8dda1e957c	b6dfa584-d9d6-4e67-9b10-13433ace7e38
fb0a9847-448b-412a-b5fc-ca8dda1e957c	66bb3a28-09f6-4ced-8423-57b3d96b060f
fb0a9847-448b-412a-b5fc-ca8dda1e957c	39926264-0a06-432f-bb03-18d391841d73
fb0a9847-448b-412a-b5fc-ca8dda1e957c	2a3f97a9-f475-4ef6-bbc3-c83e6f0cf28d
fb0a9847-448b-412a-b5fc-ca8dda1e957c	9e984c6f-a21b-4d2a-b168-59665345bb19
fb0a9847-448b-412a-b5fc-ca8dda1e957c	5f935f7b-468a-4bd3-a610-0dd1c9b9edc3
fb0a9847-448b-412a-b5fc-ca8dda1e957c	14875a45-2776-47af-b999-0ad20f1b7ff9
fb0a9847-448b-412a-b5fc-ca8dda1e957c	454cf684-62f8-4b49-bfc5-b343499cf735
fb0a9847-448b-412a-b5fc-ca8dda1e957c	c37aadfa-226f-4828-98bc-014c4e31d705
fb0a9847-448b-412a-b5fc-ca8dda1e957c	121a4efd-d31c-4a8b-9d4c-f57c7f7d0c02
fb0a9847-448b-412a-b5fc-ca8dda1e957c	f337e86e-7ee2-466c-841c-13b345ec5676
\.


--
-- Data for Name: community; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.community (community_id, uuid, admin, logo_bitstream_id) FROM stdin;
\N	d6941f14-9466-4dff-80d3-5e0809da53ce	7ec4b858-93ae-459b-9993-09170e3ade08	84d2756c-8775-4c78-bbc9-351601ea3744
\.


--
-- Data for Name: community2collection; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.community2collection (collection_id, community_id) FROM stdin;
fb0a9847-448b-412a-b5fc-ca8dda1e957c	d6941f14-9466-4dff-80d3-5e0809da53ce
e77edf9c-1dbb-4794-90d7-19b281d804b5	d6941f14-9466-4dff-80d3-5e0809da53ce
\.


--
-- Data for Name: community2community; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.community2community (parent_comm_id, child_comm_id) FROM stdin;
\.


--
-- Data for Name: doi; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.doi (doi_id, doi, resource_type_id, resource_id, status, dspace_object) FROM stdin;
\.


--
-- Data for Name: dspaceobject; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dspaceobject (uuid) FROM stdin;
5a1ce1ca-510b-47a7-af88-69ace496d4e7
a54a9824-240d-42ed-9290-df0f5fd46e4c
76d365c5-53f1-40c9-929d-239899a2472f
1cc4acc6-fd4e-4d68-b8ed-28874371d752
3c47b942-9ec4-4d9e-9f01-dd0990cf9baf
24547e55-3d4e-46d6-b048-356f3557eaa1
fca1239c-fc4e-43df-b30c-85af0a2d0317
8d71912f-e0c8-48d8-b606-c1eeaeb5ca95
4d8c7a83-92fc-4480-a0ae-3fe64e170f95
b8a75c11-585e-4dcf-831c-647be10c9915
96b11f13-ad11-4e20-abb1-1b59f0ad90bb
819182a0-8fc7-413e-a97c-6172c3d67b1f
41c9f7db-106f-4419-8e72-d6c1be75b330
4d6b1150-1cd6-4668-bbe0-7835f0fbcb09
f31b9fa2-1a95-4ddf-bdf7-a7bf138e1dea
04526745-5792-4bc4-902a-13833602fb16
55e591b9-f933-4b9f-aaac-a33dc775f60f
73f5f503-c67d-460f-8313-6e48c346c19a
d6941f14-9466-4dff-80d3-5e0809da53ce
9a1f7bb7-6d07-4a42-8c2f-044b8a8b6ff5
1ad028c5-ca62-409c-96d0-e90b9a547216
e19de17d-d456-4b3b-8102-d1a012594d36
089ec672-8120-4e7b-9f52-9cd4d44a514b
2a464f3f-cc84-40cb-b21b-9892d70707ac
c54a90fa-33e6-4c0b-b3c5-39e52d0a6887
c9b59794-1d5c-4196-aff1-cc87e2ca115b
32421ac4-1a07-4150-973f-a5437265af4e
f137eb4c-450f-40c0-81e5-48ffda8caf2b
39926264-0a06-432f-bb03-18d391841d73
6c633236-b142-42a6-9bbc-421e3e921a75
25d02dc5-8249-4146-a65a-1da2b0d306f9
67a933ee-2067-4da6-ae2b-2a0e5cf7e8ad
e518be93-fac4-433f-84c0-32533ec7b4ac
9ddaf20e-e6cd-49d4-95c8-9f5bf19cabfc
46dc8de4-2feb-4f76-bcf8-38d8c795a614
84d2756c-8775-4c78-bbc9-351601ea3744
7ec4b858-93ae-459b-9993-09170e3ade08
7729b272-7cc6-40d9-aadb-4736c2f96d13
2a3f97a9-f475-4ef6-bbc3-c83e6f0cf28d
a0c4b57b-cb3d-4ad1-9dc2-42eccc20a656
ff7d7cea-0e22-4c0a-8736-5c21a1cbe947
12f32e5e-3f28-40ba-bdbb-9264ab53f973
42590e9d-eaf5-4479-ab2c-810b7e0ce06e
e9ebf740-9ec2-4a98-a222-5612230b070a
6279e756-d48b-47ab-ab4a-7c263086ef91
9e984c6f-a21b-4d2a-b168-59665345bb19
faf47611-7203-4c82-aedb-c5333d5e84a0
442733cd-6e42-4067-aec3-7ab56c0400b2
f493e7ce-6f98-451f-8ca4-3ec03915c37f
cfec0436-26af-4ba7-80d0-4fbdfd6220f7
9d699cab-947c-4a96-b7fb-6095ae6a853a
d7635bc4-426d-4a42-8199-fa3a6fbf80f3
3aa79369-e6ac-4cde-9da1-78f0e0416693
9ac5b3f1-5be2-4f9f-a995-846b11e10e1e
80aeeef4-8b4a-44e5-a67b-60331f5e20c5
714e954e-296b-4618-990d-1e37f76b5986
2f1b5720-6de1-4cff-8dc6-2b54514544a7
c9e00944-6772-4ac8-93d3-b768ed3e73d5
67557413-f959-42a7-91e0-bf5eeabfd263
efe24c20-53cd-4a4f-8f72-d599f8df7e1a
b9d4ea49-d4b5-41b8-9891-0c65ff4bcbae
170cd97d-7d51-4ca2-b9c3-5f719c767b2b
5f935f7b-468a-4bd3-a610-0dd1c9b9edc3
e60a371a-7223-4549-844b-6c811a6e92a9
a46768eb-dec3-44f6-84bb-e1a1496c616f
85bd7949-2e63-4db6-9cef-fe4b163005bb
82c95a58-2f95-4e10-a39e-1fc04934dc2b
4def91f3-d15d-49b2-9fd8-2227cc555bf5
54cd4966-8160-459f-b43d-9eb411a5dc7a
439c20e0-ca26-4687-899f-81ff3d3b8ff2
d5cf8714-1fff-4f60-8c78-3f877fc172a8
fb0a9847-448b-412a-b5fc-ca8dda1e957c
d2c7a0f1-60ea-474b-a236-3ba7eb3d52dd
5fe9d514-2429-42cd-9d85-6365dbfce788
9eadd92d-59d3-42fd-9b6f-0d60438beaf4
f902581e-e799-4498-bcca-deb6f040e233
ac978e1a-ecdd-4409-982d-ad9f2c9d2933
4fdacc55-3668-4314-91dc-08b6b61cd9cd
b69846db-0436-4b43-9f3c-8c32473591cd
6976abc2-963e-4646-9a1a-0b84cf194e14
15cdcc8f-cf09-407d-9dfc-29472544d07d
c03e1d36-546d-4f42-8fe8-b5d5f6d9f1c8
aaf0b7cf-cfee-4539-84a1-656789dd522a
6ba33fee-756d-42f1-ada9-8218a48f4338
e4ab47bd-5177-4189-9ab3-f172d9f9138d
02241eb2-f506-4840-b663-d32b85822fec
b322b52d-0d56-417a-9f6b-8a56a93c0fb6
f647b204-93e9-4df8-bd5d-86f5955cdbfe
26cb99d7-7a32-4647-8d5e-4255dc01b1bf
6c4ae0f5-cd87-42d7-9234-c774fa3484a5
9f72041b-ba44-4aa4-86be-97622d601cfe
74942b10-1340-4fbc-bbb8-7a868ec2bccb
2e977e3b-be47-4499-a9aa-9bcbcfbf259b
45412fcf-9014-437f-ad54-b37cb064b31b
2444618d-48d1-4603-8cbb-ba77ed74fdd5
f7d06c53-c0de-4f14-a79a-a8ab735d172f
49755133-6ee6-414d-a9cb-fecf5284faf3
fc137b84-0aef-422b-8471-e0c77bd69f4c
4a8be754-f9fe-485a-8b0e-11d730b3b124
32d21a1d-acae-42b9-9edf-4e47710a340a
8aaa2fc1-c519-4138-aa02-4fc9f86930f4
9151f169-1522-4613-92cc-c524bbddde5d
7ecddc58-7be4-4c9b-afb6-7cf47980bdbb
b6dfa584-d9d6-4e67-9b10-13433ace7e38
3fadcab8-0741-48bb-a6d4-e2498776b884
cb96ce77-f592-45b1-9134-e7edc95a6fc3
41004cb5-139b-460e-972d-cab8cb44c811
f0ea2228-0bac-4d69-8132-9064c1d74396
66bb3a28-09f6-4ced-8423-57b3d96b060f
b756ceae-057c-4796-997e-16374744e2e7
4401ba15-c530-48ee-b0af-d4e57e7fc0cb
b0a816ce-64d0-4b01-924e-28a4a5b85d4e
877ece01-2af9-4a2e-b901-58e0eabe3d3d
9fd57935-4eb0-4ac6-97a2-6fced0595483
3c67b8b8-3e57-445d-8995-aacb73bf4db1
a5fe46d2-456a-4ba2-867a-afc530c3d434
b0050c80-1cf2-47bd-b0da-92241fb1a49a
e31a6004-ea04-469b-8d04-074de8c1943b
f3a701de-a6e6-467a-be2a-1b9feb40e489
45b1ef5e-922d-44fe-98ee-b114086bf222
10634130-ae05-4344-9a59-207b9d141d06
5205e355-51c7-483c-b808-3b7ecfa6e5a1
f9f4ab05-ca6f-416c-a2cb-e42ff8a3ddef
4273fe4b-70f2-4e46-88cd-901581fafe1e
932c0dc4-ff45-48a4-863b-1c937b3ee33c
c74beb9b-1608-4a6f-b5aa-6cc228a98877
f987df74-7fb5-414d-950c-f38c238ad268
8afdd918-d2e2-4888-aefc-9b94ce7a3aac
a768060f-d660-4395-8dca-a8c4c8f1d685
bc6b8623-030f-41a3-954b-045a1587d607
e77edf9c-1dbb-4794-90d7-19b281d804b5
45d6280a-2e57-445d-9ef9-1077bc71f915
14875a45-2776-47af-b999-0ad20f1b7ff9
62807404-015a-42e4-bc1e-bdeb2501f94e
85b1a7ac-ea04-472b-8b18-e5aec342eaea
880da050-40ba-4eaf-a68c-edada75594a9
b67582cb-62e9-43df-90b5-ce80eec4b405
454cf684-62f8-4b49-bfc5-b343499cf735
b97b63ea-ce0a-4c12-9e6b-1a4b3bb3876e
7e55a9ff-7590-4b90-87ea-06b90c938f18
9e7d3c2a-c897-4e5c-98d9-1751e8e50f47
2460d158-bd7a-47c3-a3a6-fb74f16068a5
c37aadfa-226f-4828-98bc-014c4e31d705
d836e6c1-1fc3-4658-af3a-8d368eb81fa3
64fe4985-27fe-4f22-8639-86bc96f20fb4
047efc13-5570-4018-a045-52dcc92d44da
f1370e88-0940-4e2f-9e70-15d072d03075
121a4efd-d31c-4a8b-9d4c-f57c7f7d0c02
4b984d79-4db8-4fb5-a070-a18248c660ff
c7fbb171-128e-4d32-989f-f60e9aa4c3a2
1d9e8682-269c-4484-ad0c-423f98fed95c
ada7ba6e-80fa-483d-b889-0d18aa72c26d
f337e86e-7ee2-466c-841c-13b345ec5676
6b8fb088-d396-4c9d-bd8b-94e2f38ec447
244b6155-22e3-4579-b2f0-f4e1b459e62a
aaf93d7b-4387-450c-9b08-0da85be3df6a
55793605-81eb-4525-be84-bb56dedb1703
508ee530-f344-4895-b49f-12fbbed92be0
417f079c-1474-4ec9-9b16-6a30f1b7d840
\.


--
-- Data for Name: eperson; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.eperson (eperson_id, email, password, can_log_in, require_certificate, self_registered, last_active, sub_frequency, netid, salt, digest_algorithm, uuid) FROM stdin;
\N	rita.fonseca@ifba.edu.br	6f7c4e7e14a54e33431380e665c62df8f5cd5dcfe251bad437eb2b211d71eba2e3645e2f996a7bd5fecae8f363e9c9706c1495f5925c79c33903a8bde5888d82	t	f	f	2022-09-26 12:28:07.49	\N	\N	998a064c7ac531607274755c5ee9a8e6	SHA-512	8d71912f-e0c8-48d8-b606-c1eeaeb5ca95
\N	teresabahia@ifba.edu.br	e1a2350872464548c0ea9f05a796c09c4790ba9e1361d1e6dbe41cfc9b874b7e7a7bdae645ef702a44450e1a9719a1746dc3f9356036057c3cc9ac08cba2c038	t	f	f	2022-09-15 20:25:19.953	\N	\N	0761e631ef81436a0e17911d5d0c1cc7	SHA-512	b8a75c11-585e-4dcf-831c-647be10c9915
\N	anateixeira@ifba.edu.br	79684f3a0a784160502a01b75396360434d4ec8c3888072176eec0446095f1eb543de196063f02755d87bbef91fcb4c90c374276474f9e3d0e86a8154e64b714	t	f	f	2022-09-27 13:35:28.092	\N	\N	d0d1bdde7d7b1da450635d3fb1a7697c	SHA-512	4d8c7a83-92fc-4480-a0ae-3fe64e170f95
\N	heidejd@ifba.edu.br	f270a61cc7a720ed5bf9f0a3dbcfd404820e4feb6eec47039a2dc8bd77b9c1b4f1a92093efbb7b047d63ce6810b2c59cd40d7b391ed5e6bb6dd0fba0cd904c3e	t	f	f	2023-07-25 13:14:30.992	\N	\N	0f0bcfe70e0c1a9db14c85078493ce6a	SHA-512	24547e55-3d4e-46d6-b048-356f3557eaa1
\N	keyla.rabelo@ifba.edu.br	de12a69bb556449185ab3cff5f5c68308cf31087244db358ec289f693b6ce1af05532ae1c8c05590f08e499f8b64590d02f71f63c24217d88ae8dbd7ed0f0595	t	f	t	2023-09-04 23:24:25.487	\N	\N	21e338be2a92c512df6de8c0c5ac2fb8	SHA-512	5fe9d514-2429-42cd-9d85-6365dbfce788
\N	janaina.pereira.rebelo@unemat.br	baa2fe056392e8e1e4f3d0bf70b6b627cc6fc8d3135760950f0b1228cdc86af6b564af29965662c5299319a321de71b7e00ac62a81eefd97e62812d0eaf71564	t	f	t	2023-08-17 18:58:41.578	\N	\N	8fc76dc0c35a970f819994404e694d3f	SHA-512	10634130-ae05-4344-9a59-207b9d141d06
\N	juniootavio@gmail.com	1465abbce05e2eb397be6d2d67279284221b2df89b7857e7e06f25455434d873c834530705d14dc8066f20beb428f9113ff6b9e7e36efd5329cd55b94defb290	t	f	t	2023-09-05 00:47:36.258	\N	\N	f80399158bd86f1e389075d80639b09d	SHA-512	f902581e-e799-4498-bcca-deb6f040e233
\N	jaci.santos@ifba.edu.br	2e549dd575ce13500b4fd1da2e02705ca9b26dcd6298929ecbb055827d0cc75a77c9429a9db0cd53f991261aa693bc5a5e11ab53c05198927a00c57284da3a6e	t	f	f	2023-08-07 12:25:27.574	\N	\N	51d52aab6958563e44837549c224c198	SHA-512	fca1239c-fc4e-43df-b30c-85af0a2d0317
\N	prates_literatura@hotmail.com	5f28cf5f7090a0c9e7cb37e12a9159f57ef424dbd28f4847e4e783732ded96d1916236d4c9bf6a4a3f32a9767449c6a1d44afb0cd854388958dba67dedab7b24	t	f	t	\N	\N	\N	9723cfacfef7c40f9fd9b06909ade623	SHA-512	45412fcf-9014-437f-ad54-b37cb064b31b
\N	carlos.alexandrino@ufvjm.edu.br	dc573e7465018f1b90d4f97e35d1ac7048a2227bba7a13ef1ad1f06ccd83b5f1d83404359e888b1b0e0c0d448eff9fd4fb997667be57fd0c0dd7a3554526b818	t	f	t	2023-09-05 02:33:10.08	\N	\N	7983bae78114ea7c3e7a337a3e89debc	SHA-512	15cdcc8f-cf09-407d-9dfc-29472544d07d
\N	julianamsaraujo@gmail.com	b42e059143bfc147587d754d0293f5cff38145be8a687eac32dc593f7ca0b9f6fb1c3f5db1482755a25b00b798b2f52613833933aa77d82f894bf2e4163bad5a	t	f	t	\N	\N	\N	9b721a597cb6867f097637d5a9b48f7c	SHA-512	aaf0b7cf-cfee-4539-84a1-656789dd522a
\N	leilokaandrade1@gmail.com	b5a2e26a12bea6c946750b96dda10511152570ed5ec5a7e02817f0b900f576d7010c3740aa3a6b3c49881130ac89b825c6c95143fbe6ce155bc0b7770f974746	t	f	t	\N	\N	\N	983acabfd1ce7438491b7d5aaea16af0	SHA-512	e4ab47bd-5177-4189-9ab3-f172d9f9138d
\N	carlasimonesouza@hotmail.com	f6b38e73d5d14c7b3dbaadb90b54a9bdb3fd20b0779167c3e8f1824f8281ce55713245454e166f345be9aa6c861b4e28a23be22a98e1b141c4874abf07e51f7b	t	f	t	2023-09-05 18:59:48.403	\N	\N	baf78a281b5a5e2760187ab0a9c39915	SHA-512	02241eb2-f506-4840-b663-d32b85822fec
\N	lidiane19072001@gmail.com	d006c0b21b5da0bbe83e3d084f60616d353325753473d2c4c9b021c6bfd8c9fc61df2dd4dd9724b44f3d29547ae22af0429d82be3e5f952495ee15b26e7f132f	t	f	t	\N	\N	\N	2305b003c2ad1e61ee3fb56d61deeee4	SHA-512	b322b52d-0d56-417a-9f6b-8a56a93c0fb6
\N	kukazaparoli@gmail.com	4c6475abe9a4893d47d8ea63366cceea0b2a8952111aeda168465f3279e58ea7d4ae2fe4121722aca9a19320324e12a196f6bd5be8844520595be13ddc08e32f	t	f	t	2023-09-06 19:26:53.036	\N	\N	30073489ed2d1e4bd1da6f9074ef11fc	SHA-512	f647b204-93e9-4df8-bd5d-86f5955cdbfe
\N	magdascruz@gmail.com	bfa01b06f139e12573d1f59313421225b26815ccccf1055688252128b9c178d9720972d9ee2cd1a4c27f3e703e4512eb15b5790b057947a6aaca696901d7bf34	t	f	t	\N	\N	\N	577a57e985f3adbf4dbad7188b185ace	SHA-512	6c4ae0f5-cd87-42d7-9234-c774fa3484a5
\N	202311290011@ifba.edu.br	9e81026fcf9fc7b203790a145dea23a053150b02b614ee0f46e37fe0c18a4ff88fadbba57d89d9e12e09aa63ca96f0ee6d0d431f36ea14c98f7140e775b7653f	t	f	t	2023-09-12 21:08:43.404	\N	\N	83114e9594e7efeba810b952a470fe08	SHA-512	877ece01-2af9-4a2e-b901-58e0eabe3d3d
\N	lisasacra@hotmail.com	86cb97e1d57ff63b2ac279d3d1ee807eaea152e6cb90ce3ad3d5bc6e4785f753e5718d076cab8c9029a317332d5e0b56ae4dfbbf82157e0cb512a9f52dc4556c	t	f	t	2023-09-12 21:04:45.36	\N	\N	adf91336c38d5ca02f073cf9d58718c5	SHA-512	2444618d-48d1-4603-8cbb-ba77ed74fdd5
\N	2019129042@ifba.edu.br	74c176c2f76ffb886138348234a4a5ba3d63c60aeeb5bd04d2240cc65429f378f38ddd4f0094f92f0d1ad4c67cd74eee11b51c05f3eabcd94e23c694ec07dfb8	t	f	t	2023-09-12 21:08:17.163	\N	\N	0cc257698400c277950e016a5395e1c2	SHA-512	f7d06c53-c0de-4f14-a79a-a8ab735d172f
\N	202211290015@ifba.edu.br	57264b99ee64c97ac7af80650a091d00c1ed972bc7bcc0cd003dd8314b1db62a8717954637a5568c1aec2223f405fbad904603f71462dfd804f24049d9c87855	t	f	t	2023-09-12 21:08:20.24	\N	\N	a4fc6b034d4375d2cf4ac1c846b081ec	SHA-512	fc137b84-0aef-422b-8471-e0c77bd69f4c
\N	thelma.ramos@ifba.edu.br	3547068f88ccc5547e5fee97aba2e96e94323fe20ee46366170837f338f795828a5fc6e32ddbe7bfa2c3d330ec4ba65adc79eb4c20eecd00a8b35bffc382171a	t	f	t	\N	\N	\N	d0b9d91f5f350025778e5a070df316d1	SHA-512	3c67b8b8-3e57-445d-8995-aacb73bf4db1
\N	taylormenezes10@gmail.com	a6c7a1ae102f7dede39b4a55edc8a912ae1a4b2c397d35efd45562dfeb70c7eca39cc6ebe8f2b162b81e08b3618ced2e29ef9c783b5e8da2a63c7f7f450dc57f	t	f	t	\N	\N	\N	043fe692d367a3c2725b2e28dfa37e7b	SHA-512	b0050c80-1cf2-47bd-b0da-92241fb1a49a
\N	andreiasr@ifba.edu.br	22d58346cec0e4b37deacdc4472d854e5cdb1ed801740b88dba64d05c337ed28ea82738e2947dc2e3e4abb858bbe2c997419d21c492cec29c988ca2ddf657ad7	t	f	f	2023-11-06 12:44:43.023	\N	\N	6a6f15bf822f353327831079d95fbc0c	SHA-512	3c47b942-9ec4-4d9e-9f01-dd0990cf9baf
\N	20221090012@ifba.edu.br	099994405b7b34165d7cb189d9532a7fc978102dc8e21fa49cde9587f62d7f8364ca0237d9edf0883d832b1de8fe0f213f98ecc16b14b4a5c10f4e197209de18	t	f	t	2023-09-12 21:12:19.632	\N	\N	d891fbf76ae81276bfb9cffc351592d7	SHA-512	f3a701de-a6e6-467a-be2a-1b9feb40e489
\N	elivanete.macedo@enova.educacao.ba.gov.br	5ed5fd98f758f238b354afab93d11bd93318b0f8ff8c796fbe5f69c5254d3acd8fc6ba4bab473a325d1a75fade85a574968454e39e0b2a87b12ec1df7080614e	t	f	t	\N	\N	\N	27e643e5d0a9a1b87c1a0ef9f86613e7	SHA-512	a768060f-d660-4395-8dca-a8c4c8f1d685
\N	mariacon@ifba.edu.br	c9a0e85c2ef6b74b115a9228e7e95d0787dfeb0465f27e11c3dda07e336b31ac826956a16ea1578106a7e708409ac33fe50c2716da43f8b59b7f3010f04c81bf	t	f	t	\N	\N	\N	75049f8c9ac1e0630a6aed351504001c	SHA-512	bc6b8623-030f-41a3-954b-045a1587d607
\N	gerson.luz@ifc.edu.br	793ed3fef793846e13afed4d643f2b718b9f30296987e5705247254dd0ad2eb72d3b351d7f9a4f624266951113384844dd19936a572e2d3c3049c6488721573e	t	f	t	\N	\N	\N	3f6c3483825daae0977dcf99223cc7b7	SHA-512	508ee530-f344-4895-b49f-12fbbed92be0
\N	jaque.19.df@gmail.com	d70bfc5e46ebbb65cbaf0542377828bf6c68f2245e95ef71e26e1de192eaf1b9ac52bd688632dee694e91fe07967260ecf67b7918fcd9ebdfc29d49354800bb9	t	f	t	\N	\N	\N	7b90839f3710554cdee78fbad920c802	SHA-512	417f079c-1474-4ec9-9b16-6a30f1b7d840
\N	valdir.santos@ifba.edu.br	1133fe0e6d92f4441fd2dffc0b4cda706f64d9f5724f0fd0c4b9b889417bc9fed3c0aa0ca581d3d14cc9dd60e08510d3198e01d4d68e86194def7fc7f258f8a5	t	f	f	2026-04-26 01:16:39.395	\N	\N	57a87deb898b89c62afa73e89fa071ba	SHA-512	1cc4acc6-fd4e-4d68-b8ed-28874371d752
\.


--
-- Data for Name: epersongroup; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.epersongroup (eperson_group_id, uuid, permanent, name) FROM stdin;
\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	t	Anonymous
\N	a54a9824-240d-42ed-9290-df0f5fd46e4c	t	Administrator
\N	819182a0-8fc7-413e-a97c-6172c3d67b1f	f	COLLECTION_76cc2d50-5342-4892-9941-9c9a29fdb8ca_WORKFLOW_STEP_2
\N	41c9f7db-106f-4419-8e72-d6c1be75b330	f	COLLECTION_76cc2d50-5342-4892-9941-9c9a29fdb8ca_WORKFLOW_STEP_3
\N	4d6b1150-1cd6-4668-bbe0-7835f0fbcb09	f	COLLECTION_eda85bf3-911b-4351-bfc3-c82d5256ae8c_WORKFLOW_STEP_2
\N	49755133-6ee6-414d-a9cb-fecf5284faf3	f	COLLECTION_0b5fe879-7875-49ad-9ec7-a3e653a4fa21_SUBMIT
\N	4a8be754-f9fe-485a-8b0e-11d730b3b124	f	COLLECTION_1c540749-d8a8-4b3c-a5e6-f007d7bb0f6c_SUBMIT
\N	7ec4b858-93ae-459b-9993-09170e3ade08	f	COMMUNITY_Colecao_Pedagogica_Ase_Tore_ADMIN
\N	9fd57935-4eb0-4ac6-97a2-6fced0595483	f	COLLECTION_f6c0759d-c7d8-4fcc-a58b-0c136ceeeac1_SUBMIT
\N	a5fe46d2-456a-4ba2-867a-afc530c3d434	f	COLLECTION_85c10a2c-5eaa-4e1a-b2da-147f45e2994f_SUBMIT
\N	e31a6004-ea04-469b-8d04-074de8c1943b	f	COLLECTION_2bc174cb-f53a-427b-bad9-d509c952308b_SUBMIT
\N	45b1ef5e-922d-44fe-98ee-b114086bf222	f	COLLECTION_5be5bcfe-1b10-424c-a3ce-14a0bf76980f_SUBMIT
\N	f493e7ce-6f98-451f-8ca4-3ec03915c37f	f	ADMIN_BIBLIOTECA
\N	5205e355-51c7-483c-b808-3b7ecfa6e5a1	f	COLLECTION_d3827ac3-c936-4aa4-8f44-b482f30e0897_SUBMIT
\N	d7635bc4-426d-4a42-8199-fa3a6fbf80f3	f	COMMUNITY_7b48288d-9562-40d5-9399-0cdb308679c4_ADMIN
\N	4273fe4b-70f2-4e46-88cd-901581fafe1e	f	COLLECTION_382716fe-9d12-4721-a491-452eb9e0b9b4_SUBMIT
\N	f987df74-7fb5-414d-950c-f38c238ad268	f	COMMUNITY_5399f765-8f84-4ecf-b72b-56ee8ed331a9_ADMIN
\N	f31b9fa2-1a95-4ddf-bdf7-a7bf138e1dea	f	COMMUNITY_20504b85-c194-4521-830e-d808b1504aba_ADMIN
\N	73f5f503-c67d-460f-8313-6e48c346c19a	f	COLLECTION_a9483ebc-ec0a-4ce8-bcc3-c23807ce6281_SUBMIT
\N	714e954e-296b-4618-990d-1e37f76b5986	f	COLLECTION_4cf73a02-5025-4e53-8cd9-90eac311d072_SUBMIT
\N	45d6280a-2e57-445d-9ef9-1077bc71f915	f	COLLECTION_e77edf9c-1dbb-4794-90d7-19b281d804b5_SUBMIT
\N	67557413-f959-42a7-91e0-bf5eeabfd263	f	COLLECTION_74edab96-f9d7-426e-b274-b96696c5718a_SUBMIT
\N	170cd97d-7d51-4ca2-b9c3-5f719c767b2b	f	COLLECTION_e73ea13a-089b-429d-80b2-7e8dcfc0de02_SUBMIT
\N	e60a371a-7223-4549-844b-6c811a6e92a9	f	COLLECTION_f687ad93-c741-4091-b2a8-bbe9b97c8fcf_SUBMIT
\N	85bd7949-2e63-4db6-9cef-fe4b163005bb	f	COLLECTION_9679f566-3d56-41f4-b5a7-92bb797e72bf_SUBMIT
\N	54cd4966-8160-459f-b43d-9eb411a5dc7a	f	COLLECTION_e4bd6a72-0086-4e4e-9838-a600b6bed7dc_SUBMIT
\N	d5cf8714-1fff-4f60-8c78-3f877fc172a8	f	COMMUNITY_9c5dcc10-fdfd-45da-b52a-6b7a930df3cb_ADMIN
\N	d2c7a0f1-60ea-474b-a236-3ba7eb3d52dd	f	COLLECTION_fb0a9847-448b-412a-b5fc-ca8dda1e957c_SUBMIT
\N	9eadd92d-59d3-42fd-9b6f-0d60438beaf4	f	COLLECTION_1f600b4c-7347-4c76-b114-efaf6f26e833_SUBMIT
\N	c03e1d36-546d-4f42-8fe8-b5d5f6d9f1c8	f	COLLECTION_314b7a6a-22d2-408b-bfce-6fed040f378f_SUBMIT
\N	6ba33fee-756d-42f1-ada9-8218a48f4338	f	COLLECTION_fc0677cc-e40f-48e8-822a-87d585e464ed_SUBMIT
\N	26cb99d7-7a32-4647-8d5e-4255dc01b1bf	f	COLLECTION_545507e3-5bb4-4974-9dc0-a178746ba385_SUBMIT
\N	9f72041b-ba44-4aa4-86be-97622d601cfe	f	COLLECTION_ab1ef24c-4faa-4c9e-bdc4-65acd4c67050_SUBMIT
\N	2e977e3b-be47-4499-a9aa-9bcbcfbf259b	f	COLLECTION_fb0a9847-448b-412a-b5fc-ca8dda1e957c_WORKFLOW_STEP_1
\.


--
-- Data for Name: epersongroup2eperson; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.epersongroup2eperson (eperson_group_id, eperson_id) FROM stdin;
a54a9824-240d-42ed-9290-df0f5fd46e4c	3c47b942-9ec4-4d9e-9f01-dd0990cf9baf
a54a9824-240d-42ed-9290-df0f5fd46e4c	1cc4acc6-fd4e-4d68-b8ed-28874371d752
a54a9824-240d-42ed-9290-df0f5fd46e4c	24547e55-3d4e-46d6-b048-356f3557eaa1
a54a9824-240d-42ed-9290-df0f5fd46e4c	fca1239c-fc4e-43df-b30c-85af0a2d0317
a54a9824-240d-42ed-9290-df0f5fd46e4c	8d71912f-e0c8-48d8-b606-c1eeaeb5ca95
a54a9824-240d-42ed-9290-df0f5fd46e4c	4d8c7a83-92fc-4480-a0ae-3fe64e170f95
a54a9824-240d-42ed-9290-df0f5fd46e4c	b8a75c11-585e-4dcf-831c-647be10c9915
819182a0-8fc7-413e-a97c-6172c3d67b1f	fca1239c-fc4e-43df-b30c-85af0a2d0317
819182a0-8fc7-413e-a97c-6172c3d67b1f	8d71912f-e0c8-48d8-b606-c1eeaeb5ca95
819182a0-8fc7-413e-a97c-6172c3d67b1f	3c47b942-9ec4-4d9e-9f01-dd0990cf9baf
819182a0-8fc7-413e-a97c-6172c3d67b1f	24547e55-3d4e-46d6-b048-356f3557eaa1
819182a0-8fc7-413e-a97c-6172c3d67b1f	1cc4acc6-fd4e-4d68-b8ed-28874371d752
41c9f7db-106f-4419-8e72-d6c1be75b330	fca1239c-fc4e-43df-b30c-85af0a2d0317
41c9f7db-106f-4419-8e72-d6c1be75b330	8d71912f-e0c8-48d8-b606-c1eeaeb5ca95
41c9f7db-106f-4419-8e72-d6c1be75b330	3c47b942-9ec4-4d9e-9f01-dd0990cf9baf
41c9f7db-106f-4419-8e72-d6c1be75b330	24547e55-3d4e-46d6-b048-356f3557eaa1
41c9f7db-106f-4419-8e72-d6c1be75b330	1cc4acc6-fd4e-4d68-b8ed-28874371d752
4d6b1150-1cd6-4668-bbe0-7835f0fbcb09	fca1239c-fc4e-43df-b30c-85af0a2d0317
4d6b1150-1cd6-4668-bbe0-7835f0fbcb09	8d71912f-e0c8-48d8-b606-c1eeaeb5ca95
4d6b1150-1cd6-4668-bbe0-7835f0fbcb09	3c47b942-9ec4-4d9e-9f01-dd0990cf9baf
4d6b1150-1cd6-4668-bbe0-7835f0fbcb09	24547e55-3d4e-46d6-b048-356f3557eaa1
4d6b1150-1cd6-4668-bbe0-7835f0fbcb09	1cc4acc6-fd4e-4d68-b8ed-28874371d752
7ec4b858-93ae-459b-9993-09170e3ade08	fca1239c-fc4e-43df-b30c-85af0a2d0317
7ec4b858-93ae-459b-9993-09170e3ade08	8d71912f-e0c8-48d8-b606-c1eeaeb5ca95
7ec4b858-93ae-459b-9993-09170e3ade08	3c47b942-9ec4-4d9e-9f01-dd0990cf9baf
7ec4b858-93ae-459b-9993-09170e3ade08	24547e55-3d4e-46d6-b048-356f3557eaa1
7ec4b858-93ae-459b-9993-09170e3ade08	1cc4acc6-fd4e-4d68-b8ed-28874371d752
f493e7ce-6f98-451f-8ca4-3ec03915c37f	8d71912f-e0c8-48d8-b606-c1eeaeb5ca95
f493e7ce-6f98-451f-8ca4-3ec03915c37f	3c47b942-9ec4-4d9e-9f01-dd0990cf9baf
f493e7ce-6f98-451f-8ca4-3ec03915c37f	1cc4acc6-fd4e-4d68-b8ed-28874371d752
\.


--
-- Data for Name: epersongroup2workspaceitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.epersongroup2workspaceitem (workspace_item_id, eperson_group_id) FROM stdin;
\.


--
-- Data for Name: fileextension; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.fileextension (file_extension_id, bitstream_format_id, extension) FROM stdin;
1	4	pdf
2	5	xml
3	6	txt
4	6	asc
5	7	htm
6	7	html
7	8	css
8	9	doc
9	10	docx
10	11	ppt
11	12	pptx
12	13	xls
13	14	xlsx
14	16	jpeg
15	16	jpg
16	17	gif
17	18	png
18	19	tiff
19	19	tif
20	20	aiff
21	20	aif
22	20	aifc
23	21	au
24	21	snd
25	22	wav
29	24	rtf
30	25	vsd
31	26	fm
32	27	bmp
33	28	psd
34	28	pdd
35	29	ps
36	29	eps
37	29	ai
38	30	mov
39	30	qt
40	31	mpa
41	31	abs
42	31	mpega
43	32	mpp
44	32	mpx
45	32	mpd
46	33	ma
47	34	latex
48	35	tex
49	36	dvi
50	37	sgm
51	37	sgml
52	38	wpd
53	39	ra
54	39	ram
55	40	pcd
56	41	odt
57	42	ott
58	43	oth
59	44	odm
60	45	odg
61	46	otg
62	47	odp
63	48	otp
64	49	ods
65	50	ots
66	51	odc
67	52	odf
68	53	odb
69	54	odi
70	55	oxt
71	56	sxw
72	57	stw
73	58	sxc
74	59	stc
75	60	sxd
76	61	std
77	62	sxi
78	63	sti
79	64	sxg
80	65	sxm
81	66	sdw
82	67	sgl
83	68	sdc
84	69	sda
85	70	sdd
86	71	sdp
87	72	smf
88	73	sds
89	74	sdm
90	75	rdf
91	76	epub
92	23	mpeg
93	23	mpg
94	23	mpe
96	77	PDF
\.


--
-- Data for Name: group2group; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.group2group (parent_id, child_id) FROM stdin;
819182a0-8fc7-413e-a97c-6172c3d67b1f	f493e7ce-6f98-451f-8ca4-3ec03915c37f
819182a0-8fc7-413e-a97c-6172c3d67b1f	a54a9824-240d-42ed-9290-df0f5fd46e4c
a54a9824-240d-42ed-9290-df0f5fd46e4c	f493e7ce-6f98-451f-8ca4-3ec03915c37f
41c9f7db-106f-4419-8e72-d6c1be75b330	f493e7ce-6f98-451f-8ca4-3ec03915c37f
4d6b1150-1cd6-4668-bbe0-7835f0fbcb09	f493e7ce-6f98-451f-8ca4-3ec03915c37f
f493e7ce-6f98-451f-8ca4-3ec03915c37f	a54a9824-240d-42ed-9290-df0f5fd46e4c
f493e7ce-6f98-451f-8ca4-3ec03915c37f	41c9f7db-106f-4419-8e72-d6c1be75b330
f493e7ce-6f98-451f-8ca4-3ec03915c37f	4d6b1150-1cd6-4668-bbe0-7835f0fbcb09
f493e7ce-6f98-451f-8ca4-3ec03915c37f	819182a0-8fc7-413e-a97c-6172c3d67b1f
f493e7ce-6f98-451f-8ca4-3ec03915c37f	7ec4b858-93ae-459b-9993-09170e3ade08
f493e7ce-6f98-451f-8ca4-3ec03915c37f	5a1ce1ca-510b-47a7-af88-69ace496d4e7
7ec4b858-93ae-459b-9993-09170e3ade08	f493e7ce-6f98-451f-8ca4-3ec03915c37f
7ec4b858-93ae-459b-9993-09170e3ade08	a54a9824-240d-42ed-9290-df0f5fd46e4c
\.


--
-- Data for Name: group2groupcache; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.group2groupcache (parent_id, child_id) FROM stdin;
\.


--
-- Data for Name: handle; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.handle (handle_id, handle, resource_type_id, resource_legacy_id, resource_id) FROM stdin;
13	123456789/12	4	\N	\N
1	123456789/0	5	\N	76d365c5-53f1-40c9-929d-239899a2472f
18	123456789/17	4	\N	\N
80	123456789/79	3	\N	\N
17	123456789/16	4	\N	\N
15	123456789/14	4	\N	\N
16	123456789/15	4	\N	\N
20	123456789/19	4	\N	\N
19	123456789/18	4	\N	\N
79	123456789/78	4	\N	\N
78	123456789/77	3	\N	\N
45	123456789/44	4	\N	\N
75	123456789/74	3	\N	\N
47	123456789/46	4	\N	\N
12	123456789/11	4	\N	d6941f14-9466-4dff-80d3-5e0809da53ce
82	123456789/81	3	\N	\N
8	123456789/7	4	\N	\N
9	123456789/8	3	\N	\N
7	123456789/6	4	\N	\N
21	123456789/20	3	\N	\N
4	123456789/3	3	\N	\N
5	123456789/4	3	\N	\N
3	123456789/2	3	\N	\N
87	123456789/86	2	\N	39926264-0a06-432f-bb03-18d391841d73
35	123456789/34	4	\N	\N
90	123456789/89	2	\N	2a3f97a9-f475-4ef6-bbc3-c83e6f0cf28d
91	123456789/90	2	\N	9e984c6f-a21b-4d2a-b168-59665345bb19
92	123456789/91	2	\N	5f935f7b-468a-4bd3-a610-0dd1c9b9edc3
81	123456789/80	4	\N	\N
86	123456789/85	4	\N	\N
85	123456789/84	4	\N	\N
83	123456789/82	4	\N	\N
89	123456789/88	4	\N	\N
88	123456789/87	4	\N	\N
84	123456789/83	4	\N	\N
93	123456789/92	3	\N	e77edf9c-1dbb-4794-90d7-19b281d804b5
94	123456789/93	2	\N	14875a45-2776-47af-b999-0ad20f1b7ff9
95	123456789/94	2	\N	454cf684-62f8-4b49-bfc5-b343499cf735
96	123456789/95	2	\N	c37aadfa-226f-4828-98bc-014c4e31d705
97	123456789/96	2	\N	121a4efd-d31c-4a8b-9d4c-f57c7f7d0c02
98	123456789/97	2	\N	f337e86e-7ee2-466c-841c-13b345ec5676
56	123456789/55	3	\N	\N
57	123456789/56	3	\N	\N
54	123456789/53	3	\N	\N
55	123456789/54	3	\N	\N
61	123456789/60	3	\N	fb0a9847-448b-412a-b5fc-ca8dda1e957c
60	123456789/59	3	\N	\N
63	123456789/62	2	\N	ac978e1a-ecdd-4409-982d-ad9f2c9d2933
52	123456789/51	3	\N	\N
58	123456789/57	3	\N	\N
64	123456789/63	3	\N	\N
66	123456789/65	3	\N	\N
65	123456789/64	3	\N	\N
69	123456789/68	3	\N	\N
67	123456789/66	3	\N	\N
70	123456789/69	2	\N	32d21a1d-acae-42b9-9edf-4e47710a340a
71	123456789/70	2	\N	b6dfa584-d9d6-4e67-9b10-13433ace7e38
72	123456789/71	2	\N	66bb3a28-09f6-4ced-8423-57b3d96b060f
68	123456789/67	3	\N	\N
62	123456789/61	3	\N	\N
59	123456789/58	4	\N	\N
53	123456789/52	3	\N	\N
74	123456789/73	3	\N	\N
73	123456789/72	3	\N	\N
77	123456789/76	3	\N	\N
76	123456789/75	3	\N	\N
46	123456789/45	4	\N	\N
10	123456789/9	4	\N	\N
11	123456789/10	4	\N	\N
22	123456789/21	4	\N	\N
6	123456789/5	4	\N	\N
48	123456789/47	4	\N	\N
50	123456789/49	4	\N	\N
51	123456789/50	4	\N	\N
49	123456789/48	4	\N	\N
14	123456789/13	4	\N	\N
23	123456789/22	4	\N	\N
24	123456789/23	4	\N	\N
25	123456789/24	4	\N	\N
26	123456789/25	4	\N	\N
27	123456789/26	4	\N	\N
28	123456789/27	4	\N	\N
29	123456789/28	4	\N	\N
30	123456789/29	4	\N	\N
31	123456789/30	4	\N	\N
32	123456789/31	4	\N	\N
33	123456789/32	4	\N	\N
34	123456789/33	4	\N	\N
36	123456789/35	4	\N	\N
37	123456789/36	4	\N	\N
38	123456789/37	4	\N	\N
39	123456789/38	4	\N	\N
40	123456789/39	4	\N	\N
41	123456789/40	4	\N	\N
42	123456789/41	4	\N	\N
43	123456789/42	4	\N	\N
44	123456789/43	4	\N	\N
2	123456789/1	4	\N	\N
\.


--
-- Data for Name: harvested_collection; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.harvested_collection (harvest_type, oai_source, oai_set_id, harvest_message, metadata_config_id, harvest_status, harvest_start_time, last_harvested, id, collection_id) FROM stdin;
\.


--
-- Data for Name: harvested_item; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.harvested_item (last_harvested, oai_id, id, item_id) FROM stdin;
\.


--
-- Data for Name: item; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.item (item_id, in_archive, withdrawn, last_modified, discoverable, uuid, submitter_id, owning_collection) FROM stdin;
\N	f	t	2023-09-04 14:52:34.474+00	t	66bb3a28-09f6-4ced-8423-57b3d96b060f	3c47b942-9ec4-4d9e-9f01-dd0990cf9baf	fb0a9847-448b-412a-b5fc-ca8dda1e957c
\N	t	f	2023-08-24 22:09:05.944+00	t	39926264-0a06-432f-bb03-18d391841d73	3c47b942-9ec4-4d9e-9f01-dd0990cf9baf	fb0a9847-448b-412a-b5fc-ca8dda1e957c
\N	t	f	2023-09-04 11:24:19.005+00	t	9e984c6f-a21b-4d2a-b168-59665345bb19	3c47b942-9ec4-4d9e-9f01-dd0990cf9baf	fb0a9847-448b-412a-b5fc-ca8dda1e957c
\N	t	f	2023-11-01 14:14:52.254+00	t	454cf684-62f8-4b49-bfc5-b343499cf735	3c47b942-9ec4-4d9e-9f01-dd0990cf9baf	fb0a9847-448b-412a-b5fc-ca8dda1e957c
\N	t	f	2023-08-24 17:07:04.721+00	t	32d21a1d-acae-42b9-9edf-4e47710a340a	3c47b942-9ec4-4d9e-9f01-dd0990cf9baf	fb0a9847-448b-412a-b5fc-ca8dda1e957c
\N	f	f	2023-08-10 20:02:23.613+00	t	74942b10-1340-4fbc-bbb8-7a868ec2bccb	\N	\N
\N	t	f	2023-08-24 17:17:53.799+00	t	ac978e1a-ecdd-4409-982d-ad9f2c9d2933	3c47b942-9ec4-4d9e-9f01-dd0990cf9baf	fb0a9847-448b-412a-b5fc-ca8dda1e957c
\N	t	f	2023-09-04 13:37:18.198+00	t	2a3f97a9-f475-4ef6-bbc3-c83e6f0cf28d	3c47b942-9ec4-4d9e-9f01-dd0990cf9baf	fb0a9847-448b-412a-b5fc-ca8dda1e957c
\N	t	f	2023-09-04 15:01:46.366+00	t	5f935f7b-468a-4bd3-a610-0dd1c9b9edc3	3c47b942-9ec4-4d9e-9f01-dd0990cf9baf	fb0a9847-448b-412a-b5fc-ca8dda1e957c
\N	t	f	2023-08-14 14:36:14.525+00	t	b6dfa584-d9d6-4e67-9b10-13433ace7e38	3c47b942-9ec4-4d9e-9f01-dd0990cf9baf	fb0a9847-448b-412a-b5fc-ca8dda1e957c
\N	t	f	2023-11-01 14:23:23.672+00	t	c37aadfa-226f-4828-98bc-014c4e31d705	3c47b942-9ec4-4d9e-9f01-dd0990cf9baf	fb0a9847-448b-412a-b5fc-ca8dda1e957c
\N	t	f	2023-11-06 13:38:27.527+00	t	f337e86e-7ee2-466c-841c-13b345ec5676	3c47b942-9ec4-4d9e-9f01-dd0990cf9baf	fb0a9847-448b-412a-b5fc-ca8dda1e957c
\N	t	f	2023-11-06 13:41:02.412+00	t	121a4efd-d31c-4a8b-9d4c-f57c7f7d0c02	3c47b942-9ec4-4d9e-9f01-dd0990cf9baf	fb0a9847-448b-412a-b5fc-ca8dda1e957c
\N	t	f	2023-11-01 14:06:12.534+00	t	14875a45-2776-47af-b999-0ad20f1b7ff9	3c47b942-9ec4-4d9e-9f01-dd0990cf9baf	fb0a9847-448b-412a-b5fc-ca8dda1e957c
\.


--
-- Data for Name: item2bundle; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.item2bundle (bundle_id, item_id) FROM stdin;
b69846db-0436-4b43-9f3c-8c32473591cd	ac978e1a-ecdd-4409-982d-ad9f2c9d2933
9151f169-1522-4613-92cc-c524bbddde5d	32d21a1d-acae-42b9-9edf-4e47710a340a
3fadcab8-0741-48bb-a6d4-e2498776b884	b6dfa584-d9d6-4e67-9b10-13433ace7e38
41004cb5-139b-460e-972d-cab8cb44c811	b6dfa584-d9d6-4e67-9b10-13433ace7e38
4401ba15-c530-48ee-b0af-d4e57e7fc0cb	66bb3a28-09f6-4ced-8423-57b3d96b060f
1ad028c5-ca62-409c-96d0-e90b9a547216	32d21a1d-acae-42b9-9edf-4e47710a340a
2a464f3f-cc84-40cb-b21b-9892d70707ac	ac978e1a-ecdd-4409-982d-ad9f2c9d2933
6c633236-b142-42a6-9bbc-421e3e921a75	39926264-0a06-432f-bb03-18d391841d73
67a933ee-2067-4da6-ae2b-2a0e5cf7e8ad	39926264-0a06-432f-bb03-18d391841d73
ff7d7cea-0e22-4c0a-8736-5c21a1cbe947	2a3f97a9-f475-4ef6-bbc3-c83e6f0cf28d
faf47611-7203-4c82-aedb-c5333d5e84a0	9e984c6f-a21b-4d2a-b168-59665345bb19
cfec0436-26af-4ba7-80d0-4fbdfd6220f7	9e984c6f-a21b-4d2a-b168-59665345bb19
9ac5b3f1-5be2-4f9f-a995-846b11e10e1e	2a3f97a9-f475-4ef6-bbc3-c83e6f0cf28d
efe24c20-53cd-4a4f-8f72-d599f8df7e1a	66bb3a28-09f6-4ced-8423-57b3d96b060f
a46768eb-dec3-44f6-84bb-e1a1496c616f	5f935f7b-468a-4bd3-a610-0dd1c9b9edc3
4def91f3-d15d-49b2-9fd8-2227cc555bf5	5f935f7b-468a-4bd3-a610-0dd1c9b9edc3
62807404-015a-42e4-bc1e-bdeb2501f94e	14875a45-2776-47af-b999-0ad20f1b7ff9
880da050-40ba-4eaf-a68c-edada75594a9	14875a45-2776-47af-b999-0ad20f1b7ff9
b97b63ea-ce0a-4c12-9e6b-1a4b3bb3876e	454cf684-62f8-4b49-bfc5-b343499cf735
9e7d3c2a-c897-4e5c-98d9-1751e8e50f47	454cf684-62f8-4b49-bfc5-b343499cf735
d836e6c1-1fc3-4658-af3a-8d368eb81fa3	c37aadfa-226f-4828-98bc-014c4e31d705
047efc13-5570-4018-a045-52dcc92d44da	c37aadfa-226f-4828-98bc-014c4e31d705
4b984d79-4db8-4fb5-a070-a18248c660ff	121a4efd-d31c-4a8b-9d4c-f57c7f7d0c02
1d9e8682-269c-4484-ad0c-423f98fed95c	121a4efd-d31c-4a8b-9d4c-f57c7f7d0c02
6b8fb088-d396-4c9d-bd8b-94e2f38ec447	f337e86e-7ee2-466c-841c-13b345ec5676
aaf93d7b-4387-450c-9b08-0da85be3df6a	f337e86e-7ee2-466c-841c-13b345ec5676
\.


--
-- Data for Name: metadatafieldregistry; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.metadatafieldregistry (metadata_field_id, metadata_schema_id, element, qualifier, scope_note) FROM stdin;
1	2	firstname	\N	\N
2	2	lastname	\N	\N
3	2	phone	\N	\N
4	2	language	\N	\N
5	1	provenance	\N	\N
6	1	rights	license	\N
7	1	contributor	\N	A person, organization, or service responsible for the content of the resource.  Catch-all for unspecified contributors.
8	1	contributor	advisor	Use primarily for thesis advisor.
9	1	contributor	author	\N
10	1	contributor	editor	\N
11	1	contributor	illustrator	\N
12	1	contributor	other	\N
13	1	coverage	spatial	Spatial characteristics of content.
14	1	coverage	temporal	Temporal characteristics of content.
15	1	creator	\N	Do not use; only for harvested metadata.
16	1	date	\N	Use qualified form if possible.
17	1	date	accessioned	Date DSpace takes possession of item.
18	1	date	available	Date or date range item became available to the public.
19	1	date	copyright	Date of copyright.
20	1	date	created	Date of creation or manufacture of intellectual content if different from date.issued.
21	1	date	issued	Date of publication or distribution.
22	1	date	submitted	Recommend for theses/dissertations.
23	1	identifier	\N	Catch-all for unambiguous identifiers not defined by\n    qualified form; use identifier.other for a known identifier common\n    to a local collection instead of unqualified form.
24	1	identifier	citation	Human-readable, standard bibliographic citation \n    of non-DSpace format of this item
25	1	identifier	govdoc	A government document number
26	1	identifier	isbn	International Standard Book Number
27	1	identifier	issn	International Standard Serial Number
28	1	identifier	sici	Serial Item and Contribution Identifier
29	1	identifier	ismn	International Standard Music Number
30	1	identifier	other	A known identifier type common to a local collection.
31	1	identifier	uri	Uniform Resource Identifier
32	1	description	\N	Catch-all for any description not defined by qualifiers.
33	1	description	abstract	Abstract or summary.
34	1	description	provenance	The history of custody of the item since its creation, including any changes successive custodians made to it.
35	1	description	sponsorship	Information about sponsoring agencies, individuals, or\n    contractual arrangements for the item.
36	1	description	statementofresponsibility	To preserve statement of responsibility from MARC records.
37	1	description	tableofcontents	A table of contents for a given item.
38	1	description	uri	Uniform Resource Identifier pointing to description of\n    this item.
39	1	format	\N	Catch-all for any format information not defined by qualifiers.
40	1	format	extent	Size or duration.
41	1	format	medium	Physical medium.
42	1	format	mimetype	Registered MIME type identifiers.
43	1	language	\N	Catch-all for non-ISO forms of the language of the\n    item, accommodating harvested values.
44	1	language	iso	Current ISO standard for language of intellectual content, including country codes (e.g. "en_US").
45	1	publisher	\N	Entity responsible for publication, distribution, or imprint.
46	1	relation	\N	Catch-all for references to other related items.
47	1	relation	isformatof	References additional physical form.
48	1	relation	ispartof	References physically or logically containing item.
49	1	relation	ispartofseries	Series name and number within that series, if available.
50	1	relation	haspart	References physically or logically contained item.
51	1	relation	isversionof	References earlier version.
52	1	relation	hasversion	References later version.
53	1	relation	isbasedon	References source.
54	1	relation	isreferencedby	Pointed to by referenced resource.
55	1	relation	requires	Referenced resource is required to support function,\n    delivery, or coherence of item.
56	1	relation	replaces	References preceeding item.
57	1	relation	isreplacedby	References succeeding item.
58	1	relation	uri	References Uniform Resource Identifier for related item.
59	1	rights	\N	Terms governing use and reproduction.
60	1	rights	uri	References terms governing use and reproduction.
61	1	source	\N	Do not use; only for harvested metadata.
62	1	source	uri	Do not use; only for harvested metadata.
63	1	subject	\N	Uncontrolled index term.
64	1	subject	classification	Catch-all for value from local classification system;\n    global classification systems will receive specific qualifier
65	1	subject	ddc	Dewey Decimal Classification Number
66	1	subject	lcc	Library of Congress Classification Number
67	1	subject	lcsh	Library of Congress Subject Headings
68	1	subject	mesh	MEdical Subject Headings
69	1	subject	other	Local controlled vocabulary; global vocabularies will receive specific qualifier.
70	1	title	\N	Title statement/title proper.
71	1	title	alternative	Varying (or substitute) form of title proper appearing in item,\n    e.g. abbreviation or translation
72	1	type	\N	Nature or genre of content.
73	3	abstract	\N	A summary of the resource.
74	3	accessRights	\N	Information about who can access the resource or an indication of its security status. May include information regarding access or restrictions based on privacy, security, or other policies.
75	3	accrualMethod	\N	The method by which items are added to a collection.
76	3	accrualPeriodicity	\N	The frequency with which items are added to a collection.
77	3	accrualPolicy	\N	The policy governing the addition of items to a collection.
78	3	alternative	\N	An alternative name for the resource.
79	3	audience	\N	A class of entity for whom the resource is intended or useful.
80	3	available	\N	Date (often a range) that the resource became or will become available.
81	3	bibliographicCitation	\N	Recommended practice is to include sufficient bibliographic detail to identify the resource as unambiguously as possible.
82	3	conformsTo	\N	An established standard to which the described resource conforms.
83	3	contributor	\N	An entity responsible for making contributions to the resource. Examples of a Contributor include a person, an organization, or a service.
84	3	coverage	\N	The spatial or temporal topic of the resource, the spatial applicability of the resource, or the jurisdiction under which the resource is relevant.
85	3	created	\N	Date of creation of the resource.
86	3	creator	\N	An entity primarily responsible for making the resource.
87	3	date	\N	A point or period of time associated with an event in the lifecycle of the resource.
88	3	dateAccepted	\N	Date of acceptance of the resource.
89	3	dateCopyrighted	\N	Date of copyright.
90	3	dateSubmitted	\N	Date of submission of the resource.
91	3	description	\N	An account of the resource.
92	3	educationLevel	\N	A class of entity, defined in terms of progression through an educational or training context, for which the described resource is intended.
93	3	extent	\N	The size or duration of the resource.
94	3	format	\N	The file format, physical medium, or dimensions of the resource.
95	3	hasFormat	\N	A related resource that is substantially the same as the pre-existing described resource, but in another format.
96	3	hasPart	\N	A related resource that is included either physically or logically in the described resource.
97	3	hasVersion	\N	A related resource that is a version, edition, or adaptation of the described resource.
98	3	identifier	\N	An unambiguous reference to the resource within a given context.
99	3	instructionalMethod	\N	A process, used to engender knowledge, attitudes and skills, that the described resource is designed to support.
100	3	isFormatOf	\N	A related resource that is substantially the same as the described resource, but in another format.
101	3	isPartOf	\N	A related resource in which the described resource is physically or logically included.
102	3	isReferencedBy	\N	A related resource that references, cites, or otherwise points to the described resource.
103	3	isReplacedBy	\N	A related resource that supplants, displaces, or supersedes the described resource.
104	3	isRequiredBy	\N	A related resource that requires the described resource to support its function, delivery, or coherence.
105	3	issued	\N	Date of formal issuance (e.g., publication) of the resource.
106	3	isVersionOf	\N	A related resource of which the described resource is a version, edition, or adaptation.
107	3	language	\N	A language of the resource.
108	3	license	\N	A legal document giving official permission to do something with the resource.
109	3	mediator	\N	An entity that mediates access to the resource and for whom the resource is intended or useful.
110	3	medium	\N	The material or physical carrier of the resource.
111	3	modified	\N	Date on which the resource was changed.
112	3	provenance	\N	A statement of any changes in ownership and custody of the resource since its creation that are significant for its authenticity, integrity, and interpretation.
113	3	publisher	\N	An entity responsible for making the resource available.
114	3	references	\N	A related resource that is referenced, cited, or otherwise pointed to by the described resource.
115	3	relation	\N	A related resource.
116	3	replaces	\N	A related resource that is supplanted, displaced, or superseded by the described resource.
117	3	requires	\N	A related resource that is required by the described resource to support its function, delivery, or coherence.
118	3	rights	\N	Information about rights held in and over the resource.
119	3	rightsHolder	\N	A person or organization owning or managing rights over the resource.
120	3	source	\N	A related resource from which the described resource is derived.
121	3	spatial	\N	Spatial characteristics of the resource.
122	3	subject	\N	The topic of the resource.
123	3	tableOfContents	\N	A list of subunits of the resource.
124	3	temporal	\N	Temporal characteristics of the resource.
125	3	title	\N	A name given to the resource.
126	3	type	\N	The nature or genre of the resource.
127	3	valid	\N	Date (often a range) of validity of a resource.
128	1	date	updated	The last time the item was updated via the SWORD interface
129	1	description	version	The Peer Reviewed status of an item
130	1	identifier	slug	a uri supplied via the sword slug header, as a suggested uri for the item
131	1	language	rfc3066	the rfc3066 form of the language for the item
132	1	rights	holder	The owner of the copyright
\.


--
-- Data for Name: metadataschemaregistry; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.metadataschemaregistry (metadata_schema_id, namespace, short_id) FROM stdin;
1	http://dublincore.org/documents/dcmi-terms/	dc
2	http://dspace.org/eperson	eperson
3	http://purl.org/dc/terms/	dcterms
4	http://dspace.org/namespace/local/	local
\.


--
-- Data for Name: metadatavalue; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.metadatavalue (metadata_value_id, metadata_field_id, text_value, text_lang, place, authority, confidence, dspace_object_id) FROM stdin;
1	2	dos Santos	\N	0	\N	-1	1cc4acc6-fd4e-4d68-b8ed-28874371d752
2	1	Valdir Nascimento	\N	0	\N	-1	1cc4acc6-fd4e-4d68-b8ed-28874371d752
3	4	pt	\N	0	\N	-1	1cc4acc6-fd4e-4d68-b8ed-28874371d752
4	2	Ribeiro	\N	0	\N	-1	3c47b942-9ec4-4d9e-9f01-dd0990cf9baf
5	1	Andreia	\N	0	\N	-1	3c47b942-9ec4-4d9e-9f01-dd0990cf9baf
6	4	pt	\N	0	\N	-1	3c47b942-9ec4-4d9e-9f01-dd0990cf9baf
7	2	de Jesus Damasceno	\N	0	\N	-1	24547e55-3d4e-46d6-b048-356f3557eaa1
8	1	Heide	\N	0	\N	-1	24547e55-3d4e-46d6-b048-356f3557eaa1
9	4	pt	\N	0	\N	-1	24547e55-3d4e-46d6-b048-356f3557eaa1
10	2	Arao	\N	0	\N	-1	fca1239c-fc4e-43df-b30c-85af0a2d0317
11	1	Jacineide	\N	0	\N	-1	fca1239c-fc4e-43df-b30c-85af0a2d0317
12	4	pt	\N	0	\N	-1	fca1239c-fc4e-43df-b30c-85af0a2d0317
13	2	Fonseca	\N	0	\N	-1	8d71912f-e0c8-48d8-b606-c1eeaeb5ca95
14	1	Rita	\N	0	\N	-1	8d71912f-e0c8-48d8-b606-c1eeaeb5ca95
15	4	pt	\N	0	\N	-1	8d71912f-e0c8-48d8-b606-c1eeaeb5ca95
16	2	Teixeira	\N	0	\N	-1	4d8c7a83-92fc-4480-a0ae-3fe64e170f95
17	1	Ana Paula	\N	0	\N	-1	4d8c7a83-92fc-4480-a0ae-3fe64e170f95
18	4	pt	\N	0	\N	-1	4d8c7a83-92fc-4480-a0ae-3fe64e170f95
19	2	Bahia	\N	0	\N	-1	b8a75c11-585e-4dcf-831c-647be10c9915
20	1	Teresa	\N	0	\N	-1	b8a75c11-585e-4dcf-831c-647be10c9915
21	4	pt	\N	0	\N	-1	b8a75c11-585e-4dcf-831c-647be10c9915
961	70	ORIGINAL	\N	1	\N	-1	1ad028c5-ca62-409c-96d0-e90b9a547216
900	70	capa caderno1.jpg	\N	0	\N	-1	96b11f13-ad11-4e20-abb1-1b59f0ad90bb
56	70	MARCA_IFBA_CMYK_DPAAE_HORIZONTAL_completa_.jpg	\N	0	\N	-1	04526745-5792-4bc4-902a-13833602fb16
57	61	/dspace/upload/MARCA_IFBA_CMYK_DPAAE_HORIZONTAL_completa_.jpg	\N	0	\N	-1	04526745-5792-4bc4-902a-13833602fb16
901	61	/dspace/upload/capa caderno1.jpg	\N	0	\N	-1	96b11f13-ad11-4e20-abb1-1b59f0ad90bb
1040	70	ORIGINAL	\N	1	\N	-1	2a464f3f-cc84-40cb-b21b-9892d70707ac
975	33	“Asé-Toré”, junção das palavras “Asé” (na língua\r\niorubá, significa poder, energia ou força presente\r\nem cada ser ou em cada coisa, que nas religiões afro\r\n-\r\n-brasileiras representa a energia sagrada dos orixás)\r\ne “Toré” (expressão espiritual-religiosa de grande\r\nimportância para os indígenas), significa para nós o\r\nresgate da força coletiva e energia vital da ancestra\r\n-\r\nlidade para vencer os desafios contemporâneos do\r\npovo negro e indígena.\r\nÉ com este nome repleto de significados e potências\r\nque a Diretoria Sistêmica de Políticas Afirmativas e\r\nAssuntos Estudantis – DPAAE/IFBA apresenta à co\r\n-\r\nmunidade interna e externa do Instituto Federal de\r\nEducação, Ciência e Tecnologia da Bahia (IFBA) esta\r\nColeção Pedagógica, um dos produtos do “Programa\r\nAsé-Toré: Formação em educação sobre negras(os)\r\ne povos indígenas do Instituto Federal de Educação,\r\nCiência e Tecnologia (IFBA), voltado à formação de\r\ngestoras(es), professoras(es), técnicas(os) administra\r\n-\r\ntivas(os), estudantes e comunidade na área da Educa\r\n-\r\nção das Relações Étnico-Raciais e ao enfrentamento\r\nao racismo no âmbito do IFBA.\r\nO Programa Asé-Toré foi institucionalizado por meio\r\nde Chamada Pública do IFBA/DPAAE, que possibilitou\r\na contratação de duas Coordenadoras (Coordenadora\r\nGeral e Coordenadora dos Cadernos Temáticos); 15\r\nbolsistas “professores conteudistas”; cinco bolsistas\r\n“professores pareceristas”; dois apoios administrati\r\n-\r\nvos pedagógicos e uma ilustradora para a produção\r\ndos Cadernos Temáticos. Envolveu, ainda, mais de dez\r\npesquisadoras(es) para o Conselho Editorial e diver\r\n-\r\nsas(os) servidoras(es) internos e externos do IFBA que\r\ncontribuíram na seleção dos bolsistas.\r\nA DPAAE é uma Diretoria recente na história do IFBA,\r\nsendo criada em 2020. Desta forma, a entrega à so\r\n-\r\nciedade da Coleção Pedagógica Asé-Toré se torna um\r\nmarco importante no cumprimento às normativas\r\nque tratam da educação das relações étnico-raciais o\r\nqual foi também missão da Diretoria. A Coleção tem\r\no objetivo de promover a Educação das Relações Ét\r\n-\r\nnico-raciais, cumprindo a Lei de Diretrizes e Base da\r\nEducação Nacional – LDB, especialmente no que con\r\n-\r\ncerne à implantação das Leis Federais nº 10.639/03\r\ne nº 11.645/08, as quais afirmam a obrigatoriedade\r\ndo estudo da “História da África e dos africanos”, da\r\n“luta dos negros e dos povos indígenas no Brasil”, da\r\n“cultura negra e indígena brasileira” e “o negro e o\r\níndio na formação da sociedade nacional”, “resgatan\r\n-\r\ndo as suas contribuições nas áreas social, econômica\r\ne política, pertinentes à história do Brasil.” (BRASIL,\r\n2008). Do mesmo modo, considerou-se as Diretrizes\r\n10\r\nCurriculares Nacionais para a Educação das Relações\r\nÉtnico-Raciais e para o Ensino de História e Cultura\r\nAfro-Brasileira e Africana, passando, ainda, por outras\r\nnormativas do estado da Bahia.\r\nComposta por 15 cadernos temáticos, a Coleção Pedagógica Asé-Toré cumpre esforços institucionais de\r\ncontribuir com a formulação de um material didático,\r\nfundamentado numa perspectiva de valorização da\r\neducação das relações étnico-raciais, da diversidade\r\nétnico-racial na educação, no enfrentamento ao racismo institucional, na valorização das ações afirmativas\r\npara a população negra e povos indígenas. Representa, ademais, contribuições coletivas de profissionais,\r\npesquisadoras/intelectuais ativistas ou não, em sua\r\nmaioria negros e mulheres, sendo destacada a participação de dois indígenas. Estas(es) pesquisadoras(es)\r\nse dedicaram a uma metodologia inovadora de trabalho baseada em aspectos da cosmovisão de mundo\r\nafricana e indígena, enfatizando o trabalho coletivo,\r\nvalorizando as lutas sociais, a produção de autoras(es)\r\nnegras(os) e indígenas e considerando suas vivências\r\ne experiências na forma e formato dos conteúdos e\r\nimagens.\r\nO Programa Asé-Toré nasceu a partir de um projeto\r\nmais amplo de implementação da Lei 10.639/03,\r\noriginalmente escrito por mim, Marcilene Garcia de\r\nSouza, e pelo professor Dr. Hélio Santos, em 2017.\r\nAqui no IFBA (DPAAE), o Programa se apresentou\r\nde forma mais sintetizada em que se destacam três\r\nprodutos: Produção dos 15 Cadernos Temáticos; Institucionalização de uma biblioteca virtual temática e\r\numa série de formações sobre educação das relações\r\nétnico-raciais.\r\nFaz-se necessário registrar o empenho da gestão\r\ndo IFBA para a realização do Programa Asé-Toré, na\r\npessoa da Reitora Profa. Dra. Luzia Matos Mota, que\r\né mulher negra, e na do Pró-Reitor de Ensino, Prof.\r\nDr. Jancarlos Lapa, mas também da Equipe gestora da DPAAE que contribui de forma mais direta na\r\nexecução do Programa: Profa. Mestra Thelma Ramos\r\n(Chefe da Coordenação Indígena e Povos Tradicionais\r\n– CIND/DPAF/DPAAE), a pedagoga Jacineide Arão\r\ndos Santos Profeta (Chefe do Departamento de Políticas Afirmativas – DPAF/DPAAE) e a assistente social\r\nCacilda Ferreira dos Reis (Chefe do Departamento de\r\nAssuntos Estudantis – DAES/DPAAE).\r\n\r\nPROFª. DRA. MARCILENE GARCIA DE SOUZA\r\nDIRETORA SISTÊMICA DE POLÍTICAS AFIRMATIVAS\r\nE ASSUNTOS ESTUDANTIS DO IFBA	pt_BR	0	\N	-1	32d21a1d-acae-42b9-9edf-4e47710a340a
976	34	Submitted by Andreia Ribeiro (andreiasr@ifba.edu.br) on 2023-08-14T14:03:14Z\r\nNo. of bitstreams: 1\r\nDiversidade_saberes_dos_povos_Indigenas.pdf: 10218276 bytes, checksum: d4c237ab0d4ab14172c7d037e1cb2640 (MD5)	en	0	\N	-1	32d21a1d-acae-42b9-9edf-4e47710a340a
68	70	Logo Asé-Toré.jpeg	\N	0	\N	-1	55e591b9-f933-4b9f-aaac-a33dc775f60f
69	61	/dspace/upload/Logo Asé-Toré.jpeg	\N	0	\N	-1	55e591b9-f933-4b9f-aaac-a33dc775f60f
163	70	ase tore.jpg	\N	0	\N	-1	84d2756c-8775-4c78-bbc9-351601ea3744
164	61	/dspace/upload/ase tore.jpg	\N	0	\N	-1	84d2756c-8775-4c78-bbc9-351601ea3744
1901	21	2023-10-30	\N	0	\N	-1	14875a45-2776-47af-b999-0ad20f1b7ff9
96	70	Logo IFBA.jpg	\N	0	\N	-1	9a1f7bb7-6d07-4a42-8c2f-044b8a8b6ff5
97	61	/dspace/upload/Logo IFBA.jpg	\N	0	\N	-1	9a1f7bb7-6d07-4a42-8c2f-044b8a8b6ff5
1043	70	Lei 11.645 08 e a educacao indigena. Cad2.pdf	\N	0	\N	-1	c54a90fa-33e6-4c0b-b3c5-39e52d0a6887
192	70	ase tore.jpg	\N	0	\N	-1	12f32e5e-3f28-40ba-bdbb-9264ab53f973
193	61	/dspace/upload/ase tore.jpg	\N	0	\N	-1	12f32e5e-3f28-40ba-bdbb-9264ab53f973
860	1	JANAÍNA	\N	0	\N	-1	10634130-ae05-4344-9a59-207b9d141d06
861	2	REBÊLO	\N	0	\N	-1	10634130-ae05-4344-9a59-207b9d141d06
862	3	66992209904	\N	0	\N	-1	10634130-ae05-4344-9a59-207b9d141d06
863	4	pt_BR	\N	0	\N	-1	10634130-ae05-4344-9a59-207b9d141d06
1044	61	/dspace/upload/Lei 11.645 08 e a educacao indigena. Cad2.pdf	\N	0	\N	-1	c54a90fa-33e6-4c0b-b3c5-39e52d0a6887
964	70	Diversidade de saberes dos povos indigenas.Cad1.pdf	\N	0	\N	-1	e19de17d-d456-4b3b-8102-d1a012594d36
965	61	/dspace/upload/Diversidade de saberes dos povos indigenas.Cad1.pdf	\N	0	\N	-1	e19de17d-d456-4b3b-8102-d1a012594d36
966	32	Caderno 1	\N	0	\N	-1	e19de17d-d456-4b3b-8102-d1a012594d36
967	70	license.txt	\N	0	\N	-1	7ecddc58-7be4-4c9b-afb6-7cf47980bdbb
968	61	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	7ecddc58-7be4-4c9b-afb6-7cf47980bdbb
969	9	IFBA, Diretoria de Políticas Afirmativas e Assuntos Estudantis	\N	0	\N	-1	32d21a1d-acae-42b9-9edf-4e47710a340a
970	9	Borum-Kren, Barbara Flores	\N	1	\N	-1	32d21a1d-acae-42b9-9edf-4e47710a340a
971	17	2023-08-14T14:03:14Z	\N	0	\N	-1	32d21a1d-acae-42b9-9edf-4e47710a340a
972	18	2023-08-14T14:03:14Z	\N	0	\N	-1	32d21a1d-acae-42b9-9edf-4e47710a340a
973	21	2023-08-14	\N	0	\N	-1	32d21a1d-acae-42b9-9edf-4e47710a340a
977	34	Made available in DSpace on 2023-08-14T14:03:14Z (GMT). No. of bitstreams: 1\r\nDiversidade_Saberes_dos_Povos_Indigenas.pdf: 10218276 bytes, checksum: d4c237ab0d4ab14172c7d037e1cb2640 (MD5)\r\n  Previous issue date: 2023-08-14	en	1	\N	-1	32d21a1d-acae-42b9-9edf-4e47710a340a
978	26	978-65-88985-18-2	\N	0	\N	-1	32d21a1d-acae-42b9-9edf-4e47710a340a
979	31	http://www.asetore.ifba.edu.br:8080/jspui/handle/123456789/69	\N	0	\N	-1	32d21a1d-acae-42b9-9edf-4e47710a340a
980	44	pt_BR	pt_BR	0	\N	-1	32d21a1d-acae-42b9-9edf-4e47710a340a
981	45	EDIFBA	pt_BR	0	\N	-1	32d21a1d-acae-42b9-9edf-4e47710a340a
982	49	Coleção Pedagógica do Programa Asé Toré Formação em Educação sobre negras(os) e Povos Indígenas, Caderno 1.	\N	0	\N	-1	32d21a1d-acae-42b9-9edf-4e47710a340a
983	63	Povos Indígenas	pt_BR	0	\N	-1	32d21a1d-acae-42b9-9edf-4e47710a340a
984	63	História	pt_BR	1	\N	-1	32d21a1d-acae-42b9-9edf-4e47710a340a
985	63	Cultura	pt_BR	2	\N	-1	32d21a1d-acae-42b9-9edf-4e47710a340a
986	63	Políticas Afirmativas	pt_BR	3	\N	-1	32d21a1d-acae-42b9-9edf-4e47710a340a
987	63	Tradição	pt_BR	4	\N	-1	32d21a1d-acae-42b9-9edf-4e47710a340a
988	63	Saberes	pt_BR	5	\N	-1	32d21a1d-acae-42b9-9edf-4e47710a340a
989	63	Diversidade	pt_BR	6	\N	-1	32d21a1d-acae-42b9-9edf-4e47710a340a
990	70	Diversidade de Saberes dos Povos Indígenas	pt_BR	0	\N	-1	32d21a1d-acae-42b9-9edf-4e47710a340a
1100	63	Povos Indígenas	pt_BR	0	\N	-1	39926264-0a06-432f-bb03-18d391841d73
1101	63	História - Cultura	pt_BR	1	\N	-1	39926264-0a06-432f-bb03-18d391841d73
1102	63	Brasil	pt_BR	2	\N	-1	39926264-0a06-432f-bb03-18d391841d73
1103	63	Bahia	pt_BR	3	\N	-1	39926264-0a06-432f-bb03-18d391841d73
1104	33	“Asé-Toré”, junção das palavras “Asé” (na língua\r\niorubá, significa poder, energia ou força presente\r\nem cada ser ou em cada coisa, que nas religiões afro\r\n-\r\n-brasileiras representa a energia sagrada dos orixás)\r\ne “Toré” (expressão espiritual-religiosa de grande\r\nimportância para os indígenas), significa para nós o\r\nresgate da força coletiva e energia vital da ancestra\r\n-\r\nlidade para vencer os desafios contemporâneos do\r\npovo negro e indígena.\r\nÉ com este nome repleto de significados e potências\r\nque a Diretoria Sistêmica de Políticas Afirmativas e\r\nAssuntos Estudantis – DPAAE/IFBA apresenta à co\r\n-\r\nmunidade interna e externa do Instituto Federal de\r\nEducação, Ciência e Tecnologia da Bahia (IFBA) esta\r\nColeção Pedagógica, um dos produtos do “Programa\r\nAsé-Toré: Formação em educação sobre negras(os)\r\ne povos indígenas do Instituto Federal de Educação,\r\nCiência e Tecnologia (IFBA), voltado à formação de\r\ngestoras(es), professoras(es), técnicas(os) administra\r\n-\r\ntivas(os), estudantes e comunidade na área da Educa\r\n-\r\nção das Relações Étnico-Raciais e ao enfrentamento\r\nao racismo no âmbito do IFBA.\r\nO Programa Asé-Toré foi institucionalizado por meio\r\nde Chamada Pública do IFBA/DPAAE, que possibilitou\r\na contratação de duas Coordenadoras (Coordenadora\r\n\r\nGeral e Coordenadora dos Cadernos Temáticos); 15\r\nbolsistas “professores conteudistas”; cinco bolsistas\r\n“professores pareceristas”; dois apoios administrati\r\n-\r\nvos pedagógicos e uma ilustradora para a produção\r\ndos Cadernos Temáticos. Envolveu, ainda, mais de dez\r\npesquisadoras(es) para o Conselho Editorial e diver\r\n-\r\nsas(os) servidoras(es) internos e externos do IFBA que\r\ncontribuíram na seleção dos bolsistas.\r\nA DPAAE é uma Diretoria recente na história do IFBA,\r\nsendo criada em 2020. Desta forma, a entrega à so\r\n-\r\nciedade da Coleção Pedagógica Asé-Toré se torna um\r\nmarco importante no cumprimento às normativas\r\nque tratam da educação das relações étnico-raciais o\r\nqual foi também missão da Diretoria. A Coleção tem\r\no objetivo de promover a Educação das Relações Ét\r\n-\r\nnico-raciais, cumprindo a Lei de Diretrizes e Base da\r\nEducação Nacional – LDB, especialmente no que con\r\n-\r\ncerne à implantação das Leis Federais no 10.639/03\r\ne no 11.645/08, as quais afirmam a obrigatoriedade\r\ndo estudo da “História da África e dos africanos”, da\r\n“luta dos negros e dos povos indígenas no Brasil”, da\r\n“cultura negra e indígena brasileira” e “o negro e o\r\níndio na formação da sociedade nacional”, “resgatan\r\n-\r\ndo as suas contribuições nas áreas social, econômica\r\ne política, pertinentes à história do Brasil.” (BRASIL,\r\n2008). Do mesmo modo, considerou-se as Diretrizes\r\n\r\n10\r\n\r\nCurriculares Nacionais para a Educação das Relações\r\nÉtnico-Raciais e para o Ensino de História e Cultura\r\nAfro-Brasileira e Africana, passando, ainda, por outras\r\nnormativas do estado da Bahia.\r\nComposta por 15 cadernos temáticos, a Coleção Pe\r\n-\r\ndagógica Asé-Toré cumpre esforços institucionais de\r\ncontribuir com a formulação de um material didático,\r\nfundamentado numa perspectiva de valorização da\r\neducação das relações étnico-raciais, da diversidade\r\nétnico-racial na educação, no enfrentamento ao racis\r\n-\r\nmo institucional, na valorização das ações afirmativas\r\npara a população negra e povos indígenas. Represen\r\n-\r\nta, ademais, contribuições coletivas de profissionais,\r\npesquisadoras/intelectuais ativistas ou não, em sua\r\nmaioria negros e mulheres, sendo destacada a parti\r\n-\r\ncipação de dois indígenas. Estas(es) pesquisadoras(es)\r\nse dedicaram a uma metodologia inovadora de traba\r\n-\r\nlho baseada em aspectos da cosmovisão de mundo\r\nafricana e indígena, enfatizando o trabalho coletivo,\r\nvalorizando as lutas sociais, a produção de autoras(es)\r\nnegras(os) e indígenas e considerando suas vivências\r\ne experiências na forma e formato dos conteúdos e\r\nimagens.\r\nO Programa Asé-Toré nasceu a partir de um projeto\r\nmais amplo de implementação da Lei 10.639/03,\r\n\r\noriginalmente escrito por mim, Marcilene Garcia de\r\nSouza, e pelo professor Dr. Hélio Santos, em 2017.\r\nAqui no IFBA (DPAAE), o Programa se apresentou\r\nde forma mais sintetizada em que se destacam três\r\nprodutos: Produção dos 15 Cadernos Temáticos; Ins\r\n-\r\ntitucionalização de uma biblioteca virtual temática e\r\numa série de formações sobre educação das relações\r\nétnico-raciais.\r\nFaz-se necessário registrar o empenho da gestão\r\ndo IFBA para a realização do Programa Asé-Toré, na\r\npessoa da Reitora Profa. Dra. Luzia Matos Mota, que\r\né mulher negra, e na do Pró-Reitor de Ensino, Prof.\r\nDr. Jancarlos Lapa, mas também da Equipe gesto\r\n-\r\nra da DPAAE que contribui de forma mais direta na\r\nexecução do Programa: Profa. Mestra Thelma Ramos\r\n(Chefe da Coordenação Indígena e Povos Tradicionais\r\n– CIND/DPAF/DPAAE), a pedagoga Jacineide Arão\r\ndos Santos Profeta (Chefe do Departamento de Políti\r\n-\r\ncas Afirmativas – DPAF/DPAAE) e a assistente social\r\nCacilda Ferreira dos Reis (Chefe do Departamento de\r\nAssuntos Estudantis – DAES/DPAAE).\r\n\r\nPROFa. DRA. MARCILENE GARCIA DE SOUZA\r\nDIRETORA SISTÊMICA DE POLÍTICAS AFIRMATIVAS\r\nE ASSUNTOS ESTUDANTIS DO IFBA	pt_BR	0	\N	-1	39926264-0a06-432f-bb03-18d391841d73
1745	34	Item withdrawn by Andreia Ribeiro (andreiasr@ifba.edu.br) on 2023-09-04T14:52:34Z\nItem was in collections:\nCadernos Temáticos - Coleção Pedagógica Asé-Toré (ID: fb0a9847-448b-412a-b5fc-ca8dda1e957c)\nNo. of bitstreams: 1\nMovimentos negros contemporaneos cad.15.pdf: 12365504 bytes, checksum: a441f69ee22e595946db6162948b6824 (MD5)	en	2	\N	-1	66bb3a28-09f6-4ced-8423-57b3d96b060f
1836	1	Lizandra	\N	0	\N	-1	2444618d-48d1-4603-8cbb-ba77ed74fdd5
1837	2	Sacramento	\N	0	\N	-1	2444618d-48d1-4603-8cbb-ba77ed74fdd5
1838	3	71983460870	\N	0	\N	-1	2444618d-48d1-4603-8cbb-ba77ed74fdd5
1045	32	Caderno 2	\N	0	\N	-1	c54a90fa-33e6-4c0b-b3c5-39e52d0a6887
1046	70	license.txt	\N	0	\N	-1	6976abc2-963e-4646-9a1a-0b84cf194e14
1839	4	pt_BR	\N	0	\N	-1	2444618d-48d1-4603-8cbb-ba77ed74fdd5
2104	1	Gerson Luis	\N	0	\N	-1	508ee530-f344-4895-b49f-12fbbed92be0
2105	2	da Luz	\N	0	\N	-1	508ee530-f344-4895-b49f-12fbbed92be0
2106	3	48996120976	\N	0	\N	-1	508ee530-f344-4895-b49f-12fbbed92be0
974	32	O Instituto Federal de Educação, Ciência e Tecnologia\r\nda Bahia tem a honra de apresentar a Coleção Pedagógica do Programa Asé-Toré: Formação em Educação\r\nsobre negras(os) e povos indígenas, produto de um dos\r\nProgramas de educação para relações étnico-raciais\r\ndesenvolvido pela Diretoria Sistêmica de Políticas Afirmativas e Assuntos Estudantis – DPAAE/IFBA.\r\nEstamos felizes em materializar esta coleção, que\r\nmarca o compromisso da nossa instituição em validar\r\na legislação nacional que trata da obrigatoriedade\r\nde educar sobre História da África, afro-brasileira e\r\nindígena, identificando-a como conquista dos movimentos sociais, negros e indígenas brasileiros. Assim,\r\nreconhecemos as lutas de quem veio antes, agradecemos às/aos servidoras/es, gestoras/es e estudantes\r\nque bravamente promovem o debate racial no IFBA\r\ne fortalecemos esforços em prol de uma educação\r\nantirracista.\r\nPREFÁCIO\r\nA Coleção Pedagógica Asé-Toré representa um marco na institucionalidade de ações que contribuem\r\npara que o IFBA solidifique sua missão institucional:\r\n“Promover a formação do cidadão histórico-crítico,\r\noferecendo ensino, pesquisa e extensão com qualidade socialmente referenciada, objetivando o desenvolvimento sustentável do país”. Além disso, a Coleção\r\ninaugura novas estratégias institucionais e interdisciplinares, ao desenvolver um produto didático e acessível a todos os níveis, formas e modalidades de ensino\r\nque ofertamos.\r\nDesejo boa leitura e estudos. Que a Coleção Pedagógica Asé-Toré alcance a comunidade do IFBA e, também, as famílias dos nossos estudantes, organizações\r\nsociais e instituições de ensino do nosso Estado e país.\r\nPROFESSORA DRA. LUZIA MATOS MOTA\r\nREITORA DO IFBA	pt_BR	0	\N	-1	32d21a1d-acae-42b9-9edf-4e47710a340a
991	72	Livro	pt_BR	0	\N	-1	32d21a1d-acae-42b9-9edf-4e47710a340a
201	70	ase tore.jpg	\N	0	\N	-1	42590e9d-eaf5-4479-ab2c-810b7e0ce06e
202	61	/dspace/upload/ase tore.jpg	\N	0	\N	-1	42590e9d-eaf5-4479-ab2c-810b7e0ce06e
2107	4	pt_BR	\N	0	\N	-1	508ee530-f344-4895-b49f-12fbbed92be0
1047	61	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	6976abc2-963e-4646-9a1a-0b84cf194e14
1048	9	IFBA, Diretoria de Políticas Afirmativas e Assuntos Estudantis	\N	0	\N	-1	ac978e1a-ecdd-4409-982d-ad9f2c9d2933
1049	9	Kayapó, Edson	\N	1	\N	-1	ac978e1a-ecdd-4409-982d-ad9f2c9d2933
1050	17	2023-08-04T19:49:22Z	\N	0	\N	-1	ac978e1a-ecdd-4409-982d-ad9f2c9d2933
1051	18	2023-08-04T19:49:22Z	\N	0	\N	-1	ac978e1a-ecdd-4409-982d-ad9f2c9d2933
1052	21	2023-08	\N	0	\N	-1	ac978e1a-ecdd-4409-982d-ad9f2c9d2933
1053	32	O Instituto Federal de Educação, Ciência e Tecnologia\r\nda Bahia tem a honra de apresentar a Coleção Pedagógica do Programa Asé-Toré: Formação em Educação\r\nsobre negras(os) e povos indígenas, produto de um dos\r\nProgramas de educação para relações étnico-raciais\r\ndesenvolvido pela Diretoria Sistêmica de Políticas Afirmativas e Assuntos Estudantis – DPAAE/IFBA.\r\nEstamos felizes em materializar esta coleção, que\r\nmarca o compromisso da nossa instituição em validar\r\na legislação nacional que trata da obrigatoriedade\r\nde educar sobre História da África, afro-brasileira e\r\nindígena, identificando-a como conquista dos movimentos sociais, negros e indígenas brasileiros. Assim,\r\nreconhecemos as lutas de quem veio antes, agradecemos às/aos servidoras/es, gestoras/es e estudantes\r\nque bravamente promovem o debate racial no IFBA\r\ne fortalecemos esforços em prol de uma educação\r\nantirracista.\r\nPREFÁCIO\r\nA Coleção Pedagógica Asé-Toré representa um marco na institucionalidade de ações que contribuem\r\npara que o IFBA solidifique sua missão institucional:\r\n“Promover a formação do cidadão histórico-crítico,\r\noferecendo ensino, pesquisa e extensão com qualidade socialmente referenciada, objetivando o desenvolvimento sustentável do país”. Além disso, a Coleção\r\ninaugura novas estratégias institucionais e interdisciplinares, ao desenvolver um produto didático e acessível a todos os níveis, formas e modalidades de ensino\r\nque ofertamos.\r\nDesejo boa leitura e estudos. Que a Coleção Pedagógica Asé-Toré alcance a comunidade do IFBA e, também, as famílias dos nossos estudantes, organizações\r\nsociais e instituições de ensino do nosso Estado e país.\r\nPROFESSORA DRA. LUZIA MATOS MOTA\r\nREITORA DO IFBA	pt_BR	0	\N	-1	ac978e1a-ecdd-4409-982d-ad9f2c9d2933
1054	33	“Asé-Toré”, junção das palavras “Asé” (na língua\r\niorubá, significa poder, energia ou força presente\r\nem cada ser ou em cada coisa, que nas religiões afro\r\n-\r\n-brasileiras representa a energia sagrada dos orixás)\r\ne “Toré” (expressão espiritual-religiosa de grande\r\nimportância para os indígenas), significa para nós o\r\nresgate da força coletiva e energia vital da ancestra\r\n-\r\nlidade para vencer os desafios contemporâneos do\r\npovo negro e indígena.\r\nÉ com este nome repleto de significados e potências\r\nque a Diretoria Sistêmica de Políticas Afirmativas e\r\nAssuntos Estudantis – DPAAE/IFBA apresenta à co\r\n-\r\nmunidade interna e externa do Instituto Federal de\r\nEducação, Ciência e Tecnologia da Bahia (IFBA) esta\r\nColeção Pedagógica, um dos produtos do “Programa\r\nAsé-Toré: Formação em educação sobre negras(os)\r\ne povos indígenas do Instituto Federal de Educação,\r\nCiência e Tecnologia (IFBA), voltado à formação de\r\ngestoras(es), professoras(es), técnicas(os) administra\r\n-\r\ntivas(os), estudantes e comunidade na área da Educa\r\n-\r\nção das Relações Étnico-Raciais e ao enfrentamento\r\nao racismo no âmbito do IFBA.\r\nO Programa Asé-Toré foi institucionalizado por meio\r\nde Chamada Pública do IFBA/DPAAE, que possibilitou\r\na contratação de duas Coordenadoras (Coordenadora\r\nGeral e Coordenadora dos Cadernos Temáticos); 15\r\nbolsistas “professores conteudistas”; cinco bolsistas\r\n“professores pareceristas”; dois apoios administrati\r\n-\r\nvos pedagógicos e uma ilustradora para a produção\r\ndos Cadernos Temáticos. Envolveu, ainda, mais de dez\r\npesquisadoras(es) para o Conselho Editorial e diver\r\n-\r\nsas(os) servidoras(es) internos e externos do IFBA que\r\ncontribuíram na seleção dos bolsistas.\r\nA DPAAE é uma Diretoria recente na história do IFBA,\r\nsendo criada em 2020. Desta forma, a entrega à so\r\n-\r\nciedade da Coleção Pedagógica Asé-Toré se torna um\r\nmarco importante no cumprimento às normativas\r\nque tratam da educação das relações étnico-raciais o\r\nqual foi também missão da Diretoria. A Coleção tem\r\no objetivo de promover a Educação das Relações Ét\r\n-\r\nnico-raciais, cumprindo a Lei de Diretrizes e Base da\r\nEducação Nacional – LDB, especialmente no que con\r\n-\r\ncerne à implantação das Leis Federais nº 10.639/03\r\ne nº 11.645/08, as quais afirmam a obrigatoriedade\r\ndo estudo da “História da África e dos africanos”, da\r\n“luta dos negros e dos povos indígenas no Brasil”, da\r\n“cultura negra e indígena brasileira” e “o negro e o\r\níndio na formação da sociedade nacional”, “resgatan\r\n-\r\ndo as suas contribuições nas áreas social, econômica\r\ne política, pertinentes à história do Brasil.” (BRASIL,\r\n2008). Do mesmo modo, considerou-se as Diretrizes\r\n10\r\nCurriculares Nacionais para a Educação das Relações\r\nÉtnico-Raciais e para o Ensino de História e Cultura\r\nAfro-Brasileira e Africana, passando, ainda, por outras\r\nnormativas do estado da Bahia.\r\nComposta por 15 cadernos temáticos, a Coleção Pedagógica Asé-Toré cumpre esforços institucionais de\r\ncontribuir com a formulação de um material didático,\r\nfundamentado numa perspectiva de valorização da\r\neducação das relações étnico-raciais, da diversidade\r\nétnico-racial na educação, no enfrentamento ao racismo institucional, na valorização das ações afirmativas\r\npara a população negra e povos indígenas. Representa, ademais, contribuições coletivas de profissionais,\r\npesquisadoras/intelectuais ativistas ou não, em sua\r\nmaioria negros e mulheres, sendo destacada a participação de dois indígenas. Estas(es) pesquisadoras(es)\r\nse dedicaram a uma metodologia inovadora de trabalho baseada em aspectos da cosmovisão de mundo\r\nafricana e indígena, enfatizando o trabalho coletivo,\r\nvalorizando as lutas sociais, a produção de autoras(es)\r\nnegras(os) e indígenas e considerando suas vivências\r\ne experiências na forma e formato dos conteúdos e\r\nimagens.\r\nO Programa Asé-Toré nasceu a partir de um projeto\r\nmais amplo de implementação da Lei 10.639/03,\r\noriginalmente escrito por mim, Marcilene Garcia de\r\nSouza, e pelo professor Dr. Hélio Santos, em 2017.\r\nAqui no IFBA (DPAAE), o Programa se apresentou\r\nde forma mais sintetizada em que se destacam três\r\nprodutos: Produção dos 15 Cadernos Temáticos; Institucionalização de uma biblioteca virtual temática e\r\numa série de formações sobre educação das relações\r\nétnico-raciais.\r\nFaz-se necessário registrar o empenho da gestão\r\ndo IFBA para a realização do Programa Asé-Toré, na\r\npessoa da Reitora Profa. Dra. Luzia Matos Mota, que\r\né mulher negra, e na do Pró-Reitor de Ensino, Prof.\r\nDr. Jancarlos Lapa, mas também da Equipe gestora da DPAAE que contribui de forma mais direta na\r\nexecução do Programa: Profa. Mestra Thelma Ramos\r\n(Chefe da Coordenação Indígena e Povos Tradicionais\r\n– CIND/DPAF/DPAAE), a pedagoga Jacineide Arão\r\ndos Santos Profeta (Chefe do Departamento de Políticas Afirmativas – DPAF/DPAAE) e a assistente social\r\nCacilda Ferreira dos Reis (Chefe do Departamento de\r\nAssuntos Estudantis – DAES/DPAAE).\r\n\r\nPROFª. DRA. MARCILENE GARCIA DE SOUZA\r\nDIRETORA SISTÊMICA DE POLÍTICAS AFIRMATIVAS\r\nE ASSUNTOS ESTUDANTIS DO IFBA	pt_BR	0	\N	-1	ac978e1a-ecdd-4409-982d-ad9f2c9d2933
1055	34	Submitted by Andreia Ribeiro (andreiasr@ifba.edu.br) on 2023-08-04T19:49:22Z\r\nNo. of bitstreams: 1\r\nLei 11645.08 e a Educacao Indigena.pdf: 9173825 bytes, checksum: 993ceccd9a4a1933d4c7196a7c77544a (MD5)	en	0	\N	-1	ac978e1a-ecdd-4409-982d-ad9f2c9d2933
1056	34	Made available in DSpace on 2023-08-04T19:49:22Z (GMT). No. of bitstreams: 1\r\nLei 11645.08 e a Educacao Indigena.pdf: 9173825 bytes, checksum: 993ceccd9a4a1933d4c7196a7c77544a (MD5)\r\n  Previous issue date: 2023-08	en	1	\N	-1	ac978e1a-ecdd-4409-982d-ad9f2c9d2933
1057	24	IFBA, Diretoria de Políticas Afirmativas e Assuntos estudantis. Lei 11.645/08 e a Educação Indígena. Texto de Edson Kayapó/DPAAE. Salvador: EDIFBA, 2023. 50 p. (Coleção Pedagógica do Programa Asé-Toré Formação em Educação sobre negras(os) e Povos Indígenas, Caderno, 2).	pt_BR	0	\N	-1	ac978e1a-ecdd-4409-982d-ad9f2c9d2933
1058	31	http://www.asetore.ifba.edu.br:8080/jspui/handle/123456789/62	\N	0	\N	-1	ac978e1a-ecdd-4409-982d-ad9f2c9d2933
1059	44	pt_BR	pt_BR	0	\N	-1	ac978e1a-ecdd-4409-982d-ad9f2c9d2933
1060	45	EDIFBA	pt_BR	0	\N	-1	ac978e1a-ecdd-4409-982d-ad9f2c9d2933
209	70	ase tore.jpg	\N	0	\N	-1	e9ebf740-9ec2-4a98-a222-5612230b070a
210	61	/dspace/upload/ase tore.jpg	\N	0	\N	-1	e9ebf740-9ec2-4a98-a222-5612230b070a
1062	63	Povos Indígenas	pt_BR	0	\N	-1	ac978e1a-ecdd-4409-982d-ad9f2c9d2933
498	70	LICENSE	\N	1	\N	-1	9151f169-1522-4613-92cc-c524bbddde5d
587	70	Lei 11645.08 e a Educacao Indigena.pdf	\N	0	\N	-1	4fdacc55-3668-4314-91dc-08b6b61cd9cd
588	61	/dspace/upload/Lei 11645.08 e a Educacao Indigena.pdf	\N	0	\N	-1	4fdacc55-3668-4314-91dc-08b6b61cd9cd
589	32	Livro Lei 11.645/08 e a Educação Indígena	\N	0	\N	-1	4fdacc55-3668-4314-91dc-08b6b61cd9cd
697	34	Submitted by Andreia Ribeiro (andreiasr@ifba.edu.br) on 2023-08-14T14:34:21Z\r\nNo. of bitstreams: 1\r\nO Pensar Científico de Africanos e de seus descendentes nas Ciências.pdf: 7905242 bytes, checksum: 2f6bdb3ac081833b1d3c1dddd9a4090c (MD5)	en	0	\N	-1	b6dfa584-d9d6-4e67-9b10-13433ace7e38
698	34	Made available in DSpace on 2023-08-14T14:34:21Z (GMT). No. of bitstreams: 1\r\nO Pensar Científico de Africanos e de seus descendentes nas Ciências.pdf: 7905242 bytes, checksum: 2f6bdb3ac081833b1d3c1dddd9a4090c (MD5)\r\n  Previous issue date: 2023-08-14	en	1	\N	-1	b6dfa584-d9d6-4e67-9b10-13433ace7e38
699	24	IFBA, Diretoria de Políticas Afirmativas e Assuntos Estudantis. O pensar científico de Africanos e de seus descendentes nas Ciências. Texto de Florença Freitas Silvério/DPAAE. Salvador: EDIFBA, 2023. 61 p. (Coleção Pedagógica do Programa Asé-Toré Formação em educação sobre Negras(os) e Povos Indígenas, Caderno 8).	pt_BR	0	\N	-1	b6dfa584-d9d6-4e67-9b10-13433ace7e38
702	44	pt_BR	pt_BR	0	\N	-1	b6dfa584-d9d6-4e67-9b10-13433ace7e38
703	45	EDIFBA	pt_BR	0	\N	-1	b6dfa584-d9d6-4e67-9b10-13433ace7e38
1061	49	Coleção Pedagógica do Programa Asé Toré Formação em Educação sobre negras(os) e Povos Indígenas, Caderno 2.	\N	0	\N	-1	ac978e1a-ecdd-4409-982d-ad9f2c9d2933
1063	63	História - Cultura	pt_BR	1	\N	-1	ac978e1a-ecdd-4409-982d-ad9f2c9d2933
1064	63	Bahia - Brasil	pt_BR	2	\N	-1	ac978e1a-ecdd-4409-982d-ad9f2c9d2933
1065	70	Lei 11.645/08 e a Educação Indígena	pt_BR	0	\N	-1	ac978e1a-ecdd-4409-982d-ad9f2c9d2933
1066	72	Livro	pt_BR	0	\N	-1	ac978e1a-ecdd-4409-982d-ad9f2c9d2933
1105	32	O Instituto Federal de Educação, Ciência e Tecnologia\r\n\r\nda Bahia tem a honra de apresentar a Coleção Peda-\r\ngógica do Programa Asé-Toré: Formação em Educação\r\n\r\nsobre negras(os) e povos indígenas, produto de um dos\r\nProgramas de educação para relações étnico-raciais\r\n\r\ndesenvolvido pela Diretoria Sistêmica de Políticas Afir-\r\nmativas e Assuntos Estudantis – DPAAE/IFBA.\r\n\r\nEstamos felizes em materializar esta coleção, que\r\nmarca o compromisso da nossa instituição em validar\r\na legislação nacional que trata da obrigatoriedade\r\nde educar sobre História da África, afro-brasileira e\r\n\r\nindígena, identificando-a como conquista dos movi-\r\nmentos sociais, negros e indígenas brasileiros. Assim,\r\n\r\nreconhecemos as lutas de quem veio antes, agradece-\r\nmos às/aos servidoras/es, gestoras/es e estudantes\r\n\r\nque bravamente promovem o debate racial no IFBA\r\ne fortalecemos esforços em prol de uma educação\r\nantirracista.\r\nPREFÁCIO\r\n\r\nA Coleção Pedagógica Asé-Toré representa um mar-\r\nco na institucionalidade de ações que contribuem\r\n\r\npara que o IFBA solidifique sua missão institucional:\r\n“Promover a formação do cidadão histórico-crítico,\r\n\r\noferecendo ensino, pesquisa e extensão com qualida-\r\nde socialmente referenciada, objetivando o desenvol-\r\nvimento sustentável do país”. Além disso, a Coleção\r\n\r\ninaugura novas estratégias institucionais e interdisci-\r\nplinares, ao desenvolver um produto didático e acessí-\r\nvel a todos os níveis, formas e modalidades de ensino\r\n\r\nque ofertamos.\r\n\r\nDesejo boa leitura e estudos. Que a Coleção Pedagó-\r\ngica Asé-Toré alcance a comunidade do IFBA e, tam-\r\nbém, as famílias dos nossos estudantes, organizações\r\n\r\nsociais e instituições de ensino do nosso Estado e país.\r\n\r\nPROFESSORA DRA. LUZIA MATOS MOTA\r\nREITORA DO IFBA	pt_BR	0	\N	-1	39926264-0a06-432f-bb03-18d391841d73
1106	70	ORIGINAL	\N	1	\N	-1	6c633236-b142-42a6-9bbc-421e3e921a75
994	70	capa caderno 2.jpg	\N	0	\N	-1	089ec672-8120-4e7b-9f52-9cd4d44a514b
995	61	/dspace/upload/capa caderno 2.jpg	\N	0	\N	-1	089ec672-8120-4e7b-9f52-9cd4d44a514b
1107	70	Territorios e povos indigenas no Brasil e na Bahia. Cad3.pdf	\N	0	\N	-1	25d02dc5-8249-4146-a65a-1da2b0d306f9
1108	61	/dspace/upload/Territorios e povos indigenas no Brasil e na Bahia. Cad3.pdf	\N	0	\N	-1	25d02dc5-8249-4146-a65a-1da2b0d306f9
1109	32	Caderno 3	\N	0	\N	-1	25d02dc5-8249-4146-a65a-1da2b0d306f9
1110	70	LICENSE	\N	1	\N	-1	67a933ee-2067-4da6-ae2b-2a0e5cf7e8ad
2108	1	Jaqueline	\N	0	\N	-1	417f079c-1474-4ec9-9b16-6a30f1b7d840
1111	70	license.txt	\N	0	\N	-1	e518be93-fac4-433f-84c0-32533ec7b4ac
1112	61	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	e518be93-fac4-433f-84c0-32533ec7b4ac
1113	34	Submitted by Andreia Ribeiro (andreiasr@ifba.edu.br) on 2023-08-24T22:09:00Z\nNo. of bitstreams: 1\nTerritorios e povos indigenas no Brasil e na Bahia. Cad3.pdf: 10002502 bytes, checksum: 4020d5a038a28e7decb814074e5400d1 (MD5)	en	0	\N	-1	39926264-0a06-432f-bb03-18d391841d73
1114	31	http://www.asetore.ifba.edu.br:8080/jspui/handle/123456789/86	\N	0	\N	-1	39926264-0a06-432f-bb03-18d391841d73
1118	34	Made available in DSpace on 2023-08-24T22:09:00Z (GMT). No. of bitstreams: 1\nTerritorios e povos indigenas no Brasil e na Bahia. Cad3.pdf: 10002502 bytes, checksum: 4020d5a038a28e7decb814074e5400d1 (MD5)\n  Previous issue date: 2023-08	en	1	\N	-1	39926264-0a06-432f-bb03-18d391841d73
1115	17	2023-08-24T22:09:00Z	\N	0	\N	-1	39926264-0a06-432f-bb03-18d391841d73
1116	18	2023-08-24T22:09:00Z	\N	0	\N	-1	39926264-0a06-432f-bb03-18d391841d73
1117	21	2023-08	\N	0	\N	-1	39926264-0a06-432f-bb03-18d391841d73
2109	2	Melo	\N	0	\N	-1	417f079c-1474-4ec9-9b16-6a30f1b7d840
2110	3	61985829596	\N	0	\N	-1	417f079c-1474-4ec9-9b16-6a30f1b7d840
2111	4	pt_BR	\N	0	\N	-1	417f079c-1474-4ec9-9b16-6a30f1b7d840
1747	9	IFBA, Diretoria de Políticas Afirmativas e Assuntos Estudantis	\N	0	\N	-1	5f935f7b-468a-4bd3-a610-0dd1c9b9edc3
1603	70	Movimentos negros  cad.15.pdf	\N	0	\N	-1	c9e00944-6772-4ac8-93d3-b768ed3e73d5
1413	70	Historia e cultura dos povos indigena cad 4.pdf	\N	0	\N	-1	80aeeef4-8b4a-44e5-a67b-60331f5e20c5
1414	61	/dspace/upload/Historia e cultura dos povos indigena cad 4.pdf	\N	0	\N	-1	80aeeef4-8b4a-44e5-a67b-60331f5e20c5
1415	32	Livro	\N	0	\N	-1	80aeeef4-8b4a-44e5-a67b-60331f5e20c5
1416	70	license.txt	\N	0	\N	-1	6279e756-d48b-47ab-ab4a-7c263086ef91
1417	61	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	6279e756-d48b-47ab-ab4a-7c263086ef91
1418	9	IFBA, Diretoria de Políticas Afirmativas e Assuntos Estudantis	\N	0	\N	-1	2a3f97a9-f475-4ef6-bbc3-c83e6f0cf28d
1419	9	Silva, Ayalla Oliveira	\N	1	\N	-1	2a3f97a9-f475-4ef6-bbc3-c83e6f0cf28d
1420	17	2023-09-04T11:14:35Z	\N	0	\N	-1	2a3f97a9-f475-4ef6-bbc3-c83e6f0cf28d
1421	18	2023-09-04T11:14:35Z	\N	0	\N	-1	2a3f97a9-f475-4ef6-bbc3-c83e6f0cf28d
1422	21	2023-08	\N	0	\N	-1	2a3f97a9-f475-4ef6-bbc3-c83e6f0cf28d
1432	49	Coleção Pedagógica do Programa Asé-Toré: Formação em educação sobre negras(os) e Povos indígenas;4	\N	0	\N	-1	2a3f97a9-f475-4ef6-bbc3-c83e6f0cf28d
1433	63	Povos Indígenas	pt_BR	0	\N	-1	2a3f97a9-f475-4ef6-bbc3-c83e6f0cf28d
1434	63	História - Cultura	pt_BR	1	\N	-1	2a3f97a9-f475-4ef6-bbc3-c83e6f0cf28d
1435	70	História e cultura dos povos indígenas na Bahia e no Brasil	pt_BR	0	\N	-1	2a3f97a9-f475-4ef6-bbc3-c83e6f0cf28d
1436	72	Livro	pt_BR	0	\N	-1	2a3f97a9-f475-4ef6-bbc3-c83e6f0cf28d
1604	61	/dspace/upload/Movimentos negros  cad.15.pdf	\N	0	\N	-1	c9e00944-6772-4ac8-93d3-b768ed3e73d5
1605	32	Livro	\N	0	\N	-1	c9e00944-6772-4ac8-93d3-b768ed3e73d5
1184	70	Movimentos negros contemporaneos e movimentos sociais indigenas, cad.15.pdf	\N	0	\N	-1	7729b272-7cc6-40d9-aadb-4736c2f96d13
1185	61	/dspace/upload/Movimentos negros contemporaneos e movimentos sociais indigenas, cad.15.pdf	\N	0	\N	-1	7729b272-7cc6-40d9-aadb-4736c2f96d13
1748	9	Araújo, Danielle Ferreira Medeiros da Silva de	\N	1	\N	-1	5f935f7b-468a-4bd3-a610-0dd1c9b9edc3
1749	70	Movimentos negros contemporâneos e movimentos sociais indígenas	pt_BR	0	\N	-1	5f935f7b-468a-4bd3-a610-0dd1c9b9edc3
1493	70	Movimentos negros contemporaneos, cad.15.pdf	\N	0	\N	-1	2f1b5720-6de1-4cff-8dc6-2b54514544a7
1494	61	/dspace/upload/Movimentos negros contemporaneos, cad.15.pdf	\N	0	\N	-1	2f1b5720-6de1-4cff-8dc6-2b54514544a7
1751	45	EDIFBA	pt_BR	0	\N	-1	5f935f7b-468a-4bd3-a610-0dd1c9b9edc3
1495	32	Livro	\N	0	\N	-1	2f1b5720-6de1-4cff-8dc6-2b54514544a7
1754	26	978-65-88985-28-1	\N	0	\N	-1	5f935f7b-468a-4bd3-a610-0dd1c9b9edc3
1840	1	Taylor	\N	0	\N	-1	f7d06c53-c0de-4f14-a79a-a8ab735d172f
1841	2	Silva Menezes dos Santos	\N	0	\N	-1	f7d06c53-c0de-4f14-a79a-a8ab735d172f
1842	3	71987464070	\N	0	\N	-1	f7d06c53-c0de-4f14-a79a-a8ab735d172f
1752	24	IFBA,Diretoria de Políticas Afirmativas e Assuntos estudantis. Movimentos negros contemporâneos e movimentos sociais indígenas.Texto de Danielle Ferreira Medeiros da Silva de Araújo/DPAAE. Salvador: EDIFBA, 2023. 65 p.	pt_BR	0	\N	-1	5f935f7b-468a-4bd3-a610-0dd1c9b9edc3
1753	49	Coleção Pedagógica do Programa Asé-Toré: Formação em educação sobre negras(os) e Povos indígenas;15	\N	0	\N	-1	5f935f7b-468a-4bd3-a610-0dd1c9b9edc3
1755	72	Livro	pt_BR	0	\N	-1	5f935f7b-468a-4bd3-a610-0dd1c9b9edc3
1756	44	pt_BR	pt_BR	0	\N	-1	5f935f7b-468a-4bd3-a610-0dd1c9b9edc3
643	70	ORIGINAL	\N	1	\N	-1	3fadcab8-0741-48bb-a6d4-e2498776b884
411	70	LICENSE	\N	1	\N	-1	b69846db-0436-4b43-9f3c-8c32473591cd
704	49	Coleção Pedagógica do Programa Asé Toré Formação em Educação sobre negras(os) e Povos Indígenas, Caderno 8;	\N	0	\N	-1	b6dfa584-d9d6-4e67-9b10-13433ace7e38
705	63	África	pt_BR	0	\N	-1	b6dfa584-d9d6-4e67-9b10-13433ace7e38
1771	70	ORIGINAL	\N	1	\N	-1	a46768eb-dec3-44f6-84bb-e1a1496c616f
1121	70	capa caderno 8.jpg	\N	0	\N	-1	9ddaf20e-e6cd-49d4-95c8-9f5bf19cabfc
1122	61	/dspace/upload/capa caderno 8.jpg	\N	0	\N	-1	9ddaf20e-e6cd-49d4-95c8-9f5bf19cabfc
741	70	LICENSE	\N	1	\N	-1	4401ba15-c530-48ee-b0af-d4e57e7fc0cb
878	70	capa_cad1.jpg.pdf	\N	0	\N	-1	932c0dc4-ff45-48a4-863b-1c937b3ee33c
879	61	/dspace/upload/capa_cad1.jpg.pdf	\N	0	\N	-1	932c0dc4-ff45-48a4-863b-1c937b3ee33c
1069	70	capa caderno 3.jpg	\N	0	\N	-1	c9b59794-1d5c-4196-aff1-cc87e2ca115b
1070	61	/dspace/upload/capa caderno 3.jpg	\N	0	\N	-1	c9b59794-1d5c-4196-aff1-cc87e2ca115b
434	70	Coleção Pedagógica Asé-Toré	\N	0	\N	-1	d6941f14-9466-4dff-80d3-5e0809da53ce
435	33	Educação sobre negras (os) e povos indígenas	\N	0	\N	-1	d6941f14-9466-4dff-80d3-5e0809da53ce
436	32	O “Programa Asé-Toré: Formação em educação sobre negras (os) e povos indígenas” é promovido pela Diretoria Sistêmica de Políticas Afirmativas e Assuntos Estudantis-DPAAE do Instituto Federal de Educação, Ciência e Tecnologia da Bahia (IFBA), com o objetivo de democratizar o acesso a conteúdo no que tange a aplicabilidade das Leis nº 10.639/2003 e nº 11.645/2008 no que se refere à História e Cultura Afro-brasileiras e das comunidades originárias, através do desenvolvimento de produtos que contribuam para educação das relações étnico-raciais e no enfrentamento ao racismo no âmbito do IFBA.	\N	0	\N	-1	d6941f14-9466-4dff-80d3-5e0809da53ce
1774	32	Livro	\N	0	\N	-1	82c95a58-2f95-4e10-a39e-1fc04934dc2b
1763	63	Movimentos Sociais	pt_BR	0	\N	-1	5f935f7b-468a-4bd3-a610-0dd1c9b9edc3
1764	63	História	pt_BR	1	\N	-1	5f935f7b-468a-4bd3-a610-0dd1c9b9edc3
1765	63	Movimentos Negros	pt_BR	2	\N	-1	5f935f7b-468a-4bd3-a610-0dd1c9b9edc3
1766	63	Povos Indígenas	pt_BR	3	\N	-1	5f935f7b-468a-4bd3-a610-0dd1c9b9edc3
1767	63	Direitos Humanos	pt_BR	4	\N	-1	5f935f7b-468a-4bd3-a610-0dd1c9b9edc3
1768	63	Lutas Sociais	pt_BR	5	\N	-1	5f935f7b-468a-4bd3-a610-0dd1c9b9edc3
1769	33	“Asé-Toré”, junção das palavras “Asé” (na língua\r\niorubá, significa poder, energia ou força presente\r\nem cada ser ou em cada coisa, que nas religiões afro-\r\n-brasileiras representa a energia sagrada dos orixás)\r\ne “Toré” (expressão espiritual-religiosa de grande\r\nimportância para os indígenas), significa para nós o\r\nresgate da força coletiva e energia vital da ancestralidade\r\npara vencer os desafios contemporâneos do\r\npovo negro e indígena.\r\nÉ com este nome repleto de significados e potências\r\nque a Diretoria Sistêmica de Políticas Afirmativas e\r\nAssuntos Estudantis – DPAAE/IFBA apresenta à comunidade\r\ninterna e externa do Instituto Federal de\r\nEducação, Ciência e Tecnologia da Bahia (IFBA) esta\r\nColeção Pedagógica, um dos produtos do “Programa\r\nAsé-Toré: Formação em educação sobre negras(os)\r\ne povos indígenas do Instituto Federal de Educação,\r\nCiência e Tecnologia (IFBA), voltado à formação de\r\ngestoras(es), professoras(es), técnicas(os) administrativas(\r\nos), estudantes e comunidade na área da Educação\r\ndas Relações Étnico-Raciais e ao enfrentamento\r\nao racismo no âmbito do IFBA.\r\nO Programa Asé-Toré foi institucionalizado por meio\r\nde Chamada Pública do IFBA/DPAAE, que possibilitou\r\na contratação de duas Coordenadoras (Coordenadora\r\nGeral e Coordenadora dos Cadernos Temáticos); 15\r\nbolsistas “professores conteudistas”; cinco bolsistas\r\n“professores pareceristas”; dois apoios administrativos\r\npedagógicos e uma ilustradora para a produção\r\ndos Cadernos Temáticos. Envolveu, ainda, mais de dez\r\npesquisadoras(es) para o Conselho Editorial e diversas(\r\nos) servidoras(es) internos e externos do IFBA que\r\ncontribuíram na seleção dos bolsistas.\r\nA DPAAE é uma Diretoria recente na história do IFBA,\r\nsendo criada em 2020. Desta forma, a entrega à sociedade\r\nda Coleção Pedagógica Asé-Toré se torna um\r\nmarco importante no cumprimento às normativas\r\nque tratam da educação das relações étnico-raciais o\r\nqual foi também missão da Diretoria. A Coleção tem\r\no objetivo de promover a Educação das Relações Étnico-\r\nraciais, cumprindo a Lei de Diretrizes e Base da\r\nEducação Nacional – LDB, especialmente no que concerne\r\nà implantação das Leis Federais nº 10.639/03\r\ne nº 11.645/08, as quais afirmam a obrigatoriedade\r\ndo estudo da “História da África e dos africanos”, da\r\n“luta dos negros e dos povos indígenas no Brasil”, da\r\n“cultura negra e indígena brasileira” e “o negro e o\r\níndio na formação da sociedade nacional”, “resgatando\r\nas suas contribuições nas áreas social, econômica\r\ne política, pertinentes à história do Brasil.” (BRASIL,\r\n2008). Do mesmo modo, considerou-se as Diretrizes Curriculares Nacionais para a Educação das Relações\r\nÉtnico-Raciais e para o Ensino de História e Cultura\r\nAfro-Brasileira e Africana, passando, ainda, por outras\r\nnormativas do estado da Bahia.\r\nComposta por 15 cadernos temáticos, a Coleção Pedagógica\r\nAsé-Toré cumpre esforços institucionais de\r\ncontribuir com a formulação de um material didático,\r\nfundamentado numa perspectiva de valorização\r\nda educação das relações étnico-raciais, da diversidade\r\nétnico-racial na educação, no enfrentamento\r\nao racismo institucional, na valorização das ações\r\nafirmativas para a população negra e povos indígenas.\r\nRepresenta, ademais, contribuições coletivas de\r\nprofissionais, pesquisadoras/intelectuais ativistas\r\nou não, em sua maioria negros e mulheres, sendo\r\ndestacada a participação de dois indígenas. Estas(es)\r\npesquisadoras(es) se dedicaram a uma metodologia\r\ninovadora de trabalho baseada em aspectos da cosmovisão\r\nde mundo africana e indígena, enfatizando\r\no trabalho coletivo, valorizando as lutas sociais, a\r\nprodução de autoras(es) negras(os) e indígenas e\r\nconsiderando suas vivências e experiências na forma\r\ne formato dos conteúdos e imagens.\r\nO Programa Asé-Toré nasceu a partir de um projeto\r\nmais amplo de implementação da Lei 10.639/03,\r\noriginalmente escrito por mim, Marcilene Garcia de\r\nSouza, e pelo professor Dr. Hélio Santos, em 2017.\r\nAqui no IFBA (DPAAE), o Programa se apresentou\r\nde forma mais sintetizada em que se destacam três\r\nprodutos: Produção dos 15 Cadernos Temáticos; Institucionalização\r\nde uma biblioteca virtual temática e\r\numa série de formações sobre educação das relações\r\nétnico-raciais.\r\nFaz-se necessário registrar o empenho da gestão\r\ndo IFBA para a realização do Programa Asé-Toré, na\r\npessoa da Reitora Profa. Dra. Luzia Matos Mota, que\r\né mulher negra, e na do Pró-Reitor de Ensino, Prof.\r\nDr. Jancarlos Lapa, mas também da Equipe gestora\r\nda DPAAE que contribui de forma mais direta na\r\nexecução do Programa: Profa. Mestra Thelma Ramos\r\n(Chefe da Coordenação Indígena e Povos Tradicionais\r\n– CIND/DPAF/DPAAE), a pedagoga Jacineide Arão\r\ndos Santos Profeta (Chefe do Departamento de Políticas\r\nAfirmativas – DPAF/DPAAE) e a assistente social\r\nCacilda Ferreira dos Reis (Chefe do Departamento de\r\nAssuntos Estudantis – DAES/DPAAE).\r\nPROFª. DRA. MARCILENE GARCIA DE SOUZA\r\nDIRETORA SISTÊMICA DE POLÍTICAS AFIRMATIVAS\r\nE ASSUNTOS ESTUDANTIS DO IFBA	pt_BR	0	\N	-1	5f935f7b-468a-4bd3-a610-0dd1c9b9edc3
1770	32	O Instituto Federal de Educação, Ciência e Tecnologia\r\nda Bahia tem a honra de apresentar a Coleção Pedagógica\r\ndo Programa Asé-Toré: Formação em Educação\r\nsobre negras(os) e povos indígenas, produto de um dos\r\nProgramas de educação para relações étnico-raciais\r\ndesenvolvido pela Diretoria Sistêmica de Políticas Afirmativas\r\ne Assuntos Estudantis – DPAAE/IFBA.\r\nEstamos felizes em materializar esta coleção, que\r\nmarca o compromisso da nossa instituição em validar\r\na legislação nacional que trata da obrigatoriedade\r\nde educar sobre História da África, afro-brasileira e\r\nindígena, identificando-a como conquista dos movimentos\r\nsociais, negros e indígenas brasileiros. Assim,\r\nreconhecemos as lutas de quem veio antes, agradecemos\r\nàs/aos servidoras/es, gestoras/es e estudantes\r\nque bravamente promovem o debate racial no IFBA\r\ne fortalecemos esforços em prol de uma educação\r\nantirracista.\r\nPREFÁCIO\r\nA Coleção Pedagógica Asé-Toré representa um marco\r\nna institucionalidade de ações que contribuem\r\npara que o IFBA solidifique sua missão institucional:\r\n“Promover a formação do cidadão histórico-crítico,\r\noferecendo ensino, pesquisa e extensão com qualidade\r\nsocialmente referenciada, objetivando o desenvolvimento\r\nsustentável do país”. Além disso, a Coleção\r\ninaugura novas estratégias institucionais e interdisciplinares,\r\nao desenvolver um produto didático e acessível\r\na todos os níveis, formas e modalidades de ensino\r\nque ofertamos.\r\nDesejo boa leitura e estudos. Que a Coleção Pedagógica\r\nAsé-Toré alcance a comunidade do IFBA e, também,\r\nas famílias dos nossos estudantes, organizações\r\nsociais e instituições de ensino do nosso Estado e país.\r\nPROFESSORA DRA. LUZIA MATOS MOTA\r\nREITORA DO IFBA	pt_BR	0	\N	-1	5f935f7b-468a-4bd3-a610-0dd1c9b9edc3
1772	70	Movimentos negros contemporaneos cad.15 (1).pdf	\N	0	\N	-1	82c95a58-2f95-4e10-a39e-1fc04934dc2b
1773	61	/dspace/upload/Movimentos negros contemporaneos cad.15 (1).pdf	\N	0	\N	-1	82c95a58-2f95-4e10-a39e-1fc04934dc2b
1775	70	LICENSE	\N	1	\N	-1	4def91f3-d15d-49b2-9fd8-2227cc555bf5
706	63	História	pt_BR	1	\N	-1	b6dfa584-d9d6-4e67-9b10-13433ace7e38
707	63	Cultura	pt_BR	2	\N	-1	b6dfa584-d9d6-4e67-9b10-13433ace7e38
708	63	Políticas Afirmativas	pt_BR	3	\N	-1	b6dfa584-d9d6-4e67-9b10-13433ace7e38
1776	70	license.txt	\N	0	\N	-1	439c20e0-ca26-4687-899f-81ff3d3b8ff2
1777	61	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	439c20e0-ca26-4687-899f-81ff3d3b8ff2
1778	34	Submitted by Andreia Ribeiro (andreiasr@ifba.edu.br) on 2023-09-04T15:01:36Z\nNo. of bitstreams: 1\nMovimentos negros contemporaneos cad.15 (1).pdf: 12365504 bytes, checksum: a441f69ee22e595946db6162948b6824 (MD5)	en	0	\N	-1	5f935f7b-468a-4bd3-a610-0dd1c9b9edc3
1779	31	http://www.asetore.ifba.edu.br:8080/jspui/handle/123456789/91	\N	0	\N	-1	5f935f7b-468a-4bd3-a610-0dd1c9b9edc3
709	63	Biografias	pt_BR	4	\N	-1	b6dfa584-d9d6-4e67-9b10-13433ace7e38
710	63	Saberes	pt_BR	5	\N	-1	b6dfa584-d9d6-4e67-9b10-13433ace7e38
711	63	Ciências	pt_BR	6	\N	-1	b6dfa584-d9d6-4e67-9b10-13433ace7e38
712	70	O pensar científico de Africanos e de seus descendentes nas Ciências	pt_BR	0	\N	-1	b6dfa584-d9d6-4e67-9b10-13433ace7e38
713	72	Livro	pt_BR	0	\N	-1	b6dfa584-d9d6-4e67-9b10-13433ace7e38
1423	32	O Instituto Federal de Educação, Ciência e Tecnologia\r\nda Bahia tem a honra de apresentar a Coleção Pedagógica do Programa Asé-Toré: Formação em Educação\r\nsobre negras(os) e povos indígenas, produto de um dos\r\nProgramas de educação para relações étnico-raciais\r\ndesenvolvido pela Diretoria Sistêmica de Políticas Afirmativas e Assuntos Estudantis – DPAAE/IFBA.\r\nEstamos felizes em materializar esta coleção, que\r\nmarca o compromisso da nossa instituição em validar\r\na legislação nacional que trata da obrigatoriedade\r\nde educar sobre História da África, afro-brasileira e\r\nindígena, identificando-a como conquista dos movimentos sociais, negros e indígenas brasileiros. Assim,\r\nreconhecemos as lutas de quem veio antes, agradecemos às/aos servidoras/es, gestoras/es e estudantes\r\nque bravamente promovem o debate racial no IFBA\r\ne fortalecemos esforços em prol de uma educação\r\nantirracista.\r\nPREFÁCIO\r\nA Coleção Pedagógica Asé-Toré representa um marco na institucionalidade de ações que contribuem\r\npara que o IFBA solidifique sua missão institucional:\r\n“Promover a formação do cidadão histórico-crítico,\r\noferecendo ensino, pesquisa e extensão com qualidade socialmente referenciada, objetivando o desenvolvimento sustentável do país”. Além disso, a Coleção\r\ninaugura novas estratégias institucionais e interdisciplinares, ao desenvolver um produto didático e acessível a todos os níveis, formas e modalidades de ensino\r\nque ofertamos.\r\nDesejo boa leitura e estudos. Que a Coleção Pedagógica Asé-Toré alcance a comunidade do IFBA e, também, as famílias dos nossos estudantes, organizações\r\nsociais e instituições de ensino do nosso Estado e país.\r\nPROFESSORA DRA. LUZIA MATOS MOTA\r\nREITORA DO IFBA	pt_BR	0	\N	-1	2a3f97a9-f475-4ef6-bbc3-c83e6f0cf28d
1424	33	APRESENTAÇÃO DA COLEÇÃO PEDAGÓGICA\r\n“Asé-Toré”, junção das palavras “Asé” (na língua\r\niorubá, significa poder, energia ou força presente\r\nem cada ser ou em cada coisa, que nas religiões afro\r\n-\r\n-brasileiras representa a energia sagrada dos orixás)\r\ne “Toré” (expressão espiritual-religiosa de grande\r\nimportância para os indígenas), significa para nós o\r\nresgate da força coletiva e energia vital da ancestra\r\n-\r\nlidade para vencer os desafios contemporâneos do\r\npovo negro e indígena.\r\nÉ com este nome repleto de significados e potências\r\nque a Diretoria Sistêmica de Políticas Afirmativas e\r\nAssuntos Estudantis – DPAAE/IFBA apresenta à co\r\n-\r\nmunidade interna e externa do Instituto Federal de\r\nEducação, Ciência e Tecnologia da Bahia (IFBA) esta\r\nColeção Pedagógica, um dos produtos do “Programa\r\nAsé-Toré: Formação em educação sobre negras(os)\r\ne povos indígenas do Instituto Federal de Educação,\r\nCiência e Tecnologia (IFBA), voltado à formação de\r\ngestoras(es), professoras(es), técnicas(os) administra\r\n-\r\ntivas(os), estudantes e comunidade na área da Educa\r\n-\r\nção das Relações Étnico-Raciais e ao enfrentamento\r\nao racismo no âmbito do IFBA.\r\nO Programa Asé-Toré foi institucionalizado por meio\r\nde Chamada Pública do IFBA/DPAAE, que possibilitou\r\na contratação de duas Coordenadoras (Coordenadora\r\nGeral e Coordenadora dos Cadernos Temáticos); 15\r\nbolsistas “professores conteudistas”; cinco bolsistas\r\n“professores pareceristas”; dois apoios administrati\r\n-\r\nvos pedagógicos e uma ilustradora para a produção\r\ndos Cadernos Temáticos. Envolveu, ainda, mais de dez\r\npesquisadoras(es) para o Conselho Editorial e diver\r\n-\r\nsas(os) servidoras(es) internos e externos do IFBA que\r\ncontribuíram na seleção dos bolsistas.\r\nA DPAAE é uma Diretoria recente na história do IFBA,\r\nsendo criada em 2020. Desta forma, a entrega à so\r\n-\r\nciedade da Coleção Pedagógica Asé-Toré se torna um\r\nmarco importante no cumprimento às normativas\r\nque tratam da educação das relações étnico-raciais o\r\nqual foi também missão da Diretoria. A Coleção tem\r\no objetivo de promover a Educação das Relações Ét\r\n-\r\nnico-raciais, cumprindo a Lei de Diretrizes e Base da\r\nEducação Nacional – LDB, especialmente no que con\r\n-\r\ncerne à implantação das Leis Federais nº 10.639/03\r\ne nº 11.645/08, as quais afirmam a obrigatoriedade\r\ndo estudo da “História da África e dos africanos”, da\r\n“luta dos negros e dos povos indígenas no Brasil”, da\r\n“cultura negra e indígena brasileira” e “o negro e o\r\níndio na formação da sociedade nacional”, “resgatan\r\n-\r\ndo as suas contribuições nas áreas social, econômica\r\ne política, pertinentes à história do Brasil.” (BRASIL,\r\n2008). Do mesmo modo, considerou-se as Diretrizes\r\n10\r\nCurriculares Nacionais para a Educação das Relações\r\nÉtnico-Raciais e para o Ensino de História e Cultura\r\nAfro-Brasileira e Africana, passando, ainda, por outras\r\nnormativas do estado da Bahia.\r\nComposta por 15 cadernos temáticos, a Coleção Pe\r\n-\r\ndagógica Asé-Toré cumpre esforços institucionais de\r\ncontribuir com a formulação de um material didático,\r\nfundamentado numa perspectiva de valorização da\r\neducação das relações étnico-raciais, da diversidade\r\nétnico-racial na educação, no enfrentamento ao racis\r\n-\r\nmo institucional, na valorização das ações afirmativas\r\npara a população negra e povos indígenas. Represen\r\n-\r\nta, ademais, contribuições coletivas de profissionais,\r\npesquisadoras/intelectuais ativistas ou não, em sua\r\nmaioria negros e mulheres, sendo destacada a parti\r\n-\r\ncipação de dois indígenas. Estas(es) pesquisadoras(es)\r\nse dedicaram a uma metodologia inovadora de traba\r\n-\r\nlho baseada em aspectos da cosmovisão de mundo\r\nafricana e indígena, enfatizando o trabalho coletivo,\r\nvalorizando as lutas sociais, a produção de autoras(es)\r\nnegras(os) e indígenas e considerando suas vivências\r\ne experiências na forma e formato dos conteúdos e\r\nimagens.\r\nO Programa Asé-Toré nasceu a partir de um projeto\r\nmais amplo de implementação da Lei 10.639/03,\r\noriginalmente escrito por mim, Marcilene Garcia de\r\nSouza, e pelo professor Dr. Hélio Santos, em 2017.\r\nAqui no IFBA (DPAAE), o Programa se apresentou\r\nde forma mais sintetizada em que se destacam três\r\nprodutos: Produção dos 15 Cadernos Temáticos; Ins\r\n-\r\ntitucionalização de uma biblioteca virtual temática e\r\numa série de formações sobre educação das relações\r\nétnico-raciais.\r\nFaz-se necessário registrar o empenho da gestão\r\ndo IFBA para a realização do Programa Asé-Toré, na\r\npessoa da Reitora Profa. Dra. Luzia Matos Mota, que\r\né mulher negra, e na do Pró-Reitor de Ensino, Prof.\r\nDr. Jancarlos Lapa, mas também da Equipe gesto\r\n-\r\nra da DPAAE que contribui de forma mais direta na\r\nexecução do Programa: Profa. Mestra Thelma Ramos\r\n(Chefe da Coordenação Indígena e Povos Tradicionais\r\n– CIND/DPAF/DPAAE), a pedagoga Jacineide Arão\r\ndos Santos Profeta (Chefe do Departamento de Políti\r\n-\r\ncas Afirmativas – DPAF/DPAAE) e a assistente social\r\nCacilda Ferreira dos Reis (Chefe do Departamento de\r\nAssuntos Estudantis – DAES/DPAAE).\r\n\r\nPROFª. DRA. MARCILENE GARCIA DE SOUZA\r\nDIRETORA SISTÊMICA DE POLÍTICAS AFIRMATIVAS\r\nE ASSUNTOS ESTUDANTIS DO IFBA	pt_BR	0	\N	-1	2a3f97a9-f475-4ef6-bbc3-c83e6f0cf28d
1425	34	Submitted by Andreia Ribeiro (andreiasr@ifba.edu.br) on 2023-09-04T11:14:35Z\r\nNo. of bitstreams: 1\r\nHistoria e cultura dos povos indigenas na Bahia e no Brasil , cad 4.pdf: 11290129 bytes, checksum: e23d5b05b24a5b245f93077c3d19b302 (MD5)	en	0	\N	-1	2a3f97a9-f475-4ef6-bbc3-c83e6f0cf28d
1426	34	Made available in DSpace on 2023-09-04T11:14:35Z (GMT). No. of bitstreams: 1\r\nHistoria e cultura dos povos indigenas na Bahia e no Brasil , cad 4.pdf: 11290129 bytes, checksum: e23d5b05b24a5b245f93077c3d19b302 (MD5)\r\n  Previous issue date: 2023-08	en	1	\N	-1	2a3f97a9-f475-4ef6-bbc3-c83e6f0cf28d
1427	24	IFBA,Diretoria de Políticas Afirmativas e Assuntos estudantis. História e cultura dos povos indígenas na Bahia e no Brasil. Texto de Ayalla Oliveira Silva/DPAAE. Salvador: EDIFBA, 2023. 63 p.	pt_BR	0	\N	-1	2a3f97a9-f475-4ef6-bbc3-c83e6f0cf28d
1428	26	978-65-88985-19-9	\N	0	\N	-1	2a3f97a9-f475-4ef6-bbc3-c83e6f0cf28d
1127	70	capa caderno 15.jpg	\N	0	\N	-1	46dc8de4-2feb-4f76-bcf8-38d8c795a614
1128	61	/dspace/upload/capa caderno 15.jpg	\N	0	\N	-1	46dc8de4-2feb-4f76-bcf8-38d8c795a614
1429	31	http://www.asetore.ifba.edu.br:8080/jspui/handle/123456789/89	\N	0	\N	-1	2a3f97a9-f475-4ef6-bbc3-c83e6f0cf28d
1430	44	pt_BR	pt_BR	0	\N	-1	2a3f97a9-f475-4ef6-bbc3-c83e6f0cf28d
1431	45	EDIFBA	pt_BR	0	\N	-1	2a3f97a9-f475-4ef6-bbc3-c83e6f0cf28d
559	70	Diversidade_saberes_dos_povos_Indigenas.pdf	\N	0	\N	-1	8aaa2fc1-c519-4138-aa02-4fc9f86930f4
560	61	/dspace/upload/Diversidade_saberes_dos_povos_Indigenas.pdf	\N	0	\N	-1	8aaa2fc1-c519-4138-aa02-4fc9f86930f4
561	32	Livro	\N	0	\N	-1	8aaa2fc1-c519-4138-aa02-4fc9f86930f4
1783	34	Made available in DSpace on 2023-09-04T15:01:36Z (GMT). No. of bitstreams: 1\nMovimentos negros contemporaneos cad.15 (1).pdf: 12365504 bytes, checksum: a441f69ee22e595946db6162948b6824 (MD5)\n  Previous issue date: 2023-08	en	1	\N	-1	5f935f7b-468a-4bd3-a610-0dd1c9b9edc3
1075	70	capa caderno 4.jpg	\N	0	\N	-1	32421ac4-1a07-4150-973f-a5437265af4e
1076	61	/dspace/upload/capa caderno 4.jpg	\N	0	\N	-1	32421ac4-1a07-4150-973f-a5437265af4e
1780	17	2023-09-04T15:01:36Z	\N	0	\N	-1	5f935f7b-468a-4bd3-a610-0dd1c9b9edc3
1781	18	2023-09-04T15:01:36Z	\N	0	\N	-1	5f935f7b-468a-4bd3-a610-0dd1c9b9edc3
1782	21	2023-08	\N	0	\N	-1	5f935f7b-468a-4bd3-a610-0dd1c9b9edc3
1843	4	pt_BR	\N	0	\N	-1	f7d06c53-c0de-4f14-a79a-a8ab735d172f
1904	9	IFBA, Diretoria de Políticas Afirmativas e Assuntos Estudantis	\N	0	\N	-1	454cf684-62f8-4b49-bfc5-b343499cf735
1905	9	Cunha Júnior, Henrique	\N	1	\N	-1	454cf684-62f8-4b49-bfc5-b343499cf735
1906	70	Tecnologias africanas e educação	pt_BR	0	\N	-1	454cf684-62f8-4b49-bfc5-b343499cf735
1908	45	EDIFBA	pt_BR	0	\N	-1	454cf684-62f8-4b49-bfc5-b343499cf735
1909	24	IFBA,Diretoria de Políticas Afirmativas e Assuntos estudantis. Tecnologias africanas e educação.Texto de Henrique Cunha Júnior/DPAAE. Salvador: EDIFBA, 2023. 56 p.	pt_BR	0	\N	-1	454cf684-62f8-4b49-bfc5-b343499cf735
1910	49	Coleção Pedagógica do Programa Asé-Toré: Formação em educação sobre negras(os) e Povos indígenas;7	\N	0	\N	-1	454cf684-62f8-4b49-bfc5-b343499cf735
1911	26	978-65-88985-37-3	\N	0	\N	-1	454cf684-62f8-4b49-bfc5-b343499cf735
1912	72	Livro	pt_BR	0	\N	-1	454cf684-62f8-4b49-bfc5-b343499cf735
1913	44	pt_BR	pt_BR	0	\N	-1	454cf684-62f8-4b49-bfc5-b343499cf735
870	70	capa_cad1.jpg.pdf	\N	0	\N	-1	f9f4ab05-ca6f-416c-a2cb-e42ff8a3ddef
871	61	/dspace/upload/capa_cad1.jpg.pdf	\N	0	\N	-1	f9f4ab05-ca6f-416c-a2cb-e42ff8a3ddef
1959	34	Made available in DSpace on 2023-11-01T14:23:20Z (GMT). No. of bitstreams: 1\nCulturas africanas e afro-brasileiras_cad.10.pdf: 7707788 bytes, checksum: d8bb8174bf7c9b1b7df92c79b60d2fc7 (MD5)\n  Previous issue date: 2023-10-30	en	1	\N	-1	c37aadfa-226f-4828-98bc-014c4e31d705
1916	63	História - África	pt_BR	0	\N	-1	454cf684-62f8-4b49-bfc5-b343499cf735
1917	63	Tecnologias	pt_BR	1	\N	-1	454cf684-62f8-4b49-bfc5-b343499cf735
1918	63	Arquitetura africana	pt_BR	2	\N	-1	454cf684-62f8-4b49-bfc5-b343499cf735
1955	31	http://www.asetore.ifba.edu.br:8080/jspui/handle/123456789/95	\N	0	\N	-1	c37aadfa-226f-4828-98bc-014c4e31d705
1233	70	LICENSE	\N	1	\N	-1	ff7d7cea-0e22-4c0a-8736-5c21a1cbe947
1956	17	2023-11-01T14:23:20Z	\N	0	\N	-1	c37aadfa-226f-4828-98bc-014c4e31d705
1957	18	2023-11-01T14:23:20Z	\N	0	\N	-1	c37aadfa-226f-4828-98bc-014c4e31d705
1958	21	2023-10-30	\N	0	\N	-1	c37aadfa-226f-4828-98bc-014c4e31d705
2011	63	Identidade Cutural	pt_BR	0	\N	-1	f337e86e-7ee2-466c-841c-13b345ec5676
647	70	LICENSE	\N	1	\N	-1	41004cb5-139b-460e-972d-cab8cb44c811
2012	63	Racismo	pt_BR	1	\N	-1	f337e86e-7ee2-466c-841c-13b345ec5676
1868	1	Maria Conceição	\N	0	\N	-1	bc6b8623-030f-41a3-954b-045a1587d607
1869	2	dos Santos	\N	0	\N	-1	bc6b8623-030f-41a3-954b-045a1587d607
1081	70	capa caderno 5.jpg	\N	0	\N	-1	f137eb4c-450f-40c0-81e5-48ffda8caf2b
1082	61	/dspace/upload/capa caderno 5.jpg	\N	0	\N	-1	f137eb4c-450f-40c0-81e5-48ffda8caf2b
886	70	capa caderno1.jpg	\N	0	\N	-1	c74beb9b-1608-4a6f-b5aa-6cc228a98877
887	61	/dspace/upload/capa caderno1.jpg	\N	0	\N	-1	c74beb9b-1608-4a6f-b5aa-6cc228a98877
1788	1	Keyla	\N	0	\N	-1	5fe9d514-2429-42cd-9d85-6365dbfce788
1789	2	Rabêlo	\N	0	\N	-1	5fe9d514-2429-42cd-9d85-6365dbfce788
1790	3	(73) 99131-2332	\N	0	\N	-1	5fe9d514-2429-42cd-9d85-6365dbfce788
1791	4	pt_BR	\N	0	\N	-1	5fe9d514-2429-42cd-9d85-6365dbfce788
685	70	O Pensar Científico de Africanos e de seus descendentes nas Ciências.pdf	\N	0	\N	-1	cb96ce77-f592-45b1-9134-e7edc95a6fc3
686	61	/dspace/upload/O Pensar Científico de Africanos e de seus descendentes nas Ciências.pdf	\N	0	\N	-1	cb96ce77-f592-45b1-9134-e7edc95a6fc3
687	32	Livro	\N	0	\N	-1	cb96ce77-f592-45b1-9134-e7edc95a6fc3
688	70	license.txt	\N	0	\N	-1	f0ea2228-0bac-4d69-8132-9064c1d74396
689	61	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	f0ea2228-0bac-4d69-8132-9064c1d74396
690	9	IFBA, Diretoria de Políticas Afirmativas e Assuntos Estudantis	\N	0	\N	-1	b6dfa584-d9d6-4e67-9b10-13433ace7e38
691	9	Silvério, Florença Freitas	\N	1	\N	-1	b6dfa584-d9d6-4e67-9b10-13433ace7e38
692	17	2023-08-14T14:34:21Z	\N	0	\N	-1	b6dfa584-d9d6-4e67-9b10-13433ace7e38
693	18	2023-08-14T14:34:21Z	\N	0	\N	-1	b6dfa584-d9d6-4e67-9b10-13433ace7e38
694	21	2023-08-14	\N	0	\N	-1	b6dfa584-d9d6-4e67-9b10-13433ace7e38
695	32	O Instituto Federal de Educação, Ciência e Tecnologia\r\nda Bahia tem a honra de apresentar a Coleção Pedagógica do Programa Asé-Toré: Formação em Educação\r\nsobre negras(os) e povos indígenas, produto de um dos\r\nProgramas de educação para relações étnico-raciais\r\ndesenvolvido pela Diretoria Sistêmica de Políticas Afirmativas e Assuntos Estudantis – DPAAE/IFBA.\r\nEstamos felizes em materializar esta coleção, que\r\nmarca o compromisso da nossa instituição em validar\r\na legislação nacional que trata da obrigatoriedade\r\nde educar sobre História da África, afro-brasileira e\r\nindígena, identificando-a como conquista dos movimentos sociais, negros e indígenas brasileiros. Assim,\r\nreconhecemos as lutas de quem veio antes, agradecemos às/aos servidoras/es, gestoras/es e estudantes\r\nque bravamente promovem o debate racial no IFBA\r\ne fortalecemos esforços em prol de uma educação\r\nantirracista.\r\nPREFÁCIO\r\nA Coleção Pedagógica Asé-Toré representa um marco na institucionalidade de ações que contribuem\r\npara que o IFBA solidifique sua missão institucional:\r\n“Promover a formação do cidadão histórico-crítico,\r\noferecendo ensino, pesquisa e extensão com qualidade socialmente referenciada, objetivando o desenvolvimento sustentável do país”. Além disso, a Coleção\r\ninaugura novas estratégias institucionais e interdisciplinares, ao desenvolver um produto didático e acessível a todos os níveis, formas e modalidades de ensino\r\nque ofertamos.\r\nDesejo boa leitura e estudos. Que a Coleção Pedagógica Asé-Toré alcance a comunidade do IFBA e, também, as famílias dos nossos estudantes, organizações\r\nsociais e instituições de ensino do nosso Estado e país.\r\nPROFESSORA DRA. LUZIA MATOS MOTA\r\nREITORA DO IFBA	pt_BR	0	\N	-1	b6dfa584-d9d6-4e67-9b10-13433ace7e38
696	33	“Asé-Toré”, junção das palavras “Asé” (na língua\r\niorubá, significa poder, energia ou força presente\r\nem cada ser ou em cada coisa, que nas religiões afro\r\n-\r\n-brasileiras representa a energia sagrada dos orixás)\r\ne “Toré” (expressão espiritual-religiosa de grande\r\nimportância para os indígenas), significa para nós o\r\nresgate da força coletiva e energia vital da ancestra\r\n-\r\nlidade para vencer os desafios contemporâneos do\r\npovo negro e indígena.\r\nÉ com este nome repleto de significados e potências\r\nque a Diretoria Sistêmica de Políticas Afirmativas e\r\nAssuntos Estudantis – DPAAE/IFBA apresenta à co\r\n-\r\nmunidade interna e externa do Instituto Federal de\r\nEducação, Ciência e Tecnologia da Bahia (IFBA) esta\r\nColeção Pedagógica, um dos produtos do “Programa\r\nAsé-Toré: Formação em educação sobre negras(os)\r\ne povos indígenas do Instituto Federal de Educação,\r\nCiência e Tecnologia (IFBA), voltado à formação de\r\ngestoras(es), professoras(es), técnicas(os) administra\r\n-\r\ntivas(os), estudantes e comunidade na área da Educa\r\n-\r\nção das Relações Étnico-Raciais e ao enfrentamento\r\nao racismo no âmbito do IFBA.\r\nO Programa Asé-Toré foi institucionalizado por meio\r\nde Chamada Pública do IFBA/DPAAE, que possibilitou\r\na contratação de duas Coordenadoras (Coordenadora\r\nGeral e Coordenadora dos Cadernos Temáticos); 15\r\nbolsistas “professores conteudistas”; cinco bolsistas\r\n“professores pareceristas”; dois apoios administrati\r\n-\r\nvos pedagógicos e uma ilustradora para a produção\r\ndos Cadernos Temáticos. Envolveu, ainda, mais de dez\r\npesquisadoras(es) para o Conselho Editorial e diver\r\n-\r\nsas(os) servidoras(es) internos e externos do IFBA que\r\ncontribuíram na seleção dos bolsistas.\r\nA DPAAE é uma Diretoria recente na história do IFBA,\r\nsendo criada em 2020. Desta forma, a entrega à so\r\n-\r\nciedade da Coleção Pedagógica Asé-Toré se torna um\r\nmarco importante no cumprimento às normativas\r\nque tratam da educação das relações étnico-raciais o\r\nqual foi também missão da Diretoria. A Coleção tem\r\no objetivo de promover a Educação das Relações Ét\r\n-\r\nnico-raciais, cumprindo a Lei de Diretrizes e Base da\r\nEducação Nacional – LDB, especialmente no que con\r\n-\r\ncerne à implantação das Leis Federais nº 10.639/03\r\ne nº 11.645/08, as quais afirmam a obrigatoriedade\r\ndo estudo da “História da África e dos africanos”, da\r\n“luta dos negros e dos povos indígenas no Brasil”, da\r\n“cultura negra e indígena brasileira” e “o negro e o\r\níndio na formação da sociedade nacional”, “resgatan\r\n-\r\ndo as suas contribuições nas áreas social, econômica\r\ne política, pertinentes à história do Brasil.” (BRASIL,\r\n2008). Do mesmo modo, considerou-se as Diretrizes\r\n10\r\nCurriculares Nacionais para a Educação das Relações\r\nÉtnico-Raciais e para o Ensino de História e Cultura\r\nAfro-Brasileira e Africana, passando, ainda, por outras\r\nnormativas do estado da Bahia.\r\nComposta por 15 cadernos temáticos, a Coleção Pedagógica Asé-Toré cumpre esforços institucionais de\r\ncontribuir com a formulação de um material didático,\r\nfundamentado numa perspectiva de valorização da\r\neducação das relações étnico-raciais, da diversidade\r\nétnico-racial na educação, no enfrentamento ao racismo institucional, na valorização das ações afirmativas\r\npara a população negra e povos indígenas. Representa, ademais, contribuições coletivas de profissionais,\r\npesquisadoras/intelectuais ativistas ou não, em sua\r\nmaioria negros e mulheres, sendo destacada a participação de dois indígenas. Estas(es) pesquisadoras(es)\r\nse dedicaram a uma metodologia inovadora de trabalho baseada em aspectos da cosmovisão de mundo\r\nafricana e indígena, enfatizando o trabalho coletivo,\r\nvalorizando as lutas sociais, a produção de autoras(es)\r\nnegras(os) e indígenas e considerando suas vivências\r\ne experiências na forma e formato dos conteúdos e\r\nimagens.\r\nO Programa Asé-Toré nasceu a partir de um projeto\r\nmais amplo de implementação da Lei 10.639/03,\r\noriginalmente escrito por mim, Marcilene Garcia de\r\nSouza, e pelo professor Dr. Hélio Santos, em 2017.\r\nAqui no IFBA (DPAAE), o Programa se apresentou\r\nde forma mais sintetizada em que se destacam três\r\nprodutos: Produção dos 15 Cadernos Temáticos; Institucionalização de uma biblioteca virtual temática e\r\numa série de formações sobre educação das relações\r\nétnico-raciais.\r\nFaz-se necessário registrar o empenho da gestão\r\ndo IFBA para a realização do Programa Asé-Toré, na\r\npessoa da Reitora Profa. Dra. Luzia Matos Mota, que\r\né mulher negra, e na do Pró-Reitor de Ensino, Prof.\r\nDr. Jancarlos Lapa, mas também da Equipe gestora da DPAAE que contribui de forma mais direta na\r\nexecução do Programa: Profa. Mestra Thelma Ramos\r\n(Chefe da Coordenação Indígena e Povos Tradicionais\r\n– CIND/DPAF/DPAAE), a pedagoga Jacineide Arão\r\ndos Santos Profeta (Chefe do Departamento de Políticas Afirmativas – DPAF/DPAAE) e a assistente social\r\nCacilda Ferreira dos Reis (Chefe do Departamento de\r\nAssuntos Estudantis – DAES/DPAAE).\r\n\r\nPROFª. DRA. MARCILENE GARCIA DE SOUZA\r\nDIRETORA SISTÊMICA DE POLÍTICAS AFIRMATIVAS\r\nE ASSUNTOS ESTUDANTIS DO IFBA	pt_BR	0	\N	-1	b6dfa584-d9d6-4e67-9b10-13433ace7e38
700	26	978-65-88985-32-8	\N	0	\N	-1	b6dfa584-d9d6-4e67-9b10-13433ace7e38
701	31	http://www.asetore.ifba.edu.br:8080/jspui/handle/123456789/70	\N	0	\N	-1	b6dfa584-d9d6-4e67-9b10-13433ace7e38
1716	70	license.txt	\N	0	\N	-1	b0a816ce-64d0-4b01-924e-28a4a5b85d4e
1717	61	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	b0a816ce-64d0-4b01-924e-28a4a5b85d4e
1718	32	Caderno 15	\N	0	\N	-1	b0a816ce-64d0-4b01-924e-28a4a5b85d4e
1719	70	Movimentos negros contemporaneos cad.15.pdf	\N	0	\N	-1	b9d4ea49-d4b5-41b8-9891-0c65ff4bcbae
1720	61	/dspace/upload/Movimentos negros contemporaneos cad.15.pdf	\N	0	\N	-1	b9d4ea49-d4b5-41b8-9891-0c65ff4bcbae
1721	32	Livro	\N	0	\N	-1	b9d4ea49-d4b5-41b8-9891-0c65ff4bcbae
1722	9	IFBA, Diretoria de Políticas Afirmativas e Assuntos Estudantis	\N	0	\N	-1	66bb3a28-09f6-4ced-8423-57b3d96b060f
1723	9	Araújo, Danielle Ferreira Medeiros da Silva de	\N	1	\N	-1	66bb3a28-09f6-4ced-8423-57b3d96b060f
1724	17	2023-08-14T16:23:29Z	\N	0	\N	-1	66bb3a28-09f6-4ced-8423-57b3d96b060f
1725	18	2023-08-14T16:23:29Z	\N	0	\N	-1	66bb3a28-09f6-4ced-8423-57b3d96b060f
1726	21	2023-10-14	\N	0	\N	-1	66bb3a28-09f6-4ced-8423-57b3d96b060f
1734	44	pt_BR	pt_BR	0	\N	-1	66bb3a28-09f6-4ced-8423-57b3d96b060f
1735	45	EDIFBA	pt_BR	0	\N	-1	66bb3a28-09f6-4ced-8423-57b3d96b060f
1736	49	Coleção Pedagógica do Programa Asé Toré Formação em Educação sobre negras(os) e Povos Indígenas,;caderno 15	\N	0	\N	-1	66bb3a28-09f6-4ced-8423-57b3d96b060f
1737	63	Movimentos Sociais	pt_BR	0	\N	-1	66bb3a28-09f6-4ced-8423-57b3d96b060f
1738	63	História	pt_BR	1	\N	-1	66bb3a28-09f6-4ced-8423-57b3d96b060f
1739	63	Movimentos Negros	pt_BR	2	\N	-1	66bb3a28-09f6-4ced-8423-57b3d96b060f
1740	63	Povos Indígenas	pt_BR	3	\N	-1	66bb3a28-09f6-4ced-8423-57b3d96b060f
1741	63	Direitos Humanos	pt_BR	4	\N	-1	66bb3a28-09f6-4ced-8423-57b3d96b060f
1742	63	Lutas Sociais	pt_BR	5	\N	-1	66bb3a28-09f6-4ced-8423-57b3d96b060f
1743	70	Movimentos negros contemporâneos e movimentos sociais Indígenas	pt_BR	0	\N	-1	66bb3a28-09f6-4ced-8423-57b3d96b060f
1744	72	Livro	pt_BR	0	\N	-1	66bb3a28-09f6-4ced-8423-57b3d96b060f
1820	1	Lidiane	\N	0	\N	-1	b322b52d-0d56-417a-9f6b-8a56a93c0fb6
1821	2	Silva	\N	0	\N	-1	b322b52d-0d56-417a-9f6b-8a56a93c0fb6
1822	3	81997896158	\N	0	\N	-1	b322b52d-0d56-417a-9f6b-8a56a93c0fb6
1823	4	pt_BR	\N	0	\N	-1	b322b52d-0d56-417a-9f6b-8a56a93c0fb6
1844	1	Manuel	\N	0	\N	-1	fc137b84-0aef-422b-8471-e0c77bd69f4c
1845	2	Aniceto Pereira Neto	\N	0	\N	-1	fc137b84-0aef-422b-8471-e0c77bd69f4c
1846	3	71984255886	\N	0	\N	-1	fc137b84-0aef-422b-8471-e0c77bd69f4c
1847	4	pt_BR	\N	0	\N	-1	fc137b84-0aef-422b-8471-e0c77bd69f4c
1852	1	Thelma	\N	0	\N	-1	3c67b8b8-3e57-445d-8995-aacb73bf4db1
1853	2	Lima da Cunha Ramos	\N	0	\N	-1	3c67b8b8-3e57-445d-8995-aacb73bf4db1
1854	3	71992922795	\N	0	\N	-1	3c67b8b8-3e57-445d-8995-aacb73bf4db1
1855	4	pt_BR	\N	0	\N	-1	3c67b8b8-3e57-445d-8995-aacb73bf4db1
1870	3	77933015094	\N	0	\N	-1	bc6b8623-030f-41a3-954b-045a1587d607
1871	4	pt_BR	\N	0	\N	-1	bc6b8623-030f-41a3-954b-045a1587d607
893	70	Logo Asé-Toré.jpeg	\N	0	\N	-1	8afdd918-d2e2-4888-aefc-9b94ce7a3aac
894	61	/dspace/upload/Logo Asé-Toré.jpeg	\N	0	\N	-1	8afdd918-d2e2-4888-aefc-9b94ce7a3aac
895	70	Cadernos Temáticos - Coleção Pedagógica Asé-Toré	\N	0	\N	-1	fb0a9847-448b-412a-b5fc-ca8dda1e957c
896	33	Apresenta 15 cadernos temáticos e de conteúdo didático e seus respectivos vídeos de apresentação, como contribuição original ao campo de formação das relações raciais.	\N	0	\N	-1	fb0a9847-448b-412a-b5fc-ca8dda1e957c
897	59	Cada Caderno Temático da Coleção Pedagógica Asé-Toré tem o DNA da equipe (autor@s, pareceristas, gestão, conselheir@s) e, ao mesmo tempo, a singularidade da escrevivência de cada autora e autor selecionada no âmbito da chamada pública nº 003/2020 DPAAE/IFBA.	\N	0	\N	-1	fb0a9847-448b-412a-b5fc-ca8dda1e957c
1245	9	IFBA, Diretoria de Políticas Afirmativas e Assuntos Estudantis	\N	0	\N	-1	9e984c6f-a21b-4d2a-b168-59665345bb19
1246	9	Argemiro, Renata do Nascimento	\N	1	\N	-1	9e984c6f-a21b-4d2a-b168-59665345bb19
1247	9	Paim, Márcio Luís da Silva	\N	2	\N	-1	9e984c6f-a21b-4d2a-b168-59665345bb19
1248	70	História da África	pt_BR	0	\N	-1	9e984c6f-a21b-4d2a-b168-59665345bb19
1250	45	EDIFBA	pt_BR	0	\N	-1	9e984c6f-a21b-4d2a-b168-59665345bb19
1251	24	IFBA,Diretoria de Políticas Afirmativas e Assuntos estudantis. História da África. Texto de Renata do Nascimento Argemiro; Márcio Luís da Silva Paim/DPAAE. Salvador: EDIFBA, 2023. 58 p.	pt_BR	0	\N	-1	9e984c6f-a21b-4d2a-b168-59665345bb19
1252	49	Coleção Pedagógica do Programa Asé-Toré: Formação em educação sobre negras(os) e Povos indígenas;5	\N	0	\N	-1	9e984c6f-a21b-4d2a-b168-59665345bb19
1253	26	978-65-88985-35-9	\N	0	\N	-1	9e984c6f-a21b-4d2a-b168-59665345bb19
1254	72	Livro	pt_BR	0	\N	-1	9e984c6f-a21b-4d2a-b168-59665345bb19
1255	44	pt_BR	pt_BR	0	\N	-1	9e984c6f-a21b-4d2a-b168-59665345bb19
1270	31	http://www.asetore.ifba.edu.br:8080/jspui/handle/123456789/90	\N	0	\N	-1	9e984c6f-a21b-4d2a-b168-59665345bb19
1258	63	África - História	pt_BR	0	\N	-1	9e984c6f-a21b-4d2a-b168-59665345bb19
1259	63	História - Cultura	pt_BR	1	\N	-1	9e984c6f-a21b-4d2a-b168-59665345bb19
1260	33	APRESENTAÇÃO DA COLEÇÃO PEDAGÓGICA\r\n“Asé-Toré”, junção das palavras “Asé” (na língua\r\niorubá, significa poder, energia ou força presente\r\nem cada ser ou em cada coisa, que nas religiões afro\r\n-\r\n-brasileiras representa a energia sagrada dos orixás)\r\ne “Toré” (expressão espiritual-religiosa de grande\r\nimportância para os indígenas), significa para nós o\r\nresgate da força coletiva e energia vital da ancestra\r\n-\r\nlidade para vencer os desafios contemporâneos do\r\npovo negro e indígena.\r\nÉ com este nome repleto de significados e potências\r\nque a Diretoria Sistêmica de Políticas Afirmativas e\r\nAssuntos Estudantis – DPAAE/IFBA apresenta à co\r\n-\r\nmunidade interna e externa do Instituto Federal de\r\nEducação, Ciência e Tecnologia da Bahia (IFBA) esta\r\nColeção Pedagógica, um dos produtos do “Programa\r\nAsé-Toré: Formação em educação sobre negras(os)\r\ne povos indígenas do Instituto Federal de Educação,\r\nCiência e Tecnologia (IFBA), voltado à formação de\r\ngestoras(es), professoras(es), técnicas(os) administra\r\n-\r\ntivas(os), estudantes e comunidade na área da Educa\r\n-\r\nção das Relações Étnico-Raciais e ao enfrentamento\r\nao racismo no âmbito do IFBA.\r\nO Programa Asé-Toré foi institucionalizado por meio\r\nde Chamada Pública do IFBA/DPAAE, que possibilitou\r\na contratação de duas Coordenadoras (Coordenadora\r\nGeral e Coordenadora dos Cadernos Temáticos); 15\r\nbolsistas “professores conteudistas”; cinco bolsistas\r\n“professores pareceristas”; dois apoios administrati\r\n-\r\nvos pedagógicos e uma ilustradora para a produção\r\ndos Cadernos Temáticos. Envolveu, ainda, mais de dez\r\npesquisadoras(es) para o Conselho Editorial e diver\r\n-\r\nsas(os) servidoras(es) internos e externos do IFBA que\r\ncontribuíram na seleção dos bolsistas.\r\nA DPAAE é uma Diretoria recente na história do IFBA,\r\nsendo criada em 2020. Desta forma, a entrega à so\r\n-\r\nciedade da Coleção Pedagógica Asé-Toré se torna um\r\nmarco importante no cumprimento às normativas\r\nque tratam da educação das relações étnico-raciais o\r\nqual foi também missão da Diretoria. A Coleção tem\r\no objetivo de promover a Educação das Relações Ét\r\n-\r\nnico-raciais, cumprindo a Lei de Diretrizes e Base da\r\nEducação Nacional – LDB, especialmente no que con\r\n-\r\ncerne à implantação das Leis Federais nº 10.639/03\r\ne nº 11.645/08, as quais afirmam a obrigatoriedade\r\ndo estudo da “História da África e dos africanos”, da\r\n“luta dos negros e dos povos indígenas no Brasil”, da\r\n“cultura negra e indígena brasileira” e “o negro e o\r\níndio na formação da sociedade nacional”, “resgatan\r\n-\r\ndo as suas contribuições nas áreas social, econômica\r\ne política, pertinentes à história do Brasil.” (BRASIL,\r\n2008). Do mesmo modo, considerou-se as Diretrizes\r\n10\r\nCurriculares Nacionais para a Educação das Relações\r\nÉtnico-Raciais e para o Ensino de História e Cultura\r\nAfro-Brasileira e Africana, passando, ainda, por outras\r\nnormativas do estado da Bahia.\r\nComposta por 15 cadernos temáticos, a Coleção Pe\r\n-\r\ndagógica Asé-Toré cumpre esforços institucionais de\r\ncontribuir com a formulação de um material didático,\r\nfundamentado numa perspectiva de valorização da\r\neducação das relações étnico-raciais, da diversidade\r\nétnico-racial na educação, no enfrentamento ao racis\r\n-\r\nmo institucional, na valorização das ações afirmativas\r\npara a população negra e povos indígenas. Represen\r\n-\r\nta, ademais, contribuições coletivas de profissionais,\r\npesquisadoras/intelectuais ativistas ou não, em sua\r\nmaioria negros e mulheres, sendo destacada a parti\r\n-\r\ncipação de dois indígenas. Estas(es) pesquisadoras(es)\r\nse dedicaram a uma metodologia inovadora de traba\r\n-\r\nlho baseada em aspectos da cosmovisão de mundo\r\nafricana e indígena, enfatizando o trabalho coletivo,\r\nvalorizando as lutas sociais, a produção de autoras(es)\r\nnegras(os) e indígenas e considerando suas vivências\r\ne experiências na forma e formato dos conteúdos e\r\nimagens.\r\nO Programa Asé-Toré nasceu a partir de um projeto\r\nmais amplo de implementação da Lei 10.639/03,\r\noriginalmente escrito por mim, Marcilene Garcia de\r\nSouza, e pelo professor Dr. Hélio Santos, em 2017.\r\nAqui no IFBA (DPAAE), o Programa se apresentou\r\nde forma mais sintetizada em que se destacam três\r\nprodutos: Produção dos 15 Cadernos Temáticos; Ins\r\n-\r\ntitucionalização de uma biblioteca virtual temática e\r\numa série de formações sobre educação das relações\r\nétnico-raciais.\r\nFaz-se necessário registrar o empenho da gestão\r\ndo IFBA para a realização do Programa Asé-Toré, na\r\npessoa da Reitora Profa. Dra. Luzia Matos Mota, que\r\né mulher negra, e na do Pró-Reitor de Ensino, Prof.\r\nDr. Jancarlos Lapa, mas também da Equipe gesto\r\n-\r\nra da DPAAE que contribui de forma mais direta na\r\nexecução do Programa: Profa. Mestra Thelma Ramos\r\n(Chefe da Coordenação Indígena e Povos Tradicionais\r\n– CIND/DPAF/DPAAE), a pedagoga Jacineide Arão\r\ndos Santos Profeta (Chefe do Departamento de Políti\r\n-\r\ncas Afirmativas – DPAF/DPAAE) e a assistente social\r\nCacilda Ferreira dos Reis (Chefe do Departamento de\r\nAssuntos Estudantis – DAES/DPAAE).\r\n\r\nPROFª. DRA. MARCILENE GARCIA DE SOUZA\r\nDIRETORA SISTÊMICA DE POLÍTICAS AFIRMATIVAS\r\nE ASSUNTOS ESTUDANTIS DO IFBA	pt_BR	0	\N	-1	9e984c6f-a21b-4d2a-b168-59665345bb19
1261	32	O Instituto Federal de Educação, Ciência e Tecnologia\r\nda Bahia tem a honra de apresentar a Coleção Pedagógica do Programa Asé-Toré: Formação em Educação\r\nsobre negras(os) e povos indígenas, produto de um dos\r\nProgramas de educação para relações étnico-raciais\r\ndesenvolvido pela Diretoria Sistêmica de Políticas Afirmativas e Assuntos Estudantis – DPAAE/IFBA.\r\nEstamos felizes em materializar esta coleção, que\r\nmarca o compromisso da nossa instituição em validar\r\na legislação nacional que trata da obrigatoriedade\r\nde educar sobre História da África, afro-brasileira e\r\nindígena, identificando-a como conquista dos movimentos sociais, negros e indígenas brasileiros. Assim,\r\nreconhecemos as lutas de quem veio antes, agradecemos às/aos servidoras/es, gestoras/es e estudantes\r\nque bravamente promovem o debate racial no IFBA\r\ne fortalecemos esforços em prol de uma educação\r\nantirracista.\r\nPREFÁCIO\r\nA Coleção Pedagógica Asé-Toré representa um marco na institucionalidade de ações que contribuem\r\npara que o IFBA solidifique sua missão institucional:\r\n“Promover a formação do cidadão histórico-crítico,\r\noferecendo ensino, pesquisa e extensão com qualidade socialmente referenciada, objetivando o desenvolvimento sustentável do país”. Além disso, a Coleção\r\ninaugura novas estratégias institucionais e interdisciplinares, ao desenvolver um produto didático e acessível a todos os níveis, formas e modalidades de ensino\r\nque ofertamos.\r\nDesejo boa leitura e estudos. Que a Coleção Pedagógica Asé-Toré alcance a comunidade do IFBA e, também, as famílias dos nossos estudantes, organizações\r\nsociais e instituições de ensino do nosso Estado e país.\r\nPROFESSORA DRA. LUZIA MATOS MOTA\r\nREITORA DO IFBA	pt_BR	0	\N	-1	9e984c6f-a21b-4d2a-b168-59665345bb19
1262	70	ORIGINAL	\N	1	\N	-1	faf47611-7203-4c82-aedb-c5333d5e84a0
1263	70	História da África, cad 5.pdf	\N	0	\N	-1	442733cd-6e42-4067-aec3-7ab56c0400b2
1264	61	/dspace/upload/História da África, cad 5.pdf	\N	0	\N	-1	442733cd-6e42-4067-aec3-7ab56c0400b2
1265	32	Livro	\N	0	\N	-1	442733cd-6e42-4067-aec3-7ab56c0400b2
1266	70	LICENSE	\N	1	\N	-1	cfec0436-26af-4ba7-80d0-4fbdfd6220f7
1344	70	Historia e cultura dos povos indigenas na Bahia e no Brasil , cad 4.pdf	\N	0	\N	-1	3aa79369-e6ac-4cde-9da1-78f0e0416693
1345	61	/dspace/upload/Historia e cultura dos povos indigenas na Bahia e no Brasil , cad 4.pdf	\N	0	\N	-1	3aa79369-e6ac-4cde-9da1-78f0e0416693
1267	70	license.txt	\N	0	\N	-1	9d699cab-947c-4a96-b7fb-6095ae6a853a
1268	61	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	9d699cab-947c-4a96-b7fb-6095ae6a853a
1269	34	Submitted by Andreia Ribeiro (andreiasr@ifba.edu.br) on 2023-09-04T11:24:13Z\nNo. of bitstreams: 1\nHistória da África, cad 5.pdf: 10153433 bytes, checksum: 2684ca8f94542f262e73c65bef7ee6b6 (MD5)	en	0	\N	-1	9e984c6f-a21b-4d2a-b168-59665345bb19
1792	1	José	\N	0	\N	-1	f902581e-e799-4498-bcca-deb6f040e233
1793	2	Otavio	\N	0	\N	-1	f902581e-e799-4498-bcca-deb6f040e233
1274	34	Made available in DSpace on 2023-09-04T11:24:13Z (GMT). No. of bitstreams: 1\nHistória da África, cad 5.pdf: 10153433 bytes, checksum: 2684ca8f94542f262e73c65bef7ee6b6 (MD5)\n  Previous issue date: 2023-08	en	1	\N	-1	9e984c6f-a21b-4d2a-b168-59665345bb19
1271	17	2023-09-04T11:24:13Z	\N	0	\N	-1	9e984c6f-a21b-4d2a-b168-59665345bb19
1272	18	2023-09-04T11:24:13Z	\N	0	\N	-1	9e984c6f-a21b-4d2a-b168-59665345bb19
1273	21	2023-08	\N	0	\N	-1	9e984c6f-a21b-4d2a-b168-59665345bb19
1794	3	+5571992050189	\N	0	\N	-1	f902581e-e799-4498-bcca-deb6f040e233
1795	4	pt_BR	\N	0	\N	-1	f902581e-e799-4498-bcca-deb6f040e233
1804	1	Carlos	\N	0	\N	-1	15cdcc8f-cf09-407d-9dfc-29472544d07d
1805	2	Alexandrino	\N	0	\N	-1	15cdcc8f-cf09-407d-9dfc-29472544d07d
1806	3	21991760057	\N	0	\N	-1	15cdcc8f-cf09-407d-9dfc-29472544d07d
1807	4	pt_BR	\N	0	\N	-1	15cdcc8f-cf09-407d-9dfc-29472544d07d
1828	1	Magda	\N	0	\N	-1	6c4ae0f5-cd87-42d7-9234-c774fa3484a5
1829	2	Cruz	\N	0	\N	-1	6c4ae0f5-cd87-42d7-9234-c774fa3484a5
1830	3	(71) 99138-9899	\N	0	\N	-1	6c4ae0f5-cd87-42d7-9234-c774fa3484a5
1346	32	Livro	\N	0	\N	-1	3aa79369-e6ac-4cde-9da1-78f0e0416693
1831	4	pt_BR	\N	0	\N	-1	6c4ae0f5-cd87-42d7-9234-c774fa3484a5
1848	1	Lizandra	\N	0	\N	-1	877ece01-2af9-4a2e-b901-58e0eabe3d3d
1849	2	Sacramento	\N	0	\N	-1	877ece01-2af9-4a2e-b901-58e0eabe3d3d
1850	3	71983460870	\N	0	\N	-1	877ece01-2af9-4a2e-b901-58e0eabe3d3d
1851	4	pt_BR	\N	0	\N	-1	877ece01-2af9-4a2e-b901-58e0eabe3d3d
1860	1	Silvio	\N	0	\N	-1	f3a701de-a6e6-467a-be2a-1b9feb40e489
1861	2	Jesus	\N	0	\N	-1	f3a701de-a6e6-467a-be2a-1b9feb40e489
1862	3	71992436311	\N	0	\N	-1	f3a701de-a6e6-467a-be2a-1b9feb40e489
1808	1	Juliana	\N	0	\N	-1	aaf0b7cf-cfee-4539-84a1-656789dd522a
1809	2	de Araújo	\N	0	\N	-1	aaf0b7cf-cfee-4539-84a1-656789dd522a
1810	3	71986318328	\N	0	\N	-1	aaf0b7cf-cfee-4539-84a1-656789dd522a
1811	4	pt_BR	\N	0	\N	-1	aaf0b7cf-cfee-4539-84a1-656789dd522a
1088	9	IFBA, Diretoria de Políticas Afirmativas e Assuntos Estudantis	\N	0	\N	-1	39926264-0a06-432f-bb03-18d391841d73
1089	9	Mota Júnior, Everaldo Rodrigues	\N	1	\N	-1	39926264-0a06-432f-bb03-18d391841d73
1090	70	Territórios e povos indígenas no Brasil e na Bahia	pt_BR	0	\N	-1	39926264-0a06-432f-bb03-18d391841d73
1092	45	EDIFBA	pt_BR	0	\N	-1	39926264-0a06-432f-bb03-18d391841d73
1093	24	IFBA,Diretoria de Políticas Afirmativas e Assuntos estudantis. Territórios e povos indígenas no Brasil e na Bahia. Texto de Everaldo Rodrigues Mota Júnior/DPAAE. Salvador: EDIFBA, 2023. 53 p.	pt_BR	0	\N	-1	39926264-0a06-432f-bb03-18d391841d73
1094	49	Coleção Pedagógica do Programa Asé-Toré: Formação em educação sobre negras(os) e Povos indígenas;3	\N	0	\N	-1	39926264-0a06-432f-bb03-18d391841d73
1095	26	978-65-88985-17-5	\N	0	\N	-1	39926264-0a06-432f-bb03-18d391841d73
1096	72	Livro	pt_BR	0	\N	-1	39926264-0a06-432f-bb03-18d391841d73
1097	44	pt_BR	pt_BR	0	\N	-1	39926264-0a06-432f-bb03-18d391841d73
1824	1	Elvina	\N	0	\N	-1	f647b204-93e9-4df8-bd5d-86f5955cdbfe
1825	2	Zaparoli	\N	0	\N	-1	f647b204-93e9-4df8-bd5d-86f5955cdbfe
1826	3	11 954453760	\N	0	\N	-1	f647b204-93e9-4df8-bd5d-86f5955cdbfe
1827	4	pt_BR	\N	0	\N	-1	f647b204-93e9-4df8-bd5d-86f5955cdbfe
834	70	Movimentos negros contemporâneos e movimentos sociais Indígenas.pdf	\N	0	\N	-1	b756ceae-057c-4796-997e-16374744e2e7
835	61	/dspace/upload/Movimentos negros contemporâneos e movimentos sociais Indígenas.pdf	\N	0	\N	-1	b756ceae-057c-4796-997e-16374744e2e7
836	32	Livro	\N	0	\N	-1	b756ceae-057c-4796-997e-16374744e2e7
1856	1	Taylor	\N	0	\N	-1	b0050c80-1cf2-47bd-b0da-92241fb1a49a
1857	2	Silva Menezes dos Santos	\N	0	\N	-1	b0050c80-1cf2-47bd-b0da-92241fb1a49a
1858	3	71987464070	\N	0	\N	-1	b0050c80-1cf2-47bd-b0da-92241fb1a49a
1859	4	pt_BR	\N	0	\N	-1	b0050c80-1cf2-47bd-b0da-92241fb1a49a
1919	33	O Instituto Federal de Educação, Ciência e Tecnologia da Bahia tem a honra de apresentar a Coleção Pedagógica do Programa Asé-Toré: Formação em Educação sobre negras(os) e povos indígenas, produto de um dos Programas de educação para relações étnico-raciais desenvolvido pela Diretoria Sistêmica de Políticas Afirmativas e Assuntos Estudantis – DPAAE/IFBA.\r\nEstamos felizes em materializar esta coleção, que\r\nmarca o compromisso da nossa instituição em validar a legislação nacional que trata da obrigatoriedade\r\nde educar sobre História da África, afro-brasileira e indígena, identificando-a como conquista dos movimentos sociais, negros e indígenas brasileiros. Assim,\r\nreconhecemos as lutas de quem veio antes, agradecemos às/aos servidoras/es, gestoras/es e estudantes\r\nque bravamente promovem o debate racial no IFBA e fortalecemos esforços em prol de uma educação\r\nantirracista.\r\nA Coleção Pedagógica Asé-Toré representa um marco na institucionalidade de ações que contribuem\r\npara que o IFBA solidifique sua missão institucional:\r\n“Promover a formação do cidadão histórico-crítico, oferecendo ensino, pesquisa e extensão com qualidade socialmente referenciada, objetivando o desenvolvimento sustentável do país”. Além disso, a Coleção\r\ninaugura novas estratégias institucionais e interdisciplinares, ao desenvolver um produto didático e acessível a todos os níveis, formas e modalidades de ensino que ofertamos.\r\nDesejo boa leitura e estudos. Que a Coleção Pedagógica Asé-Toré alcance a comunidade do IFBA e, também, as famílias dos nossos estudantes, organizações sociais e instituições de ensino do nosso Estado e país.\r\nPROFESSORA DRA. LUZIA MATOS MOTA\r\nREITORA DO IFBA	pt_BR	0	\N	-1	454cf684-62f8-4b49-bfc5-b343499cf735
1920	70	ORIGINAL	\N	1	\N	-1	b97b63ea-ce0a-4c12-9e6b-1a4b3bb3876e
2089	34	Submitted by Andreia Ribeiro (andreiasr@ifba.edu.br) on 2023-11-06T13:32:14Z\r\nNo. of bitstreams: 1\r\nQuilombolas na Bahia, lutas e resistencias. Cad11.pdf: 7734114 bytes, checksum: f3dbe1b44bd002393e029bddc3db6510 (MD5)	en	0	\N	-1	121a4efd-d31c-4a8b-9d4c-f57c7f7d0c02
2090	34	Made available in DSpace on 2023-11-06T13:32:14Z (GMT). No. of bitstreams: 1\r\nQuilombolas na Bahia, lutas e resistencias. Cad11.pdf: 7734114 bytes, checksum: f3dbe1b44bd002393e029bddc3db6510 (MD5)\r\n  Previous issue date: 2023-10-30	en	1	\N	-1	121a4efd-d31c-4a8b-9d4c-f57c7f7d0c02
1921	70	Tecnologias africanas e educação_cad.7.pdf	\N	0	\N	-1	7e55a9ff-7590-4b90-87ea-06b90c938f18
1922	61	/dspace/upload/Tecnologias africanas e educação_cad.7.pdf	\N	0	\N	-1	7e55a9ff-7590-4b90-87ea-06b90c938f18
2091	24	IFBA, Diretoria de Políticas Afirmativas e Assuntos Estudantis. Quilombolas na Bahia, lutas e resistências. Texto de João Rodrigues Araújo Santana/DPAAE. Salvador: EDIFBA, 2023. 55 p. (Coleção Pedagógica do Programa Asé-Toré Formação em educação sobre Negras(os) e Povos Indígenas, Caderno 11).	pt_BR	0	\N	-1	121a4efd-d31c-4a8b-9d4c-f57c7f7d0c02
2092	26	978-65-88985-34-2	\N	0	\N	-1	121a4efd-d31c-4a8b-9d4c-f57c7f7d0c02
1275	70	Historia e cultura dos povos indigenas na Bahia e no Brasil , cad 4.pdf	\N	0	\N	-1	a0c4b57b-cb3d-4ad1-9dc2-42eccc20a656
1276	61	/dspace/upload/Historia e cultura dos povos indigenas na Bahia e no Brasil , cad 4.pdf	\N	0	\N	-1	a0c4b57b-cb3d-4ad1-9dc2-42eccc20a656
1277	32	Livro	\N	0	\N	-1	a0c4b57b-cb3d-4ad1-9dc2-42eccc20a656
2078	70	license.txt	\N	0	\N	-1	ada7ba6e-80fa-483d-b889-0d18aa72c26d
2079	61	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	ada7ba6e-80fa-483d-b889-0d18aa72c26d
2080	70	Quilombolas na Bahia, lutas e resistencias. Cad11.pdf	\N	0	\N	-1	c7fbb171-128e-4d32-989f-f60e9aa4c3a2
2093	31	http://www.asetore.ifba.edu.br:8080/jspui/handle/123456789/96	\N	0	\N	-1	121a4efd-d31c-4a8b-9d4c-f57c7f7d0c02
2094	44	pt_BR	pt_BR	0	\N	-1	121a4efd-d31c-4a8b-9d4c-f57c7f7d0c02
2095	45	EDIFBA	pt_BR	0	\N	-1	121a4efd-d31c-4a8b-9d4c-f57c7f7d0c02
2096	49	Coleção Pedagógica do Programa Asé Toré Formação em educação sobre negras(os) e povos indígenas;caderno 11	\N	0	\N	-1	121a4efd-d31c-4a8b-9d4c-f57c7f7d0c02
2097	63	África	pt_BR	0	\N	-1	121a4efd-d31c-4a8b-9d4c-f57c7f7d0c02
2098	63	História	pt_BR	1	\N	-1	121a4efd-d31c-4a8b-9d4c-f57c7f7d0c02
2099	63	Quilombolas	pt_BR	2	\N	-1	121a4efd-d31c-4a8b-9d4c-f57c7f7d0c02
2100	63	Bahia	pt_BR	3	\N	-1	121a4efd-d31c-4a8b-9d4c-f57c7f7d0c02
2101	63	Resistência	pt_BR	4	\N	-1	121a4efd-d31c-4a8b-9d4c-f57c7f7d0c02
2103	72	Livro	pt_BR	0	\N	-1	121a4efd-d31c-4a8b-9d4c-f57c7f7d0c02
1812	1	LEILA	\N	0	\N	-1	e4ab47bd-5177-4189-9ab3-f172d9f9138d
1813	2	ASSIS DE JESUS	\N	0	\N	-1	e4ab47bd-5177-4189-9ab3-f172d9f9138d
1814	3	(71) 99613 6364	\N	0	\N	-1	e4ab47bd-5177-4189-9ab3-f172d9f9138d
1815	4	pt_BR	\N	0	\N	-1	e4ab47bd-5177-4189-9ab3-f172d9f9138d
1410	70	ORIGINAL	\N	1	\N	-1	9ac5b3f1-5be2-4f9f-a995-846b11e10e1e
1832	1	Maria Cristina	\N	0	\N	-1	45412fcf-9014-437f-ad54-b37cb064b31b
1833	2	Prates	\N	0	\N	-1	45412fcf-9014-437f-ad54-b37cb064b31b
1834	3	21969114203	\N	0	\N	-1	45412fcf-9014-437f-ad54-b37cb064b31b
1835	4	pt_BR	\N	0	\N	-1	45412fcf-9014-437f-ad54-b37cb064b31b
1863	4	pt_BR	\N	0	\N	-1	f3a701de-a6e6-467a-be2a-1b9feb40e489
1864	1	Elivanete	\N	0	\N	-1	a768060f-d660-4395-8dca-a8c4c8f1d685
1865	2	Macêdo	\N	0	\N	-1	a768060f-d660-4395-8dca-a8c4c8f1d685
1866	3	71-30360-366 ou 71 99271-8429	\N	0	\N	-1	a768060f-d660-4395-8dca-a8c4c8f1d685
1867	4	pt_BR	\N	0	\N	-1	a768060f-d660-4395-8dca-a8c4c8f1d685
1935	9	Gomes Júnior, Jorge Luiz	\N	1	\N	-1	c37aadfa-226f-4828-98bc-014c4e31d705
1684	70	ORIGINAL	\N	1	\N	-1	efe24c20-53cd-4a4f-8f72-d599f8df7e1a
1873	9	IFBA, Diretoria de Políticas Afirmativas e Assuntos Estudantis	\N	0	\N	-1	14875a45-2776-47af-b999-0ad20f1b7ff9
1874	9	Cordeiro, Paula Regina de Oliveira	\N	1	\N	-1	14875a45-2776-47af-b999-0ad20f1b7ff9
1875	70	Geografia da Àfrica e de seus descendentes no Brasil	pt_BR	0	\N	-1	14875a45-2776-47af-b999-0ad20f1b7ff9
1936	70	Culturas africanas e afro-brasileiras	pt_BR	0	\N	-1	c37aadfa-226f-4828-98bc-014c4e31d705
1877	45	EDIFBA	pt_BR	0	\N	-1	14875a45-2776-47af-b999-0ad20f1b7ff9
1878	24	IFBA,Diretoria de Políticas Afirmativas e Assuntos estudantis. Geografia da àfrica e de seus descendentes no Brasil.Texto de Paula Regina de Oliveira Cordeiro/DPAAE. Salvador: EDIFBA, 2023. 66 p.	pt_BR	0	\N	-1	14875a45-2776-47af-b999-0ad20f1b7ff9
1879	49	Coleção Pedagógica do Programa Asé-Toré: Formação em educação sobre negras(os) e Povos indígenas;6	\N	0	\N	-1	14875a45-2776-47af-b999-0ad20f1b7ff9
1880	26	978-65-88985-31-1	\N	0	\N	-1	14875a45-2776-47af-b999-0ad20f1b7ff9
1881	72	Livro	pt_BR	0	\N	-1	14875a45-2776-47af-b999-0ad20f1b7ff9
1882	44	pt_BR	pt_BR	0	\N	-1	14875a45-2776-47af-b999-0ad20f1b7ff9
1938	45	EDIFBA	pt_BR	0	\N	-1	c37aadfa-226f-4828-98bc-014c4e31d705
1923	32	Livro	\N	0	\N	-1	7e55a9ff-7590-4b90-87ea-06b90c938f18
1924	70	LICENSE	\N	1	\N	-1	9e7d3c2a-c897-4e5c-98d9-1751e8e50f47
1939	24	IFBA,Diretoria de Políticas Afirmativas e Assuntos estudantis. Culturas africanas e afro-brasileiras. Texto de Jorge Luiz Gomes Júnior/DPAAE. Salvador: EDIFBA, 2023. 59 p.	pt_BR	0	\N	-1	c37aadfa-226f-4828-98bc-014c4e31d705
1940	49	Coleção Pedagógica do Programa Asé-Toré: Formação em educação sobre negras(os) e Povos indígenas;10	\N	0	\N	-1	c37aadfa-226f-4828-98bc-014c4e31d705
1925	70	license.txt	\N	0	\N	-1	2460d158-bd7a-47c3-a3a6-fb74f16068a5
1926	61	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	2460d158-bd7a-47c3-a3a6-fb74f16068a5
1927	34	Submitted by Andreia Ribeiro (andreiasr@ifba.edu.br) on 2023-11-01T14:14:46Z\nNo. of bitstreams: 1\nTecnologias africanas e educação_cad.7.pdf: 12958783 bytes, checksum: f9b5c6896f86fa89043078106d8b6d7e (MD5)	en	0	\N	-1	454cf684-62f8-4b49-bfc5-b343499cf735
1928	31	http://www.asetore.ifba.edu.br:8080/jspui/handle/123456789/94	\N	0	\N	-1	454cf684-62f8-4b49-bfc5-b343499cf735
1941	26	978-65-88985-33-5	\N	0	\N	-1	c37aadfa-226f-4828-98bc-014c4e31d705
1942	72	Livro	pt_BR	0	\N	-1	c37aadfa-226f-4828-98bc-014c4e31d705
1943	44	pt_BR	pt_BR	0	\N	-1	c37aadfa-226f-4828-98bc-014c4e31d705
1932	34	Made available in DSpace on 2023-11-01T14:14:46Z (GMT). No. of bitstreams: 1\nTecnologias africanas e educação_cad.7.pdf: 12958783 bytes, checksum: f9b5c6896f86fa89043078106d8b6d7e (MD5)\n  Previous issue date: 2023-10-30	en	1	\N	-1	454cf684-62f8-4b49-bfc5-b343499cf735
1929	17	2023-11-01T14:14:46Z	\N	0	\N	-1	454cf684-62f8-4b49-bfc5-b343499cf735
1930	18	2023-11-01T14:14:46Z	\N	0	\N	-1	454cf684-62f8-4b49-bfc5-b343499cf735
1931	21	2023-10-30	\N	0	\N	-1	454cf684-62f8-4b49-bfc5-b343499cf735
1947	70	ORIGINAL	\N	1	\N	-1	d836e6c1-1fc3-4658-af3a-8d368eb81fa3
1934	9	IFBA, Diretoria de Políticas Afirmativas e Assuntos Estudantis	\N	0	\N	-1	c37aadfa-226f-4828-98bc-014c4e31d705
1944	63	África - História	pt_BR	0	\N	-1	c37aadfa-226f-4828-98bc-014c4e31d705
1945	63	História - Cultura	pt_BR	1	\N	-1	c37aadfa-226f-4828-98bc-014c4e31d705
1946	33	O Instituto Federal de Educação, Ciência e Tecnologia da Bahia tem a honra de apresentar a Coleção Pedagógica do Programa Asé-Toré: Formação em Educação sobre negras(os) e povos indígenas, produto de um dos Programas de educação para relações étnico-raciais desenvolvido pela Diretoria Sistêmica de Políticas Afirmativas e Assuntos Estudantis – DPAAE/IFBA.\r\nEstamos felizes em materializar esta coleção, que marca o compromisso da nossa instituição em validar\r\na legislação nacional que trata da obrigatoriedade de educar sobre História da África, afro-brasileira e\r\nindígena, identificando-a como conquista dos movimentos sociais, negros e indígenas brasileiros. Assim,\r\nreconhecemos as lutas de quem veio antes, agradecemos às/aos servidoras/es, gestoras/es e estudantes\r\nque bravamente promovem o debate racial no IFBA e fortalecemos esforços em prol de uma educação\r\nantirracista.\r\nA Coleção Pedagógica Asé-Toré representa um marco na institucionalidade de ações que contribuem\r\npara que o IFBA solidifique sua missão institucional: “Promover a formação do cidadão histórico-crítico,\r\noferecendo ensino, pesquisa e extensão com qualidade socialmente referenciada, objetivando o desenvolvimento sustentável do país”. Além disso, a Coleção inaugura novas estratégias institucionais e interdisciplinares, ao desenvolver um produto didático e acessível a todos os níveis, formas e modalidades de ensino que ofertamos.\r\nDesejo boa leitura e estudos. Que a Coleção Pedagógica Asé-Toré alcance a comunidade do IFBA e, também, as famílias dos nossos estudantes, organizações sociais e instituições de ensino do nosso Estado e país.\r\nPROFESSORA DRA. LUZIA MATOS MOTA\r\nREITORA DO IFBA	pt_BR	0	\N	-1	c37aadfa-226f-4828-98bc-014c4e31d705
1950	32	Livro	\N	0	\N	-1	64fe4985-27fe-4f22-8639-86bc96f20fb4
1948	70	Culturas africanas e afro-brasileiras_cad.10.pdf	\N	0	\N	-1	64fe4985-27fe-4f22-8639-86bc96f20fb4
1949	61	/dspace/upload/Culturas africanas e afro-brasileiras_cad.10.pdf	\N	0	\N	-1	64fe4985-27fe-4f22-8639-86bc96f20fb4
1951	70	LICENSE	\N	1	\N	-1	047efc13-5570-4018-a045-52dcc92d44da
1952	70	license.txt	\N	0	\N	-1	f1370e88-0940-4e2f-9e70-15d072d03075
1953	61	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	f1370e88-0940-4e2f-9e70-15d072d03075
1954	34	Submitted by Andreia Ribeiro (andreiasr@ifba.edu.br) on 2023-11-01T14:23:20Z\nNo. of bitstreams: 1\nCulturas africanas e afro-brasileiras_cad.10.pdf: 7707788 bytes, checksum: d8bb8174bf7c9b1b7df92c79b60d2fc7 (MD5)	en	0	\N	-1	c37aadfa-226f-4828-98bc-014c4e31d705
1727	32	O Instituto Federal de Educação, Ciência e Tecnologia\r\nda Bahia tem a honra de apresentar a Coleção Pedagógica do Programa Asé-Toré: Formação em Educação\r\nsobre negras(os) e povos indígenas, produto de um dos\r\nProgramas de educação para relações étnico-raciais\r\ndesenvolvido pela Diretoria Sistêmica de Políticas Afirmativas e Assuntos Estudantis – DPAAE/IFBA.\r\nEstamos felizes em materializar esta coleção, que\r\nmarca o compromisso da nossa instituição em validar\r\na legislação nacional que trata da obrigatoriedade\r\nde educar sobre História da África, afro-brasileira e\r\nindígena, identificando-a como conquista dos movimentos sociais, negros e indígenas brasileiros. Assim,\r\nreconhecemos as lutas de quem veio antes, agradecemos às/aos servidoras/es, gestoras/es e estudantes\r\nque bravamente promovem o debate racial no IFBA\r\ne fortalecemos esforços em prol de uma educação\r\nantirracista.\r\nPREFÁCIO\r\nA Coleção Pedagógica Asé-Toré representa um marco na institucionalidade de ações que contribuem\r\npara que o IFBA solidifique sua missão institucional:\r\n“Promover a formação do cidadão histórico-crítico,\r\noferecendo ensino, pesquisa e extensão com qualidade socialmente referenciada, objetivando o desenvolvimento sustentável do país”. Além disso, a Coleção\r\ninaugura novas estratégias institucionais e interdisciplinares, ao desenvolver um produto didático e acessível a todos os níveis, formas e modalidades de ensino\r\nque ofertamos.\r\nDesejo boa leitura e estudos. Que a Coleção Pedagógica Asé-Toré alcance a comunidade do IFBA e, também, as famílias dos nossos estudantes, organizações\r\nsociais e instituições de ensino do nosso Estado e país.\r\nPROFESSORA DRA. LUZIA MATOS MOTA\r\nREITORA DO IFBA	pt_BR	0	\N	-1	66bb3a28-09f6-4ced-8423-57b3d96b060f
1728	33	“Asé-Toré”, junção das palavras “Asé” (na língua\r\niorubá, significa poder, energia ou força presente\r\nem cada ser ou em cada coisa, que nas religiões afro\r\n-\r\n-brasileiras representa a energia sagrada dos orixás)\r\ne “Toré” (expressão espiritual-religiosa de grande\r\nimportância para os indígenas), significa para nós o\r\nresgate da força coletiva e energia vital da ancestra\r\n-\r\nlidade para vencer os desafios contemporâneos do\r\npovo negro e indígena.\r\nÉ com este nome repleto de significados e potências\r\nque a Diretoria Sistêmica de Políticas Afirmativas e\r\nAssuntos Estudantis – DPAAE/IFBA apresenta à co\r\n-\r\nmunidade interna e externa do Instituto Federal de\r\nEducação, Ciência e Tecnologia da Bahia (IFBA) esta\r\nColeção Pedagógica, um dos produtos do “Programa\r\nAsé-Toré: Formação em educação sobre negras(os)\r\ne povos indígenas do Instituto Federal de Educação,\r\nCiência e Tecnologia (IFBA), voltado à formação de\r\ngestoras(es), professoras(es), técnicas(os) administra\r\n-\r\ntivas(os), estudantes e comunidade na área da Educa\r\n-\r\nção das Relações Étnico-Raciais e ao enfrentamento\r\nao racismo no âmbito do IFBA.\r\nO Programa Asé-Toré foi institucionalizado por meio\r\nde Chamada Pública do IFBA/DPAAE, que possibilitou\r\na contratação de duas Coordenadoras (Coordenadora\r\nGeral e Coordenadora dos Cadernos Temáticos); 15\r\nbolsistas “professores conteudistas”; cinco bolsistas\r\n“professores pareceristas”; dois apoios administrati\r\n-\r\nvos pedagógicos e uma ilustradora para a produção\r\ndos Cadernos Temáticos. Envolveu, ainda, mais de dez\r\npesquisadoras(es) para o Conselho Editorial e diver\r\n-\r\nsas(os) servidoras(es) internos e externos do IFBA que\r\ncontribuíram na seleção dos bolsistas.\r\nA DPAAE é uma Diretoria recente na história do IFBA,\r\nsendo criada em 2020. Desta forma, a entrega à so\r\n-\r\nciedade da Coleção Pedagógica Asé-Toré se torna um\r\nmarco importante no cumprimento às normativas\r\nque tratam da educação das relações étnico-raciais o\r\nqual foi também missão da Diretoria. A Coleção tem\r\no objetivo de promover a Educação das Relações Ét\r\n-\r\nnico-raciais, cumprindo a Lei de Diretrizes e Base da\r\nEducação Nacional – LDB, especialmente no que con\r\n-\r\ncerne à implantação das Leis Federais nº 10.639/03\r\ne nº 11.645/08, as quais afirmam a obrigatoriedade\r\ndo estudo da “História da África e dos africanos”, da\r\n“luta dos negros e dos povos indígenas no Brasil”, da\r\n“cultura negra e indígena brasileira” e “o negro e o\r\níndio na formação da sociedade nacional”, “resgatan\r\n-\r\ndo as suas contribuições nas áreas social, econômica\r\ne política, pertinentes à história do Brasil.” (BRASIL,\r\n2008). Do mesmo modo, considerou-se as Diretrizes\r\n10\r\nCurriculares Nacionais para a Educação das Relações\r\nÉtnico-Raciais e para o Ensino de História e Cultura\r\nAfro-Brasileira e Africana, passando, ainda, por outras\r\nnormativas do estado da Bahia.\r\nComposta por 15 cadernos temáticos, a Coleção Pedagógica Asé-Toré cumpre esforços institucionais de\r\ncontribuir com a formulação de um material didático, fundamentado numa perspectiva de valorização\r\nda educação das relações étnico-raciais, da diversidade étnico-racial na educação, no enfrentamento\r\nao racismo institucional, na valorização das ações\r\nafirmativas para a população negra e povos indígenas. Representa, ademais, contribuições coletivas de\r\nprofissionais, pesquisadoras/intelectuais ativistas\r\nou não, em sua maioria negros e mulheres, sendo\r\ndestacada a participação de dois indígenas. Estas(es)\r\npesquisadoras(es) se dedicaram a uma metodologia\r\ninovadora de trabalho baseada em aspectos da cosmovisão de mundo africana e indígena, enfatizando\r\no trabalho coletivo, valorizando as lutas sociais, a\r\nprodução de autoras(es) negras(os) e indígenas e\r\nconsiderando suas vivências e experiências na forma\r\ne formato dos conteúdos e imagens.\r\nO Programa Asé-Toré nasceu a partir de um projeto\r\nmais amplo de implementação da Lei 10.639/03,\r\noriginalmente escrito por mim, Marcilene Garcia de\r\nSouza, e pelo professor Dr. Hélio Santos, em 2017.\r\nAqui no IFBA (DPAAE), o Programa se apresentou\r\nde forma mais sintetizada em que se destacam três\r\nprodutos: Produção dos 15 Cadernos Temáticos; Institucionalização de uma biblioteca virtual temática e\r\numa série de formações sobre educação das relações\r\nétnico-raciais.\r\nFaz-se necessário registrar o empenho da gestão\r\ndo IFBA para a realização do Programa Asé-Toré, na\r\npessoa da Reitora Profa. Dra. Luzia Matos Mota, que\r\né mulher negra, e na do Pró-Reitor de Ensino, Prof.\r\nDr. Jancarlos Lapa, mas também da Equipe gestora da DPAAE que contribui de forma mais direta na\r\nexecução do Programa: Profa. Mestra Thelma Ramos\r\n(Chefe da Coordenação Indígena e Povos Tradicionais\r\n– CIND/DPAF/DPAAE), a pedagoga Jacineide Arão\r\ndos Santos Profeta (Chefe do Departamento de Políticas Afirmativas – DPAF/DPAAE) e a assistente social\r\nCacilda Ferreira dos Reis (Chefe do Departamento de\r\nAssuntos Estudantis – DAES/DPAAE).\r\n\r\nPROFª. DRA. MARCILENE GARCIA DE SOUZA\r\nDIRETORA SISTÊMICA DE POLÍTICAS AFIRMATIVAS\r\nE ASSUNTOS ESTUDANTIS DO IFBA	pt_BR	0	\N	-1	66bb3a28-09f6-4ced-8423-57b3d96b060f
1729	34	Submitted by Andreia Ribeiro (andreiasr@ifba.edu.br) on 2023-08-14T16:23:28Z\r\nNo. of bitstreams: 1\r\nMovimentos negros contemporâneos e movimentos sociais Indígenas.pdf: 13182359 bytes, checksum: 128341e7d22222dc276be099616155e3 (MD5)	en	0	\N	-1	66bb3a28-09f6-4ced-8423-57b3d96b060f
1730	34	Made available in DSpace on 2023-08-14T16:23:29Z (GMT). No. of bitstreams: 1\r\nMovimentos negros contemporâneos e movimentos sociais Indígenas.pdf: 13182359 bytes, checksum: 128341e7d22222dc276be099616155e3 (MD5)\r\n  Previous issue date: 2023-10-14	en	1	\N	-1	66bb3a28-09f6-4ced-8423-57b3d96b060f
1731	24	IFBA, Diretoria de Políticas Afirmativas e Assuntos Estudantis. Movimentos negros contemporâneos e movimentos sociais Indígenas. Texto de Danielle Ferreira Medeiros da Silva de Araújo/DPAAE. Salvador: EDIFBA, 2023. 65 p. (Coleção Pedagógica do Programa Asé-Toré Formação em educação sobre Negras(os) e Povos Indígenas, Caderno 15).	pt_BR	0	\N	-1	66bb3a28-09f6-4ced-8423-57b3d96b060f
1732	26	978-65-88985-28-1	\N	0	\N	-1	66bb3a28-09f6-4ced-8423-57b3d96b060f
1733	31	http://www.asetore.ifba.edu.br:8080/jspui/handle/123456789/71	\N	0	\N	-1	66bb3a28-09f6-4ced-8423-57b3d96b060f
1816	1	Carla	\N	0	\N	-1	02241eb2-f506-4840-b663-d32b85822fec
1817	2	Souza	\N	0	\N	-1	02241eb2-f506-4840-b663-d32b85822fec
1818	3	71991643225	\N	0	\N	-1	02241eb2-f506-4840-b663-d32b85822fec
1819	4	pt_BR	\N	0	\N	-1	02241eb2-f506-4840-b663-d32b85822fec
1885	63	Geografia	pt_BR	0	\N	-1	14875a45-2776-47af-b999-0ad20f1b7ff9
1886	63	África	pt_BR	1	\N	-1	14875a45-2776-47af-b999-0ad20f1b7ff9
1887	63	História-Cultura	pt_BR	2	\N	-1	14875a45-2776-47af-b999-0ad20f1b7ff9
1888	63	Brasil	pt_BR	3	\N	-1	14875a45-2776-47af-b999-0ad20f1b7ff9
1889	33	O Instituto Federal de Educação, Ciência e Tecnologia da Bahia tem a honra de apresentar a Coleção Pedagógica do Programa Asé-Toré: Formação em Educação sobre negras(os) e povos indígenas, produto de um dos Programas de educação para relações étnico-raciais desenvolvido pela Diretoria Sistêmica de Políticas Afirmativas e Assuntos Estudantis – DPAAE/IFBA.\r\nEstamos felizes em materializar esta coleção, que marca o compromisso da nossa instituição em validar\r\na legislação nacional que trata da obrigatoriedade de educar sobre História da África, afro-brasileira e\r\nindígena, identificando-a como conquista dos movimentos sociais, negros e indígenas brasileiros. Assim,\r\nreconhecemos as lutas de quem veio antes, agradecemos às/aos servidoras/es, gestoras/es e estudantes\r\nque bravamente promovem o debate racial no IFBA e fortalecemos esforços em prol de uma educação\r\nantirracista.\r\nA Coleção Pedagógica Asé-Toré representa um marco na institucionalidade de ações que contribuem\r\npara que o IFBA solidifique sua missão institucional: “Promover a formação do cidadão histórico-crítico,\r\noferecendo ensino, pesquisa e extensão com qualidade socialmente referenciada, objetivando o desenvolvimento sustentável do país”. Além disso, a Coleção inaugura novas estratégias institucionais e interdisciplinares, ao desenvolver um produto didático e acessível a todos os níveis, formas e modalidades de ensino  que ofertamos.\r\nDesejo boa leitura e estudos. Que a Coleção Pedagógica Asé-Toré alcance a comunidade do IFBA e, também, as famílias dos nossos estudantes, organizações sociais e instituições de ensino do nosso Estado e país.\r\nPROFESSORA DRA. LUZIA MATOS MOTA\r\nREITORA DO IFBA	pt_BR	0	\N	-1	14875a45-2776-47af-b999-0ad20f1b7ff9
1890	70	ORIGINAL	\N	1	\N	-1	62807404-015a-42e4-bc1e-bdeb2501f94e
1895	70	license.txt	\N	0	\N	-1	b67582cb-62e9-43df-90b5-ce80eec4b405
1891	70	Geografia da africa e dos seus descendentes cad.6.pdf	\N	0	\N	-1	85b1a7ac-ea04-472b-8b18-e5aec342eaea
1892	61	/dspace/upload/Geografia da africa e dos seus descendentes cad.6.pdf	\N	0	\N	-1	85b1a7ac-ea04-472b-8b18-e5aec342eaea
1893	32	Livro	\N	0	\N	-1	85b1a7ac-ea04-472b-8b18-e5aec342eaea
1894	70	LICENSE	\N	1	\N	-1	880da050-40ba-4eaf-a68c-edada75594a9
1896	61	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	b67582cb-62e9-43df-90b5-ce80eec4b405
1897	34	Submitted by Andreia Ribeiro (andreiasr@ifba.edu.br) on 2023-11-01T14:06:05Z\nNo. of bitstreams: 1\nGeografia da africa e dos seus descendentes cad.6.pdf: 15736243 bytes, checksum: bf93375e5d5f80c73ed6800d96dceb6f (MD5)	en	0	\N	-1	14875a45-2776-47af-b999-0ad20f1b7ff9
1898	31	http://www.asetore.ifba.edu.br:8080/jspui/handle/123456789/93	\N	0	\N	-1	14875a45-2776-47af-b999-0ad20f1b7ff9
1902	34	Made available in DSpace on 2023-11-01T14:06:05Z (GMT). No. of bitstreams: 1\nGeografia da africa e dos seus descendentes cad.6.pdf: 15736243 bytes, checksum: bf93375e5d5f80c73ed6800d96dceb6f (MD5)\n  Previous issue date: 2023-10-30	en	1	\N	-1	14875a45-2776-47af-b999-0ad20f1b7ff9
1899	17	2023-11-01T14:06:05Z	\N	0	\N	-1	14875a45-2776-47af-b999-0ad20f1b7ff9
1900	18	2023-11-01T14:06:05Z	\N	0	\N	-1	14875a45-2776-47af-b999-0ad20f1b7ff9
1980	70	ORIGINAL	\N	1	\N	-1	4b984d79-4db8-4fb5-a070-a18248c660ff
2006	26	978-65-88985-39-7	\N	0	\N	-1	f337e86e-7ee2-466c-841c-13b345ec5676
2007	72	Livro	pt_BR	0	\N	-1	f337e86e-7ee2-466c-841c-13b345ec5676
1984	70	LICENSE	\N	1	\N	-1	1d9e8682-269c-4484-ad0c-423f98fed95c
2008	44	pt_BR	pt_BR	0	\N	-1	f337e86e-7ee2-466c-841c-13b345ec5676
1998	9	IFBA, Diretoria de Políticas Afirmativas e assuntos Estudantis	\N	0	\N	-1	f337e86e-7ee2-466c-841c-13b345ec5676
1999	9	Martins, Patricia	\N	1	\N	-1	f337e86e-7ee2-466c-841c-13b345ec5676
2000	9	Alves, Luciana	\N	2	\N	-1	f337e86e-7ee2-466c-841c-13b345ec5676
2001	70	Identidade da população negra no Brasil	pt_BR	0	\N	-1	f337e86e-7ee2-466c-841c-13b345ec5676
2003	45	EDIFBA	pt_BR	0	\N	-1	f337e86e-7ee2-466c-841c-13b345ec5676
2004	24	IFBA, Diretoria de Políticas Afirmativas e Assuntos Estudantis. Identidade da população negra no Brasil. Texto de Patricia Martins; Luciana Alves /DPAAE. Salvador: EDIFBA, 2023. 57 p. (Coleção Pedagógica do Programa Asé-Toré Formação em educação sobre Negras(os) e Povos Indígenas, Caderno 12).	pt_BR	0	\N	-1	f337e86e-7ee2-466c-841c-13b345ec5676
2005	49	Coleção Pedagógica do Programa Asé Toré Formação em educação sobre negras(os) e povos indígenas;caderno 12	\N	0	\N	-1	f337e86e-7ee2-466c-841c-13b345ec5676
2013	33	O Instituto Federal de Educação, Ciência e Tecnologia da Bahia tem a honra de apresentar a Coleção Pedagógica do Programa Asé-Toré: Formação em Educação sobre negras(os) e povos indígenas, produto de um dos Programas de educação para relações étnico-raciais desenvolvido pela Diretoria Sistêmica de Políticas Afirmativas e Assuntos Estudantis – DPAAE/IFBA.\r\nEstamos felizes em materializar esta coleção, que marca o compromisso da nossa instituição em validar\r\na legislação nacional que trata da obrigatoriedade de educar sobre História da África, afro-brasileira e\r\nindígena, identificando-a como conquista dos movimentos sociais, negros e indígenas brasileiros. Assim,\r\nreconhecemos as lutas de quem veio antes, agradecemos às/aos servidoras/es, gestoras/es e estudantes\r\nque bravamente promovem o debate racial no IFBA e fortalecemos esforços em prol de uma educação\r\nantirracista.\r\nA Coleção Pedagógica Asé-Toré representa um marco na institucionalidade de ações que contribuem\r\npara que o IFBA solidifique sua missão institucional: “Promover a formação do cidadão histórico-crítico,\r\noferecendo ensino, pesquisa e extensão com qualidade socialmente referenciada, objetivando o desenvolvimento sustentável do país”. Além disso, a Coleção inaugura novas estratégias institucionais e interdisciplinares, ao desenvolver um produto didático e acessível a todos os níveis, formas e modalidades de ensino que ofertamos.\r\nDesejo boa leitura e estudos. Que a Coleção Pedagógica Asé-Toré alcance a comunidade do IFBA e, também, as famílias dos nossos estudantes, organizações sociais e instituições de ensino do nosso Estado e país.\r\nPROFESSORA DRA. LUZIA MATOS MOTA\r\nREITORA DO IFBA	pt_BR	0	\N	-1	f337e86e-7ee2-466c-841c-13b345ec5676
2014	70	ORIGINAL	\N	1	\N	-1	6b8fb088-d396-4c9d-bd8b-94e2f38ec447
2015	70	Identidade da população negra no Brasil, cad.12.pdf	\N	0	\N	-1	244b6155-22e3-4579-b2f0-f4e1b459e62a
2016	61	/dspace/upload/Identidade da população negra no Brasil, cad.12.pdf	\N	0	\N	-1	244b6155-22e3-4579-b2f0-f4e1b459e62a
2017	32	Livro	\N	0	\N	-1	244b6155-22e3-4579-b2f0-f4e1b459e62a
2018	70	LICENSE	\N	1	\N	-1	aaf93d7b-4387-450c-9b08-0da85be3df6a
2019	70	license.txt	\N	0	\N	-1	55793605-81eb-4525-be84-bb56dedb1703
2020	61	Written by org.dspace.content.LicenseUtils	\N	0	\N	-1	55793605-81eb-4525-be84-bb56dedb1703
2021	34	Submitted by Andreia Ribeiro (andreiasr@ifba.edu.br) on 2023-11-06T13:38:24Z\nNo. of bitstreams: 1\nIdentidade da população negra no Brasil, cad.12.pdf: 11494250 bytes, checksum: 2a2ace89841c880ea677d852a7931217 (MD5)	en	0	\N	-1	f337e86e-7ee2-466c-841c-13b345ec5676
2022	31	http://www.asetore.ifba.edu.br:8080/jspui/handle/123456789/97	\N	0	\N	-1	f337e86e-7ee2-466c-841c-13b345ec5676
2026	34	Made available in DSpace on 2023-11-06T13:38:24Z (GMT). No. of bitstreams: 1\nIdentidade da população negra no Brasil, cad.12.pdf: 11494250 bytes, checksum: 2a2ace89841c880ea677d852a7931217 (MD5)\n  Previous issue date: 2023-10-30	en	1	\N	-1	f337e86e-7ee2-466c-841c-13b345ec5676
2023	17	2023-11-06T13:38:24Z	\N	0	\N	-1	f337e86e-7ee2-466c-841c-13b345ec5676
2024	18	2023-11-06T13:38:24Z	\N	0	\N	-1	f337e86e-7ee2-466c-841c-13b345ec5676
2025	21	2023-10-30	\N	0	\N	-1	f337e86e-7ee2-466c-841c-13b345ec5676
2081	61	/dspace/upload/Quilombolas na Bahia, lutas e resistencias. Cad11.pdf	\N	0	\N	-1	c7fbb171-128e-4d32-989f-f60e9aa4c3a2
2082	32	Livro	\N	0	\N	-1	c7fbb171-128e-4d32-989f-f60e9aa4c3a2
2083	9	IFBA. Diretoria de Políticas Afirmativas e Assuntos Estudantis	pt_BR	0	\N	-1	121a4efd-d31c-4a8b-9d4c-f57c7f7d0c02
2084	9	Santana, João Rodrigo Araújo	pt_BR	1	\N	-1	121a4efd-d31c-4a8b-9d4c-f57c7f7d0c02
2085	17	2023-11-06T13:32:14Z	\N	0	\N	-1	121a4efd-d31c-4a8b-9d4c-f57c7f7d0c02
2086	18	2023-11-06T13:32:14Z	\N	0	\N	-1	121a4efd-d31c-4a8b-9d4c-f57c7f7d0c02
2087	21	2023-10-30	\N	0	\N	-1	121a4efd-d31c-4a8b-9d4c-f57c7f7d0c02
2088	33	O Instituto Federal de Educação, Ciência e Tecnologia da Bahia tem a honra de apresentar a Coleção Pedagógica do Programa Asé-Toré: Formação em Educação sobre negras(os) e povos indígenas, produto de um dos Programas de educação para relações étnico-raciais desenvolvido pela Diretoria Sistêmica de Políticas Afirmativas e Assuntos Estudantis – DPAAE/IFBA.\r\nEstamos felizes em materializar esta coleção, que marca o compromisso da nossa instituição em validar\r\na legislação nacional que trata da obrigatoriedade de educar sobre História da África, afro-brasileira e\r\nindígena, identificando-a como conquista dos movimentos sociais, negros e indígenas brasileiros. Assim,\r\nreconhecemos as lutas de quem veio antes, agradecemos às/aos servidoras/es, gestoras/es e estudantes\r\nque bravamente promovem o debate racial no IFBA e fortalecemos esforços em prol de uma educação\r\nantirracista.\r\nA Coleção Pedagógica Asé-Toré representa um marco na institucionalidade de ações que contribuem\r\npara que o IFBA solidifique sua missão institucional: “Promover a formação do cidadão histórico-crítico,\r\noferecendo ensino, pesquisa e extensão com qualidade socialmente referenciada, objetivando o desenvolvimento sustentável do país”. Além disso, a Coleção inaugura novas estratégias institucionais e interdisciplinares, ao desenvolver um produto didático e acessível a todos os níveis, formas e modalidades de ensino que ofertamos.\r\nDesejo boa leitura e estudos. Que a Coleção Pedagógica Asé-Toré alcance a comunidade do IFBA e, também, as famílias dos nossos estudantes, organizações sociais e instituições de ensino do nosso Estado e país.\r\nPROFESSORA DRA. LUZIA MATOS MOTA\r\nREITORA DO IFBA	pt_BR	0	\N	-1	121a4efd-d31c-4a8b-9d4c-f57c7f7d0c02
2102	70	Quilombolas na Bahia, lutas e resistências	pt_BR	0	\N	-1	121a4efd-d31c-4a8b-9d4c-f57c7f7d0c02
\.


--
-- Data for Name: most_recent_checksum; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.most_recent_checksum (to_be_processed, expected_checksum, current_checksum, last_process_start_date, last_process_end_date, checksum_algorithm, matched_prev_checksum, result, bitstream_id) FROM stdin;
\.


--
-- Data for Name: registrationdata; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.registrationdata (registrationdata_id, email, token, expires) FROM stdin;
10	luismigueldejesusaraujo@gmail.com	8bd73368aaa5e0c289c7eb40140c3809	\N
11	grazeferreira@gmail.com	cf040801c5fba81d247bf3c3e0950be1	\N
12	graziela@ifba.edu.br	a9e4b2a8e02072bf222e861979e3cf0f	\N
19		b0e280cb8b43ae3390a552c5cbdae6ca	\N
20	drikasferraz2@hotmail.com	008ab47e501afaa6f2294348f836dd94	\N
22	jacksonoliveira.conceicao@gmail.com	55e5cae71da8216389625c551d6a78d3	\N
25	claudiammortari@gmail.com	0b3e3da2f116bef6dbe675e3848e2c1d	\N
28	mtmotokane@ffclrp.usp.br	d2accf4c7ac4e7626678ac66773f720c	\N
37	glaucia.fornazari@gmail.com	ae588ce180222ab70ced504037788f2e	\N
39	neto.manuelbatera@gmail.com	0bda1b435f50b1bc5372e05bf08b04b2	\N
41	nascimentoslaura@gmail.com	913aa65f2f702cf38abf17ecd5fba48c	\N
42	tlcramos.ifba@gmail.com	78f441932b150864426cb3f01eb62d30	\N
43	adilson.beloto@gmail.com	41937b810f0c73a68d55fd57894a69af	\N
\.


--
-- Data for Name: requestitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.requestitem (requestitem_id, token, allfiles, request_email, request_name, request_date, accept_request, decision_date, expires, request_message, item_id, bitstream_id) FROM stdin;
\.


--
-- Data for Name: resourcepolicy; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.resourcepolicy (policy_id, resource_type_id, resource_id, action_id, start_date, end_date, rpname, rptype, rpdescription, eperson_id, epersongroup_id, dspace_object) FROM stdin;
520	3	\N	0	\N	\N	\N	\N	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	e77edf9c-1dbb-4794-90d7-19b281d804b5
638	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	121a4efd-d31c-4a8b-9d4c-f57c7f7d0c02
521	3	\N	10	\N	\N	\N	\N	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	e77edf9c-1dbb-4794-90d7-19b281d804b5
522	3	\N	9	\N	\N	\N	\N	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	e77edf9c-1dbb-4794-90d7-19b281d804b5
467	0	\N	0	\N	\N	\N	\N	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	\N
352	0	\N	0	\N	\N	\N	\N	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	\N
353	0	\N	0	\N	\N	\N	\N	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	c54a90fa-33e6-4c0b-b3c5-39e52d0a6887
354	1	\N	0	\N	\N	\N	\N	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	2a464f3f-cc84-40cb-b21b-9892d70707ac
472	0	\N	0	\N	\N	\N	\N	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	\N
389	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	39926264-0a06-432f-bb03-18d391841d73
473	0	\N	0	\N	\N	\N	\N	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	80aeeef4-8b4a-44e5-a67b-60331f5e20c5
390	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	6c633236-b142-42a6-9bbc-421e3e921a75
69	0	\N	0	\N	\N	\N	\N	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	84d2756c-8775-4c78-bbc9-351601ea3744
70	0	\N	1	\N	\N	\N	\N	\N	24547e55-3d4e-46d6-b048-356f3557eaa1	\N	84d2756c-8775-4c78-bbc9-351601ea3744
71	4	\N	11	\N	\N	\N	\N	\N	\N	7ec4b858-93ae-459b-9993-09170e3ade08	d6941f14-9466-4dff-80d3-5e0809da53ce
474	1	\N	0	\N	\N	\N	\N	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	9ac5b3f1-5be2-4f9f-a995-846b11e10e1e
430	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	2a3f97a9-f475-4ef6-bbc3-c83e6f0cf28d
391	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	25d02dc5-8249-4146-a65a-1da2b0d306f9
392	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	67a933ee-2067-4da6-ae2b-2a0e5cf7e8ad
393	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	e518be93-fac4-433f-84c0-32533ec7b4ac
482	0	\N	0	\N	\N	\N	\N	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	\N
135	4	\N	1	\N	\N	\N	\N	\N	\N	f493e7ce-6f98-451f-8ca4-3ec03915c37f	d6941f14-9466-4dff-80d3-5e0809da53ce
578	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	454cf684-62f8-4b49-bfc5-b343499cf735
32	4	\N	0	\N	\N	\N	\N	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	d6941f14-9466-4dff-80d3-5e0809da53ce
579	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	b97b63ea-ce0a-4c12-9e6b-1a4b3bb3876e
580	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	7e55a9ff-7590-4b90-87ea-06b90c938f18
581	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	9e7d3c2a-c897-4e5c-98d9-1751e8e50f47
582	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	2460d158-bd7a-47c3-a3a6-fb74f16068a5
433	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	ff7d7cea-0e22-4c0a-8736-5c21a1cbe947
402	0	\N	0	\N	\N	\N	\N	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	\N
93	4	\N	11	\N	\N	\N	\N	\N	\N	f493e7ce-6f98-451f-8ca4-3ec03915c37f	d6941f14-9466-4dff-80d3-5e0809da53ce
434	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	6279e756-d48b-47ab-ab4a-7c263086ef91
639	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	4b984d79-4db8-4fb5-a070-a18248c660ff
640	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	c7fbb171-128e-4d32-989f-f60e9aa4c3a2
641	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	1d9e8682-269c-4484-ad0c-423f98fed95c
515	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	5f935f7b-468a-4bd3-a610-0dd1c9b9edc3
334	0	\N	0	\N	\N	\N	\N	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	8afdd918-d2e2-4888-aefc-9b94ce7a3aac
642	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	ada7ba6e-80fa-483d-b889-0d18aa72c26d
516	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	a46768eb-dec3-44f6-84bb-e1a1496c616f
148	3	\N	0	\N	\N	\N	\N	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	fb0a9847-448b-412a-b5fc-ca8dda1e957c
517	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	82c95a58-2f95-4e10-a39e-1fc04934dc2b
518	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	4def91f3-d15d-49b2-9fd8-2227cc555bf5
335	0	\N	1	\N	\N	\N	\N	\N	3c47b942-9ec4-4d9e-9f01-dd0990cf9baf	\N	8afdd918-d2e2-4888-aefc-9b94ce7a3aac
519	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	439c20e0-ca26-4687-899f-81ff3d3b8ff2
149	3	\N	10	\N	\N	\N	\N	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	fb0a9847-448b-412a-b5fc-ca8dda1e957c
150	3	\N	9	\N	\N	\N	\N	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	fb0a9847-448b-412a-b5fc-ca8dda1e957c
152	3	\N	11	\N	\N	\N	\N	\N	\N	f493e7ce-6f98-451f-8ca4-3ec03915c37f	fb0a9847-448b-412a-b5fc-ca8dda1e957c
157	3	\N	1	\N	\N	\N	\N	\N	\N	a54a9824-240d-42ed-9290-df0f5fd46e4c	fb0a9847-448b-412a-b5fc-ca8dda1e957c
344	0	\N	0	\N	\N	\N	\N	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	\N
345	0	\N	0	\N	\N	\N	\N	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	e19de17d-d456-4b3b-8102-d1a012594d36
346	1	\N	0	\N	\N	\N	\N	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	1ad028c5-ca62-409c-96d0-e90b9a547216
241	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	32d21a1d-acae-42b9-9edf-4e47710a340a
477	0	\N	0	\N	\N	\N	\N	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	\N
183	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	ac978e1a-ecdd-4409-982d-ad9f2c9d2933
186	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	b69846db-0436-4b43-9f3c-8c32473591cd
187	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	6976abc2-963e-4646-9a1a-0b84cf194e14
548	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	14875a45-2776-47af-b999-0ad20f1b7ff9
549	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	62807404-015a-42e4-bc1e-bdeb2501f94e
550	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	85b1a7ac-ea04-472b-8b18-e5aec342eaea
551	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	880da050-40ba-4eaf-a68c-edada75594a9
487	0	\N	0	\N	\N	\N	\N	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	\N
272	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	3fadcab8-0741-48bb-a6d4-e2498776b884
273	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	cb96ce77-f592-45b1-9134-e7edc95a6fc3
552	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	b67582cb-62e9-43df-90b5-ce80eec4b405
274	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	41004cb5-139b-460e-972d-cab8cb44c811
275	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	f0ea2228-0bac-4d69-8132-9064c1d74396
271	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	b6dfa584-d9d6-4e67-9b10-13433ace7e38
301	2	\N	12	\N	\N	\N	TYPE_INHERITED	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	66bb3a28-09f6-4ced-8423-57b3d96b060f
304	1	\N	12	\N	\N	\N	TYPE_INHERITED	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	4401ba15-c530-48ee-b0af-d4e57e7fc0cb
305	0	\N	12	\N	\N	\N	TYPE_INHERITED	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	b0a816ce-64d0-4b01-924e-28a4a5b85d4e
489	1	\N	12	\N	\N	\N	\N	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	efe24c20-53cd-4a4f-8f72-d599f8df7e1a
244	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	9151f169-1522-4613-92cc-c524bbddde5d
488	0	\N	12	\N	\N	\N	\N	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	b9d4ea49-d4b5-41b8-9891-0c65ff4bcbae
245	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	7ecddc58-7be4-4c9b-afb6-7cf47980bdbb
668	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	f337e86e-7ee2-466c-841c-13b345ec5676
669	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	6b8fb088-d396-4c9d-bd8b-94e2f38ec447
670	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	244b6155-22e3-4579-b2f0-f4e1b459e62a
608	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	c37aadfa-226f-4828-98bc-014c4e31d705
609	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	d836e6c1-1fc3-4658-af3a-8d368eb81fa3
671	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	aaf93d7b-4387-450c-9b08-0da85be3df6a
610	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	64fe4985-27fe-4f22-8639-86bc96f20fb4
611	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	047efc13-5570-4018-a045-52dcc92d44da
672	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	55793605-81eb-4525-be84-bb56dedb1703
612	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	f1370e88-0940-4e2f-9e70-15d072d03075
460	2	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	9e984c6f-a21b-4d2a-b168-59665345bb19
461	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	faf47611-7203-4c82-aedb-c5333d5e84a0
462	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	442733cd-6e42-4067-aec3-7ab56c0400b2
463	1	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	cfec0436-26af-4ba7-80d0-4fbdfd6220f7
464	0	\N	0	\N	\N	\N	TYPE_INHERITED	\N	\N	5a1ce1ca-510b-47a7-af88-69ace496d4e7	9d699cab-947c-4a96-b7fb-6095ae6a853a
\.


--
-- Data for Name: schema_version; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.schema_version (installed_rank, version, description, type, script, checksum, installed_by, installed_on, execution_time, success) FROM stdin;
1	1	<< Flyway Baseline >>	BASELINE	<< Flyway Baseline >>	\N	dspace	2022-09-14 22:26:24.073077	0	t
2	1.1	Initial DSpace 1.1 database schema	SQL	V1.1__Initial_DSpace_1.1_database_schema.sql	1147897299	dspace	2022-09-14 22:26:24.242699	396	t
3	1.2	Upgrade to DSpace 1.2 schema	SQL	V1.2__Upgrade_to_DSpace_1.2_schema.sql	903973515	dspace	2022-09-14 22:26:24.64873	37	t
4	1.3	Upgrade to DSpace 1.3 schema	SQL	V1.3__Upgrade_to_DSpace_1.3_schema.sql	-783235991	dspace	2022-09-14 22:26:24.695294	67	t
5	1.3.9	Drop constraint for DSpace 1 4 schema	JDBC	org.dspace.storage.rdbms.migration.V1_3_9__Drop_constraint_for_DSpace_1_4_schema	-1	dspace	2022-09-14 22:26:24.771296	3	t
6	1.4	Upgrade to DSpace 1.4 schema	SQL	V1.4__Upgrade_to_DSpace_1.4_schema.sql	-831219528	dspace	2022-09-14 22:26:24.784636	151	t
7	1.5	Upgrade to DSpace 1.5 schema	SQL	V1.5__Upgrade_to_DSpace_1.5_schema.sql	-1234304544	dspace	2022-09-14 22:26:24.946923	231	t
8	1.5.9	Drop constraint for DSpace 1 6 schema	JDBC	org.dspace.storage.rdbms.migration.V1_5_9__Drop_constraint_for_DSpace_1_6_schema	-1	dspace	2022-09-14 22:26:25.187515	7	t
9	1.6	Upgrade to DSpace 1.6 schema	SQL	V1.6__Upgrade_to_DSpace_1.6_schema.sql	-495469766	dspace	2022-09-14 22:26:25.206318	48	t
10	1.7	Upgrade to DSpace 1.7 schema	SQL	V1.7__Upgrade_to_DSpace_1.7_schema.sql	-589640641	dspace	2022-09-14 22:26:25.268156	4	t
11	1.8	Upgrade to DSpace 1.8 schema	SQL	V1.8__Upgrade_to_DSpace_1.8_schema.sql	-171791117	dspace	2022-09-14 22:26:25.284871	4	t
12	3.0	Upgrade to DSpace 3.x schema	SQL	V3.0__Upgrade_to_DSpace_3.x_schema.sql	-1098885663	dspace	2022-09-14 22:26:25.301275	24	t
13	4.0	Upgrade to DSpace 4.x schema	SQL	V4.0__Upgrade_to_DSpace_4.x_schema.sql	1191833374	dspace	2022-09-14 22:26:25.337066	44	t
14	4.9.2015.10.26	DS-2818 registry update	SQL	V4.9_2015.10.26__DS-2818_registry_update.sql	1675451156	dspace	2022-09-14 22:26:25.391773	7	t
15	5.0.2014.08.08	DS-1945 Helpdesk Request a Copy	SQL	V5.0_2014.08.08__DS-1945_Helpdesk_Request_a_Copy.sql	-1208221648	dspace	2022-09-14 22:26:25.411135	9	t
16	5.0.2014.09.25	DS 1582 Metadata For All Objects drop constraint	JDBC	org.dspace.storage.rdbms.migration.V5_0_2014_09_25__DS_1582_Metadata_For_All_Objects_drop_constraint	-1	dspace	2022-09-14 22:26:25.430379	2	t
17	5.0.2014.09.26	DS-1582 Metadata For All Objects	SQL	V5.0_2014.09.26__DS-1582_Metadata_For_All_Objects.sql	1509433410	dspace	2022-09-14 22:26:25.440865	21	t
18	5.6.2016.08.23	DS-3097	SQL	V5.6_2016.08.23__DS-3097.sql	410632858	dspace	2022-09-14 22:26:25.471228	2	t
19	5.7.2017.04.11	DS-3563 Index metadatavalue resource type id column	SQL	V5.7_2017.04.11__DS-3563_Index_metadatavalue_resource_type_id_column.sql	912059617	dspace	2022-09-14 22:26:25.481173	7	t
20	5.7.2017.05.05	DS 3431 Add Policies for BasicWorkflow	JDBC	org.dspace.storage.rdbms.migration.V5_7_2017_05_05__DS_3431_Add_Policies_for_BasicWorkflow	-1	dspace	2022-09-14 22:26:25.501497	29	t
21	6.0.2015.03.06	DS 2701 Dso Uuid Migration	JDBC	org.dspace.storage.rdbms.migration.V6_0_2015_03_06__DS_2701_Dso_Uuid_Migration	-1	dspace	2022-09-14 22:26:25.540032	18	t
22	6.0.2015.03.07	DS-2701 Hibernate migration	SQL	V6.0_2015.03.07__DS-2701_Hibernate_migration.sql	-542830952	dspace	2022-09-14 22:26:25.567734	589	t
23	6.0.2015.08.31	DS 2701 Hibernate Workflow Migration	JDBC	org.dspace.storage.rdbms.migration.V6_0_2015_08_31__DS_2701_Hibernate_Workflow_Migration	-1	dspace	2022-09-14 22:26:26.166465	14	t
24	6.0.2016.01.03	DS-3024	SQL	V6.0_2016.01.03__DS-3024.sql	95468273	dspace	2022-09-14 22:26:26.189427	4	t
25	6.0.2016.01.26	DS 2188 Remove DBMS Browse Tables	JDBC	org.dspace.storage.rdbms.migration.V6_0_2016_01_26__DS_2188_Remove_DBMS_Browse_Tables	-1	dspace	2022-09-14 22:26:26.20201	22	t
26	6.0.2016.02.25	DS-3004-slow-searching-as-admin	SQL	V6.0_2016.02.25__DS-3004-slow-searching-as-admin.sql	-1623115511	dspace	2022-09-14 22:26:26.232275	11	t
27	6.0.2016.04.01	DS-1955 Increase embargo reason	SQL	V6.0_2016.04.01__DS-1955_Increase_embargo_reason.sql	283892016	dspace	2022-09-14 22:26:26.251177	7	t
28	6.0.2016.04.04	DS-3086-OAI-Performance-fix	SQL	V6.0_2016.04.04__DS-3086-OAI-Performance-fix.sql	445863295	dspace	2022-09-14 22:26:26.266303	23	t
29	6.0.2016.04.14	DS-3125-fix-bundle-bitstream-delete-rights	SQL	V6.0_2016.04.14__DS-3125-fix-bundle-bitstream-delete-rights.sql	-699277527	dspace	2022-09-14 22:26:26.298408	1	t
30	6.0.2016.05.10	DS-3168-fix-requestitem item id column	SQL	V6.0_2016.05.10__DS-3168-fix-requestitem_item_id_column.sql	-1122969100	dspace	2022-09-14 22:26:26.307335	17	t
31	6.0.2016.07.21	DS-2775	SQL	V6.0_2016.07.21__DS-2775.sql	-126635374	dspace	2022-09-14 22:26:26.332243	8	t
32	6.0.2016.07.26	DS-3277 fix handle assignment	SQL	V6.0_2016.07.26__DS-3277_fix_handle_assignment.sql	-284088754	dspace	2022-09-14 22:26:26.349256	7	t
33	6.0.2016.08.23	DS-3097	SQL	V6.0_2016.08.23__DS-3097.sql	-1986377895	dspace	2022-09-14 22:26:26.363305	3	t
34	6.1.2017.01.03	DS 3431 Add Policies for BasicWorkflow	JDBC	org.dspace.storage.rdbms.migration.V6_1_2017_01_03__DS_3431_Add_Policies_for_BasicWorkflow	-1	dspace	2022-09-14 22:26:26.374825	29	t
\.


--
-- Data for Name: site; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.site (uuid) FROM stdin;
76d365c5-53f1-40c9-929d-239899a2472f
\.


--
-- Data for Name: subscription; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.subscription (subscription_id, eperson_id, collection_id) FROM stdin;
\.


--
-- Data for Name: tasklistitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tasklistitem (tasklist_id, workflow_id, eperson_id) FROM stdin;
\.


--
-- Data for Name: versionhistory; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.versionhistory (versionhistory_id) FROM stdin;
\.


--
-- Data for Name: versionitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.versionitem (versionitem_id, version_number, version_date, version_summary, versionhistory_id, eperson_id, item_id) FROM stdin;
\.


--
-- Data for Name: webapp; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.webapp (webapp_id, appname, url, started, isui) FROM stdin;
1	OAI	http://200.128.35.3:8080/jspui	2022-09-14 22:26:23.835	0
2	REST	http://200.128.35.3:8080/jspui	2022-09-14 22:26:36.26	0
3	JSPUI	http://200.128.35.3:8080/jspui	2022-09-14 22:26:49.377	1
4	XMLUI	http://200.128.35.3:8080/jspui	2022-09-14 22:26:58.538	1
5	OAI	http://200.128.35.3:8080/jspui	2022-09-14 22:30:44.063	0
6	REST	http://200.128.35.3:8080/jspui	2022-09-14 22:30:53.176	0
7	JSPUI	http://200.128.35.3:8080/jspui	2022-09-14 22:31:06.549	1
8	XMLUI	http://200.128.35.3:8080/jspui	2022-09-14 22:31:15.452	1
9	OAI	http://200.128.35.3:8080/jspui	2022-09-14 22:48:24.176	0
10	REST	http://200.128.35.3:8080/jspui	2022-09-14 22:48:32.889	0
11	JSPUI	http://200.128.35.3:8080/jspui	2022-09-14 22:48:46.404	1
12	XMLUI	http://200.128.35.3:8080/jspui	2022-09-14 22:48:55.833	1
13	OAI	http://200.128.35.3:8080/xmlui	2022-09-14 23:01:23.477	0
14	REST	http://200.128.35.3:8080/xmlui	2022-09-14 23:01:32.306	0
15	JSPUI	http://200.128.35.3:8080/xmlui	2022-09-14 23:01:45.149	1
16	XMLUI	http://200.128.35.3:8080/xmlui	2022-09-14 23:01:53.831	1
17	OAI	http://200.128.35.3:8080/jspui	2022-09-14 23:29:20.238	0
18	REST	http://200.128.35.3:8080/jspui	2022-09-14 23:29:29.593	0
19	JSPUI	http://200.128.35.3:8080/jspui	2022-09-14 23:29:42.682	1
20	XMLUI	http://200.128.35.3:8080/jspui	2022-09-14 23:29:52.15	1
21	OAI	http://200.128.35.3:8080/jspui	2022-09-27 13:21:17.431	0
22	REST	http://200.128.35.3:8080/jspui	2022-09-27 13:21:27.224	0
23	JSPUI	http://200.128.35.3:8080/jspui	2022-09-27 13:21:40.919	1
24	XMLUI	http://200.128.35.3:8080/jspui	2022-09-27 13:21:50.405	1
25	OAI	https://asetore.ifba.edu.br/jspui/jspui	2022-09-27 13:39:18.572	0
26	REST	https://asetore.ifba.edu.br/jspui/jspui	2022-09-27 13:39:27.767	0
27	JSPUI	https://asetore.ifba.edu.br/jspui/jspui	2022-09-27 13:39:42.21	1
28	XMLUI	https://asetore.ifba.edu.br/jspui/jspui	2022-09-27 13:39:52.233	1
29	OAI	https://asetore.ifba.edu.br/jspui	2022-09-30 15:50:23.78	0
30	REST	https://asetore.ifba.edu.br/jspui	2022-09-30 15:50:34.546	0
31	JSPUI	https://asetore.ifba.edu.br/jspui	2022-09-30 15:50:48.416	1
32	XMLUI	https://asetore.ifba.edu.br/jspui	2022-09-30 15:50:59.131	1
33	OAI	https://asetore.ifba.edu.br/jspui	2023-07-24 20:28:36.507	0
34	REST	https://asetore.ifba.edu.br/jspui	2023-07-24 20:28:51.829	0
35	JSPUI	https://asetore.ifba.edu.br/jspui	2023-07-24 20:29:15.975	1
36	XMLUI	https://asetore.ifba.edu.br/jspui	2023-07-24 20:29:33.101	1
37	OAI	https://asetore.ifba.edu.br/jspui	2023-07-25 00:46:48.226	0
38	REST	https://asetore.ifba.edu.br/jspui	2023-07-25 00:46:56.254	0
39	JSPUI	https://asetore.ifba.edu.br/jspui	2023-07-25 00:47:08.187	1
40	XMLUI	https://asetore.ifba.edu.br/jspui	2023-07-25 00:47:16.04	1
41	OAI	https://asetore.ifba.edu.br/jspui	2023-07-25 00:53:24.403	0
42	REST	https://asetore.ifba.edu.br/jspui	2023-07-25 00:53:32.428	0
43	JSPUI	https://asetore.ifba.edu.br/jspui	2023-07-25 00:53:44.109	1
44	XMLUI	https://asetore.ifba.edu.br/jspui	2023-07-25 00:53:51.841	1
45	OAI	https://asetore.ifba.edu.br/jspui	2023-07-25 01:05:06.175	0
46	REST	https://asetore.ifba.edu.br/jspui	2023-07-25 01:05:13.681	0
47	JSPUI	https://asetore.ifba.edu.br/jspui	2023-07-25 01:05:24.716	1
48	XMLUI	https://asetore.ifba.edu.br/jspui	2023-07-25 01:05:31.995	1
49	OAI	https://asetore.ifba.edu.br/jspui	2023-07-25 14:28:45.841	0
50	REST	https://asetore.ifba.edu.br/jspui	2023-07-25 14:28:53.457	0
51	JSPUI	https://asetore.ifba.edu.br/jspui	2023-07-25 14:29:06.058	1
52	XMLUI	https://asetore.ifba.edu.br/jspui	2023-07-25 14:29:13.463	1
53	OAI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-17 15:17:25.281	0
54	REST	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-17 15:17:34.394	0
55	JSPUI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-17 15:17:47.185	1
56	XMLUI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-17 15:17:55.435	1
57	OAI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-17 15:34:00.028	0
58	REST	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-17 15:34:07.776	0
59	JSPUI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-17 15:34:18.963	1
60	XMLUI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-17 15:34:26.453	1
61	OAI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-17 15:46:00.047	0
62	REST	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-17 15:46:08.07	0
63	JSPUI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-17 15:46:19.888	1
64	XMLUI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-17 15:46:27.648	1
65	OAI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-17 19:30:33.016	0
66	REST	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-17 19:30:40.59	0
67	JSPUI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-17 19:30:51.687	1
68	XMLUI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-17 19:30:59.043	1
69	OAI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-17 19:33:10.775	0
70	REST	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-17 19:33:18.619	0
71	JSPUI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-17 19:33:30.527	1
72	XMLUI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-17 19:33:38.209	1
73	OAI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-17 19:41:59.23	0
74	REST	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-17 19:42:06.9	0
75	JSPUI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-17 19:42:18.253	1
76	XMLUI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-17 19:42:25.85	1
77	OAI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-17 19:49:57.844	0
78	REST	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-17 19:50:05.821	0
79	JSPUI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-17 19:50:18.182	1
80	XMLUI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-17 19:50:26.366	1
81	OAI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-17 19:59:38.251	0
82	REST	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-17 19:59:45.843	0
83	XMLUI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-17 20:00:05.983	1
84	OAI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-17 20:06:01.593	0
85	REST	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-17 20:06:09.175	0
86	XMLUI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-17 20:06:26.587	1
87	OAI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-17 20:08:19.567	0
88	OAI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-17 20:08:43.082	0
89	REST	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-17 20:08:51.371	0
90	JSPUI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-17 20:09:02.715	1
91	XMLUI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-17 20:09:10.012	1
92	OAI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-17 20:11:03.081	0
93	REST	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-17 20:11:10.56	0
94	XMLUI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-17 20:11:27.626	1
95	OAI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-17 20:12:26.952	0
96	REST	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-17 20:12:34.429	0
97	XMLUI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-17 20:12:51.509	1
98	OAI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-17 20:17:37.01	0
99	OAI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-17 20:17:57.88	0
100	REST	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-17 20:18:05.4	0
139	XMLUI	http://www.asetore.ifba.edu.br:8080/jspui	2024-04-19 14:23:12.077	1
102	XMLUI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-17 20:18:24.026	1
103	JSPUI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-17 20:20:49.401	1
104	OAI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-24 19:18:45.13	0
105	REST	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-24 19:18:54.987	0
106	JSPUI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-24 19:19:10.607	1
107	XMLUI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-24 19:19:20.249	1
108	OAI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-24 19:39:09.066	0
109	REST	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-24 19:39:16.356	0
110	JSPUI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-24 19:39:27.86	1
111	XMLUI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-24 19:39:35.343	1
112	OAI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-24 20:04:24.533	0
113	REST	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-24 20:04:32.149	0
114	JSPUI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-24 20:04:43.347	1
115	XMLUI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-24 20:04:51.189	1
116	OAI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-24 21:39:20.364	0
117	REST	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-24 21:39:27.753	0
118	JSPUI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-24 21:39:38.936	1
119	XMLUI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-24 21:39:47.003	1
120	OAI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-24 21:48:07.379	0
121	REST	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-24 21:48:15.146	0
122	JSPUI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-24 21:48:26.592	1
123	XMLUI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-24 21:48:34.496	1
124	OAI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-25 14:42:36.92	0
125	REST	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-25 14:42:44.926	0
127	XMLUI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-25 14:43:04.82	1
128	OAI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-25 15:00:36.523	0
129	REST	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-25 15:00:44.246	0
130	JSPUI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-25 15:00:55.749	1
131	XMLUI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-25 15:01:03.571	1
132	OAI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-25 15:34:11.694	0
133	REST	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-25 15:34:19.119	0
134	JSPUI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-25 15:34:30.267	1
135	XMLUI	http://www.asetore.ifba.edu.br:8080/jspui	2023-08-25 15:34:37.837	1
136	OAI	http://www.asetore.ifba.edu.br:8080/jspui	2024-04-19 14:22:27.623	0
137	REST	http://www.asetore.ifba.edu.br:8080/jspui	2024-04-19 14:22:50.09	0
138	JSPUI	http://www.asetore.ifba.edu.br:8080/jspui	2024-04-19 14:23:03.113	1
140	OAI	http://www.asetore.ifba.edu.br:8080/jspui	2024-05-03 19:05:23.137	0
141	REST	http://www.asetore.ifba.edu.br:8080/jspui	2024-05-03 19:05:40.562	0
142	JSPUI	http://www.asetore.ifba.edu.br:8080/jspui	2024-05-03 19:06:04.17	1
143	XMLUI	http://www.asetore.ifba.edu.br:8080/jspui	2024-05-03 19:06:19.201	1
144	OAI	http://www.asetore.ifba.edu.br:8080/jspui	2024-06-06 19:31:44.162	0
145	REST	http://www.asetore.ifba.edu.br:8080/jspui	2024-06-06 19:32:06.869	0
146	JSPUI	http://www.asetore.ifba.edu.br:8080/jspui	2024-06-06 19:32:41.767	1
147	XMLUI	http://www.asetore.ifba.edu.br:8080/jspui	2024-06-06 19:33:07.609	1
177	OAI	http://www.asetore.ifba.edu.br:8080/jspui	2024-06-06 19:46:48.953	0
178	REST	http://www.asetore.ifba.edu.br:8080/jspui	2024-06-06 19:47:16.815	0
179	JSPUI	http://www.asetore.ifba.edu.br:8080/jspui	2024-06-06 19:47:52.743	1
180	XMLUI	http://www.asetore.ifba.edu.br:8080/jspui	2024-06-06 19:48:12.26	1
181	OAI	http://www.asetore.ifba.edu.br:8080/jspui	2024-08-06 19:09:06.642	0
182	REST	http://www.asetore.ifba.edu.br:8080/jspui	2024-08-06 19:09:30.29	0
183	JSPUI	http://www.asetore.ifba.edu.br:8080/jspui	2024-08-06 19:10:00.637	1
184	XMLUI	http://www.asetore.ifba.edu.br:8080/jspui	2024-08-06 19:10:17.101	1
185	OAI	http://www.asetore.ifba.edu.br:8080/jspui	2024-08-22 18:05:09.146	0
186	REST	http://www.asetore.ifba.edu.br:8080/jspui	2024-08-22 18:07:09.396	0
187	JSPUI	http://www.asetore.ifba.edu.br:8080/jspui	2024-08-22 18:09:50.891	1
188	XMLUI	http://www.asetore.ifba.edu.br:8080/jspui	2024-08-22 18:10:57.951	1
189	OAI	http://www.asetore.ifba.edu.br:8080/jspui	2024-08-22 22:03:58.594	0
190	REST	http://www.asetore.ifba.edu.br:8080/jspui	2024-08-22 22:04:48.84	0
191	JSPUI	http://www.asetore.ifba.edu.br:8080/jspui	2024-08-22 22:06:03.977	1
192	XMLUI	http://www.asetore.ifba.edu.br:8080/jspui	2024-08-22 22:06:43.002	1
193	OAI	http://www.asetore.ifba.edu.br:8080/jspui	2024-10-03 08:16:02.966	0
194	REST	http://www.asetore.ifba.edu.br:8080/jspui	2024-10-03 08:17:22.644	0
195	JSPUI	http://www.asetore.ifba.edu.br:8080/jspui	2024-10-03 08:18:59.058	1
196	XMLUI	http://www.asetore.ifba.edu.br:8080/jspui	2024-10-03 08:19:51.668	1
197	OAI	http://www.asetore.ifba.edu.br:8080/jspui	2024-10-23 11:16:47.043	0
198	REST	http://www.asetore.ifba.edu.br:8080/jspui	2024-10-23 11:16:57.381	0
199	JSPUI	http://www.asetore.ifba.edu.br:8080/jspui	2024-10-23 11:17:09.578	1
200	XMLUI	http://www.asetore.ifba.edu.br:8080/jspui	2024-10-23 11:17:19.294	1
201	OAI	http://www.asetore.ifba.edu.br:8080/jspui	2024-10-23 13:45:26.189	0
202	REST	http://www.asetore.ifba.edu.br:8080/jspui	2024-10-23 13:45:50.663	0
203	JSPUI	http://www.asetore.ifba.edu.br:8080/jspui	2024-10-23 13:46:37.373	1
204	XMLUI	http://www.asetore.ifba.edu.br:8080/jspui	2024-10-23 13:47:04.801	1
205	OAI	http://www.asetore.ifba.edu.br:8080/jspui	2024-10-26 17:51:21.905	0
206	REST	http://www.asetore.ifba.edu.br:8080/jspui	2024-10-26 17:51:39.412	0
207	JSPUI	http://www.asetore.ifba.edu.br:8080/jspui	2024-10-26 17:52:02.749	1
208	XMLUI	http://www.asetore.ifba.edu.br:8080/jspui	2024-10-26 17:52:17.987	1
209	OAI	http://www.asetore.ifba.edu.br:8080/jspui	2024-10-29 10:39:37.23	0
210	REST	http://www.asetore.ifba.edu.br:8080/jspui	2024-10-29 10:39:58.987	0
211	JSPUI	http://www.asetore.ifba.edu.br:8080/jspui	2024-10-29 10:40:30.766	1
212	XMLUI	http://www.asetore.ifba.edu.br:8080/jspui	2024-10-29 10:40:50.909	1
213	OAI	http://www.asetore.ifba.edu.br:8080/jspui	2024-11-26 17:34:02.515	0
214	REST	http://www.asetore.ifba.edu.br:8080/jspui	2024-11-26 17:34:13.422	0
215	JSPUI	http://www.asetore.ifba.edu.br:8080/jspui	2024-11-26 17:34:29.43	1
216	XMLUI	http://www.asetore.ifba.edu.br:8080/jspui	2024-11-26 17:34:42.778	1
217	OAI	http://www.asetore.ifba.edu.br:8080/jspui	2025-01-21 13:54:45.228	0
218	REST	http://www.asetore.ifba.edu.br:8080/jspui	2025-01-21 13:54:54.821	0
219	JSPUI	http://www.asetore.ifba.edu.br:8080/jspui	2025-01-21 13:55:08.651	1
220	XMLUI	http://www.asetore.ifba.edu.br:8080/jspui	2025-01-21 13:55:17.761	1
221	OAI	http://www.asetore.ifba.edu.br:8080/jspui	2025-01-23 13:56:30.011	0
222	REST	http://www.asetore.ifba.edu.br:8080/jspui	2025-01-23 13:56:51.44	0
223	JSPUI	http://www.asetore.ifba.edu.br:8080/jspui	2025-01-23 13:57:17.337	1
224	XMLUI	http://www.asetore.ifba.edu.br:8080/jspui	2025-01-23 13:57:31.9	1
225	OAI	http://www.asetore.ifba.edu.br:8080/jspui	2025-07-17 12:23:35.349	0
226	REST	http://www.asetore.ifba.edu.br:8080/jspui	2025-07-17 12:23:43.935	0
227	JSPUI	http://www.asetore.ifba.edu.br:8080/jspui	2025-07-17 12:23:57.375	1
228	XMLUI	http://www.asetore.ifba.edu.br:8080/jspui	2025-07-17 12:24:05.931	1
229	OAI	http://www.asetore.ifba.edu.br:8080/jspui	2025-07-23 12:29:32.503	0
230	REST	http://www.asetore.ifba.edu.br:8080/jspui	2025-07-23 12:29:45.51	0
231	JSPUI	http://www.asetore.ifba.edu.br:8080/jspui	2025-07-23 12:30:03.884	1
232	XMLUI	http://www.asetore.ifba.edu.br:8080/jspui	2025-07-23 12:30:14.873	1
233	OAI	http://www.asetore.ifba.edu.br:8080/jspui	2026-04-14 23:18:31.37	0
234	REST	http://www.asetore.ifba.edu.br:8080/jspui	2026-04-14 23:18:43.208	0
235	JSPUI	http://www.asetore.ifba.edu.br:8080/jspui	2026-04-14 23:19:00.924	1
236	XMLUI	http://www.asetore.ifba.edu.br:8080/jspui	2026-04-14 23:19:11.67	1
237	OAI	http://www.asetore.ifba.edu.br:8080/jspui	2026-04-15 15:08:23.777	0
238	REST	http://www.asetore.ifba.edu.br:8080/jspui	2026-04-15 15:08:31.842	0
239	JSPUI	http://www.asetore.ifba.edu.br:8080/jspui	2026-04-15 15:08:43.821	1
240	XMLUI	http://www.asetore.ifba.edu.br:8080/jspui	2026-04-15 15:08:51.893	1
241	OAI	http://www.asetore.ifba.edu.br:8080/jspui	2026-04-15 16:33:53.159	0
242	REST	http://www.asetore.ifba.edu.br:8080/jspui	2026-04-15 16:34:01.15	0
243	JSPUI	http://www.asetore.ifba.edu.br:8080/jspui	2026-04-15 16:34:13.022	1
244	XMLUI	http://www.asetore.ifba.edu.br:8080/jspui	2026-04-15 16:34:21.23	1
245	OAI	http://www.asetore.ifba.edu.br:8080/jspui	2026-04-16 14:25:20.206	0
246	REST	http://www.asetore.ifba.edu.br:8080/jspui	2026-04-16 14:25:28.322	0
247	JSPUI	http://www.asetore.ifba.edu.br:8080/jspui	2026-04-16 14:25:40.84	1
248	XMLUI	http://www.asetore.ifba.edu.br:8080/jspui	2026-04-16 14:25:49.554	1
249	OAI	http://www.asetore.ifba.edu.br:8080/jspui	2026-04-24 15:49:26.799	0
250	REST	http://www.asetore.ifba.edu.br:8080/jspui	2026-04-24 15:49:37.272	0
251	JSPUI	http://www.asetore.ifba.edu.br:8080/jspui	2026-04-24 15:49:52.21	1
252	XMLUI	http://www.asetore.ifba.edu.br:8080/jspui	2026-04-24 15:50:02.127	1
\.


--
-- Data for Name: workflowitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.workflowitem (workflow_id, state, multiple_titles, published_before, multiple_files, item_id, collection_id, owner) FROM stdin;
\.


--
-- Data for Name: workspaceitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.workspaceitem (workspace_item_id, multiple_titles, published_before, multiple_files, stage_reached, page_reached, item_id, collection_id) FROM stdin;
\.


--
-- Name: bitstreamformatregistry_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.bitstreamformatregistry_seq', 77, true);


--
-- Name: checksum_history_check_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.checksum_history_check_id_seq', 1, false);


--
-- Name: doi_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.doi_seq', 1, false);


--
-- Name: fileextension_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.fileextension_seq', 96, true);


--
-- Name: handle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.handle_id_seq', 98, true);


--
-- Name: handle_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.handle_seq', 97, true);


--
-- Name: harvested_collection_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.harvested_collection_seq', 1, false);


--
-- Name: harvested_item_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.harvested_item_seq', 1, false);


--
-- Name: history_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.history_seq', 1, false);


--
-- Name: metadatafieldregistry_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.metadatafieldregistry_seq', 132, true);


--
-- Name: metadataschemaregistry_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.metadataschemaregistry_seq', 4, true);


--
-- Name: metadatavalue_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.metadatavalue_seq', 2111, true);


--
-- Name: registrationdata_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.registrationdata_seq', 56, true);


--
-- Name: requestitem_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.requestitem_seq', 1, false);


--
-- Name: resourcepolicy_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.resourcepolicy_seq', 672, true);


--
-- Name: subscription_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.subscription_seq', 1, false);


--
-- Name: tasklistitem_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.tasklistitem_seq', 1, false);


--
-- Name: versionhistory_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.versionhistory_seq', 1, false);


--
-- Name: versionitem_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.versionitem_seq', 1, false);


--
-- Name: webapp_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.webapp_seq', 252, true);


--
-- Name: workflowitem_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.workflowitem_seq', 13, true);


--
-- Name: workspaceitem_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.workspaceitem_seq', 14, true);


--
-- Name: bitstream bitstream_id_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bitstream
    ADD CONSTRAINT bitstream_id_unique UNIQUE (uuid);


--
-- Name: bitstream bitstream_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bitstream
    ADD CONSTRAINT bitstream_pkey PRIMARY KEY (uuid);


--
-- Name: bitstream bitstream_uuid_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bitstream
    ADD CONSTRAINT bitstream_uuid_key UNIQUE (uuid);


--
-- Name: bitstreamformatregistry bitstreamformatregistry_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bitstreamformatregistry
    ADD CONSTRAINT bitstreamformatregistry_pkey PRIMARY KEY (bitstream_format_id);


--
-- Name: bitstreamformatregistry bitstreamformatregistry_short_description_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bitstreamformatregistry
    ADD CONSTRAINT bitstreamformatregistry_short_description_key UNIQUE (short_description);


--
-- Name: bundle2bitstream bundle2bitstream_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bundle2bitstream
    ADD CONSTRAINT bundle2bitstream_pkey PRIMARY KEY (bitstream_id, bundle_id, bitstream_order);


--
-- Name: bundle bundle_id_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bundle
    ADD CONSTRAINT bundle_id_unique UNIQUE (uuid);


--
-- Name: bundle bundle_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bundle
    ADD CONSTRAINT bundle_pkey PRIMARY KEY (uuid);


--
-- Name: bundle bundle_uuid_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bundle
    ADD CONSTRAINT bundle_uuid_key UNIQUE (uuid);


--
-- Name: checksum_history checksum_history_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.checksum_history
    ADD CONSTRAINT checksum_history_pkey PRIMARY KEY (check_id);


--
-- Name: checksum_results checksum_results_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.checksum_results
    ADD CONSTRAINT checksum_results_pkey PRIMARY KEY (result_code);


--
-- Name: collection2item collection2item_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collection2item
    ADD CONSTRAINT collection2item_pkey PRIMARY KEY (collection_id, item_id);


--
-- Name: collection collection_id_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT collection_id_unique UNIQUE (uuid);


--
-- Name: collection collection_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT collection_pkey PRIMARY KEY (uuid);


--
-- Name: collection collection_uuid_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT collection_uuid_key UNIQUE (uuid);


--
-- Name: community2collection community2collection_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.community2collection
    ADD CONSTRAINT community2collection_pkey PRIMARY KEY (collection_id, community_id);


--
-- Name: community2community community2community_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.community2community
    ADD CONSTRAINT community2community_pkey PRIMARY KEY (parent_comm_id, child_comm_id);


--
-- Name: community community_id_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.community
    ADD CONSTRAINT community_id_unique UNIQUE (uuid);


--
-- Name: community community_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.community
    ADD CONSTRAINT community_pkey PRIMARY KEY (uuid);


--
-- Name: community community_uuid_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.community
    ADD CONSTRAINT community_uuid_key UNIQUE (uuid);


--
-- Name: doi doi_doi_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.doi
    ADD CONSTRAINT doi_doi_key UNIQUE (doi);


--
-- Name: doi doi_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.doi
    ADD CONSTRAINT doi_pkey PRIMARY KEY (doi_id);


--
-- Name: dspaceobject dspaceobject_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dspaceobject
    ADD CONSTRAINT dspaceobject_pkey PRIMARY KEY (uuid);


--
-- Name: eperson eperson_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.eperson
    ADD CONSTRAINT eperson_email_key UNIQUE (email);


--
-- Name: eperson eperson_id_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.eperson
    ADD CONSTRAINT eperson_id_unique UNIQUE (uuid);


--
-- Name: eperson eperson_netid_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.eperson
    ADD CONSTRAINT eperson_netid_key UNIQUE (netid);


--
-- Name: eperson eperson_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.eperson
    ADD CONSTRAINT eperson_pkey PRIMARY KEY (uuid);


--
-- Name: eperson eperson_uuid_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.eperson
    ADD CONSTRAINT eperson_uuid_key UNIQUE (uuid);


--
-- Name: epersongroup2eperson epersongroup2eperson_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.epersongroup2eperson
    ADD CONSTRAINT epersongroup2eperson_pkey PRIMARY KEY (eperson_group_id, eperson_id);


--
-- Name: epersongroup2workspaceitem epersongroup2workspaceitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.epersongroup2workspaceitem
    ADD CONSTRAINT epersongroup2workspaceitem_pkey PRIMARY KEY (workspace_item_id, eperson_group_id);


--
-- Name: epersongroup epersongroup_id_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.epersongroup
    ADD CONSTRAINT epersongroup_id_unique UNIQUE (uuid);


--
-- Name: epersongroup epersongroup_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.epersongroup
    ADD CONSTRAINT epersongroup_pkey PRIMARY KEY (uuid);


--
-- Name: epersongroup epersongroup_uuid_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.epersongroup
    ADD CONSTRAINT epersongroup_uuid_key UNIQUE (uuid);


--
-- Name: fileextension fileextension_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fileextension
    ADD CONSTRAINT fileextension_pkey PRIMARY KEY (file_extension_id);


--
-- Name: group2group group2group_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group2group
    ADD CONSTRAINT group2group_pkey PRIMARY KEY (parent_id, child_id);


--
-- Name: group2groupcache group2groupcache_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group2groupcache
    ADD CONSTRAINT group2groupcache_pkey PRIMARY KEY (parent_id, child_id);


--
-- Name: handle handle_handle_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.handle
    ADD CONSTRAINT handle_handle_key UNIQUE (handle);


--
-- Name: handle handle_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.handle
    ADD CONSTRAINT handle_pkey PRIMARY KEY (handle_id);


--
-- Name: harvested_collection harvested_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.harvested_collection
    ADD CONSTRAINT harvested_collection_pkey PRIMARY KEY (id);


--
-- Name: harvested_item harvested_item_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.harvested_item
    ADD CONSTRAINT harvested_item_pkey PRIMARY KEY (id);


--
-- Name: item2bundle item2bundle_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item2bundle
    ADD CONSTRAINT item2bundle_pkey PRIMARY KEY (bundle_id, item_id);


--
-- Name: item item_id_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item
    ADD CONSTRAINT item_id_unique UNIQUE (uuid);


--
-- Name: item item_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item
    ADD CONSTRAINT item_pkey PRIMARY KEY (uuid);


--
-- Name: item item_uuid_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item
    ADD CONSTRAINT item_uuid_key UNIQUE (uuid);


--
-- Name: metadatafieldregistry metadatafieldregistry_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metadatafieldregistry
    ADD CONSTRAINT metadatafieldregistry_pkey PRIMARY KEY (metadata_field_id);


--
-- Name: metadataschemaregistry metadataschemaregistry_namespace_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metadataschemaregistry
    ADD CONSTRAINT metadataschemaregistry_namespace_key UNIQUE (namespace);


--
-- Name: metadataschemaregistry metadataschemaregistry_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metadataschemaregistry
    ADD CONSTRAINT metadataschemaregistry_pkey PRIMARY KEY (metadata_schema_id);


--
-- Name: metadatavalue metadatavalue_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metadatavalue
    ADD CONSTRAINT metadatavalue_pkey PRIMARY KEY (metadata_value_id);


--
-- Name: registrationdata registrationdata_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.registrationdata
    ADD CONSTRAINT registrationdata_email_key UNIQUE (email);


--
-- Name: registrationdata registrationdata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.registrationdata
    ADD CONSTRAINT registrationdata_pkey PRIMARY KEY (registrationdata_id);


--
-- Name: requestitem requestitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.requestitem
    ADD CONSTRAINT requestitem_pkey PRIMARY KEY (requestitem_id);


--
-- Name: requestitem requestitem_token_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.requestitem
    ADD CONSTRAINT requestitem_token_key UNIQUE (token);


--
-- Name: resourcepolicy resourcepolicy_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resourcepolicy
    ADD CONSTRAINT resourcepolicy_pkey PRIMARY KEY (policy_id);


--
-- Name: schema_version schema_version_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_version
    ADD CONSTRAINT schema_version_pk PRIMARY KEY (installed_rank);


--
-- Name: site site_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.site
    ADD CONSTRAINT site_pkey PRIMARY KEY (uuid);


--
-- Name: subscription subscription_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscription
    ADD CONSTRAINT subscription_pkey PRIMARY KEY (subscription_id);


--
-- Name: tasklistitem tasklistitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasklistitem
    ADD CONSTRAINT tasklistitem_pkey PRIMARY KEY (tasklist_id);


--
-- Name: versionhistory versionhistory_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.versionhistory
    ADD CONSTRAINT versionhistory_pkey PRIMARY KEY (versionhistory_id);


--
-- Name: versionitem versionitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.versionitem
    ADD CONSTRAINT versionitem_pkey PRIMARY KEY (versionitem_id);


--
-- Name: webapp webapp_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.webapp
    ADD CONSTRAINT webapp_pkey PRIMARY KEY (webapp_id);


--
-- Name: workflowitem workflowitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workflowitem
    ADD CONSTRAINT workflowitem_pkey PRIMARY KEY (workflow_id);


--
-- Name: workspaceitem workspaceitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workspaceitem
    ADD CONSTRAINT workspaceitem_pkey PRIMARY KEY (workspace_item_id);


--
-- Name: bit_bitstream_fk_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX bit_bitstream_fk_idx ON public.bitstream USING btree (bitstream_format_id);


--
-- Name: bitstream_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX bitstream_id_idx ON public.bitstream USING btree (bitstream_id);


--
-- Name: bundle2bitstream_bitstream; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX bundle2bitstream_bitstream ON public.bundle2bitstream USING btree (bitstream_id);


--
-- Name: bundle2bitstream_bundle; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX bundle2bitstream_bundle ON public.bundle2bitstream USING btree (bundle_id);


--
-- Name: bundle_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX bundle_id_idx ON public.bundle USING btree (bundle_id);


--
-- Name: bundle_primary; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX bundle_primary ON public.bundle USING btree (primary_bitstream_id);


--
-- Name: ch_result_fk_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ch_result_fk_idx ON public.checksum_history USING btree (result);


--
-- Name: checksum_history_bitstream; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX checksum_history_bitstream ON public.checksum_history USING btree (bitstream_id);


--
-- Name: collecion2item_collection; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX collecion2item_collection ON public.collection2item USING btree (collection_id);


--
-- Name: collecion2item_item; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX collecion2item_item ON public.collection2item USING btree (item_id);


--
-- Name: collection_bitstream; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX collection_bitstream ON public.collection USING btree (logo_bitstream_id);


--
-- Name: collection_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX collection_id_idx ON public.collection USING btree (collection_id);


--
-- Name: collection_submitter; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX collection_submitter ON public.collection USING btree (submitter);


--
-- Name: collection_template; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX collection_template ON public.collection USING btree (template_item_id);


--
-- Name: collection_workflow1; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX collection_workflow1 ON public.collection USING btree (workflow_step_1);


--
-- Name: collection_workflow2; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX collection_workflow2 ON public.collection USING btree (workflow_step_2);


--
-- Name: collection_workflow3; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX collection_workflow3 ON public.collection USING btree (workflow_step_3);


--
-- Name: community2collection_collection; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX community2collection_collection ON public.community2collection USING btree (collection_id);


--
-- Name: community2collection_community; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX community2collection_community ON public.community2collection USING btree (community_id);


--
-- Name: community2community_child; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX community2community_child ON public.community2community USING btree (child_comm_id);


--
-- Name: community2community_parent; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX community2community_parent ON public.community2community USING btree (parent_comm_id);


--
-- Name: community_admin; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX community_admin ON public.community USING btree (admin);


--
-- Name: community_bitstream; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX community_bitstream ON public.community USING btree (logo_bitstream_id);


--
-- Name: community_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX community_id_idx ON public.community USING btree (community_id);


--
-- Name: doi_doi_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX doi_doi_idx ON public.doi USING btree (doi);


--
-- Name: doi_object; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX doi_object ON public.doi USING btree (dspace_object);


--
-- Name: doi_resource_id_and_type_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX doi_resource_id_and_type_idx ON public.doi USING btree (resource_id, resource_type_id);


--
-- Name: eperson_email_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX eperson_email_idx ON public.eperson USING btree (email);


--
-- Name: eperson_group_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX eperson_group_id_idx ON public.epersongroup USING btree (eperson_group_id);


--
-- Name: eperson_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX eperson_id_idx ON public.eperson USING btree (eperson_id);


--
-- Name: epersongroup2eperson_group; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX epersongroup2eperson_group ON public.epersongroup2eperson USING btree (eperson_group_id);


--
-- Name: epersongroup2eperson_person; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX epersongroup2eperson_person ON public.epersongroup2eperson USING btree (eperson_id);


--
-- Name: epersongroup2workspaceitem_group; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX epersongroup2workspaceitem_group ON public.epersongroup2workspaceitem USING btree (eperson_group_id);


--
-- Name: epersongroup_unique_idx_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX epersongroup_unique_idx_name ON public.epersongroup USING btree (name);


--
-- Name: epg2wi_workspace_fk_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX epg2wi_workspace_fk_idx ON public.epersongroup2workspaceitem USING btree (workspace_item_id);


--
-- Name: fe_bitstream_fk_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fe_bitstream_fk_idx ON public.fileextension USING btree (bitstream_format_id);


--
-- Name: group2group_child; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX group2group_child ON public.group2group USING btree (child_id);


--
-- Name: group2group_parent; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX group2group_parent ON public.group2group USING btree (parent_id);


--
-- Name: group2groupcache_child; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX group2groupcache_child ON public.group2groupcache USING btree (child_id);


--
-- Name: group2groupcache_parent; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX group2groupcache_parent ON public.group2groupcache USING btree (parent_id);


--
-- Name: handle_handle_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX handle_handle_idx ON public.handle USING btree (handle);


--
-- Name: handle_object; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX handle_object ON public.handle USING btree (resource_id);


--
-- Name: handle_resource_id_and_type_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX handle_resource_id_and_type_idx ON public.handle USING btree (resource_legacy_id, resource_type_id);


--
-- Name: harvested_collection_collection; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX harvested_collection_collection ON public.harvested_collection USING btree (collection_id);


--
-- Name: harvested_item_item; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX harvested_item_item ON public.harvested_item USING btree (item_id);


--
-- Name: item2bundle_bundle; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX item2bundle_bundle ON public.item2bundle USING btree (bundle_id);


--
-- Name: item2bundle_item; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX item2bundle_item ON public.item2bundle USING btree (item_id);


--
-- Name: item_collection; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX item_collection ON public.item USING btree (owning_collection);


--
-- Name: item_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX item_id_idx ON public.item USING btree (item_id);


--
-- Name: item_submitter; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX item_submitter ON public.item USING btree (submitter_id);


--
-- Name: metadatafield_schema_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX metadatafield_schema_idx ON public.metadatafieldregistry USING btree (metadata_schema_id);


--
-- Name: metadatafieldregistry_idx_element_qualifier; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX metadatafieldregistry_idx_element_qualifier ON public.metadatafieldregistry USING btree (element, qualifier);


--
-- Name: metadataschemaregistry_unique_idx_short_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX metadataschemaregistry_unique_idx_short_id ON public.metadataschemaregistry USING btree (short_id);


--
-- Name: metadatavalue_field_fk_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX metadatavalue_field_fk_idx ON public.metadatavalue USING btree (metadata_field_id);


--
-- Name: metadatavalue_field_object; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX metadatavalue_field_object ON public.metadatavalue USING btree (metadata_field_id, dspace_object_id);


--
-- Name: metadatavalue_object; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX metadatavalue_object ON public.metadatavalue USING btree (dspace_object_id);


--
-- Name: most_recent_checksum_bitstream; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX most_recent_checksum_bitstream ON public.most_recent_checksum USING btree (bitstream_id);


--
-- Name: mrc_result_fk_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX mrc_result_fk_idx ON public.most_recent_checksum USING btree (result);


--
-- Name: requestitem_bitstream; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX requestitem_bitstream ON public.requestitem USING btree (bitstream_id);


--
-- Name: requestitem_item; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX requestitem_item ON public.requestitem USING btree (item_id);


--
-- Name: resourcepolicy_group; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX resourcepolicy_group ON public.resourcepolicy USING btree (epersongroup_id);


--
-- Name: resourcepolicy_idx_rptype; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX resourcepolicy_idx_rptype ON public.resourcepolicy USING btree (rptype);


--
-- Name: resourcepolicy_object; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX resourcepolicy_object ON public.resourcepolicy USING btree (dspace_object);


--
-- Name: resourcepolicy_person; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX resourcepolicy_person ON public.resourcepolicy USING btree (eperson_id);


--
-- Name: resourcepolicy_type_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX resourcepolicy_type_id_idx ON public.resourcepolicy USING btree (resource_type_id, resource_id);


--
-- Name: schema_version_s_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX schema_version_s_idx ON public.schema_version USING btree (success);


--
-- Name: subscription_collection; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX subscription_collection ON public.subscription USING btree (collection_id);


--
-- Name: subscription_person; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX subscription_person ON public.subscription USING btree (eperson_id);


--
-- Name: tasklist_workflow_fk_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tasklist_workflow_fk_idx ON public.tasklistitem USING btree (workflow_id);


--
-- Name: versionitem_item; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX versionitem_item ON public.versionitem USING btree (item_id);


--
-- Name: versionitem_person; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX versionitem_person ON public.versionitem USING btree (eperson_id);


--
-- Name: workspaceitem_coll; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX workspaceitem_coll ON public.workspaceitem USING btree (collection_id);


--
-- Name: workspaceitem_item; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX workspaceitem_item ON public.workspaceitem USING btree (item_id);


--
-- Name: bitstream bitstream_bitstream_format_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bitstream
    ADD CONSTRAINT bitstream_bitstream_format_id_fkey FOREIGN KEY (bitstream_format_id) REFERENCES public.bitstreamformatregistry(bitstream_format_id);


--
-- Name: bitstream bitstream_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bitstream
    ADD CONSTRAINT bitstream_uuid_fkey FOREIGN KEY (uuid) REFERENCES public.dspaceobject(uuid);


--
-- Name: bundle2bitstream bundle2bitstream_bitstream_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bundle2bitstream
    ADD CONSTRAINT bundle2bitstream_bitstream_id_fkey FOREIGN KEY (bitstream_id) REFERENCES public.bitstream(uuid);


--
-- Name: bundle2bitstream bundle2bitstream_bundle_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bundle2bitstream
    ADD CONSTRAINT bundle2bitstream_bundle_id_fkey FOREIGN KEY (bundle_id) REFERENCES public.bundle(uuid);


--
-- Name: bundle bundle_primary_bitstream_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bundle
    ADD CONSTRAINT bundle_primary_bitstream_id_fkey FOREIGN KEY (primary_bitstream_id) REFERENCES public.bitstream(uuid);


--
-- Name: bundle bundle_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bundle
    ADD CONSTRAINT bundle_uuid_fkey FOREIGN KEY (uuid) REFERENCES public.dspaceobject(uuid);


--
-- Name: checksum_history checksum_history_bitstream_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.checksum_history
    ADD CONSTRAINT checksum_history_bitstream_id_fkey FOREIGN KEY (bitstream_id) REFERENCES public.bitstream(uuid);


--
-- Name: checksum_history checksum_history_result_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.checksum_history
    ADD CONSTRAINT checksum_history_result_fkey FOREIGN KEY (result) REFERENCES public.checksum_results(result_code);


--
-- Name: collection2item collection2item_collection_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collection2item
    ADD CONSTRAINT collection2item_collection_id_fkey FOREIGN KEY (collection_id) REFERENCES public.collection(uuid);


--
-- Name: collection2item collection2item_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collection2item
    ADD CONSTRAINT collection2item_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(uuid);


--
-- Name: collection collection_admin_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT collection_admin_fkey FOREIGN KEY (admin) REFERENCES public.epersongroup(uuid);


--
-- Name: collection collection_submitter_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT collection_submitter_fkey FOREIGN KEY (submitter) REFERENCES public.epersongroup(uuid);


--
-- Name: collection collection_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT collection_uuid_fkey FOREIGN KEY (uuid) REFERENCES public.dspaceobject(uuid);


--
-- Name: collection collection_workflow_step_1_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT collection_workflow_step_1_fkey FOREIGN KEY (workflow_step_1) REFERENCES public.epersongroup(uuid);


--
-- Name: collection collection_workflow_step_2_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT collection_workflow_step_2_fkey FOREIGN KEY (workflow_step_2) REFERENCES public.epersongroup(uuid);


--
-- Name: collection collection_workflow_step_3_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT collection_workflow_step_3_fkey FOREIGN KEY (workflow_step_3) REFERENCES public.epersongroup(uuid);


--
-- Name: community2collection community2collection_collection_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.community2collection
    ADD CONSTRAINT community2collection_collection_id_fkey FOREIGN KEY (collection_id) REFERENCES public.collection(uuid);


--
-- Name: community2collection community2collection_community_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.community2collection
    ADD CONSTRAINT community2collection_community_id_fkey FOREIGN KEY (community_id) REFERENCES public.community(uuid);


--
-- Name: community2community community2community_child_comm_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.community2community
    ADD CONSTRAINT community2community_child_comm_id_fkey FOREIGN KEY (child_comm_id) REFERENCES public.community(uuid);


--
-- Name: community2community community2community_parent_comm_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.community2community
    ADD CONSTRAINT community2community_parent_comm_id_fkey FOREIGN KEY (parent_comm_id) REFERENCES public.community(uuid);


--
-- Name: community community_admin_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.community
    ADD CONSTRAINT community_admin_fkey FOREIGN KEY (admin) REFERENCES public.epersongroup(uuid);


--
-- Name: community community_logo_bitstream_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.community
    ADD CONSTRAINT community_logo_bitstream_id_fkey FOREIGN KEY (logo_bitstream_id) REFERENCES public.bitstream(uuid);


--
-- Name: community community_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.community
    ADD CONSTRAINT community_uuid_fkey FOREIGN KEY (uuid) REFERENCES public.dspaceobject(uuid);


--
-- Name: doi doi_dspace_object_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.doi
    ADD CONSTRAINT doi_dspace_object_fkey FOREIGN KEY (dspace_object) REFERENCES public.dspaceobject(uuid);


--
-- Name: eperson eperson_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.eperson
    ADD CONSTRAINT eperson_uuid_fkey FOREIGN KEY (uuid) REFERENCES public.dspaceobject(uuid);


--
-- Name: epersongroup2eperson epersongroup2eperson_eperson_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.epersongroup2eperson
    ADD CONSTRAINT epersongroup2eperson_eperson_group_id_fkey FOREIGN KEY (eperson_group_id) REFERENCES public.epersongroup(uuid);


--
-- Name: epersongroup2eperson epersongroup2eperson_eperson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.epersongroup2eperson
    ADD CONSTRAINT epersongroup2eperson_eperson_id_fkey FOREIGN KEY (eperson_id) REFERENCES public.eperson(uuid);


--
-- Name: epersongroup2workspaceitem epersongroup2workspaceitem_eperson_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.epersongroup2workspaceitem
    ADD CONSTRAINT epersongroup2workspaceitem_eperson_group_id_fkey FOREIGN KEY (eperson_group_id) REFERENCES public.epersongroup(uuid);


--
-- Name: epersongroup2workspaceitem epersongroup2workspaceitem_workspace_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.epersongroup2workspaceitem
    ADD CONSTRAINT epersongroup2workspaceitem_workspace_item_id_fkey FOREIGN KEY (workspace_item_id) REFERENCES public.workspaceitem(workspace_item_id);


--
-- Name: epersongroup epersongroup_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.epersongroup
    ADD CONSTRAINT epersongroup_uuid_fkey FOREIGN KEY (uuid) REFERENCES public.dspaceobject(uuid);


--
-- Name: fileextension fileextension_bitstream_format_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fileextension
    ADD CONSTRAINT fileextension_bitstream_format_id_fkey FOREIGN KEY (bitstream_format_id) REFERENCES public.bitstreamformatregistry(bitstream_format_id);


--
-- Name: group2group group2group_child_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group2group
    ADD CONSTRAINT group2group_child_id_fkey FOREIGN KEY (child_id) REFERENCES public.epersongroup(uuid);


--
-- Name: group2group group2group_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group2group
    ADD CONSTRAINT group2group_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.epersongroup(uuid);


--
-- Name: group2groupcache group2groupcache_child_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group2groupcache
    ADD CONSTRAINT group2groupcache_child_id_fkey FOREIGN KEY (child_id) REFERENCES public.epersongroup(uuid);


--
-- Name: group2groupcache group2groupcache_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group2groupcache
    ADD CONSTRAINT group2groupcache_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.epersongroup(uuid);


--
-- Name: handle handle_resource_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.handle
    ADD CONSTRAINT handle_resource_id_fkey FOREIGN KEY (resource_id) REFERENCES public.dspaceobject(uuid);


--
-- Name: harvested_collection harvested_collection_collection_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.harvested_collection
    ADD CONSTRAINT harvested_collection_collection_id_fkey FOREIGN KEY (collection_id) REFERENCES public.collection(uuid);


--
-- Name: harvested_item harvested_item_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.harvested_item
    ADD CONSTRAINT harvested_item_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(uuid);


--
-- Name: item2bundle item2bundle_bundle_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item2bundle
    ADD CONSTRAINT item2bundle_bundle_id_fkey FOREIGN KEY (bundle_id) REFERENCES public.bundle(uuid);


--
-- Name: item2bundle item2bundle_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item2bundle
    ADD CONSTRAINT item2bundle_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(uuid);


--
-- Name: item item_owning_collection_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item
    ADD CONSTRAINT item_owning_collection_fkey FOREIGN KEY (owning_collection) REFERENCES public.collection(uuid);


--
-- Name: item item_submitter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item
    ADD CONSTRAINT item_submitter_id_fkey FOREIGN KEY (submitter_id) REFERENCES public.eperson(uuid);


--
-- Name: item item_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item
    ADD CONSTRAINT item_uuid_fkey FOREIGN KEY (uuid) REFERENCES public.dspaceobject(uuid);


--
-- Name: metadatafieldregistry metadatafieldregistry_metadata_schema_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metadatafieldregistry
    ADD CONSTRAINT metadatafieldregistry_metadata_schema_id_fkey FOREIGN KEY (metadata_schema_id) REFERENCES public.metadataschemaregistry(metadata_schema_id);


--
-- Name: metadatavalue metadatavalue_dspace_object_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metadatavalue
    ADD CONSTRAINT metadatavalue_dspace_object_id_fkey FOREIGN KEY (dspace_object_id) REFERENCES public.dspaceobject(uuid) ON DELETE CASCADE;


--
-- Name: metadatavalue metadatavalue_metadata_field_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metadatavalue
    ADD CONSTRAINT metadatavalue_metadata_field_id_fkey FOREIGN KEY (metadata_field_id) REFERENCES public.metadatafieldregistry(metadata_field_id);


--
-- Name: most_recent_checksum most_recent_checksum_bitstream_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.most_recent_checksum
    ADD CONSTRAINT most_recent_checksum_bitstream_id_fkey FOREIGN KEY (bitstream_id) REFERENCES public.bitstream(uuid);


--
-- Name: most_recent_checksum most_recent_checksum_result_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.most_recent_checksum
    ADD CONSTRAINT most_recent_checksum_result_fkey FOREIGN KEY (result) REFERENCES public.checksum_results(result_code);


--
-- Name: requestitem requestitem_bitstream_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.requestitem
    ADD CONSTRAINT requestitem_bitstream_id_fkey FOREIGN KEY (bitstream_id) REFERENCES public.bitstream(uuid);


--
-- Name: requestitem requestitem_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.requestitem
    ADD CONSTRAINT requestitem_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(uuid);


--
-- Name: resourcepolicy resourcepolicy_dspace_object_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resourcepolicy
    ADD CONSTRAINT resourcepolicy_dspace_object_fkey FOREIGN KEY (dspace_object) REFERENCES public.dspaceobject(uuid) ON DELETE CASCADE;


--
-- Name: resourcepolicy resourcepolicy_eperson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resourcepolicy
    ADD CONSTRAINT resourcepolicy_eperson_id_fkey FOREIGN KEY (eperson_id) REFERENCES public.eperson(uuid);


--
-- Name: resourcepolicy resourcepolicy_epersongroup_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resourcepolicy
    ADD CONSTRAINT resourcepolicy_epersongroup_id_fkey FOREIGN KEY (epersongroup_id) REFERENCES public.epersongroup(uuid);


--
-- Name: site site_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.site
    ADD CONSTRAINT site_uuid_fkey FOREIGN KEY (uuid) REFERENCES public.dspaceobject(uuid);


--
-- Name: subscription subscription_collection_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscription
    ADD CONSTRAINT subscription_collection_id_fkey FOREIGN KEY (collection_id) REFERENCES public.collection(uuid);


--
-- Name: subscription subscription_eperson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscription
    ADD CONSTRAINT subscription_eperson_id_fkey FOREIGN KEY (eperson_id) REFERENCES public.eperson(uuid);


--
-- Name: tasklistitem tasklistitem_eperson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasklistitem
    ADD CONSTRAINT tasklistitem_eperson_id_fkey FOREIGN KEY (eperson_id) REFERENCES public.eperson(uuid);


--
-- Name: tasklistitem tasklistitem_workflow_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasklistitem
    ADD CONSTRAINT tasklistitem_workflow_id_fkey FOREIGN KEY (workflow_id) REFERENCES public.workflowitem(workflow_id);


--
-- Name: versionitem versionitem_eperson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.versionitem
    ADD CONSTRAINT versionitem_eperson_id_fkey FOREIGN KEY (eperson_id) REFERENCES public.eperson(uuid);


--
-- Name: versionitem versionitem_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.versionitem
    ADD CONSTRAINT versionitem_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(uuid);


--
-- Name: versionitem versionitem_versionhistory_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.versionitem
    ADD CONSTRAINT versionitem_versionhistory_id_fkey FOREIGN KEY (versionhistory_id) REFERENCES public.versionhistory(versionhistory_id);


--
-- Name: workflowitem workflowitem_collection_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workflowitem
    ADD CONSTRAINT workflowitem_collection_id_fkey FOREIGN KEY (collection_id) REFERENCES public.collection(uuid);


--
-- Name: workflowitem workflowitem_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workflowitem
    ADD CONSTRAINT workflowitem_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(uuid);


--
-- Name: workflowitem workflowitem_owner_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workflowitem
    ADD CONSTRAINT workflowitem_owner_fkey FOREIGN KEY (owner) REFERENCES public.eperson(uuid);


--
-- Name: workspaceitem workspaceitem_collection_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workspaceitem
    ADD CONSTRAINT workspaceitem_collection_id_fk FOREIGN KEY (collection_id) REFERENCES public.collection(uuid);


--
-- Name: workspaceitem workspaceitem_collection_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workspaceitem
    ADD CONSTRAINT workspaceitem_collection_id_fkey FOREIGN KEY (collection_id) REFERENCES public.collection(uuid);


--
-- Name: workspaceitem workspaceitem_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workspaceitem
    ADD CONSTRAINT workspaceitem_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(uuid);


--
-- PostgreSQL database dump complete
--

