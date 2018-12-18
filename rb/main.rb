require_relative './utils'
require_relative './parsers'

def parse_with(parser_name, fpath)
  case parser_name
  when 'brujula'
    brujula_parse(fpath)
  when 'ramlrb'
    ramlrb_parse(fpath)
  end
end

def main
  options = OptParse.parse(ARGV)
  ex_dir = clone_tck_repo
  files_list = list_ramls(ex_dir)

  count = {
    'valid' => { 'passed' => 0, 'total' => 0 },
    'invalid' => { 'passed' => 0, 'total' => 0 }
  }
  error = nil

  files_list.each do |fpath|
    success = true
    print "> Parsing #{fpath}: "

    begin
      parse_with(options.parser, fpath)
    rescue StandardError => e
      success = false
      error = e.message
    end

    shouldf = should_fail?(fpath)
    count_key = shouldf ? 'invalid' : 'valid'
    count[count_key]['total'] += 1
    if shouldf
      success = !success
      error = 'Parsing expected to fail but succeeded'
    end

    if success
      count[count_key]['passed'] += 1
      print 'OK '
    else
      print 'FAIL'
      print ": #{error}" if options.verbose
    end
    puts
  end
  puts("\nPassed/Total: #{count['valid']['passed'] + count['invalid']['passed']}/#{files_list.length}" \
       " (valid: #{count['valid']['passed']}/#{count['valid']['total']}," \
       " invalid: #{count['invalid']['passed']}/#{count['invalid']['total']})")
end

main
