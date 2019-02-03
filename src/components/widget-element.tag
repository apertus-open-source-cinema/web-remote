<!-- 

    Widget Card
    ===========

    Default Widget Shows Values.

 -->
<widget-element>
<!-- Layout -->
<div class="card-widget box" id={ id } hide={ listView }>
    <div class="full-element" onclick={ toggleSize } if={ !stateBig }>
        <div class="center">
            <h5>{ title }</h5>
            <h4 class="center-text">{ value }</h4>
        </div>
    </div>
    <div class="content" if={ stateBig }>
            <i onclick={ toggleSize } class="right icon icon-highlight_off md-24"></i>
            <div class="center">
                    <h5>{ title }</h5>
                    <h4 class="value">{ value }</h4>
                    <!-- Slider -->
                    <input class="slider" id={ id + "-valueslider" } oninput={ selectedOnChange } type="range" value={ sliderPos } min="0" max="{ selection.length-1 }" step="1">
            </div>
            <!-- Buttons -->
            <div class="section">
                <label onclick={ setToDefault } class="button">Default</label>
            </div>
    </div>
</div>
<!-- List View -->
<div show={ listView }>
    <button type="button" class="butt ">
        <b>{ title }</b> { value }
    </button>
</div>
<!-- Custom Style -->
<style>
    .value {
        font-size: 22px;
    }
    .full-element{
        width: 100%;
        height: 100%;
    }
    .content {
        position: relative;
    }
    .right{
        position: absolute;
        top: 5px;
        right: 5px;
    }
    .center {
        text-align: center;
    }
    .box {
        margin: 5px;
        width:  9rem;
        height: 100px;
        transition: 0s;
    }
    .box-active {
        margin: 5px;
        width:  18rem;
        height: 200px;
        transition: 0s;
    }
    .transition {
        opacity: 0;
    }
    .transition-active {
        opacity: 1;
        transition: 0.5s;
    }
    .butt{
        margin: 5px;
    }
    .slider{
    margin: 20px;
    color: #0074d9;
    width: -webkit-fill-available;
    background-color: #f8f8f8;
}
</style>
<!-- Code -->
<script>
// local 
let self = this;

// Mixin
this.mixin(SharedMixin);

// Getting the Object Data 
this.dataObject = opts.data;

// Set Values
this.id = this.dataObject._id;
this.title = this.dataObject.name;
this.value = this.dataObject.value;
this.selection = this.dataObject.selection.split(',');
this.sliderPos = '';
this.stateBig = false;

toggleSize(e){
    let d = document.getElementById(self.id);
    d.classList.toggle('box-active');
    self.stateBig = !self.stateBig;
    // set Slider Position
    self.sliderPos = self.selection.indexOf(self.value);
    self.update();
}

// Setting the Value to the Default Value defined by the defaultValue Attribute
setToDefault(){
    let defaultValue = self.dataObject.defaultValue;
    self.value = defaultValue;
    self.sliderPos = self.selection.indexOf(defaultValue);
    // TODO: Find a Better Solution
    document.getElementById(self.id + "-valueslider").value = self.sliderPos;
    self.update();
}

selectedOnChange (e){
    self.dataObject.value = self.selection[e.srcElement.value];
    self.value = self.selection[e.srcElement.value];

    self.updateValue();
    self.update();
}

updateValue(){
    self.observable.trigger('ID_' + self.dataObject._id, self.dataObject);
}

/**
 * OBSERVABLE
 */

// On ID 
this.observable.on('ID_' + this.id, function(data){
    let result = validateDataset(self.dataObject, data.value);
    console.log('validation:', self.id, result);
    if (result === true) {
        self.value = data.value;
    }
    self.update();
})

</script>
</widget-element>