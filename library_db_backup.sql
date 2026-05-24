--
-- PostgreSQL database dump
--

\restrict vglq5aAdoOZqUq5Ds4camZ2IHaNJPqZB25BQyaFBoxRRT7aG9k004AHaceIsfrT

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

-- Started on 2026-05-24 20:23:18

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
-- TOC entry 241 (class 1255 OID 16573)
-- Name: get_employee_salary(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_employee_salary(emp_id integer) RETURNS TABLE(last_name character varying, salary numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT e.last_name, e.salary
    FROM employees e
    WHERE e.employee_id = emp_id;
END;
$$;


ALTER FUNCTION public.get_employee_salary(emp_id integer) OWNER TO postgres;

--
-- TOC entry 238 (class 1255 OID 16502)
-- Name: set_due_date(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.set_due_date() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.due_date IS NULL THEN
        NEW.due_date := NEW.loan_date + INTERVAL '14 days';
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.set_due_date() OWNER TO postgres;

--
-- TOC entry 239 (class 1255 OID 16504)
-- Name: update_available_copies_borrow(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_available_copies_borrow() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE books 
    SET available_copies = available_copies - 1 
    WHERE book_id = NEW.book_id;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_available_copies_borrow() OWNER TO postgres;

--
-- TOC entry 240 (class 1255 OID 16506)
-- Name: update_available_copies_return(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_available_copies_return() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.return_date IS NOT NULL AND OLD.return_date IS NULL THEN
        UPDATE books 
        SET available_copies = available_copies + 1 
        WHERE book_id = NEW.book_id;
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_available_copies_return() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 222 (class 1259 OID 16399)
-- Name: authors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.authors (
    author_id integer NOT NULL,
    name character varying(100) NOT NULL,
    birth_year integer,
    nationality character varying(50)
);


ALTER TABLE public.authors OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16398)
-- Name: authors_author_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.authors_author_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.authors_author_id_seq OWNER TO postgres;

--
-- TOC entry 5101 (class 0 OID 0)
-- Dependencies: 221
-- Name: authors_author_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.authors_author_id_seq OWNED BY public.authors.author_id;


--
-- TOC entry 227 (class 1259 OID 16440)
-- Name: book_authors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.book_authors (
    book_id integer NOT NULL,
    author_id integer NOT NULL
);


ALTER TABLE public.book_authors OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16422)
-- Name: books; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.books (
    book_id integer NOT NULL,
    title character varying(255) NOT NULL,
    isbn character(13),
    publication_year integer,
    publisher_id integer,
    total_copies integer DEFAULT 1,
    available_copies integer DEFAULT 1,
    CONSTRAINT books_check CHECK ((available_copies <= total_copies))
);


ALTER TABLE public.books OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16421)
-- Name: books_book_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.books_book_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.books_book_id_seq OWNER TO postgres;

--
-- TOC entry 5102 (class 0 OID 0)
-- Dependencies: 225
-- Name: books_book_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.books_book_id_seq OWNED BY public.books.book_id;


--
-- TOC entry 232 (class 1259 OID 16508)
-- Name: departments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.departments (
    department_id integer NOT NULL,
    department_name character varying(100) NOT NULL,
    manager_id integer,
    location_id integer
);


ALTER TABLE public.departments OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 16515)
-- Name: employees; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employees (
    employee_id integer NOT NULL,
    first_name character varying(50),
    last_name character varying(50),
    email character varying(100),
    phone_number character varying(20),
    hire_date date,
    job_id character varying(20),
    salary numeric(10,2),
    manager_id integer,
    department_id integer
);


ALTER TABLE public.employees OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 16480)
-- Name: fines; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fines (
    fine_id integer NOT NULL,
    loan_id integer NOT NULL,
    amount numeric(5,2),
    paid_status boolean DEFAULT false,
    paid_date date
);


ALTER TABLE public.fines OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 16479)
-- Name: fines_fine_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.fines_fine_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.fines_fine_id_seq OWNER TO postgres;

--
-- TOC entry 5103 (class 0 OID 0)
-- Dependencies: 230
-- Name: fines_fine_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.fines_fine_id_seq OWNED BY public.fines.fine_id;


--
-- TOC entry 237 (class 1259 OID 16574)
-- Name: job_grades; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.job_grades (
    grade_level character varying(2) NOT NULL,
    lowest_salary integer NOT NULL,
    highest_salary integer NOT NULL
);


ALTER TABLE public.job_grades OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 16521)
-- Name: job_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.job_history (
    employee_id integer,
    start_date date,
    end_date date,
    job_id character varying(20),
    department_id integer
);


