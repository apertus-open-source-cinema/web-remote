<widget-bool>
<!-- Layout -->
<div class="card-widget box">
        <div class="center">
            <h5>{ title }</h5>
    </div>
    <div class="">
        <div>
            <i class="material-icons md-48">{ icon }</i>
        </div>
    </div>
</div>
<!-- Custom Style -->
<style>
    .center {
        text-align: center;
    }
    .align {
        vertical-align: middle;
        margin: 2px;
    }
    .size {
        font-size: 22px;
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
var self = this

// Mixin
this.mixin(SharedMixin)

// Getting the Object Data 
this.dataObject = opts.data

// Set Values
this.title = "Dev Bool"
this.icon = "highlight"
this.id = "0000"

/**
 * OBSERVABLE
 */

// On ID 
this.observable.on("ID_" + this.id, function(value){
    self.value = value.value
    // ADD FUNCTION True / False
    self.update()
})

</script>
</widget-bool>
