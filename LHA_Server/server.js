const express = require("express");
const app = express();
var cors = require("cors");
app.use(cors());

const server = require("http").createServer(app);
const WebSocket = require("ws");

const wss = new WebSocket.Server({ server: server });

wss.address();

// 'ws://10.0.2.2:3000'

wss.on("connection", function connection(ws) {
  console.log("A new client Connected!");
  ws.send("Welcome New Client!");

  ws.on("message", function incoming(message) {
    console.log("received: %s", message);

    wss.clients.forEach(function each(client) {
      if (client !== ws && client.readyState === WebSocket.OPEN) {
        //sends message to other connected clients
        client.send(message);
      }
      client.send(message); //Includes the client who sent the message
    });
  });
});

app.get("/", (req, res) => res.send("Hello World!"));

server.listen(3000, () => console.log(`Listening on port :3000`));

var express2 = require("express");
var app2 = express2();
var fs = require("fs");

app2.use(cors());

app2.get("/listUsers", function (req, res) {
  fs.readFile(__dirname + "/" + "users.json", "utf8", function (err, data) {
    console.log(data);
    res.end(data);
  });
});

var server2 = app2.listen(8081, function () {
  var host = server2.address().address;
  var port = server2.address().port;
  console.log("Example app listening at http://%s:%s", host, port);
});

// enameled glass x3

// Read Write file

// fs.readFile('student.json', (err, data) => {
//   if (err) throw err;
//   let student = JSON.parse(data);
//   console.log(student);
// });

// //J12

// //OR
// let rawdata = fs.readFileSync('student.json');
// let student = JSON.parse(rawdata);
// console.log(student);

// let student = {
//   name: 'Mike',
//   age: 23,
//   gender: 'Male',
//   department: 'English',
//   car: 'Honda'
// };

// let data = JSON.stringify(student);
// fs.writeFileSync('student-2.json', data);
