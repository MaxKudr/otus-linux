--
-- PostgreSQL database dump
--

-- Dumped from database version 12.1
-- Dumped by pg_dump version 12.1

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: analytics; Type: TABLE; Schema: public; Owner: wjs
--

CREATE TABLE public.analytics (
    key character varying(255) NOT NULL,
    "isEnabled" boolean DEFAULT false NOT NULL,
    config json NOT NULL
);


ALTER TABLE public.analytics OWNER TO wjs;

--
-- Name: assetData; Type: TABLE; Schema: public; Owner: wjs
--

CREATE TABLE public."assetData" (
    id integer NOT NULL,
    data bytea NOT NULL
);


ALTER TABLE public."assetData" OWNER TO wjs;

--
-- Name: assetFolders; Type: TABLE; Schema: public; Owner: wjs
--

CREATE TABLE public."assetFolders" (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    slug character varying(255) NOT NULL,
    "parentId" integer
);


ALTER TABLE public."assetFolders" OWNER TO wjs;

--
-- Name: assetFolders_id_seq; Type: SEQUENCE; Schema: public; Owner: wjs
--

CREATE SEQUENCE public."assetFolders_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."assetFolders_id_seq" OWNER TO wjs;

--
-- Name: assetFolders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wjs
--

ALTER SEQUENCE public."assetFolders_id_seq" OWNED BY public."assetFolders".id;


--
-- Name: assets; Type: TABLE; Schema: public; Owner: wjs
--

CREATE TABLE public.assets (
    id integer NOT NULL,
    filename character varying(255) NOT NULL,
    hash character varying(255) NOT NULL,
    ext character varying(255) NOT NULL,
    kind text DEFAULT 'binary'::text NOT NULL,
    mime character varying(255) DEFAULT 'application/octet-stream'::character varying NOT NULL,
    "fileSize" integer,
    metadata json,
    "createdAt" character varying(255) NOT NULL,
    "updatedAt" character varying(255) NOT NULL,
    "folderId" integer,
    "authorId" integer,
    CONSTRAINT assets_kind_check CHECK ((kind = ANY (ARRAY['binary'::text, 'image'::text])))
);


ALTER TABLE public.assets OWNER TO wjs;

--
-- Name: COLUMN assets."fileSize"; Type: COMMENT; Schema: public; Owner: wjs
--

COMMENT ON COLUMN public.assets."fileSize" IS 'In kilobytes';


--
-- Name: assets_id_seq; Type: SEQUENCE; Schema: public; Owner: wjs
--

CREATE SEQUENCE public.assets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.assets_id_seq OWNER TO wjs;

--
-- Name: assets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wjs
--

ALTER SEQUENCE public.assets_id_seq OWNED BY public.assets.id;


--
-- Name: authentication; Type: TABLE; Schema: public; Owner: wjs
--

CREATE TABLE public.authentication (
    key character varying(255) NOT NULL,
    "isEnabled" boolean DEFAULT false NOT NULL,
    config json NOT NULL,
    "selfRegistration" boolean DEFAULT false NOT NULL,
    "domainWhitelist" json NOT NULL,
    "autoEnrollGroups" json NOT NULL
);


ALTER TABLE public.authentication OWNER TO wjs;

--
-- Name: brute; Type: TABLE; Schema: public; Owner: wjs
--

CREATE TABLE public.brute (
    key character varying(255),
    "firstRequest" bigint,
    "lastRequest" bigint,
    lifetime bigint,
    count integer
);


ALTER TABLE public.brute OWNER TO wjs;

--
-- Name: comments; Type: TABLE; Schema: public; Owner: wjs
--

CREATE TABLE public.comments (
    id integer NOT NULL,
    content text NOT NULL,
    "createdAt" character varying(255) NOT NULL,
    "updatedAt" character varying(255) NOT NULL,
    "pageId" integer,
    "authorId" integer
);


ALTER TABLE public.comments OWNER TO wjs;

--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: wjs
--

CREATE SEQUENCE public.comments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.comments_id_seq OWNER TO wjs;

--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wjs
--

ALTER SEQUENCE public.comments_id_seq OWNED BY public.comments.id;


--
-- Name: editors; Type: TABLE; Schema: public; Owner: wjs
--

CREATE TABLE public.editors (
    key character varying(255) NOT NULL,
    "isEnabled" boolean DEFAULT false NOT NULL,
    config json NOT NULL
);


ALTER TABLE public.editors OWNER TO wjs;

--
-- Name: groups; Type: TABLE; Schema: public; Owner: wjs
--

CREATE TABLE public.groups (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    permissions json NOT NULL,
    "pageRules" json NOT NULL,
    "isSystem" boolean DEFAULT false NOT NULL,
    "createdAt" character varying(255) NOT NULL,
    "updatedAt" character varying(255) NOT NULL
);


ALTER TABLE public.groups OWNER TO wjs;

--
-- Name: groups_id_seq; Type: SEQUENCE; Schema: public; Owner: wjs
--

CREATE SEQUENCE public.groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.groups_id_seq OWNER TO wjs;

--
-- Name: groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wjs
--

ALTER SEQUENCE public.groups_id_seq OWNED BY public.groups.id;


--
-- Name: locales; Type: TABLE; Schema: public; Owner: wjs
--

CREATE TABLE public.locales (
    code character varying(5) NOT NULL,
    strings json,
    "isRTL" boolean DEFAULT false NOT NULL,
    name character varying(255) NOT NULL,
    "nativeName" character varying(255) NOT NULL,
    availability integer DEFAULT 0 NOT NULL,
    "createdAt" character varying(255) NOT NULL,
    "updatedAt" character varying(255) NOT NULL
);


ALTER TABLE public.locales OWNER TO wjs;

--
-- Name: loggers; Type: TABLE; Schema: public; Owner: wjs
--

CREATE TABLE public.loggers (
    key character varying(255) NOT NULL,
    "isEnabled" boolean DEFAULT false NOT NULL,
    level character varying(255) DEFAULT 'warn'::character varying NOT NULL,
    config json
);


ALTER TABLE public.loggers OWNER TO wjs;

--
-- Name: migrations; Type: TABLE; Schema: public; Owner: wjs
--

CREATE TABLE public.migrations (
    id integer NOT NULL,
    name character varying(255),
    batch integer,
    migration_time timestamp with time zone
);


ALTER TABLE public.migrations OWNER TO wjs;

--
-- Name: migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: wjs
--

CREATE SEQUENCE public.migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.migrations_id_seq OWNER TO wjs;

--
-- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wjs
--

ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;


--
-- Name: migrations_lock; Type: TABLE; Schema: public; Owner: wjs
--

CREATE TABLE public.migrations_lock (
    index integer NOT NULL,
    is_locked integer
);


ALTER TABLE public.migrations_lock OWNER TO wjs;

--
-- Name: migrations_lock_index_seq; Type: SEQUENCE; Schema: public; Owner: wjs
--

CREATE SEQUENCE public.migrations_lock_index_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.migrations_lock_index_seq OWNER TO wjs;

--
-- Name: migrations_lock_index_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wjs
--

ALTER SEQUENCE public.migrations_lock_index_seq OWNED BY public.migrations_lock.index;


--
-- Name: navigation; Type: TABLE; Schema: public; Owner: wjs
--

CREATE TABLE public.navigation (
    key character varying(255) NOT NULL,
    config json
);


ALTER TABLE public.navigation OWNER TO wjs;

--
-- Name: pageHistory; Type: TABLE; Schema: public; Owner: wjs
--

CREATE TABLE public."pageHistory" (
    id integer NOT NULL,
    path character varying(255) NOT NULL,
    hash character varying(255) NOT NULL,
    title character varying(255) NOT NULL,
    description character varying(255),
    "isPrivate" boolean DEFAULT false NOT NULL,
    "isPublished" boolean DEFAULT false NOT NULL,
    "publishStartDate" character varying(255),
    "publishEndDate" character varying(255),
    action character varying(255) DEFAULT 'updated'::character varying,
    "pageId" integer,
    content text,
    "contentType" character varying(255) NOT NULL,
    "createdAt" character varying(255) NOT NULL,
    "editorKey" character varying(255),
    "localeCode" character varying(5),
    "authorId" integer
);


ALTER TABLE public."pageHistory" OWNER TO wjs;

--
-- Name: pageHistoryTags; Type: TABLE; Schema: public; Owner: wjs
--

CREATE TABLE public."pageHistoryTags" (
    id integer NOT NULL,
    "pageId" integer,
    "tagId" integer
);


ALTER TABLE public."pageHistoryTags" OWNER TO wjs;

--
-- Name: pageHistoryTags_id_seq; Type: SEQUENCE; Schema: public; Owner: wjs
--

CREATE SEQUENCE public."pageHistoryTags_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."pageHistoryTags_id_seq" OWNER TO wjs;

--
-- Name: pageHistoryTags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wjs
--

ALTER SEQUENCE public."pageHistoryTags_id_seq" OWNED BY public."pageHistoryTags".id;


--
-- Name: pageHistory_id_seq; Type: SEQUENCE; Schema: public; Owner: wjs
--

CREATE SEQUENCE public."pageHistory_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."pageHistory_id_seq" OWNER TO wjs;

--
-- Name: pageHistory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wjs
--

ALTER SEQUENCE public."pageHistory_id_seq" OWNED BY public."pageHistory".id;


--
-- Name: pageLinks; Type: TABLE; Schema: public; Owner: wjs
--

CREATE TABLE public."pageLinks" (
    id integer NOT NULL,
    path character varying(255) NOT NULL,
    "localeCode" character varying(5) NOT NULL,
    "pageId" integer
);


ALTER TABLE public."pageLinks" OWNER TO wjs;

--
-- Name: pageLinks_id_seq; Type: SEQUENCE; Schema: public; Owner: wjs
--

CREATE SEQUENCE public."pageLinks_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."pageLinks_id_seq" OWNER TO wjs;

--
-- Name: pageLinks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wjs
--

ALTER SEQUENCE public."pageLinks_id_seq" OWNED BY public."pageLinks".id;


--
-- Name: pageTags; Type: TABLE; Schema: public; Owner: wjs
--

CREATE TABLE public."pageTags" (
    id integer NOT NULL,
    "pageId" integer,
    "tagId" integer
);


ALTER TABLE public."pageTags" OWNER TO wjs;

