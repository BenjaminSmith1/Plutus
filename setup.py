from distutils.core import setup
from Cython.Build import cythonize

setup(
  name = 'Plutus',
  ext_modules = cythonize(["*.pyx"]),
)