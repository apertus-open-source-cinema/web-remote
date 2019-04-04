<!-- 

    Widget Card
    ===========

    Default Widget Shows Values.

 -->
<widget-element>
<!-- Card -->
<div class="card box" id={ id } hide={ listView }>
    <div class="full-element" onclick={ toggleSize }>
        <div class="center">
            <h5>{ title }</h5>
            <h4 class="center-text">{ value }</h4>
        </div>
    </div>
</div>
<!-- Modal Window -->
<div class="modal" if={ stateBig }> 
    <div class="full" onclick={ toggleSize } />
    <div class="card box-active modal-content">
        <header class="content">
            <div class="center">
                <h5>{ title }</h5>
                <i onclick={ toggleSize } class="right icon icon-call_received md-24"></i>
            </div>
        </header>
        <!-- Slider -->
        <section class="section-slider">

        <div class="marker">
            <div class="triangle-right"></div>
        </div>

            <div class="clipping">
                <div class="mover" id="mover" style="top:100px;">
                    <svg width="100" height="1000"> <!-- TODO needs a better solution -->
                        <defs>
                            <linearGradient id="grad1" x1="0%" y1="0%" x2="100%" y2="0%">
                                <stop offset="0%" style="stop-color:rgb(58, 58, 58);stop-opacity:1" />
                                <stop offset="100%" style="stop-color:rgb(165, 165, 165);stop-opacity:1" />
                            </linearGradient>
                        </defs>
                        <!-- <rect width="100" height="100%" fill="url(#grad1)" /> -->
                        <rect width="100" height="100%" fill="#111" />
                        <g transform="translate(10,{ i*40 })" each={ e,i in selection }>
                            <text x="20" y="25" fill="#fff">{ e }</text>
                            <line x1="0" y1="20" x2="10" y2="20" style="stroke:rgb(255, 255, 255);stroke-width:2"/>
                        </g>
                    </svg>
                </div>
            </div>
            <div class="drag_box" ondrag={drag} ondragstart={dragStartEnd} ondragend={dragStartEnd} draggable="true">
        </section>
            <!-- END -->
            <!-- Buttons -->
            <footer class="footer-modal">
                <i onclick={ setToDefault } title="Set to Default" class="right-bottom icon icon-settings_backup_restore md-36"></i>
            </footer>
        </div>
<!-- List View
<div show={ listView }>
    <button type="button" class="butt ">
        <b>{ title }</b> { value }
    </button>
</div> -->
<!-- Custom Style -->
<style>
    .section-slider{
        height: 200px;
    }
    .footer-modal{
        height: 2rem;
    }
    .triangle-right {
        width: 0;
        height: 0;
        border-top: 10px solid transparent;
        border-left: 20px solid rgb(150, 150, 150);
        border-bottom: 10px solid transparent;
    }
    .marker{
        position: relative;
        margin-left: 5px;
        top: 30px; 
    }
    .mover{
        position: absolute;
        /* clip-path: inset(0px 0px 10px 10px); */
        margin-left: 20px;
    }
    .clipping{
        position: absolute;
        clip: rect(10px, 190px, 190px, 10px);
    }
    .hide{
        opacity: 0;
    }
    .drag_box{
        width: 100px;
        height: 190px;
        position: absolute;
        /* top:100px; */
        margin-left: 20px;
        /* background:rgba(137, 43, 226, 0.192); */
        cursor: s-resize;
    }
    .full{
        width: 100%;
        height: 100%;
        position: absolute;
        left: 0;
        top: 0;
    }
    .value {
        font-size: 22px;
    }
    .full-element{
        width: 100%;
        height: 100%;
    }
    .content {
        position: relative;
    }
    .right{
        position: absolute;
        top: 5px;
        right: 5px;
    }
    .right-bottom{
        float: right
    }
    .center {
        text-align: center;
    }
    .box {
        margin: 5px;
        width:  9rem;
        height: 100px;
        transition: 0s;
    }
    .box-active {
        margin: auto;
        width:  18rem;
        transition: 0s;
    }
    .butt-default{
        margin: 10px;
        position:inherit;
    }
</style>
<!-- Code -->
<script>
// local 
let self = this;

// Mixin
this.mixin(SharedMixin);

// Getting the Object Data 
this.dataObject = opts.data;

// Set Values
this.id = this.dataObject._id;
this.title = this.dataObject.ui.name;
this.value = this.dataObject.currentValue;
this.selection = this.dataObject.possibleValues;

this.stateBig = false;

this.pos = 0;
this.y_drag = 0;
// Configuration
this.conf_steps = 40;

dragStartEnd(e){
    let dragY = e.y;
    self.y_drag = dragY; 
    e.srcElement.classList.toggle('hide');
    self.update();
}

drag(e){
    let mov = document.getElementById('mover');
    let divY = e.y - self.y_drag ;
    if (divY > self.conf_steps || divY < -self.conf_steps && divY > -self.conf_steps*1.5 ) {
        if (divY > self.conf_steps) {
            if(self.pos > 0){
                self.y_drag += self.conf_steps;
                self.pos--;
                self.posSlider();
                self.posOnChange(self.pos);
            }
        } else {
            if (self.pos < self.selection.length-1) {
                self.y_drag -= self.conf_steps;
                self.pos++;
                self.posSlider();
                self.posOnChange(self.pos);
            }
        }
    }
}

posSlider(){
    // New Slider
    let mov = document.getElementById('mover');
    mov.style.top =  -(self.conf_steps*self.pos) + 'px';
}

posOnChange(pos) {
    self.dataObject.value = self.selection[pos];
    self.value = self.selection[pos];

    self.updateValue();
    self.update();
}

toggleSize(e){
    self.stateBig = !self.stateBig;
    self.update();
    self.posSlider();
}

updateValue(){
    self.observable.trigger('ID_' + self.dataObject._id, self.dataObject);
}

/**
 * OBSERVABLE
 */

// On ID 
this.observable.on('ID_' + this.id, function(data){
    let result = validateDataset(self.dataObject, data.value);
    self.observable.trigger('notification', ''.concat('iD: ', self.id, ' Value: ', data.value ));
    console.log('validation:', self.id, result);
    if (result === true) {
        self.value = data.value;
    }
    self.update();
})

</script>
</widget-element>