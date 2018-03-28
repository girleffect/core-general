--
-- This is an example of how to query data from multiple
-- databases and agreggate the results.
--
-- This script will create a new database called
-- "migration_investigation" into which the remote tables
-- will be mapped and where the results will be stored.
--
-- Run as user 'postgres'

DROP DATABASE IF EXISTS migration_investigation;
CREATE DATABASE migration_investigation;

\c migration_investigation

CREATE EXTENSION postgres_fdw;

-- Create a server entry for each remote database,
-- followed by a user mapping of the current user
-- to the remote user and finally a foreign table
-- that maps to the auth_user table residing on that server.

-- English database

CREATE SERVER springster_en FOREIGN DATA WRAPPER postgres_fdw
OPTIONS (host 'localhost', dbname 'gemmoloar', port '5432');

CREATE USER MAPPING FOR postgres SERVER springster_en
OPTIONS (user 'gemmoloar', password 'password');

CREATE FOREIGN TABLE en_auth_user (
    id integer NOT NULL,
    password character varying(128),
    last_login timestamp with time zone,
    is_superuser boolean NOT NULL,
    username character varying(150) NOT NULL,
    first_name character varying(30) NOT NULL,
    last_name character varying(30) NOT NULL,
    email character varying(254) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    date_joined timestamp with time zone NOT NULL
) SERVER springster_en OPTIONS (table_name 'auth_user');

-- Afrikaans database

CREATE SERVER springster_af FOREIGN DATA WRAPPER postgres_fdw
OPTIONS (host 'localhost', dbname 'gemmoloar2', port '5432');

CREATE USER MAPPING FOR postgres SERVER springster_af
OPTIONS (user 'gemmoloar2', password 'password2');

CREATE FOREIGN TABLE af_auth_user (
    id integer NOT NULL,
    password character varying(128),
    last_login timestamp with time zone,
    is_superuser boolean NOT NULL,
    username character varying(150) NOT NULL,
    first_name character varying(30) NOT NULL,
    last_name character varying(30) NOT NULL,
    email character varying(254) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    date_joined timestamp with time zone NOT NULL
) SERVER springster_af OPTIONS (table_name 'auth_user');

-- Query the remote tables, concatenate and store results

CREATE TABLE results AS
WITH all_usernames AS (
    SELECT username, 'en_auth_user' AS source FROM en_auth_user
    UNION
    SELECT username, 'af_auth_user' AS source FROM af_auth_user
)
SELECT username,
       COUNT(*) AS occurences,
       array_agg(DISTINCT source) AS sources
  FROM all_usernames
 GROUP BY username;

-- Display ordered results of duplicate usernames

SELECT username, occurences, sources
  FROM results
 WHERE occurences > 1
 ORDER BY 2 DESC, 1 ASC -- occurences desc, username asc
 LIMIT 30;


-- Display histogram
SELECT occurences, COUNT(*) AS number_of_usernames
       --, repeat('■', COUNT(*)::int) AS bar
  FROM results
 GROUP BY occurences
 ORDER BY occurences ASC;
