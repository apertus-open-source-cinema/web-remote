<!-- 

    Dashboard
    ====

    Creates the Page by Parameter.

 -->
<view-dashboard hide={ disable }>
    <!-- Layout -->
        <!-- Load Components // Note: the full Object Value gets send to the Widget -->
        <!-- <div class="row">
            <div each={ data, i in components }>
                <widget-element if={data.class == "component"} data={ data } ></widget-element>
                <widget-icon if={data.class == "icon"} data={ data }></widget-icon>
                <widget-bool if={data.class == "bool"} data={ data }></widget-bool>
                <widget-chart if={data.class == "chart"} data={ data }></widget-chart>
            </div>
        </div> -->
        
        <div class="flex-container">
            <div class="card box color-red">
                <div class="title">Titel</div>
            </div>
            <div class="card box color-green"></div>
            <div class="card box color-orange" ></div>
            <div class="card box color-orange" ></div>
        </div>
        <div class="flex-container flex-bottom">
            <div class="card box color-red"></div>
            <div class="card box color-red"></div>
            <div class="card box color-green"></div>
            <div class="card box color-orange" ></div>
        </div>

    <!-- Custom Style -->
    <style>
        .box {
        margin: 5px;
        width:  9rem;
        height: 100px;
    }
    #footer{
        bottom: 0px;
    }
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
    
    this.observable.on('DB_databaseLoaded',() => {
        self.observable.trigger('DB_queryItems', self.db_table ,'firstPageLoad', 'type', 'page');
    })
    
    this.observable.on('firstPageLoad', (data)  => {
        self.observable.trigger('DB_getItemsById', self.db_table , 'loadPage', '_id', data[0].components);
    })
    
    // Load Page Components
    this.observable.on('loadPage', (setPageValue) => {
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
</view-dashboard>