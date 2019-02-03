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
                <div class="card-widget offset color-{data.type}" >
                    <h5>{ data.message }</h5>
                </div>
            </div>
        </div>
    <!-- Custom Style -->
    <style>
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
        background-color: #b1b1b1;
    }
    .color-danger{
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
    this.time = 3000;


    /**
     * OBSERVABLE
     */

    this.observable.on('*', (event, data) => {
        let pos = self.list.length;
        self.list.unshift({"id": pos,"type":"normal", "message":event});
        setTimeout((pos) => {
            let index = self.list.findIndex(x => x.id === pos);
            self.list.splice(index, 1);
            self.update();
        }, self.time);
        self.update();
    });

    this.observable.on('notification', (message, type) => {
        let pos = self.list.length;
        self.list.unshift({"id": pos,"type": type, "message": message});
        setTimeout((pos) => {
            let index = self.list.findIndex(x => x.id === pos);
            self.list.splice(index, 1);
            self.update();
        }, self.time);
        self.update();
    });

    </script>
</view-notification>
