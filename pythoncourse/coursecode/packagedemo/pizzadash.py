# Import all the Dash libraries
from dash import Dash

import dash
import dash_core_components as dcc
import dash_html_components as html
from dash.dependencies import Input, Output

# Create the Dash object
app_hello = Dash('HelloWorldModified')

# Create the layout
app_hello.layout = html.Div([
    html.H1('Hello World - pizza order!'),
    dcc.RadioItems(
        id='dropdown-pizza-type',
        options=[{'label': c, 'value': c}
                 for c in ['Margherita', 'Pepperoni', 'Hawaiian']],
        value='Margherita'
    ),
    html.Div(id='output-pizza-type'),
    dcc.Dropdown(
        id='dropdown-pizza-size',
        options=[{'label': i, 'value': j}
                 for i, j in [('L','large'), ('M','medium'), ('S','small')]],
        value='medium'
    ),
    html.Div(id='output-pizza-size'),
    dcc.Dropdown(
        id='dropdown-location',
        options=[{'label': i, 'value': j}
                 for i, j in [('Lon','London'), ('Mil','Milan'), ('Rom','Rome')]],
        value='London'
    ),
    html.Div(id='output-location'),
    dcc.Markdown('''
#### We can also write in Markdown format like we do in Jupyter notebooks!!!

Although note, not everything is supported yet, which works in Jupyter notebooks (like LaTeX)

* We can write bullets
    * Like this

Add links like this [Pizza Express](https://www.pizzaexpress.com/).

`point out code`
''')

])

# Write the callback functions, which will get triggered
# when users click/interact with the form

# Add an extra one for restaurant location
@app_hello.callback(
    dash.dependencies.Output('output-pizza-type', 'children'),
    [dash.dependencies.Input('dropdown-pizza-type', 'value')])
def callback_pizza_type(dropdown_value):
    return "The selected pizza is %s." % dropdown_value

@app_hello.callback(
    dash.dependencies.Output('output-pizza-size', 'children'),
    [dash.dependencies.Input('dropdown-pizza-type', 'value'),
     dash.dependencies.Input('dropdown-pizza-size', 'value')])
def callback_size(dropdown_pizza, dropdown_size):
    return "The chosen pizza is a %s %s one." %(dropdown_size,
                                                  dropdown_pizza)

@app_hello.callback(
    dash.dependencies.Output('output-location', 'children'),
    [dash.dependencies.Input('dropdown-location', 'value')])
def callback_location(dropdown_location):
    return "The restaurant is in the city of %s." %(dropdown_location)

# Press the "STOP" button once you've finished (or restart the Python kernel)
app_hello.run_server()