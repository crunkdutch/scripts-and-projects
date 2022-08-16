var BANNER_WIDTH = 300;
var BANNER_HEIGHT = 250;
var carouselArray = [];
var currentItem = 0;
var feedProducts;
var last_arrow;
var lcounter = 0;
var myFT = new FT(); 
var phArray = [];
var pIndex = -1;

var ajaxhandler = {
    complete : function(request){ 
        try {
            if (request.status === 200) {
                console.log(request, ' full response Object'); 
                console.log(JSON.parse(request.response), ' parsed JSON Object');
                feedProducts = JSON.parse(request.response);
                carousel.setCarousel(feedProducts);

            }
        }
        catch(e) {
            console.log(e,' failed to load web service - default image will load');
            var img = new Image();
            img.src = 'images/ad_failed_backup.jpg';
            img.onload = function(){
                container.appendChild(img);
            }
        }
    }
}

var creative = {
	init : function(){
		myFT.addEventListener("instantads", function() {
			console.log('instantads are loaded---------');
  
            arrow_holder.innerHTML = "<div id='arrow_left'></div></div>";
            arrow_holder.innerHTML += "<div id='arrow_right'class='rotater'></div>";
            arrow_left = FT.query('#arrow_left');
            arrow_right = FT.query('#arrow_right');

            btn_cta_text.textContent = myFT.instantAds.cta_text;
            btn_cta_text.style.top = (btn_cta.clientHeight - btn_cta_text.clientHeight) / 2 + 'px';
            btn_cta_text.style.left = (btn_cta.clientWidth - btn_cta_text.clientWidth) / 2 + 'px';

            FT.ajax(myFT.instantAds.feed_endpoint, ajaxhandler);
		});
	},

    goBanner : function() {
        console.log('goBanner');
        carousel.addListeners();
        carousell.style.visibility = 'visible';
        arrow_holder.style.visibility = 'visible';
        btn_cta.style.visibility = 'visible';
    }
}

var carousel = {
    addHandlers : function() {
        var imgs = carousell.getElementsByTagName('img');
        var tmpCounter = 0;
        var errorCounter = 0;
        for (var j = 0; j < imgs.length; j++){
            imgs[j].onload = function(){
                if ((tmpCounter + errorCounter) === imgs.length - 1){
                    carousel.positionCarouselObjects();
                }
                tmpCounter ++;
            }

          

            imgs[j].onerror = function(event){
                console.log('which image broke', event.target.src);
                event.target.src = 'images/default_image_300x250.jpg';
                event.target.onload = function(){
                    errorCounter ++;
                }
            }
        }

    },

    addListeners : function() {
        console.log('addListeners');
        arrow_left.addEventListener('click', carousel.leftClicker);
        arrow_right.addEventListener('click', carousel.rightClicker);
    },

    checkIndex : function() {
        if (pIndex < 0) pIndex = phArray.length - 1;
        if (pIndex > phArray.length - 1 ) pIndex = 0;
    },

    leftClicker : function(event) {
        console.log('leftClicker');
        arrow_left.removeEventListener('click', carousel.leftClicker);
        carousel.checkIndex();
        phArray[pIndex].style.left = -205 + 'px';
        carousel.slideCarousel("+=205");
        pIndex--;
        currentItem--;

        if (currentItem < 0) currentItem = phArray.length - 1;
        if (currentItem > phArray.length - 1 ) currentItem = 0;
        
        last_arrow = arrow_left;
        console.log(last_arrow.id, ' what is the last arrow we clicked');
    },

    positionCarouselObjects : function() {
        console.log('positionCarouselObjects');
        var ph = carousel_holder.getElementsByClassName('product_holder');
        phArray = ph;
        var imgs = carousell.getElementsByTagName('img');
        for (var j = 0; j < imgs.length; j++){
            if (imgs[j].height > 90 ){
                imgs[j].height = 90;
                
            }

            if (imgs[j].width > 110){
                imgs[j].width = 110;
            }


            imgs[j].style.left += (196 - imgs[j].width) / 2 + 'px';
            imgs[j].style.top += 53 + (125 - imgs[j].height) / 2 + 'px';

        }


        for (var k = 0; k < ph.length; k++){
            ph[k].style.left = (205 * k) + 'px';
            ph[k].addEventListener('click', creative.productClicker);
        }

        btn_invis.addEventListener('click', carousel.productClicker);
        btn_cta.addEventListener('click', carousel.productClicker);
        carousell.addEventListener('click', carousel.productClicker);
        creative.goBanner();
    },

    productClicker : function(event) {
        myFT.clickTag(currentItem + 1, feedProducts[currentItem].link);
    },


    rightClicker : function(event){
        console.log('rightClicker');
        arrow_right.removeEventListener('click', carousel.rightClicker);      
        carousel.checkIndex();
        phArray[pIndex].style.left = (phArray.length - 1) * 205 + 'px';
        carousel.slideCarousel("-=205");
        pIndex++;
        currentItem ++;

        if (currentItem < 0) currentItem = phArray.length - 1;
        if (currentItem > phArray.length - 1 ) currentItem = 0;
        
        last_arrow = arrow_right;
        console.log(last_arrow.id, ' what is the last arrow we clicked');
    },

    setCarousel : function(carouselObjects) {
        console.log(carouselObjects.length, ' ----------length');

        for (var i = 0; i < carouselObjects.length; i++){
            var carouselDiv = "<div class='product_holder' id="+i+"><p>" + carouselObjects[i].brand + " : "  + 
                carouselObjects[i].title + "</p><img src=" + unescape(carouselObjects[i].image_link_cached) + "></div>";
            
            carousel_holder.innerHTML += carouselDiv;
         }

        product_holder = FT.query('.product_holder');
        phArray = product_holder;

        carousel.addHandlers();
    },

    slideCarousel : function (direction) {
        var ph = carousel_holder.getElementsByClassName('product_holder');
        for (var i = 0; i < ph.length; i++){
            var prod = ph[i];
            TweenLite.to(prod, 0.5, { left : direction, ease : Sine.easeOut,
                onComplete : function(){
                        if (lcounter === (ph.length - 1)){
                            switch (last_arrow.id) {
                                case 'arrow_left' :
                                    arrow_left.addEventListener('click', carousel.leftClicker);
                                break;

                                case 'arrow_right' :
                                    arrow_right.addEventListener('click', carousel.rightClicker);
                                break;
                            }

                            lcounter = -1;
                        }
                        lcounter ++
                    }
                }
            );
        }
    }
}

var helpers = {
    addCommas : function(val) {
        while (/(\d+)(\d{3})/.test(val.toString())){
            val = val.toString().replace(/(\d+)(\d{3})/, '$1'+','+'$2');
        }
        return val;
    },

    stripText : function(str, max, len) {
        var newStr;
        if (str.length > max) {
            newStr = str.substr(0, len);
            newStr = newStr + '...';
            return newStr;
        }
        else{
            return str;
        }
    },

    autosize : function(txt, txtWidth) {
        var maxTextWidth = txtWidth; 
        if (txt.clientWidth > maxTextWidth){      
            txt.style.fontSize = 'smaller';         
        }
    }
}

window.onload = function() {
	console.log('window.onload----------');
	creative.init();	
}