<!-- 

    Database
    ===========

    Currently only a Test Setup for Loading and changing values.

 -->
<data-database>
<script>

// local 
let self = this;

// Mixin
this.mixin(SharedMixin);

this.url = '/json/data.json';


//prefixes of implementation that we want to test
window.indexedDB = window.indexedDB || window.mozIndexedDB || 
window.webkitIndexedDB || window.msIndexedDB;

//prefixes of window.IDB objects
window.IDBTransaction = window.IDBTransaction || 
window.webkitIDBTransaction || window.msIDBTransaction;
window.IDBKeyRange = window.IDBKeyRange || window.webkitIDBKeyRange || 
window.msIDBKeyRange

if (!window.indexedDB) {
    window.alert("Your browser doesn't support a stable version of IndexedDB.")
}

this.db;
this.db_name = "webremotedb";
this.db_objstore_name = "camera_parameters";


load(db_table_name, data){
    var request = window.indexedDB.open(self.db_name, 1);
    request.onerror = function(event) {
        console.log("error: ");
    };
    
    request.onsuccess = function(event) {
        self.db = request.result;
        console.log("success: "+ self.db);
        self.observable.trigger('DB_databaseLoaded');
    };
    
    // Insert Values when DB is emty
    request.onupgradeneeded = function(event) {
        console.log("Fill DB");
        var db = event.target.result;
        var objectStore = db.createObjectStore(db_table_name, {keyPath: "_id"});

        for (var i in data) {
            objectStore.add(data[i]);
        }
    }
}

this.observable.on('DB_getItemsById', (db_table_name, trigger, objectType, objectValue) =>{
    let match = [];
    var transaction = self.db.transaction([db_table_name]);
    var objectStore = transaction.objectStore(db_table_name);
    objectValue.forEach( (id) =>{
        var request = objectStore.get(id);
        
        request.onerror = function(event) {
            console.log("Unable to retrieve data from database!");
        };

        request.onsuccess = function(event) {
            if(request.result) {
                match.push(request.result);
            } else {
                console.log("The Item %s could not be found!", id);
            }
        };
    });
    transaction.oncomplete = function (){
        self.observable.trigger(trigger, match);
    }
});

getItembyId(db_table_name, id) {
    var transaction = self.db.transaction([db_table_name]);
    var objectStore = transaction.objectStore(db_table_name);
    var request = objectStore.get(id);
    
    request.onerror = function(event) {
        console.log("Unable to retrieve data from database!");
    };
    
    request.onsuccess = function(event) {
        if(request.result) {
            return request.result;
        } else {
            console.log("The Item %s could not be found!", id);
        }
    };
}

updateValue(db_table_name, id, value){
    var transaction = self.db.transaction([db_table_name], "readwrite");
    var objectStore = transaction.objectStore(db_table_name);
    var request = objectStore.get(id);
    console.log("update");
    console.log(request);

    request.onerror = function(event) {
        console.log("Unable to retrieve data from database!");
    };
    
    request.onsuccess = function(event) {
        // Do something with the request.result!
        if(request.result) {
            request.result.value = value;
            objectStore = objectStore.put(request.result);
            console.log();
        } else {
            console.log("Update failed in database!");
        }
    };
}


/*
function add() {
    var request = db.transaction([db_objstore_name], "readwrite")
    .objectStore(db_objstore_name)
    .add({ id: "00-03", name: "Kenny", age: 19, email: "kenny@planet.org" });
    
    request.onsuccess = function(event) {
        console.log("Kenny has been added to your database.");
    };
    
    request.onerror = function(event) {
        console.log("Unable to add data\r\nKenny is aready exist in your database! ");
    }
}
*/

deleteItem(db_table_name, id) {
    var request = self.db.transaction([db_table_name], "readwrite")
    .objectStore(db_table_name)
    .delete(id);
    
    request.onsuccess = function(event) {
        console.log("The Dataset %s has been deleted from database.", id);
    };
}

/*
    Loads the Database
    ==================

    The Database gets Loaded and a update get's requested over websocket.
*/  
this.observable.on('DB_loadDatabase', () => {
    self.observable.trigger("WS_GET_ALL"); // Sent a request to Server to get Data
});
    
this.observable.on('DB_updateDatabase', (data) => {
    console.log('DB_updateDatabase');
    self.load(self.db_table, data);
});

/**
 * Database Handling
 */

 this.observable.on('DB_queryItems', (db_table_name, trigger, objectType, objectValue) =>{
    let match = [];
    var objectStore = self.db.transaction(db_table_name).objectStore(db_table_name);    
    objectStore.openCursor().onsuccess = function(event) {
        var cursor = event.target.result;

        if (cursor) {
            if (cursor.value.hasOwnProperty(objectType) && cursor.value[objectType].search(new RegExp(objectValue, 'i')) > -1) {
                match.push(cursor.value);
            }
            cursor.continue();
        } else {
            console.log("No more entries!");
            self.observable.trigger(trigger, match);
        }
    };
})

this.observable.on('DB_querySelection', (trigger, object,  objectValue) => {
    let matches = [], i, key;
    let arr = object;
    console.log(objectValue, object);
    // if (objectValue === ''){
    //     return arr
    // }
    for (let i = 0; i < arr.length; i++) {
        console.log(objectValue);
        if( arr[i].search(new RegExp(objectValue, 'i')) > -1 ){
            let arrayItem = {name: arr[i]};
            matches.push( arrayItem );  // Add Array to List
        }
    }
    self.observable.trigger(trigger, matches);
})

// this.observable.on('DB_updateItem', (item) => {
//     self.updateValue(db_table_name, item._id, item.value);
// })

this.observable.on('DB_deleteItems', (db_table_name, items) => {
    items.forEach((id) => {
        self.deleteItem(db_table_name, id);
    });
})

this.observable.on('DB_addItem', (objectArray) => {
    self.data.push(objectArray);
})

// Getting all Observable and check if there is a change on a component
this.observable.on('*', function(event, data){
    // ID Tag update Value     
    if('ID_' === event.slice(0,3)){
        self.updateValue(self.db_table, data._id, data.value);
        self.observable.trigger('reloadView');
    }
})

</script>
</data-database>