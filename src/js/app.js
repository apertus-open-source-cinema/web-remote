
function validateDataset(dataObject, value='') {
    // Dataset is a javascript Object
    console.log(typeof(dataObject));

    // Set Value from DataObject or defined Value
    if (value === ''){
        value = dataObject.value;
    }

    if (typeof(dataObject)=== 'object'){
        switch (dataObject.class) {
            case 'component':
            case 'element':
                if (dataObject.selection.split(',').indexOf(value)>= 0){
                    return true;
                }
                else { 
                    return false;
                }
                break;
                case 'bool':
                if (dataObject.selection.split(',').indexOf(value)>= 0){      
                    return true;
                }
                else { 
                    return false;
                }
                break;
            case 'icon':
                break;
            default:
                break;
        }
    }
    else{
        console.log('For Validating the Data Object it requires a JS Object')
    }
    
}

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