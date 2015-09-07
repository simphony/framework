# Makefile for Simphony Framework
#

# You can set these variables from the command line.
SIMPHONYENV   ?= ~/simphony
SIMPHONYVERSION  ?= 0.2.0
HAVE_NUMERRIN   ?= no
# Selects which Paraview package is installed (ubuntu, openfoam)
USE_OPENFOAM_PARAVIEW ?= no
# Set this to yes if packages that need HDF5 apt-paraview is used
HDF5_MPI ?= no


ifeq ($(HAVE_NUMERRIN),yes)
	TEST_NUMERRIN_COMMAND=(cd src/simphony-numerrin; haas numerrin_wrapper -v)
else
	TEST_NUMERRIN_COMMAND=@echo "skip NUMERRIN tests"
endif


.PHONY: clean base apt-openfoam apt-simphony apt-lammps apt-mayavi fix-pip simphony-env lammps jyu-lb kratos numerrin simphony simphony-lammps simphony-mayavi simphony-openfoam simphony-kratos simphony-jyu-lb simphony-numerrin test-plugins test-framework test-simphony test-jyulb test-lammps test-mayavi test-openfoam test-kratos test-integration test-paraview simphony-paraview apt-paraview

help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo "  base              to install essential packages (requires sudo)"
	@echo "  apt-openfoam      to install openfoam 2.2.2 (requires sudo)"
	@echo "  apt-simphony      to install building depedencies for the simphony library (requires sudo)"
	@echo "  apt-lammps        to install building depedencies for the lammps solver (requires sudo)"
	@echo "  apt-mayavi        to install building depedencies for the mayavi (requires sudo)"
	@echo "  apt-paraview      to install the paraview package (requires sudo)"
	@echo "  fix-pip           to update the version of pip and virtualevn (requires sudo)"
	@echo "  simphony-env      to create a simphony virtualenv"
	@echo "  kratos            to install the kratos solver"
	@echo "  lammps            to build and install the lammps solver"
	@echo "  numerrin          to install the numerrin solver"
	@echo "  jyu-lb            to build and install the JYU-LB solver"
	@echo "  simphony          to build and install the simphony library"
	@echo "  simphony-kratos   to build and install the simphony-kratos plugin"
	@echo "  simphony-lammps   to build and install the simphony-lammps plugin"
	@echo "  simphony-numerrin to build and install the simphony-numerrin plugin"
	@echo "  simphony-mayavi   to build and install the simphony-mayavi plugin"
	@echo "  simphony-paraview to build and install the simphony-paraview plugin"
	@echo "  simphony-openfoam to build and install the simphony-openfoam plugin"
	@echo "  simphony-jyu-lb   to build and install the simphony-jyu-lb plugin"
	@echo "  simphony-plugins  to build and install all the simphony-plugins"
	@echo "  test-simphony     run the tests for the simphony library"
	@echo "  test-kratos       run the tests for the simphony-kratos plugin"
	@echo "  test-lammps   	   run the tests for the simphony-lammps plugin"
	@echo "  test-numerrin     run the tests for the simphony-numerrin plugin"
	@echo "  test-mayavi       run the tests for the simphony-mayavi plugin"
	@echo "  test-paraview     run the tests for the simphony-paraview plugin"
	@echo "  test-openfoam     run the tests for the simphony-openfoam plugin"
	@echo "  test-jyu-lb       run the tests for the simphony-jyu-lb plugin"
	@echo "  test-plugins      run the tests for all the simphony-plugins"
	@echo "  test-integration  run the integration tests"
	@echo "  test-framework    run the tests for the simphony-framework"
	@echo "  clean             remove any temporary folders"

clean:
	rm -Rf src/kratos
	rm -Rf src/lammps
	rm -Rf src/JYU-LB
	rm -Rf src/simphony-openfoam
	rm -Rf src/simphony-numerrin
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
	(if ! dpkg -l | grep paraview -c >>/dev/null; then sudo apt-get install python-vtk; fi)
	apt-get install python-qt4 python-qt4-dev python-sip python-qt4-gl libqt4-scripttools python-imaging
	@echo
	@echo "Build dependencies for mayavi installed"

apt-paraview:
	apt-get update -qq
ifeq ($(USE_OPENFOAM_PARAVIEW),yes)
	echo deb http://www.openfoam.org/download/ubuntu precise main > /etc/apt/sources.list.d/openfoam.list
	apt-get update -qq
	apt-get install paraviewopenfoam410 libhdf5-openmpi-dev
	@echo
	@echo "Paraview (openfoam) installed"
else
	apt-get install paraview libhdf5-openmpi-dev
	@echo
	@echo "Paraview (ubuntu) installed"
endif

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
ifeq ($(USE_OPENFOAM_PARAVIEW),yes)
	echo "LD_LIBRARY_PATH=$(SIMPHONYENV)/lib:/opt/paraviewopenfoam410/lib/paraview-4.1:$(LD_LIBRARY_PATH)" >> $(SIMPHONYENV)/bin/activate
	echo "export LD_LIBRARY_PATH" >> $(SIMPHONYENV)/bin/activate
	echo "PYTHONPATH=/opt/paraviewopenfoam410/lib/paraview-4.1/site-packages/:/opt/paraviewopenfoam410/lib/paraview-4.1/site-packages/vtk"
	echo "export PYTHON_PATH" >> $(SIMPHONYENV)/bin/activate
else
	echo "LD_LIBRARY_PATH=$(SIMPHONYENV)/lib:$(LD_LIBRARY_PATH)" >> $(SIMPHONYENV)/bin/activate
	echo "export LD_LIBRARY_PATH" >> $(SIMPHONYENV)/bin/activate
