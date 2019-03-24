<!-- 

    Widget Bool
    ===========

    Activate and deactivate the defined Parameter.

 -->
<widget-bool>
<!-- Layout -->
<div onclick={ setState } class="card">
        <div class="center">
            <h5>{ title }</h5>
    </div>
    <div class="center">
        <div>
            <i show={ value } class="icon icon-highlight_off md-48 red"></i>
            <i hide={ value } class="icon icon-check_circle_outline md-48 blue"></i>
        </div>
    </div>
</div>
<!-- Custom Style -->
<style>
    .blue{
        color: #0074d9;
    }
    .red{
        color: red;
    }
    .center {
        text-align: center;
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
this.title = this.dataObject.ui.name;
this.id = this.dataObject._id;
this.value = this.dataObject.currentValue;

// Invert the Bool State True -> False -> True
setState(e){
    this.value = !this.value;
    this.update();
}

/**
 * OBSERVABLE
 */

// On ID 
this.observable.on('ID_' + this.id, function(data){
    self.value = data.value;
    self.update();
});
</script>

</widget-bool>