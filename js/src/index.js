const parseArgs = require('minimist')
const parsers = require('./parsers')
const utils = require('./utils')

const PARSERS = {
  'raml1parser': parsers.raml1parserParse,
  'amf': parsers.amfParse,
  'webapi': parsers.webapiParserParse
}

async function main () {
  const argv = parseArgs(process.argv.slice(2))
  const verbose = argv.verbose || false
  const parserFunc = PARSERS[argv.parser]
  if (parserFunc === undefined) {
    console.log(`Not supported parser: ${argv.parser}`)
    return
  }

  const exDir = utils.cloneTckRepo()
  const fileList = utils.listRamls(exDir)
  let count = {
    valid: {passed: 0, total: 0},
    invalid: {passed: 0, total: 0}
  }

  for (let i = 0; i < fileList.length; i++) {
    let fpath = fileList[i]
    let success = true
    let error
    // Log like this to not add newline at the end
    process.stdout.write(`> Parsing ${fpath}: `)
    try {
      await parserFunc(fpath)
    } catch (e) {
      success = false
      error = e
    }
    const shouldFail = utils.shouldFail(fpath)
    let countKey = shouldFail ? 'invalid' : 'valid'
    count[countKey].total++
    if (shouldFail) {
      success = !success
      error = 'Parsing expected to fail but succeeded'
    }
    if (success) {
      count[countKey].passed++
      console.log('OK')
    } else {
      console.log('FAIL')
      if (verbose) {
        console.log(error)
      }
    }
  }
  console.log(
    `\nPassed/Total: ${count.invalid.passed + count.valid.passed}/${fileList.length} ` +
    `(valid: ${count.valid.passed}/${count.valid.total}, ` +
    `invalid: ${count.invalid.passed}/${count.invalid.total})`)
}

main()
