Data Cleaning in SQL

I am using Nashville Housing Data to clean the data

1. Standardise Data Format**

-- First execute the below query to see if the data format is what you wanted

SELECT SaleDate, STR_TO_DATE(SaleDate, '%d-%m-%Y')
FROM PortfolioProjects.nashvillehousingdata;

-- And then we will update the table using the below query

-- SET SQL_SAFE_UPDATES = 0; -- Run this if you get Safe Update error

UPDATE nashvillehousingdata
SET SaleDate = STR_TO_DATE(SaleDate, '%d-%m-%Y');


-- SET SQL_SAFE_UPDATES = 1; - Make sure to set it back to Safe mode

-- Finally run the below query to see if the date format has been updated

SELECT SaleDate
FROM PortfolioProjects.nashvillehousingdata;

2. Populating Missing Property Address based on ParcelID - There seem to be connection between Property Address and ParcelID. So we will self join the table to populate missing 
data in the property address column.

-- Same as before run the below query to see if propertyaddress is populated for null values

SELECT n1.ParcelID, n1.PropertyAddress, n2.ParcelID, n2.PropertyAddress,
IFNULL(n2.PropertyAddress, n1.PropertyAddress)
FROM PortfolioProjects.nashvillehousingdata n1
JOIN PortfolioProjects.nashvillehousingdata n2
ON n1.ParcelID = n2.ParcelID
AND n1.UniqueID <> n2.UniqueID
WHERE n1.PropertyAddress = '' or n1.PropertyAddress IS NULL;

-- Run the below query to update the table

SET SQL_SAFE_UPDATES = 0;

UPDATE PortfolioProjects.nashvillehousingdata n1
JOIN PortfolioProjects.nashvillehousingdata n2
     ON n1.ParcelID = n2.ParcelID
     AND n1.UniqueID <> n2.UniqueID
SET n1.PropertyAddress = IFNULL(n2.PropertyAddress,n1.PropertyAddress)     
WHERE n1.PropertyAddress = '' or n1.PropertyAddress IS NULL;

SET SQL_SAFE_UPDATES = 1;

3. Split Address into different columns

SELECT 
SUBSTRING_INDEX(PropertyAddress, ',', 1) as Address,
SUBSTRING_INDEX(PropertyAddress, ',', -1) as Address
FROM PortfolioProjects.nashvillehousingdata
;

-- Creating two new columns to include the split address

ALTER TABLE nashvillehousingdata
ADD Split_PropertyAddress VARCHAR(255);

UPDATE nashvillehousingdata
SET Split_PropertyAddress = SUBSTRING_INDEX(PropertyAddress, ',', 1);

ALTER TABLE nashvillehousingdata
ADD PropertyAddress_City VARCHAR(255);

UPDATE nashvillehousingdata
SET PropertyAddress_City = SUBSTRING_INDEX(PropertyAddress, ',', -1);

SELECT *
FROM PortfolioProjects.nashvillehousingdata;


4. Split Owner Address into different columns

SELECT OwnerAddress,
SUBSTRING_INDEX((SUBSTRING_INDEX(OwnerAddress, ',', 1)), ',', -1) As Address1,
SUBSTRING_INDEX((SUBSTRING_INDEX(OwnerAddress, ',', 2)), ',', -1) As Address2,
SUBSTRING_INDEX((SUBSTRING_INDEX(OwnerAddress, ',', 3)), ',', -1) As Address3
FROM PortfolioProjects.nashvillehousingdata;

ALTER TABLE nashvillehousingdata
ADD OwnerAddress_Split VARCHAR(255);

UPDATE nashvillehousingdata
SET OwnerAddress_Split = SUBSTRING_INDEX((SUBSTRING_INDEX(OwnerAddress, ',', 1)), ',', -1);

ALTER TABLE nashvillehousingdata
ADD OwnerAddress_City VARCHAR(255);

UPDATE nashvillehousingdata
SET OwnerAddress_City = SUBSTRING_INDEX((SUBSTRING_INDEX(OwnerAddress, ',', 2)), ',', -1);


ALTER TABLE nashvillehousingdata
ADD OwnerAddress_State VARCHAR(255);

UPDATE nashvillehousingdata
SET OwnerAddress_State = SUBSTRING_INDEX((SUBSTRING_INDEX(OwnerAddress, ',', 3)), ',', -1);


5. Cleaning SoldASVacant column by chaning Y to Yes and N to NO, so it's consistent.

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' then 'Yes'
     WHEN SoldAsVacant = 'N' then 'No'
     ELSE SoldAsVacant
     END
FROM PortfolioProjects.nashvillehousingdata;

UPDATE nashvillehousingdata
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' then 'Yes'
     WHEN SoldAsVacant = 'N' then 'No'
     ELSE SoldAsVacant
     END;

6. Delete Unused Columns

ALTER TABLE PortfolioProjects.nashvillehousingdata
DROP OwnerAddress, 
DROP COLUMN TaxDistrict, 
DROP COLUMN PropertyAddress;







	
