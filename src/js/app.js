// Mixin Setup with the values
let SharedMixin = {
    observable: riot.observable(),
    listview: false
}

// Creates the Data Object and the Interface when everything got loaded
window.onload = () =>{
    // Mounting all Riot Tags
    riot.mount('*');
}