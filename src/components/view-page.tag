<!-- 

    Page
    ====

    Creates the Page by Parameter.

 -->
<view-page hide={ disable }>
<!-- Layout -->
    <!-- Load Components // Note: the full Object Value gets send to the Widget -->
    <div class="row">
        <div each={ data, i in components }>
            <widget-card if={data.class == "component"} data={ data } ></widget-card>
            <widget-icon if={data.class == "icon"} data={ data }></widget-icon>
            <widget-bool if={data.class == "bool"} data={ data }></widget-bool>
            <widget-chart if={data.class == "chart"} data={ data }></widget-chart>
        </div>
    </div>

<!-- Custom Style -->
<style>
</style>

<!-- Script -->
<script>
// local 
let self = this;

// Mixin
this.mixin(SharedMixin);

// local Variable
this.components = [];
this.disable = false;

// On Load get first Page with the Components 
this.on('mount', function() {
    console.log('load Database');
    self.observable.trigger('DB_loadDatabase');
})

/**
 * OBSERVABLE
 */

this.observable.on('DB_databaseLoaded',function(){
    self.observable.trigger('DB_queryItems','firstPageLoad', 'type', 'page');
})

this.observable.on('firstPageLoad', function(data){
    self.observable.trigger('DB_queryItems', 'loadPage', '_id', data[0].components);
})

// Load Page Components
this.observable.on('loadPage', function(setPageValue){
    if (typeof(setPageValue) === 'object'){
        self.components = setPageValue;
        self.disable = false;
    }
    else {
        self.disable = true;
    }
    self.update();
})

</script>
</view-page>