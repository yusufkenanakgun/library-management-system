-- Create yuread_books_db if not exists
SELECT 'CREATE DATABASE yuread_books_db'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'yuread_books_db');
\gexec

-- Create yuread_auth_db if not exists
SELECT 'CREATE DATABASE yuread_auth_db'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'yuread_auth_db');
\gexec

-- Create yuread_borrow_db if not exists
SELECT 'CREATE DATABASE yuread_borrow_db'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'yuread_borrow_db');
\gexec

-- Create yuread_favorite_db if not exists
SELECT 'CREATE DATABASE yuread_favorite_db'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'yuread_favorite_db');
\gexec

-- Create yuread_reservation_db if not exists
SELECT 'CREATE DATABASE yuread_reservation_db'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'yuread_reservation_db');
\gexec
