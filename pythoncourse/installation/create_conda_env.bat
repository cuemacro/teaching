REM Assumes that Anaconda has already been downloaded

REM Update conda
call conda update -n base -c defaults conda --yes

call conda activate

REM Remove any existing environment called py36class, and create a py36class with anaconda packages
call conda remove -n py36class --all --yes
call conda create -n py36class python=3.6 anaconda
call conda activate py36class

REM Install from conda-forge
call conda install -c conda-forge ^
jupyterlab jupyter_contrib_nbextensions jupyter_nbextensions_configurator ipywidgets=7.5 ^
redis-py=3.3.7 python-blosc=1.8.1 pathos graphviz python-graphviz textblob wordcloud quandl pyspark py4j ^
spacy fastparquet python-snappy nodejs koalas textacy pystan fbprophet setuptools-git=1.2 vispy=0.6.4 blpapi --yes

call pip install arctic==1.79.2

REM Install tensorflow, transformers/huggingface and table readers
REM only if you have GPU
REM call pip install tensorflow-gpu transformers cvlib pytesseract cmdstanpy==0.4 tabula-py==1.4.3
call pip install tensorflow==2.1.0 transformers pytesseract cmdstanpy==0.4 tabula-py==1.4.3

REM Install PyTorch
REM only if you have GPU
REM call conda install pytorch torchvision cudatoolkit=10.0 -c pytorch --yes
call conda install pytorch torchvision cpuonly -c pytorch --yes
call conda install -c conda-forge opencv --yes
call pip install cvlib

REM For findatapy (and NLP)
call pip install fxcmpy alpha_vantage yfinance twython newspaper3k seasonal pdfminer.six vaderSentiment gensim rise

REM findatapy, chartpy and finmarketpy
REM needs git
REM call pip install git+https://github.com/cuemacro/finmarketpy.git git+https://github.com/cuemacro/chartpy.git git+https://github.com/cuemacro/findatapy.git
call pip install finmarketpy chartpy findatapy

REM Graphics libraries
call pip install cufflinks==0.17 plotly_express==0.4.1 dash==1.9.0 dash-html-components==1.0.2 dash-core-components==1.8.0 plotly==4.5.4 dash-table==4.6.0

REM To be able to plot Plotly into PNG or JPG
call conda install -c plotly plotly-orca --yes

REM In case has been installed elsewhere by pip
call pip uninstall pandas

REM Newer versions of Pandas aren't supported as well by other libraries eg. Arctic so stick to 0.24.2
call conda install -c anaconda pandas=0.24.2 --yes
call conda install -c conda-forge pyarrow=0.16.0 --yes

REM Jupyter libraries
call jupyter contrib nbextension install --user
call jupyter nbextension enable execute_time/ExecuteTime
call jupyter-nbextension install rise --py --sys-prefix
call jupyter labextension install @jupyter-widgets/jupyterlab-manager@2.0.0 --no-build
call jupyter labextension install plotlywidget@1.5.4 --no-build
call jupyter labextension install jupyterlab-plotly@1.5.4 --no-build
call jupyter lab build

