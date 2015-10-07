/** ********************************************** **
	@Author			Dorin Grigoras
	@Website		www.stepofweb.com
	@Last Update	Sunday, March 16, 2014

	NOTE! 	Do not change anything here if you want to
			be able to update in the future! Please use
			your custom script (eg. custom.js).


	TABLE CONTENTS
	-------------------------------
	Top Nav
	Animate
	OWL Carousel
	Popover
	Lightbox
	ScrollTo
	Isotope
	Toggle
	Placeholder
	Google Map

	COUNT TO
	FITVIDS
	WAIT FOR IMAGES [used by masonry]
	LAZYLOAD
 **************************************************************** **/
	var is_msie = (navigator.appVersion.indexOf("MSIE")!=-1) ? true : false;

	/* Init */
	jQuery(window).ready(function () {
		Core();
	});


/** Core
 **************************************************************** **/
	function Core() {

		_topNav();
		_slider();
		_parallax();
		_animate();
		_owl_carousel();
		_popover();
		_lightbox();
		_scrollTo();
		_isotope();
		_toggle();
		_placeholder();
		_contact();
		_portfolio();

		/** Bootstrap Tooltip **/ 
		jQuery("a[data-toggle=tooltip]").tooltip();
		
		/** Fitvids [Youtube|Vimeo] **/
		if(jQuery("#maximage").length < 1) { // disable fitvids if maximage slider is present
			jQuery("body").fitVids(); 
		}

		/** mobile - hide on click! **/
		jQuery(document).bind("click", function() {
			if(jQuery("div.navbar-collapse").hasClass('in')) {
				jQuery("#mobileMenu").trigger('click');
			}
		});

	}


/** Top Nav
 **************************************************************** **/
	function _topNav() {



	}



/** Slider
 **************************************************************** **/
	function _slider() {

		if(jQuery().bxSlider) {

			/* Text Slider */
			jQuery('.text-slider').bxSlider({
				mode: 		'fade',
				pager: 		false,
				auto: 		true,
				pause:		4000,
				controls: 	false
			});

		}

		/* Home Slider */
		var _slc = jQuery('.slider');
		(function _loop(x) {

			_slc.removeClass('slider-current').eq(x).addClass('slider-current');

			setTimeout(function () {
				_loop((x + 1) % _slc.length);
			}, 5000);

		}(0));

	}




/** Parallax
 **************************************************************** **/
	function _parallax() {

		jQuery(window).load(function () {

			if(jQuery().parallax) {

				/* Default */
				jQuery(".parallax.parallax-default").css("background-attachment", "fixed");
				jQuery(".parallax.parallax-default").parallax("50%", "0.4");

				jQuery(".parallax.parallax-1").css("background-attachment", "fixed");
				jQuery(".parallax.parallax-1").parallax("50%", "0.4");

				jQuery(".parallax.parallax-2").css("background-attachment", "fixed");
				jQuery(".parallax.parallax-2").parallax("50%", "0.4");

				jQuery(".parallax.parallax-3").css("background-attachment", "fixed");
				jQuery(".parallax.parallax-3").parallax("50%", "0.4");

				jQuery(".parallax.parallax-4").css("background-attachment", "fixed");
				jQuery(".parallax.parallax-4").parallax("50%", "0.4");

				/* Home Slider */
				jQuery("#home div.slider").css("background-attachment", "fixed");
				jQuery("#home div.slider").parallax("50%", "0.4");

			}

		});

	}




/** Animate
 **************************************************************** **/
	function _animate() {

		// Bootstrap Progress Bar
		jQuery("[data-appear-progress-animation]").each(function() {
			var $_t = jQuery(this);

			if(jQuery(window).width() > 767) {

				$_t.appear(function() {
					_delay = 1;

					if($_t.attr("data-appear-progress-animation-delay")) {
						_delay = $_t.attr("data-appear-progress-animation-delay");
					}

					if(_delay > 1) {
						$_t.css("animation-delay", _delay + "ms");
					}

					$_t.addClass($_t.attr("data-appear-progress-animation"));

					setTimeout(function() {

						$_t.addClass("animation-visible");

					}, _delay);

				}, {accX: 0, accY: -150});

			} else {

				$_t.addClass("animation-visible");

			}

		});


		jQuery("[data-appear-progress-animation]").each(function() {
			var $_t = jQuery(this);

			$_t.appear(function() {

				var _delay = ($_t.attr("data-appear-animation-delay") ? $_t.attr("data-appear-animation-delay"): 1);

				if(_delay > 1) {
					$_t.css("animation-delay", _delay + "ms");
				}

				$_t.addClass($_t.attr("data-appear-animation"));
				setTimeout(function() {

					$_t.animate({"width": $_t.attr("data-appear-progress-animation")}, 1000, "easeOutQuad", function() {
						$_t.find(".progress-bar-tooltip").animate({"opacity": 1}, 500, "easeOutQuad");
					});

				}, _delay);

			}, {accX: 0, accY: -50});

		});


		// Count To
		jQuery(".countTo [data-to]").each(function() {
			var $_t = jQuery(this);

			$_t.appear(function() {

				$_t.countTo();

			}, {accX:0, accY:-150});

		});


		/* Knob Circular Bar */
		if(jQuery().knob) {

			jQuery(".knob").knob();

		}



		/* Animation */
		jQuery('.animate_from_top').each(function () {
			jQuery(this).appear(function() {
				jQuery(this).delay(100).animate({opacity:1,top:"0px"},1000);
			});	
		});

		jQuery('.animate_from_bottom').each(function () {
			jQuery(this).appear(function() {
				jQuery(this).delay(100).animate({opacity:1,bottom:"0px"},1000);
			});	
		});


		jQuery('.animate_from_left').each(function () {
			jQuery(this).appear(function() {
				jQuery(this).delay(100).animate({opacity:1,left:"0px"},1000);
			});	
		});


		jQuery('.animate_from_right').each(function () {
			jQuery(this).appear(function() {
				jQuery(this).delay(100).animate({opacity:1,right:"0px"},1000);
			});	
		});

		jQuery('.animate_fade_in').each(function () {
			jQuery(this).appear(function() {
				jQuery(this).delay(250).animate({opacity:1,right:"0px"},1000);
			});	
		});
	}



/** OWL Carousel
 **************************************************************** **/
	function _owl_carousel() {

		var total = jQuery("div.owl-carousel").length,
			count = 0;

		jQuery("div.owl-carousel").each(function() {

			var slider 		= jQuery(this);
			var options 	= slider.attr('data-plugin-options');

			var defaults = {
				items: 					5,
				itemsCustom: 			false,
				itemsDesktop: 			[1199,4],
				itemsDesktopSmall: 		[980,3],
				itemsTablet: 			[768,2],
				itemsTabletSmall: 		false,
				itemsMobile: 			[479,1],
				singleItem: 			true,
				itemsScaleUp: 			false,

				slideSpeed: 			200,
				paginationSpeed: 		800,
				rewindSpeed: 			1000,

				autoPlay: 				false,
				stopOnHover: 			false,

				navigation: 			false,
				navigationText: [
									'<i class="fa fa-chevron-left"></i>',
									'<i class="fa fa-chevron-right"></i>'
								],
				rewindNav: 				true,
				scrollPerPage: 			false,

				pagination: 			true,
				paginationNumbers: 		false,

				responsive: 			true,
				responsiveRefreshRate: 	200,
				responsiveBaseWidth: 	window,

				baseClass: 				"owl-carousel",
				theme: 					"owl-theme",

				lazyLoad: 				false,
				lazyFollow: 			true,
				lazyEffect: 			"fade",

				autoHeight: 			false,

				jsonPath: 				false,
				jsonSuccess: 			false,

				dragBeforeAnimFinish: 	true,
				mouseDrag: 				true,
				touchDrag: 				true,

				transitionStyle: 		false,

				addClassActive: 		false,

				beforeUpdate: 			false,
				afterUpdate: 			false,
				beforeInit: 			false,
				afterInit: 				false,
				beforeMove: 			false,
				afterMove: 				false,
				afterAction: 			false,
				startDragging: 			false,
				afterLazyLoad: 			false
			}

			var config = jQuery.extend({}, defaults, options, slider.data("plugin-options"));
			slider.owlCarousel(config).addClass("owl-carousel-init");
		});
	}



/** Popover
 **************************************************************** **/
	function _popover() {

			jQuery("a[data-toggle=popover]").bind("click", function(e) {
				e.preventDefault();
			});

			var isVisible 	= false,
				clickedAway = false;

			jQuery("a[data-toggle=popover], button[data-toggle=popover]").popover({

					html: true,
					trigger: 'manual'

				}).click(function(e) {

					jQuery(this).popover('show');
					jQuery('.popover-title').append('<button type="button" class="close">&times;</button>');
					clickedAway = false;
					isVisible = true;
					e.preventDefault();

				});

				jQuery(document).click(function(e) {

					if(isVisible & clickedAway) {

						jQuery("a[data-toggle=popover], button[data-toggle=popover]").popover('hide');
						isVisible = clickedAway = false;

					} else {

						clickedAway = true;

					}

				});

			jQuery("a[data-toggle=popover], button[data-toggle=popover]").popover({

				html: true,
				trigger: 'manual'

			}).click(function(e) {

				$(this).popover('show');
				$('.popover-title').append('<button type="button" class="close">&times;</button>');
				$('.close').click(function(e){

					jQuery("a[data-toggle=popover], button[data-toggle=popover]").popover('hide');

				});

				e.preventDefault();
			});

	}



/** LightBox
 **************************************************************** **/
	function _lightbox() {

		if(typeof(jQuery.magnificPopup) == "undefined") {
			return false;
		}

		jQuery.extend(true, jQuery.magnificPopup.defaults, {
			tClose: 		'Close',
			tLoading: 		'Loading...',

			gallery: {
				tPrev: 		'Previous',
				tNext: 		'Next',
				tCounter: 	'%curr% / %total%'
			},

			image: 	{ 
				tError: 	'Image not loaded!' 
			},

			ajax: 	{ 
				tError: 	'Content not loaded!' 
			}
		});

		jQuery(".lightbox").each(function() {

			var _t 			= jQuery(this),
				options 	= _t.attr('data-plugin-options'),
				config		= {},
				defaults 	= {
					type: 				'image',
					fixedContentPos: 	false,
					fixedBgPos: 		false,
					mainClass: 			'mfp-no-margins mfp-with-zoom',
					image: {
						verticalFit: 	true
					},

					zoom: {
						enabled: 		false,
						duration: 		300
					},

					gallery: {
						enabled: false,
						navigateByImgClick: true,
						preload: 			[0,1],
						arrowMarkup: 		'<button title="%title%" type="button" class="mfp-arrow mfp-arrow-%dir%"></button>',
						tPrev: 				'Previou',
						tNext: 				'Next',
						tCounter: 			'<span class="mfp-counter">%curr% / %total%</span>'
					},
				};

			if(_t.data("plugin-options")) {
				config = jQuery.extend({}, defaults, options, _t.data("plugin-options"));
			}

			jQuery(this).magnificPopup(config);

		});
	}



/** ScrollTo
 **************************************************************** **/
	function _scrollTo() {
		window._lastScrollTo = null;

		jQuery("a.scrollTo").bind("click", function(e) {
			e.preventDefault();

			var href = jQuery(this).attr('href');

			if(href != '#') {
				window._lastScrollTo = href;
				jQuery('html,body').animate({scrollTop: jQuery(href).offset().top/* - 60*/}, 1000, 'easeInOutExpo');
			}
		});

		jQuery("a.toTop").bind("click", function(e) {
			e.preventDefault();
			jQuery('html,body').animate({scrollTop: 0}, 1000, 'easeInOutExpo');
		});

		// On Resize
		jQuery(window).resize(function() {

			if(window.afterResize) {
				clearTimeout(window.afterResize);
			}

			window.afterResize = setTimeout(function() {

				/**
					After Resize Code
					.................
				**/

				if(window._lastScrollTo) {
					/*
					jQuery('html,body').animate({scrollTop: jQuery(window._lastScrollTo).offset().top}, 1000, 'easeInOutExpo');
					*/
				}

			}, 1000);

		});

	}

	
	
