const os = require('os')
const path = require('path')
const fs = require('fs')
const { execSync } = require('child_process')
const rimraf = require('rimraf')

function cloneTckRepo () {
  const repoDir = path.join(os.tmpdir(), 'raml-tck')
  rimraf.sync(repoDir)
  console.log('Cloning raml-tck to', repoDir)
  execSync(
    'git clone -b rename-cleanup git@github.com:raml-org/raml-tck.git ' +
    repoDir)
  return path.join(repoDir, 'tests', 'raml-1.0')
  // return '/home/post/projects/raml-tck/tests/raml-1.0/'  // DEBUG
}

function listRamls (foldPath) {
  const manifestPath = path.join(foldPath, 'manifest.json')
  const manifest = JSON.parse(fs.readFileSync(manifestPath, 'utf8'))
  return manifest.filePaths.map((filePath) => {
    return path.join(foldPath, filePath)
  })
}

function shouldFail (fpath) {
  return fpath.toLowerCase().includes('invalid')
}

function saveReport (report) {
  const fdir = path.join(__dirname, '..', '..', 'reports')
  try { fs.mkdirSync(fdir) } catch(e) {}
  const fpath = path.join(fdir, `${report.parser}.json`)
  fs.writeFileSync(fpath, JSON.stringify(report, null, 2))
}

module.exports = {
  cloneTckRepo: cloneTckRepo,
  listRamls: listRamls,
  shouldFail: shouldFail,
  saveReport: saveReport
}
