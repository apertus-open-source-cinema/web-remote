<!-- 

    Commands
    ===========

    Show's all Command as a List.

 -->
<view-commands hide={ disable }>
<!-- Layout -->
<table class="striped">
    <caption>Components List View</caption>
    <thead>
        <tr>
        <th>Name</th>
        <th>Value</th>
        <th>ID</th>
        </tr>
    </thead>
    <tbody>
        <tr onclick={ editValue } each={item, i in list}>
        <td data-label="Name">{ item.name }</td>
        <td data-label="Value">{ item.value }</td>
        <td data-label="ID">{ item._id }</td>
        </tr>
    </tbody>
    </table>
<!-- Custom Style -->
<style>

</style>

<!-- Code -->
<script>
// local 
let self = this;

// Mixin
this.mixin(SharedMixin);
this.disable = true;

this.list = []

editValue(e){
    if (e.item.item.type === "component"){
        self.observable.trigger('loadEditWindow', e.item.item);   // Passing the Component Dataset
    }
}

/**
 * OBSERVABLE
 */

// Loading all Commands from the List
this.observable.on('loadCommandList', function(data){
    self.list = data;
    self.disable = false;
    self.update();
})

// Reload View
this.observable.on('reloadView', function(){
    self.update();
})

// Load Page Components
this.observable.on('loadPage', function(data){
    self.disable = true;
    self.update();
})


</script>

</view-commands>