# Makefile for Simphony Framework
#

# You can set these variables from the command line.
SIMPHONYENV   ?= ~/simphony

# Path for MPI in HDF5 suport
MPI_INCLUDE_PATH ?= /usr/include/mpi

SIMPHONY_COMMON_VERSION  ?= 413eb6f5683c4733b943c300c3192265c79ac26b
SIMPHONY_JYU_LB_VERSION ?= 0.2.0
SIMPHONY_LAMMPS_VERSION ?= 0.1.5
SIMPHONY_NUMERRIN_VERSION ?= 0.1.1
SIMPHONY_OPENFOAM_VERSION ?= 0.2.1
SIMPHONY_KRATOS_VERSION ?= 0.2.0
SIMPHONY_AVIZ_VERSION ?= 0.2.0
SIMPHONY_MAYAVI_VERSION ?= 0.4.1
SIMPHONY_PARAVIEW_VERSION ?= 0.2.0
OPENFOAM_VERSION ?= 231
JYU_LB_VERSION ?= 0.1.2
AVIZ_VERSION ?= v6.5.0
LAMMPS_VERSION ?= r13864 


# Use Paraview OpenFoam? (if no, Paraview from Ubuntu is installed)
USE_OPENFOAM_PARAVIEW ?= no
HAVE_NUMERRIN   ?= no

.PHONY: clean base apt-aviz-deps apt-openfoam-deps apt-simphony-deps apt-lammps-deps apt-mayavi-deps apt-paraview-deps fix-pip fix-simopenfoam simphony-env aviz lammps jyu-lb kratos numerrin simphony simphony-aviz simphony-lammps simphony-mayavi simphony-paraview simphony-openfoam simphony-kratos simphony-jyu-lb simphony-numerrin test-plugins test-framework test-simphony test-aviz test-jyulb test-lammps test-mayavi test-paraview test-openfoam test-kratos test-integration

help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo "  prepare             to prepare the basic environment (requires sudo)"
	@echo "    base                to install essential packages (requires sudo)"
	@echo "    apt-aviz-deps       to install building dependencies for Aviz (requires sudo)"
	@echo "    apt-openfoam-deps   to install openfoam 2.2.2 (requires sudo)"
	@echo "    apt-simphony-deps   to install building depedencies for the simphony library (requires sudo)"
	@echo "    apt-lammps-deps     to install building depedencies for the lammps solver (requires sudo)"
	@echo "    apt-kratos-deps     to install building depedencies for the kratos package (requires sudo)"
	@echo "  plugin-deps         to update the dependencies of the plugins (requires sudo)"
	@echo "    apt-mayavi-deps     to install building depedencies for mayavi (requires sudo)"
	@echo "    apt-paraview-deps   to install building depedencies for paraview (requires sudo)"
	@echo "  prevenv             creates the virtual environment and dependencies not requiring the venv activated"
	@echo "    fix-pip             to update the version of pip and virtual evn (requires sudo)"
	@echo "    simphony-env        to create a simphony virtualenv"
	@echo "    aviz                to install AViz"
	@echo "    kratos              to install the kratos solver"
	@echo "    lammps              to build and install the lammps solver"
	@echo "    numerrin            to install the numerrin solver"
	@echo "    jyu-lb              to build and install the JYU-LB solver"
	@echo "  postvenv            build the packages that require the venv activated"
	@echo "    simphony-common     to build and install the simphony library"
	@echo "    simphony-aviz       to build and install the simphony-aviz plugin"
	@echo "    simphony-kratos     to build and install the simphony-kratos plugin"
	@echo "    simphony-lammps     to build and install the simphony-lammps plugin"
	@echo "    simphony-numerrin   to build and install the simphony-numerrin plugin"
	@echo "    simphony-openfoam   to build and install the simphony-openfoam plugin"
	@echo "    simphony-jyu-lb     to build and install the simphony-jyu-lb plugin"
	@echo "  simphony-plugins    to build and install all the simphony-plugins"
	@echo "    simphony-mayavi     to build and install the simphony-mayavi plugin"
	@echo "    simphony-paraview   to build and install the simphony-mayavi plugin"
	@echo "  test-framework      run the tests for the simphony-framework"
	@echo "    test-plugins        run the tests for all the simphony-plugins"
	@echo "      test-simphony       run the tests for the simphony library"
	@echo "      test-aviz           run the tests for the simphony-aviz plugin"
	@echo "      test-kratos         run the tests for the simphony-kratos plugin"
	@echo "      test-lammps   	     run the tests for the simphony-lammps plugin"
	@echo "      test-numerrin       run the tests for the simphony-numerrin plugin"
	@echo "      test-mayavi         run the tests for the simphony-mayavi plugin"
	@echo "      test-openfoam       run the tests for the simphony-openfoam plugin"
	@echo "      test-jyu-lb         run the tests for the simphony-jyu-lb plugin"
	@echo "    test-integration    run the integration tests"
	@echo "  clean               remove any temporary folders"

