#!/usr/bin/env bash

# update conda
conda update -n base -c defaults conda --yes

# conda config --set allow_conda_downgrades true
# conda install conda=4.6.11

source activate

# remove any existing environment called py36class, and create a py36class with anaconda packages
conda remove -n py36class --all --yes
conda create -n py36class python=3.6 anaconda
source activate py36class

# install from conda-forge (pyarrow is a newer version!)
conda install -c conda-forge \
jupyterlab jupyter_contrib_nbextensions jupyter_nbextensions_configurator \
redis-py=3.3.7 python-blosc=1.8.1 pathos graphviz python-graphviz rise textblob wordcloud quandl \
vaex-core vaex-viz vaex-jupyter vaex-arrow vaex-server vaex-hdf5 vaex-astro vaex-distributed pyspark py4j \
spacy fastparquet python-snappy nodejs koalas textacy pystan fbprophet --yes

# for database
pip install arctic==1.79.2

# celery library
pip install celery==4.3.0 celery[redis] celery[msgpack] msgpack-python

# for findatapy (and NLP)
pip install fxcmpy alpha_vantage yfinance twython newspaper3k seasonal pdfminer.six vaderSentiment gensim

# install tensorflow and transformers/huggingface (on Mac OS can have issues installing TensorFlow, so if you have Mac
# comment it out)
# only if you have GPU
# pip install tensorflow-gpu transformers cvlib pytesseract tabula-py
pip install tensorflow==2.1.0 transformers pytesseract tabula-py

# install PyTorch
# only if you have GPU
# conda install pytorch torchvision cudatoolkit=10.0 -c pytorch --yes
conda install pytorch torchvision cpuonly -c pytorch --yes
conda install -c conda-forge opencv --yes
pip install cvlib

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

# in case has been installed elsewhere by pip
pip uninstall pandas

# newer versions of Pandas aren't supported as well by other libraries (eg. Arctic), so stick to 0.24.2
conda install -c anaconda pandas=0.24.2 pyarrow=0.13.0 --yes

# GPU libraries
# conda install -c rapidsai -c nvidia -c conda-forge -c defaults rapids=0.10 python=3.6

# in case modin has changed pandas version!
# conda install -c anaconda pandas=0.24.2 --yes

# Jupyter and Jupyterlab extensions
jupyter contrib nbextension install --user # to activate js on Jupyter
jupyter nbextension enable execute_time/ExecuteTime
jupyter-nbextension install rise --py --sys-prefix
jupyter labextension install @jupyter-widgets/jupyterlab-manager@1.1 --no-build
jupyter labextension install plotlywidget@1.4.0 --no-build
jupyter labextension install jupyterlab-plotly@1.4.0 --no-build
jupyter lab build


