const http = require('http');
const fs = require('fs');
const finalhandler = require('finalhandler');
const serveStatic = require('serve-static');
const serve = serveStatic("./dist");

let port = process.env.PORT || 3000

var server = http.createServer(function(req, res) {
  if (req.url == '/') {
    res.writeHead(301, {'Location': '/index.html'});
    res.end();
    return;
  }

  var done = finalhandler(req, res);
  serve(req, res, done);
});

server.listen(port);
console.log('node server running on port '+port);