--
-- Name: pageTags_id_seq; Type: SEQUENCE; Schema: public; Owner: wjs
--

CREATE SEQUENCE public."pageTags_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."pageTags_id_seq" OWNER TO wjs;

--
-- Name: pageTags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wjs
--

ALTER SEQUENCE public."pageTags_id_seq" OWNED BY public."pageTags".id;


--
-- Name: pageTree; Type: TABLE; Schema: public; Owner: wjs
--

CREATE TABLE public."pageTree" (
    id integer NOT NULL,
    path character varying(255) NOT NULL,
    depth integer NOT NULL,
    title character varying(255) NOT NULL,
    "isPrivate" boolean DEFAULT false NOT NULL,
    "isFolder" boolean DEFAULT false NOT NULL,
    "privateNS" character varying(255),
    parent integer,
    "pageId" integer,
    "localeCode" character varying(5)
);


ALTER TABLE public."pageTree" OWNER TO wjs;

--
-- Name: pages; Type: TABLE; Schema: public; Owner: wjs
--

CREATE TABLE public.pages (
    id integer NOT NULL,
    path character varying(255) NOT NULL,
    hash character varying(255) NOT NULL,
    title character varying(255) NOT NULL,
    description character varying(255),
    "isPrivate" boolean DEFAULT false NOT NULL,
    "isPublished" boolean DEFAULT false NOT NULL,
    "privateNS" character varying(255),
    "publishStartDate" character varying(255),
    "publishEndDate" character varying(255),
    content text,
    render text,
    toc json,
    "contentType" character varying(255) NOT NULL,
    "createdAt" character varying(255) NOT NULL,
    "updatedAt" character varying(255) NOT NULL,
    "editorKey" character varying(255),
    "localeCode" character varying(5),
    "authorId" integer,
    "creatorId" integer
);


ALTER TABLE public.pages OWNER TO wjs;

--
-- Name: pages_id_seq; Type: SEQUENCE; Schema: public; Owner: wjs
--

CREATE SEQUENCE public.pages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pages_id_seq OWNER TO wjs;

--
-- Name: pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wjs
--

ALTER SEQUENCE public.pages_id_seq OWNED BY public.pages.id;


--
-- Name: renderers; Type: TABLE; Schema: public; Owner: wjs
--

CREATE TABLE public.renderers (
    key character varying(255) NOT NULL,
    "isEnabled" boolean DEFAULT false NOT NULL,
    config json
);


ALTER TABLE public.renderers OWNER TO wjs;

--
-- Name: searchEngines; Type: TABLE; Schema: public; Owner: wjs
--

CREATE TABLE public."searchEngines" (
    key character varying(255) NOT NULL,
    "isEnabled" boolean DEFAULT false NOT NULL,
    config json
);


ALTER TABLE public."searchEngines" OWNER TO wjs;

--
-- Name: sessions; Type: TABLE; Schema: public; Owner: wjs
--

CREATE TABLE public.sessions (
    sid character varying(255) NOT NULL,
    sess json NOT NULL,
    expired timestamp with time zone NOT NULL
);


ALTER TABLE public.sessions OWNER TO wjs;

--
-- Name: settings; Type: TABLE; Schema: public; Owner: wjs
--

CREATE TABLE public.settings (
    key character varying(255) NOT NULL,
    value json,
    "updatedAt" character varying(255) NOT NULL
);


ALTER TABLE public.settings OWNER TO wjs;

--
-- Name: storage; Type: TABLE; Schema: public; Owner: wjs
--

CREATE TABLE public.storage (
    key character varying(255) NOT NULL,
    "isEnabled" boolean DEFAULT false NOT NULL,
    mode character varying(255) DEFAULT 'push'::character varying NOT NULL,
    config json,
    "syncInterval" character varying(255),
    state json
);


ALTER TABLE public.storage OWNER TO wjs;

--
-- Name: tags; Type: TABLE; Schema: public; Owner: wjs
--

CREATE TABLE public.tags (
    id integer NOT NULL,
    tag character varying(255) NOT NULL,
    title character varying(255),
    "createdAt" character varying(255) NOT NULL,
    "updatedAt" character varying(255) NOT NULL
);


ALTER TABLE public.tags OWNER TO wjs;

--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: wjs
--

CREATE SEQUENCE public.tags_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tags_id_seq OWNER TO wjs;

--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wjs
--

ALTER SEQUENCE public.tags_id_seq OWNED BY public.tags.id;


--
-- Name: userGroups; Type: TABLE; Schema: public; Owner: wjs
--

CREATE TABLE public."userGroups" (
    id integer NOT NULL,
    "userId" integer,
    "groupId" integer
);


ALTER TABLE public."userGroups" OWNER TO wjs;

--
-- Name: userGroups_id_seq; Type: SEQUENCE; Schema: public; Owner: wjs
--

CREATE SEQUENCE public."userGroups_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."userGroups_id_seq" OWNER TO wjs;

--
-- Name: userGroups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wjs
--

ALTER SEQUENCE public."userGroups_id_seq" OWNED BY public."userGroups".id;


--
-- Name: userKeys; Type: TABLE; Schema: public; Owner: wjs
--

CREATE TABLE public."userKeys" (
    id integer NOT NULL,
    kind character varying(255) NOT NULL,
    token character varying(255) NOT NULL,
    "createdAt" character varying(255) NOT NULL,
    "validUntil" character varying(255) NOT NULL,
    "userId" integer
);


ALTER TABLE public."userKeys" OWNER TO wjs;

--
-- Name: userKeys_id_seq; Type: SEQUENCE; Schema: public; Owner: wjs
--

CREATE SEQUENCE public."userKeys_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."userKeys_id_seq" OWNER TO wjs;

--
-- Name: userKeys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wjs
--

ALTER SEQUENCE public."userKeys_id_seq" OWNED BY public."userKeys".id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: wjs
--

CREATE TABLE public.users (
    id integer NOT NULL,
    email character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    "providerId" character varying(255),
    password character varying(255),
    "tfaIsActive" boolean DEFAULT false NOT NULL,
    "tfaSecret" character varying(255),
    "jobTitle" character varying(255) DEFAULT ''::character varying,
    location character varying(255) DEFAULT ''::character varying,
    "pictureUrl" character varying(255),
    timezone character varying(255) DEFAULT 'America/New_York'::character varying NOT NULL,
    "isSystem" boolean DEFAULT false NOT NULL,
    "isActive" boolean DEFAULT false NOT NULL,
    "isVerified" boolean DEFAULT false NOT NULL,
    "mustChangePwd" boolean DEFAULT false NOT NULL,
    "createdAt" character varying(255) NOT NULL,
    "updatedAt" character varying(255) NOT NULL,
    "providerKey" character varying(255) DEFAULT 'local'::character varying NOT NULL,
    "localeCode" character varying(5) DEFAULT 'en'::character varying NOT NULL,
    "defaultEditor" character varying(255) DEFAULT 'markdown'::character varying NOT NULL
);


ALTER TABLE public.users OWNER TO wjs;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: wjs
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO wjs;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wjs
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: assetFolders id; Type: DEFAULT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public."assetFolders" ALTER COLUMN id SET DEFAULT nextval('public."assetFolders_id_seq"'::regclass);


--
-- Name: assets id; Type: DEFAULT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public.assets ALTER COLUMN id SET DEFAULT nextval('public.assets_id_seq'::regclass);


--
-- Name: comments id; Type: DEFAULT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public.comments ALTER COLUMN id SET DEFAULT nextval('public.comments_id_seq'::regclass);


--
-- Name: groups id; Type: DEFAULT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public.groups ALTER COLUMN id SET DEFAULT nextval('public.groups_id_seq'::regclass);


--
-- Name: migrations id; Type: DEFAULT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);


--
-- Name: migrations_lock index; Type: DEFAULT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public.migrations_lock ALTER COLUMN index SET DEFAULT nextval('public.migrations_lock_index_seq'::regclass);


--
-- Name: pageHistory id; Type: DEFAULT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public."pageHistory" ALTER COLUMN id SET DEFAULT nextval('public."pageHistory_id_seq"'::regclass);


--
-- Name: pageHistoryTags id; Type: DEFAULT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public."pageHistoryTags" ALTER COLUMN id SET DEFAULT nextval('public."pageHistoryTags_id_seq"'::regclass);


--
-- Name: pageLinks id; Type: DEFAULT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public."pageLinks" ALTER COLUMN id SET DEFAULT nextval('public."pageLinks_id_seq"'::regclass);


--
-- Name: pageTags id; Type: DEFAULT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public."pageTags" ALTER COLUMN id SET DEFAULT nextval('public."pageTags_id_seq"'::regclass);


--
-- Name: pages id; Type: DEFAULT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public.pages ALTER COLUMN id SET DEFAULT nextval('public.pages_id_seq'::regclass);


--
-- Name: tags id; Type: DEFAULT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public.tags ALTER COLUMN id SET DEFAULT nextval('public.tags_id_seq'::regclass);


--
-- Name: userGroups id; Type: DEFAULT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public."userGroups" ALTER COLUMN id SET DEFAULT nextval('public."userGroups_id_seq"'::regclass);


