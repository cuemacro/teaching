REM Assumes that Anaconda has already been downloaded and installed

REM Update conda
call conda update -n base -c defaults conda --yes

call conda activate

REM Remove any existing environment called py36class, and create a py36class with anaconda packages
call conda remove -n py36class --all --yes
call conda create -n py36class python=3.6 anaconda
call conda activate py36class

REM Install scikit-learn (downgrade for some later dependencies) - xlwings for Windows
call conda install anaconda scikit-learn=0.20.2 --yes
call conda install -c conda-forge xlwings=0.19.4 --yes

REM Install PyTorch & Tensorflow
REM only if you have GPU below 2 lines instead of CPU versions
REM call conda install tensorflow-gpu=2.1.0
REM call conda install pytorch torchvision cudatoolkit=10.1 -c pytorch --yes
call conda install anaconda tensorflow=2.1.0 --yes
call conda install pytorch torchvision cpuonly -c pytorch --yes

REM Install from conda-forge (pyarrow is a newer version!)
call conda install -c conda-forge ^
  jupyter_contrib_nbextensions jupyter_nbextensions_configurator ^
  redis-py python-blosc pathos graphviz python-graphviz textblob ^
  vaex-core vaex-viz vaex-jupyter vaex-arrow vaex-server vaex-hdf5 vaex-astro vaex-distributed ^
  pyspark=2.4.0 koalas ^
  spacy fastparquet python-snappy nodejs pystan fbprophet setuptools-git ^
  vispy datashader pyproj holoviews streamz quandl bqplot opencv s3fs blpapi ^
  --yes

REM Install database
REM Install Celery
REM For findatapy (and NLP) and complex graphics
REM Install transformers/huggingface and table libraries
REM Install graphics/plotting libraries
REM Install findatapy, chartpy and findatapy
call pip install arctic==1.79.2 ^
   celery==4.4.0 celery[redis] celery[msgpack] msgpack-python ^
   fxcmpy alpha_vantage yfinance twython newspaper3k seasonal pdfminer.six vaderSentiment gensim wordcloud rise requests_html ^
   textacy==0.8.0 ^
   transformers pytesseract cmdstanpy==0.4 tabula-py==1.4.3 ^
   cvlib ^
   cufflinks==0.17.3 plotly==4.8.0 ^
        dash==1.12.0 dash-html-components==1.0.3 dash-core-components==1.10.0 dash-table==4.7.0 dtale==1.8.1 progressbar2==3.38.0 ^
   finmarketpy chartpy findatapy

REM To be able to plot Plotly into PNG or JPG
call conda install -c plotly plotly-orca --yes

REM In case has been installed elsewhere by pip
call pip uninstall pandas

REM Newer versions of Pandas aren't supported as well by other libraries eg. Arctic so stick to 0.24.2
call conda install -c anaconda pandas=0.24.2 --yes
call conda install -c conda-forge pyarrow=0.17.1 --yes

REM Jupyter libraries
call jupyter contrib nbextension install --user
call jupyter nbextension enable execute_time/ExecuteTime
call jupyter-nbextension install rise --py --sys-prefix
call jupyter labextension install @jupyter-widgets/jupyterlab-manager --no-build
call jupyter labextension install plotlywidget --no-build
call jupyter labextension install jupyterlab-plotly --no-build
call jupyter labextension install bqplot
call jupyter lab build

