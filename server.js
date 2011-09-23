var fs = require("fs")
var https = require("https")
var options = { key: fs.readFileSync("./server.key")
              , cert: fs.readFileSync("./server.crt") }

var server = https.createServer(options, function (req, res) {
  res.writeHead(200)
  res.end()
  server.close()
})
server.listen(1337)

https.request({ host: "localhost"
              , method: "HEAD"
              , port: 1337
              , headers: { host: "registry.npmjs.org" }
              , ca: [ fs.readFileSync("./ca.crt") ]
              , path: "/" }, function (res) {
  if (res.client.authorized) {
    console.log("node test: OK")
  } else {
    throw new Error(res.client.authorizationError)
  }
}).end()
