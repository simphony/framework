SimPhoNy Framework
==================

The SimPhoNy Framework is a meta-package to simplify integration and testing
of the SimPhoNy simulation tools. The framework is build around the simphony
library and the SimPhoNy plugins.


.. image:: https://travis-ci.org/simphony/simphony-framework.svg?branch=master
    :target: https://travis-ci.org/simphony/simphony-framework

Packages
--------

The simphony-common version that is supported in version 0.2.2 of the framework is:

- https://github.com/simphony/simphony-common/releases/tag/0.2.2, version 0.2.2

The SimPhoNy plugins that are compatible with this release:
are:

- https://github.com/simphony/simphony-jyulb/releases/tag/0.2.0, version 0.2.0
- https://github.com/simphony/simphony-lammps-md/releases/tag/0.1.5, version 0.1.5
- https://github.com/simphony/simphony-openfoam/releases/tag/0.1.5, version 0.1.5
- https://github.com/simphony/simphony-numerrin/releases/tag/0.1.1, version 0.1.1
- https://github.com/simphony/simphony-kratos, commit afb3c50a630bb0d3d81f864ed4baa38093797940
- https://github.com/simphony/simphony-mayavi/releases/tag/0.3.1, version 0.3.1
- https://github.com/simphony/simphony-aviz/releases/tag/0.1.0, version 0.1.0
  
Summary of releases
-------------------

=====================  =======  ========  =======
 Repository                Version
---------------------  --------------------------
 simphony-framework     0.1.3    0.2.0     0.2.2
=====================  =======  ========  =======
 simphony-common        0.1.3    0.2.0     0.2.2
 simphony-jyulb         0.1.3     n/a      0.2.0
 simphony-kratos        0.1.1    master    master
 simphony-lammps-md     0.1.3    0.1.5     0.1.5
 simphony-openfoam      0.1.3    0.1.5     0.1.5
 simphony-numerrin      0.1.0    0.1.1*    0.1.1*
 simphony-mayavi        0.1.1     n/a      0.3.1
 simphony-aviz           n/a     master    0.1.0
=====================  =======  ========  =======

*test pending

Repository
----------

The repository is hosted in github::

  https://github.com/simphony/simphony-framework

License
-------

The SimPhoNy Framework repository code and scripts are governed by the BSD license
(see LICENSE.txt). The various dependencies, however, have their own licensing
condition please make sure that you agree and comply with the license of the
components that will be installed.


Installation
------------


Checkout the simphony-framework repo::

  git clone https://github.com/simphony/simphony-framework.git
  cd simphony-framework

.. note::

  The SymPhoNy framework is developed and tested on Ubuntu 12.04 LTS
  and the following commands and included scripts assume that they
  are executed inside the top level directory of the simphony-framework
  cloned repository.


Makefile
~~~~~~~~

To build and install the various parts of simphony framework a Makefile is provided.
Running ``make help`` list all the available targets.


Installing build dependencies
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

All these targets make sure that the necessary libraries are installed by the
various apt repositories, and require ``sudo`` access::

  sudo make base
  sudo make apt-openfoam
  sudo make apt-simphony
  sudo make apt-lammps
  sudo make apt-mayavi
  sudo make apt-aviz

.. note::

   The ``apt-openfoam`` target will install openfoam version 2.2.2. To use this solver
   please activate the related environment::

     source /opt/openfoam222/etc/bashrc



Fix python setup tools
~~~~~~~~~~~~~~~~~~~~~~

In order to properly support installing the various python packages we need to use
the latest version of pip, setuptools and virtualenv. This target will make sure
that these packages are upgraded in you system::

  sudo make fix-pip


Setup virtual environment
~~~~~~~~~~~~~~~~~~~~~~~~~

It is advised that the simphony framework is installed in a python
virtual environment to avoid contaminating the system python
with the simphony packages and allow a simpler user installation::

  make simphony-env

which will create a virtual enviroment in ``~/simphony`` or::


  SIMPHONYENV=<path> make simphony-env


.. note::

   From this point the simphony enviroment needs to be active::

     source ~/simphony/bin/activate


Install solvers
~~~~~~~~~~~~~~~

Some solvers are not available as deb packages and need to be build locally.
To build them there are separate targets::

  make -j 2 lammps
  make -j 2 jyu-lb
  make kratos
  make numerrin
  make aviz

.. note::

   The ``numerrin`` target will install the numerrin library. To use this solver, please
   ensure that environment variable PYNUMERRIN_LICENSE points to a valid Numerrin
   license file.


Install Simphony
~~~~~~~~~~~~~~~~

::

  make simphony
  make simphony-plugins

.. note::

   individual simphony plugins can be installed using the related targets.


Complete script
~~~~~~~~~~~~~~~

::

  sudo make base apt-openfoam apt-simphony apt-lammps apt-mayavi apt-aviz fix-pip
  source /opt/openfoam222/etc/bashrc
  make simphony-env
  source ~/simphony/bin/activate
  make -j 2 kratos lammps jyu-lb numerrin aviz
  make simphony
  make simphony-plugins


Test
----

::

   make test-framework

.. note::

   The testing of simphony-numerrin is only performed if the environement variable
   HAVE_NUMERRIN is set to yes (i.e. ''HAVE_NUMERRIN=yes make test-framework'')
