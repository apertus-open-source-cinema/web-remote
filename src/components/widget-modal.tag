<widget-modal>
    <!-- Layout -->
    <input type="checkbox" id="modal-control" class="modal">
    <div onclick={ closeWindow } id="modalArea" role="dialog" aria-labelledby="dialog-title">
        <div class="card fluid">
            <div class="">
                <h2 id="exampleModalLabel">{ dataObject.name }</h2>
                <label for="modal-control" class="modal-close" ></label>
            </div>  
            <div class="section">
                <input onclick={ autoUpdate } type="checkbox" checked={ autoUpdateState }/>Auto Update<br>
            </div>
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
            <div class="section">
                <button onclick={ setToDefault } type="button" class="mui-btn">Set to Default</button>
                <label type="button" class="tertiary" for="modal-control">Close</label>
                <label onclick={ updateValueAndClose } type="button" class="primary" for="modal-control">Save changes</label>
            </div>
        </div>
    </div>
        
<!-- Custom Style -->
<style>

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
    self.dataObject.value = e.srcElement.value;
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

this.observable.on('loadEditWindow', function(value){
    self.dataObject = value;
    self.selection = value.selection.split(',');
    // Check
    document.getElementById('modal-control').checked = true;
    self.update();
})

</script>
</widget-modal>