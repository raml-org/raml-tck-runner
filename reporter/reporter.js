const path = require('path')
const fs = require('fs')

function main () {
  const reportsDir = path.join(__dirname, '..', 'reports')
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

function interpretReport (report) {
  const branch = 'rename-cleanup'
  const repo = `https://github.com/raml-org/raml-tck/tree/${branch}`
  report.results.forEach(result => {
    if (shouldFail(result.file)) {
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

function composeReportStats (report) {
  // compose short report for stats page
  // return {parser: name, stats: {}}
}

function generateReportPage (report) {
  // should generate page for each parser
}

function generateStatsPage (stats) {
  // should generate main page html
}

function shouldFail (fpath) {
  return fpath.toLowerCase().includes('invalid')
}

main()
