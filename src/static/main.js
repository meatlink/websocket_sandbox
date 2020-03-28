function main() {
    const display = document.getElementById("display");
    const message = document.getElementById("message");
    const send = document.getElementById("send");
    const askHTTP = document.getElementById("askhttp");
    const socket = new WebSocket(`ws://${location.host}`);

    send.addEventListener("click", () => {
        showMessage("Client", message.value);
        socket.send(message.value);
        message.value = "";
    });

    askHTTP.addEventListener("click", () => {
        fetch("/askhttp").then((res) => {
            return res.text();
        }).then((text) => {
            showMessage("HTTP", text);
        });
    });

    socket.addEventListener('message', function (event) {
        console.log("Server: ", event.data);
        showMessage("Server", event.data);
    });   

    function showMessage(who, msg) {
        display.textContent += `${who}: ${msg}\n`;
    }

}
window.onload = main;