ALTER TABLE public.job_history OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 16524)
-- Name: jobs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.jobs (
    job_id character varying(20) NOT NULL,
    job_title character varying(50),
    min_salary integer,
    max_salary integer
);


ALTER TABLE public.jobs OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16458)
-- Name: loans; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.loans (
    loan_id integer NOT NULL,
    book_id integer NOT NULL,
    member_id integer NOT NULL,
    loan_date date DEFAULT CURRENT_DATE,
    due_date date,
    return_date date,
    status character varying(20) DEFAULT 'BORROWED'::character varying
);


ALTER TABLE public.loans OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16457)
-- Name: loans_loan_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.loans_loan_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.loans_loan_id_seq OWNER TO postgres;

--
-- TOC entry 5104 (class 0 OID 0)
-- Dependencies: 228
-- Name: loans_loan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.loans_loan_id_seq OWNED BY public.loans.loan_id;


--
-- TOC entry 236 (class 1259 OID 16530)
-- Name: locations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.locations (
    location_id integer NOT NULL,
    street_address character varying(100),
    postal_code character varying(20),
    city character varying(50),
    state_province character varying(50),
    country_id character(2)
);


ALTER TABLE public.locations OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16408)
-- Name: members; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.members (
    member_id integer NOT NULL,
    full_name character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    phone character varying(20),
    join_date date DEFAULT CURRENT_DATE,
    membership_status character varying(20) DEFAULT 'ACTIVE'::character varying
);


ALTER TABLE public.members OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16407)
-- Name: members_member_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.members_member_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.members_member_id_seq OWNER TO postgres;

--
-- TOC entry 5105 (class 0 OID 0)
-- Dependencies: 223
-- Name: members_member_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.members_member_id_seq OWNED BY public.members.member_id;


--
-- TOC entry 220 (class 1259 OID 16388)
-- Name: publishers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.publishers (
    publisher_id integer NOT NULL,
    name character varying(100) NOT NULL,
    address text,
    phone character varying(20),
    email character varying(100)
);


ALTER TABLE public.publishers OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16387)
-- Name: publishers_publisher_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.publishers_publisher_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.publishers_publisher_id_seq OWNER TO postgres;

--
-- TOC entry 5106 (class 0 OID 0)
-- Dependencies: 219
-- Name: publishers_publisher_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.publishers_publisher_id_seq OWNED BY public.publishers.publisher_id;


--
-- TOC entry 4872 (class 2604 OID 16402)
-- Name: authors author_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authors ALTER COLUMN author_id SET DEFAULT nextval('public.authors_author_id_seq'::regclass);


--
-- TOC entry 4876 (class 2604 OID 16425)
-- Name: books book_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.books ALTER COLUMN book_id SET DEFAULT nextval('public.books_book_id_seq'::regclass);


--
-- TOC entry 4882 (class 2604 OID 16483)
-- Name: fines fine_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fines ALTER COLUMN fine_id SET DEFAULT nextval('public.fines_fine_id_seq'::regclass);


--
-- TOC entry 4879 (class 2604 OID 16461)
-- Name: loans loan_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loans ALTER COLUMN loan_id SET DEFAULT nextval('public.loans_loan_id_seq'::regclass);


--
-- TOC entry 4873 (class 2604 OID 16411)
-- Name: members member_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.members ALTER COLUMN member_id SET DEFAULT nextval('public.members_member_id_seq'::regclass);


--
-- TOC entry 4871 (class 2604 OID 16391)
-- Name: publishers publisher_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publishers ALTER COLUMN publisher_id SET DEFAULT nextval('public.publishers_publisher_id_seq'::regclass);


--
-- TOC entry 5080 (class 0 OID 16399)
-- Dependencies: 222
-- Data for Name: authors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.authors (author_id, name, birth_year, nationality) FROM stdin;
1	Robert C. Martin	1952	American
2	Joshua Bloch	1961	American
3	Martin Fowler	1963	British
4	Erich Gamma	1961	Swiss
5	Kent Beck	1961	American
6	Eric Evans	1962	American
\.


--
-- TOC entry 5085 (class 0 OID 16440)
-- Dependencies: 227
-- Data for Name: book_authors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.book_authors (book_id, author_id) FROM stdin;
1	1
2	2
3	3
4	4
5	5
6	6
7	1
7	3
\.


