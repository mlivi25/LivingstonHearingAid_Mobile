// Create WebSocket connection.
// const socket = new WebSocket('ws://localhost:3000');
const socket = new WebSocket("ws://10.0.2.2:3000");
//npm install -g iisexpress-proxy && npx iisexpress-proxy 51375 to 8095
// Connection opened
socket.addEventListener("open", function (event) {
  console.log("Connected to WS Server");
});

// Listen for messages
socket.addEventListener("message", function (event) {
  console.log("Message from server ", event.data);
  var node = document.createElement("li");
  var textnode = document.createTextNode(event.data);
  node.appendChild(textnode);

  document.getElementById("addToMe").appendChild(node);
});

const sendMessage = () => {
  socket.send("Hello From Client1!");
};

function getUsers() {
  //   $.get('http://127.0.0.1:8081/listUsers', (data) => console.log(data));
  $.get("http://localhost:8081/listUsers", (data) => console.log(data));
}

function testNode() {
  $.get("http://localhost:3000/users", (data) => console.log(data));
}
