# Import all the Dash libraries and other libraries for plotting etc.
from dash import Dash

import dash
import dash_core_components as dcc
import dash_html_components as html
from dash.dependencies import Input, Output

import pandas as pd

from chartpy import Chart, Style

# For plotting create a chartpy object
chart = Chart(engine='plotly')

# external CSS stylesheets
external_stylesheets = [
    'https://codepen.io/chriddyp/pen/bWLwgP.css',
    {
        'href': 'https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css',
        'rel': 'stylesheet',
        'integrity': 'sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO',
        'crossorigin': 'anonymous'
    }
]

app_event_study = Dash('EventStudy', external_stylesheets=external_stylesheets)

data_events = ['NFP', 'ECB']
tickers = ['EURUSD', 'USDJPY']
minutes = ['10', '30', '60', '90', '180']

# Create the layout
app_event_study.layout = html.Div([

    html.H1('Event Study for FX over events'),

    # Drop down for selecting the data event
    dcc.Dropdown(
        id='dropdown-data-events',
        options=[{'label': d, 'value': d}
                 for d in data_events],
        value='NFP',
        style={'height': '30px', 'width': '400px'}
    ),
    html.Br(),

    # Drop down for selecting the data event
    dcc.Dropdown(
        id='dropdown-asset',
        options=[{'label': t, 'value': t}
                 for t in tickers],
        value='EURUSD',
        style={'height': '30px', 'width': '400px'}
    ),
    html.Br(),

    # Drop down for selecting the minute duration
    dcc.Dropdown(
        id='dropdown-minutes',
        options=[{'label': m, 'value': m}
                 for m in minutes],
        value='180',
        style={'height': '30px', 'width': '400px'}
    ),
    html.Br(),

    # Description text for the application
    dcc.Markdown('''
#### FX price action around events

* We can select the economic data event (either ECB or NFP)
* The currency pair (default: EURUSD)
* How many minutes we want the event study to run for (default: 180 minutes)

The application will then display the intraday price action over those events
'''),

    # Plotly chart output
    dcc.Graph(id='graph-data-events',
              style={'height': '500px', 'width': '1000px'}),

], style={'padding-top': '50px', 'padding-left': '50px'})


# Create a function for loading 1 minute spot data, restrict ourselves to only 6 months of data
# otherwise takes too long to download
#
# Remember to write the data to disk first time, so we can re-read it later from desk,
# rather than having to keep download it each time
def load_minute_data(ticker, start_date='01 Jan 2019', finish_date='30 Jun 2019'):
    # Load tick data from DukasCopy (if doesn't exist on disk) and then save to disk as 1 minute data
    # This is in UTC timezone
    # By default the path is the working director but we can change that
    raw_data_path = ''

    # Imports of various findatapy libraries for market data downloads
    from findatapy.market import Market, MarketDataRequest, MarketDataGenerator

    import os

    # First we can do it by defining all the vendor fields, tickers etc. so we bypass the configuration file
    md_request = MarketDataRequest(
        start_date=start_date, finish_date=finish_date,
        fields=['bid', 'ask'], vendor_fields=['bid', 'ask'],
        freq='tick', data_source='dukascopy',
        tickers=ticker, vendor_tickers=ticker, category='fx')

    market = Market(market_data_generator=MarketDataGenerator())

    compression_type = 'gzip'  # you can change this to 'snappy' if you want!

    # Only download file if not on disk (slow to download)
    if not (os.path.exists(raw_data_path + ticker + '_1min.gzip')):
        df_tick = market.fetch_market(md_request)

        df_tick['mid'] = (df_tick[ticker + '.bid'] + df_tick[ticker + '.ask']) / 2.0
        df_minute = pd.DataFrame(df_tick['mid'].resample("1min").first()).dropna()
        df_minute.to_parquet(raw_data_path + ticker + '_1min.gzip',
                             compression=compression_type, engine='fastparquet')
    else:
        # Edit the below line if you want to pick only one of the yearly Parquet files
        # If you load the whole amount might run out of memory!
        df_minute = pd.read_parquet(raw_data_path + ticker + '_1min.gzip', engine='fastparquet')

    return df_minute


# Function for loading events (ECB and NFP - or whichever other events you want)
def load_data_events():
    # Load NFP and ECB times from Cuemacro's teaching GitHub site
    url_nfp = "https://raw.githubusercontent.com/cuemacro/teaching/master/pythoncourse/data/nfp_times.csv"

    df_nfp_times = pd.read_csv(url_nfp, index_col=0)
    df_nfp_times.index = pd.to_datetime(df_nfp_times.index)

    url_ecb = "https://raw.githubusercontent.com/cuemacro/teaching/master/pythoncourse/data/ecb_times.csv"

    df_ecb_times = pd.read_csv(url_ecb, index_col=0)
    df_ecb_times.index = pd.to_datetime(df_ecb_times.index)

    event_dict = {'NFP': df_nfp_times, 'ECB': df_ecb_times}

    return event_dict

# Create an event study based on user's event times and a 1 minute history for our asset, using EventStudy
def calculate_event(df_minute, df_event_times, mins, cumsum=True):
    # from finmarketpy
    from finmarketpy.economics import EventStudy
    from findatapy.timeseries import Calculations

    es = EventStudy()
    calc = Calculations()

    if cumsum:
        df_minute = calc.calculate_returns(df_minute)

    # Work out cumulative asset price moves moves over the event
    df_event = es.get_intraday_moves_over_custom_event(df_minute, df_event_times, cumsum=cumsum, mins=mins)

    # Create an average move
    df_event['Avg'] = df_event.mean(axis=1)

    return df_event


# Plot the event study using Plotly charts
def plot_event(df_event, title, factor=100):
    # Plotting spot over economic data event
    style = Style(title=title, plotly_plot_mode='dash',
                  width=1000, height=500, scale_factor=1)

    # Plot in shades of blue (so earlier releases are lighter, later releases are darker)
    style.color = 'Blues';
    style.color_2 = []
    style.y_axis_2_series = []
    style.display_legend = False

    # Last release will be in red, average move in green
    style.color_2_series = [df_event.columns[-2], df_event.columns[-1]]
    style.color_2 = ['red', 'green']
    style.linewidth_2 = 2
    style.linewidth_2_series = style.color_2_series

    # Finally do plot
    return chart.plot(df_event * factor, style=style)


# Have an output to the graph and an input for the data event
@app_event_study.callback(
    dash.dependencies.Output('graph-data-events', 'figure'),
    [dash.dependencies.Input('dropdown-data-events', 'value'),
     dash.dependencies.Input('dropdown-asset', 'value'),
     dash.dependencies.Input('dropdown-minutes', 'value')])
def callback_event_study_chart(dropdown_data_events, dropdown_asset, dropdown_minutes):
    print(dropdown_data_events + ' ' + dropdown_asset + ' ' + dropdown_minutes)

    # Get the event times
    df_event_times = event_dict[dropdown_data_events]
    df_minute = market_dict[dropdown_asset]

    # Conduct event study using market data and event times
    df_event = calculate_event(df_minute, df_event_times, int(dropdown_minutes), cumsum=True)

    # Do plot of event study
    event_chart = plot_event(df_event, 'Event study around ' + dropdown_data_events)

    return event_chart

# Load up 1 minute market data and event dictionaries
# First time this runs it will take a while, given has to download from DukasCopy
# rather than reading from disk (which it will do on subsequent occasions)
market_dict = {}

for t in tickers:
    market_dict[t] = load_minute_data(t)

event_dict = load_data_events()

# Press the "STOP" button once you've finished (or restart the Python kernel)
app_event_study.run_server()