###
  Gyosen.core.XHR
  XHR ラッパー
###
do(Gyosen)->
  class XHR extends Gyosen.EventDispatcher
    xhr: null
    #defaults
    contentType: "application/json"
    responseType: "application/json"
    isMsgPack: false
    method: "GET"
    async: true
    data: null

    constructor:(@url, options)->
      Gyosen.extender(@, {}, options)
      _createXHR =()->
        if window.ActiveXObject
          try
            return new ActiveXObject("Msxml2.XMLHTTP")
          catch e
            try
              return new ActiveXObject("Microsoft.XMLHTTP")
            catch e
              return null
        else if window.XMLHttpRequest
          return new XMLHttpRequest()
        else
          return null

      if not @xhr
        @xhr = _createXHR()
      if @isMsgPack
        @contentType = 'application/x-msgpack'
        @responseType = 'application/x-msgpack'


    ###
      Gyosen.core.XHR.send
      ------------------------
      Send Data to server side application.
      サーバーにデータを送る。

      :params url: server url
                   送りつけたいサーバーの URL
    ###
    send:(url, data, options)->
      Gyosen.extender(@, {}, options)
      @method = if "method" not in options then "POST" else options.method
      @xhr.open(@method, @url, @async)
      @xhr.onreadystatechange = @readyStateChangeHandler
      @xhr.send(data)
      return


    ###
      Gyosen.core.XHR.receive
      ------------------------
      receive the data from server side application.
      サーバーからデータを受け取る。

      :params url: server url
                   データを持ってきたいサーバーの URL
    ###
    receive:(url, options)->
      Gyosen.extender(@, {}, options)
      @xhr.open(@method, @url, @async)
      @xhr.onreadystatechange = @readyStateChangeHandler
      @xhr.send()
      return

    readyStateChangeHandler:()=>
      setting = Gyosen.setting
      if @xhr.readyState is 4
        if @xhr.status in setting.SUCCESS_STATUS_CODE
          @data = @xhr.response
          @fire(new Gyosen.Event(Gyosen.Event.COMPLETE))
        else if @xhr.status in setting.ERROR_STATUS_CODE
          #む…
          @fire(new Gyosen.IOErrorEvent(Gyosen.IOErrorEvent.IO_ERROR))
      else
        if @xhr.status in setting.ERROR_STATUS_CODE
          @fire(new Gyosen.IOErrorEvent(Gyosen.IOErrorEvent.IO_ERROR))
        # if @xhr.status not in setting.SUCCESS_STATUS_CODE



  Gyosen.XHR = XHR

