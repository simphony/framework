# Makefile for Simphony Framework
# You can set these variables from the command line.
SIMPHONYENV   ?= $(HOME)/simphony
# end 

UBUNTU_CODENAME=$(shell lsb_release -cs)

SIMPHONY_COMMON_VERSION ?= 0.6.0
SIMPHONY_JYU_LB_VERSION ?= 
SIMPHONY_LAMMPS_VERSION ?=
SIMPHONY_NUMERRIN_VERSION ?= 
SIMPHONY_OPENFOAM_VERSION ?= 0.3.1
SIMPHONY_KRATOS_VERSION ?= 0.3.1
SIMPHONY_AVIZ_VERSION ?= 0.3.1
SIMPHONY_MAYAVI_VERSION ?= 0.5.2
SIMPHONY_PARAVIEW_VERSION ?= 0.3.1
SIMPHONY_LIGGGHTS_VERSION ?= 0.2.1

ifeq ($(UBUNTU_CODENAME),precise)
OPENFOAM_VERSION=230
else ifeq ($(UBUNTU_CODENAME),trusty)
OPENFOAM_VERSION=231
else
	$(error "Unrecognized ubuntu version $(UBUNTU_CODENAME)")
endif

JYU_LB_VERSION ?= 0.1.2
AVIZ_VERSION ?= v6.5.0
LAMMPS_VERSION ?= r13864

# Path for MPI in HDF5 suport
MPI_INCLUDE_PATH ?= /usr/include/mpi

# Use Paraview OpenFoam? (if no, Paraview from Ubuntu is installed)
USE_OPENFOAM_PARAVIEW ?= no
HAVE_NUMERRIN   ?= no

.PHONY: clean \
		base \
		apt-aviz-deps \
		apt-openfoam-deps \
		apt-simphony-deps \
		apt-lammps-deps \
		apt-mayavi-deps \
		apt-paraview-deps \
		fix-pip \
		simphony-env \
		aviz \
		lammps \
		jyu-lb \
		kratos \
		numerrin \
		simphony \
		simphony-common \
		simphony-aviz \
		simphony-lammps \
		simphony-mayavi \
		simphony-paraview \
		simphony-openfoam \
		simphony-kratos \
		simphony-jyu-lb \
		simphony-numerrin \
		test-plugins \
		test-framework \
		test-simphony \
		test-aviz \
		test-jyulb \
		test-lammps \
		test-mayavi \
		test-paraview \
		test-openfoam \
		test-kratos \
		test-integration

help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo " deps                 to install the dependencies (requires sudo)"
	@echo "  base                 to install essential packages (requires sudo)"
	@echo "  apt-aviz-deps        to install building dependencies for Aviz (requires sudo)"
	@echo "  apt-openfoam-deps    to install openfoam 2.2.2 (requires sudo)"
	@echo "  apt-simphony-deps    to install building depedencies for the simphony library (requires sudo)"
	@echo "  apt-lammps-deps      to install building depedencies for the lammps solver (requires sudo)"
	@echo "  apt-mayavi-deps      to install building depedencies for the mayavi (requires sudo)"
	@echo "  apt-paraview-deps    to install building depedencies for the paraview (requires sudo)"
	@echo "  fix-pip              to update the version of pip and virtual evn (requires sudo)"
	@echo " venv-prepare          to create a simphony virtualenv"
	@echo "  simphony-venv        to install the solvers"
	@echo "  solvers              to install the solvers"
	@echo "   aviz                 to install AViz"
	@echo "   kratos               to install the kratos solver"
	@echo "   lammps               to build and install the lammps solver"
	@echo "   numerrin             to install the numerrin solver"
	@echo "   jyu-lb               to build and install the JYU-LB solver"
	@echo " simphony             to build and install the simphony framework"
	@echo "  simphony-common      to build and install the simphony-common package"
	@echo "  simphony-aviz        to build and install the simphony-aviz plugin"
	@echo "  simphony-kratos      to build and install the simphony-kratos plugin"
	@echo "  simphony-lammps      to build and install the simphony-lammps plugin"
	@echo "  simphony-numerrin    to build and install the simphony-numerrin plugin"
	@echo "  simphony-openfoam    to build and install the simphony-openfoam plugin"
	@echo "  simphony-jyu-lb      to build and install the simphony-jyu-lb plugin"
	@echo " simphony-mayavi      to build and install the simphony-mayavi plugin"
	@echo " simphony-paraview    to build and install the simphony-paraview plugin"
	@echo " test-framework       run the tests for the simphony-framework"
	@echo "  test-plugins         run the tests for all the simphony-plugins"
	@echo "   test-aviz            run the tests for the simphony-aviz plugin"
	@echo "   test-kratos          run the tests for the simphony-kratos plugin"
	@echo "   test-lammps          run the tests for the simphony-lammps plugin"
	@echo "   test-numerrin        run the tests for the simphony-numerrin plugin"
	@echo "   test-mayavi          run the tests for the simphony-mayavi plugin"
	@echo "   test-openfoam        run the tests for the simphony-openfoam plugin"
	@echo "   test-jyu-lb          run the tests for the simphony-jyu-lb plugin"
	@echo "   test-integration     run the integration tests"
	@echo "   test-simphony        run the tests for the simphony library"
	@echo " test-paraview        run the tests for the simphony-paraview plugin"
	@echo " clean                remove any temporary folders"

