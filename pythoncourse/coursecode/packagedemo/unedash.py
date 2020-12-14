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

app_une = Dash('USStateUnemployment', external_stylesheets=external_stylesheets)

# Get a list of all US states
# Get the FRED ticker for unemployment rate in each
us_states = ["AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DC", "DE", "FL", "GA",
"HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD",
"MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ",
"NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC",
"SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY"]

us_states_fred = [x + 'UR' for x in us_states]

# Either set API keys as an environment variable (preferred for security reasons)
# or replace these below, with your own keys (I can give you a FRED key because it's by application)
try:
    import os
    FRED_API_KEY = os.environ['FRED_API_KEY']
except:
    pass

# For plotting
style_une = Style(plotly_plot_mode='dash', title='Unemployment Rate by state',
                   width=1000, height=500, scale_factor=1)
chart = Chart(engine='plotly')

# Create the layout
app_une.layout = html.Div([

    html.H1('US unemployment by state'),

    # Drop down for selecting the asset
    dcc.Dropdown(
        id='dropdown-state',
        options=[{'label': c, 'value': c}
                 for c in us_states],
        value='CA',
        style={'height': '30px', 'width': '400px'}
    ),
    html.Br(),

    # Description text for the application
    dcc.Markdown('''
#### US employment by state

* We can select the US state

The application will then display the unemployment rate in that state
'''),

    # Plotly chart output
    dcc.Graph(id='graph-une',
              style={'height': '500px', 'width': '1000px'}),

], style={'padding-top': '50px', 'padding-left': '50px'})

# Have an output to the graph and an input for the state
@app_une.callback(
    dash.dependencies.Output('graph-une', 'figure'),
    [dash.dependencies.Input('dropdown-state', 'value')])
def callback_une_chart(dropdown_state):

    print(dropdown_state)
    df_state = df_une[dropdown_state]

    return chart.plot(df_state, style=style_une)


# Create a method for downloading data from FRED
# We should only call this once!
def load_une_data():
    md_request = MarketDataRequest(
        start_date='01 Jan 2001',  # Start date
        finish_date='12 Aug 2019',  # Finish date
        tickers=us_states,  # What we want the ticker to look like once download
        vendor_tickers=us_states_fred,  # The ticker used by the vendor
        fields=['close'],  # What fields we want (usually close, we can also define vendor fields)
        data_source='alfred',  # What is the data source?
        # vendor_fields=['actual-release', 'first-revision', 'close'],
        fred_api_key=FRED_API_KEY)  # Most data sources will require us to specify an API key/password

    market = Market(market_data_generator=MarketDataGenerator())

    df_une = market.fetch_market(md_request)
    df_une.columns = [x.replace('.close', '') for x in df_une.columns]

    return df_une

df_une = load_une_data()
app_une.run_server()