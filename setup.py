import os
import sys
import warnings

try:
    from distribute_setup import use_setuptools
    use_setuptools()
except:
    warnings.warn(
    "Failed to import distribute_setup, continuing without distribute.", 
    Warning)

from setuptools import setup, find_packages

version = '0.0.3dev'

setup(name='topojson',
      version=version,
      description="Convert TopoJSON mesh objects to GeoJSON geometries",
      long_description="",
      classifiers=[
        'Development Status :: 2 - Pre-Alpha',
        'Intended Audience :: Developers',
        'Intended Audience :: Science/Research',
        'License :: OSI Approved :: BSD License',
        'Operating System :: OS Independent',
        'Programming Language :: Python',
        'Topic :: Scientific/Engineering :: GIS'
      ],
      keywords='gis geojson geometry topojson',
      author='Sean Gillies',
      author_email='sean.gillies@gmail.com',
      url='https://github.com/sgillies/topojson',
      license='BSD',
      py_modules=['topojson'],
      include_package_data=True,
      zip_safe=False,
      )
