from dash import Dash

import dash
import dash_core_components as dcc
import dash_html_components as html
from dash.dependencies import Input, Output

app_hello = Dash('HelloWorld')

app_hello.layout = html.Div([
    html.H1('Hello World!'),
    dcc.RadioItems(
        id='dropdown-burger',
        options=[{'label': c, 'value': c}
                 for c in ['Whopper', 'Big Mac', 'Honest Burger']],
        value='Whopper'
    ),
    html.Div(id='output-burger'),
    dcc.RadioItems(
        id='dropdown-size',
        options=[{'label': i, 'value': j}
                 for i, j in [('T', 'triple'), ('D', 'double'), ('S', 'single')]],
        value='medium'
    ),
    html.Div(id='output-size'),
    dcc.Markdown('''
#### We can also write in Markdown format like we do in Jupyter notebooks!!!

* We can write bullets
    * Like this

Add links like this [Burger King](http://www.burgerking.com).

`point out code`
''')

])

@app_hello.callback(
    dash.dependencies.Output('output-burger', 'children'),
    [dash.dependencies.Input('dropdown-burger', 'value')])
def callback_color(dropdown_value):
    return "The selected burger is %s." % dropdown_value

@app_hello.callback(
    dash.dependencies.Output('output-size', 'children'),
    [dash.dependencies.Input('dropdown-burger', 'value'),
     dash.dependencies.Input('dropdown-size', 'value')])
def callback_size(dropdown_burger, dropdown_size):
    return "The chosen burger is a %s %s one." %(dropdown_size,
                                                  dropdown_burger)

app_hello.run_server(threaded=True) # debug=True
