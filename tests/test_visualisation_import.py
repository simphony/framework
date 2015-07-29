import unittest
from stevedore.extension import ExtensionManager

PLUGINS = [
    'mayavi_tools']


class TestVisualisationPluginImport(unittest.TestCase):

    def test_plugin_import(self):
        extension_manager = ExtensionManager(namespace='simphony.visualisation')
        for engine in PLUGINS:
            if engine not in extension_manager:
                self.fail("`{}` could not be imported".format(engine))
