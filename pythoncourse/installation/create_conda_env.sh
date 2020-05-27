#!/usr/bin/env bash

# Assumes that Anaconda has already been downloaded and installed

# Update conda
conda update -n base -c defaults conda --yes

# conda config --set allow_conda_downgrades true
# conda install conda=4.6.11

source activate

# Remove any existing environment called py36class, and create a py36class with anaconda packages
conda remove -n py36class --all --yes
conda create -n py36class python=3.6 anaconda
source activate py36class

# Install scikit-learn (downgrade for some later dependencies) - xlwings only works for Mac (won't install on Linux)
conda install anaconda scikit-learn=0.20.2 --yes
conda install conda-forge xlwings=0.19.4 --yes

# Install PyTorch & Tensorflow
# only if you have GPU below 2 lines instead of CPU versions
# conda install tensorflow-gpu=2.1.0
# conda install pytorch torchvision cudatoolkit=10.1 -c pytorch --yes
conda install anaconda tensorflow=2.1.0 --yes
conda install pytorch torchvision cpuonly -c pytorch --yes

# Install from conda-forge (pyarrow is a newer version!)
conda install -c conda-forge \
  jupyter_contrib_nbextensions jupyter_nbextensions_configurator \
  redis-py python-blosc pathos graphviz python-graphviz textblob \
  vaex-core vaex-viz vaex-jupyter vaex-arrow vaex-server vaex-hdf5 vaex-astro vaex-distributed \
  pyspark=2.4.0 koalas \
  spacy fastparquet python-snappy nodejs pystan fbprophet setuptools-git \
  vispy datashader pyproj holoviews streamz quandl bqplot opencv s3fs \
  --yes

# Install database
# Install Celery
# For findatapy (and NLP) and complex graphics
# Install transformers/huggingface and table libraries
# Install graphics/plotting libraries
# Install findatapy, chartpy and findatapy
# Install modin (later versions need later versions of pandas, may downgrade to pandas to 0.24.2
pip install arctic==1.79.2 \
   celery==4.4.0 celery[redis] celery[msgpack] msgpack-python \
   fxcmpy alpha_vantage yfinance twython newspaper3k seasonal pdfminer.six vaderSentiment gensim wordcloud rise requests_html \
   textacy==0.8.0 \
   transformers pytesseract cmdstanpy==0.4 tabula-py==1.4.3 \
   cvlib \
   cufflinks==0.17.3 plotly==4.8.0 \
        dash==1.12.0 dash-html-components==1.0.3 dash-core-components==1.10.0 dash-table==4.7.0 jupyter-dash==0.2.1 dtale==1.8.1 progressbar2==3.38.0 \
   finmarketpy chartpy findatapy \
   modin==0.5.4

# To be able to plot Plotly into PNG or JPG
conda install -c plotly plotly-orca --yes

# In case has been installed elsewhere by pip
pip uninstall pandas

# Newer versions of Pandas aren't supported as well by other libraries (eg. Arctic), so stick to 0.24.2
conda install -c anaconda pandas=0.24.2 --yes
conda install -c conda-forge pyarrow=0.17.1 --yes

# GPU libraries for working with DataFrames
# conda install -c rapidsai -c nvidia -c conda-forge -c defaults rapids=0.10 python=3.6

# Jupyter and Jupyterlab extensions
jupyter contrib nbextension install --user # to activate js on Jupyter
jupyter nbextension enable execute_time/ExecuteTime
jupyter-nbextension install rise --py --sys-prefix
jupyter nbextension install --sys-prefix --symlink --py jupyter_dash
jupyter nbextension enable --py jupyter_dash

jupyter labextension install @jupyter-widgets/jupyterlab-manager --no-build
jupyter labextension install plotlywidget --no-build
jupyter labextension install jupyterlab-plotly --no-build
jupyter labextension install bqplot
jupyter lab build