#!/usr/bin/env bash

# Assumes that Anaconda has already been downloaded and installed
# Tested with Anaconda 2020.11

# Can create an environment YML file by running: conda env export > environment_mac.yml
# Create env from YML: conda env create -f environment_mac.yml

# Update conda
conda update -n base -c defaults conda --yes

# conda config --set allow_conda_downgrades true
# conda install conda=4.6.11

conda activate
source activate

# mamba is a very fast version of conda https://github.com/mamba-org/mamba
# if you have problems with mamba, remove the below line and make all references to mamba => conda later on in
# this script
conda install mamba=0.4.2 -n base -c conda-forge

# Remove any existing environment called py38class, and create a py38class with anaconda packages
mamba remove -n py38class --all --yes
mamba create -n py38class python=3.8
conda activate py38class
source activate py38class

# Install Tensorflow, PyTorch and Anaconda (lots of packages)
# only if you have GPU below 2 lines instead of CPU versions (although this hasn't been tested on Mac)
# mamba install anaconda tensorflow-gpu=2.0.0 pandas=1.2.3 scikit-learn graphviz python-graphviz matplotlib xlwings=0.23.0 
#   pytorch torchvision cudatoolkit=10.1 \
mamba install anaconda scikit-learn matplotlib xlwings=0.23.0 tensorflow graphviz python-graphviz pytorch pyarrow fastparquet \
    python-snappy holoviews datashader pystan pyspark nodejs numpy=1.19.1 opencv -c anaconda --yes
mamba install modin koalas \
    jupyter_contrib_nbextensions jupyter_nbextensions_configurator vaex numpy=1.19.1 -c conda-forge --yes
# conda install pandas=1.2.3 -c anaconda --yes

# Install database
# Install Celery
# For findatapy and NLP and complex graphics
# Install transformers/huggingface and table libraries
# Install graphics/plotting libraries
# Install findatapy, chartpy and findatapy
pip install arctic==1.79.4 \
   redis quandl prophet boto3 textblob \
   spacy vispy pathos bqplot streamz pyproj \
   celery celery[redis] celery[msgpack] msgpack-python \
   fxcmpy alpha_vantage yfinance twython newspaper3k seasonal pdfminer.six vaderSentiment gensim wordcloud rise requests_html \
   textacy sentencepiece tabula-py \
   transformers==3.0.2 pytesseract cmdstanpy==0.9.5 \
   cvlib \
   cufflinks==0.17.3 plotly==4.14.3 kaleido \
        dash==1.20.0 dash-html-components==1.1.3 dash-core-components==1.16.0 dash-table==4.11.3 jupyter-dash==0.4.0 chart_studio==1.1.0 \
        jupyter-book==0.10.2 jupyterbook-latex \
        dtale==1.43.0 pyldavis \
   finmarketpy chartpy findatapy financepy==0.193 findspark pandas==1.2.3 numpy==1.19.1 jedi==0.15.2 parso==0.8.2

# Hack for vaex
pip uninstall progressbar2
pip install progressbar2

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