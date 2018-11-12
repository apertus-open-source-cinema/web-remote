<widget-bool>
<!-- Layout -->
<div onclick={ setState } class="card-widget box">
        <div class="center">
            <h5>{ title }</h5>
    </div>
    <div class="center">
        <div>
            <i show={ value } class="material-icons md-48 red">highlight_off</i>
            <i hide={ value } class="material-icons md-48 blue">check_circle</i>
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
    div.box {
        margin: 5px;
        width:  9rem;
        height: 100px;
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
this.title = this.dataObject.name;
this.id = this.dataObject._id;
this.value = this.dataObject.value;


setState(e){
    this.value = !this.value;
    this.update();
}

/**
 * OBSERVABLE
 */

// On ID 
this.observable.on('ID_' + this.id, function(value){
    self.value = value.value;
    self.update();
})

</script>
</widget-bool>