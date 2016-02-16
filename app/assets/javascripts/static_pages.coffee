# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

fit_viewport = (item) ->
  if ( $(window).width() < 768 || $(window).height() < 700 )
    header_height = $('header').outerHeight(true) - 1;
    $('body').css({"padding-top": header_height + "px"});
    new_height = $(window).height() - header_height;
  else
    new_height = 600;
  item.height( new_height );

resize_map = () ->
  im = $("iframe#mapa");
  max_height = parseInt(im.parent().css("max-height"));
  loc_text_height = $('#location-text div').height();
  im.width(im.parent().width()).height(Math.min(max_height, loc_text_height));

$(window).on 'resize', ->
  fit_viewport( $('#main-slider .carousel .item') );
  resize_map()

$(document).on 'ready page:change', ->
  fit_viewport( $('#main-slider .carousel .item') );
  resize_map();
  $('.polyglot-language-switcher').polyglotLanguageSwitcher({
    openMode: "click"
  })
