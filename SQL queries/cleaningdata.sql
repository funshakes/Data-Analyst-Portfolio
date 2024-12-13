-- Изменим формат даты с созданием нового столбца
ALTER TABLE Housing
ADD SaleDateConverted Date;

UPDATE Housing
SET SaleDateConverted = CONVERT(date, SaleDate)


-- Меняем значение null в столбце PropertyAddress на значение если есть по похожему ParcelID
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress) 
FROM PortfolioProject1.dbo.Housing a
JOIN PortfolioProject1.dbo.Housing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL


-- Добавляем новые с разбитым адресом дома на адрес, город
ALTER TABLE Housing
ADD PropertySplitAddress Nvarchar(255);

UPDATE Housing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)

ALTER TABLE Housing
ADD PropertySplitCity Nvarchar(255);

UPDATE Housing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))


-- Добавляем новые столбцы с разбитым другим способом адресом владельца на адрес, город, штат
ALTER TABLE Housing
ADD OwnerSplitAddress Nvarchar(255);

UPDATE Housing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE Housing
ADD OwnerSplitCity Nvarchar(255);

UPDATE Housing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE Housing
ADD OwnerSplitState Nvarchar(255);

UPDATE Housing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)


-- Приведем значения в столбце SoldAsVacant к единому виду
UPDATE Housing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
						WHEN SoldAsVacant = 'N' THEN 'NO'
						ELSE SoldAsVacant
						END
FROM PortfolioProject1..Housing


-- Удалим дубликаты из таблицы
WITH temp AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
	ORDER BY ParcelID
	) row_num
FROM ..Housing
)
DELETE
FROM temp
WHERE row_num > 1



-- Удаляем неиспользуемые столбцы
ALTER TABLE PortfolioProject1.dbo.Housing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate