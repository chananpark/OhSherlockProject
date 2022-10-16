<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>

<%--  
┌─────┐ ┌─┐ ┌─┐ ┌─┐ ┌────┐ ┌─┐ ┌─┐ ┌─────┐ ┌─────┐  ┌─┐     ┌─────┐ ┌────┐ ┌─────┐
│ ┌─┐ │ │ │ │ │ │ │ │ ┌──┘ │ │ │ │ │ ┌───┘ │ ┌─┐ │  │ │     │ ┌─┐ │ │ ┌──┘ │ ┌───┘   
│ │ │ │ │ └─┘ │ │ │ │ └──┐ │ └─┘ │ │ └───┐ │ └─┘ └┐ │ │     │ │ │ │ │ │    │ └───┐ 
│ │ │ │ │ ┌─┐ │ └─┘ └──┐ │ │ ┌─┐ │ │ ┌───┘ │ ┌──┐ │ │ │     │ │ │ │ │ │    │ ┌─┐ │
│ └─┘ │ │ │ │ │ ┌─┐ ┌──┘ │ │ │ │ │ │ └───┐ │ │  │ │ │ └───┐ │ └─┘ │ │ └──┐ │ │ │ │
└─────┘ └─┘ └─┘ └─┘ └────┘ └─┘ └─┘ └─────┘ └─┘  └─┘ └─────┘ └─────┘ └────┘ └─┘ └─┘
--%>

<style>

@-webkit-keyframes fall {
    0% {
        opacity: 0.9;
        top: 0
    }
    100% {
        opacity: 0.2;
        top: 100%
    }
}

@-o-keyframes fall {
    0% {
        opacity: 0.9;
        top: 0
    }
    100% {
        opacity: 0.2;
        top: 100%
    }
}

@-ms-keyframes fall {
    0% {
        opacity: 0.9;
        top: 0
    }
    100% {
        opacity: 0.2;
        top: 100%
    }
}

@-moz-keyframes fall {
    0% {
        opacity: 0.9;
        top: 0
    }
    100% {
        opacity: 0.2;
        top: 100%
    }
}

@keyframes fall {
    0% {
        opacity: 0.9;
        top: 0
    }
    100% {
        opacity: 0.2;
        top: 100%
    }
}

@-webkit-keyframes blow-soft-left {
    0% {
        margin-left: 0
    }
    100% {
        margin-left: -50%
    }
}

@-o-keyframes blow-soft-left {
    0% {
        margin-left: 0
    }
    100% {
        margin-left: -50%
    }
}

@-ms-keyframes blow-soft-left {
    0% {
        margin-left: 0
    }
    100% {
        margin-left: -50%
    }
}

@-moz-keyframes blow-soft-left {
    0% {
        margin-left: 0
    }
    100% {
        margin-left: -50%
    }
}

@keyframes blow-soft-left {
    0% {
        margin-left: 0
    }
    100% {
        margin-left: -50%
    }
}

@-webkit-keyframes blow-medium-left {
    0% {
        margin-left: 0
    }
    100% {
        margin-left: -100%
    }
}

@-o-keyframes blow-medium-left {
    0% {
        margin-left: 0
    }
    100% {
        margin-left: -100%
    }
}

@-ms-keyframes blow-medium-left {
    0% {
        margin-left: 0
    }
    100% {
        margin-left: -100%
    }
}

@-moz-keyframes blow-medium-left {
    0% {
        margin-left: 0
    }
    100% {
        margin-left: -100%
    }
}

@keyframes blow-medium-left {
    0% {
        margin-left: 0
    }
    100% {
        margin-left: -100%
    }
}

@-webkit-keyframes blow-soft-right {
    0% {
        margin-left: 0
    }
    100% {
        margin-left: 50%
    }
}

@-o-keyframes blow-soft-right {
    0% {
        margin-left: 0
    }
    100% {
        margin-left: 50%
    }
}

@-ms-keyframes blow-soft-right {
    0% {
        margin-left: 0
    }
    100% {
        margin-left: 50%
    }
}

@-moz-keyframes blow-soft-right {
    0% {
        margin-left: 0
    }
    100% {
        margin-left: 50%
    }
}

