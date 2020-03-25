import traceback

from . import parsers
from . import utils


PARSERS = {
    'ramlfications': parsers.ramlfications_parser,
    'pyraml-parser': parsers.pyraml_parser,
}

PARSERS_META = {
    'ramlfications': {
        'url': 'https://github.com/spotify/ramlfications',
        'version': '0.1.9',
    },
    'pyraml-parser': {
        'url': 'https://github.com/an2deg/pyraml-parser',
        'version': '0.1.9',
    },
}


def main():
    args = utils.parse_args()
    parser_func = PARSERS[args.parser]
    ex_dir = utils.clone_tck_repo(args.branch)
    file_list = utils.list_ramls(ex_dir)
    parser_meta = PARSERS_META[args.parser].copy()
    parser_meta.update({
        'language': 'py',
        'name': args.parser,
    })
    report = {
        'parser': parser_meta,
        'results': [],
        'branch': args.branch,
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
