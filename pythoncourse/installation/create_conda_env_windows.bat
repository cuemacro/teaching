REM Assumes that Anaconda has already been downloaded and installed

REM Can create an environment YML file by running: conda env export > environment_windows.yml
REM Create env from YML: conda env create -f environment_windows.yml

REM Update conda
call conda update -n base -c defaults conda --yes

call conda activate

REM Remove any existing environment called py37class, and create a py37class with anaconda packages
call conda remove -n py37class --all --yes
call conda create -n py37class python=3.7
call conda activate py37class

REM Install Tensorflow, PyTorch and Anaconda (lots of packages)
REM only if you have GPU below 2 lines instead of CPU versions
REM call conda install anaconda tensorflow-gpu=2.3.0 anaconda pandas=1.0.5 scikit-learn=0.20.2 graphviz python-graphviz matplotlib xlwings=0.20.2 -c anaconda --yes
REM call conda install pytorch torchvision cudatoolkit=10.1 ^
call conda install anaconda tensorflow=2.3.0 pandas=1.0.5 scikit-learn=0.20.2 graphviz python-graphviz matplotlib xlwings=0.22.0 -c anaconda --yes
call conda install pytorch torchvision cpuonly ^
    pyarrow opencv modin=0.8.0 ^
    boto3 jupyter_contrib_nbextensions jupyter_nbextensions_configurator ^
    redis-py python-blosc pathos textblob ^
    vaex=3.0.0 ^
    pyspark koalas ^
    spacy fastparquet python-snappy nodejs pystan fbprophet setuptools-git ^
    vispy datashader pyproj holoviews streamz quandl bqplot blpapi ^
    -c pytorch -c conda-forge --yes

REM Install database
REM Install Celery
REM For findatapy (and NLP) and complex graphics
REM Install transformers/huggingface and table libraries
REM Install graphics/plotting libraries
REM Install findatapy, chartpy and findatapy
call pip install arctic==1.79.2 ^
   celery==4.4.0 celery[redis] celery[msgpack] msgpack-python ^
   fxcmpy alpha_vantage yfinance twython newspaper3k seasonal pdfminer.six vaderSentiment gensim wordcloud RISE requests_html ^
   textacy==0.8.0 ^
   transformers pytesseract cmdstanpy==0.4 tabula-py==1.4.3 ^
   cvlib ^
   cufflinks==0.17.3 plotly==4.9.0 kaleido ^
        dash==1.12.0 dash-html-components==1.0.3 dash-core-components==1.10.0 dash-table==4.7.0 jupyter-dash==0.2.1 chart_studio==1.1.0 ^
        dtale==1.8.1 pyldavis progressbar2==3.38.0 ^
   finmarketpy chartpy findatapy financepy eikon==1.1.5 pyxll

REM Jupyter libraries
call jupyter contrib nbextension install --user
call jupyter nbextension enable execute_time/ExecuteTime
call jupyter-nbextension install rise --py --sys-prefix

REM some of these extensions are not compatible with latest Jupyterlab
REM call jupyter labextension install @jupyter-widgets/jupyterlab-manager --no-build
REM call jupyter labextension install plotlywidget --no-build
REM call jupyter labextension install jupyterlab-plotly --no-build
REM call jupyter labextension install bqplot --no-build
REM call jupyter lab build
