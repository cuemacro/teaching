#!/usr/bin/env bash

# update conda
conda update -n base -c defaults conda --yes

# remove any existing environment called py36class, and create a py36class with anaconda packages
conda activate

# conda remove -n py36class --all
conda create -n py36class python=3.6 anaconda
conda activate py36class

# newer versions of Pandas aren't supported as well by other libraries (eg. Arctic), so stick to 0.24.2
conda install -c anaconda pandas=0.24.2 --yes

# install from conda-forge (pyarrow is a newer version!)
conda install -c conda-forge \
jupyterlab jupyter_contrib_nbextensions jupyter_nbextensions_configurator ipywidgets=7.5 \
redis-py=3.3.7 python-blosc=1.8.1 pathos pyarrow=0.14.1 graphviz python-graphviz rise textblob wordcloud quandl \
vaex-core vaex-viz vaex-jupyter vaex-arrow vaex-server vaex-hdf5 vaex-astro vaex-distributed pyspark py4j \
spacy nodejs --yes

# for database
pip install arctic==1.79.2

# install PyTorch
# only if you have GPU
# conda install pytorch torchvision cudatoolkit=10.0 -c pytorch --yes
conda install pytorch torchvision cpuonly -c pytorch --yes

# celery library
pip install celery==4.3.0 celery[redis] celery[msgpack] msgpack-python

# for findatapy
pip install fxcmpy alpha_vantage yfinance twython newspaper3k seasonal pdfminer.six vaderSentiment gensim

# install tensorflow and transformers/huggingface (on Mac OS can have issues installing TensorFlow, so if you have Mac
# comment it out)
# only if you have GPU
# pip install tensorflow-gpu transformers
pip install tensorflow transformers

# modin (downgrade pandas version)
# may downgrade to pandas to 0.24.2
pip install modin

# findatapy, chartpy and finmarketpy (or can manually clone these from GitHub and add to your Python path)
# need to have Git
# pip install git+https://github.com/cuemacro/finmarketpy.git git+https://github.com/cuemacro/chartpy.git git+https://github.com/cuemacro/findatapy.git
pip install finmarketpy chartpy findatapy

# graphics libraries
pip install cufflinks==0.17 plotly_express==0.4.1 dash==1.1.1 dash-html-components==1.0.0 dash-core-components==1.1.1 plotly==4.2.1 dash-table==4.1.0

# to be able to plot Plotly into PNG or JPG
conda install -c plotly plotly-orca --yes

# GPU libraries
# conda install -c rapidsai -c nvidia -c conda-forge -c defaults rapids=0.10 python=3.6

# in case modin has changed pandas version!
conda install -c anaconda pandas=0.24.2 --yes

# Jupyter and Jupyterlab extensions
jupyter contrib nbextension install --user # to activate js on Jupyter
jupyter nbextension enable execute_time/ExecuteTime
jupyter-nbextension install rise --py --sys-prefix
jupyter labextension install @jupyter-widgets/jupyterlab-manager@1.1 --no-build
jupyter labextension install plotlywidget@1.4.0 --no-build
jupyter labextension install jupyterlab-plotly@1.4.0 --no-build
jupyter lab build


