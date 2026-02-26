/* ----------------------------------------------------------
   DS687 DATA SCIENCE CAPSTONE
   JAN MCCONNELL
----------------------------------------------------------- */

/* ==========================================================
   DATABASE REVIEW
   Purpose:
     Quickly inspect structure, content, and metadata for all
     tables in imdb_data.db.

   Includes:
     • Drop unused tables (dummy)
     • List all tables
     • View schemas
     • Row counts
     • Index list
     • Sample data previews
     • Distinct values for key fields
========================================================== */

/* ----------------------------------------------------------
   00. DROP UNUSED TABLES
----------------------------------------------------------- */

DROP TABLE IF EXISTS dummy;

/* ----------------------------------------------------------
   01. LIST ALL TABLES
----------------------------------------------------------- */

SELECT name AS table_name
FROM sqlite_master
WHERE type = 'table'
ORDER BY name;

/* ----------------------------------------------------------
   02. TABLE SCHEMAS (PRAGMA)
   Run the PRAGMA lines manually as needed
   when inspection is needed (does not need
   to be run every time).
----------------------------------------------------------- */

-- Examples:
PRAGMA table_info(filtered_movies);
PRAGMA table_info(title_basics);
PRAGMA table_info(title_ratings);
PRAGMA table_info(name_basics);

-- TEMPLATE:
-- PRAGMA table_info(table_name_here);

/* ----------------------------------------------------------
   03. ROW COUNTS FOR MAIN TABLES
----------------------------------------------------------- */

SELECT 'actors_pivot' AS table_name, COUNT(*) FROM actors_pivot
UNION ALL SELECT 'actresses_pivot', COUNT(*) FROM actresses_pivot
UNION ALL SELECT 'directors_pivot', COUNT(*) FROM directors_pivot
UNION ALL SELECT 'filtered_movies', COUNT(*) FROM filtered_movies
UNION ALL SELECT 'name_basics', COUNT(*) FROM name_basics
UNION ALL SELECT 'title_akas', COUNT(*) FROM title_akas
UNION ALL SELECT 'title_basics', COUNT(*) FROM title_basics
UNION ALL SELECT 'title_crew', COUNT(*) FROM title_crew
UNION ALL SELECT 'title_episode', COUNT(*) FROM title_episode
UNION ALL SELECT 'title_principals', COUNT(*) FROM title_principals
UNION ALL SELECT 'title_ratings', COUNT(*) FROM title_ratings;

/* ----------------------------------------------------------
   04. LIST ALL INDEXES
----------------------------------------------------------- */

SELECT
    name AS index_name,
    tbl_name AS table_name,
    sql AS index_definition
FROM sqlite_master
WHERE type = 'index'
ORDER BY table_name, index_name;

/* ----------------------------------------------------------
   05. SAMPLE ROWS FROM ANY TABLE
   Run manually as needed.
----------------------------------------------------------- */

-- Examples:
SELECT * FROM filtered_movies LIMIT 20;
SELECT * FROM title_basics LIMIT 20;
SELECT * FROM title_principals LIMIT 20;

-- TEMPLATE:
-- SELECT * FROM table_name_here LIMIT 20;

/* ----------------------------------------------------------
   06. DISTINCT VALUES FOR KEY FIELDS (OPTIONAL)
----------------------------------------------------------- */

-- Title types:
SELECT DISTINCT titleType FROM title_basics ORDER BY titleType;

-- Principal categories:
SELECT DISTINCT category FROM title_principals ORDER BY category;

-- Sample genres:
SELECT DISTINCT genres
FROM title_basics
WHERE genres IS NOT NULL
LIMIT 50;