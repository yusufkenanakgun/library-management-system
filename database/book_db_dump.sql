--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4 (Debian 17.4-1.pgdg120+2)
-- Dumped by pg_dump version 17.4 (Debian 17.4-1.pgdg120+2)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Books; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Books" (
    "Id" uuid NOT NULL,
    "Title" text NOT NULL,
    "Author" text NOT NULL,
    "Description" text NOT NULL,
    "IsAvailable" boolean NOT NULL,
    "Image" text NOT NULL
);


ALTER TABLE public."Books" OWNER TO postgres;

--
-- Name: __EFMigrationsHistory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."__EFMigrationsHistory" (
    "MigrationId" character varying(150) NOT NULL,
    "ProductVersion" character varying(32) NOT NULL
);


ALTER TABLE public."__EFMigrationsHistory" OWNER TO postgres;

--
-- Data for Name: Books; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Books" ("Id", "Title", "Author", "Description", "IsAvailable", "Image") FROM stdin;
0196a2f4-ea3d-780c-902f-28fa92a7d271	Crime and Punishment	Fyodor Dostoevsky	A psychological novel about guilt, redemption, and morality set in St. Petersburg.	f	assets/images/crime.jpg
0196a2f5-2ab8-7b06-ae47-a12e99753386	The Catcher in the Rye	J.D. Salinger	A coming-of-age story of Holden Caulfield, a teenager facing alienation and angst.	f	assets/images/catcher.jpg
0196a2f4-c814-7fc0-b0cf-33bdc087f4ff	Moby Dick	Herman Melville	The saga of Captain Ahab’s obsessive quest to avenge the whale that 'reaped' his leg.	f	assets/images/mobydick.jpg
0196a2f5-3c66-7168-ae7b-ed4eaad1d067	The Lord of the Rings	J.R.R. Tolkien	An epic fantasy trilogy about the struggle between good and evil in Middle-earth.	t	assets/images/lotr.jpg
0196a2f5-5603-7dfa-a5ca-6cf8b9efeb82	Jane Eyre	Charlotte Brontë	A gothic novel that explores themes of love, morality, and social criticism.	t	assets/images/janeeyre.jpg
0196a2f5-9982-751b-bb65-53945c087429	Frankenstein	Mary Shelley	The story of Victor Frankenstein, who creates a living creature that ultimately seeks vengeance.	t	assets/images/frankenstein.jpg
0196a2f5-87d4-7082-b22d-44125e1abd6f	The Hobbit	J.R.R. Tolkien	A fantasy adventure following Bilbo Baggins as he joins a quest to reclaim a lost dwarven kingdom.	t	assets/images/hobbit.jpg
0196a2f4-1637-76aa-802d-88b69caf6463	The Great Gatsby	F. Scott Fitzgerald	A novel about the decline of the American Dream in the 1920s.	t	assets/images/gatsby.jpg
0196a2f4-9ae2-7f98-a5e1-0db3c40cb8c9	1984	George Orwell	A dystopian novel set in a totalitarian regime that practices extreme surveillance.	f	assets/images/1984.jpg
0196a2f5-c771-79fe-86de-3422c4ecdc40	Les Misérables	Victor Hugo	A sweeping epic of love, justice, and redemption in post-revolutionary France.	t	assets/images/lesmis.jpg
0196a2f5-aaa6-7a6b-bb5f-7a959f053cb6	Dracula	Bram Stoker	A gothic horror novel introducing Count Dracula and the battle between good and evil.	t	assets/images/dracula.jpg
0196a2f4-bb0f-79ad-bddb-8d7dfb7781f7	Pride and Prejudice	Jane Austen	A romantic novel that also critiques the British landed gentry in the early 19th century.	f	assets/images/pride.jpg
0196a2f5-d8fa-778d-aa5e-de0bb4970353	War and Peace	Leo Tolstoy	A monumental novel exploring Russian society during the Napoleonic Wars.	f	assets/images/warpeace.jpg
0196a2f5-7782-7897-b5cb-ce65d6b91ba7	Animal Farm	George Orwell	A political allegory about a group of farm animals who overthrow their human farmer.	f	assets/images/animalfarm.jpg
0196a2f5-b78a-7d00-9627-1208d8b9c0cf	A Tale of Two Cities	Charles Dickens	A historical novel set during the French Revolution, centered on themes of resurrection and sacrifice.	f	assets/images/twocities.jpg
0196a2f6-01c9-703f-a9d8-2d0ce03e8e6c	The Picture of Dorian Gray	Oscar Wilde	A philosophical novel about vanity, morality, and the cost of eternal youth.	f	assets/images/dorian.jpg
0196a2f5-68cc-778e-86e3-171a5a78166d	Wuthering Heights	Emily Brontë	A tale of passion, revenge, and the destructive nature of love set on the Yorkshire moors.	t	assets/images/wuthering.jpg
0196a2f4-accb-773f-9138-ae8ba7f1f93d	To Kill a Mockingbird	Harper Lee	A novel about racial injustice in the Deep South through the eyes of a young girl.	t	assets/images/mockingbird.jpg
0196a2f5-17c1-7b90-9897-0110b36e40cf	Brave New World	Aldous Huxley	A dystopian science fiction novel exploring a society driven by technological control and superficial pleasure.	t	assets/images/bravenew.jpg
0196a2f5-e75d-7412-94e4-b5089d495eb9	Don Quixote	Miguel de Cervantes	The comedic and tragic story of a nobleman who believes he is a knight-errant.	t	assets/images/donquixote.jpg
\.


--
-- Data for Name: __EFMigrationsHistory; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."__EFMigrationsHistory" ("MigrationId", "ProductVersion") FROM stdin;
20250505232833_InitialCreate	9.0.4
\.


--
-- Name: Books PK_Books; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Books"
    ADD CONSTRAINT "PK_Books" PRIMARY KEY ("Id");


--
-- Name: __EFMigrationsHistory PK___EFMigrationsHistory; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."__EFMigrationsHistory"
    ADD CONSTRAINT "PK___EFMigrationsHistory" PRIMARY KEY ("MigrationId");


--
-- PostgreSQL database dump complete
--

