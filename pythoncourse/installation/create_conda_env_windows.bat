REM Assumes that Anaconda has already been downloaded and installed

REM Can create an environment YML file by running: conda env export > environment_windows.yml
REM Create env from YML: conda env create -f environment_windows.yml

REM Update conda
call conda update -n base -c defaults conda --yes

call conda activate

REM mamba is a very fast version of conda https://github.com/mamba-org/mamba
REM if you have problems with mamba, remove the below line and make all references to mamba => conda later on in
REM this script
call conda install mamba=0.7.3 -n base -c conda-forge
REM 0.7.3

REM Remove any existing environment called py38class, and create a py38class with anaconda packages
call mamba remove -n py38class --all --yes
call mamba create -n py38class python=3.8
call conda activate py38class

REM Install Tensorflow, PyTorch and Anaconda (lots of packages)
REM only if you have GPU below 2 lines instead of CPU versions
REM call mamba install anaconda tensorflow-gpu=2.3.0 anaconda pandas=1.2.3 scikit-learn graphviz python-graphviz matplotlib xlwings=0.23.0 ^
REM   pytorch torchvision cudatoolkit=10.1 ^
call mamba install anaconda scikit-learn matplotlib xlwings=0.23.0 -c anaconda --yes
call mamba install tensorflow graphviz python-graphviz -c anaconda --yes
call mamba install pytorch torchvision cpuonly -c pytorch --yes
call mamba install pyarrow opencv modin ^
    boto3 ^
    redis-py python-blosc pathos textblob ^
    pyspark koalas vaex=4.0.0 numpy=1.19.1 ^
    spacy fastparquet python-snappy nodejs pystan fbprophet setuptools-git ^
    vispy datashader pyproj holoviews streamz quandl bqplot blpapi -c conda-forge --yes
call mamba install jupyter_contrib_nbextensions jupyter_nbextensions_configurator voila notebook=6.1.4 -c conda-forge --yes
call mamba install pandas=1.2.3 -c anaconda --yes

REM Install database
REM Install Celery
REM For findatapy and NLP and complex graphics
REM Install transformers/huggingface and table libraries
REM Install graphics/plotting libraries
REM Install findatapy, chartpy and findatapy
call pip install arctic==1.79.4 ^
   celery==5.0.5 celery[redis] celery[msgpack] msgpack-python ^
   fxcmpy alpha_vantage yfinance twython newspaper3k seasonal pdfminer.six vaderSentiment gensim wordcloud rise requests_html ^
   textacy sentencepiece ^
   transformers pytesseract cmdstanpy tabula-py  ^
   cvlib ^
   cufflinks==0.17.3 plotly==4.14.3 kaleido ^
        dash==1.20.0 dash-html-components==1.1.3 dash-core-components==1.16.0 dash-table==4.11.3 jupyter-dash==0.4.0 chart_studio==1.1.0 ^
        dtale==1.43.0 pyldavis ^
   finmarketpy chartpy findatapy financepy==0.193 eikon==1.1.5 pyxll findspark pandas==1.2.3 numpy==1.19.1 notebook==6.1.4

REM Hack for vaex!
call pip uninstall progressbar2
call pip install progressbar2

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