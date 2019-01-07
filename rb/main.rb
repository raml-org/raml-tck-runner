require_relative './utils'
require_relative './parsers'

def parse_with(parser_name, fpath)
  case parser_name
  when 'brujula'
    brujula_parse(fpath)
  when 'raml-rb'
    ramlrb_parse(fpath)
  end
end

def main
  options = OptParse.parse(ARGV)
  ex_dir = clone_tck_repo
  files_list = list_ramls(ex_dir)

  report = {
    'parser' => options.parser,
    'results' => []
  }

  error = nil

  files_list.each do |fpath|
    success = true

    begin
      parse_with(options.parser, fpath)
    rescue StandardError => e
      success = false
      error = "#{e.message}\n#{e.backtrace.join("\n")}"
    end

    relative_fpath = fpath.sub! ex_dir, ''
    result = {
      'file' => relative_fpath,
      'success' => success,
      'error' => error
    }
    report['results'] << result
  end

  save_report(report)
end

main
