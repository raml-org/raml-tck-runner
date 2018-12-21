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
    return arg_parser.parse_args()


# Clones raml-tck repo
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


# Lists RAML files in a folder
def list_ramls(ex_dir):
    manifest_path = os.path.join(ex_dir, 'manifest.json')
    with open(manifest_path) as f:
        manifest = json.load(f)
    return [os.path.join(ex_dir, fp) for fp in manifest['filePaths']]


# Saves report to json file in reports/json folder
def save_report(report):
    file_dir = os.path.dirname(os.path.realpath(__file__))
    reports_dir = os.path.join(file_dir, '..', '..', 'reports', 'json')
    if not os.path.exists(reports_dir):
        os.makedirs(reports_dir)
    report_fpath = os.path.join(
        reports_dir, '{}.json'.format(report['parser']))
    with open(report_fpath, 'w') as f:
        json.dump(report, f, indent=2)
