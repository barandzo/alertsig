--
-- PostgreSQL database dump
--

\restrict XJCDMvFrrSrWdgcSfcDddncpLO5HZhtwK26fV1nSMsfQn7d9IpVXoEqlcgJ6x9c

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.6

-- Started on 2026-02-24 23:52:41

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 10 (class 2615 OID 17472)
-- Name: topology; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA topology;


ALTER SCHEMA topology OWNER TO postgres;

--
-- TOC entry 6194 (class 0 OID 0)
-- Dependencies: 10
-- Name: SCHEMA topology; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA topology IS 'PostGIS Topology schema';


--
-- TOC entry 5 (class 3079 OID 17653)
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- TOC entry 6195 (class 0 OID 0)
-- Dependencies: 5
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- TOC entry 2 (class 3079 OID 16394)
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- TOC entry 6196 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry and geography spatial types and functions';


--
-- TOC entry 3 (class 3079 OID 17473)
-- Name: postgis_topology; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis_topology WITH SCHEMA topology;


--
-- TOC entry 6197 (class 0 OID 0)
-- Dependencies: 3
-- Name: EXTENSION postgis_topology; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_topology IS 'PostGIS topology spatial types and functions';


--
-- TOC entry 4 (class 3079 OID 17642)
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- TOC entry 6198 (class 0 OID 0)
-- Dependencies: 4
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 242 (class 1259 OID 17863)
-- Name: alertes_zones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alertes_zones (
    id bigint NOT NULL,
    zone_id integer,
    centre_alerte public.geometry(Point,4326),
    rayon_metres integer DEFAULT 1000,
    nb_incidents integer NOT NULL,
    message text NOT NULL,
    niveau character varying(10) DEFAULT 'warning'::character varying NOT NULL,
    est_lue boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone,
    CONSTRAINT alertes_zones_niveau_check CHECK (((niveau)::text = ANY ((ARRAY['info'::character varying, 'warning'::character varying, 'critical'::character varying])::text[])))
);


ALTER TABLE public.alertes_zones OWNER TO postgres;

--
-- TOC entry 6199 (class 0 OID 0)
-- Dependencies: 242
-- Name: TABLE alertes_zones; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.alertes_zones IS 'Alertes générées automatiquement quand le seuil d''incidents dans une zone est dépassé';


--
-- TOC entry 241 (class 1259 OID 17862)
-- Name: alertes_zones_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.alertes_zones_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.alertes_zones_id_seq OWNER TO postgres;

--
-- TOC entry 6200 (class 0 OID 0)
-- Dependencies: 241
-- Name: alertes_zones_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.alertes_zones_id_seq OWNED BY public.alertes_zones.id;


--
-- TOC entry 244 (class 1259 OID 17886)
-- Name: commentaires_incidents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.commentaires_incidents (
    id bigint NOT NULL,
    incident_id uuid NOT NULL,
    user_id uuid NOT NULL,
    contenu text NOT NULL,
    est_public boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.commentaires_incidents OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 17885)
-- Name: commentaires_incidents_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.commentaires_incidents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.commentaires_incidents_id_seq OWNER TO postgres;

--
-- TOC entry 6201 (class 0 OID 0)
-- Dependencies: 243
-- Name: commentaires_incidents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.commentaires_incidents_id_seq OWNED BY public.commentaires_incidents.id;


