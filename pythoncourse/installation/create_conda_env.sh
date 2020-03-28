#!/usr/bin/env bash

# Update conda
conda update -n base -c defaults conda --yes

# conda config --set allow_conda_downgrades true
# conda install conda=4.6.11

source activate

# Remove any existing environment called py36class, and create a py36class with anaconda packages
conda remove -n py36class --all --yes
conda create -n py36class python=3.6 anaconda
source activate py36class

# Install from conda-forge (pyarrow is a newer version!)
conda install -c conda-forge \
jupyterlab jupyter_contrib_nbextensions jupyter_nbextensions_configurator \
redis-py=3.3.7 python-blosc=1.8.1 pathos graphviz python-graphviz textblob wordcloud quandl \
vaex-core vaex-viz vaex-jupyter vaex-arrow vaex-server vaex-hdf5 vaex-astro vaex-distributed pyspark py4j \
spacy fastparquet python-snappy nodejs koalas textacy pystan fbprophet setuptools-git=1.2 vispy=0.6.4 --yes

# For database
pip install arctic==1.79.2

# Celery library
pip install celery==4.4.0 celery[redis] celery[msgpack] msgpack-python

# For findatapy (and NLP)
pip install fxcmpy alpha_vantage yfinance twython newspaper3k seasonal pdfminer.six vaderSentiment gensim rise progressbar2=3.50.1

# install tensorflow and transformers/huggingface (on Mac OS can have issues installing TensorFlow, so if you have Mac
# comment it out)
# only if you have GPU
# pip install tensorflow-gpu transformers cvlib pytesseract cmdstanpy==0.4 tabula-py==1.4.3
pip install tensorflow==2.1.0 transformers pytesseract cmdstanpy==0.4 tabula-py==1.4.3

# Install PyTorch
# only if you have GPU
# conda install pytorch torchvision cudatoolkit=10.0 -c pytorch --yes
conda install pytorch torchvision cpuonly -c pytorch --yes
conda install -c conda-forge opencv --yes
pip install cvlib

# modin (later versions need later versions of pandas)
# may downgrade to pandas to 0.24.2
pip install modin==0.5.4

# findatapy, chartpy and finmarketpy (or can manually clone these from GitHub and add to your Python path)
# need to have Git
# pip install git+https://github.com/cuemacro/finmarketpy.git git+https://github.com/cuemacro/chartpy.git git+https://github.com/cuemacro/findatapy.git
pip install finmarketpy chartpy findatapy

# Graphics libraries
pip install cufflinks==0.17 plotly_express==0.4.1 \
        dash==1.9.0 dash-html-components==1.0.2 dash-core-components==1.8.0 plotly==4.5.4 dash-table==4.6.0

# To be able to plot Plotly into PNG or JPG
conda install -c plotly plotly-orca --yes

# In case has been installed elsewhere by pip
pip uninstall pandas

# Newer versions of Pandas aren't supported as well by other libraries (eg. Arctic), so stick to 0.24.2
conda install -c anaconda pandas=0.24.2 --yes
conda install -c conda-forge pyarrow=0.16.0 --yes

# GPU libraries
# conda install -c rapidsai -c nvidia -c conda-forge -c defaults rapids=0.10 python=3.6

# Jupyter and Jupyterlab extensions
jupyter contrib nbextension install --user # to activate js on Jupyter
jupyter nbextension enable execute_time/ExecuteTime
jupyter-nbextension install rise --py --sys-prefix
jupyter labextension install @jupyter-widgets/jupyterlab-manager@2.0.0 --no-build
jupyter labextension install plotlywidget@1.5.4 --no-build
jupyter labextension install jupyterlab-plotly@1.5.4 --no-build
jupyter lab build


