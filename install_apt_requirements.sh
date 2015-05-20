#!/bin/bash
set -e
add-apt-repository ppa:cython-dev/master-ppa -y
echo deb http://www.openfoam.org/download/ubuntu precise main > /etc/apt/sources.list.d/openfoam.list
apt-get update -qq
apt-get install -y build-essential git subversion libhdf5-serial-dev mpi-default-bin mpi-default-dev python-dev cython python-vtk python-qt4 python-qt4-dev python-sip python-qt4-gl libqt4-scripttools libatlas-dev libatlas3gf-base python-imaging
apt-get install -y --force-yes openfoam222
