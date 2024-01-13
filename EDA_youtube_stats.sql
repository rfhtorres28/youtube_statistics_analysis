USE youtube_statistics




-- Rank youtuber by subscriber counts 
SELECT 
Youtuber as youtuber,
Subscribers as subs
FROM cleaned_data
ORDER BY Subscribers DESC


-- Rank category by total video views 
SELECT 
Category as category,
SUM(Video_Views) as views
FROM cleaned_data
GROUP BY Category
ORDER BY SUM(Video_Views) DESC


SELECT 
Category,
100 * CAST(SUM(CAST(Video_Views AS float)) / SUM(CAST(Uploads AS float)) / SUM(CAST(Subscribers AS float)) AS FLOAT) as view_subs_ratio
FROM cleaned_data
GROUP By Category
ORDER BY 2 DESC

SELECT 
