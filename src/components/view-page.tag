<view-page hide={ disable }>
<!-- Layout -->
    <!-- Load Components // Note: the full Object gets sendet to the Widget -->
    <div class="row">
        <div each={ data, i in components }>
            <widget-card if={data.class == 'component'} data={ data } ></widget-card>
            <widget-icon if={data.class == 'icon'} data={ data }></widget-icon>
        </div>
        <widget-chart></widget-chart>
        <widget-bool></widget-bool>
    </div>

<!-- Custom Style -->
<style>

</style>

<!-- Script -->
<script>
// local 
var self = this

// Mixin
this.mixin(SharedMixin)

// local Variable
this.components = []
this.disable = false

// On Load get first Page with the Components 
this.on('mount', function() {
    console.log("load Database")
    self.observable.trigger('DB_loadDatabase')
})

this.observable.on('DB_databaseLoaded',function(){
    self.observable.trigger('DB_queryItems',"firstPageLoad", 'type', 'page')
})

this.observable.on('firstPageLoad', function(data){
    self.observable.trigger('DB_queryItems', 'loadPage', '_id', data[0].components)
})

/**
 * OBSERVABLE
 */

// Load Page Components
this.observable.on('loadPage', function(setPageValue){
    if (typeof(setPageValue) === 'object'){
        self.components = setPageValue
        self.disable = false
    }
    else {
        self.disable = true
    }
    self.update()
})

</script>
</view-page>