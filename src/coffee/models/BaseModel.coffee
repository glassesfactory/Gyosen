do(Gyosen)->
  class BaseModel extends Gyosen.Hunanori
    @url: ''
    #ロードした後のコールバック
    @loadCB: null

    #コレクション
    #あまり直接操作することは非推奨だけど触れたほうがいいっちゃいいような
    @collection: []
    #格納しているモデルの数
    @length:0

    @_isLoaded: false
    @contentType: "application/json"
    @responseType: "application/json"
    @_dispatcher: new Gyosen.EventDispatcher()
    @isUnique: false
    #む…
    # @xhr: new Gyosen.XHR()

    #サーバーからデータを読み込む
    @load:(url, cb)=>
      if url and @.url is ''
        @.url = url
      if cb
        @.loadCB = cb
      #data type の判定いるかなー
      #msgpack だった時とか
      @xhr = new Gyosen.XHR()
      @xhr.on Gyosen.Event.COMPLETE, @_success
      @xhr.on Gyosen.IOErrorEvent.IO_ERROR, @_error
      @xhr.receive(@.url)
      return @
    #プライベートにしたほうがいいねぇ
    @queried: false
    @queriedCollection: []

    #モデルが読み込み済みかどうか
    @isLoaded:()=>
      return @_isLoaded

    #get entity.
    @get:(id)->
      if @.collection.length < 1
        throw new Error('has not entity.')
      #todo: _ に依存させない
      model = _.find(@.collection, (model)->
        return model.id is id
        )
      if not model
        #リトライするかどうか
        return null
      return model

    @on:(type, listener)=>
      @._dispatcher.on(type, listener)
      return @

    @off:(type, listener)=>
      @._dispatcher.on(type, listener)
      return @

    @_success:(data)=>
      @._isLoaded = true
      @_appendToCollection(data)
      @._dispatcher.fire(new Gyosen.Event(Gyosen.Event.COMPLETE))

    @_error:(error)->
      @warn(error)
      @._dispatcher.fire(new Gyosen.IOErrorEvent(Gyosen.IOErrorEvent.IO_ERROR, "load failed"))

    @_appendToCollection:(data)=>
      for x in data
        @.collection.push new @(x)
      #コレクション内のモデルをユニークにするかどうか
      # if @.isUnique
        #どこに書くかな
        #@.collection = @_unique(@.collection)
      @.length = @.collection.length
      if @.loadCB?
        @.loadCB.apply()
      return

    ###
      Gyosen.models.BaseModel.filter
      -----------------------------------
      **Static**
      フィルタリングの条件を関数として渡し、
      その結果のコレクションを生成する。
      :params checkFunc: フィルタリングの条件となる関数
    ###
    @filter:(checkFunc)->
      if not @queried
        @queriedCollection = @collection
        @queried = true
      for model in @queriedCollection
        result = checkFunc(model)
        if result
          results.push result
      @queriedCollection = results
      return @

    @order:(orderKey)->
      return @

    ###
    #todo
    # limit を fetch の引数にするか否か。
    # あと offset....
    ###
    ###
      Gyosen.models.BaseModel.fetch
      -----------------------------------
      **Static**
      クエリした結果を取得する。
    ###
    @fetch:()->
      results = []
      if @queried
        results = @queriedCollection
        @queriedCollection = []
        @queried = false
      else
        results = @collection
      return results


    ###
    ====================
      for instance
    ====================
    ###

    id: null

    propNames:[]

    #propMap:{}

    ###
      Gyosen.models.BaseModel
      -----------------------------------
      コンストラクタ
      :params properties: モデルのプロパティを設定する。
    ###
    constructor:(properties)->
      if properties?
        @bindProp(properties)
      return

    ###
      Gyosen.models.BaseModel.bindProp
      -----------------------------------
      モデルの内容をサーバーに PUT メソッドで投げ更新する。
      成功した場合は自身の値を投げた値で更新する。
    ###
    #TODO: DB 用のパラメーターとして設定しているものかどうか判断して追加する
    bindProp:(properties)=>
      for prop of properties
        @.propNames.push prop
        @[prop] = properties[prop]

    ###
      Gyosen.models.BaseModel.save
      -----------------------------------
      モデルの内容をサーバーに POST メソッドで投げ新規作成する。
    ###
    save:(data)=>
      if not data
        data = @.toFormArray()

      cls = @constructor
      #todo 脱 jQuery
      @xhr = new Gyosen.XHR()
      @xhr.on Gyosen.Event.COMPLETE, @_savedHandler
      @xhr.on Gyosen.IOErrorEvent.IO_ERROR, @_ioErrorHandler
      @xhr.send(cls.url, data, {"method":"POST"})
      return

    ###
      Gyosen.models.BaseModel.update
      -----------------------------------
      モデルの内容をサーバーに PUT メソッドで投げ更新する。
      成功した場合は自身の値を投げた値で更新する。
    ###
    update:(data)=>
      cls = @constructor
      if not data
        data = @.toFormArray()

      @xhr = new Gyosen.XHR()
      @xhr.on Gyosen.Event.COMPLETE, @_updatedHandler
      @xhr.on Gyosen.IOErrorEvent.IO_ERROR, @_ioErrorHandler
      @xhr.send(Gyosen.urlFor(cls.url, @.id), data, {"method":"PUT"})
      return

    ###
      Gyosen.models.BaseModel.destroy
      -----------------------------------
      モデルをサーバーにDELETEメソッドで投げる
      成功した場合はコレクションから削除される。
    ###
    destroy:()=>
      cls = @constructor

      @xhr = new Gyosen.XHR()
      @xhr.on Gyosen.Event.COMPLETE, @_deletedHandler
      @xhr.on Gyosen.IO_ERROR.IO_ERROR, @_ioErrorHandler
      @xhr.receive(Gyosen.urlFor(cls, url, @.id), {"method":"DELETE"})
      return @

    throwError:(err)->
      throw err

    #モデルを Dict (Objectハッシュマップ) にして返す
    toDict:()=>
      param = {}
      for name in @propNames
        param[name] = @[name]
      return param

    ###
      モデルの各プロパティを $.serializeArray と同じ
      {"name": "propName", "value": "propValue"}
      形式にし、配列に格納して返す。
    ###
    toSerializeArray:()=>
      param = []
      for name in @propNames
        obj = {}
        obj["name"] = name
        obj["value"] = @[name]
        param.push(obj)


    #モデルを JSON にして返す
    toJSON:()=>
      return JSON.stringify(@toDict())

    ###
      モデルを msgpack にして返す
      :require: [msgpack.js](https://github.com/msgpack/msgpack-javascript)
    ###
    toMsgPack:()=>
      if not msgpack and "msgpack" in Gyosen.win
        throw new Error('msgpack.js not found....')
      return msgpack.pack(@toDict())
  Gyosen.BaseModel = BaseModel