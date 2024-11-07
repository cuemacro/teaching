import xlwings as xw
import pandas as pd

import datetime

from finmarketpy.backtest import Backtest, BacktestRequest
from findatapy.market import Market, MarketDataRequest, MarketDataGenerator

# For signal generation
from finmarketpy.economics import TechIndicator, TechParams

def hello_xlwings():
    wb = xw.Book.caller()
    wb.sheets[0].range("A1").value = "Hello xlwings!"

@xw.func
def double_sum(x, y):
    """Returns twice the sum of the two arguments"""
    return 2 * (x + y)

@xw.func
def hello(name):
    return "hello {0}".format(name)

def get_figure(ticker, data_source, start_date, api_key):
    import matplotlib.pyplot as plt

    # Fetch market data from Quandl
    md_request = MarketDataRequest(start_date=start_date,
                                   tickers=ticker,
                                   vendor_tickers=ticker,
                                   data_source=data_source)

    if data_source == 'quandl':
        md_request.quandl_api_key = api_key
    elif data_source == "alfred":
        md_request.fred_api_key = api_key

    df = Market(market_data_generator=MarketDataGenerator()).fetch_market(md_request)

    scale = 1.0

    # Plot using Matplotlib
    fig = plt.figure(dpi=90, figsize=(scale * 3.0, scale * 2.0))
    df.plot(ax=plt.gca())

    return fig, df

def grab_plot():
    # Create a reference to the calling Excel Workbook
    sht = xw.Book.caller().sheets[0]

    # Get the ticker and the API key from Excel
    ticker = sht.range('B2').value
    data_source = sht.range("B3").value.lower()
    start_date = sht.range('B5').value
    api_key = sht.range('B50').value

    sht1 = xw.Book.caller().sheets[1]

    # Get the figure and show it in Excel
    fig, df = get_figure(ticker, data_source, start_date, api_key)
    pic = sht1.pictures.add(fig, name='market_fig', update=True)

    # Clear any old data
    xw.Book.caller().sheets[1].range('J1:K10000').clear_contents()

    # Print raw data
    xw.Book.caller().sheets[1].range("J1").value = df

def construct_backtest(ticker, vendor_ticker, sma_period, data_source, start_date, quandl_api_key):
    backtest = Backtest()
    br = BacktestRequest()

    # Set all the parameters for the backtest
    br.start_date = start_date
    br.finish_date = datetime.datetime.utcnow()
    br.spot_tc_bp = 2.5  # 2.5 bps bid/ask spread
    br.ann_factor = 252

    tech_params = TechParams()
    tech_params.sma_period = sma_period
    indicator = 'SMA'

    md_request = MarketDataRequest(
        start_date=start_date,
        finish_date=datetime.date.today(),
        freq='daily',
        data_source=data_source,
        tickers=ticker,
        fields=['close'],
        vendor_tickers=vendor_ticker,
        quandl_api_key=quandl_api_key)

    market = Market(market_data_generator=MarketDataGenerator())

    # Download the market data (the asset we are trading is also
    # being used to generate the signal)
    asset_df = market.fetch_market(md_request)
    spot_df = asset_df

    # Use technical indicator to create signals
    # (we could obviously create whatever function we wanted for generating the signal dataframe)
    # However, finmarketpy has some technical indicators built in (and some signals too)
    tech_ind = TechIndicator()
    tech_ind.create_tech_ind(spot_df, indicator, tech_params);
    signal_df = tech_ind.get_signal()

    # use the same data for generating signals
    backtest.calculate_trading_PnL(br, asset_df, signal_df, None, False)

    # Get the returns and signals for the portfolio
    port = backtest.portfolio_cum()
    port.columns = [indicator + ' = ' + str(tech_params.sma_period) + ' ' + str(backtest.portfolio_pnl_desc()[0])]
    signals = backtest.portfolio_signal()
    # returns = backtest.pnl()

    return port, signals