/** Isotope
 **************************************************************** **/
	function _isotope() {

		jQuery("ul.isotope-filter").each(function() {

			var _el		 		= jQuery(this),
				destination 	= jQuery("ul.sort-destination[data-sort-id=" + jQuery(this).attr("data-sort-id") + "]");

			if(destination.get(0)) {

				jQuery(window).load(function() {

					destination.isotope({
						itemSelector: 	"li",
						layoutMode: 	'sloppyMasonry'
					});

					_el.find("a").click(function(e) {

						e.preventDefault();

						var $_t 	= jQuery(this),
							sortId 	= $_t.parents(".sort-source").attr("data-sort-id"),
							filter 	= $_t.parent().attr("data-option-value");

						_el.find("li.active").removeClass("active");
						$_t.parent().addClass("active");

						destination.isotope({
							filter: filter
						});

						jQuery(".sort-source-title[data-sort-id=" + sortId + "] strong").html($_t.html());
						return false;

					});

				});

			}

		});


		jQuery(window).load(function() {

			jQuery("ul.isotope").addClass('fadeIn');

		});


	}



 /** Toggle
 **************************************************************** **/
	function _toggle() {

		var $_t = this,
			previewParClosedHeight = 25;

		jQuery("div.toggle.active > p").addClass("preview-active");
		jQuery("div.toggle.active > div.toggle-content").slideDown(400);
		jQuery("div.toggle > label").click(function(e) {

			var parentSection 	= jQuery(this).parent(),
				parentWrapper 	= jQuery(this).parents("div.toogle"),
				previewPar 		= false,
				isAccordion 	= parentWrapper.hasClass("toogle-accordion");

			if(isAccordion && typeof(e.originalEvent) != "undefined") {
				parentWrapper.find("div.toggle.active > label").trigger("click");
			}

			parentSection.toggleClass("active");

			if(parentSection.find("> p").get(0)) {

				previewPar 					= parentSection.find("> p");
				var previewParCurrentHeight = previewPar.css("height");
				var previewParAnimateHeight = previewPar.css("height");
				previewPar.css("height", "auto");
				previewPar.css("height", previewParCurrentHeight);

			}

			var toggleContent = parentSection.find("> div.toggle-content");

			if(parentSection.hasClass("active")) {

				jQuery(previewPar).animate({height: previewParAnimateHeight}, 350, function() {jQuery(this).addClass("preview-active");});
				toggleContent.slideDown(350);

			} else {

				jQuery(previewPar).animate({height: previewParClosedHeight}, 350, function() {jQuery(this).removeClass("preview-active");});
				toggleContent.slideUp(350);

			}

		});
	}



/** Placeholder
 **************************************************************** **/
	function _placeholder() {

		//check for IE
		if(navigator.appVersion.indexOf("MSIE")!=-1) {

			jQuery('[placeholder]').focus(function() {

				var input = jQuery(this);
				if (input.val() == input.attr('placeholder')) {
					input.val('');
					input.removeClass('placeholder');
				}

			}).blur(function() {

				var input = jQuery(this);
				if (input.val() == '' || input.val() == input.attr('placeholder')) {
				input.addClass('placeholder');
				input.val(input.attr('placeholder'));
				}

			}).blur();

		}

	}



/**	Google Map
 **************************************************************** **/
	function contactMap() {

		var latLang = new google.maps.LatLng($googlemap_latitude,$googlemap_longitude);

		var mapOptions = {
			zoom:$googlemap_zoom,
			center: latLang,
			disableDefaultUI: false,
			navigationControl: false,
			mapTypeControl: false,
			scrollwheel: false,
			// styles: styles,
			mapTypeId: google.maps.MapTypeId.ROADMAP
		};

		var map = new google.maps.Map(document.getElementById('gmap'), mapOptions);
		google.maps.event.trigger(map, 'resize');
		map.setZoom( map.getZoom() );

		var marker = new google.maps.Marker({
			icon: 'data:image/png;base64,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',
			position: latLang,
			map: map,
			title: ""
		});

		marker.setMap(map);
		google.maps.event.addListener(marker, "click", function() {
			// Add optionally an action for when the marker is clicked
		});

		// kepp googlemap responsive - center on resize
		google.maps.event.addDomListener(window, 'resize', function() {
			map.setCenter(latLang);
		});

	}

	
	function showMap(initWhat) {
		var script 		= document.createElement('script');
		script.type 	= 'text/javascript';
		script.src 		= 'https://maps.googleapis.com/maps/api/js?v=3.exp&sensor=true&callback='+initWhat;
		document.body.appendChild(script);
	}

	
	// INIT CONTACT, NLY IF #contactMap EXISRS
	if(jQuery("#gmap").length > 0) {
		showMap('contactMap');
	}

	

	

