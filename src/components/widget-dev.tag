<widget-dev>
    <div style="width: 7em; height: 20em; overflow: scroll;">
        <svg width="100" height="1000">
            <defs>
            <linearGradient id="grad1" x1="0%" y1="0%" x2="100%" y2="0%">
                <stop offset="0%" style="stop-color:rgb(58, 58, 58);stop-opacity:1" />
                <stop offset="100%" style="stop-color:rgb(165, 165, 165);stop-opacity:1" />
            </linearGradient>
            </defs>
            
            <g transform="translate(10,{ i*100 + 20  })" each={ e,i in list }>
            <rect width="100" height="100" fill="url(#grad1)" />
            <text x="20" y="45">{ e }</text>
            <line x1="0" y1="0" x2="10" y2="0" />
            <line x1="0" y1="20" x2="10" y2="20" />
            <line x1="0" y1="40" x2="15" y2="40" />
            <line x1="0" y1="60" x2="10" y2="60" />
            <line x1="0" y1="80" x2="10" y2="80" />
            </g>
        </svg>
    </div>
<!-- Script -->
<style>
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

</script>

</widget-dev>