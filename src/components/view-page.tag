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
            <widget-element if={data.ui.ui_element == "component"} data={ data } ></widget-element>
            <widget-icon if={data.ui.ui_element == "icon"} data={ data }></widget-icon>
            <widget-bool if={data.ui.ui_element == "bool"} data={ data }></widget-bool>
            <widget-chart if={data.ui.ui_element == "chart"} data={ data }></widget-chart>
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
    // console.log('load Database');
    self.observable.trigger('DB_loadDatabase');
})

/**
 * OBSERVABLE
 */

this.observable.on('DB_UI_Data_Loaded',() => {
    self.observable.trigger('DB_queryItems', self.db_table ,'firstPageLoad', 'ui_element', 'page');
})

this.observable.on('firstPageLoad', (data)  => {
    self.observable.trigger('DB_getItemsById', self.db_table , 'loadPage', '_id', data[1].components);
})

// Load Page Components
this.observable.on('loadPage', (setPageValue) => {
    console.log("setPageValue", setPageValue);
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