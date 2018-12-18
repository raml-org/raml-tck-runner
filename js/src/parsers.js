const raml = require('raml-1-parser')
const amf = require('amf-client-js')
const wap = require('webapi-parser').WebApiParser

async function raml1parserParse (fpath) {
  const res = raml.loadSync(fpath)
  if (res.errors.length > 0) {
    throw new Error(res.errors[0].message)
  }
  return res
}

async function amfParse (fpath) {
  await amf.AMF.init()
  const ramlParser = amf.AMF.raml10Parser()
  const model = await ramlParser.parseFileAsync(`file://${fpath}`)
  const report = await amf.AMF.validate(
    model, amf.ProfileNames.RAML10, amf.MessageStyles.RAML)
  report.results.map(res => {
    if (!res.conforms && res.level.toLowerCase() === 'violation') {
      throw new Error(res.message)
    }
  })
}

async function webapiParserParse (fpath) {
  const model = await wap.raml10.parse(`file://${fpath}`)
  const report = await wap.raml10.validate(model)
  report.results.map(res => {
    if (!res.conforms && res.level.toLowerCase() === 'violation') {
      throw new Error(res.message)
    }
  })
}

module.exports = {
  raml1parserParse: raml1parserParse,
  amfParse: amfParse,
  webapiParserParse: webapiParserParse
}
