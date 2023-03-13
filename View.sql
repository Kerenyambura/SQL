/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [continent]
      ,[location]
      ,[date]
      ,[population]
      ,[new_vaccinations]r
      ,[RollingPeopleVaccinated]
  FROM [PortfolioProject].[dbo].[PercentPopulationVaccinated]