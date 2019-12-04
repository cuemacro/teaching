import yfinance as yf

ticker = 'TWTR'
expiry = "2020-03-20"
data = yf.Ticker(ticker)
opt = data.option_chain(expiry)

opt.calls.to_csv(ticker + "_calls.csv")
opt.puts.to_csv(ticker + "_puts.csv")