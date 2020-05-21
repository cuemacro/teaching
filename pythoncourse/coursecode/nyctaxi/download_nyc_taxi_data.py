raw_data_path = 'raw_data/nyc_taxi/'

file_key = "nyc-20*.gzip"
arrow_file_key = "nyc-20*.arrow"

# If you have a fast internet connection (and lot of disk space and RAM)... load everything!
years = [2015, 2016, 2017, 2018, 2019]
months = list(range(1, 12 + 1)) # All 12 months!

# Otherwise just download Feb/Mar 2015
# years = [2015]; months = [2, 3]

import urllib
import os
import pandas as pd

import requests

def clean_dataframe(df, year, month):
    # Create index based upon pick up time and convert pickup/dropoff
    # to datetime64 format which is easier to work with
    date_cols = ['tpep_pickup_datetime', 'tpep_dropoff_datetime']

    # Drop any 'Unnamed' columns
    df.drop(list(df.filter(regex='Unnamed')), axis=1, inplace=True)

    print('Converting to date/time and adding index {}-{}'.format(year, month))

    for d in date_cols:
        df[d] = pd.to_datetime(df[d])

    df = df.set_index('tpep_pickup_datetime')

    return df

# Add fields for longtitude/latitude in Web Mercator format
from pyproj import Proj, transform

def add_web_mercator_coordinates(df):
    inProj, outProj = Proj('epsg:4326'), Proj('epsg:3857')

    def to_web_mercator_lon_lat(lon, lat):
        return transform(inProj, outProj, lat.values, lon.values)

    # Only apply transforms if exact coordinate columns exist
    if 'pickup_longitude' in df.columns and 'pickup_latitude' in df.columns:
        df['pickup_longitude_m'], df['pickup_latitude_m'] \
            = to_web_mercator_lon_lat(df['pickup_longitude'], df['pickup_latitude'])

    if 'dropoff_longitude' in df.columns and 'dropoff_latitude' in df.columns:
        df['dropoff_longitude_m'], df['dropoff_latitude_m'] \
            = to_web_mercator_lon_lat(df['dropoff_longitude'], df['dropoff_latitude'])

    return df


def get_cols(url):
    s = requests.get(url, headers={'Range': 'bytes=%s-%s' % (0, 10000)}).text
    cols = list(pd.read_csv(StringIO(s)).columns)

    extra_cols = 0
    keep_reading = True

    while keep_reading:
        try:
            pd.read_csv(StringIO(s), names=cols, index_col=False, skiprows=1)
            keep_reading = False
        except:
            cols.append("Unnamed: " + str(extra_cols))
            extra_cols = extra_cols + 1

    return cols

# Download the monthly CSV files for yellow NYC Taxis, if they aren't already on disk
# and clean DataFrame and add additional columns for coordinates in web Mercator format
# before dumping output to Parquet files
from io import StringIO

for year in years:
    for month in months:
        parquet_file = raw_data_path + "nyc-{}-{:0=2d}.gzip".format(year, month)
        csv_file = raw_data_path + "nyc-{}-{:0=2d}.csv".format(year, month)

        if os.path.exists(parquet_file):
            print('Already downloaded {}-{}'.format(year, month))
        else:
            print('Downloading {}-{}'.format(year, month))
            url = "https://s3.amazonaws.com/nyc-tlc/trip+data/" + \
                  "yellow_tripdata_{}-{:0=2d}.csv".format(year, month)

            # Some of the NYC Taxi can have extra cols, without header names
            # So we extract the headers separately (and add additional empty header names)
            cols = get_cols(url)

            # Load the full CSV from web, skipping the first row and reuse the header names
            # we just extracted
            df = pd.read_csv(url, header=None, skiprows=1, names=cols, index_col=False)

            # It might prove useful for debugging to dump to CSV
            # df.to_csv(csv_file)
            # df = pd.read_csv(csv_file)
            # df = pd.read_parquet(parquet_file)

            df = clean_dataframe(df, year, month)
            df = add_web_mercator_coordinates(df)
            df.to_parquet(parquet_file, engine='fastparquet')

import vaex

# Grab the years and months specified at the top of the notebook
years_vaex = [2015]; months_vaex = months

# If we want Feb/Mar 2015 only (if we have slow internet, and very little hard disk space)
# years_vaex = [2015]; months_vaex = [2, 3]

arrow_file_list = []

for year in years_vaex:
    for month in months_vaex:
        parquet_file = raw_data_path + "nyc-{}-{:0=2d}.gzip".format(year, month)
        arrow_file = raw_data_path + "nyc-{}-{:0=2d}.arrow".format(year, month)

        if os.path.exists(parquet_file) and not (os.path.exists(arrow_file)):
            print('Convert Parquet file into Arrow file for {}-{}'.format(year, month))

            df_parquet = pd.read_parquet(parquet_file, engine='fastparquet')
            df_vaex = vaex.from_pandas(df_parquet)
            df_vaex.export(arrow_file)
        elif os.path.exists(arrow_file):
            print('Arrow file already exists for {}-{}'.format(year, month))

        if os.path.exists(arrow_file):
            arrow_file_list.append(arrow_file)