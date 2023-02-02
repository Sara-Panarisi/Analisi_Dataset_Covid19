/* 
'COVID 19' DATA EXPLORATION 
*/

-- Visualizzo per intero le tabelle

SELECT * 
FROM PortfolioProject..CovidDeaths 
WHERE continent is not null
ORDER BY location, date;

SELECT * 
FROM PortfolioProject..CovidVaccinations
WHERE continent is not null
ORDER BY location, date;

-- Seleziono i dati con cui iniziare l'analisi

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
WHERE continent is not null 
ORDER BY location, date;



-- Dati aggregati relativi a tutto il mondo (casi di positività totali, morti totali e percentuale del rapporto positività/morti) 

-- 1. Divisi per data

SELECT date, SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS INT)) AS total_deaths, SUM(CAST(new_deaths AS INT))/SUM(New_Cases)*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP BY date
ORDER BY total_cases, total_deaths;

-- 2. In generale, senza suddivisioni

SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS INT)) AS total_deaths, SUM(CAST(new_deaths AS INT))/SUM(New_Cases)*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent is not null;



-- Dati suddivisi per Continente

-- I Continenti con il numero maggiore di morti

SELECT location, MAX(CAST(Total_deaths AS INT)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is null 
GROUP BY location
ORDER BY TotalDeathCount DESC;



-- Dati suddivisi per Paese

-- Paesi con la percentuale di positivi più alta in relazione alla popolazione

SELECT Location, Population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC;

-- Paesi con il rapporto numero di morti/popolazione più alto

SELECT Location, MAX(CAST(Total_deaths AS INT)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is not null 
GROUP BY Location
ORDER BY TotalDeathCount DESC;

-- Percentuale delle persone che hanno ricevuto almeno un vaccino

SELECT dea.continent, dea.location, dea.date, dea.population, vac.total_vaccinations, (vac.total_vaccinations/population)*100 AS PercentagePeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null 
ORDER BY location, date;



-- Dati relativi all'Italia

-- Percentuale delle morti in relazione al totale dei casi in Italia

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE location = 'Italy'
  AND continent is not null 
ORDER BY date;

-- Percentuale dei casi totali rispetto alla popolazione totale in Italia

SELECT Location, date, Population, total_cases, (total_cases/population)*100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
WHERE location = 'Italy'
  AND continent is not null 
ORDER BY date;

-- Percentuale delle persone che hanno ricevuto almeno un vaccino in Italia

SELECT dea.continent, dea.location, dea.date, dea.population, vac.total_vaccinations, (vac.total_vaccinations/population)*100 AS PercentagePeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.location = 'Italy'
ORDER BY date DESC;