clean:
	rm -Rf src/aviz
	rm -Rf src/kratos
	rm -Rf src/lammps
	rm -Rf src/JYU-LB
	rm -Rf src/simphony-openfoam
	rm -Rf src/simphony-numerrin
	@echo
	@echo "Removed temporary folders"

deps: base apt-openfoam-deps apt-simphony-deps apt-lammps-deps apt-aviz-deps fix-pip

venv-prepare: simphony-env solvers

solvers: aviz kratos lammps jyu-lb numerrin

simphony: simphony-common simphony-aviz simphony-jyu-lb simphony-lammps simphony-mayavi simphony-openfoam simphony-numerrin simphony-kratos simphony-liggghts
	@echo
	@echo "Simphony plugins installed"

test-plugins: test-simphony test-jyulb test-lammps test-mayavi test-openfoam test-kratos test-aviz
	@echo
	@echo "Tests for simphony plugins done"

test-framework: test-plugins test-integration
	@echo
	@echo "Tests for the simphony framework done"


# ----------------------
# Individual rules

base:
	apt-get install -y --force-yes software-properties-common apt-transport-https python-software-properties
	add-apt-repository ppa:git-core/ppa -y
	apt-get update -qq
	apt-get install -y --force-yes build-essential git subversion

apt-aviz-deps:
	apt-get install -y --force-yes python-qt4 python-qt4-gl qt4-qmake qt4-dev-tools libpng-dev libqt4-dev
	@echo
	@echo "Build dependencies for Aviz"

apt-openfoam-deps:
ifeq ($(UBUNTU_CODENAME),precise)
	echo "deb http://www.openfoam.org/download/ubuntu precise main" > /etc/apt/sources.list.d/openfoam.list
	echo "deb http://dl.openfoam.org/ubuntu precise main" > /etc/apt/sources.list.d/openfoam.list
	add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/ precise multiverse"
else ifeq ($(UBUNTU_CODENAME),trusty)
	add-apt-repository http://www.openfoam.org/download/ubuntu
else
	$(error "Unrecognized ubuntu version $(UBUNTU_CODENAME)")
endif
	apt-get update -qq
ifeq ($(UBUNTU_CODENAME),precise)
	apt-get install -y libcgal8 libcgal-dev
endif
	apt-get install -y --force-yes openfoam$(OPENFOAM_VERSION)
	@echo
	@echo "Openfoam installed use . /opt/openfoam$(OPENFOAM_VERSION)/etc/bashrc to setup the environment"

apt-simphony-deps:
ifeq ($(UBUNTU_CODENAME),precise)
	apt-get install -y --force-yes libhdf5-serial-1.8.4 libhdf5-serial-dev
else ifeq ($(UBUNTU_CODENAME),trusty)
	apt-get install -y --force-yes libhdf5-7 libhdf5-dev
else
	$(error "Unrecognized ubuntu version $(UBUNTU_CODENAME)")
endif
	apt-get install -y --force-yes python-dev libatlas-dev libatlas3gf-base
	@echo
	@echo "Build dependencies for simphony installed"

apt-lammps-deps:
	apt-get install -y --force-yes mpi-default-bin mpi-default-dev
	@echo
	@echo "Build dependencies for lammps installed"

apt-mayavi-deps:
	apt-get install -y --force-yes python-vtk python-qt4 python-qt4-dev python-sip python-qt4-gl libqt4-scripttools python-imaging
	@echo
	@echo "Build dependencies for mayavi installed"