--
-- TOC entry 246 (class 1259 OID 17908)
-- Name: historique_statuts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.historique_statuts (
    id bigint NOT NULL,
    incident_id uuid NOT NULL,
    statut_avant character varying(20),
    statut_apres character varying(20) NOT NULL,
    change_par uuid NOT NULL,
    commentaire text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.historique_statuts OWNER TO postgres;

--
-- TOC entry 6202 (class 0 OID 0)
-- Dependencies: 246
-- Name: TABLE historique_statuts; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.historique_statuts IS 'Journal de toutes les transitions de statut d''un incident (audit trail)';


--
-- TOC entry 245 (class 1259 OID 17907)
-- Name: historique_statuts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.historique_statuts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.historique_statuts_id_seq OWNER TO postgres;

--
-- TOC entry 6203 (class 0 OID 0)
-- Dependencies: 245
-- Name: historique_statuts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.historique_statuts_id_seq OWNED BY public.historique_statuts.id;


--
-- TOC entry 236 (class 1259 OID 17773)
-- Name: incidents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.incidents (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    type_id integer NOT NULL,
    severite smallint DEFAULT 2 NOT NULL,
    titre character varying(200),
    description text,
    "position" public.geometry(Point,4326) NOT NULL,
    adresse text,
    quartier character varying(100),
    ville character varying(100) DEFAULT 'Lomé'::character varying NOT NULL,
    pays character varying(100) DEFAULT 'Togo'::character varying NOT NULL,
    precision_gps numeric(8,2),
    statut character varying(20) DEFAULT 'nouveau'::character varying NOT NULL,
    signale_par uuid NOT NULL,
    pris_en_charge_par uuid,
    photos text[],
    nb_confirmations integer DEFAULT 0 NOT NULL,
    nb_infirmations integer DEFAULT 0 NOT NULL,
    score_confiance numeric(5,2) GENERATED ALWAYS AS (
CASE
    WHEN ((nb_confirmations + nb_infirmations) = 0) THEN (50)::numeric
    ELSE (((nb_confirmations)::numeric / ((nb_confirmations + nb_infirmations))::numeric) * (100)::numeric)
END) STORED,
    est_zone_critique boolean DEFAULT false NOT NULL,
    nb_incidents_proches integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    resolu_at timestamp with time zone,
    expire_at timestamp with time zone,
    CONSTRAINT incidents_severite_check CHECK ((severite = ANY (ARRAY[1, 2, 3]))),
    CONSTRAINT incidents_statut_check CHECK (((statut)::text = ANY ((ARRAY['nouveau'::character varying, 'en_cours'::character varying, 'resolu'::character varying, 'rejete'::character varying, 'archive'::character varying])::text[])))
);


ALTER TABLE public.incidents OWNER TO postgres;

--
-- TOC entry 6204 (class 0 OID 0)
-- Dependencies: 236
-- Name: TABLE incidents; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.incidents IS 'Table principale des signalements d''incidents géolocalisés';


--
-- TOC entry 6205 (class 0 OID 0)
-- Dependencies: 236
-- Name: COLUMN incidents."position"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.incidents."position" IS 'POINT WGS84 (SRID 4326) — coordonnées GPS du signalement. Utilisé pour toutes les requêtes spatiales PostGIS.';


--
-- TOC entry 6206 (class 0 OID 0)
-- Dependencies: 236
-- Name: COLUMN incidents.score_confiance; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.incidents.score_confiance IS 'Calculé automatiquement : % de confirmations parmi les votes. Colonne générée.';


--
-- TOC entry 6207 (class 0 OID 0)
-- Dependencies: 236
-- Name: COLUMN incidents.est_zone_critique; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.incidents.est_zone_critique IS 'Mis à TRUE par trigger si ≥ N incidents actifs dans un rayon de 1km.';


--
-- TOC entry 249 (class 1259 OID 17948)
-- Name: notifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notifications (
    id bigint NOT NULL,
    user_id uuid NOT NULL,
    type character varying(50) NOT NULL,
    titre text NOT NULL,
    message text NOT NULL,
    data_json jsonb,
    est_lue boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.notifications OWNER TO postgres;

--
-- TOC entry 248 (class 1259 OID 17947)
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.notifications_id_seq OWNER TO postgres;

--
-- TOC entry 6208 (class 0 OID 0)
-- Dependencies: 248
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;


--
-- TOC entry 247 (class 1259 OID 17928)
-- Name: sessions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sessions (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    user_id uuid NOT NULL,
    refresh_token text NOT NULL,
    ip_address inet,
    user_agent text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone DEFAULT (now() + '30 days'::interval) NOT NULL,
    revoked_at timestamp with time zone
);


ALTER TABLE public.sessions OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 17759)
-- Name: type_incident; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.type_incident (
    id integer NOT NULL,
    code character varying(30) NOT NULL,
    libelle character varying(100) NOT NULL,
    emoji character varying(10) NOT NULL,
    couleur_hex character varying(7) DEFAULT '#FF3B3B'::character varying NOT NULL,
    icone_url text,
    seuil_zone_critique integer DEFAULT 3 NOT NULL,
    est_actif boolean DEFAULT true NOT NULL,
    ordre integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.type_incident OWNER TO postgres;

--
-- TOC entry 6209 (class 0 OID 0)
-- Dependencies: 235
-- Name: TABLE type_incident; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.type_incident IS 'Référentiel paramétrable des types d''incidents';


--
-- TOC entry 234 (class 1259 OID 17758)
-- Name: type_incident_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.type_incident_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.type_incident_id_seq OWNER TO postgres;

--
-- TOC entry 6210 (class 0 OID 0)
-- Dependencies: 234
-- Name: type_incident_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.type_incident_id_seq OWNED BY public.type_incident.id;


--
-- TOC entry 233 (class 1259 OID 17734)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    email character varying(255) NOT NULL,
    password_hash text NOT NULL,
    nom character varying(100),
    prenom character varying(100),
    telephone character varying(20),
    role character varying(20) DEFAULT 'citoyen'::character varying NOT NULL,
    est_verifie boolean DEFAULT false NOT NULL,
    token_verif text,
    avatar_url text,
    derniere_position public.geometry(Point,4326),
    score_fiabilite integer DEFAULT 100 NOT NULL,
    nb_signalements integer DEFAULT 0 NOT NULL,
    nb_confirmations integer DEFAULT 0 NOT NULL,
    nb_faux_positifs integer DEFAULT 0 NOT NULL,
    est_banni boolean DEFAULT false NOT NULL,
    raison_bannissement text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    last_login_at timestamp with time zone,
    CONSTRAINT users_role_check CHECK (((role)::text = ANY ((ARRAY['citoyen'::character varying, 'admin'::character varying, 'superviseur'::character varying])::text[]))),
    CONSTRAINT users_score_fiabilite_check CHECK (((score_fiabilite >= 0) AND (score_fiabilite <= 500)))
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 6211 (class 0 OID 0)
-- Dependencies: 233
-- Name: TABLE users; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.users IS 'Utilisateurs de la plateforme AlertSIG (citoyens + admins)';


--
-- TOC entry 6212 (class 0 OID 0)
-- Dependencies: 233
-- Name: COLUMN users.derniere_position; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.users.derniere_position IS 'Géométrie POINT WGS84 (SRID 4326) — position GPS optionnelle';


--
-- TOC entry 6213 (class 0 OID 0)
-- Dependencies: 233
-- Name: COLUMN users.score_fiabilite; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.users.score_fiabilite IS 'Score de fiabilité de 0 à 500. Augmente si ses signalements sont confirmés, diminue si faux positifs.';


--
-- TOC entry 238 (class 1259 OID 17815)
-- Name: votes_incidents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.votes_incidents (
    id bigint NOT NULL,
    incident_id uuid NOT NULL,
    user_id uuid NOT NULL,
    type_vote character varying(10) NOT NULL,
    commentaire text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT votes_incidents_type_vote_check CHECK (((type_vote)::text = ANY ((ARRAY['confirme'::character varying, 'infirme'::character varying])::text[])))
);


ALTER TABLE public.votes_incidents OWNER TO postgres;

--
-- TOC entry 6214 (class 0 OID 0)
-- Dependencies: 238
-- Name: TABLE votes_incidents; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.votes_incidents IS 'Vote citoyen pour confirmer ou infirmer un incident signalé';


--
-- TOC entry 237 (class 1259 OID 17814)
-- Name: votes_incidents_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.votes_incidents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.votes_incidents_id_seq OWNER TO postgres;

--
-- TOC entry 6215 (class 0 OID 0)
-- Dependencies: 237
-- Name: votes_incidents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.votes_incidents_id_seq OWNED BY public.votes_incidents.id;


--
-- TOC entry 240 (class 1259 OID 17840)
-- Name: zones_surveillance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.zones_surveillance (
    id integer NOT NULL,
    nom character varying(150) NOT NULL,
    description text,
    geom public.geometry(Geometry,4326) NOT NULL,
    type_zone character varying(30) DEFAULT 'quartier'::character varying NOT NULL,
    seuil_alerte integer DEFAULT 3 NOT NULL,
    couleur_hex character varying(7) DEFAULT '#FF7A00'::character varying,
    opacite numeric(3,2) DEFAULT 0.15,
    est_active boolean DEFAULT true NOT NULL,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT zones_surveillance_type_zone_check CHECK (((type_zone)::text = ANY ((ARRAY['quartier'::character varying, 'commune'::character varying, 'district'::character varying, 'perimetre_custom'::character varying, 'zone_risque'::character varying])::text[])))
);


ALTER TABLE public.zones_surveillance OWNER TO postgres;

--
-- TOC entry 6216 (class 0 OID 0)
-- Dependencies: 240
-- Name: TABLE zones_surveillance; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.zones_surveillance IS 'Zones géographiques (polygones) pour surveiller la densité d''incidents. Utilisées pour les alertes automatiques.';


--
-- TOC entry 239 (class 1259 OID 17839)
-- Name: zones_surveillance_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.zones_surveillance_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.zones_surveillance_id_seq OWNER TO postgres;

--
-- TOC entry 6217 (class 0 OID 0)
-- Dependencies: 239
-- Name: zones_surveillance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.zones_surveillance_id_seq OWNED BY public.zones_surveillance.id;


--
-- TOC entry 5927 (class 2604 OID 17866)
-- Name: alertes_zones id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alertes_zones ALTER COLUMN id SET DEFAULT nextval('public.alertes_zones_id_seq'::regclass);


--
-- TOC entry 5932 (class 2604 OID 17889)
-- Name: commentaires_incidents id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.commentaires_incidents ALTER COLUMN id SET DEFAULT nextval('public.commentaires_incidents_id_seq'::regclass);


--
-- TOC entry 5935 (class 2604 OID 17911)
-- Name: historique_statuts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historique_statuts ALTER COLUMN id SET DEFAULT nextval('public.historique_statuts_id_seq'::regclass);


--
-- TOC entry 5940 (class 2604 OID 17951)
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);


--
-- TOC entry 5901 (class 2604 OID 17762)
-- Name: type_incident id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.type_incident ALTER COLUMN id SET DEFAULT nextval('public.type_incident_id_seq'::regclass);


--
-- TOC entry 5918 (class 2604 OID 17818)
-- Name: votes_incidents id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.votes_incidents ALTER COLUMN id SET DEFAULT nextval('public.votes_incidents_id_seq'::regclass);


--
-- TOC entry 5920 (class 2604 OID 17843)
-- Name: zones_surveillance id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.zones_surveillance ALTER COLUMN id SET DEFAULT nextval('public.zones_surveillance_id_seq'::regclass);


--
-- TOC entry 6181 (class 0 OID 17863)
-- Dependencies: 242
-- Data for Name: alertes_zones; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alertes_zones (id, zone_id, centre_alerte, rayon_metres, nb_incidents, message, niveau, est_lue, created_at, expires_at) FROM stdin;
\.


--
-- TOC entry 6183 (class 0 OID 17886)
-- Dependencies: 244
-- Data for Name: commentaires_incidents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.commentaires_incidents (id, incident_id, user_id, contenu, est_public, created_at) FROM stdin;
\.


--
-- TOC entry 6185 (class 0 OID 17908)
-- Dependencies: 246
-- Data for Name: historique_statuts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.historique_statuts (id, incident_id, statut_avant, statut_apres, change_par, commentaire, created_at) FROM stdin;
\.


--
-- TOC entry 6175 (class 0 OID 17773)
-- Dependencies: 236
-- Data for Name: incidents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.incidents (id, type_id, severite, titre, description, "position", adresse, quartier, ville, pays, precision_gps, statut, signale_par, pris_en_charge_par, photos, nb_confirmations, nb_infirmations, est_zone_critique, nb_incidents_proches, created_at, updated_at, resolu_at, expire_at) FROM stdin;
\.


--
-- TOC entry 6188 (class 0 OID 17948)
-- Dependencies: 249
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notifications (id, user_id, type, titre, message, data_json, est_lue, created_at) FROM stdin;
\.


--
-- TOC entry 6186 (class 0 OID 17928)
-- Dependencies: 247
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sessions (id, user_id, refresh_token, ip_address, user_agent, created_at, expires_at, revoked_at) FROM stdin;
\.


--
-- TOC entry 5884 (class 0 OID 16716)
-- Dependencies: 223
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) FROM stdin;
\.


