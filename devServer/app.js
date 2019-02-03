// Requirements
const WebSocket = require('ws');
const fs = require('fs');

// Start up
console.log('Start Server');

const ws = new WebSocket.Server({port: 7070});

// Load Config File
let dataFile = '';
// Load File on Startup 
loadFile();

function loadFile(){
    let filename = 'devServer/json/data.json';
    fs.readFile(filename, 'utf8', (err, data) => {
        if (err) {
            console.error(err);
            return;
        }
        dataFile = data;
        console.log('File is Loaded: %s', filename);
    });
}

ws.on('connection', socket =>{
    socket.on('message', data => {
        try {
            var message = JSON.parse(data);
        
            var tx_message;
            switch (message.type) {
            case 'get_all':
                console.log('get_all');
                tx_message = {
                    "sender": "server",
                    "type": "get_all",
                    "data": dataFile
                }
                socket.send(JSON.stringify(tx_message));
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