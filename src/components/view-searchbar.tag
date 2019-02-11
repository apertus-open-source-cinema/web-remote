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
            <input id="searchbar" aria-label="Searchbar" autofocus onkeydown={ onKeyPress } onkeyup={ onKeyUp } oninput={ searchbarInput } type="text" class="form-control" placeholder="Search">
        </div>
        <div show={ showList } class="dropdown-content">
            <div each={ item, i in list } >
                <div class="list" onclick={ setValue } pos={ item.pos }><h6>{ item.value }</h6></div>
            </div>
        </div>
    </div>

<!-- Custom Style -->
<style>
    .list{
        padding: 0.2rem;
    }
    .list:hover{
        background-color:#dadada;
    }
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
        margin-left: 10px;
        background-color: #f9f9f9;
        min-width: 160px;
        box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
        /* padding: 12px 16px; */
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
this.list = [];
this.showList = false;
this.item = '';
this.itemSelectionPos = '';
this.components = [];


// Clean up all Values when there is no search value
clean(e){
    e.srcElement.value = '';
    self.list = [];
    self.components = [];
    self.item = '';
    self.itemSelectionPos = '';
    this.showList = false;
    self.update();
}

/**
 * Searchbar
*/

this.observable.on('view_setItemName', (pos) =>{
    let sb = document.getElementById('searchbar');
    if(sb.value.length < self.item.name.length){
        sb.value = self.item.name + ' ';
    }
    else{
        self.itemSelectionPos = pos; // TODO fix
        sb.value = self.item.name + ' ' + self.item.selection[0];
    }
});

searchbarInput(e){
    console.log("key event");
    if (self.item === '') {
        self.searchQuery(e);
    }
    else{
        // Search in Selection from Item
        let inputString = e.srcElement.value;
        let name = self.item.name;
        let length = name.length;
        let searchValue = inputString.slice(length+1);

        if (inputString.slice(0, length) !== name) {
            self.item = '';
        }

        let find = [];
        for (let i = 0; i < self.list.length; i++){
            if(self.list[i].value.search(searchValue) != -1){
                find.push(self.list[i]);
            }
        }
        self.list = find; 

        // if (searchValue === '') {
        //     self.observable.trigger('view_searchvalue', self.item.selection);
        // }   
    }
}

/**
 *  Key Events
 */

// Clears the Search Input
onKeyEsc(e){
    self.clean(e);
}

onKeyEnter(e){

    self.item.value = self.item.selection[self.itemSelectionPos];
    self.observable.trigger('ID_' + self.item._id, self.item);
    self.clean(e);
}

onKeyPress(e){
    let keyCode = e.code;
    if (keyCode === 'Tab'){
        self.observable.trigger('view_selectionvalue', 0);  // 0 -> First Element
        e.preventDefault();
        }
    if (keyCode === 'Escape'){
        self.onKeyEsc(e)
        e.preventDefault();
    }
    if (keyCode === 'Enter'){
        self.onKeyEnter(e);
        e.preventDefault();
    }
}

onKeyUp(e){
    let keyCode = e.code;
    if (keyCode === 'Backspace'){
        if (e.srcElement.value === ''){
            self.clean(e);
        }
        e.preventDefault();
    }
}

/**
 * Helper Functions
*/

stringToListArray(item){
    let list= [];
        let data = item.selection.split(',');
        for (let i = 0; i < data.length; i++) {
            list.push({"value" : data[i], "pos": i});
        }
    return list;
}

/**
 *  List
 */ 

this.observable.on('view_showList', (data) =>{
    self.list = data;
    self.showList = Boolean(Number(data.length));
    self.update();
});

/**
 * Search Querys
*/

// Search Items
searchQuery(e){
    self.observable.trigger('DB_queryItems', self.db_table, 'view_searchvalue', 'name',  e.srcElement.value);
}

// Get all Items that matches (makes a simple array)
this.observable.on('view_searchvalue', (data) =>{
    self.components = data;
    let list = [];
    for (let i = 0; i < data.length; i++) {
        list.push({"value" : data[i].name, "pos": i});
    }
    console.log("view_searchvalue",list);
    self.observable.trigger('view_showList', list);
});

// Get all selection values in the Item
this.observable.on('view_selectionvalue', (pos) =>{
    if(self.item === ''){
        self.item = self.components[pos];
        self.observable.trigger('view_showList', self.stringToListArray(self.item));
        self.observable.trigger('view_setItemName', pos);
    }
    else{
        self.observable.trigger('view_showList', self.stringToListArray(self.item));
    }
});

</script>
</view-searchbar>