@keyframes blow-soft-right {
    0% {
        margin-left: 0
    }
    100% {
        margin-left: 50%
    }
}

@-webkit-keyframes blow-medium-right {
    0% {
        margin-left: 0
    }
    100% {
        margin-left: 100%
    }
}

@-o-keyframes blow-medium-right {
    0% {
        margin-left: 0
    }
    100% {
        margin-left: 100%
    }
}

@-ms-keyframes blow-medium-right {
    0% {
        margin-left: 0
    }
    100% {
        margin-left: 100%
    }
}

@-moz-keyframes blow-medium-lerightft {
    0% {
        margin-left: 0
    }
    100% {
        margin-left: 100%
    }
}

@keyframes blow-medium-right {
    0% {
        margin-left: 0
    }
    100% {
        margin-left: 100%
    }
}

@-webkit-keyframes sway-0 {
    0% {
        -webkit-transform: rotate(-5deg)
    }
    40% {
        -webkit-transform: rotate(28deg)
    }
    100% {
        -webkit-transform: rotate(3deg)
    }
}

@-o-keyframes sway-0 {
    0% {
        -o-transform: rotate(-5deg)
    }
    40% {
        -o-transform: rotate(28deg)
    }
    100% {
        -o-transform: rotate(3deg)
    }
}

@-ms-keyframes sway-0 {
    0% {
        -ms-transform: rotate(-5deg)
    }
    40% {
        -ms-transform: rotate(28deg)
    }
    100% {
        -ms-transform: rotate(3deg)
    }
}

@-moz-keyframes sway-0 {
    0% {
        -moz-transform: rotate(-5deg)
    }
    40% {
        -moz-transform: rotate(28deg)
    }
    100% {
        -moz-transform: rotate(3deg)
    }
}

@keyframes sway-0 {
    0% {
        transform: rotate(-5deg)
    }
    40% {
        transform: rotate(28deg)
    }
    100% {
        transform: rotate(3deg)
    }
}

@-webkit-keyframes sway-1 {
    0% {
        -webkit-transform: rotate(10deg)
    }
    40% {
        -webkit-transform: rotate(43deg)
    }
    100% {
        -webkit-transform: rotate(15deg)
    }
}

@-o-keyframes sway-1 {
    0% {
        -o-transform: rotate(10deg)
    }
    40% {
        -o-transform: rotate(43deg)
    }
    100% {
        -o-transform: rotate(15deg)
    }
}

@-ms-keyframes sway-1 {
    0% {
        -ms-transform: rotate(10deg)
    }
    40% {
        -ms-transform: rotate(43deg)
    }
    100% {
        -ms-transform: rotate(15deg)
    }
}

@-moz-keyframes sway-1 {
    0% {
        -moz-transform: rotate(10deg)
    }
    40% {
        -moz-transform: rotate(43deg)
    }
    100% {
        -moz-transform: rotate(15deg)
    }
}

@keyframes sway-1 {
    0% {
        transform: rotate(10deg)
    }
    40% {
        transform: rotate(43deg)
    }
    100% {
        transform: rotate(15deg)
    }
}

@-webkit-keyframes sway-2 {
    0% {
        -webkit-transform: rotate(15deg)
    }
    40% {
        -webkit-transform: rotate(56deg)
    }
    100% {
        -webkit-transform: rotate(22deg)
    }
}

@-o-keyframes sway-2 {
    0% {
        -o-transform: rotate(15deg)
    }
    40% {
        -o-transform: rotate(56deg)
    }
    100% {
        -o-transform: rotate(22deg)
    }
}

@-ms-keyframes sway-2 {
    0% {
        -ms-transform: rotate(15deg)
    }
    40% {
        -ms-transform: rotate(56deg)
    }
    100% {
        -ms-transform: rotate(22deg)
    }
}

@-moz-keyframes sway-2 {
    0% {
        -moz-transform: rotate(15deg)
    }
    40% {
        -moz-transform: rotate(56deg)
    }
    100% {
        -moz-transform: rotate(22deg)
    }
}

@keyframes sway-2 {
    0% {
        transform: rotate(15deg)
    }
    40% {
        transform: rotate(56deg)
    }
    100% {
        transform: rotate(22deg)
    }
}

