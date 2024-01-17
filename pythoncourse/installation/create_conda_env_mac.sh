#!/usr/bin/env bash

# Assumes that Anaconda has already been downloaded and installed
# Tested with Anaconda 2021.11

# Can create an environment YML file by running: conda env export > environment_mac.yml
# Create env from YML: conda env create -f environment_mac.yml 

conda activate
source activate

# Update conda
conda update -n base -c defaults conda --yes

# conda config --set allow_conda_downgrades true
# conda install conda=4.6.11

# mamba is a very fast version of conda https://github.com/mamba-org/mamba
# if you have problems with mamba, remove the below line and make all references to mamba => conda later on in
# this script
conda install mamba=0.7.6 -n base -c conda-forge
# 0.7.3

# Remove any existing environment called py38class, and create a py38class with anaconda packages
mamba remove -n py38class --all --yes
mamba create -n py38class python=3.8
conda activate py38class
source activate py38class

# Install Tensorflow, PyTorch and Anaconda (lots of packages)
# only if you have GPU below 2 lines instead of CPU versions`
# mamba install anaconda tensorflow-gpu=2.3.0 anaconda pandas=1.2.3 scikit-learn graphviz python-graphviz matplotlib \
#  pytorch torchvision cudatoolkit=10.1 \
mamba install anaconda -c anaconda --yes
mamba install tensorflow graphviz python-graphviz pandas=1.2.3 numpy=1.19.5 lz4 xlwings=0.23.0 -c anaconda --yes
mamba install pytorch -c pytorch --yes
mamba install \
    pyarrow opencv=4.5.3 modin=0.9.1 dask=2021.4.0 \
    boto3 \
    redis-py python-blosc pathos \
    pyspark koalas vaex \
    spacy fastparquet python-snappy nodejs pystan fbprophet setuptools-git \
    pandas=1.2.3 numpy=1.19.5 -c conda-forge --yes
mamba install vispy datashader pyproj holoviews streamz quandl bqplot gensim=3.8.3 \
    textacy transformers textblob pyldavis eikon findspark celery \
    pytesseract tabula-py \
    newspaper3k \
    sentencepiece jupyter_contrib_nbextensions \
    jupyter_nbextensions_configurator voila pandas=1.2.3 numpy=1.19.5 -c conda-forge --yes

# Install findatapy, chartpy and findatapy 
# Install various graphics libraries
pip install \
   alpha_vantage yfinance twython seasonal pdfminer.six \
   vaderSentiment rise requests_html \
   cvlib==0.2.6 \
   cufflinks==0.17.3 plotly kaleido wordcloud \
        dash dash-html-components dash-core-components \
        dash-table jupyter-dash chart_studio \
   finmarketpy chartpy findatapy financepy==0.310 pandas==1.2.3 numpy==1.19.5

# Hack for vaex!
pip uninstall progressbar2
pip install progressbar2

# Jupyter and Jupyterlab extensions
jupyter contrib nbextension install --user # to activate js on Jupyter
jupyter nbextension enable execute_time/ExecuteTime
jupyter-nbextension install rise --py --sys-prefix

# Run this if you need to use spacy to install the large English model
# python -m spacy download en_core_web_lg

# GPU libraries for working with DataFrames
# conda install -c rapidsai -c nvidia -c conda-forge -c defaults rapids=0.10 python=3.8

# Some of these extensions are not compatible with latest Jupyterlab
# jupyter labextension install @jupyter-widgets/jupyterlab-manager --no-build
# jupyter labextension install plotlywidget --no-build
# jupyter labextension install jupyterlab-plotly --no-build
# jupyter labextension install bqplot
# jupyter lab build