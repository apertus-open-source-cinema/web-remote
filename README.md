# web-remote
AXIOM Beta webbased control GUI for camera remote control

#### Target Features

* All Function are in a Database that can be searched (at the moment JSON File)
* Interface are Layoutet in Tabs
* Tabs can be Add or Deleted and Edited (needs to be defined how it should implemented)
* Preset Storage (needs to be defined how it should implemented)


#### Folder Layout
/component  -> All view and widget components are here
/css        -> CSS File Location
/js         -> External JS files and App.js
/img        -> Image Folder
/icon       -> when project is on first version all icons will be inside here

#### Structure (simple)
**Current State**
JSON FIle <> Custom DB Function <> Riot View Component

**Target**
DB.file <> Custom DB Function <> Riot View Component


#### Used JS Libs
* Riot.js       (MVC Lib)
* mini.css     (GUI Components Stylesheet)
* custom DB       (Database stores all Commands / Presets / Interface layout) **NOT INPLEMENTED**
    


### Components

#### Views

Index HTML -> View TAG -> Widget Tag

## Data Structure

**NOTE** 
There are some Questions open that should be solved on a later stage. 
Current Target is to have something to work with.

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

### Page

* _id               -> internal id
* type              -> Definition that this dataset is a page
* name              -> Name of the Page
* _pos              -> internal position value
* components        -> Array of Components

#### Data Structure
{
    "_id":"value",
    "type":"value",
    "name":"value",
    "_pos":"value",
    "components": ["comp01_id", "comp02_id"]
}


## Observable

**Triggers**
* loadPage      -> Loading Selected Page
* loadSetup     -> Loading Setup View

## Web Sockets

### Connections

There will be 2 Ports one for a open stream from the Camera to the Web Interface second a Communication port from Web Inetrface to Camera.

Example sent Command
{
    "sender" : "web_ui",
    "module" : "image_sensor",
    "command" : "set_gain",
    "value" : "3"
    "timestamp" : "",  // can't remember the format for now
    "status" : "success"    //have still to be defined finally
}

## Installation

Requirement npm: (https://nodejs.org/)

1. Download the Project
2. Go to Folder where the **package.json** file is
3. Run **npm install**

Development: **run_dev.sh** or **run_dev.bat**

Build: **build.sh** or **build.bat**