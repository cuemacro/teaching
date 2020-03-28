#!/usr/bin/env bash

# Assume already has py36 Azure ML environment, which has most libraries already installed (TensorFlow, PyTorch etc.)
conda activate py36

# Newer versions of Pandas aren't supported as well by other libraries, so stick to 0.24.2
conda install -c anaconda pandas=0.24.2 --yes

# Install from conda-forge (pyarrow is a newer version, but may get downgraded later by modin)
conda install -c conda-forge \
python-blosc=1.8.1 graphviz python-graphviz rise \
vaex-core vaex-viz vaex-jupyter vaex-arrow vaex-server vaex-hdf5 vaex-astro vaex-distributed \
nltk spacy fastparquet python-snappy fbprophet pystan pyarrow=0.16.0 --yes

# For celery and NLP
pip install celery==4.4.0 celery[redis] celery[msgpack] msgpack-python fxcmpy alpha_vantage yfinance twython newspaper3k seasonal \
pdfminer.six vaderSentiment gensim textblob wordcloud quandl redis

# Install opencv for computer vision
conda install -c conda-forge opencv --yes

# Install transformers, various NLP/text libraries
pip install transformers cvlib pytesseract cmdstanpy==0.4 tabula-py==1.4.3 koalas textacy modin==0.5.4

# findatapy, finmarketpy, chartpy & graphics libraries
pip install finmarketpy chartpy findatapy \
    cufflinks==0.17 plotly_express==0.4.1 \
    dash==1.9.0 dash-html-components==1.0.2 dash-core-components==1.8.0 plotly==4.5.4 dash-table==4.6.0

# To be able to plot Plotly into PNG or JPG
conda install -c plotly plotly-orca --yes

# In case another application installed a later verison of pandas
pip uninstall pandas
conda install -c anaconda pandas=0.24.2 --yes


