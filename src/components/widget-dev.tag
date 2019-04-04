<widget-dev>

<div class="marker">
    <div class="triangle-right"></div>
</div>
<div class="mover" id="mover" style="top: 100px;">
    <svg width="100" height="500">
        <defs>
            <linearGradient id="grad1" x1="0%" y1="0%" x2="100%" y2="0%">
                <stop offset="0%" style="stop-color:rgb(58, 58, 58);stop-opacity:1" />
                <stop offset="100%" style="stop-color:rgb(165, 165, 165);stop-opacity:1" />
            </linearGradient>
        </defs>
        <g transform="translate(10,{ i*40 })" each={ e,i in list }>
            <rect width="100" height="40" fill="url(#grad1)" />
            <text x="20" y="25">{ e }</text>
            <line x1="0" y1="20" x2="10" y2="20" />
        </g>
    </svg>
</div>
<div class="box" ondrag={drag} ondragstart={dragStartEnd} ondragend={dragStartEnd} draggable="true">
    <!-- Script -->
<style>
    .triangle-right {
	width: 0;
	height: 0;
	border-top: 10px solid transparent;
	border-left: 20px solid rgb(0, 0, 0);
	border-bottom: 10px solid transparent;
    }
    .marker{
        position: absolute;
        margin-left: 0px;
        top: 110px;
    }
    .mover{
        /* width: 100px;
        height: 100px; */
        background:blueviolet;
        position: absolute;
        clip-path: inset(0px 0px 10px 10px);
        margin-left: 20px;
    }
    .hide{
        opacity: 0;
    }
    .box{
        width: 100px;
        height: 100px;
        position: absolute;
        top:100px;
        margin-left: 20px;
        cursor: s-resize;
    }
    text{
        font-size: 20px;
        font-weight: 600;
    }
    line {
        stroke: rgb(0, 0, 0);
        stroke-width: 2;
    }

</style>
<script>
    // local 
    let self = this;
    
    // Mixin
    this.mixin(SharedMixin);
    
    // local Variable
    this.list = ['hello', 'test', 'bla', 'sdfdsf'];
    this.pos = 0;
    this.y_drag = 0;
    // Configuration
    this.conf_steps = 40;

    dragStartEnd(e){
        let dragY = e.y;
        self.y_drag = dragY; 
        e.srcElement.classList.toggle('hide');
    }

    drag(e){
        let mov = document.getElementById('mover');
        let divY = e.y - self.y_drag ;
        if (divY > self.conf_steps || divY < -self.conf_steps && divY > -self.conf_steps*1.5 ) {
            if (divY > self.conf_steps) {
                if(self.pos > 0){
                    mov.style.top = (parseInt(mov.style.top, 10) + self.conf_steps) + 'px';
                    self.y_drag += self.conf_steps;
                    self.pos--;
                }
            } else {
                if (self.pos < self.list.length-1) {
                    mov.style.top = (parseInt(mov.style.top, 10) - self.conf_steps) + 'px';
                    self.y_drag -= self.conf_steps;
                    self.pos++;
                }
            }
        }
    }

</script>

</widget-dev>