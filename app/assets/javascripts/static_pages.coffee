# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

fit_viewport = () ->
  new_height = $(window).height() - $('header').outerHeight() - $('footer').outerHeight();

$(window).on 'resize', ->
  $('#main-slider .carousel .item').height( fit_viewport() );

$(document).on 'ready page:change', ->
  $('#main-slider .carousel .item').height( fit_viewport() );