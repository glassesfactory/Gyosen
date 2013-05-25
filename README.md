Gyosen
==========

ソイヤソイヤソイヤソイヤ！

ソイヤ…
[Kazitori.js](https://github.com/glassesfactory/kazitori.js)
[Hunanori.js](https://github.com/glassesfactory/Hunanori.js)

ソイヤ！
-----------------------

###ソイヤ！

```coffee
class App extends Gyosen.Engine
  routes:
    "/": "index"
    "/foo": "foo"

  index:()->
    @.log "ソイヤ！"

  foo:()->
    @.log "ソイヤ?"

app = new App()
```

###ソイヤ!!

```coffee
class Index extends Gyosen.Engine
  routes:
    "/": "index"
    "/<int:id>": "show"

  index:()->
    @.log "ソイヤ!"

  show:(id)->
    @.log "ソイヤ!:" + id

class Foo extends Gyosen.Engine
  routes:
    "/": "index"
    "/<int:id>": "show"

  index:()->
    @.log "foo: ソイヤ!"

  show:(id)->
    @.log "foo: ソイヤ!:" + id

class App extends Gyosen.Engine
  routes:
  	"/": Index
  	"/foo": Foo
```

ソイヤソイヤ！
---------------------

###ソイヤ!

```coffee
class IyoboyaModel extends Gyosen.BaseModel
  url: '/'
  sex: false
  size: 0
  created_at: null
  updated_at: null

loaded:(event)->
  Gyosen.log "ソイヤソイヤー！"

IyoboyaModel.on(Gyosen.Event.COMPLETE, loaded).load()
```

###ソイヤソイヤ!?

```coffee
#for model in IyoboyaModel.collection
#  Gyosen.log model.size
#
#results...
#80, 93, 100, 128, 143, 112

checkSize =(model)->
  return model.size > 120

dekkaino = IyoboyaModel.filter(checkSize).fetch()
#for model in dekkaino
#  Gyosen.log model.size
#
#results...
#[128, 143]
```

ソイヤソイヤソイヤ!
---------------------

ソイヤ…
