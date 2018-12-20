const path = require('path')
const fs = require('fs')

function main () {
  const reportsDir = path.join(__dirname, '..', '..', 'reports')
  let stats = []
  let report
  fs.readdirSync(reportsDir).forEach(fpath => {
    report = JSON.parse(fs.readFileSync(fpath))
    interpretReport(report)
    stats.push(composeReportStats(report))
    generateReportPage(report)
  })
  generateStatsPage(stats)
}

/*
  * Inverts invalid files parsing results;
  * Composes repo url from relative file path;
*/
function interpretReport (report) {
  const branch = 'rename-cleanup'
  const repo = `https://github.com/raml-org/raml-tck/tree/${branch}`
  report.results.forEach(result => {
    result.invalid = shouldFail(result.file)
    if (result.invalid) {
      delete result.error
      result.success = !result.success
      if (!result.success) {
        result.error = 'Parsing expected to fail but succeeded'
      }
    }
    result.file = result.file.startsWith('/')
      ? result.file.slice(1)
      : result.file
    result.file = `${repo}/tests/raml-1.0/${fpath}`
  })
}

/*
  Composes single parser report stats:
    number of successfully parsed and total number of invalid, valid
    and all files.
*/
function composeReportStats (report) {
  let stats = {
    parser: report.parser,
    valid: {success: 0, total: 0},
    invalid: {success: 0, total: 0},
    all: {success: 0, total: report.results.length}
  }
  const invalid = report.results.filter(r => { return r.invalid })
  const invalidSuccess = invalid.filter(r => { return r.success })
  stats.invalid.total = invalid.length
  stats.invalid.success = invalidSuccess.length

  const valid = report.results.filter(r => { return !r.invalid })
  const validSuccess = valid.filter(r => { return r.success })
  stats.valid.total = valid.length
  stats.valid.success = validSuccess.length

  stats.all.success = invalidSuccess.length + validSuccess.length

  return stats
}

/* Generate report page for single parser */
function generateReportPage (report) {

}

function generateStatsPage (stats) {
  // should generate main page html
}

function shouldFail (fpath) {
  return fpath.toLowerCase().includes('invalid')
}

main()
