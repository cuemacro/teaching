try:
    import plotly.express as px  # plotly 4 onwards
except:
    import plotly_express as px

iris = px.data.iris()
fig = px.scatter(iris, x="sepal_width", y="sepal_length")
fig.show()
