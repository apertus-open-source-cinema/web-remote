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
    var self = this;
    
    // Mixin
    this.mixin(SharedMixin);
    
    /**
     * Websocket  Handling
     */

    var host = location.hostname;
    this.wsUrl = "ws://" + host + ":7070/";
    this.wsFeedUrl = "ws://" + host + ":7070/";
    this.ws = '';
    
    retry(){
        
    }

    send(data) {
        self.ws = new WebSocket(self.wsUrl);
        // When the connection is open, send some data to the server
        self.ws.onopen = () => {
            console.log(data);
            self.ws.send(data);
        }
    
        // Log errors
        self.ws.onerror = (error) => {
            // TODO: Inplement a list with all open messages
            self.observable.trigger('notification', 'Websocket can\'t connect to Server', 'warning');

            setTimeout((msg=data) => {
                self.send(msg);
            }, 5000);

            /**
             * Todo: 
             * - on connection loos
             * - can't connect (reconnecion try)
            */
        }
    
        // Log messages from the server
        self.ws.onmessage = (e) => {
            console.log(e.data);
            let message = JSON.parse(e.data);
            let data = JSON.parse(message.data);
            console.log('Server: ');
            console.log(data);

            switch (message.type) {
                case 'get_all':
                    console.log('get_all');
                    self.observable.trigger('DB_updateDatabase', data);
                    break;
                // case 'set':
                //     console.log('set');
                //     break;
                // case 'sync':
                //     console.log('sync');
                //     break;
            
                default:
                    console.log('ERROR RX Message has a wrong Type!');
                    break;
            }

            self.ws.close();
        }
    }
    
    // Create the Message
    createMessage(type, data) {
        // var timestamp = new Date().getTime()
        let message;
        switch (type) {
            case 'set':
                message = {
                "sender" : "web_ui",
                "module" : data.type,
                "type" : "set",
                "command" : data.command,
                "value" : data.value
                };
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
                "value" : data.value
                };
                break;
            default:
                break;
        }
        return JSON.stringify(message);
    }
    
    init(){
        console.log('Websocket init');
        var ws_feed = new WebSocket(self.wsFeedUrl);
    
        // Log errors
        ws_feed.onerror = (error) => {
            self.observable.trigger('notification', 'Websocket Feed can\'t connect to Server', 'warning');

            setTimeout(() => {
                self.init();
            }, 5000);
        }   
    
        console.log("start feed");
        ws_feed.onmessage = (event) => {
            var obj = JSON.parse(event.data);
            for (let i = 0; i < obj.length; i++) {
                self.observable.trigger("ID_" + obj[i].id, obj[i]);
            }
        }
    }

    // Websocket Feed 
    this.on('mount', () => {
        self.init();
        })

    
    /**
     * OBSERVABLE
     */

    // Getting all Observable and check if there is a change on a component
    this.observable.on('*', (event, data) => {
        // ID Tag update Value     
        if('ID_' === event.slice(0,3)){
            self.send(self.createMessage('set',data));
        }
        if('WS_GET_ALL' === event){
            self.send(self.createMessage('get_all',data));
        }
        if('WS_SYNC' === event){
            self.send(self.createMessage('sync',data));
        }
        // DEBUG Output of all Observable's
        console.log("data:", event, data);
    })
    
    </script>
</data-websocket>