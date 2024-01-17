REM Assumes that Anaconda has already been downloaded and installed
REM Tested with Anaconda3-2021.11 on Windows

REM Can create an environment YML file by running: conda env export > environment_windows.yml
REM Create env from YML: conda env create -f environment_windows.yml

call conda activate

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
call mamba install anaconda scikit-learn matplotlib xlwings=0.23.0 lz4 dask=2021.4.0 ^
    pandas=1.2.3 scipy=1.6.1 numpy=1.19.1 -c anaconda --yes
call mamba install tensorflow graphviz python-graphviz -c anaconda --yes
call mamba install pytorch torchvision cpuonly -c pytorch --yes
call mamba install pyarrow opencv=4.5.3 modin=0.9.1 ^
    boto3 ^
    redis-py python-blosc pathos textblob ^
    pyspark koalas vaex=4.7.0 pandas=1.2.3 scipy=1.6.1 numpy=1.19.1 ^
    spacy fastparquet python-snappy nodejs pystan fbprophet setuptools-git ^
    vispy datashader pyproj holoviews streamz quandl bqplot blpapi gensim=3.8.3 ^
    textacy=0.10.0 transformers pyldavis eikon=1.1.5 findspark celery ^
    pytesseract tabula-py ^
    newspaper3k dtale ^
    sentencepiece jupyter_contrib_nbextensions ^
    jupyter_nbextensions_configurator voila -c conda-forge --yes
call mamba install pandas=1.2.3 scipy=1.6.1 numpy=1.19.1 -c anaconda --yes

REM Install findatapy, chartpy and findatapy
REM Install various graphics libraries
call pip install ^
   alpha_vantage yfinance twython seasonal pdfminer.six ^
   vaderSentiment rise requests_html ^
   cvlib==0.2.6 ^
   cufflinks==0.17.3 plotly kaleido wordcloud ^
        dash dash-html-components dash-core-components ^
        dash-table jupyter-dash chart_studio Pillow==7.2.0 ^
   finmarketpy chartpy findatapy financepy==0.310 pandas==1.2.3

REM plotly==4.14.3
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

REM Run this if you need to use spacy to install the large English model
REM call python -m spacy download en_core_web_lg