clean:
	rm -Rf src/aviz
	rm -Rf src/kratos
	rm -Rf src/lammps
	rm -Rf src/JYU-LB
	rm -Rf src/simphony-openfoam
	rm -Rf src/simphony-numerrin
	@echo
	@echo "Removed temporary folders"

prepare: base apt-openfoam-deps apt-simphony-deps apt-lammps-deps apt-aviz-deps apt-kratos-deps

prevenv: fix-pip simphony-env aviz kratos lammps jyu-lb numerrin

postvenv: simphony-common simphony-aviz simphony-jyu-lb simphony-lammps simphony-mayavi simphony-openfoam simphony-numerrin simphony-kratos

plugin-deps: apt-mayavi-deps apt-paraview-deps

simphony-plugins: simphony-mayavi simphony-paraview

base:
	apt-get update -qq
	apt-get install -y build-essential subversion wget software-properties-common python-software-properties
	add-apt-repository ppa:git-core/ppa -y
	apt-get update -qq
	apt-get install -y git

apt-aviz-deps:
	apt-get update -qq
	apt-get install -y python-qt4 python-qt4-gl qt4-qmake qt4-dev-tools libpng-dev
	@echo
	@echo "Build dependencies for Aviz"

apt-openfoam-deps:
	add-apt-repository http://www.openfoam.org/download/ubuntu
	apt-get update -qq
	apt-get install -y --force-yes openfoam$(OPENFOAM_VERSION)
	@echo
	@echo "Openfoam installed use . /opt/openfoam$(OPENFOAM_VERSION)/etc/bashrc to setup the environment"

apt-simphony-deps:
	add-apt-repository ppa:cython-dev/master-ppa -y
	apt-get update -qq
	apt-get install -y python-dev cython libhdf5-serial-dev libatlas-dev libatlas3gf-base
	@echo
	@echo "Build dependencies for simphony installed"

apt-lammps-deps:
	apt-get update -qq
	apt-get install -y mpi-default-bin mpi-default-dev
	@echo
	@echo "Build dependencies for lammps installed"

apt-mayavi-deps:
	apt-get update -qq
	apt-get install -y python-vtk python-qt4 python-qt4-dev python-sip python-qt4-gl libqt4-scripttools python-imaging
	@echo
	@echo "Build dependencies for mayavi installed"

apt-paraview-deps:
	apt-get update -qq
ifeq ($(USE_OPENFOAM_PARAVIEW),yes)
	echo deb http://www.openfoam.org/download/ubuntu precise main > /etc/apt/sources.list.d/openfoam.list
	apt-get update -qq
	apt-get install -y --force-yes paraviewopenfoam410 libhdf5-openmpi-dev
	@echo
	@echo "Paraview (openfoam) installed"
else
	apt-get install -y --force-yes paraview libhdf5-openmpi-dev
	@echo
	@echo "Paraview (ubuntu) installed"
endif

apt-kratos-deps:
	apt-get update -qq
	apt-get install -y subversion
	@echo
	@echo "Build dependencies for kratos installed"

fix-pip:
	wget https://bootstrap.pypa.io/get-pip.py
	python get-pip.py
	rm get-pip.py
	# Fix version to 27.2. mayavi 4.5.0 does not play nice with setuptools 28.0. 
	# See https://github.com/enthought/mayavi/issues/443
	pip install setuptools==27.2
	pip install --upgrade virtualenv
	pip install --upgrade pip
	@echo
	pip --version
	@echo "Latest pip installed"

simphony-env:
	rm -rf $(SIMPHONYENV)
	virtualenv $(SIMPHONYENV) --system-site-packages
	echo "LD_LIBRARY_PATH=$(SIMPHONYENV)/lib:$(LD_LIBRARY_PATH)" >> $(SIMPHONYENV)/bin/activate
	echo "export LD_LIBRARY_PATH" >> $(SIMPHONYENV)/bin/activate
	@echo
	@echo "Simphony virtualenv created"

aviz:
	rm -Rf src/aviz
	git clone --branch $(AVIZ_VERSION) https://github.com/simphony/AViz src/aviz
	(cd src/aviz/src; qmake aviz.pro; make; cp aviz $(SIMPHONYENV)/bin/)
	@echo
	@echo "Aviz installed"

