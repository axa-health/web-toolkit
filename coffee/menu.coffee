(($) ->

  # Public class definition
  class Menu
    @DEFAULTS

    constructor: (element, options) ->
      @$element = $ element
      @options = $.extend {}, Menu.DEFAULTS, options

      @init()

    init: () ->
      @$element.on 'click', '.menu__link--back', @, (event) ->
        link = $(event.target)
        currentLevel = link.closest('.menu__level')
        upperLevel = currentLevel.parent().closest('.menu__level')

        event.data.level(upperLevel)

      @$element.on 'click', '.menu__link', @, (event) ->
        link = $(event.target)
        subLevel = link.siblings('.menu__level')

        if subLevel.length > 0
          event.data.level(subLevel)

      # .menu__level
      # .menu__item

      # is-active

      # is-previous
      # is-current

    level: (toSet) ->
      if not toSet
        return @$element.find '.is-current'

      else
        @$element.find('.is-current').removeClass('is-current')
        @$element.find('.is-previous').removeClass('is-previous')

        level = @$element.find toSet

        if not level
          throw new Error 'Provided level not in menu!'

        level.addClass('is-current')

        parentLevels = level.parentsUntil @$element, ($e) ->
          return $e.hasClass('menu__level')

        parentLevels.addClass('is-previous')

        parentLinks = level.parentsUntil @$element, ($e) ->
          return $e.hasClass('menu__link')
        
        parentLinks.addClass('is_active')

    back: () ->

  # Plugin definition
  Plugin = (option) ->
    params = arguments

    return this.each () ->
      $this = $ this
      options = $.extend({}, Menu.DEFAULTS, data, typeof option == 'object' && option)
      action = option if typeof option == 'string'
      data = $this.data('axa.menu')

      if not data
        data = new Menu this, options
        $this.data 'axa.menu', data

      if action == 'level'
        data.level(params[1])

  # Plugin registration
  $.fn.menu = Plugin
  $.fn.menu.Constructor = Menu

  # DATA-API
  $(window).on 'load', () ->
    $('[data-menu="compact"]').each () ->
      $menu = $(this)
      data = $menu.data()

      Plugin.call($menu, data)

)(jQuery)
