<view-navbar>
<!-- Layout -->
<header class="sticky">
    <a class="logo block"><img src="/img/apertus_Logo.svg" width="60" class="block" alt=""></a>
    <div each={item, i in pagelist} class="block hidden-sm">
        <a class="button" onclick={ setPage }>{ item.name }</a>
    </div>
    <!-- List View -->
    <div onclick={ setCommandList } class="block hidden-sm">
        <div class="button">
            <i class="material-icons">view_list</i>
        </div>
    </div>
    <!-- App Settings -->
    <div onclick={ setConfiguration } class="block hidden-sm">
        <div class="button">
            <i class="material-icons">settings</i>
        </div>
    </div>

    <!-- DRAWER -->
    <div class="right">
        <label onclick={ testListner } for="drawer-control" class="button drawer-toggle"></label>
    </div>
    
    <!-- Drawer Menu -->
    <input type="checkbox" id="drawer-control" class="drawer">
    <div id="drawerWindow">
        <label for="drawer-control" class="drawer-close"></label>
        <div onclick={ setPage } each={item, i in pagelist} >
            <a class="button" >{ item.name }</a>
        </div>
        <!-- List View -->
        <div onclick={ setListView }>
            <div class="button">
                <i class="material-icons">view_list</i>
                <span>List View</span>
            </div>
        </div>
        <!-- App Settings -->
        <div onclick={ setConfiguration }>
            <div class="button">
                <i class="material-icons">settings</i>
                <span>Settings</span>
            </div>
        </div>
    </div>
</header>

<!-- Custom Style -->
<style>
    .right{
        float: right;
        display: inline-block;
    }
    .block{
        margin: 5px;
        display: inline-block;
    }
</style>

<!-- Script -->
<script>
// local 
var self = this

// Mixin
this.mixin(SharedMixin)

// local Variable
this.pagelist = []

// On Load get first Page with the Components 
this.observable.on('firstPageLoad', function(data){
    self.pagelist = data
    self.update()
})

// TODO nedds to be fixed
testListner(e){
    var d = document.body
    var dwarea = document.getElementById("drawerWindow").getBoundingClientRect()
    
    d.addEventListener("click", function(event){
        console.log(dwarea)
    })
}

// Set Page 
setPage(e){
    var i = e.item.i
    self.currentPage = self.pagelist[i]
    self.observable.trigger('DB_queryItems', 'loadPage', '_id', self.currentPage.components)
    self.update() 
}

// Load Commads List (view-commands.tag)
setConfiguration(){
    self.observable.trigger('loadPage','loadConfiguration')
}

// Set List View
setCommandList(){
    self.observable.trigger('loadPage','loadCommand') // just a unique string value that every other view gets disabled
    self.observable.trigger('DB_queryItems',"loadCommandList", 'type', 'component')
    self.update()
}

</script>
</view-navbar>