apt-paraview-deps:
ifeq ($(USE_OPENFOAM_PARAVIEW),yes)
	echo deb http://www.openfoam.org/download/ubuntu precise main > /etc/apt/sources.list.d/openfoam.list
	apt-get update -qq
	apt-get install -y --force-yes paraviewopenfoam410 libhdf5-openmpi-1.8.4 libhdf5-openmpi-dev
	@echo
	@echo "Paraview (openfoam) installed"
else
	apt-get install -y --force-yes paraview libhdf5-openmpi-1.8.4 libhdf5-openmpi-dev
	@echo
	@echo "Paraview (ubuntu) installed"
endif

fix-pip:
	wget https://bootstrap.pypa.io/get-pip.py
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
	# Put the site-packages as well. some .so files from liggghts end up there.
	echo "export LD_LIBRARY_PATH=$(SIMPHONYENV)/lib:$(SIMPHONYENV)/lib/python2.7/site-packages/:$(SIMPHONYENV)/lib/kratos/python2.7/site-packages/:\$$LD_LIBRARY_PATH" >> "$(SIMPHONYENV)/bin/activate"
ifeq ($(USE_OPENFOAM_PARAVIEW),yes)
	echo "export LD_LIBRARY_PATH=$(SIMPHONYENV)/lib:/opt/paraviewopenfoam410/lib/paraview-4.1:\$$LD_LIBRARY_PATH\n" >> "$(SIMPHONYENV)/bin/activate"
	echo "export PYTHONPATH=/opt/paraviewopenfoam410/lib/paraview-4.1/site-packages/:/opt/paraviewopenfoam410/lib/paraview-4.1/site-packages/vtk:\$$PYTHONPATH" >> "$(SIMPHONYENV)/bin/activate"
