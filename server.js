const http = require("http");

const server = http.createServer((req, res) => {
  res.writeHead(200, { "Content-Type": "text/plain" });
  res.end("Veracode IaC/Container scan sample app\n");
});

server.listen(3000, () => {
  console.log("Sample app listening on port 3000");
});
