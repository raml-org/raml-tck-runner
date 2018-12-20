const path = require('path')
const fs = require('fs')
const Mustache = require('mustache')

function main () {
  const reportsDir = path.join(__dirname, '..', '..', 'reports', 'json')
  let stats = []
  fs.readdirSync(reportsDir).forEach(fpath => {
    if (!fpath.endsWith('.json')) {
      return
    }
    let fullPath = path.join(reportsDir, fpath)
    console.log(`Processing report: ${fullPath}`)
    let report = JSON.parse(fs.readFileSync(fullPath))
    interpretReport(report)
    stats.push(composeReportStats(report))
    renderTemplate(report, 'report', report.parser)
  })
  renderTemplate({stats: stats}, 'index', 'index')
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
    result.fileUrl = `${repo}/tests/raml-1.0/${result.file}`
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

function renderTemplate (data, tmplName, htmlName) {
  const inPath = path.join(
    __dirname, '..', 'templates', `${tmplName}.mustache`)
  const tmplStr = fs.readFileSync(inPath, 'utf-8')
  const htmlStr = Mustache.render(tmplStr, data)
  const outDir = path.join(__dirname, '..', '..', 'reports', 'html')
  const outPath = path.join(outDir, `${htmlName}.html`)
  fs.writeFileSync(outPath, htmlStr)
  console.log(`Rendered HTML: ${outPath}`)
}

function shouldFail (fpath) {
  return fpath.toLowerCase().includes('invalid')
}

main()
