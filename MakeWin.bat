@echo off
REM Windows script for the SimPhoNy Framework

REM Current features of this script:
REM     - install simphony-common package
REM     - install nCad wrapper package
REM     - install nfluid package
REM     - install entire SimPhoNy Framework
REM     - uninstall entire SimPhoNy Framework
REM     - install pip package manager

REM All installation packages are directly downloaded and installed from GitHub

REM What is pendant in this script:
REM     - Lammps integration?
REM     - JYU-LB integration?
REM     - Openfoam integration?
REM     - Mayavi integration?
REM     - Testing command
REM     - Virtualenv command


REM Current SimPhoNy version to be installed
set SIMPHONYVERSION=0.2.0
REM Current nCad version to be installed
set NCADVERSION=0.2.1
REM Current nFluid version to be installed
set NFLUIDVERSION=0.0.2.1


REM Check that we only get one argument
if     '%1'==''  goto help
if not '%2'==''  goto help
goto check_target


:help
echo Usage: 'MakeWin ^<target^>' with one of these targets:
echo   simphony:        install simphony library (version %SIMPHONYVERSION%)
echo   simphony-ncad:   install ncad plugin      (version %NCADVERSION%)
echo   nfluid:          install nfluid package   (version %NFLUIDVERSION%)
echo   all:             install simphony, ncad and nfluid modules
echo   clean:           remove simphony, ncad and nfluid modules
echo   pip:             install pip package manager
goto exit


:check_target
if '%1'=='simphony'       goto simphony
if '%1'=='simphony-ncad'  goto simphony-ncad
if '%1'=='nfluid'         goto nfluid
if '%1'=='all' (
                          call %0 simphony
                          call %0 simphony-ncad
                          call %0 nfluid
                          goto exit
               )
if '%1'=='clean'          goto clean
if '%1'=='help'           goto help
if '%1'=='pip'            goto pip
REM ----- DEVELOPMENT -------------------------
if '%1'=='nfluid-dev'     goto nfluid-dev
REM -------------------------------------------
goto help


:simphony
echo ----- INSTALLING SIMPHONY -----
REM Check if pip is installed
python -c "import pip" 2>nul
if %ERRORLEVEL% neq 0  call %0 pip

REM Retrieve and install simphony library
pip install --upgrade git+https://github.com/simphony/simphony-common.git@%SIMPHONYVERSION%#egg=simphony
goto exit


:simphony-ncad
echo ----- INSTALLING SIMPHONY-NCAD -----
REM Check if pip is installed
python -c "import pip" 2>nul
if %ERRORLEVEL% neq 0  call %0 pip
REM Check if cython is installed
python -c "import cython" 2>nul
if %ERRORLEVEL% neq 0  pip install cython
REM Check if simphony is installed
python -c "import simphony" 2>nul
if %ERRORLEVEL% neq 0  call %0 simphony

pip install --upgrade git+https://github.com/simphony/simphony-nCAD.git@%NCADVERSION%#egg=simphony_ncad
goto exit


:nfluid
echo ----- INSTALLING NFLUID -----
REM Check if pip is installed
python -c "import pip" 2>nul
if %ERRORLEVEL% neq 0  call %0 pip
REM Check if simphony is installed
python -c "import simphony" 2>nul
if %ERRORLEVEL% neq 0  call %0 simphony

pip install --upgrade git+https://github.com/simphony/nfluid.git@%NFLUIDVERSION%#egg=nfluid
goto exit


:nfluid-dev
echo ----- INSTALLING NFLUID-DEV -----
pip install --upgrade git+https://github.com/simphony/nfluid.git@nfluid-goyo-dev#egg=nfluid-goyo-dev
goto exit


:clean
echo ----- REMOVING SIMPHONY, SIMPHONY-NCAD AND NFLUID -----
for /d %%f in ("C:\Python27\Lib\site-packages\ncad_wrapper*") do rd /s /q "%%~f"
for /d %%f in ("C:\Python27\Lib\site-packages\nfluid*") do rd /s /q "%%~f"
for /d %%f in ("C:\Python27\Lib\site-packages\simncad*") do rd /s /q "%%~f"
for /d %%f in ("C:\Python27\Lib\site-packages\simphony*") do rd /s /q "%%~f"
goto exit


:pip
REM Get pip package
REM -- using urllib
python -c "import urllib; urllib.urlretrieve('https://bootstrap.pypa.io/get-pip.py', 'C:\Python27\Tools\get-pip.py')"
REM -- using urllib2
REM python -c "import urllib2; ifile=urllib2.urlopen('https://bootstrap.pypa.io/get-pip.py');ofile=open('C:/Python27/Tools/pip.py','wb');ofile.write(ifile.read());ofile.close()"
REM Install pip
python C:\Python27\Tools\get-pip.py
del C:\Python27\Tools\get-pip.py
echo.
echo Please add C:\Python27\Scripts\ to your PATH environment
goto exit


:exit
REM pause
echo.

