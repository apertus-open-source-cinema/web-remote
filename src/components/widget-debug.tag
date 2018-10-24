<widget-debug>
    <button class="button-custom btn btn-danger" onclick="db.deleteDB()">Delete Database</button>
    <button class="button-custom btn btn-info" onclick="db.infoDB()">About Database</button>
    <button class="button-custom btn btn-info" onclick="db.getAll()">Get All Item</button>
    <button class="button-custom btn btn-info" onclick="db.deleteAll()">Delete All Item</button>
    <button class="button-custom btn btn-dark" onclick={ addComponents }>Add Item</button>
    <button class="button-custom btn btn-warning" onclick={ getPage }>Get Item</button>
<style> 
.button-custom {
    margin: 2px;
}
</style>
<script>

 

addComponent(e){
    this.list.forEach(element => {
        db.put(element)
    });
}

addComponents(){
    for (let index = 0; index < 100; index++) {
        var v = { "_id": new Date().toISOString() + index, "name":"page_03", "pos":"2", "components": ["id_01", "id_03"]}
        db.put(v)
        
    }
}

getPage(){
    console.log("getPage")
    console.log(db)
    db.query(function (doc, emit) {
        emit(doc.name)
    }, {key: 'name_01'}).then(function (result) {
        console.log(result)
    }).catch(function (err) {
        console.log(result)
    });
}

addPage(){
    console.log('add page')
}

</script>

</widget-debug>