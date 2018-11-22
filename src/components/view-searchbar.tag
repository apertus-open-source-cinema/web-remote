<!-- 

    Searchbar
    ====

    Search Parameter and change values.
    Keyboard Commands:  Tab -> Selects First Parameter in the List and Loads selection List.

 -->
<view-searchbar>
    <!-- Layout -->
    <div>
        <!-- Search Bar -->
        <div  class="form-search dropdown">
            <input id="searchbar" aria-label="Searchbar" autofocus onkeydown={ quickEdit } oninput={ searchQuery } type="text" class="form-control" placeholder="Search">
        </div>
        <div show={ showList } class="dropdown-content">
            <div each={ searchResult, i in searchComponents } >
                <h6 onclick={ setValue } pos={ i }>{ searchResult.name }</h6>
            </div>
        </div>
    </div>

<!-- Custom Style -->
<style>
    .form-search{
        margin: 5px;
        width: 90%;    
    }
    .form-control{
        width: 100%;
    }
    .form-submit{   
        margin-top: 5px;
        padding-top: 3px;
        padding-bottom: 3px;
    }

    .dropdown {
        position: relative;
        display: inline-block;
    }

    .dropdown-content {
        position: absolute;
        background-color: #f9f9f9;
        min-width: 160px;
        box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
        padding: 12px 16px;
        z-index: 1;
    }

    .dropdown:hover .dropdown-content {
        display: block;
    }
</style>
<!-- Script -->
<script>
// local 
let self = this;

// Mixin
this.mixin(SharedMixin);

// Fast Manipulation Edit
this.searchComponents = [];
this.component = [];
this.showList = false;
self.state = false;

// Clean up all Values when there is no search value
clean(e){
    e.srcElement.value = '';
    self.searchComponents = [];
    self.component = [];
    self.showList = false;
    self.update();
}

// Key Functiont for faster Execution 
quickEdit(e){
    let keyCode = e.code;
    if (keyCode === 'Tab'){
        // Set Focus on First Input Element
        if (!self.state) {
            self.component = self.searchComponents[0];
            e.srcElement.value = self.component.name + ' ';
            let selection = self.component.selection.split(',');
            self.observable.trigger('DB_querySelection', 'view_searchvalue', selection, '');
            e.preventDefault();
        }
        if (self.state) {
            e.srcElement.value = self.component.name + ' ' + self.searchComponents[0].name;
            self.showList = false;
            e.preventDefault();
        }
    }
    // Clears the Search Input
    if (keyCode === 'Escape'){
        self.clean(e);
    }
    if (keyCode === 'Enter'){
        let scv = e.srcElement.value.slice(parseInt(self.component.name.length +1));
        self.component.value = scv;
        self.observable.trigger('ID_' + self.component._id, self.component);
        self.clean(e);
    }
    // TODO Fix
    if (self.state) {
        if (self.component.name.length > e.srcElement.value.length){
            self.state = false;
            self.update();
        }

    }
}

// Searching in the Database for the Items
searchQuery(e){
    self.state = Object.keys(self.component).length;
    if (!self.state) {
        self.observable.trigger('DB_queryItems', 'view_searchvalue', 'name',  e.srcElement.value);
    }
    if (self.state) {
        let scv = e.srcElement.value.slice(parseInt(self.component.name.length)+1);
        let selection = self.component.selection.split(',');
        self.observable.trigger('DB_querySelection', 'view_searchvalue', selection, scv);
    }
    // Resetting Values
    if(e.srcElement.value.length < 1 ){
        self.clean(e);
    }
    self.update();
}

setValue(e){
    let sb = document.getElementById('searchbar');
    let pos = e.srcElement.attributes.pos.value;
    
    if (!self.state){
        self.component = self.searchComponents[pos];
        sb.value = self.component.name + ' ';
        let selection = self.component.selection.split(',');
        self.observable.trigger('DB_querySelection', 'view_searchvalue', selection, '' );

    }
    else{
        sb.value = self.component.name + ' ' + self.searchComponents[pos].name;
        self.showList = false;
    }
    // Update and set the focus to Inputfield
    sb.focus();
    e.preventDefault();
    self.update();
}

this.observable.on('view_searchvalue', function(data){
    self.showList = Boolean(Number(data.length));
    self.searchComponents = data;
    self.update();
})
</script>
</view-searchbar>