# web-remote
AXIOM Beta webbased control GUI for camera remote control


## Installation

1. Install nodejs and npm
1. Download the Project
1. Go to Folder where the `package.json` file is
1. Run `npm install`

To start a development server, run `npm run start`.  
To build the project statically, run `npm run build`.


#### Folder Layout
/component  -> All view and widget components are here
/css        -> CSS file location
/js         -> External JS files and App.js
/img        -> Image folder
/icon       -> in the future all icons will be inside here
/font       -> Font Folder

#### Structure (simple)
**Current State**
JSON FIle <> Custom DB Function <> Riot View Component

**Target**
Axiom Server <> Custom DB Function <> Riot View Component

### Components

#### Views
Index HTML -> View TAG -> Widget Tag

## Data Structure

**NOTE**
There are some open questions that should be solved on a later stage.
Current target is to have something to work with.

```js
{
    "id"
    "camera_id" :   "camera id"
    "function_id" :   "unique value",
    "type"      :   "data type",
    "class"     :   "for what type of object"
    "data"      {
        "value"
        "defaultValue"
        "range": [0,100]
        "custom_value": false
    }
}
```

### Function

* _id               -> internal id
* type              -> Defined Type will be used for the Widget
* name              -> Name of the Function
* class             -> for what is it (imagesensor / hardware / imageprocessing / ...)
* value             -> Current set Value
* defaultValue      -> default defined Value for Reseting
* selection         -> Range / Array / ???
* command           -> websocket command

#### Data Structure

```js
{
    "_id":"value",
    "type":"value",
    "name":"value",
    "class":"value",
    "value":"value",
    "defaultValue":"value",
    "selection":"value",
    "command":"value"
}
```

### Page

* _id               -> internal id
* type              -> Definition that this dataset is a page
* name              -> Name of the Page
* _pos              -> internal position value
* components        -> Array of Components

#### Data Structure

```js
{
    "_id":"value",
    "type":"value",
    "name":"value",
    "_pos":"value",
    "components": ["comp01_id", "comp02_id"]
}
```


## Observable

**Triggers**
* loadPage      -> Loading Selected Page
* loadSetup     -> Loading Setup View

## Web Sockets

### Connections

There will be 2 Ports one for a open stream from the Camera to the Web Interface second a Communication port from Web Inetrface to Camera.

Example sent Command:

```js
{
    "sender" : "web_ui",
    "module" : "image_sensor",
    "command" : "set_gain",
    "value" : "3"
    "timestamp" : "",  // can't remember the format for now
    "status" : "success"    // has still to be defined finally
}
```
