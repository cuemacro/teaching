from findatapy.market import Market, MarketDataGenerator, MarketDataRequest

market = Market(market_data_generator=MarketDataGenerator())


##### Download FX spot data
# for FX
fx_tickers = ['EURUSD', 'USDJPY', 'GBPUSD', 'AUDUSD',
            'USDCAD', 'NZDUSD', 'USDCHF', 'USDNOK', 'USDSEK']

# Vendor tickers for Quandl for the above currency pairs
fx_vendor_tickers = ['FRED/DEXUSEU', 'FRED/DEXJPUS', 'FRED/DEXUSUK', 'FRED/DEXUSAL',
                  'FRED/DEXCAUS', 'FRED/DEXUSNZ', 'FRED/DEXSZUS', 'FRED/DEXNOUS',
                  'FRED/DEXSDUS']

md_request = MarketDataRequest(
    start_date="1 Jan 2003",    # Start date
    finish_date="2 Sep 2019"
    freq='daily',               # Daily data
    data_source='quandl',       # Use Quandl as data source
    tickers=fx_tickers,           # Ticker (Cuemacro)
    fields=['close'],           # Which fields to download
    vendor_tickers=fx_vendor_tickers,  # Ticker (Quandl)
    vendor_fields=['close'])

# Fill in your own API keys for Quandl and FRED here
# md_request.QUANDL_API_KEY = "TYPE HERE"
# md_request.FRED_API_KEY = "TYPE HERE"

df_fx = market.fetch_market(md_request=md_request)

##### Download deposit rate data
rates_tickers = ['USD3M', 'CAD3M', 'EUR3M', 'AUD3M', 'CHF3M', 'SEK3M', 'GBP3M', 'NOK3M', 'JPY3M', 'NZD3M']

rates_vendor_tickers = ['IR3TIB01USM156N', 'IR3TIB01CAM156N', 'IR3TIB01EZM156N', 'IR3TIB01AUM156N', 'IR3TIB01CHM156N',
'IR3TIB01SEM156N', 'IR3TIB01GBM156N', 'IR3TIB01NOM156N', 'IR3TIB01JPM156N', 'IR3TIB01NZM156N']

md_request.data_source = 'alfred'
md_request.tickers = rates_tickers
md_request.vendor_tickers = rates_vendor_tickers

df_rates = market.fetch_market(md_request=md_request)
df_rates = df_rates.resample('BM').last()

df = df_fx.join(df_rates, how='left')
df = df.fillna(method='ffill')
df.to_csv("fx_rates.csv")

##### Download US stocks data
equities_tickers = ['TWTR', 'GOOG', 'FB', 'AAPL', 'NFLX', 'AMZN', 'TSLA', 'S&P500']
equities_vendor_tickers = ['TWTR', 'GOOG', 'FB', 'AAPL', 'NFLX', 'AMZN', 'TSLA', '^GSPC']

md_request.data_source = 'yahoo'
md_request.tickers = equities_tickers
md_request.vendor_tickers = equities_vendor_tickers

df_equities = market.fetch_market(md_request=md_request)
df_equities = df_equities.fillna(method='ffill')

df_equities.to_csv("us_equities.csv")