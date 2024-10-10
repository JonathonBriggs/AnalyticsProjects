-- Count of Unique Review IDs (18,389 with DISTINCT, 18,393 without)
SELECT COUNT(DISTINCT reviewid)
  FROM reviews;
  
-- Count of Unique Artists (8,633)
SELECT COUNT(DISTINCT artist)
  FROM artists;
  
-- Count of Unique Review Authors (432)
SELECT COUNT(DISTINCT author)
  FROM reviews;

-- Date Range for reviews table  
SELECT MIN(pub_date), MAX(pub_date)
FROM reviews;

-- Check for NULLS (rotated each field name through here)
SELECT COUNT(*) - COUNT(score) AS null_count
FROM reviews;

-- Document counts of reviews by author type
SELECT DISTINCT author_type, COUNT(DISTINCT reviewid)
FROM reviews
WHERE author_type IS NOT NULL
GROUP BY author_type
ORDER BY 2 DESC;

-- Investigate NULL and non NULL values in author_type 
--across full range of years
WITH author_type_available AS (
    SELECT pub_year AS year, COUNT(*) AS valid_count
    FROM reviews
    WHERE author_type IS NOT NULL
    GROUP BY 1
    ORDER BY 1
    ),

author_type_missing AS(
    SELECT pub_year AS year, COUNT(*) AS null_count
    FROM reviews
    WHERE author_type IS NULL
    GROUP BY 1
    ORDER BY 1
)

SELECT a. year, a.valid_count, b.null_count
FROM author_type_available AS a
INNER JOIN author_type_missing AS b
ON a.year = b.year;

-- Determine Top 10 Bands by review count
SELECT artist, COUNT(*) AS review_count, 
ROUND(AVG(score),2) AS average_score 
FROM reviews
WHERE artist IS NOT "various artists"
GROUP BY artist
ORDER BY 2 DESC
LIMIT 10;

-- Determine Top 10 Bands by average review score
SELECT artist, COUNT(*) AS review_count, 
ROUND(AVG(score),2) AS average_score 
FROM reviews
WHERE artist IS NOT "various artists"
GROUP BY artist
ORDER BY 3 DESC
LIMIT 10;

-- Determine average ratings per year
SELECT author_type, pub_year, COUNT(*), ROUND(AVG(score),2) AS average_score
FROM reviews
WHERE author_type IS NOT NULL
GROUP BY 1,2
ORDER BY 1,2;


-- Determine average ratings per year per author_type
-- SQLite does not support PIVOT function, so I have 
-- to do this a bit more manually
-- leaving the NULL results in on purpose, as correcting them in 
-- the CASE statement affects the AVG function
SELECT
    author_type,
    ROUND(AVG(CASE WHEN pub_year = 1999 THEN score END),2) AS scores_1999,
    ROUND(AVG(CASE WHEN pub_year = 2000 THEN score END),2) AS scores_2000,
    ROUND(AVG(CASE WHEN pub_year = 2001 THEN score END),2) AS scores_2001,
    ROUND(AVG(CASE WHEN pub_year = 2002 THEN score END),2) AS scores_2002,
    ROUND(AVG(CASE WHEN pub_year = 2003 THEN score END),2) AS scores_2003,
    ROUND(AVG(CASE WHEN pub_year = 2004 THEN score END),2) AS scores_2004,
    ROUND(AVG(CASE WHEN pub_year = 2005 THEN score END),2) AS scores_2005,
    ROUND(AVG(CASE WHEN pub_year = 2006 THEN score END),2) AS scores_2006,
    ROUND(AVG(CASE WHEN pub_year = 2007 THEN score END),2) AS scores_2007,
    ROUND(AVG(CASE WHEN pub_year = 2008 THEN score END),2) AS scores_2008,
    ROUND(AVG(CASE WHEN pub_year = 2009 THEN score END),2) AS scores_2009,
    ROUND(AVG(CASE WHEN pub_year = 2010 THEN score END),2) AS scores_2010,
    ROUND(AVG(CASE WHEN pub_year = 2011 THEN score END),2) AS scores_2011,
    ROUND(AVG(CASE WHEN pub_year = 2012 THEN score END),2) AS scores_2012,
    ROUND(AVG(CASE WHEN pub_year = 2013 THEN score END),2) AS scores_2013,
    ROUND(AVG(CASE WHEN pub_year = 2014 THEN score END),2) AS scores_2014,
    ROUND(AVG(CASE WHEN pub_year = 2015 THEN score END),2) AS scores_2015,
    ROUND(AVG(CASE WHEN pub_year = 2016 THEN score END),2) AS scores_2016,
    ROUND(AVG(CASE WHEN pub_year = 2017 THEN score END),2) AS scores_2017
FROM reviews
WHERE author_type IS NOT NULL
GROUP BY 1
ORDER BY 1;