lammps:
	rm -Rf src/lammps
	# bulding and installing executable
	git clone --branch $(LAMMPS_VERSION) --depth 1 git://git.lammps.org/lammps-ro.git src/lammps
	$(MAKE) -C src/lammps/src ubuntu_simple -j 3
	cp src/lammps/src/lmp_ubuntu_simple $(SIMPHONYENV)/bin/lammps
	# bulding and installing python module
	$(MAKE) -C src/lammps/src -j 2 ubuntu_simple mode=shlib
	(cd src/lammps/python; python install.py $(SIMPHONYENV)/lib/python2.7/site-packages/)
	rm -Rf src/lammps
	# build liggghts
	@echo "Building LIGGGHTS"
	git clone --branch 3.3.0 --depth 1 git://github.com/CFDEMproject/LIGGGHTS-PUBLIC.git src/lammps/myliggghts
	$(MAKE) -C src/lammps/myliggghts/src fedora -j 2
	cp src/lammps/myliggghts/src/lmp_fedora $(SIMPHONYENV)/bin/liggghts
	@echo
	@echo "Lammps/LIGGGHTS solver installed"

jyu-lb:
	rm -Rf src/JYU-LB
	git clone --branch $(JYU_LB_VERSION) https://github.com/simphony/JYU-LB.git src/JYU-LB
	$(MAKE) -C src/JYU-LB -j 2
	cp src/JYU-LB/bin/jyu_lb_isothermal.exe $(SIMPHONYENV)/bin/jyu_lb_isothermal.exe
	rm -Rf src/JYU-LB
	@echo
	@echo "jyu-lb solver installed"

