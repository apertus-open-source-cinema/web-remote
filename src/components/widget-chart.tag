<widget-chart>
<!-- Layout -->
<div class="card-widget box">
    <div class="center">
        <h5>{ title }</h5>
    </div>
    <div class="center-svg">
        <svg width="100" height="60" viewBox="0 0 100 100">
        <polyline
            fill="none"
            stroke="#0074d9"
            stroke-width="2"
            points={ chart_value }
        />
        </svg>
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
    .center-svg{
        align-content: center;
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

//
this.chart_value = this.dataObject.value;
this.list = [];

// Getting the Object Data 
this.dataObject = opts.data;

// Set Values
this.title = this.dataObject.name;

this.count = 20;
this.x_count = 100;
this.y_count = 100;

this.id = this.dataObject._id;

/**
* OBSERVABLE
*/

// On ID 
this.observable.on('ID_' + this.id, function(data){
    let value = data.value;
    // Add value to list 
    self.list.push(value);
    let length = self.list.count();
    
    // for (let index = 0; index < ; index++) {
    //     self.chart_value = 
    //     const element = array[index];
        
    // }

    self.update();
})

</script>
</widget-chart>
