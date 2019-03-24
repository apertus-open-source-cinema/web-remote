// Requirements
const WebSocket = require('ws');
const fs = require('fs');

// Start up
console.log('Start Server');

const ws = new WebSocket.Server({port: 7070});

function sendData(socket, type, filename){
    console.log(type);
    fs.readFile(filename, 'utf8', (err, data) => {
        if (err) {
            console.error(err);
            return;
        }
        console.log('File is Loaded: %s', filename);
        // Create JSON Message
        let tx_message = {
            "sender": "server",
            "type": type,
            "data": data
        }
        // Send the JSON Data
        socket.send(JSON.stringify(tx_message));
    });
}

ws.on('connection', socket =>{
    socket.on('message', data => {
        try {
            var message = JSON.parse(data);
            switch (message.type) {
            case 'get_all':
                sendData(socket, 'get_all', 'devServer/json/data.json');
                break;
            case 'get_ui':
                sendData(socket, 'get_ui', 'devServer/json/ui.json');
                break;
            case 'available_parameters':
                sendData(socket, 'get_camera', 'devServer/json/camera.json');
                break;
            case 'set':
                // Add Test code here
                console.log('set');
                socket.send(JSON.stringify({"status":"ok"}));
                break;
                /**
                * This Command is for Development only
                */
            case 'close':
                socket.send('{status:\'ok\'}');
                console.log('Close Application');
                process.exit();
            case 'reloadFile':
                socket.send('{status:\'ok\'}');
                loadFile();
                console.log('Reload File');
            default:
                break;
            }
            console.log('received: %s', data);
        } catch (error) {
            console.log('Can\'t parse the incoming Data');
            socket.send('{status:\'error\', message:\'error by parsing incoming message}');
        }
    });
});