# Peter RL XUE
# 2023-07
# This file automatically scrapes 1950-2020 monthly data from ERA5-land. It may take some time to complete the download process.
# source: https://cds.climate.copernicus.eu/cdsapp#!/dataset/reanalysis-era5-land-monthly-means?tab=overview

# Import time module
import time

# record start time
start = time.time()

# create empty list
year=[];
for i in range(2013,2014,1):  # You can change 2013 into 1950 and 2014 into 2020.
    year.append(str(i))
print(year)

month=[];
for i in range(1,12,1): # January to December.
    num=str(i)
    if i<10:          # add zero to 1-9 to avoid potential errors.
       addzero = num.zfill(2)
    else:
        addzero=num
    month.append(addzero)
print(month)

filename=[]
for i in year:
    for j in month:
        ans="rainfall_"+i+"_"+j+".nc"
        filename.append(ans)

# download data
import cdsapi
for i in year:
    for j in month:
        c = cdsapi.Client()
        text='current downloading: temper'+'_'+i+"_"+j
        print(text)
        c.retrieve(
            'reanalysis-era5-land-monthly-means',
            {
                'product_type': 'monthly_averaged_reanalysis',
                #'variable': 'total_precipitation',
                'variable':'2m_temperature',
                'year': i,
                'month': j,
                'format': 'netcdf',
                'time': '00:00',
            },
            #"rainfall_"+i+"_"+j+".nc"
            "temper_"+i+"_"+j+".nc"
            )


# record end time
end = time.time()

# print the difference between start and end time in seconds
print("The time of execution of above program is :",
	(end-start), "s")



# Pycharm: alt+shift+e (run selected lines)
