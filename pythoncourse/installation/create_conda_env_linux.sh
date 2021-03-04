#!/usr/bin/env bash

# Assumes that Anaconda has already been downloaded and installed

# Can create an environment YML file by running: conda env export > environment_linux.yml
# Create env from YML: conda env create -f environment_linux.yml

# Update conda
conda update -n base -c defaults conda --yes

# conda config --set allow_conda_downgrades true
# conda install conda=4.6.11

conda activate
source activate

# mamba is a very fast version of conda https://github.com/mamba-org/mamba
# if you have problems with mamba, remove the below line and make all references to mamba => conda later on in
# this script
conda install mamba -n base -c conda-forge

# Remove any existing environment called py37class, and create a py37class with anaconda packages
mamba remove -n py37class --all --yes
mamba create -n py37class python=3.7
conda activate py37class
source activate py37class

# Install Tensorflow, PyTorch and Anaconda (lots of packages)
# only if you have GPU below 2 lines instead of CPU versions
# mamba install anaconda tensorflow-gpu=2.3.0 anaconda pandas=1.0.5 scikit-learn graphviz python-graphviz matplotlib -c anaconda --yes
# mamba install pytorch torchvision cudatoolkit=10.1 \
mamba install anaconda tensorflow=2.3.0 pandas=1.0.5 scikit-learn graphviz python-graphviz matplotlib -c anaconda --yes
mamba install pytorch torchvision cpuonly \
  pyarrow opencv modin=0.8.0 \
  boto3 jupyter_contrib_nbextensions jupyter_nbextensions_configurator \
  redis-py python-blosc pathos textblob \
  vaex=3.0.0 \
  spacy fastparquet python-snappy nodejs pystan fbprophet setuptools-git \
  pyspark koalas \
  vispy datashader pyproj holoviews streamz quandl bqplot \
    -c pytorch -c conda-forge --yes

# Install database
# Install Celery
# For findatapy (and NLP) and complex graphics
# Install transformers/huggingface and table libraries
# Install graphics/plotting libraries
# Install findatapy, chartpy and findatapy
pip install arctic==1.79.2 \
   celery==4.4.0 celery[redis] celery[msgpack] msgpack-python \
   fxcmpy alpha_vantage yfinance twython newspaper3k seasonal pdfminer.six vaderSentiment gensim wordcloud RISE requests_html \
   textacy==0.8.0 \
   transformers pytesseract cmdstanpy==0.4 tabula-py==1.4.3 \
   cvlib \
   cufflinks==0.17.3 plotly==4.14.3 kaleido \
        dash==1.19.0 dash-html-components==1.1.2 dash-core-components==1.15.0 dash-table==4.11.2 jupyter-dash==0.4.0 chart_studio==1.1.0 \
        dtale==1.8.1 pyldavis progressbar2==3.38.0  \
   finmarketpy chartpy findatapy financepy

# GPU libraries for working with DataFrames
# conda install -c rapidsai -c nvidia -c conda-forge -c defaults rapids=0.10 python=3.7

# Jupyter and Jupyterlab extensions
jupyter contrib nbextension install --user # to activate js on Jupyter
jupyter nbextension enable execute_time/ExecuteTime
jupyter-nbextension install rise --py --sys-prefix

# Some of these extensions are not compatible with latest Jupyterlab
# jupyter labextension install @jupyter-widgets/jupyterlab-manager --no-build
# jupyter labextension install plotlywidget --no-build
# jupyter labextension install jupyterlab-plotly --no-build
# jupyter labextension install bqplot
# jupyter lab build