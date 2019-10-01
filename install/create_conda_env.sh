#!/usr/bin/env bash

conda remove -n py36 --all
conda create -n py36 python=3.6 anaconda

source deactivate
source activate py36

# newer versions of Pandas aren't supported as well by other libraries (eg. Arctic), so stick to 0.24.2
conda install -c anaconda pandas=0.24.2 --yes

# install from conda-forge (pyarrow is a newer version!)
conda install -c conda-forge \
jupyterlab jupyter_contrib_nbextensions jupyter_nbextensions_configurator \
redis-py=3.3.7 python-blosc=1.8.1 pathos pyarrow=0.14.1 graphviz python-graphviz rise textblob wordcloud quandl keras \
vaex-core vaex-viz vaex-jupyter vaex-arrow vaex-server vaex-hdf5 vaex-astro vaex-distributed pyspark py4j spacy --yes

# graphics libraries
pip install cufflinks==0.16 plotly_express==0.3.1 dash==1.1.1 dash-html-components==1.0.0 dash-core-components==1.1.1 plotly==3.10.0 dash-table==4.1.0 --yes

# for database
pip install arctic=1.79.2 --yes

# to be able to plot Plotly into PNG or JPG
conda install -c plotly plotly-orca --yes

jupyter contrib nbextension install --user # to activate js on Jupyter
jupyter nbextension enable execute_time/ExecuteTime
jupyter-nbextension install rise --py --sys-prefix

# celery library
pip install celery==4.3.0 celery[redis] celery[msgpack] msgpack-python --yes

# for findatapy
pip install fxcmpy alpha_vantage yfinance twython newspaper3k seasonal pdfminer.six --yes

# modin (downgrade pandas version)
# may downgrade to pandas to 0.24.2
pip install modin --yes

# findatapy, chartpy and finmarketpy (or can manually clone these from GitHub and add to your Python path)
# sudo yum install git # for Linux
pip install git+https://github.com/cuemacro/finmarketpy.git git+https://github.com/cuemacro/chartpy.git git+https://github.com/cuemacro/findatapy.git --yes