--
-- TOC entry 6174 (class 0 OID 17759)
-- Dependencies: 235
-- Data for Name: type_incident; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.type_incident (id, code, libelle, emoji, couleur_hex, icone_url, seuil_zone_critique, est_actif, ordre) FROM stdin;
1	INCENDIE	Incendie	🔥	#FF3B3B	\N	2	t	1
2	INONDATION	Inondation	💧	#3B82F6	\N	3	t	2
3	BRAQUAGE	Braquage / Agression	🚨	#FF3B3B	\N	2	t	3
4	ACCIDENT	Accident de la route	🚗	#FF7A00	\N	3	t	4
5	EFFONDREMENT	Effondrement	🏗️	#F59E0B	\N	2	t	5
6	MANIFESTATION	Manifestation	📣	#8B5CF6	\N	4	t	6
7	PANNE_ELECTRO	Panne électrique	⚡	#FCD34D	\N	5	t	7
8	AUTRE	Autre incident	⚠️	#6B7280	\N	5	t	8
\.


--
-- TOC entry 6172 (class 0 OID 17734)
-- Dependencies: 233
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, email, password_hash, nom, prenom, telephone, role, est_verifie, token_verif, avatar_url, derniere_position, score_fiabilite, nb_signalements, nb_confirmations, nb_faux_positifs, est_banni, raison_bannissement, created_at, updated_at, last_login_at) FROM stdin;
\.


