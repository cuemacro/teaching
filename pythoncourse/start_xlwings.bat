REM illustrates how to start xlwings to force it to include your conda environment
REM note you may need to change some of the PYTHONPATH or PATH variables (or you can add your own)
call C:\Anaconda3\Scripts\activate.bat
call conda activate py37class

set PYTHONPATH=e:\cuemacro\chartpy\;e:\cuemacro\findatapy\;e:\cuemacro\finmarketpy\;e:\cuemacro\pythoncourse\;%PYTHONPATH%
set PATH=%PATH%

call "c:\Program Files\Microsoft Office\root\Office16\excel" /x