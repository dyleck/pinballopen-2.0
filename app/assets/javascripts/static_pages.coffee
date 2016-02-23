# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

fit_viewport = (item) ->
  if ( $(window).width() < 768 || $(window).height() < 700 )
    header_height = $('header').outerHeight(true) - 1;
    new_height = $(window).height() - header_height;
  else
    new_height = 600;
  item.height( new_height );
#  $('body').css({"padding-top": $('header').outerHeight(true) - 1});



resize_map = () ->
  im = $("iframe#mapa");
  max_height = parseInt(im.parent().css("max-height"));
  loc_text_height = $('#location-text div').height();
  im.width(im.parent().width()).height(Math.min(max_height, loc_text_height));

$(window).on 'resize', ->
  fit_viewport( $('#main-slider .carousel .item') );
  resize_map()

$(document).on 'click','.navbar-collapse.in', (e) ->
  $(this).collapse('hide') if $(e.target).is('a')

$(document).on 'ready page:change', ->
  $('.polyglot-language-switcher').polyglotLanguageSwitcher({
    openMode: "click"
  })
  fit_viewport( $('#main-slider .carousel .item') );
  resize_map();

  # affixed nav
  $('div.navbar').affix({offset: {top: $('#lang-switcher').outerHeight(true)}})
  $('div.navbar').on 'affix.bs.affix', ->
    $(this).parent().next().css({ paddingTop: $(this).outerHeight(true) })
  $('div.navbar').on 'affix-top.bs.affix', ->
    $(this).parent().next().css({ paddingTop: 0})

  # animated scrolling on a.click
  # TODO Fix the default action when not an page with anchor
  body = $('html, body')
  $('header a').click (e) ->
    href = $.attr(this, 'href')
    index = href.indexOf("#")
    if index == -1
      return
    else
      e.preventDefault()
      body.animate({ scrollTop: $( href.substr(index) ).offset().top }, 500)
    end

