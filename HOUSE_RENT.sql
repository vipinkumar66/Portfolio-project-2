USE [Portfolio projcet];
--Analysing the data
SELECT * 
FROM dbo.House_Rent_Dataset$ 

SELECT COUNT(*) 
FROM dbo.House_Rent_Dataset$ 

SELECT MAX(H.Rent) Rent, MAX(H.Size) Size, MAX(H.Bathroom) Bathroom, MAX(H.BHK) BHK
FROM dbo.House_Rent_Dataset$ H

SELECT DISTINCT(H.city)
FROM dbo.House_Rent_Dataset$ H

SELECT H.[Area Type], H.[Furnishing Status], H.[Point of Contact], H.[Tenant Preferred], COUNT(H.[Area Type]) Total
FROM dbo.House_Rent_Dataset$ H
GROUP BY H.[Area Type], H.[Furnishing Status],H.[Point of Contact], H.[Tenant Preferred]


--Let's get our data ready for the data visualization

-- Analysing some numerical data
SELECT H.Rent, H.BHK, H.Size, H.Bathroom, H.City, H.[Area Locality]
FROM House_Rent_Dataset$ AS H
ORDER BY H.Rent DESC;

-- Average rent according to cities
DROP TABLE IF EXISTS #Avg_rent
CREATE TABLE #Avg_rent(
Avg_Rent INT,
City VARCHAR(30))
INSERT INTO #Avg_rent
SELECT AVG(H.Rent), H.City
FROM dbo.House_Rent_Dataset$ H
GROUP BY H.City; 

SELECT * FROM #Avg_rent
ORDER BY 1 DESC;

-- Maximum rent according to cities
DROP TABLE IF EXISTS #Max_rent
CREATE TABLE #Max_rent(
Max_rent INT,
City VARCHAR(30))
INSERT INTO #Max_rent
SELECT MAX(H.Rent), H.City
FROM dbo.House_Rent_Dataset$ H
GROUP BY H.City; 

SELECT * FROM #Max_rent
ORDER BY 1 DESC;

-- Minimum rent according to cities
DROP TABLE IF EXISTS #Min_rent
CREATE TABLE #Min_rent(
Min_Rent INT,
City VARCHAR(30))
INSERT INTO #Min_rent
SELECT Min(H.Rent), H.City
FROM dbo.House_Rent_Dataset$ H
GROUP BY H.City; 

SELECT * FROM #Min_rent
ORDER BY 1 DESC;

--Combining the avg, min and max values
SELECT ar.Avg_Rent, mxr.Max_rent, mir.Min_Rent, ar.City
FROM #Avg_rent ar
JOIN #Max_rent mxr 
on ar.City= mxr.City
JOIN #Min_rent mir
ON mxr.City=mir.City
ORDER BY 1 DESC 

--Total rent and size with respect to area type and city
SELECT SUM(H.Rent) AS Total_rent, SUM(H.Size) AS Total_size, H.[Area Type], H.City
FROM dbo.House_Rent_Dataset$ H
GROUP BY H.[Area Type], H.City
ORDER BY 1 DESC,2 DESC;

--Total rent with respect to furnishing status
SELECT H.[Furnishing Status], COUNT(H.[Furnishing Status]) AS total, SUM(H.Rent) AS Rent_total
From dbo.House_Rent_Dataset$ H
GROUP BY H.[Furnishing Status]
ORDER BY 2 DESC ,3 DESC

--Data on the basis of BHK

SELECT H.BHK, COUNT(H.[BHK]) Total, SUM(H.[Rent]) Total_rent, H.[Tenant Preferred], H.[Point of Contact], H.[City]
FROM dbo.House_Rent_Dataset$ H
GROUP BY H.BHK, H.[Point of Contact],H.[Tenant Preferred], H.[City]
ORDER BY 1 DESC,2 DESC, 3 DESC


--Area locality whose rent is more than the average rent
SELECT H.[Area Locality], H.City, H.Rent
FROM dbo.House_Rent_Dataset$ H
WHERE H.Rent>
(SELECT AVG(H.[Rent])
FROM dbo.House_Rent_Dataset$ H)
ORDER BY 3 DESC,2
