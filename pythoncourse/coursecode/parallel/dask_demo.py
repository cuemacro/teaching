import pandas as pd
import dask.dataframe as dd
import dask

# change to your path!
raw_data_path = '/home/redhat/cuemacro/pythoncourse/pythoncourse/notebooks/raw_data/'

df_dask  = dd.read_parquet(raw_data_path + 'EURUSD_2019.gzip')

# need to reset the index (and tell Dask, it is already sorted)
df_dask = df_dask.reset_index()
df_dask = df_dask.set_index('Date', sorted=True)

# calculate the spread
df_dask_spread = 10000.0 * (df_dask['EURUSD.ask'] - df_dask['EURUSD.bid'])/ \
    ((df_dask['EURUSD.ask'] + df_dask['EURUSD.bid'])/2.0)

# get the average spread per minute
df_dask_spread = df_dask_spread.resample(rule='1min').mean()
df_dask_spread = df_dask_spread.dropna()
