/* ----------------------------------------------------------
   DS687 DATA SCIENCE CAPSTONE
   JAN MCCONNELL
----------------------------------------------------------- */

/* ----------------------------------------------------------
   01: BASIC DATA OVERVIEW
   Count total number of titles in the dataset
----------------------------------------------------------- */
SELECT COUNT(*) AS total_titles
FROM title_basics;

/* ----------------------------------------------------------
   02: TITLE TYPE DISTRIBUTION
   Shows how many entries exist per category
   Example titleTypes: movie, short, tvSeries, tvMovie, etc.
----------------------------------------------------------- */
SELECT titleType, COUNT(*) AS count_by_type
FROM title_basics
GROUP BY titleType
ORDER BY count_by_type DESC;

/* ----------------------------------------------------------
   03: MOST COMMON GENRES
   This reveals which genres appear most frequently
----------------------------------------------------------- */
SELECT genres, COUNT(*) AS genre_count
FROM title_basics
WHERE genres IS NOT NULL
GROUP BY genres
ORDER BY genre_count DESC
LIMIT 20;

/* ----------------------------------------------------------
   04: MOST RECENT MOVIES
   Shows latest movies added to the database
----------------------------------------------------------- */
SELECT primaryTitle, startYear, genres
FROM title_basics
WHERE titleType = 'movie'
ORDER BY startYear DESC
LIMIT 20;

/* ----------------------------------------------------------
   05: TITLES WITH THE MOST VOTES
   Useful for identifying popular or widely rated titles
----------------------------------------------------------- */
SELECT *
FROM title_ratings
ORDER BY numVotes DESC
LIMIT 20;