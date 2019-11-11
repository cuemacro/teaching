# Author: Gael Varoquaux gael.varoquaux@normalesup.org
# License: BSD 3 clause

import sys

import numpy as np
import matplotlib.pyplot as plt
from matplotlib.collections import LineCollection

import pandas as pd

from sklearn import cluster, covariance, manifold

print(__doc__)

# #############################################################################
# Retrieve the data Quandl

symbol_dict = {
    'FRED/DEXUSEU' :  'EURUSD',
    'FRED/DEXJPUS' :  'USDJPY',
    'FRED/DEXUSUK' :  'GBPUSD',
    'FRED/DEXUSAL' :  'AUDUSD',
    'FRED/DEXCAUS' :  'USDCAD',
    'FRED/DEXUSNZ' :  'NZDUSD',
    'FRED/DEXSZUS' :  'USDCHF',
    'FRED/DEXNOUS' :  'USDNOK',
    'FRED/DEXSDUS' :  'USDSEK',

    'FRED/DEXCHUS' :  'USDCNY',
    'FRED/DEXKOUS' :  'USDKRW',
    'FRED/DEXINUS' :  'USDINR',
    'FRED/DEXBZUS' :  'USDBRL',
    'FRED/DEXMXUS' :  'USDMXN',
    'FRED/DEXSFUS' :  'USDZAR'
}

symbols, names = np.array(sorted(symbol_dict.items())).T

from findatapy.market import Market, MarketDataGenerator, MarketDataRequest

market = Market(market_data_generator=MarketDataGenerator())

md_request = MarketDataRequest(start_date='01 Jan 2010',
                      finish_date='01 Aug 2019',
                      tickers=names.tolist(),
                      vendor_tickers=symbols.tolist(),
                      data_source='quandl',
                      quandl_api_key='mv3QfyqQQWicUtLyL7aK', cache_algo='cache_algo_return')

# get market data (and fill down blanks)
df_market = market.fetch_market(md_request=md_request).fillna(method='ffill')

# resample into weekly data
df_market = df_market.resample('W').last()

# for crosses quoted xxxUSD, make USD base currency
for c in df_market.columns:
    if 'USD' != c[0:3]:
        df_market[c] = 1.0 / df_market[c]

# calculate returns (and strip out the first day, where return is undefined)
df_returns = df_market / df_market.shift(1) - 1
df_returns = df_market[1:]



# stack returns on top of each other
variation = np.vstack([df_returns[n + '.close'] for n in names])

# #############################################################################
# Learn a graphical structure from the correlations

try:
    # for newer versions of scikit-learn
    edge_model = covariance.GraphicalLassoCV(cv=5)
except:
    edge_model = covariance.GraphLassoCV(cv=5)

# standardize the time series: using correlations rather than covariance
# is more efficient for structure recovery
X = variation.copy().T
X /= X.std(axis=0)
edge_model.fit(X)

# #############################################################################
# Cluster using affinity propagation

_, labels = cluster.affinity_propagation(edge_model.covariance_)
n_labels = labels.max()

for i in range(n_labels + 1):
    print('Cluster %i: %s' % ((i + 1), ', '.join(names[labels == i])))

# #############################################################################
# Find a low-dimension embedding for visualization: find the best position of
# the nodes (the stocks) on a 2D plane

# We use a dense eigen_solver to achieve reproducibility (arpack is
# initiated with random vectors that we don't control). In addition, we
# use a large number of neighbors to capture the large-scale structure.
node_position_model = manifold.LocallyLinearEmbedding(
    n_components=2, eigen_solver='dense', n_neighbors=6)

embedding = node_position_model.fit_transform(X.T).T