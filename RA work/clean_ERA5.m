% Peter RL Xue
% 2023-07

% This file generates yearly temperature and rainfall for each powerplant location from 2013-2019.
% It takes about 4 minutes to run this script. 
% The output is "clean_ERA5_output.xlsx".

tic


clear all, clc


%% rearrange data
% iteration 
year = [2013,2014,2015,2016,2017,2018,2019];

% create a list of names of climate data

for k = 1:length(year)
    temp_file{k} = ['temp' '_' num2str(year(k),'%02d') '_' 'R.nc']; 
    rainfall_file{k} = ['rainfall' '_' num2str(year(k),'%02d') '_' 'R.nc']; % cell Array
end


powerplant = readtable('global_power_plant_database.csv'); % import powerplant data

for k = 1:length(year) % k is index for each year, k=1,2,...,7
    
    j=year(k); % j=2013, 2014, ..., 2019
    
    % read variables of powerplants, convert table to matrix, round coordinates (1 decimal digit)
    identifier{k}= table2array(powerplant(:,4)); % powerplant ID
      
    lon_target{k} = round(table2array(powerplant(:,7)).',1); % longitude of powerplant
    lat_target{k} = round(table2array(powerplant(:,6)).',1); % latitude of powerplant
    dim = max(size(lon_target{k},2),size(lat_target{k},2)); % the number of targets (powerplant observations)

    % import netcdf climate data from ERA5-land
    temp_nc{k} = temp_file{k}; % temperature
    ncdisp (temp_nc{k},'/','min')
    rainfall_nc{k} = rainfall_file{k}; %total precipitation
    ncdisp (rainfall_nc{k},'/','min')
    
    % read variables of netcdf files 
    temper{k} = ncread(temp_nc{k}, '2m_temperature');
    rainfall{k} = ncread(rainfall_nc{k}, 'total_precipitation');
    lon{k} = round(ncread(temp_nc{k},'longitude'),1); % round the data
    lat{k} = round(ncread(temp_nc{k},'latitude'),1);% round the data
    
    % match longitude and latitude in the nc file with targets in the csv file
    for i = 1:dim
        LON = find(lon{k}==lon_target{k}(i));
        LAT = find(lat{k}==lat_target{k}(i));
            if isempty(LON)||isempty(LAT)
                disp('Error (location cannot match)');
                break
            end
       Temper{k}(:,i)=temper{k}(LON,LAT); % obtain temperature for target coordinates
       Rainfall{k}(:,i)=rainfall{k}(LON,LAT);% obtain total precipitation for target coordinates
    end
    % convert dimensional array to column vector array for one location
    location{k} = [lon_target{k}; lat_target{k}].';
    
    %create time
    date1{k}=[j];
    date1{k}=repelem(date1{k},dim).';
    
    
    Temper_new{k}=Temper{k}.'; % transpose var in order to merge later
    Rainfall{k}=Rainfall{k}.*1000; % convert Meter to Millimeters
    Rainfall_new{k}=Rainfall{k}.'; % transpose var in order to merge later
end

%% write into excel 

output='clean_ERA5_output.xlsx';
sheet=1;
Varlist={'identifier','year','longitude','latitude','temperature','rainfall'};
xlswrite(output,Varlist,sheet,'A1');

% pin down cells to store data
count = 0; % define a count number

% write powerplant identifier in column A

for k = 1:length(year)
   kk = 2 + count;
   A{k} = ['A' num2str(kk,'%u')];% Cell Array
   xlswrite(output,identifier{k},sheet,A{k});
   count = count + dim;
end

count = 0;
% write year in column B
for k = 1:length(year)
   kk = 2 + count;
   B{k} = ['B' num2str(kk,'%u')];% Cell Array
   xlswrite(output,date1{k},sheet,B{k});
   count = count + dim;
end

count = 0;
% write longitude and latitude in column C and D
for k = 1:length(year)
   kk = 2 + count;
   CD{k} = ['C' num2str(kk,'%u')];% Cell Array
   xlswrite(output,location{k},sheet,CD{k});
   count = count + dim;
end

count = 0;
% write temperature in column E
for k = 1:length(year)
   kk = 2 + count;
   E{k} = ['E' num2str(kk,'%u')];% Cell Array
   xlswrite(output,Temper_new{k},sheet,E{k});
   count = count + dim;
end

count = 0;
% write rainfall in column F
for k = 1:length(year)
   kk = 2 + count;
   F{k} = ['F' num2str(kk,'%u')];% Cell Array
   xlswrite(output,Rainfall_new{k},sheet,F{k});
   count = count + dim;
end
 
toc