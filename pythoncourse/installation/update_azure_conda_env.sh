#!/usr/bin/env bash

# assume already has py36 Azure ML environment, which has most libraries already installed (TensorFlow, PyTorch etc.)
conda activate py36

# newer versions of Pandas aren't supported as well by other libraries (eg. Arctic), so stick to 0.24.2
conda install -c anaconda pandas=0.24.2 --yes

# install from conda-forge (pyarrow is a newer version!)
conda install -c conda-forge \
jupyterlab jupyter_contrib_nbextensions jupyter_nbextensions_configurator \
python-blosc=1.8.1 graphviz python-graphviz rise textblob wordcloud \
vaex-core vaex-viz vaex-jupyter vaex-arrow vaex-server vaex-hdf5 vaex-astro vaex-distributed \
nltk spacy fastparquet python-snappy nodejs koalas textacy pystan fbprophet --yes

# celery library
pip install celery==4.3.0 celery[redis] celery[msgpack] msgpack-python

# for findatapy (and NLP)
pip install fxcmpy alpha_vantage yfinance twython newspaper3k seasonal pdfminer.six vaderSentiment gensim

# install transformers/huggingface
pip install transformers cvlib pytesseract tabula-py
conda install -c conda-forge opencv --yes

# modin (later versions need later versions of pandas)
# may downgrade to pandas to 0.24.2
pip install modin=0.5.0

# findatapy, chartpy and finmarketpy (or can manually clone these from GitHub and add to your Python path)
# need to have Git
# pip install git+https://github.com/cuemacro/finmarketpy.git git+https://github.com/cuemacro/chartpy.git git+https://github.com/cuemacro/findatapy.git
pip install finmarketpy chartpy findatapy

# graphics libraries
pip install cufflinks==0.17 plotly_express==0.4.1 dash==1.8.0 dash-html-components==1.0.2 dash-core-components==1.7.0 plotly==4.5.0 dash-table==4.6.0

# to be able to plot Plotly into PNG or JPG
conda install -c plotly plotly-orca --yes

# Jupyter and Jupyterlab extensions
jupyter contrib nbextension install --user # to activate js on Jupyter
jupyter nbextension enable execute_time/ExecuteTime
jupyter-nbextension install rise --py --sys-prefix
jupyter labextension install @jupyter-widgets/jupyterlab-manager@1.1 --no-build
jupyter labextension install plotlywidget@1.4.0 --no-build
jupyter labextension install jupyterlab-plotly@1.4.0 --no-build
jupyter lab build


