# Imports for Dash
from dash import Dash

import dash
import dash_core_components as dcc
import dash_html_components as html

# Imports for downloading market data and generating charts
from findatapy.market import Market, MarketDataRequest, MarketDataGenerator
from chartpy import Chart, Style

# For scaling realized_vol volatility later
import math

# For plotting
style_vol = Style(plotly_plot_mode='dash', title='Realized Volatilty', width=1000, height=500, scale_factor=1)
style_spot = Style(plotly_plot_mode='dash', title='Spot', width=1000, height=500, scale_factor=1)
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

app_vol = Dash('RealizedVolatility', external_stylesheets=external_stylesheets)

# Tickers
tickers = ['EURUSD', 'USDJPY', 'GBPUSD', 'AUDUSD', 'USDCAD', 'NZDUSD', 'USDCHF', 'USDNOK', 'USDSEK']

# Vendor tickers for Quandl for the above currency pairs
vendor_tickers = ['FRED/DEXUSEU', 'FRED/DEXJPUS', 'FRED/DEXUSUK', 'FRED/DEXUSAL',
                  'FRED/DEXCAUS', 'FRED/DEXUSNZ', 'FRED/DEXSZUS', 'FRED/DEXNOUS',
                  'FRED/DEXSDUS']

# Create the layout
app_vol.layout = html.Div([

    html.H1('Realised volatility calculator'),

    # Drop down for selecting the asset
    dcc.Dropdown(
        id='dropdown-asset',
        options=[{'label': c, 'value': c}
                 for c in tickers],
        value='EURUSD',
        style={'height': '30px', 'width': '400px'}
    ),
    html.Br(),

    # Radio button for selecting the tenor
    dcc.RadioItems(
        id='dropdown-tenor',
        options=[{'label': i, 'value': j}
                 for i, j in [('1W  ', '5'), ('1M  ', '20'), ('1Y  ', '252')]],
        value='1W'
    ),

    # Description text for the application
    dcc.Markdown('''
#### Realized volatility calculator

* We can select the currency pair
* And also the tenor

The application will then compute realized_vol volatility on the fly.
'''),

    # Plotly chart output
    dcc.Graph(id='graph-vol', style={'height': '500px', 'width': '1000px'}),

    # Plotly spot output
    dcc.Graph(id='graph-spot', style={'height': '500px', 'width': '1000px'}),

], style={'padding-top': '50px', 'padding-left': '50px'})

def load_data():

    # Download the historical spot data once and store in memory, we'll process later
    market = Market(market_data_generator=MarketDataGenerator())

    market_data_request = MarketDataRequest(
        start_date='01 Jan 2000',       # Start date
        freq='daily',                   # Daily data
        data_source='quandl',           # Use Quandl as data source
        tickers=tickers,                # Ticker (Cuemacro)
        fields=['close'],               # Which fields to download
        vendor_tickers=vendor_tickers,  # Ticker (Quandl)
        vendor_fields=['close'],        # Which Bloomberg fields to download
        cache_algo='cache_algo_return') # How to return data

    # You need to type your Quandl API below (or modify the DataCred file)
    # market_data_request.quandl_api_key = None

    df = market.fetch_market(market_data_request)
    df = df.fillna(method='ffill')

    df_ret = df / df.shift(1) - 1

    return df, df_ret

# Here we have multiple outputs, which is a newer feature for in Dash, previously, we could only have one output
@app_vol.callback(
    [dash.dependencies.Output('graph-vol', 'figure'),
    dash.dependencies.Output('graph-spot', 'figure')],
    [dash.dependencies.Input('dropdown-asset', 'value'),
     dash.dependencies.Input('dropdown-tenor', 'value')])
def callback_vol_chart(dropdown_asset, dropdown_tenor):

    print(dropdown_asset + ' ' + dropdown_tenor)
    df_vol = df_ret[dropdown_asset + '.close'].rolling(int(dropdown_tenor)).std() * math.sqrt(252) * 100.0

    return chart.plot(df_vol, style=style_vol), chart.plot(df_spot[dropdown_asset + '.close'], style=style_spot)

df_spot, df_ret = load_data()

if __name__ == '__main__':

    app_vol.run_server(threaded=True) # debug=True
