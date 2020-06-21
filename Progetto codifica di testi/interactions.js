window.onload = kit_image;


var aree = [];
var lines = [];
var i;

function kit_image() {
    aree = document.getElementsByTagName("area");
    lines = document.getElementsByTagName("span");
    for (i=0;i<aree.length;i++) {
        aree[i].onmouseover = Evidenzia;
        aree[i].onmouseout = spegni;
    }
    start()
    
}

function Evidenzia() {
    var target = this.getAttribute("class");
    var light = document.getElementsByClassName(target);
    light[0].setAttribute("style", "fill:red;")
    for (i=1;i<light.length; i++) {
        light[i].setAttribute("style", "background-color: #ffdf7c");
    }
}

function spegni() {
    var target = this.getAttribute("class");
    var light = document.getElementsByClassName(target);
    for (i=0; i <light.length; i++){
        light[i].removeAttribute("style");
    }
    
}

function start() {


  var zoomer = function () {
    document.getElementById('img_letter')
      .addEventListener('mousemove', function (e) {

        var original = document.getElementById('small_letter'),
          magnified = document.getElementById('big_letter'),
          style = magnified.style,
          x = e.pageX - this.offsetLeft,
          y = e.pageY - this.offsetTop,
          imgWidth = original.width,
          imgHeight = original.height,
          xperc = ((x / imgWidth) * 100),
          yperc = ((y / imgHeight) * 100);

        if (x > (.01 * imgWidth)) {
          xperc += (.15 * xperc);
        };

        if (y >= (.01 * imgHeight)) {
          yperc += (.05 * yperc);
        };

        style.backgroundPositionX = (xperc - 9) + '%';
        style.backgroundPositionY = (yperc - 9) + '%';

        style.left = (x - 180) + 'px';
        style.top = (y - 180) + 'px';

      }, false);
  }();
}