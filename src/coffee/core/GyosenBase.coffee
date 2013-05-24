do(Gyosen)->
  ###
  ###
  class Hunanori
    separator: null
    prefix: null
    constructor:()->

    log:(msg, level)=>
      if not Gyosen.debug
        return
      if @.prfix
        console.log @.prefix
      Hunanori.log(msg, level)
      if @.separator
        console.log @.separator

    warn:(msg)=>
      @log(msg, Gyosen.WARINING)

    error:(msg)=>
      @log(msg, Gyosen.ERROR)

  ###
  ---------
    meta
  ---------
  ###
  Hunanori.version = 0.1
  Hunanori.name = "Hunanori"
  #for Gyosen
  # Hunanori.LOG_LEVELS = ["info", "error", "warning"]
  # Hunanori.INFO = Hunanori.LOG_LEVELS[0]
  # Hunanori.ERROR = Hunanori.LOG_LEVELS[1]
  # Hunanori.WARINING = Hunanori.LOG_LEVELS[2]
  # Hunanori.level = "info"
  Hunanori.logger = null
  Hunanori.prefix = null
  Hunanori.separator = null

  Hunanori.log =(msg, level)=>
    if not Gyosen.debug
      return
    if Hunanori.prefix
      console.log prefix
    Hunanori.doLogging(msg, level)
    if Hunanori.separator
      console.log Hunanori.separator

  Hunanori.warn =(msg)=>
    Hunanori.log(msg, Gyosen.WARINING)

  Hunanori.error =(msg)=>
    Hunanori.log(msg, Gyosen.ERROR)

  Hunanori.doLogging =(msg, level)->
    if level and Gyosen.level isnt level
      logger = _createLogger(level)
    else
      if not Hunanori.logger
        Hunanori.logger = _createLogger(Gyosen.level)
      logger = Hunanori.logger
    logger(msg)

  _createLogger:(level)->
    if level not in Gyosen.LOG_LEVELS
      throw new Error("log level is undefined.")

    if level is "info"
      return console.log
    else if level is "error"
      return console.error
    else if level is "warning"
      return console.warn

  Gyosen.Hunanori = Hunanori