--
-- TOC entry 6177 (class 0 OID 17815)
-- Dependencies: 238
-- Data for Name: votes_incidents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.votes_incidents (id, incident_id, user_id, type_vote, commentaire, created_at) FROM stdin;
\.


--
-- TOC entry 6179 (class 0 OID 17840)
-- Dependencies: 240
-- Data for Name: zones_surveillance; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.zones_surveillance (id, nom, description, geom, type_zone, seuil_alerte, couleur_hex, opacite, est_active, created_by, created_at) FROM stdin;
\.


--
-- TOC entry 5886 (class 0 OID 17475)
-- Dependencies: 228
-- Data for Name: topology; Type: TABLE DATA; Schema: topology; Owner: postgres
--

COPY topology.topology (id, name, srid, "precision", hasz) FROM stdin;
\.


--
-- TOC entry 5887 (class 0 OID 17487)
-- Dependencies: 229
-- Data for Name: layer; Type: TABLE DATA; Schema: topology; Owner: postgres
--

COPY topology.layer (topology_id, layer_id, schema_name, table_name, feature_column, feature_type, level, child_id) FROM stdin;
\.


--
-- TOC entry 6218 (class 0 OID 0)
-- Dependencies: 241
-- Name: alertes_zones_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.alertes_zones_id_seq', 1, false);


