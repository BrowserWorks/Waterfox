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

with open('README.rst', 'rb') as f:
    longdesc = f.read().decode('utf-8')

setup(name='mac_alias',
      version='2.2.0',
      description='Generate/parse Mac OS Alias records from Python',
      long_description=longdesc,
      author='Alastair Houghton',
      author_email='alastair@alastairs-place.net',
      url='http://alastairs-place.net/projects/mac_alias',
      license='MIT License',
      platforms='darwin',
      packages=['mac_alias'],
      classifiers=[
          'Development Status :: 5 - Production/Stable',
          'License :: OSI Approved :: MIT License',
          'Topic :: Desktop Environment',
          'Topic :: Software Development :: Libraries :: Python Modules'],
      tests_require=['pytest'],
      cmdclass={
          'test': PyTest
          },
      provides=['mac_alias'])