/**	CONTACT FORM
************************************************** **/
	function _contact() {

		jQuery("#contact_submit").bind("click", function(e) {

			var contact_name 	= jQuery("#contact_name").val(),			// required
				contact_email 	= jQuery("#contact_email").val(),			// required
				contact_subject = jQuery("#contact_subject").val(),			// optional
				contact_comment = jQuery("#contact_comment").val(),			// required
				captcha 		= jQuery("#captcha").val(),					// required TO BE EMPTY if humans
				_action			= jQuery("#contactForm").attr('action'),	// form action URL
				_method			= jQuery("#contactForm").attr('method'),	// form method
				_err			= false;									// status

			// Remove error class
			jQuery("input, textarea").removeClass('err');

			// Spam bots will see captcha field - that's how we decet spams.
			// It's very simple and not very efficient antispam method but works for bots.
			if(captcha != '') {
				return false;
			}


			// Name Check
			if(contact_name == '') {
				jQuery("#contact_name").addClass('err');
				var _err = true;
			}

			// Email Check
			if(contact_email == '') {
				jQuery("#contact_email").addClass('err');
				var _err = true;
			}

			// Comment Check
			if(contact_comment == '') {
				jQuery("#contact_comment").addClass('err');
				var _err = true;
			}

			// Stop here, we have empty fields!
			if(_err !== true) {
				e.preventDefault();

				// SEND MAIL VIA AJAX
				$.ajax({
					url: 	_action,
					data: 	{ajax:"true", action:'email_send', contact_name:contact_name, contact_email:contact_email, contact_comment:contact_comment, contact_subject:contact_subject},
					type: 	_method,
					error: 	function(XMLHttpRequest, textStatus, errorThrown) {

						alert('Server Internal Error'); // usualy on headers 404

					},

					success: function(data) {
						data = data.trim(); // remove output spaces


						// PHP RETURN: Mandatory Fields
						if(data == '_required_') {
							alert('Please, complete required fields!');
						} else

						// PHP RETURN: INVALID EMAIL
						if(data == '_invalid_email_') {
							alert('Invalid Email');
						} else

						// VALID EMAIL
						if(data == '_sent_ok_') {

							// append message and show ok alert
							jQuery("#_msg_txt_").empty().append('Message Sent, Thank you!');
							jQuery("#_sent_ok_").removeClass('hide');

							// reset form
							jQuery("#contact_name, #contact_email, #contact_subject, #contact_comment").val('');

						} else {

							// PHPMAILER ERROR
							alert(data); 

						}
					}
				});

			}
		});

	}





/** Portfolio
 **************************************************************** **/
	function _portfolio() {

		// External Portfolio
		jQuery("a.ajax-project").bind("click", function(e) {
			e.preventDefault();

			var href = jQuery(this).attr('href');

			$.ajax({
				url: 	href,
				data: 	{ajax:"true"},
				type: 	"get",
				error: 	function(XMLHttpRequest, textStatus, errorThrown) {

					alert('Server Internal Error'); // usualy on headers 404

				},

				success: function(data) {
					jQuery('body').append('<div id="ajax_modal">' + data + '</div>');
					jQuery("#ajax_modal").fadeIn(300, function() {
						jQuery("body").fitVids();
						_owl_carousel();
						_lightbox();
						_animate();
						_popover();
						_toggle();
						_placeholder();

						// close modal
						jQuery("button.close-modal").bind("click", function(e) {
							jQuery("#ajax_modal").fadeOut(300, function() {
								jQuery('body').css({"overflow-y":"visible"});
								jQuery(this).remove();
							});
						});

						// Esc key
						jQuery(document).keydown(function(e){
							var code = e.keyCode ? e.keyCode : e.which;
							if(code === 27) {
								jQuery("#ajax_modal").fadeOut(300, function() {
									jQuery('body').css({"overflow-y":"visible"});
									jQuery(this).remove();
								});
							}
						});

					});

					// hide page scroll
					jQuery('body').css({"overflow-y":"hidden"});
				}
			});

		});

	}	
 
 


/** **************************************************************************************************************** **/
/** **************************************************************************************************************** **/
/** **************************************************************************************************************** **/
/** **************************************************************************************************************** **/




/** MISC
*************************************************** **/
	// easing - only needed
	jQuery.extend( jQuery.easing,{
		easeInOutExpo: function (x, t, b, c, d) {
			if (t==0) return b;
			if (t==d) return b+c;
			if ((t/=d/2) < 1) return c/2 * Math.pow(2, 10 * (t - 1)) + b;
			return c/2 * (-Math.pow(2, -10 * --t) + 2) + b;
		},
		easeOutQuad: function (x, t, b, c, d) {
			return -c *(t/=d)*(t-2) + b;
		}
	});


