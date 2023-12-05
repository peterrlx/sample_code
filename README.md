# Readme

- This repository contains various codes that I have written to extract, clean, re-organize, and analyze data for RA work, course projects, or other purposes.   
- In this readme file, I briefly describe what each file in each folder does.     
- Datasets related to the code commands are not included in this repo. To run some of the codes successfully, you may need the data files, which are available upon request. 

## RA work
selected files of past RA work.
- `gen_csv_wb_data.ipynb`: convert netcdf files downloaded from World Bank climate change databse into csv files.
- `clean_ERA5.m` and `gen_panel_ERA5.do`: The `.m` file uses powerplant location information to find the temperature and rainfall at that location based on netcdf spaital data extracted from ERA5-land (a dataset from Copernicus Climate Change Service). The matching target is latitude and longitude. Then, the `.do` file generates a panel by merging powerplant data with ERA-5 temperature & rainfall data.
- `download_ERA5_monthly_data.py`: This file automatically scrapes 1950-2020 monthly data from ERA5-land. It may take some time to complete the download process.

## Course projects or homework
- `model0.mod`: The code used to simulate a simplified version of the dynamic general equilibrium model in my thesis. There are only DMP-type labor market frictions. Workers find themselves either unemployed or employed. When unemployed, workers receive a transfer payment from the government. When employed, workers receive wages and exert work effort. The separation rate and job-finding rate are exogeneous. Firms are subject to quadratic labor adjustment costs since recruitment is costly. In this simplified model (20 equations with 20 endogenous variables), financial frictions are not considered, work effort is now fixed, and wages are determined by standard Nash bargaining (i.e., flexible wage). Only productivity shocks are considered. We can find that the model underpredicts the standard deviation of labor market tightness (relative to output) with US quarterly data.

- `fin065_vc_hw.do`: Homework for venture capital course. The dateset given is US venture capital investments from the VentureXpert database. The requirement is to perform some basic data analysis (e.g., compute the number of startups that have exited through IPO or acquisitions, investigate whether CVC-backed startups are more likely to exit through IPO than VC-backed startups, etc.). 
- `ec530_applied_micro_hw.do`: Homework for applied micro course. The problem set is based on the paper Almond, Chay, and Lee (2005). The requirement is to estimate the causal effect of maternal smoking during pregnancy on infant birthweight and other infant health outcomes based on propensity score approach. The data for the problem set is an extract of all births from the 1993 National Natality Detail Files for Pennsylvania. Each observation represents an infant-mother match.
- `analyze_pokeball.do`: code for the exercise at https://raguide.github.io/new_email. 
- `macro_RBC_habit_BK.m`: Homework 5 for advanced macro I. It solves a RBC model with habit formation by BK method.
- `py_text_analysis_hw.py`: text analysis homework for python intro course (undergrad).
- `summer_school_uchicago.R`: Homework for "Programming in R" at UChicago summer school (undergrad).



<!-- ## Others -->