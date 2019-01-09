const parseArgs = require('minimist')
const parsers = require('./parsers')
const utils = require('./utils')

const PARSERS = {
  'raml-1-parser': parsers.raml1parserParse,
  'amf-client-js': parsers.amfParse,
  'webapi-parser': parsers.webapiParserParse
}

async function main () {
  const argv = parseArgs(process.argv.slice(2))
  const parserFunc = PARSERS[argv.parser]
  if (parserFunc === undefined) {
    console.log(`Not supported parser: ${argv.parser}`)
    return
  }

  const exDir = utils.cloneTckRepo()
  const fileList = utils.listRamls(exDir)
  let report = {
    parser: argv.parser,
    results: []
  }

  for (let i = 0; i < fileList.length; i++) {
    let fpath = fileList[i]
    let success = true
    let error
    try {
      await parserFunc(fpath)
    } catch (e) {
      success = false
      error = e
    }
    report.results.push({
      file: fpath.replace(exDir, ''),
      success: success,
      error: error ? error.message : error
    })
  }

  utils.saveReport(report, argv.outdir || './')
}

main()