--
-- TOC entry 5084 (class 0 OID 16422)
-- Dependencies: 226
-- Data for Name: books; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.books (book_id, title, isbn, publication_year, publisher_id, total_copies, available_copies) FROM stdin;
6	Domain-Driven Design: Tackling Complexity in the Heart of Software	9780321125217	2003	1	3	3
7	The Pragmatic Programmer	9780201616224	1999	3	4	4
8	Introduction to Algorithms	9780262033848	2009	4	2	2
2	Effective Java	9780134685991	2017	3	3	2
3	Refactoring: Improving the Design of Existing Code	9780201485677	1999	3	4	3
5	Test-Driven Development: By Example	9780321146533	2002	3	2	1
1	Clean Code: A Handbook of Agile Software Craftsmanship	9780132350884	2008	3	5	5
4	Design Patterns: Elements of Reusable Object-Oriented Software	9780201633610	1994	1	3	3
\.


--
-- TOC entry 5090 (class 0 OID 16508)
-- Dependencies: 232
-- Data for Name: departments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.departments (department_id, department_name, manager_id, location_id) FROM stdin;
10	Administration	200	1700
20	Marketing	201	1800
50	Shipping	124	1500
60	IT	103	1400
80	Sales	149	2500
90	Executive	100	1700
110	Accounting	205	1700
100	Finance	108	1700
\.


--
-- TOC entry 5091 (class 0 OID 16515)
-- Dependencies: 233
-- Data for Name: employees; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employees (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, manager_id, department_id) FROM stdin;
101	Neena	Kochhar	neena.kochhar@company.com	\N	\N	\N	17000.00	\N	90
102	Lex	De Haan	lex.dehaan@company.com	\N	\N	\N	17000.00	\N	90
103	Alexander	Hunold	alexander.hunold@company.com	\N	\N	\N	9000.00	\N	60
104	Bruce	Ernst	bruce.ernst@company.com	\N	\N	\N	6000.00	\N	60
105	David	Austin	david.austin@company.com	\N	\N	\N	4800.00	\N	60
106	Valli	Pataballa	valli.pataballa@company.com	\N	\N	\N	4800.00	\N	60
107	Diana	Lorentz	diana.lorentz@company.com	\N	\N	\N	4200.00	\N	60
108	Nancy	Greenberg	nancy.greenberg@company.com	\N	\N	\N	12000.00	\N	110
109	Daniel	Faviet	daniel.faviet@company.com	\N	\N	\N	9000.00	\N	110
100	Steven	King	steven.king@company.com	\N	\N	\N	24000.00	\N	90
\.


--
-- TOC entry 5089 (class 0 OID 16480)
-- Dependencies: 231
-- Data for Name: fines; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fines (fine_id, loan_id, amount, paid_status, paid_date) FROM stdin;
1	5	3.00	t	2024-01-26
2	4	419.50	f	\N
\.


--
-- TOC entry 5095 (class 0 OID 16574)
-- Dependencies: 237
-- Data for Name: job_grades; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.job_grades (grade_level, lowest_salary, highest_salary) FROM stdin;
A	1000	2999
B	3000	5999
C	6000	9999
D	10000	14999
E	15000	24999
F	25000	40000
\.


--
-- TOC entry 5092 (class 0 OID 16521)
-- Dependencies: 234
-- Data for Name: job_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.job_history (employee_id, start_date, end_date, job_id, department_id) FROM stdin;
101	1997-09-21	2001-10-27	AC_ACCOUNT	110
101	2001-10-28	2005-03-15	AC_MGR	110
102	2001-01-13	2006-07-24	IT_PROG	60
103	1999-03-03	2004-02-22	MK_REP	20
\.


--
-- TOC entry 5093 (class 0 OID 16524)
-- Dependencies: 235
-- Data for Name: jobs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.jobs (job_id, job_title, min_salary, max_salary) FROM stdin;
AC_ACCOUNT	Public Accountant	4200	9000
AC_MGR	Accounting Manager	8200	16000
IT_PROG	Programmer	4000	10000
MK_REP	Marketing Representative	4000	9000
AD_PRES	President	20080	40000
AD_VP	Administration Vice President	15000	30000
AD_ASST	Administration Assistant	3000	6000
SA_MAN	Sales Manager	10000	20080
SA_REP	Sales Representative	6000	12008
MK_MAN	Marketing Manager	9000	15000
\.