def create_backtest():
    # Create a reference to the calling Excel Workbook
    sht = xw.Book.caller().sheets[0]

    # Get the ticker and the API key from Excel
    vendor_ticker = sht.range('B2').value
    ticker = sht.range('C2').value
    data_source = sht.range("B3").value.lower()
    sma_period = int(sht.range("B4").value)
    start_date = sht.range('B5').value
    quandl_api_key = sht.range('B50').value

    # Run the backtest
    port, signals = construct_backtest(ticker, vendor_ticker, sma_period, data_source, start_date, quandl_api_key)

    # Clear any old data
    xw.Book.caller().sheets[2].range('A1:D10000').clear_contents()

    # Print raw data to the spreadsheet
    xw.Book.caller().sheets[2].range("A1").value = port
    xw.Book.caller().sheets[2].range("C1").value = signals

import os

def get_mid_price(raw_data_path, ticker='EURUSD'):
    # First we can do it by defining all the vendor fields, tickers etc. so we bypass the configuration file
    # We use findatapy
    md_request = MarketDataRequest(
        start_date='01 Jan 2007', finish_date='30 Jun 2019',
        fields=['bid', 'ask'], vendor_fields=['bid', 'ask'],
        freq='tick', data_source='dukascopy',
        tickers=[ticker], vendor_tickers=[ticker], category='fx')

    market = Market(market_data_generator=MarketDataGenerator())

    compression_type = 'gzip'  # you can change this to 'snappy' if you want!

    # Only download file if not on disk (slow to download),
    # then write to disk as parquet and CSV
    # Note: writing to CSV takes a long time, so we have commented it here!
    if not (os.path.exists(os.path.join(raw_data_path, ticker + '.gzip'))):
        df_tick = market.fetch_market(md_request)

        df_tick.to_parquet(os.path.join(raw_data_path, ticker + '.gzip'), compression=compression_type,
                           engine='fastparquet')

        start_year = df_tick.index[0].year
        finish_year = df_tick.index[-1].year

        for i in range(start_year, finish_year + 1):
            df_year = df_tick[df_tick.index.year == i]
            df_year.to_parquet(raw_data_path + ticker + '_' + str(i) + '.gzip',
                               compression=compression_type, engine='fastparquet')
    else:
        # Edit the below line if you want to pick only one of the yearly Parquet files
        # If you load the whole amount might run out of memory!
        df_tick = pd.read_parquet(os.path.join(raw_data_path, ticker + '_2019.gzip'),
                                  engine='fastparquet')

    # calculate mid-price
    df_tick['mid'] = (df_tick[ticker + '.ask'] + df_tick[ticker + '.bid']) / 2.0

    # get 1 minute data
    return pd.DataFrame(df_tick['mid'].resample("1min").first()).dropna()

def calculate_event(df_minute, df_event_times, cumsum=True):
    # Create an event study based on user's event times and a 1 minute history for our asset, using EventStudy
    # from finmarketpy
    from finmarketpy.economics import EventStudy
    from findatapy.timeseries import Calculations

    es = EventStudy()
    calc = Calculations()

    if cumsum:
        df_minute = calc.calculate_returns(df_minute)

    # Work out cumulative asset price moves moves over the event
    df_event = es.get_intraday_moves_over_custom_event(df_minute, df_event_times, cumsum=cumsum)

    # Create an average move
    df_event['Avg'] = df_event.mean(axis=1)

    return df_event

def create_event_study():
    # Create a reference to the calling Excel Workbook
    sht = xw.Book.caller().sheets[0]

    # Get the folder where tick data is stored
    raw_data_path = sht.range('B8').value
    df_event_times = sht.range('M1:M200').value

    # Convert the event times into a format that can be used
    df_event_times = pd.DataFrame([x for x in df_event_times if x is not None], columns=['events'])
    df_event_times = df_event_times.set_index('events')
    df_event_times.index.name = 'Date'

    # Get spot data (only for EURUSD because don't have any other assets on disk)
    df_minute = get_mid_price(raw_data_path, ticker='EURUSD')

    # Run event study
    df_event = calculate_event(df_minute, df_event_times, cumsum=True)

    # Clear any old data from the output sheet
    xw.Book.caller().sheets[3].range('A1:M10000').clear_contents()

    # Print event study to the spreadsheet
    xw.Book.caller().sheets[3].range("A1").value = df_event

if __name__ == '__main__':
    xw.serve()
