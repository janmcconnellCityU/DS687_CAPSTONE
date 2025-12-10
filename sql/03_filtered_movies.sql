/* ==========================================================
   03: CREATE FILTERED MOVIE DATASET FOR MODELING
   Purpose:
   - Narrow IMDb data to movies only
   - Remove incomplete or low-engagement movies
   - Keep films with stable, meaningful ratings
   - Create a clean dataset for Python and R

   Applied Filters:
     • titleType = 'movie'
     • startYear IS NOT NULL
     • runtimeMinutes IS NOT NULL
     • genres IS NOT NULL
     • numVotes ≥ 5000

   Rationale:
     A 5,000-vote threshold balances quality and quantity.
     It removes low-engagement, noisy films while preserving
     a large enough dataset (tens of thousands of titles)
     for modeling and advanced analysis.
   ========================================================== */

/* ----------------------------------------------------------
   STEP 1: Drop the table if it already exists
----------------------------------------------------------- */
DROP TABLE IF EXISTS filtered_movies;

/* ----------------------------------------------------------
   STEP 2: Create the filtered movie table
----------------------------------------------------------- */
CREATE TABLE filtered_movies AS
SELECT
    b.tconst,
    b.primaryTitle,
    b.originalTitle,
    b.startYear,
    b.runtimeMinutes,
    b.genres,
    r.averageRating,
    r.numVotes
FROM title_basics b
JOIN title_ratings r ON b.tconst = r.tconst
WHERE b.titleType = 'movie'
  AND r.numVotes >= 5000
  AND b.startYear IS NOT NULL
  AND b.runtimeMinutes IS NOT NULL
  AND b.genres IS NOT NULL;

/* ----------------------------------------------------------
   STEP 3: Add indexes for faster analysis
----------------------------------------------------------- */
CREATE INDEX IF NOT EXISTS idx_fm_tconst ON filtered_movies(tconst);
CREATE INDEX IF NOT EXISTS idx_fm_startYear ON filtered_movies(startYear);
CREATE INDEX IF NOT EXISTS idx_fm_numVotes ON filtered_movies(numVotes);
CREATE INDEX IF NOT EXISTS idx_fm_rating ON filtered_movies(averageRating);
CREATE INDEX IF NOT EXISTS idx_fm_genres ON filtered_movies(genres);

/* ----------------------------------------------------------
   STEP 4: Basic summary check (optional)
   Run this to verify the table contents:
   SELECT COUNT(*) FROM filtered_movies;
----------------------------------------------------------- */
SELECT COUNT(*) FROM filtered_movies;

/* ----------------------------------------------------------
   STEP 5: Preview filtered_movies to verify contents
----------------------------------------------------------- */
SELECT * FROM filtered_movies LIMIT 20;