/** COUNT TO
	https://github.com/mhuggins/jquery-countTo
 **************************************************************** **/
	(function ($) {
		$.fn.countTo = function (options) {
			options = options || {};

			return jQuery(this).each(function () {
				// set options for current element
				var settings = jQuery.extend({}, $.fn.countTo.defaults, {
					from:            jQuery(this).data('from'),
					to:              jQuery(this).data('to'),
					speed:           jQuery(this).data('speed'),
					refreshInterval: jQuery(this).data('refresh-interval'),
					decimals:        jQuery(this).data('decimals')
				}, options);

				// how many times to update the value, and how much to increment the value on each update
				var loops = Math.ceil(settings.speed / settings.refreshInterval),
					increment = (settings.to - settings.from) / loops;

				// references & variables that will change with each update
				var self = this,
					$self = jQuery(this),
					loopCount = 0,
					value = settings.from,
					data = $self.data('countTo') || {};

				$self.data('countTo', data);

				// if an existing interval can be found, clear it first
				if (data.interval) {
					clearInterval(data.interval);
				}
				data.interval = setInterval(updateTimer, settings.refreshInterval);

				// __construct the element with the starting value
				render(value);

				function updateTimer() {
					value += increment;
					loopCount++;

					render(value);

					if (typeof(settings.onUpdate) == 'function') {
						settings.onUpdate.call(self, value);
					}

					if (loopCount >= loops) {
						// remove the interval
						$self.removeData('countTo');
						clearInterval(data.interval);
						value = settings.to;

						if (typeof(settings.onComplete) == 'function') {
							settings.onComplete.call(self, value);
						}
					}
				}

				function render(value) {
					var formattedValue = settings.formatter.call(self, value, settings);
					$self.html(formattedValue);
				}
			});
		};

		$.fn.countTo.defaults = {
			from: 0,               // the number the element should start at
			to: 0,                 // the number the element should end at
			speed: 1000,           // how long it should take to count between the target numbers
			refreshInterval: 100,  // how often the element should be updated
			decimals: 0,           // the number of decimal places to show
			formatter: formatter,  // handler for formatting the value before rendering
			onUpdate: null,        // callback method for every time the element is updated
			onComplete: null       // callback method for when the element finishes updating
		};

		function formatter(value, settings) {
			return value.toFixed(settings.decimals);
		}
	}(jQuery));





/** FITVIDS
	http://fitvidsjs.com/
 **************************************************************** **/
	(function( $ ){

	  "use strict";

	  $.fn.fitVids = function( options ) {
		var settings = {
		  customSelector: null
		};

		if(!document.getElementById('fit-vids-style')) {

		  var div = document.createElement('div'),
			  ref = document.getElementsByTagName('base')[0] || document.getElementsByTagName('script')[0];

		  div.className = 'fit-vids-style';
		  div.id = 'fit-vids-style';
		  div.style.display = 'none';
		  div.innerHTML = '&shy;<style>         \
			.fluid-width-video-wrapper {        \
			   width: 100%;                     \
			   position: relative;              \
			   padding: 0;                      \
			}                                   \
												\
			.fluid-width-video-wrapper iframe,  \
			.fluid-width-video-wrapper object,  \
			.fluid-width-video-wrapper embed {  \
			   position: absolute;              \
			   top: 0;                          \
			   left: 0;                         \
			   width: 100%;                     \
			   height: 100%;                    \
			}                                   \
		  </style>';

		  ref.parentNode.insertBefore(div,ref);

		}

		if ( options ) {
		  jQuery.extend( settings, options );
		}

		return this.each(function(){
		  var selectors = [
			"iframe[src*='player.vimeo.com']",
			"iframe[src*='youtube.com']",
			"iframe[src*='youtube-nocookie.com']",
			"iframe[src*='kickstarter.com'][src*='video.html']",
			"object",
			"embed"
		  ];

		  if (settings.customSelector) {
			selectors.push(settings.customSelector);
		  }

		  var $allVideos = jQuery(this).find(selectors.join(','));
		  $allVideos = $allVideos.not("object object"); // SwfObj conflict patch

		  $allVideos.each(function(){
			var $_t = jQuery(this);
			if (this.tagName.toLowerCase() === 'embed' && $_t.parent('object').length || $_t.parent('.fluid-width-video-wrapper').length) { return; }
			var height = ( this.tagName.toLowerCase() === 'object' || ($_t.attr('height') && !isNaN(parseInt($_t.attr('height'), 10))) ) ? parseInt($_t.attr('height'), 10): $_t.height(),
				width = !isNaN(parseInt($_t.attr('width'), 10)) ? parseInt($_t.attr('width'), 10): $_t.width(),
				aspectRatio = height / width;
			if(!$_t.attr('id')){
			  var videoID = 'fitvid' + Math.floor(Math.random()*999999);
			  $_t.attr('id', videoID);
			}
			$_t.wrap('<div class="fluid-width-video-wrapper"></div>').parent('.fluid-width-video-wrapper').css('padding-top', (aspectRatio * 100)+"%");
			$_t.removeAttr('height').removeAttr('width');
		  });
		});
	  };
	})(jQuery);

	// remove fitvids for a specific element: jQuery("#myDiv").unFitVids();
	jQuery.fn.unFitVids = function () {
		var id = jQuery(this).attr("id");
		var $children = jQuery("#" + id + " .fluid-width-video-wrapper").children().clone();
		jQuery("#" + id + " .fluid-width-video-wrapper").remove(); //removes the element
		jQuery("#" + id).append($children); //adds it to the parent
	};

	
	
