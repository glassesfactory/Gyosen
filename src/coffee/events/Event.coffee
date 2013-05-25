do(Gyosen)->
  class Event extends Gyosen.Hunanori
    @COMPLETE: "complete"

    type:null
    constructor:(@type)->
      if not type
        @error("イベントタイプを指定して下さい。")

    toString:()->
      return "Gyosen.Event:: type:" + @type

    clone:()->
      return new Gyosen.Event(@type)

  Gyosen.Event = Event
