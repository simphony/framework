import unittest
import importlib
import os

ENGINES = [
    'lammps',
    'openfoam',
    'jyulb']

if os.getenv("HAVE_NUMERRIN", "no") == "yes":
    ENGINES.append("numerrin")


class TestEngineImport(unittest.TestCase):

    def test_engine_import(self):
        for engine in ENGINES:
    	    print engine 
            importlib.import_module('simphony.engine', engine)