--
-- TOC entry 6219 (class 0 OID 0)
-- Dependencies: 243
-- Name: commentaires_incidents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.commentaires_incidents_id_seq', 1, false);


--
-- TOC entry 6220 (class 0 OID 0)
-- Dependencies: 245
-- Name: historique_statuts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.historique_statuts_id_seq', 1, false);


--
-- TOC entry 6221 (class 0 OID 0)
-- Dependencies: 248
-- Name: notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notifications_id_seq', 1, false);


--
-- TOC entry 6222 (class 0 OID 0)
-- Dependencies: 234
-- Name: type_incident_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.type_incident_id_seq', 8, true);


--
-- TOC entry 6223 (class 0 OID 0)
-- Dependencies: 237
-- Name: votes_incidents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.votes_incidents_id_seq', 1, false);


--
-- TOC entry 6224 (class 0 OID 0)
-- Dependencies: 239
-- Name: zones_surveillance_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.zones_surveillance_id_seq', 1, false);


--
-- TOC entry 6225 (class 0 OID 0)
-- Dependencies: 227
-- Name: topology_id_seq; Type: SEQUENCE SET; Schema: topology; Owner: postgres
--

SELECT pg_catalog.setval('topology.topology_id_seq', 1, false);


--
-- TOC entry 5990 (class 2606 OID 17875)
-- Name: alertes_zones alertes_zones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alertes_zones
    ADD CONSTRAINT alertes_zones_pkey PRIMARY KEY (id);


--
-- TOC entry 5995 (class 2606 OID 17895)
-- Name: commentaires_incidents commentaires_incidents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.commentaires_incidents
    ADD CONSTRAINT commentaires_incidents_pkey PRIMARY KEY (id);


--
-- TOC entry 5998 (class 2606 OID 17916)
-- Name: historique_statuts historique_statuts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historique_statuts
    ADD CONSTRAINT historique_statuts_pkey PRIMARY KEY (id);


