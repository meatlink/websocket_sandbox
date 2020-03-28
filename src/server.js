const http = require("http");

const express = require("express");
const ws = require("ws");


const app = express();
const server = http.createServer(app);
const wss = new ws.Server({ server });

app.use(express.static('static'));

app.get("/askhttp", (req, res) => {
    res.send(`Hello world ${(new Date()).toLocaleTimeString()}`);
});

wss.on('connection', (ws) => {
    ws.send("Hi client! You successfully connected!");
    ws.on('message', (message) => {
        console.log("received: %s", message);
        ws.send(`You said: "${message}"`);
    });
});

server.listen(8080);
