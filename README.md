# web-remote
AXIOM Beta webbased control GUI for camera remote control


# Build status
| master |
|:------:|
|[![CircleCI](https://circleci.com/gh/apertus-open-source-cinema/web-remote/tree/master.svg?style=svg)](https://circleci.com/gh/apertus-open-source-cinema/web-remote/tree/master)|




## Installation

1. Install nodejs and npm
1. Download the Project
1. Go to Folder where the `package.json` file is
1. Run `npm install`

To start a development gulp build server, run `npm run dev`.  
To start the development websocket server, run `npm run server`.  
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

### Daemon Data

```js
{
    "module": "image_sensor",
    "parameter": "digital_gain",
    "possibleValues": [
    "1", "2", "3", "4", "6", "8", "10", "12", "14", "16"
    ],
    "currentValue": "1",
    "defaultValue": "1",
    "lastValue" : "",
    "range": [],
    "readOnly": false
}
```

### Function

* module            -> internal Hardware Module
* parameter         -> Defined Parameter
* possibleValues    -> Range of possible Values
* currentValue      -> The current set Value
* defaultValue      -> The default Value
* lastValue         -> The previewus Value
* range             -> Defined Range [1,10]
* readOnly          -> Can the Value be changed or ony readed

#### UI Data

```js
{ "module": "camera", "parameter": "battery",
    "name":"Battery",
    "ui_element": "icon",
    "defaultIcon": "battery_unknown",
    "selectionType": "range",
    "selection": {
        "range":[5,20,50,99,100],
        "icon":[
        "battery_alert",
        "battery_20",
        "battery_50",
        "battery_90",
        "battery_full"
        ]
    }
},
{ "module": "camera", "parameter": "recording", "name": "Recording",
    "ui_element": "bool"
}
```

### UI Parameters

* module            -> internal Hardware Module
* parameter         -> Defined Parameter
* name              -> Name 
* ui_element        -> Defines how the UI should display this Parameter

#### Final Data Structure in Web Remote

The UI Data gets merged with the Daemon Data and will be in the "ui" item.

```js
{
    {
    "module": "image_sensor",
    "parameter": "digital_gain",
    "possibleValues": [
    "1", "2", "3", "4", "6", "8", "10", "12", "14", "16"
    ],
    "currentValue": "1",
    "defaultValue": "1",
    "lastValue" : "",
    "range": [],
    "readOnly": false,
    "ui": { "module": "image_sensor","parameter": "digital_gain",
        "ui_element": "component", "name": "Digital Gain"
    }
}
}
```


## Observable

There are Multiple Observables they will be listed here:

**Triggers**
* loadPage      -> Loading Selected Page
* loadSetup     -> Loading Setup View

## Web Sockets

### Connections

There will be 2 Ports one for a open stream from the Camera to the Web Interface second a Communication port from Web Inetrface to Camera.

The current sent Command:

```js
{
    "sender" : "web_ui",
    "module" : data.type,
    "command" : "set",
    "parameter" : data.command,
    "value1" : data.selection.indexOf(data.value).toString(),
    "value2" : '',
    "status" : '',
    "message" : '',
    "timestamp" : '',
};
```
