/*

Cleaning Data Sql Queries


*/

Select *
From PorfolioProject..NashvilleHousing

-------------------------------------------------------------------------------------------
--Standardize Data Format

Select SaleDateConverted, CONVERT(Date, SaleDate)
From PorfolioProject..NashvilleHousing

ALTER TABLE PorfolioProject..NashvilleHousing
Add SaleDateConverted Date;

Update PorfolioProject..NashvilleHousing
SET SaleDateConverted = Convert(Date, SaleDate)


-------------------------------------------------------------------------------------------
-- Populate Propety Adress Data


Select *
From PorfolioProject..NashvilleHousing
Order by ParcelID
--Where PropertyAddress is null


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PorfolioProject..NashvilleHousing a 
JOIN PorfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PorfolioProject..NashvilleHousing a 
JOIN PorfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

-------------------------------------------------------------------------------------------

--Breaking out Adress into Individual Columns (Adress, City, State)

Select PropertyAddress
From PorfolioProject..NashvilleHousing
--Order by ParcelID
--Where PropertyAddress is null

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
 ,SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
From PorfolioProject..NashvilleHousing

ALTER TABLE PorfolioProject..NashvilleHousing
Add PropetySplitAdress Nvarchar(255);

Update PorfolioProject..NashvilleHousing
SET PropetySplitAdress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE PorfolioProject..NashvilleHousing
Add PropetySplitCity Nvarchar(255);

Update PorfolioProject..NashvilleHousing
SET PropetySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

Select * 
From PorfolioProject..NashvilleHousing



Select OwnerAddress 
From PorfolioProject..NashvilleHousing

Select
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
From PorfolioProject..NashvilleHousing

ALTER TABLE PorfolioProject..NashvilleHousing
Add OwnerSplitAdress Nvarchar(255);

Update PorfolioProject..NashvilleHousing
SET OwnerSplitAdress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE PorfolioProject..NashvilleHousing
Add OwnerSplitCity  Nvarchar(255);

Update PorfolioProject..NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE PorfolioProject..NashvilleHousing
Add OwnerSplitState  Nvarchar(255);

Update PorfolioProject..NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)


-------------------------------------------------------------------------------------------

--Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From PorfolioProject..NashvilleHousing
Group by SoldAsVacant
order by 2


Select SoldAsVacant
, Case When SoldAsVacant = 'Y' THEN 'YES'
	   When SoldAsVacant = 'N' THEN 'NO'
	   Else SoldAsVacant
	   END
From PorfolioProject..NashvilleHousing

Update PorfolioProject..NashvilleHousing
SET SoldAsVacant = Case When SoldAsVacant = 'Y' THEN 'YES'
	   When SoldAsVacant = 'N' THEN 'NO'
	   Else SoldAsVacant
	   END
From PorfolioProject..NashvilleHousing

-------------------------------------------------------------------------------------------

-- Remove duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 SalePrice,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
From PorfolioProject..NashvilleHousing
--Order by ParcelID
)
Select *
From RowNumCTE
where row_num > 1
order by PropertyAddress
 

 
-------------------------------------------------------------------------------------------

-- Delete unused columns

--
Select*
From PorfolioProject..NashvilleHousing

ALTER TABLE PorfolioProject..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PorfolioProject..NashvilleHousing
DROP COLUMN SaleDate