/** APPEAR
	https://github.com/bas2k/jquery.appear/
	http://code.google.com/p/jquery-appear/
 **************************************************************** **/
(function($) {
    $.fn.appear = function(fn, options) {

        var settings = $.extend({

            //arbitrary data to pass to fn
            data: undefined,

            //call fn only on the first appear?
            one: true,

            // X & Y accuracy
            accX: 0,
            accY: 0

        }, options);

        return this.each(function() {

            var t = $(this);

            //whether the element is currently visible
            t.appeared = false;

            if (!fn) {

                //trigger the custom event
                t.trigger('appear', settings.data);
                return;
            }

            var w = $(window);

            //fires the appear event when appropriate
            var check = function() {

                //is the element hidden?
                if (!t.is(':visible')) {

                    //it became hidden
                    t.appeared = false;
                    return;
                }

                //is the element inside the visible window?
                var a = w.scrollLeft();
                var b = w.scrollTop();
                var o = t.offset();
                var x = o.left;
                var y = o.top;

                var ax = settings.accX;
                var ay = settings.accY;
                var th = t.height();
                var wh = w.height();
                var tw = t.width();
                var ww = w.width();

                if (y + th + ay >= b &&
                    y <= b + wh + ay &&
                    x + tw + ax >= a &&
                    x <= a + ww + ax) {

                    //trigger the custom event
                    if (!t.appeared) t.trigger('appear', settings.data);

                } else {

                    //it scrolled out of view
                    t.appeared = false;
                }
            };

            //create a modified fn with some additional logic
            var modifiedFn = function() {

                //mark the element as visible
                t.appeared = true;

                //is this supposed to happen only once?
                if (settings.one) {

                    //remove the check
                    w.unbind('scroll', check);
                    var i = $.inArray(check, $.fn.appear.checks);
                    if (i >= 0) $.fn.appear.checks.splice(i, 1);
                }

                //trigger the original fn
                fn.apply(this, arguments);
            };

            //bind the modified fn to the element
            if (settings.one) t.one('appear', settings.data, modifiedFn);
            else t.bind('appear', settings.data, modifiedFn);

            //check whenever the window scrolls
            w.scroll(check);

            //check whenever the dom changes
            $.fn.appear.checks.push(check);

            //check now
            (check)();
        });
    };

    //keep a queue of appearance checks
    $.extend($.fn.appear, {

        checks: [],
        timeout: null,

        //process the queue
        checkAll: function() {
            var length = $.fn.appear.checks.length;
            if (length > 0) while (length--) ($.fn.appear.checks[length])();
        },

        //check the queue asynchronously
        run: function() {
            if ($.fn.appear.timeout) clearTimeout($.fn.appear.timeout);
            $.fn.appear.timeout = setTimeout($.fn.appear.checkAll, 20);
        }
    });

    //run checks when these methods are called
    $.each(['append', 'prepend', 'after', 'before', 'attr',
        'removeAttr', 'addClass', 'removeClass', 'toggleClass',
        'remove', 'css', 'show', 'hide'], function(i, n) {
        var old = $.fn[n];
        if (old) {
            $.fn[n] = function() {
                var r = old.apply(this, arguments);
                $.fn.appear.run();
                return r;
            }
        }
    });

})(jQuery);




