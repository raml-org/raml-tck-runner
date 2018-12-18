import argparse
import tempfile
import shutil
import os
import json

from git import Repo


def parse_args():
    arg_parser = argparse.ArgumentParser(
        description='Test few RAML Python parsers.')
    arg_parser.add_argument(
        '--parser', type=str, help='Parser to test',
        choices=['ramlfications', 'pyraml'],
        required=True)
    arg_parser.add_argument(
        '--verbose', help='Print errors or not',
        action='store_true')
    return arg_parser.parse_args()


def clone_tck_repo():
    repo_dir = os.path.join(tempfile.gettempdir(), 'raml-tck')
    if os.path.exists(repo_dir):
        print('Removing existing raml-tck repo directory')
        shutil.rmtree(repo_dir)
    os.mkdir(repo_dir)
    print('Cloning raml-tck repo to {}'.format(repo_dir))
    repo = Repo.init(repo_dir)
    origin = repo.create_remote(
        'origin', 'git@github.com:raml-org/raml-tck.git')
    origin.fetch('refs/heads/rename-cleanup:refs/heads/origin')
    origin.pull(origin.refs[0].remote_head)
    return os.path.join(repo_dir, 'tests', 'raml-1.0')
    # return '/home/post/projects/raml-tck/tests/raml-1.0/'  # DEBUG

def list_ramls(ex_dir):
    manifest_path = os.path.join(ex_dir, 'manifest.json')
    with open(manifest_path) as f:
        manifest = json.load(f)
    return [os.path.join(ex_dir, fp) for fp in manifest['filePaths']]


def should_fail(fpath):
    return 'invalid' in fpath.lower()
