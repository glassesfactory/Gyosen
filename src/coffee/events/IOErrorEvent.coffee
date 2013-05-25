do(Gyosen)->
  class IOErrorEvent extends Gyosen.Event
    @IO_ERROR: "io_error"

    msg:""
    constructor:(@type, @msg)->
      super(type)

    toString:()->
      return "Gyosen.IOErrorEvent:: type:" + @type + ' msg:' + @msg

    clone:()->
      return new Gyosen.IoErrorEvent(@type, @msg)

  Gyosen.IOErrorEvent = IOErrorEvent