/** WAIT FOR IMAGES [used by masonry]
	https://github.com/alexanderdickson/waitForImages
 **************************************************************** **/
	;(function ($) {
		// Namespace all events.
		var eventNamespace = 'waitForImages';

		// CSS properties which contain references to images.
		$.waitForImages = {
			hasImageProperties: ['backgroundImage', 'listStyleImage', 'borderImage', 'borderCornerImage', 'cursor']
		};

		// Custom selector to find `img` elements that have a valid `src` attribute and have not already loaded.
		$.expr[':'].uncached = function (obj) {
			// Ensure we are dealing with an `img` element with a valid `src` attribute.
			if (!$(obj).is('img[src!=""]')) {
				return false;
			}

			// Firefox's `complete` property will always be `true` even if the image has not been downloaded.
			// Doing it this way works in Firefox.
			var img = new Image();
			img.src = obj.src;
			return !img.complete;
		};

		$.fn.waitForImages = function (finishedCallback, eachCallback, waitForAll) {

			var allImgsLength = 0;
			var allImgsLoaded = 0;

			// Handle options object.
			if ($.isPlainObject(arguments[0])) {
				waitForAll = arguments[0].waitForAll;
				eachCallback = arguments[0].each;
				// This must be last as arguments[0]
				// is aliased with finishedCallback.
				finishedCallback = arguments[0].finished;
			}

			// Handle missing callbacks.
			finishedCallback = finishedCallback || $.noop;
			eachCallback = eachCallback || $.noop;

			// Convert waitForAll to Boolean
			waitForAll = !! waitForAll;

			// Ensure callbacks are functions.
			if (!$.isFunction(finishedCallback) || !$.isFunction(eachCallback)) {
				throw new TypeError('An invalid callback was supplied.');
			}

			return this.each(function () {
				// Build a list of all imgs, dependent on what images will be considered.
				var obj = $(this);
				var allImgs = [];
				// CSS properties which may contain an image.
				var hasImgProperties = $.waitForImages.hasImageProperties || [];
				// To match `url()` references.
				// Spec: http://www.w3.org/TR/CSS2/syndata.html#value-def-uri
				var matchUrl = /url\(\s*(['"]?)(.*?)\1\s*\)/g;

				if (waitForAll) {

					// Get all elements (including the original), as any one of them could have a background image.
					obj.find('*').addBack().each(function () {
						var element = $(this);

						// If an `img` element, add it. But keep iterating in case it has a background image too.
						if (element.is('img:uncached')) {
							allImgs.push({
								src: element.attr('src'),
								element: element[0]
							});
						}

						$.each(hasImgProperties, function (i, property) {
							var propertyValue = element.css(property);
							var match;

							// If it doesn't contain this property, skip.
							if (!propertyValue) {
								return true;
							}

							// Get all url() of this element.
							while (match = matchUrl.exec(propertyValue)) {
								allImgs.push({
									src: match[2],
									element: element[0]
								});
							}
						});
					});
				} else {
					// For images only, the task is simpler.
					obj.find('img:uncached')
						.each(function () {
						allImgs.push({
							src: this.src,
							element: this
						});
					});
				}

				allImgsLength = allImgs.length;
				allImgsLoaded = 0;

				// If no images found, don't bother.
				if (allImgsLength === 0) {
					finishedCallback.call(obj[0]);
				}

				$.each(allImgs, function (i, img) {

					var image = new Image();

					// Handle the image loading and error with the same callback.
					$(image).on('load.' + eventNamespace + ' error.' + eventNamespace, function (event) {
						allImgsLoaded++;

						// If an error occurred with loading the image, set the third argument accordingly.
						eachCallback.call(img.element, allImgsLoaded, allImgsLength, event.type == 'load');

						if (allImgsLoaded == allImgsLength) {
							finishedCallback.call(obj[0]);
							return false;
						}

					});

					image.src = img.src;
				});
			});
		};
	}(jQuery));