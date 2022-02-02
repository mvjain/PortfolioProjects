
Select *
From [Portfolio Project1]..NashvilleHousing


Select SaleDate , CONVERT( date, SaleDate)
From [Portfolio Project1]..NashvilleHousing

Update NashvilleHousing
Set SaleDate = CONVERT(date, SaleDate)

Alter Table NashvilleHousing
Add SaleDateConverted Date;


Update NashvilleHousing
Set SaleDateConverted  = CONVERT(date, SaleDate)

Select SaleDateConverted, CONVERT( date, SaleDate)
From [Portfolio Project1]..NashvilleHousing

----Populate Property Address----

Select *
From [Portfolio Project1]..NashvilleHousing
--Where PropertyAddress is null
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
From [Portfolio Project1]..NashvilleHousing a
Join [Portfolio Project1]..NashvilleHousing b
  on a.ParcelID = b.ParcelID
  And a.UniqueID <> b.UniqueID
where a.PropertyAddress is null

Update a
Set PropertyAddress  = isnull(a.PropertyAddress, b.PropertyAddress)
From [Portfolio Project1]..NashvilleHousing a
Join [Portfolio Project1]..NashvilleHousing b
  on a.ParcelID = b.ParcelID
  And a.UniqueID <> b.UniqueID


 --- Breaking Aress into individual columns

 Select PropertyAddress
From [Portfolio Project1]..NashvilleHousing

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress)+ 1, LEN(PropertyAddress)) as Address
From [Portfolio Project1]..NashvilleHousing

Alter Table NashvilleHousing  -- adding column to the table
Add PropertySplitAddress Nvarchar(255);


Update NashvilleHousing
Set PropertySplitAddress  = SUBSTRING(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress)-1)

Alter Table NashvilleHousing
Add PropertySplitCity Nvarchar(255);


Update NashvilleHousing
Set PropertySplitCity  = SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress)+ 1, LEN(PropertyAddress))


Select *
From [Portfolio Project1]..NashvilleHousing



Select OwnerAddress
From [Portfolio Project1]..NashvilleHousing

---Alternative method 

Select 
PARSENAME(replace(OwnerAddress, ',', '.'),3),
PARSENAME(replace(OwnerAddress, ',', '.'),2),
PARSENAME(replace(OwnerAddress, ',', '.'),1)

From [Portfolio Project1]..NashvilleHousing



Alter Table NashvilleHousing
Add OwnerSplitAddress  Nvarchar(255);


Update NashvilleHousing
Set OwnerSplitAddress  = PARSENAME(replace(OwnerAddress, ',', '.'),3)


Alter Table NashvilleHousing  -- adding column to the table
Add OwnerSplitCity Nvarchar(255);


Update NashvilleHousing
Set OwnerSplitCity  = PARSENAME(replace(OwnerAddress, ',', '.'),2)

Alter Table NashvilleHousing
Add OwnerSplitState	 Nvarchar(255);


Update NashvilleHousing
Set OwnerSplitState  = PARSENAME(replace(OwnerAddress, ',', '.'),1)

---Changing Y and N to Yes and No in " Sold as Vacant" field

Select Distinct(SoldAsVacant), count(SoldAsVacant)
From [Portfolio Project1]..NashvilleHousing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant,
CASE when SoldAsVacant = 'Y' then 'Yes'
     when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 end
From [Portfolio Project1]..NashvilleHousing

Update NashvilleHousing
Set SoldAsVacant = CASE when SoldAsVacant = 'Y' then 'Yes'
     when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 end


---Remove Duplicates

With RowNumCTE As(
Select * ,
     Row_Number() over (
	 Partition by ParcelID,
	              PropertyAddress, 
	              SalePrice,
				  SaleDate, 
	              LegalReference
				  order by 
				  UniqueID
				  ) row_num
From [Portfolio Project1]..NashvilleHousing
--order by ParcelID
)
select *
From RowNumCTE
Where row_num >1
--Order by PropertyAddress

	
	
	
--Delete Unused Columns

Select *
From [Portfolio Project1]..NashvilleHousing

Alter table [Portfolio Project1]..NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

Alter table [Portfolio Project1]..NashvilleHousing
Drop Column SaleDate