--
-- TOC entry 5087 (class 0 OID 16458)
-- Dependencies: 229
-- Data for Name: loans; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.loans (loan_id, book_id, member_id, loan_date, due_date, return_date, status) FROM stdin;
1	1	1	2024-01-10	2024-01-24	2024-01-20	RETURNED
2	2	2	2024-01-15	2024-01-29	2024-01-28	RETURNED
3	3	3	2024-01-20	2024-02-03	\N	BORROWED
5	5	5	2024-01-05	2024-01-19	2024-01-25	RETURNED
6	1	5	2026-05-13	2026-05-27	2026-05-13	RETURNED
7	4	1	2026-05-24	2026-06-07	\N	BORROWED
4	4	4	2024-01-22	2024-02-05	2026-05-24	RETURNED
\.


--
-- TOC entry 5094 (class 0 OID 16530)
-- Dependencies: 236
-- Data for Name: locations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.locations (location_id, street_address, postal_code, city, state_province, country_id) FROM stdin;
1700	2004 Charade Rd	98199	Seattle	Washington	US
1800	147 Spadina Ave	M5V 2L7	Toronto	Ontario	CA
1500	2011 Interiors Blvd	99236	South San Francisco	California	US
1400	2014 Jabberwocky Rd	26192	Southlake	Texas	US
2500	Magdalene Centre	OX9 9ZB	Oxford	Oxford	UK
\.


--
-- TOC entry 5082 (class 0 OID 16408)
-- Dependencies: 224
-- Data for Name: members; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.members (member_id, full_name, email, phone, join_date, membership_status) FROM stdin;
1	John Smith	john.smith@email.com	555-0101	2023-01-15	ACTIVE
2	Emma Johnson	emma.j@email.com	555-0102	2023-02-20	ACTIVE
3	Michael Brown	michael.brown@email.com	555-0103	2023-03-10	ACTIVE
4	Sarah Davis	sarah.davis@email.com	555-0104	2023-04-05	ACTIVE
5	James Wilson	james.w@email.com	555-0105	2023-05-12	ACTIVE
\.


--
-- TOC entry 5078 (class 0 OID 16388)
-- Dependencies: 220
-- Data for Name: publishers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.publishers (publisher_id, name, address, phone, email) FROM stdin;
1	Penguin Random House	1745 Broadway, New York, NY 10019	212-782-9000	contact@penguinrandomhouse.com
2	HarperCollins	195 Broadway, New York, NY 10007	212-207-7000	info@harpercollins.com
3	O'Reilly Media	1005 Gravenstein Highway North, Sebastopol, CA 95472	707-827-7000	info@oreilly.com
4	Simon & Schuster	1230 Avenue of the Americas, New York, NY 10020	212-698-7000	publicity@simonandschuster.com
5	Wiley	111 River Street, Hoboken, NJ 07030	201-748-6000	customer@wiley.com
\.


--
-- TOC entry 5107 (class 0 OID 0)
-- Dependencies: 221
-- Name: authors_author_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.authors_author_id_seq', 6, true);


--
-- TOC entry 5108 (class 0 OID 0)
-- Dependencies: 225
-- Name: books_book_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.books_book_id_seq', 8, true);


--
-- TOC entry 5109 (class 0 OID 0)
-- Dependencies: 230
-- Name: fines_fine_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.fines_fine_id_seq', 2, true);


--
-- TOC entry 5110 (class 0 OID 0)
-- Dependencies: 228
-- Name: loans_loan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.loans_loan_id_seq', 7, true);


--
-- TOC entry 5111 (class 0 OID 0)
-- Dependencies: 223
-- Name: members_member_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.members_member_id_seq', 5, true);


--
-- TOC entry 5112 (class 0 OID 0)
-- Dependencies: 219
-- Name: publishers_publisher_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.publishers_publisher_id_seq', 5, true);


--
-- TOC entry 4888 (class 2606 OID 16406)
-- Name: authors authors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authors
    ADD CONSTRAINT authors_pkey PRIMARY KEY (author_id);


--
-- TOC entry 4901 (class 2606 OID 16446)
-- Name: book_authors book_authors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.book_authors
    ADD CONSTRAINT book_authors_pkey PRIMARY KEY (book_id, author_id);


--
-- TOC entry 4895 (class 2606 OID 16434)
-- Name: books books_isbn_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT books_isbn_key UNIQUE (isbn);


--
-- TOC entry 4897 (class 2606 OID 16432)
-- Name: books books_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT books_pkey PRIMARY KEY (book_id);


--
-- TOC entry 4912 (class 2606 OID 16514)
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (department_id);


--
-- TOC entry 4914 (class 2606 OID 16520)
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (employee_id);


--
-- TOC entry 4908 (class 2606 OID 16490)
-- Name: fines fines_loan_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fines
    ADD CONSTRAINT fines_loan_id_key UNIQUE (loan_id);


