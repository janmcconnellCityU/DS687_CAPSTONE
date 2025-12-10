/* ----------------------------------------------------------
   01: DISTRIBUTION OF USER RATINGS (averageRating)
   Helps reveal how IMDb ratings are skewed across all titles
----------------------------------------------------------- */
SELECT
    averageRating,
    COUNT(*) AS count_titles
FROM title_ratings
GROUP BY averageRating
ORDER BY averageRating;

/* ----------------------------------------------------------
   02: DISTRIBUTION OF USER VOTE COUNTS (numVotes)
   Categorizes movie popularity into buckets
----------------------------------------------------------- */
SELECT
    CASE
        WHEN numVotes < 100 THEN '<100'
        WHEN numVotes BETWEEN 100 AND 999 THEN '100–999'
        WHEN numVotes BETWEEN 1000 AND 9999 THEN '1k–9k'
        WHEN numVotes BETWEEN 10000 AND 99999 THEN '10k–99k'
        WHEN numVotes BETWEEN 100000 AND 999999 THEN '100k–999k'
        ELSE '1M+'
    END AS vote_bucket,
    COUNT(*) AS count_titles
FROM title_ratings
GROUP BY vote_bucket
ORDER BY count_titles DESC;

/* ----------------------------------------------------------
   03: MOVIE COUNTS BY DECADE
   Provides a temporal overview of movie production
----------------------------------------------------------- */
SELECT
    (startYear / 10) * 10 AS decade,
    COUNT(*) AS count_movies
FROM title_basics
WHERE titleType = 'movie'
  AND startYear IS NOT NULL
GROUP BY decade
ORDER BY decade;

/* ----------------------------------------------------------
   04: AVERAGE MOVIE RUNTIME BY DECADE
   Useful for understanding trends in film length over time
----------------------------------------------------------- */
SELECT
    (startYear / 10) * 10 AS decade,
    AVG(runtimeMinutes) AS avg_runtime,
    COUNT(*) AS count_movies
FROM title_basics
WHERE titleType = 'movie'
  AND runtimeMinutes IS NOT NULL
  AND startYear IS NOT NULL
GROUP BY decade
ORDER BY decade;

/* ----------------------------------------------------------
   05: CAST & CREW ROLE DISTRIBUTION
   Shows how many individuals exist in each role category
   Examples: actor, actress, director, producer, etc.
----------------------------------------------------------- */
SELECT
    category,
    COUNT(*) AS count_people
FROM title_principals
GROUP BY category
ORDER BY count_people DESC;

/* ----------------------------------------------------------
   06: MOST ACTIVE INDIVIDUALS IN THE DATABASE
   Shows people with the highest number of credited titles
----------------------------------------------------------- */
SELECT
    n.primaryName,
    COUNT(*) AS title_count
FROM name_basics n
JOIN title_principals p ON n.nconst = p.nconst
GROUP BY n.nconst
ORDER BY title_count DESC
LIMIT 20;

/* ----------------------------------------------------------
   07 - NOT USED: DIRECTOR POPULARITY (BASED ON AVERAGE NUMVOTES)
   Helps determine whether directors influence popularity
----------------------------------------------------------- */
SELECT
    n.primaryName AS director_name,
    COUNT(*) AS films_directed,
    AVG(r.numVotes) AS avg_votes
FROM title_crew c
JOIN title_ratings r ON c.tconst = r.tconst
JOIN name_basics n ON c.directors LIKE '%' || n.nconst || '%'
GROUP BY director_name
HAVING films_directed >= 3
ORDER BY avg_votes DESC
LIMIT 20;

/* ----------------------------------------------------------
   07: DIRECTOR POPULARITY
   The original query is too slow due to substring matching.
   These steps create a normalized director table and then
   perform the popularity analysis efficiently.
----------------------------------------------------------- */

-- STEP 1: Create a normalized table mapping each director to each film
CREATE TABLE IF NOT EXISTS directors_pivot AS
SELECT
    c.tconst,
    TRIM(value) AS nconst
FROM title_crew c,
     json_each('["' || REPLACE(c.directors, ',', '","') || '"]')
WHERE c.directors IS NOT NULL;

-- STEP 2: Add indexes for performance
CREATE INDEX IF NOT EXISTS idx_dp_nconst ON directors_pivot(nconst);
CREATE INDEX IF NOT EXISTS idx_dp_tconst ON directors_pivot(tconst);

-- STEP 3: Run the efficient director popularity query
SELECT
    n.primaryName AS director_name,
    COUNT(*) AS films_directed,
    AVG(r.numVotes) AS avg_votes
