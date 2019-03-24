<!-- 
    Navigation Bar 
    ==============

    Generates Automaticaly the Menu's

 -->
<view-sidebar>
<!-- Layout -->

<div id="mySidenav" class="sidenav" >
    <a class="logo block"><img src="/img/apertus_Logo.svg" width="120" class="block" alt=""></a>
    <!-- <a href="javascript:void(0)" class="closebtn" onclick={toggleNav} >&times;</a> -->
    <div each={item, i in pagelist}>
        <nobr><a onclick={ setPage }>{ item.name }</a></nobr>
    </div>
    <div id="mySidenav-btn" class="container">
        <div class="vertical-center">
            <div onclick={ toggleNav }>
                <div class="bar1"></div>
                <div class="bar2"></div>
                <div class="bar3"></div>
            </div>
        </div>
    </div>
</div>


<!-- Custom Style -->
<style>

.container { 
    height: 100%;
    right: 0px;
    margin-left: 250px;
}

.vertical-center {
    margin: 0;
    position: absolute;
    top: 50%;
    -ms-transform: translateY(-50%);
    transform: translateY(-50%);
}

.bar1, .bar2, .bar3 {
  width: 35px;
  height: 5px;
  background-color: #333;
  margin: 6px 0;
  transition: 0.4s;
}
</style>

<!-- Script -->
<script>
// local 
let self = this;

// Mixin
this.mixin(SharedMixin);

// local Variable
this.pagelist = [];

// On Load get first Page with the Components 
this.observable.on('firstPageLoad', (data) => {
    self.pagelist = data;
    self.update();
})

toggleNav() {
    let l = document.getElementById("mySidenav").style.left;
    if(l === "0px"){
        document.getElementById("mySidenav").style.left = "-250px";
    } else {
        document.getElementById("mySidenav").style.left = "0px";
    }
}

// Set Page 
setPage(e){
    let i = e.item.i;
    self.currentPage = self.pagelist[i];
    self.observable.trigger('DB_getItemsById', self.db_table, 'loadPage', '_id', self.currentPage.components);
    self.update();
}

// Load Commads List (view-commands.tag)
setConfiguration(){
    self.observable.trigger('loadPage','loadConfiguration');
}

// Set List View
setCommandList(){
    self.observable.trigger('loadPage','loadCommand'); // just a unique string value that every other view gets disabled
    self.observable.trigger('DB_queryItems', self.db_table ,'loadCommandList', 'type', 'component');
    self.update();
}

</script>
</view-sidebar>