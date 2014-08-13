###
 * jquery.adultAuth.js v0.1
 * https://github.com/kawasako/adultAuth.js
 *
 * Copyright (c) 2014 Kohei Kawasaki
 * Licensed under the MIT license: http://www.opensource.org/licenses/MIT###


class AdultAuthHandler
  cookieName: "_adultAuthSession"
  adultClass: "is_adult"
  notAdultClass: "not_adult"
  currentBtnClass: "current"

  constructor: (opt)->
    return false  unless typeof opt is "object"
    return false  unless opt.adultBtn || opt.adultContent || opt.notadultBtn || opt.notadultContent

    @SmoothScroller = new SmoothScroller
      speed: opt.scrollSpeed
      easing: opt.scrollEasing
      padding: opt.scrollPadding

    @$adultBtn = $(opt.adultBtn)
    @$adultContent = $(opt.adultContent)
    @$notAdultBtn = $(opt.notAdultBtn)
    @$notAdultContent = $(opt.notAdultContent)

    @$adultContent.hide()
    @$notAdultContent.hide()

    @isAdult = false
    if document.cookie
      cookies = document.cookie.split("; ")
      i = 0
      while i < cookies.length
        str = cookies[i].split("=")
        if str[0] is @cookieName and str[1] is @adultClass
          @isAdult = true
        i++
    @showAdultContent()  if @isAdult

    @listenEvent()

  listenEvent: ->
    _this = @
    @$adultBtn.on
      click: (event)->
        _this.showAdultContent()
        setTimeout ->
          _this.SmoothScroller.toScroll(_this.$adultContent)
        ,10
        event.preventDefault()
    @$notAdultBtn.on
      click: (event)->
        _this.showNotAdultContent()
        setTimeout ->
          _this.SmoothScroller.toScroll(_this.$notAdultContent)
        ,10
        event.preventDefault()

  showAdultContent: ->
    @isAdult = true
    document.cookie = "#{@cookieName}=#{@adultClass}";

    @$adultBtn.addClass(@currentBtnClass)
    $('body').addClass(@adultClass)
    @$adultContent.show()

    @$notAdultBtn.removeClass(@currentBtnClass)
    $('body').removeClass(@notAdultClass)
    @$notAdultContent.hide()

  showNotAdultContent: ->
    @isAdult = false
    document.cookie = "#{@cookieName}=false";

    @$adultBtn.removeClass(@currentBtnClass)
    $('body').removeClass(@adultClass)
    @$adultContent.hide()

    @$notAdultBtn.addClass(@currentBtnClass)
    $('body').addClass(@notAdultClass)
    @$notAdultContent.show()


class SmoothScroller
  constructor: (opt)->
    @speed = if opt.speed then opt.speed else 640
    @easing = if opt.easing then opt.easing else "linear"
    @padding = if opt.padding then opt.padding else 0

  toScroll: ($target)->
    return false  unless $target
    return false  unless $target[0]
    position = $target.offset().top
    ty = Math.min(position, $(document).height() - $(window).height())

    $("html,body").animate
      scrollTop: ty
    , @speed, @easing


$.extend
  adultAuth: (opt)->
    new AdultAuthHandler(opt)










