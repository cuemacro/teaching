REM assumes that Anaconda has already been downloaded

REM update conda
call conda update -n base -c defaults conda --yes

REM remove any existing environment called py36, and create a py36 with anaconda packages
REM call conda remove -n py36 --all
call conda create -n py36 python=3.6 anaconda --yes
call conda activate py36

REM newer versions of Pandas aren't supported as well by other libraries (eg. Arctic), so stick to 0.24.2
call conda install -c anaconda pandas=0.24.2 --yes

REM install from conda-forge (pyarrow is a newer version!)
call conda install -c conda-forge ^
jupyterlab jupyter_contrib_nbextensions jupyter_nbextensions_configurator ^
redis-py=3.3.7 python-blosc=1.8.1 pathos graphviz python-graphviz rise textblob wordcloud quandl spacy --yes

call conda install -c conda-forge pystan fbprophet --yes

REM graphics libraries
call pip install cufflinks==0.16 plotly_express==0.3.1 dash==1.1.1 dash-html-components==1.0.0 dash-core-components==1.1.1 plotly==3.10.0 dash-table==4.1.0 --yes

REM to be able to plot Plotly into PNG or JPG
call conda install -c plotly plotly-orca --yes

REM Jupyter libraries
call jupyter contrib nbextension install --user
call jupyter nbextension enable execute_time/ExecuteTime
call jupyter-nbextension install rise --py --sys-prefix

call pip install arctic==1.79.2

REM for findatapy
call pip install fxcmpy alpha_vantage yfinance twython newspaper3k seasonal pdfminer.six --yes

REM findatapy, chartpy and finmarketpy
REM needs git
REM pip install git+https://github.com/cuemacro/finmarketpy.git git+https://github.com/cuemacro/chartpy.git git+https://github.com/cuemacro/findatapy.git


