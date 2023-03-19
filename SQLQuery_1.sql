
---- Cleaning Data in SQL Queries



SELECT *
FROM Housing_Data

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format


SELECT CONVERT(DATE,SaleDate)
FROM Housing_Data


UPDATE Housing_Data
SET SaleDate = CONVERT(DATE,SaleDate)

-- If it doesn't Update properly

ALTER TABLE Housing_Data
ADD SaleDateConverted DATE;

UPDATE Housing_Data
SET SaleDateConverted = CONVERT(DATE,SaleDate)


 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

SELECT *
FROM Housing_Data
--Where PropertyAddress is null
ORDER BY ParcelID


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM Housing_Data a
JOIN Housing_Data b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM Housing_Data a
JOIN Housing_Data b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL




--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


SELECT PropertyAddress
FROM Housing_Data
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) AS Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) AS Address

FROM Housing_Data


ALTER TABLE Housing_Data
ADD PropertySplitAddress NVARCHAR(255);

UPDATE Housing_Data
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE Housing_Data
ADD PropertySplitCity NVARCHAR(255);

UPDATE Housing_Data
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




SELECT *
FROM Housing_Data





SELECT OwnerAddress
FROM Housing_Data


SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3) AS Owner_adress
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2) AS Owner_city
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1) AS Owmer_state
FROM Housing_Data



ALTER TABLE Housing_Data
ADD OwnerSplitAddress NVARCHAR(255);

UPDATE Housing_Data
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE Housing_Data
ADD OwnerSplitCity NVARCHAR(255);

UPDATE Housing_Data
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE Housing_Data
ADD OwnerSplitState NVARCHAR(255);

UPDATE Housing_Data
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



SELECT *
FROM Housing_Data


--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "So  ld as Vacant" field


SELECT DISTINCT(SoldAsVacant), Count(SoldAsVacant)
FROM Housing_Data
GROUP BY SoldAsVacant
ORDER BY 2




SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
FROM Housing_Data


UPDATE Housing_Data
SET SoldAsVacant = 
       CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END






-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
    SELECT *, 
	ROW_NUMBER() OVER (PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference ORDER BY UniqueID) AS row_num
    FROM Housing_Data
)
DELETE
FROM RowNumCTE
WHERE row_num > 1
--Order by PropertyAddress



SELECT *
FROM Housing_Data




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



SELECT *
FROM Housing_Data


ALTER TABLE Housing_Data
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate


























