import unittest
import os

from stevedore.extension import ExtensionManager

ENGINES = [
    'lammps',
    'openfoam_file_io',
    'openfoam_internal',
    'kratos',
    'jyulb_fileio_isothermal',
    'jyulb_internal_isothermal']

if os.getenv("HAVE_NUMERRIN", "no") == "yes":
    ENGINES.append("numerrin")


class TestEngineImport(unittest.TestCase):

    def test_engine_import(self):
        extension_manager = ExtensionManager(namespace='simphony.engine')
        for engine in ENGINES:
            if engine not in extension_manager:
                self.fail("`{}` could not be imported".format(engine))