endif
	echo "export PYTHONPATH=$(SIMPHONYENV)/lib/kratos/python2.7/site-packages/:\$$PYTHONPATH" >> "$(SIMPHONYENV)/bin/activate"
	echo ". /opt/openfoam$(OPENFOAM_VERSION)/etc/bashrc" >> "$(SIMPHONYENV)/bin/activate"
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
	rm -rf $(SIMPHONYENV)/lib/kratos/python2.7/site-packages/KratosMultiphysics
	mkdir -p $(SIMPHONYENV)/lib/kratos/python2.7/site-packages/
	cp -rf $(PWD)/src/kratos/KratosMultiphysics $(SIMPHONYENV)/lib/kratos/python2.7/site-packages/KratosMultiphysics
	cp -rf src/kratos/libs/*Kratos*.so $(SIMPHONYENV)/lib/kratos/python2.7/site-packages/.
	cp -rf src/kratos/libs/libboost_python.so.1.55.0 $(SIMPHONYENV)/lib/.
	cp -rf src/kratos/applications $(SIMPHONYENV)/lib/kratos/python2.7/site-packages/.
	cp -rf src/kratos/kratos/python_scripts/* $(SIMPHONYENV)/lib/kratos/python2.7/site-packages/.
	@echo
	@echo "Kratos solver installed"

numerrin:
ifneq ($(SIMPHONY_NUMERRIN_VERSION),)
	rm -Rf src/simphony-numerrin
	git clone --branch $(SIMPHONY_NUMERRIN_VERSION) https://github.com/simphony/simphony-numerrin.git src/simphony-numerrin
	cp src/simphony-numerrin/numerrin-interface/libnumerrin4.so $(SIMPHONYENV)/lib/.
	cp src/simphony-numerrin/numerrin-interface/numerrin.so $(SIMPHONYENV)/lib/python2.7/site-packages/.
	rm -Rf src/simphony-numerrin
	@echo
	@echo "Numerrin installed"
	@echo "(Ensure that environment variable PYNUMERRIN_LICENSE points to license file)"
else
	@echo
	@echo "Skipped Numerrin"
endif

simphony-common:
	C_INCLUDE_PATH=$(MPI_INCLUDE_PATH) pip install -r requirements.txt
	pip install git+https://github.com/simphony/simphony-common.git@$(SIMPHONY_COMMON_VERSION)#egg=simphony
	@echo
	@echo "Simphony library installed"

simphony-aviz:
	pip install git+https://github.com/simphony/simphony-aviz.git@$(SIMPHONY_AVIZ_VERSION)
	@echo
	@echo "Simphony AViz plugin installed"

simphony-mayavi:
	pip install git+https://github.com/simphony/simphony-mayavi.git@$(SIMPHONY_MAYAVI_VERSION)#egg=simphony_mayavi
	@echo
	@echo "Simphony Mayavi plugin installed"


simphony-paraview:
ifeq ($(USE_OPENFOAM_PARAVIEW),yes)
	@echo
	@echo "Paraview (openfoam) installed"
else
	@echo
	@echo "Paraview (ubuntu) installed"
endif
	pip install git+https://github.com/simphony/simphony-paraview.git@$(SIMPHONY_PARAVIEW_VERSION)#egg=simphony_paraview
	@echo
	@echo "Simphony Paraview plugin installed"

simphony-numerrin:
ifneq ($(SIMPHONY_NUMERRIN_VERSION),)
	pip install git+https://github.com/simphony/simphony-numerrin.git@$(SIMPHONY_NUMERRIN_VERSION)
	@echo
	@echo "simphony numerrin plugin installed"
else
	@echo
	@echo "Skipping simphony numerrin plugin"
endif

simphony-openfoam:
	rm -Rf src/simphony-openfoam
	(mkdir -p src/simphony-openfoam/pyfoam; wget https://openfoamwiki.net/images/3/3b/PyFoam-0.6.4.tar.gz -O src/simphony-openfoam/pyfoam/pyfoam.tgz --no-check-certificate)
	tar -xzf src/simphony-openfoam/pyfoam/pyfoam.tgz -C src/simphony-openfoam/pyfoam
	(pip install src/simphony-openfoam/pyfoam/PyFoam-0.6.4; rm -Rf src/simphony-openfoam/pyfoam)
	#pip install git+https://github.com/simphony/simphony-openfoam.git@$(SIMPHONY_OPENFOAM_VERSION)
	git clone --branch $(SIMPHONY_OPENFOAM_VERSION) https://github.com/simphony/simphony-openfoam.git
	cd simphony-openfoam && python setup.py install
	
	@echo
	@echo "Simphony OpenFoam plugin installed"

simphony-kratos:
	pip install git+https://github.com/simphony/simphony-kratos.git@$(SIMPHONY_KRATOS_VERSION)
	@echo
	@echo "Simphony Kratos plugin installed"

simphony-jyu-lb:
ifneq ($(SIMPHONY_JYU_LB_VERSION),)
	pip install git+https://github.com/simphony/simphony-jyulb.git@$(SIMPHONY_JYU_LB_VERSION)
	@echo
	@echo "Simphony jyu-lb plugin installed"
else
	@echo
	@echo "Skipping Simphony jyu-lb plugin"
endif

simphony-lammps:
ifneq ($(SIMPHONY_LAMMPS_VERSION),)
	pip install git+https://github.com/simphony/simphony-lammps-md.git@$(SIMPHONY_LAMMPS_VERSION)#egg=simlammps
	@echo
	@echo "Simphony lammps plugin installed"
else
	@echo
	@echo "Skipping Simphony jyu-lb plugin"
endif

simphony-liggghts:
	git clone https://github.com/simphony/simphony-liggghts.git
	
	cd simphony-liggghts && git checkout $(SIMPHONY_LIGGGHTS_VERSION) && PREFIX=$(SIMPHONYENV) ./install_external.sh && python setup.py install

test-simphony:
	haas simphony -v
	@echo
	@echo "Tests for simphony library done"

test-aviz:
	haas simphony_aviz -v
	@echo
	@echo "Tests for the aviz plugin done"

test-jyulb:
ifneq ($(SIMPHONY_JYU_LB_VERSION),)
	haas jyulb -v
	@echo
	@echo "Tests for the jyulb plugin done"
else
	@echo
	@echo "Skipping tests for the jyulb plugin"
endif

test-lammps:
ifneq ($(SIMPHONY_LAMMPS_VERSION),)
	haas simlammps -v
	@echo
	@echo "Tests for the lammps plugin done"
else
	@echo
	@echo "Skipping tests for lammps plugin"
endif

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

test-numerrin:
ifeq ($(HAVE_NUMERRIN),yes)
	TEST_NUMERRIN_COMMAND=haas numerrin_wrapper -v
else
	TEST_NUMERRIN_COMMAND=@echo "skip NUMERRIN tests"
endif
	@echo
	@echo "Tests for the numerrin plugin done"

test-integration:
	haas tests/ -v
	@echo
	@echo "Integration tests for the simphony framework done"
