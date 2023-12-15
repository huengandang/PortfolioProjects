select * 
from PortfolioProject.dbo.NashvilleHousing

-- standardize date format 
select SaleDate
from PortfolioProject.dbo.NashvilleHousing

select SaleDateConverted, convert (Date, SaleDate)
from PortfolioProject.dbo.NashvilleHousing

update NashvilleHousing
set SaleDate = convert(Date, SaleDate)

ALTER TABLE NashvilleHousing
add SaleDateConverted Date;

Update NashvilleHousing
Set SaleDateConverted = convert (Date, SaleDate)

--populate property address data 
select *
from PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


--breaking out address into individual columns (address, city, state)

select PropertyAddress
from PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
--order by ParcelID

select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1,len(PropertyAddress)) as Address
--if remove + 1, a comma go with address

from PortfolioProject.dbo.NashvilleHousing

alter table NashvilleHousing
add SaleDateConverted Date;

update NashvilleHousing
set SaleDateConverted = converted(Date, SaleDay)

alter table NashvilleHousing
add SaleDateConverted Date;

update NashvilleHousing
set SaleDateConverted = converted(Date, SaleDay)

alter table NashvilleHousing
add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


alter table NashvilleHousing
add PropertySplitCity Nvarchar(255)

Update NashvilleHousing
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1,len(PropertyAddress))


select * 
from PortfolioProject.dbo.NashvilleHousing


select OwnerAddress
from PortfolioProject.dbo.NashvilleHousing

select 
PARSENAME(replace(OwnerAddress,',','.'), 3) 
,PARSENAME(replace(OwnerAddress,',','.'), 2)
,PARSENAME(replace(OwnerAddress,',','.'), 1)


from PortfolioProject.dbo.NashvilleHousing

alter table NashvilleHousing
add OwnerSplitAddress Nvarchar(255)

Update NashvilleHousing
set OwnerSplitAddress =PARSENAME(replace(OwnerAddress, ',', '.'),3)

alter table NashvilleHousing
add OwnerSplitCity Nvarchar(255)

Update NashvilleHousing
set OwnerSplitCity = PARSENAME(replace(OwnerAddress, ',', '.'),2)

alter table NashvilleHousing
add OwnerSplitState Nvarchar(255)

Update NashvilleHousing
set OwnerSplitState = PARSENAME(replace(OwnerAddress, ',', '.'),1)

select *
from PortfolioProject.dbo.NashvilleHousing

--Change Y and N to Yes and No in Sold as Vacant field 
select distinct (SoldAsVacant), count(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2

select SoldAsVacant
, case when SoldAsVacant = 'Y' Then 'Yes'
		when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
		end
from PortfolioProject.dbo.NashvilleHousing

update NashvilleHousing
set SoldAsVacant = case when SoldAsVacant = 'Y' Then 'Yes'
		when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
		end

-- remove duplicates
with RowNumCTE as(
select *,
	ROW_NUMBER() over(
	Partition by ParcelID,
					PropertyAddress,
					SalePrice,
					SaleDate,
					LegalReference
					order  by 
					uniqueID
					) row_num

from PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)

delete
from RowNumCTE
where row_num > 1 
--order by PropertyAddress

--delete unused columns

select * 
from PortfolioProject.dbo.NashvilleHousing

alter table PortfolioProject.dbo.NashvilleHousing
drop column OwnerAddress, TaxDistrict, PropertyAddress


alter table PortfolioProject.dbo.NashvilleHousing
drop column SaleDate