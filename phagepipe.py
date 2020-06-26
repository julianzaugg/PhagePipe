import sys
import os
import logging
import subprocess
import glob
import shutil
import multiprocessing
import click


@click.group(context_settings=dict(help_option_names=["-h", "--help"]))
# @click.version_option(__version__)
# @click.pass_context
def cli(obj):
    """
    PhagePipe
    """

def get_snakefile(f="Snakefile"):
    sf = os.path.join(os.path.dirname(os.path.abspath(__file__)), f)
    if not os.path.exists(sf):
        sys.exit("Unable to locate the Snakemake workflow file; tried %s" % sf)
    return sf


@cli.command(
    'run',
    context_settings=dict(ignore_unknown_options=True),
    short_help='run'
)
@click.option('-w',
    '--working-dir',
    type=click.Path(dir_okay=True,writable=True,resolve_path=True),
    help='Output directory',
    default='.'
)
@click.option('-i',
    '--fasta',
    required=True,
    type=click.Path(resolve_path=True),
    help='Input fasta file'
)

@click.option(
    '--min-length',
    default=0,
    type=int,
    show_default=True,
    help='Minimum sequence length required; all sequences shorter than this will be removed.'
)
@click.option(
    '-t',
    '--threads',
    default= 1, #multiprocessing.cpu_count(),
    type=int,
    show_default=True,
    help='Max number of threads.',
)

@click.argument(
    'snakemake_args',
    nargs=-1,
    type=click.UNPROCESSED,
)
def run_workflow():
    pass