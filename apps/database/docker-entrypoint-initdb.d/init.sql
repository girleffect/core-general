CREATE USER access_control PASSWORD 'password';
CREATE DATABASE access_control OWNER access_control;

CREATE USER authentication_service PASSWORD 'password';
CREATE DATABASE authentication_service OWNER authentication_service;

CREATE USER user_data_store PASSWORD 'password';
CREATE DATABASE user_data_store OWNER user_data_store;

CREATE USER wagtail_1 PASSWORD 'password';
CREATE DATABASE wagtail_1;

CREATE USER wagtail_2 PASSWORD 'password';
CREATE DATABASE wagtail_2;

CREATE USER data_ingestion_service PASSWORD 'password';
CREATE DATABASE data_ingestion_service;

-- Connect to database before creating extension
\c authentication_service
CREATE EXTENSION pg_trgm;
