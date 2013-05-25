do(Gyosen)->
  class EventDispatcher extends Gyosen.Hunanori
    listeners: {}

    on:(type, listener)->
      if @listeners[ type ] is undefined
        @listeners[ type ] =[]

      if @_inArray(listener, @listeners[type]) < 0
        @listeners[type].push listener
      return @

    off:(type, listener)->
      len = 0
      for prop of @listeners
        len++
      if len < 1
        return @
      arr = @listeners[type]
      if not arr
        return @
      i = 0
      len = arr.length
      while i < len
        if arr[i] is listener
          if len is 1
            delete @listeners[type]
          else arr.splice(i,1)
          break
        i++
      return @

    fire:(event)->
      if "type" not in event
        @error("event object has not event type.")
        return @
      ary = @listeners[ event.type ]
      if ary isnt undefined
        event.target = @

        for handler in ary
          handler.call(@, event)
      return @
  Gyosen.EventDispatcher = EventDispatcher
