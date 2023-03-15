-- Fuel Imports and Exports by country data exploration
-- Skills used: Joins, CTE's, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types


SELECT * FROM dbo.Countries
WHERE Region is NOT NULL

SELECT * FROM Dbo.Fuel_imports
ORDER BY 1,2

SELECT * FROM Dbo.Fuel_Exports
ORDER BY 1,2



--Showing just the countries
--The "Country_name" column in the Fuel imports and exports tables also include Regions like "Africa Western and Southern". i am going to pick just the countries.

SELECT * 
FROM dbo.[Fuel_imports] imp
JOIN dbo.[Countries] ctr 
ON imp.Country_Name = ctr.Country
WHERE ctr.Region IS NOT NULL


--Countries with hieghest precentage of fuel exports from total exports

Select ctr.Country, exp.Year, exp.Fuel_exports_as_precentage_of_total_exports
FROM dbo.[Fuel_Exports] exp
JOIN dbo.[Countries] ctr 
    ON exp.Country_Name = ctr.Country
WHERE ctr.Region IS NOT NULL



--Import VS Export 
--Showing the % of fuel imports from  total imports VS the % of fuel exports from total exports throughthout the years 


SELECT imp.Country_Name, imp.Year, imp.Fuel_imports_as_precentage_of_total_imports, exp.Fuel_exports_as_precentage_of_total_exports
FROM dbo.[Fuel_imports] imp
JOIN dbo.[Fuel_Exports] exp
	ON imp.Country_Name = exp.Country_Name
	and imp.Year = exp.Year


--Import VS Export average
--Showing the % of fuel imports from total imports VS the % of fuel exports from total exports on average 


SELECT imp.Country_Name, AVG(imp.Fuel_imports_as_precentage_of_total_imports) AS Fuel_imports_average, AVG(exp.Fuel_exports_as_precentage_of_total_exports) AS Fuel_exports_average
FROM dbo.[Fuel_imports] imp
JOIN dbo.[Fuel_Exports] exp
	ON imp.Country_Name = exp.Country_Name
	and imp.Year = exp.Year
--WHERE imp.Country_Name LIKE '%United States%'
GROUP BY imp.Country_Name
ORDER BY 1


---- Top income Groups Inporters and Exporters 

-- Top importers

Select imp.Year, ctr.IncomeGroup,AVG(imp.Fuel_imports_as_precentage_of_total_imports) AS Average_fuel_imports_precentage_in_the_income_group
FROM dbo.[Fuel_imports] imp
JOIN dbo.[Countries] ctr 
    ON imp.Country_Name = ctr.Country
WHERE ctr.IncomeGroup IS NOT NULL
GROUP BY ctr.IncomeGroup, imp.Year
ORDER BY 1,3 DESC

-- Top exporters

Select exp.Year, ctr.IncomeGroup,AVG(exp.Fuel_exports_as_precentage_of_total_exports) AS Average_fuel_exports_precentage_in_the_income_group
FROM dbo.[Fuel_exports] exp
JOIN dbo.[Countries] ctr 
    ON exp.Country_Name = ctr.Country
WHERE ctr.IncomeGroup IS NOT NULL
GROUP BY ctr.IncomeGroup, exp.Year
ORDER BY 1,3 DESC


---- BREAKING THINGS DOWN BY REGION


-- Showing regions with the highest Fuel Exports and Imports every year


WITH Region_highest_exp (Region, Year, Fuel_exports_Prec)
AS
(

SELECT ctr.Country AS Region, exp.Year, AVG(exp.Fuel_exports_as_precentage_of_total_exports) AS Fuel_exports_Prec
FROM dbo.[Fuel_exports] exp
JOIN dbo.[Countries] ctr
    ON exp.Country_Name = ctr.Country
WHERE ctr.Region IS NULL 
GROUP BY exp.Year, ctr.Country
)

Select reg.Region, reg.Year, reg.Fuel_exports_Prec, imp.Fuel_imports_as_precentage_of_total_imports
From Region_highest_exp reg
JOIN dbo.Fuel_imports imp
    ON imp.Country_Name = reg.Region
	and imp.Year = reg.Year
ORDER BY 2,3 DESC -- for highest fuel exports
--ORDER BY 2,4 DESC -- for highest fuel imports


-- Find the top 3 regions with the highest fuel exports precentage


Select *
 From  (
        SELECT exp.Country_Name AS Region, exp.Year, exp.Fuel_exports_as_precentage_of_total_exports AS Fuel_exports_Prec,
        DENSE_RANK() OVER(PARTITION BY exp.Year ORDER BY exp.Fuel_exports_as_precentage_of_total_exports DESC) AS rnk
        FROM dbo.[Fuel_exports] exp
        JOIN dbo.[Countries] ctr
            ON exp.Country_Name = ctr.Country
        WHERE ctr.Region IS NULL 
       ) scr
Where rnk < 4


---- Creating Views to store data for later visualizations

CREATE VIEW Just_countries AS 
SELECT * 
FROM dbo.[Fuel_imports] imp
JOIN dbo.[Countries] ctr 
ON imp.Country_Name = ctr.Country
WHERE ctr.Region IS NOT NULL



CREATE VIEW Import_VS_Export AS
SELECT imp.Country_Name, imp.Year, imp.Fuel_imports_as_precentage_of_total_imports, exp.Fuel_exports_as_precentage_of_total_exports
FROM dbo.[Fuel_imports] imp
JOIN dbo.[Fuel_Exports] exp
	ON imp.Country_Name = exp.Country_Name
	and imp.Year = exp.Year



