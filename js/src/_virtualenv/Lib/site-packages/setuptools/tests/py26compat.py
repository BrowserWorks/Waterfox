import sys
import tarfile
import contextlib

def _tarfile_open_ex(*args, **kwargs):
	"""
	Extend result as a context manager.
	"""
	return contextlib.closing(tarfile.open(*args, **kwargs))

tarfile_open = _tarfile_open_ex if sys.version_info < (2,7) else tarfile.open
