# This Dockerfile creates a complete SimPhoNy environment.

# The base image
FROM ubuntu:12.04

MAINTAINER SimPhoNy Team

# Make assume-yes permanent. Having this, there is no need to change scripts.
# Update the os and install dev requirements afterwards
RUN echo 'APT::Get::Assume-Yes "true";' > /etc/apt/apt.conf.d/90forceyes && \
  apt-get update && apt-get install --yes \
    build-essential \
    git \
    python-software-properties \
    wget \
# Clone simphony-frameowork and start building
&& git clone https://github.com/simphony/simphony-framework.git

WORKDIR /simphony-framework

RUN make base 		\
  apt-openfoam-deps 	\
  apt-simphony-deps 	\
  apt-lammps-deps 	\
  apt-mayavi-deps 	\
  apt-aviz-deps 	\
# Load openfoam environment at startup
&& echo '. /opt/openfoam222/etc/bashrc' >> ~/.bashrc

# Intall latest version of pip and virtualenv and solvers
RUN make	\
  fix-pip 	\
  simphony-env 	\
  lammps 	\
  jyu-lb 	\
  kratos 	\
  numerrin 	\
  aviz

# Install simphony
RUN make 	\
  simphony 	\
  simphony-plugins
