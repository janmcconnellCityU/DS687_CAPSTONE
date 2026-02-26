-- SQLite
SELECT sqlite_version() AS sqlite_version;

-- List all tables
SELECT name
FROM sqlite_master
WHERE type = 'table'
ORDER BY name;

-- Check row counts for each table
SELECT 'actors_pivot'      AS table_name, COUNT(*) AS row_count FROM actors_pivot
UNION ALL
SELECT 'actresses_pivot',  COUNT(*) FROM actresses_pivot
UNION ALL
SELECT 'directors_pivot',  COUNT(*) FROM directors_pivot
UNION ALL
SELECT 'filtered_movies',  COUNT(*) FROM filtered_movies
UNION ALL
SELECT 'name_basics',      COUNT(*) FROM name_basics
UNION ALL
SELECT 'title_akas',       COUNT(*) FROM title_akas
UNION ALL
SELECT 'title_basics',     COUNT(*) FROM title_basics
UNION ALL
SELECT 'title_crew',       COUNT(*) FROM title_crew
UNION ALL
SELECT 'title_episode',    COUNT(*) FROM title_episode
UNION ALL
SELECT 'title_principals', COUNT(*) FROM title_principals
UNION ALL
SELECT 'title_ratings',    COUNT(*) FROM title_ratings
ORDER BY table_name;

-- Spot check data
SELECT *
FROM title_basics
LIMIT 10;

SELECT *
FROM title_ratings
LIMIT 10;

-- Confirm primary keys and duplicates
SELECT COUNT(*) AS total_rows,
       COUNT(DISTINCT tconst) AS distinct_tconst
FROM title_basics;

SELECT COUNT(*) AS total_rows,
       COUNT(DISTINCT tconst) AS distinct_tconst
FROM title_ratings;

-- Confirm join coverage between basics and ratings
SELECT
  (SELECT COUNT(*) FROM title_basics)  AS basics_rows,
  (SELECT COUNT(*) FROM title_ratings) AS ratings_rows,
  (SELECT COUNT(*)
   FROM title_basics b
   INNER JOIN title_ratings r ON r.tconst = b.tconst) AS inner_join_rows,
  (SELECT COUNT(*)
   FROM title_basics b
   LEFT JOIN title_ratings r ON r.tconst = b.tconst
   WHERE r.tconst IS NULL) AS basics_missing_ratings;

-- Validate filtered_movies as the candidate analysis dataset (size, fields, sample)
SELECT COUNT(*) AS row_count
FROM filtered_movies;

PRAGMA table_info(filtered_movies);

SELECT *
FROM filtered_movies
LIMIT 10;

-- Create or refresh analysis_movies view (movies only, non-adult, with ratings)
DROP VIEW IF EXISTS analysis_movies;

CREATE VIEW analysis_movies AS
SELECT
    b.tconst,
    b.primaryTitle,
    b.startYear,
    b.runtimeMinutes,
    b.genres,
    r.averageRating,
    r.numVotes
FROM title_basics b
JOIN title_ratings r
    ON b.tconst = r.tconst
WHERE b.titleType = 'movie'
  AND b.isAdult = 0
  AND r.numVotes IS NOT NULL;

-- Verify the view
SELECT COUNT(*) AS row_count FROM analysis_movies;
SELECT * FROM analysis_movies LIMIT 10;