@-webkit-keyframes sway-3 {
    0% {
        -webkit-transform: rotate(25deg)
    }
    40% {
        -webkit-transform: rotate(74deg)
    }
    100% {
        -webkit-transform: rotate(37deg)
    }
}

@-o-keyframes sway-3 {
    0% {
        -o-transform: rotate(25deg)
    }
    40% {
        -o-transform: rotate(74deg)
    }
    100% {
        -o-transform: rotate(37deg)
    }
}

@-ms-keyframes sway-3 {
    0% {
        -ms-transform: rotate(25deg)
    }
    40% {
        -ms-transform: rotate(74deg)
    }
    100% {
        -ms-transform: rotate(37deg)
    }
}

@-moz-keyframes sway-3 {
    0% {
        -moz-transform: rotate(25deg)
    }
    40% {
        -moz-transform: rotate(74deg)
    }
    100% {
        -moz-transform: rotate(37deg)
    }
}

@keyframes sway-3 {
    0% {
        transform: rotate(25deg)
    }
    40% {
        transform: rotate(74deg)
    }
    100% {
        transform: rotate(37deg)
    }
}

@-webkit-keyframes sway-4 {
    0% {
        -webkit-transform: rotate(40deg)
    }
    40% {
        -webkit-transform: rotate(68deg)
    }
    100% {
        -webkit-transform: rotate(25deg)
    }
}

@-o-keyframes sway-4 {
    0% {
        -o-transform: rotate(40deg)
    }
    40% {
        -o-transform: rotate(68deg)
    }
    100% {
        -o-transform: rotate(25deg)
    }
}

@-ms-keyframes sway-4 {
    0% {
        -ms-transform: rotate(40deg)
    }
    40% {
        -ms-transform: rotate(68deg)
    }
    100% {
        -ms-transform: rotate(25deg)
    }
}

@-moz-keyframes sway-4 {
    0% {
        -moz-transform: rotate(40deg)
    }
    40% {
        -moz-transform: rotate(68deg)
    }
    100% {
        -moz-transform: rotate(25deg)
    }
}

@keyframes sway-4 {
    0% {
        transform: rotate(40deg)
    }
    40% {
        transform: rotate(68deg)
    }
    100% {
        transform: rotate(25deg)
    }
}

@-webkit-keyframes sway-5 {
    0% {
        -webkit-transform: rotate(50deg)
    }
    40% {
        -webkit-transform: rotate(78deg)
    }
    100% {
        -webkit-transform: rotate(40deg)
    }
}

@-o-keyframes sway-5 {
    0% {
        -o-transform: rotate(50deg)
    }
    40% {
        -o-transform: rotate(78deg)
    }
    100% {
        -o-transform: rotate(40deg)
    }
}

@-ms-keyframes sway-5 {
    0% {
        -ms-transform: rotate(50deg)
    }
    40% {
        -ms-transform: rotate(78deg)
    }
    100% {
        -ms-transform: rotate(40deg)
    }
}

@-moz-keyframes sway-5 {
    0% {
        -moz-transform: rotate(50deg)
    }
    40% {
        -moz-transform: rotate(78deg)
    }
    100% {
        -moz-transform: rotate(40deg)
    }
}

@keyframes sway-5 {
    0% {
        transform: rotate(50deg)
    }
    40% {
        transform: rotate(78deg)
    }
    100% {
        transform: rotate(40deg)
    }
}

@-webkit-keyframes sway-6 {
    0% {
        -webkit-transform: rotate(65deg)
    }
    40% {
        -webkit-transform: rotate(92deg)
    }
    100% {
        -webkit-transform: rotate(58deg)
    }
}

@-o-keyframes sway-6 {
    0% {
        -o-transform: rotate(65deg)
    }
    40% {
        -o-transform: rotate(92deg)
    }
    100% {
        -o-transform: rotate(58deg)
    }
}

@-ms-keyframes sway-6 {
    0% {
        -ms-transform: rotate(65deg)
    }
    40% {
        -ms-transform: rotate(92deg)
    }
    100% {
        -ms-transform: rotate(58deg)
    }
}

