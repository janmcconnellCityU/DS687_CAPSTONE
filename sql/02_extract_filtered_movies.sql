SELECT
    b.tconst,
    b.primaryTitle,
    b.startYear,
    b.runtimeMinutes,
    b.genres,
    r.averageRating,
    r.numVotes
FROM title_basics b
JOIN title_ratings r ON b.tconst = r.tconst
WHERE b.titleType = 'movie'
  AND b.isAdult = 0
  AND b.startYear >= 2000
  AND r.numVotes >= 1000;
