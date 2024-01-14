# Top Youtuber Statistics Performance (2022)

## Authors
* [rfhtorres28](https://github.com/rfhtorres28)
  
## Project Overview
Hello there! This project is all about the analysis of Performance of Top Youtuber in 2022. I performed the analysis using Microsoft SQL Server Management Studio and Python for Data Quality Assessment and Exploratory Data Analysis. For Data Visualization, I used Power BI and Python's Matplotlib and Seaborn Libraries.  

## Data Source
* The CSV files were downloaded from kaggle website. I created a database on SQL Server and make tables for each file. 

## Tools 
* SQL Server - Data Wrangling / Exploratory Data Analysis
* Python - Data Cleaning 
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
  For each questions, I used group-by with aggregation method and created a table for it. Each resulting table was transferred to Power Bi for Data Visualization. 

## Python Data Cleaning

import necessary libraries 
```
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import pyodbc 
```
Load the CSV file
```
data = pd.read_csv(r"C:\Users\bobby\Desktop\Python\Global Youtube Statistics 2023\Global YouTube Statistics.csv", encoding= 'windows-1252')
data.head()
```
![mytable](https://github.com/rfhtorres28/youtube_statistics_analysis/assets/153373159/8d80160a-2db4-4ad1-8dcc-85ab1922bca1)

Inspect unecessary characters from the column
```
data.columns
```
![image](https://github.com/rfhtorres28/youtube_statistics_analysis/assets/153373159/9c18ee08-2d9b-4cad-9cba-e8f7eb3fa249)

Replace uncessary characters on each column title and capitalize each word
```
data.columns = data.columns.str.replace(' ','_')  
data.columns = data.columns.str.replace(' (%)','')  
data.columns = data.columns.str.replace('_(%)','')  
data.columns = data.columns.str.title()
```
Drop duplicate columns. In this case, Youtuber and title has the same category values. Abbreviation also is not necessary since there is already the country column
```
data = data[['Youtuber', 'Subscribers', 'Video_Views', 'Category',
       'Uploads', 'Country', 'Channel_Type',
       'Video_Views_Rank', 'Country_Rank', 'Channel_Type_Rank',
       'Video_Views_For_The_Last_30_Days', 'Lowest_Monthly_Earnings',
       'Highest_Monthly_Earnings', 'Lowest_Yearly_Earnings',
       'Highest_Yearly_Earnings', 'Subscribers_For_Last_30_Days',
       'Created_Year', 'Created_Month', 'Created_Date',
       'Gross_Tertiary_Education_Enrollment', 'Population',
       'Unemployment_Rate', 'Urban_Population', 'Latitude', 'Longitude']]
```

Replace underscore character with space for each object column
```
data['Youtuber'] = data['Youtuber'].str.replace('_', ' ')
data['Category'] = data['Category'].str.replace('_', ' ')
data['Country'] = data['Country'].str.replace('_', ' ')
data['Channel_Type'] = data['Channel_Type'].str.replace('_', ' ')
data['Created_Month'] = data['Created_Month'].str.replace('_', ' ')
```
Capitalize each word for each object column
```
data['Youtuber'] = data['Youtuber'].str.title()
data['Category'] = data['Category'].str.title()
data['Country'] = data['Country'].str.title()
data['Channel_Type'] = data['Channel_Type'].str.title()
data['Created_Month'] = data['Created_Month'].str.title()
```
Check if the format is good
```
data.loc[:, object_column] 
```
![image](https://github.com/rfhtorres28/youtube_statistics_analysis/assets/153373159/da3c8961-619b-4fc7-8476-bdedda72d006)

Check if there are any duplicate rows
```
data.duplicated().any()
```
![image](https://github.com/rfhtorres28/youtube_statistics_analysis/assets/153373159/c150758d-a69e-4e53-a4fa-718df286b08b)

List all the numeric column for detection of outliers
```
numeric_column = [ col for col, dt in data.dtypes.items() if ((dt == int) | (dt == float))] 
numeric_column
```
IQR rule to use for the skewed distribution and Standard Deviation Rule for symmetric distribution
```
q25, q75 = np.percentile(data['Video_Views'], (25,75))
iqr = q75 - q25 
min_1 = q25 - 1.5*iqr 
max_1 = q75 + 1.5*iqr
sns.boxplot(x=data['Video_Views']);
```
![image](https://github.com/rfhtorres28/youtube_statistics_analysis/assets/153373159/0d5ad4e2-823b-4b23-a470-acc20a873ac4)

Show some of the outliers in the video views
```
data['Video_Views'].loc[data['Video_Views'] > max_1].head()
```
![image](https://github.com/rfhtorres28/youtube_statistics_analysis/assets/153373159/894e2f67-7a96-4ed2-8076-80b48cc3ac4a)

* In this case, we will retain these values since they are valid number of video views in youtube


























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



### Insights

1. From the graph, we can see that Music has the most views and Travel and Events categories has the least views.
2. 2006 has the highest amount of views.
3. In terms of the demographic information, First World Countries has the highest tertiary enrollment ratio and this is expected since they
have more developed industries leading to higher wages that can support education expenses.
4. From the scatter plot, the unemployment rate has no linear relationship with the enrollment ratio meaning has nothing to do with the students enrolling in university or college. There are a lot of factors that can affect the tertiary enrollment rate. It can be financial supporting capability of a family, the decision of the student of not going the university and many more. 
