# Top Youtuber Statistics Performance (2022)

## Author
* [rfhtorres28](https://github.com/rfhtorres28)
  
## Project Overview
Hello there! This project is all about the analysis of Performance of Top Youtuber in 2022. I performed the analysis using Python and Microsoft Server Management Studio for Data Quality Assessment and Exploratory Data Analysis. I used python for data cleaning since it has more statistical tools that can help me detect and assess outliers for numeric data columns. It has also boxplot graphs for easy visualization of outliers. I performed Data Visualization on Power BI. 
## Data Source
* The CSV files were downloaded from kaggle website. I created a database on SQL Server and make a table for the cleaned data after Data Cleaning from Python. 

## Tools 
* Python - Data Cleaning 
* SQL Server - Exploratory Data Analysis
* Power BI - Data Visualization

  
# Methods

### First Phase 
 In the initial phase of data preparation, the following tasks were performed: 

 1. Load the CSV file using Python.
 3. Removed duplicate rows, change the format of column names, detecting and replacing outliers and filling missing values.
 4. Send the cleaned data to SQL Server for Exploratory Data Analysis

### Second Phase
 EDA involves exploring the sales data to answer some of the following questions:

 1. Which Youtuber has the most subscribers and video views? 
 2. What video category has high view to subscriber ratio? 
 3. Which country has the highest unemployment rate and gross tertiary enrollment ratio?

### Last Phase
  For each questions, I used group-by with aggregation method and created a table for it. Each resulting table was transferred to Power BI for Data Visualization. 

## Python Data Cleaning Process 
Notebook file for Data Cleaning is uploaded in the repository section. 

Steps: 

1. Load the CSV file using pd.read_csv()
2. Remove unecessary characters on column title and capitalize each word.
3. Repeat step 2 for each category columns.
4. Select necessary columns for analysis.
5. Drop duplicate rows
6. Detect outliers by graphing each numeric column using boxplot.
7. If the graph is skewed distribution and has potential outliers, use inter quartile rule for removing outliers.
8. If the graph is symmetric distribution, use standard deviation rule for removing outliers.
9. If the outliers are valid values for each column, just retain them.
10. If the count of outliers are almost 10% of the total values on that column, retain them. Removing the outliers or replacing them can affect the accuracy of the result since 10% is significant.
11. Detect null values and replace them with zero or median value.
12. If the numeric column has null values with extreme outliers, use the median value as a replacement for null values instead of mean value since it can be affected due to presence of extreme outliers.
13. For categorical column, if the number of null values is significant, I replace them with 'Others' category for country and channel type column.
14. Check if each columns has correct data types.
15. For Month, Year and Day column, I combine them into one column then convert it to datetime format.
16. Transfer the cleaned dataframe to SQL Server for Exploratory Data Analysis.

## SQL EDA Implementation 

Create a Database
```
CREATE DATABASE youtube_statistics;
USE youtube_statistics;
```

Rank youtuber by subscriber counts 
```
SELECT 
Youtuber as youtuber,
Subscribers as subs
INTO youtuber_subs
FROM cleaned_data
ORDER BY Subscribers DESC
```

Rank category by total video views 
```
SELECT 
Category as category,
SUM(Video_Views) as views
INTO total_views
FROM cleaned_data
GROUP BY Category
ORDER BY SUM(Video_Views) DESC
```



Views to Subs to Ratio
```
SELECT 
Category,
CAST(SUM(CAST(Video_Views AS float)) / SUM(CAST(Uploads AS float)) / SUM(CAST(Subscribers AS float)) AS FLOAT) as view_subs_ratio
INTO views_subs
FROM cleaned_data
GROUP By Category
ORDER BY 2 DESC
```

Views to Subs to Ratio the last 30 days
```
SELECT 
Category,
CAST(SUM(CAST(Video_Views_For_The_Last_30_Days AS float)) / SUM(CAST(Uploads AS float)) / SUM(CAST(Subscribers_For_Last_30_Days AS float)) AS FLOAT) as view_subs_ratio
INTO views_subs_30days
FROM cleaned_data
WHERE Subscribers_For_Last_30_Days > 0
GROUP By Category
ORDER BY 2 DESC
```

Average Highest Yearly Earnings per category
```
SELECT
Category AS category,
AVG(Highest_Yearly_Earnings + Lowest_Yearly_Earnings) as avg_earning
INTO avg_earning
FROM cleaned_data
GROUP BY Category
ORDER BY 2 DESC
```

Number of uploads per year
```
SELECT 
YEAR(complete_date) as yr,
CAST(AVG(Video_Views) AS BIGINT) as views
INTO year_views
FROM cleaned_data
GROUP BY YEAR(complete_date)
ORDER BY 1
```

Gross Tertiary Enrollment Ratio 
```
SELECT 
Country, 
AVG(Gross_Tertiary_Education_Enrollment) / 100 as tertiary_enrollment
INTO tertiary_ratio
FROM cleaned_data
GROUP BY Country
ORDER BY AVG(Gross_Tertiary_Education_Enrollment) DESC
```

Unemployment Rate
```
SELECT 
Country, 
AVG(Unemployment_Rate) / 100 as Unemployment_Rate
INTO unemployment_rate
FROM cleaned_data
GROUP BY Country
ORDER BY AVG(Unemployment_Rate) DESC
```

#### Avg Earnings by Country
```
SELECT
Country,
AVG(Highest_Yearly_Earnings + Lowest_Yearly_Earnings) as avg_earnings
INTO earnings_country
FROM cleaned_data
GROUP BY Country
ORDER BY 2 DESC

```

## Overview of the results

![image](https://github.com/rfhtorres28/youtube_statistics_analysis/assets/153373159/61186214-aba9-45bf-ae0d-7d2d6fb2f761)
![image](https://github.com/rfhtorres28/youtube_statistics_analysis/assets/153373159/86647b7c-64df-4684-8dad-17979bd6bc27)
![image](https://github.com/rfhtorres28/youtube_statistics_analysis/assets/153373159/d6bff16f-750a-4e2c-9be6-563ff3a21880)
![image](https://github.com/rfhtorres28/youtube_statistics_analysis/assets/153373159/93f38f9d-fab5-4afe-be91-f40120f914ec)



## Insights

1. From the graph, we can see that Music has the most views and Travel and Events categories has the least views.
2. 2006 has the highest amount of views.
3. In terms of the demographic information, First World Countries has the highest tertiary enrollment ratio and this is expected since they
have more developed industries leading to higher wages that can support education expenses.
4. From the scatter plot, the unemployment rate has no linear relationship with the enrollment ratio meaning has nothing to do with the students enrolling in university or college. There are a lot of factors that can affect the tertiary enrollment rate. It can be financial supporting capability of a family, the decision of the student of not going the university and many more. 