--
-- TOC entry 5978 (class 2606 OID 17793)
-- Name: incidents incidents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incidents
    ADD CONSTRAINT incidents_pkey PRIMARY KEY (id);


--
-- TOC entry 6008 (class 2606 OID 17957)
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- TOC entry 6003 (class 2606 OID 17937)
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- TOC entry 6005 (class 2606 OID 17939)
-- Name: sessions sessions_refresh_token_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_refresh_token_key UNIQUE (refresh_token);


--
-- TOC entry 5969 (class 2606 OID 17772)
-- Name: type_incident type_incident_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.type_incident
    ADD CONSTRAINT type_incident_code_key UNIQUE (code);


--
-- TOC entry 5971 (class 2606 OID 17770)
-- Name: type_incident type_incident_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.type_incident
    ADD CONSTRAINT type_incident_pkey PRIMARY KEY (id);


--
-- TOC entry 5965 (class 2606 OID 17754)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 5967 (class 2606 OID 17752)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 5982 (class 2606 OID 17826)
-- Name: votes_incidents votes_incidents_incident_id_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.votes_incidents
    ADD CONSTRAINT votes_incidents_incident_id_user_id_key UNIQUE (incident_id, user_id);


--
-- TOC entry 5984 (class 2606 OID 17824)
-- Name: votes_incidents votes_incidents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.votes_incidents
    ADD CONSTRAINT votes_incidents_pkey PRIMARY KEY (id);


--
-- TOC entry 5988 (class 2606 OID 17854)
-- Name: zones_surveillance zones_surveillance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.zones_surveillance
    ADD CONSTRAINT zones_surveillance_pkey PRIMARY KEY (id);


--
-- TOC entry 5991 (class 1259 OID 17883)
-- Name: idx_alertes_centre; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_alertes_centre ON public.alertes_zones USING gist (centre_alerte);


--
-- TOC entry 5992 (class 1259 OID 17884)
-- Name: idx_alertes_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_alertes_date ON public.alertes_zones USING btree (created_at DESC);


--
-- TOC entry 5993 (class 1259 OID 17882)
-- Name: idx_alertes_zone; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_alertes_zone ON public.alertes_zones USING btree (zone_id);


--
-- TOC entry 5996 (class 1259 OID 17906)
-- Name: idx_comments_incident; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_comments_incident ON public.commentaires_incidents USING btree (incident_id);


--
-- TOC entry 5999 (class 1259 OID 17927)
-- Name: idx_historique_incident; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_historique_incident ON public.historique_statuts USING btree (incident_id);


--
-- TOC entry 5972 (class 1259 OID 17813)
-- Name: idx_incidents_fts; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_incidents_fts ON public.incidents USING gin (to_tsvector('french'::regconfig, ((COALESCE(description, ''::text) || ' '::text) || (COALESCE(titre, ''::character varying))::text)));


--
-- TOC entry 5973 (class 1259 OID 17809)
-- Name: idx_incidents_position; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_incidents_position ON public.incidents USING gist ("position");


--
-- TOC entry 5974 (class 1259 OID 17810)
-- Name: idx_incidents_statut_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_incidents_statut_date ON public.incidents USING btree (statut, created_at DESC);


--
-- TOC entry 5975 (class 1259 OID 17811)
-- Name: idx_incidents_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_incidents_type ON public.incidents USING btree (type_id);


--
-- TOC entry 5976 (class 1259 OID 17812)
-- Name: idx_incidents_zone_statut; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_incidents_zone_statut ON public.incidents USING gist ("position") WHERE ((statut)::text <> ALL ((ARRAY['resolu'::character varying, 'rejete'::character varying, 'archive'::character varying])::text[]));


--
-- TOC entry 6006 (class 1259 OID 17963)
-- Name: idx_notif_user_lue; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_notif_user_lue ON public.notifications USING btree (user_id, est_lue, created_at DESC);


--
-- TOC entry 6000 (class 1259 OID 17946)
-- Name: idx_sessions_token; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_sessions_token ON public.sessions USING btree (refresh_token);


--
-- TOC entry 6001 (class 1259 OID 17945)
-- Name: idx_sessions_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_sessions_user ON public.sessions USING btree (user_id);


