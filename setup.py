import os
from setuptools import setup, find_packages
import pkg_resources

from phagepipe import __version__, _progam

setup(name = "PhagePipe",
      version = __version__,
      packages = find_packages,
      scripts = ["phagepipe/scripts/virfinder.R"],
      description='Automated phage prediction and annotation pipeline',
      url='https://github.com/julianzaugg/PhagePipe',
      author='Julian Zaugg',
      long_description=open('README.txt').read(),
      entry_points={'console_scripts' : ['phagepipe = phagepipe.phagepipe.cli']}
      )
    #   entry_points="""
    #   [console_scripts]
    # {program} = phagepipe.command:main
    # """.format(program = _program),
    # include_package_data=True,
    # keywords=[],
    # zip_safe=False)


# read the contents of your README file
# this_directory = os.path.abspath(os.path.dirname(__file__))
# with open(os.path.join(this_directory, 'README.md')) as f:
#     long_description = f.read()