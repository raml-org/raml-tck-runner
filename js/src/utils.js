const os = require('os')
const path = require('path')
const fs = require('fs')
const { execSync } = require('child_process')
const rimraf = require('rimraf')

/* Clones raml-tck repo and returns tests path */
function cloneTckRepo (branch) {
  const repoDir = path.join(os.tmpdir(), 'raml-tck')
  rimraf.sync(repoDir)
  console.log('Cloning raml-tck to', repoDir)
  execSync(
    `git clone -b ${branch} git@github.com:raml-org/raml-tck.git ${repoDir}`)
  return repoDir
}

/* Lists raml files in folder */
function listRamls (foldPath) {
  const manifestPath = path.join(foldPath, 'manifest.json')
  const manifest = JSON.parse(fs.readFileSync(manifestPath, 'utf8'))
  return manifest.filePaths.map((filePath) => {
    return path.join(foldPath, filePath)
  })
}

/* Writes JSON report to output folder */
function saveReport (report, outdir) {
  outdir = path.resolve(outdir)
  try { fs.mkdirSync(outdir) } catch(e) {}
  const fpath = path.join(outdir, `${report.parser}.json`)
  fs.writeFileSync(fpath, JSON.stringify(report, null, 2))
}

module.exports = {
  cloneTckRepo: cloneTckRepo,
  listRamls: listRamls,
  saveReport: saveReport
}
