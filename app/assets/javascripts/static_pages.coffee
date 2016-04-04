# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

fit_viewport = (item) ->
#  if ( $(window).width() < 768 || $(window).height() < 700 )
#    header_height = $('header').outerHeight(true) - 1;
#    new_height = $(window).height() - header_height;
#  else
#    new_height = 600;
#  item.height( new_height );
  header_height = $('header').outerHeight(true) + $('#btn-register').outerHeight(true) - 1;
  new_height = ($(window).height() - header_height);
  if ($(document).width() >= 768)
    if new_height > 800
      new_height = (new_height / 2) + 150;
    else
      new_height = 450
  item.height( new_height );

clickHandler = () ->
  tag = $(this);
  tag.on("mouseleave", mouseLeaveHandler);
  tag.off("click", clickHandler);
  tag.find("iframe").css("pointer-events", "auto");

mouseLeaveHandler = () ->
  tag = $(this);
  tag.on("click", clickHandler);
  tag.off("mouseleave", mouseLeaveHandler);
  tag.find("iframe").css("pointer-events", "none");

alignDescRows = (objects) ->
  heights = objects.map () ->
    $(this).height()
  .get()
  maxHeight = Math.max.apply(null, heights)
  objects.height(maxHeight)

$(window).on 'resize orientationchange', ->
  fit_viewport( $('#main-slider .carousel .item') );
  flippers = $('#flippers .translite');
  flippers.css("height", "");
  alignDescRows(flippers)
  alignDescRows($('#flippers .flipper-name'));
  alignDescRows($('#description .desc-row-1'));
  alignDescRows($('#description .desc-row-2'));

$(document).on 'click','#main-navbar .navbar-collapse.in, #tournaments-navbar .navbar-collapse.in', (e) ->
  $(this).collapse('hide') if $(e.target).is('a')

$(document).on 'page:change', ->
  fit_viewport( $('#main-slider .carousel .item') );
  $('.map-frame').on("click", clickHandler);

  $('#flippers-header a').on("click", (e) ->
    e.preventDefault();
    $('#flippers-header a i').toggleClass("fa-angle-down").toggleClass("fa-angle-up");
    $('#flippers-grid').slideToggle(500, ->
      $('#flippers .translite').imagesLoaded () ->
        alignDescRows($('#flippers .translite'));
        alignDescRows($('#flippers .flipper-name'));
    );
  )
  $('#flippers-footer a').on("click", (e) ->
    e.preventDefault();
    $('#flippers-header a i').toggleClass("fa-angle-down").toggleClass("fa-angle-up");
    $('#flippers-grid').slideToggle(500, ->
      $('#flippers .translite').imagesLoaded () ->
        alignDescRows($('#flippers .translite'));
    );
    $('html, body').animate({ scrollTop: $('#flippers').offset().top - 50 }, 500);
  )
  # affixed nav
  $('#main-navbar').affix({offset: {top: $('#lang-switcher').outerHeight(true)}})
  $('#main-navbar').on 'affix.bs.affix', ->
    $(this).parent().next().css({ marginTop: $(this).outerHeight(true)})
  $('#main-navbar').on 'affix-top.bs.affix', ->
    $(this).parent().next().css({ marginTop: 0})


$(document).on 'ready', ->
  alignDescRows($('#description .desc-row-1'));
  alignDescRows($('#description .desc-row-2'));

  # affixed nav
  $('#main-navbar').affix({offset: {top: $('#lang-switcher').outerHeight(true)}})
  $('#main-navbar').on 'affix.bs.affix', ->
    $(this).parent().next().css({ marginTop: $(this).outerHeight(true)})
  $('#main-navbar').on 'affix-top.bs.affix', ->
    $(this).parent().next().css({ marginTop: 0})

  # hide flash on modal when closed
  $('#loginModal').on 'hidden.bs.modal', ->
    $(this).find('#modal-flash').hide();

  # animated scrolling on a.click
  body = $('html, body')
  $('header a, #tournaments-navbar a').click (e) ->
    href = $.attr(this, 'href')
    index = href.indexOf("#")
    if index == -1 || $(href.substr(index)).length == 0
      return
    else
      e.preventDefault()
      body.animate({ scrollTop: $( href.substr(index) ).offset().top - 50 }, 500, ->
        window.location.hash = href.substr(index+1))