-- Same query as above, but for the NULL author_types
SELECT
    author_type,
    ROUND(AVG(CASE WHEN pub_year = 1999 THEN score END),2) AS scores_1999,
    ROUND(AVG(CASE WHEN pub_year = 2000 THEN score END),2) AS scores_2000,
    ROUND(AVG(CASE WHEN pub_year = 2001 THEN score END),2) AS scores_2001,
    ROUND(AVG(CASE WHEN pub_year = 2002 THEN score END),2) AS scores_2002,
    ROUND(AVG(CASE WHEN pub_year = 2003 THEN score END),2) AS scores_2003,
    ROUND(AVG(CASE WHEN pub_year = 2004 THEN score END),2) AS scores_2004,
    ROUND(AVG(CASE WHEN pub_year = 2005 THEN score END),2) AS scores_2005,
    ROUND(AVG(CASE WHEN pub_year = 2006 THEN score END),2) AS scores_2006,
    ROUND(AVG(CASE WHEN pub_year = 2007 THEN score END),2) AS scores_2007,
    ROUND(AVG(CASE WHEN pub_year = 2008 THEN score END),2) AS scores_2008,
    ROUND(AVG(CASE WHEN pub_year = 2009 THEN score END),2) AS scores_2009,
    ROUND(AVG(CASE WHEN pub_year = 2010 THEN score END),2) AS scores_2010,
    ROUND(AVG(CASE WHEN pub_year = 2011 THEN score END),2) AS scores_2011,
    ROUND(AVG(CASE WHEN pub_year = 2012 THEN score END),2) AS scores_2012,
    ROUND(AVG(CASE WHEN pub_year = 2013 THEN score END),2) AS scores_2013,
    ROUND(AVG(CASE WHEN pub_year = 2014 THEN score END),2) AS scores_2014,
    ROUND(AVG(CASE WHEN pub_year = 2015 THEN score END),2) AS scores_2015,
    ROUND(AVG(CASE WHEN pub_year = 2016 THEN score END),2) AS scores_2016,
    ROUND(AVG(CASE WHEN pub_year = 2017 THEN score END),2) AS scores_2017
FROM reviews
WHERE author_type IS NULL
GROUP BY 1
ORDER BY 1;

-- Analyze groups of scores by year using CASE statements
SELECT
    pub_year,
    COUNT(CASE WHEN (score >0) AND (score <1) THEN score END) AS count_0to1,
    COUNT(CASE WHEN (score >=1) AND (score <2) THEN score END) AS count_1to2,
    COUNT(CASE WHEN (score >=2) AND (score <3) THEN score END) AS count_2to3,
    COUNT(CASE WHEN (score >=3) AND (score <4) THEN score END) AS count_3to4,
    COUNT(CASE WHEN (score >=4) AND (score <5) THEN score END) AS count_4to5,
    COUNT(CASE WHEN (score >=5) AND (score <6) THEN score END) AS count_5to6,
    COUNT(CASE WHEN (score >=6) AND (score <7) THEN score END) AS count_6to7,
    COUNT(CASE WHEN (score >=7) AND (score <8) THEN score END) AS count_7to8,
    COUNT(CASE WHEN (score >=8) AND (score <9) THEN score END) AS count_8to9,
    COUNT(CASE WHEN (score >=9) AND (score <10) THEN score END) AS count_9to10
FROM reviews
GROUP BY pub_year;

-- Combining reviews and genres into temp table
-- Review of average scores by year by genre
WITH reviews_genres AS (
    SELECT r.*, g.genre
    FROM reviews AS r
    INNER JOIN genres AS g
    ON r.reviewid = g.reviewid
)

SELECT
    genre,
    ROUND(AVG(CASE WHEN pub_year = 1999 THEN score END),2) AS scores_1999,
    ROUND(AVG(CASE WHEN pub_year = 2000 THEN score END),2) AS scores_2000,
    ROUND(AVG(CASE WHEN pub_year = 2001 THEN score END),2) AS scores_2001,
    ROUND(AVG(CASE WHEN pub_year = 2002 THEN score END),2) AS scores_2002,
    ROUND(AVG(CASE WHEN pub_year = 2003 THEN score END),2) AS scores_2003,
    ROUND(AVG(CASE WHEN pub_year = 2004 THEN score END),2) AS scores_2004,
    ROUND(AVG(CASE WHEN pub_year = 2005 THEN score END),2) AS scores_2005,
    ROUND(AVG(CASE WHEN pub_year = 2006 THEN score END),2) AS scores_2006,
    ROUND(AVG(CASE WHEN pub_year = 2007 THEN score END),2) AS scores_2007,
    ROUND(AVG(CASE WHEN pub_year = 2008 THEN score END),2) AS scores_2008,
    ROUND(AVG(CASE WHEN pub_year = 2009 THEN score END),2) AS scores_2009,
    ROUND(AVG(CASE WHEN pub_year = 2010 THEN score END),2) AS scores_2010,
    ROUND(AVG(CASE WHEN pub_year = 2011 THEN score END),2) AS scores_2011,
    ROUND(AVG(CASE WHEN pub_year = 2012 THEN score END),2) AS scores_2012,
    ROUND(AVG(CASE WHEN pub_year = 2013 THEN score END),2) AS scores_2013,
    ROUND(AVG(CASE WHEN pub_year = 2014 THEN score END),2) AS scores_2014,
    ROUND(AVG(CASE WHEN pub_year = 2015 THEN score END),2) AS scores_2015,
    ROUND(AVG(CASE WHEN pub_year = 2016 THEN score END),2) AS scores_2016,
    ROUND(AVG(CASE WHEN pub_year = 2017 THEN score END),2) AS scores_2017
