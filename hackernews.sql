
-- Import the Hackernews Dataset and save it as HACKERNEWS
.mode csv
.import 'hackernews.csv' HACKERNEWS

-- Query the Table with the name given to it to see its content
SELECT * FROM HACKERNEWS;


SELECT name FROM sqlite_master WHERE type='table';

-- Check the Columns for Null values

SELECT COUNT(*) AS COUNT
FROM HACKERNEWS
WHERE URL is NULL;

SELECT COUNT(*) AS COUNT
FROM HACKERNEWS
WHERE "Post Type" is NULL;

SELECT COUNT(*) AS COUNT
FROM HACKERNEWS
WHERE Points is NULL;


SELECT COUNT(*) AS COUNT
FROM HACKERNEWS
WHERE "Created At" is NULL;
--The above analysis of the Hackernews dataset revealed a balanced distribution of data across the selected websites.
--It further demonstrated that the dataset has minimal null values.


--Part of the Preprocessing is to change the datatypes to appropraite datatypes
CREATE TABLE NEW_HACKERNEWS (
  "Object_ID" INTEGER,
  "Title" TEXT,
  "Post_Type" TEXT,
  "Author" TEXT,
  "Created_At" DATETIME,
  "URL" TEXT,
  "Points" INTEGER,
  "Number_of_Comments" INTEGER
);

INSERT INTO NEW_HACKERNEWS (
  "Object_ID",
  "Title",
  "Post_Type",
  "Author",
  "Created_At",
  "URL",
  "Points",
  "Number_of_Comments"
)
SELECT 
  CAST("Object ID" AS INTEGER),
  "Title",
  "Post Type",
  "Author",
  DATETIME("Created At"),
  "URL",
  CAST("Points" AS INTEGER),
  CAST("Number of Comments" AS INTEGER)
FROM HACKERNEWS;

SELECT * FROM NEW_HACKERNEWS;

DROP TABLE HACKERNEWS;

ALTER TABLE NEW_HACKERNEWS RENAME TO HACKERNEWS;

--Confirms that all changes were made correctly
.schema

SELECT * FROM HACKERNEWS
LIMIT 10
;


--This code queries the table to produce the values of the URL and Points allocated to each 
--post that is a story made in 2022 to recent date.
--It also checks only the fields that are not NULL
SELECT
  URL,
  Points,
  DATE([Created_At]) AS date_published
FROM
  HACKERNEWS
WHERE
  DATE([Created_At]) BETWEEN '2022-01-01' AND '2023-03-31'
  AND URL IS NOT NULL
  AND Points IS NOT NULL
  AND [Post_Type] = 'story'
;


-- The previous analysis shows that the URLs have extensions and needs to be streamlined to just the Domain Names
--This code filters out the extensions then saves the domain names in a New column called 'Domain_names'
SELECT
  SUBSTR(URL, INSTR(URL, '//') + 2, INSTR(SUBSTR(URL, INSTR(URL, '//') + 2), '/') - 1) AS Domain_names,
  Points
FROM
  HACKERNEWS
WHERE
  DATE([Created_At]) BETWEEN '2022-01-01' AND '2023-03-31'
  AND URL IS NOT NULL
  AND Points IS NOT NULL
  AND [Post_Type] = 'story'
;


-- To get the Domains with high ratings in the tables, the table is queried to count all the domains with ratings above 100
-- Then filters to the top 2 websites with ratings above 100
-- This give the best 2 Websites that would yeild maximum Profit for the marketing campaign.
SELECT
  SUBSTR(URL, INSTR(URL, '//') + 2, INSTR(SUBSTR(URL, INSTR(URL, '//') + 2), '/') - 1) AS Top_2_Websites,
  COUNT(CASE WHEN Points > 100 THEN 1 END) AS rating_abv_100
FROM
  HACKERNEWS
WHERE
  DATE([Created_At]) BETWEEN '2022-01-01' AND '2023-03-31'
  AND Points IS NOT NULL
  AND URL IS NOT NULL
  AND "Post_Type" = 'story'
GROUP BY
  Top_2_Websites
ORDER BY
  rating_abv_100 DESC
LIMIT 2
;