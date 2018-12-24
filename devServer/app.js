// Requirements
const WebSocket = require('ws');
const fs = require('fs');

// Start up
console.log('Start Server');

const ws = new WebSocket.Server({port: 7070});

// Load Config File
let dataFile = '';
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
// Load File on Startup 
loadFile();

ws.on('connection', socket =>{
    socket.on('message', data => {
        var message = JSON.parse(data);
        switch (message.type) {
        case 'get_all':
            console.log('get_all');
            socket.send(dataFile);
            break;
        case 'set':
            // Add Test code here
            console.log('set');
            socket.send('{status:\'ok\')');
            break;
            /**
            * This Command is for Development only
            */
        case 'close':
            socket.send('{status:\'ok\')');
            console.log('Close Application');
            process.exit();
        case 'reloadFile':
            socket.send('{status:\'ok\')');
            loadFile();
            console.log('Reload File');
        default:
            break;
        }
        console.log('received: %s', data);
    });
     
});