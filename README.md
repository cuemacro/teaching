 teaching - resources for Cuemacro courses

In this repo, we have resources for Cuemacro courses (including Python for finance taught on QDC), such as how to install Anaconda, PyCharm etc.

For more information about my Python for finance workshops, please contact saeed@cuemacro.com

For instructions on how to install Anaconda and PyCharm see [Installing Anaconda and PyCharm](pythoncourse/installation/installing_anaconda_and_pycharm.ipynb)

If you can't view the Jupyter notebook in GitHub, you can try viewing that by copying and pasting the URL for the installation guide
https://github.com/cuemacro/teaching/blob/master/pythoncourse/installation/installing_anaconda_and_pycharm.ipynb
in https://nbviewer.jupyter.org/ ie. to go to the following link 
https://nbviewer.jupyter.org/github/cuemacro/teaching/blob/master/pythoncourse/installation/installing_anaconda_and_pycharm.ipynb

# Jupyter notebooks on teaching 

* [Installing Anaconda Python and PyCharm (nbviewer link)](https://nbviewer.jupyter.org/github/cuemacro/teaching/blob/master/pythoncourse/installation/installing_anaconda_and_pycharm.ipynb) - how to install a Python environment for data analysis

You can also run some of the notebooks interactively with Binder too

* [Coronavirus example (nbviewer link)](https://nbviewer.jupyter.org/github/cuemacro/teaching/blob/master/pythoncourse/notebooks/coronavirus_example.ipynb) or run interactively in [Binder](https://mybinder.org/v2/gh/cuemacro/teaching/master?filepath=pythoncourse/notebooks/coronavirus_example.ipynb) - how to download case data for coronavirus and do basic analysis including charting
* [Numba example (nbviewer link)](https://nbviewer.jupyter.org/github/cuemacro/teaching/blob/master/pythoncourse/notebooks/numba_example.ipynb) or run interactively in [Binder](https://mybinder.org/v2/gh/cuemacro/teaching/master?filepath=pythoncourse/notebooks/numba_example.ipynb) - how to speed up CDF with Numba
* [Timestream example (nbviewer link)](https://nbviewer.jupyter.org/github/cuemacro/teaching/blob/master/pythoncourse/notebooks/timestream_example.ipynb) or run interactively in [Binder](https://mybinder.org/v2/gh/cuemacro/teaching/master?filepath=pythoncourse/notebooks/timestream_example.ipynb) - using AWS Timestream database from Python
* [Vaex example (nbviewer link)](https://nbviewer.jupyter.org/github/cuemacro/teaching/blob/master/pythoncourse/notebooks/vaex_example.ipynb) or run interactively in [Binder](https://mybinder.org/v2/gh/cuemacro/teaching/master?filepath=pythoncourse/notebooks/timestream_example.ipynb) - TBA Binder friendly version

# Coding log

* 03 Feb 2022
  * Updated Windows conda environment (`environment_windows.yml` 
  & `create_conda_env_windows.bat`)
  * Updated Linux conda environment (`environment_linux.yml` 
  & `create_conda_env_linux.sh`)
* 02 Feb 2022
  * Made modin version=0.9.1 for scripts
* 15 Jan 2022
  * Updated yfinance in conda YML to 0.1.69
* 25 Oct 2021
  * Minor update to installation instructions
* 08 Oct 2021
  * Updated some library versions (chartpy, findatapy and finmarketpy)
* 29 Jul 2021
  * Updated environment.yml files for yfinance 0.1.63
* 25 Jun 2021
  * Updated xlwings files for py38class
* 03 Jun 2021
  * Updated findatapy library in conda environments
* 01 Jun 2021
  * Updated Cuemacro libraries to latest versions for conda environments
* 24 Apr 2021
  * Updated conda environments to Python 3.8 and Pandas 1.2.3
* 09 Mar 2021
  * Updated installation instructions
* 08 Mar 2021
  * Updated installation instructions
* 07 Mar 2021
  * Added if all else fails conda installation
* 04 Mar 2021
  * Updated conda bat/sh files (now use mamba to install libraries instead of conda)
  * Updated conda environments
* 18 Feb 2021
  * Updated Python installation instructions
* 13 Feb 2021
  * Added vaex example
* 11 Feb 2021
  * Updated conda environments and Python installation instructions
* 12 Jan 2021
  * Added pyxll to Windows conda env
* 02 Jan 2021
  * Updated conda enviornment with newest FinancePy
  * Added Numba example Jupyter notebook
* 15 Dec 2020
    * Updated conda environment for Mac for pyarrow 2.0.0 (and fixed transformers)
* 14 Dec 2020
    * Updated conda environments for Windows and Linux for TensorFlow 2.3.0 and pyarrow 2.0.0
* 17 Nov 2020
    * Updated Anaconda installation notes
    * Added Google Colab details
* 13 Nov 2020
    * Adding Binder
    * Fixed Linux conda environment file (and updated Windows)
* 03 Nov 2020
    * Updated Linux conda environment to TensorFlow 2.2.0
* 31 Oct 2020
    * Added Timestream notebook
* 25 Oct 2020
    * Updated Linux and Windows conda environments to include boto3
* 20 Oct 2020
    * Updated Python environments to latest finmarketpy (0.11.7)
* 14 Oct 2020
    * Added extra instructions for finding environment.yml files when installing conda environment
* 01 Oct 2020
    * Updated Python environments to include FinancePy
* 13 Sep 2020
    * Removed multiprocessing_on_dill dep
* 27 Aug 2020
    * Updated Python environments to Pandas 1.0.5 and Python 3.7
* 30 Jun 2020
    * Added orca path on coronavirus notebook
* 29 Jun 2020
    * Updated coronavirus path and tidied conda installation files
* 25 Jun 2020
    * Added BAT file to start Excel/xlwings
* 23 Jun 2020
    * Updated Celery files and coronavirus notebook
* 08 Jun 2020
    * Updated YML files for chartpy v0.1.8
* 07 Jun 2020
    * Fixed Windows conda YML file (fixed vaex link), also updated Linux YML file
* 04 Jun 2020
    * Added Mac conda environment (and installation)
* 30 May 2020
    * Added pyLDAvis to Anaconda installation files
* 27 May 2020
    * Updated Anaconda installation files (speeded up, removed modin)
* 27 May 2020
    * Updated Anaconda installation files (new Plotly version)
    * Added different filter for removing comments in Jupyter notebook
* 21 May 2020
    * Updated Anaconda installation files and environment YML files to include new Python libaries
* 06 May 2020
    * Note on using nbviewer to view Jupyter notebooks
    * Updated Anaconda installation files
    * Updated environment YML files for new versions of chartpy, findatapy and finmarketpy
* 12 Apr 2020
    * Updated coronavirus Jupyter notebook, fixing bugs and adding new charts
    * Updated Anaconda installation files for Windows and Linux with new libraries
* 28 Mar 2020
    * Updated coronavirus Jupyter notebook with interactive ipywidgets examples from Ewan Kirk
    * Updated Anaconda installation files for Windows and Linux
* 25 Mar 2020
    * Updated coronavirus Jupyter notebook with new paths for source data and lagged analysis
* 12 Mar 2020
    * Edited Anaconda installation files
    * Added coronavirus Jupyter notebook example
* 21 Feb 2020
    * Added extra details on checking Azure Notebook package installation
    * Added additional libraries to conda installations for Windows and Linux
* 21 Jan 2020
    * Added Jupyterlab installation extensions
* 07 Jan 2020 
    * Added Dash example for event study 
    * Added xlwings example for backtesting
    * Script to strip input code from Jupyter notebooks
* 03 Jan 2020 - Added more market data
* 31 Dec 2019 - Added extra Dash examples
* 19 Dec 2019 - Now using later findatapy version
* 08 Dec 2019 - Fixed updated instructions using Azure
* 04 Dec 2019 - Updated installation instructions for Anaconda/and using Azure notebooks
* 11 Nov 2019 - Added course code (xlwings)
* 28 Oct 2019 - Added Bloomberg installation
* 27 Oct 2019 - Added source code
* 24 Oct 2019 - Added sample FX data
* 23 Oct 2019 - Updated installation instructions for pip installation
* 12 Oct 2019 - Fixed typos and added GPU libraries
* 07 Oct 2019 - Added details on setting paths in Anaconda installation
* 02 Oct 2019 - Moved files for installation
* 01 Oct 2019 - Created teaching GitHub repo

End of note
