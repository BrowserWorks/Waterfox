# -*- coding: utf-8 -*-
import sys
from setuptools import setup
from setuptools.command.test import test as TestCommand

class PyTest(TestCommand):
    def finalize_options(self):
        TestCommand.finalize_options(self)
        self.test_args = []
        self.test_suite = True

    def run_tests(self):
        import pytest
        errno = pytest.main(self.test_args)
        sys.exit(errno)

requires = [ 'mac_alias >= 2.0.1' ]

# On Python <3.4, we need biplist
if sys.version_info < (3, 4):
    requires.append('biplist >= 0.6')

with open('README.rst', 'rb') as f:
    longdesc = f.read().decode('utf-8')

setup(name='ds_store',
      version='1.3.0',
      description='Manipulate Finder .DS_Store files from Python',
      long_description=longdesc,
      author='Alastair Houghton',
      author_email='alastair@alastairs-place.net',
      url='http://alastairs-place.net/projects/ds_store',
      license='MIT License',
      platforms='Any',
      packages=['ds_store'],
      classifiers=[
          'Development Status :: 5 - Production/Stable',
          'License :: OSI Approved :: MIT License',
          'Topic :: Desktop Environment',
          'Topic :: Software Development :: Libraries :: Python Modules'],
      install_requires=requires,
      tests_require=['pytest'],
      scripts=['scripts/ds_store'],
      cmdclass={
          'test': PyTest
          },
      provides=[
          'ds_store'
          ])