kratos:
	rm -Rf src/kratos
	mkdir -p src/kratos
	wget https://web.cimne.upc.edu/users/croig/data/kratos-simphony.tgz -O src/kratos/kratos.tgz
	(tar -xzf src/kratos/kratos.tgz -C src/kratos; rm -Rf src/kratos/kratos.tgz)
	rm -rf $(SIMPHONYENV)/lib/python2.7/site-packages/KratosMultiphysics
	(ln -s $(PWD)/src/kratos/KratosMultiphysics $(SIMPHONYENV)/lib/python2.7/site-packages/KratosMultiphysics)
	cp -rf src/kratos/libs/*Kratos*.so $(SIMPHONYENV)/lib/.
	cp -rf src/kratos/libs/libboost_python.so.1.55.0 $(SIMPHONYENV)/lib/.
	@echo
	@echo "Kratos solver installed"

numerrin:
	rm -Rf src/simphony-numerrin
	git clone --branch $(SIMPHONY_NUMERRIN_VERSION) https://github.com/simphony/simphony-numerrin.git src/simphony-numerrin
	(cp src/simphony-numerrin/numerrin-interface/libnumerrin4.so $(SIMPHONYENV)/lib/.)
	rm -Rf src/simphony-numerrin
	@echo
	@echo "Numerrin installed"
	@echo "(Ensure that environment variable PYNUMERRIN_LICENSE points to license file)"

simphony-common:
	pip install numpy
	pip install "numexpr>=2.0.0"
	C_INCLUDE_PATH=$(MPI_INCLUDE_PATH) pip install tables
	pip install -r requirements.txt
	pip install --upgrade git+https://github.com/simphony/simphony-common.git@$(SIMPHONYVERSION)#egg=simphony
	@echo
	@echo "Simphony library installed"

simphony-aviz:
	pip install --upgrade git+https://github.com/simphony/simphony-aviz.git@$(SIMPHONY_AVIZ_VERSION)
	@echo
	@echo "Simphony AViz plugin installed"

simphony-mayavi:
	pip install --upgrade git+https://github.com/simphony/simphony-mayavi.git@$(SIMPHONY_MAYAVI_VERSION)#egg=simphony_mayavi
	@echo
	@echo "Simphony Mayavi plugin installed"


simphony-paraview:
ifeq ($(USE_OPENFOAM_PARAVIEW),yes)
	echo "LD_LIBRARY_PATH=$(SIMPHONYENV)/lib:/opt/paraviewopenfoam410/lib/paraview-4.1:\$$LD_LIBRARY_PATH\n" >> $(SIMPHONYENV)/bin/activate
	echo "export LD_LIBRARY_PATH" >> $(SIMPHONYENV)/bin/activate
	echo "PYTHONPATH=/opt/paraviewopenfoam410/lib/paraview-4.1/site-packages/:/opt/paraviewopenfoam410/lib/paraview-4.1/site-packages/vtk:\$$PYTHONPATH" >> $(SIMPHONYENV)/bin/activate
	echo "export PYTHONPATH" >> $(SIMPHONYENV)/bin/activate
	@echo
	@echo "Paraview (openfoam) installed"
else
	echo "LD_LIBRARY_PATH=$(SIMPHONYENV)/lib:\$$LD_LIBRARY_PATH" >> $(SIMPHONYENV)/bin/activate
	echo "export LD_LIBRARY_PATH" >> $(SIMPHONYENV)/bin/activate
	@echo
	@echo "Paraview (ubuntu) installed"
endif
	pip install --upgrade git+https://github.com/simphony/simphony-paraview.git@$(SIMPHONY_PARAVIEW_VERSION)#egg=simphony_paraview
	@echo
	@echo "Simphony Paraview plugin installed"

simphony-numerrin:
	pip install --upgrade git+https://github.com/simphony/simphony-numerrin.git@$(SIMPHONY_NUMERRIN_VERSION)
	@echo
	@echo "Simphony Numerrin plugin installed"

simphony-openfoam:
	rm -Rf src/simphony-openfoam
	(mkdir -p src/simphony-openfoam/pyfoam; wget https://openfoamwiki.net/images/3/3b/PyFoam-0.6.4.tar.gz -O src/simphony-openfoam/pyfoam/pyfoam.tgz --no-check-certificate)
	tar -xzf src/simphony-openfoam/pyfoam/pyfoam.tgz -C src/simphony-openfoam/pyfoam
	(pip install --upgrade src/simphony-openfoam/pyfoam/PyFoam-0.6.4; rm -Rf src/simphony-openfoam/pyfoam)
	git clone --branch $(SIMPHONY_OPENFOAM_VERSION) https://github.com/simphony/simphony-openfoam.git src/simphony-openfoam
	# install simphony-openfoam
	(cd src/simphony-openfoam; pip install .)
	# install simphony-openfoam-interface
	(cd src/simphony-openfoam; ./install_foam_interface.sh)
	@echo
	@echo "Simphony OpenFoam plugin installed"

simphony-kratos:
	pip install --upgrade git+https://github.com/simphony/simphony-kratos.git@$(SIMPHONY_KRATOS_VERSION)
	@echo
	@echo "Simphony Kratos plugin installed"

simphony-jyu-lb:
	pip install --upgrade cython
	pip install --upgrade git+https://github.com/simphony/simphony-jyulb.git@$(SIMPHONY_JYU_LB_VERSION)
	@echo
	@echo "Simphony jyu-lb plugin installed"

simphony-lammps:
	pip install --upgrade git+https://github.com/simphony/simphony-lammps-md.git@$(SIMPHONY_LAMMPS_VERSION)#egg=simlammps
	@echo
	@echo "Simphony lammps plugin installed"

simphony-plugins: simphony-kratos simphony-numerrin simphony-mayavi simphony-openfoam simphony-jyu-lb simphony-lammps fix-simopenfoam
	@echo
	@echo "Simphony plugins installed"

simphony-framework:
	@echo
	@echo "Simphony framework installed"

test-plugins: test-simphony test-jyulb test-lammps test-mayavi test-openfoam test-kratos test-aviz
	@echo
	@echo "Tests for simphony plugins done"

test-simphony:
	haas simphony -v
	@echo
	@echo "Tests for simphony library done"

test-aviz:
	haas simphony_aviz -v
	@echo
	@echo "Tests for the aviz plugin done"

test-jyulb:
	haas jyulb -v
	@echo
	@echo "Tests for the jyulb plugin done"

test-lammps:
	haas simlammps -v
	@echo
	@echo "Tests for the lammps plugin done"

test-mayavi:
	pip install mock hypothesis
	haas simphony_mayavi -v
	@echo
	@echo "Tests for the mayavi plugin done"

test-paraview:
	pip install mock hypothesis pillow
	haas simphony_paraview -v
	@echo
	@echo "Tests for the paraview plugin done"

test-openfoam:
	haas foam_controlwrapper foam_internalwrapper -v
	@echo
	@echo "Tests for the openfoam plugin done"

test-kratos:
	haas simkratos -v
	@echo
	@echo "Tests for the kratos plugin done"

ifeq ($(HAVE_NUMERRIN),yes)
	TEST_NUMERRIN_COMMAND=haas numerrin_wrapper -v
else
	TEST_NUMERRIN_COMMAND=@echo "skip NUMERRIN tests"
endif

test-numerrin:
	$(TEST_NUMERRIN_COMMAND)
	@echo
	@echo "Tests for the numerrin plugin done"

test-integration:
	haas tests/ -v
	@echo
	@echo "Integration tests for the simphony framework done"

test-framework: test-plugins test-integration
	@echo
	@echo "Tests for the simphony framework done"
