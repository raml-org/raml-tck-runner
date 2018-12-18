from . import parsers
from . import utils


PARSERS = {
    'ramlfications': parsers.ramlfications_parser,
    'pyraml': parsers.pyraml_parser,
}

def main():
    args = utils.parse_args()
    parser_func = PARSERS[args.parser]
    ex_dir = utils.clone_tck_repo()
    file_list = utils.list_ramls(ex_dir)

    count = {
        'valid': {'passed': 0, 'total': 0},
        'invalid': {'passed': 0, 'total': 0}
    }

    for fpath in file_list:
        print('> Parsing {}:'.format(fpath), end=' ')
        success = True
        err = None
        try:
            parser_func(fpath)
        except Exception as ex:
            success = False
            err = ex
        should_fail = utils.should_fail(fpath)
        countKey = 'invalid' if should_fail else 'valid'
        count[countKey]['total'] += 1
        if should_fail:
            success = not success
            if err is None:
                err = 'Parsing expected to fail but succeeded'
        if success:
            count[countKey]['passed'] += 1
            print('OK')
        else:
            err = err if args.verbose else ''
            print('FAIL {}'.format(err))
    tmpl = '\nPassed/Total: {}/{} (valid: {}/{}, invalid: {}/{})'
    print(tmpl.format(
        count['valid']['passed'] + count['invalid']['passed'], len(file_list),
        count['valid']['passed'], count['valid']['total'],
        count['invalid']['passed'], count['invalid']['total']))
