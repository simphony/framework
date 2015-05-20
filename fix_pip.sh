#!/bin/bash
set -e

wget https://raw.github.com/pypa/pip/master/contrib/get-pip.py
python get-pip.py
rm get-pip.py
pip --version
pip install --upgrade setuptools
pip install --upgrade virtualenv
