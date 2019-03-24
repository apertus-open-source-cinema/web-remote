<!-- 

    Widget Chart
    ===========

    Show's the Value as a line chart. 
    Currently predefined with showing last 20 values.

 -->
<widget-chart>
<!-- Layout -->
<div class="card">
    <div class="center">
        <h5>{ title }</h5>
    </div>
    <div class="center-svg">
        <svg width="100" height="60" viewBox="0 0 100 100">
        <polyline
            fill="none"
            stroke="#0074d9"
            stroke-width="2"
            points={ chartValue }
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

// Set Values
this.chartValue = "";
this.title = this.dataObject.name;
this.id = this.dataObject._id;

// Default Values
this.countTotal = 20; // Total count of values that are showed
this.list = Array(this.countTotal);
this.xCount = 100;
this.yCount = 100;

/**
* OBSERVABLE
*/

// On ID 
this.observable.on('ID_' + this.id, function(data){
    // limit array lenght
    if (self.list.length >= self.countTotal) {
        self.list.shift();
    }
    // Set the Data to 2 Digits (example: 2 -> 02)
    self.list.push((data.value).toLocaleString('en-US', {minimumIntegerDigits: 2, useGrouping:false}));
    
    // Add value to list 
    let length = self.list.length;
    let chartCreateValue = "";
    let steps = self.xCount / self.countTotal;
    let addValue = ""; // emty variable

    // Creates the String vor the SVG points value
    for (let index = length-1; index > -1; index--) {
        chartCreateValue += addValue.concat(steps*index, ",", self.list[index], " ");
    }
    console.log("Chart Value:", chartCreateValue);
    self.chartValue = chartCreateValue;
    self.update();
})

</script>
</widget-chart>