--
-- TOC entry 5961 (class 1259 OID 17756)
-- Name: idx_users_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_email ON public.users USING btree (email);


--
-- TOC entry 5962 (class 1259 OID 17755)
-- Name: idx_users_position; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_position ON public.users USING gist (derniere_position);


--
-- TOC entry 5963 (class 1259 OID 17757)
-- Name: idx_users_role; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_role ON public.users USING btree (role);


--
-- TOC entry 5979 (class 1259 OID 17837)
-- Name: idx_votes_incident; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_votes_incident ON public.votes_incidents USING btree (incident_id);


--
-- TOC entry 5980 (class 1259 OID 17838)
-- Name: idx_votes_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_votes_user ON public.votes_incidents USING btree (user_id);


--
-- TOC entry 5985 (class 1259 OID 17860)
-- Name: idx_zones_geom; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_zones_geom ON public.zones_surveillance USING gist (geom);


--
-- TOC entry 5986 (class 1259 OID 17861)
-- Name: idx_zones_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_zones_type ON public.zones_surveillance USING btree (type_zone);


--
-- TOC entry 6015 (class 2606 OID 17876)
-- Name: alertes_zones alertes_zones_zone_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alertes_zones
    ADD CONSTRAINT alertes_zones_zone_id_fkey FOREIGN KEY (zone_id) REFERENCES public.zones_surveillance(id);


--
-- TOC entry 6016 (class 2606 OID 17896)
-- Name: commentaires_incidents commentaires_incidents_incident_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.commentaires_incidents
    ADD CONSTRAINT commentaires_incidents_incident_id_fkey FOREIGN KEY (incident_id) REFERENCES public.incidents(id) ON DELETE CASCADE;


--
-- TOC entry 6017 (class 2606 OID 17901)
-- Name: commentaires_incidents commentaires_incidents_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.commentaires_incidents
    ADD CONSTRAINT commentaires_incidents_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 6018 (class 2606 OID 17922)
-- Name: historique_statuts historique_statuts_change_par_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historique_statuts
    ADD CONSTRAINT historique_statuts_change_par_fkey FOREIGN KEY (change_par) REFERENCES public.users(id);


--
-- TOC entry 6019 (class 2606 OID 17917)
-- Name: historique_statuts historique_statuts_incident_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historique_statuts
    ADD CONSTRAINT historique_statuts_incident_id_fkey FOREIGN KEY (incident_id) REFERENCES public.incidents(id) ON DELETE CASCADE;


--
-- TOC entry 6009 (class 2606 OID 17804)
-- Name: incidents incidents_pris_en_charge_par_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incidents
    ADD CONSTRAINT incidents_pris_en_charge_par_fkey FOREIGN KEY (pris_en_charge_par) REFERENCES public.users(id);


--
-- TOC entry 6010 (class 2606 OID 17799)
-- Name: incidents incidents_signale_par_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incidents
    ADD CONSTRAINT incidents_signale_par_fkey FOREIGN KEY (signale_par) REFERENCES public.users(id);


--
-- TOC entry 6011 (class 2606 OID 17794)
-- Name: incidents incidents_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incidents
    ADD CONSTRAINT incidents_type_id_fkey FOREIGN KEY (type_id) REFERENCES public.type_incident(id);


--
-- TOC entry 6021 (class 2606 OID 17958)
-- Name: notifications notifications_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 6020 (class 2606 OID 17940)
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 6012 (class 2606 OID 17827)
-- Name: votes_incidents votes_incidents_incident_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.votes_incidents
    ADD CONSTRAINT votes_incidents_incident_id_fkey FOREIGN KEY (incident_id) REFERENCES public.incidents(id) ON DELETE CASCADE;


--
-- TOC entry 6013 (class 2606 OID 17832)
-- Name: votes_incidents votes_incidents_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.votes_incidents
    ADD CONSTRAINT votes_incidents_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 6014 (class 2606 OID 17855)
-- Name: zones_surveillance zones_surveillance_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.zones_surveillance
    ADD CONSTRAINT zones_surveillance_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


-- Completed on 2026-02-24 23:52:43

--
-- PostgreSQL database dump complete
--

\unrestrict XJCDMvFrrSrWdgcSfcDddncpLO5HZhtwK26fV1nSMsfQn7d9IpVXoEqlcgJ6x9c

