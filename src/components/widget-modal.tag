<!-- 

    Widget Modal
    ===========

    Show's a Modal Window where the User can update the value.

 -->
<widget-modal>
    <!-- Layout -->
    <input type="checkbox" id="modal-control" class="modal">
    <div onclick={ closeWindow } id="modalArea" role="dialog" aria-labelledby="dialog-title">
        <div class="card fluid">
            <div class="">
                <h2 id="exampleModalLabel">{ dataObject.name }</h2>
                <label for="modal-control" class="modal-close" ></label>
            </div>
            <!-- Auto Update -->
            <div class="section">
                <input onclick={ autoUpdate } type="checkbox" checked={ autoUpdateState }/>Auto Update<br>
            </div>
            <!-- Slider -->
            <input class="slider" oninput={ selectedOnChange } type="range" min="0" max="{ selection.length-1 }" step="1">
            <h4 class="center-text">{ value }</h4>
            <!-- Pulldown -->
            <div class="section">
                <div class="form-group">
                    <label for="formSelection">Set { dataObject.name } Value:</label>
                    <select onchange={ selectedOnChange } class="form-control" id="formSelection">
                        <option selected>{ dataObject.value }</option>
                        <option disabled>----------------</option>
                        <option each={ item, i in selection} >
                            { item }
                        </option>
                    </select>
                </div>
            </div>
            <!-- Buttons -->
            <div class="section">
                <label onclick={ setToDefault } type="button" class="">Set to Default</label>
                <label type="button" class="tertiary" for="modal-control">Close</label>
                <label onclick={ updateValueAndClose } type="button" class="primary" for="modal-control">Save changes</label>
            </div>
        </div>
    </div>
        
<!-- Custom Style -->
<style>
.slider{
    margin: 20px;
    color: #0074d9;
}
.center-text{
    text-align: center;
}

</style>

<!-- Code -->
<script>
// local 
let self = this;

// Mixin
this.mixin(SharedMixin);

// Current DataObject
this.dataObject = [];
this.selection = [];
this.autoUpdateState = false;
this.value = "";

closeWindow(e){
    if(e.srcElement.id === "modalArea"){
        document.getElementById('modal-control').checked = false;
        this.update();
    }
}

// Setting the Value to the Default Value defined by the defaultValue Attribute
setToDefault(){
    self.dataObject.value = self.dataObject.defaultValue;
    self.update();
}

selectedOnChange (e){
    self.dataObject.value = self.selection[e.srcElement.value];
    self.value = self.selection[e.srcElement.value];
    if (self.autoUpdateState === true) {
        self.updateValue();
    }
    self.update();
}

updateValue(){
    self.observable.trigger('ID_' + self.dataObject._id, self.dataObject);
}

updateValueAndClose(){
    self.autoUpdateState = false;
    self.updateValue();
}

autoUpdate(e){
    self.autoUpdateState = !self.autoUpdateState;
    if (self.autoUpdateState === true) {
        self.updateValue();
    }
    self.update();
}

/**
 * OBSERVABLE
 */

this.observable.on('loadEditWindow', function(data){
    self.dataObject = data;
    self.selection = data.selection.split(',');
    self.value = self.selection[0];
    // Check
    document.getElementById('modal-control').checked = true;
    self.update();
})

</script>
</widget-modal>