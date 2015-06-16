# Makefile for Simphony Framework
#

# You can set these variables from the command line.
SIMPHONYENV   ?= ~/simphony
SIMPHONYVERSION  ?= 0.1.3

.PHONY: clean base apt-openfoam apt-simphony apt-lammps apt-mayavi fix-pip simphony-env lammps jyu-lb simphony simphony-lammps simphony-mayavi simphony-openfoam simphony-jyu-lb test-plugins test-framework

help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo "  base              to install essential packages (requires sudo)"
	@echo "  apt-openfoam      to install openfoam 2.2.2 (requires sudo)"
	@echo "  apt-simphony      to install building depedencies for the simphony library (requires sudo)"
	@echo "  apt-lammps        to install building depedencies for the lammps solver (requires sudo)"
	@echo "  apt-mayavi        to install building depedencies for the mayavi (requires sudo)"
	@echo "  fix-pip           to update the version of pip and virtual evn (requires sudo)"
	@echo "  simphony-env      to create a simphony virtualenv"
	@echo "  lammps            to build and install the lammps solver"
	@echo "  jyu-lb            to build and install the JYU-LB solver"
	@echo "  simphony          to build and install the simphony library"
	@echo "  simphony-lammps   to build and install the simphony-lammps plugin"
	@echo "  simphony-mayavi   to build and install the simphony-mayavi plugin"
	@echo "  simphony-openfoam to build and install the simphony-mayavi plugin"
	@echo "  simphony-jyu-lb   to build and install the simphony-jyu-lb plugin"
	@echo "  simphony-plugins  to build and install all the simphony-plugins"
	@echo "  test-plugins      run the tests for all the simphony-plugins"
	@echo "  test-framework    run the tests for the simphony-framework"
	@echo "  clean             remove any temporary folders"

clean:
	rm -Rf src/lammps
	rm -Rf src/JYU-LB
	rm -Rf src/simphony-openfoam
	rm -rf lib/liblammps.so
	@echo
	@echo "Removed temporary folders"

base:
	add-apt-repository ppa:git-core/ppa -y
	apt-get update -qq
	apt-get install build-essential git subversion -y

apt-openfoam:
	echo deb http://www.openfoam.org/download/ubuntu precise main > /etc/apt/sources.list.d/openfoam.list
	apt-get update -qq
	apt-get install -y --force-yes openfoam222
	@echo
	@echo "Openfoam installed use . /opt/openfoam222/etc/bashrc to setup the environment"

apt-simphony:
	add-apt-repository ppa:cython-dev/master-ppa -y
	apt-get update -qq
	apt-get install -y python-dev cython libhdf5-serial-dev libatlas-dev libatlas3gf-base
	@echo
	@echo "Build dependencies for simphony installed"

apt-lammps:
	apt-get update -qq
	apt-get install -y mpi-default-bin mpi-default-dev
	@echo
	@echo "Build dependencies for lammps installed"

apt-mayavi:
	apt-get update -qq
	apt-get install python-vtk python-qt4 python-qt4-dev python-sip python-qt4-gl libqt4-scripttools python-imaging
	@echo
	@echo "Build dependencies for mayavi installed"

fix-pip:
	wget https://raw.github.com/pypa/pip/master/contrib/get-pip.py
	python get-pip.py
	rm get-pip.py
	pip install --upgrade setuptools
	pip install --upgrade virtualenv
	@echo
	pip --version
	@echo "Latest pip installed"

simphony-env:
	rm -rf $(SIMPHONYENV)
	virtualenv $(SIMPHONYENV) --system-site-packages
	@echo
	@echo "Simphony virtualenv created"

lammps:
	rm -Rf src/lammps
	git clone --branch r12824 --depth 1 git://git.lammps.org/lammps-ro.git src/lammps
	$(MAKE) -C src/lammps/src ubuntu_simple -j 2
	cp src/lammps/src/lmp_ubuntu_simple $(SIMPHONYENV)/bin/lammps
	$(MAKE) -C src/lammps/src makeshlib -j 2
	$(MAKE) -C src/lammps/src ubuntu_simple -f Makefile.shlib -j 2
	(mkdir lib; cd src/lammps/python; python install.py ../../../lib $(SIMPHONYENV)/lib/python2.7/site-packages/)
	rm -Rf src/lammps
	@echo
	@echo "Lammps solver installed"

jyu-lb:
	rm -Rf src/JYU-LB
	git clone --branch 0.1.0 https://github.com/simphony/JYU-LB.git src/JYU-LB
	$(MAKE) -C src/JYU-LB -j 2
	cp src/JYU-LB/bin/jyu_lb_isothermal3D.exe $(SIMPHONYENV)/bin/jyu_lb_isothermal3D.exe
	rm -Rf src/JYU-LB
	@echo
	@echo "jyu-lb solver installed"

simphony:
	pip install "numexpr>=2.0.0"
	pip install -r requirements.txt
	pip install --upgrade git+https://github.com/simphony/simphony-common.git@$(SIMPHONYVERSION)#egg=simphony
	@echo
	@echo "Simphony library installed"

simphony-mayavi:
	pip install --upgrade git+https://github.com/simphony/simphony-mayavi.git@0.1.1#egg=simphony_mayavi
	@echo
	@echo "Simphony Mayavi plugin installed"

simphony-openfoam:
	pip install --upgrade svn+https://svn.code.sf.net/p/openfoam-extend/svn/trunk/Breeder/other/scripting/PyFoam#egg=PyFoam
	rm -Rf src/simphony-openfoam
	git clone --branch 0.1.1 --depth 1 https://github.com/simphony/simphony-openfoam.git src/simphony-openfoam
	/opt/openfoam222/wmake/wmake libso src/simphony-openfoam/openfoam-interface
	(cd src/simphony-openfoam/openfoam-interface; python setup.py install)
	(cd src/simphony-openfoam; python setup.py develop)
	@echo
	@echo "Simphony OpenFoam plugin installed"

simphony-jyu-lb:
	pip install --upgrade git+https://github.com/simphony/simphony-jyulb.git@0.1.1#egg=jyu_engine
	@echo
	@echo "Simphony jyu-lb plugin installed"

simphony-lammps:
	pip install --upgrade git+https://github.com/simphony/simphony-lammps-md.git@0.1.3#egg=simlammps
	@echo
	@echo "Simphony lammps plugin installed"

simphony-plugins: simphony-mayavi simphony-openfoam simphony-jyu-lb simphony-lammps
	@echo
	@echo "Simphony plugins installed"

simphony-framework:
	@echo
	@echo "Simphony framework installed"

test-plugins:
	pip install haas
	haas simphony -v
	haas jyulb -v
	LD_LIBRARY_PATH=./lib/:$LD_LIBRARY_PATH haas simlammps -v
	haas simphony_mayavi -v
	(cd src/simphony-openfoam; haas foam_controlwrapper -v)
	@echo
	@echo "Tests for the simphony plugins done"

test-framework: test-plugins
	haas tests/ -v
	@echo
	@echo "Tests for the simphony framework done"