FROM reviews_genres
GROUP BY genre
ORDER BY genre;

-- Combining reviews and genres into temp table
-- Review of average scores by year by genre
WITH reviews_genres AS (
    SELECT r.*, g.genre
    FROM reviews AS r
    INNER JOIN genres AS g
    ON r.reviewid = g.reviewid
)

SELECT
    genre,
    COUNT(CASE WHEN pub_year = 1999 THEN reviewid END) AS count_1999,
    COUNT(CASE WHEN pub_year = 2000 THEN reviewid END) AS count_2000,
    COUNT(CASE WHEN pub_year = 2001 THEN reviewid END) AS count_2001,
    COUNT(CASE WHEN pub_year = 2002 THEN reviewid END) AS count_2002,
    COUNT(CASE WHEN pub_year = 2003 THEN reviewid END) AS count_2003,
    COUNT(CASE WHEN pub_year = 2004 THEN reviewid END) AS count_2004,
    COUNT(CASE WHEN pub_year = 2005 THEN reviewid END) AS count_2005,
    COUNT(CASE WHEN pub_year = 2006 THEN reviewid END) AS count_2006,
    COUNT(CASE WHEN pub_year = 2007 THEN reviewid END) AS count_2007,
    COUNT(CASE WHEN pub_year = 2008 THEN reviewid END) AS count_2008,
    COUNT(CASE WHEN pub_year = 2009 THEN reviewid END) AS count_2009,
    COUNT(CASE WHEN pub_year = 2010 THEN reviewid END) AS count_2010,
    COUNT(CASE WHEN pub_year = 2011 THEN reviewid END) AS count_2011,
    COUNT(CASE WHEN pub_year = 2012 THEN reviewid END) AS count_2012,
    COUNT(CASE WHEN pub_year = 2013 THEN reviewid END) AS count_2013,
    COUNT(CASE WHEN pub_year = 2014 THEN reviewid END) AS count_2014,
    COUNT(CASE WHEN pub_year = 2015 THEN reviewid END) AS count_2015,
    COUNT(CASE WHEN pub_year = 2016 THEN reviewid END) AS count_2016,
    COUNT(CASE WHEN pub_year = 2017 THEN reviewid END) AS count_2017
FROM reviews_genres
GROUP BY 1
ORDER BY 1;


-- Combining reviews and genres into temp table
-- Review of Best new music by genre
WITH reviews_genres AS (
    SELECT r.*, g.genre
    FROM reviews AS r
    INNER JOIN genres AS g
    ON r.reviewid = g.reviewid
)

SELECT
    genre,
    SUM(CASE WHEN pub_year = 1999 THEN best_new_music END) AS count_1999,
    SUM(CASE WHEN pub_year = 2000 THEN best_new_music END) AS count_2000,
    SUM(CASE WHEN pub_year = 2001 THEN best_new_music END) AS count_2001,
    SUM(CASE WHEN pub_year = 2002 THEN best_new_music END) AS count_2002,
    SUM(CASE WHEN pub_year = 2003 THEN best_new_music END) AS count_2003,
    SUM(CASE WHEN pub_year = 2004 THEN best_new_music END) AS count_2004,
    SUM(CASE WHEN pub_year = 2005 THEN best_new_music END) AS count_2005,
    SUM(CASE WHEN pub_year = 2006 THEN best_new_music END) AS count_2006,
    SUM(CASE WHEN pub_year = 2007 THEN best_new_music END) AS count_2007,
    SUM(CASE WHEN pub_year = 2008 THEN best_new_music END) AS count_2008,
    SUM(CASE WHEN pub_year = 2009 THEN best_new_music END) AS count_2009,
    SUM(CASE WHEN pub_year = 2010 THEN best_new_music END) AS count_2010,
    SUM(CASE WHEN pub_year = 2011 THEN best_new_music END) AS count_2011,
    SUM(CASE WHEN pub_year = 2012 THEN best_new_music END) AS count_2012,
    SUM(CASE WHEN pub_year = 2013 THEN best_new_music END) AS count_2013,
    SUM(CASE WHEN pub_year = 2014 THEN best_new_music END) AS count_2014,
    SUM(CASE WHEN pub_year = 2015 THEN best_new_music END) AS count_2015,
    SUM(CASE WHEN pub_year = 2016 THEN best_new_music END) AS count_2016,
    SUM(CASE WHEN pub_year = 2017 THEN best_new_music END) AS count_2017
FROM reviews_genres
GROUP BY 1
ORDER BY 1;