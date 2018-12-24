<!-- 

    Websocket
    ===========

    It gets all "ID_*" Observales that are changed and sent's the new value to the server.
    Note: the UI updates before the Camera Daemon updates it!
    If there is a fail it could be set back to the previews value. 

 -->
<data-websocket>
    <script>
    
    // local 
    var self = this
    
    // Mixin
    this.mixin(SharedMixin)
    
    /**
     * Websocket  Handling
     */

    var host = location.hostname;
    this.wsUrl = "ws://" + host + ":7070/"
    this.wsFeedUrl = "ws://" + host + ":7070/"
    this.ws = ''
    
    send(data){
        self.ws = new WebSocket(self.wsUrl)
        // When the connection is open, send some data to the server
        self.ws.onopen = function () {
            console.log(data)
            self.ws.send(data)
        }
    
        // Log errors
        self.ws.onerror = function (error) {
            console.log('WebSocket Error ' + error);
        }
    
        // Log messages from the server
        self.ws.onmessage = function (e) {
            console.log('Server: ' + e.data);
            self.ws.close()
        }
    }
    
    // Create the Message
    createMessage(type, data){
        // var timestamp = new Date().getTime()
        var command = data.command;
        var value = data.value;
        var message;
        switch (type) {
            case 'set':
                message = {
                "sender" : "web_ui",
                "module" : data.type,
                "type" : "set",
                "command" : command,
                "value" : value
                }
                break;
            case 'get_all':
                message = {
                "sender" : "web_ui",
                "module" : "system",
                "type" : "get_all"
                };
                break;
            case 'sync':
                message = {
                "sender" : "web_ui",
                "module" : "system",
                "type" : "sync",
                "value" : value
                }
                break;
            default:
                break;
        }
        console.log(JSON.stringify(message));
        return JSON.stringify(message);
    }
    
    // Websocket Feed 
    this.on('mount', function() {
        var ws_feed = new WebSocket(self.wsFeedUrl)
    
        // Log errors
        ws_feed.onerror = function (error) {
            console.log('WebSocket Error ' + error);
        }   
    
        console.log("start feed")
        ws_feed.onmessage = function (event) {
            var obj = JSON.parse(event.data)
            self.observable.trigger("ID_" + obj.id, obj)
        }
    })
    
    
    /**
     * OBSERVABLE
     */
    
    // Getting all Observable and check if there is a change on a component
    this.observable.on('*', function(event, data){
        // ID Tag update Value     
        if('ID_' === event.slice(0,3)){
            self.send(self.createMessage('set',data))
        }
        if('WS_GET_ALL' === event){
            self.send(self.createMessage('get_all',data))
        }
        if('WS_SYNC' === event){
            self.send(self.createMessage('sync',data))
        }
        // DEBUG Output of all Observable's
        console.log("data:", event, data)
    })
    
    </script>
</data-websocket>