const http = require("http")
const port = 3000
const server = http.createServer((req, res) => {
 console.log(req.headers)
 res.statusCode = 200
 res.end(" <html><body><button onclick=QUOTEdocument.getElementById('greeting' ).innerText=''>ClickMe</button> <p id=QUOTEgreetingQUOTE > </p></body></html> " );
})
server.listen(port)
console.log("Listening on port 3000")