@-moz-keyframes sway-6 {
    0% {
        -moz-transform: rotate(65deg)
    }
    40% {
        -moz-transform: rotate(92deg)
    }
    100% {
        -moz-transform: rotate(58deg)
    }
}

@keyframes sway-6 {
    0% {
        transform: rotate(65deg)
    }
    40% {
        transform: rotate(92deg)
    }
    100% {
        transform: rotate(58deg)
    }
}

@-webkit-keyframes sway-7 {
    0% {
        -webkit-transform: rotate(72deg)
    }
    40% {
        -webkit-transform: rotate(118deg)
    }
    100% {
        -webkit-transform: rotate(68deg)
    }
}

@-o-keyframes sway-7 {
    0% {
        -o-transform: rotate(72deg)
    }
    40% {
        -o-transform: rotate(118deg)
    }
    100% {
        -o-transform: rotate(68deg)
    }
}

@-ms-keyframes sway-7 {
    0% {
        -ms-transform: rotate(72deg)
    }
    40% {
        -ms-transform: rotate(118deg)
    }
    100% {
        -ms-transform: rotate(68deg)
    }
}

@-moz-keyframes sway-7 {
    0% {
        -moz-transform: rotate(72deg)
    }
    40% {
        -moz-transform: rotate(118deg)
    }
    100% {
        -moz-transform: rotate(68deg)
    }
}

@keyframes sway-7 {
    0% {
        transform: rotate(72deg)
    }
    40% {
        transform: rotate(118deg)
    }
    100% {
        transform: rotate(68deg)
    }
}

@-webkit-keyframes sway-8 {
    0% {
        -webkit-transform: rotate(94deg)
    }
    40% {
        -webkit-transform: rotate(136deg)
    }
    100% {
        -webkit-transform: rotate(82deg)
    }
}

@-o-keyframes sway-8 {
    0% {
        -o-transform: rotate(94deg)
    }
    40% {
        -o-transform: rotate(136deg)
    }
    100% {
        -o-transform: rotate(82deg)
    }
}

@-ms-keyframes sway-8 {
    0% {
        -ms-transform: rotate(94deg)
    }
    40% {
        -ms-transform: rotate(136deg)
    }
    100% {
        -ms-transform: rotate(82deg)
    }
}

@-moz-keyframes sway-8 {
    0% {
        -moz-transform: rotate(94deg)
    }
    40% {
        -moz-transform: rotate(136deg)
    }
    100% {
        -moz-transform: rotate(82deg)
    }
}

@keyframes sway-8 {
    0% {
        transform: rotate(94deg)
    }
    40% {
        transform: rotate(136deg)
    }
    100% {
        transform: rotate(82deg)
    }
}