--
-- Name: userKeys id; Type: DEFAULT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public."userKeys" ALTER COLUMN id SET DEFAULT nextval('public."userKeys_id_seq"'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: analytics; Type: TABLE DATA; Schema: public; Owner: wjs
--

COPY public.analytics (key, "isEnabled", config) FROM stdin;
azureinsights	f	{"instrumentationKey":""}
baidutongji	f	{"propertyTrackingId":""}
countly	f	{"appKey":"","serverUrl":""}
elasticapm	f	{"serverUrl":"http://apm.example.com:8200","serviceName":"wiki-js","environment":""}
fathom	f	{"host":"","siteId":""}
fullstory	f	{"org":""}
google	f	{"propertyTrackingId":""}
gtm	f	{"containerTrackingId":""}
hotjar	f	{"siteId":""}
matomo	f	{"siteId":1,"serverHost":"https://example.matomo.cloud","scriptUrl":"//cdn.matomo.cloud/EXAMPLE.matomo.cloud/matomo.js"}
newrelic	f	{"licenseKey":"","appId":""}
statcounter	f	{"projectId":"","securityToken":""}
yandex	f	{"tagNumber":""}
\.


--
-- Data for Name: assetData; Type: TABLE DATA; Schema: public; Owner: wjs
--

COPY public."assetData" (id, data) FROM stdin;
\.


--
-- Data for Name: assetFolders; Type: TABLE DATA; Schema: public; Owner: wjs
--

COPY public."assetFolders" (id, name, slug, "parentId") FROM stdin;
\.


--
-- Data for Name: assets; Type: TABLE DATA; Schema: public; Owner: wjs
--

COPY public.assets (id, filename, hash, ext, kind, mime, "fileSize", metadata, "createdAt", "updatedAt", "folderId", "authorId") FROM stdin;
\.


--
-- Data for Name: authentication; Type: TABLE DATA; Schema: public; Owner: wjs
--

COPY public.authentication (key, "isEnabled", config, "selfRegistration", "domainWhitelist", "autoEnrollGroups") FROM stdin;
auth0	f	{"domain":"","clientId":"","clientSecret":""}	f	{"v":[]}	{"v":[]}
azure	f	{"entryPoint":"","clientId":""}	f	{"v":[]}	{"v":[]}
cas	f	{"ssoBaseURL":"","serverBaseURL":""}	f	{"v":[]}	{"v":[]}
discord	f	{"clientId":"","clientSecret":""}	f	{"v":[]}	{"v":[]}
dropbox	f	{"clientId":"","clientSecret":""}	f	{"v":[]}	{"v":[]}
facebook	f	{"clientId":"","clientSecret":""}	f	{"v":[]}	{"v":[]}
firebase	f	{}	f	{"v":[]}	{"v":[]}
github	f	{"clientId":"","clientSecret":"","useEnterprise":false,"enterpriseDomain":"","enterpriseUserEndpoint":"https://api.github.com/user"}	f	{"v":[]}	{"v":[]}
gitlab	f	{"clientId":"","clientSecret":"","baseUrl":"https://gitlab.com"}	f	{"v":[]}	{"v":[]}
google	f	{"clientId":"","clientSecret":""}	f	{"v":[]}	{"v":[]}
keycloak	f	{"host":"","realm":"","clientId":"","clientSecret":"","authorizationURL":"","userInfoURL":"","tokenURL":""}	f	{"v":[]}	{"v":[]}
ldap	f	{"url":"ldap://serverhost:389","bindDn":"cn='root'","bindCredentials":"","searchBase":"o=users,o=example.com","searchFilter":"(uid={{username}})","tlsEnabled":false,"tlsCertPath":"","mappingUID":"uid","mappingEmail":"mail","mappingDisplayName":"displayName","mappingPicture":"jpegPhoto"}	f	{"v":[]}	{"v":[]}
local	t	{}	f	{"v":[]}	{"v":[]}
microsoft	f	{"clientId":"","clientSecret":""}	f	{"v":[]}	{"v":[]}
oauth2	f	{"clientId":"","clientSecret":"","authorizationURL":"","tokenURL":""}	f	{"v":[]}	{"v":[]}
oidc	f	{"clientId":"","clientSecret":"","authorizationURL":"","tokenURL":"","issuer":"","userInfoUrl":"","emailClaim":"","usernameClaim":""}	f	{"v":[]}	{"v":[]}
okta	f	{"clientId":"","clientSecret":"","idp":"","audience":""}	f	{"v":[]}	{"v":[]}
saml	f	{"entryPoint":"","issuer":"","audience":"","cert":"","privateCert":"","decryptionPvk":"","signatureAlgorithm":"sha1","identifierFormat":"urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress","acceptedClockSkewMs":-1,"disableRequestedAuthnContext":false,"authnContext":"urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport","forceAuthn":false,"providerName":"wiki.js","skipRequestCompression":false,"authnRequestBinding":"HTTP-POST","mappingUID":"http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier","mappingEmail":"http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress","mappingDisplayName":"http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name","mappingPicture":"http://schemas.xmlsoap.org/ws/2005/05/identity/claims/picture"}	f	{"v":[]}	{"v":[]}
slack	f	{"clientId":"","clientSecret":"","team":""}	f	{"v":[]}	{"v":[]}
twitch	f	{"clientId":"","clientSecret":""}	f	{"v":[]}	{"v":[]}
\.


--
-- Data for Name: brute; Type: TABLE DATA; Schema: public; Owner: wjs
--

COPY public.brute (key, "firstRequest", "lastRequest", lifetime, count) FROM stdin;
\.


--
-- Data for Name: comments; Type: TABLE DATA; Schema: public; Owner: wjs
--

COPY public.comments (id, content, "createdAt", "updatedAt", "pageId", "authorId") FROM stdin;
\.


--
-- Data for Name: editors; Type: TABLE DATA; Schema: public; Owner: wjs
--

COPY public.editors (key, "isEnabled", config) FROM stdin;
ckeditor	f	{}
code	f	{}
markdown	t	{}
wysiwyg	f	{}
\.


--
-- Data for Name: groups; Type: TABLE DATA; Schema: public; Owner: wjs
--

COPY public.groups (id, name, permissions, "pageRules", "isSystem", "createdAt", "updatedAt") FROM stdin;
1	Administrators	["manage:system"]	[]	t	2020-01-07T17:36:47.846Z	2020-01-07T17:36:47.846Z
2	Guests	["read:pages","read:assets","read:comments"]	[{"id":"guest","roles":["read:pages","read:assets","read:comments"],"match":"START","deny":false,"path":"","locales":[]}]	t	2020-01-07T17:36:47.856Z	2020-01-07T17:36:47.856Z
\.


--
-- Data for Name: locales; Type: TABLE DATA; Schema: public; Owner: wjs
--

COPY public.locales (code, strings, "isRTL", name, "nativeName", availability, "createdAt", "updatedAt") FROM stdin;
en	{"common":{"footer":{"poweredBy":"Powered by","copyright":"© {{year}} {{company}}. All rights reserved."},"actions":{"save":"Save","cancel":"Cancel","download":"Download","upload":"Upload","discard":"Discard","clear":"Clear","create":"Create","edit":"Edit","delete":"Delete","refresh":"Refresh","saveChanges":"Save Changes","proceed":"Proceed","ok":"OK","add":"Add","apply":"Apply","browse":"Browse...","close":"Close","page":"Page","discardChanges":"Discard Changes","move":"Move","rename":"Rename","optimize":"Optimize","preview":"Preview","properties":"Properties","insert":"Insert","fetch":"Fetch"},"newpage":{"title":"This page does not exist yet.","subtitle":"Would you like to create it now?","create":"Create Page","goback":"Go back"},"unauthorized":{"title":"Unauthorized","action":{"view":"You cannot view this page.","source":"You cannot view the page source.","history":"You cannot view the page history.","edit":"You cannot edit the page.","create":"You cannot create the page."},"goback":"Go Back","login":"Login As..."},"notfound":{"gohome":"Home","title":"Not Found","subtitle":"This page does not exist."},"welcome":{"title":"Welcome to your wiki!","subtitle":"Let's get started and create the home page.","createhome":"Create Home Page"},"header":{"home":"Home","newPage":"New Page","currentPage":"Current Page","view":"View","edit":"Edit","history":"History","viewSource":"View Source","move":"Move / Rename","delete":"Delete","assets":"Assets","imagesFiles":"Images & Files","search":"Search...","admin":"Administration","account":"Account","myWiki":"My Wiki","profile":"Profile","logout":"Logout","login":"Login","searchHint":"Type at least 2 characters to start searching...","searchLoading":"Searching...","searchNoResult":"No pages matching your query.","searchResultsCount":"Found {{total}} results","searchDidYouMean":"Did you mean...","searchClose":"Close","searchCopyLink":"Copy Search Link","language":"Language","browseTags":"Browse by Tags","siteMap":"Site Map","pageActions":"Page Actions"},"page":{"lastEditedBy":"Last edited by","unpublished":"Unpublished","editPage":"Edit Page","toc":"Table of Contents","bookmark":"Bookmark","share":"Share","printFormat":"Print Format","delete":"Delete Page","deleteTitle":"Are you sure you want to delete page {{title}}?","deleteSubtitle":"The page can be restored from the administration area.","viewingSource":"Viewing source of page {{path}}","returnNormalView":"Return to Normal View","id":"ID {{id}}","published":"Published","private":"Private","global":"Global","loading":"Loading Page..."},"error":{"unexpected":"An unexpected error occurred."},"password":{"veryWeak":"Very Weak","weak":"Weak","average":"Average","strong":"Strong","veryStrong":"Very Strong"},"user":{"search":"Search User","searchPlaceholder":"Search Users..."},"duration":{"every":"Every","minutes":"Minute(s)","hours":"Hour(s)","days":"Day(s)","months":"Month(s)","years":"Year(s)"},"outdatedBrowserWarning":"Your browser is outdated. Upgrade to a {{modernBrowser}}.","modernBrowser":"modern browser"},"auth":{"loginRequired":"Login required","fields":{"emailUser":"Email / Username","password":"Password","email":"Email Address","verifyPassword":"Verify Password","name":"Name"},"actions":{"login":"Log In","register":"Register"},"errors":{"invalidLogin":"Invalid Login","invalidLoginMsg":"The email or password is invalid.","invalidUserEmail":"Invalid User Email","loginError":"Login error","notYetAuthorized":"You have not been authorized to login to this site yet.","tooManyAttempts":"Too many attempts!","tooManyAttemptsMsg":"You've made too many failed attempts in a short period of time, please try again {{time}}.","userNotFound":"User not found"},"providers":{"local":"Local","windowslive":"Microsoft Account","azure":"Azure Active Directory","google":"Google ID","facebook":"Facebook","github":"GitHub","slack":"Slack","ldap":"LDAP / Active Directory"},"tfa":{"title":"Two Factor Authentication","subtitle":"Security code required:","placeholder":"XXXXXX","verifyToken":"Verify"},"registerTitle":"Create an account","switchToLogin":{"text":"Already have an account? {{link}}","link":"Login instead"},"loginUsingStrategy":"Login using {{strategy}}","forgotPasswordLink":"Forgot your password?","orLoginUsingStrategy":"or login using...","switchToRegister":{"text":"Don't have an account yet? {{link}}","link":"Create an account"},"invalidEmailUsername":"Enter a valid email / username.","invalidPassword":"Enter a valid password.","loginSuccess":"Login Successful! Redirecting...","signingIn":"Signing In...","genericError":"Authentication is unavailable.","registerSubTitle":"Fill-in the form below to create your account.","pleaseWait":"Please wait","registerSuccess":"Account created successfully!","registering":"Creating account...","missingEmail":"Missing email address.","invalidEmail":"Email address is invalid.","missingPassword":"Missing password.","passwordTooShort":"Password is too short.","passwordNotMatch":"Both passwords do not match.","missingName":"Name is missing.","nameTooShort":"Name is too short.","nameTooLong":"Name is too long.","forgotPasswordCancel":"Cancel","sendResetPassword":"Reset Password","forgotPasswordSubtitle":"Enter your email address to receive the instructions to reset your password:","registerCheckEmail":"Check your emails to activate your account.","changePwd":{"subtitle":"Choose a new password","instructions":"You must choose a new password:","newPasswordPlaceholder":"New Password","newPasswordVerifyPlaceholder":"Verify New Password","proceed":"Change Password","loading":"Changing password..."}},"admin":{"dashboard":{"title":"Dashboard","subtitle":"Wiki.js","pages":"Pages","users":"Users","groups":"Groups","versionLatest":"You are running the latest version.","versionNew":"A new version is available: {{version}}","contributeSubtitle":"Wiki.js is a free and open source project. There are several ways you can contribute to the project.","contributeHelp":"We need your help!","contributeLearnMore":"Learn More","recentPages":"Recent Pages","mostPopularPages":"Most Popular Pages"},"general":{"title":"General","subtitle":"Main settings of your wiki","siteInfo":"Site Info","siteBranding":"Site Branding","general":"General","siteUrl":"Site URL","siteUrlHint":"Full URL to your wiki, without the trailing slash. (e.g. https://wiki.example.com)","siteTitle":"Site Title","siteTitleHint":"Displayed in the top bar and appended to all pages meta title.","logo":"Logo","uploadLogo":"Upload Logo","uploadClear":"Clear","uploadSizeHint":"An image of {{size}} pixels is recommended for best results.","uploadTypesHint":"{{typeList}} or {{lastType}} files only","footerCopyright":"Footer Copyright","companyName":"Company / Organization Name","companyNameHint":"Name to use when displaying copyright notice in the footer. Leave empty to hide.","siteDescription":"Site Description","siteDescriptionHint":"Default description when none is provided for a page.","metaRobots":"Meta Robots","metaRobotsHint":"Default: Index, Follow. Can also be set on a per-page basis.","logoUrl":"Logo URL","logoUrlHint":"Specify an image to use as the logo. SVG, PNG, JPG are supported, in a square ratio, 34x34 pixels or larger. Click the button on the right to upload a new image."},"locale":{"title":"Locale","subtitle":"Set localization options for your wiki","settings":"Locale Settings","namespacing":"Multilingual Namespacing","downloadTitle":"Download Locale","base":{"labelWithNS":"Base Locale","hint":"All UI text elements will be displayed in selected language.","label":"Site Locale"},"autoUpdate":{"label":"Update Automatically","hintWithNS":"Automatically download updates to all namespaced locales enabled below.","hint":"Automatically download updates to this locale as they become available."},"namespaces":{"label":"Multilingual Namespaces","hint":"Enables multiple language versions of the same page."},"activeNamespaces":{"label":"Active Namespaces","hint":"List of locales enabled for multilingual namespacing. The base locale defined above will always be included regardless of this selection."},"namespacingPrefixWarning":{"title":"The locale code will be prefixed to all paths. (e.g. /{{langCode}}/page-name)","subtitle":"Paths without a locale code will be automatically redirected to the base locale defined above."},"sideload":"Sideload Locale Package","sideloadHelp":"If you are not connected to the internet or cannot download locale files using the method above, you can instead sideload packages manually by uploading them below.","code":"Code","name":"Name","nativeName":"Native Name","rtl":"RTL","availability":"Availability","download":"Download"},"stats":{"title":"Statistics"},"theme":{"title":"Theme","subtitle":"Modify the look & feel of your wiki","siteTheme":"Site Theme","siteThemeHint":"Themes affect how content pages are displayed. Other site sections (such as the editor or admin area) are not affected.","darkMode":"Dark Mode","darkModeHint":"Not recommended for accessibility. May not be supported by all themes.","codeInjection":"Code Injection","cssOverride":"CSS Override","cssOverrideHint":"CSS code to inject after system default CSS. Consider using custom themes if you have a large amount of css code. Injecting too much CSS code will result in poor page load performance! CSS will automatically be minified.","headHtmlInjection":"Head HTML Injection","headHtmlInjectionHint":"HTML code to be injected just before the closing head tag. Usually for script tags.","bodyHtmlInjection":"Body HTML Injection","bodyHtmlInjectionHint":"HTML code to be injected just before the closing body tag.","downloadThemes":"Download Themes","iconset":"Icon Set","iconsetHint":"Set of icons to use for the sidebar navigation.","downloadName":"Name","downloadAuthor":"Author","downloadDownload":"Download","cssOverrideWarning":"{{caution}} When adding styles for page content, you must scope them to the {{cssClass}} class. Omitting this could break the layout of the editor!","cssOverrideWarningCaution":"CAUTION:","options":"Theme Options"},"groups":{"title":"Groups"},"users":{"title":"Users","active":"Active","inactive":"Inactive","verified":"Verified","unverified":"Unverified","edit":"Edit User","id":"ID {{id}}","basicInfo":"Basic Info","email":"Email","displayName":"Display Name","authentication":"Authentication","authProvider":"Provider","password":"Password","changePassword":"Change Password","newPassword":"New Password","tfa":"Two Factor Authentication (2FA)","toggle2FA":"Toggle 2FA","authProviderId":"Provider Id","groups":"User Groups","noGroupAssigned":"This user is not assigned to any group yet. You must assign at least 1 group to a user.","selectGroup":"Select Group...","groupAssign":"Assign","extendedMetadata":"Extended Metadata","location":"Location","jobTitle":"Job Title","timezone":"Timezone","userUpdateSuccess":"User updated successfully.","userAlreadyAssignedToGroup":"User is already assigned to this group!","deleteConfirmTitle":"Delete User?","deleteConfirmText":"Are you sure you want to delete user {{username}}?","updateUser":"Update User","groupAssignNotice":"Note that you cannot assign users to the Administrators or Guests groups from this panel.","deleteConfirmForeignNotice":"Note that you cannot delete a user that already created content. You must instead either deactivate the user or delete all content that was created by that user.","userVerifySuccess":"User has been verified successfully.","userActivateSuccess":"User has been activated successfully.","userDeactivateSuccess":"User deactivated successfully."},"auth":{"title":"Authentication","subtitle":"Configure the authentication settings of your wiki","strategies":"Strategies","globalAdvSettings":"Global Advanced Settings","jwtAudience":"JWT Audience","jwtAudienceHint":"Audience URN used in JWT issued upon login. Usually your domain name. (e.g. urn:your.domain.com)","tokenExpiration":"Token Expiration","tokenExpirationHint":"The expiration period of a token until it must be renewed. (default: 30m)","tokenRenewalPeriod":"Token Renewal Period","tokenRenewalPeriodHint":"The maximum period a token can be renewed when expired. (default: 14d)","strategyState":"This strategy is {{state}} {{locked}}","strategyStateActive":"active","strategyStateInactive":"not active","strategyStateLocked":"and cannot be disabled.","strategyConfiguration":"Strategy Configuration","strategyNoConfiguration":"This strategy has no configuration options you can modify.","registration":"Registration","selfRegistration":"Allow self-registration","selfRegistrationHint":"Allow any user successfully authorized by the strategy to access the wiki.","domainsWhitelist":"Limit to specific email domains","domainsWhitelistHint":"A list of domains authorized to register. The user email address domain must match one of these to gain access.","autoEnrollGroups":"Assign to group","autoEnrollGroupsHint":"Automatically assign new users to these groups.","security":"Security","force2fa":"Force all users to use Two-Factor Authentication (2FA)","force2faHint":"Users will be required to setup 2FA the first time they login and cannot be disabled by the user.","configReference":"Configuration Reference","configReferenceSubtitle":"Some strategies may require some configuration values to be set on your provider. These are provided for reference only and may not be needed by the current strategy.","siteUrlNotSetup":"You must set a valid {{siteUrl}} first! Click on {{general}} in the left sidebar.","allowedWebOrigins":"Allowed Web Origins","callbackUrl":"Callback URL / Redirect URI","loginUrl":"Login URL","logoutUrl":"Logout URL","tokenEndpointAuthMethod":"Token Endpoint Authentication Method","refreshSuccess":"List of strategies has been refreshed.","saveSuccess":"Authentication configuration saved successfully."},"editor":{"title":"Editor"},"logging":{"title":"Logging"},"rendering":{"title":"Rendering"},"search":{"title":"Search Engine","subtitle":"Configure the search capabilities of your wiki","rebuildIndex":"Rebuild Index","searchEngine":"Search Engine","engineConfig":"Engine Configuration","engineNoConfig":"This engine has no configuration options you can modify.","listRefreshSuccess":"List of search engines has been refreshed.","configSaveSuccess":"Search engine configuration saved successfully.","indexRebuildSuccess":"Index rebuilt successfully."},"storage":{"title":"Storage","subtitle":"Set backup and sync targets for your content","targets":"Targets","status":"Status","lastSync":"Last synchronization {{time}}","lastSyncAttempt":"Last attempt was {{time}}","errorMsg":"Error Message","noTarget":"You don't have any active storage target.","targetConfig":"Target Configuration","noConfigOption":"This storage target has no configuration options you can modify.","syncDirection":"Sync Direction","syncDirectionSubtitle":"Choose how content synchronization is handled for this storage target.","syncDirBi":"Bi-directional","syncDirPush":"Push to target","syncDirPull":"Pull from target","unsupported":"Unsupported","syncDirBiHint":"In bi-directional mode, content is first pulled from the storage target. Any newer content overwrites local content. New content since last sync is then pushed to the storage target, overwriting any content on target if present.","syncDirPushHint":"Content is always pushed to the storage target, overwriting any existing content. This is safest choice for backup scenarios.","syncDirPullHint":"Content is always pulled from the storage target, overwriting any local content which already exists. This choice is usually reserved for single-use content import. Caution with this option as any local content will always be overwritten!","syncSchedule":"Sync Schedule","syncScheduleHint":"For performance reasons, this storage target synchronize changes on an interval-based schedule, instead of on every change. Define at which interval should the synchronization occur.","syncScheduleCurrent":"Currently set to every {{schedule}}.","syncScheduleDefault":"The default is every {{schedule}}.","actions":"Actions","actionRun":"Run","targetState":"This storage target is {{state}}","targetStateActive":"active","targetStateInactive":"inactive","actionsInactiveWarn":"You must enable this storage target and apply changes before you can run actions."},"api":{"title":"API Access"},"system":{"title":"System Info","subtitle":"Information about your system","hostInfo":"Host Information","currentVersion":"Current Version","latestVersion":"Latest Version","published":"Published","os":"Operating System","hostname":"Hostname","cpuCores":"CPU Cores","totalRAM":"Total RAM","workingDirectory":"Working Directory","configFile":"Configuration File","ramUsage":"RAM Usage: {{used}} / {{total}}","dbPartialSupport":"Your database version is not fully supported. Some functionality may be limited or not work as expected.","refreshSuccess":"System Info has been refreshed."},"utilities":{"title":"Utilities","subtitle":"Maintenance and miscellaneous tools","tools":"Tools","authTitle":"Authentication","authSubtitle":"Various tools for authentication / users","cacheTitle":"Flush Cache","cacheSubtitle":"Flush cache of various components","graphEndpointTitle":"GraphQL Endpoint","graphEndpointSubtitle":"Change the GraphQL endpoint for Wiki.js","importv1Title":"Import from Wiki.js 1.x","importv1Subtitle":"Migrate data from a previous 1.x installation","telemetryTitle":"Telemetry","telemetrySubtitle":"Enable/Disable telemetry or reset the client ID","contentTitle":"Content","contentSubtitle":"Various tools for pages"},"dev":{"title":"Developer Tools","flags":{"title":"Flags"},"graphiql":{"title":"GraphiQL"},"voyager":{"title":"Voyager"}},"contribute":{"title":"Contribute to Wiki.js","subtitle":"Help support Wiki.js development and operations","fundOurWork":"Fund our work","spreadTheWord":"Spread the word","talkToFriends":"Talk to your friends and colleagues about how awesome Wiki.js is!","followUsOnTwitter":"Follow us on {{0}}.","submitAnIdea":"Submit an idea or vote on a proposed one on the {{0}}.","submitAnIdeaLink":"feature requests board","foundABug":"Found a bug? Submit an issue on {{0}}.","helpTranslate":"Help translate Wiki.js in your language. Let us know on {{0}}.","makeADonation":"Make a donation","contribute":"Contribute","openCollective":"Wiki.js is also part of the Open Collective initiative, a transparent fund that goes toward community resources. You can contribute financially by making a monthly or one-time donation:","needYourHelp":"We need your help to keep improving the software and run the various associated services (e.g. hosting and networking).","openSource":"Wiki.js is a free and open-source software brought to you with {{0}} by {{1}} and {{2}}.","openSourceContributors":"contributors","tshirts":"You can also buy Wiki.js t-shirts to support the project financially:","shop":"Wiki.js Shop","becomeAPatron":"Become a Patron","patreon":"Become a backer or sponsor via Patreon (goes directly into supporting lead developer Nicolas Giard's goal of working full-time on Wiki.js)","paypal":"Make a one-time or recurring donation via Paypal:","ethereum":"We accept donations using Ethereum:","github":"Become a sponsor via GitHub Sponsors (goes directly into supporting lead developer Nicolas Giard's goal of working full-time on Wiki.js)","becomeASponsor":"Become a Sponsor"},"nav":{"site":"Site","users":"Users","modules":"Modules","system":"System"},"pages":{"title":"Pages"},"navigation":{"title":"Navigation","subtitle":"Manage the site navigation","link":"Link","divider":"Divider","header":"Header","label":"Label","icon":"Icon","targetType":"Target Type","target":"Target","noSelectionText":"Select a navigation item on the left.","untitled":"Untitled {{kind}}","navType":{"external":"External Link","home":"Home","page":"Page","searchQuery":"Search Query"},"edit":"Edit {{kind}}","delete":"Delete {{kind}}","saveSuccess":"Navigation saved successfully.","noItemsText":"Click the Add button to add your first navigation item.","emptyList":"Navigation is empty","visibilityMode":{"all":"Visible to everyone","restricted":"Visible to select groups..."},"selectPageButton":"Select Page...","mode":"Navigation Mode","modeSiteTree":{"title":"Site Tree","description":"Classic Tree-based Navigation"},"modeCustom":{"title":"Custom Navigation","description":"Static Navigation Menu + Site Tree Button"},"modeNone":{"title":"None","description":"Disable Site Navigation"}},"mail":{"title":"Mail","subtitle":"Configure mail settings","configuration":"Configuration","dkim":"DKIM (optional)","test":"Send a test email","testRecipient":"Recipient Email Address","testSend":"Send Email","sender":"Sender","senderName":"Sender Name","senderEmail":"Sender Email","smtp":"SMTP Settings","smtpHost":"Host","smtpPort":"Port","smtpPortHint":"Usually 465 (recommended), 587 or 25.","smtpTLS":"Secure (TLS)","smtpTLSHint":"Should be enabled when using port 465, otherwise turned off (587 or 25).","smtpUser":"Username","smtpPwd":"Password","dkimHint":"DKIM (DomainKeys Identified Mail) provides a layer of security on all emails sent from Wiki.js by providing the means for recipients to validate the domain name and ensure the message authenticity.","dkimUse":"Use DKIM","dkimDomainName":"Domain Name","dkimKeySelector":"Key Selector","dkimPrivateKey":"Private Key","dkimPrivateKeyHint":"Private key for the selector in PEM format","testHint":"Send a test email to ensure your SMTP configuration is working.","saveSuccess":"Configuration saved successfully.","sendTestSuccess":"A test email was sent successfully."},"webhooks":{"title":"Webhooks","subtitle":"Manage webhooks to external services"},"adminArea":"Administration Area","analytics":{"title":"Analytics","subtitle":"Add analytics and tracking tools to your wiki","providers":"Providers","providerConfiguration":"Provider Configuration","providerNoConfiguration":"This provider has no configuration options you can modify.","refreshSuccess":"List of providers refreshed successfully.","saveSuccess":"Analytics configuration saved successfully"},"comments":{"title":"Comments"},"tags":{"title":"Tags"},"ssl":{"title":"SSL","subtitle":"Manage SSL configuration","provider":"Provider","providerHint":"Select Custom Certificate if you have your own certificate already.","domain":"Domain","domainHint":"Enter the fully qualified domain pointing to your wiki. (e.g. wiki.example.com)","providerOptions":"Provider Options","providerDisabled":"Disabled","providerLetsEncrypt":"Let's Encrypt","providerCustomCertificate":"Custom Certificate","ports":"Ports","httpPort":"HTTP Port","httpPortHint":"Non-SSL port the server will listen to for HTTP requests. Usually 80 or 3000.","httpsPort":"HTTPS Port","httpsPortHint":"SSL port the server will listen to for HTTPS requests. Usually 443.","httpPortRedirect":"Redirect HTTP requests to HTTPS","httpPortRedirectHint":"Will automatically redirect any requests on the HTTP port to HTTPS.","writableConfigFileWarning":"Note that your config file must be writable in order to persist ports configuration."}},"editor":{"page":"Page","save":{"processing":"Processing","pleaseWait":"Please wait...","createSuccess":"Page created successfully.","error":"An error occurred while creating the page","updateSuccess":"Page updated successfully."},"props":{"pageProperties":"Page Properties","pageInfo":"Page Info","title":"Title","shortDescription":"Short Description","shortDescriptionHint":"Shown below the title","pathCategorization":"Path & Categorization","locale":"Locale","path":"Path","pathHint":"Do not include any leading or trailing slashes.","tags":"Tags","tagsHint":"Use tags to categorize your pages and make them easier to find.","publishState":"Publishing State","publishToggle":"Published","publishToggleHint":"Unpublished pages can still be seen by users having write permissions on this page.","publishStart":"Publish starting on...","publishStartHint":"Leave empty for no start date","publishEnd":"Publish ending on...","publishEndHint":"Leave empty for no end date","info":"Info","scheduling":"Scheduling","social":"Social","categorization":"Categorization","socialFeatures":"Social Features","allowComments":"Allow Comments","allowCommentsHint":"Enable commenting abilities on this page.","allowRatings":"Allow Ratings","displayAuthor":"Display Author Info","displaySharingBar":"Display Sharing Toolbar","displaySharingBarHint":"Show a toolbar with buttons to share and print this page","displayAuthorHint":"Show the page author along with the last edition time.","allowRatingsHint":"Enable rating capabilities on this page.","scripts":"Scripts","js":"Javascript","css":"CSS","jsHint":"Note that scripts will not work if your administrator disabled this feature.","cssHint":"CSS will automatically be minified upon saving."},"unsaved":{"title":"Discard Unsaved Changes?","body":"You have unsaved changes. Are you sure you want to leave the editor and discard any modifications you made since the last save?"},"select":{"title":"Which editor do you want to use for this page?","cannotChange":"This cannot be changed once the page is created.","customView":"or create a custom view?"},"assets":{"title":"Assets","newFolder":"New Folder","folderName":"Folder Name","folderNameNamingRules":"Must follow the asset folder {{namingRules}}.","folderNameNamingRulesLink":"naming rules","folderEmpty":"This asset folder is empty.","fileCount":"{{count}} files","headerId":"ID","headerFilename":"Filename","headerType":"Type","headerFileSize":"File Size","headerAdded":"Added","headerActions":"Actions","uploadAssets":"Upload Assets","uploadAssetsDropZone":"Browse or Drop files here...","fetchImage":"Fetch Remote Image","imageAlign":"Image Alignment","renameAsset":"Rename Asset","renameAssetSubtitle":"Enter the new name for this asset:","deleteAsset":"Delete Asset","deleteAssetConfirm":"Are you sure you want to delete asset","deleteAssetWarn":"This action cannot be undone!","refreshSuccess":"List of assets refreshed successfully.","uploadFailed":"File upload failed.","folderCreateSuccess":"Asset folder created successfully.","renameSuccess":"Asset renamed successfully.","deleteSuccess":"Asset deleted successfully.","noUploadError":"You must choose a file to upload first!"},"backToEditor":"Back to Editor","markup":{"bold":"Bold","italic":"Italic","strikethrough":"Strikethrough","heading":"Heading {{level}}","subscript":"Subscript","superscript":"Superscript","blockquote":"Blockquote","blockquoteInfo":"Info Blockquote","blockquoteSuccess":"Success Blockquote","blockquoteWarning":"Warning Blockquote","blockquoteError":"Error Blockquote","unorderedList":"Unordered List","orderedList":"Ordered List","inlineCode":"Inline Code","keyboardKey":"Keyboard Key","horizontalBar":"Horizontal Bar","togglePreviewPane":"Hide / Show Preview Pane","insertLink":"Insert Link","insertAssets":"Insert Assets","insertBlock":"Insert Block","insertCodeBlock":"Insert Code Block","insertVideoAudio":"Insert Video / Audio","insertDiagram":"Insert Diagram","insertMathExpression":"Insert Math Expression","tableHelper":"Table Helper","distractionFreeMode":"Distraction Free Mode","markdownFormattingHelp":"Markdown Formatting Help","noSelectionError":"Text must be selected first!"}},"tags":{"currentSelection":"Current Selection","clearSelection":"Clear Selection","selectOneMoreTags":"Select one or more tags","searchWithinResultsPlaceholder":"Search within results...","locale":"Locale","orderBy":"Order By","selectOneMoreTagsHint":"Select one or more tags on the left.","retrievingResultsLoading":"Retrieving page results...","noResults":"Couldn't find any page with the selected tags.","noResultsWithFilter":"Couldn't find any page matching the current filtering options.","pageLastUpdated":"Last Updated {{date}}","orderByField":{"creationDate":"Creation Date","ID":"ID","lastModified":"Last Modified","path":"Path","title":"Title"},"localeAny":"Any"}}	f	English	English	100	2020-01-07T17:36:47.829Z	2020-01-07T17:36:56.252Z
\.


--
-- Data for Name: loggers; Type: TABLE DATA; Schema: public; Owner: wjs
--

COPY public.loggers (key, "isEnabled", level, config) FROM stdin;
airbrake	f	warn	{}
bugsnag	f	warn	{"key":""}
disk	f	info	{}
eventlog	f	warn	{}
loggly	f	warn	{"token":"","subdomain":""}
logstash	f	warn	{}
newrelic	f	warn	{}
papertrail	f	warn	{"host":"","port":0}
raygun	f	warn	{}
rollbar	f	warn	{"key":""}
sentry	f	warn	{"key":""}
syslog	f	warn	{}
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: wjs
--

COPY public.migrations (id, name, batch, migration_time) FROM stdin;
1	2.0.0.js	1	2020-01-07 17:28:55.721+00
\.


--
-- Data for Name: migrations_lock; Type: TABLE DATA; Schema: public; Owner: wjs
--

COPY public.migrations_lock (index, is_locked) FROM stdin;
1	0
\.


--
-- Data for Name: navigation; Type: TABLE DATA; Schema: public; Owner: wjs
--

COPY public.navigation (key, config) FROM stdin;
site	[{"id":"1de27bc4-ed4c-4977-a285-498209da31d8","icon":"mdi-home","kind":"link","label":"Home","target":"/","targetType":"home"}]
\.


--
-- Data for Name: pageHistory; Type: TABLE DATA; Schema: public; Owner: wjs
--

COPY public."pageHistory" (id, path, hash, title, description, "isPrivate", "isPublished", "publishStartDate", "publishEndDate", action, "pageId", content, "contentType", "createdAt", "editorKey", "localeCode", "authorId") FROM stdin;
\.


--
-- Data for Name: pageHistoryTags; Type: TABLE DATA; Schema: public; Owner: wjs
--

COPY public."pageHistoryTags" (id, "pageId", "tagId") FROM stdin;
\.


--
-- Data for Name: pageLinks; Type: TABLE DATA; Schema: public; Owner: wjs
--

COPY public."pageLinks" (id, path, "localeCode", "pageId") FROM stdin;
\.


--
-- Data for Name: pageTags; Type: TABLE DATA; Schema: public; Owner: wjs
--

COPY public."pageTags" (id, "pageId", "tagId") FROM stdin;
\.


--
-- Data for Name: pageTree; Type: TABLE DATA; Schema: public; Owner: wjs
--

COPY public."pageTree" (id, path, depth, title, "isPrivate", "isFolder", "privateNS", parent, "pageId", "localeCode") FROM stdin;
1	home	1	Hello OTUS	f	f	\N	\N	1	en
\.


--
-- Data for Name: pages; Type: TABLE DATA; Schema: public; Owner: wjs
--

COPY public.pages (id, path, hash, title, description, "isPrivate", "isPublished", "privateNS", "publishStartDate", "publishEndDate", content, render, toc, "contentType", "createdAt", "updatedAt", "editorKey", "localeCode", "authorId", "creatorId") FROM stdin;
1	home	b29b5d2ce62e55412776ab98f05631e0aa96597b	Hello OTUS		f	t	\N			# Hello\tOTUS\nTest page for NodeJS site.	<h1 id="hellootus" class="toc-header"><a class="toc-anchor" href="#hellootus">&#xB6;</a> Hello\tOTUS</h1>\n<p>Test page for NodeJS site.</p>\n	[{"title":"Hello\\tOTUS","anchor":"#hellootus","children":[]}]	markdown	2020-01-07T17:38:16.831Z	2020-01-07T17:38:20.789Z	markdown	en	1	1
\.


--
-- Data for Name: renderers; Type: TABLE DATA; Schema: public; Owner: wjs
--

COPY public.renderers (key, "isEnabled", config) FROM stdin;
htmlAsciinema	f	{}
htmlBlockquotes	t	{}
htmlCodehighlighter	t	{}
htmlCore	t	{}
htmlMathjax	f	{}
htmlMediaplayers	t	{}
htmlMermaid	f	{}
htmlPlantuml	f	{}
htmlSecurity	t	{"stripJS":false,"filterBadWords":false}
htmlTwemoji	t	{}
markdownAbbr	t	{}
markdownCore	t	{"allowHTML":true,"linkify":true,"linebreaks":true,"typographer":false,"quotes":"English"}
markdownEmoji	t	{}
markdownExpandtabs	t	{"tabWidth":4}
markdownFootnotes	t	{}
markdownImsize	t	{}
markdownMathjax	f	{}
markdownPlantuml	t	{"server":"https://www.plantuml.com/plantuml","openMarker":"@startuml","closeMarker":"@enduml","imageFormat":"svg"}
markdownSupsub	t	{"subEnabled":true,"supEnabled":true}
markdownTasklists	t	{}
\.


--
-- Data for Name: searchEngines; Type: TABLE DATA; Schema: public; Owner: wjs
--

COPY public."searchEngines" (key, "isEnabled", config) FROM stdin;
algolia	f	{"appId":"","apiKey":"","indexName":"wiki"}
aws	f	{"domain":"","endpoint":"","region":"us-east-1","accessKeyId":"","secretAccessKey":"","AnalysisSchemeLang":"en"}
azure	f	{"serviceName":"","adminKey":"","indexName":"wiki"}
db	t	{}
elasticsearch	f	{"apiVersion":"6.x","hosts":"","indexName":"wiki","sniffOnStart":false,"sniffInterval":0}
manticore	f	{}
postgres	f	{"dictLanguage":"english"}
solr	f	{"host":"solr","port":8983,"core":"wiki","protocol":"http"}
sphinx	f	{}
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: wjs
--

COPY public.sessions (sid, sess, expired) FROM stdin;
\.


--
-- Data for Name: settings; Type: TABLE DATA; Schema: public; Owner: wjs
--

COPY public.settings (key, value, "updatedAt") FROM stdin;
auth	{"audience":"urn:wiki.js","tokenExpiration":"30m","tokenRenewal":"14d"}	2020-01-07T17:36:47.155Z
certs	{"jwk":{"kty":"RSA","n":"z48NTUMrrd7F1PiFRCgzz0HWVfWdT1VJ335BsStpSCG-YH6x0QAJ9FUfj0R4pffHwU1JuUI8PBhM-TZGVrY2EI54oX4LqFxiiKa-GbslHdJiP-49kksByIXfbp_qHBffG4j_IB-JphJQYYNJ_-lymgSWxYavnuQ0Iv1gQZgE0sFSZhp_xJGN5U7SyV0loZpVR_x6tEKJGWeeam_oPMPjukliz8JdWaAsHw7hsgwUpNowUNe4zLLrbgdUoyGdzSBBKh9-LhNZSPnlxVNJLwEhuf4rApq42Mv8e7X6EsIGWgBojU5rYXVySAJkDv7viOntbov6AQsJkSaMnKN10y2-rw","e":"AQAB"},"public":"-----BEGIN RSA PUBLIC KEY-----\\nMIIBCgKCAQEAz48NTUMrrd7F1PiFRCgzz0HWVfWdT1VJ335BsStpSCG+YH6x0QAJ\\n9FUfj0R4pffHwU1JuUI8PBhM+TZGVrY2EI54oX4LqFxiiKa+GbslHdJiP+49kksB\\nyIXfbp/qHBffG4j/IB+JphJQYYNJ/+lymgSWxYavnuQ0Iv1gQZgE0sFSZhp/xJGN\\n5U7SyV0loZpVR/x6tEKJGWeeam/oPMPjukliz8JdWaAsHw7hsgwUpNowUNe4zLLr\\nbgdUoyGdzSBBKh9+LhNZSPnlxVNJLwEhuf4rApq42Mv8e7X6EsIGWgBojU5rYXVy\\nSAJkDv7viOntbov6AQsJkSaMnKN10y2+rwIDAQAB\\n-----END RSA PUBLIC KEY-----\\n","private":"-----BEGIN RSA PRIVATE KEY-----\\nProc-Type: 4,ENCRYPTED\\nDEK-Info: AES-256-CBC,8256C7D5A3F8A5F161AFF258369B5622\\n\\nxBaHQ9uiay9G61MxhaIR574cQLQDPty7ME8E5EtkbnVpYoVP0TzZcMOLQGdSciRq\\n75vVVDlsV9vBJubevswiNmaeNRpC5vRM/xnh2ET/lThQx3a8oH7FKmM2MRDdYRt8\\nT8rqp2EUGfbmv3si7Nq5aAGhbhq1j/tzM7E9DImiP/OGV+4nvPKq7yxCEOUmcQZW\\nqePW5O6qOQG8fKDcxpCjKaRsgeeeZQFSAywKzIevUQJeIiV2KYV8JONSwR5HphrD\\nAqTrIoFVE/brl+bkXsNt+3JrxPNR0J7zZV6RPycIn0fRdjcSPncp7+jv5RiFH2uQ\\nhLW7dlcZ1HjrwroL/EKF8i8OXPLPahI8ka/ooZ0St3eB8YdYhydKxdo+66NjFsA9\\nD6yiAoK25JA0qbUqYudsjhwMtpg13ASFaR+ZZ1ilYAvX6oz4XBrATpi4mKIKvGqf\\nY82eCLnrxnQwM0GOTj5pkTnudULfLL+gV4kLZo/rZMK355vEIZ7wlODtLpV0tv3v\\nwN3CE+GXD0QfBv9r6+GeJJoZwfLNgy8s2K5IJoQcqMMcDjzgCMSgHCfafhh8n21c\\nvQ7jVL9y6QDe9xvb6Rv4HMKMYyETQRJSF2f1F/YQsITRHQjcAFVxa+ZT6CtnRwYM\\nOP+F/BfPxKSoiuMNz1NU5Qbm7CujuTNIwvRxN8A977NoAclbCAw52xrE97ZhB0tu\\nLwd0f7KbxW9/uIungiSP/3JI/f+0hsCfl/UFSNZxZvtYQzYThrwsIuOmyIozSRUp\\noAFNpOcLnZi+OLQL/MoSXGlXDfl+pA+RloQA0+JWlXbpcCqxgno5R/Qou+W5+8k6\\nUpwsD5ejjoYM9a+lDEBbW/ofeZsAYIFFyohnUfYZ6REPoR78xUDMU1RJUoKu/iTd\\nQCzSfr6SWbIq79CZ+hr2NrhLWuiRxeGab7Sap4aRa6fWf4vkd4nOXpTgByP1EFim\\ndvoQ/UIWUCLjJETSJv/5RgS8XwRPrUkRqivEGCS65eruF+DzS8sRcATkGCp5uyzq\\ncrRawc8LaJE7HjpHfcdC+FXW8siqvSpC+fnIKkaUo1GQ2YzoY1GTtc6f0IKfI4TB\\nHU5tolkvBLniqsjVGa0g2aJxpQM6MloV4ODd4zXwx2bClegju2ZzZmdmuHKd0fPJ\\nRGw4AV6xrhNhCo9XMOlOdQi8wqw7J0yrmL39G4SXNZ1WuX6BiVX2adIAtcCBhaiN\\nVSYN0ky7y9vv9nb7pBh+YuOyWY8LxnJ2FUpTkeURgRM6IbvJKaKVzQssMhy6+hfG\\nGnqIeAKmImoma7WwVzfvZfX4jna0AYIrTQtGRGtw52NKzLMoV7Y1a7ll5pQXg5vO\\nt7SlXpRGZUZJVNYCwwZ6T5r6oI29STi1I2xci76jTddxJYYh3wl0BP4FmIQPdhyH\\nn02No/28BNoB2noTo2m0V1myQEn0UZDHPapI61xICYD5im9Ydu2OedY8X6z8FUKn\\nIUrjqGGTf3Pxxxrd8cvZ5DSXw8nPBUR+K8Nofk8AFwMm6ib3r4x/xihf1UoYvbQA\\nBdqdvYKlg6MbLgfJRXeLfSnvr6oltnKebCBgk2gN0apqAH8dbVfO3qolAWjTbAkA\\n-----END RSA PRIVATE KEY-----\\n"}	2020-01-07T17:36:47.237Z
company	{"v":""}	2020-01-07T17:36:47.326Z
features	{"featurePageRatings":true,"featurePageComments":true,"featurePersonalWikis":true}	2020-01-07T17:36:47.335Z
graphEndpoint	{"v":"https://graph.requarks.io"}	2020-01-07T17:36:47.343Z
host	{"v":"http://localhost"}	2020-01-07T17:36:47.351Z
lang	{"code":"en","autoUpdate":true,"namespacing":false,"namespaces":[]}	2020-01-07T17:36:47.359Z
logo	{"hasLogo":false,"logoIsSquare":false}	2020-01-07T17:36:47.367Z
mail	{"senderName":"","senderEmail":"","host":"","port":465,"secure":true,"user":"","pass":"","useDKIM":false,"dkimDomainName":"","dkimKeySelector":"","dkimPrivateKey":""}	2020-01-07T17:36:47.377Z
seo	{"description":"","robots":["index","follow"],"analyticsService":"","analyticsId":""}	2020-01-07T17:36:47.385Z
sessionSecret	{"v":"8a0101b055baebdcd9235b7471f352d39c3358f34bcf2c3f1e7dfb77bc7c8093"}	2020-01-07T17:36:47.394Z
telemetry	{"isEnabled":false,"clientId":"1ae2a488-0dc7-4bda-8ffc-6539dd2c5e3c"}	2020-01-07T17:36:47.405Z
theming	{"theme":"default","darkMode":false,"iconset":"mdi","injectCSS":"","injectHead":"","injectBody":""}	2020-01-07T17:36:47.414Z
title	{"v":"Wiki.js"}	2020-01-07T17:36:47.423Z
\.


--
-- Data for Name: storage; Type: TABLE DATA; Schema: public; Owner: wjs
--

COPY public.storage (key, "isEnabled", mode, config, "syncInterval", state) FROM stdin;
azure	f	push	{"accountName":"","accountKey":"","container":""}	P0D	{"status":"pending","message":"","lastAttempt":null}
box	f	push	{"clientId":"","clientSecret":"","rootFolder":""}	P0D	{"status":"pending","message":"","lastAttempt":null}
digitalocean	f	push	{"endpoint":"nyc3.digitaloceanspaces.com","bucket":"","accessKeyId":"","secretAccessKey":""}	P0D	{"status":"pending","message":"","lastAttempt":null}
disk	f	push	{"path":"","createDailyBackups":false}	P0D	{"status":"pending","message":"","lastAttempt":null}
dropbox	f	push	{"appKey":"","appSecret":""}	P0D	{"status":"pending","message":"","lastAttempt":null}
gdrive	f	push	{"clientId":"","clientSecret":""}	P0D	{"status":"pending","message":"","lastAttempt":null}
git	f	sync	{"authType":"ssh","repoUrl":"","branch":"master","sshPrivateKeyMode":"path","sshPrivateKeyPath":"","sshPrivateKeyContent":"","verifySSL":true,"basicUsername":"","basicPassword":"","defaultEmail":"name@company.com","defaultName":"John Smith","localRepoPath":"./data/repo","gitBinaryPath":""}	PT5M	{"status":"pending","message":"","lastAttempt":null}
onedrive	f	push	{"clientId":"","clientSecret":""}	P0D	{"status":"pending","message":"","lastAttempt":null}
s3	f	push	{"region":"","bucket":"","accessKeyId":"","secretAccessKey":""}	P0D	{"status":"pending","message":"","lastAttempt":null}
scp	f	push	{"host":"","port":22,"username":"","privateKeyPath":"","basePath":"~"}	P0D	{"status":"pending","message":"","lastAttempt":null}
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: wjs
--

COPY public.tags (id, tag, title, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: userGroups; Type: TABLE DATA; Schema: public; Owner: wjs
--

COPY public."userGroups" (id, "userId", "groupId") FROM stdin;
1	1	1
2	2	2
\.


--
-- Data for Name: userKeys; Type: TABLE DATA; Schema: public; Owner: wjs
--

COPY public."userKeys" (id, kind, token, "createdAt", "validUntil", "userId") FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: wjs
--

COPY public.users (id, email, name, "providerId", password, "tfaIsActive", "tfaSecret", "jobTitle", location, "pictureUrl", timezone, "isSystem", "isActive", "isVerified", "mustChangePwd", "createdAt", "updatedAt", "providerKey", "localeCode", "defaultEditor") FROM stdin;
1	admin@otus.local	Administrator	\N	$2a$12$UZn1H6LLGB/Bhh4pygRFa.6eEWzZRfH0oXzSkpN8UojudFMEd1GT6	f	\N			\N	America/New_York	f	t	t	f	2020-01-07T17:36:48.596Z	2020-01-07T17:36:48.596Z	local	en	markdown
2	guest@example.com	Guest	\N		f	\N			\N	America/New_York	t	t	t	f	2020-01-07T17:36:49.286Z	2020-01-07T17:36:49.286Z	local	en	markdown
\.


--
-- Name: assetFolders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wjs
--

SELECT pg_catalog.setval('public."assetFolders_id_seq"', 1, false);


--
-- Name: assets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wjs
--

SELECT pg_catalog.setval('public.assets_id_seq', 1, false);


--
-- Name: comments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wjs
--

SELECT pg_catalog.setval('public.comments_id_seq', 1, false);


--
-- Name: groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wjs
--

SELECT pg_catalog.setval('public.groups_id_seq', 2, true);


--
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wjs
--

SELECT pg_catalog.setval('public.migrations_id_seq', 1, true);


--
-- Name: migrations_lock_index_seq; Type: SEQUENCE SET; Schema: public; Owner: wjs
--

SELECT pg_catalog.setval('public.migrations_lock_index_seq', 1, true);


--
-- Name: pageHistoryTags_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wjs
--

SELECT pg_catalog.setval('public."pageHistoryTags_id_seq"', 1, false);


--
-- Name: pageHistory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wjs
--

SELECT pg_catalog.setval('public."pageHistory_id_seq"', 1, false);


--
-- Name: pageLinks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wjs
--

SELECT pg_catalog.setval('public."pageLinks_id_seq"', 1, false);


--
-- Name: pageTags_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wjs
--

SELECT pg_catalog.setval('public."pageTags_id_seq"', 1, false);


--
-- Name: pages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wjs
--

SELECT pg_catalog.setval('public.pages_id_seq', 1, true);


--
-- Name: tags_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wjs
--

SELECT pg_catalog.setval('public.tags_id_seq', 1, false);


--
-- Name: userGroups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wjs
--

SELECT pg_catalog.setval('public."userGroups_id_seq"', 2, true);


--
-- Name: userKeys_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wjs
--

SELECT pg_catalog.setval('public."userKeys_id_seq"', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wjs
--

SELECT pg_catalog.setval('public.users_id_seq', 2, true);


--
-- Name: analytics analytics_pkey; Type: CONSTRAINT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public.analytics
    ADD CONSTRAINT analytics_pkey PRIMARY KEY (key);


--
-- Name: assetData assetData_pkey; Type: CONSTRAINT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public."assetData"
    ADD CONSTRAINT "assetData_pkey" PRIMARY KEY (id);


--
-- Name: assetFolders assetFolders_pkey; Type: CONSTRAINT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public."assetFolders"
    ADD CONSTRAINT "assetFolders_pkey" PRIMARY KEY (id);


--
-- Name: assets assets_pkey; Type: CONSTRAINT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_pkey PRIMARY KEY (id);


--
-- Name: authentication authentication_pkey; Type: CONSTRAINT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public.authentication
    ADD CONSTRAINT authentication_pkey PRIMARY KEY (key);


--
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: editors editors_pkey; Type: CONSTRAINT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public.editors
    ADD CONSTRAINT editors_pkey PRIMARY KEY (key);


--
-- Name: groups groups_pkey; Type: CONSTRAINT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);


--
-- Name: locales locales_pkey; Type: CONSTRAINT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public.locales
    ADD CONSTRAINT locales_pkey PRIMARY KEY (code);


--
-- Name: loggers loggers_pkey; Type: CONSTRAINT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public.loggers
    ADD CONSTRAINT loggers_pkey PRIMARY KEY (key);


--
-- Name: migrations_lock migrations_lock_pkey; Type: CONSTRAINT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public.migrations_lock
    ADD CONSTRAINT migrations_lock_pkey PRIMARY KEY (index);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: navigation navigation_pkey; Type: CONSTRAINT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public.navigation
    ADD CONSTRAINT navigation_pkey PRIMARY KEY (key);


--
-- Name: pageHistoryTags pageHistoryTags_pkey; Type: CONSTRAINT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public."pageHistoryTags"
    ADD CONSTRAINT "pageHistoryTags_pkey" PRIMARY KEY (id);


--
-- Name: pageHistory pageHistory_pkey; Type: CONSTRAINT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public."pageHistory"
    ADD CONSTRAINT "pageHistory_pkey" PRIMARY KEY (id);


--
-- Name: pageLinks pageLinks_pkey; Type: CONSTRAINT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public."pageLinks"
    ADD CONSTRAINT "pageLinks_pkey" PRIMARY KEY (id);


--
-- Name: pageTags pageTags_pkey; Type: CONSTRAINT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public."pageTags"
    ADD CONSTRAINT "pageTags_pkey" PRIMARY KEY (id);


--
-- Name: pageTree pageTree_pkey; Type: CONSTRAINT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public."pageTree"
    ADD CONSTRAINT "pageTree_pkey" PRIMARY KEY (id);


--
-- Name: pages pages_pkey; Type: CONSTRAINT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pages_pkey PRIMARY KEY (id);


--
-- Name: renderers renderers_pkey; Type: CONSTRAINT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public.renderers
    ADD CONSTRAINT renderers_pkey PRIMARY KEY (key);


--
-- Name: searchEngines searchEngines_pkey; Type: CONSTRAINT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public."searchEngines"
    ADD CONSTRAINT "searchEngines_pkey" PRIMARY KEY (key);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (sid);


--
-- Name: settings settings_pkey; Type: CONSTRAINT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (key);


--
-- Name: storage storage_pkey; Type: CONSTRAINT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public.storage
    ADD CONSTRAINT storage_pkey PRIMARY KEY (key);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: tags tags_tag_unique; Type: CONSTRAINT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_tag_unique UNIQUE (tag);


--
-- Name: userGroups userGroups_pkey; Type: CONSTRAINT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public."userGroups"
    ADD CONSTRAINT "userGroups_pkey" PRIMARY KEY (id);


--
-- Name: userKeys userKeys_pkey; Type: CONSTRAINT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public."userKeys"
    ADD CONSTRAINT "userKeys_pkey" PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_providerkey_email_unique; Type: CONSTRAINT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_providerkey_email_unique UNIQUE ("providerKey", email);


--
-- Name: pagelinks_path_localecode_index; Type: INDEX; Schema: public; Owner: wjs
--

CREATE INDEX pagelinks_path_localecode_index ON public."pageLinks" USING btree (path, "localeCode");


--
-- Name: sessions_expired_index; Type: INDEX; Schema: public; Owner: wjs
--

CREATE INDEX sessions_expired_index ON public.sessions USING btree (expired);


--
-- Name: assetFolders assetfolders_parentid_foreign; Type: FK CONSTRAINT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public."assetFolders"
    ADD CONSTRAINT assetfolders_parentid_foreign FOREIGN KEY ("parentId") REFERENCES public."assetFolders"(id);


--
-- Name: assets assets_authorid_foreign; Type: FK CONSTRAINT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_authorid_foreign FOREIGN KEY ("authorId") REFERENCES public.users(id);


--
-- Name: assets assets_folderid_foreign; Type: FK CONSTRAINT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_folderid_foreign FOREIGN KEY ("folderId") REFERENCES public."assetFolders"(id);


--
-- Name: comments comments_authorid_foreign; Type: FK CONSTRAINT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_authorid_foreign FOREIGN KEY ("authorId") REFERENCES public.users(id);


--
-- Name: comments comments_pageid_foreign; Type: FK CONSTRAINT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pageid_foreign FOREIGN KEY ("pageId") REFERENCES public.pages(id);


--
-- Name: pageHistory pagehistory_authorid_foreign; Type: FK CONSTRAINT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public."pageHistory"
    ADD CONSTRAINT pagehistory_authorid_foreign FOREIGN KEY ("authorId") REFERENCES public.users(id);


--
-- Name: pageHistory pagehistory_editorkey_foreign; Type: FK CONSTRAINT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public."pageHistory"
    ADD CONSTRAINT pagehistory_editorkey_foreign FOREIGN KEY ("editorKey") REFERENCES public.editors(key);


--
-- Name: pageHistory pagehistory_localecode_foreign; Type: FK CONSTRAINT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public."pageHistory"
    ADD CONSTRAINT pagehistory_localecode_foreign FOREIGN KEY ("localeCode") REFERENCES public.locales(code);


--
-- Name: pageHistoryTags pagehistorytags_pageid_foreign; Type: FK CONSTRAINT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public."pageHistoryTags"
    ADD CONSTRAINT pagehistorytags_pageid_foreign FOREIGN KEY ("pageId") REFERENCES public."pageHistory"(id) ON DELETE CASCADE;


--
-- Name: pageHistoryTags pagehistorytags_tagid_foreign; Type: FK CONSTRAINT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public."pageHistoryTags"
    ADD CONSTRAINT pagehistorytags_tagid_foreign FOREIGN KEY ("tagId") REFERENCES public.tags(id) ON DELETE CASCADE;


--
-- Name: pageLinks pagelinks_pageid_foreign; Type: FK CONSTRAINT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public."pageLinks"
    ADD CONSTRAINT pagelinks_pageid_foreign FOREIGN KEY ("pageId") REFERENCES public.pages(id) ON DELETE CASCADE;


--
-- Name: pages pages_authorid_foreign; Type: FK CONSTRAINT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pages_authorid_foreign FOREIGN KEY ("authorId") REFERENCES public.users(id);


--
-- Name: pages pages_creatorid_foreign; Type: FK CONSTRAINT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pages_creatorid_foreign FOREIGN KEY ("creatorId") REFERENCES public.users(id);


--
-- Name: pages pages_editorkey_foreign; Type: FK CONSTRAINT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pages_editorkey_foreign FOREIGN KEY ("editorKey") REFERENCES public.editors(key);


--
-- Name: pages pages_localecode_foreign; Type: FK CONSTRAINT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pages_localecode_foreign FOREIGN KEY ("localeCode") REFERENCES public.locales(code);


--
-- Name: pageTags pagetags_pageid_foreign; Type: FK CONSTRAINT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public."pageTags"
    ADD CONSTRAINT pagetags_pageid_foreign FOREIGN KEY ("pageId") REFERENCES public.pages(id) ON DELETE CASCADE;


--
-- Name: pageTags pagetags_tagid_foreign; Type: FK CONSTRAINT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public."pageTags"
    ADD CONSTRAINT pagetags_tagid_foreign FOREIGN KEY ("tagId") REFERENCES public.tags(id) ON DELETE CASCADE;


--
-- Name: pageTree pagetree_localecode_foreign; Type: FK CONSTRAINT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public."pageTree"
    ADD CONSTRAINT pagetree_localecode_foreign FOREIGN KEY ("localeCode") REFERENCES public.locales(code);


--
-- Name: pageTree pagetree_pageid_foreign; Type: FK CONSTRAINT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public."pageTree"
    ADD CONSTRAINT pagetree_pageid_foreign FOREIGN KEY ("pageId") REFERENCES public.pages(id) ON DELETE CASCADE;


--
-- Name: pageTree pagetree_parent_foreign; Type: FK CONSTRAINT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public."pageTree"
    ADD CONSTRAINT pagetree_parent_foreign FOREIGN KEY (parent) REFERENCES public."pageTree"(id) ON DELETE CASCADE;


--
-- Name: userGroups usergroups_groupid_foreign; Type: FK CONSTRAINT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public."userGroups"
    ADD CONSTRAINT usergroups_groupid_foreign FOREIGN KEY ("groupId") REFERENCES public.groups(id) ON DELETE CASCADE;


--
-- Name: userGroups usergroups_userid_foreign; Type: FK CONSTRAINT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public."userGroups"
    ADD CONSTRAINT usergroups_userid_foreign FOREIGN KEY ("userId") REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: userKeys userkeys_userid_foreign; Type: FK CONSTRAINT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public."userKeys"
    ADD CONSTRAINT userkeys_userid_foreign FOREIGN KEY ("userId") REFERENCES public.users(id);


--
-- Name: users users_defaulteditor_foreign; Type: FK CONSTRAINT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_defaulteditor_foreign FOREIGN KEY ("defaultEditor") REFERENCES public.editors(key);


--
-- Name: users users_localecode_foreign; Type: FK CONSTRAINT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_localecode_foreign FOREIGN KEY ("localeCode") REFERENCES public.locales(code);


--
-- Name: users users_providerkey_foreign; Type: FK CONSTRAINT; Schema: public; Owner: wjs
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_providerkey_foreign FOREIGN KEY ("providerKey") REFERENCES public.authentication(key);


--
-- PostgreSQL database dump complete
--

