import argparse
import tempfile
import shutil
import os
import json

from git import Repo


# Parser command line arguments
def parse_args():
    arg_parser = argparse.ArgumentParser(
        description='Test few RAML Python parsers.')
    arg_parser.add_argument(
        '--parser', type=str, help='Parser to test',
        choices=[
            'ramlfications',
            'pyraml-parser',
        ],
        required=True)
    arg_parser.add_argument(
        '--outdir', type=str, help='Output directory',
        default='./',
        required=False)
    arg_parser.add_argument(
        '--branch', type=str,
        help='raml-tck branch to load RAML files from',
        required=True)
    return arg_parser.parse_args()


# Clones raml-tck repo
def clone_tck_repo(branch):
    repo_dir = os.path.join(tempfile.gettempdir(), 'raml-tck')
    if os.path.exists(repo_dir):
        print('Removing existing raml-tck repo directory')
        shutil.rmtree(repo_dir)
    os.mkdir(repo_dir)
    print('Cloning raml-tck repo to {}'.format(repo_dir))
    repo = Repo.init(repo_dir)
    origin = repo.create_remote(
        'origin', 'git@github.com:raml-org/raml-tck.git')
    origin.fetch(
        'refs/heads/{}:refs/heads/origin'.format(branch))
    origin.pull(origin.refs[0].remote_head)
    return repo_dir


# Lists RAML files in a folder
def list_ramls(ex_dir):
    manifest_path = os.path.join(ex_dir, 'manifest.json')
    with open(manifest_path) as f:
        manifest = json.load(f)
    return [os.path.join(ex_dir, fp) for fp in manifest['filePaths']]


# Saves report to json file in output folder
def save_report(report, outdir):
    outdir = os.path.abspath(outdir)
    if not os.path.exists(outdir):
        os.makedirs(outdir)
    report_fpath = os.path.join(
        outdir, '{}.json'.format(report['parser']['name']))
    with open(report_fpath, 'w') as f:
        json.dump(report, f, indent=2)