.sakura {
    background: -webkit-linear-gradient(120deg, #1E7F15, #d5f8d3);
    background: -o-linear-gradient(120deg, #1E7F15, #d5f8d3);
    background: -ms-linear-gradient(120deg, #1E7F15, #d5f8d3);
    background: -moz-linear-gradient(120deg, #1E7F15, #d5f8d3);
    background: linear-gradient(120deg, #1E7F15, #d5f8d3);
    -webkit-border-radius: 12px 1px;
    -o-border-radius: 12px 1px;
    -ms-border-radius: 12px 1px;
    -moz-border-radius: 12px 1px;
    border-radius: 12px 1px;
    -webkit-pointer-events: none;
    -moz-pointer-events: none;
    -ms-pointer-events: none;
    -o-pointer-events: none;
    pointer-events: none;
    position: absolute
}


.bsContainer section {
    width: 100%;
    min-height: 500px;
}

.bsContainer .navbar {
    position: fixed;
    z-index: 999;
    top: 50%;
    right: 50px;
    transform: translateY(-50%);
}

.bsContainer .navbar .nav-menu {
    margin: 0;
    padding: 0;
    list-style-type: none;
}

.bsContainer .navbar .nav-menu li {
    position: relative;
    min-width: 200px;
    text-align: right;
}

.bsContainer .navbar .nav-menu li .dot {
    display: block;
    color: #fff;
    padding: 5px 0;
}

.bsContainer .navbar .nav-menu li .dot::before,
.bsContainer .navbar .nav-menu li .dot::after {
    display: block;
    position: absolute;
    content: '';
    border-radius: 50%;
    top: 50%;
    transition: all .3s ease;
}

.bsContainer .navbar .nav-menu li .dot::before {
    width: 5px;
    height: 5px;
    right: 0;
    border: 2px solid #181818;
    transform: translateY(-50%);
}

.bsContainer .navbar .nav-menu li .dot::after {
    width: 15px;
    height: 15px;
    border: 2px solid #1E7F15;
    right: -5px;
    transform: translateY(-50%) scale(0);
}

.bsContainer .navbar .nav-menu li .dot.active::before,
.bsContainer .navbar .nav-menu li:hover .dot::before {
    background: #1E7F15;
    border-color: #1E7F15;
}

.bsContainer .navbar .nav-menu li .dot.active::after,
.bsContainer .navbar .nav-menu li:hover .dot::after {
    transform: translateY(-50%) scale(1);
}

.bsContainer .navbar .nav-menu li .dot span {
    display: inline-block;
    opacity: 0;
    font-weight: 700;
    letter-spacing: .5px;
    text-transform: capitalize;
    background-color: #1E7F15;
    padding: 10px 20px;
    border-radius: 3px;
    margin-right: 30px;
    transform: translateX(20px);
    transition: all .3s ease;
}

.bsContainer .navbar .nav-menu li .dot span::before {
    display: block;
    position: absolute;
    content: '';
    border-left: 7px solid #1E7F15;
    border-top: 7px solid transparent;
    border-bottom: 7px solid transparent;
    top: 50%;
    transform: translate(7px, -50%);
    right: 0;
    transition: all .3s ease;
}

.bsContainer .navbar .nav-menu li .dot.active span,
.navbar .nav-menu li:hover .dot span {
    transform: translateX(0px);
    opacity: 1;
}

.carousel-inner img {
	display: block;
	max-width: 100%;
	height: auto;
}

.carousel-caption {
    position: absolute;
    top: 30px;
    left: 8%;
    right: auto;
    text-shadow: 2px 2px 2px gray;
    opacity: 0.8;
}

#demo{
	display: inline-block;
}

body {
	background: linear-gradient( to right, white 50px, rgb(242, 240, 203));
}
</style>


<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>


<script>
(function ($) {
    // requestAnimationFrame Polyfill
    (function () {
        var lastTime = 0;
        var vendors = ['ms', 'moz', 'webkit', 'o'];

        for (var x = 0; x < vendors.length && !window.requestAnimationFrame; ++x) {
            window.requestAnimationFrame = window[vendors[x] + 'RequestAnimationFrame'];
            window.cancelAnimationFrame = window[vendors[x] + 'CancelAnimationFrame'] || window[vendors[x] + 'CancelRequestAnimationFrame'];
        }

        if (!window.requestAnimationFrame)
            window.requestAnimationFrame = function (callback, element) {
                var currTime = new Date().getTime();
                var timeToCall = Math.max(0, 16 - (currTime - lastTime));
                var id = window.setTimeout(function () {
                        callback(currTime + timeToCall);
                    },
                    timeToCall);
                lastTime = currTime + timeToCall;

                return id;
            };

        if (!window.cancelAnimationFrame)
            window.cancelAnimationFrame = function (id) {
                clearTimeout(id);
            };
    }());

    // Sakura function.
    $.fn.sakura = function (options) {
        // We rely on these random values a lot, so define a helper function for it.
        function getRandomInt(min, max) {
            return Math.floor(Math.random() * (max - min + 1)) + min;
        }

        // Helper function to attach cross-browser events to an element.
        var prefixes = ['moz', 'ms', 'o', 'webkit', ''];
        var prefCount = prefixes.length;

        function prefixedEvent(element, type, callback) {
            for (var i = 0; i < prefCount; i++) {
                if (!prefixes[i]) {
                    type = type.toLowerCase();
                }

                element.get(0).addEventListener(prefixes[i] + type, callback, false);
            }
        }

        // Defaults for the option object, which gets extended below.
        var defaults = {
            blowAnimations: ['blow-soft-left', 'blow-medium-left', 'blow-hard-left', 'blow-soft-right', 'blow-medium-right', 'blow-hard-right'],
            className: 'sakura',
            fallSpeed: 0.1,
            maxSize: 14,
            minSize: 9,
            newOn: 300,
            swayAnimations: ['sway-0', 'sway-1', 'sway-2', 'sway-3', 'sway-4', 'sway-5', 'sway-6', 'sway-7', 'sway-8']
        };

        var options = $.extend({}, defaults, options);

        // Declarations.
        var documentHeight = $(document).height();
        var documentWidth = $(document).width();
        var sakura = $('<div class="' + options.className + '" />');

        // Set the overflow-x CSS property on the body to prevent horizontal scrollbars.
        $('body').css({ 'overflow-x': 'hidden' });

        // Function that inserts new petals into the document.
        var petalCreator = function () {
            setTimeout(function () {
                requestAnimationFrame(petalCreator);
            }, options.newOn);

            // Get one random animation of each type and randomize fall time of the petals.
            var blowAnimation = options.blowAnimations[Math.floor(Math.random() * options.blowAnimations.length)];
            var swayAnimation = options.swayAnimations[Math.floor(Math.random() * options.swayAnimations.length)];
            var fallTime = (Math.round(documentHeight * 0.007) + Math.random() * 5) * options.fallSpeed;

            var animations = 'fall ' + fallTime + 's linear 0s 1' + ', ' +
                blowAnimation + ' ' + (((fallTime > 30 ? fallTime : 30) - 20) + getRandomInt(0, 20)) + 's linear 0s infinite' + ', ' +
                swayAnimation + ' ' + getRandomInt(2, 4) + 's linear 0s infinite';
            var petal = sakura.clone();
            var size = getRandomInt(options.minSize, options.maxSize);
            var startPosLeft = Math.random() * documentWidth - 100;
            var startPosTop = -((Math.random() * 20) + 15);

            // Apply Event Listener to remove petals that reach the bottom of the page.
            prefixedEvent(petal, 'AnimationEnd', function () {
                $(this).remove();
            });

            // Apply Event Listener to remove petals that finish their horizontal float animation.
            prefixedEvent(petal, 'AnimationIteration', function (ev) {
                if ($.inArray(ev.animationName, options.blowAnimations) != -1) {
                    $(this).remove();
                }
            });

            petal
                .css({
                    '-webkit-animation': animations,
                    '-o-animation': animations,
                    '-ms-animation': animations,
                    '-moz-animation': animations,
                    animation: animations,
                    height: size,
                    left: startPosLeft,
                    'margin-top': startPosTop,
                    width: size
                })
                .appendTo('body');
        };


        // Recalculate documentHeight and documentWidth on browser resize.
        $(window).resize(function () {
            documentHeight = $(document).height();
            documentWidth = $(document).width();
        });

        // Finally: Start adding petals.
        requestAnimationFrame(petalCreator);
    };
}(jQuery));


$(function(){
	$('body').sakura();
	
    var link = $('#navbar a.dot');
    link.on('click',function(e){
        
        //href 속성을 통해, section id 타겟을 잡음
        var target = $($(this).attr('href')); 
        
        //target section의 좌표를 통해 꼭대기로 이동
        $('html, body').animate({
            scrollTop: target.offset().top
        },600);
        
        //active 클래스 부여
        $(this).addClass('active');

        //앵커를 통해 이동할때, URL에 #id가 붙지 않도록 함.
        e.preventDefault();
    });
    
    $(window).on('scroll',function(){
        findPosition();
    });

    function findPosition(){
        $('section').each(function(){
            if( ($(this).offset().top - $(window).scrollTop() ) < 200){
                link.removeClass('active');
                $('#navbar').find('[data-scroll="'+ $(this).attr('id') +'"]').addClass('active');
            }
        });
    }

    findPosition();
    
	// 페이지 로딩되면 자동으로 브랜드스토리 클릭
	$("a#bsHome").trigger("click");
	
});
</script>

<div class="container bsContainer" >
	<nav id="navbar" class="navbar">
		<ul class="nav-menu">
			<li><a data-scroll="home" href="#home" class="dot active" id="bsHome"> <span>Oh!Sherlock</span>
			</a></li>
			<li><a data-scroll="bi" href="#bi" class="dot active"> <span>BI</span>
			</a></li>
			<li><a data-scroll="pca" href="#pca" class="dot"> <span>박찬안</span>
			</a></li>
			<li><a data-scroll="lye" href="#lye" class="dot"> <span>이예은</span>
			</a></li>
			<li><a data-scroll="syj" href="#syj" class="dot"> <span>손여진</span>
			</a></li>
			<li><a data-scroll="lsw" href="#lsw" class="dot"> <span>임선우</span>
			</a></li>
			<li><a data-scroll="kcy" href="#kcy" class="dot"> <span>강채영</span>
			</a></li>
		</ul>
	</nav>

	<section id="home">
	<hr style="padding-top: 90px; border-style:none">
	<h2 style="font-weight: bold">오셜록 브랜드스토리</h2>
	<hr>
	
	<div class="row">
		<div id="demo col" class="carousel slide mt-5 mx-3" data-ride="carousel" style="width:700px; height:440px;">
		  <div class="carousel-inner">
		    <div class="carousel-item active">
		      <img src="../images/sherlock1.png" width="700" height="440">
		      <div class="carousel-caption">
		        <h1 class=" text-white">OH! Sherlock</h1>
		        <h5 class=" text-white">오셜록은 향긋합니다</h5>
		      </div>   
		    </div>
		    <div class="carousel-item">
		      <img src="../images/sherlock2.png" width="700" height="440">
		      <div class="carousel-caption">
		        <h1 class=" text-white">OH! Sherlock</h1>
				<h5 class=" text-white">오셜록은 맛있습니다</h5>
		      </div>   
		    </div>
		    <div class="carousel-item">
		      <img src="../images/sherlock3.png" width="700" height="440">
		      <div class="carousel-caption">
		        <h1 class=" text-white">OH! Sherlock</h1>
				<h5 class=" text-white">오셜록은 진실합니다</h5>
		      </div>   
		    </div>
		  </div>
		</div>
		
		<div class="col col-4">
			<p style="font-size: 13pt; padding-top:85%; padding-left:5%">
				
				오!셜록의 역사는 2022년 5월,<br>21B Worldcup Street에서 시작되었습니다.<br><br> 
				오!셜록은 바쁜 일상 속 차 한잔의 여유를 즐기는 슬로우 라이프를 추구하며,<br>
				 최고의 인재들을 영입하여 부단한 노력과 연구를 통해 지속적으로 발전하고 있습니다.
			</p>
		</div>
	</div>	
	</section>


	<section id="bi">
		<hr style="padding-top: 90px; border-style:none">
		<h2 style="font-weight: bold" class="mt-5">BI(Brand Identity)</h2>
		<hr>
		<div class="bi text-center" style="margin: 5% 0;">
		<h4 style="margin-top: 5%; font-weight:bold">브랜드 로고<br>─</h4>
		<h5 style="margin: 5% 0;">Fragrant World의 비전을 담은 OH!Sherlock의 얼굴을 소개합니다.</h5>
		<img src="../images/o_logo_big.png" width=300>
		<h5 style="margin: 5% 0;">OH!Sherlock의 심볼마크는 Java 찻잔의 향긋함을 담아<br>
		인생의 모든 순간에 늘 <span style="color: #1E7F15; font-weight:bold">아름다운 향기</span>를 선사하겠다는 약속입니다.</h5>
		<hr style="width:50%">
		<h4 style="margin-top: 5%; font-weight:bold">브랜드 시그니처 컬러<br>─</h4>
		<img src="../images/signature_color.png" width=80%/>
		<h5 style="margin: 5% 0;">OH!Sherlock의 시그니처 컬러는 <span style="color: #1E7F15; font-weight:bold">제주 녹차밭의 진녹색</span>을 떠올리게 하여<br>
		하루 종일 컴퓨터만 보느라 지친 현대인의 안구 피로감을 해소해줍니다.</h5>
		</div>
	</section>

	<hr style="padding-top: 90px; border-style:none">
	<h2 style="font-weight: bold" class="mt-5">임직원 소개</h2>
	<hr>

	<section id="pca">
	<hr style="padding-top: 90px; border-style:none">
		<div class="mt-4 pca">
			<h4 style="font-weight: bold;">👑박찬안👑</h4>
			<br>
			<br>
			<h4>
			이번 프로젝트를 통해서 MVC 패턴에 대한 이해도를 높일 수 있었다.<br>
			수업으로만 들었을 때는 헷갈리는 점이 많았지만 직접 만들어보며 체화할 수 있는 좋은 기회가 되었다.<br>
			무엇보다 너무 좋은 팀원들을 만나 행운이었다고 생각한다.<br>
			힘들기도 했지만 서로서로 응원해주며 훈훈한 분위기에서 작업할 수 있었다.<br>
			팀원들 너무너무 고맙고 그동안 고생 많았어요❤❣ 곱창 먹자!
			</h4>
		</div>
	</section>
	<hr>
	<section id="lye">
	<hr style="padding-top: 90px; border-style:none">
		<h4 style="font-weight: bold;">이예은</h4>
		<h4>
		<br>
		<br>
		약 4주동안 팀원들과 웹사이트를 구현하면서 힘들면서도 보람있고 즐거운 시간이었습니다.<br>
		수업시간에 배운 부분을 직접 적용하고 추가적인 기능을 구현하면서 많은 것을 배울 수 있었고,<br>
		팀원들 간에 서로 응원하고 도와주면서 한층 더 돈독해졌던 것 같습니다:)<br>
		시행착오도 여러번 있었지만 좋은 팀원들 덕분에 빠르게 해결해 나갈 수 있었고, 마지막까지 힘내서 열심히 할 수 있었습니다! 다들 고생 많았어 우리 오셜록2조!♥
		</h4>
	</section>
	<hr>
	<section id="syj">
	<hr style="padding-top: 90px; border-style:none">
		<h4 style="font-weight: bold;">손여진</h4>
		<br>
		<br>
		<h4>
		수업 때 배웠던 개념들을 직접 적용시켜 보며 응용해 볼 수 있어서 좋은 기회였다. <br>
		서로 모르는 거를 물어보고 알아가며 더 많이 배울 수 있어서 좋았다.<br>
		좋은 팀원들과 함께해서 즐겁게 프로젝트를 진행하였다.<br>
		시간이 조금 더 있었다면 좋았겠지만, 모두가 최선을 다해서 임했기 때문에 후회는 없다.  2조 최고 °˖✧◝(⁰▿⁰)◜✧˖°
		</h4>
	</section> 
	<hr>
	<section id="lsw">
	<hr style="padding-top: 90px; border-style:none">
		<h4 style="font-weight: bold;">임선우</h4>
		<br>
		<br>
		<h4>
		깃을 처음 배우고 한번 잘못하면 팀 전체코드가 날라간다는 말에 무서워 초반에는 병합하는걸 미루다가<br>
		팀원들과 소통을 하면서 깃에 대한 두려움을 극복했습니다. MVC를 시작하면서 정리가 안되어 복잡했는데, <br>
		프로젝트를 하면서 정리가 많이 되었습니다. 진행하면서 예상하지 못한 변수들이 많아서 힘들었지만, <br>
		팀원들과 해결해 나가 너무 좋았던 경험이었습니다. 2조 오셜록짱! 
		</h4>
	</section>
	<hr>
	<section id="kcy">   
	<hr style="padding-top: 90px; border-style:none">  
		<h4 style="font-weight: bold;">강채영</h4> 
		<br>
		<br>
		<h4>
		마무리하며 소감을 요약해서 말하자면 좋은 사람들을 만나고 그 사람들을 통해 즐겁게 배워갈 수 있는 시간이었습니다!<br>
	    많이 부족했을 저를 옆에서 이끌어주고 응원해 준 팀장님과 팀원분들께 이 자리를 빌려 다시 한번 고맙다는 말을 전합니다.<br>
	    실제 수업을 들으면서 머릿속으로만 이해하던 부분들을 직접 생각하고, 만들어가며 손으로 익힐 수 있어 좋았습니다~! <br>
	    이번 프로젝트 모든 분들 수고 많으셨고 행복 가득한 주말 보내세요🍵
		</h4>
		
	</section>
</div>
 
<%@ include file="../footer.jsp"%>