--
-- TOC entry 4910 (class 2606 OID 16488)
-- Name: fines fines_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fines
    ADD CONSTRAINT fines_pkey PRIMARY KEY (fine_id);


--
-- TOC entry 4920 (class 2606 OID 16581)
-- Name: job_grades job_grades_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_grades
    ADD CONSTRAINT job_grades_pkey PRIMARY KEY (grade_level);


--
-- TOC entry 4916 (class 2606 OID 16529)
-- Name: jobs jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_pkey PRIMARY KEY (job_id);


--
-- TOC entry 4906 (class 2606 OID 16468)
-- Name: loans loans_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loans
    ADD CONSTRAINT loans_pkey PRIMARY KEY (loan_id);


--
-- TOC entry 4918 (class 2606 OID 16535)
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (location_id);


--
-- TOC entry 4891 (class 2606 OID 16420)
-- Name: members members_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.members
    ADD CONSTRAINT members_email_key UNIQUE (email);


--
-- TOC entry 4893 (class 2606 OID 16418)
-- Name: members members_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.members
    ADD CONSTRAINT members_pkey PRIMARY KEY (member_id);


--
-- TOC entry 4886 (class 2606 OID 16397)
-- Name: publishers publishers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publishers
    ADD CONSTRAINT publishers_pkey PRIMARY KEY (publisher_id);


--
-- TOC entry 4898 (class 1259 OID 16497)
-- Name: idx_books_isbn; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_books_isbn ON public.books USING btree (isbn);


--
-- TOC entry 4899 (class 1259 OID 16496)
-- Name: idx_books_title; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_books_title ON public.books USING btree (title);


--
-- TOC entry 4902 (class 1259 OID 16500)
-- Name: idx_loans_book_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_loans_book_id ON public.loans USING btree (book_id);


--
-- TOC entry 4903 (class 1259 OID 16499)
-- Name: idx_loans_member_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_loans_member_id ON public.loans USING btree (member_id);


--
-- TOC entry 4904 (class 1259 OID 16501)
-- Name: idx_loans_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_loans_status ON public.loans USING btree (status);


--
-- TOC entry 4889 (class 1259 OID 16498)
-- Name: idx_members_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_members_email ON public.members USING btree (email);


--
-- TOC entry 4927 (class 2620 OID 16503)
-- Name: loans trigger_set_due_date; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_set_due_date BEFORE INSERT ON public.loans FOR EACH ROW EXECUTE FUNCTION public.set_due_date();


--
-- TOC entry 4928 (class 2620 OID 16505)
-- Name: loans trigger_update_copies_borrow; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_update_copies_borrow AFTER INSERT ON public.loans FOR EACH ROW EXECUTE FUNCTION public.update_available_copies_borrow();


--
-- TOC entry 4929 (class 2620 OID 16507)
-- Name: loans trigger_update_copies_return; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_update_copies_return AFTER UPDATE ON public.loans FOR EACH ROW EXECUTE FUNCTION public.update_available_copies_return();


--
-- TOC entry 4922 (class 2606 OID 16452)
-- Name: book_authors book_authors_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.book_authors
    ADD CONSTRAINT book_authors_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.authors(author_id) ON DELETE CASCADE;


--
-- TOC entry 4923 (class 2606 OID 16447)
-- Name: book_authors book_authors_book_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.book_authors
    ADD CONSTRAINT book_authors_book_id_fkey FOREIGN KEY (book_id) REFERENCES public.books(book_id) ON DELETE CASCADE;


--
-- TOC entry 4921 (class 2606 OID 16435)
-- Name: books books_publisher_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT books_publisher_id_fkey FOREIGN KEY (publisher_id) REFERENCES public.publishers(publisher_id);


--
-- TOC entry 4926 (class 2606 OID 16491)
-- Name: fines fines_loan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fines
    ADD CONSTRAINT fines_loan_id_fkey FOREIGN KEY (loan_id) REFERENCES public.loans(loan_id);


--
-- TOC entry 4924 (class 2606 OID 16469)
-- Name: loans loans_book_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loans
    ADD CONSTRAINT loans_book_id_fkey FOREIGN KEY (book_id) REFERENCES public.books(book_id);


--
-- TOC entry 4925 (class 2606 OID 16474)
-- Name: loans loans_member_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loans
    ADD CONSTRAINT loans_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(member_id);


-- Completed on 2026-05-24 20:23:19

--
-- PostgreSQL database dump complete
--

\unrestrict vglq5aAdoOZqUq5Ds4camZ2IHaNJPqZB25BQyaFBoxRRT7aG9k004AHaceIsfrT