endif
	@echo
	@echo "Simphony virtualenv created"

lammps:
	rm -Rf src/lammps
	# bulding and installing executable
	git clone --branch r12824 --depth 1 git://git.lammps.org/lammps-ro.git src/lammps
	$(MAKE) -C src/lammps/src ubuntu_simple -j 3
	cp src/lammps/src/lmp_ubuntu_simple $(SIMPHONYENV)/bin/lammps
	# bulding and installing python module
	$(MAKE) -C src/lammps/src makeshlib -j 3
	$(MAKE) -C src/lammps/src ubuntu_simple -f Makefile.shlib -j 3
	(cd src/lammps/python; python install.py $(SIMPHONYENV)/lib $(SIMPHONYENV)/lib/python2.7/site-packages/)
	rm -Rf src/lammps
	@echo
	@echo "Lammps solver installed"

jyu-lb:
	rm -Rf src/JYU-LB
	git clone --branch 0.1.2 https://github.com/simphony/JYU-LB.git src/JYU-LB
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
	git clone --branch 0.1.0 https://github.com/simphony/simphony-numerrin.git src/simphony-numerrin
	(cp src/simphony-numerrin/numerrin-interface/libnumerrin4.so $(SIMPHONYENV)/lib/.)
	rm -Rf src/simphony-numerrin
	@echo
	@echo "Numerrin installed"
	@echo "(Ensure that environment variable PYNUMERRIN_LICENSE points to license file)"

simphony:
	pip install numpy
	pip install "numexpr>=2.0.0"
	pip install haas
ifeq ($(HDF5_MPI),yes)
	C_INCLUDE_PATH=/usr/lib/openmpi/include pip install tables
else
	pip install tables
endif
	pip install -r requirements.txt
	pip install --upgrade git+https://github.com/simphony/simphony-common.git@$(SIMPHONYVERSION)#egg=simphony
	@echo
	@echo "Simphony library installed"

simphony-mayavi:
	pip install --upgrade git+https://github.com/simphony/simphony-mayavi.git@0.1.1#egg=simphony_mayavi
	@echo
	@echo "Simphony Mayavi plugin installed"

simphony-paraview:
	pip install --upgrade git+https://github.com/simphony/simphony-paraview.git@0.1.1#egg=simphony_paraview
	@echo
	@echo "Simphony Paraview plugin installed"

simphony-numerrin:
	rm -Rf src/simphony-numerrin
	git clone --branch 0.1.0 https://github.com/simphony/simphony-numerrin.git src/simphony-numerrin
	cp src/simphony-numerrin/numerrin-interface/numerrin.so $(SIMPHONYENV)/lib/python2.7/site-packages/
	(cd src/simphony-numerrin; python setup.py install)
	@echo
	@echo "Simphony Numerrin plugin installed"

simphony-openfoam:
	rm -Rf src/simphony-openfoam
	(mkdir -p src/simphony-openfoam/pyfoam; wget https://openfoamwiki.net/images/3/3b/PyFoam-0.6.4.tar.gz -O src/simphony-openfoam/pyfoam/pyfoam.tgz --no-check-certificate)
	tar -xzf src/simphony-openfoam/pyfoam/pyfoam.tgz -C src/simphony-openfoam/pyfoam
	(pip install --upgrade src/simphony-openfoam/pyfoam/PyFoam-0.6.4; rm -Rf src/simphony-openfoam/pyfoam)
	git clone --branch 0.1.3 --depth 1 https://github.com/simphony/simphony-openfoam.git src/simphony-openfoam
	(cd src/simphony-openfoam; python setup.py install)
	@echo
	@echo "Simphony OpenFoam plugin installed"

simphony-kratos:
	pip install --upgrade git+https://github.com/simphony/simphony-kratos.git@0.1.1
	@echo
	@echo "Simphony Kratos plugin installed"

simphony-jyu-lb:
	pip install --upgrade git+https://github.com/simphony/simphony-jyulb.git@0.1.3
	@echo
	@echo "Simphony jyu-lb plugin installed"

simphony-lammps:
	pip install --upgrade git+https://github.com/simphony/simphony-lammps-md.git@0.1.3#egg=simlammps
	@echo
	@echo "Simphony lammps plugin installed"

simphony-plugins: simphony-kratos simphony-numerrin simphony-mayavi simphony-paraview simphony-openfoam simphony-jyu-lb simphony-lammps
	@echo
	@echo "Simphony plugins installed"

simphony-framework:
	@echo
	@echo "Simphony framework installed"

test-plugins: test-simphony test-jyulb test-lammps test-mayavi test-paraview test-openfoam test-kratos
	@echo
	@echo "Tests for simphony plugins done"

test-simphony:
	haas simphony -v
	@echo
	@echo "Tests for simphony library done"

test-jyulb:
	haas jyulb -v
	@echo
	@echo "Tests for the jyulb plugin done"

test-lammps:
	haas simlammps -v
	@echo
	@echo "Tests for the lammps plugin done"

test-mayavi:
	haas simphony_mayavi -v
	@echo
	@echo "Tests for the mayavi plugin done"

test-paraview:
	haas simphony_paraview -v
	@echo
	@echo "Tests for the paraview plugin done"

test-openfoam:
	(cd src/simphony-openfoam; haas foam_controlwrapper foam_internalwrapper -v)
	@echo
	@echo "Tests for the openfoam plugin done"

test-kratos:
	haas simkratos -v
	@echo
	@echo "Tests for the kratos plugin done"

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
