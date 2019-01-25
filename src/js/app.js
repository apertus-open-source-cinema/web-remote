
// Mixin Setup with the values
let SharedMixin = {
    observable: riot.observable(),
    listview: false,
    db_table: 'camera_parameters',
    db_websocket: 'websocket_command_queue'
}

// Creates the Data Object and the Interface when everything got loaded
window.onload = () => {
    // Mounting all Riot Tags
    riot.mount('*');
}