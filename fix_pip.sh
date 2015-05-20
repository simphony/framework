#!/bin/bash
set -e

curl https://raw.github.com/pypa/pip/master/contrib/get-pip.py
python get-pip.py
pip --version
pip install --upgrade setuptools
pip install --upgrade virtualenv
