#!/usr/bin/env bash

# assume already has py36 Azure ML environment, which has most libraries already installed (TensorFlow, PyTorch etc.)
conda activate py36

# newer versions of Pandas aren't supported as well by other libraries, so stick to 0.24.2
conda install -c anaconda pandas=0.24.2 --yes

# install from conda-forge (pyarrow is a newer version, but may get downgraded later by modin)
conda install -c conda-forge \
python-blosc=1.8.1 graphviz python-graphviz rise \
vaex-core vaex-viz vaex-jupyter vaex-arrow vaex-server vaex-hdf5 vaex-astro vaex-distributed \
nltk spacy fastparquet python-snappy fbprophet pystan pyarrow=0.16.0 --yes

# for celery and NLP
pip install celery==4.3.0 celery[redis] celery[msgpack] msgpack-python fxcmpy alpha_vantage yfinance twython newspaper3k seasonal \
pdfminer.six vaderSentiment gensim textblob wordcloud quandl redis

# install opencv for computer vision
conda install -c conda-forge opencv --yes

# install transformers, various NLP/text libraries
pip install transformers cvlib pytesseract tabula-py koalas textacy modin==0.5.0

# findatapy, finmarketpy, chartpy & graphics libraries
pip install finmarketpy chartpy findatapy \
cufflinks==0.17 plotly_express==0.4.1 dash==1.8.0 dash-html-components==1.0.2 dash-core-components==1.7.0 plotly==4.5.0 dash-table==4.6.0

# to be able to plot Plotly into PNG or JPG
conda install -c plotly plotly-orca --yes


