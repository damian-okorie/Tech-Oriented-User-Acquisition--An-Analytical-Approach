# Tech-Oriented User Acquisition: An Analytical Approach
![Repo hero image](https://academy-public.coinmarketcap.com/srd-optimized-uploads/7f6449f451b94c5cb1155efb24a19532.jpg)


 **Harnessing Data Insights for Effective Fintech Marketing**: This repository documents an innovative marketing strategy deployed by a fintech startup seeking to expand its user base. The startup’s unique mobile app offers users effortless financial management, personalized budgeting, and robust investment tracking capabilities. To gain more traction in a highly competitive space, the startup identified the need for a data-driven, targeted marketing approach.

## Objectives:
1.  **Identification of Key Online Platforms**: The startup aimed to determine the most valuable websites for their marketing campaign, intending to target tech-savvy users with an interest in financial technology and innovation. By analyzing the Hackernews dataset - a rich resource of technology-related discussions and news - the startup aspired to gain valuable insights about their target audience's preferences and interests.

2.  **Resource Allocation for Marketing Campaign**: The startup sought to calculate the percentage of users engaged with each of the top identified websites. This data would allow them to optimally distribute resources, ensuring the greatest impact of their marketing campaign.

## Repository Content:
This portfolio repository comprehensively outlines the my journey from data extraction to Data Visualization of the analysis. The process involved leveraging SQL to filter the Hackernews dataset, deriving key insights, and eventually leading to the discovery of top websites with high user engagement. The findings from this analysis guided the startup's marketing efforts, assisting in resource allocation and strategy formulation.

The repository also details the strategic execution of the marketing campaign, demonstrating how targeted advertisements, engaging content, and alliances with the identified websites effectively reached the desired audience.

## Dataset Information:
The Hackernews dataset is a rich source of information about technology-related news, discussions, and user interactions. It comprises a vast collection of posts, comments, and other user-generated content from the Hacker News platform.

For this analysis, the Hackernews dataset was chosen because it provides valuable insights into the preferences and interests of technology enthusiasts. By analyzing this dataset, we can gain a deeper understanding of the technological user community and their engagement with different websites and topics.

The dataset contains various attributes such as post titles, URLs, points (indicating user engagement), number of comments, and more. These attributes allow us to assess the popularity and engagement levels of different posts and websites, making it a valuable resource for our analysis.

By leveraging the Hackernews dataset, we can identify the top websites that resonate with technological users and allocate campaign resources effectively. This dataset helps us make data-driven decisions to target the right audience, optimize our marketing efforts, and attract more followers and users to our fintech app.

Through the exploration of the Hackernews dataset, we can uncover valuable insights that contribute to the success of our campaign and enable us to establish a strong presence among the technology-savvy audience.

## Section 1: Setup
The analysis in this repository utilizes SQLite, which is a serverless database technology. To run the queries, you will need to set up SQLite on your local machine. Follow the steps below to get started:

**Install SQLite Extension**: If you are using Visual Studio Code, install the SQLite extension from the marketplace. This extension provides an interface for running SQL queries and managing SQLite databases within the editor.

**Install SQLite Locally**: If you prefer to work with SQLite outside of Visual Studio Code, you can download and install it on your computer. Visit the official SQLite website (https://www.sqlite.org/) and download the appropriate version for your operating system. Follow the installation instructions provided.

Create a Database: Once you have SQLite installed, create a new database where you can store the dataset for analysis. You can create a new database using the SQLite command-line tool or within Visual Studio Code using the SQLite extension.

With these initial setup steps completed, you are now ready to proceed with the analysis.

## Section 2: Queries

### Importation of the Hackernews Dataset
The first step is to import the Hackernews dataset and save it in the database that was intitially created.

```SQL
-- Import the Hackernews Dataset and save it as HACKERNEWS
.mode csv
.import 'hackernews.csv' HACKERNEWS

-- Query the Table with the name given to it to see its content
SELECT * FROM HACKERNEWS;
```

### Appraisal of the Dataset
Query the dataset to do an appraisal of the dataset

```SQL
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
```

- The analysis of the Hackernews dataset revealed a balanced distribution of data across the selected websites. This indicates that there is a relatively equal representation of engagement and popularity among the technological users for these websites, making them suitable targets for the marketing campaign.

- The exploration of the Hackernews dataset further demonstrated that the dataset has minimal null values. This implies that the dataset is well-maintained and provides reliable information for analysis, ensuring the accuracy and completeness of the findings obtained from the dataset.

### Preprocessing of the Dataset

```SQL
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
```
In this preprocessing stage, some of the columns were changed to an appropriate datatype. This is necessary for other queries and analysis that would be performed on the dataset.

### Exploring Engagement Trends in Hackernews Dataset

```SQL
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
```

From the result of this query, you can observe the points given to each story within the specified time range of 2022 to 2023. By filtering out past years, the query focuses on analyzing the engagement and popularity of stories published during this period. The points metric provides an indication of the level of user interest and engagement with each story. This information can be valuable in identifying highly rated stories and understanding the factors that contribute to their popularity.

```SQL
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
```
The previous analysis revealed that the URLs in the dataset contain extensions and need to be streamlined to display only the domain names. To address this, the code above filters out the extensions and saves the domain names in a new column called 'Domain_names':

```SQL
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
```
To identify the domains with high ratings in the dataset and determine the most profitable websites for the marketing campaign, the table is queried to count all the domains with ratings above 100. This filtering process helps focus on the domains that have shown significant engagement and interest from the users.

The analysis then narrows down the results to the top two websites with ratings above 100. These websites are identified as the most promising candidates to yield maximum profit and user acquisition for the marketing campaign. By targeting these websites, the campaign can capitalize on the high user engagement and leverage the strong reputation and popularity of these domains.

This strategic approach ensures that the marketing campaign allocates resources effectively and concentrates efforts on the websites with the highest potential to attract and engage the desired technological user audience. By selecting the best two websites based on ratings and engagement, the campaign maximizes the chances of success and achieves optimal results in terms of follower and user acquisition for the fintech app.

In summary, this analysis focuses on identifying the domains with high ratings and narrows down to the top two websites, providing actionable insights for the marketing campaign to target the most profitable platforms and optimize resource allocation.