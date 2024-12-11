-- 1. ���������� ���������� ������� ���������� ������������
Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject1..CovidDeaths
Where continent is not null
order by 1,2

-- 2. �������� view � ��������� ������� �� ���� ����
Create View WorldTotalDeaths as
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject1..CovidDeaths
where continent is not null 

-- 3. �������� view � ���-��� ������� �� �����������
Create View ContinentDeathCount as
Select Location, MAX(cast(Total_deaths as int)) AS TotalDeath 
From PortfolioProject1..CovidDeaths
Where continent is not null
and location not in ('World', 'European Union', 'International')
Group by Location

-- 4. ������� view � ������ �������� ���������� ��������� �� ��������� � ���������
Create View HighestInfectionRate as
Select Location, population, MAX(total_cases) AS HighestInfRate, MAX(ROUND((total_cases / population) * 100, 4)) AS CasesPercent 
From PortfolioProject1..CovidDeaths
GROUP BY Location, population

-- 5. ������� ����� �� view ��� ����. �� ������������� � ������������ �� ����
Create View DateCasesPercent as
Select Location, population, date, MAX(total_cases) AS HighestInfRate, MAX(ROUND((total_cases / population) * 100, 4)) AS CasesPercent 
From PortfolioProject1..CovidDeaths
GROUP BY Location, population, date
