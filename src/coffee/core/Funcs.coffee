do(Gyosen)->
  _slice = Array.prototype.slice


  Gyosen.binder =(func, obj)->
    slice = _slice
    args = slice.call(arguments, 2)
    return ()->
      return func.apply(obj||{}, args.concat(slice.call(arguments)))

  Gyosen.each =(obj, iter, ctx)->
    if not obj?
      return
    each = Array.prototype.forEach
    if each && obj.forEach is each
      obj.forEach(iter, ctx)
    else if obj.length is +obj.length
      i = 0
      l = obj.length
      while i < l
        if iter.call(ctx, obj[i], i, obj ) is @breaker
          return
        i++
    else
      for k of obj
        if k in obj
          if iter.call(ctx, obj[k], k, obj) is @breaker
            return

  _each = Gyosen.each

  Gyosen.extender =(obj)->
    _each(_slice.call(arguments,1), (source)->
      if source
        for prop of source
          obj[prop] = source[prop]
      )
    return obj

  Gyosen.find=()->
    throw new Error("no implements")
    return

  Gyosen.unique=()->
    throw new Error("no implements")
    return

  Gyosen.urlFor=(base)->
    throw new Error("no implements")
    return