FROM directors_pivot dp
JOIN name_basics n ON dp.nconst = n.nconst
JOIN title_ratings r ON dp.tconst = r.tconst
GROUP BY director_name
HAVING films_directed >= 3
ORDER BY avg_votes DESC
LIMIT 20;

/* ----------------------------------------------------------
   INDEXES FOR PERFORMANCE
----------------------------------------------------------- */

CREATE INDEX IF NOT EXISTS idx_principals_category ON title_principals(category);
CREATE INDEX IF NOT EXISTS idx_principals_tconst ON title_principals(tconst);
CREATE INDEX IF NOT EXISTS idx_principals_nconst ON title_principals(nconst);

CREATE INDEX IF NOT EXISTS idx_ratings_tconst ON title_ratings(tconst);
CREATE INDEX IF NOT EXISTS idx_names_nconst ON name_basics(nconst);

/* ----------------------------------------------------------
   PIVOT TABLES FOR ACTORS AND ACTRESSES
----------------------------------------------------------- */

DROP TABLE IF EXISTS actors_pivot;
CREATE TABLE actors_pivot AS
SELECT p.tconst, p.nconst
FROM title_principals p
WHERE p.category = 'actor';

CREATE INDEX idx_ap_tconst ON actors_pivot(tconst);
CREATE INDEX idx_ap_nconst ON actors_pivot(nconst);


DROP TABLE IF EXISTS actresses_pivot;
CREATE TABLE actresses_pivot AS
SELECT p.tconst, p.nconst
FROM title_principals p
WHERE p.category = 'actress';

CREATE INDEX idx_acp_tconst ON actresses_pivot(tconst);
CREATE INDEX idx_acp_nconst ON actresses_pivot(nconst);

/* ----------------------------------------------------------
   08 - NOT USED: ACTOR POPULARITY (BASED ON AVERAGE NUMVOTES)
   Evaluates whether certain actors appear in more popular films
----------------------------------------------------------- */
SELECT
    n.primaryName AS actor_name,
    COUNT(*) AS films_acted,
    AVG(r.numVotes) AS avg_votes
FROM title_principals p
JOIN title_ratings r ON p.tconst = r.tconst
JOIN name_basics n ON p.nconst = n.nconst
WHERE p.category = 'actor'
GROUP BY actor_name
HAVING films_acted >= 5
ORDER BY avg_votes DESC
LIMIT 20;

/* ----------------------------------------------------------
   08: ACTOR POPULARITY - OPTIMIZED
----------------------------------------------------------- */
SELECT
    n.primaryName AS actor_name,
    COUNT(*) AS films_acted,
    AVG(r.numVotes) AS avg_votes
FROM actors_pivot ap
JOIN name_basics n ON ap.nconst = n.nconst
JOIN title_ratings r ON ap.tconst = r.tconst
GROUP BY actor_name
HAVING films_acted >= 5
ORDER BY avg_votes DESC
LIMIT 20;

/* ----------------------------------------------------------
   09 - NOT USED: ACTRESS POPULARITY (BASED ON AVERAGE NUMVOTES)
   Same analysis as above, but specifically for actresses
----------------------------------------------------------- */
SELECT
    n.primaryName AS actress_name,
    COUNT(*) AS films_acted,
    AVG(r.numVotes) AS avg_votes
FROM title_principals p
JOIN title_ratings r ON p.tconst = r.tconst
JOIN name_basics n ON p.nconst = n.nconst
WHERE p.category = 'actress'
GROUP BY actress_name
HAVING films_acted >= 5
ORDER BY avg_votes DESC
LIMIT 20;

/* ----------------------------------------------------------
   09: ACTRESS POPULARITY - OPTIMIZED
----------------------------------------------------------- */
SELECT
    n.primaryName AS actress_name,
    COUNT(*) AS films_acted,
    AVG(r.numVotes) AS avg_votes
FROM actresses_pivot acp
JOIN name_basics n ON acp.nconst = n.nconst
JOIN title_ratings r ON acp.tconst = r.tconst
GROUP BY actress_name
HAVING films_acted >= 5
ORDER BY avg_votes DESC
LIMIT 20;

/* ----------------------------------------------------------
   10: CHECK FOR MISSING VALUES
   Helps you understand data quality issues for modeling
----------------------------------------------------------- */

-- Missing runtime values
SELECT COUNT(*) AS missing_runtime
FROM title_basics
WHERE runtimeMinutes IS NULL
  AND titleType = 'movie';

-- Missing startYear values
SELECT COUNT(*) AS missing_startYear
FROM title_basics
WHERE startYear IS NULL
  AND titleType = 'movie';

-- Missing genres
SELECT COUNT(*) AS missing_genres
FROM title_basics
WHERE genres IS NULL
  AND titleType = 'movie';