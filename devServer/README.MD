# Dev Server

## Commands

### get

The get command will sent the selected Parameter value back.

### get_all

The get_all command will get all Parameters from the Camera.

### set

Set's the Value and gives feedback if it was sucessful or not

### sync

Will check if the values are in Sync. Camera -> Webremote

## Dev Commands

### close

Will close the Application

### reloadFile

Reload the data File 

# Test Patterns

1. weighting the function
2. set pattern
3. set error state


```js
{
    "id"
    "data"      {
        "value"
        "defaultValue"
        "range": [0,100]
        "custom_value": false
    }
    "pattern" {
        "weight" : "value"
        "pattern" : "values"
        "error" : "values"
    }
}
```