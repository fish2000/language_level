
from __future__ import print_function

import os
import os.path
import psutil
from setuptools import setup, find_packages # import before Cython stuff, to avoid
                                            # overriding Cython’s Extension class.
from distutils.sysconfig import get_python_inc
from Cython.Distutils import Extension
from Cython.Build import cythonize

try:
    import numpy
except ImportError:
    class FakeNumpy(object):
        def get_include(self):
            return os.path.curdir
    numpy = FakeNumpy()
    print("NUMPY NOT FOUND (using shim)")
else:
    print(f"import: module {numpy.__name__} found")

# VERSION & METADATA
__version__ = "<undefined>"
exec(compile(
    open(os.path.join(
        os.path.dirname(__file__),
        '__version__.py')).read(),
        '__version__.py', 'exec'))

long_description = """ Test for cinclude bug with language_level=3 """

classifiers = [
    'Development Status :: 4 - Beta',
    'Intended Audience :: Developers',
    'Intended Audience :: Science/Research',
    'Topic :: Multimedia',
    'Topic :: Scientific/Engineering :: Image Recognition',
    'Topic :: Software Development :: Libraries',
    'Programming Language :: Python',
    'Programming Language :: Python :: 3',
    'Programming Language :: C++',
    'License :: OSI Approved :: MIT License']

mypackage_extension_sources = [os.path.join('mypackage', 'mycymod.pyx')]
mypackage_base_path = os.path.abspath(os.path.dirname(
                                      os.path.join('mypackage', 'ext')))

include_dirs = [
    get_python_inc(plat_specific=1),
    numpy.get_include(),
    mypackage_base_path,
    os.path.join(mypackage_base_path, 'ext'),
    os.path.curdir]

define_macros = []
define_macros.append(
    ('VERSION', __version__))
define_macros.append(
    ('NPY_NO_DEPRECATED_API', 'NPY_1_7_API_VERSION'))
define_macros.append(
    ('PY_ARRAY_UNIQUE_SYMBOL', 'YO_DOGG_I_HEARD_YOU_LIKE_UNIQUE_SYMBOLS'))


setup(name='language-level',
    version=__version__,
    description=long_description,
    long_description=long_description,
    author='Alexander Bohn',
    author_email='fish2000@gmail.com',
    license='MIT',
    platforms=['Any'],
    classifiers=classifiers,
    url='http://github.com/fish2000/language-level',
    packages=find_packages(),
    package_dir={
        'mypackage'   : 'mypackage'
    },
    package_data=dict(),
    test_suite='nose.collector',
    ext_modules=cythonize([
        Extension('mypackage.mycymod',
            mypackage_extension_sources,
            language="c++",
            include_dirs=include_dirs,
            define_macros=define_macros,
            extra_link_args=[
                '-lHalide'],
            extra_compile_args=[
                '-Wno-unused-function',
                '-Wno-unneeded-internal-declaration',
                '-O3',
                '-fstrict-aliasing',
                '-funroll-loops',
                '-mtune=native',
                '-std=c++17',
                '-stdlib=libc++']
        )],
        nthreads=psutil.cpu_count(),
        language="c++",
        compiler_directives=dict(language_level=3,
                                 infer_types=True,
                                 embedsignature=True)
    )
)
