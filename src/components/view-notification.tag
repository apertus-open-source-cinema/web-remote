<!-- 
    Notification 
    ==============

    Shows Notifications
    Current Verion is a simple implementation.
    TODO: Build a solid Version.

 -->
<view-notification>
    <!-- Layout -->
        <div class="fixed">
            <div each={ data, i in list }>
                <div id="toast" pos={ data.id } class="card-widget offset color-{data.type}" >
                    <h5>{ data.message }</h5>
                </div>
            </div>
        </div>
    <!-- Custom Style -->
    <style>
    @keyframes anim {
        0% {opacity: 0;}
        25% {opacity: 1; transform:translateX(-20px);}
        75% {opacity: 1; transform:translateX(-20px);}
        100% {opacity: 0;}
    }

    #toast{
        animation-name: anim;
        animation-duration: 3s;
        border-radius: 10px;
    }

    .offset{
        padding: 5px;
        margin: 10px;
    }
    .fixed {
        position: fixed;
        bottom: 0;
        right: 0;
        min-width: 200px;
    }
    .color-normal{
        background-color: #49d449;
    }
    .color-danger{
        background-color: #ff4040;
    }
    .color-warning{
        background-color: #fffb00;
    }
    </style>
    
    <!-- Script -->
    <script>
    // local 
    let self = this;
    
    // Mixin
    this.mixin(SharedMixin);

    this.list = [];

    removeMessage(e){
        if (e.animationName == "anim" && 
            e.type.toLowerCase().indexOf("animationend") >= 0) {
            let pos = e.srcElement.attributes.pos;
            let index = self.list.findIndex(x => x.id === pos);
            self.list.splice(index, 1);
            self.update();
        }
    }
    
    addMessage(message, type='normal'){
        let pos = self.list.length;
        self.list.unshift({"id": pos,"type": type, "message": message});
        self.update();
        document.getElementById('toast').addEventListener('animationend', self.removeMessage);
    }

    /**
     * OBSERVABLE
     */

    this.observable.on('notification', (message, type) => {
        self.addMessage(message, type);
    });
    </script>
</view-notification>