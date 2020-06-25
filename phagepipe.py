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

@cli.command(
    'run',
    context_settings=dict(ignore_unknown_options=True),
    short_help='run main workflow'
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
    default=multiprocessing.cpu_count(),
    type=int,
    show_default=True,
    help='max # of jobs allowed in parallel.',
)


@click.argument(
    'snakemake_args',
    nargs=-1,
    type=click.UNPROCESSED,
)
def run_workflow():
    pass