import traceback

from . import parsers
from . import utils


PARSERS = {
    'ramlfications': parsers.ramlfications_parser,
    'pyraml-parser': parsers.pyraml_parser,
}


def main():
    args = utils.parse_args()
    parser_func = PARSERS[args.parser]
    branch = 'rename-cleanup'
    ex_dir = utils.clone_tck_repo(branch)
    file_list = utils.list_ramls(ex_dir)

    report = {
        'parser': args.parser,
        'results': [],
        'branch': branch,
    }

    for fpath in file_list:
        success = True
        err = None
        try:
            parser_func(fpath)
        except Exception:
            success = False
            err = traceback.format_exc()

        report['results'].append({
            'file': fpath.replace(ex_dir, ''),
            'success': success,
            'error': err
        })

    utils.save_report(report, args.outdir)
